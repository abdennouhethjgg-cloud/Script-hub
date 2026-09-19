-- ═══════════════════════════════════════════════════════════
-- Auto Accept 175 — UI KillXRift Edition
-- ═══════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

if not RunService:IsClient() then return end

local player = Players.LocalPlayer
if not player then return end

-- ═══════════════════════════════════════════════════════════
-- CONFIG
-- ═══════════════════════════════════════════════════════════
local CONFIG = {
	ToggleKey = Enum.KeyCode.M,
	ToggleUIKey = Enum.KeyCode.Insert,
	DefaultMode = "Normal",
	RiftImage = "",
	StartOpen = true,
}

local MODES = {
	{ Id = "Slow",   Name = "Slow",   Delay = 1.5, Info = "Slow accept loop. Safest against detection." },
	{ Id = "Normal", Name = "Normal", Delay = 0.5, Info = "Balanced accept loop. Recommended." },
	{ Id = "Fast",   Name = "Fast",   Delay = 0.1, Info = "Aggressive accept loop. Fastest but riskier." },
}

local C = {
	Panel = Color3.fromRGB(6, 8, 14),
	Card = Color3.fromRGB(4, 6, 12),
	Bar = Color3.fromRGB(8, 10, 18),
	Pill = Color3.fromRGB(12, 18, 34),
	ToggleOff = Color3.fromRGB(18, 24, 40),
	ToggleOn = Color3.fromRGB(46, 108, 230),
	KnobOff = Color3.fromRGB(148, 158, 176),
	KnobOn = Color3.fromRGB(236, 242, 252),
	Text = Color3.fromRGB(236, 242, 252),
	Muted = Color3.fromRGB(122, 138, 164),
	Power = Color3.fromRGB(138, 152, 176),
	Green = Color3.fromRGB(64, 220, 140),
	Red = Color3.fromRGB(255, 88, 88),
	Yellow = Color3.fromRGB(255, 200, 80),
	Blue = Color3.fromRGB(120, 176, 255),
}

local TWEEN_FAST = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_MED = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_SPRING = TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- ═══════════════════════════════════════════════════════════
-- HELPERS
-- ═══════════════════════════════════════════════════════════
local function tween(obj, info, props)
	local t = TweenService:Create(obj, info, props)
	t:Play()
	return t
end

local function corner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = typeof(radius) == "UDim" and radius or UDim.new(0, radius)
	c.Parent = parent
	return c
end

local function pad(parent, l, t, r, b)
	local p = Instance.new("UIPadding")
	p.PaddingLeft = UDim.new(0, l)
	p.PaddingTop = UDim.new(0, t)
	p.PaddingRight = UDim.new(0, r)
	p.PaddingBottom = UDim.new(0, b)
	p.Parent = parent
	return p
end

local function stroke(parent, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.LineJoinMode = Enum.LineJoinMode.Round
	s.Parent = parent
	return s
end

local spinning = {}

local function movingOutline(parent, thickness, speed, bright)
	local s = stroke(parent, Color3.new(1, 1, 1), thickness or 1.2, 0)
	local g = Instance.new("UIGradient")
	if bright then
		g.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(18, 28, 48)),
			ColorSequenceKeypoint.new(0.38, Color3.fromRGB(40, 80, 140)),
			ColorSequenceKeypoint.new(0.50, Color3.fromRGB(230, 242, 255)),
			ColorSequenceKeypoint.new(0.62, Color3.fromRGB(90, 170, 255)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(18, 28, 48)),
		})
		g.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0.00, 0.72),
			NumberSequenceKeypoint.new(0.40, 0.55),
			NumberSequenceKeypoint.new(0.50, 0.00),
			NumberSequenceKeypoint.new(0.60, 0.55),
			NumberSequenceKeypoint.new(1.00, 0.72),
		})
	else
		g.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(16, 24, 40)),
			ColorSequenceKeypoint.new(0.42, Color3.fromRGB(36, 58, 96)),
			ColorSequenceKeypoint.new(0.50, Color3.fromRGB(160, 198, 255)),
			ColorSequenceKeypoint.new(0.58, Color3.fromRGB(48, 86, 140)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 24, 40)),
		})
		g.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0.00, 0.82),
			NumberSequenceKeypoint.new(0.45, 0.70),
			NumberSequenceKeypoint.new(0.50, 0.18),
			NumberSequenceKeypoint.new(0.55, 0.70),
			NumberSequenceKeypoint.new(1.00, 0.82),
		})
	end
	g.Rotation = math.random(0, 359)
	g.Parent = s
	table.insert(spinning, { gradient = g, speed = speed or 48, stroke = s })
	return s, g
end

local function label(parent, props)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.BorderSizePixel = 0
	l.Font = Enum.Font.GothamBold
	l.TextColor3 = C.Text
	l.TextScaled = false
	l.RichText = false
	for k, v in pairs(props) do
		l[k] = v
	end
	l.Parent = parent
	return l
end

local function btn(parent, props)
	local b = Instance.new("TextButton")
	b.AutoButtonColor = false
	b.BorderSizePixel = 0
	b.Font = Enum.Font.GothamBold
	b.Text = ""
	b.TextColor3 = C.Text
	b.BackgroundColor3 = Color3.new(0, 0, 0)
	for k, v in pairs(props) do
		b[k] = v
	end
	b.Parent = parent
	return b
end

-- ═══════════════════════════════════════════════════════════
-- GUI BASE
-- ═══════════════════════════════════════════════════════════
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("AutoAccept175")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "AutoAccept175"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 80
gui.Parent = playerGui

local root = Instance.new("Frame")
root.Name = "Root"
root.BackgroundTransparency = 1
root.BorderSizePixel = 0
root.Size = UDim2.fromScale(1, 1)
root.Parent = gui

local uiScale = Instance.new("UIScale")
uiScale.Parent = root

local function fitScale()
	local cam = workspace.CurrentCamera
	local vs = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
	uiScale.Scale = math.clamp(math.min(vs.X / 1920, vs.Y / 1080), 0.78, 0.92)
end
fitScale()
if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitScale)
end

-- ═══════════════════════════════════════════════════════════
-- STATE
-- ═══════════════════════════════════════════════════════════
local state = {
	open = CONFIG.StartOpen,
	enabled = false,
	selected = CONFIG.DefaultMode,
	uiHidden = false,
}

local tradeAccepting = false
local tradeCount = 0

local cards = {}
local setOpen, setEnabled, selectMode, showInfo, hideInfo, toast

local PANEL_W, PANEL_H = 348, 196

-- ═══════════════════════════════════════════════════════════
-- PANEL
-- ═══════════════════════════════════════════════════════════
local panel = Instance.new("CanvasGroup")
panel.Name = "Panel"
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.Size = UDim2.fromOffset(PANEL_W, PANEL_H)
panel.BackgroundColor3 = C.Panel
panel.BackgroundTransparency = 0.04
panel.BorderSizePixel = 0
panel.ZIndex = 2
panel.Visible = state.open
panel.ClipsDescendants = true
panel.Parent = root
corner(panel, 24)
movingOutline(panel, 1.25, 36, false)

local rift = Instance.new("Frame")
rift.Name = "Rift"
rift.BackgroundColor3 = Color3.fromRGB(4, 6, 12)
rift.BorderSizePixel = 0
rift.Size = UDim2.fromScale(1, 1)
rift.ZIndex = 2
rift.ClipsDescendants = true
rift.Parent = panel
corner(rift, 24)

local function glow(size, pos, rot, color, t)
	local f = Instance.new("Frame")
	f.AnchorPoint = Vector2.new(0.5, 0.5)
	f.Position = pos
	f.Size = size
	f.Rotation = rot or 0
	f.BackgroundColor3 = color
	f.BackgroundTransparency = t or 0.84
	f.BorderSizePixel = 0
	f.ZIndex = 2
	f.Parent = rift
	corner(f, 200)
	return f
end

glow(UDim2.fromOffset(520, 380), UDim2.new(0.52, 0, 0.22, 0), 0, Color3.fromRGB(200, 220, 255), 0.86)
glow(UDim2.fromOffset(260, 260), UDim2.new(0.50, 0, 0.18, 0), 0, Color3.fromRGB(230, 240, 255), 0.80)

local function stream(x, y, w, h, rot, a)
	local f = Instance.new("Frame")
	f.AnchorPoint = Vector2.new(0.5, 0.5)
	f.Position = UDim2.new(x, 0, y, 0)
	f.Size = UDim2.fromOffset(w, h)
	f.Rotation = rot
	f.BackgroundColor3 = Color3.fromRGB(210, 226, 255)
	f.BackgroundTransparency = a
	f.BorderSizePixel = 0
	f.ZIndex = 3
	f.Parent = rift
	corner(f, 40)
	local g = Instance.new("UIGradient")
	g.Rotation = 90
	g.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.45, 0.15),
		NumberSequenceKeypoint.new(0.55, 0.15),
		NumberSequenceKeypoint.new(1, 1),
	})
	g.Parent = f
	return f
end

stream(0.50, 0.55, 70, 560, 8, 0.78)
stream(0.42, 0.58, 42, 520, -16, 0.84)
stream(0.62, 0.50, 36, 480, 22, 0.86)
stream(0.34, 0.70, 28, 400, -28, 0.88)
stream(0.70, 0.66, 24, 360, 34, 0.90)

local veil = Instance.new("Frame")
veil.Name = "Veil"
veil.BackgroundColor3 = Color3.fromRGB(4, 6, 14)
veil.BackgroundTransparency = 0.42
veil.BorderSizePixel = 0
veil.Size = UDim2.fromScale(1, 1)
veil.ZIndex = 4
veil.Parent = panel

local content = Instance.new("Frame")
content.Name = "Content"
content.BackgroundTransparency = 1
content.Size = UDim2.fromScale(1, 1)
content.ZIndex = 5
content.Parent = panel
pad(content, 10, 8, 10, 9)

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 7)
layout.Parent = content

-- ═══════════════════════════════════════════════════════════
-- HEADER
-- ═══════════════════════════════════════════════════════════
local header = Instance.new("Frame")
header.Name = "Header"
header.BackgroundTransparency = 1
header.BorderSizePixel = 0
header.Size = UDim2.new(1, 0, 0, 26)
header.LayoutOrder = 1
header.ZIndex = 8
header.Parent = content

label(header, {
	Name = "Title",
	Text = "AUTO ACCEPT 175",
	Size = UDim2.new(1, -120, 1, 0),
	Position = UDim2.fromOffset(4, 0),
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Center,
	ZIndex = 8,
})

local counterPill = label(header, {
	Name = "Counter",
	Text = "0",
	Size = UDim2.fromOffset(34, 18),
	Position = UDim2.new(1, -120, 0.5, 0),
	AnchorPoint = Vector2.new(1, 0.5),
	BackgroundColor3 = C.Pill,
	BackgroundTransparency = 0.08,
	Font = Enum.Font.GothamBold,
	TextSize = 10,
	TextColor3 = C.Blue,
	ZIndex = 9,
})
corner(counterPill, 9)
stroke(counterPill, Color3.fromRGB(36, 52, 86), 1, 0.25)

-- ⚙ Bouton toggle ENABLE (nouveau, dans le header)
local enableBtn = btn(header, {
	Name = "EnableBtn",
	Size = UDim2.fromOffset(48, 22),
	Position = UDim2.new(1, -82, 0.5, 0),
	AnchorPoint = Vector2.new(1, 0.5),
	BackgroundColor3 = Color3.fromRGB(40, 20, 20),
	Text = "OFF",
	TextSize = 10,
	TextColor3 = C.Red,
	ZIndex = 10,
})
corner(enableBtn, 8)
local enableBtnStroke = stroke(enableBtn, Color3.fromRGB(90, 40, 40), 1, 0.2)

local swords = btn(header, {
	Name = "Swords",
	Size = UDim2.fromOffset(22, 22),
	Position = UDim2.new(1, -56, 0.5, 0),
	AnchorPoint = Vector2.new(1, 0.5),
	BackgroundTransparency = 1,
	ZIndex = 9,
	Text = "⚔",
	TextSize = 13,
	TextColor3 = Color3.fromRGB(214, 196, 150),
})

local keyPill = label(header, {
	Name = "Keybind",
	Text = "M",
	Size = UDim2.fromOffset(32, 18),
	Position = UDim2.new(1, -26, 0.5, 0),
	AnchorPoint = Vector2.new(1, 0.5),
	BackgroundColor3 = C.Pill,
	BackgroundTransparency = 0.08,
	Font = Enum.Font.GothamBold,
	TextSize = 10,
	ZIndex = 9,
})
corner(keyPill, 9)
stroke(keyPill, Color3.fromRGB(36, 52, 86), 1, 0.25)

-- ═══════════════════════════════════════════════════════════
-- CARDS
-- ═══════════════════════════════════════════════════════════
local row = Instance.new("Frame")
row.Name = "Cards"
row.BackgroundTransparency = 1
row.Size = UDim2.new(1, 0, 0, 98)
row.LayoutOrder = 2
row.ZIndex = 6
row.Parent = content

local rowLayout = Instance.new("UIListLayout")
rowLayout.FillDirection = Enum.FillDirection.Horizontal
rowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
rowLayout.Padding = UDim.new(0, 6)
rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
rowLayout.Parent = row

local function makeCard(mode, order)
	local card = btn(row, {
		Name = mode.Id,
		Size = UDim2.new(1 / #MODES, -5, 1, 0),
		BackgroundColor3 = C.Card,
		BackgroundTransparency = 0.08,
		LayoutOrder = order,
		ZIndex = 6,
	})
	corner(card, 16)
	local cardStroke, cardGrad = movingOutline(card, 1.15, 42, false)

	local titleRow = Instance.new("Frame")
	titleRow.Name = "TitleRow"
	titleRow.BackgroundTransparency = 1
	titleRow.AnchorPoint = Vector2.new(0.5, 0.5)
	titleRow.Position = UDim2.new(0.5, 0, 0.40, 0)
	titleRow.AutomaticSize = Enum.AutomaticSize.XY
	titleRow.ZIndex = 7
	titleRow.Parent = card

	local trLayout = Instance.new("UIListLayout")
	trLayout.FillDirection = Enum.FillDirection.Horizontal
	trLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	trLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	trLayout.Padding = UDim.new(0, 4)
	trLayout.SortOrder = Enum.SortOrder.LayoutOrder
	trLayout.Parent = titleRow

	label(titleRow, {
		Name = "ModeName",
		Text = mode.Name,
		AutomaticSize = Enum.AutomaticSize.XY,
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		LayoutOrder = 1,
		ZIndex = 7,
	})

	local infoBtn = btn(titleRow, {
		Name = "Info",
		Size = UDim2.fromOffset(14, 14),
		BackgroundColor3 = Color3.fromRGB(10, 14, 24),
		BackgroundTransparency = 0.15,
		Text = "i",
		Font = Enum.Font.GothamBold,
		TextSize = 9,
		TextColor3 = Color3.fromRGB(186, 198, 214),
		LayoutOrder = 2,
		ZIndex = 8,
	})
	corner(infoBtn, 5)
	stroke(infoBtn, Color3.fromRGB(70, 86, 112), 1, 0.2)

	label(card, {
		Name = "Power",
		Text = "Delay " .. tostring(mode.Delay) .. "s",
		Size = UDim2.new(1, -10, 0, 14),
		Position = UDim2.new(0.5, 0, 0.66, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Font = Enum.Font.GothamMedium,
		TextSize = 10,
		TextColor3 = C.Power,
		ZIndex = 7,
	})

	cards[mode.Id] = {
		mode = mode,
		root = card,
		stroke = cardStroke,
		grad = cardGrad,
		info = infoBtn,
	}

	card.MouseEnter:Connect(function()
		if state.selected ~= mode.Id then
			tween(card, TWEEN_FAST, { BackgroundTransparency = 0.02 })
		end
	end)
	card.MouseLeave:Connect(function()
		if state.selected ~= mode.Id then
			tween(card, TWEEN_FAST, { BackgroundTransparency = 0.08 })
		end
	end)
	card.MouseButton1Click:Connect(function()
		selectMode(mode.Id)
	end)
	infoBtn.MouseButton1Click:Connect(function()
		showInfo(mode, infoBtn)
	end)

	return card
end

for i, mode in ipairs(MODES) do
	makeCard(mode, i)
end

-- ═══════════════════════════════════════════════════════════
-- BARRE ENABLE
-- ═══════════════════════════════════════════════════════════
local bar = Instance.new("Frame")
bar.Name = "EnableBar"
bar.BackgroundColor3 = C.Bar
bar.BackgroundTransparency = 0.06
bar.BorderSizePixel = 0
bar.Size = UDim2.new(1, 0, 0, 34)
bar.LayoutOrder = 3
bar.ZIndex = 6
bar.Parent = content
corner(bar, 17)
local barStroke = movingOutline(bar, 1.1, 40, false)

label(bar, {
	Name = "EnableLabel",
	Text = "ENABLE AUTO ACCEPT",
	Size = UDim2.new(1, -58, 1, 0),
	Position = UDim2.fromOffset(12, 0),
	Font = Enum.Font.GothamBold,
	TextSize = 10,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 7,
})

local toggle = btn(bar, {
	Name = "Toggle",
	Size = UDim2.fromOffset(38, 20),
	Position = UDim2.new(1, -10, 0.5, 0),
	AnchorPoint = Vector2.new(1, 0.5),
	BackgroundColor3 = C.ToggleOff,
	ZIndex = 8,
})
corner(toggle, 10)
stroke(toggle, Color3.fromRGB(32, 44, 68), 1, 0.35)

local knob = Instance.new("Frame")
knob.Name = "Knob"
knob.Size = UDim2.fromOffset(16, 16)
knob.Position = UDim2.fromOffset(2, 2)
knob.BackgroundColor3 = C.KnobOff
knob.BorderSizePixel = 0
knob.ZIndex = 9
knob.Parent = toggle
corner(knob, 8)

toggle.MouseButton1Click:Connect(function()
	setEnabled(not state.enabled)
end)

-- ═══════════════════════════════════════════════════════════
-- POPUP INFO
-- ═══════════════════════════════════════════════════════════
local pop = Instance.new("Frame")
pop.Name = "InfoPop"
pop.Visible = false
pop.BackgroundColor3 = Color3.fromRGB(8, 12, 22)
pop.BorderSizePixel = 0
pop.Size = UDim2.fromOffset(176, 72)
pop.ZIndex = 30
pop.Parent = root
corner(pop, 12)
stroke(pop, Color3.fromRGB(70, 110, 170), 1, 0.15)
movingOutline(pop, 1.3, 70, true)

local popTitle = label(pop, {
	Name = "PTitle",
	Text = "",
	Size = UDim2.new(1, -16, 0, 16),
	Position = UDim2.fromOffset(10, 8),
	TextXAlignment = Enum.TextXAlignment.Left,
	TextSize = 11,
	ZIndex = 31,
})

local popBody = label(pop, {
	Name = "PBody",
	Text = "",
	Size = UDim2.new(1, -16, 0, 40),
	Position = UDim2.fromOffset(10, 26),
	Font = Enum.Font.GothamMedium,
	TextSize = 10,
	TextColor3 = C.Muted,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
	TextWrapped = true,
	ZIndex = 31,
})

-- ═══════════════════════════════════════════════════════════
-- 📢 NOTIFICATION SYSTEM (stylé)
-- ═══════════════════════════════════════════════════════════
local notifHolder = Instance.new("Frame")
notifHolder.Name = "NotifHolder"
notifHolder.BackgroundTransparency = 1
notifHolder.AnchorPoint = Vector2.new(1, 0)
notifHolder.Position = UDim2.new(1, -12, 0, 56)
notifHolder.Size = UDim2.fromOffset(240, 400)
notifHolder.ZIndex = 60
notifHolder.Parent = root

local notifLayout = Instance.new("UIListLayout")
notifLayout.FillDirection = Enum.FillDirection.Vertical
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.Padding = UDim.new(0, 8)
notifLayout.Parent = notifHolder

local NOTIF_STYLES = {
	info    = { Icon = "ℹ", Color = C.Blue,   Bg = Color3.fromRGB(10, 22, 44) },
	success = { Icon = "✓", Color = C.Green,  Bg = Color3.fromRGB(10, 30, 20) },
	warning = { Icon = "⚠", Color = C.Yellow, Bg = Color3.fromRGB(38, 28, 6) },
	error   = { Icon = "✕", Color = C.Red,    Bg = Color3.fromRGB(38, 12, 14) },
}

local notifToken = 0

toast = function(text, style)
	style = style or "info"
	notifToken += 1
	local id = notifToken
	local def = NOTIF_STYLES[style] or NOTIF_STYLES.info

	-- Card notification
	local n = Instance.new("Frame")
	n.Name = "Notif"
	n.BackgroundColor3 = def.Bg
	n.BackgroundTransparency = 0.06
	n.BorderSizePixel = 0
	n.Size = UDim2.fromOffset(240, 42)
	n.Position = UDim2.new(1, 60, 0, 0)
	n.ZIndex = 61
	n.Parent = notifHolder
	corner(n, 10)

	local nStroke = stroke(n, def.Color, 1.2, 0.35)
	nStroke.Transparency = 0.35

	-- Barre latérale colorée
	local sideBar = Instance.new("Frame")
	sideBar.BackgroundColor3 = def.Color
	sideBar.BorderSizePixel = 0
	sideBar.Size = UDim2.new(0, 3, 1, -12)
	sideBar.Position = UDim2.new(0, 0, 0, 6)
	sideBar.ZIndex = 62
	sideBar.Parent = n
	corner(sideBar, 2)

	-- Icône
	local icon = Instance.new("TextLabel")
	icon.BackgroundTransparency = 1
	icon.Size = UDim2.fromOffset(26, 26)
	icon.Position = UDim2.fromOffset(12, 8)
	icon.Text = def.Icon
	icon.TextColor3 = def.Color
	icon.TextSize = 15
	icon.Font = Enum.Font.GothamBold
	icon.ZIndex = 62
	icon.Parent = n

	-- Texte
	local txt = Instance.new("TextLabel")
	txt.BackgroundTransparency = 1
	txt.Size = UDim2.new(1, -50, 1, 0)
	txt.Position = UDim2.fromOffset(42, 0)
	txt.Text = tostring(text)
	txt.TextColor3 = C.Text
	txt.TextSize = 11
	txt.Font = Enum.Font.GothamBold
	txt.TextXAlignment = Enum.TextXAlignment.Left
	txt.TextYAlignment = Enum.TextYAlignment.Center
	txt.ZIndex = 62
	txt.Parent = n

	-- Slide in
	tween(n, TWEEN_SPRING, { Position = UDim2.new(1, -250, 0, 0) })
	-- Fade du stroke
	task.delay(0.3, function()
		if n.Parent then
			tween(nStroke, TWEEN_MED, { Transparency = 0.35 })
		end
	end)

	-- Auto dismiss
	task.delay(2.6, function()
		if id == notifToken or n.Parent then
			tween(n, TWEEN_MED, { BackgroundTransparency = 1 })
			tween(nStroke, TWEEN_MED, { Transparency = 1 })
			tween(icon, TWEEN_MED, { TextTransparency = 1 })
			tween(txt, TWEEN_MED, { TextTransparency = 1 })
			task.wait(0.24)
			n:Destroy()
		end
	end)
end

-- ═══════════════════════════════════════════════════════════
-- FAB
-- ═══════════════════════════════════════════════════════════
local fab = btn(root, {
	Name = "Reopen",
	Visible = not state.open,
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -12, 0, 12),
	Size = UDim2.fromOffset(30, 30),
	BackgroundColor3 = C.Panel,
	Text = "⚔",
	TextSize = 13,
	TextColor3 = Color3.fromRGB(214, 196, 150),
	ZIndex = 12,
})
corner(fab, 10)
movingOutline(fab, 1.15, 55, true)

fab.MouseButton1Click:Connect(function()
	setOpen(true)
end)

-- ═══════════════════════════════════════════════════════════
-- FONCTIONS UI
-- ═══════════════════════════════════════════════════════════
hideInfo = function()
	pop.Visible = false
end

showInfo = function(mode, anchor)
	popTitle.Text = mode.Name .. "  ·  " .. tostring(mode.Delay) .. "s"
	popBody.Text = mode.Info
	local pos = anchor.AbsolutePosition
	local size = anchor.AbsoluteSize
	local rootPos = root.AbsolutePosition
	local scale = uiScale.Scale
	if scale == 0 then scale = 1 end
	local x = (pos.X - rootPos.X) / scale - 80
	local y = (pos.Y - rootPos.Y) / scale + size.Y / scale + 8
	pop.Position = UDim2.fromOffset(math.clamp(x, 12, 900), y)
	pop.Visible = true
end

local function restyleCard(id)
	local item = cards[id]
	if not item then return end
	local on = state.selected == id
	item.root.BackgroundTransparency = on and 0.02 or 0.08
	item.stroke.Thickness = on and 1.45 or 1.15
	if on then
		item.grad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(20, 40, 80)),
			ColorSequenceKeypoint.new(0.36, Color3.fromRGB(70, 140, 255)),
			ColorSequenceKeypoint.new(0.50, Color3.fromRGB(240, 248, 255)),
			ColorSequenceKeypoint.new(0.64, Color3.fromRGB(90, 180, 255)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(20, 40, 80)),
		})
		item.grad.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0.00, 0.55),
			NumberSequenceKeypoint.new(0.42, 0.28),
			NumberSequenceKeypoint.new(0.50, 0.00),
			NumberSequenceKeypoint.new(0.58, 0.28),
			NumberSequenceKeypoint.new(1.00, 0.55),
		})
	else
		item.grad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(16, 24, 40)),
			ColorSequenceKeypoint.new(0.42, Color3.fromRGB(36, 58, 96)),
			ColorSequenceKeypoint.new(0.50, Color3.fromRGB(160, 198, 255)),
			ColorSequenceKeypoint.new(0.58, Color3.fromRGB(48, 86, 140)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 24, 40)),
		})
		item.grad.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0.00, 0.82),
			NumberSequenceKeypoint.new(0.45, 0.70),
			NumberSequenceKeypoint.new(0.50, 0.18),
			NumberSequenceKeypoint.new(0.55, 0.70),
			NumberSequenceKeypoint.new(1.00, 0.82),
		})
	end
end

selectMode = function(id)
	if not cards[id] then return end
	hideInfo()
	state.selected = id
	for modeId in pairs(cards) do
		restyleCard(modeId)
	end
	if state.enabled then
		toast("Profile: " .. id, "info")
	end
end

setEnabled = function(on)
	state.enabled = on and true or false
	tradeAccepting = state.enabled

	-- Toggle switch
	tween(toggle, TWEEN_MED, {
		BackgroundColor3 = state.enabled and C.ToggleOn or C.ToggleOff,
	})
	tween(knob, TWEEN_MED, {
		Position = state.enabled and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2),
		BackgroundColor3 = state.enabled and C.KnobOn or C.KnobOff,
	})
	barStroke.Thickness = state.enabled and 1.35 or 1.1

	-- Bouton header
	enableBtn.Text = state.enabled and "ON" or "OFF"
	tween(enableBtn, TWEEN_MED, {
		BackgroundColor3 = state.enabled and Color3.fromRGB(12, 40, 26) or Color3.fromRGB(40, 20, 20),
		TextColor3 = state.enabled and C.Green or C.Red,
	})
	tween(enableBtnStroke, TWEEN_MED, {
		Color = state.enabled and Color3.fromRGB(40, 130, 80) or Color3.fromRGB(90, 40, 40),
	})

	if state.enabled then
		toast(state.selected .. " enabled", "success")
	else
		toast("Disabled", "warning")
	end
end

setOpen = function(open)
	state.open = open and true or false
	hideInfo()
	if state.open then
		panel.Visible = true
		panel.Size = UDim2.fromOffset(math.floor(PANEL_W * 0.94), math.floor(PANEL_H * 0.94))
		tween(panel, TWEEN_SPRING, { Size = UDim2.fromOffset(PANEL_W, PANEL_H) })
		fab.Visible = false
	else
		panel.Visible = false
		fab.Visible = true
	end
end

-- Bouton header enable
enableBtn.MouseButton1Click:Connect(function()
	setEnabled(not state.enabled)
end)
enableBtn.MouseEnter:Connect(function()
	tween(enableBtn, TWEEN_FAST, { BackgroundTransparency = 0.15 })
end)
enableBtn.MouseLeave:Connect(function()
	tween(enableBtn, TWEEN_FAST, { BackgroundTransparency = 0 })
end)

selectMode(state.selected)
setEnabled(false)
if not state.open then setOpen(false) end

-- ═══════════════════════════════════════════════════════════
-- DRAG + KEYBINDS
-- ═══════════════════════════════════════════════════════════
local dragging = false
local dragStart, panelCenter

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		panelCenter = panel.AbsolutePosition + panel.AbsoluteSize * 0.5
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not dragging then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
		local scale = uiScale.Scale
		if scale == 0 then scale = 1 end
		local delta = input.Position - dragStart
		local nextPos = panelCenter + Vector2.new(delta.X, delta.Y)
		local origin = root.AbsolutePosition
		panel.Position = UDim2.fromOffset(
			(nextPos.X - origin.X) / scale,
			(nextPos.Y - origin.Y) / scale
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == CONFIG.ToggleKey then
		setOpen(not state.open)
	elseif input.KeyCode == CONFIG.ToggleUIKey then
		state.uiHidden = not state.uiHidden
		gui.Enabled = not state.uiHidden
	elseif input.KeyCode == Enum.KeyCode.Escape then
		hideInfo()
	elseif input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		if pop.Visible then
			local pos = input.Position
			local p = pop.AbsolutePosition
			local s = pop.AbsoluteSize
			local inside = pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
			if not inside then hideInfo() end
		end
	end
end)

RunService.RenderStepped:Connect(function(dt)
	for _, item in ipairs(spinning) do
		if item.gradient and item.gradient.Parent then
			item.gradient.Rotation = (item.gradient.Rotation + item.speed * dt) % 360
		end
	end
end)

swords.MouseButton1Click:Connect(function()
	toast("Auto Accept 175", "info")
end)

-- ═══════════════════════════════════════════════════════════
-- 🎯 LOGIQUE AUTO-ACCEPT
-- ═══════════════════════════════════════════════════════════

local function updateCounter()
	counterPill.Text = tostring(tradeCount)
end

-- Flash du compteur quand trade comptabilisé
local function flashCounter()
	tween(counterPill, TWEEN_FAST, { TextColor3 = C.Green })
	task.delay(0.4, function()
		tween(counterPill, TWEEN_MED, { TextColor3 = C.Blue })
	end)
end

local function clickYes(prompt)
	if not tradeAccepting then return end
	local yesButton = prompt:FindFirstChild("Yes", true)
	if yesButton then
		if firesignal then
			local ok = pcall(function() firesignal(yesButton.Activated) end)
			if not ok then
				local pos = yesButton.AbsolutePosition + (yesButton.AbsoluteSize / 2)
				VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
				VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
			end
		else
			local pos = yesButton.AbsolutePosition + (yesButton.AbsoluteSize / 2)
			VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
			VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
		end
	end
end

local function acceptTrade()
	if not tradeAccepting then return end
	local pg = player.PlayerGui
	local tlt = pg:FindFirstChild("TradeLiveTrade")
	if not tlt then return end
	tlt = tlt:FindFirstChild("TradeLiveTrade")
	if not tlt then return end
	local other = tlt:FindFirstChild("Other")
	if not other then return end
	local ready = other:FindFirstChild("ReadyButton")
	if not ready then return end

	if firesignal then
		pcall(function() firesignal(ready.Activated) end)
	else
		local pos = ready.AbsolutePosition + (ready.AbsoluteSize / 2)
		VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
		VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
	end
end

local processedTexts = {}

local function checkTradeComplete(text)
	if not text or text == "" then return end
	if string.find(text, "Trade with @") and string.find(text, "completed!") then
		if processedTexts[text] then return end
		processedTexts[text] = true
		tradeCount = tradeCount + 1
		updateCounter()
		flashCounter()
		toast("Trade #" .. tradeCount .. " complete", "success")
	end
end

-- Loop d'accept
task.spawn(function()
	while task.wait(0.15) do
		if tradeAccepting then
			local ok = pcall(acceptTrade)
			if not ok then
				-- silently ignore
			end
		end
	end
end)

-- Détection via GUI
player.PlayerGui.DescendantAdded:Connect(function(obj)
	if obj:IsA("TextLabel") or obj:IsA("TextBox") then
		checkTradeComplete(obj.Text)
		obj:GetPropertyChangedSignal("Text"):Connect(function()
			checkTradeComplete(obj.Text)
		end)
	end
end)

-- Détection prompt Trade Request (avec retry)
task.spawn(function()
	while task.wait(2) do
		local promptHolder = player.PlayerGui:FindFirstChild("DuelsMachinePrompt")
		if promptHolder then
			local container = promptHolder:FindFirstChild("DuelsMachinePrompt")
			if container and not container:GetAttribute("Hooked") then
				container:SetAttribute("Hooked", true)
				container.ChildAdded:Connect(function(child)
					if child.Name == "Prompt" then
						local lbl = child:FindFirstChild("Label", true)
						if lbl and lbl.Text == "Trade Request" then
							clickYes(child)
						end
					end
				end)
			end
		end
	end
end)

-- ═══════════════════════════════════════════════════════════
-- AFK TAG
-- ═══════════════════════════════════════════════════════════
local function createAFKTag()
	local character = player.Character or player.CharacterAdded:Wait()
	local head = character:WaitForChild("Head", 5)
	if not head then return end
	if head:FindFirstChild("AFKTag") then return end
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "AFKTag"
	billboard.Size = UDim2.new(0, 180, 0, 40)
	billboard.StudsOffset = Vector3.new(0, 2.5, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = head
	local tl = Instance.new("TextLabel")
	tl.Size = UDim2.new(1, 0, 1, 0)
	tl.BackgroundTransparency = 1
	tl.Text = "Auto Accept 175 AFK"
	tl.TextColor3 = Color3.fromRGB(255, 0, 0)
	tl.TextStrokeTransparency = 0
	tl.TextScaled = true
	tl.Font = Enum.Font.GothamBold
	tl.Parent = billboard
end

pcall(createAFKTag)
player.CharacterAdded:Connect(function()
	task.wait(1)
	pcall(createAFKTag)
end)

-- ═══════════════════════════════════════════════════════════
-- Welcome
-- ═══════════════════════════════════════════════════════════
task.delay(0.4, function()
	toast("Auto Accept 175 loaded", "info")
end)
