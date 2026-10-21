-- ============================================================
-- Helper GUI  |  Delta Executor
-- ============================================================

-- Nettoyage anciennes instances
if _G.__HelperGUI then pcall(function() _G.__HelperGUI:Destroy() end) end
if _G.__PodiumESPCleanup then pcall(_G.__PodiumESPCleanup) end
if _G.__NextBaseCleanup  then pcall(_G.__NextBaseCleanup)  end

local CoreGui        = game:GetService("CoreGui")
local RunService     = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local hui            = (gethui and gethui()) or CoreGui

-- ============================================================
-- GUI
-- ============================================================
local sg = Instance.new("ScreenGui")
sg.Name = "__HelperGUI"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.IgnoreGuiInset = true
sg.DisplayOrder = 999
sg.Parent = hui
_G.__HelperGUI = sg

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 160, 0, 30)
main.Position = UDim2.new(0, 20, 0, 100)
main.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = sg
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(70, 70, 90)
stroke.Thickness = 1

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Helper"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 22, 0, 22)
minBtn.Position = UDim2.new(1, -26, 0, 4)
minBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
minBtn.BorderSizePixel = 0
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 16
minBtn.Parent = titleBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 5)

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -10, 1, -35)
content.Position = UDim2.new(0, 5, 0, 32)
content.BackgroundTransparency = 1
content.Visible = false
content.Parent = main

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function makeButton(text)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, 28)
	b.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
	b.BorderSizePixel = 0
	b.Text = text
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.GothamSemibold
	b.TextSize = 12
	b.AutoButtonColor = true
	b.Parent = content
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	return b
end

local function bindClick(btn, fn)
	local last = 0
	local function run()
		local t = os.clock()
		if t - last < 0.25 then return end
		last = t
		fn()
	end
	btn.MouseButton1Click:Connect(run)
	if btn.TouchTap then btn.TouchTap:Connect(run) end
end

-- Drag
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging, dragStart, startPos = true, input.Position, main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch) then
		local d = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
		                          startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)

-- Minimize
local minimized = false
bindClick(minBtn, function()
	minimized = not minimized
	content.Visible = not minimized
	main.Size = minimized and UDim2.new(0, 160, 0, 30) or UDim2.new(0, 160, 0, 145)
	minBtn.Text = minimized and "+" or "−"
end)

-- ============================================================
-- Fonctions
-- ============================================================

-- 1) Job ID
local jobBtn = makeButton("Copy Job ID")
bindClick(jobBtn, function()
	local jobId = game.JobId
	if setclipboard then setclipboard(jobId)
	elseif toclipboard then toclipboard(jobId) end
	print("Job ID: " .. jobId)
	jobBtn.Text = "Copied!"
	task.wait(1.2)
	jobBtn.Text = "Copy Job ID"
end)

-- 2) Podium ESP
local espActive = false
local espBtn = makeButton("Podium ESP: OFF")
local function loadPodiumESP()
	local RunService = game:GetService("RunService")
	local hui = (gethui and gethui()) or game:GetService("CoreGui")
	local Plots = workspace:WaitForChild("Plots")
	local PALETTE = {
		RED    = Color3.fromRGB(255, 60, 60),
		ORANGE = Color3.fromRGB(255, 150, 40),
		YELLOW = Color3.fromRGB(255, 225, 60),
		GREEN  = Color3.fromRGB(70, 235, 110),
		CYAN   = Color3.fromRGB(55, 225, 235),
		BLUE   = Color3.fromRGB(55, 185, 255),
		PURPLE = Color3.fromRGB(175, 95, 255),
		PINK   = Color3.fromRGB(255, 95, 190),
		WHITE  = Color3.fromRGB(255, 255, 255),
		BLACK  = Color3.fromRGB(20, 20, 20),
	}
	local CFG = { FLOOR_COLOR = { PALETTE.RED, PALETTE.RED, PALETTE.RED }, COLLIDE = true }
	local FILL_T, INNER_T, MISS_T, THICK = 0.55, 0.42, 0.10, 0.05
	local PULSE_SPEED, PULSE_AMOUNT = 2, 0.12
	local TEMPLATE = {
		{ 18.500,  1.531, -14.476,  90}, { 18.500,  1.531,  -6.976,  90}, { 18.500,  1.531,   0.524,  90},
		{ 18.500,  1.531,   8.024,  90}, { 18.500,  1.531,  15.524,  90},
		{-18.536,  1.531,  15.524, -90}, {-18.536,  1.531,   8.024, -90}, {-18.536,  1.531,   0.524, -90},
		{-18.536,  1.531,  -6.976, -90}, {-18.536,  1.531, -14.476, -90},
		{ 18.500, 19.531, -14.476,  90}, { 18.500, 19.531,  -6.976,  90}, { 18.500, 19.531,   0.524,  90},
		{ 18.500, 19.531,   8.024,  90}, { 18.500, 19.531,  15.524,  90},
		{-18.380, 19.531, -14.452, -90}, {-18.380, 19.531,  -6.952, -90}, {-18.380, 19.531,   0.548, -90},
		{ 18.500, 36.531, -12.476,  90}, { 18.500, 36.531,  -4.976,  90}, { 18.500, 36.531,   2.524,  90},
		{ 18.500, 36.531,  10.024,  90}, { 18.500, 36.531,  17.524,  90},
		{-18.472, 36.531, -12.501, -90}, {-18.471, 36.531,  -5.001, -90}, {-18.471, 36.531,   2.499, -90},
		{-18.471, 36.531,   9.999, -90}, {-18.471, 36.531,  17.499, -90},
	}
	local OUTER, INNER_SZ, INNER_UP = Vector3.new(6, 0.25, 6), Vector3.new(4, 0.25, 4), 0.25
	for _, where in ipairs({workspace, game:GetService("CoreGui"), hui}) do
		for _, n in ipairs({"__PodiumMarkers", "__PodiumTest", "__PodiumCollide"}) do
			local o = where:FindFirstChild(n)
			if o then o:Destroy() end
		end
	end
	local markers, fills, conns = {}, {}, {}
	local alive = true
	local solids
	local function keep(x) markers[#markers + 1] = x; x.Parent = hui; return x end
	local function clear()
		for _, m in ipairs(markers) do pcall(function() m:Destroy() end) end
		table.clear(markers); table.clear(fills)
		if solids then solids:ClearAllChildren() end
	end
	local function box(adornee, cf, size, color, trans, isFill)
		local a = Instance.new("BoxHandleAdornment")
		a.Adornee = adornee; a.Size = size; a.CFrame = cf
		a.Color3 = color; a.Transparency = trans
		a.AlwaysOnTop = false; a.ZIndex = 0
		keep(a)
		if isFill then fills[#fills + 1] = { a = a, base = trans } end
		return a
	end
	local function outline(part, color)
		local b = Instance.new("SelectionBox")
		b.Adornee = part; b.Color3 = color; b.SurfaceColor3 = color
		b.LineThickness = THICK; b.Transparency = 0; b.SurfaceTransparency = 1
		return keep(b)
	end
	local function edges(root, cf, size, color)
		local t = THICK * 1.6
		local hx, hz, y = size.X * 0.5, size.Z * 0.5, size.Y * 0.5
		box(root, cf * CFrame.new(0, y,  hz), Vector3.new(size.X, t, t), color, 0)
		box(root, cf * CFrame.new(0, y, -hz), Vector3.new(size.X, t, t), color, 0)
		box(root, cf * CFrame.new( hx, y, 0), Vector3.new(t, t, size.Z), color, 0)
		box(root, cf * CFrame.new(-hx, y, 0), Vector3.new(t, t, size.Z), color, 0)
	end
	local function solid(worldCF)
		if not CFG.COLLIDE then return end
		if not solids then
			solids = Instance.new("Folder"); solids.Name = "__PodiumCollide"; solids.Parent = workspace
		end
		local p = Instance.new("Part")
		p.Anchored = true; p.CanCollide = true; p.CanQuery = false; p.CanTouch = false
		p.Transparency = 1; p.Size = OUTER; p.CFrame = worldCF; p.Parent = solids
	end
	local function colorFor(i)
		if i <= 10 then return CFG.FLOOR_COLOR[1]
		elseif i <= 18 then return CFG.FLOOR_COLOR[2] end
		return CFG.FLOOR_COLOR[3]
	end
	local function slabsOf(slot)
		local base = slot:FindFirstChild("Base") or slot
		local decos = base:FindFirstChild("Decorations")
		local parts = {}
		if decos then
			for _, c in ipairs(decos:GetChildren()) do
				if c:IsA("BasePart") and c.Transparency < 1 then parts[#parts + 1] = c end
			end
		end
		table.sort(parts, function(a, b) return a.Size.X * a.Size.Z > b.Size.X * b.Size.Z end)
		return parts
	end
	local function drawReal(parts, color)
		local anchor = parts[1]
		for i, p in ipairs(parts) do
			local rel = anchor.CFrame:Inverse() * p.CFrame
			box(anchor, rel, p.Size + Vector3.new(0.03, 0.03, 0.03), color, i == 1 and FILL_T or INNER_T, true)
			outline(p, color)
		end
	end
	local function drawGhost(root, e, color)
		local cf = CFrame.new(e[1], e[2], e[3]) * CFrame.Angles(0, math.rad(e[4]), 0)
		box(root, cf, OUTER, color, FILL_T + MISS_T, true)
		box(root, cf * CFrame.new(0, INNER_UP, 0), INNER_SZ, color, INNER_T + MISS_T, true)
		edges(root, cf, OUTER, color)
		solid(root.CFrame * cf)
	end
	local function build()
		if not alive then return end
		clear()
		for _, plot in ipairs(Plots:GetChildren()) do
			local root = plot:FindFirstChild("MainRoot")
			local pods = plot:FindFirstChild("AnimalPodiums")
			if root and pods then
				for i = 1, #TEMPLATE do
					local sl = pods:FindFirstChild(tostring(i))
					local parts = sl and slabsOf(sl)
					local c = colorFor(i)
					if parts and parts[1] then drawReal(parts, c)
					else drawGhost(root, TEMPLATE[i], c) end
				end
			end
		end
	end
	build()
	local pending = false
	local function rebuild()
		if pending or not alive then return end
		pending = true
		task.delay(0.4, function() pending = false; build() end)
	end
	local function watch(plot)
		local pods = plot:WaitForChild("AnimalPodiums", 20)
		if pods and alive then
			conns[#conns + 1] = pods.ChildAdded:Connect(rebuild)
			conns[#conns + 1] = pods.ChildRemoved:Connect(rebuild)
		end
	end
	for _, plot in ipairs(Plots:GetChildren()) do task.spawn(watch, plot) end
	conns[#conns + 1] = Plots.ChildAdded:Connect(function(plot) task.spawn(watch, plot); rebuild() end)
	do
		local acc = 0
		conns[#conns + 1] = RunService.Heartbeat:Connect(function(dt)
			acc = acc + dt
			if acc < 0.05 then return end
			acc = 0
			local w = math.sin(os.clock() * PULSE_SPEED) * PULSE_AMOUNT
			for _, f in ipairs(fills) do
				if f.a.Parent then f.a.Transparency = math.clamp(f.base + w, 0, 1) end
			end
		end)
	end
	_G.__PodiumESPCleanup = function()
		alive = false
		for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
		table.clear(conns); clear()
		if solids then solids:Destroy(); solids = nil end
		_G.__PodiumESPCleanup = nil
	end
end
bindClick(espBtn, function()
	if espActive then
		if _G.__PodiumESPCleanup then pcall(_G.__PodiumESPCleanup) end
		espActive = false
		espBtn.Text = "Podium ESP: OFF"
		espBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
	else
		espActive = true
		espBtn.Text = "Podium ESP: ON"
		espBtn.BackgroundColor3 = Color3.fromRGB(55, 140, 75)
		local ok, err = pcall(loadPodiumESP)
		if not ok then warn("[PodiumESP] " .. tostring(err)) end
	end
end)

-- 3) Next Base
local nbActive = false
local nbBtn = makeButton("Next Base: OFF")
local function loadNextBase()
	local CoreGui = game:GetService("CoreGui")
	local Plots = workspace:WaitForChild("Plots")
	local BASE_POSITIONS = {
		Vector3.new(-342.439, 10.399, 113.107), Vector3.new(-342.439, 10.465,   6.107),
		Vector3.new(-476.752, 10.465, 114.107), Vector3.new(-476.752, 10.465,   7.107),
		Vector3.new(-342.440, 10.464, 220.107), Vector3.new(-476.752, 10.465, 221.107),
		Vector3.new(-342.439, 10.465,-100.893), Vector3.new(-476.752, 10.465, -99.893),
	}
	local MATCH_TOL = 6
	local EMPTY_TEXT = "Empty Base"
	local ARROW = utf8.char(0x2B07)
	local function baseIndexFor(model)
		local ok, cf = pcall(function() return (model:GetBoundingBox()) end)
		if not ok then return nil end
		local p, bestI, bestD = cf.Position
		for i, bp in ipairs(BASE_POSITIONS) do
			local dx, dz = p.X - bp.X, p.Z - bp.Z
			local d = math.sqrt(dx * dx + dz * dz)
			if not bestD or d < bestD then bestI, bestD = i, d end
		end
		return (bestD and bestD <= MATCH_TOL) and bestI or nil
	end
	local bases, connected, conns = {}, {}, {}
	local anchor = Instance.new("Part")
	anchor.Name = "__NextBaseAnchor"
	anchor.Anchored, anchor.CanCollide, anchor.CanQuery, anchor.CanTouch = true, false, false, false
	anchor.Transparency = 1
	anchor.Size = Vector3.new(1, 1, 1)
	anchor.Parent = CoreGui
	local bb = Instance.new("BillboardGui")
	bb.Name = "NextBaseBillboard"
	bb.Adornee = anchor
	bb.Size = UDim2.fromScale(32, 13)
	bb.StudsOffset = Vector3.new(0, 10, 0)
	bb.MaxDistance = math.huge
	bb.AlwaysOnTop = true
	bb.LightInfluence = 0
	bb.Enabled = false
	bb.Parent = anchor
	local top = Instance.new("TextLabel", bb)
	top.BackgroundTransparency = 1
	top.AnchorPoint = Vector2.new(0.5, 0.5)
	top.Position = UDim2.fromScale(0.5, 0.30)
	top.Size = UDim2.fromScale(0.95, 0.50)
	top.Font = Enum.Font.GothamBlack
	top.Text = ARROW .. "  NEXT  " .. ARROW
	top.TextScaled = true
	top.TextColor3 = Color3.fromRGB(255, 60, 60)
	top.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	top.TextStrokeTransparency = 0
	local bottom = Instance.new("TextLabel", bb)
	bottom.BackgroundTransparency = 1
	bottom.AnchorPoint = Vector2.new(0.5, 0.5)
	bottom.Position = UDim2.fromScale(0.5, 0.72)
	bottom.Size = UDim2.fromScale(0.95, 0.42)
	bottom.Font = Enum.Font.GothamBlack
	bottom.Text = "EMPTY BASE"
	bottom.TextScaled = true
	bottom.TextColor3 = Color3.fromRGB(255, 255, 255)
	bottom.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	bottom.TextStrokeTransparency = 0
	local function isEmpty(label)
		return (label.Text:gsub("^%s+", ""):gsub("%s+$", "")) == EMPTY_TEXT
	end
	local function recompute()
		local targetIdx
		for i = 1, #BASE_POSITIONS do
			local b = bases[i]
			if b and b.label and isEmpty(b.label) then targetIdx = i; break end
		end
		if targetIdx then anchor.CFrame = bases[targetIdx].cf; bb.Enabled = true
		else bb.Enabled = false end
	end
	local function connectLabel(label)
		if connected[label] then return end
		connected[label] = true
		table.insert(conns, label:GetPropertyChangedSignal("Text"):Connect(recompute))
	end
	local function scan()
		for _, plot in ipairs(Plots:GetChildren()) do
			local sign  = plot:FindFirstChild("PlotSign")
			local model = sign and sign:FindFirstChild("Model")
			local gui   = sign and sign:FindFirstChild("SurfaceGui")
			local fr    = gui and gui:FindFirstChild("Frame")
			local label = fr and fr:FindFirstChild("TextLabel")
			if model and label then
				local idx = baseIndexFor(model)
				if idx then
					bases[idx] = { label = label, cf = (select(1, model:GetBoundingBox())) }
					connectLabel(label)
				end
			end
		end
		recompute()
	end
	scan()
	table.insert(conns, Plots.DescendantAdded:Connect(function(d)
		if d:IsA("TextLabel") then task.defer(scan) end
	end))
	table.insert(conns, Plots.ChildAdded:Connect(function() task.defer(scan) end))
	_G.__NextBaseCleanup = function()
		for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
		if anchor then anchor:Destroy() end
		_G.__NextBaseCleanup = nil
	end
end
bindClick(nbBtn, function()
	if nbActive then
		if _G.__NextBaseCleanup then pcall(_G.__NextBaseCleanup) end
		nbActive = false
		nbBtn.Text = "Next Base: OFF"
		nbBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
	else
		nbActive = true
		nbBtn.Text = "Next Base: ON"
		nbBtn.BackgroundColor3 = Color3.fromRGB(55, 140, 75)
		local ok, err = pcall(loadNextBase)
		if not ok then warn("[NextBase] " .. tostring(err)) end
	end
end)
