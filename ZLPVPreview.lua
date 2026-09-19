print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")
print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")
print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")
print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")
print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")
print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")
print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")
print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")
print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")
print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer
local playerGui = LP:WaitForChild("PlayerGui")

-- ============================================================
-- RUNTIME
-- ============================================================
local environment = (getgenv and getgenv()) or _G
local RUNTIME_KEY = "__WEEKLY_CODE_SNIPER_RUNTIME"
local previous = environment[RUNTIME_KEY]
if type(previous) == "table" and type(previous.destroy) == "function" then
    pcall(previous.destroy)
end

local runtime = {
    alive = true,
    enabled = false,
    snipeKey = Enum.KeyCode.Z,
    listeningKey = false,
    connections = {},
    spamCount = 20,
    submitAfter = 1,
    autoSubmit = false,
    spamRedeem = true,
    antiRagdoll = false,
    autoBuy = false,
    antiLag = false,
    removeAccessories = false,
    gui = nil,
    settingsGui = nil,
    headDisplay = nil,
    lastCode = nil,
    spamLoopActive = false,
    notifConn = nil,
    notifyRemote = nil,
    seen = {},
    capturedParts = {},
}
environment[RUNTIME_KEY] = runtime

-- ============================================================
-- HELPERS
-- ============================================================
local function disconnect(conn)
    if conn then pcall(function() conn:Disconnect() end) end
end

local function connect(signal, callback)
    local c = signal:Connect(callback)
    table.insert(runtime.connections, c)
    return c
end

local function new(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    if parent then obj.Parent = parent end
    return obj
end

local function corner(parent, radius)
    return new("UICorner", {
        CornerRadius = typeof(radius) == "UDim" and radius or UDim.new(0, radius),
    }, parent)
end

local function stroke(parent, color, transparency, thickness)
    return new("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = color,
        Transparency = transparency or 0,
        Thickness = thickness or 1,
    }, parent)
end

-- ============================================================
-- BACKGROUND PADRÃO
-- ============================================================
local BG_IMAGE = "rbxassetid://70418952815837"
local BG_BASE_COLOR = Color3.fromRGB(15, 10, 25)

local function applyBackground(parent, cornerRadius)
    local bgFrame = new("Frame", {
        Name = parent.Name .. "Background",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = BG_BASE_COLOR,
        BorderSizePixel = 0,
        ZIndex = 0,
    }, parent)
    corner(bgFrame, cornerRadius)

    new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(25, 10, 40)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(15, 8, 25)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(30, 12, 45)),
        }),
        Rotation = 45,
    }, bgFrame)

    local bgImage = new("ImageLabel", {
        Name = parent.Name .. "BackgroundImage",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = BG_IMAGE,
        ImageTransparency = 0.3,
        ScaleType = Enum.ScaleType.Stretch,
        ZIndex = 1,
    }, bgFrame)
    corner(bgImage, cornerRadius)

    return bgFrame, bgImage
end

-- ============================================================
-- HEAD DISPLAY
-- ============================================================
local function createHeadDisplay()
    local char = LP.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local old = head:FindFirstChild("WeeklyCodeSniperHeadDisplay")
    if old then old:Destroy() end

    local billboard = new("BillboardGui", {
        Name = "WeeklyCodeSniperHeadDisplay",
        Adornee = head,
        Size = UDim2.new(0, 200, 0, 30),
        StudsOffset = Vector3.new(0, 2.5, 0),
        MaxDistance = 100,
        AlwaysOnTop = true,
    }, head)

    new("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "this code sniper deobf full by 073 992 discord.gg/9ybcc9bM63",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextScaled = true,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
    }, billboard)

    runtime.headDisplay = billboard
end

-- ============================================================
-- GUI DETECTION
-- ============================================================
local function isOurGui(instance)
    local p = instance
    for _ = 1, 10 do
        if not p then break end
        if p.Name == "WeeklyCodeSniperUI" or p.Name == "WeeklySettingsUI" then return true end
        p = p.Parent
    end
    return false
end

local function isVisibleChain(inst)
    local current = inst
    while current do
        if current:IsA("GuiObject") and not current.Visible then return false end
        if current:IsA("ScreenGui") then return current.Enabled end
        current = current.Parent
    end
    return true
end

local function findAllTextBoxes(pg)
    local boxes = {}
    for _, gui in ipairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled and not isOurGui(gui) then
            for _, d in ipairs(gui:GetDescendants()) do
                if d:IsA("TextBox") and not isOurGui(d) then
                    boxes[#boxes+1] = d
                end
            end
        end
    end
    return boxes
end

local function findCodeBox()
    local pg = playerGui
    if not pg then return nil end
    local allBoxes = findAllTextBoxes(pg)
    for _, box in ipairs(allBoxes) do
        if isVisibleChain(box) then
            local n  = box.Name:lower()
            local pn = (box.Parent and box.Parent.Name or ""):lower()
            if n:find("code") or pn:find("code") or n:find("redeem") or pn:find("redeem") or n:find("input") or n:find("enter") then
                return box
            end
        end
    end
    for _, box in ipairs(allBoxes) do
        if isVisibleChain(box) then return box end
    end
    return nil
end

local function findSubmitButton(box)
    local pg = playerGui
    if not pg then return nil end

    local searchNames = {"submit","redeem","claim","confirm","enter","send","apply","ok","use","go","check"}

    if box then
        local p = box.Parent
        for _ = 1, 6 do
            if not p then break end
            for _, d in ipairs(p:GetDescendants()) do
                if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) and d ~= box then
                    local n = d.Name:lower()
                    local txt = ""
                    pcall(function() txt = d.Text:lower() end)
                    for _, sn in ipairs(searchNames) do
                        if (n:find(sn) or txt:find(sn)) and isVisibleChain(d) then
                            return d
                        end
                    end
                end
            end
            p = p.Parent
        end
    end

    local btns = {}
    for _, gui in ipairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled and not isOurGui(gui) then
            for _, d in ipairs(gui:GetDescendants()) do
                if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
                    local n = d.Name:lower()
                    local txt = ""
                    pcall(function() txt = d.Text:lower() end)
                    for _, sn in ipairs(searchNames) do
                        if (n:find(sn) or txt:find(sn)) and isVisibleChain(d) then
                            table.insert(btns, d)
                            break
                        end
                    end
                end
            end
        end
    end
    return btns[1]
end

local _dbg = rawget(_G, "debug")
local getupvalues = (getupvalues) or (_dbg and _dbg.getupvalues) or (_dbg and _dbg.getupvalue)
local getconns    = (getconnections) or (_dbg and _dbg.getconnections)
local setupv      = (setupvalue) or (_dbg and _dbg.setupvalue)

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
            local ok2, cs2 = pcall(getconns, btn.Activated)
            if ok2 and type(cs2) == "table" then
                for _, c in ipairs(cs2) do pcall(function() c:Fire() end) end
            end
        end)
    end
    if typeof(fireclick) == "function" then
        table.insert(methods, function() fireclick(btn) end)
    end
    for _, fn in ipairs(methods) do
        local ok = pcall(fn)
        anyOk = anyOk or ok
    end
    return anyOk
end

local function fireBoxFocusLost(box)
    if not box then return false end
    local anyFired = false
    if typeof(firesignal) == "function" then
        anyFired = anyFired or pcall(firesignal, box.FocusLost, true)
    end
    if typeof(getconns) == "function" then
        local ok, cs = pcall(getconns, box.FocusLost)
        if ok and type(cs) == "table" then
            for _, c in ipairs(cs) do
                local fn
                pcall(function() fn = c.Function end)
                if fn and typeof(getupvalues) == "function" and typeof(setupv) == "function" then
                    local uOk, ups = pcall(getupvalues, fn)
                    if uOk and type(ups) == "table" then
                        for i, v in pairs(ups) do
                            if type(v) == "boolean" and v == true then
                                pcall(setupv, fn, i, false)
                            end
                        end
                    end
                end
                local fOk = pcall(function()
                    if c.Enabled ~= false then c:Fire(true) end
                end)
                anyFired = anyFired or fOk
            end
        end
    end
    return anyFired
end

-- ============================================================
-- REDEEM
-- ============================================================
local function redeemCode(code)
    if not code or code == "" then return false, "no code" end

    local box = findCodeBox()
    if not box then return false, "no code box" end

    pcall(function() box.Text = code end)

    local submitBtn = findSubmitButton(box)
    if not submitBtn then
        fireBoxFocusLost(box)
        return false, "no submit button"
    end

    -- UN SEUL clic ici. C'est startSpamRedeem qui gère la boucle.
    clickButton(submitBtn)
    fireBoxFocusLost(box)
    return true, "submitted"
end

local function startSpamRedeem(code)
    if runtime.spamLoopActive then return end
    runtime.spamLoopActive = true

    local count = math.clamp(runtime.spamCount, 1, 100)
    local success = 0

    consoleLog(string.format(
        "<font color='rgb(105,190,132)'>Spamming %d vezes...</font>",
        count
    ))

    task.spawn(function()
        for i = 1, count do
            if not runtime.alive or not runtime.spamLoopActive then break end
            local ok = redeemCode(code)
            if ok then success = success + 1 end
            if i % 5 == 0 or i == count then
                consoleLog(string.format(
                    "<font color='rgb(105,190,132)'>Spam %d/%d</font> <font color='rgb(150,150,150)'>(%d ok)</font>",
                    i, count, success
                ))
            end
            task.wait(0.0001)
        end
        consoleLog(string.format(
            "<font color='rgb(105,190,132)'>Spam finalizado: %d/%d</font>",
            success, count
        ))
        runtime.spamLoopActive = false
    end)
end

-- ============================================================
-- NOTIFICATION LISTENER (Submit After funcional)
-- ============================================================
local function resolveNotifyRemote()
    if runtime.notifyRemote and runtime.notifyRemote.Parent then
        return runtime.notifyRemote
    end
    local candidates = {}
    pcall(function()
        for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
            if d:IsA("RemoteEvent") then
                local n = d.Name:lower()
                if n:find("notif") or n:find("announce") or n:find("broadcast")
                or n:find("global") or n:find("message") or n:find("chat") then
                    table.insert(candidates, d)
                end
            end
        end
    end)
    if #candidates > 0 then
        runtime.notifyRemote = candidates[1]
        return candidates[1]
    end
    return nil
end

local function stripRich(text)
    if type(text) ~= "string" then return tostring(text) end
    return (text:gsub("<[^>]->", ""))
end

local function tokenize(text)
    local words = {}
    for word in text:gmatch("[%w_]+") do
        words[#words + 1] = word
    end
    return words
end

local function onAnnouncement(...)
    if not runtime.enabled then return end

    local text = stripRich(tostring((...) or ""))
    text = text:match("^%s*(.-)%s*$") or ""
    if text == "" then return end
    if text:find("%s") then return end

    if runtime.seen[text] then return end
    runtime.seen[text] = true
    task.delay(1.25, function() runtime.seen[text] = nil end)

    for _, word in ipairs(tokenize(text)) do
        table.insert(runtime.capturedParts, word)
    end

    local capturedCount = #runtime.capturedParts
    local joined = table.concat(runtime.capturedParts)

    consoleLog(string.format(
        "<font color='rgb(105,190,132)'>Captured %d/%d</font> <font color='rgb(150,150,150)'>[%s]</font>",
        capturedCount,
        runtime.submitAfter,
        joined
    ))

    if capturedCount >= runtime.submitAfter then
        runtime.lastCode = joined
        runtime.capturedParts = {}

        consoleLog("<font color='rgb(105,190,132)'>Submitting: " .. joined .. "</font>")

        if runtime.autoSubmit then
            task.spawn(function()
                local ok, err = redeemCode(joined)
                if ok then
                    consoleLog("<font color='rgb(105,190,132)'>Redeemed: " .. joined .. "</font>")
                else
                    consoleLog("<font color='rgb(150,150,150)'>Failed: " .. tostring(err) .. "</font>")
                end
            end)
        end
    end
end

local function startNotifListener()
    if runtime.notifConn then return end
    local remote = resolveNotifyRemote()
    if remote then
        runtime.notifConn = remote.OnClientEvent:Connect(function(...)
            pcall(onAnnouncement, ...)
        end)
    end
end

local function stopNotifListener()
    if runtime.notifConn then
        disconnect(runtime.notifConn)
        runtime.notifConn = nil
    end
end

-- ============================================================
-- MAIN UI
-- ============================================================
local parentGui = (gethui and gethui()) or CoreGui
local oldGui = parentGui:FindFirstChild("WeeklyCodeSniperUI")
if oldGui then oldGui:Destroy() end

local ScreenGui = new("ScreenGui", {
    Name = "WeeklyCodeSniperUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 999,
}, parentGui)
runtime.gui = ScreenGui

local Window = new("Frame", {
    Name = "Window",
    Size = UDim2.new(0, 270, 0, 400),
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -8, 0, 8),
    BackgroundColor3 = BG_BASE_COLOR,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Active = true,
}, ScreenGui)
corner(Window, 14)
new("UIScale", { Name = "InterfaceScale", Scale = 0.92 }, Window)
applyBackground(Window, 14)

-- Header
local Header = new("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 56),
    BackgroundTransparency = 1,
    Active = true,
    ZIndex = 3,
}, Window)

local Avatar = new("ImageLabel", {
    Name = "AvatarImage",
    Size = UDim2.new(0, 32, 0, 32),
    Position = UDim2.new(0, 8, 0, 12),
    BackgroundTransparency = 1,
    ZIndex = 3,
}, Header)
corner(Avatar, 16)

new("TextLabel", {
    Name = "Title",
    Size = UDim2.new(0, 140, 0, 30),
    Position = UDim2.new(0, 46, 0, 8),
    BackgroundTransparency = 1,
    Text = "Weekly Code Sniper",
    TextSize = 16,
    TextColor3 = Color3.fromRGB(180, 180, 190),
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBold,
    ZIndex = 3,
}, Header)

local KeybindsBtn = new("TextButton", {
    Name = "KeybindsButton",
    Size = UDim2.new(0, 62, 0, 24),
    Position = UDim2.new(1, -95, 0, 16),
    BackgroundColor3 = Color3.fromRGB(26, 26, 32),
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "Keybinds",
    TextSize = 11,
    TextColor3 = Color3.fromRGB(200, 200, 210),
    Font = Enum.Font.GothamBold,
    ZIndex = 5,
}, Header)
corner(KeybindsBtn, 6)
stroke(KeybindsBtn, Color3.fromRGB(85, 85, 95), 0.4)

local MinimizeBtn = new("TextButton", {
    Name = "MinimizeBtn",
    Size = UDim2.new(0, 20, 0, 24),
    Position = UDim2.new(1, -26, 0, 16),
    BackgroundColor3 = Color3.fromRGB(26, 26, 32),
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "-",
    TextSize = 16,
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    ZIndex = 5,
}, Header)
corner(MinimizeBtn, 6)
stroke(MinimizeBtn, Color3.fromRGB(85, 85, 95), 0.4)

-- Console
local Console = new("ScrollingFrame", {
    Name = "Console",
    Size = UDim2.new(1, -20, 0, 42),
    Position = UDim2.new(0, 10, 0, 64),
    BackgroundColor3 = Color3.fromRGB(5, 5, 7),
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Active = true,
    ScrollingEnabled = true,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
    VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.None,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Color3.fromRGB(120, 120, 140),
    ZIndex = 3,
}, Window)
corner(Console, 9)
stroke(Console, Color3.fromRGB(60, 60, 70), 0.3)

local ConsoleOutput = new("TextLabel", {
    Name = "ConsoleOutput",
    Size = UDim2.new(1, -18, 0, 90),
    AutomaticSize = Enum.AutomaticSize.Y,
    Position = UDim2.new(0, 9, 0, 4),
    BackgroundTransparency = 1,
    RichText = true,
    Text = "<font color='rgb(105,190,132)'>Sniping for codes</font>",
    TextSize = 13,
    Font = Enum.Font.GothamMedium,
    TextColor3 = Color3.fromRGB(120, 120, 140),
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    ZIndex = 4,
}, Console)

local function updateConsoleCanvas()
    local size = ConsoleOutput.AbsoluteSize
    if size then Console.CanvasSize = UDim2.new(0, 0, 0, size.Y + 8) end
end

local function scrollConsoleToBottom()
    updateConsoleCanvas()
    task.defer(function()
        local canvas = Console.AbsoluteCanvasSize
        if canvas then
            Console.CanvasPosition = Vector2.new(0, math.max(0, canvas.Y - Console.AbsoluteWindowSize.Y))
        end
    end)
end

function consoleLog(text)
    ConsoleOutput.Text = text
    scrollConsoleToBottom()
end

connect(ConsoleOutput:GetPropertyChangedSignal("Text"), function()
    updateConsoleCanvas()
    scrollConsoleToBottom()
end)
connect(Console:GetPropertyChangedSignal("AbsoluteWindowSize"), updateConsoleCanvas)
task.defer(updateConsoleCanvas)

-- Buttons
local ButtonFrame = new("Frame", {
    Name = "ButtonFrame",
    Size = UDim2.new(1, -20, 0, 34),
    Position = UDim2.new(0, 10, 0, 110),
    BackgroundTransparency = 1,
    ZIndex = 3,
}, Window)

local ClearLogsBtn = new("TextButton", {
    Name = "ClearLogsBtn",
    Size = UDim2.new(0, 78, 0, 26),
    Position = UDim2.new(0, 0, 0, 4),
    BackgroundColor3 = Color3.fromRGB(26, 26, 32),
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "Clear",
    TextSize = 12,
    TextColor3 = Color3.fromRGB(200, 200, 210),
    Font = Enum.Font.GothamBold,
    ZIndex = 3,
}, ButtonFrame)
corner(ClearLogsBtn, 6)
stroke(ClearLogsBtn, Color3.fromRGB(85, 85, 95), 0.5)

local RedeemBtn = new("TextButton", {
    Name = "RedeemBtn",
    Size = UDim2.new(0, 78, 0, 26),
    Position = UDim2.new(0.5, -39, 0, 4),
    BackgroundColor3 = Color3.fromRGB(180, 180, 190),
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "Redeem",
    TextSize = 12,
    TextColor3 = Color3.fromRGB(8, 8, 10),
    Font = Enum.Font.GothamBold,
    ZIndex = 3,
}, ButtonFrame)
corner(RedeemBtn, 6)
stroke(RedeemBtn, Color3.new(1, 1, 1), 0.3)

local CopyCodeBtn = new("TextButton", {
    Name = "CopyCodeBtn",
    Size = UDim2.new(0, 78, 0, 26),
    Position = UDim2.new(1, -78, 0, 4),
    BackgroundColor3 = Color3.fromRGB(26, 26, 32),
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "Copy",
    TextSize = 12,
    TextColor3 = Color3.fromRGB(200, 200, 210),
    Font = Enum.Font.GothamBold,
    ZIndex = 3,
}, ButtonFrame)
corner(CopyCodeBtn, 6)
stroke(CopyCodeBtn, Color3.fromRGB(85, 85, 95), 0.5)

-- Main Section
local MainSection = new("Frame", {
    Name = "MainSection",
    Size = UDim2.new(1, -20, 0, 118),
    Position = UDim2.new(0, 10, 0, 148),
    BackgroundColor3 = Color3.fromRGB(15, 15, 18),
    BackgroundTransparency = 0.35,
    BorderSizePixel = 0,
    ZIndex = 3,
}, Window)
corner(MainSection, 8)
stroke(MainSection, Color3.fromRGB(60, 60, 70), 0.5)

new("TextLabel", {
    Name = "SectionTitle",
    Size = UDim2.new(1, -12, 0, 16),
    Position = UDim2.new(0, 10, 0, 2),
    BackgroundTransparency = 1,
    Text = "Main",
    TextSize = 12,
    TextColor3 = Color3.fromRGB(160, 160, 175),
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
}, MainSection)

local function makeRow(parent, order, label, valueText)
    local row = new("Frame", {
        Name = label:gsub("%s+", "") .. "Row",
        Size = UDim2.new(1, -12, 0, 22),
        Position = UDim2.new(0, 6, 0, 20 + (order * 22)),
        BackgroundTransparency = 1,
        ZIndex = 4,
    }, parent)

    new("TextLabel", {
        Size = UDim2.new(0, 130, 0, 22),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(200, 200, 210),
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
    }, row)

    local btn = new("TextButton", {
        Name = label:gsub("%s+", "") .. "Btn",
        Size = UDim2.new(0, 48, 0, 20),
        Position = UDim2.new(1, -54, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(26, 26, 32),
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = valueText,
        TextSize = 10,
        TextColor3 = Color3.fromRGB(200, 200, 210),
        Font = Enum.Font.GothamBold,
        ZIndex = 5,
    }, row)
    corner(btn, 5)
    stroke(btn, Color3.fromRGB(85, 85, 95), 0.5)

    return row, btn
end

local SnipeRow, SnipeBtn = makeRow(MainSection, 0, "Snipe", "OFF")
local AutoSubmitRow, AutoSubmitBtn = makeRow(MainSection, 1, "Auto submit", "OFF")

-- Submit after
local SubmitRow = new("Frame", {
    Size = UDim2.new(1, -12, 0, 22),
    Position = UDim2.new(0, 6, 0, 64),
    BackgroundTransparency = 1,
    ZIndex = 4,
}, MainSection)

new("TextLabel", {
    Size = UDim2.new(0, 130, 0, 22),
    Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1,
    Text = "Submit after",
    TextSize = 12,
    TextColor3 = Color3.fromRGB(200, 200, 210),
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
}, SubmitRow)

local Counter = new("Frame", {
    Name = "Counter",
    Size = UDim2.new(0, 86, 0, 20),
    Position = UDim2.new(1, -92, 0.5, -10),
    BackgroundColor3 = Color3.fromRGB(26, 26, 32),
    BackgroundTransparency = 0.05,
    BorderSizePixel = 0,
    ZIndex = 4,
}, SubmitRow)
corner(Counter, 5)
stroke(Counter, Color3.fromRGB(85, 85, 95), 0.4)

local MinusBtn = new("TextButton", {
    Name = "Minus",
    Size = UDim2.new(0, 20, 0, 18),
    Position = UDim2.new(0, 2, 0, 1),
    BackgroundColor3 = Color3.fromRGB(40, 40, 48),
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "-",
    TextSize = 14,
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    ZIndex = 5,
}, Counter)
corner(MinusBtn, 4)

local CountLabel = new("TextLabel", {
    Name = "Count",
    Size = UDim2.new(0, 24, 0, 18),
    Position = UDim2.new(0, 31, 0, 1),
    BackgroundTransparency = 1,
    Text = "1",
    TextSize = 12,
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    ZIndex = 5,
}, Counter)

local PlusBtn = new("TextButton", {
    Name = "Plus",
    Size = UDim2.new(0, 20, 0, 18),
    Position = UDim2.new(0, 64, 0, 1),
    BackgroundColor3 = Color3.fromRGB(40, 40, 48),
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "+",
    TextSize = 14,
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    ZIndex = 5,
}, Counter)
corner(PlusBtn, 4)

-- Spam redeem
local SpamRow = new("Frame", {
    Size = UDim2.new(1, -12, 0, 22),
    Position = UDim2.new(0, 6, 0, 86),
    BackgroundTransparency = 1,
    ZIndex = 4,
}, MainSection)

new("TextLabel", {
    Size = UDim2.new(0, 130, 0, 22),
    Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1,
    Text = "Spam redeem",
    TextSize = 12,
    TextColor3 = Color3.fromRGB(200, 200, 210),
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
}, SpamRow)

local SpamCounter = new("Frame", {
    Name = "SpamCounter",
    Size = UDim2.new(0, 86, 0, 20),
    Position = UDim2.new(1, -92, 0.5, -10),
    BackgroundColor3 = Color3.fromRGB(26, 26, 32),
    BackgroundTransparency = 0.05,
    BorderSizePixel = 0,
    ZIndex = 4,
}, SpamRow)
corner(SpamCounter, 5)
stroke(SpamCounter, Color3.fromRGB(85, 85, 95), 0.4)

local SpamMinus = new("TextButton", {
    Name = "SpamMinus",
    Size = UDim2.new(0, 20, 0, 18),
    Position = UDim2.new(0, 2, 0, 1),
    BackgroundColor3 = Color3.fromRGB(40, 40, 48),
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "-",
    TextSize = 14,
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    ZIndex = 5,
}, SpamCounter)
corner(SpamMinus, 4)

local SpamBox = new("TextBox", {
    Name = "SpamBox",
    Size = UDim2.new(0, 38, 0, 18),
    Position = UDim2.new(0, 24, 0, 1),
    BackgroundTransparency = 1,
    Text = "20",
    TextSize = 12,
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Center,
    ClearTextOnFocus = false,
    ZIndex = 5,
}, SpamCounter)

local SpamPlus = new("TextButton", {
    Name = "SpamPlus",
    Size = UDim2.new(0, 20, 0, 18),
    Position = UDim2.new(0, 64, 0, 1),
    BackgroundColor3 = Color3.fromRGB(40, 40, 48),
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "+",
    TextSize = 14,
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    ZIndex = 5,
}, SpamCounter)
corner(SpamPlus, 4)

-- AA Helper
local AAHelper = new("Frame", {
    Name = "AAHelperSection",
    Size = UDim2.new(1, -20, 0, 118),
    Position = UDim2.new(0, 10, 0, 272),
    BackgroundColor3 = Color3.fromRGB(15, 15, 18),
    BackgroundTransparency = 0.35,
    BorderSizePixel = 0,
    ZIndex = 3,
}, Window)
corner(AAHelper, 8)
stroke(AAHelper, Color3.fromRGB(60, 60, 70), 0.5)

new("TextLabel", {
    Name = "SectionTitle",
    Size = UDim2.new(1, -12, 0, 16),
    Position = UDim2.new(0, 10, 0, 2),
    BackgroundTransparency = 1,
    Text = "AA Helper",
    TextSize = 12,
    TextColor3 = Color3.fromRGB(160, 160, 175),
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
}, AAHelper)

local AAButtons = {}
local aaFeatures = {
    { name = "Anti Ragdoll", key = "antiRagdoll" },
    { name = "Auto Buy", key = "autoBuy" },
    { name = "Anti Lag", key = "antiLag" },
    { name = "Remove Accessories", key = "removeAccessories" },
}

for i, feat in ipairs(aaFeatures) do
    local row = new("Frame", {
        Size = UDim2.new(1, -12, 0, 22),
        Position = UDim2.new(0, 6, 0, 20 + ((i - 1) * 22)),
        BackgroundTransparency = 1,
        ZIndex = 4,
    }, AAHelper)

    new("TextLabel", {
        Size = UDim2.new(0, 160, 0, 22),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = feat.name,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(200, 200, 210),
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
    }, row)

    local btn = new("TextButton", {
        Name = feat.name:gsub("%s+", "") .. "Btn",
        Size = UDim2.new(0, 48, 0, 20),
        Position = UDim2.new(1, -54, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(26, 26, 32),
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "OFF",
        TextSize = 10,
        TextColor3 = Color3.fromRGB(120, 120, 140),
        Font = Enum.Font.GothamBold,
        ZIndex = 5,
    }, row)
    corner(btn, 5)
    stroke(btn, Color3.fromRGB(85, 85, 95), 0.5)

    AAButtons[feat.key] = btn
end

-- ============================================================
-- KEYBINDS WINDOW
-- ============================================================
local keybindsBtnRef = nil

local function createKeybindsWindow()
    local old = parentGui:FindFirstChild("WeeklySettingsUI")
    if old then old:Destroy() end

    local SG = new("ScreenGui", {
        Name = "WeeklySettingsUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 998,
    }, parentGui)
    runtime.settingsGui = SG

    local win = new("Frame", {
        Name = "SettingsWindow",
        Size = UDim2.new(0, 220, 0, 90),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = BG_BASE_COLOR,
        BorderSizePixel = 0,
        Active = true,
        ClipsDescendants = true,
    }, SG)
    corner(win, 10)
    applyBackground(win, 10)
    stroke(win, Color3.fromRGB(60, 60, 70), 0.3)

    new("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -20, 0, 22),
        Position = UDim2.new(0, 10, 0, 6),
        BackgroundTransparency = 1,
        Text = "Keybinds",
        TextSize = 12,
        TextColor3 = Color3.fromRGB(200, 200, 210),
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 2,
    }, win)

    local closeBtn = new("TextButton", {
        Name = "CloseBtn",
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -28, 0, 4),
        BackgroundTransparency = 1,
        Text = "X",
        TextSize = 12,
        TextColor3 = Color3.fromRGB(180, 180, 190),
        Font = Enum.Font.GothamBold,
        ZIndex = 2,
    }, win)

    connect(closeBtn.MouseButton1Click, function()
        if SG then SG:Destroy() end
        runtime.settingsGui = nil
    end)

    local row = new("Frame", {
        Size = UDim2.new(1, -20, 0, 22),
        Position = UDim2.new(0, 10, 0, 36),
        BackgroundTransparency = 1,
        ZIndex = 2,
    }, win)

    new("TextLabel", {
        Size = UDim2.new(0, 120, 0, 22),
        Position = UDim2.new(0, 6, 0, 0),
        BackgroundTransparency = 1,
        Text = "Snipe Key",
        TextSize = 11,
        TextColor3 = Color3.fromRGB(160, 160, 175),
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 2,
    }, row)

    local keyBtn = new("TextButton", {
        Size = UDim2.new(0, 44, 0, 20),
        Position = UDim2.new(1, -50, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(26, 26, 32),
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = runtime.snipeKey.Name,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(200, 200, 210),
        Font = Enum.Font.GothamBold,
        ZIndex = 3,
    }, row)
    corner(keyBtn, 5)
    stroke(keyBtn, Color3.fromRGB(85, 85, 95), 0.5)

    connect(keyBtn.MouseButton1Click, function()
        runtime.listeningKey = true
        keyBtn.Text = "..."
    end)

    local dragging2, dragStart2, startPos2
    connect(win.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging2 = true
            dragStart2 = input.Position
            startPos2 = win.Position
        end
    end)
    connect(UserInputService.InputChanged, function(input)
        if dragging2 and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart2
            win.Position = UDim2.new(
                startPos2.X.Scale, startPos2.X.Offset + delta.X,
                startPos2.Y.Scale, startPos2.Y.Offset + delta.Y
            )
        end
    end)
    connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging2 = false
        end
    end)

    return keyBtn
end

-- ============================================================
-- TOGGLE HELPER
-- ============================================================
local function setToggleVisual(btn, on)
    btn.Text = on and "ON" or "OFF"
    btn.TextColor3 = on and Color3.fromRGB(105, 190, 132) or Color3.fromRGB(120, 120, 140)
    btn.BackgroundColor3 = on and Color3.fromRGB(30, 50, 35) or Color3.fromRGB(26, 26, 32)
end

-- ============================================================
-- LÓGICAS
-- ============================================================
local snipeConn = nil
local function startSnipe()
    if snipeConn then return end
    startNotifListener()
    snipeConn = RunService.Heartbeat:Connect(function()
        if not runtime.alive or not runtime.enabled then return end
    end)
end

local function stopSnipe()
    disconnect(snipeConn)
    snipeConn = nil
    stopNotifListener()
end

local antiRagdollConn = nil
local function startAntiRagdoll()
    if antiRagdollConn then return end
    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not runtime.antiRagdoll then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                if hum:GetState() == Enum.HumanoidStateType.Physics then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end)
        end
    end)
end

local autoBuyConn = nil
local function startAutoBuy()
    if autoBuyConn then return end
    autoBuyConn = RunService.Heartbeat:Connect(function()
        if not runtime.autoBuy then return end
    end)
end

local antiLagOriginal = nil
local function startAntiLag()
    if antiLagOriginal then return end
    pcall(function()
        antiLagOriginal = {
            QualityLevel = settings().Rendering.QualityLevel,
            GlobalShadows = Lighting.GlobalShadows,
        }
    end)
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.GlobalShadows = false
    end)
    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("BasePart") then
            pcall(function()
                d.Material = Enum.Material.Plastic
                d.Reflectance = 0
                d.CastShadow = false
            end)
        end
    end
end

local function stopAntiLag()
    if not antiLagOriginal then return end
    pcall(function()
        settings().Rendering.QualityLevel = antiLagOriginal.QualityLevel
        Lighting.GlobalShadows = antiLagOriginal.GlobalShadows
    end)
    antiLagOriginal = nil
end

local function removeAccessoriesNow()
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        if char then
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("Accessory") or d:IsA("Hat") then
                    pcall(function() d:Destroy() end)
                end
            end
        end
    end
end

-- ============================================================
-- BOTÕES
-- ============================================================
connect(SnipeBtn.MouseButton1Click, function()
    runtime.enabled = not runtime.enabled
    setToggleVisual(SnipeBtn, runtime.enabled)
    if runtime.enabled then startSnipe() else stopSnipe() end
end)

connect(AutoSubmitBtn.MouseButton1Click, function()
    runtime.autoSubmit = not runtime.autoSubmit
    setToggleVisual(AutoSubmitBtn, runtime.autoSubmit)
end)

connect(MinusBtn.MouseButton1Click, function()
    runtime.submitAfter = math.clamp(runtime.submitAfter - 1, 1, 10)
    CountLabel.Text = tostring(runtime.submitAfter)
    runtime.capturedParts = {}
end)

connect(PlusBtn.MouseButton1Click, function()
    runtime.submitAfter = math.clamp(runtime.submitAfter + 1, 1, 10)
    CountLabel.Text = tostring(runtime.submitAfter)
    runtime.capturedParts = {}
end)

connect(SpamMinus.MouseButton1Click, function()
    runtime.spamCount = math.clamp(runtime.spamCount - 1, 1, 100)
    SpamBox.Text = tostring(runtime.spamCount)
end)

connect(SpamPlus.MouseButton1Click, function()
    runtime.spamCount = math.clamp(runtime.spamCount + 1, 1, 100)
    SpamBox.Text = tostring(runtime.spamCount)
end)

connect(SpamBox.FocusLost, function()
    local n = tonumber(SpamBox.Text)
    if n then runtime.spamCount = math.clamp(math.floor(n), 1, 100) end
    SpamBox.Text = tostring(runtime.spamCount)
end)

connect(ClearLogsBtn.MouseButton1Click, function()
    consoleLog("")
end)

connect(RedeemBtn.MouseButton1Click, function()
    local code = runtime.lastCode
    if (not code or code == "") and #runtime.capturedParts > 0 then
        code = table.concat(runtime.capturedParts)
    end
    if code and code ~= "" then
        runtime.lastCode = code
        startSpamRedeem(code)
    else
        consoleLog("<font color='rgb(150,150,150)'>No code to redeem</font>")
    end
end)

connect(CopyCodeBtn.MouseButton1Click, function()
    local code = runtime.lastCode
    if (not code or code == "") and #runtime.capturedParts > 0 then
        code = table.concat(runtime.capturedParts)
    end
    if code and code ~= "" then
        if setclipboard then pcall(setclipboard, code)
        elseif toclipboard then pcall(toclipboard, code) end
        consoleLog("<font color='rgb(105,190,132)'>Copied: " .. code .. "</font>")
    else
        consoleLog("<font color='rgb(150,150,150)'>No code to copy</font>")
    end
end)

-- AA Helper
connect(AAButtons.antiRagdoll.MouseButton1Click, function()
    runtime.antiRagdoll = not runtime.antiRagdoll
    setToggleVisual(AAButtons.antiRagdoll, runtime.antiRagdoll)
    if runtime.antiRagdoll then
        startAntiRagdoll()
    else
        disconnect(antiRagdollConn)
        antiRagdollConn = nil
    end
end)

connect(AAButtons.autoBuy.MouseButton1Click, function()
    runtime.autoBuy = not runtime.autoBuy
    setToggleVisual(AAButtons.autoBuy, runtime.autoBuy)
    if runtime.autoBuy then
        startAutoBuy()
    else
        disconnect(autoBuyConn)
        autoBuyConn = nil
    end
end)

connect(AAButtons.antiLag.MouseButton1Click, function()
    runtime.antiLag = not runtime.antiLag
    setToggleVisual(AAButtons.antiLag, runtime.antiLag)
    if runtime.antiLag then startAntiLag() else stopAntiLag() end
end)

connect(AAButtons.removeAccessories.MouseButton1Click, function()
    runtime.removeAccessories = not runtime.removeAccessories
    setToggleVisual(AAButtons.removeAccessories, runtime.removeAccessories)
    if runtime.removeAccessories then removeAccessoriesNow() end
end)

-- ============================================================
-- KEYBINDS / MINIMIZE / DRAG
-- ============================================================
connect(KeybindsBtn.MouseButton1Click, function()
    keybindsBtnRef = createKeybindsWindow()
end)

local minimized = false
connect(MinimizeBtn.MouseButton1Click, function()
    minimized = not minimized
    Window.Size = minimized and UDim2.new(0, 270, 0, 56) or UDim2.new(0, 270, 0, 400)
    MinimizeBtn.Text = minimized and "+" or "-"
end)

local dragging, dragStart, startPos
connect(Header.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Window.Position
    end
end)

connect(UserInputService.InputChanged, function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Window.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

connect(UserInputService.InputEnded, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Keybind global
connect(UserInputService.InputBegan, function(input, gpe)
    if gpe then return end
    if runtime.listeningKey then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            runtime.snipeKey = input.KeyCode
            runtime.listeningKey = false
            if keybindsBtnRef then keybindsBtnRef.Text = input.KeyCode.Name end
        end
        return
    end
    if input.KeyCode == runtime.snipeKey then
        runtime.enabled = not runtime.enabled
        setToggleVisual(SnipeBtn, runtime.enabled)
        if runtime.enabled then startSnipe() else stopSnipe() end
    end
end)

-- ============================================================
-- CHARACTER
-- ============================================================
connect(LP.CharacterAdded, function()
    task.wait(1)
    createHeadDisplay()
end)

task.spawn(function()
    task.wait(0.5)
    createHeadDisplay()
end)

connect(Players.PlayerAdded, function(plr)
    plr.CharacterAdded:Connect(function(char)
        if runtime.removeAccessories then
            task.wait(1)
            removeAccessoriesNow()
        end
    end)
end)

-- ============================================================
-- DESTROY
-- ============================================================
function runtime.destroy()
    runtime.alive = false
    runtime.enabled = false
    runtime.spamLoopActive = false

    stopSnipe()
    disconnect(antiRagdollConn)
    disconnect(autoBuyConn)
    stopAntiLag()

    for _, c in ipairs(runtime.connections) do
        disconnect(c)
    end
    table.clear(runtime.connections)

    if runtime.gui then pcall(function() runtime.gui:Destroy() end) runtime.gui = nil end
    if runtime.settingsGui then pcall(function() runtime.settingsGui:Destroy() end) runtime.settingsGui = nil end
    if runtime.headDisplay then pcall(function() runtime.headDisplay:Destroy() end) runtime.headDisplay = nil end

    if environment[RUNTIME_KEY] == runtime then
        environment[RUNTIME_KEY] = nil
    end
end

-- ============================================================
-- API
-- ============================================================
_G.WeeklyCodeSniper = {
    Toggle = function()
        runtime.enabled = not runtime.enabled
        setToggleVisual(SnipeBtn, runtime.enabled)
    end,
    SetKey = function(k) runtime.snipeKey = k end,
    SetCode = function(c) runtime.lastCode = c end,
    SetSpam = function(n) runtime.spamCount = math.clamp(n, 1, 100) SpamBox.Text = tostring(runtime.spamCount) end,
    Redeem = function() if runtime.lastCode then startSpamRedeem(runtime.lastCode) end end,
    Destroy = runtime.destroy,
}

print("[Weekly Code Sniper] Carregado. Keybind:", runtime.snipeKey.Name)
print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")
print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")
print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")
print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")
print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")
print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")
print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")
print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")
print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")
print("no source stealer please, this script genv by 992 deobf discord.gg/9ybcc9bM63 No remove watermark please!!! DEOBF BY 073!!!")
