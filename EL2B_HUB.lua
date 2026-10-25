local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- === Generation token ===
-- Every execution bumps the generation; old callbacks become inert.
_G.E01FixerGen = (_G.E01FixerGen or 0) + 1
local myGen = _G.E01FixerGen
local function isCurrent() return _G.E01FixerGen == myGen end

-- === Persistent state (survives re-execute) ===
_G.E01FixerState = _G.E01FixerState or { position = nil, locked = false }

-- === Tear down any previous execution ===
if _G.E01FixerCleanup then
	_G.E01FixerCleanup()
end

-- === Per-execution state ===
local countdownActive = false
local connections = {}   -- all non-character connections
local charConns = {}     -- character-specific watchers

local function track(conn)
	table.insert(connections, conn)
	return conn
end

-- === Carrying detection ===
local function isCarryingName(name)
	name = name:lower()
	return name:find("brainrot") or name:find("brain") or name:find("animal") or
		name:find("carry") or name:find("stolen") or name:find("held") or name:find("steal")
end

local function isCarryingAttr(name)
	name = name:lower()
	return name:find("carrying") or name:find("carry") or name:find("stealing") or
		name:find("isstealing") or name:find("hasbrainrot")
end

local function isCarrying()
	local char = LocalPlayer.Character
	if not char then return false end

	for _, child in ipairs(char:GetChildren()) do
		if isCarryingName(child.Name) then
			return true
		end
	end

	for attrName, attrValue in pairs(char:GetAttributes()) do
		if attrValue == true and isCarryingAttr(attrName) then
			return true
		end
	end

	return false
end

-- === Sakura-themed E01 Fixer Countdown UI ===
local function startE01HeadCountdown()
	if countdownActive then return end

	local char = LocalPlayer.Character
	if not char then return end

	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	if not playerGui then return end

	countdownActive = true

	-- Delete old countdown UI
	local old = playerGui:FindFirstChild("E01FixerUI")
	if old then old:Destroy() end

	-- ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "E01FixerUI"
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 100
	screenGui.Parent = playerGui

	-- Container
	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(0, 380, 0, 128)
	container.BackgroundTransparency = 1
	container.Parent = screenGui

	-- Position from saved state or default bottom-center
	local defaultX = 0.5
	local defaultXOffset = -190
	local defaultY = 1
	local defaultYOffset = -150

	if _G.E01FixerState.position then
		container.Position = _G.E01FixerState.position
	else
		container.Position = UDim2.new(defaultX, defaultXOffset, 1, 30)
		task.spawn(function()
			task.wait(0.05)
			if not screenGui.Parent then return end
			TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Position = UDim2.new(defaultX, defaultXOffset, defaultY, defaultYOffset)
			}):Play()
		end)
	end

	-- Drop shadow
	local shadow = Instance.new("Frame")
	shadow.Name = "Shadow"
	shadow.Size = UDim2.new(1, 10, 1, 10)
	shadow.Position = UDim2.new(0, -5, 0, 3)
	shadow.BackgroundColor3 = Color3.fromRGB(180, 80, 110)
	shadow.BackgroundTransparency = 0.55
	shadow.BorderSizePixel = 0
	shadow.ZIndex = 0
	shadow.Parent = container

	local shadowCorner = Instance.new("UICorner")
	shadowCorner.CornerRadius = UDim.new(0, 22)
	shadowCorner.Parent = shadow

	local shadowGradient = Instance.new("UIGradient")
	shadowGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.2),
		NumberSequenceKeypoint.new(1, 1),
	})
	shadowGradient.Rotation = 90
	shadowGradient.Parent = shadow

	-- Main rounded rectangle
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(1, 0, 1, 0)
	mainFrame.BackgroundColor3 = Color3.fromRGB(255, 240, 248)
	mainFrame.BackgroundTransparency = 0.02
	mainFrame.BorderSizePixel = 0
	mainFrame.ZIndex = 1
	mainFrame.Parent = container

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 18)
	mainCorner.Parent = mainFrame

	local mainGradient = Instance.new("UIGradient")
	mainGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 245, 250)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(252, 235, 245)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(248, 225, 240)),
	})
	mainGradient.Rotation = 90
	mainGradient.Parent = mainFrame

	-- Outline progress bar (depletes in thickness + shifts to red)
	local outline = Instance.new("UIStroke")
	outline.Color = Color3.fromRGB(255, 100, 140)
	outline.Thickness = 7
	outline.Transparency = 0
	outline.Parent = mainFrame

	-- Inner highlight
	local innerStroke = Instance.new("UIStroke")
	innerStroke.Color = Color3.fromRGB(255, 255, 255)
	innerStroke.Thickness = 1
	innerStroke.Transparency = 0.5
	innerStroke.Parent = mainFrame

	-- Bottom progress bar
	local progressBg = Instance.new("Frame")
	progressBg.Name = "ProgressBg"
	progressBg.Size = UDim2.new(1, -24, 0, 6)
	progressBg.Position = UDim2.new(0, 12, 1, -14)
	progressBg.BackgroundColor3 = Color3.fromRGB(230, 200, 215)
	progressBg.BackgroundTransparency = 0.3
	progressBg.BorderSizePixel = 0
	progressBg.ZIndex = 3
	progressBg.Parent = mainFrame

	local progressBgCorner = Instance.new("UICorner")
	progressBgCorner.CornerRadius = UDim.new(1, 0)
	progressBgCorner.Parent = progressBg

	local progressFill = Instance.new("Frame")
	progressFill.Name = "ProgressFill"
	progressFill.Size = UDim2.new(1, 0, 1, 0)
	progressFill.Position = UDim2.new(0, 0, 0, 0)
	progressFill.BackgroundColor3 = Color3.fromRGB(255, 100, 140)
	progressFill.BorderSizePixel = 0
	progressFill.ZIndex = 4
	progressFill.Parent = progressBg

	local progressFillCorner = Instance.new("UICorner")
	progressFillCorner.CornerRadius = UDim.new(1, 0)
	progressFillCorner.Parent = progressFill

	local progressGradient = Instance.new("UIGradient")
	progressGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 130, 170)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 140)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 80, 120)),
	})
	progressGradient.Parent = progressFill

	-- Title bar
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 34)
	titleBar.Position = UDim2.new(0, 0, 0, 0)
	titleBar.BackgroundColor3 = Color3.fromRGB(255, 200, 220)
	titleBar.BackgroundTransparency = 0.5
	titleBar.BorderSizePixel = 0
	titleBar.ZIndex = 2
	titleBar.Parent = mainFrame

	local titleBarCorner = Instance.new("UICorner")
	titleBarCorner.CornerRadius = UDim.new(0, 18)
	titleBarCorner.Parent = titleBar

	-- Clip: squares off the bottom of the title bar (must render ON TOP of titleBar)
	local titleBarClip = Instance.new("Frame")
	titleBarClip.Size = UDim2.new(1, 0, 0, 16)
	titleBarClip.Position = UDim2.new(0, 0, 0, 18)
	titleBarClip.BackgroundColor3 = Color3.fromRGB(255, 235, 245)
	titleBarClip.BackgroundTransparency = 0.02
	titleBarClip.BorderSizePixel = 0
	titleBarClip.ZIndex = 2  -- fixed: was 1 (rendered under titleBar)
	titleBarClip.Parent = mainFrame

	-- Title text
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -60, 0, 34)
	titleLabel.Position = UDim2.new(0, 12, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "🌸 Green's E01 Fixer"
	titleLabel.TextColor3 = Color3.fromRGB(40, 25, 35)
	titleLabel.Font = Enum.Font.GothamBlack
	titleLabel.TextSize = 16
	titleLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextStrokeTransparency = 0.2
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 3
	titleLabel.Parent = mainFrame

	-- Lock button
	local lockBtn = Instance.new("TextButton")
	lockBtn.Name = "LockBtn"
	lockBtn.Size = UDim2.new(0, 34, 0, 22)
	lockBtn.Position = UDim2.new(1, -42, 0, 6)
	lockBtn.BackgroundColor3 = Color3.fromRGB(200, 140, 220)
	lockBtn.BorderSizePixel = 0
	lockBtn.Text = ""
	lockBtn.ZIndex = 4
	lockBtn.Parent = mainFrame

	local lockBtnCorner = Instance.new("UICorner")
	lockBtnCorner.CornerRadius = UDim.new(0, 8)
	lockBtnCorner.Parent = lockBtn

	local lockBtnStroke = Instance.new("UIStroke")
	lockBtnStroke.Color = Color3.fromRGB(255, 255, 255)
	lockBtnStroke.Thickness = 1.5
	lockBtnStroke.Transparency = 0.3
	lockBtnStroke.Parent = lockBtn

	local lockBtnLabel = Instance.new("TextLabel")
	lockBtnLabel.Size = UDim2.new(1, 0, 1, 0)
	lockBtnLabel.BackgroundTransparency = 1
	lockBtnLabel.Text = "🔒"
	lockBtnLabel.Font = Enum.Font.GothamBold
	lockBtnLabel.TextSize = 11
	lockBtnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	lockBtnLabel.ZIndex = 5
	lockBtnLabel.Parent = lockBtn

	-- === Drag + lock logic ===
	local isLocked = _G.E01FixerState.locked or false
	local isDragging = false
	local dragStart, startPos

	local function updateLockVisual()
		if isLocked then
			lockBtn.BackgroundColor3 = Color3.fromRGB(200, 140, 220)
			lockBtnLabel.Text = "🔒"
		else
			lockBtn.BackgroundColor3 = Color3.fromRGB(255, 130, 180)
			lockBtnLabel.Text = "🔓"
		end
		_G.E01FixerState.locked = isLocked
	end

	updateLockVisual()

	track(lockBtn.MouseButton1Click:Connect(function()
		isLocked = not isLocked
		updateLockVisual()
	end))

	track(titleBar.InputBegan:Connect(function(input)
		if not isLocked and (input.UserInputType == Enum.UserInputType.MouseButton1 or
			input.UserInputType == Enum.UserInputType.Touch) then
			isDragging = true
			dragStart = input.Position
			startPos = container.AbsolutePosition
		end
	end))

	track(titleBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
			input.UserInputType == Enum.UserInputType.Touch then
			isDragging = false
		end
	end))

	track(UserInputService.InputChanged:Connect(function(input)
		if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
			input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			local newPos = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
			container.Position = newPos
			_G.E01FixerState.position = newPos
		end
	end))

	-- Status label
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "Status"
	statusLabel.Size = UDim2.new(1, -24, 0, 32)
	statusLabel.Position = UDim2.new(0, 12, 0, 40)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Text = "Don't pass"
	statusLabel.TextColor3 = Color3.fromRGB(210, 40, 70)
	statusLabel.Font = Enum.Font.GothamBold
	statusLabel.TextSize = 20
	statusLabel.TextStrokeColor3 = Color3.fromRGB(255, 240, 245)
	statusLabel.TextStrokeTransparency = 0.3
	statusLabel.ZIndex = 3
	statusLabel.Parent = mainFrame

	-- Timer label
	local timerLabel = Instance.new("TextLabel")
	timerLabel.Name = "Timer"
	timerLabel.Size = UDim2.new(1, -24, 0, 18)
	timerLabel.Position = UDim2.new(0, 12, 0, 72)
	timerLabel.BackgroundTransparency = 1
	timerLabel.Text = ""
	timerLabel.TextColor3 = Color3.fromRGB(120, 80, 100)
	timerLabel.Font = Enum.Font.GothamMedium
	timerLabel.TextSize = 14
	timerLabel.ZIndex = 3
	timerLabel.Parent = mainFrame

	-- Decorative petals
	local function createPetal(parent, posX, posY, size, color, z)
		local petal = Instance.new("Frame")
		petal.Size = UDim2.new(0, size, 0, size)
		petal.Position = UDim2.new(0, posX, 0, posY)
		petal.BackgroundColor3 = color
		petal.BorderSizePixel = 0
		petal.ZIndex = z or 4
		petal.Parent = parent

		local petalCorner = Instance.new("UICorner")
		petalCorner.CornerRadius = UDim.new(1, 0)
		petalCorner.Parent = petal

		return petal
	end

	createPetal(mainFrame, 8, 8, 6, Color3.fromRGB(255, 170, 195))
	createPetal(mainFrame, 366, 8, 6, Color3.fromRGB(255, 170, 195))
	createPetal(mainFrame, 8, 114, 6, Color3.fromRGB(255, 180, 200))
	createPetal(mainFrame, 366, 114, 6, Color3.fromRGB(255, 180, 200))

	-- === Countdown logic ===
	local duration = 3.0
	local startTime = os.clock()
	local finished = false
	local maxThickness = 7
	local minThickness = 1.5

	local connection
	connection = RunService.RenderStepped:Connect(function()
		if finished or not isCurrent() then return end
		if not mainFrame or not mainFrame.Parent then
			finished = true
			if connection then connection:Disconnect() end
			return
		end

		local elapsed = os.clock() - startTime
		local remaining = math.max(0, duration - elapsed)
		local progress = remaining / duration

		if remaining > 0 then
			statusLabel.Text = "Don't pass"
			statusLabel.TextColor3 = Color3.fromRGB(210, 40, 70)
			timerLabel.Text = string.format("%.1fs remaining", remaining)
			timerLabel.TextColor3 = Color3.fromRGB(120, 80, 100)

			outline.Thickness = minThickness + (maxThickness - minThickness) * progress
			local r = math.floor(255 * progress + 230 * (1 - progress))
			local g = math.floor(100 * progress + 50 * (1 - progress))
			local b = math.floor(140 * progress + 60 * (1 - progress))
			outline.Color = Color3.fromRGB(r, g, b)

			progressFill.Size = UDim2.new(progress, 0, 1, 0)
			progressGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, math.floor(130 * progress + 80 * (1 - progress)), math.floor(170 * progress + 90 * (1 - progress)))),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(230, math.floor(80 * progress + 40 * (1 - progress)), math.floor(120 * progress + 60 * (1 - progress)))),
			})
		else
			finished = true
			connection:Disconnect()

			statusLabel.Text = "✓ Pass"
			statusLabel.TextColor3 = Color3.fromRGB(40, 180, 90)
			timerLabel.Text = "All clear!"
			timerLabel.TextColor3 = Color3.fromRGB(40, 160, 80)

			outline.Thickness = maxThickness
			outline.Color = Color3.fromRGB(80, 200, 120)

			progressFill.Size = UDim2.new(1, 0, 1, 0)
			progressGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 220, 140)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 190, 100)),
			})

			-- Fade & destroy after a short hold
			task.spawn(function()
				task.wait(2.5)
				if not isCurrent() then return end
				if not (screenGui and screenGui.Parent) then
					countdownActive = false
					return
				end

				local fadeTweens = {
					TweenService:Create(mainFrame, TweenInfo.new(0.5), { BackgroundTransparency = 1 }),
					TweenService:Create(titleBar, TweenInfo.new(0.5), { BackgroundTransparency = 1 }),
					TweenService:Create(titleBarClip, TweenInfo.new(0.5), { BackgroundTransparency = 1 }),
					TweenService:Create(titleLabel, TweenInfo.new(0.5), { TextTransparency = 1, TextStrokeTransparency = 1 }),
					TweenService:Create(statusLabel, TweenInfo.new(0.5), { TextTransparency = 1, TextStrokeTransparency = 1 }),
					TweenService:Create(timerLabel, TweenInfo.new(0.5), { TextTransparency = 1 }),
					TweenService:Create(outline, TweenInfo.new(0.5), { Transparency = 1 }),
					TweenService:Create(innerStroke, TweenInfo.new(0.5), { Transparency = 1 }),
					TweenService:Create(shadow, TweenInfo.new(0.5), { BackgroundTransparency = 1 }),
					TweenService:Create(lockBtn, TweenInfo.new(0.5), { BackgroundTransparency = 1 }),
					TweenService:Create(lockBtnLabel, TweenInfo.new(0.5), { TextTransparency = 1 }),
					TweenService:Create(lockBtnStroke, TweenInfo.new(0.5), { Transparency = 1 }),
					TweenService:Create(progressBg, TweenInfo.new(0.5), { BackgroundTransparency = 1 }),
					TweenService:Create(progressFill, TweenInfo.new(0.5), { BackgroundTransparency = 1 }),
				}

				track(fadeTweens[1].Completed:Connect(function()
					if screenGui and screenGui.Parent then
						screenGui:Destroy()
					end
					if isCurrent() then
						countdownActive = false
					end
				end))

				for _, tween in ipairs(fadeTweens) do
					tween:Play()
				end
			end)
		end
	end)

	track(connection)
end

-- === Signal-based detection (no polling) ===
local function watchCharacter(char)
	-- Drop previous character's watchers
	for _, conn in ipairs(charConns) do
		if conn.Connected then conn:Disconnect() end
	end
	charConns = {}

	if not char then return end

	table.insert(charConns, char.ChildAdded:Connect(function(child)
		if not isCurrent() then return end
		if countdownActive then return end
		if isCarryingName(child.Name) and isCarrying() then
			startE01HeadCountdown()
		end
	end))

	table.insert(charConns, char.AttributeChanged:Connect(function(attrName)
		if not isCurrent() then return end
		if countdownActive then return end
		if char:GetAttribute(attrName) == true and isCarryingAttr(attrName) and isCarrying() then
			startE01HeadCountdown()
		end
	end))

	-- Initial check for this character (handles "already carrying on load/respawn")
	if isCarrying() and not countdownActive then
		startE01HeadCountdown()
	end
end

track(LocalPlayer.CharacterAdded:Connect(watchCharacter))
if LocalPlayer.Character then
	watchCharacter(LocalPlayer.Character)
end

-- === Cleanup for re-execute ===
_G.E01FixerCleanup = function()
	countdownActive = false
	for _, conn in ipairs(connections) do
		if conn.Connected then conn:Disconnect() end
	end
	connections = {}
	for _, conn in ipairs(charConns) do
		if conn.Connected then conn:Disconnect() end
	end
	charConns = {}

	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	if playerGui and playerGui:FindFirstChild("E01FixerUI") then
		playerGui.E01FixerUI:Destroy()
	end
end
