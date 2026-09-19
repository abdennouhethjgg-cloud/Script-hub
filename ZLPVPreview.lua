-- ═══════════════════════════════════════════════════════════
--   Zlhub Pro Panel v9.0 — Fixed Loading + Fast Reload
-- ═══════════════════════════════════════════════════════════

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local Lighting         = game:GetService("Lighting")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

pcall(function()
    local old = playerGui:FindFirstChild("ZlhubProPanel")
    if old then old:Destroy() end
end)

-- ═══════════════════════════════════════════
-- [1] CONSTANTES
-- ═══════════════════════════════════════════
local C = {
    panel      = Color3.fromRGB(16, 16, 28),
    card       = Color3.fromRGB(24, 26, 44),
    cardHover  = Color3.fromRGB(32, 34, 56),
    cyan       = Color3.fromRGB(0, 220, 255),
    purple     = Color3.fromRGB(160, 80, 255),
    green      = Color3.fromRGB(0, 255, 130),
    yellow     = Color3.fromRGB(255, 210, 80),
    red        = Color3.fromRGB(255, 90, 90),
    text       = Color3.fromRGB(230, 240, 255),
    textDim    = Color3.fromRGB(140, 160, 200),
}

-- Image décorative utilisée derrière le bouton et dans le panneau.
-- Remplace uniquement cette valeur par l'ID de ton image Roblox si nécessaire.
local BACKGROUND_IMAGE = "rbxassetid://6031071053"

local FAB_SIZE        = 60
local PANEL_W         = 320
local PANEL_H         = 400
local RELOAD_COOLDOWN = 1
local RELOAD_TIMEOUT  = 8   -- ⭐ sécurité anti-blocage
local RENDER_INTERVAL = 1 / 30

-- ═══════════════════════════════════════════
-- [2] SAVE
-- ═══════════════════════════════════════════
local SAVE_FILE = "zlhub_pro_pos.json"

local function hasFS()
    return typeof(writefile) == "function"
       and typeof(readfile) == "function"
       and typeof(isfile) == "function"
end

local function loadPos()
    if not hasFS() then return UDim2.new(0, 30, 0.4, 0) end
    local ok, data = pcall(function()
        if isfile(SAVE_FILE) then return HttpService:JSONDecode(readfile(SAVE_FILE)) end
    end)
    if ok and type(data) == "table" and data.X and data.Y then
        return UDim2.new(0, data.X, 0, data.Y)
    end
    return UDim2.new(0, 30, 0.4, 0)
end

local function savePos(pos)
    if not hasFS() then return end
    pcall(function()
        writefile(SAVE_FILE, HttpService:JSONEncode({
            X = pos.X.Offset, Y = pos.Y.Offset
        }))
    end)
end

-- ═══════════════════════════════════════════
-- [3] ANTI-LAG
-- ═══════════════════════════════════════════
local AntiLag = {
    enabled = false,
    origQuality = nil,
    origEffects = {},
    scanned = false,
    particleCache = {},
}

function AntiLag:Enable()
    if self.enabled then return end
    self.enabled = true

    pcall(function()
        self.origQuality = settings().Rendering.QualityLevel
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level02
    end)

    pcall(function()
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("SunRaysEffect")
            or v:IsA("DepthOfFieldEffect") then
                self.origEffects[v] = v.Enabled
                v.Enabled = false
            end
        end
    end)

    if not self.scanned then
        self.scanned = true
        task.spawn(function()
            local ok, list = pcall(function()
                local result = {}
                local char = player.Character
                if not char then return result end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return result end
                local pos = hrp.Position

                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") and obj.Parent then
                        local part = obj.Parent
                        if part:IsA("BasePart") then
                            if (part.Position - pos).Magnitude > 200 then
                                table.insert(result, obj)
                            end
                        end
                    end
                end
                return result
            end)

            if ok and list and self.enabled then
                for _, emitter in ipairs(list) do
                    pcall(function()
                        if emitter and emitter.Parent then
                            self.particleCache[emitter] = emitter.Enabled
                            emitter.Enabled = false
                        end
                    end)
                end
            end
        end)
    end
end

function AntiLag:Disable()
    if not self.enabled then return end
    self.enabled = false
    pcall(function()
        if self.origQuality then
            settings().Rendering.QualityLevel = self.origQuality
        end
    end)
    pcall(function()
        for effect, state in pairs(self.origEffects) do
            if effect and effect.Parent then effect.Enabled = state end
        end
        self.origEffects = {}
    end)
    pcall(function()
        for emitter, state in pairs(self.particleCache) do
            if emitter and emitter.Parent then emitter.Enabled = state end
        end
        self.particleCache = {}
        self.scanned = false
    end)
end

function AntiLag:GC()
    pcall(function()
        if collectgarbage then collectgarbage("collect") end
    end)
end

-- ═══════════════════════════════════════════
-- [4] ROOT
-- ═══════════════════════════════════════════
local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "ZlhubProPanel"
screenGui.ResetOnSpawn   = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent         = playerGui

-- ═══════════════════════════════════════════
-- [5] FAB
-- ═══════════════════════════════════════════
local fabContainer = Instance.new("Frame")
fabContainer.Size = UDim2.new(0, FAB_SIZE + 20, 0, FAB_SIZE + 20)
fabContainer.Position = loadPos()
fabContainer.BackgroundTransparency = 1
fabContainer.Parent = screenGui

local glow = Instance.new("Frame")
glow.Size = UDim2.new(0, FAB_SIZE + 16, 0, FAB_SIZE + 16)
glow.Position = UDim2.new(0.5, -(FAB_SIZE + 16) / 2, 0.5, -(FAB_SIZE + 16) / 2)
glow.BackgroundColor3 = C.cyan
glow.BackgroundTransparency = 0.85
glow.BorderSizePixel = 0
glow.ZIndex = 1
glow.Parent = fabContainer

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(1, 0)
glowCorner.Parent = glow

local ringOuter = Instance.new("Frame")
ringOuter.Size = UDim2.new(0, FAB_SIZE + 6, 0, FAB_SIZE + 6)
ringOuter.Position = UDim2.new(0.5, -(FAB_SIZE + 6) / 2, 0.5, -(FAB_SIZE + 6) / 2)
ringOuter.BackgroundTransparency = 1
ringOuter.ZIndex = 2
ringOuter.Parent = fabContainer

local roCorner = Instance.new("UICorner")
roCorner.CornerRadius = UDim.new(1, 0)
roCorner.Parent = ringOuter

local roStroke = Instance.new("UIStroke")
roStroke.Thickness = 2
roStroke.Color = C.cyan
roStroke.Transparency = 0.2
roStroke.Parent = ringOuter

local roGrad = Instance.new("UIGradient")
roGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, C.cyan),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1.0, C.purple),
}
roGrad.Parent = roStroke

local fab = Instance.new("TextButton")
fab.Size = UDim2.new(0, FAB_SIZE, 0, FAB_SIZE)
fab.Position = UDim2.new(0.5, -FAB_SIZE / 2, 0.5, -FAB_SIZE / 2)
fab.BackgroundColor3 = Color3.fromRGB(16, 16, 28)
fab.BorderSizePixel = 0
fab.Text = ""
fab.AutoButtonColor = false
fab.ZIndex = 3
fab.Parent = fabContainer

local fabImage = Instance.new("ImageLabel")
fabImage.Name = "BackgroundImage"
fabImage.Size = UDim2.new(1, 0, 1, 0)
fabImage.Position = UDim2.new(0, 0, 0, 0)
fabImage.BackgroundTransparency = 1
fabImage.Image = BACKGROUND_IMAGE
fabImage.ImageColor3 = C.cyan
fabImage.ImageTransparency = 0.48
fabImage.ScaleType = Enum.ScaleType.Crop
fabImage.ZIndex = 1
fabImage.Parent = fab

local fabImageCorner = Instance.new("UICorner")
fabImageCorner.CornerRadius = UDim.new(1, 0)
fabImageCorner.Parent = fabImage

local fabCorner = Instance.new("UICorner")
fabCorner.CornerRadius = UDim.new(1, 0)
fabCorner.Parent = fab

local iconFrame = Instance.new("Frame")
iconFrame.Size = UDim2.new(0, 24, 0, 24)
iconFrame.Position = UDim2.new(0.5, -12, 0.5, -12)
iconFrame.BackgroundTransparency = 1
iconFrame.ZIndex = 4
iconFrame.Parent = fab

local barH = Instance.new("Frame")
barH.Size = UDim2.new(1, 0, 0, 3)
barH.Position = UDim2.new(0, 0, 0.5, -1.5)
barH.BackgroundColor3 = C.cyan
barH.BorderSizePixel = 0
barH.ZIndex = 4
barH.Parent = iconFrame

local bhC = Instance.new("UICorner")
bhC.CornerRadius = UDim.new(1, 0)
bhC.Parent = barH

local barV = Instance.new("Frame")
barV.Size = UDim2.new(0, 3, 1, 0)
barV.Position = UDim2.new(0.5, -1.5, 0, 0)
barV.BackgroundColor3 = C.cyan
barV.BorderSizePixel = 0
barV.ZIndex = 4
barV.Parent = iconFrame

local bvC = Instance.new("UICorner")
bvC.CornerRadius = UDim.new(1, 0)
bvC.Parent = barV

local function spawnRipple()
    local ripple = Instance.new("Frame")
    ripple.Size = UDim2.new(0, 10, 0, 10)
    ripple.Position = UDim2.new(0.5, -5, 0.5, -5)
    ripple.BackgroundColor3 = C.cyan
    ripple.BackgroundTransparency = 0.3
    ripple.BorderSizePixel = 0
    ripple.ZIndex = 2
    ripple.Parent = fabContainer

    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(1, 0)
    rc.Parent = ripple

    local tw = TweenService:Create(
        ripple,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, FAB_SIZE * 3, 0, FAB_SIZE * 3),
            Position = UDim2.new(0.5, -(FAB_SIZE * 3) / 2, 0.5, -(FAB_SIZE * 3) / 2),
            BackgroundTransparency = 1
        }
    )
    tw:Play()
    tw.Completed:Connect(function()
        pcall(function() ripple:Destroy() end)
    end)
end

-- ═══════════════════════════════════════════
-- [6] PANEL
-- ═══════════════════════════════════════════
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, PANEL_W, 0, 0)
panel.Position = UDim2.new(
    fabContainer.Position.X.Scale, fabContainer.Position.X.Offset + FAB_SIZE + 22,
    fabContainer.Position.Y.Scale, fabContainer.Position.Y.Offset
)
panel.BackgroundColor3 = C.panel
panel.BorderSizePixel = 0
panel.Visible = false
panel.ClipsDescendants = true
panel.Parent = screenGui

local panelImage = Instance.new("ImageLabel")
panelImage.Name = "BackgroundImage"
panelImage.Size = UDim2.new(1, 0, 1, 0)
panelImage.Position = UDim2.new(0, 0, 0, 0)
panelImage.BackgroundTransparency = 1
panelImage.Image = BACKGROUND_IMAGE
panelImage.ImageColor3 = C.purple
panelImage.ImageTransparency = 0.84
panelImage.ScaleType = Enum.ScaleType.Crop
panelImage.ZIndex = 0
panelImage.Parent = panel

local panelImageCorner = Instance.new("UICorner")
panelImageCorner.CornerRadius = UDim.new(0, 18)
panelImageCorner.Parent = panelImage

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 18)
panelCorner.Parent = panel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = C.cyan
panelStroke.Thickness = 1.4
panelStroke.Transparency = 0.35
panelStroke.Parent = panel

local panelGrad = Instance.new("UIGradient")
panelGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(22, 22, 42)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16, 18, 34)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(24, 18, 42)),
}
panelGrad.Rotation = 35
panelGrad.Parent = panel

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 52)
header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
header.BackgroundTransparency = 0.55
header.BorderSizePixel = 0
header.Parent = panel

local hGrad = Instance.new("UIGradient")
hGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, C.cyan),
    ColorSequenceKeypoint.new(1.0, C.purple),
}
hGrad.Rotation = 90
hGrad.Parent = header

local logo = Instance.new("Frame")
logo.Size = UDim2.new(0, 32, 0, 32)
logo.Position = UDim2.new(0, 14, 0.5, -16)
logo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
logo.BackgroundTransparency = 0.3
logo.BorderSizePixel = 0
logo.Parent = panel

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0)
logoCorner.Parent = logo

local logoIcon = Instance.new("TextLabel")
logoIcon.Size = UDim2.new(1, 0, 1, 0)
logoIcon.BackgroundTransparency = 1
logoIcon.Text = "⚡"
logoIcon.TextColor3 = C.yellow
logoIcon.TextSize = 18
logoIcon.Font = Enum.Font.GothamBold
logoIcon.Parent = logo

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 0, 22)
title.Position = UDim2.new(0, 54, 0, 8)
title.BackgroundTransparency = 1
title.Text = "ZLHUB PANEL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -100, 0, 14)
subtitle.Position = UDim2.new(0, 54, 0, 28)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Fixed Edition v9.0"
subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
subtitle.TextTransparency = 0.4
subtitle.TextSize = 10
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = panel

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -40, 0.5, -14)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundTransparency = 0.82
closeBtn.BorderSizePixel = 0
closeBtn.Text = "×"
closeBtn.TextColor3 = C.red
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.AutoButtonColor = false
closeBtn.Parent = panel

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

-- ═══════════════════════════════════════════
-- [7] RELOAD SECTION
-- ═══════════════════════════════════════════
local reloadBtn = Instance.new("TextButton")
reloadBtn.Size = UDim2.new(1, -28, 0, 52)
reloadBtn.Position = UDim2.new(0, 14, 0, 66)
reloadBtn.BackgroundColor3 = C.card
reloadBtn.BorderSizePixel = 0
reloadBtn.Text = ""
reloadBtn.AutoButtonColor = false
reloadBtn.Parent = panel

local rlCorner = Instance.new("UICorner")
rlCorner.CornerRadius = UDim.new(0, 14)
rlCorner.Parent = reloadBtn

local rlStroke = Instance.new("UIStroke")
rlStroke.Color = C.cyan
rlStroke.Thickness = 1.2
rlStroke.Transparency = 0.4
rlStroke.Parent = reloadBtn

local rlIconBg = Instance.new("Frame")
rlIconBg.Size = UDim2.new(0, 34, 0, 34)
rlIconBg.Position = UDim2.new(0, 12, 0.5, -17)
rlIconBg.BackgroundColor3 = C.cyan
rlIconBg.BackgroundTransparency = 0.85
rlIconBg.BorderSizePixel = 0
rlIconBg.Parent = reloadBtn

local rlIconCorner = Instance.new("UICorner")
rlIconCorner.CornerRadius = UDim.new(1, 0)
rlIconCorner.Parent = rlIconBg

local rlIcon = Instance.new("TextLabel")
rlIcon.Size = UDim2.new(1, 0, 1, 0)
rlIcon.BackgroundTransparency = 1
rlIcon.Text = "↻"
rlIcon.TextColor3 = C.cyan
rlIcon.TextSize = 22
rlIcon.Font = Enum.Font.GothamBold
rlIcon.Parent = rlIconBg

local rlTitle = Instance.new("TextLabel")
rlTitle.Size = UDim2.new(1, -70, 0, 18)
rlTitle.Position = UDim2.new(0, 56, 0, 10)
rlTitle.BackgroundTransparency = 1
rlTitle.Text = "RELOAD SCRIPT"
rlTitle.TextColor3 = C.text
rlTitle.TextSize = 13
rlTitle.Font = Enum.Font.GothamBold
rlTitle.TextXAlignment = Enum.TextXAlignment.Left
rlTitle.Parent = reloadBtn

local rlSub = Instance.new("TextLabel")
rlSub.Size = UDim2.new(1, -70, 0, 12)
rlSub.Position = UDim2.new(0, 56, 0, 28)
rlSub.BackgroundTransparency = 1
rlSub.Text = "Redémarrer le script"
rlSub.TextColor3 = C.textDim
rlSub.TextSize = 10
rlSub.Font = Enum.Font.Gotham
rlSub.TextXAlignment = Enum.TextXAlignment.Left
rlSub.Parent = reloadBtn

reloadBtn.MouseEnter:Connect(function()
    reloadBtn.BackgroundColor3 = C.cardHover
    rlStroke.Transparency = 0.15
end)

reloadBtn.MouseLeave:Connect(function()
    reloadBtn.BackgroundColor3 = C.card
    rlStroke.Transparency = 0.4
end)

-- ═══════════════════════════════════════════
-- [8] AUTO-RELOAD
-- ═══════════════════════════════════════════
local autoLabel = Instance.new("TextLabel")
autoLabel.Size = UDim2.new(1, -28, 0, 16)
autoLabel.Position = UDim2.new(0, 14, 0, 130)
autoLabel.BackgroundTransparency = 1
autoLabel.Text = "AUTO-RELOAD"
autoLabel.TextColor3 = C.textDim
autoLabel.TextSize = 10
autoLabel.Font = Enum.Font.GothamBold
autoLabel.TextXAlignment = Enum.TextXAlignment.Left
autoLabel.Parent = panel

local intervalRow = Instance.new("Frame")
intervalRow.Size = UDim2.new(1, -28, 0, 34)
intervalRow.Position = UDim2.new(0, 14, 0, 150)
intervalRow.BackgroundTransparency = 1
intervalRow.Parent = panel

local function makeIBtn(txt, x, w)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(w, -4, 1, 0)
    b.Position = UDim2.new(x, 0, 0, 0)
    b.BackgroundColor3 = C.card
    b.BorderSizePixel = 0
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(180, 190, 220)
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = false
    b.Parent = intervalRow

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = b

    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(80, 90, 130)
    s.Thickness = 1
    s.Transparency = 0.5
    s.Parent = b

    return b, s
end

local btn20, str20 = makeIBtn("20s", 0.00, 0.25)
local btn30, str30 = makeIBtn("30s", 0.25, 0.25)
local btn60, str60 = makeIBtn("60s", 0.50, 0.25)
local btnOff, strOff = makeIBtn("OFF", 0.75, 0.25)

local countdown = Instance.new("TextLabel")
countdown.Size = UDim2.new(1, -28, 0, 22)
countdown.Position = UDim2.new(0, 14, 0, 192)
countdown.BackgroundTransparency = 1
countdown.Text = "⏱  --"
countdown.TextColor3 = C.cyan
countdown.TextSize = 12
countdown.Font = Enum.Font.GothamBold
countdown.TextXAlignment = Enum.TextXAlignment.Center
countdown.Parent = panel

local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(1, -28, 0, 5)
progressBg.Position = UDim2.new(0, 14, 0, 216)
progressBg.BackgroundColor3 = Color3.fromRGB(40, 45, 68)
progressBg.BorderSizePixel = 0
progressBg.Parent = panel

local pbC = Instance.new("UICorner")
pbC.CornerRadius = UDim.new(1, 0)
pbC.Parent = progressBg

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = C.cyan
progressFill.BorderSizePixel = 0
progressFill.Parent = progressBg

local pfC = Instance.new("UICorner")
pfC.CornerRadius = UDim.new(1, 0)
pfC.Parent = progressFill

local pfGrad = Instance.new("UIGradient")
pfGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, C.cyan),
    ColorSequenceKeypoint.new(1, C.purple),
}
pfGrad.Parent = progressFill

-- ═══════════════════════════════════════════
-- [9] ANTI-LAG SECTION
-- ═══════════════════════════════════════════
local lagLabel = Instance.new("TextLabel")
lagLabel.Size = UDim2.new(1, -28, 0, 16)
lagLabel.Position = UDim2.new(0, 14, 0, 236)
lagLabel.BackgroundTransparency = 1
lagLabel.Text = "PERFORMANCE"
lagLabel.TextColor3 = C.textDim
lagLabel.TextSize = 10
lagLabel.Font = Enum.Font.GothamBold
lagLabel.TextXAlignment = Enum.TextXAlignment.Left
lagLabel.Parent = panel

local lagBtn = Instance.new("TextButton")
lagBtn.Size = UDim2.new(1, -28, 0, 46)
lagBtn.Position = UDim2.new(0, 14, 0, 256)
lagBtn.BackgroundColor3 = C.card
lagBtn.BorderSizePixel = 0
lagBtn.Text = ""
lagBtn.AutoButtonColor = false
lagBtn.Parent = panel

local lgC = Instance.new("UICorner")
lgC.CornerRadius = UDim.new(0, 14)
lgC.Parent = lagBtn

local lgStroke = Instance.new("UIStroke")
lgStroke.Color = Color3.fromRGB(200, 180, 60)
lgStroke.Thickness = 1.2
lgStroke.Transparency = 0.5
lgStroke.Parent = lagBtn

local lgIconBg = Instance.new("Frame")
lgIconBg.Size = UDim2.new(0, 30, 0, 30)
lgIconBg.Position = UDim2.new(0, 12, 0.5, -15)
lgIconBg.BackgroundColor3 = C.yellow
lgIconBg.BackgroundTransparency = 0.85
lgIconBg.BorderSizePixel = 0
lgIconBg.Parent = lagBtn

local lgIconCorner = Instance.new("UICorner")
lgIconCorner.CornerRadius = UDim.new(1, 0)
lgIconCorner.Parent = lgIconBg

local lgIcon = Instance.new("TextLabel")
lgIcon.Size = UDim2.new(1, 0, 1, 0)
lgIcon.BackgroundTransparency = 1
lgIcon.Text = "⚡"
lgIcon.TextColor3 = C.yellow
lgIcon.TextSize = 18
lgIcon.Font = Enum.Font.GothamBold
lgIcon.Parent = lgIconBg

local lgText = Instance.new("TextLabel")
lgText.Size = UDim2.new(1, -70, 0, 16)
lgText.Position = UDim2.new(0, 54, 0, 8)
lgText.BackgroundTransparency = 1
lgText.Text = "ANTI-LAG : OFF"
lgText.TextColor3 = C.yellow
lgText.TextSize = 12
lgText.Font = Enum.Font.GothamBold
lgText.TextXAlignment = Enum.TextXAlignment.Left
lgText.Parent = lagBtn

local lgSub = Instance.new("TextLabel")
lgSub.Size = UDim2.new(1, -70, 0, 12)
lgSub.Position = UDim2.new(0, 54, 0, 26)
lgSub.BackgroundTransparency = 1
lgSub.Text = "Réduire les effets"
lgSub.TextColor3 = C.textDim
lgSub.TextSize = 10
lgSub.Font = Enum.Font.Gotham
lgSub.TextXAlignment = Enum.TextXAlignment.Left
lgSub.Parent = lagBtn

lagBtn.MouseEnter:Connect(function()
    lagBtn.BackgroundColor3 = C.cardHover
end)

lagBtn.MouseLeave:Connect(function()
    lagBtn.BackgroundColor3 = C.card
end)

-- ═══════════════════════════════════════════
-- [10] STATUS BAR
-- ═══════════════════════════════════════════
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0, 34)
statusBar.Position = UDim2.new(0, 0, 1, -34)
statusBar.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
statusBar.BackgroundTransparency = 0.35
statusBar.BorderSizePixel = 0
statusBar.Parent = panel

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 7, 0, 7)
statusDot.Position = UDim2.new(0, 16, 0.5, -3.5)
statusDot.BackgroundColor3 = C.green
statusDot.BorderSizePixel = 0
statusDot.Parent = statusBar

local sdC = Instance.new("UICorner")
sdC.CornerRadius = UDim.new(1, 0)
sdC.Parent = statusDot

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -40, 1, 0)
statusText.Position = UDim2.new(0, 30, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "READY"
statusText.TextColor3 = C.green
statusText.TextSize = 11
statusText.Font = Enum.Font.GothamBold
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusBar

-- ═══════════════════════════════════════════
-- [11] TWEEN MANAGER
-- ═══════════════════════════════════════════
local activeTweens = {}

local function tw(obj, dur, props, style, dir)
    if not obj or not obj.Parent then return nil end
    if activeTweens[obj] then
        pcall(function() activeTweens[obj]:Cancel() end)
        activeTweens[obj] = nil
    end
    local ok, t = pcall(function()
        return TweenService:Create(
            obj,
            TweenInfo.new(dur, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
            props
        )
    end)
    if ok and t then
        activeTweens[obj] = t
        t:Play()
        t.Completed:Connect(function() activeTweens[obj] = nil end)
        return t
    end
    return nil
end

-- ═══════════════════════════════════════════
-- [12] DRAG FAB
-- ═══════════════════════════════════════════
local DRAG_THRESHOLD = 6
local dragState = { active=false, moved=false, startPos=nil, framePos=nil, inputObj=nil }

fab.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1
    and input.UserInputType ~= Enum.UserInputType.Touch then return end
    dragState.active = true
    dragState.moved = false
    dragState.startPos = input.Position
    dragState.framePos = fabContainer.Position
    dragState.inputObj = input

    local conn
    conn = input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragState.active = false
            if dragState.moved then savePos(fabContainer.Position) end
            if conn then conn:Disconnect() end
        end
    end)
end)

fab.InputChanged:Connect(function(input)
    if not dragState.active then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
    and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local d = input.Position - dragState.startPos
    if math.abs(d.X) + math.abs(d.Y) > DRAG_THRESHOLD then
        dragState.moved = true
    end
    if dragState.moved then
        fabContainer.Position = UDim2.new(
            dragState.framePos.X.Scale, dragState.framePos.X.Offset + d.X,
            dragState.framePos.Y.Scale, dragState.framePos.Y.Offset + d.Y
        )
        if panel.Visible then
            panel.Position = UDim2.new(
                fabContainer.Position.X.Scale,
                fabContainer.Position.X.Offset + FAB_SIZE + 22,
                fabContainer.Position.Y.Scale,
                fabContainer.Position.Y.Offset
            )
        end
    end
end)

local pDrag = { active=false, startPos=nil, framePos=nil, inputObj=nil }

header.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1
    and input.UserInputType ~= Enum.UserInputType.Touch then return end
    pDrag.active = true
    pDrag.startPos = input.Position
    pDrag.framePos = panel.Position
    pDrag.inputObj = input

    local conn
    conn = input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            pDrag.active = false
            if conn then conn:Disconnect() end
        end
    end)
end)

UserInputService.InputChanged:Connect(function(input)
    if not pDrag.active then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
    and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local d = input.Position - pDrag.startPos
    panel.Position = UDim2.new(
        pDrag.framePos.X.Scale, pDrag.framePos.X.Offset + d.X,
        pDrag.framePos.Y.Scale, pDrag.framePos.Y.Offset + d.Y
    )
end)

-- ═══════════════════════════════════════════
-- [13] MORPH
-- ═══════════════════════════════════════════
local isOpen = false

local function morphToClose()
    tw(barH, 0.3, { Rotation = 45 }, Enum.EasingStyle.Back)
    tw(barV, 0.3, { Rotation = 45 }, Enum.EasingStyle.Back)
    barH.BackgroundColor3 = C.purple
    barV.BackgroundColor3 = C.purple
    roStroke.Color = C.purple
    tw(ringOuter, 0.35, { Rotation = 180 })
end

local function morphToOpen()
    tw(barH, 0.3, { Rotation = 0 }, Enum.EasingStyle.Back)
    tw(barV, 0.3, { Rotation = 0 }, Enum.EasingStyle.Back)
    barH.BackgroundColor3 = C.cyan
    barV.BackgroundColor3 = C.cyan
    roStroke.Color = C.cyan
    tw(ringOuter, 0.35, { Rotation = 0 })
end

-- ═══════════════════════════════════════════
-- [14] OPEN / CLOSE
-- ═══════════════════════════════════════════
local function openPanel()
    isOpen = true
    panel.Visible = true
    panel.Size = UDim2.new(0, PANEL_W, 0, 0)
    panel.Position = UDim2.new(
        fabContainer.Position.X.Scale,
        fabContainer.Position.X.Offset + FAB_SIZE + 22,
        fabContainer.Position.Y.Scale,
        fabContainer.Position.Y.Offset
    )
    tw(panel, 0.3, { Size = UDim2.new(0, PANEL_W, 0, PANEL_H) }, Enum.EasingStyle.Back)
    morphToClose()
end

local function closePanel()
    isOpen = false
    tw(panel, 0.22, { Size = UDim2.new(0, PANEL_W, 0, 0) })
    morphToOpen()
    task.delay(0.25, function()
        if not isOpen then panel.Visible = false end
    end)
end

fab.MouseButton1Click:Connect(function()
    if dragState.moved then
        dragState.moved = false
        return
    end
    spawnRipple()
    if isOpen then closePanel() else openPanel() end
end)

closeBtn.MouseButton1Click:Connect(closePanel)

-- ═══════════════════════════════════════════
-- [15] NETTOYAGE
-- ═══════════════════════════════════════════
local function deepClean()
    local containers = { playerGui }
    pcall(function() table.insert(containers, game:GetService("CoreGui")) end)

    for _, container in ipairs(containers) do
        pcall(function()
            for _, gui in ipairs(container:GetChildren()) do
                if gui ~= screenGui then
                    local n = string.lower(gui.Name)
                    if n:find("zl") or n:find("zlpv") or n:find("xspeed") then
                        pcall(function() gui:Destroy() end)
                    end
                end
            end
        end)
    end

    pcall(function()
        if getgenv then
            for k, _ in pairs(getgenv()) do
                if type(k) == "string" then
                    local lk = string.lower(k)
                    if lk:find("zl") or lk:find("zlpv") or lk:find("xspeed") then
                        getgenv()[k] = nil
                    end
                end
            end
        end
    end)
end

-- ═══════════════════════════════════════════
-- [16] RELOAD FIXED ⭐ (state toujours reset)
-- ═══════════════════════════════════════════
local busy = false
local lastReload = 0
local spinConn = nil
local reloadToken = 0  -- ⭐ token unique par reload

local function startSpin()
    if spinConn then
        pcall(function() spinConn:Disconnect() end)
        spinConn = nil
    end
    spinConn = RunService.RenderStepped:Connect(function(dt)
        if rlIcon and rlIcon.Parent then
            rlIcon.Rotation = (rlIcon.Rotation + dt * 720) % 360
        end
    end)
end

local function stopSpin()
    if spinConn then
        pcall(function() spinConn:Disconnect() end)
        spinConn = nil
    end
    rlIcon.Rotation = 0
end

local function setStatus(text, color)
    statusText.Text = text
    statusText.TextColor3 = color
    statusDot.BackgroundColor3 = color
end

-- ⭐ FONCTION QUI FORCE LE RESET COMPLET
local function resetButtonToIdle()
    busy = false
    stopSpin()
    rlTitle.Text = "RELOAD SCRIPT"
    rlSub.Text = "Redémarrer le script"
    rlSub.TextColor3 = C.textDim
    rlStroke.Color = C.cyan
    rlStroke.Transparency = 0.4
    rlIcon.TextColor3 = C.cyan
    rlIconBg.BackgroundColor3 = C.cyan
    rlIconBg.BackgroundTransparency = 0.85
    reloadBtn.BackgroundColor3 = C.card
    setStatus("READY", C.green)
end

local function doReload()
    -- Verrou strict
    if busy then return end
    local now = tick()
    if now - lastReload < RELOAD_COOLDOWN then
        local remain = math.ceil(RELOAD_COOLDOWN - (now - lastReload))
        setStatus("WAIT " .. remain .. "s", C.yellow)
        return
    end

    lastReload = now
    busy = true
    reloadToken = reloadToken + 1
    local myToken = reloadToken

    -- Feedback visuel
    reloadBtn.BackgroundColor3 = Color3.fromRGB(40, 42, 70)
    rlStroke.Color = C.yellow
    rlStroke.Transparency = 0
    rlTitle.Text = "LOADING..."
    rlSub.Text = "Patientez..."
    rlSub.TextColor3 = C.yellow
    rlIconBg.BackgroundColor3 = C.yellow
    rlIcon.TextColor3 = C.yellow
    setStatus("LOADING...", C.yellow)
    startSpin()

    -- ⭐ Thread avec timeout de sécurité
    task.spawn(function()
        local startTime = tick()
        local loadOK, loadErr = false, nil

        -- Timeout wrapper
        local function safeRun()
            -- Nettoyage rapide
            pcall(deepClean)

            -- Vérifie que le reload est toujours valide
            if myToken ~= reloadToken then return false end

            -- Chargement
            local URL = "https://raw.githubusercontent.com/abdennouhethjgg-cloud/Script-hub/main/ZLPVPreview.lua"
            local ok, err = pcall(function()
                local src = game:HttpGet(URL)
                if not src or #src < 10 then error("Empty response") end
                local fn = loadstring(src)
                if not fn then error("loadstring failed") end
                fn()
            end)
            return ok, err
        end

        loadOK, loadErr = safeRun()

        -- ⭐ Force le reset même si le token a changé
        if myToken ~= reloadToken then return end

        -- Vérifie le timeout
        if tick() - startTime > RELOAD_TIMEOUT then
            loadOK = false
            loadErr = "Timeout dépassé"
        end

        stopSpin()

        if loadOK then
            setStatus("SUCCESS ✓", C.green)
            rlTitle.Text = "✓ SUCCESS"
            rlSub.Text = "Script rechargé"
            rlSub.TextColor3 = C.green
            rlStroke.Color = C.green
            rlIcon.TextColor3 = C.green
            rlIconBg.BackgroundColor3 = C.green
        else
            setStatus("ERROR ✗", C.red)
            rlTitle.Text = "✗ FAILED"
            rlSub.Text = "Échec du chargement"
            rlSub.TextColor3 = C.red
            rlStroke.Color = C.red
            rlIcon.TextColor3 = C.red
            rlIconBg.BackgroundColor3 = C.red
            warn("[Zlhub] " .. tostring(loadErr))
        end

        task.wait(0.8)

        -- ⭐ Reset complet garanti (même si token changé → on force reset)
        resetButtonToIdle()
    end)
end

reloadBtn.MouseButton1Click:Connect(doReload)

-- ⭐ Timeout global : si busy depuis > 10s, force reset
task.spawn(function()
    while screenGui.Parent do
        task.wait(2)
        if busy and (tick() - lastReload > RELOAD_TIMEOUT + 2) then
            warn("[Zlhub] Timeout de sécurité → reset")
            reloadToken = reloadToken + 1
            resetButtonToIdle()
        end
    end
end)

-- ═══════════════════════════════════════════
-- [17] AUTO-RELOAD
-- ═══════════════════════════════════════════
local AutoReload = { enabled=false, interval=30, elapsed=0, conn=nil }

local function setIntervalUI(seconds)
    local btns = { [20]={btn20,str20}, [30]={btn30,str30}, [60]={btn60,str60} }
    for s, pair in pairs(btns) do
        local b, st = pair[1], pair[2]
        if s == seconds then
            b.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
            st.Color = C.cyan
            st.Transparency = 0
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            b.BackgroundColor3 = C.card
            st.Color = Color3.fromRGB(80, 90, 130)
            st.Transparency = 0.5
            b.TextColor3 = Color3.fromRGB(180, 190, 220)
        end
    end
    if seconds == 0 then
        btnOff.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
        strOff.Color = C.red
        strOff.Transparency = 0
        btnOff.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        btnOff.BackgroundColor3 = C.card
        strOff.Color = Color3.fromRGB(80, 90, 130)
        strOff.Transparency = 0.5
        btnOff.TextColor3 = Color3.fromRGB(180, 190, 220)
    end
end

local function stopAuto()
    AutoReload.enabled = false
    AutoReload.elapsed = 0
    if AutoReload.conn then
        pcall(function() AutoReload.conn:Disconnect() end)
        AutoReload.conn = nil
    end
    countdown.Text = "⏱  --"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
end

local function startAuto(seconds)
    stopAuto()
    AutoReload.enabled = true
    AutoReload.interval = seconds
    AutoReload.elapsed = 0
    AutoReload.conn = RunService.Heartbeat:Connect(function(dt)
        if not AutoReload.enabled then return end
        if busy then return end

        AutoReload.elapsed = AutoReload.elapsed + dt
        local remaining = math.max(0, AutoReload.interval - AutoReload.elapsed)
        countdown.Text = string.format("⏱  %.1f s", remaining)
        local ratio = math.clamp(AutoReload.elapsed / AutoReload.interval, 0, 1)
        progressFill.Size = UDim2.new(ratio, 0, 1, 0)

        if AutoReload.elapsed >= AutoReload.interval then
            AutoReload.elapsed = 0
            doReload()
        end
    end)
end

btn20.MouseButton1Click:Connect(function() setIntervalUI(20); startAuto(20) end)
btn30.MouseButton1Click:Connect(function() setIntervalUI(30); startAuto(30) end)
btn60.MouseButton1Click:Connect(function() setIntervalUI(60); startAuto(60) end)
btnOff.MouseButton1Click:Connect(function() stopAuto(); setIntervalUI(0) end)

setIntervalUI(0)

-- ═══════════════════════════════════════════
-- [18] ANTI-LAG BTN
-- ═══════════════════════════════════════════
lagBtn.MouseButton1Click:Connect(function()
    AntiLag.enabled = not AntiLag.enabled
    if AntiLag.enabled then
        AntiLag:Enable()
        lgText.Text = "ANTI-LAG : ON"
        lgText.TextColor3 = C.green
        lgIconBg.BackgroundColor3 = C.green
        lgIcon.TextColor3 = C.green
        lgStroke.Color = C.green
        lgStroke.Transparency = 0.2
    else
        AntiLag:Disable()
        lgText.Text = "ANTI-LAG : OFF"
        lgText.TextColor3 = C.yellow
        lgIconBg.BackgroundColor3 = C.yellow
        lgIcon.TextColor3 = C.yellow
        lgStroke.Color = Color3.fromRGB(200, 180, 60)
        lgStroke.Transparency = 0.5
    end
end)

-- ═══════════════════════════════════════════
-- [19] RENDER LOOP
-- ═══════════════════════════════════════════
local accum = 0
local t = 0
RunService.RenderStepped:Connect(function(dt)
    accum = accum + dt
    if accum < RENDER_INTERVAL then return end
    accum = 0
    t = t + RENDER_INTERVAL

    pcall(function()
        if isOpen and roGrad.Parent then
            roGrad.Rotation = (roGrad.Rotation + RENDER_INTERVAL * 80) % 360
        end
        if not isOpen and glow.Parent then
            local pulse = (math.sin(t * 2) + 1) * 0.5
            glow.BackgroundTransparency = 0.85 + pulse * 0.1
        end
    end)
end)

-- ═══════════════════════════════════════════
-- [20] FAB HOVER
-- ═══════════════════════════════════════════
fab.MouseEnter:Connect(function()
    if not isOpen then glow.BackgroundTransparency = 0.7 end
end)

fab.MouseLeave:Connect(function()
    if not isOpen then glow.BackgroundTransparency = 0.85 end
end)

-- ═══════════════════════════════════════════
-- [21] RACCOURCIS
-- ═══════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.R
    and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        doReload()
    end
    if input.KeyCode == Enum.KeyCode.H
    and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        if isOpen then closePanel() else openPanel() end
    end
end)

-- ═══════════════════════════════════════════
-- [22] CLEANUP
-- ═══════════════════════════════════════════
screenGui.AncestryChanged:Connect(function()
    if not screenGui.Parent then
        pcall(function() stopAuto() end)
        pcall(function() AntiLag:Disable() end)
        pcall(function()
            if spinConn then spinConn:Disconnect() end
        end)
        for obj, tw in pairs(activeTweens) do
            pcall(function() tw:Cancel() end)
        end
        activeTweens = {}
    end
end)

resetButtonToIdle()

print("╔═══════════════════════════════════════════╗")
print("║  ✅ Zlhub Pro Panel v9.0 — Fixed Loading  ║")
print("║  🔒 État toujours reset après reload      ║")
print("║  ⏱  Timeout 8s anti-blocage               ║")
print("║  🛡️  Timeout global 10s de secours         ║")
print("╚═══════════════════════════════════════════╝")

