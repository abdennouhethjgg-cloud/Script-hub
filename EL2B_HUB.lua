local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local wasCarrying = false
local countdownActive = false

-- Persistent UI state (survives re-execute)
local savedPosition = nil
local savedLocked = false

-- Try to read saved state from a global so re-execute preserves it
if _G.E01FixerState then
	savedPosition = _G.E01FixerState.position
	savedLocked = _G.E01FixerState.locked or false
end

_G.E01FixerState = _G.E01FixerState or {}

-- Clean up old persistent UI if it exists
if _G.E01FixerCleanup then
	_G.E01FixerCleanup()
end

-- 1. Check if player is carrying an item
local function isCarrying()
	local char = LocalPlayer.Character
	if not char then return false end

	for _, child in pairs(char:GetChildren()) do
		local name = child.Name:lower()
		if name:find("brainrot") or name:find("brain") or name:find("animal") or 
			name:find("carry") or name:find("stolen") or name:find("held") or name:find("steal") then
			return true
		end
	end

	for attrName, attrValue in pairs(char:GetAttributes()) do
		local name = attrName:lower()
		if (name:find("carrying") or name:find("carry") or name:find("stealing") or 
			name:find("isstealing") or name:find("hasbrainrot")) and attrValue == true then
			return true
		end
	end

	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.WalkSpeed > 0 and humanoid.WalkSpeed <= 25 and humanoid.WalkSpeed ~= 16 then
		return true
	end

	return false
end

-- 2. Sakura-themed E01 Fixer Countdown UI
local function startE01HeadCountdown()
	if countdownActive then return end
	countdownActive = true

	local char = LocalPlayer.Character
	if not char then
		countdownActive = false
		return
	end

	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	if not playerGui then
		countdownActive = false
		return
	end

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

	-- Container frame (380x128 — less tall)
	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(0, 380, 0, 128)
	container.BackgroundTransparency = 1
	container.Parent = screenGui

	-- Use saved position (Offset-only) or default bottom-center
	local defaultX = 0.5
	local defaultXOffset = -190
	local defaultY = 1
	local defaultYOffset = -150

	local currentSavedPosition = _G.E01FixerState and _G.E01FixerState.position or nil
	if currentSavedPosition then
		container.Position = currentSavedPosition
	else
		container.Position = UDim2.new(defaultX, defaultXOffset, 1, 30)
		-- Slide-in animation
		task.spawn(function()
			task.wait(0.05)
			local slideIn = TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Position = UDim2.new(defaultX, defaultXOffset, defaultY, defaultYOffset)
			})
			slideIn:Play()
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

	-- Main gradient
	local mainGradient = Instance.new("UIGradient")
	mainGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 245, 250)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(252, 235, 245)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(248, 225, 240)),
	})
	mainGradient.Rotation = 90
	mainGradient.Parent = mainFrame

	-- === OUTLINE PROGRESS BAR ===
	-- UIStroke that depletes in thickness + shifts color during countdown
	local outline = Instance.new("UIStroke")
	outline.Color = Color3.fromRGB(255, 100, 140)
	outline.Thickness = 7
	outline.Transparency = 0
	outline.Parent = mainFrame

	-- Inner highlight stroke
	local innerStroke = Instance.new("UIStroke")
	innerStroke.Color = Color3.fromRGB(255, 255, 255)
	innerStroke.Thickness = 1
	innerStroke.Transparency = 0.5
	innerStroke.Parent = mainFrame

	-- === BOTTOM PROGRESS BAR === (clearly visible depleting bar)
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

	-- Title bar background
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

	-- Clip the bottom of title bar so only top corners are rounded
	local titleBarClip = Instance.new("Frame")
	titleBarClip.Size = UDim2.new(1, 0, 0, 16)
	titleBarClip.Position = UDim2.new(0, 0, 0, 18)
	titleBarClip.BackgroundColor3 = Color3.fromRGB(255, 235, 245)
	titleBarClip.BackgroundTransparency = 0.02
	titleBarClip.BorderSizePixel = 0
	titleBarClip.ZIndex = 1
	titleBarClip.Parent = mainFrame

	-- Title text with sakura icon
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

	-- Lock / Unlock button (pink/purple)
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

	-- Dragging logic
	local isLocked = savedLocked
	local isDragging = false
	local dragStart = nil
	local startPos = nil

	local function updateLockVisual()
		if isLocked then
			lockBtn.BackgroundColor3 = Color3.fromRGB(200, 140, 220) -- purple (locked)
			lockBtnLabel.Text = "🔒"
		else
			lockBtn.BackgroundColor3 = Color3.fromRGB(255, 130, 180) -- pink (unlocked)
			lockBtnLabel.Text = "🔓"
		end
		_G.E01FixerState.locked = isLocked
	end

	updateLockVisual()

	lockBtn.MouseButton1Click:Connect(function()
		isLocked = not isLocked
		updateLockVisual()
	end)

	-- Make the title bar the drag handle
	titleBar.InputBegan:Connect(function(input)
		if not isLocked and (
			input.UserInputType == Enum.UserInputType.MouseButton1 or
				input.UserInputType == Enum.UserInputType.Touch
			) then
			isDragging = true
			dragStart = input.Position
			startPos = container.AbsolutePosition
		end
	end)

	titleBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = false
		end
	end)

	local dragConn
	dragConn = UserInputService.InputChanged:Connect(function(input)
		if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			-- Use AbsolutePosition so Scale-based initial positions are handled correctly
			local newPosX = startPos.X + delta.X
			local newPosY = startPos.Y + delta.Y
			local newPos = UDim2.new(0, newPosX, 0, newPosY)
			container.Position = newPos
			_G.E01FixerState.position = newPos
		end
	end)

	-- Status label ("Don't pass" / "Pass")
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

	-- Countdown timer label
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

	-- Decorative sakura petals
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

	-- === COUNTDOWN LOGIC ===
	local duration = 3.0
	local startTime = tick()
	local finished = false
	local connection

	local maxThickness = 7
	local minThickness = 1.5

	connection = RunService.RenderStepped:Connect(function()
		if finished then return end

		local elapsed = tick() - startTime
		local remaining = math.max(0, duration - elapsed)
		local progress = remaining / duration -- 1 = full, 0 = empty

		if mainFrame and mainFrame.Parent then
			if remaining > 0 then
				statusLabel.Text = "Don't pass"
				statusLabel.TextColor3 = Color3.fromRGB(210, 40, 70)
				timerLabel.Text = string.format("%.1fs remaining", remaining)
				timerLabel.TextColor3 = Color3.fromRGB(120, 80, 100)

				-- Outline depletes: thickness shrinks + color shifts from pink to red
				outline.Thickness = minThickness + (maxThickness - minThickness) * progress
				local r = math.floor(255 * progress + 230 * (1 - progress))
				local g = math.floor(100 * progress + 50 * (1 - progress))
				local b = math.floor(140 * progress + 60 * (1 - progress))
				outline.Color = Color3.fromRGB(r, g, b)

				-- Bottom progress bar depletes (width shrinks from right)
				progressFill.Size = UDim2.new(progress, 0, 1, 0)
				-- Shift progress bar color from pink to red
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

				-- Outline becomes full thickness green
				outline.Thickness = maxThickness
				outline.Color = Color3.fromRGB(80, 200, 120)

				-- Progress bar fills to full green
				progressFill.Size = UDim2.new(1, 0, 1, 0)
				progressGradient.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 220, 140)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 190, 100)),
				})

				-- Fade and destroy
				task.spawn(function()
					task.wait(2.5)
					if screenGui and screenGui.Parent then
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
						for _, tween in ipairs(fadeTweens) do
							tween:Play()
						end
						fadeTweens[1].Completed:Connect(function()
							screenGui:Destroy()
							countdownActive = false
						end)
					end
				end)
			end
		end
	end)
end

-- 3. Automatic Detection
task.spawn(function()
	while task.wait(0.1) do
		local currentlyCarrying = isCarrying()

		if not wasCarrying and currentlyCarrying then
			startE01HeadCountdown()
		end

		-- Only reset wasCarrying when countdown is NOT active,
		-- so flickering detection won't restart the countdown
		if not countdownActive then
			wasCarrying = currentlyCarrying
		end
	end
end)

-- Cleanup function for re-execute
_G.E01FixerCleanup = function()
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	if playerGui and playerGui:FindFirstChild("E01FixerUI") then
		playerGui.E01FixerUI:Destroy()
	end
	countdownActive = false
	wasCarrying = false
end
