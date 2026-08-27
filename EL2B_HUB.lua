--[[
  VIS HUB — Full Menu
  Tab 1 Player: Anti Gummy/Ragdoll/Paintball/Boogie + Speed 3-mode (Vis S2 loop)
                + Tool Aimbot + Drop Jump/Stand + Insta V1/V2 + TP Down keybinds
  Tab 2 ESP: Player ESP + Tracker + Anti Lag (Vis logic)
  Tab 3 Settings: Mobile 3-mode buttons, Lock/Unlock, shape Box/Round/Square,
                  per-button size +/-, Reset Mobile / Reset All
  Đóng menu: nút − | Mở: mini kéo được | KHÔNG keybind đóng/mở
]]

repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
if not LP then
	repeat task.wait() until Players.LocalPlayer
	LP = Players.LocalPlayer
end
local PlayerGui = LP:WaitForChild("PlayerGui", 30) or LP:FindFirstChild("PlayerGui") or game:GetService("CoreGui")

pcall(function()
	for _, n in ipairs({
		"VisHubFullMenu", "VisHubFullMini", "VisHubModeBar", "VisHubActionButtons",
	}) do
		local g = PlayerGui:FindFirstChild(n)
		if g then g:Destroy() end
	end
end)

----------------------------------------------------------------
-- COLORS / STATE
----------------------------------------------------------------
local C = {
	-- Empire-style palette
	bg = Color3.fromRGB(12, 12, 16), bg2 = Color3.fromRGB(18, 18, 24),
	card = Color3.fromRGB(24, 24, 32), stroke = Color3.fromRGB(60, 60, 80),
	accent = Color3.fromRGB(255, 20, 147), text = Color3.fromRGB(255, 255, 255),
	textDim = Color3.fromRGB(160, 160, 180), on = Color3.fromRGB(60, 220, 110),
	off = Color3.fromRGB(40, 40, 52), box = Color3.fromRGB(32, 32, 44),
	danger = Color3.fromRGB(220, 70, 90),
	modeOnBg = Color3.fromRGB(255, 20, 147), modeOnTxt = Color3.fromRGB(255, 255, 255),
	modeOffBg = Color3.fromRGB(255, 255, 255), modeOffTxt = Color3.fromRGB(25, 25, 30),
	btnOn = Color3.fromRGB(50, 210, 100), -- xanh khi bật (Empire style)
	btnOff = Color3.fromRGB(16, 16, 22),
}


-- [STABILIZED] Embedded Auto Steal file generation disabled.
-- [STABILIZED] The main VIS HUB implementation remains active.

local St = {
	antiGummy = true, antiRagdoll = false, antiPaint = true, antiBoogie = true,
	toolAim = true, speedOn = true, infJump = true, bodyLock = false, bodyLockRange = 20,
	activeMode = "Normal",
	modes = {
		Normal = { norm = 59, steal = 30, key = Enum.KeyCode.T },
		Lagger = { norm = 18, steal = 24, key = Enum.KeyCode.Q },
		Custom = { norm = 33, steal = 33, key = Enum.KeyCode.C },
	},
	dropMode = 2, -- 1 Stand/Fling, 2 Jump
	instaMode = "V1",
	mobileBtns = true, guiLock = false, -- default ON: Drop / Insta / TP buttons
	showStealBtn = true, showLaggerPanel = false, showPingLaggerPanel = false, showSpeedBypassPanel = false, speedBypassLock = false, panelGuiScale = 0.7, panelGuiWidth = 1, laggerPanelLock = false, pingPanelLock = false, -- hiện nút Auto Steal ngoài (độc lập auto steal on/off)
	btnShape = "Square", -- Round | Box | Square
	btnScale = 0.75,
	menuScale = 1.0,
	btnSizes = { mode = 50, drop = 50, insta = 50, tp = 50, sentry = 50, steal = 50 },
	keys = {
		Drop = Enum.KeyCode.X,
		TPDown = Enum.KeyCode.F,
		InstaReset = Enum.KeyCode.Z,
		DestroySentry = Enum.KeyCode.H,
		AutoSteal = nil, -- nil = None (no key)
	},
	esp = false, tracer = false, antiLag = false,
	antiKick = true, wallOpacity = 0.12, speedMethod = "Velocity",
	destroySentry = false,
	spamLaser = false, spamPaint = false,
	counterLaser = false, counterBoogie = false, counterSwapBody = false,
	equipOnDrop = false,
}
_G.VisState = St
local ToggleRefs = {} -- shared state for embedded helpers

local CFG = "VisAllgear.json"
local _saveToken = 0
function autoSaveDebounced()
	_saveToken = _saveToken + 1
	local t = _saveToken
	task.delay(0.35, function()
		if t == _saveToken then pcall(saveCfg) end
	end)
end
function _serializeValue(v, depth)
	depth = depth or 0
	if depth > 6 then return nil end
	local t = typeof(v)
	if t == "number" or t == "string" or t == "boolean" then
		return v
	elseif t == "EnumItem" then
		return v.Name
	elseif t == "table" then
		local out = {}
		for k2, v2 in pairs(v) do
			local kt = type(k2)
			if kt == "string" or kt == "number" then
				local sv = _serializeValue(v2, depth + 1)
				if sv ~= nil then out[k2] = sv end
			end
		end
		return out
	end
	return nil
end
function saveCfg()
	local d = {}
	-- dump TOÀN BỘ St (mọi key có thể JSON được)
	for k, v in pairs(St) do
		if type(k) == "string" then
			-- không lưu base/pet TP — chỉ nhớ vị trí panel
			if k == "_saveBase" or k == "_savePet" or k == "saveBase" or k == "savePet"
				or k == "_delayBase" or k == "_delayPet" then
				-- skip
			elseif k == "modes" or k == "keys" then
				-- skip, handle below
			else
				local sv = _serializeValue(v)
				if sv ~= nil then d[k] = sv end
			end
		end
	end
	d.modes = {}
	for k, m in pairs(St.modes or {}) do
		if type(m) == "table" then
			d.modes[k] = {
				norm = tonumber(m.norm) or 16,
				steal = tonumber(m.steal) or 16,
				key = (typeof(m.key) == "EnumItem" and m.key.Name) or (type(m.key) == "string" and m.key) or "Unknown",
			}
		end
	end
	d.keys = {}
	for k, v in pairs(St.keys or {}) do
		d.keys[k] = (typeof(v) == "EnumItem" and v.Name) or tostring(v)
	end
	local ok, err = pcall(function()
		if not writefile then error("no writefile") end
		d._saveBase = nil
	d._savePet = nil
	d.saveBase = nil
	d.savePet = nil
	d._delayBase = nil
	d._delayPet = nil
	writefile(CFG, HttpService:JSONEncode(d))
	end)
	if not ok then
		warn("[VisHub] saveCfg fail:", err)
	end
	return ok
end
function loadCfg()
	local ok, data = pcall(function()
		if isfile and readfile then
			if isfile(CFG) then
				return HttpService:JSONDecode(readfile(CFG))
			end
			for _, old in ipairs({"RaraOnflop.json", "VisHub_FullMenu_v1.json", "VisHub_Config.json", "VisHub.json"}) do
				if isfile(old) then
					local d = HttpService:JSONDecode(readfile(old))
					pcall(function() writefile(CFG, HttpService:JSONEncode(d)) end)
					return d
				end
			end
		end
	end)
	if not (ok and type(data) == "table") then return false end
	for k, v in pairs(data) do
		if type(k) == "string" and k ~= "modes" and k ~= "keys" then
			St[k] = v
		end
	end
	if type(data.modes) == "table" then
		for k, m in pairs(data.modes) do
			if type(m) == "table" then
				St.modes[k] = St.modes[k] or { norm = 59, steal = 30, key = Enum.KeyCode.Unknown }
				St.modes[k].norm = tonumber(m.norm) or St.modes[k].norm
				St.modes[k].steal = tonumber(m.steal) or St.modes[k].steal
				if type(m.key) == "string" then
					pcall(function() St.modes[k].key = Enum.KeyCode[m.key] end)
				end
			end
		end
	end
	if type(data.keys) == "table" then
		St.keys = St.keys or {}
		for k, name in pairs(data.keys) do
			pcall(function() St.keys[k] = Enum.KeyCode[name] end)
		end
	end
	if type(data.btnSizes) == "table" then
		St.btnSizes = data.btnSizes
		for k,v in pairs(St.btnSizes) do
			St.btnSizes[k] = math.clamp(tonumber(v) or 50, 20, 200)
		end
	end
	if type(data._btnPos) == "table" then St._btnPos = data._btnPos end
	St.stealRadius = tonumber(St.stealRadius) or 60
	St.stealVer = St.stealVer or "V1"
	St.stealBarScale = tonumber(St.stealBarScale) or 1
	if St.showStealBtn == nil then St.showStealBtn = true end
	autoStealRadius = St.stealRadius
	return true
end
loadCfg()
task.spawn(function()
	while true do
		task.wait(3)
		local ok, err = pcall(saveCfg)
		if not ok then warn("[VisHub] autosave 3s fail:", err) end
	end
end)

----------------------------------------------------------------
----------------------------------------------------------------
-- SPEED — full Empire multi-method loop (Velocity / LV / CFrame / ...)
----------------------------------------------------------------
local speedConnection = nil
local currentSpeedValue = 16
St.speedMethod = St.speedMethod or "Velocity"
St.hyperMult = tonumber(St.hyperMult) or 4

local _spd = {
	lastMethod = nil,
	lastMoveDir = Vector3.zero,
	anchoredBySpeed = nil,
	bodyVel = nil, bodyPosition = nil, bodyForce = nil, bodyThrust = nil,
	linearVel = nil, vectorForce = nil, alignPos = nil,
	rocket = nil, rocketTarget = nil,
	attLinVel = nil, attVecForce = nil, attAlign = nil,
	speedTween = nil,
}

local MOVE_KEYS = {
	[Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true, [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
	[Enum.KeyCode.Up] = true, [Enum.KeyCode.Down] = true, [Enum.KeyCode.Left] = true, [Enum.KeyCode.Right] = true,
}

function getCharParts()
	local char = LP.Character
	if not char then return nil, nil end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not hum or not root then return nil, nil end
	return hum, root
end


----------------------------------------------------------------
-- SPEED LOOP + INF JUMP — FULL EMPIRE (fetched) — no old leftovers
-- 3 mode (Normal/Lagger/Custom) = St.modes + getActiveMoveSpeed
----------------------------------------------------------------
_spd = _spd or {
	lastMethod = nil,
	lastMoveDir = Vector3.zero,
	anchoredBySpeed = nil,
	bodyVel = nil, bodyPosition = nil, bodyForce = nil, bodyThrust = nil,
	linearVel = nil, vectorForce = nil, alignPos = nil,
	rocket = nil, rocketTarget = nil,
	attLinVel = nil, attVecForce = nil, attAlign = nil,
	speedTween = nil,
}
speedConnection = nil
currentSpeedValue = 16

function isCarryingBrainrot(char)
	if not char then return false end
	local ok, st = pcall(function() return LP:GetAttribute("Stealing") end)
	if ok and st == true then return true end
	local ok2, st2 = pcall(function() return char:GetAttribute("Stealing") end)
	if ok2 and st2 == true then return true end
	for _, v in ipairs(char:GetChildren()) do
		if v:IsA("Tool") or v:IsA("Model") or v:IsA("Folder") then
			local n = string.lower(tostring(v.Name))
			if n:find("brainrot", 1, true) or n:find("carriedbrain", 1, true) then
				return true
			end
		end
	end
	return false
end

function getActiveMoveSpeed()
	-- 3 mode speed: Normal / Lagger / Custom (UI + V2 bar)
	local mode = St.activeMode
	if not mode or not St.modes[mode] then
		mode = "Normal"
		St.activeMode = "Normal"
	end
	local m = St.modes[mode] or { norm = 59, steal = 30 }
	local norm = math.clamp(tonumber(m.norm) or 59, 1, 200)
	local steal = math.clamp(tonumber(m.steal) or 30, 1, 200)
	if isCarryingBrainrot(LP.Character) then
		return steal
	end
	return norm
end

function ensureSpeedAttachment(hrp, key, name)
	local att = _spd[key]
	if not att or att.Parent ~= hrp then
		if att then pcall(function() att:Destroy() end) end
		att = Instance.new("Attachment")
		att.Name = name or "VisEmpireSpeedAtt"
		att.Parent = hrp
		_spd[key] = att
	end
	return att
end

function destroySpeedObjects() if _spd.anchoredBySpeed then pcall(function() _spd.anchoredBySpeed.Anchored = false end); _spd.anchoredBySpeed = nil end if _spd.bodyVel then pcall(function() _spd.bodyVel:Destroy() end); _spd.bodyVel = nil end if _spd.bodyPosition then pcall(function() _spd.bodyPosition:Destroy() end); _spd.bodyPosition = nil end if _spd.bodyForce then pcall(function() _spd.bodyForce:Destroy() end); _spd.bodyForce = nil end if _spd.bodyThrust then pcall(function() _spd.bodyThrust:Destroy() end); _spd.bodyThrust = nil end if _spd.linearVel then pcall(function() _spd.linearVel:Destroy() end); _spd.linearVel = nil end if _spd.vectorForce then pcall(function() _spd.vectorForce:Destroy() end); _spd.vectorForce = nil end if _spd.alignPos then pcall(function() _spd.alignPos:Destroy() end); _spd.alignPos = nil end if _spd.rocket then pcall(function() _spd.rocket:Destroy() end); _spd.rocket = nil end if _spd.rocketTarget then pcall(function() _spd.rocketTarget:Destroy() end); _spd.rocketTarget = nil end if _spd.attLinVel then pcall(function() _spd.attLinVel:Destroy() end); _spd.attLinVel = nil end if _spd.attVecForce then pcall(function() _spd.attVecForce:Destroy() end); _spd.attVecForce = nil end if _spd.attAlign then pcall(function() _spd.attAlign:Destroy() end); _spd.attAlign = nil end if _spd.speedTween then pcall(function() _spd.speedTween:Cancel() end); _spd.speedTween = nil end end function applySpeedMethod(hrp, hum, dir, spd, dt) local step = dt or 1/60 local m = (St.speedMethod or "Velocity") if _spd.lastMethod ~= m then destroySpeedObjects() if m ~= "WalkSpeed" and hum.WalkSpeed ~= 16 then hum.WalkSpeed = 16 end _spd.lastMethod = m end local char = hrp.Parent local targetPos = hrp.Position + (dir * spd * step) local function massImpulse(direction, targetSpeed) local mass = hrp.AssemblyMass or 1 local current = hrp.AssemblyLinearVelocity local desired = Vector3.new(direction.X * targetSpeed, current.Y, direction.Z * targetSpeed) local delta = desired - current pcall(function() hrp:ApplyImpulse(Vector3.new(delta.X, 0, delta.Z) * mass) end) end if m == "Velocity" then massImpulse(dir, spd) elseif m == "AssemblyLinearVelocity" then massImpulse(dir, spd) elseif m == "Velocity Lerp" then local current = hrp.AssemblyLinearVelocity local desired = Vector3.new(dir.X*spd, current.Y, dir.Z*spd) local blended = current:Lerp(desired, 0.6) local mass = hrp.AssemblyMass or 1 pcall(function() hrp:ApplyImpulse(Vector3.new(blended.X - current.X, 0, blended.Z - current.Z) * mass) end) elseif m == "AssemblyLinearVelocity Lerp" then local current = hrp.AssemblyLinearVelocity local desired = Vector3.new(dir.X*spd, current.Y, dir.Z*spd) local blended = current:Lerp(desired, 0.6) local mass = hrp.AssemblyMass or 1 pcall(function() hrp:ApplyImpulse(Vector3.new(blended.X - current.X, 0, blended.Z - current.Z) * mass) end) elseif m == "CFrame" then hrp.CFrame = hrp.CFrame + (dir * spd * step) elseif m == "CFrame Lerp" then hrp.CFrame = hrp.CFrame:Lerp(hrp.CFrame + (dir * spd * step), 0.5) elseif m == "Hyper CFrame" then hrp.CFrame = hrp.CFrame + (dir * spd * ((St.hyperMult or 4) or 4) * step) elseif m == "Anchored CFrame" then if not hrp.Anchored then hrp.Anchored = true _spd.anchoredBySpeed = hrp end hrp.CFrame = hrp.CFrame + (dir * spd * step) elseif m == "PivotTo" then hrp:PivotTo(hrp.CFrame + (dir * spd * step)) elseif m == "Model PivotTo" then if char and char:IsA("Model") then char:PivotTo(char:GetPivot() + (dir * spd * step)) else hrp:PivotTo(hrp.CFrame + (dir * spd * step)) end elseif m == "Tween CFrame" then if _spd.speedTween then pcall(function() _spd.speedTween:Cancel() end) end _spd.speedTween = TS:Create(hrp, TweenInfo.new(step, Enum.EasingStyle.Linear), {CFrame = hrp.CFrame + (dir * spd * step)}) _spd.speedTween:Play() elseif m == "WalkSpeed" then hum.WalkSpeed = spd elseif m == "Humanoid Move" then hum.WalkSpeed = spd hum:Move(dir) elseif m == "Humanoid MoveTo" then hum:MoveTo(targetPos, hrp) elseif m == "BodyVelocity" then if not _spd.bodyVel or _spd.bodyVel.Parent ~= hrp then if _spd.bodyVel then pcall(function() _spd.bodyVel:Destroy() end) end _spd.bodyVel = Instance.new("BodyVelocity") _spd.bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge) _spd.bodyVel.Parent = hrp end _spd.bodyVel.Velocity = Vector3.new(dir.X*spd, _spd.bodyVel.Velocity.Y, dir.Z*spd) elseif m == "BodyPosition" then if not _spd.bodyPosition or _spd.bodyPosition.Parent ~= hrp then if _spd.bodyPosition then pcall(function() _spd.bodyPosition:Destroy() end) end _spd.bodyPosition = Instance.new("BodyPosition") _spd.bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge) _spd.bodyPosition.P = 500 _spd.bodyPosition.D = 50 _spd.bodyPosition.Parent = hrp end _spd.bodyPosition.Position = targetPos elseif m == "BodyForce" then if not _spd.bodyForce or _spd.bodyForce.Parent ~= hrp then if _spd.bodyForce then pcall(function() _spd.bodyForce:Destroy() end) end _spd.bodyForce = Instance.new("BodyForce") _spd.bodyForce.Parent = hrp end _spd.bodyForce.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100 elseif m == "BodyThrust" then if not _spd.bodyThrust or _spd.bodyThrust.Parent ~= hrp then if _spd.bodyThrust then pcall(function() _spd.bodyThrust:Destroy() end) end _spd.bodyThrust = Instance.new("BodyThrust") _spd.bodyThrust.Force = Vector3.new(math.huge, math.huge, math.huge) _spd.bodyThrust.Parent = hrp end _spd.bodyThrust.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100 elseif m == "LinearVelocity" then if not _spd.linearVel or _spd.linearVel.Parent ~= hrp then if _spd.linearVel then pcall(function() _spd.linearVel:Destroy() end) end local att = ensureSpeedAttachment(hrp, "attLinVel", "MoveeLinVelAtt") _spd.linearVel = Instance.new("LinearVelocity") _spd.linearVel.Attachment0 = att _spd.linearVel.MaxForce = 1e8 _spd.linearVel.RelativeTo = Enum.ActuatorRelativeTo.World _spd.linearVel.Parent = hrp end _spd.linearVel.VectorVelocity = Vector3.new(dir.X*spd, _spd.linearVel.VectorVelocity.Y, dir.Z*spd) elseif m == "VectorForce" then if not _spd.vectorForce or _spd.vectorForce.Parent ~= hrp then if _spd.vectorForce then pcall(function() _spd.vectorForce:Destroy() end) end local att = ensureSpeedAttachment(hrp, "attVecForce", "MoveeVecForceAtt") _spd.vectorForce = Instance.new("VectorForce") _spd.vectorForce.Attachment0 = att _spd.vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World _spd.vectorForce.Parent = hrp end _spd.vectorForce.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100 elseif m == "AlignPosition" then if not _spd.alignPos or _spd.alignPos.Parent ~= hrp then if _spd.alignPos then pcall(function() _spd.alignPos:Destroy() end) end local att = ensureSpeedAttachment(hrp, "attAlign", "MoveeAlignAtt") _spd.alignPos = Instance.new("AlignPosition") _spd.alignPos.Attachment0 = att _spd.alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment _spd.alignPos.MaxForce = math.huge _spd.alignPos.Responsiveness = 15 _spd.alignPos.RigidityEnabled = false _spd.alignPos.Parent = hrp end _spd.alignPos.Position = targetPos elseif m == "ApplyImpulse" then local mass = hrp.AssemblyMass or 1 local current = hrp.AssemblyLinearVelocity local desired = Vector3.new(dir.X * spd, current.Y, dir.Z * spd) local delta = desired - current pcall(function() hrp:ApplyImpulse(Vector3.new(delta.X, 0, delta.Z) * mass) end) elseif m == "RocketPropulsion" then if not _spd.rocket or _spd.rocket.Parent ~= hrp or not _spd.rocketTarget then if _spd.rocket then pcall(function() _spd.rocket:Destroy() end) end if _spd.rocketTarget then pcall(function() _spd.rocketTarget:Destroy() end) end _spd.rocketTarget = Instance.new("Part") _spd.rocketTarget.Name = "MoveeRocketTarget" _spd.rocketTarget.Anchored = true _spd.rocketTarget.CanCollide = false _spd.rocketTarget.Transparency = 1 _spd.rocketTarget.Size = Vector3.new(1,1,1) _spd.rocketTarget.Parent = workspace _spd.rocket = Instance.new("RocketPropulsion") _spd.rocket.MaxThrust = 3000 _spd.rocket.MaxTorque = 1000 _spd.rocket.ThrustP = 100 _spd.rocket.ThrustD = 20 _spd.rocket.TurnP = 100 _spd.rocket.TurnD = 10 _spd.rocket.Target = _spd.rocketTarget _spd.rocket.Parent = hrp end _spd.rocketTarget.Position = targetPos pcall(function() _spd.rocket:Fire() end) end end

function stopSpeedBoost()
	if speedConnection then
		pcall(function() speedConnection:Disconnect() end)
		speedConnection = nil
	end
	pcall(destroySpeedObjects)
end

function startSpeedBoost()
	if not St.speedOn then
		stopSpeedBoost()
		return
	end
	currentSpeedValue = getActiveMoveSpeed()
	if speedConnection then
		pcall(function() speedConnection:Disconnect() end)
		speedConnection = nil
	end
	-- EMPIRE full loop (RenderStepped)
	speedConnection = RS.RenderStepped:Connect(function(dt)
		if not St.speedOn then return end
		local char = LP.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hum or not hrp then return end
		-- ragdoll → stop
		local stt = hum:GetState()
		if stt == Enum.HumanoidStateType.Physics
			or stt == Enum.HumanoidStateType.Ragdoll
			or stt == Enum.HumanoidStateType.FallingDown
			or hum.Health <= 0 then
			_spd.lastMoveDir = Vector3.zero
			destroySpeedObjects()
			return
		end
		local md = hum.MoveDirection
		local spd = getActiveMoveSpeed()
		currentSpeedValue = spd
		local dir = Vector3.zero
		if md.Magnitude > 0.01 then
			_spd.lastMoveDir = md
			dir = md
		else
			-- giữ hướng khi anti ragdoll + phím còn giữ (Empire style)
			local anyHeld = false
			if type(MOVE_KEYS) == "table" then
				for key in pairs(MOVE_KEYS) do
					if UIS:IsKeyDown(key) then anyHeld = true break end
				end
			end
			if anyHeld and _spd.lastMoveDir and _spd.lastMoveDir.Magnitude > 0.01 then
				dir = _spd.lastMoveDir
			end
		end
		if dir.Magnitude > 0.01 then
			applySpeedMethod(hrp, hum, dir.Unit, spd, dt)
		else
			destroySpeedObjects()
		end
	end)
end

function setSpeedOn(on)
	St.speedOn = on and true or false
	if St.speedOn then startSpeedBoost() else stopSpeedBoost() end
	saveCfg()
end

function setActiveMode(mode)
	if not St.modes[mode] then return end
	St.activeMode = mode
	currentSpeedValue = getActiveMoveSpeed()
	if St.speedOn then
		startSpeedBoost() -- restart Empire loop
	end
	if _G.VisRefreshModeBar then pcall(_G.VisRefreshModeBar) end
	if _G.VisRefreshV2ModeBar then pcall(_G.VisRefreshV2ModeBar) end
	if _G.VisRefreshModeCards then pcall(_G.VisRefreshModeCards) end
	pcall(saveCfg)
end

----------------------------------------------------------------
-- INFINITE JUMP — FULL EMPIRE (hold + manual 2 mode)
----------------------------------------------------------------
InfJumpState = { enabled = false, mode = "hold", jumpHeld = false }
local _holdInfJumpConn = nil

function stopHoldInfJump()
	if _holdInfJumpConn then
		pcall(function() _holdInfJumpConn:Disconnect() end)
		_holdInfJumpConn = nil
	end
end

function startHoldInfJump()
	stopHoldInfJump()
	-- FULL Empire hold infinite jump (Velocity)
	_holdInfJumpConn = RS.Heartbeat:Connect(function()
		if not InfJumpState.enabled then return end
		local char = LP.Character
		if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not root or not hum then return end
		local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true) or (InfJumpState.jumpHeld == true)
		local vel = root.Velocity
		pcall(function()
			local av = root.AssemblyLinearVelocity
			if av then vel = av end
		end)
		if isJumpHeld and vel.Y < 35 then
			local nv = Vector3.new(vel.X, 55, vel.Z)
			pcall(function() root.Velocity = nv end)
			pcall(function() root.AssemblyLinearVelocity = nv end)
		end
		if vel.Y < -120 then
			local nv = Vector3.new(vel.X, -120, vel.Z)
			pcall(function() root.Velocity = nv end)
			pcall(function() root.AssemblyLinearVelocity = nv end)
		end
	end)
end

function startInfJump()
	InfJumpState.enabled = true
	InfJumpState.mode = St.infJumpMode or "hold"
	startHoldInfJump()
end

function stopInfJump()
	InfJumpState.enabled = false
	InfJumpState.jumpHeld = false
	stopHoldInfJump()
end

function setInfJump(on)
	St.infJump = on and true or false
	if St.infJump then startInfJump() else stopInfJump() end
	saveCfg()
end

function setInfJumpMode(mode)
	-- "hold" | "manual" — Empire dùng cùng loop; manual chỉ pulse jumpHeld
	St.infJumpMode = mode
	InfJumpState.mode = mode
	if St.infJump then startInfJump() end
	saveCfg()
end

-- Mobile JumpButton + Space (Empire)
if not _G._VisEmpireJumpHook then
	_G._VisEmpireJumpHook = true
	task.spawn(function()
		local pg = LP:WaitForChild("PlayerGui", 15)
		if not pg then return end
		local function hookJumpButton(btn)
			if btn:IsA("GuiButton") and btn.Name == "JumpButton" and not btn:GetAttribute("VisInfJumpHooked") then
				btn:SetAttribute("VisInfJumpHooked", true)
				btn.MouseButton1Down:Connect(function()
					if InfJumpState.enabled then InfJumpState.jumpHeld = true end
				end)
				btn.MouseButton1Up:Connect(function()
					InfJumpState.jumpHeld = false
				end)
			end
		end
		for _, d in ipairs(pg:GetDescendants()) do hookJumpButton(d) end
		pg.DescendantAdded:Connect(hookJumpButton)
	end)
	UIS.JumpRequest:Connect(function()
		if not InfJumpState.enabled then return end
		if InfJumpState.mode == "manual" then
			InfJumpState.jumpHeld = true
			task.defer(function() InfJumpState.jumpHeld = false end)
		end
	end)
	UIS.InputEnded:Connect(function(inp)
		if inp.KeyCode == Enum.KeyCode.Space then
			InfJumpState.jumpHeld = false
		end
	end)
end


-- ANTI KICK (Empire full) — LUÔN BẬT, không bao giờ tắt
----------------------------------------------------------------
local AntiKickState = { enabled = true, brainrotDetected = false, conn = nil }
function enableAntiKick()
	AntiKickState.enabled = true
	St.antiKick = true
	-- namecall Kick shield (executor)
	pcall(function()
		if hookmetamethod and not _G._FAGAntiKickHooked then
			_G._FAGAntiKickHooked = true
			local old
			old = hookmetamethod(game, "__namecall", function(self, ...)
				local method = (getnamecallmethod and getnamecallmethod()) or ""
				if tostring(method) == "Kick" then
					if self == LP or (typeof(self) == "Instance" and self:IsA("Player") and self == LP) then
						return -- block LocalPlayer:Kick
					end
				end
				return old(self, ...)
			end)
		end
	end)
	-- block Players.LocalPlayer:Kick via hookfunction if available
	pcall(function()
		if hookfunction and not _G._FAGKickFnHooked then
			_G._FAGKickFnHooked = true
			local oldKick = LP.Kick
			if typeof(oldKick) == "function" then
				hookfunction(oldKick, function(self, ...)
					return -- never kick self
				end)
			end
		end
	end)
	if AntiKickState.conn then return end
	AntiKickState.conn = task.spawn(function()
		while true do -- forever
			AntiKickState.enabled = true
			St.antiKick = true
			task.wait(0.5)
			local char = LP.Character
			local found = false
			if char then
				for _, tool in ipairs(char:GetChildren()) do
					if tool:IsA("Tool") then
						local n = tool.Name:lower()
						if n:find("brainrot") or n:find("skibidi") or n:find("toilet") then
							found = true
							break
						end
					end
				end
			end
			AntiKickState.brainrotDetected = found
		end
	end)
end
function disableAntiKick()
	-- KHÔNG BAO GIỜ TẮT — bỏ qua
	enableAntiKick()
end
function setAntiKick(on)
	enableAntiKick()
	saveCfg()
end
task.defer(enableAntiKick)



-- Anti Ragdoll V1=Splatter / V2=No Splatter (full Vynx logic)
AntiRagdollV2 = AntiRagdollV2 or { Connection = nil, Enabled = false, ResetCooldown = 0 }
St.antiRagdollMode = St.antiRagdollMode or "V1" -- V1=Splatter, V2=No Splatter

function forceNoSplatterReset()
	local char = LP.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not hum or not root or hum.Health <= 0 then return end
	pcall(function()
		hum:ChangeState(Enum.HumanoidStateType.GettingUp)
		root.Velocity = Vector3.zero
		root.RotVelocity = Vector3.zero
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		for _, obj in ipairs(char:GetDescendants()) do
			if obj:IsA("Motor6D") then obj.Enabled = true end
			if obj:IsA("Constraint") then obj.Enabled = true end
		end
		workspace.CurrentCamera.CameraSubject = hum
		local PM = LP:FindFirstChild("PlayerScripts") and LP.PlayerScripts:FindFirstChild("PlayerModule")
		if PM then
			local ok, CM = pcall(function() return require(PM:FindFirstChild("ControlModule")) end)
			if ok and CM and CM.Enable then pcall(function() CM:Enable() end) end
		end
		hum.AutoRotate = true
		hum.PlatformStand = false
		hum.Sit = false
	end)
end

function startAntiRagdoll()
	stopAntiRagdoll()
	AntiRagdollV2.Enabled = true
	AntiRagdollV2.Connection = RS.Heartbeat:Connect(function()
		if not AntiRagdollV2.Enabled or not St.antiRagdoll then return end
		local char = LP.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		local root = char:FindFirstChild("HumanoidRootPart")
		if not hum or hum.Health <= 0 then return end
		local state = hum:GetState()
		local ragdolled = (state == Enum.HumanoidStateType.Physics
			or state == Enum.HumanoidStateType.Ragdoll
			or state == Enum.HumanoidStateType.FallingDown)
		local mode = tostring(St.antiRagdollMode or "V1"):upper()
		-- V2 = No Splatter (Vynx)
		if mode == "V2" or mode == "NO SPLATTER" then
			if ragdolled then
				local now = tick()
				if now - (AntiRagdollV2.ResetCooldown or 0) > 0.15 then
					AntiRagdollV2.ResetCooldown = now
					forceNoSplatterReset()
				end
			end
			return
		end
		-- V1 = Splatter (Vynx): clear constraints + Running
		if not root then return end
		local endTime = LP:GetAttribute("RagdollEndTime")
		if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
			ragdolled = true
		end
		if ragdolled then
			pcall(function()
				LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
			end)
			for _, d in ipairs(char:GetDescendants()) do
				if d:IsA("BallSocketConstraint") or
					(d:IsA("Attachment") and tostring(d.Name):find("RagdollAttachment")) then
					d:Destroy()
				end
			end
			for _, obj in ipairs(char:GetDescendants()) do
				if obj:IsA("Motor6D") and obj.Enabled == false then
					obj.Enabled = true
				end
			end
			if hum.Health > 0 then
				hum:ChangeState(Enum.HumanoidStateType.Running)
			end
			pcall(function() workspace.CurrentCamera.CameraSubject = hum end)
			root.Anchored = false
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
		end
	end)
end

function stopAntiRagdoll()
	AntiRagdollV2.Enabled = false
	if AntiRagdollV2.Connection then
		pcall(function() AntiRagdollV2.Connection:Disconnect() end)
		AntiRagdollV2.Connection = nil
	end
	AntiRagdollV2.ResetCooldown = 0
end

function setAntiRagdoll(on)
	St.antiRagdoll = on and true or false
	if St.antiRagdoll then
		startAntiRagdoll()
	else
		stopAntiRagdoll()
	end
	pcall(saveCfg)
end

function setAntiRagdollMode(mode)
	mode = tostring(mode or "V1"):upper()
	if mode == "V2" or mode == "NO SPLATTER" or mode == "NOSPLATTER" then
		St.antiRagdollMode = "V2"
	else
		St.antiRagdollMode = "V1"
	end
	if St.antiRagdoll then
		stopAntiRagdoll()
		startAntiRagdoll()
	end
	pcall(function() if _G.VisRefreshAntiRagMode then _G.VisRefreshAntiRagMode() end end)
	pcall(saveCfg)
end
_G.VisSetAntiRagdollMode = setAntiRagdollMode



----------------------------------------------------------------
-- ANTI GUMMY / BOOGIE / PAINTBALL (VisHub full) — LUÔN BẬT
--------------------------------------------------------------
-- Anti Gummy / Boogie / Bee / Paintball (from Tp Heatseeker)
-- Always ON, no GUI
-- ============================================================
if not _G._FAG_VisAntiGummyFullLoaded then
	_G._FAG_VisAntiGummyFullLoaded = true
	task.spawn(function()
		local Players = game:GetService("Players")
		local RunService = game:GetService("RunService")
		local Lighting = game:GetService("Lighting")
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local LocalPlayer = Players.LocalPlayer

		local AntiGummy, AntiBoogie, AntiBee = true, true, false -- no Anti Bee
		local ANTI_PAINTBALL_ALWAYS_ON = true

		local function ResetTool(Char)
			if not Char then Char = LocalPlayer.Character end
			if not Char then return end
			pcall(function()
				LocalPlayer:SetAttribute("BlockTools", false)
				LocalPlayer:SetAttribute("Web", false)
				Char:SetAttribute("BackpackReady", true)
			end)
		end

		local function ClearEffect()
			if AntiBee then
				for _, V in pairs(Lighting:GetChildren()) do
					if V.Name == "BeeBlur" or V.Name == "Flashbang" then
						pcall(function() V:Destroy() end)
					end
				end
				local Ctrl = ReplicatedStorage:FindFirstChild("Controllers")
				if Ctrl then
					local BC = Ctrl:FindFirstChild("BeeLauncherController")
					if BC then
						local B = BC:FindFirstChild("Buzzing")
						if B then pcall(function() B:Stop() end) end
					end
				end
			end
			if AntiBoogie then
				for _, V in pairs(Lighting:GetChildren()) do
					if V.Name == "DiscoEffect" then
						pcall(function() V:Destroy() end)
					end
				end
				local Ctrl = ReplicatedStorage:FindFirstChild("Controllers")
				if Ctrl then
					local BC = Ctrl:FindFirstChild("BoogieBombController")
					if BC then
						local B = BC:FindFirstChild("BOOM")
						if B then pcall(function() B:Stop() end) end
					end
				end
			end
		end

		local function getMainHudGui()
			local pg = LocalPlayer:FindFirstChild("PlayerGui")
			return pg and pg:FindFirstChild("Main")
		end

		local function isPaintballSplatGui(gui)
			if not gui or gui.Parent ~= getMainHudGui() then return false end
			if not (gui:IsA("ImageLabel") or gui:IsA("ImageButton")) then return false end
			if gui:GetAttribute("__UGPaintballIgnore") or gui:GetAttribute("__UGPaintballShrunk") then return false end
			return math.abs(gui.Rotation) > 0.01
		end

		local function shrinkPaintballSplat(gui)
			if not gui or gui:GetAttribute("__UGPaintballShrunk") then return end
			gui:SetAttribute("__UGPaintballShrunk", true)
			gui.Size = UDim2.fromOffset(6, 6)
		end

		local function runAntiPaintballSweep()
			if not ANTI_PAINTBALL_ALWAYS_ON then return end
			task.spawn(function()
				for _ = 1, 8 do
					local main = getMainHudGui()
					if not main then break end
					for _, c in ipairs(main:GetChildren()) do
						if isPaintballSplatGui(c) then
							pcall(shrinkPaintballSplat, c)
						end
					end
					task.wait(0.05)
				end
			end)
		end

		-- Paintball continuous sweep
		task.spawn(function()
			while task.wait(0.25) do
				if ANTI_PAINTBALL_ALWAYS_ON then
					pcall(runAntiPaintballSweep)
				end
			end
		end)

		-- Heartbeat: Anti Gummy + Boogie/Bee
		RunService.Heartbeat:Connect(function()
			if AntiGummy then
				pcall(ResetTool)
			end
			if AntiBoogie or AntiBee then
				pcall(ClearEffect)
			end
		end)

		-- Also clear on Lighting child added (instant)
		pcall(function()
			Lighting.ChildAdded:Connect(function(child)
				if not child then return end
				local n = child.Name
				if AntiBee and (n == "BeeBlur" or n == "Flashbang") then
					task.defer(function() pcall(function() child:Destroy() end) end)
				end
				if AntiBoogie and n == "DiscoEffect" then
					task.defer(function() pcall(function() child:Destroy() end) end)
				end
			end)
		end)

		-- Paintball: shrink when new splat appears on Main HUD
		pcall(function()
			local function hookMain(main)
				if not main or main:GetAttribute("_VisAntiPaintballHooked") then return end
				main:SetAttribute("_VisAntiPaintballHooked", true)
				main.ChildAdded:Connect(function(c)
					task.defer(function()
						if isPaintballSplatGui(c) then
							pcall(shrinkPaintballSplat, c)
						end
					end)
				end)
			end
			local pg = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
			if pg then
				hookMain(pg:FindFirstChild("Main"))
				pg.ChildAdded:Connect(function(ch)
					if ch.Name == "Main" then
						task.defer(function() hookMain(ch) end)
					end
				end)
			end
		end)

		-- CharacterAdded: ensure tools unblocked
		LocalPlayer.CharacterAdded:Connect(function(char)
			task.defer(function()
				pcall(ResetTool, char)
			end)
		end)

		print("[Vis AllGear] Anti Gummy / Boogie / Bee / Paintball ON (silent)")
	end)
end

-- Setters: luôn bật, không tắt được
function setAntiGummy(on)
	St.antiGummy = true
	AntiFX.gummy = true
	saveCfg()
end
function setAntiBoogie(on)
	St.antiBoogie = true
	AntiFX.boogie = true
	saveCfg()
end
function setAntiPaint(on)
	St.antiPaint = true
	AntiFX.paint = true
	saveCfg()
end

----------------------------------------------------------------
-- TOOL AIMBOT (VisHub full) — LUÔN BẬT
----------------------------------------------------------------
local aimOn = true
local TOOLS = { ["Web Slinger"] = true, ["Paintball Gun"] = true, ["Laser Cape"] = true }
local hooked = {}
local mouseMod, lastAimUp = nil, 0
function getMouse()
	if mouseMod then return mouseMod end
	pcall(function()
		local pkg = ReplicatedStorage:FindFirstChild("Packages")
		if pkg then mouseMod = require(pkg:WaitForChild("PlayerMouse", 5)) end
	end)
	return mouseMod
end
function bestEnemy()
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local cam = workspace.CurrentCamera
	if not root or not cam then return nil end
	local best, score = nil, math.huge
	local camPos, camDir = cam.CFrame.Position, cam.CFrame.LookVector
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then
			local r = plr.Character:FindFirstChild("HumanoidRootPart")
			local h = plr.Character:FindFirstChildOfClass("Humanoid")
			if r and h and h.Health > 0 then
				local d = (r.Position - root.Position).Magnitude
				if d <= 100 then
					local to = r.Position - camPos
					if to.Magnitude > 0.01 then
						local ang = math.deg(math.acos(math.clamp(camDir:Dot(to.Unit), -1, 1)))
						local sc = d + (ang > 200 and 1000 or 0)
						if sc < score then score, best = sc, r end
					end
				end
			end
		end
	end
	return best
end
function overrideMouse()
	if not aimOn then return end
	local pm = getMouse()
	if not pm then return end
	local e = bestEnemy()
	if e and e.Parent then
		local vel = e.AssemblyLinearVelocity or Vector3.zero
		pcall(function()
			pm.Hit = CFrame.new(e.Position + vel * 0.1)
			pm.Target = e
		end)
	end
end
function hookTool(tool)
	if hooked[tool] or not tool then return end
	hooked[tool] = true
	tool.Activated:Connect(overrideMouse)
	tool.Equipped:Connect(function()
		task.wait(0.1)
		local pm = getMouse()
		if pm and aimOn then
			local old = pm.Button1Down
			pm.Button1Down = function(...)
				overrideMouse()
				if old then old(...) end
			end
		end
	end)
end
function watchTools(parent)
	if not parent then return end
	for _, c in ipairs(parent:GetChildren()) do
		if TOOLS[c.Name] then hookTool(c) end
	end
	parent.ChildAdded:Connect(function(c)
		task.wait(0.05)
		if TOOLS[c.Name] then hookTool(c) end
	end)
end
watchTools(LP.Backpack)
if LP.Character then watchTools(LP.Character) end
LP.CharacterAdded:Connect(function(c)
	task.wait(0.2)
	watchTools(c)
	watchTools(LP.Backpack)
end)
RS.RenderStepped:Connect(function()
	if not aimOn then return end
	if tick() - lastAimUp > 0.1 then lastAimUp = tick(); bestEnemy() end
	if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then overrideMouse() end
end)
function setToolAim(on)
	-- LUÔN BẬT tool aimbot
	aimOn = true
	St.toolAim = true
	local char = LP.Character
	if char then pcall(watchTools, char) end
	local bp = LP:FindFirstChild("Backpack")
	if bp then pcall(watchTools, bp) end
	saveCfg()
end
-- boot tool aim
task.defer(function()
	aimOn = true
	St.toolAim = true
	pcall(function()
		if LP.Character then watchTools(LP.Character) end
		if LP.Backpack then watchTools(LP.Backpack) end
	end)
end)

----------------------------------------------------------------
-- DROP JUMP / STAND (Vis Clean)
----------------------------------------------------------------
local dropActive = false
local DROP_SPD, DROP_DUR = 200, 0.28
function runDrop()
	if dropActive then return end
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not root or not hum then return end
	local mode = tonumber(St.dropMode) or 2
	if mode == 1 then
		-- Stand / Fling style burst
		dropActive = true
		local t0 = tick()
		local conn
		conn = RS.Heartbeat:Connect(function()
			if not dropActive or tick() - t0 > 0.25 then
				if conn then conn:Disconnect() end
				dropActive = false
				if root and root.Parent then
					root.AssemblyLinearVelocity = Vector3.zero
				end
				return
			end
			local r = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
			if not r then return end
			local v = Vector3.new(0, r.AssemblyLinearVelocity.Y, 0)
			r.AssemblyLinearVelocity = v * 10000 + Vector3.new(0, 10000, 0)
		end)
		return
	end
	-- Jump ascend
	dropActive = true
	local t0 = tick()
	local conn
	conn = RS.Heartbeat:Connect(function()
		local c = LP.Character
		local r = c and c:FindFirstChild("HumanoidRootPart")
		if not r or not dropActive then
			if conn then conn:Disconnect() end
			dropActive = false
			return
		end
		if tick() - t0 >= DROP_DUR then
			if conn then conn:Disconnect() end
			local rp = RaycastParams.new()
			rp.FilterDescendantsInstances = { c }
			rp.FilterType = Enum.RaycastFilterType.Exclude
			local rr = workspace:Raycast(r.Position, Vector3.new(0, -3000, 0), rp)
			if rr then
				local h2 = c:FindFirstChildOfClass("Humanoid")
				local off = ((h2 and h2.HipHeight) or 2) + (r.Size.Y / 2)
				r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
			end
			r.AssemblyLinearVelocity = Vector3.zero
			r.AssemblyAngularVelocity = Vector3.zero
			dropActive = false
			return
		end
		r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, DROP_SPD, r.AssemblyLinearVelocity.Z)
	end)
end

----------------------------------------------------------------
-- INSTA RESET V1 / V2 (Vis)
----------------------------------------------------------------
local _resetBusy = false
local _resetCD = false
local INST_V2_POS = CFrame.new(2000.5, 9911.9, 4000.2)
function InstaResetV2()
	if _resetBusy then return end
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end
	_resetBusy = true
	local cam = workspace.CurrentCamera
	local lockCF = cam and cam.CFrame
	pcall(function()
		if cam then cam.CameraType = Enum.CameraType.Scriptable; cam.CFrame = lockCF end
		RS:BindToRenderStep("VisInstaV2Cam", Enum.RenderPriority.Camera.Value + 1, function()
			pcall(function()
				if cam then cam.CameraType = Enum.CameraType.Scriptable; if lockCF then cam.CFrame = lockCF end end
				local ac = LP.Character
				local ah = ac and ac:FindFirstChild("HumanoidRootPart")
				if ah then
					ah.AssemblyLinearVelocity = Vector3.zero
					ah.CFrame = INST_V2_POS
				end
			end)
		end)
	end)
	local conn
	conn = LP.CharacterAdded:Connect(function(newChar)
		if conn then conn:Disconnect() end
		pcall(function() RS:UnbindFromRenderStep("VisInstaV2Cam") end)
		local nh = newChar:WaitForChild("Humanoid", 5)
		task.wait(0.05)
		pcall(function()
			if cam and nh then cam.CameraSubject = nh; cam.CameraType = Enum.CameraType.Custom end
		end)
		_resetBusy = false
	end)
	task.delay(8, function()
		if _resetBusy then
			pcall(function() RS:UnbindFromRenderStep("VisInstaV2Cam") end)
			_resetBusy = false
		end
	end)
end

function InstaResetV1()
	-- V1: HipHeight kill — KHÔNG khóa camera, vẫn xoay ngang/dọc bình thường
	if _resetCD then return end
	local character = LP.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	if not character or not humanoid or not hrp then return end
	_resetCD = true
	_resetBusy = true
	local originalHip = humanoid.HipHeight
	local cam = workspace.CurrentCamera

	-- Giữ camera Custom — người chơi tự xoay, không Scriptable / không BindToRenderStep
	pcall(function()
		if cam then
			cam.CameraType = Enum.CameraType.Custom
			if humanoid then cam.CameraSubject = humanoid end
		end
		pcall(function() RS:UnbindFromRenderStep("VisInstaV1Cam") end)
		pcall(function() RS:UnbindFromRenderStep("VisInstaV2Cam") end)
	end)

	local charConn
	charConn = LP.CharacterAdded:Connect(function(newChar)
		if charConn then charConn:Disconnect() end
		local nh = newChar:WaitForChild("Humanoid", 5)
		task.wait(0.05)
		pcall(function()
			local c = workspace.CurrentCamera
			if c and nh then
				c.CameraSubject = nh
				c.CameraType = Enum.CameraType.Custom
			end
		end)
		_resetCD = false
		_resetBusy = false
	end)

	task.spawn(function()
		local attempts = 0
		while character and character.Parent and humanoid and attempts < 40 do
			if LP.Character ~= character then break end
			pcall(function()
				humanoid.PlatformStand = false
				humanoid.Sit = false
				pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end)
				pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Running) end)
				humanoid.HipHeight = 1e30
				humanoid.AutoRotate = true
				local rp = character:FindFirstChild("HumanoidRootPart")
				if rp then rp.CanCollide = false end
				for _, part in ipairs(character:GetChildren()) do
					if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
						part.CanCollide = false
					end
				end
				-- camera vẫn Custom mỗi frame (phòng script khác đổi)
				if cam then
					cam.CameraType = Enum.CameraType.Custom
					cam.CameraSubject = humanoid
				end
			end)
			if humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then break end
			attempts = attempts + 1
			task.wait(0.05)
		end
		if character and character.Parent and humanoid and humanoid.Health > 0 then
			pcall(function() humanoid.Health = 0 end)
		end
		if character and character.Parent and humanoid then
			pcall(function()
				humanoid.HipHeight = originalHip
				local rp = character:FindFirstChild("HumanoidRootPart")
				if rp then rp.CanCollide = true end
			end)
		end
		task.delay(5, function()
			if _resetBusy then
				_resetCD = false
				_resetBusy = false
			end
		end)
	end)
end

function doInstaReset()
	if St.instaMode == "V2" then InstaResetV2() else InstaResetV1() end
end

----------------------------------------------------------------
-- TP DOWN (Vis)
----------------------------------------------------------------
function doTPDown(force)
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum or hum.Health <= 0 then return end
	if not force then
		if hum.FloorMaterial ~= Enum.Material.Air then return end
		if hrp.Position.Y < 20 then return end
	end
	hrp.CFrame = CFrame.new(hrp.Position.X, -7, hrp.Position.Z)
		* CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
	hrp.AssemblyLinearVelocity = Vector3.zero
end

----------------------------------------------------------------
-- ESP + TRACER + ANTI LAG
----------------------------------------------------------------
local ESP = { on = false, data = {}, conns = {} }
function espCleanup(plr)
	local d = ESP.data[plr]
	if not d then return end
	pcall(function() if d.hl then d.hl:Destroy() end end)
	pcall(function() if d.bb then d.bb:Destroy() end end)
	pcall(function() if d.tracer then d.tracer:Remove() end end)
	ESP.data[plr] = nil
end
function espSetup(plr, char)
	if not ESP.on or plr == LP or not char then return end
	espCleanup(plr)
	local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 3)
	local head = char:FindFirstChild("Head")
	if not hrp then return end
	local hl = Instance.new("Highlight")
	hl.Adornee = char
	hl.FillColor = Color3.fromRGB(35, 35, 35)
	hl.FillTransparency = 0.7
	hl.OutlineColor = Color3.fromRGB(255, 255, 255)
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = char
	local bb, tracer
	if head then
		bb = Instance.new("BillboardGui")
		bb.Adornee = head
		bb.Size = UDim2.new(0, 100, 0, 20)
		bb.StudsOffset = Vector3.new(0, 2.5, 0)
		bb.AlwaysOnTop = true
		bb.Parent = head
		local t = Instance.new("TextLabel", bb)
		t.Size = UDim2.new(1, 0, 1, 0)
		t.BackgroundTransparency = 1
		t.Text = plr.DisplayName or plr.Name
		t.TextColor3 = Color3.new(1, 1, 1)
		t.TextSize = 12
		t.Font = Enum.Font.GothamBold
		t.TextStrokeTransparency = 0.5
	end
	if St.tracer then
		tracer = Drawing and Drawing.new and Drawing.new("Line")
		if tracer then
			tracer.Thickness = 1
			tracer.Color = Color3.fromRGB(255, 255, 255)
			tracer.Visible = true
		end
	end
	ESP.data[plr] = { hl = hl, bb = bb, tracer = tracer, hrp = hrp }
end
function startESP()
	if ESP.on then return end
	ESP.on = true
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then espSetup(plr, plr.Character) end
		table.insert(ESP.conns, plr.CharacterAdded:Connect(function(c)
			task.defer(espSetup, plr, c)
		end))
	end
	table.insert(ESP.conns, Players.PlayerAdded:Connect(function(plr)
		table.insert(ESP.conns, plr.CharacterAdded:Connect(function(c)
			task.defer(espSetup, plr, c)
		end))
	end))
	table.insert(ESP.conns, RS.RenderStepped:Connect(function()
		if not St.tracer then return end
		local cam = workspace.CurrentCamera
		local my = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
		if not cam or not my then return end
		local origin = cam:WorldToViewportPoint(my.Position)
		for plr, d in pairs(ESP.data) do
			if d.tracer and d.hrp and d.hrp.Parent then
				local p, onScreen = cam:WorldToViewportPoint(d.hrp.Position)
				d.tracer.From = Vector2.new(origin.X, origin.Y)
				d.tracer.To = Vector2.new(p.X, p.Y)
				d.tracer.Visible = onScreen and p.Z > 0
			elseif d.tracer then
				d.tracer.Visible = false
			end
		end
	end))
end
function stopESP()
	ESP.on = false
	for _, c in ipairs(ESP.conns) do pcall(function() c:Disconnect() end) end
	ESP.conns = {}
	for plr in pairs(ESP.data) do espCleanup(plr) end
end
function setESP(on)
	St.esp = on
	if on then startESP() else stopESP() end
	saveCfg()
end
function setTracer(on)
	St.tracer = on
	if St.esp then stopESP(); startESP() end
	saveCfg()
end

-- Anti Lag (Vis simplified)
local antiLagConn = nil
function applyDerender(obj)
	pcall(function()
		if obj:IsA("Accessory") or obj:IsA("Hat") then
			obj:Destroy()
		elseif obj:IsA("BasePart") then
			obj.Material = Enum.Material.Plastic
			obj.Reflectance = 0
			obj.CastShadow = false
		elseif obj:IsA("Decal") or obj:IsA("Texture") then
			obj.Transparency = 1
		elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
			or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
			obj.Enabled = false
		end
	end)
end
function setAntiLag(on)
	St.antiLag = on
	if on then
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 1e10
		Lighting.Brightness = 0
		for _, e in pairs(Lighting:GetChildren()) do
			if e:IsA("BlurEffect") or e:IsA("BloomEffect") or e:IsA("SunRaysEffect")
				or e:IsA("ColorCorrectionEffect") or e:IsA("DepthOfFieldEffect") then
				pcall(function() e.Enabled = false end)
			end
		end
		for _, obj in ipairs(workspace:GetDescendants()) do applyDerender(obj) end
		if antiLagConn then antiLagConn:Disconnect() end
		antiLagConn = workspace.DescendantAdded:Connect(applyDerender)
	else
		if antiLagConn then antiLagConn:Disconnect() antiLagConn = nil end
		Lighting.GlobalShadows = true
		Lighting.FogEnd = 100000
		Lighting.Brightness = 2
	end
	saveCfg()
end


----------------------------------------------------------------
-- INFINITE JUMP (Vis BloodHounds hold)
----------------------------------------------------------------
local InfJump = { enabled = false, conn = nil, last = 0 }
-- (InfJump moved above with BloodHounds speed)

-- AUTO DESTROY SENTRY (full from AutoDestroyTurret)
----------------------------------------------------------------
local GTurret = { AutoDestroyTurret = false }
local turretBusy = setmetatable({}, { __mode = "k" })
local turretQueued = setmetatable({}, { __mode = "k" })
local turretCD = setmetatable({}, { __mode = "k" })
local activeTurretAtk = 0
function isEnemyTurret(obj)
	if not obj or not obj:IsA("BasePart") then return false end
	local name, nameLower = obj.Name, obj.Name:lower()
	local ownerId = name:match("^Sentry_(%d+)$") or name:match("^sentry_(%d+)$")
	if not ownerId then
		ownerId = name:match("^CandySentry_(%d+)$") or name:match("^Candy_Sentry_(%d+)$")
			or name:match("^candy_sentry_(%d+)$") or nameLower:match("^candy[_%-]?sentry_(%d+)$")
	end
	if not ownerId and nameLower:find("candy") and nameLower:find("sentry") then
		ownerId = name:match("(%d+)$")
	end
	if not ownerId then ownerId = name:match("^[Tt]urret_(%d+)$") end
	if not ownerId and nameLower:find("sentry") then ownerId = name:match("(%d+)$") end
	return ownerId ~= nil and tostring(ownerId) ~= tostring(LP.UserId)
end
function setTurretNoClip(turret)
	if not isEnemyTurret(turret) then return end
	pcall(function()
		turret.CanCollide = false
		turret.Anchored = true
		turret.AssemblyLinearVelocity = Vector3.zero
		turret.AssemblyAngularVelocity = Vector3.zero
	end)
end
function getTurretTimeLabel(turret)
	if not turret or not turret.Parent then return nil end
	local sf = turret:FindFirstChild("SetupFrame")
	local mf = sf and sf:FindFirstChild("MainFrame")
	local tl = mf and mf:FindFirstChild("Time")
	if tl and tl:IsA("TextLabel") then return tl end
	for _, d in ipairs(turret:GetDescendants()) do
		if d:IsA("TextLabel") then
			local n = d.Name:lower()
			if n == "time" or n == "timer" or n == "countdown" then return d end
		end
	end
	return nil
end
function shouldAttackTurret(turret)
	if LP:GetAttribute("Stealing") ~= nil then return false end
	if not isEnemyTurret(turret) then return false end
	setTurretNoClip(turret)
	local timeLabel = getTurretTimeLabel(turret)
	if timeLabel then
		local ok, text = pcall(function() return timeLabel.Text end)
		if not ok then return false end
		text = tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
		if text == "" then return false end
		if string.find(text, "^%d+%s*[sS]!?$") or string.find(text, "^%d+$") then return true end
		return false
	end
	return true
end
function bringTurretInFront(turret, hrp)
	if not turret or not hrp then return end
	local forward = hrp.CFrame.LookVector
	local targetPos = hrp.Position + forward * 2.8 + Vector3.new(0, 1.15, 0)
	pcall(function()
		turret.AssemblyLinearVelocity = Vector3.zero
		turret.CFrame = CFrame.lookAt(targetPos, targetPos + forward)
	end)
end
function findBat()
	local char = LP.Character
	if not char then return nil end
	local bat = char:FindFirstChild("Bat") or LP.Backpack:FindFirstChild("Bat")
	if bat then return bat end
	for _, t in ipairs(char:GetChildren()) do
		if t:IsA("Tool") and t.Name:lower():find("bat") then return t end
	end
	for _, t in ipairs(LP.Backpack:GetChildren()) do
		if t:IsA("Tool") and t.Name:lower():find("bat") then return t end
	end
	return nil
end
function ensureBat(hum, char)
	local held = char:FindFirstChildOfClass("Tool")
	if held and (held.Name == "Bat" or held.Name:lower():find("bat")) then return held end
	local bat = findBat()
	if not bat then return nil end
	pcall(function() hum:EquipTool(bat) end)
	return char:FindFirstChild("Bat") or bat
end
function attackTurret(turret)
	local now = os.clock()
	if turretBusy[turret] or turretQueued[turret] then return end
	if activeTurretAtk >= 2 then return end
	if not shouldAttackTurret(turret) then return end
	if (turretCD[turret] or 0) > now then return end
	turretQueued[turret] = true
	turretCD[turret] = now + 0.15
	task.spawn(function()
		turretQueued[turret] = nil
		if activeTurretAtk >= 2 or turretBusy[turret] or not shouldAttackTurret(turret) then return end
		activeTurretAtk = activeTurretAtk + 1
		turretBusy[turret] = true
		pcall(function()
			local attempts, batReady = 0, false
			while attempts < 18 and GTurret.AutoDestroyTurret do
				if not turret or not turret.Parent or not shouldAttackTurret(turret) then break end
				local char = LP.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				if not hrp or not hum or hum.Health <= 0 then break end
				local okD, dist = pcall(function() return (turret.Position - hrp.Position).Magnitude end)
				if okD and dist > 250 then break end
				setTurretNoClip(turret)
				bringTurretInFront(turret, hrp)
				local bat
				if not batReady then
					bat = ensureBat(hum, char)
					batReady = bat ~= nil
				else
					bat = char:FindFirstChild("Bat") or findBat()
					local held = char:FindFirstChildOfClass("Tool")
					if held and held.Name ~= "Bat" and not held.Name:lower():find("bat") then break end
				end
				if bat then pcall(function() bat:Activate() end) end
				attempts = attempts + 1
				task.wait(0.045)
			end
		end)
		turretBusy[turret] = nil
		activeTurretAtk = math.max(0, activeTurretAtk - 1)
	end)
end
workspace.DescendantAdded:Connect(function(obj)
	if isEnemyTurret(obj) then setTurretNoClip(obj) end
	if GTurret.AutoDestroyTurret and shouldAttackTurret(obj) then task.defer(attackTurret, obj) end
end)
task.spawn(function()
	while task.wait(0.25) do
		if GTurret.AutoDestroyTurret then
			local pending = {}
			for _, obj in ipairs(workspace:GetDescendants()) do
				if isEnemyTurret(obj) then
					setTurretNoClip(obj)
					if shouldAttackTurret(obj) and not turretBusy[obj] then
						table.insert(pending, obj)
					end
				end
			end
			local char = LP.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hrp and #pending > 0 then
				table.sort(pending, function(a, b)
					return (a.Position - hrp.Position).Magnitude < (b.Position - hrp.Position).Magnitude
				end)
				for i = 1, math.min(2, #pending) do attackTurret(pending[i]) end
			end
		end
	end
end)
function setDestroySentry(on)
	St.destroySentry = on and true or false
	GTurret.AutoDestroyTurret = St.destroySentry
	if _G.VisRefreshSentryBtn then _G.VisRefreshSentryBtn() end
	saveCfg()
end

----------------------------------------------------------------
-- SPAM LASER CAPE / PAINTBALL (activate only, no auto-equip)
----------------------------------------------------------------
local spamConn = nil
function startSpamLoop()
	if spamConn then return end
	spamConn = RS.Heartbeat:Connect(function()
		local char = LP.Character
		if not char then return end
		local tool = char:FindFirstChildOfClass("Tool")
		if not tool then return end
		local n = tool.Name
		if St.spamLaser and n == "Laser Cape" then
			if aimOn then overrideMouse() end
			pcall(function() tool:Activate() end)
		elseif St.spamPaint and n == "Paintball Gun" then
			if aimOn then overrideMouse() end
			pcall(function() tool:Activate() end)
		end
	end)
end
function stopSpamLoopIfIdle()
	if not St.spamLaser and not St.spamPaint then
		if spamConn then pcall(function() spamConn:Disconnect() end) spamConn = nil end
	end
end
function setSpamLaser(on)
	St.spamLaser = on and true or false
	if St.spamLaser then startSpamLoop() else stopSpamLoopIfIdle() end
	saveCfg()
end
function setSpamPaint(on)
	St.spamPaint = on and true or false
	if St.spamPaint then startSpamLoop() else stopSpamLoopIfIdle() end
	saveCfg()
end

----------------------------------------------------------------
-- COUNTER: Laser Cape / Boogie Bomb / Swap Body / Equip on Drop
----------------------------------------------------------------
local counterConn = nil
local COUNTER_TOOL_NAMES = {
	laser = { "Laser Cape", "LaserCape", "laser cape" },
	boogie = { "Boogie Bomb", "BoogieBomb", "boogie bomb", "Disco Ball" },
	swap = { "Body Swap Potion", "Swap Body", "Body Swap", "SwapBody", "Potion of Body Swap" },
}

local function findToolByNames(names)
	local char = LP.Character
	local bp = LP:FindFirstChild("Backpack")
	for _, nm in ipairs(names) do
		if char then
			local t = char:FindFirstChild(nm)
			if t and t:IsA("Tool") then return t end
		end
		if bp then
			local t = bp:FindFirstChild(nm)
			if t and t:IsA("Tool") then return t end
		end
	end
	-- fuzzy
	local function scan(parent)
		if not parent then return nil end
		for _, ch in ipairs(parent:GetChildren()) do
			if ch:IsA("Tool") then
				local ln = string.lower(ch.Name)
				for _, nm in ipairs(names) do
					if ln:find(string.lower(nm), 1, true) then return ch end
				end
			end
		end
		return nil
	end
	return scan(char) or scan(bp)
end

local function equipAndActivate(tool)
	if not tool then return end
	local char = LP.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	pcall(function()
		if tool.Parent ~= char then
			hum:EquipTool(tool)
		end
	end)
	task.defer(function()
		pcall(function() tool:Activate() end)
	end)
end

function startCounterLoop()
	-- Không spam Activate khi chọn counter — chỉ dùng lúc Drop
	if counterConn then
		pcall(function() counterConn:Disconnect() end)
		counterConn = nil
	end
end

function stopCounterLoopIfIdle()
	if not (St.counterLaser or St.counterBoogie or St.counterSwapBody or St.equipOnDrop) then
		if counterConn then pcall(function() counterConn:Disconnect() end) counterConn = nil end
	end
end

local function _counterExclusive(which)
	-- Chỉ 1 counter bật: tắt các cái còn lại
	St.counterLaser = (which == "laser")
	St.counterBoogie = (which == "boogie")
	St.counterSwapBody = (which == "swap")
	if ToggleRefs then
		for k, flag in pairs({counterLaser = (which=="laser"), counterBoogie = (which=="boogie"), counterSwapBody = (which=="swap")}) do
			local r = ToggleRefs[k]
			if r and r.setVisual then pcall(r.setVisual, flag) end
		end
	end
end

function setCounterLaser(on)
	if on then
		_counterExclusive("laser")
		-- chỉ lưu lựa chọn; equip+activate x2 khi Drop
		stopCounterLoopIfIdle()
	else
		St.counterLaser = false
		stopCounterLoopIfIdle()
	end
	saveCfg()
end
function setCounterBoogie(on)
	if on then
		_counterExclusive("boogie")
		-- chỉ lưu lựa chọn; equip+activate x2 khi Drop
		stopCounterLoopIfIdle()
	else
		St.counterBoogie = false
		stopCounterLoopIfIdle()
	end
	saveCfg()
end
function setCounterSwapBody(on)
	if on then
		_counterExclusive("swap")
		-- chỉ lưu lựa chọn; equip+activate x2 khi Drop
		stopCounterLoopIfIdle()
	else
		St.counterSwapBody = false
		stopCounterLoopIfIdle()
	end
	saveCfg()
end
function setEquipOnDrop(on)
	St.equipOnDrop = on and true or false
	saveCfg()
end

-- Equip + activate khi Drop xong
_G.VisCounterOnDrop = function()
	-- Counter đã chọn: equip 1 + activate 2 khi Drop (Fling & Jump)
	local anyCounter = St.counterLaser or St.counterBoogie or St.counterSwapBody
	if not anyCounter and not St.equipOnDrop then return end
	if _G._VisCounterDropBusy == true then return end
	_G._VisCounterDropBusy = true
	task.spawn(function()
		local char = LP.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local prevTool = char and char:FindFirstChildOfClass("Tool")
		local prevName = prevTool and prevTool.Name or nil
		task.wait(0.2)
		local function runOnce(names)
			local tool = findToolByNames(names)
			if not tool then return end
			equipAndActivate(tool) -- equip + activate #1
			task.wait(0.15)
			pcall(function() tool:Activate() end) -- activate #2
			task.wait(0.1)
		end
		if St.counterLaser then runOnce(COUNTER_TOOL_NAMES.laser) end
		if St.counterBoogie then runOnce(COUNTER_TOOL_NAMES.boogie) end
		if St.counterSwapBody then runOnce(COUNTER_TOOL_NAMES.swap) end
		task.wait(0.1)
		pcall(function()
			local c = LP.Character
			local h = c and c:FindFirstChildOfClass("Humanoid")
			if not h or not prevName then return end
			local pl = string.lower(prevName)
			local isCounter = false
			for _, names in pairs(COUNTER_TOOL_NAMES) do
				for _, nm in ipairs(names) do
					if pl:find(string.lower(nm), 1, true) then isCounter = true break end
				end
				if isCounter then break end
			end
			if not isCounter then
				local bp = LP:FindFirstChild("Backpack")
				local t = (c and c:FindFirstChild(prevName)) or (bp and bp:FindFirstChild(prevName))
				if t and t:IsA("Tool") then h:EquipTool(t) end
			end
		end)
		_G._VisCounterDropBusy = false
	end)
end

-- Bật toggle Counter: equip 1 + activate 2 (một lần)
_G.VisCounterOneShot = function(kind)
	if _G._VisCounterDropBusy then return end
	_G._VisCounterDropBusy = true
	task.spawn(function()
		local names = COUNTER_TOOL_NAMES[kind]
		if not names then _G._VisCounterDropBusy = false return end
		local tool = findToolByNames(names)
		if tool then
			equipAndActivate(tool)
			task.wait(0.15)
			pcall(function() tool:Activate() end)
		end
		_G._VisCounterDropBusy = false
	end)
end



function corner(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 10)
	c.Parent = p
	return c
end
function stroke(p, col)
	local s = Instance.new("UIStroke")
	s.Color = col or C.stroke
	s.Thickness = 1
	s.Transparency = 0.35
	s.Parent = p
	return s
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "VisHubFullMenu"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 200
Gui.Parent = PlayerGui

local MW, MH = 310, 380
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, MW, 0, MH)
Main.Position = UDim2.new(0.5, -MW / 2, 0.5, -MH / 2)
Main.BackgroundColor3 = C.bg
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Main.Parent = Gui

-- Menu scale (to/nhỏ menu chính)
local menuScaleObj = Instance.new("UIScale")
menuScaleObj.Name = "VisMenuScale"
menuScaleObj.Scale = tonumber(St.menuScale) or 1
menuScaleObj.Parent = Main
function applyMenuScale()
	local sc = math.clamp(tonumber(St.menuScale) or 1, 0.5, 1.5)
	St.menuScale = sc
	if menuScaleObj and menuScaleObj.Parent then
		menuScaleObj.Scale = sc
	else
		-- fallback: resize Main
		local baseW, baseH = 270, 360
		Main.Size = UDim2.new(0, math.floor(baseW * sc), 0, math.floor(baseH * sc))
	end
end
pcall(applyMenuScale)
-- restore menu position
pcall(function()
	local p = St._mainPos
	if type(p) == "table" and p[1] ~= nil then
		Main.Position = UDim2.new(p[1], p[2], p[3], p[4])
	end
end)

corner(Main, 14)
local mainStroke = stroke(Main)
mainStroke.Thickness = 2.2
mainStroke.Transparency = 0
-- Empire-style animated outline gradient
do
	local g = Instance.new("UIGradient")
	g.Name = "EmpireOutlineGrad"
	g.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.15, Color3.fromRGB(255, 140, 200)),
		ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 45, 160)),
		ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 20, 140)),
		ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 80, 180)),
		ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 150, 210)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
	})
	g.Parent = mainStroke
	task.spawn(function()
		local t0 = tick()
		while mainStroke and mainStroke.Parent do
			local t = (tick() - t0) * 0.35
			g.Rotation = (t * 60) % 360
			task.wait(0.03)
		end
	end)
end

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 36)
Top.BackgroundColor3 = C.bg2
Top.BorderSizePixel = 0
Top.ZIndex = 15
Top.Active = true
Top.Parent = Main
corner(Top, 14)
local topFix = Instance.new("Frame")
topFix.Size = UDim2.new(1, 0, 0, 12)
topFix.Position = UDim2.new(0, 0, 1, -12)
topFix.BackgroundColor3 = C.bg2
topFix.BorderSizePixel = 0
topFix.Parent = Top

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Free Sell Là Tuất Ngu Lồn"
Title.TextColor3 = Color3.fromRGB(255, 230, 245)
Title.TextSize = 12
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextStrokeTransparency = 0.55
Title.TextStrokeColor3 = Color3.fromRGB(255, 80, 160)
Title.Parent = Top
-- gradient chữ menu
local titleGrad = Instance.new("UIGradient")
titleGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 160, 210)),
	ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255, 90, 180)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 140, 255)),
})
titleGrad.Parent = Title
task.spawn(function()
	local t0 = tick()
	while Title and Title.Parent do
		titleGrad.Offset = Vector2.new((math.sin(tick() - t0) * 0.35), 0)
		task.wait(0.03)
	end
end)

-- Close nút nhỏ góc phải (phụ)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -11)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 32, 48)
CloseBtn.Text = "−"
CloseBtn.TextColor3 = C.textDim
CloseBtn.TextSize = 11
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Top
corner(CloseBtn, 6)

-- Helper tròn bên TRÁI menu (LKZ style) — ấn = đóng
local Helper = Instance.new("TextButton")
Helper.Name = "HelperClose"
Helper.Size = UDim2.new(0, 44, 0, 44)
Helper.Position = UDim2.new(0, -52, 0, 8)
Helper.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
Helper.Text = "⚔"
Helper.TextColor3 = C.accent
Helper.TextSize = 18
Helper.Font = Enum.Font.GothamBold
Helper.AutoButtonColor = false
Helper.Parent = Main
corner(Helper, 22)
local hs = Instance.new("UIStroke", Helper)
hs.Color = C.accent
hs.Thickness = 2
hs.Transparency = 0.15

-- Tabs dọc (Clean style) — PC kéo xuống được
local TAB_W = 72
local TabBar = Instance.new("ScrollingFrame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(0, TAB_W, 1, -48)
TabBar.Position = UDim2.new(0, 4, 0, 44)
TabBar.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
TabBar.BackgroundTransparency = 0.25
TabBar.BorderSizePixel = 0
TabBar.ScrollBarThickness = 4
TabBar.ScrollBarImageColor3 = C.accent
TabBar.ScrollingDirection = Enum.ScrollingDirection.Y
TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
TabBar.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabBar.ZIndex = 20
TabBar.Active = true
TabBar.Selectable = true
TabBar.Parent = Main
corner(TabBar, 8)
local tabList = Instance.new("UIListLayout", TabBar)
tabList.FillDirection = Enum.FillDirection.Vertical
tabList.Padding = UDim.new(0, 4)
tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabList.SortOrder = Enum.SortOrder.LayoutOrder
local tabPad = Instance.new("UIPadding", TabBar)
tabPad.PaddingTop = UDim.new(0, 4)
tabPad.PaddingBottom = UDim.new(0, 6)
tabPad.PaddingLeft = UDim.new(0, 3)
tabPad.PaddingRight = UDim.new(0, 3)

local pages, tabBtns = {}, {}
function makePage(name)
	local sc = Instance.new("ScrollingFrame")
	sc.Name = name
	-- Nội dung bên phải tab dọc
	sc.Size = UDim2.new(1, -(TAB_W + 10), 1, -52)
	sc.Position = UDim2.new(0, TAB_W + 8, 0, 48)
	sc.BackgroundTransparency = 1
	sc.BorderSizePixel = 0
	sc.ScrollBarThickness = 4
	sc.ScrollBarImageColor3 = C.accent
	sc.ScrollingDirection = Enum.ScrollingDirection.Y
	sc.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sc.CanvasSize = UDim2.new(0, 0, 0, 0)
	sc.Visible = false
	sc.ZIndex = 10
	sc.Active = true
	sc.Selectable = true
	sc.Parent = Main
	local pad = Instance.new("UIPadding", sc)
	pad.PaddingTop = UDim.new(0, 4)
	pad.PaddingBottom = UDim.new(0, 10)
	pad.PaddingLeft = UDim.new(0, 6)
	pad.PaddingRight = UDim.new(0, 8)
	local lay = Instance.new("UIListLayout", sc)
	lay.Padding = UDim.new(0, 5)
	lay.SortOrder = Enum.SortOrder.LayoutOrder
	sc.Active = true
	sc.Selectable = true
	pages[name] = sc
	return sc
end
local pagePlayer = makePage("Player")
local pageESP = makePage("ESP")
local pageSpam = makePage("Spam")
local pageCounter = makePage("Counter")
local pageSet = makePage("Settings")
local pageKeys = makePage("Keybinds")

function setTab(name)
	for n, p in pairs(pages) do
		p.Visible = (n == name)
		p.ZIndex = 3
	end
	for n, b in pairs(tabBtns) do
		local on = n == name
		b.BackgroundColor3 = on and C.accent or C.card
		b.TextColor3 = on and Color3.fromRGB(30, 20, 30) or C.text
	end
end
function addTab(name, order)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -4, 0, 28)
	b.BackgroundColor3 = C.card
	b.Text = name
	b.TextColor3 = C.text
	b.TextSize = 11
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.LayoutOrder = order
	b.Active = true
	b.Selectable = true
	b.ZIndex = 21
	b.Parent = TabBar
	corner(b, 8)
	local function go() setTab(name) end
	b.MouseButton1Click:Connect(go)
	b.Activated:Connect(go)
	tabBtns[name] = b
end
addTab("Player", 1)
addTab("ESP", 2)
addTab("Spam", 3)
addTab("Counter", 4)
addTab("Settings", 5)
addTab("Keybinds", 6)

function section(parent, text, order)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(1, 0, 0, 16)
	f.BackgroundTransparency = 1
	f.LayoutOrder = order
	f.Parent = parent
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, 0, 1, 0)
	t.BackgroundTransparency = 1
	t.Text = text
	t.TextColor3 = C.textDim
	t.TextSize = 11
	t.Font = Enum.Font.GothamBold
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = f
end
function row(parent, h, order)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(1, 0, 0, h or 38)
	f.BackgroundColor3 = C.card
	f.BorderSizePixel = 0
	f.LayoutOrder = order
	f.Active = true
	f.Parent = parent
	corner(f, 9)
	stroke(f)
	return f
end
function toggle(parent, label, default, cb, order)
	local r = row(parent, 38, order)
	local txt = Instance.new("TextLabel")
	txt.Size = UDim2.new(1, -60, 1, 0)
	txt.Position = UDim2.new(0, 12, 0, 0)
	txt.BackgroundTransparency = 1
	txt.Text = label
	txt.TextColor3 = C.text
	txt.TextSize = 13
	txt.Font = Enum.Font.Gotham
	txt.TextXAlignment = Enum.TextXAlignment.Left
	txt.Parent = r
	local track = Instance.new("Frame")
	track.Size = UDim2.new(0, 40, 0, 22)
	track.Position = UDim2.new(1, -50, 0.5, -11)
	track.BackgroundColor3 = default and C.on or C.off
	track.BorderSizePixel = 0
	track.Parent = r
	corner(track, 11)
	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 18, 0, 18)
	knob.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
	knob.BackgroundColor3 = Color3.new(1, 1, 1)
	knob.BorderSizePixel = 0
	knob.Parent = track
	corner(knob, 9)
	local state = default
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.Parent = r
	local function apply(on)
		state = on and true or false
		TS:Create(track, TweenInfo.new(0.15), { BackgroundColor3 = state and C.on or C.off }):Play()
		TS:Create(knob, TweenInfo.new(0.15), {
			Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
		}):Play()
		if cb then pcall(cb, state) end
		pcall(saveCfg)
	end
	btn.Active = true
	btn.Selectable = true
	btn.ZIndex = 50
	track.ZIndex = 6
	knob.ZIndex = 7
	r.Active = true
	local _busy = false
	local function fireToggle()
		if _busy then return end
		_busy = true
		apply(not state)
		task.delay(0.15, function() _busy = false end)
	end
	btn.MouseButton1Click:Connect(fireToggle)
	btn.Activated:Connect(fireToggle)
	-- mobile fallback: InputEnded short tap
	do
		local down, startP
		btn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				down = true
				startP = input.Position
			end
		end)
		btn.InputEnded:Connect(function(input)
			if not down then return end
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
			down = false
			if startP and (input.Position - startP).Magnitude < 12 then
				fireToggle()
			end
		end)
	end
	local function setVisualOnly(on)
		state = on and true or false
		TS:Create(track, TweenInfo.new(0.12), { BackgroundColor3 = state and C.on or C.off }):Play()
		TS:Create(knob, TweenInfo.new(0.12), {
			Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
		}):Play()
	end
	return {
		set = apply,
		setVisual = setVisualOnly,
		get = function() return state end,
	}
end
function toggleNamed(parent, label, default, cb, order, refName)
	local api = toggle(parent, label, default, cb, order)
	if refName then ToggleRefs[refName] = api end
	return api
end
function numBox(parent, pos, w, val, cb)
	local b = Instance.new("TextBox")
	b.Size = UDim2.new(0, w, 0, 24)
	b.Position = pos
	b.BackgroundColor3 = C.box
	b.Text = tostring(val)
	b.TextColor3 = C.text
	b.TextSize = 12
	b.Font = Enum.Font.GothamBold
	b.ClearTextOnFocus = false
	b.Active = true
	b.ZIndex = 25
	b.Parent = parent
	corner(b, 6)
	b.FocusLost:Connect(function()
		local n = tonumber(b.Text)
		if n then
			n = math.clamp(n, 1, 200)
			b.Text = tostring(n)
			if cb then cb(n) end
		else
			b.Text = tostring(val)
		end
	end)
	return b
end
function keyName(k)
	return k and tostring(k):gsub("Enum.KeyCode.", "") or "?"
end
local listening = nil
function keyBtn(parent, key, onSet, pos)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 36, 0, 24)
	b.Position = pos or UDim2.new(0, 0, 0, 0)
	b.BackgroundColor3 = C.box
	b.Text = keyName(key)
	b.TextColor3 = C.text
	b.TextSize = 11
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Active = true
	b.ZIndex = 25
	b.Parent = parent
	corner(b, 6)
	b.MouseButton1Click:Connect(function()
		if listening then return end
		listening = b
		b.Text = "..."
		local conn
		conn = UIS.InputBegan:Connect(function(input, gp)
			if gp or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
			if input.KeyCode == Enum.KeyCode.Escape then
				b.Text = keyName(key)
				listening = nil
				conn:Disconnect()
				return
			end
			key = input.KeyCode
			b.Text = keyName(key)
			listening = nil
			conn:Disconnect()
			if onSet then onSet(key) end
		end)
	end)
	return b
end
function actionBtn(parent, text, color, cb, order)
	local r = row(parent, 36, order)
	r.BackgroundColor3 = color or C.accent
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 1, 0)
	b.BackgroundTransparency = 1
	b.Text = text
	b.TextColor3 = Color3.fromRGB(30, 20, 30)
	b.TextSize = 13
	b.Font = Enum.Font.GothamBold
	b.Parent = r
	b.Active = true
	b.ZIndex = 20
	local _busy = false
	local function fire()
		if _busy then return end
		_busy = true
		if cb then pcall(cb) end
		task.delay(0.15, function() _busy = false end)
	end
	b.MouseButton1Click:Connect(fire)
	b.Activated:Connect(fire)
	return r
end

----------------------------------------------------------------
-- PLAYER TAB
----------------------------------------------------------------
section(pagePlayer, "* — ANTI", 1)
toggleNamed(pagePlayer, "Anti Gummy Bear", St.antiGummy, setAntiGummy, 2, "antiGummy")
toggleNamed(pagePlayer, "Anti Ragdoll", St.antiRagdoll, setAntiRagdoll, 3, "antiRagdoll")
do
	local r = row(pagePlayer, 36, 3.5)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(0.4, 0, 1, 0)
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = C.textDim
	label.Text = "  Mode"
	label.Parent = r
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(0.55, 0, 0, 26)
	holder.Position = UDim2.new(0.42, 0, 0.5, -13)
	holder.BackgroundColor3 = C.box
	holder.BorderSizePixel = 0
	holder.Parent = r
	local hc = Instance.new("UICorner")
	hc.CornerRadius = UDim.new(0, 8)
	hc.Parent = holder
	local slide = Instance.new("Frame")
	slide.Size = UDim2.new(0.5, -6, 1, -6)
	slide.Position = UDim2.new(0, 3, 0, 3)
	slide.BackgroundColor3 = C.accent
	slide.BorderSizePixel = 0
	slide.ZIndex = 2
	slide.Parent = holder
	local sc = Instance.new("UICorner")
	sc.CornerRadius = UDim.new(0, 6)
	sc.Parent = slide
	local t1 = Instance.new("TextLabel")
	t1.BackgroundTransparency = 1
	t1.Size = UDim2.new(0.5, 0, 1, 0)
	t1.Font = Enum.Font.GothamBold
	t1.TextSize = 11
	t1.Text = "V1"
	t1.TextColor3 = C.text
	t1.ZIndex = 3
	t1.Parent = holder
	local t2 = Instance.new("TextLabel")
	t2.BackgroundTransparency = 1
	t2.Size = UDim2.new(0.5, 0, 1, 0)
	t2.Position = UDim2.new(0.5, 0, 0, 0)
	t2.Font = Enum.Font.GothamBold
	t2.TextSize = 11
	t2.Text = "V2"
	t2.TextColor3 = C.text
	t2.ZIndex = 3
	t2.Parent = holder
	local function refresh()
		local isV2 = tostring(St.antiRagdollMode or "V1"):upper() == "V2"
		slide.Position = isV2 and UDim2.new(0.5, 2, 0, 3) or UDim2.new(0, 3, 0, 3)
		t1.TextTransparency = isV2 and 0.35 or 0
		t2.TextTransparency = isV2 and 0 or 0.35
	end
	_G.VisRefreshAntiRagMode = refresh
	local b1 = Instance.new("TextButton")
	b1.BackgroundTransparency = 1
	b1.Size = UDim2.new(0.5, 0, 1, 0)
	b1.Text = ""
	b1.ZIndex = 4
	b1.Parent = holder
	b1.MouseButton1Click:Connect(function() setAntiRagdollMode("V1"); refresh() end)
	local b2 = Instance.new("TextButton")
	b2.BackgroundTransparency = 1
	b2.Size = UDim2.new(0.5, 0, 1, 0)
	b2.Position = UDim2.new(0.5, 0, 0, 0)
	b2.Text = ""
	b2.ZIndex = 4
	b2.Parent = holder
	b2.MouseButton1Click:Connect(function() setAntiRagdollMode("V2"); refresh() end)
	refresh()
end
toggleNamed(pagePlayer, "Anti Paintball Gun", St.antiPaint, setAntiPaint, 4, "antiPaint")
toggleNamed(pagePlayer, "Anti Boogie Bomb", St.antiBoogie, setAntiBoogie, 5, "antiBoogie")

section(pagePlayer, "* — SPEED (Vis S2)", 10)
toggleNamed(pagePlayer, "Speed On", St.speedOn, setSpeedOn, 11, "speedOn")

local modeCards = {}
function modeCard(name, desc, order)
	local m = St.modes[name]
	local r = row(pagePlayer, 58, order)
	modeCards[name] = r
	local nm = Instance.new("TextLabel")
	nm.Size = UDim2.new(0, 130, 0, 18)
	nm.Position = UDim2.new(0, 12, 0, 6)
	nm.BackgroundTransparency = 1
	nm.Text = name .. " Speed"
	nm.TextColor3 = C.text
	nm.TextSize = 13
	nm.Font = Enum.Font.GothamBold
	nm.TextXAlignment = Enum.TextXAlignment.Left
	nm.Parent = r
	local ds = Instance.new("TextLabel")
	ds.Size = UDim2.new(0, 140, 0, 14)
	ds.Position = UDim2.new(0, 12, 0, 24)
	ds.BackgroundTransparency = 1
	ds.Text = desc
	ds.TextColor3 = C.textDim
	ds.TextSize = 10
	ds.Font = Enum.Font.Gotham
	ds.TextXAlignment = Enum.TextXAlignment.Left
	ds.Parent = r
	-- Keybind PC: giữa khoảng norm ↔ steal
	keyBtn(r, m.key, function(k) St.modes[name].key = k; saveCfg() end, UDim2.new(1, -112, 0, 28))
	local ln = Instance.new("TextLabel")
	ln.Size = UDim2.new(0, 48, 0, 12)
	ln.Position = UDim2.new(1, -150, 0, 4)
	ln.BackgroundTransparency = 1
	ln.Text = "norm"
	ln.TextColor3 = C.textDim
	ln.TextSize = 9
	ln.Font = Enum.Font.Gotham
	ln.Parent = r
	local ls = Instance.new("TextLabel")
	ls.Size = UDim2.new(0, 48, 0, 12)
	ls.Position = UDim2.new(1, -72, 0, 4)
	ls.BackgroundTransparency = 1
	ls.Text = "steal"
	ls.TextColor3 = C.textDim
	ls.TextSize = 9
	ls.Font = Enum.Font.Gotham
	ls.Parent = r
	numBox(r, UDim2.new(1, -150, 0, 20), 48, m.norm, function(v)
		St.modes[name].norm = math.clamp(tonumber(v) or 59, 1, 200)
		if St.activeMode == name then
			currentSpeedValue = getActiveMoveSpeed()
			if speedConnection then pcall(function() speedConnection:Disconnect() end); speedConnection = nil end
			if St.speedOn then pcall(startSpeedBoost) end
		end
		saveCfg()
	end)
	numBox(r, UDim2.new(1, -72, 0, 20), 48, m.steal, function(v)
		St.modes[name].steal = math.clamp(tonumber(v) or 30, 1, 200)
		if St.activeMode == name then
			currentSpeedValue = getActiveMoveSpeed()
			if speedConnection then pcall(function() speedConnection:Disconnect() end); speedConnection = nil end
			if St.speedOn then pcall(startSpeedBoost) end
		end
		saveCfg()
	end)
	local hit = Instance.new("TextButton")
	hit.Size = UDim2.new(0.45, 0, 1, 0)
	hit.BackgroundTransparency = 1
	hit.Text = ""
	hit.Active = true
	hit.ZIndex = 15
	hit.Parent = r
	hit.MouseButton1Click:Connect(function() setActiveMode(name) end)
	hit.Activated:Connect(function() setActiveMode(name) end)
end
modeCard("Normal", "default mode", 12)
modeCard("Lagger", "use against lagger", 13)
modeCard("Custom", "custom spd", 14)
function _G.VisRefreshModeCards()
	for n, card in pairs(modeCards) do
		local st = card:FindFirstChildOfClass("UIStroke")
		if st then
			local on = St.activeMode == n
			st.Color = on and C.accent or C.stroke
			st.Transparency = on and 0.05 or 0.35
		end
	end
end
_G.VisRefreshModeCards()


-- ============================================================
-- Ragdoll TP Left/Right removed

section(pagePlayer, "* — COMBAT / DROP / RESET", 20)
toggleNamed(pagePlayer, "Tool Aimbot", St.toolAim, setToolAim, 21, "toolAim")
toggleNamed(pagePlayer, "Body Lock", St.bodyLock == true, setBodyLock, 22, "bodyLock")
do
	local rr = row(pagePlayer, 36, 22)
	local rl = Instance.new("TextLabel")
	rl.Size = UDim2.new(0.55, 0, 1, 0)
	rl.BackgroundTransparency = 1
	rl.Text = "Body Lock Range"
	rl.TextColor3 = C.text
	rl.TextSize = 12
	rl.Font = Enum.Font.Gotham
	rl.TextXAlignment = Enum.TextXAlignment.Left
	rl.Parent = rr
	numBox(rr, UDim2.new(1, -70, 0.5, -12), 56, tonumber(St.bodyLockRange) or 20, function(v)
		setBodyLockRange(v)
	end)
end
-- Ragdoll TP Left/Right removed from menu

toggleNamed(pagePlayer, "Infinite Jump (Hold)", St.infJump, setInfJump, 215, "infJump")
toggleNamed(pagePlayer, "Auto Destroy Sentry", St.destroySentry, setDestroySentry, 216, "destroySentry")
-- drop mode
local dropRow = row(pagePlayer, 38, 22)
local dropLbl = Instance.new("TextLabel")
dropLbl.Size = UDim2.new(0.4, 0, 1, 0)
dropLbl.Position = UDim2.new(0, 12, 0, 0)
dropLbl.BackgroundTransparency = 1
dropLbl.Text = "Drop Mode"
dropLbl.TextColor3 = C.text
dropLbl.TextSize = 13
dropLbl.Font = Enum.Font.Gotham
dropLbl.TextXAlignment = Enum.TextXAlignment.Left
dropLbl.Parent = dropRow
for i, name in ipairs({ "Stand", "Jump" }) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 60, 0, 26)
	b.Position = UDim2.new(1, -140 + (i - 1) * 66, 0.5, -13)
	b.BackgroundColor3 = ((St.dropMode == 1 and name == "Stand") or (St.dropMode == 2 and name == "Jump")) and C.accent or C.box
	b.Text = name
	b.TextColor3 = ((St.dropMode == 1 and name == "Stand") or (St.dropMode == 2 and name == "Jump")) and Color3.fromRGB(30, 20, 30) or C.text
	b.TextSize = 11
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Parent = dropRow
	corner(b, 7)
	b.Active = true
	b.ZIndex = 40
	function pickDrop()
		St.dropMode = (name == "Jump") and 2 or 1
		for _, ch in ipairs(dropRow:GetChildren()) do
			if ch:IsA("TextButton") then
				local on = (St.dropMode == 2 and ch.Text == "Jump") or (St.dropMode == 1 and ch.Text == "Stand")
				ch.BackgroundColor3 = on and C.accent or C.box
				ch.TextColor3 = on and Color3.fromRGB(30, 20, 30) or C.text
			end
		end
		pcall(saveCfg)
	end
	b.MouseButton1Click:Connect(pickDrop)
	b.Activated:Connect(pickDrop)
end
actionBtn(pagePlayer, "Drop Now", C.accent, runDrop, 23)

local instaRow = row(pagePlayer, 38, 24)
local instaLbl = Instance.new("TextLabel")
instaLbl.Size = UDim2.new(0.4, 0, 1, 0)
instaLbl.Position = UDim2.new(0, 12, 0, 0)
instaLbl.BackgroundTransparency = 1
instaLbl.Text = "Insta Reset"
instaLbl.TextColor3 = C.text
instaLbl.TextSize = 13
instaLbl.Font = Enum.Font.Gotham
instaLbl.TextXAlignment = Enum.TextXAlignment.Left
instaLbl.Parent = instaRow
for i, name in ipairs({ "V1", "V2" }) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 48, 0, 26)
	b.Position = UDim2.new(1, -120 + (i - 1) * 54, 0.5, -13)
	b.BackgroundColor3 = (St.instaMode == name) and C.accent or C.box
	b.Text = name
	b.TextColor3 = (St.instaMode == name) and Color3.fromRGB(30, 20, 30) or C.text
	b.TextSize = 11
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Parent = instaRow
	corner(b, 7)
	b.Active = true
	b.ZIndex = 40
	function pickInsta()
		St.instaMode = name
		for _, ch in ipairs(instaRow:GetChildren()) do
			if ch:IsA("TextButton") then
				local on = ch.Text == St.instaMode
				ch.BackgroundColor3 = on and C.accent or C.box
				ch.TextColor3 = on and Color3.fromRGB(30, 20, 30) or C.text
			end
		end
		pcall(saveCfg)
	end
	b.MouseButton1Click:Connect(pickInsta)
	b.Activated:Connect(pickInsta)
end
actionBtn(pagePlayer, "Insta Reset Now", C.danger, doInstaReset, 25)
actionBtn(pagePlayer, "TP Down", C.accent, function() doTPDown(true) end, 26)

section(pagePlayer, "* — KEYBINDS", 30)
function keyRow(label, keyId, order)
	local r = row(pagePlayer, 36, order)
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, -56, 1, 0)
	t.Position = UDim2.new(0, 12, 0, 0)
	t.BackgroundTransparency = 1
	t.Text = label
	t.TextColor3 = C.text
	t.TextSize = 13
	t.Font = Enum.Font.Gotham
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = r
	keyBtn(r, St.keys[keyId], function(k) St.keys[keyId] = k; saveCfg() end, UDim2.new(1, -48, 0.5, -12))
end
keyRow("Key Drop", "Drop", 31)
keyRow("Key TP Down", "TPDown", 32)
keyRow("Key Insta Reset", "InstaReset", 33)
keyRow("Key Destroy Sentry", "DestroySentry", 34)
keyRow("Key Auto Steal", "AutoSteal", 35)

-- Full KEYBINDS TAB
if pageKeys then
	section(pageKeys, "* — KEYBINDS (PC) — None = không phím", 1)
	local function keyRowTab(label, keyId, order)
		local r = row(pageKeys, 36, order)
		local t = Instance.new("TextLabel")
		t.Size = UDim2.new(1, -100, 1, 0)
		t.Position = UDim2.new(0, 12, 0, 0)
		t.BackgroundTransparency = 1
		t.Text = label
		t.TextColor3 = C.text
		t.TextSize = 13
		t.Font = Enum.Font.Gotham
		t.TextXAlignment = Enum.TextXAlignment.Left
		t.Parent = r
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0, 88, 0, 28)
		b.Position = UDim2.new(1, -96, 0.5, -14)
		b.BackgroundColor3 = C.box
		b.TextColor3 = C.text
		b.TextSize = 12
		b.Font = Enum.Font.GothamBold
		b.AutoButtonColor = false
		b.Parent = r
		corner(b, 7)
		local function refresh()
			local k = St.keys and St.keys[keyId]
			if not k or k == Enum.KeyCode.Unknown then
				b.Text = "None"
			else
				b.Text = tostring(k.Name or k)
			end
		end
		refresh()
		local listening = false
		local function startListen()
			if listening then return end
			listening = true
			b.Text = "..."
			b.BackgroundColor3 = C.accent
			local conn
			conn = UIS.InputBegan:Connect(function(inp, gp)
				if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
				local code = inp.KeyCode
				if code == Enum.KeyCode.Escape then
					-- keep current
					listening = false
					b.BackgroundColor3 = C.box
					refresh()
					if conn then conn:Disconnect() end
					return
				end
				if code == Enum.KeyCode.Backspace or code == Enum.KeyCode.Delete then
					St.keys[keyId] = nil
				else
					St.keys[keyId] = code
				end
				listening = false
				b.BackgroundColor3 = C.box
				refresh()
				pcall(saveCfg)
				if conn then conn:Disconnect() end
			end)
		end
		b.MouseButton1Click:Connect(startListen)
		b.Activated:Connect(startListen)
	end
	keyRowTab("Drop", "Drop", 2)
	keyRowTab("TP Down", "TPDown", 3)
	keyRowTab("Insta Reset", "InstaReset", 4)
	keyRowTab("Destroy Sentry", "DestroySentry", 5)
	keyRowTab("Auto Steal (toggle)", "AutoSteal", 6)
	local hint = Instance.new("TextLabel")
	hint.Size = UDim2.new(1, -16, 0, 40)
	hint.BackgroundTransparency = 1
	hint.Text = "Bấm nút → nhấn phím để gán\nBackspace/Delete = None | Esc = hủy"
	hint.TextColor3 = C.textDim
	hint.TextSize = 11
	hint.Font = Enum.Font.Gotham
	hint.TextWrapped = true
	hint.TextXAlignment = Enum.TextXAlignment.Left
	hint.Parent = pageKeys
	hint.LayoutOrder = 20
end

----------------------------------------------------------------
-- ESP TAB
----------------------------------------------------------------
section(pageESP, "* — ESP", 1)
toggleNamed(pageESP, "Player ESP", St.esp, setESP, 2, "esp")
toggleNamed(pageESP, "Tracker / Tracer", St.tracer, setTracer, 3, "tracer")
toggleNamed(pageESP, "Anti Lag", St.antiLag, setAntiLag, 4, "antiLag")


----------------------------------------------------------------
-- SPAM TAB
----------------------------------------------------------------
section(pageSpam, "* — AUTO SPAM (không auto-equip)", 1)
toggleNamed(pageSpam, "Spam Laser Cape", St.spamLaser, setSpamLaser, 2, "spamLaser")
toggleNamed(pageSpam, "Spam Paintball Gun", St.spamPaint, setSpamPaint, 3, "spamPaint")

section(pageCounter, "* — COUNTER (auto equip / activate)", 1)
toggleNamed(pageCounter, "Auto Laser Cape", St.counterLaser == true, setCounterLaser, 2, "counterLaser")
toggleNamed(pageCounter, "Auto Boogie Bomb", St.counterBoogie == true, setCounterBoogie, 3, "counterBoogie")
toggleNamed(pageCounter, "Auto Swap Body", St.counterSwapBody == true, setCounterSwapBody, 4, "counterSwapBody")
toggleNamed(pageCounter, "Equip & Activate on Drop", St.equipOnDrop == true, setEquipOnDrop, 5, "equipOnDrop")
do
	local info = Instance.new("TextLabel")
	info.Size = UDim2.new(1, -20, 0, 48)
	info.BackgroundTransparency = 1
	info.Text = "Laser Cape / Boogie Bomb / Swap Body: tự cầm + Activate.\nOn Drop: sau khi DROP sẽ equip & activate tool counter."
	info.TextColor3 = C.textDim
	info.TextSize = 11
	info.Font = Enum.Font.Gotham
	info.TextWrapped = true
	info.TextXAlignment = Enum.TextXAlignment.Left
	info.Parent = pageCounter
	info.LayoutOrder = 7
end


local spamInfo = row(pageSpam, 48, 4)
local spamTxt = Instance.new("TextLabel")
spamTxt.Size = UDim2.new(1, -12, 1, 0)
spamTxt.Position = UDim2.new(0, 6, 0, 0)
spamTxt.BackgroundTransparency = 1
spamTxt.Text = "Chỉ Activate khi đang CẦM tool.\nKhông tự Equip. Dùng cùng Tool Aimbot nếu cần."
spamTxt.TextColor3 = C.textDim
spamTxt.TextSize = 10
spamTxt.Font = Enum.Font.Gotham
spamTxt.TextXAlignment = Enum.TextXAlignment.Left
spamTxt.TextYAlignment = Enum.TextYAlignment.Center
spamTxt.Parent = spamInfo

----------------------------------------------------------------
-- SETTINGS TAB
----------------------------------------------------------------
section(pageSet, "* — MOBILE / LOCK", 1)
toggleNamed(pageSet, "Mobile Buttons", St.mobileBtns, function(on)
	St.mobileBtns = on
	if _G.VisApplyMobile then _G.VisApplyMobile() end
	saveCfg()
end, 2, "mobileBtns")
toggleNamed(pageSet, "Show Auto Steal Button", St.showStealBtn ~= false, function(on)
	St.showStealBtn = on and true or false
	if _G.VisRefreshStealBtn then pcall(_G.VisRefreshStealBtn) end
	-- nếu bật show mà chưa có nút → rebuild
	if St.showStealBtn and (not actRefs or not actRefs.steal) and _G.VisApplyMobile then
		pcall(_G.VisApplyMobile)
	end
	saveCfg()
end, 2.5, "showStealBtn")
toggleNamed(pageSet, "Show Panel TP", St.showTPPanel ~= false, function(on)
	St.showTPPanel = on and true or false
	local g = PlayerGui:FindFirstChild("VisHubbTP")
	if g then g.Enabled = St.showTPPanel end
	saveCfg()
end, 25, "showTPPanel")
toggleNamed(pageSet, "Show Panel Lagger", St.showLaggerPanel == true, function(on)
	if _G.VisSetLaggerPanel then _G.VisSetLaggerPanel(on) else St.showLaggerPanel = on; saveCfg() end
end, 25.1, "showLaggerPanel")
toggleNamed(pageSet, "Show Panel Speed Bypass", St.showSpeedBypassPanel == true, function(on)
	if _G.VisSetSpeedBypassPanel then _G.VisSetSpeedBypassPanel(on) else St.showSpeedBypassPanel = on; saveCfg() end
end, 25.3, "showSpeedBypassPanel")
-- Panel GUI size (to/nhỏ + rộng) dưới các panel
do
	local r = row(pageSet, 38, 25.4)
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(0.45, 0, 1, 0)
	t.Position = UDim2.new(0, 12, 0, 0)
	t.BackgroundTransparency = 1
	t.Text = "Panels Scale %"
	t.TextColor3 = C.text
	t.TextSize = 12
	t.Font = Enum.Font.Gotham
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = r
	local val = Instance.new("TextLabel")
	val.Size = UDim2.new(0, 44, 0, 24)
	val.Position = UDim2.new(1, -120, 0.5, -12)
	val.BackgroundTransparency = 1
	val.Text = tostring(math.floor((St.panelGuiScale or 0.7) * 100)) .. "%"
	val.TextColor3 = C.text
	val.TextSize = 12
	val.Font = Enum.Font.GothamBold
	val.Parent = r
	for _, info in ipairs({{"-", -80}, {"+", -44}}) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0, 28, 0, 28)
		b.Position = UDim2.new(1, info[2], 0.5, -14)
		b.BackgroundColor3 = C.box
		b.Text = info[1]
		b.TextColor3 = C.text
		b.TextSize = 16
		b.Font = Enum.Font.GothamBold
		b.AutoButtonColor = false
		b.Parent = r
		corner(b, 7)
		local function fire()
			St.panelGuiScale = math.clamp((tonumber(St.panelGuiScale) or 1) + (info[1] == "+" and 0.05 or -0.05), 0.6, 1.6)
			val.Text = tostring(math.floor(St.panelGuiScale * 100)) .. "%"
			if _G.VisApplyPanelGuiScale then pcall(_G.VisApplyPanelGuiScale) end
			saveCfg()
		end
		b.MouseButton1Click:Connect(fire)
		b.Activated:Connect(fire)
	end
end
do
	local r = row(pageSet, 38, 25.45)
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(0.45, 0, 1, 0)
	t.Position = UDim2.new(0, 12, 0, 0)
	t.BackgroundTransparency = 1
	t.Text = "Panels Width %"
	t.TextColor3 = C.text
	t.TextSize = 12
	t.Font = Enum.Font.Gotham
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = r
	local val = Instance.new("TextLabel")
	val.Size = UDim2.new(0, 44, 0, 24)
	val.Position = UDim2.new(1, -120, 0.5, -12)
	val.BackgroundTransparency = 1
	val.Text = tostring(math.floor((St.panelGuiWidth or 1) * 100)) .. "%"
	val.TextColor3 = C.text
	val.TextSize = 12
	val.Font = Enum.Font.GothamBold
	val.Parent = r
	for _, info in ipairs({{"-", -80}, {"+", -44}}) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0, 28, 0, 28)
		b.Position = UDim2.new(1, info[2], 0.5, -14)
		b.BackgroundColor3 = C.box
		b.Text = info[1]
		b.TextColor3 = C.text
		b.TextSize = 16
		b.Font = Enum.Font.GothamBold
		b.AutoButtonColor = false
		b.Parent = r
		corner(b, 7)
		local function fire()
			St.panelGuiWidth = math.clamp((tonumber(St.panelGuiWidth) or 1) + (info[1] == "+" and 0.05 or -0.05), 0.7, 1.5)
			val.Text = tostring(math.floor(St.panelGuiWidth * 100)) .. "%"
			if _G.VisApplyPanelGuiScale then pcall(_G.VisApplyPanelGuiScale) end
			saveCfg()
		end
		b.MouseButton1Click:Connect(fire)
		b.Activated:Connect(fire)
	end
end
toggleNamed(pageSet, "Lock UI", St.guiLock, function(on)
	St.guiLock = on and true or false
	-- snapshot positions then save immediately on lock/unlock
	pcall(function()
		if Main and Main.Parent then
			St._mainPos = {Main.Position.X.Scale, Main.Position.X.Offset, Main.Position.Y.Scale, Main.Position.Y.Offset}
			St.menuOpen = Main.Visible == true
		end
		local miniGui = PlayerGui:FindFirstChild("VisHubFullMini")
		local mini = miniGui and miniGui:FindFirstChildWhichIsA("TextButton")
		if mini then
			St._miniPos = {mini.Position.X.Scale, mini.Position.X.Offset, mini.Position.Y.Scale, mini.Position.Y.Offset}
		end
		local mb = PlayerGui:FindFirstChild("VisHubModeBar")
		local mf = mb and mb:FindFirstChildWhichIsA("Frame")
		if mf then
			St._modeBarPos = {mf.Position.X.Scale, mf.Position.X.Offset, mf.Position.Y.Scale, mf.Position.Y.Offset}
		end
		St._btnPos = St._btnPos or {}
		local function snapHoldersLock(gui)
			if not gui then return end
			for _, holder in ipairs(gui:GetChildren()) do
				if holder:IsA("Frame") or holder:IsA("TextButton") then
					local key = holder.Name
					if key and (key:sub(1,2) == "A_" or key:sub(1,2) == "M_") then
						St._btnPos[key] = {
							holder.Position.X.Scale, holder.Position.X.Offset,
							holder.Position.Y.Scale, holder.Position.Y.Offset,
							holder.Size.X.Offset, holder.Size.Y.Offset,
						}
					end
				end
			end
		end
		snapHoldersLock(PlayerGui:FindFirstChild("VisHubActionButtons"))
		snapHoldersLock(PlayerGui:FindFirstChild("VisHubModeBar"))
	end)
	pcall(saveCfg)
end, 3, "guiLock")
-- Anti Kick luôn ON — chỉ hiện trạng thái, không tắt được
do
	local r = row(pageSet, 32, 4)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -16, 1, 0)
	lbl.Position = UDim2.new(0, 8, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = "Anti Kick  ·  ALWAYS ON"
	lbl.TextColor3 = Color3.fromRGB(120, 255, 160)
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 12
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = r
end

section(pageSet, "* — BUTTON SHAPE", 10)
local shapeRow = row(pageSet, 38, 11)
for i, name in ipairs({ "Round", "Box", "Square" }) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 90, 0, 28)
	b.Position = UDim2.new(0, 12 + (i - 1) * 100, 0.5, -14)
	b.BackgroundColor3 = (St.btnShape == name) and C.accent or C.box
	b.Text = name
	b.TextColor3 = (St.btnShape == name) and Color3.fromRGB(30, 20, 30) or C.text
	b.TextSize = 12
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Parent = shapeRow
	corner(b, name == "Round" and 14 or (name == "Box" and 6 or 2))
	local function pickShape()
		St.btnShape = name
		-- Áp shape ngay lên MỌI action button
		pcall(function()
			if actRefs then
				for key, e in pairs(actRefs) do
					if e and e.btn then
						applyCorner(e.btn, name)
						applyCornerToChildren(e.btn, name)
					end
				end
			end
		end)
		if _G.VisUpdateMobileVisuals then pcall(_G.VisUpdateMobileVisuals) end
		if _G.VisForceApplyShape then pcall(_G.VisForceApplyShape, name) end
		for _, ch in ipairs(shapeRow:GetChildren()) do
			if ch:IsA("TextButton") then
				local on = ch.Text == name
				ch.BackgroundColor3 = on and C.accent or C.box
				ch.TextColor3 = on and Color3.fromRGB(30, 20, 30) or C.text
			end
		end
		pcall(saveCfg)
	end
	b.MouseButton1Click:Connect(pickShape)
	b.Activated:Connect(pickShape)
	b.MouseButton1Down:Connect(pickShape)
end

section(pageSet, "* — BUTTON SIZE", 20)
function sizeRow(label, key, order)
	local r = row(pageSet, 38, order)
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(0.4, 0, 1, 0)
	t.Position = UDim2.new(0, 12, 0, 0)
	t.BackgroundTransparency = 1
	t.Text = label
	t.TextColor3 = C.text
	t.TextSize = 13
	t.Font = Enum.Font.Gotham
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = r
	local val = Instance.new("TextLabel")
	val.Size = UDim2.new(0, 40, 0, 24)
	val.Position = UDim2.new(1, -120, 0.5, -12)
	val.BackgroundTransparency = 1
	val.Text = tostring(St.btnSizes[key] or 50)
	val.TextColor3 = C.text
	val.TextSize = 13
	val.Font = Enum.Font.GothamBold
	val.Parent = r
	local function mk(sign, x)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0, 28, 0, 28)
		b.Position = UDim2.new(1, x, 0.5, -14)
		b.BackgroundColor3 = C.box
		b.Text = sign
		b.TextColor3 = C.text
		b.TextSize = 16
		b.Font = Enum.Font.GothamBold
		b.AutoButtonColor = false
		b.Active = true
		b.ZIndex = 30
		b.Parent = r
		corner(b, 7)
		local function fire()
			local cur = tonumber(St.btnSizes[key]) or 50
			cur = math.clamp(cur + (sign == "+" and 5 or -5), 20, 200)
			St.btnSizes[key] = cur
			val.Text = tostring(cur)
			if _G.VisUpdateMobileVisuals then pcall(_G.VisUpdateMobileVisuals) end
			if _G.VisApplyMobile then pcall(_G.VisApplyMobile) end
			-- Speed 3Mode: rebuild để áp chiều cao mới
			if key == "mode" and _G.VisBuildV2ModeBar then pcall(_G.VisBuildV2ModeBar) end
			saveCfg()
		end
		b.MouseButton1Click:Connect(fire)
		b.Activated:Connect(fire)
	end
	mk("-", -80)
	mk("+", -44)
end
sizeRow("All Scale %", "mode", 21) -- reuse mode key for display; actual all scale below
-- all scale
local scaleRow = row(pageSet, 38, 22)
local st = Instance.new("TextLabel")
st.Size = UDim2.new(0.4, 0, 1, 0)
st.Position = UDim2.new(0, 12, 0, 0)
st.BackgroundTransparency = 1
st.Text = "All Buttons Scale"
st.TextColor3 = C.text
st.TextSize = 13
st.Font = Enum.Font.Gotham
st.TextXAlignment = Enum.TextXAlignment.Left
st.Parent = scaleRow
local scaleVal = Instance.new("TextLabel")
scaleVal.Size = UDim2.new(0, 48, 0, 24)
scaleVal.Position = UDim2.new(1, -128, 0.5, -12)
scaleVal.BackgroundTransparency = 1
scaleVal.Text = tostring(math.floor(St.btnScale * 100)) .. "%"
scaleVal.TextColor3 = C.text
scaleVal.TextSize = 13
scaleVal.Font = Enum.Font.GothamBold
scaleVal.Parent = scaleRow
for _, info in ipairs({ { "-", -80 }, { "+", -44 } }) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 28, 0, 28)
	b.Position = UDim2.new(1, info[2], 0.5, -14)
	b.BackgroundColor3 = C.box
	b.Text = info[1]
	b.TextColor3 = C.text
	b.TextSize = 16
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Active = true
	b.ZIndex = 30
	b.Parent = scaleRow
	corner(b, 7)
	function fire()
		St.btnScale = math.clamp((tonumber(St.btnScale) or 1) + (info[1] == "+" and 0.05 or -0.05), 0.3, 2.0)
		scaleVal.Text = tostring(math.floor(St.btnScale * 100)) .. "%"
		if _G.VisUpdateMobileVisuals then pcall(_G.VisUpdateMobileVisuals) end
		if _G.VisApplyMobile then pcall(_G.VisApplyMobile) end
		-- rebuild V2 bar to pick new scale defaults
		if _G.VisBuildV2ModeBar then pcall(_G.VisBuildV2ModeBar) end
		saveCfg()
	end
	b.MouseButton1Click:Connect(fire)
	b.Activated:Connect(fire)
end
sizeRow("Size: Speed 3Mode", "mode", 22.5)
sizeRow("Size: Drop", "drop", 23)
sizeRow("Size: Insta", "insta", 24)
sizeRow("Size: TP", "tp", 25)
sizeRow("Size: Sentry", "sentry", 25.5)
sizeRow("Size: Auto Steal", "steal", 26)


section(pageSet, "* — MENU UI SCALE", 28)
local menuScaleRow = row(pageSet, 36, 29)
local msl = Instance.new("TextLabel")
msl.Size = UDim2.new(0.4, 0, 1, 0)
msl.Position = UDim2.new(0, 10, 0, 0)
msl.BackgroundTransparency = 1
msl.Text = "Menu Size"
msl.TextColor3 = C.text
msl.TextSize = 12
msl.Font = Enum.Font.Gotham
msl.TextXAlignment = Enum.TextXAlignment.Left
msl.Parent = menuScaleRow
local msVal = Instance.new("TextLabel")
msVal.Size = UDim2.new(0, 40, 0, 22)
msVal.Position = UDim2.new(1, -110, 0.5, -11)
msVal.BackgroundTransparency = 1
msVal.Text = tostring(math.floor((St.menuScale or 1) * 100)) .. "%"
msVal.TextColor3 = C.text
msVal.TextSize = 12
msVal.Font = Enum.Font.GothamBold
msVal.Parent = menuScaleRow
for _, info in ipairs({{"-", -72}, {"+", -40}}) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 26, 0, 26)
	b.Position = UDim2.new(1, info[2], 0.5, -13)
	b.BackgroundColor3 = C.box
	b.Text = info[1]
	b.TextColor3 = C.text
	b.TextSize = 14
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Active = true
	b.ZIndex = 30
	b.Parent = menuScaleRow
	corner(b, 6)
	function fire()
		St.menuScale = math.clamp((St.menuScale or 1) + (info[1] == "+" and 0.05 or -0.05), 0.7, 1.3)
		msVal.Text = tostring(math.floor(St.menuScale * 100)) .. "%"
		applyMenuScale()
		saveCfg()
	end
	b.MouseButton1Click:Connect(fire)
	b.Activated:Connect(fire)
end

section(pageSet, "* — RESET", 30)
actionBtn(pageSet, "Reset Mobile Positions", C.accent, function()
	if _G.VisResetMobilePos then _G.VisResetMobilePos() end
	saveCfg()
end, 31)
actionBtn(pageSet, "Reset All Settings", C.danger, function()
	-- full defaults
	pcall(function() setAntiGummy(true) end)
	pcall(function() setAntiRagdoll(false) end)
	pcall(function() setAntiPaint(true) end)
	pcall(function() setAntiBoogie(true) end)
	pcall(function() setToolAim(true) end)
	pcall(function() setInfJump(true) end)
	pcall(function() setDestroySentry(false) end)
	pcall(function() setSpeedOn(true) end)
	pcall(function() setActiveMode("Normal") end)
	St.dropMode = 2
	St.instaMode = "V1"
	St.mobileBtns = true
	St.showStealBtn = true
	St.guiLock = false
	St.btnShape = "Square"
	St.btnScale = 0.75
	St.menuScale = 1
	St.btnSizes = { mode = 50, drop = 50, insta = 50, tp = 50, sentry = 50, steal = 50 }
	St._btnPos = nil
	St._modeBarPos = nil
	St._miniPos = nil
	St._mainPos = nil
	St._stealBarPos = nil
	St._tpMainPos = nil
	St.stealVer = "V1"
	St.stealRadius = 60
	St.stealPause = false
	St.stealPausePct = 75
	St.autoSteal = false
	St.modes = {
		Normal = { norm = 59, steal = 30, key = Enum.KeyCode.T },
		Lagger = { norm = 18, steal = 24, key = Enum.KeyCode.Q },
		Custom = { norm = 33, steal = 33, key = Enum.KeyCode.C },
	}
	St.activeMode = "Normal"
	St.keys = {
		Drop = Enum.KeyCode.X,
		TPDown = Enum.KeyCode.F,
		InstaReset = Enum.KeyCode.Z,
		DestroySentry = Enum.KeyCode.H,
	}
	pcall(function() setESP(false) end)
	pcall(function() setTracer(false) end)
	pcall(function() setAntiLag(false) end)
	pcall(function() setSpamLaser(false) end)
	pcall(function() setSpamPaint(false) end)
	if type(setAutoSteal) == "function" then
		pcall(function() setAutoSteal(false) end)
	end
	-- sync toggle UI
	local defs = {
		antiGummy = true, antiRagdoll = false, antiPaint = true, antiBoogie = true,
		toolAim = true, infJump = true, destroySentry = false, speedOn = true,
		mobileBtns = true, guiLock = false,
		esp = false, tracer = false, antiLag = false,
		spamLaser = false, spamPaint = false,
		autoSteal = false, stealPause = false, showTPPanel = true,
	}
	for k, v in pairs(defs) do
		if ToggleRefs[k] and ToggleRefs[k].set then
			pcall(function() ToggleRefs[k].set(v) end)
		end
	end
	if _G.VisResetMobilePos then pcall(_G.VisResetMobilePos) end
	if _G.VisApplyMobile then pcall(_G.VisApplyMobile) end
	if _G.VisRefreshModeCards then pcall(_G.VisRefreshModeCards) end
	pcall(applyMenuScale)
	if _G.VisSyncAutoSteal then pcall(_G.VisSyncAutoSteal) end
	pcall(saveCfg)
	showToast("RESET ALL ✓ Free Sell Là Tuất Ngu Lồn")
end, 32)
actionBtn(pageSet, "Save Now", C.accent, function()
	-- snapshot vị trí menu / mini / bar trước khi ghi
	pcall(function()
		if Main then
			St._mainPos = {Main.Position.X.Scale, Main.Position.X.Offset, Main.Position.Y.Scale, Main.Position.Y.Offset}
		end
		local mini = PlayerGui:FindFirstChild("VisHubFullMini")
		local mb = mini and mini:FindFirstChildWhichIsA("GuiObject")
		if mb then
			St._miniPos = {mb.Position.X.Scale, mb.Position.X.Offset, mb.Position.Y.Scale, mb.Position.Y.Offset}
		end
		St.menuOpen = Main and Main.Visible == true
	end)
	local ok = saveCfg()
	if ok then
		showToast("SAVED ✓ Free Sell Là Tuất Ngu Lồn")
	else
		showToast("SAVE FAIL (no writefile?)")
	end
end, 33)

----------------------------------------------------------------
-- MINI + CLOSE (no keybind)
----------------------------------------------------------------
local MiniGui = Instance.new("ScreenGui")
MiniGui.Name = "VisHubFullMini"
MiniGui.ResetOnSpawn = false
MiniGui.IgnoreGuiInset = true
MiniGui.DisplayOrder = 121
MiniGui.Parent = PlayerGui
-- Helper tròn khi menu ẩn (LKZ style) — kéo được, ấn mở menu
local Mini = Instance.new("TextButton")
Mini.Size = UDim2.new(0, 110, 0, 36)
Mini.Position = UDim2.new(0, 14, 0, 90)
Mini.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
Mini.Text = "VisHub"
Mini.TextColor3 = C.accent
Mini.TextSize = 12
Mini.Font = Enum.Font.GothamBold
Mini.Visible = false
Mini.AutoButtonColor = false
Mini.Parent = MiniGui
corner(Mini, 8)
local miniStroke = Instance.new("UIStroke", Mini)
miniStroke.Color = C.accent
miniStroke.Thickness = 2
miniStroke.Transparency = 0.15

do
	local dragging, dragStart, startPos, moved
	Top.InputBegan:Connect(function(input)
		if St.guiLock then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					St._mainPos = {Main.Position.X.Scale, Main.Position.X.Offset, Main.Position.Y.Scale, Main.Position.Y.Offset}
					St.menuOpen = Main.Visible == true
					pcall(saveCfg)
				end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and not St.guiLock and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - dragStart
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
end
do
	local dragging, dragStart, startPos, moved
	-- Load vị trí nút đóng/mở đã lưu
	pcall(function()
		local p = St._miniPos
		if type(p) == "table" and p[1] ~= nil then
			Mini.Position = UDim2.new(p[1], p[2], p[3], p[4])
		end
	end)
	Mini.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			moved = false
			dragStart = input.Position
			startPos = Mini.Position
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - dragStart
			if math.abs(d.X) > 5 or math.abs(d.Y) > 5 then moved = true end
			if moved then
				Mini.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
			end
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
		if not dragging then return end
		dragging = false
		if moved then
			St._miniPos = {Mini.Position.X.Scale, Mini.Position.X.Offset, Mini.Position.Y.Scale, Mini.Position.Y.Offset}
			pcall(saveCfg)
		end
	end)
	Mini.MouseButton1Click:Connect(function()
		if moved then return end -- vừa kéo xong không mở menu
		St.menuOpen = true
		saveCfg()
		if moved then return end
		openMenu()
	end)
end

function openMenu()
	Main.Visible = true
	Mini.Visible = false
	St.menuOpen = true
	pcall(saveCfg)
	Main.Size = UDim2.new(0, 0, 0, MH)
	TS:Create(Main, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, MW, 0, MH),
	}):Play()
end
function closeMenu()
	local tw = TS:Create(Main, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, MH),
	})
	tw:Play()
	tw.Completed:Connect(function()
		Main.Visible = false
		St.menuOpen = false
		pcall(function()
			if Main and Main.Parent then
				St._mainPos = {Main.Position.X.Scale, Main.Position.X.Offset, Main.Position.Y.Scale, Main.Position.Y.Offset}
			end
		end)
		Mini.Visible = true
		Mini.Text = "VisHub"
		-- Giữ vị trí mini đã lưu; nếu chưa có thì đặt gần chỗ menu
		pcall(function()
			local p = St._miniPos
			if type(p) == "table" and p[1] ~= nil then
				Mini.Position = UDim2.new(p[1], p[2], p[3], p[4])
			else
				Mini.Position = UDim2.new(Main.Position.X.Scale, Main.Position.X.Offset + 8, Main.Position.Y.Scale, Main.Position.Y.Offset)
				St._miniPos = {Mini.Position.X.Scale, Mini.Position.X.Offset, Mini.Position.Y.Scale, Mini.Position.Y.Offset}
			end
		end)
		pcall(saveCfg)
	end)
end
CloseBtn.Active = true
CloseBtn.ZIndex = 50
CloseBtn.MouseButton1Click:Connect(closeMenu)
CloseBtn.Activated:Connect(closeMenu)
if Helper then
	Helper.MouseButton1Click:Connect(closeMenu)
	pcall(function() Helper.Activated:Connect(closeMenu) end)
end

----------------------------------------------------------------
-- MOBILE: 3 mode + Drop + Insta + TP
----------------------------------------------------------------
local ModeGui = Instance.new("ScreenGui")
ModeGui.Name = "VisHubModeBar"
ModeGui.ResetOnSpawn = false
ModeGui.IgnoreGuiInset = true
ModeGui.DisplayOrder = 2501
ModeGui.Enabled = false
ModeGui.Parent = PlayerGui

local ActGui = Instance.new("ScreenGui")
ActGui.Name = "VisHubActionButtons"
ActGui.ResetOnSpawn = false
ActGui.IgnoreGuiInset = true
ActGui.DisplayOrder = 2500
ActGui.Enabled = false
ActGui.Parent = PlayerGui

local modeRefs = {}
local actRefs = {}

-- Shape chỉ áp dụng cho ACTION buttons (Drop/Insta/TP/Sentry/Steal).
-- 3-mode speed (Normal/Lagger/Custom) LUÔN giữ style mặc định (Pill) như video.
function applyCorner(btn, forceShape)
	if not btn then return end
	local shape = forceShape or St.btnShape or "Square"
	-- Xoá hết UICorner cũ rồi tạo lại (tránh kẹt radius cũ)
	for _, ch in ipairs(btn:GetChildren()) do
		if ch:IsA("UICorner") then pcall(function() ch:Destroy() end) end
	end
	local rad
	if shape == "Round" then
		rad = UDim.new(1, 0) -- tròn
	elseif shape == "Box" then
		rad = UDim.new(0, 12) -- bo vừa
	elseif shape == "Pill" then
		rad = UDim.new(0, 16)
	else
		rad = UDim.new(0, 2) -- Square gần vuông
	end
	local c = Instance.new("UICorner")
	c.Name = "ShapeCorner"
	c.CornerRadius = rad
	c.Parent = btn
	-- đồng bộ ảnh nền / dim
	for _, ch in ipairs(btn:GetChildren()) do
		if ch:IsA("ImageLabel") or (ch:IsA("Frame") and ch.Name ~= "BtnTextOverlay") then
			for _, sub in ipairs(ch:GetChildren()) do
				if sub:IsA("UICorner") then pcall(function() sub:Destroy() end) end
			end
			local c2 = Instance.new("UICorner")
			c2.Name = "ShapeCorner"
			c2.CornerRadius = rad
			c2.Parent = ch
		end
	end
end

function applyCornerToChildren(btn, shape)
	if not btn then return end
	shape = shape or St.btnShape or "Square"
	local rad
	if shape == "Round" then rad = UDim.new(1, 0)
	elseif shape == "Box" then rad = UDim.new(0, 12)
	elseif shape == "Pill" then rad = UDim.new(0, 16)
	else rad = UDim.new(0, 2)
	end
	for _, ch in ipairs(btn:GetChildren()) do
		if ch:IsA("ImageLabel") or (ch:IsA("Frame") and ch.Name ~= "BtnTextOverlay") then
			for _, sub in ipairs(ch:GetChildren()) do
				if sub:IsA("UICorner") then pcall(function() sub:Destroy() end) end
			end
			local c = Instance.new("UICorner")
			c.Name = "ShapeCorner"
			c.CornerRadius = rad
			c.Parent = ch
		end
	end
end

local MOB_BTN_IMAGE_IDS = {
	126832513729779, 81347949983999, 76940707345653, 100648743625857,
	73857705647948, 86237559415852, 81474116937197, 86668822094069,
	108384375206363, 86791880986403, 126414648469223,
}
function applyEmpireBtnBg(btn, index)
	if not btn then return end
	local old = btn:FindFirstChild("BtnBgImage")
	if old then old:Destroy() end
	local list = MOB_BTN_IMAGE_IDS
	local id = list[((tonumber(index) or 1) - 1) % #list + 1]
	if not id or id <= 0 then return end
	-- nền đậm hơn (VisHub style) nhưng chữ vẫn đọc được
	btn.BackgroundTransparency = 0.35
	btn.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
	local bgImg = Instance.new("ImageLabel")
	bgImg.Name = "BtnBgImage"
	bgImg.BackgroundTransparency = 1
	bgImg.Image = "rbxassetid://" .. tostring(id)
	bgImg.ImageTransparency = 0.08 -- đậm hơn (thấp = rõ ảnh hơn)
	bgImg.ScaleType = Enum.ScaleType.Crop
	bgImg.Size = UDim2.new(1, 0, 1, 0)
	bgImg.ZIndex = (btn.ZIndex or 1)
	bgImg.Active = false
	bgImg.Selectable = false
	bgImg.Parent = btn
	-- lớp tối nhẹ để chữ trắng nổi
	local dim = Instance.new("Frame")
	dim.Name = "BtnDim"
	dim.Size = UDim2.new(1, 0, 1, 0)
	dim.BackgroundColor3 = Color3.new(0, 0, 0)
	dim.BackgroundTransparency = 0.45
	dim.BorderSizePixel = 0
	dim.ZIndex = (btn.ZIndex or 1) + 1
	dim.Active = false
	dim.Selectable = false
	dim.Parent = btn
	local rad = UDim.new(1, 0)
	if St.btnShape == "Box" then rad = UDim.new(0, 10)
	elseif St.btnShape == "Square" then rad = UDim.new(0, 4)
	end
	local c = Instance.new("UICorner")
	c.CornerRadius = rad
	c.Parent = bgImg
	local c2 = Instance.new("UICorner")
	c2.CornerRadius = rad
	c2.Parent = dim
	-- chữ trên cùng
	btn.TextTransparency = 0
	btn.TextStrokeTransparency = 0.4
	btn.TextStrokeColor3 = Color3.new(0, 0, 0)
	pcall(function() btn.ZIndex = math.max(btn.ZIndex or 1, 100) end)
	-- Empire gradient stroke on button
	local st = btn:FindFirstChildOfClass("UIStroke")
	if st and not st:FindFirstChild("EmpireOutlineGrad") then
		st.Thickness = 1.6
		st.Transparency = 0.1
		local g = Instance.new("UIGradient")
		g.Name = "EmpireOutlineGrad"
		g.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 80, 180)),
			ColorSequenceKeypoint.new(0.7, Color3.fromRGB(180, 80, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
		})
		g.Parent = st
		task.spawn(function()
			local t0 = tick()
			while st and st.Parent do
				g.Rotation = ((tick() - t0) * 50) % 360
				task.wait(0.04)
			end
		end)
	end
end

----------------------------------------------------------------
-- SPEED V2 MODE BAR (full GUI from VisHub Clean) — 3 mode
----------------------------------------------------------------
local v2BarButtons = {}
function _G.VisBuildV2ModeBar()
	pcall(function()
		local old = PlayerGui:FindFirstChild("VisV2ModeBar")
		if old then old:Destroy() end
	end)
	if not St.mobileBtns then return end
		local sc = math.clamp(tonumber(St.btnScale) or 1, 0.3, 2)
	local modeBase = tonumber(St.btnSizes and St.btnSizes.mode) or 50
	-- Size: Speed 3Mode tăng CHIỀU CAO (height), width giữ vừa đủ chữ
	local V2_BTN_H = math.max(28, math.floor(modeBase * sc))
	local V2_BTN_W = math.max(72, math.floor(88 * sc)) -- rộng ổn định, không phình theo size
	local V2_CORNER = 12	local MODE_COLORS = {
		Normal = {
			onBg = Color3.fromRGB(255, 200, 210), onTxt = Color3.fromRGB(30, 20, 30),
			offBg = Color3.fromRGB(255, 255, 255), offTxt = Color3.fromRGB(25, 25, 30),
			stroke = Color3.fromRGB(255, 160, 180),
		},
		Lagger = {
			onBg = Color3.fromRGB(255, 200, 210), onTxt = Color3.fromRGB(30, 20, 30),
			offBg = Color3.fromRGB(255, 255, 255), offTxt = Color3.fromRGB(25, 25, 30),
			stroke = Color3.fromRGB(255, 160, 180),
		},
		Custom = {
			onBg = Color3.fromRGB(255, 200, 210), onTxt = Color3.fromRGB(30, 20, 30),
			offBg = Color3.fromRGB(255, 255, 255), offTxt = Color3.fromRGB(25, 25, 30),
			stroke = Color3.fromRGB(255, 160, 180),
		},
	}
	local gui = Instance.new("ScreenGui")
	gui.Name = "VisV2ModeBar"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 95
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = PlayerGui
	v2BarButtons = {}
	local function styleV2Btn(btn, modeName, active)
		local col = MODE_COLORS[modeName] or MODE_COLORS.Normal
		btn.BackgroundColor3 = active and col.onBg or col.offBg
		btn.TextColor3 = active and col.onTxt or col.offTxt
		local st = btn:FindFirstChildOfClass("UIStroke")
		if st then
			st.Color = active and col.stroke or Color3.fromRGB(210, 210, 220)
			st.Transparency = active and 0.15 or 0.35
			st.Thickness = active and 1.5 or 1
		end
	end
	local function posFromSaved(modeName, order)
		local key = "V2_" .. modeName
		local t = St._btnPos and St._btnPos[key]
		if type(t) == "table" and t[1] ~= nil then
			return UDim2.new(t[1], t[2], t[3], t[4])
		end
		local gap = 10
		local total = (V2_BTN_W + gap) * 3 - gap
		return UDim2.new(0.5, -total / 2 + (order - 1) * (V2_BTN_W + gap), 1, -118)
	end
	local function saveV2Pos(modeName, holder)
		St._btnPos = St._btnPos or {}
		St._btnPos["V2_" .. modeName] = {
			holder.Position.X.Scale, holder.Position.X.Offset,
			holder.Position.Y.Scale, holder.Position.Y.Offset,
		}
		pcall(saveCfg)
	end
	local function makeV2ModeBtn(modeName, label, order)
		local holder = Instance.new("Frame")
		holder.Name = "V2MH_" .. modeName
		holder.Size = UDim2.new(0, V2_BTN_W, 0, V2_BTN_H)
		holder.Position = posFromSaved(modeName, order)
		holder.BackgroundTransparency = 1
		holder.BorderSizePixel = 0
		holder.ZIndex = 10
		holder.Active = true
		holder.Parent = gui
		local btn = Instance.new("TextButton")
		btn.Name = "V2Bar_" .. modeName
		btn.Size = UDim2.new(1, 0, 1, 0)
		btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		btn.Text = label
		btn.TextColor3 = Color3.fromRGB(25, 25, 30)
		btn.Font = Enum.Font.GothamBlack
		btn.TextSize = 13
		btn.AutoButtonColor = false
		btn.ZIndex = 12
		btn.Parent = holder
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, V2_CORNER)
		local st = Instance.new("UIStroke", btn)
		st.Thickness = 1
		st.Transparency = 0.35
		st.Color = Color3.fromRGB(210, 210, 220)
		st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		styleV2Btn(btn, modeName, St.activeMode == modeName)
		local activeInput, pressPos, holderStart = nil, nil, nil
		local moved, lastClick = false, 0
		local function runClick()
			local now = tick()
			if now - lastClick < 0.08 then return end
			lastClick = now
			if type(setActiveMode) == "function" then
				setActiveMode(modeName)
			else
				St.activeMode = modeName
			end
			for n, e in pairs(v2BarButtons) do
				if e and e.btn then styleV2Btn(e.btn, n, n == modeName) end
			end
			-- sync old modeRefs if any
			for n, e in pairs(modeRefs or {}) do
				if e and e.style then pcall(e.style, n == modeName)
				elseif e and e.btn then
					e.btn.BackgroundColor3 = (n == modeName) and Color3.fromRGB(255, 200, 210) or Color3.fromRGB(255, 255, 255)
				end
			end
		end
		btn.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
			activeInput = input
			pressPos = input.Position
			holderStart = holder.Position
			moved = false
			input.Changed:Connect(function()
				if input.UserInputState ~= Enum.UserInputState.End or activeInput ~= input then return end
				activeInput = nil
				if not moved then
					runClick()
				elseif not St.guiLock then
					saveV2Pos(modeName, holder)
				end
			end)
		end)
		btn.Activated:Connect(function()
			if moved then return end
			runClick()
		end)
		UIS.InputChanged:Connect(function(input)
			if not activeInput or not pressPos or not holderStart then return end
			if activeInput.UserInputType == Enum.UserInputType.Touch then
				if input ~= activeInput then return end
			elseif activeInput.UserInputType == Enum.UserInputType.MouseButton1 then
				if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
			else return end
			local dx = input.Position.X - pressPos.X
			local dy = input.Position.Y - pressPos.Y
			if math.abs(dx) > 4 or math.abs(dy) > 4 then moved = true end
			if moved and not St.guiLock then
				holder.Position = UDim2.new(holderStart.X.Scale, holderStart.X.Offset + dx, holderStart.Y.Scale, holderStart.Y.Offset + dy)
			end
		end)
		v2BarButtons[modeName] = { holder = holder, btn = btn }
		return btn
	end
	makeV2ModeBtn("Normal", "NORMAL", 1)
	makeV2ModeBtn("Lagger", "LAGGER", 2)
	makeV2ModeBtn("Custom", "CUSTOM", 3)
	_G.VisRefreshV2ModeBar = function()
		for n, e in pairs(v2BarButtons) do
			if e and e.btn then styleV2Btn(e.btn, n, St.activeMode == n) end
		end
	end
end


function makeModeBtn(name, order)
	-- Size Speed 3Mode: tăng chiều cao; width ổn định
	local sc = tonumber(St.btnScale) or 1
	local modeBase = tonumber(St.btnSizes and St.btnSizes.mode) or 50
	local V2_CORNER = 12
	local h = math.max(28, math.floor(modeBase * sc))
	local w = math.max(72, math.floor(88 * sc))
	local holder = Instance.new("Frame")
	holder.Name = "M_" .. name
	holder.Size = UDim2.new(0, w, 0, h)
	local gap = 10
	local total = (w + gap) * 3 - gap
	holder.Position = UDim2.new(0.5, -total / 2 + (order - 1) * (w + gap), 1, -118)
	holder.BackgroundTransparency = 1
	holder.BorderSizePixel = 0
	holder.ZIndex = 10
	holder.Active = true
	holder.Parent = ModeGui
	-- restore saved pos
	pcall(function()
		local p = St._btnPos and St._btnPos["M_" .. name]
		if type(p) == "table" and p[1] ~= nil then
			holder.Position = UDim2.new(p[1], p[2], p[3], p[4])
		end
	end)
	local btn = Instance.new("TextButton")
	btn.Name = "ModeBtn"
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = name:upper()
	if name == "Normal" then btn.Text = "NORMAL" end
	btn.TextColor3 = Color3.fromRGB(25, 25, 30)
	btn.Font = Enum.Font.GothamBlack
	btn.TextSize = math.clamp(math.floor(h * 0.36), 11, 14)
	btn.AutoButtonColor = false
	btn.ZIndex = 12
	btn.Active = true
	btn.Parent = holder
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, V2_CORNER)
	local st = Instance.new("UIStroke", btn)
	st.Thickness = 1
	st.Transparency = 0.35
	st.Color = Color3.fromRGB(210, 210, 220)
	st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local function styleMode(on)
		if on then
			btn.BackgroundColor3 = Color3.fromRGB(255, 200, 210)
			btn.TextColor3 = Color3.fromRGB(30, 20, 30)
			st.Color = Color3.fromRGB(255, 160, 180)
			st.Transparency = 0.1
		else
			btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			btn.TextColor3 = Color3.fromRGB(25, 25, 30)
			st.Color = Color3.fromRGB(210, 210, 220)
			st.Transparency = 0.35
		end
	end
	styleMode(St.activeMode == name)
	local dragging, dragStart, startPos, moved = false, nil, nil, false
	local movedDistance = 0
	local TAP_MAX = 22
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			moved = false
			movedDistance = 0
			dragStart = input.Position
			startPos = holder.Position
		end
	end)
	btn.InputChanged:Connect(function(input)
		if not dragging or not dragStart then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local d = input.Position - dragStart
			movedDistance = d.Magnitude
			if movedDistance > 8 then moved = true end
			if not St.guiLock and moved then
				holder.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
			end
		end
	end)
	local function pick()
		setActiveMode(name)
		-- refresh all mode styles
		for n, e in pairs(modeRefs) do
			if e and e.btn and e.style then
				e.style(St.activeMode == n)
			elseif e and e.btn then
				local on = St.activeMode == n
				e.btn.BackgroundColor3 = on and Color3.fromRGB(255, 200, 210) or Color3.fromRGB(255, 255, 255)
				e.btn.TextColor3 = on and Color3.fromRGB(30, 20, 30) or Color3.fromRGB(25, 25, 30)
			end
		end
		styleMode(true)
	end
	btn.InputEnded:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
		if not dragging then return end
		dragging = false
		if not moved and movedDistance < TAP_MAX then
			pick()
		elseif moved and not St.guiLock then
			savePos(holder, "M_" .. name)
		end
		movedDistance = 0
		dragStart = nil
	end)
	btn.MouseButton1Click:Connect(function()
		if moved then return end
		pick()
	end)
	btn.Activated:Connect(function()
		if moved then return end
		pick()
	end)
	modeRefs[name] = { holder = holder, btn = btn, style = styleMode }
end


function makeActBtn(key, label, pos, cb)
	-- Mobile button: dễ bấm — steal/sentry/drop/insta/tp cùng độ nhạy
	local baseSz = (St.btnSizes[key] or 50)
	if key == "steal" or key == "sentry" then
		baseSz = math.max(baseSz, 56)
	end
	local sz = math.max(28, math.floor(baseSz * (St.btnScale or 1)))
	local holder = Instance.new("Frame")
	holder.Name = "A_" .. key
	holder.Size = UDim2.new(0, sz, 0, sz)
	holder.Position = pos
	holder.BackgroundTransparency = 1
	holder.Active = true -- nhận touch
	holder.ZIndex = 50
	holder.Parent = ActGui
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
	btn.Text = label
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = math.clamp(math.floor(sz * 0.22), 10, 16)
	btn.Font = Enum.Font.GothamBold
	btn.TextWrapped = true
	btn.AutoButtonColor = false
	btn.Active = true
	btn.Selectable = true
	btn.Modal = false
	btn.ZIndex = 100
	btn.Parent = holder
	-- Action buttons: shape từ Settings (Round/Box/Square)
	applyCorner(btn, St.btnShape)
	do
		local oldS = btn:FindFirstChildOfClass("UIStroke")
		if oldS then oldS:Destroy() end
		local s = Instance.new("UIStroke")
		s.Name = "BtnBorder"
		s.Color = Color3.fromRGB(220, 220, 235)
		s.Thickness = 2
		s.Transparency = 0.15
		s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		s.Parent = btn
	end
	applyEmpireBtnBg(btn, ({drop=1,insta=2,tp=3,sentry=4,steal=5})[key] or 5)
	applyCornerToChildren(btn, St.btnShape)
	local bgImg = btn:FindFirstChild("BtnBgImage")
	if bgImg then
		bgImg.Active = false
		bgImg.Selectable = false
		bgImg.ZIndex = 0
	end
	-- Chữ luôn hiện: TextButton text + label đè trên ảnh
	btn.TextTransparency = 0
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	local oldL = btn:FindFirstChild("BtnTextOverlay")
	if oldL then oldL:Destroy() end
	local tl = Instance.new("TextLabel")
	tl.Name = "BtnTextOverlay"
	tl.BackgroundTransparency = 1
	tl.Size = UDim2.new(1, -4, 1, -4)
	tl.Position = UDim2.new(0, 2, 0, 2)
	tl.Text = label
	tl.TextColor3 = Color3.fromRGB(255, 255, 255)
	tl.TextStrokeTransparency = 0.35
	tl.TextStrokeColor3 = Color3.new(0, 0, 0)
	tl.Font = Enum.Font.GothamBold
	tl.TextScaled = true
	tl.TextWrapped = true
	tl.ZIndex = (btn.ZIndex or 100) + 5
	tl.Active = false
	tl.Parent = btn
	-- ẩn text gốc tránh double (giữ overlay)
	btn.TextTransparency = 1
	local dragging, dragStart, startPos = false, nil, nil
	local movedDistance = 0
	local TAP_MAX = 22 -- dễ bấm / dễ kéo hơn
	local dragThresh = 8 -- kéo nhạy, không nặng
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			movedDistance = 0
			dragStart = input.Position
			startPos = holder.Position
		end
	end)
	-- UIS global = mượt hơn InputChanged trên button
	UIS.InputChanged:Connect(function(input)
		if not dragging or not dragStart then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local d = input.Position - dragStart
		movedDistance = d.Magnitude
		if St.guiLock then return end
		if movedDistance > dragThresh then
			holder.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	btn.InputEnded:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
		if not dragging then return end
		dragging = false
		local tapLimit = TAP_MAX
		-- steal/sentry/drop/insta/tp: dễ bấm hơn
		if key == "steal" or key == "sentry" or key == "drop" or key == "insta" or key == "tp" then
			tapLimit = 48
		end
		if movedDistance < tapLimit then
			if cb then
				btn:SetAttribute("_lastTap", tick())
				pcall(cb)
				if key == "sentry" then
					if _G.VisRefreshSentryBtn then pcall(_G.VisRefreshSentryBtn) end
				elseif key == "steal" then
					if _G.VisRefreshStealBtn then pcall(_G.VisRefreshStealBtn) end
				end
			end
		else
			if not St.guiLock then
				savePos(holder, "A_" .. key)
			end
		end
		movedDistance = 0
		dragStart = nil
	end)
	local function backupClick()
		local last = btn:GetAttribute("_lastTap") or 0
		if tick() - last < 0.15 then return end
		btn:SetAttribute("_lastTap", tick())
		if cb then pcall(cb) end
		if key == "sentry" and _G.VisRefreshSentryBtn then pcall(_G.VisRefreshSentryBtn) end
		if key == "steal" and _G.VisRefreshStealBtn then pcall(_G.VisRefreshStealBtn) end
	end
	btn.MouseButton1Click:Connect(backupClick)
	btn.Activated:Connect(backupClick)
	-- overlay không chặn click
	local ov = btn:FindFirstChild("BtnTextOverlay")
	if ov then ov.Active = false; ov.Selectable = false end

	-- STEAL / SENTRY: phản hồi ngay + màu xanh đậm
	if key == "steal" or key == "sentry" then
		local function instantToggle()
			local last = btn:GetAttribute("_lastTap") or 0
			if tick() - last < 0.12 then return end
			btn:SetAttribute("_lastTap", tick())
			if key == "steal" then
				local on = not (St.autoSteal == true)
				if type(setAutoSteal) == "function" then pcall(setAutoSteal, on)
				elseif type(_G.setAutoSteal) == "function" then pcall(_G.setAutoSteal, on)
				else
					St.autoSteal = on
					autoStealEnabled = on
					if on and type(startAutoSteal)=="function" then pcall(startAutoSteal)
					elseif (not on) and type(stopAutoSteal)=="function" then pcall(stopAutoSteal) end
				end
				applyActBtnState(btn, St.autoSteal == true, "STEAL\nON", "AUTO\nSTEAL")
				if _G.VisRefreshStealBtn then pcall(_G.VisRefreshStealBtn) end
			else
				local on = not (St.destroySentry == true)
				if type(setDestroySentry) == "function" then pcall(setDestroySentry, on)
				else St.destroySentry = on end
				applyActBtnState(btn, St.destroySentry == true, "SENTRY\nON", "SENTRY")
				if _G.VisRefreshSentryBtn then pcall(_G.VisRefreshSentryBtn) end
			end
		end
		btn.MouseButton1Down:Connect(instantToggle)
		btn.TouchTap:Connect(function() end) -- ensure touch focus
		-- thay cb để InputEnded cũng dùng logic này
		cb = instantToggle
	end

	actRefs[key] = { holder = holder, btn = btn }
end

function restorePos(holder, key, defaultPos)
	local t = St._btnPos and St._btnPos[key]
	if type(t) == "table" and t[1] ~= nil then
		holder.Position = UDim2.new(tonumber(t[1]) or 0, tonumber(t[2]) or 0, tonumber(t[3]) or 0, tonumber(t[4]) or 0)
		if t[5] and t[6] then
			local s = tonumber(t[5])
			local h = tonumber(t[6])
			if s and h and s > 10 and h > 10 then
				holder.Size = UDim2.new(0, s, 0, h)
			end
		end
	elseif defaultPos then
		holder.Position = defaultPos
	end
end

function savePos(holder, key)
	St._btnPos = St._btnPos or {}
	St._btnPos[key] = {
		holder.Position.X.Scale, holder.Position.X.Offset,
		holder.Position.Y.Scale, holder.Position.Y.Offset,
		holder.Size.X.Offset, holder.Size.Y.Offset
	}
	saveCfg()
end

function rebuildMobile()
	for _, e in pairs(modeRefs) do if e.holder then e.holder:Destroy() end end
	for _, e in pairs(actRefs) do if e.holder then e.holder:Destroy() end end
	modeRefs, actRefs = {}, {}
	makeModeBtn("Normal", 1)
	makeModeBtn("Lagger", 2)
	makeModeBtn("Custom", 3)
	-- Full Speed V2 GUI bar
	pcall(function()
		if ModeGui then
			for _, ch in ipairs(ModeGui:GetChildren()) do
				if ch:IsA("Frame") and tostring(ch.Name):match("^M_") then
					ch.Visible = false
				end
			end
		end
		if _G.VisBuildV2ModeBar then _G.VisBuildV2ModeBar() end
		if St.speedOn then
			currentSpeedValue = getActiveMoveSpeed()
			pcall(startSpeedBoost)
		end
	end)
	makeActBtn("drop", "DROP", UDim2.new(1, -150, 0.5, -40), function() runDrop() if _G.VisCounterOnDrop then pcall(_G.VisCounterOnDrop) end end)
	makeActBtn("insta", "INSTA\nRESET", UDim2.new(1, -80, 0.5, -40), doInstaReset)
	makeActBtn("tp", "TP\nDOWN", UDim2.new(1, -80, 0.5, 30), function() doTPDown(true) end)
	makeActBtn("sentry", "SENTRY", UDim2.new(1, -150, 0.5, 30), function()
		local on = not (St.destroySentry == true)
		if type(setDestroySentry) == "function" then
			setDestroySentry(on)
		else
			St.destroySentry = on
		end
		if _G.VisRefreshSentryBtn then pcall(_G.VisRefreshSentryBtn) end
	end)
	makeActBtn("steal", "AUTO\nSTEAL", UDim2.new(1, -150, 0.5, 100), function()
		local on = not (St.autoSteal == true)
		if type(setAutoSteal) == "function" then
			setAutoSteal(on)
		elseif type(_G.setAutoSteal) == "function" then
			_G.setAutoSteal(on)
		else
			St.autoSteal = on
			autoStealEnabled = on
			if on and startAutoSteal then startAutoSteal() elseif stopAutoSteal then stopAutoSteal() end
		end
		if _G.VisRefreshStealBtn then pcall(_G.VisRefreshStealBtn) end
		if ToggleRefs and ToggleRefs.autoSteal and ToggleRefs.autoSteal.setVisual then
			pcall(ToggleRefs.autoSteal.setVisual, St.autoSteal == true)
		end
	end)
	-- restore saved positions
	for key, e in pairs(actRefs) do
		if e.holder then restorePos(e.holder, "A_" .. key) end
	end
	for key, e in pairs(modeRefs) do
		if e.holder then restorePos(e.holder, "M_" .. key) end
	end
	_G.VisRefreshModeBar()
	_G.VisRefreshSentryBtn()
	if _G.VisRefreshStealBtn then pcall(_G.VisRefreshStealBtn) end
end



-- Empire-style: nút bật = xanh đậm rõ, tắt = tối
function applyActBtnState(btn, on, onText, offText)
	if not btn then return end
	on = on and true or false
	if on then
		-- Xanh đậm khi BẬT
		btn.BackgroundColor3 = Color3.fromRGB(0, 130, 45)
		btn.BackgroundTransparency = 0
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		if onText then btn.Text = onText end
		local bgImg = btn:FindFirstChild("BtnBgImage")
		if bgImg then bgImg.ImageTransparency = 0.75 end
		local dim = btn:FindFirstChild("BtnDim")
		if not dim then
			dim = Instance.new("Frame")
			dim.Name = "BtnDim"
			dim.Size = UDim2.new(1, 0, 1, 0)
			dim.BorderSizePixel = 0
			dim.ZIndex = (btn.ZIndex or 100) + 1
			dim.Active = false
			dim.Parent = btn
			local dc = Instance.new("UICorner")
			dc.CornerRadius = UDim.new(0, 8)
			dc.Parent = dim
		end
		dim.BackgroundColor3 = Color3.fromRGB(0, 120, 40)
		dim.BackgroundTransparency = 0.15
		dim.Visible = true
		local tl = btn:FindFirstChild("BtnTextOverlay")
		if tl then
			if onText then tl.Text = onText end
			tl.TextColor3 = Color3.fromRGB(255, 255, 255)
			tl.TextStrokeTransparency = 0.2
			tl.ZIndex = (btn.ZIndex or 100) + 6
		end
		local st = btn:FindFirstChild("BtnBorder") or btn:FindFirstChildOfClass("UIStroke")
		if st then st.Color = Color3.fromRGB(40, 255, 100); st.Transparency = 0; st.Thickness = 2.5 end
	else
		btn.BackgroundColor3 = C.btnOff or Color3.fromRGB(16, 16, 22)
		btn.BackgroundTransparency = 0.35
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		if offText then btn.Text = offText end
		local bgImg = btn:FindFirstChild("BtnBgImage")
		if bgImg then bgImg.ImageTransparency = 0.08 end
		local dim = btn:FindFirstChild("BtnDim")
		if dim then
			dim.BackgroundColor3 = Color3.new(0, 0, 0)
			dim.BackgroundTransparency = 0.45
		end
		local tl = btn:FindFirstChild("BtnTextOverlay")
		if tl then
			if offText then tl.Text = offText end
			tl.TextColor3 = Color3.fromRGB(255, 255, 255)
			tl.TextStrokeTransparency = 0.35
		end
		local st = btn:FindFirstChildOfClass("UIStroke")
		if st then st.Color = Color3.fromRGB(255, 80, 180); st.Transparency = 0.2; st.Thickness = 1.6 end
	end
end

function _G.VisRefreshStealBtn()
	local e = actRefs and actRefs.steal
	if not e or not e.holder then return end
	local show = (St.showStealBtn ~= false)
	e.holder.Visible = show
	if e.btn then
		e.btn.Visible = show
		applyActBtnState(e.btn, St.autoSteal == true, "STEAL\nON", "AUTO\nSTEAL")
	end
end

function _G.VisRefreshSentryBtn()
	local e = actRefs and actRefs.sentry
	if e and e.btn then
		applyActBtnState(e.btn, St.destroySentry == true, "SENTRY\nON", "SENTRY")
	end
end


function _G.VisRefreshModeBar()
	for n, e in pairs(modeRefs) do
		if e and e.btn then
			local on = St.activeMode == n
			applyCorner(e.btn, "Pill")
			if on then
				e.btn.BackgroundColor3 = C.modeOnBg or Color3.fromRGB(255, 20, 147)
				e.btn.BackgroundTransparency = 0
				e.btn.TextColor3 = C.modeOnTxt or Color3.fromRGB(255, 255, 255)
				local tl = e.btn:FindFirstChild("BtnTextOverlay")
				if tl then
					tl.TextColor3 = Color3.fromRGB(255, 255, 255)
					tl.Text = n
				end
				local st = e.btn:FindFirstChildOfClass("UIStroke")
				if st then st.Color = Color3.fromRGB(255, 120, 200); st.Transparency = 0.05 end
			else
				e.btn.BackgroundColor3 = C.modeOffBg or Color3.fromRGB(255, 255, 255)
				e.btn.BackgroundTransparency = 0
				e.btn.TextColor3 = C.modeOffTxt or Color3.fromRGB(25, 25, 30)
				local tl = e.btn:FindFirstChild("BtnTextOverlay")
				if tl then
					tl.TextColor3 = Color3.fromRGB(25, 25, 30)
					tl.Text = n
				end
				local st = e.btn:FindFirstChildOfClass("UIStroke")
				if st then st.Color = Color3.fromRGB(200, 200, 210); st.Transparency = 0.2 end
			end
		end
	end
end

-- Cập nhật size + shape TRỰC TIẾP (không destroy → giữ vị trí kéo)
_G.VisForceApplyShape = function(shape)
	shape = shape or (St and St.btnShape) or "Square"
	if St then St.btnShape = shape end
	local refs = actRefs
	if type(refs) ~= "table" then return end
	for key, e in pairs(refs) do
		if e and e.btn then
			pcall(function()
				applyCorner(e.btn, shape)
				if applyCornerToChildren then applyCornerToChildren(e.btn, shape) end
			end)
		end
	end
end

function _G.VisUpdateMobileVisuals()
	for n, e in pairs(modeRefs) do
		if e and e.holder and e.btn then
			local sc = tonumber(St.btnScale) or 1
			local w = math.max(80, math.floor(98 * sc))
			local h = math.max(32, math.floor(36 * sc))
			e.holder.Size = UDim2.new(0, w, 0, h)
			e.btn.TextSize = math.clamp(math.floor(h * 0.36), 11, 14)
			local c = e.btn:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", e.btn)
			c.CornerRadius = UDim.new(0, 12) -- V2 bo góc chữ nhật
			if e.style then e.style(St.activeMode == n) end
		end
	end
	for key, e in pairs(actRefs) do
		if e and e.holder and e.btn then
			local base = (St.btnSizes[key] or 50)
			if key == "steal" or key == "sentry" then base = math.max(base, 56) end
			local sz = math.max(28, math.floor(base * (St.btnScale or 1)))
			e.holder.Size = UDim2.new(0, sz, 0, sz)
			e.btn.TextSize = math.clamp(math.floor(sz * 0.22), 10, 16)
			applyCorner(e.btn, St.btnShape or "Round")
			applyCornerToChildren(e.btn, St.btnShape or "Round")
			-- viền
			local s = e.btn:FindFirstChild("BtnBorder") or e.btn:FindFirstChildOfClass("UIStroke")
			if not s then
				s = Instance.new("UIStroke")
				s.Name = "BtnBorder"
				s.Parent = e.btn
			end
			s.Color = Color3.fromRGB(220, 220, 235)
			s.Thickness = 2
			s.Transparency = 0.15
		end
	end
	if _G.VisRefreshModeBar then pcall(_G.VisRefreshModeBar) end
	if _G.VisRefreshSentryBtn then pcall(_G.VisRefreshSentryBtn) end
	if _G.VisRefreshStealBtn then pcall(_G.VisRefreshStealBtn) end
	-- Scale Speed V2 mode bar
	pcall(function()
		local gui = PlayerGui:FindFirstChild("VisV2ModeBar")
		if not gui then return end
		local sc = tonumber(St.btnScale) or 1
		local modeSz = tonumber(St.btnSizes and St.btnSizes.mode) or 50
		-- Size Speed 3Mode: tăng chiều cao; width ổn định
		local h = math.max(28, math.floor(modeSz * sc))
		local w = math.max(72, math.floor(88 * sc))
		for _, holder in ipairs(gui:GetChildren()) do
			if holder:IsA("Frame") and holder.Name:match("^V2MH_") then
				holder.Size = UDim2.new(0, w, 0, h)
				local btn = holder:FindFirstChildWhichIsA("TextButton")
				if btn then
					btn.TextSize = math.clamp(math.floor(h * 0.36), 9, 16)
				end
			end
		end
	end)
end

function _G.VisApplyMobile()
	ModeGui.Enabled = St.mobileBtns == true
	ActGui.Enabled = St.mobileBtns == true
	local hasMode = next(modeRefs) ~= nil
	local hasAct = next(actRefs) ~= nil
	if not hasMode or not hasAct then
		rebuildMobile()
	end
	-- luôn áp shape/size (Box/Round/Square) kể cả khi đã có nút
	if _G.VisUpdateMobileVisuals then pcall(_G.VisUpdateMobileVisuals) end
end
function _G.VisResetMobilePos()
	St._btnPos = {}
	rebuildMobile()
	pcall(saveCfg)
end
_G.VisApplyMobile()

----------------------------------------------------------------
-- KEYBINDS (Drop / TP / Insta / Mode) — no menu toggle key
----------------------------------------------------------------
UIS.InputBegan:Connect(function(input, gp)
	if gp or listening then return end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	local k = input.KeyCode
	if k == St.keys.Drop then runDrop()
	elseif k == St.keys.TPDown then doTPDown(true)
	elseif k == St.keys.InstaReset then doInstaReset()
	elseif k == St.keys.DestroySentry then setDestroySentry(not St.destroySentry)
	elseif St.keys.AutoSteal and k == St.keys.AutoSteal then
		if type(setAutoSteal) == "function" then
			setAutoSteal(not (St.autoSteal == true))
			-- sync toggle UI
			if ToggleRefs and ToggleRefs.autoSteal and ToggleRefs.autoSteal.setVisual then
				pcall(ToggleRefs.autoSteal.setVisual, St.autoSteal == true)
			end
		end
	else
		for name, m in pairs(St.modes) do
			if m.key == k then setActiveMode(name) break end
		end
	end
end)

----------------------------------------------------------------
-- BOOT
----------------------------------------------------------------

-- ============================================================
-- REAPPLY ALL LOGIC (fix/rejoin/respawn) — không nút ảo
-- ============================================================
function reapplyAllLogic(reason)
	reason = tostring(reason or "boot")
	-- Speed
	pcall(function()
		if St.speedOn then
			-- force restart loop
			if speedConnection then
				pcall(function() speedConnection:Disconnect() end)
				speedConnection = nil
			end
			startSpeedBoost()
			if St.activeMode and setActiveMode then setActiveMode(St.activeMode) end
		else
			if stopSpeedBoost then stopSpeedBoost() end
		end
	end)
	-- Inf Jump
	pcall(function()
		if St.infJump then
			InfJumpState.enabled = true
			InfJumpState.mode = St.infJumpMode or "hold"
			if startInfJump then startInfJump() elseif setInfJump then setInfJump(true) end
		else
			if stopInfJump then stopInfJump() end
		end
	end)
	-- Anti ragdoll
	pcall(function()
		if St.antiRagdoll then
			if AntiRagdollV2 then AntiRagdollV2.Enabled = true end
			if startAntiRagdoll then startAntiRagdoll() end
		else
			if stopAntiRagdoll then stopAntiRagdoll() end
		end
	end)
	-- Anti FX flags
	pcall(function()
		if AntiFX then
			AntiFX.gummy = true
			AntiFX.boogie = true
			AntiFX.paint = true
			St.antiGummy = true
			St.antiBoogie = true
			St.antiPaint = true
		end
	end)
	-- Tool aim + rehook
	pcall(function()
		if St.toolAim then
			aimOn = true
			local char = LP.Character
			if char and watchTools then watchTools(char) end
			local bp = LP:FindFirstChild("Backpack")
			if bp and watchTools then watchTools(bp) end
		else
			aimOn = false
		end
	end)
	-- Destroy sentry
	pcall(function()
		if St.destroySentry and setDestroySentry then setDestroySentry(true) end
	end)
	-- ESP / tracer / antilag
	pcall(function() if St.esp and setESP then setESP(true) end end)
	pcall(function() if St.tracer and setTracer then setTracer(true) end end)
	pcall(function() if St.antiLag and setAntiLag then setAntiLag(true) end end)
	-- Spam
	pcall(function() if St.spamLaser and setSpamLaser then setSpamLaser(true) end end)
	pcall(function() if St.spamPaint and setSpamPaint then setSpamPaint(true) end end)
	-- Auto steal
	pcall(function()
		if St.autoSteal then
			if type(setAutoSteal) == "function" then setAutoSteal(true) end
			if _G.VisSyncAutoSteal then pcall(_G.VisSyncAutoSteal) end
		end
	end)
	-- Ragdoll TP
	pcall(function()
	end)
	-- Mobile buttons
	pcall(function()
		if ModeGui then ModeGui.Enabled = St.mobileBtns == true end
		if ActGui then ActGui.Enabled = St.mobileBtns == true end
		if _G.VisApplyMobile then pcall(_G.VisApplyMobile) end
	end)
	-- Sync toggle UI + ép logic chạy nếu đang ON
	pcall(function()
		for name, ref in pairs(ToggleRefs or {}) do
			if ref and St[name] ~= nil then
				local on = St[name] == true
				if ref.setVisual then
					pcall(ref.setVisual, on)
				end
			end
		end
	end)
end
_G.VisReapplyAllLogic = reapplyAllLogic


-- Re-apply ALL saved states so toggles that show ON actually work
pcall(function() setAntiGummy(St.antiGummy ~= false) end)
pcall(function() setAntiBoogie(St.antiBoogie ~= false) end)
pcall(function() setAntiPaint(St.antiPaint ~= false) end)
pcall(function() setAntiRagdoll(St.antiRagdoll == true) end)
pcall(function() setToolAim(St.toolAim ~= false) end)
pcall(function() setInfJump(St.infJump ~= false) end)
pcall(function() setDestroySentry(St.destroySentry == true) end)
pcall(function() setSpeedOn(St.speedOn ~= false) end)
pcall(function() setActiveMode(St.activeMode or "Normal") end)
pcall(function() setESP(St.esp == true) end)
pcall(function() setTracer(St.tracer == true) end)
pcall(function() setAntiLag(St.antiLag == true) end)
pcall(function() setSpamLaser(St.spamLaser == true) end)
pcall(function() setSpamPaint(St.spamPaint == true) end)
-- Auto Steal after setups exist
task.defer(function()
	pcall(function()
		if type(setAutoSteal) == "function" then
			setAutoSteal(St.autoSteal == true)
		end
		if St.autoSteal and _G.VisSyncAutoSteal then
			pcall(_G.VisSyncAutoSteal)
		end
	end)
end)
pcall(applyMenuScale)
pcall(function() setTab("Player") end)
task.defer(function()
	task.wait(0.6)
	pcall(function() if reapplyAllLogic then reapplyAllLogic("boot") end end)
end)
task.defer(function()
	-- rejoin server: re-apply sau 2s (chờ character/plot load)
	task.wait(2)
	pcall(function() if reapplyAllLogic then reapplyAllLogic("boot-delayed") end end)
end)
-- Sync toggle UI to match actual state
task.defer(function()
	-- sync toggle UI
	for name, ref in pairs(ToggleRefs or {}) do
		if ref and ref.set and St[name] ~= nil then
			pcall(function() ref.set(St[name] == true) end)
		end
	end
	-- force-apply runtime features (sau load / rejoin) — logic thật, không chỉ UI
	pcall(function() if St.speedOn and startSpeedBoost then startSpeedBoost() end end)
	pcall(function() if St.antiRagdoll and startAntiRagdoll then startAntiRagdoll() end end)
	pcall(function()
		if St.infJump then
			InfJumpState.enabled = true
			InfJumpState.mode = St.infJumpMode or "hold"
		end
	end)
	pcall(function() if St.toolAim and setToolAim then setToolAim(true) end end)
	pcall(function()
		if ModeGui then ModeGui.Enabled = St.mobileBtns == true end
		if ActGui then ActGui.Enabled = St.mobileBtns == true end
		if next(modeRefs) == nil or next(actRefs) == nil then
			if _G.VisApplyMobile then _G.VisApplyMobile() end
		end
	end)
	pcall(function() if St.activeMode and setActiveMode then setActiveMode(St.activeMode) end end)
	pcall(function() if St.autoSteal and type(setAutoSteal) == "function" then setAutoSteal(true) end end)
	pcall(function() if St.destroySentry and setDestroySentry then setDestroySentry(true) end end)
end)


-- Re-apply features on respawn / rejoin (full logic, không nút ảo)
if _G._VisHubCharReapplyConn then
	pcall(function() _G._VisHubCharReapplyConn:Disconnect() end)
	_G._VisHubCharReapplyConn = nil
end
_G._VisHubCharReapplyConn = LP.CharacterAdded:Connect(function(char)
	task.wait(0.4)
	pcall(function()
		if reapplyAllLogic then
			reapplyAllLogic("CharacterAdded")
		else
			if St.speedOn and startSpeedBoost then
				if speedConnection then pcall(function() speedConnection:Disconnect() end); speedConnection = nil end
				startSpeedBoost()
			end
			if St.infJump and setInfJump then setInfJump(true) end
			if St.antiRagdoll and startAntiRagdoll then startAntiRagdoll() end
			if St.toolAim and setToolAim then setToolAim(true) end
			if St.autoSteal and _G.VisSyncAutoSteal then pcall(_G.VisSyncAutoSteal) end
		end
	end)
end)

print("[VisHub Full] Player(Anti+Speed S2+Aim+Drop+Insta) | ESP | Settings mobile/lock/shape/size")



-- ============================================================
-- EXTENSION: InfJump 2-mode | Auto Steal V1/V2 | Steal Bar | Panel TP
-- ============================================================

-- InfJump mode: hold | manual
St.infJumpMode = St.infJumpMode or "hold"
-- setInfJumpMode already defined above

function isMyPlot(plotName)
	local plots = workspace:FindFirstChild("Plots")
	local plot = plots and plots:FindFirstChild(plotName)
	if not plot then return false end
	local sign = plot:FindFirstChild("PlotSign")
	local yb = sign and sign:FindFirstChild("YourBase")
	return yb and yb:IsA("BillboardGui") and yb.Enabled
end

function findStealPrompt()
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return nil, nil end
	local radius = St.stealRadius or 60
	local best, bestDist, bestPart = nil, math.huge, nil
	local function consider(d)
		if not isStealAction(d) then return end
		if d.Enabled == false then return end
		if LP.Character and d:IsDescendantOf(LP.Character) then return end
		local part = d.Parent
		local basePart = part and (part:IsA("BasePart") and part
			or part:FindFirstChildWhichIsA("BasePart", true)
			or d:FindFirstAncestorWhichIsA("BasePart"))
		if not basePart then return end
		local plot = d
		for _ = 1, 8 do
			if not plot.Parent or plot.Parent == workspace then break end
			plot = plot.Parent
			if isOwnPlot(plot) then return end
		end
		local dist = (basePart.Position - root.Position).Magnitude
		if dist <= radius and dist < bestDist then
			best, bestDist, bestPart = d, dist, basePart
		end
	end
	local plots = workspace:FindFirstChild("Plots") or workspace:FindFirstChild("plots")
	if plots then
		for _, plot in ipairs(plots:GetChildren()) do
			if not isOwnPlot(plot) then
				for _, d in ipairs(plot:GetDescendants()) do
					if d:IsA("ProximityPrompt") then consider(d) end
				end
			end
		end
	else
		for _, d in ipairs(workspace:GetDescendants()) do
			if d:IsA("ProximityPrompt") then consider(d) end
		end
	end
	return best, bestPart
end

function fireSteal(prompt)
	if not prompt then return end
	if not StealA.data[prompt] then
		StealA.data[prompt] = { hold = {}, trigger = {} }
		if getconnections then
			pcall(function()
				for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan) or {}) do
					if c.Function then table.insert(StealA.data[prompt].hold, c.Function) end
				end
				for _, c in ipairs(getconnections(prompt.Triggered) or {}) do
					if c.Function then table.insert(StealA.data[prompt].trigger, c.Function) end
				end
			end)
		end
	end
	local data = StealA.data[prompt]
	for _, fn in ipairs(data.hold) do task.spawn(fn) end
	for _, fn in ipairs(data.trigger) do task.spawn(fn) end
	if #data.hold == 0 and #data.trigger == 0 and fireproximityprompt then
		pcall(function() fireproximityprompt(prompt) end)
	end
end

function executeStealV1(prompt, part)
	if StealA.busy or not prompt then return end
	StealA.busy = true
	local dur = St.stealDuration or 1.4
	local pauseOn = St.stealPause == true
	local pausePct = (St.stealPausePct or 75) / 100
	local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	local function stillInRange()
		if not prompt or not prompt.Parent or not part or not part.Parent then return false end
		local r = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
		if not r then return false end
		return (r.Position - part.Position).Magnitude <= (St.stealRadius or 60)
	end
	local function closeEnough()
		local r = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
		if not r or not part then return false end
		return (r.Position - part.Position).Magnitude <= 3
	end

	task.spawn(function()
		-- hold begin
		for _, fn in ipairs((StealA.data[prompt] and StealA.data[prompt].hold) or {}) do
			task.spawn(fn)
		end
		if fireproximityprompt then pcall(function() fireproximityprompt(prompt, dur) end) end

		if pauseOn then
			-- 0 → pausePct, wait close, then → 100%
			local t0 = tick()
			while tick() - t0 < dur * pausePct do
				if not StealA.enabled or not stillInRange() then
					_G.VisStealBar.Reset()
					StealA.busy = false
					return
				end
				local p = (tick() - t0) / dur
				_G.VisStealBar.Set(math.clamp(p, 0, pausePct), "STEALING")
				task.wait()
			end
			_G.VisStealBar.Set(pausePct, "WAIT")
			-- wait until close
			while StealA.enabled and stillInRange() and not closeEnough() do
				_G.VisStealBar.Set(pausePct, "WAIT")
				task.wait(0.05)
			end
			if not StealA.enabled or not stillInRange() then
				_G.VisStealBar.Reset()
				StealA.busy = false
				return
			end
			local t1 = tick()
			local remain = dur * (1 - pausePct)
			while tick() - t1 < remain do
				if not StealA.enabled or not stillInRange() then
					_G.VisStealBar.Reset()
					StealA.busy = false
					return
				end
				local p = pausePct + (tick() - t1) / remain * (1 - pausePct)
				_G.VisStealBar.Set(p, "STEALING")
				task.wait()
			end
		else
			-- continuous 0-100 loop while in radius
			while StealA.enabled and stillInRange() do
				local t0 = tick()
				while tick() - t0 < dur do
					if not StealA.enabled or not stillInRange() then
						_G.VisStealBar.Reset()
						StealA.busy = false
						return
					end
					_G.VisStealBar.Set((tick() - t0) / dur, "STEALING")
					task.wait()
				end
				_G.VisStealBar.Set(1, "SUCCESS")
				fireSteal(prompt)
				_G.VisStealBar.Reset() -- 100% → 0 ngay, loop tiếp trong radius
			end
			StealA.busy = false
			return
		end
		_G.VisStealBar.Set(1, "SUCCESS")
		fireSteal(prompt)
		_G.VisStealBar.Reset() -- 100% → 0 ngay
		StealA.busy = false
		-- tiếp tục nếu còn trong radius (heartbeat startAutoSteal sẽ pick lại)
	end)
end

function executeStealV2(prompt, part)
	-- V2: hold full then trigger when in range (simpler BloodHounds-like)
	if StealA.busy or not prompt then return end
	StealA.busy = true
	local dur = St.stealDuration or 1.4
	task.spawn(function()
		local t0 = tick()
		while tick() - t0 < dur do
			if not StealA.enabled then
				_G.VisStealBar.Reset()
				StealA.busy = false
				return
			end
			local r = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
			if not r or not part or not part.Parent then
				_G.VisStealBar.Reset()
				StealA.busy = false
				return
			end
			if (r.Position - part.Position).Magnitude > (St.stealRadius or 60) then
				_G.VisStealBar.Reset()
				StealA.busy = false
				return
			end
			_G.VisStealBar.Set((tick() - t0) / dur, "STEALING")
			task.wait()
		end
		_G.VisStealBar.Set(1, "SUCCESS")
		fireSteal(prompt)
		_G.VisStealBar.Reset() -- 100% → 0 ngay
		StealA.busy = false
	end)
end

function startAutoSteal()
	StealA.enabled = true
	if StealA.conn then return end
	StealA.conn = RS.Heartbeat:Connect(function()
		if not StealA.enabled or StealA.busy then return end
		local prompt, part = findStealPrompt()
		if prompt then
			if St.stealVer == "V2" then
				executeStealV2(prompt, part)
			else
				executeStealV1(prompt, part)
			end
		end
	end)
end
function stopAutoSteal()
	StealA.enabled = false
	StealA.busy = false
	if StealA.conn then pcall(function() StealA.conn:Disconnect() end) StealA.conn = nil end
	-- Chỉ về 0%, KHÔNG ẩn / destroy steal bar
	_G.AceStealBarProgress = 0
	pcall(function() if _G.StealBar and _G.StealBar.Reset then _G.StealBar.Reset() end end)
	pcall(function() if _G.VisStealBar and _G.VisStealBar.Reset then _G.VisStealBar.Reset() end end)
end
function setAutoSteal(on)
	-- exported below
	St.autoSteal = on and true or false
	autoStealEnabled = St.autoSteal
	autoStealRadius = tonumber(St.stealRadius) or 60
	selectedStealMode = St.stealVer or "V1"
	if St.autoSteal then startAutoSteal() else stopAutoSteal() end
	if _G.VisSyncAutoSteal then pcall(_G.VisSyncAutoSteal) end
	if _G.VisRefreshStealBtn then pcall(_G.VisRefreshStealBtn) end
	-- đảm bảo nút mobile tồn tại
	if St.autoSteal and (not actRefs or not actRefs.steal) and _G.VisApplyMobile then
		pcall(_G.VisApplyMobile)
	end
	saveCfg()
end

----------------------------------------------------------------
-- PANEL TP (from VisHubb, no music / no image / no sentry)
----------------------------------------------------------------
local TP = {
	base = nil, pet = nil,
	delayBase = 0.07, delayPet = 0.07,
	key = Enum.KeyCode.X,
	busy = false, markers = {},
}

_G.setAutoSteal = setAutoSteal
_G.setDestroySentry = setDestroySentry

function tpMarker(pos, col)
	local P = Instance.new("Part")
	P.Size = Vector3.new(3, 0.25, 3)
	P.Material = Enum.Material.Neon
	P.Anchored = true
	P.CanCollide = false
	P.Position = pos + Vector3.new(0, 2, 0)
	P.Color = col
	P.Name = "VisTP_SavePoint"
	P.Parent = workspace
	return P
end

function smoothTP(hrp, pos)
	hrp.AssemblyLinearVelocity = Vector3.zero
	hrp.AssemblyAngularVelocity = Vector3.zero
	local tw = TS:Create(hrp, TweenInfo.new(0.065, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		CFrame = CFrame.new(pos),
	})
	tw:Play()
	tw.Completed:Wait()
end

function chilliTP(hrp, targetPos, char)
	if not hrp or not targetPos then return end
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	-- equip carpet if any
	pcall(function()
		for _, n in ipairs({"Flying Carpet", "Carpet", "Cloud", "Witch's Broom"}) do
			local g = char:FindFirstChild(n) or LP.Backpack:FindFirstChild(n)
			if g and hum then hum:EquipTool(g) break end
		end
	end)
	task.wait(0.04)
	for _, p in ipairs(char:GetDescendants()) do
		if p:IsA("BasePart") then pcall(function() p.CanCollide = false end) end
	end
	if hum then pcall(function() hum.PlatformStand = true end) end
	local airHeight = 95
	local airPos = Vector3.new(targetPos.X, targetPos.Y + airHeight, targetPos.Z)
	hrp.CFrame = CFrame.new(airPos)
	hrp.AssemblyLinearVelocity = Vector3.new(0, -5, 0)
	task.wait(0.05)
	hrp.AssemblyLinearVelocity = Vector3.new(0, -220, 0)
	local landY = targetPos.Y + 3
	pcall(function()
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = { char }
		local result = workspace:Raycast(airPos, Vector3.new(0, -(airHeight + 80), 0), params)
		if result then landY = result.Position.Y + 3.2 end
	end)
	local landPos = Vector3.new(targetPos.X, landY, targetPos.Z)
	local t0 = os.clock()
	while os.clock() - t0 < 0.55 do
		if not hrp.Parent then break end
		if hrp.Position.Y <= landY + 8 then break end
		hrp.AssemblyLinearVelocity = Vector3.new(0, -220, 0)
		task.wait()
	end
	for _ = 1, 6 do
		if not hrp.Parent then break end
		hrp.CFrame = CFrame.new(landPos)
		hrp.AssemblyLinearVelocity = Vector3.zero
		task.wait(0.03)
	end
	if hum then pcall(function() hum.PlatformStand = false end) end
	for _, p in ipairs(char:GetDescendants()) do
		if p:IsA("BasePart") then pcall(function() p.CanCollide = true end) end
	end
end

function runPanelTP()
	if TP.busy then return end
	if not TP.base and not TP.pet then
		showToast("Chưa lưu điểm")
		return
	end
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	TP.busy = true
	task.spawn(function()
		pcall(function()
			if (TP.base and not TP.pet) or (TP.pet and not TP.base) then
				chilliTP(hrp, TP.base or TP.pet, char)
			else
				smoothTP(hrp, TP.base)
				task.wait(TP.delayBase)
				char = LP.Character or char
				hrp = char and char:FindFirstChild("HumanoidRootPart") or hrp
				if hrp and TP.pet then smoothTP(hrp, TP.pet) end
			end
		end)
		TP.busy = false
		if _G.VisRefreshTPBtn then _G.VisRefreshTPBtn() end
	end)
end

-- Panel TP GUI (popup)
function openPanelTP()
	local old = PlayerGui:FindFirstChild("VisPanelTP")
	if old then old:Destroy() end
	local gui = Instance.new("ScreenGui")
	gui.Name = "VisPanelTP"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 130
	gui.Parent = PlayerGui
	local f = Instance.new("Frame")
	f.Size = UDim2.new(0, 260, 0, 320)
	f.Position = UDim2.new(0.5, -130, 0.5, -160)
	f.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
	f.BorderSizePixel = 0
	f.Active = true
	f.Parent = gui
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
	local st = Instance.new("UIStroke", f)
	st.Color = Color3.fromRGB(120, 90, 200)
	st.Thickness = 1.5
	-- drag
	local panelLocked = false
	do
		local dragging, dragStart, startPos
		f.InputBegan:Connect(function(input)
			if panelLocked then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = f.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
						-- save panel pos
						St._panelTPPos = {f.Position.X.Scale, f.Position.X.Offset, f.Position.Y.Scale, f.Position.Y.Offset}
						saveCfg()
					end
				end)
			end
		end)
		UIS.InputChanged:Connect(function(input)
			if dragging and not panelLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local d = input.Position - dragStart
				f.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
			end
		end)
	end
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -120, 0, 32)
	title.Position = UDim2.new(0, 10, 0, 4)
	title.BackgroundTransparency = 1
	title.Text = "PANEL TP"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = f
	local close = Instance.new("TextButton")
	close.Size = UDim2.new(0, 28, 0, 28)
	close.Position = UDim2.new(1, -34, 0, 6)
	close.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
	close.Text = "X"
	close.TextColor3 = Color3.new(1, 1, 1)
	close.Font = Enum.Font.GothamBold
	close.Parent = f
	Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
	close.MouseButton1Click:Connect(function() gui:Destroy() end)
	local lockB = Instance.new("TextButton")
	lockB.Size = UDim2.new(0, 64, 0, 24)
	lockB.Position = UDim2.new(1, -100, 0, 8)
	lockB.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
	lockB.Text = "UNLOCK"
	lockB.TextColor3 = Color3.new(1,1,1)
	lockB.Font = Enum.Font.GothamBold
	lockB.TextSize = 10
	lockB.Parent = f
	Instance.new("UICorner", lockB).CornerRadius = UDim.new(0, 6)
	lockB.MouseButton1Click:Connect(function()
		panelLocked = not panelLocked
		lockB.Text = panelLocked and "LOCK" or "UNLOCK"
		lockB.BackgroundColor3 = panelLocked and Color3.fromRGB(180, 60, 80) or Color3.fromRGB(40, 40, 55)
	end)
	-- restore pos
	if St._panelTPPos then
		f.Position = UDim2.new(St._panelTPPos[1], St._panelTPPos[2], St._panelTPPos[3], St._panelTPPos[4])
	end

	local function mkBtn(text, y, col, cb)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, -24, 0, 32)
		b.Position = UDim2.new(0, 12, 0, y)
		b.BackgroundColor3 = col or Color3.fromRGB(50, 50, 70)
		b.Text = text
		b.TextColor3 = Color3.new(1, 1, 1)
		b.Font = Enum.Font.GothamBold
		b.TextSize = 12
		b.Parent = f
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
		b.MouseButton1Click:Connect(cb)
		return b
	end
	mkBtn("Lưu Base (điểm 1)", 44, Color3.fromRGB(180, 80, 140), function()
		local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		TP.base = hrp.Position
		if TP.markers.base then TP.markers.base:Destroy() end
		TP.markers.base = tpMarker(TP.base, Color3.fromRGB(255, 105, 180))
		showToast("BASE SAVED")
		if _G.VisRefreshTPBtn then _G.VisRefreshTPBtn() end
	end)
	mkBtn("Lưu Pet (điểm 2)", 84, Color3.fromRGB(200, 120, 40), function()
		local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		TP.pet = hrp.Position
		if TP.markers.pet then TP.markers.pet:Destroy() end
		TP.markers.pet = tpMarker(TP.pet, Color3.fromRGB(255, 140, 0))
		showToast("PET SAVED")
		if _G.VisRefreshTPBtn then _G.VisRefreshTPBtn() end
	end)
	mkBtn("Xóa điểm", 124, Color3.fromRGB(80, 40, 40), function()
		TP.base, TP.pet = nil, nil
		if TP.markers.base then TP.markers.base:Destroy() end
		if TP.markers.pet then TP.markers.pet:Destroy() end
		TP.markers = {}
		showToast("CLEARED")
		if _G.VisRefreshTPBtn then _G.VisRefreshTPBtn() end
	end)
	mkBtn("TP NOW", 164, Color3.fromRGB(90, 70, 180), function()
		runPanelTP()
	end)
	-- delays
	local function delayRow(label, key, y)
		local t = Instance.new("TextLabel")
		t.Size = UDim2.new(0.5, 0, 0, 24)
		t.Position = UDim2.new(0, 12, 0, y)
		t.BackgroundTransparency = 1
		t.Text = label
		t.TextColor3 = Color3.fromRGB(200, 200, 210)
		t.TextSize = 11
		t.Font = Enum.Font.Gotham
		t.TextXAlignment = Enum.TextXAlignment.Left
		t.Parent = f
		local val = Instance.new("TextLabel")
		val.Size = UDim2.new(0, 50, 0, 24)
		val.Position = UDim2.new(1, -100, 0, y)
		val.BackgroundTransparency = 1
		val.Text = string.format("%.2f", TP[key])
		val.TextColor3 = Color3.new(1, 1, 1)
		val.Font = Enum.Font.GothamBold
		val.TextSize = 12
		val.Parent = f
		for i, sign in ipairs({ "-", "+" }) do
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(0, 24, 0, 24)
			b.Position = UDim2.new(1, -40 + (i - 1) * 28 - 28, 0, y)
			b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
			b.Text = sign
			b.TextColor3 = Color3.new(1, 1, 1)
			b.Font = Enum.Font.GothamBold
			b.Parent = f
			Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
			b.MouseButton1Click:Connect(function()
				TP[key] = math.clamp(TP[key] + (sign == "+" and 0.01 or -0.01), 0.01, 0.5)
				val.Text = string.format("%.2f", TP[key])
			end)
		end
	end
	delayRow("Delay Base", "delayBase", 210)
	delayRow("Delay Pet", "delayPet", 240)
	-- keybind
	local keyBtn = mkBtn("PHÍM TP: [" .. tostring(TP.key):gsub("Enum.KeyCode.", "") .. "]", 270, Color3.fromRGB(40, 40, 55), function() end)
	keyBtn.MouseButton1Click:Connect(function()
		keyBtn.Text = "Nhấn phím..."
		local conn
		conn = UIS.InputBegan:Connect(function(input, gp)
			if gp or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
			TP.key = input.KeyCode
			keyBtn.Text = "PHÍM TP: [" .. input.KeyCode.Name .. "]"
			conn:Disconnect()
		end)
	end)
end

-- Center TP button when 2 points saved
do
	local tpg = Instance.new("ScreenGui")
	tpg.Name = "VisCenterTP"
	tpg.ResetOnSpawn = false
	tpg.IgnoreGuiInset = true
	tpg.DisplayOrder = 1002
	tpg.Parent = PlayerGui
	local btn = Instance.new("TextButton")
	btn.Name = "CenterTP"
	btn.Size = UDim2.new(0, 160, 0, 40)
	btn.Position = UDim2.new(0.5, -80, 1, -120)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
	btn.Text = "TP"
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBlack
	btn.TextSize = 14
	btn.Visible = false
	btn.Parent = tpg
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
	local bst = Instance.new("UIStroke", btn)
	bst.Color = Color3.fromRGB(140, 100, 255)
	btn.MouseButton1Click:Connect(runPanelTP)
	function _G.VisRefreshTPBtn()
		local has = TP.base ~= nil or TP.pet ~= nil
		btn.Visible = has
		local kn = tostring(TP.key):gsub("Enum.KeyCode.", "")
		if TP.base and TP.pet then
			btn.Text = "TP [" .. kn .. "]"
		elseif TP.base or TP.pet then
			btn.Text = "TP 1pt [" .. kn .. "]"
		else
			btn.Visible = false
		end
	end
end

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == TP.key then
		runPanelTP()
	end
end)


----------------------------------------------------------------
-- BODY LOCK (full VisHub Clean / BloodHounds)
----------------------------------------------------------------
local bodyLockEnabled = false
local bodyLockRange = 20
local _bodyLockConn = nil
local _blSuppressCount = 0

function bodyLockCombatActive()
	return (_G.AceNormalAimbotOn == true)
		or (_G.AceAntiBypassAimbotOn == true)
		or (_G.AceAntiDesyncAimbotOn == true)
		or (St and St.toolAim == true and _G._VisToolAimActive == true)
end

function getClosestTargetBody()
	local char = LP.Character
	if not char then return nil end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	local closest, minDist = nil, math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then
			local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			if tRoot and hum and hum.Health > 0 then
				local dist = (tRoot.Position - root.Position).Magnitude
				if dist < minDist then
					minDist = dist
					closest = tRoot
				end
			end
		end
	end
	return closest
end

-- Clean / BloodHounds body lock tick (predict + angular velocity)
function _bodyLockTick()
	local char = LP.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local target = getClosestTargetBody()
	if not target then
		if not hum.AutoRotate then hum.AutoRotate = true end
		return
	end
	local range = tonumber(bodyLockRange) or (type(St)=="table" and tonumber(St.bodyLockRange)) or 20
	local dist = (target.Position - root.Position).Magnitude
	if dist > range then
		if not hum.AutoRotate then hum.AutoRotate = true end
		return
	end
	if hum.AutoRotate then hum.AutoRotate = false end
	local targetVel = target.AssemblyLinearVelocity
	local speed3 = targetVel.Magnitude
	local predictTime = math.clamp(speed3 / 80, 0.08, 0.35)
	local predictedPos = target.Position + targetVel * predictTime
	local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
	local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
	local myHeight = root.Position.Y + (hum.HipHeight or 0)
	local heightDiff = targetHeight - myHeight
	local verticalCorrection = math.clamp(heightDiff * 0.15, -1.5, 1.5)
	local flatTarget = Vector3.new(predictedPos.X, root.Position.Y + verticalCorrection, predictedPos.Z)
	local toPredict = flatTarget - root.Position
	if toPredict.Magnitude > 0.1 then
		local goalCF = CFrame.lookAt(root.Position, flatTarget)
		local diffCF = root.CFrame:Inverse() * goalCF
		local _, ry, _ = diffCF:ToEulerAnglesXYZ()
		ry = math.clamp(ry, -2.5, 2.5)
		root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
	end
end

function startBodyLock()
	if _bodyLockConn then
		pcall(function() _bodyLockConn:Disconnect() end)
		_bodyLockConn = nil
	end
	bodyLockEnabled = true
	if type(St) == "table" then St.bodyLock = true end
	local RS_ = RS or RunService or game:GetService("RunService")
	_bodyLockConn = RS_.RenderStepped:Connect(function()
		if not bodyLockEnabled then return end
		if (_blSuppressCount or 0) > 0 then return end
		_bodyLockTick()
	end)
end

function stopBodyLock()
	if _bodyLockConn then
		pcall(function() _bodyLockConn:Disconnect() end)
		_bodyLockConn = nil
	end
	bodyLockEnabled = false
	if type(St) == "table" then St.bodyLock = false end
	local c = LP.Character
	local root = c and c:FindFirstChild("HumanoidRootPart")
	if root then
		root.AssemblyAngularVelocity = Vector3.zero
		root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z)
	end
	local hum2 = c and c:FindFirstChildOfClass("Humanoid")
	if hum2 then hum2.AutoRotate = true end
end

-- Clean suppress (auto left/right / bat can pause lock)
function _suppressBodyLock()
	_blSuppressCount = (_blSuppressCount or 0) + 1
	if _blSuppressCount == 1 and bodyLockEnabled then
		_blWasEnabled = true
		-- only disconnect loop, keep bodyLockEnabled true for restore
		if _bodyLockConn then
			pcall(function() _bodyLockConn:Disconnect() end)
			_bodyLockConn = nil
		end
		if bodyLockSetVisual then pcall(bodyLockSetVisual, false) end
		if _blRestoreTimer then
			pcall(task.cancel, _blRestoreTimer)
			_blRestoreTimer = nil
		end
		_blSmoothRestore = false
	end
end

function _unsuppressBodyLock(delayed)
	if (_blSuppressCount or 0) > 0 then
		_blSuppressCount = _blSuppressCount - 1
	end
	if _blSuppressCount == 0 and _blWasEnabled then
		_blWasEnabled = false
		local function restore()
			if bodyLockEnabled then
				_blSmoothRestore = true
				startBodyLock()
				if bodyLockSetVisual then pcall(bodyLockSetVisual, true) end
				task.delay(0.5, function() _blSmoothRestore = false end)
			end
			_blRestoreTimer = nil
		end
		if delayed then
			_blRestoreTimer = task.delay(1, restore)
		else
			restore()
		end
	end
end

function setBodyLock(on)
	if on then startBodyLock() else stopBodyLock() end
	pcall(function() if saveCfg then saveCfg() end end)
end

-- sync range from config when set
function setBodyLockRange(v)
	v = math.clamp(tonumber(v) or 20, 5, 100)
	bodyLockRange = v
	St.bodyLockRange = v
	saveCfg()
end


----------------------------------------------------------------
-- UI: Panel tab + Auto Steal + InfJump mode on existing pages
----------------------------------------------------------------
task.defer(function()
	-- Auto steal on Player page
	if not pagePlayer then warn("[VisHub] pagePlayer nil") return end
	section(pagePlayer, "* — AUTO STEAL", 20)
	local function safeSetAS(on)
		if type(setAutoSteal) == "function" then
			setAutoSteal(on)
		else
			St.autoSteal = on and true or false
		end
	end
	toggleNamed(pagePlayer, "Auto Steal", St.autoSteal == true, safeSetAS, 21, "autoSteal")
	-- ver modes
	local verRow = row(pagePlayer, 36, 22)
	local vl = Instance.new("TextLabel")
	vl.Size = UDim2.new(0.35, 0, 1, 0)
	vl.Position = UDim2.new(0, 10, 0, 0)
	vl.BackgroundTransparency = 1
	vl.Text = "Version"
	vl.TextColor3 = C.text
	vl.TextSize = 12
	vl.Font = Enum.Font.Gotham
	vl.TextXAlignment = Enum.TextXAlignment.Left
	vl.Parent = verRow
	for i, name in ipairs({"V1", "V2", "V3"}) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0, 40, 0, 26)
		b.Position = UDim2.new(1, -140 + (i - 1) * 44, 0.5, -13)
		b.BackgroundColor3 = (St.stealVer == name) and C.accent or C.box
		b.Text = name
		b.TextColor3 = (St.stealVer == name) and Color3.fromRGB(30, 20, 30) or C.text
		b.TextSize = 11
		b.Font = Enum.Font.GothamBold
		b.AutoButtonColor = false
		b.Active = true
		b.ZIndex = 40
		b.Parent = verRow
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
		local function pickVer()
			St.stealVer = name
			for _, ch in ipairs(verRow:GetChildren()) do
				if ch:IsA("TextButton") then
					local on = ch.Text == St.stealVer
					ch.BackgroundColor3 = on and C.accent or C.box
					ch.TextColor3 = on and Color3.fromRGB(30, 20, 30) or C.text
				end
			end
			-- apply mode immediately (fix non-responsive V1/V2/V3)
			selectedStealMode = (name == "V1") and "Normal" or "Semi"
			if name == "V2" then autoStealV2Version = "V1" end
			if name == "V3" then autoStealV2Version = "V2" end
			if name == "V1" then selectedStealMode = "Normal" end
			autoStealRadius = tonumber(St.stealRadius) or 60
			if type(setAutoSteal) == "function" and St.autoSteal then
				pcall(function() setAutoSteal(true) end)
			elseif _G.VisSyncAutoSteal then
				pcall(_G.VisSyncAutoSteal)
			end
			pcall(saveCfg)
		end
		b.MouseButton1Click:Connect(pickVer)
		b.Activated:Connect(pickVer)
	end
	toggleNamed(pagePlayer, "Pause (chỉ khi bật)", St.stealPause == true, function(on)
		St.stealPause = on and true or false
		_G.VisStealPause = St.stealPause
		if _G.VisSyncAutoSteal then pcall(_G.VisSyncAutoSteal) end
		saveCfg()
	end, 23, "stealPause")
	-- radius box
	local rr = row(pagePlayer, 36, 24)
	local rl = Instance.new("TextLabel")
	rl.Size = UDim2.new(0.5, 0, 1, 0)
	rl.Position = UDim2.new(0, 10, 0, 0)
	rl.BackgroundTransparency = 1
	rl.Text = "Steal Radius"
	rl.TextColor3 = C.text
	rl.TextSize = 12
	rl.Font = Enum.Font.Gotham
	rl.TextXAlignment = Enum.TextXAlignment.Left
	rl.Parent = rr
	numBox(rr, UDim2.new(1, -70, 0.5, -12), 56, St.stealRadius, function(v)
		St.stealRadius = v
		saveCfg()
	end)
	-- force scroll size so AUTO STEAL is visible
	pcall(function()
		local lay = pagePlayer:FindFirstChildOfClass("UIListLayout")
		if lay then
			pagePlayer.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y + 40)
		end
	end)

	-- InfJump mode row near inf jump if exists
	section(pagePlayer, "* — INF JUMP MODE", 217)
	local ij = row(pagePlayer, 36, 218)
	for i, name in ipairs({"hold", "manual"}) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0, 70, 0, 26)
		b.Position = UDim2.new(0, 12 + (i - 1) * 80, 0.5, -13)
		b.BackgroundColor3 = (St.infJumpMode == name) and C.accent or C.box
		b.Text = name
		b.TextColor3 = (St.infJumpMode == name) and Color3.fromRGB(30, 20, 30) or C.text
		b.TextSize = 11
		b.Font = Enum.Font.GothamBold
		b.Parent = ij
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
		b.MouseButton1Click:Connect(function()
			setInfJumpMode(name)
			for _, ch in ipairs(ij:GetChildren()) do
				if ch:IsA("TextButton") then
					local on = ch.Text == St.infJumpMode
					ch.BackgroundColor3 = on and C.accent or C.box
					ch.TextColor3 = on and Color3.fromRGB(30, 20, 30) or C.text
				end
			end
		end)
	end

	setTab("Panel")
end)

print("[VisHub Ext] Panel TP | AutoSteal V1/V2 + bar | InfJump hold/manual | ToolAim ON")



-- ============================================================
-- TP TO BEST (Chilli style) — equip carpet + TP best brainrot
-- ============================================================
function parseGenValue(text)
	if not text then return 0 end
	text = tostring(text):gsub(",", ""):gsub("%s", ""):upper()
	-- $5M/s  $1.2B  850M  7M/S  14.8B
	local best = 0
	for num, suffix in text:gmatch("([%d%.]+)([KMBTQA]?)") do
		local n = tonumber(num)
		if n then
			local mul = 1
			if suffix == "K" then mul = 1e3
			elseif suffix == "M" then mul = 1e6
			elseif suffix == "B" then mul = 1e9
			elseif suffix == "T" then mul = 1e12
			elseif suffix == "Q" or suffix == "QA" then mul = 1e15
			end
			local v = n * mul
			if v > best then best = v end
		end
	end
	return best
end

function isStealAction(prompt)
	if not prompt or not prompt:IsA("ProximityPrompt") then return false end
	local act = tostring(prompt.ActionText or ""):lower()
	local obj = tostring(prompt.ObjectText or ""):lower()
	-- EN + ES + VI (Cướp)
	if act:find("steal") or act:find("robar") or act:find("cướp") or act:find("cuop")
		or act:find("grab") or act:find("take") then
		return true
	end
	if obj:find("steal") or obj:find("cướp") or obj:find("cuop") or obj:find("robar") then
		return true
	end
	-- unicode normalize fallback
	local actRaw = tostring(prompt.ActionText or "")
	if actRaw:find("ướp") or actRaw:find("Cướp") or actRaw:find("cướp") then return true end
	return false
end

function isOwnPlot(plot)
	if not plot then return false end
	local sign = plot:FindFirstChild("PlotSign") or plot:FindFirstChild("Sign")
	if sign then
		for _, d in ipairs(sign:GetDescendants()) do
			if d:IsA("BillboardGui") and (d.Name:lower():find("your") or d.Enabled) then
				if d.Name:lower():find("your") or d.Name:lower():find("base") then
					-- check owner attribute
				end
			end
		end
	end
	-- attribute / string value owner
	local ok, owner = pcall(function()
		return plot:GetAttribute("Owner") or plot:GetAttribute("OwnerId")
	end)
	if ok and owner and tostring(owner) == tostring(LP.UserId) then return true end
	local ok2, ownerName = pcall(function()
		return plot:GetAttribute("OwnerName")
	end)
	if ok2 and ownerName and tostring(ownerName) == LP.Name then return true end
	-- YourBase billboard
	for _, d in ipairs(plot:GetDescendants()) do
		if d:IsA("BillboardGui") and d.Name == "YourBase" and d.Enabled then
			return true
		end
	end
	return false
end

function findBestBrainrot()
	local roots = {}
	for _, name in ipairs({"Plots", "plots", "Bases", "Animals", "Pets", "Map"}) do
		local f = workspace:FindFirstChild(name)
		if f then table.insert(roots, f) end
	end
	if #roots == 0 then table.insert(roots, workspace) end

	local bestPrompt, bestVal, bestPart = nil, -1, nil
	local function consider(d)
		if not d:IsA("ProximityPrompt") then return end
		if not isStealAction(d) then return end
		if d.Enabled == false then return end
		-- skip own character
		if LP.Character and d:IsDescendantOf(LP.Character) then return end
		local part = d.Parent
		if not part then return end
		-- climb out of own plot
		local plot = d
		for _ = 1, 8 do
			if not plot.Parent or plot.Parent == workspace then break end
			plot = plot.Parent
			if isOwnPlot(plot) then return end
		end
		local basePart = part:IsA("BasePart") and part
			or (part:IsA("Model") and part:FindFirstChildWhichIsA("BasePart", true))
			or part:FindFirstAncestorWhichIsA("BasePart")
		if not basePart then return end
		local val = 0
		local searchRoot = part:IsA("Model") and part or part.Parent
		if searchRoot then
			for _, lab in ipairs(searchRoot:GetDescendants()) do
				if lab:IsA("TextLabel") or lab:IsA("TextButton") then
					local t = lab.Text or ""
					if t:find("%$") or t:find("/s") or t:find("/S") or t:upper():find("[KMBT]") then
						local v = parseGenValue(t)
						if v > val then val = v end
					end
				end
			end
		end
		local v2 = parseGenValue(d.ObjectText)
		if v2 > val then val = v2 end
		-- BillboardGui near prompt
		for _, bb in ipairs(workspace:GetDescendants()) do
			if bb:IsA("BillboardGui") and bb.Adornee then
				local okd, dist = pcall(function()
					return (bb.Adornee.Position - basePart.Position).Magnitude
				end)
				if okd and dist and dist < 12 then
					for _, lab in ipairs(bb:GetDescendants()) do
						if lab:IsA("TextLabel") then
							local v = parseGenValue(lab.Text)
							if v > val then val = v end
						end
					end
				end
			end
		end
		if val > bestVal or (val == bestVal and bestVal < 0) then
			bestVal = val
			bestPrompt = d
			bestPart = basePart
		elseif bestPrompt == nil then
			bestVal = val
			bestPrompt = d
			bestPart = basePart
		end
	end

	for _, root in ipairs(roots) do
		if root == workspace then
			-- limit scan
			for _, d in ipairs(workspace:GetDescendants()) do
				if d:IsA("ProximityPrompt") then consider(d) end
			end
		else
			for _, plot in ipairs(root:GetChildren()) do
				if not isOwnPlot(plot) then
					for _, d in ipairs(plot:GetDescendants()) do
						consider(d)
					end
				end
			end
		end
	end
	return bestPart, bestVal, bestPrompt
end

function equipFlyingCarpet(char)
	char = char or LP.Character
	if not char then return false end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return false end
	local names = {
		"Flying Carpet", "Carpet", "Cloud", "Witch's Broom",
		"Magic Carpet", "Fly Carpet", "FlyingCarpet",
	}
	for _, n in ipairs(names) do
		local g = char:FindFirstChild(n) or LP.Backpack:FindFirstChild(n)
		if g and g:IsA("Tool") then
			pcall(function() hum:EquipTool(g) end)
			return true
		end
	end
	-- fuzzy
	for _, t in ipairs(LP.Backpack:GetChildren()) do
		if t:IsA("Tool") then
			local ln = t.Name:lower()
			if ln:find("carpet") or ln:find("broom") or ln:find("cloud") or ln:find("fly") then
				pcall(function() hum:EquipTool(t) end)
				return true
			end
		end
	end
	for _, t in ipairs(char:GetChildren()) do
		if t:IsA("Tool") then
			local ln = t.Name:lower()
			if ln:find("carpet") or ln:find("broom") or ln:find("cloud") then
				return true
			end
		end
	end
	return false
end

local tpBestBusy = false
function tpToBestChilli()
	-- removed per request
end
_G.VisTpToBest = tpToBestChilli

-- UI: button on Panel + mobile + keybind
St.keys.TpBest = St.keys.TpBest or Enum.KeyCode.B

task.defer(function()
	local pagePanel = pages and pages["Panel"]
	if pagePanel then
		section(pagePanel, "* — PANEL TP", 10)
		-- TP BEST removed
	-- actionBtn panel removed
		local info = row(pagePanel, 44, 12)
		local t = Instance.new("TextLabel")
		t.Size = UDim2.new(1, -10, 1, 0)
		t.Position = UDim2.new(0, 6, 0, 0)
		t.BackgroundTransparency = 1
		t.Text = "Infinite Jump Hold/Manual — BloodHounds"
		t.TextColor3 = C.textDim
		t.TextSize = 10
		t.Font = Enum.Font.Gotham
		t.TextXAlignment = Enum.TextXAlignment.Left
		t.Parent = info
	end
	-- also on Player for easy test
	if pagePlayer then
		section(pagePlayer, "* — INFINITE JUMP", 40)
		-- TP BEST removed
	end
end)

-- Mobile external button
task.defer(function()
	local g = Instance.new("ScreenGui")
	g.Name = "VisTpBestBtn"
	g.Enabled = false -- removed TP BEST
	g.ResetOnSpawn = false
	g.IgnoreGuiInset = true
	g.DisplayOrder = 1003
	g.Parent = PlayerGui
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 110, 0, 36)
	b.Position = UDim2.new(0.5, -55, 0, 12)
	b.BackgroundColor3 = Color3.fromRGB(20, 40, 30)
	b.Text = "INF JUMP"
	b.TextColor3 = Color3.fromRGB(120, 255, 160)
	b.Font = Enum.Font.GothamBlack
	b.TextSize = 13
	b.Parent = g
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
	local s = Instance.new("UIStroke", b)
	s.Color = Color3.fromRGB(80, 220, 120)
	s.Thickness = 1.5
	b.MouseButton1Click:Connect(tpToBestChilli)
	-- drag
	do
		local dragging, dragStart, startPos, moved
		b.InputBegan:Connect(function(input)
			if St.guiLock then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				moved = false
				dragStart = input.Position
				startPos = b.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then dragging = false end
				end)
			end
		end)
		UIS.InputChanged:Connect(function(input)
			if not dragging or St.guiLock then return end
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				local d = input.Position - dragStart
				if math.abs(d.X) > 4 or math.abs(d.Y) > 4 then moved = true end
				if moved then
					b.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
				end
			end
		end)
	end
end)

-- TP Best keybind removed



----------------------------------------------------------------
-- OVERHEAD: real speed + discord (from VisHub)
----------------------------------------------------------------
local overheadGui, overheadSpeedLabel
function setupOverheadInfo(char)
	char = char or LP.Character
	if not char then return end
	local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
	if not head then
		-- fallback HRP
		head = char:FindFirstChild("HumanoidRootPart")
		if not head then return end
	end
	pcall(function()
		local old = head:FindFirstChild("VisOverheadInfo")
		if old then old:Destroy() end
	end)
	if overheadGui then pcall(function() overheadGui:Destroy() end) end
	overheadGui = Instance.new("BillboardGui")
	overheadGui.Name = "VisOverheadInfo"
	overheadGui.Size = UDim2.new(0, 300, 0, 96)
	overheadGui.StudsOffset = Vector3.new(0, 2.8, 0)
	overheadGui.AlwaysOnTop = true
	overheadGui.MaxDistance = 200
	overheadGui.LightInfluence = 0
	overheadGui.Adornee = head
	overheadGui.Parent = head
	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1, 0, 0, 22)
	titleLbl.Position = UDim2.new(0, 0, 0, 0)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = "Free Sell Là Tuất Ngu Lồn"
	titleLbl.TextColor3 = Color3.fromRGB(255, 220, 100)
	titleLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	titleLbl.TextStrokeTransparency = 0
	titleLbl.Font = Enum.Font.Bangers
	titleLbl.TextSize = 17
	titleLbl.Parent = overheadGui
	local discordLbl = Instance.new("TextLabel")
	discordLbl.Size = UDim2.new(1, 0, 0, 20)
	discordLbl.Position = UDim2.new(0, 0, 0, 22)
	discordLbl.BackgroundTransparency = 1
	discordLbl.Text = "discord.gg/mSYQk9BEQq"
	discordLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	discordLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	discordLbl.TextStrokeTransparency = 0
	discordLbl.Font = Enum.Font.Bangers
	discordLbl.TextSize = 16
	discordLbl.Parent = overheadGui
	overheadSpeedLabel = Instance.new("TextLabel")
	overheadSpeedLabel.Size = UDim2.new(1, 0, 0, 22)
	overheadSpeedLabel.Position = UDim2.new(0, 0, 0, 44)
	overheadSpeedLabel.BackgroundTransparency = 1
	overheadSpeedLabel.Text = "Tốc độ: 0.0"
	overheadSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	overheadSpeedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	overheadSpeedLabel.TextStrokeTransparency = 0
	overheadSpeedLabel.Font = Enum.Font.Bangers
	overheadSpeedLabel.TextSize = 18
	overheadSpeedLabel.Parent = overheadGui
end
if not _G._VisOverheadLoop then
	_G._VisOverheadLoop = true
	LP.CharacterAdded:Connect(function(ch)
		task.wait(0.5)
		setupOverheadInfo(ch)
	end)
	if LP.Character then task.defer(function() setupOverheadInfo(LP.Character) end) end
	RS.RenderStepped:Connect(function()
		if not overheadSpeedLabel then return end
		local char = LP.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local v = root.AssemblyLinearVelocity
		local actual = Vector3.new(v.X, 0, v.Z).Magnitude
		local target = 0
		pcall(function() target = getActiveMoveSpeed() end)
		if St.speedOn and target > 0 then
			overheadSpeedLabel.Text = string.format("Tốc độ: %.0f (%.0f)", target, actual)
		else
			overheadSpeedLabel.Text = string.format("Tốc độ: %.1f", actual)
		end
	end)
end


print("[VisHub] TP TO BEST (Chilli) ready | key B | nút TP BEST")



-- ============================================================
-- [STABILIZED] Dynamic Auto Steal reload disabled; internal functions remain available.
-- Remote control panel intentionally removed.
-- It contained a hard-coded API key and commands capable of kicking, freezing,
-- or deliberately lagging the client.
