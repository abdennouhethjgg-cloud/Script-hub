local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer or Players:WaitForChild("LocalPlayer")

-- ✅ Résolution sécurisée du parent GUI (remplace la ligne risquée)
local GUI_PARENT
do
	local ok, hui = pcall(function() return gethui and gethui() end)
	if ok and hui then
		GUI_PARENT = hui
	else
		local ok2, cg = pcall(function() return game:GetService("CoreGui") end)
		if ok2 and cg then
			GUI_PARENT = cg
		else
			GUI_PARENT = LocalPlayer:WaitForChild("PlayerGui")
		end
	end
end

local ACCENT_GREEN = Color3.fromRGB(52, 232, 128)
local ACCENT_BLUE = Color3.fromRGB(40, 200, 255)
local BG_DARK = Color3.fromRGB(8, 16, 21)
local BG_MID = Color3.fromRGB(16, 38, 46)
local BG_HEADER = Color3.fromRGB(13, 31, 40)
local TEXT_LIGHT = Color3.fromRGB(230, 255, 238)
local TEXT_DIM = Color3.fromRGB(112, 158, 160)
local STROKE_TEAL = Color3.fromRGB(64, 150, 140)

local SAVE_KEY = "SertyPvP_Save_v2"

local savedData = {
	positions = {},
	toggles = {},
	boostValue = 100,
	globalScale = 0.815
}

local function saveData()
	if not (writefile and readfile) then return end
	local ok, encoded = pcall(function()
		local t = {}
		for k, v in pairs(savedData.positions) do
			t[k] = {v.X.Scale, v.X.Offset, v.Y.Scale, v.Y.Offset}
		end
		local togs = {}
		for k, v in pairs(savedData.toggles) do
			togs[k] = v
		end
		return game:GetService("HttpService"):JSONEncode({
			positions = t,
			toggles = togs,
			boostValue = savedData.boostValue,
			globalScale = savedData.globalScale
		})
	end)
	if ok then
		pcall(function() writefile(SAVE_KEY .. ".json", encoded) end)
	end
end

local function loadData()
	if not (readfile) then return end
	local ok, raw = pcall(function() return readfile(SAVE_KEY .. ".json") end)
	if not ok or not raw or raw == "" then return end
	local ok2, decoded = pcall(function()
		return game:GetService("HttpService"):JSONDecode(raw)
	end)
	if not ok2 or not decoded then return end
	if decoded.positions then
		for k, v in pairs(decoded.positions) do
			savedData.positions[k] = UDim2.new(v[1], v[2], v[3], v[4])
		end
	end
	if decoded.toggles then
		for k, v in pairs(decoded.toggles) do
			savedData.toggles[k] = v
		end
	end
	if decoded.boostValue then savedData.boostValue = decoded.boostValue end
	if decoded.globalScale then savedData.globalScale = decoded.globalScale end
end

loadData()

local allScales = {}
local allFrames = {}

local function applyGlobalScale(val)
	savedData.globalScale = val
	for _, s in ipairs(allScales) do
		if s and s.Parent then
			s.Scale = val
		end
	end
	saveData()
end

local function makeDraggable(frame, handle)
	handle = handle or frame
	local dragging, dragStart, startPos
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
			savedData.positions[frame.Name] = frame.Position
			saveData()
		end
	end)
end

local function shimmerAnim(streakFrame)
	task.spawn(function()
		while streakFrame and streakFrame.Parent do
			TweenService:Create(streakFrame, TweenInfo.new(0, Enum.EasingStyle.Linear), {
				Position = UDim2.new(-0.5, 0, 0.5, 0)
			}):Play()
			task.wait(0.05)
			TweenService:Create(streakFrame, TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.new(1.5, 0, 0.5, 0)
			}):Play()
			task.wait(3.5)
		end
	end)
end

local function dotPulse(dot)
	task.spawn(function()
		while dot and dot.Parent do
			TweenService:Create(dot, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				BackgroundTransparency = 0.6
			}):Play()
			task.wait(0.5)
			TweenService:Create(dot, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				BackgroundTransparency = 0
			}):Play()
			task.wait(0.5)
		end
	end)
end

local function hoverGlow(btn, normalColor, hoverColor)
	normalColor = normalColor or BG_MID
	hoverColor = hoverColor or Color3.fromRGB(20, 55, 65)
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = hoverColor}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = normalColor}):Play()
	end)
end

local masterGui = Instance.new("ScreenGui")
masterGui.Name = "SertyPvP_Master"
masterGui.ResetOnSpawn = false
masterGui.DisplayOrder = 2147483645
masterGui.IgnoreGuiInset = true
-- ✅ pcall pour compatibilité vieux clients
pcall(function()
	masterGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
end)
masterGui.Parent = GUI_PARENT

local function uiCorner(r, p)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = p
	return c
end

local function uiStroke(color, thick, trans, mode, p)
	local s = Instance.new("UIStroke")
	s.Color = color
	s.Thickness = thick or 1.5
	s.Transparency = trans or 0.3
	s.ApplyStrokeMode = mode or Enum.ApplyStrokeMode.Border
	s.Parent = p
	return s
end

local function uiGradientBorder(stroke)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, ACCENT_GREEN),
		ColorSequenceKeypoint.new(0.5, ACCENT_BLUE),
		ColorSequenceKeypoint.new(1, ACCENT_GREEN)
	})
	g.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.2, 0),
		NumberSequenceKeypoint.new(0.5, 0.7, 0),
		NumberSequenceKeypoint.new(1, 0.2, 0)
	})
	g.Parent = stroke
	return g
end

local function bgGradient(p)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 27, 34)),
		ColorSequenceKeypoint.new(0.55, Color3.fromRGB(16, 32, 41)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 20, 27))
	})
	g.Rotation = 135
	g.Parent = p
	return g
end

local function headerGradient(p)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 62, 74)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 34, 44))
	})
	g.Rotation = 90
	g.Parent = p
	return g
end

local function makeShimmer(parent, radius)
	local shimFrame = Instance.new("Frame")
	shimFrame.Name = "SertyShimmer"
	shimFrame.BackgroundTransparency = 1
	shimFrame.BorderSizePixel = 0
	shimFrame.ClipsDescendants = true
	shimFrame.Size = UDim2.new(1, 0, 1, 0)
	shimFrame.ZIndex = 5
	shimFrame.Parent = parent
	uiCorner(radius or 14, shimFrame)
	local streak = Instance.new("Frame")
	streak.Name = "Streak"
	streak.AnchorPoint = Vector2.new(0.5, 0.5)
	streak.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	streak.BackgroundTransparency = 0.88
	streak.BorderSizePixel = 0
	streak.Position = UDim2.new(1.4, 0, 0.5, 0)
	streak.Rotation = 18
	streak.Size = UDim2.new(0.35, 0, 2, 0)
	streak.ZIndex = 5
	streak.Parent = shimFrame
	local g = Instance.new("UIGradient")
	g.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1, 0),
		NumberSequenceKeypoint.new(0.5, 0, 0),
		NumberSequenceKeypoint.new(1, 1, 0)
	})
	g.Parent = streak
	shimmerAnim(streak)
	return shimFrame
end

local function makeGripLines(parent)
	local sizes = {4, 8, 11}
	local positions = {{-6,-6},{-11,-11},{-15,-15}}
	for i = 1, 3 do
		local line = Instance.new("Frame")
		line.Name = "GripLine"..i
		line.AnchorPoint = Vector2.new(0.5, 0.5)
		line.BackgroundColor3 = ACCENT_GREEN
		line.BackgroundTransparency = 0.35
		line.BorderSizePixel = 0
		line.Position = UDim2.new(1, positions[i][1], 1, positions[i][2])
		line.Rotation = -45
		line.Size = UDim2.new(0, sizes[i], 0, 1)
		line.ZIndex = 51
		line.Parent = parent
		uiCorner(2, line)
	end
end

local function makeResizeGrip(parent, sz)
	sz = sz or 22
	local btn = Instance.new("TextButton")
	btn.Name = "SertyResizeGrip"
	btn.AnchorPoint = Vector2.new(1, 1)
	btn.BackgroundTransparency = 1
	btn.BorderSizePixel = 0
	btn.Position = UDim2.new(1, 0, 1, 0)
	btn.Size = UDim2.new(0, sz, 0, sz)
	btn.ZIndex = 50
	btn.AutoButtonColor = false
	btn.Text = ""
	btn.Parent = parent
	makeGripLines(btn)
	return btn
end

local function makeToggleTrack(parent, posX, posY)
	local track = Instance.new("Frame")
	track.AnchorPoint = Vector2.new(1, 0.5)
	track.BackgroundColor3 = Color3.fromRGB(34, 58, 68)
	track.BorderSizePixel = 0
	track.Position = UDim2.new(1, posX or -7, 0.5, posY or 0)
	track.Size = UDim2.new(0, 28, 0, 15)
	track.Parent = parent
	uiCorner(100, track)
	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, ACCENT_GREEN),
		ColorSequenceKeypoint.new(1, ACCENT_BLUE)
	})
	grad.Enabled = false
	grad.Parent = track
	uiStroke(STROKE_TEAL, 1, 0.5, Enum.ApplyStrokeMode.Border, track)
	local knob = Instance.new("Frame")
	knob.AnchorPoint = Vector2.new(0, 0.5)
	knob.BackgroundColor3 = Color3.fromRGB(168, 198, 204)
	knob.BorderSizePixel = 0
	knob.Position = UDim2.new(0, 2, 0.5, 0)
	knob.Size = UDim2.new(0, 11, 0, 11)
	knob.Parent = track
	uiCorner(100, knob)
	local toggled = false
	local function setToggle(val)
		toggled = val
		grad.Enabled = toggled
		if toggled then
			TweenService:Create(knob, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Position = UDim2.new(1, -13, 0.5, 0),
				BackgroundColor3 = ACCENT_GREEN
			}):Play()
			TweenService:Create(track, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(20, 60, 50)
			}):Play()
		else
			TweenService:Create(knob, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Position = UDim2.new(0, 2, 0.5, 0),
				BackgroundColor3 = Color3.fromRGB(168, 198, 204)
			}):Play()
			TweenService:Create(track, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(34, 58, 68)
			}):Play()
		end
	end
	track.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			setToggle(not toggled)
		end
	end)
	return track, function() return toggled end, setToggle
end

local function makeLockBtn(parent, posX, posY, sz)
	local btn = Instance.new("TextButton")
	btn.Name = "LockBtn"
	btn.AnchorPoint = Vector2.new(1, 0.5)
	btn.BackgroundColor3 = BG_MID
	btn.BackgroundTransparency = 0.25
	btn.BorderSizePixel = 0
	btn.Position = UDim2.new(1, posX or -26, 0.5, posY or 0)
	btn.Size = UDim2.new(0, sz or 20, 0, sz or 20)
	btn.AutoButtonColor = false
	pcall(function()
		btn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	end)
	btn.Text = "🔒"
	btn.TextColor3 = TEXT_LIGHT
	btn.TextSize = 12
	btn.TextTransparency = 0.45
	btn.Parent = parent
	uiCorner(6, btn)
	uiStroke(STROKE_TEAL, 1, 0.5, Enum.ApplyStrokeMode.Border, btn)
	local locked = false
	btn.MouseButton1Click:Connect(function()
		locked = not locked
		btn.Text = locked and "🔓" or "🔒"
		TweenService:Create(btn, TweenInfo.new(0.12), {
			BackgroundColor3 = locked and Color3.fromRGB(20, 80, 50) or BG_MID
		}):Play()
	end)
	return btn
end

local function makeCloseButton(parent, frame, offsetX, offsetY)
	offsetX = offsetX or -6
	offsetY = offsetY or 0
	local btn = Instance.new("TextButton")
	btn.Name = "CloseBtn"
	btn.AnchorPoint = Vector2.new(1, 0.5)
	btn.BackgroundColor3 = Color3.fromRGB(180, 40, 60)
	btn.BackgroundTransparency = 0.2
	btn.BorderSizePixel = 0
	btn.Position = UDim2.new(1, offsetX, 0.5, offsetY)
	btn.Size = UDim2.new(0, 16, 0, 16)
	btn.AutoButtonColor = false
	pcall(function()
		btn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
	end)
	btn.Text = "✕"
	btn.TextColor3 = Color3.fromRGB(255, 200, 200)
	btn.TextSize = 9
	btn.ZIndex = 10
	btn.Parent = parent
	uiCorner(4, btn)
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(220, 50, 70), Size = UDim2.new(0, 18, 0, 18)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(180, 40, 60), Size = UDim2.new(0, 16, 0, 16)}):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		TweenService:Create(frame, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1
		}):Play()
		task.delay(0.2, function()
			frame.Visible = false
			frame.Size = frame:GetAttribute("OriginalSize") or frame.Size
			frame.BackgroundTransparency = frame:GetAttribute("OrigBGT") or 0.36
		end)
	end)
	return btn
end

local function panelEntry(size, pos, name)
	local f = Instance.new("Frame")
	f.Name = name or "Panel"
	f.BackgroundColor3 = BG_DARK
	f.BackgroundTransparency = 0.36
	f.BorderSizePixel = 0
	f.ClipsDescendants = true
	f.Size = size
	f.Position = savedData.positions[name] or pos
	f:SetAttribute("OriginalSize", size)
	f:SetAttribute("OrigBGT", 0.36)
	bgGradient(f)
	local stroke = Instance.new("UIStroke")
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.22
	stroke.Parent = f
	uiGradientBorder(stroke)
	table.insert(allFrames, f)
	return f
end

local function panelHeader(parent, text, cornerR, headerH, textSize)
	cornerR = cornerR or 14
	headerH = headerH or 24
	textSize = textSize or 11
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.BackgroundColor3 = BG_HEADER
	header.BackgroundTransparency = 0.3
	header.BorderSizePixel = 0
	header.Size = UDim2.new(1, 0, 0, headerH)
	header.Parent = parent
	uiCorner(cornerR, header)
	headerGradient(header)
	makeShimmer(header, cornerR)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 9, 0, 0)
	label.Size = UDim2.new(1, -80, 1, 0)
	pcall(function()
		label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
	end)
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = textSize
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = header
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, ACCENT_GREEN),
		ColorSequenceKeypoint.new(0.5, ACCENT_BLUE),
		ColorSequenceKeypoint.new(1, ACCENT_GREEN)
	})
	g.Parent = label
	return header, label
end

local function addScale(frame, val, key)
	local s = Instance.new("UIScale")
	s.Scale = val or savedData.globalScale
	if key then s:SetAttribute("ScaleKey", key) end
	s.Parent = frame
	table.insert(allScales, s)
	return s
end

-- ============ WATERMARK ============
local WatermarkFrame = Instance.new("Frame")
WatermarkFrame.Name = "SertyWatermark"
WatermarkFrame.AnchorPoint = Vector2.new(0.5, 0)
WatermarkFrame.AutomaticSize = Enum.AutomaticSize.X
WatermarkFrame.BackgroundColor3 = BG_DARK
WatermarkFrame.BackgroundTransparency = 0.36
WatermarkFrame.BorderSizePixel = 0
WatermarkFrame.Position = savedData.positions["SertyWatermark"] or UDim2.new(0.5, 0, 0, 4)
WatermarkFrame.Size = UDim2.new(0, 0, 0, 30)
WatermarkFrame.Parent = masterGui
uiCorner(100, WatermarkFrame)
bgGradient(WatermarkFrame)
addScale(WatermarkFrame, savedData.globalScale, "WATERMARK")
local wmStroke = Instance.new("UIStroke")
wmStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
wmStroke.Color = Color3.fromRGB(255, 255, 255)
wmStroke.Thickness = 1.6
wmStroke.Transparency = 0.1
wmStroke.Parent = WatermarkFrame
local wmStrokeGrad = Instance.new("UIGradient")
wmStrokeGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, ACCENT_GREEN),
	ColorSequenceKeypoint.new(0.5, ACCENT_BLUE),
	ColorSequenceKeypoint.new(1, ACCENT_GREEN)
})
wmStrokeGrad.Rotation = 154.5
wmStrokeGrad.Parent = wmStroke
local wmPad = Instance.new("UIPadding")
wmPad.PaddingLeft = UDim.new(0, 13)
wmPad.PaddingRight = UDim.new(0, 15)
wmPad.Parent = WatermarkFrame
local wmList = Instance.new("UIListLayout")
wmList.FillDirection = Enum.FillDirection.Horizontal
wmList.Padding = UDim.new(0, 9)
wmList.SortOrder = Enum.SortOrder.LayoutOrder
wmList.VerticalAlignment = Enum.VerticalAlignment.Center
wmList.Parent = WatermarkFrame
local brandSection = Instance.new("Frame")
brandSection.AutomaticSize = Enum.AutomaticSize.X
brandSection.BackgroundTransparency = 1
brandSection.LayoutOrder = 1
brandSection.Size = UDim2.new(0, 0, 0, 16)
brandSection.Parent = WatermarkFrame
local brandList = Instance.new("UIListLayout")
brandList.FillDirection = Enum.FillDirection.Horizontal
brandList.Padding = UDim.new(0, 5)
brandList.SortOrder = Enum.SortOrder.LayoutOrder
brandList.VerticalAlignment = Enum.VerticalAlignment.Center
brandList.Parent = brandSection
local brandDot = Instance.new("Frame")
brandDot.BackgroundColor3 = ACCENT_GREEN
brandDot.BackgroundTransparency = 0.55
brandDot.BorderSizePixel = 0
brandDot.LayoutOrder = 1
brandDot.Size = UDim2.new(0, 8, 0, 8)
brandDot.Parent = brandSection
uiCorner(100, brandDot)
dotPulse(brandDot)
local sertyLabel = Instance.new("TextLabel")
sertyLabel.AutoLocalize = false
sertyLabel.AutomaticSize = Enum.AutomaticSize.X
sertyLabel.BackgroundTransparency = 1
sertyLabel.LayoutOrder = 2
sertyLabel.Size = UDim2.new(0, 0, 0, 14)
pcall(function()
	sertyLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
end)
sertyLabel.Text = "SERTY"
sertyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sertyLabel.TextSize = 13
sertyLabel.TextXAlignment = Enum.TextXAlignment.Left
sertyLabel.Parent = brandSection
local sertyGrad = Instance.new("UIGradient")
sertyGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, ACCENT_GREEN),
	ColorSequenceKeypoint.new(0.4, ACCENT_BLUE),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(0.6, ACCENT_BLUE),
	ColorSequenceKeypoint.new(1, ACCENT_GREEN)
})
sertyGrad.Parent = sertyLabel
local pvpLabel = Instance.new("TextLabel")
pvpLabel.AutoLocalize = false
pvpLabel.AutomaticSize = Enum.AutomaticSize.X
pvpLabel.BackgroundTransparency = 1
pvpLabel.LayoutOrder = 3
pvpLabel.Size = UDim2.new(0, 0, 0, 14)
pcall(function()
	pvpLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
end)
pvpLabel.Text = "PVP"
pvpLabel.TextColor3 = TEXT_DIM
pvpLabel.TextSize = 9
pvpLabel.TextXAlignment = Enum.TextXAlignment.Left
pvpLabel.Parent = brandSection
local divider1 = Instance.new("Frame")
divider1.BackgroundColor3 = ACCENT_BLUE
divider1.BackgroundTransparency = 0.55
divider1.BorderSizePixel = 0
divider1.LayoutOrder = 2
divider1.Size = UDim2.new(0, 1, 0, 14)
divider1.Parent = WatermarkFrame
local pingSection = Instance.new("Frame")
pingSection.AutomaticSize = Enum.AutomaticSize.X
pingSection.BackgroundTransparency = 1
pingSection.LayoutOrder = 3
pingSection.Size = UDim2.new(0, 0, 0, 16)
pingSection.Parent = WatermarkFrame
local pingList = Instance.new("UIListLayout")
pingList.FillDirection = Enum.FillDirection.Horizontal
pingList.Padding = UDim.new(0, 5)
pingList.SortOrder = Enum.SortOrder.LayoutOrder
pingList.VerticalAlignment = Enum.VerticalAlignment.Center
pingList.Parent = pingSection
local barsFrame = Instance.new("Frame")
barsFrame.BackgroundTransparency = 1
barsFrame.LayoutOrder = 1
barsFrame.Size = UDim2.new(0, 13, 0, 12)
barsFrame.Parent = pingSection
local barsLayout = Instance.new("UIListLayout")
barsLayout.FillDirection = Enum.FillDirection.Horizontal
barsLayout.Padding = UDim.new(0, 2)
barsLayout.SortOrder = Enum.SortOrder.LayoutOrder
barsLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
barsLayout.Parent = barsFrame
for i, h in ipairs({6, 9, 12}) do
	local bar = Instance.new("Frame")
	bar.BackgroundColor3 = ACCENT_GREEN
	bar.BorderSizePixel = 0
	bar.LayoutOrder = i
	bar.Size = UDim2.new(0, 3, 0, h)
	bar.Parent = barsFrame
	uiCorner(1, bar)
end
local pingWordLabel = Instance.new("TextLabel")
pingWordLabel.AutoLocalize = false
pingWordLabel.AutomaticSize = Enum.AutomaticSize.X
pingWordLabel.BackgroundTransparency = 1
pingWordLabel.LayoutOrder = 2
pingWordLabel.Size = UDim2.new(0, 0, 0, 14)
pcall(function()
	pingWordLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
end)
pingWordLabel.Text = "PING"
pingWordLabel.TextColor3 = TEXT_DIM
pingWordLabel.TextSize = 9
pingWordLabel.TextXAlignment = Enum.TextXAlignment.Left
pingWordLabel.Parent = pingSection
local pingValueLabel = Instance.new("TextLabel")
pingValueLabel.AutoLocalize = false
pingValueLabel.BackgroundTransparency = 1
pingValueLabel.LayoutOrder = 3
pingValueLabel.Size = UDim2.new(0, 46, 0, 14)
pcall(function()
	pingValueLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
end)
pingValueLabel.Text = "-- ms"
pingValueLabel.TextColor3 = ACCENT_GREEN
pingValueLabel.TextSize = 12
pingValueLabel.TextXAlignment = Enum.TextXAlignment.Left
pingValueLabel.Parent = pingSection
local divider2 = Instance.new("Frame")
divider2.BackgroundColor3 = ACCENT_BLUE
divider2.BackgroundTransparency = 0.55
divider2.BorderSizePixel = 0
divider2.LayoutOrder = 4
divider2.Size = UDim2.new(0, 1, 0, 14)
divider2.Parent = WatermarkFrame
local fpsSection = Instance.new("Frame")
fpsSection.AutomaticSize = Enum.AutomaticSize.X
fpsSection.BackgroundTransparency = 1
fpsSection.LayoutOrder = 5
fpsSection.Size = UDim2.new(0, 0, 0, 16)
fpsSection.Parent = WatermarkFrame
local fpsList = Instance.new("UIListLayout")
fpsList.FillDirection = Enum.FillDirection.Horizontal
fpsList.Padding = UDim.new(0, 5)
fpsList.SortOrder = Enum.SortOrder.LayoutOrder
fpsList.VerticalAlignment = Enum.VerticalAlignment.Center
fpsList.Parent = fpsSection
local fpsWordLabel = Instance.new("TextLabel")
fpsWordLabel.AutoLocalize = false
fpsWordLabel.AutomaticSize = Enum.AutomaticSize.X
fpsWordLabel.BackgroundTransparency = 1
fpsWordLabel.LayoutOrder = 1
fpsWordLabel.Size = UDim2.new(0, 0, 0, 14)
pcall(function()
	fpsWordLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
end)
fpsWordLabel.Text = "FPS"
fpsWordLabel.TextColor3 = TEXT_DIM
fpsWordLabel.TextSize = 9
fpsWordLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsWordLabel.Parent = fpsSection
local fpsValueLabel = Instance.new("TextLabel")
fpsValueLabel.AutoLocalize = false
fpsValueLabel.BackgroundTransparency = 1
fpsValueLabel.LayoutOrder = 2
fpsValueLabel.Size = UDim2.new(0, 24, 0, 14)
pcall(function()
	fpsValueLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
end)
fpsValueLabel.Text = "--"
fpsValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsValueLabel.TextSize = 12
fpsValueLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsValueLabel.Parent = fpsSection
makeDraggable(WatermarkFrame)

task.spawn(function()
	local frameCount = 0
	local lastTime = tick()
	RunService.Heartbeat:Connect(function()
		frameCount = frameCount + 1
		local now = tick()
		if now - lastTime >= 1 then
			fpsValueLabel.Text = tostring(math.floor(frameCount / (now - lastTime)))
			-- ✅ Ping sécurisé
			local okPing, pingVal = pcall(function()
				return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
			end)
			if okPing and pingVal then
				pingValueLabel.Text = pingVal .. " ms"
				if pingVal < 80 then
					pingValueLabel.TextColor3 = ACCENT_GREEN
				elseif pingVal < 150 then
					pingValueLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
				else
					pingValueLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
				end
			else
				pingValueLabel.Text = "-- ms"
			end
			frameCount = 0
			lastTime = now
		end
	end)
end)

-- ============ ANIMALS ============
local ANIMALS_FULL_H = 256
local ANIMALS_HEADER_H = 24
local ANIMALS_BTNS_H = 34
local ANIMALS_MINI_H = ANIMALS_HEADER_H + ANIMALS_BTNS_H + 10

local AnimalsFrame = panelEntry(UDim2.new(0, 204, 0, ANIMALS_FULL_H), UDim2.new(0, 36, 0, 138), "SertyAnimalsPanelFrame")
uiCorner(14, AnimalsFrame)
addScale(AnimalsFrame, savedData.globalScale, "ANIMALS")
AnimalsFrame.Parent = masterGui
makeResizeGrip(AnimalsFrame, 22)

local anHeader, anLabel = panelHeader(AnimalsFrame, "Animals", 14, ANIMALS_HEADER_H, 11)
makeCloseButton(anHeader, AnimalsFrame, -5, 0)
makeLockBtn(anHeader, -26, 0)

local anScroll = Instance.new("ScrollingFrame")
anScroll.Name = "AnScroll"
anScroll.Active = true
anScroll.BackgroundTransparency = 1
anScroll.BorderSizePixel = 0
anScroll.Position = UDim2.new(0, 5, 0, ANIMALS_HEADER_H + 4)
anScroll.Size = UDim2.new(1, -10, 1, -(ANIMALS_HEADER_H + 4 + ANIMALS_BTNS_H + 10))
anScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
anScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
anScroll.ElasticBehavior = Enum.ElasticBehavior.Never
anScroll.ScrollBarImageColor3 = ACCENT_BLUE
anScroll.ScrollBarThickness = 5
anScroll.ScrollingDirection = Enum.ScrollingDirection.Y
anScroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always
anScroll.Parent = AnimalsFrame
local anScrollPad = Instance.new("UIPadding")
anScrollPad.PaddingBottom = UDim.new(0, 3)
anScrollPad.PaddingLeft = UDim.new(0, 3)
anScrollPad.PaddingRight = UDim.new(0, 6)
anScrollPad.PaddingTop = UDim.new(0, 3)
anScrollPad.Parent = anScroll
local anScrollLayout = Instance.new("UIListLayout")
anScrollLayout.Padding = UDim.new(0, 4)
anScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
anScrollLayout.Parent = anScroll
local anStatusLabel = Instance.new("TextLabel")
anStatusLabel.Name = "StatusMessageLabel"
anStatusLabel.BackgroundTransparency = 1
anStatusLabel.Position = UDim2.new(0, 8, 0, ANIMALS_HEADER_H + 4)
anStatusLabel.Size = UDim2.new(1, -16, 1, -(ANIMALS_HEADER_H + 4 + ANIMALS_BTNS_H + 10))
anStatusLabel.ZIndex = 5
pcall(function()
	anStatusLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
end)
anStatusLabel.Text = "There are no animals"
anStatusLabel.TextColor3 = TEXT_DIM
anStatusLabel.TextSize = 11
anStatusLabel.TextWrapped = true
anStatusLabel.Parent = AnimalsFrame

local anActions = Instance.new("Frame")
anActions.Name = "Actions"
anActions.AnchorPoint = Vector2.new(0, 1)
anActions.BackgroundTransparency = 1
anActions.BorderSizePixel = 0
anActions.Position = UDim2.new(0, 6, 1, -5)
anActions.Size = UDim2.new(1, -12, 0, ANIMALS_BTNS_H)
anActions.Parent = AnimalsFrame

local anActLayout = Instance.new("UIListLayout")
anActLayout.FillDirection = Enum.FillDirection.Horizontal
anActLayout.Padding = UDim.new(0, 3)
anActLayout.SortOrder = Enum.SortOrder.LayoutOrder
anActLayout.VerticalAlignment = Enum.VerticalAlignment.Center
anActLayout.Parent = anActions

local function makeActionBtn(name, text, lo)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.BackgroundColor3 = BG_MID
	btn.BorderSizePixel = 0
	btn.LayoutOrder = lo
	btn.Size = UDim2.new(0.3333, -2, 1, 0)
	btn.AutoButtonColor = false
	pcall(function()
		btn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	end)
	btn.Text = text
	btn.TextColor3 = TEXT_LIGHT
	btn.TextSize = 13
	btn.TextTruncate = Enum.TextTruncate.AtEnd
	btn.Parent = anActions
	uiCorner(6, btn)
	local stroke = Instance.new("UIStroke")
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = ACCENT_GREEN
	stroke.Thickness = 1.2
	stroke.Transparency = 0.4
	stroke.Parent = btn
	local accentBar = Instance.new("Frame")
	accentBar.Name = "AccentBar"
	accentBar.AnchorPoint = Vector2.new(0, 0.5)
	accentBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	accentBar.BorderSizePixel = 0
	accentBar.Position = UDim2.new(0, 3, 0.5, 0)
	accentBar.Size = UDim2.new(0, 2, 0.5, 0)
	accentBar.Parent = btn
	local accentG = Instance.new("UIGradient")
	accentG.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, ACCENT_GREEN),
		ColorSequenceKeypoint.new(1, ACCENT_BLUE)
	})
	accentG.Rotation = 90
	accentG.Parent = accentBar
	uiCorner(100, accentBar)
	hoverGlow(btn, BG_MID, Color3.fromRGB(22, 55, 70))
	return btn
end

local flashBtn = makeActionBtn("FlashBtn", "Flash", 1)
local blockBtn = makeActionBtn("BlockBtn", "Block", 2)
local resetBtn = makeActionBtn("ResetBtn", "Reset", 3)

local anMinimized = false
local anStoredSize = UDim2.new(0, 204, 0, ANIMALS_FULL_H)
local anMinBtn = Instance.new("TextButton")
anMinBtn.Name = "MinimizeBtn"
anMinBtn.AnchorPoint = Vector2.new(1, 0.5)
anMinBtn.BackgroundColor3 = BG_MID
anMinBtn.BackgroundTransparency = 0.25
anMinBtn.BorderSizePixel = 0
anMinBtn.Position = UDim2.new(1, -48, 0.5, 0)
anMinBtn.Size = UDim2.new(0, 16, 0, 16)
anMinBtn.AutoButtonColor = false
pcall(function()
	anMinBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
end)
anMinBtn.Text = "—"
anMinBtn.TextColor3 = TEXT_LIGHT
anMinBtn.TextSize = 9
anMinBtn.ZIndex = 10
anMinBtn.Parent = anHeader
uiCorner(4, anMinBtn)
uiStroke(STROKE_TEAL, 1, 0.5, Enum.ApplyStrokeMode.Border, anMinBtn)

anMinBtn.MouseButton1Click:Connect(function()
	if not anMinimized then
		anStoredSize = AnimalsFrame.Size
		anMinimized = true
		anMinBtn.Text = "+"
		anScroll.Visible = false
		anStatusLabel.Visible = false
		anActions.Visible = true
		TweenService:Create(AnimalsFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 204, 0, ANIMALS_MINI_H)
		}):Play()
		task.delay(0.22, function()
			anActions.Position = UDim2.new(0, 6, 0, ANIMALS_HEADER_H + 4)
			anActions.Size = UDim2.new(1, -12, 0, ANIMALS_BTNS_H)
		end)
	else
		anMinimized = false
		anMinBtn.Text = "—"
		TweenService:Create(AnimalsFrame, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = anStoredSize
		}):Play()
		task.delay(0.1, function()
			anActions.Position = UDim2.new(0, 6, 1, -5)
			anActions.Size = UDim2.new(1, -12, 0, ANIMALS_BTNS_H)
			anScroll.Visible = true
			anStatusLabel.Visible = true
		end)
	end
end)

makeDraggable(AnimalsFrame, anHeader)

-- ============ QUICK SPEED ============
local CARPET_W = 200
local CARPET_H = 148
local CarpetFrame = panelEntry(UDim2.new(0, CARPET_W, 0, CARPET_H), UDim2.new(0.5, 168, 0, 38), "SertyPvPQuickSpeedFrame")
uiCorner(14, CarpetFrame)
addScale(CarpetFrame, savedData.globalScale, "CARPET")
CarpetFrame.Parent = masterGui
makeResizeGrip(CarpetFrame, 22)

local carpetHeader, carpetLabel = panelHeader(CarpetFrame, "Quick Speed", 14, 28, 11)

local carpetCloseBtn = makeCloseButton(carpetHeader, CarpetFrame, -5, 0)
local carpetLockBtn = makeLockBtn(carpetHeader, -26, 0)

local carpetBody = Instance.new("Frame")
carpetBody.Name = "Body"
carpetBody.BackgroundTransparency = 1
carpetBody.BorderSizePixel = 0
carpetBody.Position = UDim2.new(0, 6, 0, 32)
carpetBody.Size = UDim2.new(1, -12, 0, CARPET_H - 38)
carpetBody.Parent = CarpetFrame

local function makeRowToggle(parent, labelText, yPos, toggleKey)
	local row = Instance.new("Frame")
	row.BackgroundColor3 = BG_MID
	row.BackgroundTransparency = 0.25
	row.BorderSizePixel = 0
	row.Position = UDim2.new(0, 0, 0, yPos)
	row.Size = UDim2.new(1, 0, 0, 28)
	row.Parent = parent
	uiCorner(6, row)
	local stroke = Instance.new("UIStroke")
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = STROKE_TEAL
	stroke.Transparency = 0.6
	stroke.Parent = row
	local lbl = Instance.new("TextLabel")
	lbl.BackgroundTransparency = 1
	lbl.Position = UDim2.new(0, 8, 0, 0)
	lbl.Size = UDim2.new(1, -50, 1, 0)
	pcall(function()
		lbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	end)
	lbl.Text = labelText
	lbl.TextColor3 = Color3.fromRGB(222, 248, 248)
	lbl.TextSize = 11
	lbl.TextTruncate = Enum.TextTruncate.AtEnd
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = row
	local track, getState, setState = makeToggleTrack(row, -7, 0)
	if toggleKey and savedData.toggles[toggleKey] then
		setState(true)
	end
	track.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			if toggleKey then
				savedData.toggles[toggleKey] = getState()
				saveData()
			end
		end
	end)
	return row, track, getState
end

local carpetSpeedRow = makeRowToggle(carpetBody, "Carpet Speed", 0, "carpetSpeed")
local autoEquipRow = makeRowToggle(carpetBody, "Auto On Equip", 32, "autoEquip")

local boostRow = Instance.new("Frame")
boostRow.Name = "CarpetBoostRow"
boostRow.BackgroundColor3 = BG_MID
boostRow.BackgroundTransparency = 0.25
boostRow.BorderSizePixel = 0
boostRow.Position = UDim2.new(0, 0, 0, 64)
boostRow.Size = UDim2.new(1, 0, 0, 40)
boostRow.Parent = carpetBody
uiCorner(6, boostRow)
local boostStroke = Instance.new("UIStroke")
boostStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
boostStroke.Color = STROKE_TEAL
boostStroke.Transparency = 0.6
boostStroke.Parent = boostRow
local boostLbl = Instance.new("TextLabel")
boostLbl.BackgroundTransparency = 1
boostLbl.Position = UDim2.new(0, 8, 0, 4)
boostLbl.Size = UDim2.new(1, -56, 0, 16)
pcall(function()
	boostLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
end)
boostLbl.Text = "Carpet Boost"
boostLbl.TextColor3 = Color3.fromRGB(222, 248, 248)
boostLbl.TextSize = 10
boostLbl.TextXAlignment = Enum.TextXAlignment.Left
boostLbl.Parent = boostRow
local boostBox = Instance.new("TextBox")
boostBox.AnchorPoint = Vector2.new(1, 0)
boostBox.BackgroundColor3 = Color3.fromRGB(15, 36, 44)
boostBox.BorderSizePixel = 0
boostBox.Position = UDim2.new(1, -7, 0, 4)
boostBox.Size = UDim2.new(0, 40, 0, 16)
pcall(function()
	boostBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
end)
boostBox.Text = tostring(savedData.boostValue)
boostBox.TextColor3 = ACCENT_GREEN
boostBox.TextSize = 10
boostBox.ClearTextOnFocus = false
boostBox.Parent = boostRow
uiCorner(5, boostBox)
local boostBoxStroke = Instance.new("UIStroke")
boostBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
boostBoxStroke.Color = ACCENT_GREEN
boostBoxStroke.Transparency = 0.45
boostBoxStroke.Parent = boostBox

-- ✅ Forward declaration locale (au lieu de globals implicites)
local sliderFillRef, sliderKnobRef

boostBox.FocusLost:Connect(function()
	local n = tonumber(boostBox.Text)
	if n then
		n = math.clamp(n, 0, 500)
		boostBox.Text = tostring(n)
		savedData.boostValue = n
		local pct = n / 500
		-- ✅ Garde-fous
		if sliderFillRef then sliderFillRef.Size = UDim2.new(pct, 0, 1, 0) end
		if sliderKnobRef then sliderKnobRef.Position = UDim2.new(pct, 0, 0.5, 0) end
		saveData()
	else
		boostBox.Text = tostring(savedData.boostValue)
	end
end)

local sliderHit = Instance.new("TextButton")
sliderHit.Name = "SliderHitArea"
sliderHit.BackgroundTransparency = 1
sliderHit.Position = UDim2.new(0, 8, 0, 22)
sliderHit.Size = UDim2.new(1, -16, 0, 16)
sliderHit.AutoButtonColor = false
sliderHit.Text = ""
sliderHit.Parent = boostRow
local sliderTrack = Instance.new("Frame")
sliderTrack.Name = "Track"
sliderTrack.BackgroundColor3 = Color3.fromRGB(26, 58, 68)
sliderTrack.BorderSizePixel = 0
sliderTrack.Position = UDim2.new(0, 0, 0.5, -2)
sliderTrack.Size = UDim2.new(1, 0, 0, 5)
sliderTrack.Parent = sliderHit
uiCorner(100, sliderTrack)
local sliderFill = Instance.new("Frame")
sliderFill.Name = "Fill"
sliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderFill.BorderSizePixel = 0
local initPct = savedData.boostValue / 500
sliderFill.Size = UDim2.new(initPct, 0, 1, 0)
sliderFill.Parent = sliderTrack
uiCorner(100, sliderFill)
local sliderFillGrad = Instance.new("UIGradient")
sliderFillGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, ACCENT_GREEN),
	ColorSequenceKeypoint.new(1, ACCENT_BLUE)
})
sliderFillGrad.Parent = sliderFill
local sliderKnob = Instance.new("Frame")
sliderKnob.Name = "Knob"
sliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.BorderSizePixel = 0
sliderKnob.Position = UDim2.new(initPct, 0, 0.5, 0)
sliderKnob.Size = UDim2.new(0, 12, 0, 12)
sliderKnob.Parent = sliderTrack
uiCorner(100, sliderKnob)
local knobStroke = Instance.new("UIStroke")
knobStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
knobStroke.Color = ACCENT_GREEN
knobStroke.Thickness = 1.5
knobStroke.Transparency = 0.1
knobStroke.Parent = sliderKnob

-- ✅ Assignation locale (plus de pollution globale)
sliderFillRef = sliderFill
sliderKnobRef = sliderKnob

local sliderDragging = false
sliderHit.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
		sliderDragging = true
	end
end)
sliderHit.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
		sliderDragging = false
		saveData()
	end
end)
UserInputService.InputChanged:Connect(function(inp)
	if sliderDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
		local absPos = sliderTrack.AbsolutePosition.X
		local absSize = sliderTrack.AbsoluteSize.X
		if absSize <= 0 then return end
		local rel = math.clamp((inp.Position.X - absPos) / absSize, 0, 1)
		sliderFill.Size = UDim2.new(rel, 0, 1, 0)
		sliderKnob.Position = UDim2.new(rel, 0, 0.5, 0)
		local val = math.floor(500 * rel)
		boostBox.Text = tostring(val)
		savedData.boostValue = val
	end
end)

local carpetMinimized = false
local carpetStoredSize = UDim2.new(0, CARPET_W, 0, CARPET_H)
local carpetMinBtn = Instance.new("TextButton")
carpetMinBtn.Name = "MinimizeBtn"
carpetMinBtn.AnchorPoint = Vector2.new(1, 0.5)
carpetMinBtn.BackgroundColor3 = BG_MID
carpetMinBtn.BackgroundTransparency = 0.25
carpetMinBtn.BorderSizePixel = 0
carpetMinBtn.Position = UDim2.new(1, -48, 0.5, 0)
carpetMinBtn.Size = UDim2.new(0, 16, 0, 16)
carpetMinBtn.AutoButtonColor = false
pcall(function()
	carpetMinBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
end)
carpetMinBtn.Text = "—"
carpetMinBtn.TextColor3 = TEXT_LIGHT
carpetMinBtn.TextSize = 9
carpetMinBtn.ZIndex = 10
carpetMinBtn.Parent = carpetHeader
uiCorner(4, carpetMinBtn)
uiStroke(STROKE_TEAL, 1, 0.5, Enum.ApplyStrokeMode.Border, carpetMinBtn)
carpetMinBtn.MouseButton1Click:Connect(function()
	if not carpetMinimized then
		carpetStoredSize = CarpetFrame.Size
		carpetMinimized = true
		carpetMinBtn.Text = "+"
		carpetBody.Visible = false
		TweenService:Create(CarpetFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, CARPET_W, 0, 32)
		}):Play()
	else
		carpetMinimized = false
		carpetMinBtn.Text = "—"
		TweenService:Create(CarpetFrame, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = carpetStoredSize
		}):Play()
		task.delay(0.1, function() carpetBody.Visible = true end)
	end
end)

makeDraggable(CarpetFrame, carpetHeader)

-- ============ QUICK ADMIN ============
local CARPET_QA_W = 300
local CARPET_QA_H = 70
local QuickAdminFrame = panelEntry(UDim2.new(0, CARPET_QA_W, 0, CARPET_QA_H), UDim2.new(0.5, -484, 0.3, 138), "QuickAdminPanel")
uiCorner(12, QuickAdminFrame)
addScale(QuickAdminFrame, savedData.globalScale, "QA")
QuickAdminFrame.Parent = masterGui
makeResizeGrip(QuickAdminFrame, 22)

local qaHeader, qaLabel = panelHeader(QuickAdminFrame, "Quick Admin", 12, 28, 13)
makeCloseButton(qaHeader, QuickAdminFrame, -6, 0)
makeLockBtn(qaHeader, -32, 0)
local qaMinimized = false
local qaStoredSize = UDim2.new(0, CARPET_QA_W, 0, CARPET_QA_H)
local qaMinBtn = Instance.new("TextButton")
qaMinBtn.Name = "MinimizeBtn"
qaMinBtn.AnchorPoint = Vector2.new(1, 0.5)
qaMinBtn.BackgroundColor3 = BG_MID
qaMinBtn.BackgroundTransparency = 0.25
qaMinBtn.BorderSizePixel = 0
qaMinBtn.Position = UDim2.new(1, -54, 0.5, 0)
qaMinBtn.Size = UDim2.new(0, 16, 0, 16)
qaMinBtn.AutoButtonColor = false
pcall(function()
	qaMinBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
end)
qaMinBtn.Text = "—"
qaMinBtn.TextColor3 = TEXT_LIGHT
qaMinBtn.TextSize = 9
qaMinBtn.ZIndex = 10
qaMinBtn.Parent = qaHeader
uiCorner(4, qaMinBtn)
uiStroke(STROKE_TEAL, 1, 0.5, Enum.ApplyStrokeMode.Border, qaMinBtn)
local qaPlayerList = Instance.new("ScrollingFrame")
qaPlayerList.Name = "PlayerList"
qaPlayerList.Active = true
qaPlayerList.BackgroundTransparency = 1
qaPlayerList.BorderSizePixel = 0
qaPlayerList.Position = UDim2.new(0, 6, 0, 34)
qaPlayerList.Size = UDim2.new(1, -12, 0, 30)
qaPlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
qaPlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
qaPlayerList.ElasticBehavior = Enum.ElasticBehavior.Never
qaPlayerList.ScrollBarImageColor3 = ACCENT_BLUE
qaPlayerList.ScrollBarThickness = 5
qaPlayerList.ScrollingDirection = Enum.ScrollingDirection.Y
qaPlayerList.VerticalScrollBarInset = Enum.ScrollBarInset.Always
qaPlayerList.Parent = QuickAdminFrame
local qaLayout = Instance.new("UIListLayout")
qaLayout.Padding = UDim.new(0, 4)
qaLayout.SortOrder = Enum.SortOrder.LayoutOrder
qaLayout.Parent = qaPlayerList
local qaEmpty = Instance.new("Frame")
qaEmpty.Name = "Empty"
qaEmpty.BackgroundColor3 = Color3.fromRGB(15, 36, 44)
qaEmpty.BorderSizePixel = 0
qaEmpty.Size = UDim2.new(1, -4, 0, 30)
qaEmpty.Parent = qaPlayerList
uiCorner(6, qaEmpty)
local qaEmptyLabel = Instance.new("TextLabel")
qaEmptyLabel.BackgroundTransparency = 1
qaEmptyLabel.Size = UDim2.new(1, 0, 1, 0)
pcall(function()
	qaEmptyLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
end)
qaEmptyLabel.Text = "No other players"
qaEmptyLabel.TextColor3 = TEXT_DIM
qaEmptyLabel.TextSize = 11
qaEmptyLabel.Parent = qaEmpty
qaMinBtn.MouseButton1Click:Connect(function()
	if not qaMinimized then
		qaStoredSize = QuickAdminFrame.Size
		qaMinimized = true
		qaMinBtn.Text = "+"
		qaPlayerList.Visible = false
		TweenService:Create(QuickAdminFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, CARPET_QA_W, 0, 32)
		}):Play()
	else
		qaMinimized = false
		qaMinBtn.Text = "—"
		TweenService:Create(QuickAdminFrame, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = qaStoredSize
		}):Play()
		task.delay(0.1, function() qaPlayerList.Visible = true end)
	end
end)
makeDraggable(QuickAdminFrame, qaHeader)

-- ============ FLOAT BUTTONS ============
local function makeFloatButton(name, labelText, pos)
	local gui = Instance.new("Frame")
	gui.Name = name
	gui.BackgroundTransparency = 1
	gui.BorderSizePixel = 0
	gui.Position = savedData.positions[name] or pos
	gui.Size = UDim2.new(0, 148, 0, 30)
	gui.Parent = masterGui
	addScale(gui, savedData.globalScale, name)
	local lockBtn = Instance.new("TextButton")
	lockBtn.Name = "LockBtn"
	lockBtn.AnchorPoint = Vector2.new(0, 0.5)
	lockBtn.BackgroundColor3 = BG_MID
	lockBtn.BackgroundTransparency = 0.25
	lockBtn.BorderSizePixel = 0
	lockBtn.Position = UDim2.new(0, 0, 0.5, 0)
	lockBtn.Size = UDim2.new(0, 22, 0, 22)
	lockBtn.AutoButtonColor = false
	lockBtn.Text = "🔒"
	lockBtn.TextColor3 = TEXT_LIGHT
	lockBtn.TextSize = 11
	lockBtn.TextTransparency = 0.45
	lockBtn.Parent = gui
	uiCorner(6, lockBtn)
	uiStroke(STROKE_TEAL, 1, 0.5, Enum.ApplyStrokeMode.Border, lockBtn)
	local locked = false
	lockBtn.MouseButton1Click:Connect(function()
		locked = not locked
		lockBtn.Text = locked and "🔓" or "🔒"
		TweenService:Create(lockBtn, TweenInfo.new(0.12), {
			BackgroundColor3 = locked and Color3.fromRGB(20, 80, 50) or BG_MID
		}):Play()
	end)
	local mainBtn = Instance.new("TextButton")
	mainBtn.Name = "MainBtn"
	mainBtn.BackgroundColor3 = BG_MID
	mainBtn.BorderSizePixel = 0
	mainBtn.Position = UDim2.new(0, 26, 0, 0)
	mainBtn.Size = UDim2.new(1, -26, 1, 0)
	mainBtn.AutoButtonColor = false
	pcall(function()
		mainBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	end)
	mainBtn.Text = labelText
	mainBtn.TextColor3 = TEXT_LIGHT
	mainBtn.TextSize = 11
	mainBtn.Parent = gui
	uiCorner(6, mainBtn)
	local stroke = Instance.new("UIStroke")
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Thickness = 1.25
	stroke.Transparency = 0.22
	stroke.Parent = mainBtn
	uiGradientBorder(stroke)
	hoverGlow(mainBtn, BG_MID, Color3.fromRGB(22, 55, 68))
	makeResizeGrip(gui, 14)
	makeDraggable(gui)
	return gui, mainBtn
end

local swapGui, swapBtn = makeFloatButton("SwapClone", "Swap Clone", UDim2.new(0.5, 316, 0.7, -360))
local ragdollGui, ragdollBtn = makeFloatButton("RagdollTech", "Ragdoll Tech", UDim2.new(0.5, 371, 0.7, -358))
local preResetGui, preResetBtn = makeFloatButton("PreReset", "Pre Reset", UDim2.new(0.5, 350, 0.7, -236))
local dropGui, dropBtn = makeFloatButton("Drop", "Drop", UDim2.new(0.5, 332, 0.7, -188))
local allowGui, allowBtn = makeFloatButton("Allow", "Allow", UDim2.new(0.5, 341, 0.7, -282))

-- ============ STEAL BAR ============
local StealBarFrame = Instance.new("Frame")
StealBarFrame.Name = "AutoStealPvP_Bar"
StealBarFrame.AnchorPoint = Vector2.new(0.5, 1)
StealBarFrame.BackgroundColor3 = BG_DARK
StealBarFrame.BackgroundTransparency = 0.38
StealBarFrame.BorderSizePixel = 0
StealBarFrame.Position = savedData.positions["AutoStealPvP_Bar"] or UDim2.new(0.5, 0, 1, -70)
StealBarFrame.Size = UDim2.new(0, 240, 0, 46)
StealBarFrame.Parent = masterGui
uiCorner(12, StealBarFrame)
local stealStroke = Instance.new("UIStroke")
stealStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stealStroke.Color = Color3.new(0.204, 0.91, 0.502)
stealStroke.Thickness = 1.6
stealStroke.Transparency = 0.3
stealStroke.Parent = StealBarFrame
bgGradient(StealBarFrame)
addScale(StealBarFrame, savedData.globalScale, "STEAL")
local stealCaption = Instance.new("TextLabel")
stealCaption.Name = "Caption"
stealCaption.BackgroundTransparency = 1
stealCaption.Position = UDim2.new(0, 22, 0, 5)
stealCaption.Size = UDim2.new(1, -82, 0, 14)
pcall(function()
	stealCaption.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
end)
stealCaption.Text = "EMPTY SLOT"
stealCaption.TextColor3 = Color3.fromRGB(230, 255, 238)
stealCaption.TextSize = 12
stealCaption.TextTruncate = Enum.TextTruncate.AtEnd
stealCaption.TextXAlignment = Enum.TextXAlignment.Left
stealCaption.Parent = StealBarFrame
local stealPercent = Instance.new("TextLabel")
stealPercent.Name = "Percent"
stealPercent.AnchorPoint = Vector2.new(1, 0)
stealPercent.BackgroundTransparency = 1
stealPercent.Position = UDim2.new(1, -12, 0, 5)
stealPercent.Size = UDim2.new(0, 52, 0, 14)
pcall(function()
	stealPercent.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
end)
stealPercent.Text = "1.1s"
stealPercent.TextColor3 = ACCENT_GREEN
stealPercent.TextSize = 12
stealPercent.TextXAlignment = Enum.TextXAlignment.Right
stealPercent.Parent = StealBarFrame
local stealDot = Instance.new("Frame")
stealDot.Name = "StatusDot"
stealDot.AnchorPoint = Vector2.new(0, 0.5)
stealDot.BackgroundColor3 = ACCENT_GREEN
stealDot.BorderSizePixel = 0
stealDot.Position = UDim2.new(0, 11, 0, 12)
stealDot.Size = UDim2.new(0, 6, 0, 6)
stealDot.ZIndex = 3
stealDot.Parent = StealBarFrame
uiCorner(100, stealDot)
dotPulse(stealDot)
local stealTrack = Instance.new("Frame")
stealTrack.Name = "Track"
stealTrack.AnchorPoint = Vector2.new(0.5, 1)
stealTrack.BackgroundColor3 = Color3.fromRGB(16, 38, 46)
stealTrack.BackgroundTransparency = 0.35
stealTrack.BorderSizePixel = 0
stealTrack.ClipsDescendants = true
stealTrack.Position = UDim2.new(0.5, 0, 1, -8)
stealTrack.Size = UDim2.new(1, -20, 0, 9)
stealTrack.Parent = StealBarFrame
uiCorner(100, stealTrack)
local stealTrackStroke = Instance.new("UIStroke")
stealTrackStroke.Color = Color3.fromRGB(64, 150, 140)
stealTrackStroke.Transparency = 0.45
stealTrackStroke.Parent = stealTrack
local stealFill = Instance.new("Frame")
stealFill.Name = "Fill"
stealFill.BackgroundColor3 = ACCENT_GREEN
stealFill.BorderSizePixel = 0
stealFill.Size = UDim2.new(0.42, 0, 1, 0)
stealFill.Parent = stealTrack
uiCorner(100, stealFill)
local stealFillGrad = Instance.new("UIGradient")
stealFillGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(0.45, Color3.fromRGB(220,220,220)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255))
})
stealFillGrad.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.45, 0),
	NumberSequenceKeypoint.new(0.5, 0.85, 0),
	NumberSequenceKeypoint.new(1, 0.45, 0)
})
stealFillGrad.Parent = stealFill
local stealShine = Instance.new("Frame")
stealShine.Name = "Shine"
stealShine.AnchorPoint = Vector2.new(1, 0)
stealShine.BackgroundColor3 = Color3.fromRGB(255,255,255)
stealShine.BackgroundTransparency = 0.556
stealShine.BorderSizePixel = 0
stealShine.Position = UDim2.new(1, 0, 0, 0)
stealShine.Size = UDim2.new(0, 3, 1, 0)
stealShine.ZIndex = 4
stealShine.Parent = stealFill
makeDraggable(StealBarFrame)

-- ============ ANTI VOID ============
local AntiVoidFrame = Instance.new("Frame")
AntiVoidFrame.Name = "AntiVoidBar"
AntiVoidFrame.AnchorPoint = Vector2.new(0.5, 1)
AntiVoidFrame.BackgroundColor3 = BG_DARK
AntiVoidFrame.BackgroundTransparency = 0.38
AntiVoidFrame.BorderSizePixel = 0
AntiVoidFrame.Position = savedData.positions["AntiVoidBar"] or UDim2.new(0.5, 0, 1, -102)
AntiVoidFrame.Size = UDim2.new(0, 220, 0, 40)
AntiVoidFrame.Visible = true
AntiVoidFrame.Parent = masterGui
uiCorner(12, AntiVoidFrame)
local avStroke = Instance.new("UIStroke")
avStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
avStroke.Color = ACCENT_GREEN
avStroke.Thickness = 1.6
avStroke.Transparency = 0.3
avStroke.Parent = AntiVoidFrame
bgGradient(AntiVoidFrame)
addScale(AntiVoidFrame, savedData.globalScale, "ANTIVOID")
local avCaption = Instance.new("TextLabel")
avCaption.Name = "Caption"
avCaption.BackgroundTransparency = 1
avCaption.Position = UDim2.new(0, 21, 0, 4)
avCaption.Size = UDim2.new(1, -80, 0, 12)
pcall(function()
	avCaption.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
end)
avCaption.Text = "Anti Void: Enabled"
avCaption.TextColor3 = Color3.fromRGB(230, 255, 238)
avCaption.TextSize = 10
avCaption.TextTruncate = Enum.TextTruncate.AtEnd
avCaption.TextXAlignment = Enum.TextXAlignment.Left
avCaption.Parent = AntiVoidFrame
local avPercent = Instance.new("TextLabel")
avPercent.Name = "Percent"
avPercent.AnchorPoint = Vector2.new(1, 0)
avPercent.BackgroundTransparency = 1
avPercent.Position = UDim2.new(1, -10, 0, 4)
avPercent.Size = UDim2.new(0, 60, 0, 12)
pcall(function()
	avPercent.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
end)
avPercent.Text = "0%"
avPercent.TextColor3 = ACCENT_GREEN
avPercent.TextSize = 10
avPercent.TextXAlignment = Enum.TextXAlignment.Right
avPercent.Parent = AntiVoidFrame
local avDot = Instance.new("Frame")
avDot.Name = "StatusDot"
avDot.AnchorPoint = Vector2.new(0, 0.5)
avDot.BackgroundColor3 = ACCENT_GREEN
avDot.BorderSizePixel = 0
avDot.Position = UDim2.new(0, 10, 0, 10)
avDot.Size = UDim2.new(0, 6, 0, 6)
avDot.ZIndex = 3
avDot.Parent = AntiVoidFrame
uiCorner(100, avDot)
dotPulse(avDot)
local avTrack = Instance.new("Frame")
avTrack.Name = "Track"
avTrack.AnchorPoint = Vector2.new(0.5, 1)
avTrack.BackgroundColor3 = Color3.fromRGB(16, 38, 46)
avTrack.BackgroundTransparency = 0.35
avTrack.BorderSizePixel = 0
avTrack.ClipsDescendants = true
avTrack.Position = UDim2.new(0.5, 0, 1, -8)
avTrack.Size = UDim2.new(1, -20, 0, 9)
avTrack.Parent = AntiVoidFrame
uiCorner(100, avTrack)
uiStroke(Color3.fromRGB(64, 150, 140), 1, 0.45, Enum.ApplyStrokeMode.Border, avTrack)
local avFill = Instance.new("Frame")
avFill.Name = "Fill"
avFill.BackgroundColor3 = ACCENT_GREEN
avFill.BorderSizePixel = 0
avFill.Size = UDim2.new(0, 0, 1, 0)
avFill.Parent = avTrack
uiCorner(100, avFill)
local avFillGrad = Instance.new("UIGradient")
avFillGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(0.45, Color3.fromRGB(220,220,220)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255))
})
avFillGrad.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.45, 0),
	NumberSequenceKeypoint.new(0.5, 0.85, 0),
	NumberSequenceKeypoint.new(1, 0.45, 0)
})
avFillGrad.Parent = avFill
local avShine = Instance.new("Frame")
avShine.Name = "Shine"
avShine.AnchorPoint = Vector2.new(1, 0)
avShine.BackgroundColor3 = Color3.fromRGB(255,255,255)
avShine.BackgroundTransparency = 0.25
avShine.BorderSizePixel = 0
avShine.Position = UDim2.new(1, 0, 0, 0)
avShine.Size = UDim2.new(0, 3, 1, 0)
avShine.ZIndex = 4
avShine.Parent = avFill
makeDraggable(AntiVoidFrame)

-- ============ ENTRY ANIMATION ============
task.wait(0.1)
local function entryAnim(f, delay_)
	task.delay(delay_ or 0, function()
		if not f or not f.Parent then return end
		local origTrans = f.BackgroundTransparency
		f.BackgroundTransparency = 1
		TweenService:Create(f, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = origTrans
		}):Play()
	end)
end
local animList = {WatermarkFrame, QuickAdminFrame, AnimalsFrame, CarpetFrame, StealBarFrame, AntiVoidFrame, swapGui, ragdollGui, preResetGui, dropGui, allowGui}
for i, f in ipairs(animList) do
	entryAnim(f, (i - 1) * 0.04)
end

return {
	Watermark = WatermarkFrame,
	QuickAdmin = QuickAdminFrame,
	Animals = AnimalsFrame,
	QuickSpeed = CarpetFrame,
	StealBar = StealBarFrame,
	AntiVoid = AntiVoidFrame,
	SwapClone = swapGui,
	RagdollTech = ragdollGui,
	PreReset = preResetGui,
	Drop = dropGui,
	Allow = allowGui,
	ApplyGlobalScale = applyGlobalScale,
	FlashBtn = flashBtn,
	BlockBtn = blockBtn,
	ResetBtn = resetBtn,
}
