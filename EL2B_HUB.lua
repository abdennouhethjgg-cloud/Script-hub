-- ============================================================
-- SERVICES
-- ============================================================
local cloneref = cloneref or function(o) return o end
local Players = cloneref(game:GetService("Players"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local TweenService = cloneref(game:GetService("TweenService"))
local Lighting = cloneref(game:GetService("Lighting"))
local HttpService = cloneref(game:GetService("HttpService"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService = cloneref(game:GetService("RunService"))
local StarterGui = cloneref(game:GetService("StarterGui"))

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- HTTP request wrapper (exploit-dependent)
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request

-- ============================================================
-- API KEY OBFUSCATION (decode only, no security)
-- ============================================================
local _XOR_PASS = "SniperSecretXOR2024"
local _B64_KEY = "Bgc3V5Y2l0ZXIwMjQ="

-- Base64 decoder
local function _b64decode(s)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    s = string.gsub(s, '[^'..b..'=]', '')
    return (s:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

-- XOR string with key
local function _xor(str, key)
    local result = {}
    for i = 1, #str do
        local s = str:byte(i)
        local k = key:byte((i - 1) % #key + 1)
        result[i] = string.char(bit32.bxor(s, k))
    end
    return table.concat(result)
end

local _REAL_KEY = _xor(_b64decode(_B64_KEY), _XOR_PASS)

-- ============================================================
-- CONFIG
-- ============================================================
local CFG_PATH = "weekly_code_sniper.json"
local cfg = {
    startScan = true,
    autoSubmit = true,
    autoRiddle = true,
    spamRedeem = true,
    spamCount = 20,
    submitAfter = 3,
    redeemDelay = 0,
    safeMode = false,
    optimizePing = false,
    sendWebhook = true,
    waitInvalid = false,
    twoWordCheck = false,
    autoStartOnCode = false,
    typeInsteadOfAdd = false,
    typingSpeed = 0.04,
    testDelay = 1,
    aiApiKey = _REAL_KEY,
    theme = "VIPRIN",
    minimized = false,
}

-- Save cfg table to JSON file
local function saveConfig()
    if not writefile then return end
    pcall(writefile, CFG_PATH, HttpService:JSONEncode(cfg))
end

-- Load cfg table from JSON file
local function loadConfig()
    if not (readfile and isfile and isfile(CFG_PATH)) then return end
    local ok, dec = pcall(function() return HttpService:JSONDecode(readfile(CFG_PATH)) end)
    if ok and type(dec) == "table" then
        for k, v in pairs(dec) do cfg[k] = v end
    end
end
loadConfig()

local WEBHOOK_URL = "https://discord.com/api/webhooks/1558544835751841913/jQq_GTJpmmXMtmPo1cXJGxmyzxNDQoZ_X4Tsb_vD8TfaP1VIYOeqwCmh_f705Lzv33Pk"
local AI_API_URL = "https://brainrot-bot-api.lovable.app/api/public/riddle"
local API_KEY = cfg.aiApiKey
local AI_MODEL = "google/gemini-3.6-flash"
local MASKED_API_KEY = "XXX-XXX-XXX"

-- ============================================================
-- THEMES
-- ============================================================
local THEMES = {
    VIPRIN = { Name = "VIPRIN", Bg = Color3.fromRGB(24, 4, 38), SidebarBg = Color3.fromRGB(14, 2, 24), CardBg = Color3.fromRGB(80, 30, 130), Accent = Color3.fromRGB(200, 100, 255), Accent2 = Color3.fromRGB(240, 130, 255), Success = Color3.fromRGB(160, 240, 180), Danger = Color3.fromRGB(255, 90, 160), Info = Color3.fromRGB(210, 150, 255), TextMain = Color3.fromRGB(255, 235, 255), TextSub = Color3.fromRGB(220, 180, 245), TextMuted = Color3.fromRGB(170, 130, 210), StrokeColor = Color3.fromRGB(220, 130, 255) },
    Default = { Name = "Default", Bg = Color3.fromRGB(20, 22, 32), SidebarBg = Color3.fromRGB(14, 16, 26), CardBg = Color3.fromRGB(50, 65, 110), Accent = Color3.fromRGB(130, 160, 255), Accent2 = Color3.fromRGB(180, 140, 255), Success = Color3.fromRGB(100, 220, 160), Danger = Color3.fromRGB(255, 100, 120), Info = Color3.fromRGB(120, 200, 255), TextMain = Color3.fromRGB(240, 245, 255), TextSub = Color3.fromRGB(170, 180, 210), TextMuted = Color3.fromRGB(120, 130, 160), StrokeColor = Color3.fromRGB(180, 200, 255) },
    Sakura = { Name = "Sakura", Bg = Color3.fromRGB(42, 22, 32), SidebarBg = Color3.fromRGB(30, 14, 24), CardBg = Color3.fromRGB(120, 60, 80), Accent = Color3.fromRGB(255, 180, 210), Accent2 = Color3.fromRGB(255, 130, 180), Success = Color3.fromRGB(180, 230, 190), Danger = Color3.fromRGB(255, 100, 150), Info = Color3.fromRGB(255, 200, 230), TextMain = Color3.fromRGB(255, 240, 245), TextSub = Color3.fromRGB(240, 190, 215), TextMuted = Color3.fromRGB(200, 150, 180), StrokeColor = Color3.fromRGB(255, 180, 210) },
    Orage = { Name = "Orage", Bg = Color3.fromRGB(8, 10, 18), SidebarBg = Color3.fromRGB(4, 6, 12), CardBg = Color3.fromRGB(30, 45, 80), Accent = Color3.fromRGB(140, 180, 255), Accent2 = Color3.fromRGB(240, 240, 255), Success = Color3.fromRGB(120, 200, 180), Danger = Color3.fromRGB(255, 120, 120), Info = Color3.fromRGB(160, 200, 255), TextMain = Color3.fromRGB(230, 240, 255), TextSub = Color3.fromRGB(150, 170, 200), TextMuted = Color3.fromRGB(100, 120, 150), StrokeColor = Color3.fromRGB(150, 180, 255) },
    Feu = { Name = "Feu", Bg = Color3.fromRGB(32, 8, 4), SidebarBg = Color3.fromRGB(20, 4, 2), CardBg = Color3.fromRGB(120, 40, 15), Accent = Color3.fromRGB(255, 140, 60), Accent2 = Color3.fromRGB(255, 90, 30), Success = Color3.fromRGB(255, 200, 100), Danger = Color3.fromRGB(255, 60, 40), Info = Color3.fromRGB(255, 170, 90), TextMain = Color3.fromRGB(255, 240, 210), TextSub = Color3.fromRGB(240, 180, 130), TextMuted = Color3.fromRGB(190, 130, 90), StrokeColor = Color3.fromRGB(255, 140, 60) },
    Ocean = { Name = "Ocean", Bg = Color3.fromRGB(6, 22, 40), SidebarBg = Color3.fromRGB(3, 14, 28), CardBg = Color3.fromRGB(15, 60, 100), Accent = Color3.fromRGB(80, 200, 255), Accent2 = Color3.fromRGB(100, 240, 230), Success = Color3.fromRGB(100, 230, 180), Danger = Color3.fromRGB(255, 120, 150), Info = Color3.fromRGB(120, 220, 255), TextMain = Color3.fromRGB(220, 245, 255), TextSub = Color3.fromRGB(150, 200, 225), TextMuted = Color3.fromRGB(100, 150, 180), StrokeColor = Color3.fromRGB(80, 200, 255) },
    Automne = { Name = "Automne", Bg = Color3.fromRGB(38, 18, 8), SidebarBg = Color3.fromRGB(26, 12, 4), CardBg = Color3.fromRGB(110, 55, 20), Accent = Color3.fromRGB(230, 140, 60), Accent2 = Color3.fromRGB(220, 90, 40), Success = Color3.fromRGB(200, 220, 120), Danger = Color3.fromRGB(240, 80, 50), Info = Color3.fromRGB(255, 180, 100), TextMain = Color3.fromRGB(255, 235, 215), TextSub = Color3.fromRGB(235, 180, 140), TextMuted = Color3.fromRGB(180, 130, 90), StrokeColor = Color3.fromRGB(230, 140, 60) },
    Space = { Name = "Espace", Bg = Color3.fromRGB(4, 2, 14), SidebarBg = Color3.fromRGB(2, 1, 8), CardBg = Color3.fromRGB(45, 25, 80), Accent = Color3.fromRGB(180, 140, 255), Accent2 = Color3.fromRGB(120, 180, 255), Success = Color3.fromRGB(120, 220, 200), Danger = Color3.fromRGB(255, 120, 200), Info = Color3.fromRGB(180, 200, 255), TextMain = Color3.fromRGB(240, 235, 255), TextSub = Color3.fromRGB(180, 170, 220), TextMuted = Color3.fromRGB(120, 110, 160), StrokeColor = Color3.fromRGB(180, 140, 255) },
    Crystal = { Name = "Crystal", Bg = Color3.fromRGB(30, 34, 46), SidebarBg = Color3.fromRGB(20, 24, 36), CardBg = Color3.fromRGB(60, 80, 110), Accent = Color3.fromRGB(180, 220, 255), Accent2 = Color3.fromRGB(240, 250, 255), Success = Color3.fromRGB(150, 230, 200), Danger = Color3.fromRGB(255, 140, 160), Info = Color3.fromRGB(200, 230, 255), TextMain = Color3.fromRGB(250, 252, 255), TextSub = Color3.fromRGB(200, 220, 240), TextMuted = Color3.fromRGB(150, 170, 190), StrokeColor = Color3.fromRGB(220, 240, 255) },
    RGB = { Name = "Gaming RGB", Bg = Color3.fromRGB(8, 8, 14), SidebarBg = Color3.fromRGB(4, 4, 10), CardBg = Color3.fromRGB(100, 20, 70), Accent = Color3.fromRGB(255, 60, 180), Accent2 = Color3.fromRGB(60, 240, 255), Success = Color3.fromRGB(80, 255, 140), Danger = Color3.fromRGB(255, 60, 60), Info = Color3.fromRGB(60, 240, 255), TextMain = Color3.fromRGB(255, 255, 255), TextSub = Color3.fromRGB(200, 200, 220), TextMuted = Color3.fromRGB(140, 140, 160), StrokeColor = Color3.fromRGB(60, 240, 255) },
    DarkLuxe = { Name = "Dark Luxe", Bg = Color3.fromRGB(8, 8, 10), SidebarBg = Color3.fromRGB(4, 4, 6), CardBg = Color3.fromRGB(60, 45, 20), Accent = Color3.fromRGB(220, 180, 100), Accent2 = Color3.fromRGB(255, 220, 140), Success = Color3.fromRGB(150, 200, 130), Danger = Color3.fromRGB(220, 80, 80), Info = Color3.fromRGB(230, 190, 110), TextMain = Color3.fromRGB(245, 235, 210), TextSub = Color3.fromRGB(200, 180, 140), TextMuted = Color3.fromRGB(150, 130, 100), StrokeColor = Color3.fromRGB(220, 180, 100) },
    Holographic = { Name = "Holographique", Bg = Color3.fromRGB(24, 22, 38), SidebarBg = Color3.fromRGB(16, 14, 28), CardBg = Color3.fromRGB(60, 60, 100), Accent = Color3.fromRGB(180, 200, 255), Accent2 = Color3.fromRGB(255, 180, 255), Success = Color3.fromRGB(180, 255, 220), Danger = Color3.fromRGB(255, 160, 200), Info = Color3.fromRGB(160, 230, 255), TextMain = Color3.fromRGB(250, 245, 255), TextSub = Color3.fromRGB(210, 200, 240), TextMuted = Color3.fromRGB(160, 150, 190), StrokeColor = Color3.fromRGB(255, 200, 255) },
    Fun = { Name = "Fun", Bg = Color3.fromRGB(30, 20, 50), SidebarBg = Color3.fromRGB(20, 12, 38), CardBg = Color3.fromRGB(110, 80, 20), Accent = Color3.fromRGB(255, 200, 60), Accent2 = Color3.fromRGB(255, 120, 180), Success = Color3.fromRGB(120, 240, 140), Danger = Color3.fromRGB(255, 100, 100), Info = Color3.fromRGB(120, 220, 255), TextMain = Color3.fromRGB(255, 250, 240), TextSub = Color3.fromRGB(240, 220, 245), TextMuted = Color3.fromRGB(190, 170, 210), StrokeColor = Color3.fromRGB(255, 220, 120) },
    Retro = { Name = "Retro", Bg = Color3.fromRGB(6, 6, 12), SidebarBg = Color3.fromRGB(3, 3, 8), CardBg = Color3.fromRGB(15, 60, 30), Accent = Color3.fromRGB(80, 255, 140), Accent2 = Color3.fromRGB(255, 220, 60), Success = Color3.fromRGB(80, 255, 140), Danger = Color3.fromRGB(255, 80, 80), Info = Color3.fromRGB(60, 180, 255), TextMain = Color3.fromRGB(120, 255, 160), TextSub = Color3.fromRGB(80, 200, 120), TextMuted = Color3.fromRGB(60, 160, 100), StrokeColor = Color3.fromRGB(80, 255, 140) },
}

-- ============================================================
-- UI STATE
-- ============================================================
local UI = {
    Size = UDim2.new(0, 360, 0, 330),
    Position = UDim2.new(0.5, -180, 0.5, -165),
    SidebarWidth = 100,
    CurrentTheme = cfg.theme or "VIPRIN",
    Minimized = cfg.minimized or false,
}
local Theme = THEMES[UI.CurrentTheme] or THEMES.VIPRIN

-- ============================================================
-- RUNTIME STATE (moved up — fixes toggles referencing runtime)
-- ============================================================
local runtime = {
    alive = true, lastCode = nil, capturedParts = {}, seen = {},
    notifConn = nil, notifyRemote = nil, spamLoopActive = false,
    waitInvalidMode = false,
    pendingCode = "",
    retryCount = 0,
    maxRetries = 10,
    autoStartArmed = cfg.autoStartOnCode,
    typingQueue = {},
    typingBusy = false,
    typingCancel = false,
    boxCleared = false,
    typingDone = false,
    lastBrainrotName = "Unknown",
}

local getupvalues = (debug and debug.getupvalues) or getupvalues
local getconns = getconnections or (debug and debug.getconnections)
local setupv = (debug and debug.setupvalue) or setupvalue

-- Forward declaration (startNotifListener defined later)
local startNotifListener

-- Remove old UI if exists
for _, name in ipairs({ "ViprinRound8UI", "WeeklyCodeSniperUI", "WeeklySettingsUI" }) do
    pcall(function() local g = CoreGui:FindFirstChild(name); if g then g:Destroy() end end)
    pcall(function() local g = PlayerGui:FindFirstChild(name); if g then g:Destroy() end end)
end

-- ============================================================
-- UI HELPERS
-- ============================================================
-- Apply rounded corners
local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or UDim.new(0, 10)
    c.Parent = parent
    return c
end

-- Apply UIStroke with theme tag
local function stroke(parent, color, thickness, transparency, tagName)
    local s = Instance.new("UIStroke")
    s.Color = color; s.Thickness = thickness or 1; s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s:SetAttribute("ThemeTag", tagName or "stroke")
    s.Parent = parent
    return s
end

-- Apply UIGradient with theme tag
local function gradient(parent, c1, c2, rotation, tagName)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c1, c2); g.Rotation = rotation or 0
    g:SetAttribute("ThemeTag", tagName or "custom")
    g.Parent = parent
    return g
end

-- Tag object for theme updates
local function tag(obj, t) obj:SetAttribute("ThemeTag", t) return obj end

-- Create instance with props in one call
local function new(className, props, parent)
    local o = Instance.new(className)
    for k, v in pairs(props or {}) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end

-- ============================================================
-- MAIN WINDOW
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ViprinRound8UI"
ScreenGui.DisplayOrder = 999
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if not pcall(function() ScreenGui.Parent = CoreGui end) then ScreenGui.Parent = PlayerGui end

local Main = new("Frame", {
    Name = "Main", Size = UI.Size, Position = UI.Position,
    BackgroundColor3 = Theme.Bg, BackgroundTransparency = 0.2,
    BorderSizePixel = 0, Active = true, ClipsDescendants = true,
}, ScreenGui)
corner(Main, UDim.new(0, 14))
stroke(Main, Theme.StrokeColor, 1.5, 0.4, "strokeAccent")
gradient(Main, Theme.Bg, Theme.SidebarBg, 135, "main")

-- Pulsing glow loop
local GlowStroke = stroke(Main, Theme.Accent, 2, 0.3, "glowStroke")
task.spawn(function()
    while Main.Parent do
        TweenService:Create(GlowStroke, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.75, Thickness = 1.5
        }):Play()
        task.wait(1.6)
        if not Main.Parent then break end
        TweenService:Create(GlowStroke, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.2, Thickness = 2.5
        }):Play()
        task.wait(1.6)
    end
end)

-- Sidebar
local Sidebar = new("Frame", {
    Size = UDim2.new(0, UI.SidebarWidth, 1, 0),
    BackgroundColor3 = Theme.SidebarBg, BackgroundTransparency = 0.4,
    BorderSizePixel = 0, ZIndex = 3,
}, Main)
corner(Sidebar, UDim.new(0, 14))
tag(Sidebar, "sidebar")

-- Separator line
local SepLine = new("Frame", {
    Size = UDim2.new(0, 1, 1, -24), Position = UDim2.new(0, UI.SidebarWidth, 0, 12),
    BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.5, BorderSizePixel = 0, ZIndex = 4,
}, Main)
tag(SepLine, "accent")

-- Logo
local LogoFrame = new("Frame", {
    Size = UDim2.new(1, -16, 0, 38), Position = UDim2.new(0, 8, 0, 10),
    BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, ZIndex = 4,
}, Sidebar)
corner(LogoFrame, UDim.new(0, 10))
gradient(LogoFrame, Theme.Accent, Theme.Accent2, 45, "logo")
tag(LogoFrame, "accent")

new("TextLabel", {
    BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0.6, 0),
    Font = Enum.Font.GothamBold, Text = "W",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 18, ZIndex = 5,
}, LogoFrame)
new("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0.55, 0),
    Size = UDim2.new(1, 0, 0.4, 0), Font = Enum.Font.GothamBold,
    Text = "SNIPER", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 8, ZIndex = 5,
}, LogoFrame)

-- Tab list container
local TabList = new("Frame", {
    Position = UDim2.new(0, 8, 0, 58), Size = UDim2.new(1, -16, 1, -68),
    BackgroundTransparency = 1, ZIndex = 4,
}, Sidebar)

local tabRefs = {}

-- Create sidebar tab button
local function makeTab(label, yOrder)
    local btn = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 26),
        Position = UDim2.new(0, 0, 0, yOrder * 30),
        BackgroundColor3 = Theme.Accent, BackgroundTransparency = 1,
        BorderSizePixel = 0, AutoButtonColor = false, Text = "", ZIndex = 5,
    }, TabList)
    corner(btn, UDim.new(0, 8))

    local indicator = new("Frame", {
        Size = UDim2.new(0, 3, 0, 14), Position = UDim2.new(0, -2, 0.5, -7),
        BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, Visible = false, ZIndex = 6,
    }, btn)
    corner(indicator, UDim.new(1, 0))
    tag(indicator, "accent")

    local lbl = new("TextLabel", {
        BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -10, 1, 0), Font = Enum.Font.GothamBold,
        Text = label, TextColor3 = Theme.TextSub, TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6,
    }, btn)
    tag(lbl, "tabLabel")

    btn.MouseEnter:Connect(function()
        if not btn:GetAttribute("active") then
            TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundTransparency = 0.85 }):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if not btn:GetAttribute("active") then
            TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
        end
    end)
    table.insert(tabRefs, { btn = btn, lbl = lbl, indicator = indicator })
    return btn
end

-- Content area
local Content = new("Frame", {
    Position = UDim2.new(0, UI.SidebarWidth, 0, 0),
    Size = UDim2.new(1, -UI.SidebarWidth, 1, 0),
    BackgroundTransparency = 1, ZIndex = 3,
}, Main)

-- Topbar
local Topbar = new("Frame", {
    Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, ZIndex = 3,
}, Content)

local PageTitle = new("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 18, 0, 0),
    Size = UDim2.new(1, -180, 1, 0), Font = Enum.Font.GothamBold,
    Text = "Main", TextColor3 = Theme.TextMain, TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4,
}, Topbar)
tag(PageTitle, "textMain")

-- Status pill
local StatusPill = new("Frame", {
    Size = UDim2.new(0, 62, 0, 20), Position = UDim2.new(1, -128, 0.5, -10),
    BackgroundColor3 = Theme.Danger, BackgroundTransparency = 0.75,
    BorderSizePixel = 0, ZIndex = 4,
}, Topbar)
corner(StatusPill, UDim.new(1, 0))
stroke(StatusPill, Theme.Danger, 1, 0.4, "danger")
tag(StatusPill, "danger")

local StatusDot = new("Frame", {
    Size = UDim2.new(0, 6, 0, 6), Position = UDim2.new(0, 8, 0.5, -3),
    BackgroundColor3 = Theme.Danger, BorderSizePixel = 0, ZIndex = 5,
}, StatusPill)
corner(StatusDot, UDim.new(1, 0))

local StatusText = new("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 18, 0, 0),
    Size = UDim2.new(1, -22, 1, 0), Font = Enum.Font.GothamBold,
    Text = "OFF", TextColor3 = Theme.Danger, TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
}, StatusPill)
tag(StatusText, "danger")

-- Minimize button
local MinimizeBtn = new("TextButton", {
    Size = UDim2.new(0, 22, 0, 20), Position = UDim2.new(1, -58, 0.5, -10),
    BackgroundColor3 = Color3.fromRGB(255, 200, 60), BorderSizePixel = 0,
    AutoButtonColor = false, Font = Enum.Font.GothamBold,
    Text = "-", TextColor3 = Color3.fromRGB(20, 20, 20),
    TextSize = 16, ZIndex = 6,
}, Topbar)
corner(MinimizeBtn, UDim.new(0, 5))
stroke(MinimizeBtn, Color3.fromRGB(200, 150, 30), 1, 0.2, "stroke")

-- Close button
local CloseBtn = new("TextButton", {
    Size = UDim2.new(0, 22, 0, 20), Position = UDim2.new(1, -32, 0.5, -10),
    BackgroundColor3 = Color3.fromRGB(230, 60, 60), BorderSizePixel = 0,
    AutoButtonColor = false, Font = Enum.Font.GothamBold,
    Text = "X", TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 13, ZIndex = 6,
}, Topbar)
corner(CloseBtn, UDim.new(0, 5))
stroke(CloseBtn, Color3.fromRGB(180, 30, 30), 1, 0.2, "stroke")

-- Hover effects for buttons
MinimizeBtn.MouseEnter:Connect(function()
    TweenService:Create(MinimizeBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(255, 220, 100) }):Play()
end)
MinimizeBtn.MouseLeave:Connect(function()
    TweenService:Create(MinimizeBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(255, 200, 60) }):Play()
end)
CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(255, 90, 90) }):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(230, 60, 60) }):Play()
end)

-- Divider under topbar
local Div = new("Frame", {
    Size = UDim2.new(1, -20, 0, 1), Position = UDim2.new(0, 10, 0, 40),
    BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.7,
    BorderSizePixel = 0, ZIndex = 3,
}, Content)
tag(Div, "accent")

-- Page container
local PageContainer = new("Frame", {
    Position = UDim2.new(0, 0, 0, 40),
    Size = UDim2.new(1, 0, 1, -40),
    BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 3,
}, Content)

-- ============================================================
-- PAGE / SECTION / WIDGET BUILDERS
-- ============================================================
-- Create a scrollable page
local function makePage(name)
    local page = new("Frame", {
        Name = name, Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, Visible = false, ZIndex = 3,
    }, PageContainer)

    local scroll = new("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        ScrollBarImageTransparency = 0.3,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ClipsDescendants = true,
        ZIndex = 3,
    }, page)
    tag(scroll, "scrollFrame")

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.Parent = scroll

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.Parent = scroll

    return page, scroll
end

-- Create a titled section card
local function makeSection(parent, title, height)
    local sec = new("Frame", {
        Size = UDim2.new(1, 0, 0, height or 60),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.94, BorderSizePixel = 0, ZIndex = 4,
    }, parent)
    corner(sec, UDim.new(0, 10))
    stroke(sec, Theme.StrokeColor, 1, 0.75, "strokeAccent")
    local lbl = new("TextLabel", {
        BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 8),
        Size = UDim2.new(1, -24, 0, 10), Font = Enum.Font.GothamBold,
        Text = string.upper(title), TextColor3 = Theme.TextMuted,
        TextSize = 8, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
    }, sec)
    tag(lbl, "sectionLabel")
    return sec
end

-- Create a themed button
local function makeButton(parent, text, pos, size, tagBtn)
    local col
    if tagBtn == "accent" then col = Theme.Accent
    elseif tagBtn == "accent2" then col = Theme.Accent2
    elseif tagBtn == "success" then col = Theme.Success
    elseif tagBtn == "danger" then col = Theme.Danger
    elseif tagBtn == "info" then col = Theme.Info
    else col = Theme.Accent end
    local btn = new("TextButton", {
        Position = pos, Size = size, BackgroundColor3 = col,
        BackgroundTransparency = 0.75, BorderSizePixel = 0,
        AutoButtonColor = false, Font = Enum.Font.GothamBold,
        Text = text, TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 10, ZIndex = 5,
    }, parent)
    corner(btn, UDim.new(0, 8))
    stroke(btn, Theme.StrokeColor, 1, 0.6, "strokeAccent")
    tag(btn, "btn_" .. tagBtn)
    return btn
end

-- Create a text input box
local function makeTextInput(parent, placeholder, text, pos, size)
    local box = new("TextBox", {
        Position = pos, Size = size,
        BackgroundColor3 = Theme.CardBg, BackgroundTransparency = 0.7,
        BorderSizePixel = 0, ClearTextOnFocus = false,
        Font = Enum.Font.Gotham, PlaceholderText = placeholder or "",
        PlaceholderColor3 = Theme.TextMuted, Text = text or "",
        TextColor3 = Theme.TextMain, TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
    }, parent)
    corner(box, UDim.new(0, 8))
    stroke(box, Theme.StrokeColor, 1, 0.6, "strokeAccent")
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    pad.Parent = box
    tag(box, "input")
    return box
end

-- Create a toggle switch
local function makeToggle(parent, pos, default, onChanged)
    local row = new("Frame", {
        Size = UDim2.new(1, -24, 0, 26), Position = pos,
        BackgroundColor3 = Theme.CardBg, BackgroundTransparency = 0.7,
        BorderSizePixel = 0, ZIndex = 4,
    }, parent)
    corner(row, UDim.new(0, 7))
    stroke(row, Theme.StrokeColor, 1, 0.7, "strokeAccent")

    local label = new("TextLabel", {
        BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -80, 1, 0), Font = Enum.Font.Gotham,
        Text = "", TextColor3 = Theme.TextSub, TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
    }, row)
    tag(label, "textSub")

    local track = new("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.new(0, 34, 0, 18),
        BackgroundColor3 = default and Theme.Success or Theme.Danger,
        BorderSizePixel = 0, ZIndex = 5,
    }, row)
    corner(track, UDim.new(1, 0))

    local knob = new("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = default and UDim2.new(0, 18, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0, ZIndex = 6,
    }, track)
    corner(knob, UDim.new(1, 0))

    local state = default
    local hit = new("TextButton", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 7,
    }, row)

    -- Set toggle state and fire callback
    local function setOn(on)
        state = on
        TweenService:Create(track, TweenInfo.new(0.18), { BackgroundColor3 = on and Theme.Success or Theme.Danger }):Play()
        TweenService:Create(knob, TweenInfo.new(0.18), {
            Position = on and UDim2.new(0, 18, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        }):Play()
        if onChanged then onChanged(on) end
    end

    hit.MouseButton1Click:Connect(function() setOn(not state) end)

    return row, setOn, function() return state end, label
end

-- ============================================================
-- MAIN PAGE
-- ============================================================
local PageMain, ScrollMain = makePage("Main")
local SecControl = makeSection(ScrollMain, "Farm Control", 214)

local ScanBtn = makeButton(SecControl, "START SCAN", UDim2.new(0, 12, 0, 26), UDim2.new(1, -24, 0, 28), "success")
ScanBtn.Text = cfg.startScan and "SCANNING..." or "START SCAN"

new("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 60),
    Size = UDim2.new(1, -120, 0, 20), Font = Enum.Font.Gotham,
    Text = "Auto Submit After", TextColor3 = Theme.TextSub, TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
}, SecControl)

local SubmitAfterBox = makeTextInput(SecControl, "3", tostring(cfg.submitAfter), UDim2.new(1, -70, 0, 60), UDim2.new(0, 58, 0, 22))

local AutoRow, setAuto, getAuto, AutoLabel = makeToggle(SecControl, UDim2.new(0, 12, 0, 88), cfg.autoSubmit, function(on)
    cfg.autoSubmit = on; saveConfig()
end)
AutoLabel.Text = "Auto Submit"

local RiddleRow, setRiddle, getRiddle, RiddleLabel = makeToggle(SecControl, UDim2.new(0, 12, 0, 118), cfg.autoRiddle, function(on)
    cfg.autoRiddle = on; saveConfig()
end)
RiddleLabel.Text = "AI Riddle Solver"

local SpamRow, setSpam, getSpam, SpamLabel = makeToggle(SecControl, UDim2.new(0, 12, 0, 148), cfg.spamRedeem, function(on)
    cfg.spamRedeem = on; saveConfig()
end)
SpamLabel.Text = "Spam Redeem"

new("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 180),
    Size = UDim2.new(1, -120, 0, 20), Font = Enum.Font.Gotham,
    Text = "Spam Count", TextColor3 = Theme.TextSub, TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
}, SecControl)

local SpamCountBox = makeTextInput(SecControl, "20", tostring(cfg.spamCount), UDim2.new(1, -70, 0, 180), UDim2.new(0, 58, 0, 22))

-- ============================================================
-- LOGS SECTION
-- ============================================================
local SecLogs = makeSection(ScrollMain, "Logs", 180)
local ClearLogsBtn = makeButton(SecLogs, "CLEAR", UDim2.new(1, -68, 0, 2), UDim2.new(0, 56, 0, 18), "accent")

local LogFrame = new("ScrollingFrame", {
    Position = UDim2.new(0, 10, 0, 24),
    Size = UDim2.new(1, -20, 0, 148),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.5,
    BorderSizePixel = 0, ScrollBarThickness = 3,
    ScrollBarImageColor3 = Theme.Accent,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ClipsDescendants = true, ZIndex = 5,
}, SecLogs)
corner(LogFrame, UDim.new(0, 5))
new("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = Enum.FillDirection.Vertical }, LogFrame)
new("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }, LogFrame)

local logEntries = {}

-- Print log to UI and console
local function consoleLog(msg)
    local t = os.date("%H:%M:%S")
    local entry = "[" .. t .. "] " .. tostring(msg)
    table.insert(logEntries, entry)
    if #logEntries > 200 then table.remove(logEntries, 1) end
    print("[SNIPER] " .. entry)
    local lbl = new("TextLabel", {
        Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Font = Enum.Font.Code, TextSize = 9,
        TextColor3 = Theme.TextSub, TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true, Text = entry, LayoutOrder = #logEntries, ZIndex = 6,
    }, LogFrame)
    tag(lbl, "textSub")
    task.defer(function() LogFrame.CanvasPosition = Vector2.new(0, math.huge) end)
end

-- Clear all log labels
ClearLogsBtn.MouseButton1Click:Connect(function()
    for _, c in ipairs(LogFrame:GetChildren()) do
        if c:IsA("TextLabel") then c:Destroy() end
    end
    logEntries = {}
    consoleLog("Logs cleared")
end)

-- ============================================================
-- TESTER PAGE
-- ============================================================
local PageTester, ScrollTester = makePage("Tester")
local SecTest = makeSection(ScrollTester, "Test Sender", 130)
new("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 24),
    Size = UDim2.new(1, -24, 0, 12), Font = Enum.Font.Gotham,
    Text = "Simulate a notification:", TextColor3 = Theme.TextMuted,
    TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
}, SecTest)
local TestInput = makeTextInput(SecTest, "the code is ABC123...", "", UDim2.new(0, 12, 0, 40), UDim2.new(1, -24, 0, 26))
local SendBtn = makeButton(SecTest, "SEND TEST", UDim2.new(0, 12, 0, 74), UDim2.new(0.5, -16, 0, 26), "success")
local ClearTestBtn = makeButton(SecTest, "CLEAR", UDim2.new(0.5, 4, 0, 74), UDim2.new(0.5, -16, 0, 26), "accent")

local SecTestCode = makeSection(ScrollTester, "Test Code", 110)
new("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 24),
    Size = UDim2.new(1, -24, 0, 12), Font = Enum.Font.Gotham,
    Text = "Sends CERB > IS > TUFF with delay between each", TextColor3 = Theme.TextMuted,
    TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
}, SecTestCode)
new("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 44),
    Size = UDim2.new(0, 120, 0, 20), Font = Enum.Font.Gotham,
    Text = "Delay between (s)", TextColor3 = Theme.TextSub, TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
}, SecTestCode)
local TestDelayBox = makeTextInput(SecTestCode, "1", tostring(cfg.testDelay), UDim2.new(1, -70, 0, 44), UDim2.new(0, 58, 0, 22))
local TestCodeBtn = makeButton(SecTestCode, "TEST CODE", UDim2.new(0, 12, 0, 76), UDim2.new(1, -24, 0, 26), "info")

local SecLastCode = makeSection(ScrollTester, "Last Captured Code", 82)
local LastCodeLabel = new("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 24),
    Size = UDim2.new(1, -24, 0, 20), Font = Enum.Font.Code,
    Text = "--", TextColor3 = Theme.TextMain, TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
}, SecLastCode)
tag(LastCodeLabel, "textMain")
local RedeemBtn = makeButton(SecLastCode, "REDEEM", UDim2.new(0, 12, 0, 50), UDim2.new(0.5, -16, 0, 24), "success")
local CopyBtn = makeButton(SecLastCode, "COPY", UDim2.new(0.5, 4, 0, 50), UDim2.new(0.5, -16, 0, 24), "accent")

local SecPing = makeSection(ScrollTester, "Test Ping (CERBISTUFF)", 70)
new("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 24),
    Size = UDim2.new(1, -24, 0, 16), Font = Enum.Font.Gotham,
    Text = "Redeems CERBISTUFF (spam if Spam Redeem ON)", TextColor3 = Theme.TextMuted,
    TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
}, SecPing)
local TestPingBtn = makeButton(SecPing, "TEST PING", UDim2.new(0, 12, 0, 42), UDim2.new(1, -24, 0, 22), "info")

-- ============================================================
-- SETTINGS PAGE
-- ============================================================
local PageSettings, ScrollSettings = makePage("Settings")
local SecSett = makeSection(ScrollSettings, "Configuration", 400)

new("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 24),
    Size = UDim2.new(0, 120, 0, 20), Font = Enum.Font.Gotham,
    Text = "Delay (s)", TextColor3 = Theme.TextSub, TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
}, SecSett)
local DelayBox = makeTextInput(SecSett, "0", tostring(cfg.redeemDelay), UDim2.new(1, -70, 0, 24), UDim2.new(0, 58, 0, 22))

new("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 52),
    Size = UDim2.new(0, 120, 0, 20), Font = Enum.Font.Gotham,
    Text = "AI API Key", TextColor3 = Theme.TextSub, TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
}, SecSett)

local ApiKeyBox = makeTextInput(SecSett, MASKED_API_KEY, MASKED_API_KEY, UDim2.new(0, 12, 0, 72), UDim2.new(1, -24, 0, 24))
ApiKeyBox.TextEditable = false

local SafeRow, setSafe, getSafe, SafeLabel = makeToggle(SecSett, UDim2.new(0, 12, 0, 104), cfg.safeMode, function(on)
    cfg.safeMode = on; saveConfig()
end)
SafeLabel.Text = "Safe Mode"

local OptRow, setOpt, getOpt, OptLabel = makeToggle(SecSett, UDim2.new(0, 12, 0, 134), cfg.optimizePing, function(on)
    cfg.optimizePing = on; saveConfig()
end)
OptLabel.Text = "Optimize Ping"

local WebRow, setWeb, getWeb, WebLabel = makeToggle(SecSett, UDim2.new(0, 12, 0, 164), cfg.sendWebhook, function(on)
    cfg.sendWebhook = on; saveConfig()
end)
WebLabel.Text = "Discord Webhook"

local WaitRow, setWait, getWait, WaitLabel = makeToggle(SecSett, UDim2.new(0, 12, 0, 194), cfg.waitInvalid, function(on)
    cfg.waitInvalid = on
    if not on then
        runtime.waitInvalidMode = false
        runtime.pendingCode = ""
        runtime.retryCount = 0
    end
    saveConfig()
end)
WaitLabel.Text = "Wait for Msg if Invalid"

local TwoWordRow, setTwoWord, getTwoWord, TwoWordLabel = makeToggle(SecSett, UDim2.new(0, 12, 0, 224), cfg.twoWordCheck, function(on)
    cfg.twoWordCheck = on
    saveConfig()
end)
TwoWordLabel.Text = "2 Word Check"

-- FIX: attach listener when AutoStart toggled ON
local AutoStartRow, setAutoStart, getAutoStart, AutoStartLabel = makeToggle(SecSett, UDim2.new(0, 12, 0, 254), cfg.autoStartOnCode, function(on)
    cfg.autoStartOnCode = on
    runtime.autoStartArmed = on
    if on then
        startNotifListener()
    end
    saveConfig()
end)
AutoStartLabel.Text = "Auto Start Scan on Code Is"

local TypeRow, setType, getType, TypeLabel = makeToggle(SecSett, UDim2.new(0, 12, 0, 284), cfg.typeInsteadOfAdd, function(on)
    cfg.typeInsteadOfAdd = on
    saveConfig()
end)
TypeLabel.Text = "Type Instead Of Add"

new("TextLabel", {
    BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 314),
    Size = UDim2.new(0, 140, 0, 20), Font = Enum.Font.Gotham,
    Text = "Typing Speed (s)", TextColor3 = Theme.TextSub, TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
}, SecSett)
local TypingSpeedBox = makeTextInput(SecSett, "0.04", tostring(cfg.typingSpeed), UDim2.new(1, -70, 0, 314), UDim2.new(0, 58, 0, 22))

local PingBtn = makeButton(SecSett, "SHOW PING / FPS", UDim2.new(0, 12, 0, 350), UDim2.new(1, -24, 0, 26), "info")

-- ============================================================
-- THEMES PAGE
-- ============================================================
local PageThemes, ScrollThemes = makePage("Themes")
local ThemeScroll = new("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
    BorderSizePixel = 0, ScrollBarThickness = 4,
    ScrollBarImageColor3 = Theme.Accent,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 4,
}, ScrollThemes)

new("UIGridLayout", {
    CellSize = UDim2.new(0.5, -6, 0, 40),
    CellPadding = UDim2.new(0, 8, 0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, ThemeScroll)

local themeButtons = {}

-- Create one theme preview button
local function createThemeButton(themeKey, order)
    local t = THEMES[themeKey]
    local btn = new("TextButton", {
        Name = "Theme_" .. themeKey, BackgroundColor3 = t.Accent,
        BackgroundTransparency = 0.6, BorderSizePixel = 0,
        AutoButtonColor = false, Text = "", LayoutOrder = order, ZIndex = 5,
    }, ThemeScroll)
    corner(btn, UDim.new(0, 8))
    local bStroke = stroke(btn, t.StrokeColor, 1.5, 0.3, "themeBtnStroke")
    local bGrad = gradient(btn, t.Accent, t.Accent2, 45, "themeBtnGrad")
    new("TextLabel", {
        BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0), Font = Enum.Font.GothamBold,
        Text = t.Name, TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6,
    }, btn)

    if themeKey == UI.CurrentTheme then
        bStroke.Transparency = 0; bStroke.Thickness = 3
        btn.BackgroundTransparency = 0.35; btn:SetAttribute("selected", true)
    end
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.4 }):Play()
    end)
    btn.MouseLeave:Connect(function()
        if btn:GetAttribute("selected") then
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.35 }):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.6 }):Play()
        end
    end)
    themeButtons[themeKey] = { btn = btn, stroke = bStroke, grad = bGrad }
    btn.MouseButton1Click:Connect(function() applyTheme(themeKey) end)
end

-- Apply theme to every tagged UI element
function applyTheme(themeKey)
    local t = THEMES[themeKey]
    if not t then return end
    UI.CurrentTheme = themeKey; Theme = t
    cfg.theme = themeKey; saveConfig()

    local ti = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    for _, obj in ipairs(ScreenGui:GetDescendants()) do
        if obj:IsA("GuiObject") then
            local tg = obj:GetAttribute("ThemeTag")
            if tg == "sidebar" then
                TweenService:Create(obj, ti, { BackgroundColor3 = t.SidebarBg }):Play()
            elseif tg == "accent" then
                TweenService:Create(obj, ti, { BackgroundColor3 = t.Accent }):Play()
            elseif tg == "danger" then
                TweenService:Create(obj, ti, { BackgroundColor3 = t.Danger }):Play()
            end
            if tg and tg:sub(1,4) == "btn_" then
                local kind = tg:sub(5)
                local col
                if kind == "accent" then col = t.Accent
                elseif kind == "accent2" then col = t.Accent2
                elseif kind == "success" then col = t.Success
                elseif kind == "danger" then col = t.Danger
                elseif kind == "info" then col = t.Info
                else col = t.Accent end
                TweenService:Create(obj, ti, { BackgroundColor3 = col }):Play()
            end
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                if tg == "textMain" then
                    TweenService:Create(obj, ti, { TextColor3 = t.TextMain }):Play()
                elseif tg == "textSub" then
                    TweenService:Create(obj, ti, { TextColor3 = t.TextSub }):Play()
                elseif tg == "sectionLabel" then
                    TweenService:Create(obj, ti, { TextColor3 = t.TextMuted }):Play()
                elseif tg == "danger" then
                    TweenService:Create(obj, ti, { TextColor3 = t.Danger }):Play()
                elseif tg == "tabLabel" then
                    local parent = obj.Parent
                    local isActive = parent and parent:GetAttribute("active")
                    TweenService:Create(obj, ti, { TextColor3 = isActive and t.TextMain or t.TextSub }):Play()
                end
            end
        end
        if obj:IsA("UIStroke") then
            local tg = obj:GetAttribute("ThemeTag")
            if tg == "strokeAccent" or tg == "stroke" then
                TweenService:Create(obj, ti, { Color = t.StrokeColor }):Play()
            elseif tg == "danger" then
                TweenService:Create(obj, ti, { Color = t.Danger }):Play()
            elseif tg == "glowStroke" then
                TweenService:Create(obj, ti, { Color = t.Accent }):Play()
            end
        end
        if obj:IsA("UIGradient") then
            local tg = obj:GetAttribute("ThemeTag")
            if tg == "main" then
                TweenService:Create(obj, ti, { Color = ColorSequence.new(t.Bg, t.SidebarBg) }):Play()
            elseif tg == "logo" then
                TweenService:Create(obj, ti, { Color = ColorSequence.new(t.Accent, t.Accent2) }):Play()
            end
        end
        if obj:IsA("ScrollingFrame") and obj:GetAttribute("ThemeTag") == "scrollFrame" then
            TweenService:Create(obj, ti, { ScrollBarImageColor3 = t.Accent }):Play()
        end
    end
    TweenService:Create(Main, ti, { BackgroundColor3 = t.Bg }):Play()
    TweenService:Create(LogFrame, ti, { ScrollBarImageColor3 = t.Accent }):Play()
    TweenService:Create(ThemeScroll, ti, { ScrollBarImageColor3 = t.Accent }):Play()

    for key, tb in pairs(themeButtons) do
        local tt = THEMES[key]
        TweenService:Create(tb.grad, ti, { Color = ColorSequence.new(tt.Accent, tt.Accent2) }):Play()
        TweenService:Create(tb.stroke, ti, {
            Color = tt.StrokeColor,
            Transparency = (key == themeKey) and 0 or 0.3,
            Thickness = (key == themeKey) and 3 or 1.5
        }):Play()
        if key == themeKey then
            tb.btn:SetAttribute("selected", true)
            TweenService:Create(tb.btn, ti, { BackgroundTransparency = 0.35 }):Play()
        else
            tb.btn:SetAttribute("selected", false)
            TweenService:Create(tb.btn, ti, { BackgroundTransparency = 0.6 }):Play()
        end
    end
    for _, tab in ipairs(tabRefs) do
        TweenService:Create(tab.indicator, ti, { BackgroundColor3 = t.Accent }):Play()
    end

    -- FIX: reapply correct StatusPill colors based on actual state
    local active = cfg.startScan
    StatusPill.BackgroundColor3 = active and t.Success or t.Danger
    StatusPill.BackgroundTransparency = 0.75
    StatusText.TextColor3 = active and t.Success or t.Danger
    for _, c in ipairs(StatusPill:GetChildren()) do
        if c:IsA("Frame") then c.BackgroundColor3 = active and t.Success or t.Danger end
        if c:IsA("UIStroke") then c.Color = active and t.Success or t.Danger end
    end
end

local themeOrder = { "VIPRIN", "Default", "Sakura", "Orage", "Feu", "Ocean", "Automne", "Space", "Crystal", "RGB", "DarkLuxe", "Holographic", "Fun", "Retro" }
for i, key in ipairs(themeOrder) do createThemeButton(key, i) end

-- ============================================================
-- QUESTIONS PAGE
-- ============================================================
local PageQuestions, ScrollQuestions = makePage("Questions")

-- Create a Q&A card
local function makeQuestionSection(parent, title, text)
    local sec = new("Frame", {
        Size = UDim2.new(1, 0, 0, 10), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.94,
        BorderSizePixel = 0, ZIndex = 4,
    }, parent)
    corner(sec, UDim.new(0, 10))
    stroke(sec, Theme.StrokeColor, 1, 0.75, "strokeAccent")

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.Parent = sec

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = sec

    local titleLbl = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 12), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, Text = string.upper(title),
        TextColor3 = Theme.Accent, TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
        TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1,
    }, sec)
    tag(titleLbl, "accent")

    local descLbl = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 10), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = text, TextColor3 = Theme.TextSub, TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true, ZIndex = 5, LayoutOrder = 2,
    }, sec)
    tag(descLbl, "textSub")

    return sec
end

local SecQ1 = makeQuestionSection(ScrollQuestions, "Farm Control", 
    "START SCAN : Active ou désactive la capture automatique des notifications du jeu.\n\n" ..
    "Auto Submit After : Nombre de messages à capturer avant de lancer le redeem automatiquement.\n" ..
    "Exemple : si réglé sur 3, il attend 3 messages (ex: CERB / IS / TUFF) et assemble le code.\n\n" ..
    "Auto Submit : Si activé, le script envoie le code automatiquement dès qu'il est complet. Si désactivé, tu peux cliquer sur REDEEM manuellement.\n\n" ..
    "AI Riddle Solver : Si activé, le script détecte les devinettes (riddles) dans les messages du jeu et utilise une IA pour trouver la réponse, puis redeem automatiquement.\n\n" ..
    "Spam Redeem : Au lieu de cliquer une seule fois sur le bouton de confirmation, le script clique plusieurs fois (voir Spam Count).\n\n" ..
    "Spam Count : Nombre de clics lors d'un Spam Redeem. Max 100."
)

local SecQ2 = makeQuestionSection(ScrollQuestions, "Settings", 
    "Delay (s) : Temps d'attente en secondes avant de lancer le redeem. Utile pour laisser le temps au jeu d'afficher le code.\n\n" ..
    "AI API Key : Clé API pour le solveur de riddles. Elle est masquée pour des raisons de sécurité.\n\n" ..
    "Safe Mode : Mode plus prudent pour éviter les erreurs de capture.\n\n" ..
    "Optimize Ping : Réduit la qualité graphique pour améliorer les performances et diminuer le ping.\n\n" ..
    "Discord Webhook : Si activé, envoie un message Discord à chaque fois qu'un code est capturé ou redeem.\n\n" ..
    "Wait for Msg if Invalid : Si le redeem renvoie une erreur (Invalid Code), le script garde le code en mémoire et attend un message de plus pour l'ajouter au code et retenter. Max 10 retries.\n\n" ..
    "2 Word Check : Force le redeem au 2ème message. S'il y a une erreur 'Invalid Code', il garde le code et attend le prochain message pour l'ajouter et retenter (sans avoir besoin d'activer Wait for Invalid).\n\n" ..
    "Auto Start Scan on Code Is : Écoute constamment les messages. Si un message contient 'code is', 'use code', 'the code is', 'enter code' ou 'redeem code', il active automatiquement le Start Scan.\n\n" ..
    "Type Instead Of Add : Au lieu d'écrire le code d'un coup dans la TextBox, le script tape chaque lettre une par une (comme un vrai joueur).\n\n" ..
    "Typing Speed (s) : Vitesse d'écriture en secondes entre chaque lettre. Plus c'est bas, plus c'est rapide. Recommandé : 0.03 - 0.06."
)

local SecQ3 = makeQuestionSection(ScrollQuestions, "Tester", 
    "Test Sender : Permet de simuler une notification pour tester la capture. Tape un message et clique sur SEND TEST.\n\n" ..
    "Test Code : Envoie automatiquement 3 notifications (CERB / IS / TUFF) avec un délai entre chaque (configurable). Idéal pour tester l'assemblage de code.\n\n" ..
    "Delay between (s) : Délai en secondes entre chaque faux message lors du Test Code.\n\n" ..
    "Last Captured Code : Affiche le dernier code capturé. Tu peux cliquer sur REDEEM pour le redeem manuellement ou COPY pour le copier.\n\n" ..
    "Test Ping : Envoie 'CERBISTUFF' pour tester si le redeem fonctionne correctement (respecte le mode Spam et Type Instead Of Add)."
)

local SecQ4 = makeQuestionSection(ScrollQuestions, "Themes", 
    "Change l'apparence complète du menu (couleurs, dégradés, glow, etc.).\n\n" ..
    "14 thèmes disponibles : VIPRIN, Default, Sakura, Orage, Feu, Ocean, Automne, Space, Crystal, RGB, DarkLuxe, Holographic, Fun, Retro.\n\n" ..
    "Le thème est sauvegardé automatiquement et sera appliqué au prochain lancement."
)

local SecQ5 = makeQuestionSection(ScrollQuestions, "Fonctionnement Général", 
    "1. Active START SCAN en haut à gauche.\n" ..
    "2. Le script écoute les notifications du jeu (annonces serveur).\n" ..
    "3. Il assemble les messages jusqu'à atteindre 'Auto Submit After' (ou 2 si 2 Word Check).\n" ..
    "4. Si Auto Riddle Solver est activé, il utilise l'IA pour résoudre les devinettes.\n" ..
    "5. Si Auto Submit est activé, il écrit le code dans la TextBox et clique sur Confirm.\n" ..
    "6. En cas de succès, il t'envoie une notification Roblox et Discord (si activé).\n\n" ..
    "Le script garde toute ta configuration en mémoire, pas besoin de tout refaire à chaque fois."
)

local SecQ6 = makeQuestionSection(ScrollQuestions, "Conseils", 
    "- Active '2 Word Check' pour les codes qui arrivent en 2 parties (retry auto inclus).\n\n" ..
    "- Laisse 'Typing Speed' aux alentours de 0.04s pour un bon équilibre entre rapidité et discrétion.\n\n" ..
    "- Teste tes réglages avec 'Test Code' avant de farm pour être sûr que tout fonctionne.\n\n" ..
    "- Si le redeem échoue souvent, active 'Wait for Msg if Invalid' ou baisse 'Auto Submit After'.\n\n" ..
    "- Le mode 'Spam Redeem' peut faire ban si abusé, utilise-le avec modération."
)

-- ============================================================
-- TAB SWITCHING
-- ============================================================
local Pages = {
    { label = "Main",      page = PageMain },
    { label = "Tester",    page = PageTester },
    { label = "Settings",  page = PageSettings },
    { label = "Themes",    page = PageThemes },
    { label = "Questions", page = PageQuestions },
}
local currentTab = nil

-- Show a specific page and highlight the tab
local function switchTab(index)
    if currentTab == index then return end
    local prev = currentTab
    currentTab = index
    for i, tab in ipairs(tabRefs) do
        local active = (i == index)
        tab.btn:SetAttribute("active", active)
        TweenService:Create(tab.btn, TweenInfo.new(0.25), { BackgroundTransparency = active and 0.82 or 1 }):Play()
        TweenService:Create(tab.lbl, TweenInfo.new(0.25), { TextColor3 = active and Theme.TextMain or Theme.TextSub }):Play()
        tab.indicator.Visible = active
    end
    if prev then Pages[prev].page.Visible = false end
    local newPage = Pages[index].page
    newPage.Visible = true
    newPage.Position = UDim2.new(0, 16, 0, 0)
    TweenService:Create(newPage, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(0, 0, 0, 0) }):Play()
    PageTitle.Text = Pages[index].label
end
for i, def in ipairs(Pages) do
    local btn = makeTab(def.label, i - 1)
    btn.MouseButton1Click:Connect(function() switchTab(i) end)
end
switchTab(1)

-- ============================================================
-- STATUS PILL UPDATE
-- ============================================================
-- Update ON/OFF pill in topbar
local function updateStatus()
    local active = cfg.startScan
    StatusText.Text = active and "ON" or "OFF"
    StatusText.TextColor3 = active and Theme.Success or Theme.Danger
    StatusPill.BackgroundColor3 = active and Theme.Success or Theme.Danger
    StatusPill.BackgroundTransparency = 0.75
    for _, c in ipairs(StatusPill:GetChildren()) do
        if c:IsA("Frame") then c.BackgroundColor3 = active and Theme.Success or Theme.Danger end
        if c:IsA("UIStroke") then c.Color = active and Theme.Success or Theme.Danger end
    end
end
updateStatus()

-- ============================================================
-- RUNTIME HELPERS
-- ============================================================

-- Check if an instance belongs to our GUI
local function isOurGui(instance)
    local p = instance
    for _ = 1, 10 do
        if not p then break end
        if p.Name == "ViprinRound8UI" or p.Name == "WeeklyCodeSniperUI" or p.Name == "WeeklySettingsUI" then return true end
        p = p.Parent
    end
    return false
end

-- Try multiple ways to fire a button click
local function clickButton(btn)
    if not btn then return false end
    local anyOk = false
    local methods = {
        function() btn.MouseButton1Click:Fire() end,
        function() btn.Activated:Fire() end,
    }
    if typeof(firesignal) == "function" then
        table.insert(methods, function() firesignal(btn.MouseButton1Click) end)
        table.insert(methods, function() firesignal(btn.Activated) end)
    end
    if typeof(getconns) == "function" then
        table.insert(methods, function()
            local ok, cs = pcall(getconns, btn.MouseButton1Click)
            if ok and type(cs) == "table" then
                for _, c in ipairs(cs) do pcall(function() c:Fire() end) end
            end
        end)
    end
    if typeof(fireclick) == "function" then
        table.insert(methods, function() fireclick(btn) end)
    end
    for _, fn in ipairs(methods) do anyOk = anyOk or pcall(fn) end
    return anyOk
end

-- Show a Roblox notification
local function sendRobloxNotification(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 5
        })
    end)
end

-- Locate the code TextBox and Confirm button
local function getCodeBoxAndConfirm()
    local ok, result = pcall(function()
        local Codes = PlayerGui:WaitForChild("Codes", 3).Codes
        local textBox = Codes.CodeRedeem.TextBox
        local confirmButton = Codes.Confirm
        return { box = textBox, confirm = confirmButton }
    end)
    if ok then return result end
    return nil
end

-- Type a string into the code box character by character
local function typeStringInBox(data, str)
    if not data or not data.box then return false end
    local speed = math.max(0.005, tonumber(cfg.typingSpeed) or 0.04)
    for i = 1, #str do
        if runtime.typingCancel then return false end
        local char = str:sub(i, i)
        pcall(function()
            data.box.Text = data.box.Text .. char
        end)
        task.wait(speed)
    end
    return true
end

-- Worker that drains the typing queue
local function typingWorker()
    if runtime.typingBusy then return end
    runtime.typingBusy = true

    while #runtime.typingQueue > 0 do
        if runtime.typingCancel or not cfg.typeInsteadOfAdd then break end
        local data = getCodeBoxAndConfirm()
        if not data or not data.box then break end

        if not runtime.boxCleared then
            pcall(function() data.box:CaptureFocus() end)
            pcall(function() data.box.Text = "" end)
            runtime.boxCleared = true
        end

        local str = table.remove(runtime.typingQueue, 1)
        consoleLog("Typing: " .. str)
        typeStringInBox(data, str)
    end

    runtime.typingBusy = false
    if #runtime.typingQueue == 0 then
        runtime.typingDone = true
    end
end

-- Add a string to the typing queue
local function queueTyping(str)
    if not str or str == "" then return end
    runtime.typingDone = false
    table.insert(runtime.typingQueue, str)
    if not runtime.typingBusy then
        task.spawn(typingWorker)
    end
end

-- Stop and clear typing state
local function resetTyping()
    runtime.typingQueue = {}
    runtime.typingCancel = true
    task.wait(0.02)
    runtime.typingCancel = false
    runtime.typingBusy = false
    runtime.boxCleared = false
    runtime.typingDone = false
end

-- Wait until typing finishes or timeout
local function waitForTypingComplete(timeout)
    timeout = timeout or 30
    local start = tick()
    while (runtime.typingBusy or #runtime.typingQueue > 0) and (tick() - start < timeout) do
        task.wait(0.05)
    end
    task.wait(0.15)
    return (not runtime.typingBusy) and (#runtime.typingQueue == 0)
end

-- ⚠️ BACKDOOR REMOVED ⚠️
-- The block that used to be here downloaded a remote script from
-- pastebin.com/raw/2H5JyQKE and executed it via loadstring. That
-- was the reason the GUI was being destroyed right after creation.
-- It has been permanently deleted. DO NOT re-add it.

-- Release focus and press confirm after typing
local function finalizeTyping()
    local ok = waitForTypingComplete(30)
    if not ok then consoleLog("Warning: typing timeout, still submitting") end

    local data = getCodeBoxAndConfirm()
    if not data then return end
    pcall(function() firesignal(data.box.FocusLost, true) end)
    pcall(function() data.box:ReleaseFocus(true) end)
    local button = data.confirm:FindFirstChildWhichIsA("TextButton") or data.confirm
    if button then
        pcall(function() firesignal(button.MouseButton1Click) end)
        pcall(function() firesignal(button.Activated) end)
    end
    runtime.boxCleared = false
    runtime.typingDone = false
end

-- ============================================================
-- REDEEM
-- ============================================================
-- Submit a code instantly (optionally spam clicks)
local function redeemCodeClassic(code, forceNoSpam)
    if not code or code == "" then return false, "no code" end

    local ok, err = pcall(function()
        local Codes = PlayerGui:WaitForChild("Codes", 3).Codes
        local textBox = Codes.CodeRedeem.TextBox
        local confirmButton = Codes.Confirm

        -- Set text and press confirm once
        local function executeRedeem()
            textBox.Text = code
            pcall(function() firesignal(textBox.FocusLost, true) end)
            local button = confirmButton:FindFirstChildWhichIsA("TextButton") or confirmButton
            if button then
                pcall(function() firesignal(button.MouseButton1Click) end)
                pcall(function() firesignal(button.Activated) end)
            end
        end

        local useSpam = cfg.spamRedeem and not forceNoSpam
        if useSpam then
            local n = math.clamp(tonumber(cfg.spamCount) or 20, 1, 100)
            for i = 1, n do
                task.spawn(function()
                    if i > 1 then task.wait((i - 1) * 0.04) end
                    executeRedeem()
                end)
            end
        else
            executeRedeem()
        end
    end)

    if not ok then
        return false, "no code box"
    end

    return true, (cfg.spamRedeem and not forceNoSpam) and "spammed" or "submitted"
end

-- Redeem through typed input if enabled, otherwise instant
local function redeemFinalCode(code)
    if not code or code == "" then return false, "no code" end
    if cfg.typeInsteadOfAdd then
        task.spawn(function() finalizeTyping() end)
        return true, "typed-finalized"
    end
    return redeemCodeClassic(code)
end

-- Send captured code to Discord webhook
local function sendWebhook(code, triggerText, isRiddle)
    if not cfg.sendWebhook then return end
    if not httpRequest then return end
    local displayName = LocalPlayer.DisplayName
    local username = LocalPlayer.Name
    local currentTime = os.date("%H:%M:%S")
    local typeStr = isRiddle and "Riddle" or "Code"
    local description = string.format(
        "Sniper Triggered\nPlayer: %s (@%s)\nTrigger: %s\nCode: %s\nTime: %s\nType: %s",
        displayName, username, tostring(triggerText or ""), tostring(code), currentTime, typeStr
    )
    local embed = { description = description, color = 65280, footer = { text = "Weekly Code Sniper | " .. currentTime } }
    local body = HttpService:JSONEncode({ content = "@here", embeds = {embed} })
    pcall(function()
        httpRequest({ Url = WEBHOOK_URL, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = body })
    end)
end

-- ============================================================
-- AI RIDDLE
-- ============================================================
-- Remove forbidden characters from AI answer
local function sanitizeAiResponse(text)
    if not text then return "" end
    local forbidden = { ['"']=true, ["'"]=true, [":"]=true, [";"]=true, ["!"]=true, ["?"]=true, ["*"]=true, ["+"]=true, ["("]=true, [")"]=true, ["/"]=true, ["€"]=true, ["#"]=true, ["@"]=true, ["&"]=true, [","]=true }
    local out = {}
    for i = 1, #text do
        local char = text:sub(i, i)
        if not forbidden[char] then table.insert(out, char) end
    end
    return table.concat(out)
end

-- Ask the AI API to solve a riddle
local function solveRiddleWithAPI(text)
    if not text or text == "" then return nil end
    local addNum = text:match("%+%s*(%d+)")
    local cleanText = text:gsub("%+%s*%d+", ""):match("^%s*(.-)%s*$")
    if not cleanText or cleanText == "" then cleanText = text end
    local rawCode = nil
    if httpRequest then
        local success, res = pcall(function()
            return httpRequest({
                Url = AI_API_URL, Method = "POST",
                Headers = { ["Content-Type"] = "application/json", ["Authorization"] = "Bearer " .. (API_KEY ~= "" and API_KEY or "sab_0471641fd41bb2f183b4596cc5e3cb56377b65740bea5f28") },
                Body = HttpService:JSONEncode({
                    riddle = cleanText, question = cleanText, prompt = cleanText, model = AI_MODEL,
                    messages = {
                        { role = "system", content = "Solve the riddle and provide ONLY the answer. No special characters." },
                        { role = "user", content = cleanText }
                    }
                })
            })
        end)
        if success and res and res.Body then
            local okDec, data = pcall(function() return HttpService:JSONDecode(res.Body) end)
            if okDec and data then
                if data.code then rawCode = tostring(data.code)
                elseif data.answer then rawCode = tostring(data.answer)
                elseif data.result then rawCode = tostring(data.result)
                elseif data.choices and data.choices[1] and data.choices[1].message then
                    rawCode = tostring(data.choices[1].message.content)
                elseif type(data) == "string" then rawCode = data end
            end
        end
    end
    if not rawCode then return nil end
    local processed = rawCode
    local lowerText = cleanText:lower()
    if lowerText:find("age") or lowerText:find("old") then
        local numOnly = processed:match("%d+")
        if numOnly then processed = numOnly end
    else
        processed = processed:upper():gsub("%s+", "")
    end
    if addNum then processed = processed .. addNum end
    processed = sanitizeAiResponse(processed)
    return processed
end

-- ============================================================
-- TEXT PARSING
-- ============================================================
-- Strip Roblox rich-text tags
local function stripRich(text)
    if type(text) ~= "string" then return tostring(text) end
    return (text:gsub("<[^>]->", ""))
end

-- Split text into words
local function tokenize(text)
    local words = {}
    for word in text:gmatch("[%w_]+") do words[#words + 1] = word end
    return words
end

local INVALID_PATTERNS = {
    "invalid code", "invalid", "expired", "already redeemed", "already used",
    "not found", "rejected", "does not exist", "code redeemed", "you have already",
}

-- Check if a message looks like an invalid-code error
local function isInvalidMessage(text)
    local l = tostring(text or ""):lower()
    for _, p in ipairs(INVALID_PATTERNS) do
        if l:find(p, 1, true) then return true, p end
    end
    return false
end

local CODE_TRIGGERS = {
    "code is", "use code", "the code is", "enter code", "redeem code",
}

-- Normalize punctuation to spaces for trigger matching
local function normalizeForTrigger(text)
    local t = tostring(text or ""):lower()
    t = t:gsub("[%:%;%!%?%'%\"%*%#%€%_%&%-%+%(%)%/%@%.]", " ")
    t = t:gsub("%s+", " ")
    return t
end

-- Check if a message contains a code trigger phrase
local function containsCodeTrigger(text)
    local norm = normalizeForTrigger(text)
    for _, trig in ipairs(CODE_TRIGGERS) do
        if norm:find(trig, 1, true) then return true, trig end
    end
    return false
end

local lastCapturedForUI = nil

-- ============================================================
-- ANNOUNCEMENT HANDLER
-- ============================================================
-- Main handler for every server notification
local function onAnnouncement(...)
    local text = stripRich(tostring((...) or ""))
    text = text:match("^%s*(.-)%s*$") or ""
    if text == "" then return end
    if runtime.seen[text] then return end
    runtime.seen[text] = true
    task.delay(2, function() runtime.seen[text] = nil end)

    -- Detect brainrot spawn messages
    local spawned = text:match("^(.-)%s+spawned!")
    if spawned and spawned ~= "" then
        runtime.lastBrainrotName = spawned
        consoleLog("Brainrot detected: " .. spawned)
    end

    -- Auto start scan when code trigger is found
    if cfg.autoStartOnCode and runtime.autoStartArmed then
        local hasTrigger, trig = containsCodeTrigger(text)
        if hasTrigger then
            consoleLog("Trigger detected (" .. tostring(trig) .. ") -> Start Scan ON")
            if not cfg.startScan then
                cfg.startScan = true
                ScanBtn.Text = "SCANNING..."
                updateStatus()
                saveConfig()
                startNotifListener()
                consoleLog("Start Scan auto-ON")
            end
        end
    end

    if not cfg.startScan then return end
    consoleLog("Notification: [" .. text .. "]")

    -- Handle pending retry after Invalid
    if runtime.waitInvalidMode and (cfg.waitInvalid or cfg.twoWordCheck) then
        local invalid, matched = isInvalidMessage(text)
        if invalid then
            runtime.retryCount = runtime.retryCount + 1
            consoleLog("Invalid detected - retry " .. runtime.retryCount)
            if runtime.retryCount > runtime.maxRetries then
                consoleLog("Max retries reached, resetting")
                runtime.waitInvalidMode = false
                runtime.pendingCode = ""
                runtime.retryCount = 0
                runtime.capturedParts = {}
                resetTyping()
                return
            end
            runtime.capturedParts = {}
            return
        end

        consoleLog("Adding to pending code: " .. text)
        for _, word in ipairs(tokenize(text)) do table.insert(runtime.capturedParts, word) end
        local joined = runtime.pendingCode .. table.concat(runtime.capturedParts)
        runtime.capturedParts = {}
        runtime.pendingCode = ""
        runtime.waitInvalidMode = false
        runtime.retryCount = 0

        runtime.lastCode = joined
        lastCapturedForUI = joined
        LastCodeLabel.Text = joined

        if cfg.autoSubmit then
            task.spawn(function()
                task.wait(tonumber(cfg.redeemDelay) or 0)
                local ok, err = redeemFinalCode(joined)
                if ok then
                    consoleLog("Redeemed: " .. joined)
                    sendWebhook(joined, text, false)
                    sendRobloxNotification("GGBG Ta Redeem un Code", runtime.lastBrainrotName .. " Spawned!")
                    if cfg.waitInvalid or cfg.twoWordCheck then
                        runtime.waitInvalidMode = true
                        runtime.pendingCode = joined
                        runtime.retryCount = 1
                    end
                end
            end)
        end
        return
    end

    -- Try AI riddle solving
    if cfg.autoRiddle then
        task.spawn(function()
            local answer = solveRiddleWithAPI(text)
            if answer and answer ~= "" then
                runtime.lastCode = answer
                lastCapturedForUI = answer
                LastCodeLabel.Text = answer
                if cfg.autoSubmit then
                    task.wait(tonumber(cfg.redeemDelay) or 0)
                    local ok, err = redeemFinalCode(answer)
                    if ok then
                        consoleLog("Redeemed: " .. answer)
                        sendWebhook(answer, text, true)
                        sendRobloxNotification("GGBG Ta Redeem un Code", runtime.lastBrainrotName .. " Spawned!")
                    end
                end
            end
        end)
        return
    end

    -- Normal code capture flow
    local words = tokenize(text)
    for _, word in ipairs(words) do table.insert(runtime.capturedParts, word) end
    local count = #runtime.capturedParts
    local joined = table.concat(runtime.capturedParts)

    if cfg.typeInsteadOfAdd and cfg.autoSubmit then
        for _, word in ipairs(words) do queueTyping(word) end
    end

    local targetCount = cfg.twoWordCheck and 2 or cfg.submitAfter
    consoleLog("Captured " .. count .. "/" .. targetCount .. " [" .. joined .. "]")

    if count >= targetCount then
        runtime.lastCode = joined
        lastCapturedForUI = joined
        LastCodeLabel.Text = joined
        runtime.capturedParts = {}
        
        if cfg.autoSubmit then
            task.spawn(function()
                task.wait(tonumber(cfg.redeemDelay) or 0)
                local ok, err = redeemFinalCode(joined)
                if ok then
                    consoleLog("Redeemed: " .. joined)
                    sendWebhook(joined, text, false)
                    sendRobloxNotification("GGBG Ta Redeem un Code", runtime.lastBrainrotName .. " Spawned!")
                    
                    if cfg.twoWordCheck then
                        runtime.waitInvalidMode = true
                        runtime.pendingCode = joined
                        runtime.retryCount = 0
                        consoleLog("2 Word Check: waiting for Invalid response...")
                    elseif cfg.waitInvalid then
                        runtime.waitInvalidMode = true
                        runtime.pendingCode = joined
                        runtime.retryCount = 0
                    end
                end
            end)
        end
    end
end

-- ============================================================
-- NOTIFICATION LISTENER
-- ============================================================
-- Find the RemoteEvent used by NotificationController
local function resolveNotifyRemote()
    if runtime.notifyRemote and runtime.notifyRemote.Parent then return runtime.notifyRemote end
    local ok, ctrl = pcall(function() return require(ReplicatedStorage.Controllers:FindFirstChild("NotificationController", true)) end)
    if ok and type(ctrl) == "table" and type(ctrl.Start) == "function" then
        if getupvalues then
            local ok2, ups = pcall(getupvalues, ctrl.Start)
            if ok2 and type(ups) == "table" then
                for _, v in pairs(ups) do
                    if typeof(v) == "Instance" and (v:IsA("RemoteEvent") or v:IsA("UnreliableRemoteEvent")) then
                        runtime.notifyRemote = v; return v
                    end
                end
            end
        end
    end
    return nil
end

-- Attach the announcement listener once (assigns to forward-declared local)
function startNotifListener()
    if runtime.notifConn then return end
    local remote = resolveNotifyRemote()
    if remote then
        runtime.notifConn = remote.OnClientEvent:Connect(function(...) pcall(onAnnouncement, ...) end)
        consoleLog("Notification listener attached")
    end
end

-- Fire a fake notification for testing
local function fireTestNotification(message)
    if not message or message == "" then return end
    local remote = resolveNotifyRemote()
    if remote and typeof(firesignal) == "function" then
        if pcall(firesignal, remote.OnClientEvent, message, nil, nil, "Top", 2678001507) then return end
    end
    pcall(onAnnouncement, message)
end

-- ============================================================
-- BUTTON WIRING
-- ============================================================
ScanBtn.MouseButton1Click:Connect(function()
    cfg.startScan = not cfg.startScan
    ScanBtn.Text = cfg.startScan and "SCANNING..." or "START SCAN"
    updateStatus(); saveConfig()
    if cfg.startScan then startNotifListener(); consoleLog("Start Scan ON")
    else
        runtime.capturedParts = {}; runtime.waitInvalidMode = false; runtime.pendingCode = ""; runtime.retryCount = 0; resetTyping()
    end
end)

SubmitAfterBox.FocusLost:Connect(function()
    local n = tonumber(SubmitAfterBox.Text)
    cfg.submitAfter = (n and n >= 1) and math.floor(n) or 3
    SubmitAfterBox.Text = tostring(cfg.submitAfter)
    saveConfig()
end)

SpamCountBox.FocusLost:Connect(function()
    local n = tonumber(SpamCountBox.Text)
    cfg.spamCount = (n and n >= 1) and math.clamp(math.floor(n), 1, 100) or 20
    SpamCountBox.Text = tostring(cfg.spamCount)
    saveConfig()
end)

DelayBox.FocusLost:Connect(function()
    cfg.redeemDelay = math.max(0, tonumber(DelayBox.Text) or 0)
    DelayBox.Text = tostring(cfg.redeemDelay)
    saveConfig()
end)

TypingSpeedBox.FocusLost:Connect(function()
    cfg.typingSpeed = math.max(0.005, math.min(1, tonumber(TypingSpeedBox.Text) or 0.04))
    TypingSpeedBox.Text = tostring(cfg.typingSpeed)
    saveConfig()
end)

TestDelayBox.FocusLost:Connect(function()
    cfg.testDelay = math.max(0, math.min(10, tonumber(TestDelayBox.Text) or 1))
    TestDelayBox.Text = tostring(cfg.testDelay)
    saveConfig()
end)

SendBtn.MouseButton1Click:Connect(function() fireTestNotification(TestInput.Text) end)
ClearTestBtn.MouseButton1Click:Connect(function() TestInput.Text = "" end)

TestCodeBtn.MouseButton1Click:Connect(function()
    local delayTime = math.max(0, tonumber(cfg.testDelay) or 1)
    resetTyping()
    task.spawn(function()
        fireTestNotification("CERB")
        task.wait(delayTime)
        fireTestNotification("IS")
        task.wait(delayTime)
        fireTestNotification("TUFF")
    end)
end)

RedeemBtn.MouseButton1Click:Connect(function()
    local code = lastCapturedForUI or runtime.lastCode
    if code and code ~= "" then
        task.spawn(function()
            local ok = redeemFinalCode(code)
            if ok then sendWebhook(code, "Manual", false) end
        end)
    end
end)

CopyBtn.MouseButton1Click:Connect(function()
    local code = lastCapturedForUI or runtime.lastCode
    if code and code ~= "" and setclipboard then pcall(setclipboard, code) end
end)

TestPingBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        if cfg.typeInsteadOfAdd then
            resetTyping(); queueTyping("CERBISTUFF"); waitForTypingComplete(30); finalizeTyping()
        else
            redeemFinalCode("CERBISTUFF")
        end
    end)
end)

PingBtn.MouseButton1Click:Connect(function()
    local ping = 0
    pcall(function() ping = math.floor(LocalPlayer:GetNetworkPing() * 1000 + 0.5) end)
    consoleLog(string.format("Ping: %d ms", ping))
end)

-- ============================================================
-- MINIMIZE
-- ============================================================
-- Apply minimized/maximized window state
local function applyMinimize()
    if UI.Minimized then
        Main.Size = UDim2.new(0, 360, 0, 40); Sidebar.Visible = false; SepLine.Visible = false; Div.Visible = false; PageContainer.Visible = false
        MinimizeBtn.Text = "+"; MinimizeBtn.BackgroundColor3 = Color3.fromRGB(120, 220, 120)
    else
        Main.Size = UI.Size; Sidebar.Visible = true; SepLine.Visible = true; Div.Visible = true; PageContainer.Visible = true
        MinimizeBtn.Text = "-"; MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 60)
    end
end

MinimizeBtn.MouseButton1Click:Connect(function()
    UI.Minimized = not UI.Minimized; cfg.minimized = UI.Minimized; applyMinimize(); saveConfig()
end)
applyMinimize()

-- ============================================================
-- CLOSE + DRAG
-- ============================================================
CloseBtn.MouseButton1Click:Connect(function()
    if runtime.notifConn then pcall(function() runtime.notifConn:Disconnect() end) end
    ScreenGui:Destroy()
end)

-- Window dragging
do
    local dragging, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = Main.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ============================================================
-- BOOT
-- ============================================================
applyTheme(UI.CurrentTheme)

-- FIX: attach listener if auto-start is on but startScan is off
if cfg.startScan or cfg.autoStartOnCode then startNotifListener() end

Main.BackgroundTransparency = 1
TweenService:Create(Main, TweenInfo.new(0.4), { BackgroundTransparency = 0.2 }):Play()

getgenv = getgenv or function() return _G end

-- Global stop function
getgenv().StopWeeklySniper = function()
    if runtime.notifConn then pcall(function() runtime.notifConn:Disconnect() end) end
    if ScreenGui then ScreenGui:Destroy() end
end
