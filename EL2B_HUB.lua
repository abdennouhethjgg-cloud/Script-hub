local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting          = game:GetService("Lighting")
local Debris            = game:GetService("Debris")

local player    = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local camera    = workspace.CurrentCamera
local LOGO_ID   = "rbxassetid://88206773600496"

do
    local old = PlayerGui:FindFirstChild("INFIN_AA")
    if old then old:Destroy() end
end

-- helpers
local function new(class, props)
    local o = Instance.new(class)
    local parent
    for k, v in pairs(props or {}) do
        if k == "Parent" then parent = v else o[k] = v end
    end
    if parent then o.Parent = parent end
    return o
end
local function corner(o, r) new("UICorner", { CornerRadius = UDim.new(0, r), Parent = o }) return o end
local function round(o) new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = o }) return o end
local function stroke(o, c, t, tr)
    return new("UIStroke", { Color = c, Thickness = t or 1, Transparency = tr or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = o })
end
local function tween(o, t, props, style, dir)
    local tw = TweenService:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end
local C = {
    glass  = Color3.fromRGB(14, 13, 24),
    tile   = Color3.fromRGB(30, 27, 48),
    line   = Color3.fromRGB(120, 110, 170),
    violet = Color3.fromRGB(150, 68, 240),
    blue   = Color3.fromRGB(56, 128, 246),
    accent = Color3.fromRGB(190, 160, 255),
    white  = Color3.fromRGB(255, 255, 255),
    muted  = Color3.fromRGB(215, 210, 235),
    dim    = Color3.fromRGB(150, 144, 175),
    green  = Color3.fromRGB(64, 224, 128),
    yellow = Color3.fromRGB(246, 206, 76),
    red    = Color3.fromRGB(240, 70, 70),
}
local FB, FM, FK = Enum.Font.GothamBold, Enum.Font.GothamMedium, Enum.Font.GothamBlack
local function label(parent, props)
    local base = { BackgroundTransparency = 1, Font = FM, TextSize = 11, TextColor3 = C.white,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = parent }
    for k, v in pairs(props) do base[k] = v end
    return new("TextLabel", base)
end
local function bounce(btn)
    local sc = btn:FindFirstChildOfClass("UIScale") or new("UIScale", { Parent = btn })
    btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            tween(sc, 0.08, { Scale = 0.94 }, Enum.EasingStyle.Quad)
        end
    end)
    btn.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            tween(sc, 0.32, { Scale = 1 }, Enum.EasingStyle.Back)
        end
    end)
end
local function glass(parent, size, pos, radius)
    local f = new("Frame", { Size = size, Position = pos or UDim2.new(), BackgroundColor3 = C.glass,
        BackgroundTransparency = 0.28, BorderSizePixel = 0, Parent = parent })
    corner(f, radius)
    local rim = stroke(f, C.white, 1.3, 0.1)
    local g = new("UIGradient", { Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.violet), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 200, 230)),
        ColorSequenceKeypoint.new(1, C.blue) }), Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(0.5, 0.65), NumberSequenceKeypoint.new(1, 0.1) }),
        Parent = rim })
    local gloss = new("Frame", { Size = UDim2.new(1, 0, 0.45, 0), BackgroundColor3 = C.white, BackgroundTransparency = 0.9,
        BorderSizePixel = 0, ZIndex = 0, Parent = f })
    corner(gloss, radius)
    -- ✅ CORRECTION : NumberSequence valide avec keypoints
    new("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1),
    }), Parent = gloss })
    return f, g
end

local gui = new("ScreenGui", { Name = "INFIN_AA", ResetOnSpawn = false, IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 98, Parent = PlayerGui })

-- ================================================================
-- ===================== CODE REDEEMER CORE =======================
-- ================================================================
local getupvalues_    = debug and debug.getupvalues or getupvalues
local getconnections_ = getconnections or (debug and debug.getconnections)
local setupvalue_     = debug and debug.setupvalue or setupvalue
local writeClipboard  = setclipboard or toclipboard or (syn and syn.write_clipboard)

local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")

local settingsFile = "infin_redeemer.txt"
local savedSettings = {}
if readfile and isfile then
    local ok, contents = pcall(function()
        if isfile(settingsFile) then return readfile(settingsFile) end
    end)
    if ok and type(contents) == "string" then
        for line in contents:gmatch("[^\n]+") do
            local k, v = line:match("^(%w+)=(.*)$")
            if k then savedSettings[k] = v end
        end
    end
end

local function cfgBool(key, default)
    local v = savedSettings[key]
    if v == "1" then return true end
    if v == "0" then return false end
    return default
end
local function cfgSet(key, value)
    savedSettings[key] = type(value) == "boolean" and (value and "1" or "0") or tostring(value)
    if not writefile then return end
    local lines = {}
    for k, v in pairs(savedSettings) do lines[#lines+1] = k .. "=" .. tostring(v) end
    table.sort(lines)
    pcall(writefile, settingsFile, table.concat(lines, "\n"))
end

local autoRedeem   = cfgBool("autoRedeem", true)
local autoType     = cfgBool("autoType", true)
local manual       = cfgBool("manual", false)
local autoListen   = cfgBool("autoListen", true)
local spamOnListen = cfgBool("spamOnListen", true)
local ignoreSystem = cfgBool("ignoreSystem", true)
local showKeybinds = true
local isListening  = false
local isSpamming   = false
local spamCount    = 0
local wordsToCollect = 1
local wordMode     = false
local listenKey    = Enum.KeyCode.F
local redeemKey    = Enum.KeyCode.G
local rebindingTarget = nil
local listenedWords = {}
local lastAutoTyped = nil
local notifyRemote = nil
local remoteFallbackUsed = false
local maxSpamDelay = 0.15

-- Utils
local function stripTags(s)
    if type(s) ~= "string" then return tostring(s) end
    return (s:gsub("<[^>]->", ""))
end
local function trim(s)
    return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end
local function copyToClipboard(text)
    if not writeClipboard then return false end
    return (pcall(writeClipboard, text))
end
local function extractWords(s)
    local out = {}
    for w in s:gmatch("[%w_]+") do out[#out+1] = w end
    return out
end
local function pickCodeCandidate(s)
    local candidate
    for w in s:gmatch("[%w_]+") do
        if #w >= 4 and w:match("%a") and (w:match("%u") or w:match("%d")) then candidate = w end
    end
    if candidate then return candidate end
    for w in s:gmatch("[%w_]+") do
        if #w >= 4 then return w end
    end
end

-- Code box finder + submit
local setCodeBoxText, submitCode

do
    local function findCodeBox()
        local codes = PlayerGui:FindFirstChild("Codes")
        if not codes then return nil end
        local main = (codes:FindFirstChild("Codes") or codes):FindFirstChild("Main")
        local box = main and main:FindFirstChild("TextBox")
        if box and box:IsA("TextBox") then return box end
        for _, d in ipairs(codes:GetDescendants()) do
            if d:IsA("TextBox") then return d end
        end
    end
    local function findConfirmButton()
        local codes = PlayerGui:FindFirstChild("Codes")
        if not codes then return nil end
        local codes2 = codes:FindFirstChild("Codes") or codes
        local confirm = (codes2:FindFirstChild("Main") or codes2):FindFirstChild("Confirm")
        if confirm and (confirm:IsA("ImageButton") or confirm:IsA("TextButton")) then return confirm end
        for _, d in ipairs(codes:GetDescendants()) do
            if d:IsA("ImageButton") or d:IsA("TextButton") then
                local n = d.Name:lower()
                if n:find("confirm") or n:find("submit") or n:find("redeem") or n:find("enter") then return d end
            end
        end
    end
    local function clearBooleans(fn, depth)
        if not (fn and setupvalue_ and getupvalues_) then return end
        depth = depth or 1
        local ok, ups = pcall(getupvalues_, fn)
        if ok and type(ups) == "table" then
            for k, v in pairs(ups) do
                if type(v) == "boolean" then pcall(setupvalue_, fn, k, false)
                elseif type(v) == "function" and depth > 0 then clearBooleans(v, depth - 1) end
            end
        end
    end
    local function fireConnections(signal, ...)
        if not getconnections_ then return false end
        local ok, conns = pcall(getconnections_, signal)
        if not ok or type(conns) ~= "table" or #conns == 0 then return false end
        local args = table.pack(...)
        local any = false
        for _, c in ipairs(conns) do
            if c.Enabled ~= false then
                local cb
                pcall(function() cb = c.Function end)
                clearBooleans(cb)
                local ok2
                if cb then ok2 = pcall(task.spawn, cb, table.unpack(args, 1, args.n))
                else ok2 = pcall(function() c:Fire(table.unpack(args, 1, args.n)) end) end
                any = any or ok2
            end
        end
        return any
    end
    setCodeBoxText = function(text)
        if type(text) ~= "string" or text == "" then return end
        local box = findCodeBox()
        if not box then return end
        pcall(function() if box.Text ~= text then box.Text = text end end)
    end
    local function trySubmitViaConnections(text)
        if not getconnections_ then return false end
        local box = findCodeBox()
        if not box then return false end
        pcall(function() box.Text = text; box.Active = true; box.Selectable = true end)
        local confirm = findConfirmButton()
        local ok = false
        if confirm then
            local a = fireConnections(confirm.MouseButton1Click)
            local b = fireConnections(confirm.Activated)
            ok = a or b or false
        end
        if not ok then ok = fireConnections(box.FocusLost, true) or ok end
        return ok
    end
    local function trySubmitViaFocus(text)
        local box = findCodeBox()
        if not box then return false end
        if not pcall(function() box.Text = text; box:CaptureFocus() end) then return false end
        task.wait(0.1)
        return pcall(function() box:ReleaseFocus(true) end)
    end
    submitCode = function(text)
        if trySubmitViaConnections(text) then return true end
        if getconnections_ then return false end
        return trySubmitViaFocus(text)
    end
end

-- Notification remote
local findNotificationRemote
do
    local function remoteInstancesOf(func)
        if not getupvalues_ then return {} end
        local ok, ups = pcall(getupvalues_, func)
        local out = {}
        if ok and ups then
            for _, v in pairs(ups) do
                if typeof(v) == "Instance"
                   and (v:IsA("RemoteEvent") or v:IsA("RemoteFunction") or v:IsA("UnreliableRemoteEvent"))
                   and v.Parent == Net then table.insert(out, v) end
            end
        end
        return out
    end
    findNotificationRemote = function()
        local ok, mod = pcall(function()
            return require(ReplicatedStorage.Controllers:FindFirstChild("NotificationController", true))
        end)
        if ok and type(mod) == "table" and type(mod.Start) == "function" then
            return remoteInstancesOf(mod.Start)[1]
        end
    end
end

-- Extract code after trigger
local extractCodeAfterTrigger
do
    local patterns = {
        leads = { "use", "using", "redeem", "type", "enter", "claim", "with", "grab", "got",
                  "here is", "heres", "here's", "there is", "theres", "there's" },
        articles = { "", "the%s+", "a%s+", "an%s+", "this%s+", "your%s+", "new%s+" },
        patterns = { "code%s+is", "codes?%s+are", "code%s+for", "code%s+to%s+use",
                     "code%s*[:%-]", "new%s+code", "free%s+code", "secret%s+code",
                     "working%s+code", "another%s+code" },
        names = { "sammy" },
    }
    for _, lead in ipairs(patterns.leads) do
        local esc = lead:gsub("%s+", "%%s+")
        for _, article in ipairs(patterns.articles) do
            patterns.patterns[#patterns.patterns+1] = esc .. "%s+" .. article .. "code"
        end
    end
    local function firstCodeWordTail(s)
        for pos, word in s:gmatch("()([%w_]+)") do
            if #word >= 4 and word:match("%a") and (word:match("%u") or word:match("%d")) then
                return s:sub(pos)
            end
        end
    end
    extractCodeAfterTrigger = function(raw)
        local lower = raw:lower()
        local bestEnd, bestFlag
        local function scan(pat, plain, flag)
            local i = 1
            while true do
                local ok, s, e = pcall(string.find, lower, pat, i, plain)
                if not ok or not s then break end
                if not bestEnd or e > bestEnd then bestEnd = e; bestFlag = flag end
                i = e + 1
            end
        end
        for _, pat in ipairs(patterns.patterns) do scan(pat, false, false) end
        if lower:find("code") then
            for _, name in ipairs(patterns.names) do scan(name:lower(), true, true) end
        end
        if not bestEnd then return nil end
        local tail = raw:sub(bestEnd + 1)
        local code = firstCodeWordTail(tail)
        if bestFlag then return code end
        return code or ""
    end
end

-- System phrases
local function isSystemPhrase(text)
    if not ignoreSystem or not isListening then return false end
    local lower = stripTags(tostring(text or "")):lower()
    local compact = lower:gsub("[^%w]", "")
    local phrases = {
        "codeis", "usecode", "fontcolor", "fontcolour",
        "sammyhasactivated", "sammyactivated",
        "coinsshop", "brainrottrader", "robuxshop",
        "spinwheel", "tradeplaza", "eventhasstarted",
        "yourbaseisalreadylocked", "yourbaseisfull",
        "yougotafreespin", "brokeintoyourbase",
        "someoneisstealing", "tradehasbeencompleted",
        "eventhasbeenactivated", "hasbeenactivated", "hasactivated",
        "youlocked yourbase", "locked yourbase",
        "brainrotexpresshasarrived", "brainrotexpressleavingin",
    }
    for _, p in ipairs({ "sammy:", "spydersammy:" }) do
        if compact:find(p, 1, true) then return true end
    end
    for _, p in ipairs(phrases) do
        if compact:find(p, 1, true) then return true end
    end
    return false
end

-- ================================================================
-- ===================== MAIN WINDOW (Infin) ======================
-- ================================================================
local SIZE, MINI_H = 340, 84
local holder = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(SIZE, SIZE), BackgroundTransparency = 1, Parent = gui })
local fit = new("UIScale", { Parent = holder })
local function refit()
    local vp = camera.ViewportSize
    fit.Scale = math.clamp(math.min(vp.Y * 0.8 / SIZE, vp.X * 0.62 / (SIZE + 230)), 0.55, 1.15)
end
refit()
camera:GetPropertyChangedSignal("ViewportSize"):Connect(refit)

local card, rimGrad = glass(holder, UDim2.fromScale(1, 1), nil, 22)
card.ClipsDescendants = true
local pop = new("UIScale", { Scale = 0.6, Parent = card })

-- Glow orbs
local function orb(col, size, pos)
    local o = new("Frame", { Size = UDim2.fromOffset(size, size), AnchorPoint = Vector2.new(0.5, 0.5), Position = pos,
        BackgroundColor3 = col, BorderSizePixel = 0, ZIndex = 0, Parent = card })
    round(o)
    new("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(0.7, 0.97), NumberSequenceKeypoint.new(1, 1) }), Parent = o })
    return o
end
local o1 = orb(C.violet, 240, UDim2.fromScale(0.1, 0.15))
local o2 = orb(C.blue, 220, UDim2.fromScale(0.95, 0.95))
local drift = TweenInfo.new(8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
TweenService:Create(o1, drift, { Position = UDim2.fromScale(0.35, 0.3) }):Play()
TweenService:Create(o2, drift, { Position = UDim2.fromScale(0.7, 0.75) }):Play()

local sparkles = {}
local rng = Random.new()
for i = 1, 18 do
    local s = new("Frame", { Size = UDim2.fromOffset(2, 2),
        Position = UDim2.fromOffset(rng:NextInteger(8, SIZE - 8), rng:NextInteger(8, SIZE - 8)),
        BackgroundColor3 = (i % 3 == 0) and C.accent or C.white, BorderSizePixel = 0, ZIndex = 0, Parent = card })
    round(s)
    sparkles[i] = { f = s, ph = rng:NextNumber(0, 6.28), sp = rng:NextNumber(0.8, 2.4) }
end

-- Header
local head = new("Frame", { Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, ZIndex = 2, Parent = card })
do
    local logo = new("ImageLabel", { Size = UDim2.fromOffset(32, 32), Position = UDim2.fromOffset(14, 8), Image = LOGO_ID,
        ScaleType = Enum.ScaleType.Crop, BackgroundColor3 = C.tile, BorderSizePixel = 0, ZIndex = 2, Parent = head })
    round(logo)
    local ls = stroke(logo, C.white, 1.6, 0)
    new("UIGradient", { Color = ColorSequence.new(C.violet, C.blue), Parent = ls })
    label(head, { Text = "Infin AA Helper", Font = FK, TextSize = 15, Position = UDim2.fromOffset(54, 9),
        Size = UDim2.fromOffset(150, 18), ZIndex = 2 })
    local badge = new("Frame", { Position = UDim2.fromOffset(180, 11), Size = UDim2.fromOffset(40, 16), BackgroundColor3 = C.white,
        BorderSizePixel = 0, ZIndex = 2, Parent = head })
    round(badge)
    new("UIGradient", { Color = ColorSequence.new(C.violet, C.blue), Parent = badge })
    label(badge, { Text = "FREE", Font = FK, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.fromScale(1, 1), ZIndex = 3 })
    label(head, { Text = "admin abuse helper  ·  .gg/infinhub", TextSize = 9, TextColor3 = C.dim,
        Position = UDim2.fromOffset(54, 28), Size = UDim2.fromOffset(220, 12), ZIndex = 2 })
end

-- Settings button (⚙)
local settBtn = new("TextButton", { Text = "⚙", Font = FB, TextSize = 16, TextColor3 = C.white,
    Size = UDim2.fromOffset(30, 30), AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -48, 0, 9), BackgroundColor3 = C.tile,
    BackgroundTransparency = 0.2, BorderSizePixel = 0, ZIndex = 2, Parent = head })
corner(settBtn, 10)
stroke(settBtn, C.line, 1, 0.3)
bounce(settBtn)

-- Minimize button
local minBtn = new("TextButton", { Text = "", AutoButtonColor = false, Size = UDim2.fromOffset(30, 30), AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -12, 0, 9), BackgroundColor3 = C.tile, BackgroundTransparency = 0.2, BorderSizePixel = 0, ZIndex = 2, Parent = head })
corner(minBtn, 10)
stroke(minBtn, C.line, 1, 0.3)
bounce(minBtn)
local minBar = new("Frame", { Size = UDim2.fromOffset(12, 2), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = 3, Parent = minBtn })
round(minBar)
local minPlus = new("Frame", { Size = UDim2.fromOffset(2, 12), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    BackgroundColor3 = C.white, BorderSizePixel = 0, Visible = false, ZIndex = 3, Parent = minBtn })
round(minPlus)

-- Status strip
local strip = new("Frame", { Size = UDim2.new(1, -28, 0, 26), Position = UDim2.fromOffset(14, 50), BackgroundColor3 = C.tile,
    BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 2, Parent = card })
corner(strip, 13)
stroke(strip, C.line, 1, 0.45)
local sDot = new("Frame", { Size = UDim2.fromOffset(8, 8), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 11, 0.5, 0),
    BackgroundColor3 = C.green, BorderSizePixel = 0, ZIndex = 3, Parent = strip })
round(sDot)
local sText = label(strip, { Text = "ready", Font = FB, TextSize = 11, TextColor3 = C.green, TextTruncate = Enum.TextTruncate.AtEnd,
    Position = UDim2.fromOffset(26, 0), Size = UDim2.new(1, -110, 1, 0), ZIndex = 3 })
local sStats = label(strip, { Text = "-- fps  |  -- ms", Font = FB, TextSize = 9, TextColor3 = C.dim,
    TextXAlignment = Enum.TextXAlignment.Right, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -11, 0, 0),
    Size = UDim2.fromOffset(90, 26), ZIndex = 3 })
local function status(text, col)
    sText.Text, sText.TextColor3, sDot.BackgroundColor3 = text, col, col
    sText.Position = UDim2.fromOffset(32, 0)
    tween(sText, 0.25, { Position = UDim2.fromOffset(26, 0) })
end

-- Tiles
local grid = new("Frame", { Size = UDim2.new(1, -28, 0, 246), Position = UDim2.fromOffset(14, 84), BackgroundTransparency = 1,
    ZIndex = 2, Parent = card })
new("UIGridLayout", { CellSize = UDim2.new(0.5, -5, 0, 76), CellPadding = UDim2.fromOffset(10, 9),
    SortOrder = Enum.SortOrder.LayoutOrder, Parent = grid })

local function tile(order, icon, title, sub, isToggle, onPress)
    local b = new("TextButton", { Text = "", AutoButtonColor = false, BackgroundColor3 = C.tile, BackgroundTransparency = 0.25,
        BorderSizePixel = 0, LayoutOrder = order, ZIndex = 2, ClipsDescendants = true, Parent = grid })
    corner(b, 16)
    local e = stroke(b, C.line, 1.1, 0.35)
    local lit = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.white, BackgroundTransparency = 1,
        BorderSizePixel = 0, ZIndex = 2, Parent = b })
    corner(lit, 16)
    new("UIGradient", { Color = ColorSequence.new(C.violet, C.blue), Rotation = 25, Parent = lit })
    local ic = label(b, { Text = icon, TextSize = 20, TextXAlignment = Enum.TextXAlignment.Center,
        Position = UDim2.fromOffset(10, 9), Size = UDim2.fromOffset(28, 28), ZIndex = 3 })
    local t = label(b, { Text = title, Font = FK, TextSize = 12, TextColor3 = C.white, Position = UDim2.fromOffset(12, 40),
        Size = UDim2.new(1, -20, 0, 15), ZIndex = 3 })
    local s = label(b, { Text = sub, Font = FM, TextSize = 9, TextColor3 = C.dim, TextTruncate = Enum.TextTruncate.AtEnd,
        Position = UDim2.fromOffset(12, 56), Size = UDim2.new(1, -20, 0, 12), ZIndex = 3 })
    local sw, knob
    if isToggle then
        sw = new("Frame", { Size = UDim2.fromOffset(34, 18), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 12),
            BackgroundColor3 = Color3.fromRGB(50, 46, 76), BorderSizePixel = 0, ZIndex = 3, Parent = b })
        round(sw)
        knob = new("Frame", { Size = UDim2.fromOffset(12, 12), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 9, 0.5, 0),
            BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = 4, Parent = sw })
        round(knob)
    end
    bounce(b)
    local api = { on = false, sub = s }
    function api.paint(v)
        api.on = v
        tween(lit, 0.25, { BackgroundTransparency = v and 0.15 or 1 })
        e.Color = v and C.accent or C.line
        tween(s, 0.2, { TextColor3 = v and C.white or C.dim })
        if sw then
            tween(sw, 0.2, { BackgroundColor3 = v and C.white or Color3.fromRGB(50, 46, 76) })
            tween(knob, 0.32, { Position = UDim2.new(0, v and 25 or 9, 0.5, 0), BackgroundColor3 = v and C.violet or C.white },
                Enum.EasingStyle.Back)
        end
        ic.Rotation = -15
        tween(ic, 0.4, { Rotation = 0 }, Enum.EasingStyle.Back)
    end
    function api.flash(text, col)
        local f = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = col or C.violet, BackgroundTransparency = 0.35,
            BorderSizePixel = 0, ZIndex = 2, Parent = b })
        corner(f, 16)
        tween(f, 0.6, { BackgroundTransparency = 1 })
        Debris:AddItem(f, 0.65)
        if text then
            local old = t.Text
            t.Text = text
            t.TextColor3 = col or C.green
            task.delay(1.6, function() t.Text = old; tween(t, 0.3, { TextColor3 = C.white }) end)
        end
    end
    b.MouseButton1Click:Connect(function()
        if isToggle then
            api.paint(not api.on)
            onPress(api.on, api)
        else
            onPress(api)
        end
    end)
    return api
end

-- Anti-ragdoll
local AR = { on = false, conn = nil }
local function anchorChar(on)
    local ch = player.Character
    if not ch then return end
    for _, d in ipairs(ch:GetDescendants()) do
        if d:IsA("BasePart") then d.Anchored = on end
    end
end
function AR.set(on)
    AR.on = on
    if AR.conn then AR.conn:Disconnect() AR.conn = nil end
    if on then
        AR.conn = RunService.Heartbeat:Connect(function()
            local ch = player.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            local root = ch and ch:FindFirstChild("HumanoidRootPart")
            if not (hum and root) or hum.Health <= 0 then return end
            anchorChar(true)
            root.AssemblyLinearVelocity, root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.Physics then
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    hum.PlatformStand, hum.Sit = false, false
                end)
            end
        end)
    else
        anchorChar(false)
    end
end
player.CharacterAdded:Connect(function()
    if AR.on then task.wait(0.4); anchorChar(true) end  -- ✅ séparé
end)

-- Block events
local function blockEvents()
    local done = false
    pcall(function()
        local folder = ReplicatedStorage:FindFirstChild("Controllers")
        local m = folder and folder:FindFirstChild("EventController", true)
        local Events = m and require(m)
        if type(Events) == "table" and type(Events.Events) == "table" then
            for k, ev in pairs(Events.Events) do
                if type(ev) == "table" and rawget(ev, "Active") then
                    if not (type(Events.Cancel) == "function" and pcall(function() Events:Cancel(k) end)) then
                        rawset(ev, "Active", false)
                    end
                end
            end
            Events.Execute = function() return false end
            local fx = folder:FindFirstChild("EffectController", true)
            local Effects = fx and require(fx)
            if type(Effects) == "table" then
                if type(Effects.ActiveEffects) == "table" then
                    for k in pairs(Effects.ActiveEffects) do
                        local e = type(Effects.Effects) == "table" and Effects.Effects[k]
                        Effects.ActiveEffects[k] = nil
                        if type(e) == "table" and type(e.OnStop) == "function" then pcall(function() e:OnStop() end) end
                    end
                end
                Effects.Run = function() return false, false end
            end
            done = true
        end
    end)
    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("Sound") and d.Looped and d.Playing then pcall(function() d:Stop() end) end
    end
    local ae = PlayerGui:FindFirstChild("ActiveEvents")
    if ae then pcall(function() if ae:IsA("ScreenGui") then ae.Enabled = false end end) end
    return done
end

-- Boost FPS
local boosted = false
local function boostFPS(api)
    if boosted then api.flash("Already on", C.green) return end
    boosted = true
    task.spawn(function()
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
        pcall(function() Lighting.GlobalShadows = false; Lighting.FogEnd = 9e9 end)
        local function strip(d)
            if d:IsA("BasePart") then
                d.Material = Enum.Material.SmoothPlastic
                d.CastShadow = false
            elseif d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam") or d:IsA("Fire") or d:IsA("Smoke") or d:IsA("Sparkles") then
                d.Enabled = false
            elseif d:IsA("Decal") or d:IsA("Texture") then
                d.Transparency = 1
            elseif d:IsA("PostEffect") then
                d.Enabled = false
            end
        end
        for _, d in ipairs(Lighting:GetDescendants()) do pcall(strip, d) end
        workspace.DescendantAdded:Connect(function(d) pcall(strip, d) end)
        local list = workspace:GetDescendants()
        for i = 1, #list do
            pcall(strip, list[i])
            if i % 400 == 0 then task.wait() end
        end
    end)
    api.flash("Boosted", C.green)
    api.sub.Text = "on until you rejoin"
end

-- Fullbright
local saved
local function fullbright(on)
    if on then
        saved = { Lighting.Brightness, Lighting.ClockTime, Lighting.FogEnd, Lighting.GlobalShadows, Lighting.Ambient, Lighting.OutdoorAmbient }
        Lighting.Brightness, Lighting.ClockTime, Lighting.FogEnd, Lighting.GlobalShadows = 2, 14, 1e9, false
        Lighting.Ambient, Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180), Color3.fromRGB(180, 180, 180)
    elseif saved then
        Lighting.Brightness, Lighting.ClockTime, Lighting.FogEnd, Lighting.GlobalShadows, Lighting.Ambient, Lighting.OutdoorAmbient =
            saved[1], saved[2], saved[3], saved[4], saved[5], saved[6]
    end
end

-- Auto Buy
local AB = { on = false, models = {}, conns = {}, last = nil, lastAt = 0, count = 0, acc = 0 }
local DATA = {}
local function datas(name)
    local d = ReplicatedStorage:FindFirstChild("Datas")
    local m = d and d:FindFirstChild(name)
    local ok, r = pcall(require, m)
    return ok and type(r) == "table" and r or nil
end
local function fmt(n)
    n = tonumber(n)
    if not n then return "—" end
    for _, u in ipairs({ { 1e15, "Qa" }, { 1e12, "T" }, { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" } }) do
        if math.abs(n) >= u[1] then return ("%.1f%s"):format(n / u[1], u[2]) end
    end
    return tostring(math.floor(n))
end
local function traitsOf(model)
    local out, seen = {}, {}
    local function add(v)
        v = tostring(v or ""):gsub("<[^>]->", ""):gsub("^%s+", ""):gsub("%s+$", "")
        if v ~= "" and v:lower() ~= "none" and not seen[v] then seen[v] = true; out[#out+1] = v end
    end
    local raw = model:GetAttribute("Traits") or model:GetAttribute("Trait")
    if type(raw) == "string" then
        local ok, arr = pcall(function() return game:GetService("HttpService"):JSONDecode(raw) end)
        if ok and type(arr) == "table" then for _, v in ipairs(arr) do add(v) end
        else for p in raw:gmatch("[^,;|/]+") do add(p) end end
    end
    for k, v in pairs(model:GetAttributes()) do
        if type(k) == "string" and k:match("^Trait%d+$") then add(v) end
    end
    local f = model:FindFirstChild("Traits")
    if f then for _, c in ipairs(f:GetChildren()) do add(c:IsA("StringValue") and c.Value or c.Name) end end
    return out
end
local function info(model)
    DATA.animals = DATA.animals or datas("Animals")
    DATA.muts = DATA.muts or datas("Mutations")
    DATA.traits = DATA.traits or datas("Traits")
    local idx = model:GetAttribute("Index")
    local mut = model:GetAttribute("Mutation")
    if mut == "" or tostring(mut):lower() == "none" then mut = nil end
    local tr = traitsOf(model)
    local d = DATA.animals and DATA.animals[idx]
    local gen = type(d) == "table" and tonumber(d.Generation) or nil
    if gen then
        local mult = 1
        local mi = mut and DATA.muts and DATA.muts[mut]
        if type(mi) == "table" and tonumber(mi.Modifier) then mult = 1 + tonumber(mi.Modifier) end
        local sleepy = false
        for _, t in ipairs(tr) do
            if t == "Sleepy" then sleepy = true
            else
                local ti = DATA.traits and DATA.traits[t]
                if type(ti) == "table" and tonumber(ti.MultiplierModifier) then mult += tonumber(ti.MultiplierModifier) end
            end
        end
        gen = gen * mult * (sleepy and 0.5 or 1)
    end
    return {
        name = (type(d) == "table" and d.DisplayName) or idx or "?",
        price = type(d) == "table" and tonumber(d.Price) or nil,
        rarity = type(d) == "table" and d.Rarity or nil,
        income = gen, mutation = mut, traits = tr,
    }
end
local function promptOf(model)
    local pp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if not pp then return nil end
    for _, d in ipairs(pp:GetDescendants()) do
        if d:IsA("ProximityPrompt") and d.Enabled and d.ActionText == "Purchase" then return d, pp end
    end
end
local function nearest()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local best, bp, bd = nil, nil, math.huge
    for m in pairs(AB.models) do
        if m.Parent then
            local p, part = promptOf(m)
            if p then
                local d = (part.Position - root.Position).Magnitude
                if d < bd then best, bp, bd = m, p, d end
            end
        else AB.models[m] = nil end
    end
    return best, bp, bd
end
local function buy(prompt)
    pcall(function() prompt.HoldDuration = 0; prompt.RequiresLineOfSight = false end)
    if type(fireproximityprompt) == "function" and pcall(fireproximityprompt, prompt) then return true end
    return (pcall(function() prompt:InputHoldBegin() prompt:InputHoldEnd() end))
end

-- Auto-buy mini panel
local bp = glass(holder, UDim2.fromOffset(210, 196), UDim2.new(1, 12, 0, 0), 18)
bp.Visible = false
bp.ClipsDescendants = true
local bpScale = new("UIScale", { Parent = bp })
label(bp, { Text = "AUTO BUY", Font = FK, TextSize = 12, Position = UDim2.fromOffset(14, 10), Size = UDim2.fromOffset(120, 16), ZIndex = 2 })
local bpPill = label(bp, { Text = "SCANNING", Font = FK, TextSize = 8, TextColor3 = C.yellow, TextXAlignment = Enum.TextXAlignment.Center,
    AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 10), Size = UDim2.fromOffset(78, 16),
    BackgroundColor3 = C.yellow, BackgroundTransparency = 0.82, ZIndex = 2 })
round(bpPill)
local pillEdge = stroke(bpPill, C.yellow, 1, 0.4)
local lines = {}
local function bpLine(i, txt, col)
    lines[i] = label(bp, { Text = txt, Font = i == 1 and FK or FM, TextSize = i == 1 and 12 or 10, TextColor3 = col or C.muted,
        TextTruncate = Enum.TextTruncate.AtEnd, TextWrapped = i == 5, TextYAlignment = Enum.TextYAlignment.Top,
        Position = UDim2.fromOffset(14, 34 + (i - 1) * 20), Size = UDim2.new(1, -28, 0, i == 5 and 30 or 16), ZIndex = 2 })
end
bpLine(1, "—", C.white); bpLine(2, "Income: —", C.green); bpLine(3, "Rarity: —"); bpLine(4, "Mutation: —"); bpLine(5, "Traits: —")
local bpFoot = label(bp, { Text = "0 bought", Font = FB, TextSize = 9, TextColor3 = C.accent, AnchorPoint = Vector2.new(0, 1),
    Position = UDim2.new(0, 14, 1, -10), Size = UDim2.new(1, -28, 0, 12), ZIndex = 2 })

local PILL = { scan = { "SCANNING", C.yellow }, far = { "OUT OF RANGE", C.yellow }, buy = { "BUYING", C.accent }, ok = { "BOUGHT", C.green } }
local function setPill(k)
    local p = PILL[k]
    if bpPill.Text == p[1] then return end
    bpPill.Text, bpPill.TextColor3, bpPill.BackgroundColor3 = p[1], p[2], p[2]
    pillEdge.Color = p[2]
end
local function showInfo(model, dist)
    if not model then
        AB.curPrice = nil
        lines[1].Text, lines[2].Text, lines[3].Text, lines[4].Text, lines[5].Text = "—", "Income: —", "Rarity: —", "Mutation: —", "Traits: —"
        return
    end
    local i = info(model)
    AB.curPrice = i.price
    if i.price then AB.lastPrice = i.price end
    lines[1].Text = tostring(i.name) .. (i.price and ("  ($" .. fmt(i.price) .. ")") or "")
    lines[2].Text = "Income: " .. (i.income and ("$" .. fmt(i.income) .. "/s") or "—")
    lines[3].Text = "Rarity: " .. tostring(i.rarity or "—")
    lines[4].Text = "Mutation: " .. tostring(i.mutation or "None")
    lines[5].Text = "Traits: " .. (#i.traits > 0 and table.concat(i.traits, ", ") or "None")
    bpFoot.Text = ("%d bought  ·  %.0f studs"):format(AB.count, dist or 0)
end
local function tryBuy(model, prompt)
    local now = os.clock()
    if prompt == AB.last and now - AB.lastAt < 0.35 then return end
    AB.last, AB.lastAt = prompt, now
    if buy(prompt) then
        AB.count += 1
        task.defer(function()
            setPill("ok"); AB.flashUntil = os.clock() + 1.2
            showInfo(model, 0); status("bought " .. tostring(info(model).name), C.green)
        end)
    end
end
local function track(ch)
    if ch:IsA("Model") and ch:GetAttribute("Index") ~= nil then AB.models[ch] = true end
end
local function abSet(on)
    AB.on = on
    for _, c in ipairs(AB.conns) do c:Disconnect() end
    AB.conns, AB.models = {}, {}
    if on then
        for _, ch in ipairs(workspace:GetChildren()) do track(ch) end
        AB.conns[#AB.conns+1] = workspace.ChildAdded:Connect(track)
        AB.conns[#AB.conns+1] = RunService.Heartbeat:Connect(function(dt)
            local m, p, d = nearest()
            local inRange = p and d <= (p.MaxActivationDistance or 10) + 2
            if inRange then tryBuy(m, p) end
            AB.acc += dt
            if AB.acc < 0.2 then return end
            AB.acc = 0
            if AB.flashUntil and os.clock() < AB.flashUntil then return end
            showInfo(m, d)
            setPill(not p and "scan" or (inRange and "buy" or "far"))
        end)
        AB.conns[#AB.conns+1] = game:GetService("ProximityPromptService").PromptShown:Connect(function(p)
            if p.ActionText ~= "Purchase" then return end
            tryBuy(p:FindFirstAncestorWhichIsA("Model"), p)
        end)
        bp.Visible = true
        bp.Position = UDim2.new(1, -40, 0, 0)
        bpScale.Scale = 0.85
        tween(bp, 0.45, { Position = UDim2.new(1, 12, 0, 0) }, Enum.EasingStyle.Back)
        tween(bpScale, 0.45, { Scale = 1 }, Enum.EasingStyle.Back)
    else
        tween(bpScale, 0.2, { Scale = 0.85 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        tween(bp, 0.22, { Position = UDim2.new(1, -40, 0, 0) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.delay(0.23, function() if not AB.on then bp.Visible = false end end)
    end
end

-- Cash alert
local CA = { on = false, conn = nil, armed = true, acc = 0 }
local SUFFIX = { k = 1e3, m = 1e6, b = 1e9, t = 1e12, qa = 1e15, qi = 1e18 }
local function parseCash(v)
    if type(v) == "number" then return v end
    local s = tostring(v or ""):lower():gsub("[%$,%s]", "")
    local num, suf = s:match("^([%d%.]+)(%a*)")
    num = tonumber(num)
    if not num then return nil end
    return num * (SUFFIX[suf] or 1)
end
local function getCash()
    local ls = player:FindFirstChild("leaderstats")
    local c = ls and (ls:FindFirstChild("Cash") or ls:FindFirstChild("Money"))
    if c then return parseCash(c.Value) end
    local a = player:GetAttribute("Cash") or player:GetAttribute("Money")
    return a and parseCash(a) or nil
end
local alarm = new("Sound", { SoundId = "rbxasset://sounds/electronicpingshort.wav", Volume = 1, PlaybackSpeed = 0.75, Parent = gui })
local function boop()
    task.spawn(function()
        for _ = 1, 4 do alarm.TimePosition = 0; alarm:Play(); task.wait(0.5) end
    end)
end
local function cashAlert(on, api)
    CA.on, CA.armed = on, true
    if CA.conn then CA.conn:Disconnect() CA.conn = nil end
    if not on then return end
    CA.conn = RunService.Heartbeat:Connect(function(dt)
        CA.acc += dt
        if CA.acc < 0.25 then return end
        CA.acc = 0
        if not AB.on then
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local best, bd = nil, math.huge
            if root then
                for _, ch in ipairs(workspace:GetChildren()) do
                    if ch:IsA("Model") and ch:GetAttribute("Index") ~= nil then
                        local _, part = promptOf(ch)
                        if part then
                            local d = (part.Position - root.Position).Magnitude
                            if d < bd then best, bd = ch, d end
                        end
                    end
                end
            end
            AB.curPrice = best and info(best).price or nil
            if AB.curPrice then AB.lastPrice = AB.curPrice end
        end
        local price = AB.curPrice or AB.lastPrice
        local cash = getCash()
        if not (price and cash) then api.sub.Text = "waiting for a brainrot" return end
        local limit = price * 2
        api.sub.Text = "$" .. fmt(cash) .. " / alert under $" .. fmt(limit)
        if cash < limit then
            if CA.armed then
                CA.armed = false; boop(); api.flash("LOW CASH", C.red)
                status("low cash  ·  under 2x the brainrot's cost", C.red)
            end
        elseif cash >= limit then CA.armed = true end
    end)
end

-- ================================================================
-- ===================== FEED WINDOW ==============================
-- ================================================================
local feedEntries, feedTotal = {}, 0
local feedWindow, feedCount, feedList, feedEmpty, feedAdd

do
    local feedTitleRow
    feedWindow = glass(holder, UDim2.fromOffset(300, 340), UDim2.new(1, 12, 0, 220), 18)
    feedWindow.Visible = false
    feedWindow.ClipsDescendants = true

    feedTitleRow = new("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, ZIndex = 2, Parent = feedWindow })
    label(feedTitleRow, { Text = "LIVE FEED", Font = FK, TextSize = 13, Position = UDim2.fromOffset(14, 12), Size = UDim2.fromOffset(120, 18), ZIndex = 2 })

    local clearBtn = new("TextButton", { Text = "Clear", Font = FB, TextSize = 9, TextColor3 = C.white,
        Size = UDim2.fromOffset(40, 22), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -80, 0, 9),
        BackgroundColor3 = C.tile, BackgroundTransparency = 0.2, BorderSizePixel = 0, ZIndex = 2, Parent = feedTitleRow })
    corner(clearBtn, 8); bounce(clearBtn)

    local closeBtn = new("TextButton", { Text = "×", Font = FB, TextSize = 16, TextColor3 = C.white,
        Size = UDim2.fromOffset(22, 22), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 9),
        BackgroundColor3 = C.tile, BackgroundTransparency = 0.2, BorderSizePixel = 0, ZIndex = 2, Parent = feedTitleRow })
    corner(closeBtn, 8); bounce(closeBtn)
    closeBtn.MouseButton1Click:Connect(function() feedWindow.Visible = false end)

    feedCount = label(feedTitleRow, { Text = "0 caught", Font = FB, TextSize = 9, TextColor3 = C.dim,
        TextXAlignment = Enum.TextXAlignment.Right, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -85, 0, 12),
        Size = UDim2.fromOffset(60, 16), ZIndex = 2 })

    feedList = new("ScrollingFrame", { Size = UDim2.new(1, -20, 1, -50), Position = UDim2.fromOffset(10, 44),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = C.violet,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 2, Parent = feedWindow })
    new("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = feedList })

    feedEmpty = label(feedList, { Text = "waiting for notifications...", Font = FM, TextSize = 10, TextColor3 = C.dim,
        TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.new(1, 0, 0, 40), LayoutOrder = 999 })
    feedEmpty.BackgroundTransparency = 1

    feedAdd = function(text, code)
        if feedEmpty then feedEmpty:Destroy(); feedEmpty = nil end
        feedTotal = feedTotal + 1
        feedCount.Text = feedTotal .. " caught"

        local c = new("Frame", { Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = C.tile, BackgroundTransparency = 0.3, BorderSizePixel = 0,
            LayoutOrder = -feedTotal, ZIndex = 3, Parent = feedList })
        corner(c, 10)
        stroke(c, code and C.violet or C.line, 1, 0.4)
        new("UIPadding", { PaddingTop = UDim.new(0, 7), PaddingBottom = UDim.new(0, 7),
            PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 9), Parent = c })
        new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = c })

        local body = label(c, { Text = text, Font = FM, TextSize = 10, TextColor3 = C.muted,
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top, LayoutOrder = 1, ZIndex = 3 })

        if code then
            local row = new("Frame", { Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, LayoutOrder = 2, ZIndex = 3, Parent = c })
            local codeLbl = new("TextLabel", { Size = UDim2.new(0.55, -3, 1, 0), BackgroundColor3 = C.glass,
                Text = code, Font = FK, TextSize = 10, TextColor3 = C.accent, BorderSizePixel = 0, ZIndex = 3, Parent = row })
            corner(codeLbl, 6); stroke(codeLbl, C.accent, 1, 0.4)

            local copy = new("TextButton", { Size = UDim2.new(0.2, -3, 1, 0), Position = UDim2.new(0.57, 3, 0, 0),
                BackgroundColor3 = C.tile, Text = "COPY", Font = FB, TextSize = 8, TextColor3 = C.white,
                BorderSizePixel = 0, ZIndex = 3, Parent = row })
            corner(copy, 6)
            copy.MouseButton1Click:Connect(function()
                copy.Text = copyToClipboard(code) and "OK" or "ERR"
                task.delay(0.7, function() if copy.Parent then copy.Text = "COPY" end end)
            end)

            local use = new("TextButton", { Size = UDim2.new(0.23, -3, 1, 0), Position = UDim2.new(0.77, 3, 0, 0),
                BackgroundColor3 = C.violet, Text = "USE", Font = FK, TextSize = 9, TextColor3 = C.white,
                BorderSizePixel = 0, ZIndex = 3, Parent = row })
            corner(use, 6)
            use.MouseButton1Click:Connect(function()
                if _G.__InfinUse then _G.__InfinUse(code) end
            end)
        end

        table.insert(feedEntries, c)
        if #feedEntries > 36 then
            local old = table.remove(feedEntries, 1)
            if old then old:Destroy() end
        end
    end

    clearBtn.MouseButton1Click:Connect(function()
        for _, e in ipairs(feedEntries) do e:Destroy() end
        feedEntries, feedTotal = {}, 0
        feedCount.Text = "0 caught"
        if not feedEmpty then
            feedEmpty = label(feedList, { Text = "waiting for notifications...", Font = FM, TextSize = 10, TextColor3 = C.dim,
                TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.new(1, 0, 0, 40), LayoutOrder = 999 })
            feedEmpty.BackgroundTransparency = 1
        end
    end)
end

-- ================================================================
-- ===================== SETTINGS WINDOW ==========================
-- ================================================================
local settingsWindow
do
    local SETTINGS_H = 560
    settingsWindow = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(400, SETTINGS_H), BackgroundTransparency = 1, Visible = false, Parent = gui })
    local settCard = glass(settingsWindow, UDim2.fromScale(1, 1), nil, 20)
    settCard.ClipsDescendants = true
    local pop2 = new("UIScale", { Scale = 0.7, Parent = settCard })

    -- Header
    local settHead = new("Frame", { Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, ZIndex = 2, Parent = settCard })
    label(settHead, { Text = "Settings", Font = FK, TextSize = 15, Position = UDim2.fromOffset(16, 14), Size = UDim2.fromOffset(200, 20), ZIndex = 2 })
    label(settHead, { Text = "code redeemer  ·  listen  ·  spam", Font = FM, TextSize = 9, TextColor3 = C.dim,
        Position = UDim2.fromOffset(16, 30), Size = UDim2.fromOffset(250, 14), ZIndex = 2 })
    local closeBtn = new("TextButton", { Text = "×", Font = FB, TextSize = 18, TextColor3 = C.white,
        Size = UDim2.fromOffset(30, 30), AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -12, 0, 9), BackgroundColor3 = C.tile, BackgroundTransparency = 0.2,
        BorderSizePixel = 0, ZIndex = 2, Parent = settHead })
    corner(closeBtn, 10); stroke(closeBtn, C.line, 1, 0.3); bounce(closeBtn)
    closeBtn.MouseButton1Click:Connect(function() settingsWindow.Visible = false end)

    -- Scroll content
    local scroll = new("ScrollingFrame", { Size = UDim2.new(1, -20, 1, -60), Position = UDim2.fromOffset(10, 52),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4, ScrollBarImageColor3 = C.violet,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 2, Parent = settCard })
    new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = scroll })
    new("UIPadding", { PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4),
        PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 8), Parent = scroll })

    local orderCounter = 0
    local function nextOrder() orderCounter = orderCounter + 1; return orderCounter end

    local function sectionHeader(text)
        local h = label(scroll, { Text = text, Font = FK, TextSize = 10, TextColor3 = C.accent,
            Position = UDim2.fromOffset(6, 0), Size = UDim2.new(1, -12, 0, 14), LayoutOrder = nextOrder(), ZIndex = 3 })
    end
    local function rowFrame(height)
        local r = new("Frame", { Size = UDim2.new(1, 0, 0, height or 32), BackgroundColor3 = C.tile,
            BackgroundTransparency = 0.35, BorderSizePixel = 0, LayoutOrder = nextOrder(), ZIndex = 2, Parent = scroll })
        corner(r, 10); stroke(r, C.line, 1, 0.4)
        return r
    end
    -- Toggle switch inside row (Infin style)
    local function makeSwitch(r, initial, onChange)
        local track = new("Frame", { Size = UDim2.fromOffset(34, 18), AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -10, 0.5, 0), BackgroundColor3 = Color3.fromRGB(50, 46, 76),
            BorderSizePixel = 0, ZIndex = 3, Parent = r })
        round(track)
        local knob = new("Frame", { Size = UDim2.fromOffset(12, 12), AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0, 9, 0.5, 0), BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = 4, Parent = track })
        round(knob)
        local state = initial
        local function render()
            tween(track, 0.18, { BackgroundColor3 = state and C.violet or Color3.fromRGB(50, 46, 76) })
            tween(knob, 0.28, { Position = UDim2.new(0, state and 25 or 9, 0.5, 0) }, Enum.EasingStyle.Back)
        end
        render()
        local hit = new("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "",
            ZIndex = 5, Parent = r })
        hit.MouseButton1Click:Connect(function()
            state = not state
            render()
            if onChange then onChange(state) end
        end)
        return { set = function(v) state = v; render() end }
    end
    local function toggleRow(text, initial, onChange)
        local r = rowFrame(32)
        label(r, { Text = text, Font = FB, TextSize = 11, TextColor3 = C.white,
            Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -60, 1, 0), ZIndex = 3 })
        makeSwitch(r, initial, onChange)
        return r
    end
    -- Segmented buttons
    local function segmentedRow(labelText, options, initial, onChange)
        local r = rowFrame(32)
        label(r, { Text = labelText, Font = FB, TextSize = 10, TextColor3 = C.white,
            Position = UDim2.fromOffset(12, 0), Size = UDim2.fromOffset(70, 32), ZIndex = 3 })
        local track = new("Frame", { Size = UDim2.fromOffset(180, 24), AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -8, 0.5, 0), BackgroundColor3 = C.glass, BorderSizePixel = 0, ZIndex = 3, Parent = r })
        corner(track, 8)
        local btns = {}
        local function render(sel)
            for k, b in pairs(btns) do
                local active = k == sel
                tween(b, 0.15, { BackgroundColor3 = active and C.violet or C.glass })
                b.TextColor3 = active and C.white or C.dim
            end
            if onChange then onChange(sel) end
        end
        for i, opt in ipairs(options) do
            local key = type(opt) == "table" and opt[1] or opt
            local text = type(opt) == "table" and opt[2] or opt
            local b = new("TextButton", { Size = UDim2.new(1/#options, -2, 1, -2),
                Position = UDim2.new((i-1)/#options, 1, 0, 1), BackgroundColor3 = C.glass,
                Text = text, Font = FB, TextSize = 9, TextColor3 = C.dim, AutoButtonColor = false,
                BorderSizePixel = 0, ZIndex = 4, Parent = track })
            corner(b, 6)
            btns[key] = b
            b.MouseButton1Click:Connect(function() render(key) end)
        end
        render(initial)
        return r
    end
    -- Input row (text box + buttons)
    local function keybindRow(text, currentKey, onSetKey, onClearKey)
        local r = rowFrame(32)
        label(r, { Text = text, Font = FB, TextSize = 10, TextColor3 = C.white,
            Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -140, 1, 0), ZIndex = 3 })
        local keyBtn = new("TextButton", { Text = currentKey and currentKey.Name or "-", Font = FB, TextSize = 10,
            TextColor3 = C.white, Size = UDim2.fromOffset(46, 22), AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -84, 0.5, 0), BackgroundColor3 = C.glass,
            BorderSizePixel = 0, ZIndex = 3, Parent = r })
        corner(keyBtn, 6); stroke(keyBtn, C.line, 1, 0.4); bounce(keyBtn)
        local clrBtn = new("TextButton", { Text = "X", Font = FK, TextSize = 12, TextColor3 = C.white,
            Size = UDim2.fromOffset(24, 22), AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -32, 0.5, 0), BackgroundColor3 = C.glass,
            BorderSizePixel = 0, ZIndex = 3, Parent = r })
        corner(clrBtn, 6); stroke(clrBtn, C.line, 1, 0.4); bounce(clrBtn)
        keyBtn.MouseButton1Click:Connect(function()
            keyBtn.Text = "..."
            keyBtn.TextColor3 = C.yellow
            rebindingTarget = text:lower():find("listen") and "listen" or "redeem"
            onSetKey(keyBtn)
        end)
        clrBtn.MouseButton1Click:Connect(function()
            onClearKey()
            keyBtn.Text = "-"
            keyBtn.TextColor3 = C.white
        end)
        return r, keyBtn
    end
    -- Button row (3 buttons like COPY/CLEAR/REDEEM)
    local function buttonsRow(defs)
        local r = new("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1,
            LayoutOrder = nextOrder(), ZIndex = 2, Parent = scroll })
        new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder, Parent = r })
        for i, d in ipairs(defs) do
            local b = new("TextButton", { Text = d.text, Font = d.accent and FK or FB, TextSize = 10,
                TextColor3 = C.white, Size = UDim2.new(1/#defs, -4, 1, 0),
                BackgroundColor3 = d.accent and C.violet or C.tile,
                BackgroundTransparency = d.accent and 0 or 0.35,
                BorderSizePixel = 0, LayoutOrder = i, ZIndex = 3, Parent = r })
            corner(b, 8); stroke(b, d.accent and C.violet or C.line, 1, d.accent and 0 or 0.4)
            bounce(b)
            b.MouseButton1Click:Connect(function() if d.onClick then d.onClick(b) end end)
        end
        return r
    end

    -- ============ CODE SECTION ============
    sectionHeader("CODE REDEEMER")

    local codeRow = new("Frame", { Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = C.tile,
        BackgroundTransparency = 0.35, BorderSizePixel = 0, LayoutOrder = nextOrder(), ZIndex = 2, Parent = scroll })
    corner(codeRow, 10); stroke(codeRow, C.line, 1, 0.4)
    label(codeRow, { Text = "CODE", Font = FK, TextSize = 8, TextColor3 = C.accent,
        Position = UDim2.fromOffset(10, 4), Size = UDim2.fromOffset(60, 12), ZIndex = 3 })
    local codeInput = new("TextBox", { Size = UDim2.new(1, -20, 0, 28), Position = UDim2.fromOffset(10, 18),
        BackgroundColor3 = C.glass, Text = "", PlaceholderText = "type or snipe a code...",
        PlaceholderColor3 = C.dim, Font = FK, TextSize = 13, TextColor3 = C.white,
        ClearTextOnFocus = false, BorderSizePixel = 0, TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3, Parent = codeRow })
    corner(codeInput, 7); stroke(codeInput, C.line, 1.2, 0.3)
    new("UIPadding", { PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 9), Parent = codeInput })
    codeInput.Focused:Connect(function()
        tween(codeInput:FindFirstChildOfClass("UIStroke"), 0.12, { Color = C.violet, Transparency = 0 })
    end)
    codeInput.FocusLost:Connect(function()
        tween(codeInput:FindFirstChildOfClass("UIStroke"), 0.12, { Color = C.line, Transparency = 0.3 })
    end)

    buttonsRow({
        { text = "COPY", onClick = function(b)
            local txt = trim(codeInput.Text)
            if txt == "" then status("nothing to copy", C.red) return end
            local ok = copyToClipboard(txt)
            status(ok and ("copied: " .. txt) or "copy failed", ok and C.green or C.red)
            b.Text = ok and "OK!" or "ERR"
            task.delay(0.8, function() b.Text = "COPY" end)
        end },
        { text = "CLEAR", onClick = function()
            codeInput.Text = ""
            lastAutoTyped = nil
            listenedWords = {}
            status(isListening and "listening... (cleared)" or "cleared", C.dim)
        end },
        { text = "REDEEM", accent = true, onClick = function(b)
            b.Text = "..."
            _G.__InfinUse(codeInput.Text)
            b.Text = "REDEEM"
        end },
    })

    -- ============ LISTEN SECTION ============
    sectionHeader("LISTEN")

    toggleRow("LISTEN", isListening, function(v)
        if setListening then setListening(v) end
    end)
    toggleRow("AUTO LISTEN", autoListen, function(v) autoListen = v; cfgSet("autoListen", v) end)
    toggleRow("SPAM ON LISTEN", spamOnListen, function(v) spamOnListen = v; cfgSet("spamOnListen", v) end)

    -- ============ OPTIONS ============
    sectionHeader("OPTIONS")

    toggleRow("AUTO REDEEM", autoRedeem, function(v) autoRedeem = v; cfgSet("autoRedeem", v) end)
    toggleRow("AUTO TYPE", autoType, function(v) autoType = v; cfgSet("autoType", v) end)
    toggleRow("MANUAL MODE", manual, function(v) manual = v; cfgSet("manual", v); listenedWords = {} end)

    segmentedRow("WORDS", { "1", "2", "3", "4" }, tostring(wordsToCollect), function(v)
        wordsToCollect = tonumber(v) or 1
        listenedWords = {}
    end)
    segmentedRow("SPEED", { "MAX", { "WORD", "EVERY WORD" } },
        wordMode and "WORD" or "MAX",
        function(v)
            wordMode = v == "WORD"
            if not wordMode then maxSpamDelay = 0.15 end
            cfgSet("wordMode", wordMode)
        end)

    -- ============ KEYBINDS ============
    sectionHeader("KEYBINDS")

    local listenKeyBtnRef
    local r1, lkBtn = keybindRow("LISTEN KEY", listenKey,
        function(btn) listenKeyBtnRef = btn end,
        function()
            listenKey = nil
            rebindingTarget = nil
        end)
    listenKeyBtnRef = lkBtn

    local redeemKeyBtnRef
    local r2, rkBtn = keybindRow("REDEEM KEY", redeemKey,
        function(btn) redeemKeyBtnRef = btn end,
        function()
            redeemKey = nil
            rebindingTarget = nil
        end)
    redeemKeyBtnRef = rkBtn

    toggleRow("SHOW KEYBINDS", showKeybinds, function(v) showKeybinds = v end)
    toggleRow("IGNORE SYSTEM PHRASES", ignoreSystem, function(v) ignoreSystem = v; cfgSet("ignoreSystem", v) end)

    -- ============ FEED ============
    sectionHeader("FEED")

    buttonsRow({
        { text = "OPEN FEED", onClick = function()
            feedWindow.Visible = not feedWindow.Visible
        end },
        { text = "CLEAR FEED", onClick = function()
            for _, e in ipairs(feedEntries) do e:Destroy() end
            feedEntries, feedTotal = {}, 0
            feedCount.Text = "0 caught"
        end },
    })

    -- ============ TEST ============
    sectionHeader("TEST SENDER (fake notifications)")

    buttonsRow({
        { text = "TEST CODE", onClick = function()
            local code = "TESTCODE" .. tostring(math.random(1000, 9999))
            _G.__InfinFakeAnnounce("Use code " .. code .. " for free rewards!", nil, nil, "Top")
            status("test: " .. code, C.green)
        end },
        { text = "TEST RIDDLE", onClick = function()
            _G.__InfinFakeAnnounce("What has 4 legs in the morning and 2 in the evening?", nil, nil, "Top")
            status("test riddle sent", C.green)
        end },
    })

    -- ============ SPAM ============
    sectionHeader("SPAM")

    toggleRow("SPAM REDEEM", isSpamming, function(v)
        if v and not isListening then status("turn LISTEN on first", C.red); return end
        if setSpamming then setSpamming(v) end
    end)

    -- Show settings
    settBtn.MouseButton1Click:Connect(function()
        settingsWindow.Visible = not settingsWindow.Visible
        if settingsWindow.Visible then
            pop2.Scale = 0.7
            tween(pop2, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)
        end
    end)

    -- Draggable settings window (header)
    do
        local dragging, start, origin
        settHead.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
            dragging, start, origin = true, i.Position, settingsWindow.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end)
        UserInputService.InputChanged:Connect(function(i)
            if not dragging then return end
            if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
            local d = i.Position - start
            settingsWindow.Position = UDim2.new(origin.X.Scale, origin.X.Offset + d.X, origin.Y.Scale, origin.Y.Offset + d.Y)
        end)
    end
end

-- ================================================================
-- ===================== REDEEMER CORE LOGIC ======================
-- ================================================================
local doRedeem, spamOnWord, setCodeText, listenHint, idleHint, setListening
local handleCaptured, retryConfirm, toggleListen, setSpamming

do
    doRedeem = function(code, prefix)
        local clean = trim(code)
        if clean == "" then status("nothing to redeem", C.red); return false, false end
        prefix = prefix and (prefix .. " ") or ""
        status(("%sredeeming: %s"):format(prefix, clean), C.accent)
        local ok, res = submitCode(clean)
        local isTable = ok and type(res) == "table"
        if isTable and (res.success or res.Success) then
            status(("%sredeemed: %s"):format(prefix, clean), C.green)
        elseif isTable then
            status(("%srejected: %s"):format(prefix, clean), C.red)
        elseif ok then
            status(("%ssent: %s"):format(prefix, clean), C.accent)
        else
            status(("%sfailed: %s"):format(prefix, clean), C.red)
        end
        return ok, isTable
    end
    _G.__InfinUse = function(text)
        if _G.__InfinSetCodeText then _G.__InfinSetCodeText(text) end
        doRedeem(text)
    end

    spamOnWord = function(word)
        if isSpamming and isListening and wordMode then
            spamCount = spamCount + 1
            doRedeem(word, ("[spam %d]"):format(spamCount))
        end
    end

    local spamTick
    setSpamming = function(enabled)
        if enabled and not isListening then status("turn LISTEN on first", C.red); return end
        if enabled == isSpamming then return end
        isSpamming = enabled
        if enabled then
            spamCount = 0
            task.spawn(function()
                while isSpamming and isListening do
                    if wordMode then
                        if spamCount == 0 then status("spam - redeem on every word", C.yellow) end
                        task.wait(0.1)
                    else
                        local box = nil
                        for _, d in ipairs(PlayerGui:GetDescendants()) do
                            if d:IsA("TextBox") and d.Parent and d.Parent:IsA("Frame") then
                                -- skip: we don't have the actual codeBox reference here
                            end
                        end
                        if trim(_G.__InfinCodeText or "") == "" then
                            status("spam - waiting for a code...", C.yellow)
                        else
                            spamCount = spamCount + 1
                            doRedeem(_G.__InfinCodeText, ("[spam %d]"):format(spamCount))
                        end
                        task.wait(maxSpamDelay)
                    end
                end
                if isSpamming then setSpamming(false) end
            end)
        else
            if isListening then status("spam stopped", C.yellow) end
        end
    end

    setCodeText = function(text)
        lastAutoTyped = text
        _G.__InfinCodeText = text
        if setCodeBoxText then setCodeBoxText(text) end
        -- Also update settings input
        for _, d in ipairs(gui:GetDescendants()) do
            if d:IsA("TextBox") and d.PlaceholderText == "type or snipe a code..." then
                d.Text = text
                break
            end
        end
    end
    _G.__InfinSetCodeText = setCodeText

    listenHint = function()
        if listenKey then return "press " .. listenKey.Name .. " to fire" end
        return "tap LISTEN to fire"
    end
    idleHint = function()
        return listenKey and ("idle - press " .. listenKey.Name .. " to listen") or "idle - no listen key bound"
    end

    setListening = function(on)
        isListening = on
        if not on and isSpamming then setSpamming(false) end
        if on then
            listenedWords = {}
            if spamOnListen and not isSpamming then
                if lastAutoTyped and _G.__InfinCodeText == lastAutoTyped then
                    setCodeText("")
                end
                setSpamming(true)
            end
            if manual then status("listening... " .. listenHint(), C.yellow)
            else status(("listening... 0/%d"):format(wordsToCollect), C.yellow) end
        else
            status(idleHint(), C.dim)
        end
    end

    handleCaptured = function(code)
        if autoType then setCodeText(code) end
        if autoRedeem then doRedeem(code, "[FULL]")
        else status("captured: " .. code .. " (auto-redeem off)", C.green) end
    end

    retryConfirm = function(code)
        local clean = trim(code or "")
        if clean == "" then return end
        task.spawn(function()
            for i = 1, 3 do
                task.wait(0.5)
                spamCount = spamCount + 1
                local ok = doRedeem(clean, "[FULL]")
                status(("confirm %d/3"):format(i), ok and C.green or C.accent)
                if ok then return end
            end
        end)
    end

    toggleListen = function()
        if isListening then
            if manual then
                local joined = table.concat(listenedWords)
                setListening(false)
                if joined ~= "" then handleCaptured(joined) end
            else
                setListening(false)
            end
        else
            setListening(true)
        end
    end
end

-- ================================================================
-- ===================== ANNOUNCEMENT HANDLER =====================
-- ================================================================
local function onAnnouncement(...)
    local args = table.pack(...)
    if args.n == 0 or typeof(args[1]) ~= "string" then return end
    local text = stripTags(tostring(args[1] or ""))
    if text == "" then return end
    if isSystemPhrase(text) then return end
    local candidate = pickCodeCandidate(text)
    local code

    if autoListen and not isListening then
        code = extractCodeAfterTrigger(text)
        if code then
            setListening(true)
            if code == "" then
                status("trigger heard - waiting for the code...", C.accent)
                if feedAdd then feedAdd(text, candidate) end
                return
            end
        else
            code = text
        end
    else
        code = text
    end

    if isListening then
        for _, word in ipairs(extractWords(code)) do
            listenedWords[#listenedWords + 1] = word
            if wordMode and isSpamming then
                if manual then spamOnWord(table.concat(listenedWords))
                else
                    local take = {}
                    for i = 1, math.min(#listenedWords, wordsToCollect) do take[i] = listenedWords[i] end
                    spamOnWord(table.concat(take))
                end
            end
        end

        if manual then
            local joined = table.concat(listenedWords)
            setCodeText(joined)
            status(("listening... %d words - %s"):format(#listenedWords, listenHint()), C.yellow)
        else
            local take = {}
            for i = 1, math.min(#listenedWords, wordsToCollect) do take[i] = listenedWords[i] end
            local joined = table.concat(take)
            setCodeText(joined)
            if wordsToCollect <= #listenedWords then
                listenedWords = {}
                setListening(false)
                handleCaptured(joined)
            else
                status(("listening... %d/%d"):format(#listenedWords, wordsToCollect), C.yellow)
            end
        end
    end

    if feedAdd then feedAdd(text, candidate) end
end
_G.__InfinFakeAnnounce = onAnnouncement

-- ================================================================
-- ===================== INPUT WIRING =============================
-- ================================================================
UserInputService.InputBegan:Connect(function(input, processed)
    local t = input.UserInputType
    if not (t == Enum.UserInputType.Keyboard or t == Enum.UserInputType.Gamepad1) then return end
    if rebindingTarget == "listen" then
        rebindingTarget = nil
        if input.KeyCode ~= Enum.KeyCode.Escape then listenKey = input.KeyCode end
        -- Find the keybind button by scanning
        for _, d in ipairs(gui:GetDescendants()) do
            if d:IsA("TextButton") and d.Text == "..." and d.Parent then
                local p = d.Parent
                for _, c in ipairs(p:GetChildren()) do
                    if c:IsA("TextLabel") and c.Text == "LISTEN KEY" then
                        d.Text = listenKey and listenKey.Name or "-"
                        d.TextColor3 = C.white
                        break
                    end
                end
            end
        end
        return
    end
    if rebindingTarget == "redeem" then
        rebindingTarget = nil
        if input.KeyCode ~= Enum.KeyCode.Escape then redeemKey = input.KeyCode end
        for _, d in ipairs(gui:GetDescendants()) do
            if d:IsA("TextButton") and d.Text == "..." and d.Parent then
                local p = d.Parent
                for _, c in ipairs(p:GetChildren()) do
                    if c:IsA("TextLabel") and c.Text == "REDEEM KEY" then
                        d.Text = redeemKey and redeemKey.Name or "-"
                        d.TextColor3 = C.white
                        break
                    end
                end
            end
        end
        return
    end
    if processed then return end
    if listenKey and input.KeyCode == listenKey then toggleListen() end
    if redeemKey and input.KeyCode == redeemKey then doRedeem(_G.__InfinCodeText or "") end
end)

-- Notification remote discovery + fallback
do
    local connections = {}
    local lastText, lastAt = nil, 0
    local function throttled(...)
        local args = table.pack(...)
        local text = tostring(...)
        local now = os.clock()
        if text == lastText and now - lastAt < 0.25 then return end
        lastText, lastAt = text, now
        pcall(onAnnouncement, table.unpack(args, 1, args.n))
    end

    notifyRemote = findNotificationRemote()
    if notifyRemote then
        connections[#connections+1] = notifyRemote.OnClientEvent:Connect(throttled)
    else
        local count = 0
        for _, child in ipairs(Net:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("UnreliableRemoteEvent") then
                count = count + 1
                connections[#connections+1] = child.OnClientEvent:Connect(throttled)
                if count >= 400 then break end
            end
        end
        connections[#connections+1] = Net.ChildAdded:Connect(function(child)
            if child:IsA("RemoteEvent") or child:IsA("UnreliableRemoteEvent") then
                connections[#connections+1] = child.OnClientEvent:Connect(throttled)
            end
        end)
        remoteFallbackUsed = count > 0
    end

    getgenv().StopInfinAA = function()
        for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
        if AR.on then AR.set(false) end
        abSet(false)
        if gui then gui:Destroy() end
    end
end

-- ================================================================
-- ===================== TILES (main window) ======================
-- ================================================================
tile(1, "🛡️", "Anti Ragdoll", "anchors your character", true, function(on)
    AR.set(on)
    status(on and "anti ragdoll on  ·  you're anchored" or "anti ragdoll off", on and C.green or C.dim)
end)
tile(2, "🛒", "Auto Buy", "instant  ·  shows traits", true, function(on)
    abSet(on)
    status(on and "auto buy on  ·  scanning the belt" or "auto buy off", on and C.green or C.dim)
end)
tile(3, "⛔", "Block Events", "stops events + their music", false, function(api)
    local viaGame = blockEvents()
    api.flash("Blocked", C.green)
    status(viaGame and "events blocked" or "events muted + hidden", C.green)
end)
tile(4, "⚡", "Boost FPS", "lower graphics, no effects", false, function(api)
    boostFPS(api)
    status("FPS boosted", C.green)
end)
tile(5, "🚨", "Cash Alert", "alarm under 2x the cost", true, function(on, api)
    cashAlert(on, api)
    if not on then api.sub.Text = "alarm under 2x the cost" end
    status(on and "cash alert on" or "cash alert off", on and C.green or C.dim)
end)
tile(6, "💡", "Fullbright", "see clearly in dark events", true, function(on)
    fullbright(on)
    status(on and "fullbright on" or "fullbright off", on and C.green or C.dim)
end)

-- ================================================================
-- ===================== MINIMIZE / DRAG / STATS ==================
-- ================================================================
local mini = false
minBtn.MouseButton1Click:Connect(function()
    mini = not mini
    minPlus.Visible = mini
    tween(card, 0.38, { Size = UDim2.new(1, 0, 0, mini and MINI_H or SIZE) }, Enum.EasingStyle.Quart)
    tween(bp, 0.3, { Size = UDim2.fromOffset(210, mini and 0 or 196) })
end)

do
    local dragging, start, origin
    head.InputBegan:Connect(function(i)
        if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging, start, origin = true, i.Position, holder.Position
        i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = i.Position - start
        holder.Position = UDim2.new(origin.X.Scale, origin.X.Offset + d.X, origin.Y.Scale, origin.Y.Offset + d.Y)
    end)
end

UserInputService.InputBegan:Connect(function(i, processed)
    if not processed and i.KeyCode == Enum.KeyCode.RightShift then holder.Visible = not holder.Visible end
end)

-- Animations + FPS
do
    local frames, acc = 0, 0
    RunService.RenderStepped:Connect(function(dt)
        frames += 1
        acc += dt
        if not holder.Visible then return end
        local t = os.clock()
        rimGrad.Rotation = (t * 35) % 360
        for _, s in ipairs(sparkles) do
            s.f.BackgroundTransparency = 0.3 + (math.sin(t * s.sp + s.ph) + 1) * 0.35
        end
        if acc >= 0.5 then
            local fps = math.floor(frames / acc + 0.5)
            frames, acc = 0, 0
            local ping = "--"
            pcall(function() ping = tostring(math.floor(player:GetNetworkPing() * 1000 + 0.5)) end)
            sStats.Text = fps .. " fps  |  " .. ping .. " ms"
        end
    end)
end

-- Open
status("ready  ·  tap a tile  ·  ⚙ for redeemer", C.green)
tween(pop, 0.5, { Scale = 1 }, Enum.EasingStyle.Back)
