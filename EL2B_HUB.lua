-- deobfed by solar
-- ts leak is from rift hub babyessss
-- discord.gg/rifthub

local Players           = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local Stats             = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui        = game:GetService("StarterGui")
local GuiService        = game:GetService("GuiService")
local CoreGui           = game:GetService("CoreGui")
local Workspace         = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

local ActiveConnections = {}
local thisScriptStopped = false

-- ==========================================
-- PING LAGGER (déclenché au début du Flash TP)
-- ==========================================
_G.LaggerOnFlash = _G.LaggerOnFlash or false
_G.LaggerPower   = _G.LaggerPower   or 50   -- 0-100

local laggerConn = nil

local function startFlashLagger()
    if not _G.LaggerOnFlash then return end
    local strength = math.clamp(_G.LaggerPower / 40, 0.3, 3.0)
    pcall(function()
        settings().Network.IncomingReplicationLag = strength
    end)
    if laggerConn then laggerConn:Disconnect() laggerConn = nil end
    laggerConn = task.delay(2.5, function()
        pcall(function() settings().Network.IncomingReplicationLag = 0 end)
        laggerConn = nil
    end)
end

local function stopFlashLagger()
    if laggerConn then
        pcall(function() laggerConn:Disconnect() end)
        laggerConn = nil
    end
    pcall(function() settings().Network.IncomingReplicationLag = 0 end)
end

local MultiZones = {
	{Shape = 'Line', Center = Vector3.new(-345.35, -6.55, 39.19), Size = 5, Rotation = 0},
	{Shape = 'Line', Center = Vector3.new(-350.53, -6.55, 38.67), Size = 20, Rotation = 0},
	{Shape = 'Line', Center = Vector3.new(-364.01, -6.55, 38.94), Size = 20, Rotation = 0},
	{Shape = 'Line', Center = Vector3.new(-337.34, -6.55, 39.18), Size = 20, Rotation = 0},
	{Shape = 'Square', Center = Vector3.new(-365.29, -6.95, -10.40), Size = 20, Rotation = 0},
	{Shape = 'Square', Center = Vector3.new(-354.68, -6.95, 6.22), Size = 20, Rotation = 0},
	{Shape = 'Square', Center = Vector3.new(-343.15, -6.53, -13.20), Size = 20, Rotation = 0},
	{Shape = 'Square', Center = Vector3.new(-344.93, -6.95, 25.73), Size = 20, Rotation = 0},
	{Shape = 'Square', Center = Vector3.new(-343.76, -6.95, -10.27), Size = 20, Rotation = 0},
	{Shape = 'Square', Center = Vector3.new(-354.42, -6.95, 6.51), Size = 20, Rotation = 0},
	{Shape = 'Square', Center = Vector3.new(-340.48, -5.32, 28.10), Size = 20, Rotation = 0},
	{Shape = 'Square', Center = Vector3.new(-361.10, -6.95, 29.42), Size = 20, Rotation = 0},
	{Shape = 'Line', Center = Vector3.new(-354.83, 27.19, 31.22), Size = 20, Rotation = 0},
}

-- ==========================================
-- AUTO BALLOON LOGIC (HUGO VERSION)
-- ==========================================
local BalloonState = {
    Active = {},
    Auto = false
}

local function hasBrainrot(targetPlayer)
	if not targetPlayer.Character then return false end
	local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root then return false end
	local playerNames = {}
	for _, p in pairs(Players:GetPlayers()) do
		playerNames[p.Name] = true
	end
	for _, v in pairs(Workspace:GetDescendants()) do
		if v:IsA("Model") and not playerNames[v.Name] and not v:IsDescendantOf(targetPlayer.Character) then
			local rp = v:FindFirstChild("RootPart") or v:FindFirstChild("FakeRootPart")
			if rp then
				if (rp.Position - root.Position).Magnitude < 8 then
					return true
				end
			end
		end
	end
	return false
end

local function isInAnyZone(position)
	for _, zone in ipairs(MultiZones) do
		local half = zone.Size / 2
		local dx = math.abs(position.X - zone.Center.X)
		local dz = math.abs(position.Z - zone.Center.Z)
		if zone.Shape == 'Line' then
			if dx <= half and dz <= 1.5 then return true end
		elseif zone.Shape == 'Square' then
			if dx <= half and dz <= half then return true end
		end
	end
	return false
end

local function findAdminPanel()
	return PlayerGui:FindFirstChild("AdminPanel")
end

local function findPlayerButton(targetPlayer)
	local adminPanel = findAdminPanel()
	if not adminPanel then return nil end
	for _, desc in pairs(adminPanel:GetDescendants()) do
		if desc:IsA("TextButton") or desc:IsA("ImageButton") then
			local t = ""
			if desc:IsA("TextButton") then
				t = desc.Text
			else
				local lbl = desc:FindFirstChildWhichIsA("TextLabel", true)
				if lbl then t = lbl.Text end
			end
			if t == targetPlayer.DisplayName or string.find(t, targetPlayer.DisplayName) or t == targetPlayer.Name or string.find(t, targetPlayer.Name) then
				return desc
			end
		end
	end
	return nil
end

local function getCommandButtons()
	local btns = {}
	local adminPanel = findAdminPanel()
	if not adminPanel then return btns end
	for _, desc in pairs(adminPanel:GetDescendants()) do
		if desc:IsA("TextButton") or desc:IsA("ImageButton") then
			local t = ""
			if desc:IsA("TextButton") then
				t = desc.Text
			else
				local lbl = desc:FindFirstChildWhichIsA("TextLabel", true)
				if lbl then t = lbl.Text end
			end
			if t and t ~= "" and (t:match("^:") or t:match("^;")) then
				table.insert(btns, {button = desc, name = t})
			end
		end
	end
	return btns
end

local function clickButton(button)
    -- Interface locale uniquement : aucun signal d’interface externe n’est forcé.
    return false
end
local function isExactCommand(buttonName, expectedCmdName)
	local bName = string.lower(string.match(buttonName, "^%s*(.-)%s*$") or buttonName)
	local cmdName = string.lower(expectedCmdName)
	if bName == cmdName or bName == ":"..cmdName or bName == ";"..cmdName then return true end
	if string.match(bName, "^[:;]?"..cmdName.."$") or string.match(bName, "^[:;]?"..cmdName.."%s") then return true end
	return false
end

local function triggerBalloonOnTarget(targetPlayer)
    warn('[EL2B HUB] Action Balloon désactivée : aucune commande distante n’est exécutée.')
    return false
end
-- AUTO LASER CAPE LOGIC
-- ==========================================
local LaserState = {
    Active = {},
}

local function triggerLaserOnTarget(targetPlayer)
    warn('[EL2B HUB] Action Laser désactivée : aucune commande distante n’est exécutée.')
    return false
end
-- ==========================================
-- QUICK PICKUP (from Gamma Hub)
-- ==========================================
local QuickPickup = {
    set = function(enabled)
        if enabled then
            warn('[EL2B HUB] Quick Pickup désactivé pour éviter les actions non autorisées.')
        end
        return false
    end,
    stop = function() return true end,
}
-- ==========================================
-- (Rest of the Kay Hub code remains unchanged)
-- ==========================================

local TinyState = { Enabled = false }
local function startAutoResetTiny()
    warn('[EL2B HUB] Auto-reset Tiny désactivé.')
    return false
end
local function stopAutoResetTiny()
    TinyState.Enabled = false
    return true
end
local JailState = { Enabled = false }
local function startAutoResetJail()
    warn('[EL2B HUB] Auto-reset Jail désactivé.')
    return false
end
local function stopAutoResetJail()
    JailState.Enabled = false
    return true
end
local SETTINGS_FILE = "kay_pvp_settings.json"
local UI_LAYOUT_FILE = "kay_pvp_ui_placement.json"

local function loadSettings()
    local ok, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(SETTINGS_FILE))
    end)
    if ok and type(data) == "table" then return data end
    return {}
end

-- Table centrale : toutes les valeurs de toggles passent par ici.
local settingsGetters = {}
-- ============================================================
-- AIMBOT désactivé dans l’édition sûre : aucun ciblage automatique et aucun RemoteEvent.
local function fireRemote(name, ...)
    return false
end
local function resolveUseItemRemote()
    return nil
end
local function initRemotes()
    return false
end

local function saveSettings()
    pcall(function()
        local out = {}
        for key, getter in pairs(settingsGetters) do
            out[key] = getter()
        end
        writefile(SETTINGS_FILE, game:GetService("HttpService"):JSONEncode(out))
    end)
end

-- ============================================================
-- SAUVEGARDE POSITION / TAILLE DES PANELS UI
-- ============================================================
local function loadUILayout()
    local ok, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(UI_LAYOUT_FILE))
    end)
    if ok and type(data) == "table" then return data end
    return {}
end

local uiLayout = loadUILayout()
local saveUILayoutQueued = false

local function saveUILayout()
    if saveUILayoutQueued then return end
    saveUILayoutQueued = true
    task.delay(0.5, function()
        saveUILayoutQueued = false
        pcall(function()
            writefile(UI_LAYOUT_FILE, game:GetService("HttpService"):JSONEncode(uiLayout))
        end)
    end)
end

local function registerPanelLayout(panel, name, defaultMinW, defaultMinH)
    local saved = uiLayout[name]
    if saved then
        pcall(function()
            panel.Position = UDim2.new(0, saved.px, 0, saved.py)
            panel.Size     = UDim2.new(0, saved.pw, 0, saved.ph)
        end)
    end
    local function persist()
        uiLayout[name] = {
            px = panel.Position.X.Offset,
            py = panel.Position.Y.Offset,
            pw = panel.Size.X.Offset,
            ph = panel.Size.Y.Offset,
        }
        saveUILayout()
    end
    panel:GetPropertyChangedSignal("Position"):Connect(persist)
    panel:GetPropertyChangedSignal("Size"):Connect(persist)
end

local savedSettings = loadSettings()

if savedSettings.AutoResetOnBalloon ~= nil then _G.AutoResetOnBalloon = savedSettings.AutoResetOnBalloon
elseif _G.AutoResetOnBalloon == nil then _G.AutoResetOnBalloon = true end

if savedSettings.AutoFlashTP ~= nil then _G.AutoFlashTP = savedSettings.AutoFlashTP
elseif _G.AutoFlashTP == nil then _G.AutoFlashTP = false end


if savedSettings.AutoGiant ~= nil then _G.AutoGiant = savedSettings.AutoGiant
elseif _G.AutoGiant == nil then _G.AutoGiant = false end

if savedSettings.RagdollBypass ~= nil then _G.RagdollBypass = savedSettings.RagdollBypass
elseif _G.RagdollBypass == nil then _G.RagdollBypass = true end

if savedSettings.AutoBlock ~= nil then _G.AutoBlock = savedSettings.AutoBlock
elseif _G.AutoBlock == nil then _G.AutoBlock = false end

if savedSettings.BlockMode ~= nil then _G.BlockMode = savedSettings.BlockMode
elseif _G.BlockMode == nil then _G.BlockMode = "normal" end

if savedSettings.LaggerOnFlash ~= nil then _G.LaggerOnFlash = savedSettings.LaggerOnFlash
elseif _G.LaggerOnFlash == nil then _G.LaggerOnFlash = false end

if savedSettings.LaggerPower ~= nil then _G.LaggerPower = savedSettings.LaggerPower
elseif _G.LaggerPower == nil then _G.LaggerPower = 50 end

if savedSettings.AutoBalloon ~= nil then _G.AutoBalloon = savedSettings.AutoBalloon
elseif _G.AutoBalloon == nil then _G.AutoBalloon = false end

if savedSettings.AutoLaser ~= nil then _G.AutoLaser = savedSettings.AutoLaser
elseif _G.AutoLaser == nil then _G.AutoLaser = false end

if savedSettings.Aimbot ~= nil then _G.AimbotEnabled = savedSettings.Aimbot
elseif _G.AimbotEnabled == nil then _G.AimbotEnabled = false end

if savedSettings.AutoSelectBest ~= nil then _G.AutoSelectBest = savedSettings.AutoSelectBest
elseif _G.AutoSelectBest == nil then _G.AutoSelectBest = false end

if savedSettings.AutoResetTiny ~= nil then _G.AutoResetTiny = savedSettings.AutoResetTiny
elseif _G.AutoResetTiny == nil then _G.AutoResetTiny = false end
TinyState.Enabled = _G.AutoResetTiny
if TinyState.Enabled then startAutoResetTiny() end

if savedSettings.AutoResetJail ~= nil then _G.AutoResetJail = savedSettings.AutoResetJail
elseif _G.AutoResetJail == nil then _G.AutoResetJail = false end
JailState.Enabled = _G.AutoResetJail
if JailState.Enabled then startAutoResetJail() end

if savedSettings.APESP ~= nil then _G.APESP = savedSettings.APESP
elseif _G.APESP == nil then _G.APESP = false end

if savedSettings.EspTimer ~= nil then _G.EspTimer = savedSettings.EspTimer
elseif _G.EspTimer == nil then _G.EspTimer = false end

if savedSettings.AutoFlashLowTimer ~= nil then _G.AutoFlashLowTimer = savedSettings.AutoFlashLowTimer
elseif _G.AutoFlashLowTimer == nil then _G.AutoFlashLowTimer = false end

if savedSettings.QuickAP ~= nil then _G.QuickAP = savedSettings.QuickAP
elseif _G.QuickAP == nil then _G.QuickAP = false end

if savedSettings.AutoReturnBase ~= nil then _G.AutoReturnBase = savedSettings.AutoReturnBase
elseif _G.AutoReturnBase == nil then _G.AutoReturnBase = false end

if savedSettings.BrainrotHighlight ~= nil then _G.BrainrotHighlight = savedSettings.BrainrotHighlight
elseif _G.BrainrotHighlight == nil then _G.BrainrotHighlight = true end

if savedSettings.TpPathVisual ~= nil then _G.TpPathVisual = savedSettings.TpPathVisual
elseif _G.TpPathVisual == nil then _G.TpPathVisual = true end

if savedSettings.BackpackESP ~= nil then _G.BackpackESP = savedSettings.BackpackESP
elseif _G.BackpackESP == nil then _G.BackpackESP = false end

if savedSettings.ShowAPESP ~= nil then _G.ShowAPESP = savedSettings.ShowAPESP
elseif _G.ShowAPESP == nil then _G.ShowAPESP = true end

if savedSettings.ShowGiantPotion ~= nil then _G.ShowGiantPotion = savedSettings.ShowGiantPotion
elseif _G.ShowGiantPotion == nil then _G.ShowGiantPotion = true end

if savedSettings.ShowFlashTeleport ~= nil then _G.ShowFlashTeleport = savedSettings.ShowFlashTeleport
elseif _G.ShowFlashTeleport == nil then _G.ShowFlashTeleport = true end

if savedSettings.ShowFlyingCarpet ~= nil then _G.ShowFlyingCarpet = savedSettings.ShowFlyingCarpet
elseif _G.ShowFlyingCarpet == nil then _G.ShowFlyingCarpet = true end

-- Quick Pickup
if savedSettings.QuickPickup ~= nil then _G.QuickPickup = savedSettings.QuickPickup
elseif _G.QuickPickup == nil then _G.QuickPickup = false end
QuickPickup.set(_G.QuickPickup)

local WalkItemOptions = { "Flying Carpet", "Cupid's Wings", "Witch's Broom", "Waverider", "Santa's Sleigh" }
if savedSettings.WalkItem ~= nil and table.find(WalkItemOptions, savedSettings.WalkItem) then
    _G.WalkItem = savedSettings.WalkItem
elseif _G.WalkItem == nil then
    _G.WalkItem = "Flying Carpet"
end

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid  = Character:WaitForChild("Humanoid")
local Root      = Character:WaitForChild("HumanoidRootPart")
local Camera    = Workspace.CurrentCamera

local autoStealEnabled  = false
local stealDelay        = 1.30
local isStealing        = false
local currentMovement   = nil
local selectedPrompt    = nil
local selectedSlotNumber= nil

local player = LocalPlayer
local maxVelocity  = 40
local clampVelocity= 25
local maxClamp     = 15

-- ==========================================
-- ANTI RAGDOLL (logique propre, toggle dans Misc)
-- ==========================================
local AntiRagdollConns = {}
local antiRagdollEnabled = false

local function removeRagdollConstraints(char)
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("BallSocketConstraint") or d:IsA("HingeConstraint")
            or d:IsA("NoCollisionConstraint")
            or (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
            pcall(function() d:Destroy() end)
        end
    end
end

local function connectAntiRagdollToChar(c)
    local humanoid = c:WaitForChild("Humanoid")
    local root     = c:WaitForChild("HumanoidRootPart")
    local animator = humanoid:WaitForChild("Animator")
    local lastVelocity = Vector3.new(0,0,0)
    local lastClean    = 0
    local isRag = false

    local function IsRagdollState()
        local state = humanoid:GetState()
        return state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.GettingUp
    end

    local function CleanRagdollEffects()
        local now = tick()
        if now - lastClean < 0.15 then return end
        lastClean = now
        for _, obj in pairs(c:GetDescendants()) do
            if obj:IsA("BallSocketConstraint") or obj:IsA("NoCollisionConstraint") or obj:IsA("HingeConstraint")
                or (obj:IsA("Attachment") and (obj.Name == "A" or obj.Name == "B")) then
                pcall(function() obj:Destroy() end)
            elseif obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
                pcall(function() obj:Destroy() end)
            elseif obj:IsA("Motor6D") then
                obj.Enabled = true
            end
        end
        removeRagdollConstraints(c)
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
            local animName = track.Animation and track.Animation.Name:lower() or ""
            if animName:find("rag") or animName:find("fall") or animName:find("hurt") or animName:find("down") then
                pcall(function() track:Stop(0) end)
            end
        end
    end

    local function ReEnableControls()
        pcall(function()
            require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls():Enable()
        end)
    end

    local function AdvancedReset()
        root.Anchored = false
        root.AssemblyLinearVelocity  = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        for _, obj in ipairs(c:GetDescendants()) do
            if obj:IsA("Motor6D") then obj.Enabled = true end
        end
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,     false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,     false)
        humanoid.PlatformStand = false
        humanoid.Sit           = false
        if humanoid.Health > 0 then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
        workspace.CurrentCamera.CameraSubject = humanoid
    end

    table.insert(AntiRagdollConns, humanoid.StateChanged:Connect(function(_, newState)
        if not antiRagdollEnabled then return end
        if IsRagdollState() then
            isRag = true
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            CleanRagdollEffects()
            workspace.CurrentCamera.CameraSubject = humanoid
            ReEnableControls()
        else
            isRag = false
        end
    end))

    table.insert(AntiRagdollConns, humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
        if not antiRagdollEnabled then return end
        if humanoid.PlatformStand then
            task.defer(function()
                if not antiRagdollEnabled then return end
                AdvancedReset()
                removeRagdollConstraints(c)
            end)
        end
    end))

    table.insert(AntiRagdollConns, RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local endTime = LocalPlayer:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then isRag = true end
        if isRag then
            CleanRagdollEffects()
            local vel = root.AssemblyLinearVelocity
            if (vel - lastVelocity).Magnitude > 40 and vel.Magnitude > 25 then
                root.AssemblyLinearVelocity = vel.Unit * math.min(vel.Magnitude, 15)
            end
            lastVelocity = vel
            if humanoid.PlatformStand then AdvancedReset() end
        end
    end))

    table.insert(AntiRagdollConns, c.DescendantAdded:Connect(function(obj)
        if not antiRagdollEnabled then return end
        if isRag then CleanRagdollEffects() end
        if obj:IsA("BallSocketConstraint") or obj:IsA("HingeConstraint")
            or obj:IsA("NoCollisionConstraint")
            or (obj:IsA("Attachment") and obj.Name:find("RagdollAttachment")) then
            task.defer(function()
                if not antiRagdollEnabled then return end
                if obj.Parent then pcall(function() obj:Destroy() end) end
            end)
        end
    end))

    ReEnableControls()
    CleanRagdollEffects()
end

local function startAntiRagdoll()
    for _, conn in pairs(AntiRagdollConns) do pcall(function() conn:Disconnect() end) end
    AntiRagdollConns = {}
    local c = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    connectAntiRagdollToChar(c)
end

local function stopAntiRagdoll()
    for _, conn in pairs(AntiRagdollConns) do pcall(function() conn:Disconnect() end) end
    AntiRagdollConns = {}
    pcall(function()
        local c   = LocalPlayer.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,     true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics,     true)
        end
    end)
end

table.insert(ActiveConnections, LocalPlayer.CharacterAdded:Connect(function(newChar)
    if not antiRagdollEnabled then return end
    for _, conn in pairs(AntiRagdollConns) do pcall(function() conn:Disconnect() end) end
    AntiRagdollConns = {}
    task.spawn(function() connectAntiRagdollToChar(newChar) end)
end))

-- Init depuis les settings sauvegardés
if savedSettings.AntiRagdoll ~= nil then antiRagdollEnabled = savedSettings.AntiRagdoll
else antiRagdollEnabled = false end
if antiRagdollEnabled then task.spawn(startAntiRagdoll) end


local function FastConfirm()
    return false
end
local function getNearestPlayer()
    local hrp = Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local closest, dist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local d = (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if d < dist then dist = d closest = plr end
        end
    end
    return closest
end

local blockDelay = 0.05

local function PromptClick()
    return false
end
local function blockPlayer(plr)
    if not plr or plr == LocalPlayer then return end
    pcall(function()
        StarterGui:SetCore("PromptBlockPlayer", plr)
        PromptClick()
    end)
end

local function blockAllPlayers()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            blockPlayer(p)
            task.wait(1)
        end
    end
end

local function waitForStealPrompt()
    for _, v in ipairs(CoreGui:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text and string.find(v.Text, "Steal") then return true end
    end
    local found = false
    local connection
    connection = CoreGui.DescendantAdded:Connect(function(v)
        if v:IsA("TextLabel") and v.Text and string.find(v.Text, "Steal") then found = true end
    end)
    table.insert(ActiveConnections, connection)
    while not found and not thisScriptStopped do task.wait(0.05) end
    if connection then pcall(function() connection:Disconnect() end) end
    return true
end

local charAddedConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
    if currentMovement then pcall(function() currentMovement:Disconnect() end) currentMovement = nil end
    Character = newChar
    Humanoid  = newChar:WaitForChild("Humanoid")
    Root      = newChar:WaitForChild("HumanoidRootPart")
    Camera    = Workspace.CurrentCamera
    autoStealEnabled = false isStealing = false
    task.wait()
    if Root then
        local oldVelocity = Root:FindFirstChild("LinearVelocity")
        if oldVelocity then oldVelocity:Destroy() end
        local oldAttachment = Root:FindFirstChild("Attachment")
        if oldAttachment then oldAttachment:Destroy() end
    end
    
    if _G.AutoFlashTP and _G.AutoResetOnBalloon and selectedPrompt and selectedSlotNumber then
        task.delay(0.5, function()
            if not thisScriptStopped and selectedPrompt and selectedSlotNumber then
                startTripToPetSlot(selectedPrompt, selectedSlotNumber)
            end
        end)
    end
end)
table.insert(ActiveConnections, charAddedConn)

local SlotsConfig = {
    [1]  = { Positions = { Vector3.new(-345.4766,-6.0291,1.5014) }, CamOffset = Vector3.new(-354.1492,4.0350,9.3823)-Vector3.new(-345.4766,-6.0291,1.5014), CamAngles = {-0.827500,-0.640100,-0.576243} },
    [2]  = { Positions = { Vector3.new(-349.9259,-6.2791,-1.5767) }, CamOffset = Vector3.new(-363.2081,2.9403,3.3074)-Vector3.new(-349.9259,-6.2791,-1.5767), CamAngles = {-1.007271,-0.967909,-0.916433} },
    [3]  = { Positions = { Vector3.new(-349.9259,-6.2791,-1.5758) }, CamOffset = Vector3.new(-367.7556,4.3232,3.4983)-Vector3.new(-349.9259,-6.2791,-1.5758), CamAngles = {-1.062718,-1.041500,-0.997864} },
    [4]  = { Positions = { Vector3.new(-343.4199,-5.9197,10.5505) }, CamOffset = Vector3.new(-359.0885,4.0544,21.0001)-Vector3.new(-343.4199,-5.9197,10.5505), CamAngles = {-0.681953,-0.861073,-0.551998} },
    [5]  = { Positions = { Vector3.new(-343.7608,-6.3272,-9.7994) }, CamOffset = Vector3.new(-363.9226,-0.3924,-9.1459)-Vector3.new(-343.7608,-6.3272,-9.7994), CamAngles = {-1.424811,-1.351549,-1.421283} },
    [6] = { Positions = { Vector3.new(-353.820709,-7.3017997,56.7122993), Vector3.new(-300.422119,-7.30179977,34.2573051) }, CamOffset = Vector3.new(-298.584991,3.38974237,49.2246361)-Vector3.new(-300.422119,-7.30179977,34.2573051), CamAngles = {0,0.06,0}, FixedCFrame = CFrame.new(-301.68, -10.02, 39.60, 1.000, -0.020, -0.020, 0.000, 0.714, -0.700, 0.028, 0.700, 0.714) },
    [7]  = { Positions = { Vector3.new(-344.4383,-6.4281,41.8672) }, CamOffset = Vector3.new(-362.8094,-3.2299,51.1552)-Vector3.new(-344.4383,-6.4281,41.8672), CamAngles = {-0.181885,-1.095968,-0.162135} },
    [8]  = { Positions = { Vector3.new(-348.5228,-6.4281,48.1022) }, CamOffset = Vector3.new(-369.4075,-0.1123,63.3763)-Vector3.new(-348.5228,-6.4281,48.1022), CamAngles = {-0.306020,-0.916511,-0.245634} },
    [9]  = { Positions = { Vector3.new(-339.6349,-6.4281,60.4164) }, CamOffset = Vector3.new(-349.9293,-1.6218,84.4119)-Vector3.new(-339.6349,-6.4281,60.4164), CamAngles = {-0.137335,-0.401849,-0.054002} },
    [10] = { Positions = { Vector3.new(-355.3322,-6.4281,25.3526) }, CamOffset = Vector3.new(-377.7117,8.9106,25.7208)-Vector3.new(-355.3322,-6.4281,25.3526), CamAngles = {-1.544218,-1.016502,-1.539540} },
    [11] = { Positions = { Vector3.new(-354.9932,-6.4281,-47.3879), Vector3.new(-331.5262,-6.4281,-47.3607) }, CamOffset = Vector3.new(-333.2372,-9.9613,-64.2099)-Vector3.new(-331.5262,-6.4281,-47.3607), CamAngles = {2.851853,-0.097011,3.112724} },
    [12] = { Positions = { Vector3.new(-354.9584,-6.4208,-42.6520), Vector3.new(-338.7290,-6.4281,-43.4713) }, CamOffset = Vector3.new(-346.9807,-9.9578,-60.5865)-Vector3.new(-338.7290,-6.4281,-43.4713), CamAngles = {2.856299,-0.433315,3.019061} },
    [13] = { Positions = { Vector3.new(-354.8862,-6.2793,-37.9787), Vector3.new(-334.5183,-6.4281,-41.6819) }, CamOffset = Vector3.new(-343.9747,-9.9590,-57.3332)-Vector3.new(-334.5183,-6.4281,-41.6819), CamAngles = {2.831168,-0.522070,2.982964} },
    [14] = { Positions = { Vector3.new(-351.8463,-6.5022,-37.0529), Vector3.new(-319.8298,-6.4281,-45.1476) }, CamOffset = Vector3.new(-325.1408,-9.9618,-60.9837)-Vector3.new(-319.8298,-6.4281,-45.1476), CamAngles = {2.834406,-0.309406,3.045298} },
    [15] = { Positions = { Vector3.new(-351.0894,-6.2833,-32.7751), Vector3.new(-317.9170,-6.4281,-41.9999) }, CamOffset = Vector3.new(-327.9996,-9.9581,-57.8876)-Vector3.new(-317.9170,-6.4281,-41.9999), CamAngles = {2.835549,-0.544183,2.979445} },
    [16] = { Positions = { Vector3.new(-338.2857,-6.4281,57.2060) }, CamOffset = Vector3.new(-341.5551,-9.9642,72.3530)-Vector3.new(-338.2857,-6.4281,57.2060), CamAngles = {0.320392,-0.202067,0.066497} },
    [17] = { Positions = { Vector3.new(-337.9285,-6.4281,55.1757) }, CamOffset = Vector3.new(-344.4950,-9.9637,69.4787)-Vector3.new(-337.9285,-6.4281,55.1757), CamAngles = {0.337895,-0.408747,0.138758} },
    [18] = { Positions = { Vector3.new(-332.1088,-6.4281,53.1675) }, CamOffset = Vector3.new(-338.8290,-9.9674,65.6692)-Vector3.new(-332.1088,-6.4281,53.1675), CamAngles = {0.382481,-0.462609,0.177644} },
    [19] = { Positions = { Vector3.new(-347.9923,-6.2933,-34.0232), Vector3.new(-328.5790,-6.4281,-35.0857) }, CamOffset = Vector3.new(-328.6130,-10.0174,-40.4923)-Vector3.new(-328.5790,-6.4281,-35.0857), CamAngles = {2.387391,-0.004579,3.137291} },
    [20] = { Positions = { Vector3.new(-355.0801,-6.4404,-33.2302), Vector3.new(-321.5783,-6.4281,-33.5778) }, CamOffset = Vector3.new(-321.6123,-10.0174,-38.9844)-Vector3.new(-321.5783,-6.4281,-33.5778), CamAngles = {2.387391,-0.004579,3.137291} },
    [21] = { Positions = { Vector3.new(-351.5396,-7.5033,-41.797), Vector3.new(-314.088,-7.5033,-32.1806) }, CamOffset = Vector3.new(-314.1147,-10.0174,-36.4214)-Vector3.new(-314.088,-7.5033,-32.1806), CamAngles = {2.387391,-0.004579,3.137291}, NeedJump = true },
    [22] = { Positions = { Vector3.new(-351.5396,-7.5033,-41.797), Vector3.new(-306.8919,-7.5033,-33.9124) }, CamOffset = Vector3.new(-306.923,-10.008,-38.86)-Vector3.new(-306.8919,-7.5033,-33.9124), CamAngles = {2.4648,-0.004898,3.137657}, NeedJump = true },
    [23] = { Positions = { Vector3.new(-351.5396,-7.5033,-41.797), Vector3.new(-300.2759,-7.5033,-32.7047) }, CamOffset = Vector3.new(-300.4669,-10.016,-37.044)-Vector3.new(-300.2759,-7.5033,-32.7047), CamAngles = {2.399014,-0.032413,3.111857}, NeedJump = true },
    [24] = { Positions = { Vector3.new(-348.2407,-7.5033,74.3719), Vector3.new(-330.0484,-7.5033,48.183) }, CamOffset = Vector3.new(-330.1124,-10.0063,53.2779)-Vector3.new(-330.0484,-7.5033,48.183), CamAngles = {0.662308,-0.00991,0.007727}, NeedJump = true },
    [25] = { Positions = { Vector3.new(-348.2407,-7.5033,74.3719), Vector3.new(-325.4576,-7.5033,46.8182) }, CamOffset = Vector3.new(-326.0541,-10.0104,51.5397)-Vector3.new(-325.4576,-7.5033,46.8182), CamAngles = {0.700033,-0.09632,0.080833}, NeedJump = true },
    [26] = { Positions = { Vector3.new(-348.2407,-7.5033,74.3719), Vector3.new(-324.6721,-7.5033,47.2033) }, CamOffset = Vector3.new(-326.6859,-10.0057,51.9385)-Vector3.new(-324.6721,-7.5033,47.2033), CamAngles = {0.698024,-0.314979,0.254268}, NeedJump = true },
    [27] = { Positions = { Vector3.new(-348.2407,-7.5033,74.3719), Vector3.new(-320.4196,-7.5033,44.1) }, CamOffset = Vector3.new(-322.9213,-10.0122,49.5157)-Vector3.new(-320.4196,-7.5033,44.1), CamAngles = {0.876985,-0.422603,0.397417} },
}

local function findTool(name)
    if not Character then return nil end
    for _, tool in ipairs(Character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find(name:lower()) then return tool end
    end
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find(name:lower()) then return tool end
    end
    return nil
end

local function isMyPlot(plot)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yourBase = sign:FindFirstChild("YourBase")
        if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled then return true end
    end
    return false
end

local function isValidStealPrompt(prompt)
    if not prompt or not prompt.Parent or not prompt.Enabled then return false end
    local state      = prompt:GetAttribute("State")
    local actionText = prompt.ActionText
    if state == "Steal" or state == "Grab" or actionText == "Steal" or actionText == "Grab" then return true end
    return false
end

local function firePromptConnections(prompt, signalName)
    -- Ne déclenche jamais les connexions internes du jeu.
    return false
end
-- ==========================================
-- AUTO RETURN TO BASE
-- ==========================================
local BASE_TARGET    = Vector3.new(-350.8919, -6.6011, 108.6947)
local BASE_SPEED     = 25
local BASE_STOP_DIST = 3
local BASE_SLOW_DIST = 15
local returnMovement = nil

local function stopReturnToBase()
    if returnMovement then
        pcall(function() returnMovement:Disconnect() end)
        returnMovement = nil
    end
end

local function startReturnToBase()
    if not Root or not Humanoid then return end
    stopReturnToBase()

    local savedWalkSpeed = Humanoid.WalkSpeed
    local savedJumpPower = Humanoid.JumpPower
    Humanoid.WalkSpeed  = 0
    Humanoid.JumpPower  = 0
    Humanoid.AutoRotate = false

    local animator = Humanoid:FindFirstChildOfClass("Animator")
    local animConn
    if animator then
        animConn = animator.AnimationPlayed:Connect(function(track)
            pcall(function() track:Stop(0) end)
        end)
    end

    local carpet = findTool(_G.WalkItem or "Flying Carpet")
    if carpet then
        pcall(function() Humanoid:UnequipTools() end)
        task.wait(0.03)
        pcall(function() Humanoid:EquipTool(carpet) end)
    end

    if Root:FindFirstChild("ReturnVelocity") then Root:FindFirstChild("ReturnVelocity"):Destroy() end
    if Root:FindFirstChild("ReturnAttachment") then Root:FindFirstChild("ReturnAttachment"):Destroy() end

    local Attachment = Instance.new("Attachment")
    Attachment.Name   = "ReturnAttachment"
    Attachment.Parent = Root

    local Velocity = Instance.new("LinearVelocity")
    Velocity.Name            = "ReturnVelocity"
    Velocity.Attachment0     = Attachment
    Velocity.RelativeTo      = Enum.ActuatorRelativeTo.World
    Velocity.MaxForce        = math.huge
    Velocity.VectorVelocity  = Vector3.zero
    Velocity.Parent          = Root

    local floatStartTime = os.clock()
    local floatAmplitude = 4
    local floatSpeed     = 3

    local function restore()
        Humanoid.WalkSpeed  = savedWalkSpeed
        Humanoid.JumpPower  = savedJumpPower
        Humanoid.AutoRotate = true
        if animConn then pcall(function() animConn:Disconnect() end) end
        pcall(function() Velocity:Destroy() end)
        pcall(function() Attachment:Destroy() end)
    end

    -- Point intermédiaire uniquement pour les slots 1-10
    local WAYPOINT = Vector3.new(-348.2184, -6.6011, 7.1711)
    local useWaypoint = selectedSlotNumber and selectedSlotNumber >= 1 and selectedSlotNumber <= 10
    local waypointReached = not useWaypoint  -- si pas de waypoint, on considère direct

    returnMovement = RunService.Heartbeat:Connect(function()
        if thisScriptStopped or not Root or not Root.Parent or not Humanoid or Humanoid.Health <= 0 then
            restore(); stopReturnToBase(); return
        end

        local rootPos = Root.Position

        -- Phase 1 : aller au waypoint si nécessaire
        if not waypointReached then
            local wpDir = Vector3.new(WAYPOINT.X - rootPos.X, 0, WAYPOINT.Z - rootPos.Z)
            local wpDist = wpDir.Magnitude

            if wpDist <= BASE_STOP_DIST then
                waypointReached = true
            else
                local floatY  = math.sin((os.clock() - floatStartTime) * floatSpeed) * floatAmplitude
                local targetY = WAYPOINT.Y + floatAmplitude + floatY + 4
                local vertErr = targetY - rootPos.Y
                local vertVel = math.clamp(vertErr * 5, -15, 15)
                local speedMult = 1
                if wpDist < BASE_SLOW_DIST then speedMult = math.max(0.15, wpDist / BASE_SLOW_DIST) end
                local moveDir = wpDir.Unit
                Velocity.VectorVelocity = Vector3.new(
                    moveDir.X * BASE_SPEED * speedMult,
                    vertVel,
                    moveDir.Z * BASE_SPEED * speedMult
                )
                return
            end
        end

        -- Phase 2 : aller à la base
        local dir2D   = Vector3.new(BASE_TARGET.X - rootPos.X, 0, BASE_TARGET.Z - rootPos.Z)
        local dist    = dir2D.Magnitude

        if dist <= BASE_STOP_DIST then
            Velocity.VectorVelocity = Vector3.zero
            pcall(function() Root.AssemblyLinearVelocity = Vector3.zero end)
            Root.CFrame = CFrame.new(BASE_TARGET)
            restore(); stopReturnToBase(); return
        end

        local floatY  = math.sin((os.clock() - floatStartTime) * floatSpeed) * floatAmplitude
        local targetY = BASE_TARGET.Y + floatAmplitude + floatY + 4
        local vertErr = targetY - rootPos.Y
        local vertVel = math.clamp(vertErr * 5, -15, 15)

        local speedMult = 1
        if dist < BASE_SLOW_DIST then speedMult = math.max(0.15, dist / BASE_SLOW_DIST) end

        local moveDir = dir2D.Unit
        Velocity.VectorVelocity = Vector3.new(
            moveDir.X * BASE_SPEED * speedMult,
            vertVel,
            moveDir.Z * BASE_SPEED * speedMult
        )
    end)
end

local function executeSteal(prompt)
    if isStealing or not prompt or not prompt.Parent then return end
    isStealing = true
    firePromptConnections(prompt, "PromptButtonHoldBegan")
    task.wait(stealDelay)
    if prompt and prompt.Parent and prompt.Enabled and not thisScriptStopped then
        firePromptConnections(prompt, "Triggered")
    end
    isStealing = false
end

local STOP_DIST = 5
local SLOW_DIST = 20

local resetRemote = nil
local instaResetCooldown = false
local function resetCharacter(char)
    warn('[EL2B HUB] Reset distant désactivé.')
    return false
end
local function doReset()
    return false
end
-- AUTO BALLOON HEARTBEAT (HUGO VERSION)
-- ==========================================
local lastBalloonCheck = 0
RunService.Heartbeat:Connect(function()
	if not _G.AutoBalloon then return end
	local now = tick()
	if now - lastBalloonCheck < 0.1 then return end
	lastBalloonCheck = now

	for _, p in pairs(Players:GetPlayers()) do
		if p == LocalPlayer then continue end
		local character = p.Character
		if not character then continue end
		local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
		if not rootPart then continue end

		local targetKey = p.UserId
		local inZone = isInAnyZone(rootPart.Position)
		local withBrainrot = hasBrainrot(p)

		-- Balloon si: dans la zone, a un brainrot, pas encore ballonné cette session
		if inZone and withBrainrot and not BalloonState.Active[targetKey] then
			BalloonState.Active[targetKey] = true
			triggerBalloonOnTarget(p)
		elseif (not inZone or not withBrainrot) and BalloonState.Active[targetKey] then
			BalloonState.Active[targetKey] = nil
		end
	end
end)

Players.PlayerRemoving:Connect(function(p)
	BalloonState.Active[p.UserId] = nil
	LaserState.Active[p.UserId] = nil
end)

-- ==========================================
-- AUTO LASER CAPE HEARTBEAT
-- ==========================================
local lastLaserCheck = 0
RunService.Heartbeat:Connect(function()
	if not _G.AutoLaser then return end
	local now = tick()
	if now - lastLaserCheck < 0.1 then return end
	lastLaserCheck = now

	for _, p in pairs(Players:GetPlayers()) do
		if p == LocalPlayer then continue end
		local character = p.Character
		if not character then continue end
		local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
		if not rootPart then continue end

		local targetKey = p.UserId
		local inZone = isInAnyZone(rootPart.Position)
		local withBrainrot = hasBrainrot(p)

		if inZone and withBrainrot and not LaserState.Active[targetKey] then
			LaserState.Active[targetKey] = true
			triggerLaserOnTarget(p)
		elseif (not inZone or not withBrainrot) and LaserState.Active[targetKey] then
			LaserState.Active[targetKey] = nil
		end
	end
end)

local _resetWasByBalloon = false
local balloonConnection
balloonConnection = LocalPlayer:GetAttributeChangedSignal("Balloon"):Connect(function()
    if thisScriptStopped then pcall(function() balloonConnection:Disconnect() end) return end
    if _G.AutoResetOnBalloon == true and LocalPlayer:GetAttribute("Balloon") == true then
        _resetWasByBalloon = true
        task.spawn(function() doReset() end)
    end
end)
table.insert(ActiveConnections, balloonConnection)

for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") then
        local conn = obj.OnClientEvent:Connect(function(...)
            if not _G.AutoResetOnBalloon then return end
            for _, arg in ipairs({...}) do
                if type(arg) == "string" and arg:lower():find("jump higher") then
                    task.spawn(function() doReset() end)
                end
            end
        end)
        table.insert(ActiveConnections, conn)
    end
end



local PREBLOCK_DIST_BY_SLOT = {
    [1]  = 1.6, [2]  = 1.6, [3]  = 1.6, [4]  = 1.6, [5]  = 1.6,
    [6]  = 1.6, [7]  = 1.6, [8]  = 1.6, [9]  = 1.6,
    [11] = 7.8, [12] = 7.8, [13] = 7.8, [14] = 7.8, [15] = 7.8, [16] = 7.8,
    [19] = 7.8, [20] = 7.8, [21] = 7.8, [22] = 7.8, [23] = 7.8,
    [24] = 6.6, [25] = 6.6, [26] = 6.6, [27] = 6.6,
}

local clearTpPathVisual -- forward declaration (défini plus bas)

local function startTripToPetSlot(prompt, slotNumber)
    local config          = SlotsConfig[slotNumber] or SlotsConfig[1]
    local targetPositions = config.Positions or { config.Position }
    local needJump        = config.NeedJump == true
    if slotNumber >= 19 and slotNumber <= 27 then needJump = true end

    if currentMovement then pcall(function() currentMovement:Disconnect() end) currentMovement = nil end
    if not Root or not Humanoid then return end

    autoStealEnabled = true
    startFlashLagger()
    clearTpPathVisual()
    local Speed            = 200
    local grabStartDistance= 60
    local grabStarted      = false

    -- Surveille l'attribut Stealing pendant tout le flash TP
    if _G.AutoReturnBase then
        task.spawn(function()
            while autoStealEnabled and not thisScriptStopped do
                if LocalPlayer:GetAttribute("Stealing") then
                    startReturnToBase()
                    return
                end
                task.wait(0.05)
            end
        end)
    end

    -- Bloque les déplacements manuels et coupe l'animation de marche pendant le vol
    local savedWalkSpeed = Humanoid.WalkSpeed
    local savedJumpPower = Humanoid.JumpPower
    Humanoid.WalkSpeed = 0
    Humanoid.JumpPower = 0
    Humanoid.AutoRotate = false

    local animator = Humanoid:FindFirstChildOfClass("Animator")
    local stoppedTracks = {}
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            pcall(function() track:Stop(0) end)
            table.insert(stoppedTracks, track)
        end
    end
    local animPlayConn
    if animator then
        animPlayConn = animator.AnimationPlayed:Connect(function(track)
            -- Empêche toute nouvelle animation de marche/course de démarrer pendant le vol
            pcall(function() track:Stop(0) end)
        end)
        table.insert(ActiveConnections, animPlayConn)
    end

    local function restoreMovement()
        Humanoid.WalkSpeed  = savedWalkSpeed
        Humanoid.JumpPower  = savedJumpPower
        Humanoid.AutoRotate = true
        if animPlayConn then pcall(function() animPlayConn:Disconnect() end) end
    end

    local carpet = findTool(_G.WalkItem or "Flying Carpet")
    if carpet then Humanoid:UnequipTools() task.wait(0.03) Humanoid:EquipTool(carpet) end

    if Root:FindFirstChild("LinearVelocity") then Root.LinearVelocity:Destroy() end
    if Root:FindFirstChild("Attachment")     then Root.Attachment:Destroy() end

    local Attachment = Instance.new("Attachment")
    Attachment.Parent = Root

    local Velocity = Instance.new("LinearVelocity")
    Velocity.Attachment0     = Attachment
    Velocity.RelativeTo      = Enum.ActuatorRelativeTo.World
    Velocity.MaxForce        = math.huge
    Velocity.Parent          = Root

    local currentPosIndex       = 1
    local intermediatePauseActive = false
    local earlyBlockDone = false

    currentMovement = RunService.Heartbeat:Connect(function()
        if thisScriptStopped then
            if currentMovement then pcall(function() currentMovement:Disconnect() end) currentMovement = nil end
            restoreMovement()
            return
        end
        if not Root or not Humanoid or not Root.Parent or Humanoid.Health <= 0 then
            if currentMovement then pcall(function() currentMovement:Disconnect() end) currentMovement = nil end
            restoreMovement()
            return
        end
        if intermediatePauseActive then Velocity.VectorVelocity = Vector3.zero return end

        local TargetPosition = targetPositions[currentPosIndex]
        if not TargetPosition then return end

        local rootPos = Root.Position
        local dir     = Vector3.new(TargetPosition.X - rootPos.X, 0, TargetPosition.Z - rootPos.Z)
        local dist    = dir.Magnitude

        local finalPosition = targetPositions[#targetPositions]
        local finalDist = Vector3.new(finalPosition.X - rootPos.X, 0, finalPosition.Z - rootPos.Z).Magnitude
        if finalDist <= grabStartDistance and not grabStarted then
            grabStarted = true
            task.spawn(function() executeSteal(prompt) end)
        end

        if dist <= STOP_DIST then
            if currentPosIndex < #targetPositions then
                intermediatePauseActive = true
                Velocity.VectorVelocity = Vector3.zero
                Root.AssemblyLinearVelocity = Vector3.zero
                task.spawn(function()
                    currentPosIndex = currentPosIndex + 1
                    intermediatePauseActive = false
                end)
                return
            end

            Velocity.VectorVelocity = Vector3.zero
            Root.AssemblyLinearVelocity = Vector3.zero
            Velocity:Destroy()
            Attachment:Destroy()
            Root.CFrame = CFrame.new(TargetPosition)
            if currentMovement then pcall(function() currentMovement:Disconnect() end) currentMovement = nil end

            if _G.AutoBlock and (_G.BlockMode == "veryfast") and not earlyBlockDone then
                earlyBlockDone = true
                local blockDelay
                if slotNumber >= 19 and slotNumber <= 23 then
                    blockDelay = 0.065
                elseif slotNumber >= 11 and slotNumber <= 15 then
                    blockDelay = 0.14
                else
                    blockDelay = 0.2
                end
                task.spawn(function()
                    task.wait(blockDelay)
                    local target = getNearestPlayer()
                    if target then blockPlayer(target) end
                end)
            end

            task.wait(0.12)
            Camera.CameraType = Enum.CameraType.Scriptable
            Camera.CFrame = config.FixedCFrame or (CFrame.new(Root.Position + config.CamOffset) * CFrame.Angles(unpack(config.CamAngles)))
            Humanoid:UnequipTools()
            task.wait(0.06)

            if needJump then
                Root.AssemblyLinearVelocity = Vector3.new(0, 55, 0)
                task.wait(0.08)
            end

            local flash = findTool("flash")
            if flash then
                if not earlyBlockDone and _G.AutoBlock and (_G.BlockMode == "veryfast") then
                    task.spawn(function()
                        local target = getNearestPlayer()
                        if target then blockPlayer(target) end
                    end)
                end
                Humanoid:EquipTool(flash)
                task.wait(0.08)
                flash:Activate()
                if slotNumber == 6 then
                    Camera.CFrame = CFrame.new(-299.38, -3.06, 29.14, 0.914, -0.035, 0.405, 0.000, 0.996, 0.086, -0.407, -0.078, 0.910)
                end
            end

            task.wait(0.1)

            if _G.AutoGiant then
                local giant = findTool("giant potion")
                if giant then
                    Humanoid:EquipTool(giant)
                    task.wait(0.08)
                    giant:Activate()
                    task.wait(0.05)
                    if _G.RagdollBypass then
                        task.spawn(function()
                            ExecuteCommand("ragdoll", LocalPlayer.Name)
                        end)
                    end
                    Humanoid:UnequipTools()
                end
            end

            Camera.CameraType = Enum.CameraType.Custom

            if _G.AutoBlock then
                local mode = _G.BlockMode or "normal"
                if mode ~= "veryfast" then
                    task.spawn(function()
                        if mode == "normal" then
                            task.wait(0.13)
                        end
                        local target = getNearestPlayer()
                        if target then blockPlayer(target) end
                    end)
                end
            end

            task.spawn(function() task.wait(1.0) autoStealEnabled = false end)
            restoreMovement()
            return
        end

        Velocity.VectorVelocity = Vector3.new(dir.Unit.X * Speed, 0, dir.Unit.Z * Speed)
    end)
    table.insert(ActiveConnections, currentMovement)
end

local scrollListRef = nil
local brainrotNameGradients = {}

-- ============================================================
-- HIGHLIGHT JAUNE DES BRAINROTS IN-GAME
-- ============================================================
local brainrotHighlights = {}
local brainrotModelByPrompt = {}

local function clearBrainrotHighlights()
    for key, h in pairs(brainrotHighlights) do
        pcall(function() h:Destroy() end)
        brainrotHighlights[key] = nil
    end
end

local function updateBrainrotHighlights()
    if not _G.BrainrotHighlight then
        clearBrainrotHighlights()
        return
    end
    local plotsFolder = Workspace:FindFirstChild("Plots")
    if not plotsFolder then return end

    local seen = {}

    for _, plot in ipairs(plotsFolder:GetChildren()) do
        if not isMyPlot(plot) then
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, podium in ipairs(podiums:GetChildren()) do
                    local slotNumber = tonumber(podium.Name:match("%d+")) or 1
                    local key = plot.Name .. "_" .. slotNumber
                    local base = podium:FindFirstChild("Base") or podium
                    local spawnPoint = base:FindFirstChild("Spawn")
                    local attachment = spawnPoint and spawnPoint:FindFirstChild("PromptAttachment")
                    if attachment then
                        for _, child in ipairs(attachment:GetChildren()) do
                            if child:IsA("ProximityPrompt") and isValidStealPrompt(child) then
                                seen[key] = true
                                if not brainrotHighlights[key] then
                                    -- Le brainrot est un Model dans le plot dont la PrimaryPart/RootPart est proche du Spawn
                                    local model = nil
                                    local spawnPos = spawnPoint.Position
                                    local bestDist = 5 -- max 5 studs
                                    local playerNames = {}
                                    for _, p in pairs(Players:GetPlayers()) do playerNames[p.Name] = true end
                                    for _, v in ipairs(plot:GetDescendants()) do
                                        if v:IsA("Model") and not playerNames[v.Name] and not v:IsDescendantOf(podium) then
                                            local rp = v.PrimaryPart or v:FindFirstChild("RootPart") or v:FindFirstChild("HumanoidRootPart") or v:FindFirstChildWhichIsA("BasePart")
                                            if rp then
                                                local d = (rp.Position - spawnPos).Magnitude
                                                if d < bestDist then
                                                    bestDist = d
                                                    model = v
                                                end
                                            end
                                        end
                                    end
                                    if model then
                                        brainrotModelByPrompt[child] = model
                                        local existing = model:FindFirstChild("_BrainrotHL")
                                        if existing then existing:Destroy() end
                                        local h = Instance.new("Highlight")
                                        h.Name                  = "_BrainrotHL"
                                        h.Adornee               = model
                                        h.FillColor             = Color3.fromRGB(255, 215, 0)
                                        h.OutlineColor          = Color3.fromRGB(255, 255, 0)
                                        h.FillTransparency      = 0.5
                                        h.OutlineTransparency   = 0
                                        h.DepthMode             = Enum.HighlightDepthMode.AlwaysOnTop
                                        h.Parent                = model
                                        brainrotHighlights[key] = h
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- Nettoyer les highlights des brainrots disparus
    for key, h in pairs(brainrotHighlights) do
        if not seen[key] then
            pcall(function() h:Destroy() end)
            brainrotHighlights[key] = nil
        end
    end
    for prompt, _ in pairs(brainrotModelByPrompt) do
        if not prompt.Parent then
            brainrotModelByPrompt[prompt] = nil
        end
    end
end

task.spawn(function()
    while task.wait(0.5) do
        if thisScriptStopped then
            clearBrainrotHighlights()
            clearTpPathVisual()
            break
        end
        pcall(updateBrainrotHighlights)
    end
end)

-- ============================================================
-- VISUALISATION DU TRAJET DE TP (flèches numérotées + highlight rouge)
-- ============================================================
local tpPathMarkers   = {}
local tpTargetHighlight = nil
local tpVisualPrompt  = nil

clearTpPathVisual = function()
    for _, m in ipairs(tpPathMarkers) do
        pcall(function() m:Destroy() end)
    end
    tpPathMarkers = {}
    if tpTargetHighlight then
        pcall(function() tpTargetHighlight:Destroy() end)
        tpTargetHighlight = nil
    end
    tpVisualPrompt = nil
end

local function createArrowMarker(position, index)
    local part = Instance.new("Part")
    part.Name        = "_TPPathMarker"
    part.Anchored    = true
    part.CanCollide  = false
    part.CanQuery    = false
    part.CanTouch    = false
    part.Transparency = 1
    part.Size        = Vector3.new(0.2, 0.2, 0.2)
    part.Position    = position + Vector3.new(0, 5, 0)
    part.Parent      = Workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Name             = "_TPPathBillboard"
    billboard.Size             = UDim2.new(0, 60, 0, 80)
    billboard.StudsOffset      = Vector3.new(0, 0, 0)
    billboard.AlwaysOnTop      = true
    billboard.Parent           = part

    local arrowLabel = Instance.new("TextLabel")
    arrowLabel.Size               = UDim2.new(1, 0, 0, 40)
    arrowLabel.Position           = UDim2.new(0, 0, 0, 0)
    arrowLabel.BackgroundTransparency = 1
    arrowLabel.Text               = "▼"
    arrowLabel.TextColor3         = Color3.fromRGB(255, 60, 60)
    arrowLabel.TextScaled         = true
    arrowLabel.Font               = Enum.Font.GothamBold
    arrowLabel.Parent             = billboard

    local numberLabel = Instance.new("TextLabel")
    numberLabel.Size               = UDim2.new(1, 0, 0, 30)
    numberLabel.Position           = UDim2.new(0, 0, 0, 38)
    numberLabel.BackgroundTransparency = 1
    numberLabel.Text               = tostring(index)
    numberLabel.TextColor3         = Color3.fromRGB(255, 255, 255)
    numberLabel.TextStrokeTransparency = 0
    numberLabel.TextStrokeColor3   = Color3.fromRGB(0, 0, 0)
    numberLabel.TextScaled         = true
    numberLabel.Font               = Enum.Font.GothamBold
    numberLabel.Parent             = billboard

    -- petite animation de flottement pour rendre la flèche plus visible
    task.spawn(function()
        local t = 0
        while part.Parent do
            t += task.wait(0.05)
            if not part.Parent then break end
            part.Position = position + Vector3.new(0, 5 + math.sin(t * 3) * 0.4, 0)
        end
    end)

    return part
end

local function showTpPathVisual(prompt, slotNumber)
    clearTpPathVisual()
    if not _G.TpPathVisual then return end
    tpVisualPrompt = prompt

    local config = SlotsConfig[slotNumber] or SlotsConfig[1]
    local positions = config.Positions or { config.Position }

    for i, pos in ipairs(positions) do
        local marker = createArrowMarker(pos, i)
        table.insert(tpPathMarkers, marker)
    end

    local model = brainrotModelByPrompt[prompt]
    if model then
        local existing = model:FindFirstChild("_TPTargetHL")
        if existing then existing:Destroy() end
        local h = Instance.new("Highlight")
        h.Name                = "_TPTargetHL"
        h.Adornee             = model
        h.FillColor           = Color3.fromRGB(255, 0, 0)
        h.OutlineColor        = Color3.fromRGB(255, 80, 80)
        h.FillTransparency    = 0.4
        h.OutlineTransparency = 0
        h.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent              = model
        tpTargetHighlight = h
    end
end

local function autoSelectBestBrainrot(petsList)
	if not _G.AutoSelectBest or isStealing or autoStealEnabled then return end
	if #petsList == 0 then return end
	
	local bestPet = nil
	local lowestSlot = math.huge
	
	for _, petData in ipairs(petsList) do
		if petData.slot < lowestSlot then
			lowestSlot = petData.slot
			bestPet = petData
		end
	end
	
	if bestPet then
		selectedPrompt = bestPet.prompt
		selectedSlotNumber = bestPet.slot
		showTpPathVisual(selectedPrompt, selectedSlotNumber)
	end
end

local function updatePetList()
    if isStealing or autoStealEnabled or thisScriptStopped then return end
    if not scrollListRef then return end

    for _, child in ipairs(scrollListRef:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    brainrotNameGradients = {}

    local plotsFolder = Workspace:FindFirstChild("Plots")
    if not plotsFolder then return end

    local tempPets = {}
    for _, plot in ipairs(plotsFolder:GetChildren()) do
        if not isMyPlot(plot) then
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, podium in ipairs(podiums:GetChildren()) do
                    local slotNumber  = tonumber(podium.Name:match("%d+")) or 1
                    local base        = podium:FindFirstChild("Base") or podium
                    local spawnPoint  = base:FindFirstChild("Spawn")
                    local attachment  = spawnPoint and spawnPoint:FindFirstChild("PromptAttachment")
                    if attachment then
                        for _, child in ipairs(attachment:GetChildren()) do
                            if child:IsA("ProximityPrompt") and isValidStealPrompt(child) then
                                local petName = child.ObjectText or "Pet"
                                table.insert(tempPets, { prompt = child, slot = slotNumber, name = petName })
                            end
                        end
                    end
                end
            end
        end
    end

    table.sort(tempPets, function(a, b) return a.slot < b.slot end)
	
	autoSelectBestBrainrot(tempPets)

    local C_list = {
        card   = Color3.fromRGB(38, 40, 46),
        accent = Color3.fromRGB(196, 168, 60),
        stroke = Color3.fromRGB(110, 95, 45),
        bright = Color3.fromRGB(235, 235, 240),
        mute   = Color3.fromRGB(170, 170, 178),
    }

    for _, petData in ipairs(tempPets) do
        if thisScriptStopped then break end
        local isSelected = (selectedPrompt == petData.prompt)

        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -8, 0, 40)
        row.BackgroundColor3 = isSelected and Color3.fromRGB(28, 26, 16) or C_list.card
        row.BorderSizePixel = 0
        row.Parent = scrollListRef
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)

        local rStroke = Instance.new("UIStroke")
        rStroke.Color     = isSelected and C_list.accent or C_list.stroke
        rStroke.Thickness = isSelected and 1.5 or 1
        rStroke.Parent    = row

        -- === VIEWPORT 3D ===
        local VP_SIZE = 60
        row.Size = UDim2.new(1, -8, 0, 66)

        local vp = Instance.new("ViewportFrame")
        vp.Size                   = UDim2.new(0, VP_SIZE, 0, VP_SIZE)
        vp.Position               = UDim2.new(0, 3, 0.5, -VP_SIZE / 2)
        vp.BackgroundTransparency = 1
        vp.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
        vp.BorderSizePixel        = 0
        vp.ZIndex                 = 5
        vp.Parent                 = row

        local vpCam = Instance.new("Camera")
        vpCam.Parent = vp
        vp.CurrentCamera = vpCam

        task.spawn(function()
            local plotsFolder = Workspace:FindFirstChild("Plots")
            if not plotsFolder then return end
            local playerNames = {}
            for _, p in pairs(Players:GetPlayers()) do playerNames[p.Name] = true end

            local foundModel = nil
            for _, v in ipairs(plotsFolder:GetDescendants()) do
                if v:IsA("Model") and v.Name == petData.name and not playerNames[v.Name] then
                    foundModel = v
                    break
                end
            end
            if not foundModel then return end

            local clone = foundModel:Clone()
            for _, d in ipairs(clone:GetDescendants()) do
                if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("Highlight") then
                    d:Destroy()
                end
            end
            clone.Parent = vp

            local cf, size = clone:GetBoundingBox()
            local dist = math.max(size.Magnitude * 1.2, 2)
            local center = cf.Position
            local height = size.Y * 0.2

            -- Rotation continue du modèle
            local angle = 0
            local rotConn
            rotConn = RunService.Heartbeat:Connect(function(dt)
                if not vp.Parent then
                    rotConn:Disconnect()
                    return
                end
                angle = angle + dt * 60 -- 60 degrés/seconde
                local rad = math.rad(angle)
                vpCam.CFrame = CFrame.new(
                    center + Vector3.new(math.sin(rad) * dist, height, math.cos(rad) * dist),
                    center
                )
            end)
            table.insert(ActiveConnections, rotConn)
        end)

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text               = petData.name
        nameLabel.Size               = UDim2.new(1, -(VP_SIZE + 18), 1, 0)
        nameLabel.Position           = UDim2.new(0, VP_SIZE + 10, 0, -4)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3         = Color3.fromRGB(235, 235, 240)
        nameLabel.Font               = Enum.Font.GothamMedium
        nameLabel.TextSize           = 13
        nameLabel.TextXAlignment     = Enum.TextXAlignment.Left
        nameLabel.Parent             = row

        local nameGrad = Instance.new("UIGradient")
        nameGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,  Color3.fromRGB(235, 235, 240)),
            ColorSequenceKeypoint.new(.5, Color3.fromRGB(224, 198, 100)),
            ColorSequenceKeypoint.new(1,  Color3.fromRGB(235, 235, 240))
        })
        nameGrad.Parent = nameLabel
        table.insert(brainrotNameGradients, nameGrad)

        local slotLabel = Instance.new("TextLabel")
        slotLabel.Text               = "slot " .. petData.slot
        slotLabel.Size               = UDim2.new(1, -(VP_SIZE + 14), 1, 0)
        slotLabel.Position           = UDim2.new(0, VP_SIZE + 2, 0, 6)
        slotLabel.BackgroundTransparency = 1
        slotLabel.TextColor3         = C_list.mute
        slotLabel.Font               = Enum.Font.GothamMedium
        slotLabel.TextSize           = 11
        slotLabel.TextXAlignment     = Enum.TextXAlignment.Right
        slotLabel.Parent             = row

        local clickBtn = Instance.new("TextButton")
        clickBtn.Size                = UDim2.new(1, 0, 1, 0)
        clickBtn.BackgroundTransparency = 1
        clickBtn.Text               = ""
        clickBtn.BorderSizePixel    = 0
        clickBtn.Parent             = row

        local rowBtnConn = clickBtn.MouseButton1Click:Connect(function()
            if not isStealing and not autoStealEnabled then
                selectedPrompt     = petData.prompt
                selectedSlotNumber = petData.slot
                showTpPathVisual(selectedPrompt, selectedSlotNumber)
                updatePetList()
            end
        end)
        table.insert(ActiveConnections, rowBtnConn)
    end

end

-- ============================================================
-- NETTOYAGE DES ANCIENNES GUI
-- ============================================================
local function BuildHUB()
local old = PlayerGui:FindFirstChild("Nexyra SCRIPT")
if old then old:Destroy() end
local oldB = PlayerGui:FindFirstChild("NOXHUB BANNER")
if oldB then oldB:Destroy() end
local oldN = PlayerGui:FindFirstChild("NOX SCRIPT")
if oldN then oldN:Destroy() end

-- ============================================================
-- COULEURS
-- ============================================================
local C = {
    accent     = Color3.fromRGB(196, 168, 60),
    accentHi   = Color3.fromRGB(224, 198, 100),
    deepPurple = Color3.fromRGB(60,  52,  20),
    body       = Color3.fromRGB(22,  24,  28),
    panel      = Color3.fromRGB(26,  28,  32),
    card       = Color3.fromRGB(40,  42,  48),
    iconBg     = Color3.fromRGB(50,  52,  58),
    stroke     = Color3.fromRGB(196, 168, 60),
    strokeDim  = Color3.fromRGB(110,  95,  45),
    textBright = Color3.fromRGB(235, 235, 240),
    textMauve  = Color3.fromRGB(224, 198, 100),
    textMute   = Color3.fromRGB(170, 170, 178),
    textDim    = Color3.fromRGB(120, 120, 128),
    knobOn     = Color3.fromRGB(230, 205, 120),
    knobOff    = Color3.fromRGB(90,   90,  98),
    trackOff   = Color3.fromRGB(44,   46,  52),
}

-- ============================================================
-- DEVICE
-- ============================================================
local function getDevice()
    local isMobil = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    if isMobil then
        local s = workspace.CurrentCamera.ViewportSize
        if s.X >= 900 or s.Y >= 900 then return "ipad" end
        return "mobile"
    end
    return "pc"
end
local DEVICE = getDevice()
local isMob  = DEVICE ~= "pc"

local L = {
    posX     = UDim2.new(0.5, 0, 0.5, 0),
    textSize = { btn = isMob and 10 or 12, header = 11, tab = 12 },
}

-- ============================================================
-- SCREENGUI PRINCIPALE
-- ============================================================
local NOX_SCRIPT_GUI = Instance.new("ScreenGui")
NOX_SCRIPT_GUI.Name           = "NOX SCRIPT"
NOX_SCRIPT_GUI.ResetOnSpawn   = false
NOX_SCRIPT_GUI.DisplayOrder   = 999
NOX_SCRIPT_GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NOX_SCRIPT_GUI.IgnoreGuiInset = false
NOX_SCRIPT_GUI.Parent         = PlayerGui

-- ── Bandeau Kay PvP (style Gamma) ───────────────────────────────────────────
do
    local BN_W  = isMob and 310 or 420
    local BN_H  = isMob and 38  or 52

    -- colonnes (positions X absolues dans la barre)
    local LOGO_X  = isMob and 6   or 8
    local logoSz  = isMob and 26  or 40
    local HUB_X   = LOGO_X + logoSz + (isMob and 8 or 12)
    local D1_X    = isMob and 148 or 200   -- séparateur 1 : après nom/version
    local STAT_X  = D1_X + (isMob and 8 or 12)
    local D2_X    = isMob and 238 or 320   -- séparateur 2 : avant badge
    local BADGE_X = D2_X + (isMob and 6 or 8)
    local BADGE_W = isMob and 64 or 88

    local banner = Instance.new("Frame")
    banner.Name                   = "KayHubBanner"
    banner.AnchorPoint            = Vector2.new(0.5, 0)
    banner.Size                   = UDim2.new(0, BN_W, 0, BN_H)
    banner.Position               = UDim2.new(0.5, 0, 0, 8)
    banner.BackgroundColor3       = Color3.fromRGB(10, 10, 14)
    banner.BackgroundTransparency = 0.08
    banner.BorderSizePixel        = 0
    banner.ZIndex                 = 999
    banner.Parent                 = NOX_SCRIPT_GUI
    Instance.new("UICorner", banner).CornerRadius = UDim.new(0, 14)
    -- stroke accent avec gradient animé
    local bStroke = Instance.new("UIStroke", banner)
    bStroke.Color       = C.accent
    bStroke.Thickness   = isMob and 1.2 or 1.6
    bStroke.Transparency = 0
    local bStrokeGrad = Instance.new("UIGradient", bStroke)
    bStrokeGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0.6),
        NumberSequenceKeypoint.new(1, 0),
    })
    bStrokeGrad.Rotation = 90
    table.insert(ActiveConnections, RunService.Heartbeat:Connect(function()
        bStrokeGrad.Rotation = (tick() * 25) % 360
    end))

    -- ── Logo box "K" ────────────────────────────────────────────────────────
    local logoBox = Instance.new("Frame")
    logoBox.Size             = UDim2.new(0, logoSz, 0, logoSz)
    logoBox.Position         = UDim2.new(0, LOGO_X, 0.5, -logoSz / 2)
    logoBox.BackgroundColor3 = C.accent
    logoBox.BorderSizePixel  = 0
    logoBox.ZIndex           = 1000
    logoBox.Parent           = banner
    Instance.new("UICorner", logoBox).CornerRadius = UDim.new(0, isMob and 7 or 10)
    local logoStroke = Instance.new("UIStroke", logoBox)
    logoStroke.Color        = Color3.fromRGB(255,255,255)
    logoStroke.Thickness    = isMob and 1 or 1.4
    logoStroke.Transparency = 0.75
    -- gradient animé sur le fond du logo
    local logoGrad = Instance.new("UIGradient", logoBox)
    logoGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   C.accent),
        ColorSequenceKeypoint.new(0.5, C.accentHi),
        ColorSequenceKeypoint.new(1,   C.accent),
    })
    logoGrad.Rotation = 115
    table.insert(ActiveConnections, RunService.Heartbeat:Connect(function()
        logoGrad.Rotation = (tick() * 40) % 360
    end))
    local logoLetter = Instance.new("TextLabel")
    logoLetter.Size               = UDim2.new(1, 0, 1, 0)
    logoLetter.BackgroundTransparency = 1
    logoLetter.Text               = "K"
    logoLetter.TextColor3         = Color3.fromRGB(255, 255, 255)
    logoLetter.TextSize           = isMob and 16 or 24
    logoLetter.Font               = Enum.Font.GothamBlack
    logoLetter.TextXAlignment     = Enum.TextXAlignment.Center
    logoLetter.TextYAlignment     = Enum.TextYAlignment.Center
    logoLetter.ZIndex             = 1001
    logoLetter.Parent             = logoBox

    -- ── Fonction divider vertical ────────────────────────────────────────────
    local function bnDivider(x)
        local d = Instance.new("Frame")
        d.Size             = UDim2.new(0, 1, 0, isMob and 24 or 34)
        d.Position         = UDim2.new(0, x, 0.5, isMob and -12 or -17)
        d.BackgroundColor3 = Color3.fromRGB(60, 45, 90)
        d.BorderSizePixel  = 0
        d.ZIndex           = 1000
        d.Parent           = banner
    end
    bnDivider(D1_X)
    bnDivider(D2_X)

    -- ── Section nom + version ────────────────────────────────────────────────
    local hubLabel = Instance.new("TextLabel")
    hubLabel.Size               = UDim2.new(0, D1_X - HUB_X - 6, 0, isMob and 18 or 24)
    hubLabel.Position           = UDim2.new(0, HUB_X, 0, isMob and 3 or 5)
    hubLabel.BackgroundTransparency = 1
    hubLabel.Text               = "Kay Hub"
    hubLabel.TextColor3         = Color3.fromRGB(255, 255, 255)
    hubLabel.TextSize           = isMob and 10 or 14
    hubLabel.Font               = Enum.Font.GothamBold
    hubLabel.TextXAlignment     = Enum.TextXAlignment.Left
    hubLabel.TextYAlignment     = Enum.TextYAlignment.Center
    hubLabel.TextTruncate       = Enum.TextTruncate.AtEnd
    hubLabel.ZIndex             = 1000
    hubLabel.Parent             = banner
    local hubLabelGrad = Instance.new("UIGradient", hubLabel)
    hubLabelGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, C.accentHi),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 255, 255)),
    })
    hubLabelGrad.Rotation = 0
    table.insert(ActiveConnections, RunService.Heartbeat:Connect(function()
        hubLabelGrad.Rotation = (tick() * 30) % 360
    end))

    local versionLabel = Instance.new("TextLabel")
    versionLabel.Size               = UDim2.new(0, D1_X - HUB_X - 6, 0, isMob and 14 or 18)
    versionLabel.Position           = UDim2.new(0, HUB_X, 0.5, isMob and 1 or 2)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text               = "v5.5  •  PvP"
    versionLabel.TextColor3         = Color3.fromRGB(180, 165, 210)
    versionLabel.TextSize           = isMob and 8 or 11
    versionLabel.Font               = Enum.Font.GothamBold
    versionLabel.TextXAlignment     = Enum.TextXAlignment.Left
    versionLabel.TextYAlignment     = Enum.TextYAlignment.Center
    versionLabel.TextTruncate       = Enum.TextTruncate.AtEnd
    versionLabel.ZIndex             = 1000
    versionLabel.Parent             = banner

    -- ── Section FPS + PING (stacked) ─────────────────────────────────────────
    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Size               = UDim2.new(0, D2_X - STAT_X - 4, 0, isMob and 17 or 22)
    fpsLabel.Position           = UDim2.new(0, STAT_X, 0, isMob and 3 or 5)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Text               = "FPS: --"
    fpsLabel.TextColor3         = C.accent
    fpsLabel.TextSize           = isMob and 9 or 12
    fpsLabel.Font               = Enum.Font.GothamBold
    fpsLabel.TextXAlignment     = Enum.TextXAlignment.Left
    fpsLabel.TextYAlignment     = Enum.TextYAlignment.Center
    fpsLabel.ZIndex             = 1000
    fpsLabel.Parent             = banner

    local pingLabel = Instance.new("TextLabel")
    pingLabel.Size               = UDim2.new(0, D2_X - STAT_X - 4, 0, isMob and 15 or 20)
    pingLabel.Position           = UDim2.new(0, STAT_X, 0.5, isMob and -1 or -2)
    pingLabel.BackgroundTransparency = 1
    pingLabel.Text               = "PING: --ms"
    pingLabel.TextColor3         = Color3.fromRGB(80, 220, 130)
    pingLabel.TextSize           = isMob and 9 or 12
    pingLabel.Font               = Enum.Font.GothamBold
    pingLabel.TextXAlignment     = Enum.TextXAlignment.Left
    pingLabel.TextYAlignment     = Enum.TextYAlignment.Center
    pingLabel.ZIndex             = 1000
    pingLabel.Parent             = banner

    -- ── Badge "● LIVE" ────────────────────────────────────────────────────────
    local badgeH = isMob and 22 or 30
    local statusBadge = Instance.new("Frame")
    statusBadge.Size             = UDim2.new(0, BADGE_W, 0, badgeH)
    statusBadge.Position         = UDim2.new(0, BADGE_X, 0.5, -badgeH / 2)
    statusBadge.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    statusBadge.BorderSizePixel  = 0
    statusBadge.ZIndex           = 1000
    statusBadge.Parent           = banner
    Instance.new("UICorner", statusBadge).CornerRadius = UDim.new(0, 8)
    local badgeStroke = Instance.new("UIStroke", statusBadge)
    badgeStroke.Color        = C.accent
    badgeStroke.Thickness    = isMob and 0.8 or 1
    badgeStroke.Transparency = 0.25
    local badgeLbl = Instance.new("TextLabel")
    badgeLbl.Size               = UDim2.new(1, 0, 1, 0)
    badgeLbl.BackgroundTransparency = 1
    badgeLbl.Text               = "● LIVE"
    badgeLbl.TextColor3         = C.accent
    badgeLbl.TextSize           = isMob and 8 or 12
    badgeLbl.Font               = Enum.Font.GothamBold
    badgeLbl.TextXAlignment     = Enum.TextXAlignment.Center
    badgeLbl.TextYAlignment     = Enum.TextYAlignment.Center
    badgeLbl.ZIndex             = 1001
    badgeLbl.Parent             = statusBadge

    -- ── Update FPS / PING ────────────────────────────────────────────────────
    local netStats = Stats.Network and Stats.Network.ServerStatsItem and Stats.Network.ServerStatsItem["Data Ping"]
    local frameCount, fpsTimer = 0, 0
    local currentFps, currentPing = 0, 0
    table.insert(ActiveConnections, RunService.Heartbeat:Connect(function(dt)
        frameCount = frameCount + 1
        fpsTimer   = fpsTimer + dt
        if fpsTimer >= 0.5 then
            currentFps = math.floor(frameCount / fpsTimer + 0.5)
            fpsLabel.Text = "FPS: " .. currentFps
            frameCount, fpsTimer = 0, 0
        end
    end))
    task.spawn(function()
        while not thisScriptStopped do
            local ok, val = pcall(function()
                return netStats and netStats:GetValue()
            end)
            if ok and val then
                currentPing = math.floor(val)
                pingLabel.Text = "PING: " .. currentPing .. "ms"
            end
            task.wait(1)
        end
    end)
end
-- ── Fin bandeau ──────────────────────────────────────────────────────────────

local screenW = workspace.CurrentCamera.ViewportSize.X
local screenH = workspace.CurrentCamera.ViewportSize.Y

-- ============================================================
-- HELPER : DRAG
-- ============================================================
local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos
    handle.Active = true
    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = inp.Position
            startPos  = frame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement
        and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = inp.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end)
end

-- ============================================================
-- HELPER : RESIZE (poignée bas-droite)
-- ============================================================
local function makeResizable(panel, minW, minH)
    local grip = Instance.new("TextButton")
    grip.Size             = UDim2.new(0, 18, 0, 18)
    grip.Position         = UDim2.new(1, -20, 1, -20)
    grip.BackgroundTransparency = 1
    grip.BorderSizePixel  = 0
    grip.ZIndex           = 30
    grip.Text             = "⋯"
    grip.TextColor3       = C.textMute
    grip.TextSize         = 10
    grip.Font             = Enum.Font.Gotham
    grip.AutoButtonColor  = false
    grip.Parent           = panel

    local resizing, resizeStart, startSz
    grip.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            resizing   = true
            resizeStart = inp.Position
            startSz     = Vector2.new(panel.AbsoluteSize.X, panel.AbsoluteSize.Y)
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then resizing = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if not resizing then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement
        and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local d  = inp.Position - resizeStart

        -- Marge dynamique basée sur la position réelle du panel à l'écran et la taille
        -- de viewport courante (au lieu de bornes fixes qui ne tenaient pas compte d'où
        -- le panel est positionné -> c'était la cause du blocage en hauteur sur Quick AP).
        local viewport  = workspace.CurrentCamera.ViewportSize
        local panelTopY = panel.AbsolutePosition.Y
        local panelLeftX= panel.AbsolutePosition.X
        local maxW = math.max(minW, viewport.X - panelLeftX - 6)
        local maxH = math.max(minH, viewport.Y - panelTopY  - 6)

        local nW = math.clamp(startSz.X + d.X, minW, maxW)
        local nH = math.clamp(startSz.Y + d.Y, minH, maxH)
        panel.Size = UDim2.new(0, nW, 0, nH)
    end)
end

-- ============================================================
-- FACTORY : PANEL (header draggable + resize)
-- ============================================================
local HEADER_H = 34

local function makePanel(name, titleText, px, py, pw, ph, minW, minH)
    local panel = Instance.new("Frame")
    panel.Name             = name
    panel.Size             = UDim2.new(0, pw, 0, ph)
    panel.Position         = UDim2.new(0, px, 0, py)
    panel.BackgroundColor3 = C.body
    panel.BackgroundTransparency = 0.20
    panel.ClipsDescendants = false
    panel.ZIndex           = 5
    panel.Parent           = NOX_SCRIPT_GUI
    local pc = Instance.new("UICorner", panel); pc.CornerRadius = UDim.new(0, 14)
    local ps = Instance.new("UIStroke",  panel); ps.Color = C.stroke; ps.Thickness = 1.4

    -- header
    local hdr = Instance.new("Frame")
    hdr.Name             = "Header"
    hdr.Size             = UDim2.new(1, 0, 0, HEADER_H)
    hdr.BackgroundColor3 = C.panel
    hdr.BackgroundTransparency = 0.20
    hdr.ZIndex           = 6
    hdr.Active           = true
    hdr.Parent           = panel
    Instance.new("UICorner", hdr).CornerRadius = UDim.new(0, 14)

    -- bouche le gap arrondi en bas du header
    local hExt = Instance.new("Frame")
    hExt.Size             = UDim2.new(1, 0, 0, 14)
    hExt.Position         = UDim2.new(0, 0, 1, -14)
    hExt.BackgroundColor3 = C.panel
    hExt.BackgroundTransparency = 0.20
    hExt.ZIndex           = 5
    hExt.Parent           = hdr

    -- point accent
    local dot = Instance.new("Frame")
    dot.Size             = UDim2.new(0, 6, 0, 6)
    dot.Position         = UDim2.new(0, 11, 0.5, -3)
    dot.BackgroundColor3 = C.accent
    dot.BorderSizePixel  = 0
    dot.ZIndex           = 8
    dot.Parent           = hdr
    Instance.new("UICorner", dot).CornerRadius = UDim.new(0, 3)

    -- titre
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size               = UDim2.new(0, 0, 1, 0)
    titleLbl.AutomaticSize      = Enum.AutomaticSize.X
    titleLbl.Position           = UDim2.new(0, 22, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.ZIndex             = 8
    titleLbl.Text               = titleText
    titleLbl.TextColor3         = C.textBright
    titleLbl.TextSize           = isMob and 11 or 13
    titleLbl.Font               = Enum.Font.GothamBold
    titleLbl.TextXAlignment     = Enum.TextXAlignment.Left
    titleLbl.Parent             = hdr
    
    -- Gradient rotatif sur le titre (comme dans NoxHub)
    local titleGrad = Instance.new("UIGradient", titleLbl)
    titleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.textBright),
        ColorSequenceKeypoint.new(.5, C.textMauve),
        ColorSequenceKeypoint.new(1, C.textBright)
    })
    table.insert(ActiveConnections, RunService.Heartbeat:Connect(function()
        if titleGrad and titleGrad.Parent then
            titleGrad.Rotation = (tick()*100)%360
        end
    end))

    -- zone de contenu
    local content = Instance.new("Frame")
    content.Name             = "Content"
    content.Size             = UDim2.new(1, 0, 1, -HEADER_H)
    content.Position         = UDim2.new(0, 0, 0, HEADER_H)
    content.BackgroundTransparency = 1
    content.BorderSizePixel  = 0
    content.ClipsDescendants = true
    content.ZIndex           = 5
    content.Parent           = panel

    makeDraggable(panel, hdr)
    makeResizable(panel, minW, minH)

    return panel, content, hdr, titleLbl
end

-- ============================================================
-- PANEL 1 : ACTIONS (liste verticale empilée, style "Actions" photo)
-- ============================================================
local FLASHTP, flashAccent, BLOCK, blockAccent, RESET, resetAccent
do
    local AW = isMob and 150 or 175
    local ACT_BTN_H   = isMob and 30 or 34
    local ACT_PADDING = 8
    local ACT_COUNT   = 4 -- FLASHTP, BLOCK, RESET, REJOIN
    local AH = HEADER_H + 12 + (ACT_BTN_H * ACT_COUNT) + (ACT_PADDING * (ACT_COUNT - 1))

    local actionsPanel, actionsContent, actionsHdr = makePanel(
        "ActionsPanel", "ACTIONS",
        math.floor(screenW / 2 - AW / 2),
        math.floor(screenH * 0.07),
        AW, AH, 170, AH
    )
    registerPanelLayout(actionsPanel, "ActionsPanel", 170, AH)

    local btnContainer = Instance.new("ScrollingFrame")
    btnContainer.Name                  = "ActionsScroll"
    btnContainer.Size                  = UDim2.new(1, -14, 1, -12)
    btnContainer.Position              = UDim2.new(0, 7, 0, 6)
    btnContainer.BackgroundTransparency = 1
    btnContainer.BorderSizePixel       = 0
    btnContainer.ZIndex                = 6
    btnContainer.CanvasSize            = UDim2.new(0, 0, 0, 0)
    btnContainer.AutomaticCanvasSize   = Enum.AutomaticSize.Y
    btnContainer.ScrollBarThickness    = 3
    btnContainer.ScrollBarImageColor3  = C.accent
    btnContainer.ScrollingDirection    = Enum.ScrollingDirection.Y
    btnContainer.Parent                = actionsContent

    local UIListAct = Instance.new("UIListLayout")
    UIListAct.FillDirection      = Enum.FillDirection.Vertical
    UIListAct.VerticalAlignment  = Enum.VerticalAlignment.Top
    UIListAct.HorizontalAlignment= Enum.HorizontalAlignment.Center
    UIListAct.SortOrder          = Enum.SortOrder.LayoutOrder
    UIListAct.Padding            = UDim.new(0, ACT_PADDING)
    UIListAct.Parent             = btnContainer

    local function mkActionBtn(name, txt, order)
        local b = Instance.new("TextButton")
        b.Name                   = name
        b.Size                   = UDim2.new(0.86, 0, 0, ACT_BTN_H)
        b.AnchorPoint             = Vector2.new(0.5, 0)
        b.Position                = UDim2.new(0.5, 0, 0, 0)
        b.BackgroundColor3       = C.card
        b.BackgroundTransparency = 0.2
        b.BorderSizePixel        = 0
        b.ZIndex                 = 7
        b.Text                   = ""
        b.AutoButtonColor        = false
        b.LayoutOrder            = order
        b.Parent                 = btnContainer
        Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
        local bs = Instance.new("UIStroke", b)
        bs.Color     = C.strokeDim
        bs.Thickness = 1
        bs.Transparency = 0.35
        -- label
        local lbl = Instance.new("TextLabel")
        lbl.Size               = UDim2.new(1, -8, 1, 0)
        lbl.Position           = UDim2.new(0, 4, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.ZIndex             = 9
        lbl.Text               = txt
        lbl.TextColor3         = C.textBright
        lbl.TextSize           = isMob and 12 or 14
        lbl.Font               = Enum.Font.GothamBold
        lbl.TextWrapped        = true
        lbl.TextXAlignment     = Enum.TextXAlignment.Center
        lbl.TextYAlignment     = Enum.TextYAlignment.Center
        lbl.Parent             = b
        -- bar gardée pour compatibilité avec flashBar() (effet flash au clic), invisible
        local bar = Instance.new("Frame")
        bar.Name             = "AccentBar"
        bar.Size             = UDim2.new(0, 0, 0, 0)
        bar.BackgroundColor3 = C.stroke
        bar.BackgroundTransparency = 1
        bar.BorderSizePixel  = 0
        bar.ZIndex           = 1
        bar.Parent           = b
        return b, bar, lbl
    end

    FLASHTP, flashAccent = mkActionBtn("FLASHTP", "FLASH TP [F]", 1)
    BLOCK,   blockAccent = mkActionBtn("BLOCK",   "BLOCK [B]",    2)
    RESET,   resetAccent = mkActionBtn("RESET",   "RESET [R]",    3)
    local REJOIN, rejoinAccent = mkActionBtn("REJOIN", "REJOIN [J]", 4)

    -- Stocker REJOIN pour utilisation plus tard
    _G._KayRejoinBtn = REJOIN
end

-- Frame13 : dummy conservé pour compatibilité
local Frame13 = Instance.new("Frame")
Frame13.Size             = UDim2.new(0, 1, 0, 1)
Frame13.BackgroundTransparency = 1
Frame13.Parent           = actionsPanel

-- ============================================================
-- PANEL 2 : BRAINROTS
-- ============================================================
local BW = isMob and 198 or 234
local BH = isMob and 195 or 245

local brainrotsPanel, brainrotsContent = makePanel(
    "BrainrotsPanel", "BRAINROTS",
    math.floor(screenW / 2 - BW / 2),
    math.floor(screenH * 0.22),
    BW, BH, 160, 130
)
registerPanelLayout(brainrotsPanel, "BrainrotsPanel", 160, 130)

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name                  = "ScrollingFrame"
ScrollingFrame.Size                  = UDim2.new(1, -4, 1, -4)
ScrollingFrame.Position              = UDim2.new(0, 2, 0, 2)
ScrollingFrame.BackgroundTransparency= 1
ScrollingFrame.BorderSizePixel       = 0
ScrollingFrame.CanvasSize            = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness    = 3
ScrollingFrame.ScrollBarImageColor3  = C.accent
ScrollingFrame.ScrollingDirection    = Enum.ScrollingDirection.Y
ScrollingFrame.AutomaticCanvasSize   = Enum.AutomaticSize.Y
ScrollingFrame.Parent                = brainrotsContent

local UIListLayout2 = Instance.new("UIListLayout")
UIListLayout2.SortOrder           = Enum.SortOrder.LayoutOrder
UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout2.Padding             = UDim.new(0, 4)
UIListLayout2.Parent              = ScrollingFrame

local UIPaddingList = Instance.new("UIPadding")
UIPaddingList.PaddingTop    = UDim.new(0, 6)
UIPaddingList.PaddingBottom = UDim.new(0, 6)
UIPaddingList.PaddingLeft   = UDim.new(0, 5)
UIPaddingList.PaddingRight  = UDim.new(0, 5)
UIPaddingList.Parent        = ScrollingFrame

scrollListRef = ScrollingFrame

-- ============================================================
-- PANEL 3 : SETTINGS  (caché par défaut)
-- ============================================================
local SW = isMob and 228 or 268
local SH = isMob and 280 or 340

local settingsPanel, settingsContent, settingsHdr = makePanel(
    "SettingsPanel", "SETTINGS",
    math.floor(screenW / 2 + 14),
    math.floor(screenH * 0.14),
    SW, SH, 200, 200
)
registerPanelLayout(settingsPanel, "SettingsPanel", 200, 200)
settingsPanel.Visible = false

-- bouton fermer sur le header settings
local sCloseBtn = Instance.new("TextButton")
sCloseBtn.Size             = UDim2.new(0, 18, 0, 18)
sCloseBtn.Position         = UDim2.new(1, -24, 0.5, -9)
sCloseBtn.BackgroundTransparency = 1
sCloseBtn.BorderSizePixel  = 0
sCloseBtn.ZIndex           = 15
sCloseBtn.Text             = "−"
sCloseBtn.TextColor3       = C.textMute
sCloseBtn.TextSize         = 12
sCloseBtn.Font             = Enum.Font.GothamBold
sCloseBtn.AutoButtonColor  = false
sCloseBtn.Parent           = settingsHdr
sCloseBtn.MouseButton1Click:Connect(function() settingsPanel.Visible = false end)

-- ============================================================
-- COLOUR PICKER  (style "Pick Accent" — carré SV + slider hue + hex)
-- 2 boutons dans le header : Accent et Body
-- ============================================================
local colorAppliers = {}
local function regColor(fn) table.insert(colorAppliers, fn) end

-- Couleurs courantes en HSV (pour le picker)
local cpHSV_accent = { H=0.137, S=0.69, V=0.77 }   -- ~RGB(196,168,60)
local cpHSV_body   = { H=0.63,  S=0.21, V=0.11 }   -- ~RGB(22,24,28)

local function applyTheme(newAccent, newBody)
    C.accent    = newAccent
    C.accentHi  = Color3.new(math.min(1,newAccent.R*1.14), math.min(1,newAccent.G*1.18), math.min(1,newAccent.B*1.14))
    C.body      = newBody
    C.panel     = Color3.new(math.min(1,newBody.R+0.016), math.min(1,newBody.G+0.016), math.min(1,newBody.B+0.020))
    C.card      = Color3.new(math.min(1,newBody.R+0.070), math.min(1,newBody.G+0.070), math.min(1,newBody.B+0.080))
    C.iconBg    = Color3.new(math.min(1,newBody.R+0.110), math.min(1,newBody.G+0.110), math.min(1,newBody.B+0.120))
    C.stroke    = newAccent
    C.strokeDim = Color3.new(newAccent.R*0.56, newAccent.G*0.56, newAccent.B*0.23)
    C.textMauve = C.accentHi
    C.knobOn    = Color3.new(math.min(1,newAccent.R*1.17), math.min(1,newAccent.G*1.22), math.min(1,newAccent.B*0.50))
    for _, fn in ipairs(colorAppliers) do pcall(fn) end
end

-- Helper : construit UN color picker complet dans un Frame parent
-- Retourne { frame, onPick(fn) }  — fn sera appelée avec Color3 à chaque changement
local function makePicker(titleText, initialHSV, parentFrame, pickerZIndex)
    local PW, PH = 220, 240
    local PAD = 10
    local SQ = PH - 90  -- taille du carré SV

    local frame = Instance.new("Frame")
    frame.Size              = UDim2.new(0, PW, 0, PH)
    frame.BackgroundColor3  = Color3.fromRGB(18, 20, 24)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel   = 0
    frame.ZIndex            = pickerZIndex
    frame.ClipsDescendants  = false
    frame.Visible           = false
    frame.Parent            = parentFrame
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
    local fStr = Instance.new("UIStroke", frame)
    fStr.Color = Color3.fromRGB(60,62,68); fStr.Thickness = 1.2
    regColor(function() if frame.Parent then fStr.Color=Color3.fromRGB(
        math.floor(C.accent.R*60), math.floor(C.accent.G*60), math.floor(C.accent.B*60)) end end)

    -- Titre + croix fermer
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1,-36,0,28); titleLbl.Position = UDim2.new(0,PAD,0,0)
    titleLbl.BackgroundTransparency=1; titleLbl.ZIndex=pickerZIndex+1
    titleLbl.Text=titleText; titleLbl.TextColor3=Color3.fromRGB(220,220,228)
    titleLbl.TextSize=13; titleLbl.Font=Enum.Font.GothamBold
    titleLbl.TextXAlignment=Enum.TextXAlignment.Left; titleLbl.Parent=frame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size=UDim2.new(0,22,0,22); closeBtn.Position=UDim2.new(1,-28,0,3)
    closeBtn.BackgroundColor3=Color3.fromRGB(160,40,40); closeBtn.BorderSizePixel=0
    closeBtn.ZIndex=pickerZIndex+2; closeBtn.Text="×"
    closeBtn.TextColor3=Color3.new(1,1,1); closeBtn.TextSize=14
    closeBtn.Font=Enum.Font.GothamBold; closeBtn.AutoButtonColor=false; closeBtn.Parent=frame
    Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
    closeBtn.MouseButton1Click:Connect(function() frame.Visible=false end)

    -- Carré SV
    local sq = Instance.new("Frame")
    sq.Size=UDim2.new(0,PW-PAD*2,0,SQ); sq.Position=UDim2.new(0,PAD,0,30)
    sq.BackgroundColor3=Color3.fromHSV(initialHSV.H,1,1)
    sq.BorderSizePixel=0; sq.ZIndex=pickerZIndex+1; sq.ClipsDescendants=true; sq.Parent=frame
    Instance.new("UICorner",sq).CornerRadius=UDim.new(0,8)
    -- overlay blanc (saturation)
    local wOv=Instance.new("Frame",sq)
    wOv.Size=UDim2.new(1,0,1,0); wOv.BackgroundColor3=Color3.new(1,1,1)
    wOv.BackgroundTransparency=0; wOv.BorderSizePixel=0; wOv.ZIndex=pickerZIndex+2
    local wGrad=Instance.new("UIGradient",wOv)
    wGrad.Color=ColorSequence.new(Color3.new(1,1,1),Color3.new(1,1,1))
    wGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})
    -- overlay noir (value)
    local bOv=Instance.new("Frame",sq)
    bOv.Size=UDim2.new(1,0,1,0); bOv.BackgroundColor3=Color3.new(0,0,0)
    bOv.BackgroundTransparency=0; bOv.BorderSizePixel=0; bOv.ZIndex=pickerZIndex+3
    local bGrad=Instance.new("UIGradient",bOv)
    bGrad.Rotation=90
    bGrad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)})
    -- curseur SV (cercle blanc avec bord noir)
    local svCur=Instance.new("Frame",sq)
    svCur.Size=UDim2.new(0,14,0,14); svCur.AnchorPoint=Vector2.new(0.5,0.5)
    svCur.Position=UDim2.new(initialHSV.S,0,1-initialHSV.V,0)
    svCur.BackgroundColor3=Color3.new(1,1,1); svCur.BorderSizePixel=0; svCur.ZIndex=pickerZIndex+5
    Instance.new("UICorner",svCur).CornerRadius=UDim.new(1,0)
    local svStr=Instance.new("UIStroke",svCur); svStr.Color=Color3.new(0,0,0); svStr.Thickness=2

    -- Slider hue
    local HUE_H = 14
    local hueBar=Instance.new("Frame")
    hueBar.Size=UDim2.new(0,PW-PAD*2,0,HUE_H); hueBar.Position=UDim2.new(0,PAD,0,30+SQ+8)
    hueBar.BackgroundColor3=Color3.new(1,0,0); hueBar.BorderSizePixel=0
    hueBar.ZIndex=pickerZIndex+1; hueBar.ClipsDescendants=true; hueBar.Parent=frame
    Instance.new("UICorner",hueBar).CornerRadius=UDim.new(1,0)
    local hGrad=Instance.new("UIGradient",hueBar)
    hGrad.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromHSV(0,    1,1)),
        ColorSequenceKeypoint.new(1/6,  Color3.fromHSV(1/6,  1,1)),
        ColorSequenceKeypoint.new(2/6,  Color3.fromHSV(2/6,  1,1)),
        ColorSequenceKeypoint.new(3/6,  Color3.fromHSV(3/6,  1,1)),
        ColorSequenceKeypoint.new(4/6,  Color3.fromHSV(4/6,  1,1)),
        ColorSequenceKeypoint.new(5/6,  Color3.fromHSV(5/6,  1,1)),
        ColorSequenceKeypoint.new(1,    Color3.fromHSV(1,    1,1)),
    })
    -- curseur hue (ligne blanche)
    local hueCur=Instance.new("Frame",hueBar)
    hueCur.Size=UDim2.new(0,4,1,4); hueCur.AnchorPoint=Vector2.new(0.5,0.5)
    hueCur.Position=UDim2.new(initialHSV.H,0,0.5,0)
    hueCur.BackgroundColor3=Color3.new(1,1,1); hueCur.BorderSizePixel=0; hueCur.ZIndex=pickerZIndex+3
    Instance.new("UICorner",hueCur).CornerRadius=UDim.new(0,2)
    local hcStr=Instance.new("UIStroke",hueCur); hcStr.Color=Color3.new(0,0,0); hcStr.Thickness=1

    -- Aperçu couleur + hex
    local previewY = 30+SQ+8+HUE_H+8
    local preview=Instance.new("Frame")
    preview.Size=UDim2.new(0,32,0,22); preview.Position=UDim2.new(0,PAD,0,previewY)
    preview.BackgroundColor3=Color3.fromHSV(initialHSV.H,initialHSV.S,initialHSV.V)
    preview.BorderSizePixel=0; preview.ZIndex=pickerZIndex+2; preview.Parent=frame
    Instance.new("UICorner",preview).CornerRadius=UDim.new(0,6)
    Instance.new("UIStroke",preview).Color=Color3.fromRGB(80,82,88)

    local hexLbl=Instance.new("TextLabel")
    hexLbl.Size=UDim2.new(1,-PAD*2-36,0,22); hexLbl.Position=UDim2.new(0,PAD+36+4,0,previewY)
    hexLbl.BackgroundColor3=Color3.fromRGB(28,30,34); hexLbl.BorderSizePixel=0
    hexLbl.ZIndex=pickerZIndex+2; hexLbl.Font=Enum.Font.Code; hexLbl.TextSize=11
    hexLbl.TextColor3=Color3.fromRGB(200,200,208); hexLbl.Parent=frame
    Instance.new("UICorner",hexLbl).CornerRadius=UDim.new(0,6)
    local function toHex(c)
        return string.format("#%02X%02X%02X",
            math.floor(c.R*255+.5), math.floor(c.G*255+.5), math.floor(c.B*255+.5))
    end

    -- État HSV interne
    local H,S,V = initialHSV.H, initialHSV.S, initialHSV.V
    local pickCallbacks = {}

    local function updateVisuals()
        local col = Color3.fromHSV(H,S,V)
        sq.BackgroundColor3 = Color3.fromHSV(H,1,1)
        svCur.Position = UDim2.new(S,0,1-V,0)
        hueCur.Position = UDim2.new(H,0,0.5,0)
        preview.BackgroundColor3 = col
        hexLbl.Text = "  "..toHex(col)
        for _, cb in ipairs(pickCallbacks) do pcall(cb, col) end
    end
    updateVisuals()

    -- Drag SV
    local dragSV=false
    sq.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragSV=true
            local ap=sq.AbsolutePosition; local as=sq.AbsoluteSize
            S=math.clamp((i.Position.X-ap.X)/as.X,0,1)
            V=1-math.clamp((i.Position.Y-ap.Y)/as.Y,0,1)
            updateVisuals()
        end
    end)
    -- Drag hue
    local dragH=false
    hueBar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragH=true
            local ap=hueBar.AbsolutePosition; local as=hueBar.AbsoluteSize
            H=math.clamp((i.Position.X-ap.X)/as.X,0,1)
            updateVisuals()
        end
    end)
    table.insert(ActiveConnections, UserInputService.InputChanged:Connect(function(i)
        if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end
        if dragSV then
            local ap=sq.AbsolutePosition; local as=sq.AbsoluteSize
            S=math.clamp((i.Position.X-ap.X)/as.X,0,1)
            V=1-math.clamp((i.Position.Y-ap.Y)/as.Y,0,1)
            updateVisuals()
        elseif dragH then
            local ap=hueBar.AbsolutePosition; local as=hueBar.AbsoluteSize
            H=math.clamp((i.Position.X-ap.X)/as.X,0,1)
            updateVisuals()
        end
    end))
    table.insert(ActiveConnections, UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragSV=false; dragH=false
        end
    end))

    -- Fonction pour forcer une couleur (reset)
    local function setHSV(h,s,v)
        H,S,V=h,s,v; updateVisuals()
    end

    return {
        frame    = frame,
        onPick   = function(fn) table.insert(pickCallbacks, fn) end,
        setHSV   = setHSV,
    }
end

-- ---- Bouton Accent (doré) dans le header ----
local cpBtnAccent = Instance.new("TextButton")
cpBtnAccent.Size             = UDim2.new(0, 14, 0, 14)
cpBtnAccent.Position         = UDim2.new(1, -66, 0.5, -7)
cpBtnAccent.BackgroundColor3 = C.accent
cpBtnAccent.BorderSizePixel  = 0
cpBtnAccent.ZIndex           = 16
cpBtnAccent.Text             = ""
cpBtnAccent.AutoButtonColor  = false
cpBtnAccent.Parent           = settingsHdr
Instance.new("UICorner", cpBtnAccent).CornerRadius = UDim.new(1,0)
local cpBtnAs = Instance.new("UIStroke",cpBtnAccent)
cpBtnAs.Color=Color3.new(1,1,1); cpBtnAs.Thickness=1.2
regColor(function() if cpBtnAccent.Parent then cpBtnAccent.BackgroundColor3=C.accent end end)

-- ---- Bouton Body (fond) dans le header ----
local cpBtnBody = Instance.new("TextButton")
cpBtnBody.Size             = UDim2.new(0, 14, 0, 14)
cpBtnBody.Position         = UDim2.new(1, -48, 0.5, -7)
cpBtnBody.BackgroundColor3 = C.body
cpBtnBody.BorderSizePixel  = 0
cpBtnBody.ZIndex           = 16
cpBtnBody.Text             = ""
cpBtnBody.AutoButtonColor  = false
cpBtnBody.Parent           = settingsHdr
Instance.new("UICorner", cpBtnBody).CornerRadius = UDim.new(1,0)
local cpBtnBs = Instance.new("UIStroke",cpBtnBody)
cpBtnBs.Color=Color3.new(1,1,1); cpBtnBs.Thickness=1.2
regColor(function() if cpBtnBody.Parent then cpBtnBody.BackgroundColor3=C.body end end)

-- ---- Crée les 2 pickers ----
-- Picker Accent : apparaît ancré sous le header, décalé à gauche
local pickerAccentObj = makePicker("Pick Accent", cpHSV_accent, settingsPanel, 70)
pickerAccentObj.frame.Position = UDim2.new(1, -230, 0, HEADER_H + 4)
pickerAccentObj.onPick(function(col)
    cpHSV_accent.H, cpHSV_accent.S, cpHSV_accent.V = Color3.toHSV(col)
    applyTheme(col, C.body)
end)

-- Picker Body : apparaît en dessous du picker accent
local pickerBodyObj = makePicker("Pick Background", cpHSV_body, settingsPanel, 70)
pickerBodyObj.frame.Position = UDim2.new(1, -230, 0, HEADER_H + 4)
pickerBodyObj.onPick(function(col)
    cpHSV_body.H, cpHSV_body.S, cpHSV_body.V = Color3.toHSV(col)
    applyTheme(C.accent, col)
end)

-- Toggle : un seul picker visible à la fois
cpBtnAccent.MouseButton1Click:Connect(function()
    local wasVisible = pickerAccentObj.frame.Visible
    pickerAccentObj.frame.Visible = false
    pickerBodyObj.frame.Visible   = false
    if not wasVisible then pickerAccentObj.frame.Visible = true end
end)
cpBtnBody.MouseButton1Click:Connect(function()
    local wasVisible = pickerBodyObj.frame.Visible
    pickerAccentObj.frame.Visible = false
    pickerBodyObj.frame.Visible   = false
    if not wasVisible then pickerBodyObj.frame.Visible = true end
end)
sCloseBtn.MouseButton1Click:Connect(function()
    pickerAccentObj.frame.Visible = false
    pickerBodyObj.frame.Visible   = false
end)

-- ---- Scan post-création : enregistre tous les éléments à recolorer ----
task.defer(function()
    local gui = NOX_SCRIPT_GUI
    if not gui then return end
    local oA = Color3.fromRGB(196,168,60)
    local oB = Color3.fromRGB(22,24,28)
    local oP = Color3.fromRGB(26,28,32)
    local oC = Color3.fromRGB(40,42,48)
    local oI = Color3.fromRGB(50,52,58)
    local oD = Color3.fromRGB(110,95,45)
    local function near(a,b)
        return math.abs(a.R-b.R) < 0.045 and math.abs(a.G-b.G) < 0.045 and math.abs(a.B-b.B) < 0.045
    end
    for _, inst in ipairs(gui:GetDescendants()) do
        pcall(function()
            if inst:IsA("UIStroke") then
                if near(inst.Color, oA) then
                    regColor(function()
                        if inst.Parent then inst.Color = C.accent end
                    end)
                elseif near(inst.Color, oD) then
                    regColor(function()
                        if inst.Parent then inst.Color = C.strokeDim end
                    end)
                end
            elseif inst:IsA("Frame") then
                local bg = inst.BackgroundColor3
                if near(bg, oA) then
                    regColor(function()
                        if inst.Parent then inst.BackgroundColor3 = C.accent end
                    end)
                elseif near(bg, oB) then
                    regColor(function()
                        if inst.Parent then inst.BackgroundColor3 = C.body end
                    end)
                elseif near(bg, oP) then
                    regColor(function()
                        if inst.Parent then inst.BackgroundColor3 = C.panel end
                    end)
                elseif near(bg, oC) then
                    regColor(function()
                        if inst.Parent then inst.BackgroundColor3 = C.card end
                    end)
                elseif near(bg, oI) then
                    regColor(function()
                        if inst.Parent then inst.BackgroundColor3 = C.iconBg end
                    end)
                end
            elseif inst:IsA("ScrollingFrame") then
                if near(inst.ScrollBarImageColor3, oA) then
                    regColor(function()
                        if inst.Parent then inst.ScrollBarImageColor3 = C.accent end
                    end)
                end
            elseif inst:IsA("TextButton") or inst:IsA("TextLabel") then
                if near(inst.TextColor3, oA) then
                    regColor(function()
                        if inst.Parent then inst.TextColor3 = C.accent end
                    end)
                end
            elseif inst:IsA("UIGradient") then
                local hasAcc = false
                for _, kp in ipairs(inst.Color.Keypoints) do
                    if near(kp.Value, oA) then
                        hasAcc = true
                        break
                    end
                end
                if hasAcc then
                    regColor(function()
                        if inst.Parent then
                            inst.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, C.textBright),
                                ColorSequenceKeypoint.new(0.5, C.textMauve),
                                ColorSequenceKeypoint.new(1, C.textBright),
                            })
                        end
                    end)
                end
            end
        end)
    end
end)
-- ============================================================

local TABBAR_H = 30

local tabBar = Instance.new("Frame")
tabBar.Name             = "TabBar"
tabBar.Size             = UDim2.new(1, -4, 0, TABBAR_H)
tabBar.Position         = UDim2.new(0, 2, 0, 2)
tabBar.BackgroundTransparency = 1
tabBar.BorderSizePixel  = 0
tabBar.ZIndex           = 6
tabBar.Parent           = settingsContent

local tabListLayout = Instance.new("UIListLayout")
tabListLayout.FillDirection      = Enum.FillDirection.Horizontal
tabListLayout.HorizontalAlignment= Enum.HorizontalAlignment.Center
tabListLayout.VerticalAlignment  = Enum.VerticalAlignment.Center
tabListLayout.SortOrder          = Enum.SortOrder.LayoutOrder
tabListLayout.Padding            = UDim.new(0, 4)
tabListLayout.Parent             = tabBar

local tabButtons = {}
local tabFrames  = {}
local function selectTab(key)
    for k, frame in pairs(tabFrames) do
        frame.Visible = (k == key)
    end
    for k, btn in pairs(tabButtons) do
        local active = (k == key)
        TweenService:Create(btn, TweenInfo.new(0.12), {
            BackgroundTransparency = active and 0.2 or 0.7,
        }):Play()
        local bs = btn:FindFirstChildOfClass("UIStroke")
        if bs then
            TweenService:Create(bs, TweenInfo.new(0.12), {
                Color = active and C.accent or C.strokeDim,
                Transparency = active and 0 or 0.4,
            }):Play()
        end
        local lbl = btn:FindFirstChildOfClass("TextLabel")
        if lbl then lbl.TextColor3 = active and C.textBright or C.textMute end
    end
end

local function makeTab(key, label, order)
    local btn = Instance.new("TextButton")
    btn.Name                  = "Tab_" .. key
    btn.Size                  = UDim2.new(0, 0, 1, 0)
    btn.AutomaticSize         = Enum.AutomaticSize.X
    btn.BackgroundColor3      = C.card
    btn.BackgroundTransparency = 0.7
    btn.BorderSizePixel       = 0
    btn.ZIndex                = 7
    btn.Text                  = ""
    btn.AutoButtonColor       = false
    btn.LayoutOrder           = order
    btn.Parent                = tabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    local bs = Instance.new("UIStroke", btn)
    bs.Color = C.strokeDim
    bs.Thickness = 1
    bs.Transparency = 0.4
    local pad = Instance.new("UIPadding", btn)
    pad.PaddingLeft  = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    local lbl = Instance.new("TextLabel")
    lbl.Size               = UDim2.new(0, 0, 1, 0)
    lbl.AutomaticSize      = Enum.AutomaticSize.X
    lbl.BackgroundTransparency = 1
    lbl.ZIndex             = 8
    lbl.Text               = label
    lbl.TextColor3         = C.textMute
    lbl.TextSize           = 10
    lbl.Font               = Enum.Font.GothamBold
    lbl.Parent             = btn

    local frame = Instance.new("ScrollingFrame")
    frame.Name                  = "Tab_" .. key .. "_Content"
    frame.Size                  = UDim2.new(1, -4, 1, -(TABBAR_H + 6))
    frame.Position              = UDim2.new(0, 2, 0, TABBAR_H + 4)
    frame.BackgroundTransparency= 1
    frame.BorderSizePixel       = 0
    frame.CanvasSize            = UDim2.new(0, 0, 0, 0)
    frame.ScrollBarThickness    = 3
    frame.ScrollBarImageColor3  = C.accent
    frame.ScrollingDirection    = Enum.ScrollingDirection.Y
    frame.AutomaticCanvasSize   = Enum.AutomaticSize.Y
    frame.Visible               = false
    frame.Parent                = settingsContent

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder           = Enum.SortOrder.LayoutOrder
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.Padding             = UDim.new(0, 4)
    listLayout.Parent              = frame

    local padding = Instance.new("UIPadding")
    padding.PaddingTop    = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft   = UDim.new(0, 8)
    padding.PaddingRight  = UDim.new(0, 8)
    padding.Parent        = frame

    btn.MouseButton1Click:Connect(function() selectTab(key) end)
    tabButtons[key] = btn
    tabFrames[key]  = frame
    return frame
end

makeTab("reset", "RESET", 1)
makeTab("block", "BLOCK", 2)
makeTab("flash", "FLASH TP", 3)
makeTab("misc",  "MISC", 4)
makeTab("visual","VISUAL", 5)
local ScrollReset, ScrollBlock, ScrollFlash, ScrollMisc, ScrollVisual =
    tabFrames.reset, tabFrames.block, tabFrames.flash, tabFrames.misc, tabFrames.visual
selectTab("reset")

local sectionOrder = 0
local toggleRefs   = {}

local function sectionHeader(parent, text)
    sectionOrder += 1
    local wrap = Instance.new("Frame")
    wrap.Size             = UDim2.new(1, 0, 0, 22)
    wrap.BackgroundTransparency = 1
    wrap.BorderSizePixel  = 0
    wrap.ZIndex           = 4
    wrap.LayoutOrder      = sectionOrder
    wrap.Parent           = parent
    local line = Instance.new("Frame")
    line.Size             = UDim2.new(1, 0, 0, 1)
    line.Position         = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = C.stroke
    line.BorderSizePixel  = 0
    line.ZIndex           = 5
    line.Parent           = wrap
    local pill = Instance.new("Frame")
    pill.Size             = UDim2.new(0, 0, 1, 0)
    pill.Position         = UDim2.new(0.5, 0, 0, 0)
    pill.AnchorPoint      = Vector2.new(0.5, 0)
    pill.BackgroundColor3 = C.panel
    pill.BorderSizePixel  = 0
    pill.ZIndex           = 6
    pill.AutomaticSize    = Enum.AutomaticSize.X
    pill.Parent           = wrap
    Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 5)
    local lbl = Instance.new("TextLabel")
    lbl.Size                = UDim2.new(1, 8, 1, 0)
    lbl.Position           = UDim2.new(0, -4, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.ZIndex             = 7
    lbl.Text               = text
    lbl.TextColor3         = C.textMute
    lbl.TextSize           = 10
    lbl.Font               = Enum.Font.GothamBold
    lbl.Parent             = pill
    return wrap
end

local function toggleRow(parent, title, defaultOn, onToggle)
    sectionOrder += 1
    local row = Instance.new("Frame")
    row.Size              = UDim2.new(0.92, 0, 0, 32)
    row.AnchorPoint         = Vector2.new(0.5, 0)
    row.Position           = UDim2.new(0.5, 0, 0, 0)
    row.BackgroundColor3  = C.card
    row.BackgroundTransparency = 0.6
    row.BorderSizePixel   = 0
    row.ZIndex            = 4
    row.LayoutOrder       = sectionOrder
    row.Parent            = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(1, 0)
    local s = Instance.new("UIStroke", row)
    s.Color = C.strokeDim
    s.Thickness = 1
    s.Transparency = 0.35

    local t1 = Instance.new("TextLabel")
    t1.Size               = UDim2.new(1, -50, 1, 0)
    t1.Position           = UDim2.new(0, 10, 0, 0)
    t1.BackgroundTransparency = 1
    t1.ZIndex             = 5
    t1.Text               = title
    t1.TextColor3         = C.textBright
    t1.TextSize           = 12
    t1.Font               = Enum.Font.GothamMedium
    t1.TextXAlignment     = Enum.TextXAlignment.Left
    t1.Parent             = row

    local track = Instance.new("Frame")
    track.Size             = UDim2.new(0, 34, 0, 18)
    track.Position         = UDim2.new(1, -40, 0.5, -9)
    track.BackgroundColor3 = C.accent
    track.BorderSizePixel  = 0
    track.ZIndex           = 6
    track.Parent           = row
    Instance.new("UICorner", track).CornerRadius = UDim.new(0, 9)
    local ts = Instance.new("UIStroke", track); ts.Color = C.accent

    local knob = Instance.new("Frame")
    knob.Size             = UDim2.new(0, 12, 0, 12)
    knob.Position         = UDim2.new(0, 18, 0.5, -6)
    knob.BackgroundColor3 = C.knobOn
    knob.BorderSizePixel  = 0
    knob.ZIndex           = 7
    knob.Parent           = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 6)

    local hit = Instance.new("TextButton")
    hit.Size               = UDim2.new(1, 0, 1, 0)
    hit.BackgroundTransparency = 1
    hit.ZIndex             = 8
    hit.Text               = ""
    hit.Parent             = row

    local ref = { on = defaultOn ~= false, track = track, stroke = ts, knob = knob }
    local function render(animate)
        local info = TweenInfo.new(animate and 0.14 or 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        if ref.on then
            TweenService:Create(track, info, { BackgroundColor3 = C.accent   }):Play()
            TweenService:Create(ts,    info, { Color            = C.accent   }):Play()
            TweenService:Create(knob,  info, { Position = UDim2.new(0, 18, 0.5, -6), BackgroundColor3 = C.knobOn  }):Play()
        else
            TweenService:Create(track, info, { BackgroundColor3 = C.trackOff }):Play()
            TweenService:Create(ts,    info, { Color            = C.stroke   }):Play()
            TweenService:Create(knob,  info, { Position = UDim2.new(0, 3,  0.5, -6), BackgroundColor3 = C.knobOff }):Play()
        end
    end
    ref.render = render
    render(false)
    if onToggle then task.defer(function() pcall(onToggle, ref.on) end) end
    hit.MouseButton1Click:Connect(function()
        ref.on = not ref.on
        render(true)
        if onToggle then pcall(onToggle, ref.on) end
        saveSettings()
    end)
    table.insert(toggleRefs, ref)
    return row, ref
end

local function dropdownRow(parent, title, options, defaultValue, onSelect)
    sectionOrder += 1
    local row = Instance.new("Frame")
    row.Size              = UDim2.new(0.92, 0, 0, 32)
    row.AnchorPoint        = Vector2.new(0.5, 0)
    row.Position           = UDim2.new(0.5, 0, 0, 0)
    row.BackgroundColor3  = C.card
    row.BackgroundTransparency = 0.6
    row.BorderSizePixel    = 0
    row.ZIndex            = 4
    row.LayoutOrder       = sectionOrder
    row.ClipsDescendants  = false
    row.Parent            = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(1, 0)
    local s = Instance.new("UIStroke", row)
    s.Color = C.strokeDim
    s.Thickness = 1
    s.Transparency = 0.35

    local t1 = Instance.new("TextLabel")
    t1.Size               = UDim2.new(1, -120, 1, 0)
    t1.Position           = UDim2.new(0, 10, 0, 0)
    t1.BackgroundTransparency = 1
    t1.ZIndex             = 5
    t1.Text               = title
    t1.TextColor3         = C.textBright
    t1.TextSize           = 12
    t1.Font               = Enum.Font.GothamMedium
    t1.TextXAlignment     = Enum.TextXAlignment.Left
    t1.Parent             = row

    local selectorBtn = Instance.new("TextButton")
    selectorBtn.Size               = UDim2.new(0, 104, 0, 22)
    selectorBtn.Position           = UDim2.new(1, -112, 0.5, -11)
    selectorBtn.BackgroundColor3   = C.iconBg
    selectorBtn.BorderSizePixel    = 0
    selectorBtn.ZIndex             = 6
    selectorBtn.Text               = defaultValue
    selectorBtn.TextColor3         = C.textBright
    selectorBtn.TextSize           = 11
    selectorBtn.TextTruncate       = Enum.TextTruncate.AtEnd
    selectorBtn.Font               = Enum.Font.GothamBold
    selectorBtn.AutoButtonColor    = false
    selectorBtn.Parent             = row
    Instance.new("UICorner", selectorBtn).CornerRadius = UDim.new(0, 6)
    local selStroke = Instance.new("UIStroke", selectorBtn); selStroke.Color = C.accent

    local arrow = Instance.new("TextLabel")
    arrow.Size               = UDim2.new(0, 16, 1, 0)
    arrow.Position           = UDim2.new(1, -18, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.ZIndex             = 7
    arrow.Text               = "v"
    arrow.TextColor3         = C.accent
    arrow.TextSize           = 11
    arrow.Font               = Enum.Font.GothamBold
    arrow.Parent             = selectorBtn

    local list = Instance.new("Frame")
    list.Name              = "DropList"
    list.Size              = UDim2.new(0, 104, 0, #options * 24)
    list.BackgroundColor3   = C.panel
    list.BorderSizePixel    = 0
    list.ZIndex             = 50
    list.Visible            = false
    list.Parent             = settingsPanel
    Instance.new("UICorner", list).CornerRadius = UDim.new(0, 6)
    local listStroke = Instance.new("UIStroke", list); listStroke.Color = C.accent; listStroke.Thickness = 1

    local listLayout2 = Instance.new("UIListLayout")
    listLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout2.Parent    = list

    local open = false
    local function setOpen(state)
        open = state
        if state then
            local abs = selectorBtn.AbsolutePosition
            local panelAbs = settingsPanel.AbsolutePosition
            list.Position = UDim2.new(0, abs.X - panelAbs.X, 0, abs.Y - panelAbs.Y + selectorBtn.AbsoluteSize.Y + 4)
        end
        list.Visible = state
        arrow.Text   = state and "^" or "v"
    end

    for i, optName in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size               = UDim2.new(1, 0, 0, 24)
        optBtn.BackgroundColor3   = C.card
        optBtn.BackgroundTransparency = (optName == defaultValue) and 0 or 1
        optBtn.BorderSizePixel    = 0
        optBtn.ZIndex             = 51
        optBtn.Text               = optName
        optBtn.TextColor3         = C.textBright
        optBtn.TextSize           = 10
        optBtn.TextTruncate       = Enum.TextTruncate.AtEnd
        optBtn.Font               = Enum.Font.GothamMedium
        optBtn.AutoButtonColor    = false
        optBtn.LayoutOrder        = i
        optBtn.Parent             = list
        optBtn.MouseButton1Click:Connect(function()
            selectorBtn.Text = optName
            for _, child in ipairs(list:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundTransparency = (child == optBtn) and 0 or 1
                end
            end
            setOpen(false)
            if onSelect then pcall(onSelect, optName) end
            saveSettings()
        end)
    end

    selectorBtn.MouseButton1Click:Connect(function()
        setOpen(not open)
    end)

    if onSelect then task.defer(function() pcall(onSelect, defaultValue) end) end

    return row
end

-- ============================================================
-- OUVERTURE SETTINGS : Ctrl Gauche (PC) ou bouton (mobile)
-- ============================================================
local settingsOpen = false
local function toggleSettings()
    settingsOpen = not settingsOpen
    settingsPanel.Visible = settingsOpen
end

if DEVICE == "pc" then
    local ctrlConn = UserInputService.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == Enum.KeyCode.LeftControl then toggleSettings() end
    end)
    table.insert(ActiveConnections, ctrlConn)
end

if isMob then
    local mBtn = Instance.new("TextButton")
    mBtn.Name             = "SettingsBtn"
    mBtn.Size             = UDim2.new(0, 36, 0, 36)
    mBtn.Position         = UDim2.new(1, -46, 0, 10)
    mBtn.BackgroundColor3 = C.card
    mBtn.BorderSizePixel  = 0
    mBtn.ZIndex           = 20
    mBtn.Text             = "⚙"
    mBtn.TextColor3       = C.accent
    mBtn.TextSize         = 18
    mBtn.Font             = Enum.Font.GothamBold
    mBtn.AutoButtonColor  = false
    mBtn.Parent           = NOX_SCRIPT_GUI
    Instance.new("UICorner", mBtn).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", mBtn).Color = C.stroke
    makeDraggable(mBtn)
    mBtn.MouseButton1Click:Connect(toggleSettings)
end

-- dummy TextLabel (référencé en bas du script)
local TextLabel = Instance.new("TextLabel")
TextLabel.Visible = false
TextLabel.Parent  = NOX_SCRIPT_GUI


-- ============================================================
-- PANEL 4 : QUICK ADMIN PANEL
-- ============================================================
local QW = isMob and 300 or 340
local QH = isMob and 220 or 260
local qapPanel, qapContent, qapHdr = makePanel(
    "QuickAPPanel", "QUICK ADMIN PANEL",
    math.floor(screenW / 2 - QW / 2),
    math.floor(screenH * 0.6),
    QW, QH, 280, 60
)
registerPanelLayout(qapPanel, "QuickAPPanel", 280, 60)
qapPanel.Visible = _G.QuickAP or false

local qapPlayerScroll = Instance.new("ScrollingFrame")
qapPlayerScroll.Name = "PlayerList"
qapPlayerScroll.Size = UDim2.new(1, -16, 1, -28)
qapPlayerScroll.Position = UDim2.new(0, 6, 0, 6)
qapPlayerScroll.BackgroundTransparency = 1
qapPlayerScroll.ScrollBarThickness = 3
qapPlayerScroll.ScrollBarImageColor3 = C.accent
qapPlayerScroll.BorderSizePixel = 0
qapPlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
qapPlayerScroll.ScrollingDirection = Enum.ScrollingDirection.Y
qapPlayerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
qapPlayerScroll.Parent = qapContent

local qapListLayout = Instance.new("UIListLayout")
qapListLayout.Padding = UDim.new(0, 6)
qapListLayout.SortOrder = Enum.SortOrder.LayoutOrder
qapListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
qapListLayout.Parent = qapPlayerScroll

local qapNoTargetLabel = Instance.new("TextLabel")
qapNoTargetLabel.Size = UDim2.new(1, 0, 0, 28)
qapNoTargetLabel.Position = UDim2.new(0, 0, 0, 0)
qapNoTargetLabel.BackgroundTransparency = 1
qapNoTargetLabel.Text = "Aucun joueur trouvé"
qapNoTargetLabel.Font = Enum.Font.GothamMedium
qapNoTargetLabel.TextColor3 = C.textMute
qapNoTargetLabel.TextSize = 12
qapNoTargetLabel.TextXAlignment = Enum.TextXAlignment.Center
qapNoTargetLabel.Parent = qapPlayerScroll

-- === LOGIQUE QUICK AP ===
local adminCommands = {
    { name = "tiny",    emoji = "🤏" },
    { name = "jail",    emoji = "🔒" },
    { name = "rocket",  emoji = "🚀" },
    { name = "ragdoll", emoji = "🏃" },
    { name = "balloon", emoji = "🎈" },
}

local qapCooldownBtns = {}
for _, cmd in ipairs(adminCommands) do qapCooldownBtns[cmd.name] = {} end

local function qapGetInGameScrollFrame()
    local ok, sf = pcall(function() return LocalPlayer.PlayerGui.AdminPanel.AdminPanel.Content.ScrollingFrame end)
    return ok and sf or nil
end

local function qapIsOnCooldown(cmdName)
    local sf = qapGetInGameScrollFrame()
    if not sf then return false end
    local timer = sf:FindFirstChild(cmdName) and sf[cmdName]:FindFirstChild("Timer")
    return timer and timer.Visible == true
end

local function qapGetCooldownText(cmdName)
    local sf = qapGetInGameScrollFrame()
    if not sf then return nil end
    local timer = sf:FindFirstChild(cmdName) and sf[cmdName]:FindFirstChild("Timer")
    return timer and timer.Visible and timer.Text or ""
end

-- TextBox récupérée une seule fois au démarrage (même logique que le fix)
local _qapTextBox = nil
task.spawn(function()
    local ok, tb = pcall(function()
        return LocalPlayer.PlayerGui
            :WaitForChild("AdminPanel")
            :WaitForChild("AdminPanel")
            :WaitForChild("CommandBox")
            :WaitForChild("TextBox")
    end)
    if ok and tb then
        _qapTextBox = tb
    else
        warn("[QuickAP] TextBox introuvable — AdminPanel non chargé ?")
    end
end)

-- ExecuteCommand(cmd, playerName) — playerName est une string
local function ExecuteCommand(cmd, playerName)
    warn('[EL2B HUB] Commandes AdminPanel désactivées : aucune commande n’est injectée.')
    return false
end
-- Wrapper pour les boutons du QAP (prend un objet player)
local function qapRunCommand(commandName, target)
    if not target then return end
    ExecuteCommand(commandName, target.Name)
end

-- ==========================================
-- RAGDOLL BYPASS : hook Giant Potion Activated
-- ==========================================
local function hookGiantPotion(tool)
    if tool.Name ~= "Giant Potion" then return end
    tool.Activated:Connect(function()
        if not _G.RagdollBypass then return end
        if not autoStealEnabled then return end
        task.spawn(function()
            ExecuteCommand("ragdoll", LocalPlayer.Name)
        end)
    end)
end

local function hookCharForGiant(char)
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then hookGiantPotion(child) end
    end
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then hookGiantPotion(child) end
    end)
end

local function hookBackpackForGiant(bp)
    for _, child in ipairs(bp:GetChildren()) do
        if child:IsA("Tool") then hookGiantPotion(child) end
    end
    bp.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then hookGiantPotion(child) end
    end)
end

task.spawn(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    hookCharForGiant(char)
    local bp = LocalPlayer:WaitForChild("Backpack")
    hookBackpackForGiant(bp)
end)

table.insert(ActiveConnections, LocalPlayer.CharacterAdded:Connect(function(newChar)
    hookCharForGiant(newChar)
    local bp = LocalPlayer:WaitForChild("Backpack")
    hookBackpackForGiant(bp)
end))


local function createQAPPlayerRow(plr, order)
    local row = Instance.new("Frame")
    row.Name = "QAP_" .. plr.Name
    row.Size = UDim2.new(1, -8, 0, 40)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0.6
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = qapPlayerScroll
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    
    local rs = Instance.new("UIStroke", row)
    rs.Color = C.strokeDim
    rs.Thickness = 1
    rs.Transparency = 0.35

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 26, 0, 26)
    avatar.Position = UDim2.new(0, 8, 0.5, -13)
    avatar.BackgroundTransparency = 1
    avatar.Parent = row
    Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
    
    task.spawn(function()
        local content, isReady = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        if isReady and avatar.Parent then avatar.Image = content end
    end)

    local displayText = plr.DisplayName
    if plr.DisplayName ~= plr.Name then
        displayText = plr.DisplayName .. " (@" .. plr.Name .. ")"
    end

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0, 120, 1, 0)
    nameLbl.Position = UDim2.new(0, 42, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = displayText
    nameLbl.Font = Enum.Font.GothamMedium
    nameLbl.TextColor3 = C.textBright
    nameLbl.TextSize = 11
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    nameLbl.Parent = row

    local btnSize = 26
    local btnGap = 4
    local startX = 166 -- Ajustement pour alignement à droite (à ajuster selon QW)

    for i, cmd in ipairs(adminCommands) do
        local btn = Instance.new("TextButton")
        btn.Name = "Cmd_" .. cmd.name
        btn.Size = UDim2.new(0, btnSize, 0, btnSize)
        -- Ancrage à droite pour que la liste des boutons s'étende proprement
        btn.AnchorPoint = Vector2.new(1, 0.5)
        btn.Position = UDim2.new(1, -((#adminCommands - i) * (btnSize + btnGap) + 8), 0.5, 0)
        btn.BackgroundColor3 = C.card
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 0
        btn.Text = cmd.emoji
        btn.TextSize = 13
        btn.Font = Enum.Font.SourceSans
        btn.AutoButtonColor = false
        btn.Parent = row
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        local bs = Instance.new("UIStroke", btn)
        bs.Color = C.strokeDim
        bs.Thickness = 1
        bs.Transparency = 0.35

        table.insert(qapCooldownBtns[cmd.name], { btn, cmd.emoji, bs })

        btn.MouseEnter:Connect(function()
            if not qapIsOnCooldown(cmd.name) then 
                TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = 0.2 }):Play()
                TweenService:Create(bs, TweenInfo.new(0.12), { Color = C.accent, Transparency = 0 }):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if not qapIsOnCooldown(cmd.name) then 
                TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = 0.5 }):Play()
                TweenService:Create(bs, TweenInfo.new(0.12), { Color = C.strokeDim, Transparency = 0.35 }):Play()
            end
        end)

        local function fireCommand()
            if qapIsOnCooldown(cmd.name) then return end
            task.spawn(function() qapRunCommand(cmd.name, plr) end)
            TweenService:Create(btn, TweenInfo.new(0.08), { BackgroundColor3 = C.accentHi }):Play()
            task.delay(0.2, function() 
                TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = C.card }):Play() 
            end)
        end

        btn.MouseButton1Click:Connect(fireCommand)
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then fireCommand() end
        end)
    end
    return row
end

local function refreshQAPPlayers()
    for _, cmd in ipairs(adminCommands) do qapCooldownBtns[cmd.name] = {} end
    for _, child in ipairs(qapPlayerScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local order = 1
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            createQAPPlayerRow(plr, order)
            order = order + 1
        end
    end
    qapNoTargetLabel.Visible = (order == 1)
end

Players.PlayerAdded:Connect(function() task.wait(0.3) refreshQAPPlayers() end)
Players.PlayerRemoving:Connect(function(plr)
    task.wait(0.3)
    refreshQAPPlayers()
end)

task.defer(refreshQAPPlayers)

task.spawn(function()
    while task.wait(0.25) do
        if thisScriptStopped then break end
        if not qapPanel.Visible then continue end
        
        for _, cmd in ipairs(adminCommands) do
            local onCD  = qapIsOnCooldown(cmd.name)
            local cdTxt = onCD and qapGetCooldownText(cmd.name) or nil
            
            for _, entry in ipairs(qapCooldownBtns[cmd.name]) do
                local btn, emoji, bs = entry[1], entry[2], entry[3]
                if btn and btn.Parent then
                    if onCD and cdTxt then
                        btn.Text = cdTxt
                        btn.TextSize = 10
                        btn.TextColor3 = Color3.fromRGB(200, 80, 80)
                        btn.BackgroundTransparency = 0.8
                        if bs then
                            bs.Color = C.strokeDim
                            bs.Transparency = 0.6
                        end
                    else
                        btn.Text = emoji
                        btn.TextSize = 13
                        btn.TextColor3 = C.textBright
                        btn.BackgroundTransparency = 0.5
                    end
                end
            end
        end
    end
end)


-- ============================================================
-- CONTENU SETTINGS : toggles
-- ============================================================
settingsGetters = {
    AutoResetOnBalloon = function() return _G.AutoResetOnBalloon end,
    AutoFlashTP        = function() return _G.AutoFlashTP end,
    RagdollBypass      = function() return _G.RagdollBypass end,

    AutoGiant          = function() return _G.AutoGiant end,
    AutoBlock          = function() return _G.AutoBlock end,
    BlockMode          = function() return _G.BlockMode end,
    AntiRagdoll        = function() return antiRagdollEnabled    end,
    AutoBalloon        = function() return _G.AutoBalloon end,
    AutoLaser          = function() return _G.AutoLaser end,
    AutoSelectBest     = function() return _G.AutoSelectBest end,
    AutoResetTiny      = function() return _G.AutoResetTiny end,
    AutoResetJail      = function() return _G.AutoResetJail end,
    APESP              = function() return _G.APESP end,
    EspTimer           = function() return _G.EspTimer end,
    AutoFlashLowTimer  = function() return _G.AutoFlashLowTimer end,
    QuickAP            = function() return _G.QuickAP end,
    AutoReturnBase     = function() return _G.AutoReturnBase end,
    BrainrotHighlight  = function() return _G.BrainrotHighlight end,
    TpPathVisual       = function() return _G.TpPathVisual end,
    WalkItem           = function() return _G.WalkItem end,
    BackpackESP        = function() return _G.BackpackESP end,
    ShowAPESP          = function() return _G.ShowAPESP end,
    ShowGiantPotion    = function() return _G.ShowGiantPotion end,
    ShowFlashTeleport  = function() return _G.ShowFlashTeleport end,
    ShowFlyingCarpet   = function() return _G.ShowFlyingCarpet end,
    Aimbot                             = function() return _G.AimbotEnabled or false end,
    QuickPickup                        = function() return _G.QuickPickup or false end,
    LaggerOnFlash                      = function() return _G.LaggerOnFlash or false end,
    LaggerPower                        = function() return _G.LaggerPower or 50 end,
}

-- ===== TAB: RESET =====
sectionHeader(ScrollReset, "  AUTO RESET  ")
toggleRow(ScrollReset, "Reset On Balloon", _G.AutoResetOnBalloon, function(v)
    _G.AutoResetOnBalloon = v
end)
toggleRow(ScrollReset, "Reset On Tiny", _G.AutoResetTiny, function(v)
    _G.AutoResetTiny = v
    TinyState.Enabled = v
    if v then startAutoResetTiny() else stopAutoResetTiny() end
end)
toggleRow(ScrollReset, "Reset On Jail", _G.AutoResetJail, function(v)
    _G.AutoResetJail = v
    JailState.Enabled = v
    if v then startAutoResetJail() else stopAutoResetJail() end
end)

-- ===== TAB: BLOCK =====
sectionHeader(ScrollBlock, "  BLOCK  ")
toggleRow(ScrollBlock, "Auto Block", _G.AutoBlock, function(v)
    _G.AutoBlock = v
end)

-- Sélecteur de mode : Normal / Fast / Very Fast
do
    local modes = { {key="normal", label="NORMAL"}, {key="fast", label="FAST"}, {key="veryfast", label="VERY FAST"} }
    local modeButtons = {}

    local function refreshModeButtons()
        for _, info in ipairs(modes) do
            local btn = modeButtons[info.key]
            if not btn then continue end
            local active = (_G.BlockMode == info.key)
            TweenService:Create(btn, TweenInfo.new(0.12), {
                BackgroundTransparency = active and 0.2 or 0.7,
            }):Play()
            local bs = btn:FindFirstChildOfClass("UIStroke")
            if bs then
                TweenService:Create(bs, TweenInfo.new(0.12), {
                    Color = active and C.accent or C.strokeDim,
                    Transparency = active and 0 or 0.35,
                }):Play()
            end
            local lbl2 = btn:FindFirstChildOfClass("TextLabel")
            if lbl2 then
                lbl2.TextColor3 = active and C.accent or C.textMute
            end
        end
    end

    for i, info in ipairs(modes) do
        sectionOrder += 1
        local mbtn = Instance.new("TextButton")
        mbtn.Name                  = "ModeBtn_" .. info.key
        mbtn.Size                  = UDim2.new(0.92, 0, 0, 26)
        mbtn.AnchorPoint           = Vector2.new(0.5, 0)
        mbtn.Position              = UDim2.new(0.5, 0, 0, 0)
        mbtn.BackgroundColor3      = C.card
        mbtn.BackgroundTransparency = 0.6
        mbtn.BorderSizePixel       = 0
        mbtn.ZIndex                = 6
        mbtn.Text                  = ""
        mbtn.AutoButtonColor       = false
        mbtn.LayoutOrder           = sectionOrder
        mbtn.Parent                = ScrollBlock
        Instance.new("UICorner", mbtn).CornerRadius = UDim.new(1, 0)
        local mbs = Instance.new("UIStroke", mbtn)
        mbs.Color       = C.strokeDim
        mbs.Thickness   = 1
        mbs.Transparency = 0.35

        local mlbl = Instance.new("TextLabel")
        mlbl.Size               = UDim2.new(1, -8, 1, 0)
        mlbl.Position           = UDim2.new(0, 4, 0, 0)
        mlbl.BackgroundTransparency = 1
        mlbl.ZIndex             = 7
        mlbl.Text               = info.label
        mlbl.TextColor3         = C.textMute
        mlbl.TextSize           = isMob and 11 or 12
        mlbl.Font               = Enum.Font.GothamBold
        mlbl.TextXAlignment     = Enum.TextXAlignment.Center
        mlbl.TextYAlignment     = Enum.TextYAlignment.Center
        mlbl.Parent             = mbtn

        modeButtons[info.key] = mbtn
        mbtn.MouseButton1Click:Connect(function()
            _G.BlockMode = info.key
            saveSettings()
            refreshModeButtons()
        end)
    end

    refreshModeButtons()
end

-- ===== TAB: FLASH TP =====
sectionHeader(ScrollFlash, "  FLASH TP  ")
toggleRow(ScrollFlash, "Auto Flash TP On Low Timer", _G.AutoFlashLowTimer, function(v)
    _G.AutoFlashLowTimer = v
end)
toggleRow(ScrollFlash, "Auto Flash TP On Reset", _G.AutoFlashTP, function(v)
    _G.AutoFlashTP = v
end)
toggleRow(ScrollFlash, "Auto Giant", _G.AutoGiant, function(v)
    _G.AutoGiant = v
end)
toggleRow(ScrollFlash, "Ragdoll Bypass", _G.RagdollBypass, function(v)
    _G.RagdollBypass = v
end)

-- ---- Lagger on Flash TP ----
toggleRow(ScrollFlash, "Lagger on Flash TP", _G.LaggerOnFlash, function(v)
    _G.LaggerOnFlash = v
    if not v then stopFlashLagger() end
    saveSettings()
end)

do
    -- Label "LAGGER POWER"
    sectionOrder += 1
    local lagLblRow = Instance.new("Frame")
    lagLblRow.Name = "LaggerPowerRow"
    lagLblRow.Size = UDim2.new(0.92, 0, 0, 36)
    lagLblRow.AnchorPoint = Vector2.new(0.5, 0)
    lagLblRow.Position = UDim2.new(0.5, 0, 0, 0)
    lagLblRow.BackgroundTransparency = 1
    lagLblRow.LayoutOrder = sectionOrder
    lagLblRow.Parent = ScrollFlash

    local lagTitleLbl = Instance.new("TextLabel")
    lagTitleLbl.Size = UDim2.new(1, 0, 0, 13)
    lagTitleLbl.BackgroundTransparency = 1
    lagTitleLbl.Text = "LAGGER POWER"
    lagTitleLbl.TextColor3 = C.textMute
    lagTitleLbl.Font = Enum.Font.GothamBold
    lagTitleLbl.TextSize = isMob and 9 or 10
    lagTitleLbl.TextXAlignment = Enum.TextXAlignment.Center
    lagTitleLbl.ZIndex = 6
    lagTitleLbl.Parent = lagLblRow

    local lagValLbl = Instance.new("TextLabel")
    lagValLbl.Size = UDim2.new(1, 0, 0, 13)
    lagValLbl.Position = UDim2.new(0, 0, 0, 12)
    lagValLbl.BackgroundTransparency = 1
    lagValLbl.Text = tostring(math.floor(_G.LaggerPower))
    lagValLbl.TextColor3 = C.accent
    lagValLbl.Font = Enum.Font.GothamBold
    lagValLbl.TextSize = isMob and 9 or 10
    lagValLbl.TextXAlignment = Enum.TextXAlignment.Center
    lagValLbl.ZIndex = 6
    lagValLbl.Parent = lagLblRow

    -- Slider track
    local lagTrack = Instance.new("Frame")
    lagTrack.Size = UDim2.new(0.92, 0, 0, 6)
    lagTrack.AnchorPoint = Vector2.new(0.5, 0)
    lagTrack.Position = UDim2.new(0.5, 0, 0, 26)
    lagTrack.BackgroundColor3 = C.cardDark or C.card
    lagTrack.BackgroundTransparency = 0.3
    lagTrack.BorderSizePixel = 0
    lagTrack.ZIndex = 6
    lagTrack.Parent = lagLblRow
    Instance.new("UICorner", lagTrack).CornerRadius = UDim.new(1, 0)

    local lagFill = Instance.new("Frame")
    lagFill.Size = UDim2.new(_G.LaggerPower / 100, 0, 1, 0)
    lagFill.BackgroundColor3 = C.accent
    lagFill.BorderSizePixel = 0
    lagFill.ZIndex = 7
    lagFill.Parent = lagTrack
    Instance.new("UICorner", lagFill).CornerRadius = UDim.new(1, 0)

    local function updateLagger(pct)
        pct = math.clamp(pct, 0, 1)
        _G.LaggerPower = math.floor(pct * 100)
        lagFill.Size = UDim2.new(pct, 0, 1, 0)
        lagValLbl.Text = tostring(_G.LaggerPower)
        saveSettings()
    end

    local dragging = false
    lagTrack.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local pct = (inp.Position.X - lagTrack.AbsolutePosition.X) / lagTrack.AbsoluteSize.X
            updateLagger(pct)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local pct = (inp.Position.X - lagTrack.AbsolutePosition.X) / lagTrack.AbsoluteSize.X
            updateLagger(pct)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ============================================================
-- ESP TIMER (BASE REMAINING TIME)
-- ============================================================
local baseEspInstances = {}

local function createBaseESP(plot, mainPart)
    if baseEspInstances[plot.Name] then baseEspInstances[plot.Name]:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Name = "WHITE_BaseTimer"
    bb.Size = UDim2.new(0, 38, 0, 16)
    bb.StudsOffset = Vector3.new(0, 4, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = mainPart
    bb.MaxDistance = 1000
    bb.Parent = plot
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBold
    lbl.TextColor3 = Color3.fromRGB(255, 225, 0)
    lbl.TextStrokeTransparency = 0
    lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
    lbl.Parent = bb
    baseEspInstances[plot.Name] = bb
    return bb
end

local function clearBaseESP()
    for k, v in pairs(baseEspInstances) do v:Destroy(); baseEspInstances[k] = nil end
end

local function toSecondsOnly(text)
    if typeof(text) ~= "string" then return text end
    local m, s = text:match("(%d+):(%d+)")
    if m and s then return tostring(tonumber(m) * 60 + tonumber(s)) .. "s" end
    local n = text:match("(%d+)")
    if n then return n .. "s" end
    return text
end

local lastLowTimerFire = 0

local function updateBaseESP()
    if not _G.EspTimer then
        if next(baseEspInstances) then clearBaseESP() end
        return
    end
    local plotsFolder = Workspace:FindFirstChild("Plots")
    if not plotsFolder then return end
    for _, plot in ipairs(plotsFolder:GetChildren()) do
        local purchases = plot:FindFirstChild("Purchases")
        local plotBlock = purchases and purchases:FindFirstChild("PlotBlock")
        local mainPart = plotBlock and plotBlock:FindFirstChild("Main")
        local bb = baseEspInstances[plot.Name]
        local timeLabel = mainPart and mainPart:FindFirstChild("BillboardGui") and mainPart.BillboardGui:FindFirstChild("RemainingTime")
        if timeLabel and mainPart then
            bb = bb or createBaseESP(plot, mainPart)
            local lbl = bb:FindFirstChildWhichIsA("TextLabel")
            local converted = toSecondsOnly(timeLabel.Text)
            if lbl then lbl.Text = converted end
        elseif bb then
            bb:Destroy(); baseEspInstances[plot.Name] = nil
        end
    end
end

task.spawn(function()
    while true do
        pcall(updateBaseESP)
        task.wait(0.4)
    end
end)

-- Lock l'adversaire par UserId (le 1er autre joueur dans le serveur)
-- Même s'il quitte et rejoint, son UserId reste le même → il reste l'adversaire locké
-- Un 3ème joueur qui rejoint ne peut pas prendre sa place
local lockedAdversaryId = nil

do
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            lockedAdversaryId = p.UserId
            break
        end
    end
end

table.insert(ActiveConnections, Players.PlayerAdded:Connect(function(p)
    if lockedAdversaryId == nil then
        lockedAdversaryId = p.UserId
    end
end))

-- Trouve le plot de l'adversaire en comparant son DisplayName avec le TextLabel du PlotSign
local function findAdversaryPlot()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end
    if not lockedAdversaryId then return nil end

    local adversary = Players:GetPlayerByUserId(lockedAdversaryId)
    if not adversary then return nil end

    local expectedText = adversary.DisplayName .. "'s Base"

    for _, plot in ipairs(plots:GetChildren()) do
        local ok, text = pcall(function()
            return plot.PlotSign.SurfaceGui.Frame.TextLabel.Text
        end)
        if ok and text == expectedText then
            return plot
        end
    end
    return nil
end

-- Auto Flash TP On Low Timer : boucle dédiée sur la base adverse
local lastSeenTimerValue = nil
task.spawn(function()
    while true do
        task.wait(0.1)
        if not _G.AutoFlashLowTimer then lastSeenTimerValue = nil continue end
        if isStealing or autoStealEnabled then continue end
        if not selectedPrompt or not selectedSlotNumber then continue end

        local timeLabel = nil
        pcall(function()
            local advPlot = findAdversaryPlot()
            local purchases = advPlot and advPlot:FindFirstChild("Purchases")
            local plotBlock = purchases and purchases:FindFirstChild("PlotBlock")
            local mainPart = plotBlock and plotBlock:FindFirstChild("Main")
            timeLabel = mainPart and mainPart:FindFirstChild("BillboardGui") and mainPart.BillboardGui:FindFirstChild("RemainingTime")
        end)
        if not timeLabel then
            lastSeenTimerValue = nil
            continue
        end

        local converted = toSecondsOnly(timeLabel.Text)
        local seconds = tonumber(converted:match("(%d+)"))
        if not seconds then continue end

        -- Flash TP dès que le timer passe à 1
        if seconds <= 1 and lastSeenTimerValue and lastSeenTimerValue > 1 then
            task.spawn(function()
                startTripToPetSlot(selectedPrompt, selectedSlotNumber)
            end)
        end

        lastSeenTimerValue = seconds
    end
end)

task.spawn(function()
    while true do
        pcall(updateBaseESP)
        task.wait(0.4)
    end
end)

-- ===== TAB: MISC =====
sectionHeader(ScrollMisc, "  MISC  ")
toggleRow(ScrollMisc, "Auto Return to Base", _G.AutoReturnBase, function(v)
    _G.AutoReturnBase = v
end)
toggleRow(ScrollMisc, "Auto Balloon", _G.AutoBalloon, function(v)
    _G.AutoBalloon = v
    BalloonState.Auto = v
    if not v then BalloonState.Active = {} end
end)
toggleRow(ScrollMisc, "Auto Laser Cape", _G.AutoLaser, function(v)
    _G.AutoLaser = v
    if not v then LaserState.Active = {} end
end)
toggleRow(ScrollMisc, "Anti Ragdoll", antiRagdollEnabled, function(v)
    antiRagdollEnabled = v
    if v then startAntiRagdoll() else stopAntiRagdoll() end
end)

toggleRow(ScrollMisc, "Auto Select Best Brainrot", _G.AutoSelectBest, function(v)
    _G.AutoSelectBest = v
end)

-- Le Toggle Quick Admin Panel intégré exactement comme demandé
toggleRow(ScrollMisc, "Quick Admin Panel", _G.QuickAP, function(v)
    _G.QuickAP = v
    if qapPanel then qapPanel.Visible = v end
end)

-- Quick Pickup (from Gamma Hub)
toggleRow(ScrollMisc, "Quick Pickup", _G.QuickPickup, function(v)
    _G.QuickPickup = v
    QuickPickup.set(v)
    if not v then QuickPickup.set(false) end
    saveSettings()
end)

-- ============================================================
-- AP ESP : affiche "Admin Panel" au-dessus des joueurs avec l'attribut AdminCommands
-- ============================================================
local apEspInstances = {} -- [player.UserId] = BillboardGui

local function clearAPESP()
    for uid, bb in pairs(apEspInstances) do
        pcall(function() bb:Destroy() end)
        apEspInstances[uid] = nil
    end
end

local function updateAPESP()
    if not _G.BackpackESP or not _G.ShowAPESP then
        if next(apEspInstances) then clearAPESP() end
        return
    end

    local activePlayers = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        activePlayers[p.UserId] = true

        local hasAP = pcall(function()
            return p:GetAttribute("AdminCommands") ~= nil
        end) and p:GetAttribute("AdminCommands") ~= nil

        if not hasAP then
            if apEspInstances[p.UserId] then
                pcall(function() apEspInstances[p.UserId]:Destroy() end)
                apEspInstances[p.UserId] = nil
            end
            continue
        end

        if not apEspInstances[p.UserId] then
            local bb = Instance.new("BillboardGui")
            bb.Name        = "_APESP"
            bb.Size        = UDim2.new(0, 52, 0, 52)
            bb.StudsOffset = Vector3.new(3.5, 7, 0)
            bb.AlwaysOnTop = true
            bb.Adornee     = hrp
            bb.MaxDistance = 200
            bb.Parent      = char

            local img = Instance.new("ImageLabel")
            img.Size               = UDim2.new(1, 0, 1, 0)
            img.BackgroundTransparency = 1
            img.Image              = "rbxassetid://95529031547606"
            img.ScaleType          = Enum.ScaleType.Fit
            img.Parent             = bb

            apEspInstances[p.UserId] = bb
        else
            apEspInstances[p.UserId].Adornee = hrp
        end
    end

    -- Nettoyer les joueurs qui ont quitté
    for uid, bb in pairs(apEspInstances) do
        if not activePlayers[uid] then
            pcall(function() bb:Destroy() end)
            apEspInstances[uid] = nil
        end
    end
end

task.spawn(function()
    while true do
        pcall(updateAPESP)
        task.wait(0.5)
    end
end)

-- ============================================================
-- BACKPACK ESP : affiche icône + nom des tools importants au-dessus des joueurs
-- ============================================================
local BACKPACK_TRACKED = {
    ["Giant Potion"]   = true,
    ["Flash Teleport"] = true,
    ["Flying Carpet"]  = true,
}

local ICON_SIZE  = 32  -- taille icône en pixels

local backpackEspInstances = {} -- [player.UserId] = BillboardGui

local function clearBackpackESP()
    for uid, bb in pairs(backpackEspInstances) do
        pcall(function() bb:Destroy() end)
        backpackEspInstances[uid] = nil
    end
end

local function buildBackpackBillboard(char, hrp, found)
    local count = #found
    local ICON = 48
    local GAP  = 4
    local bb = Instance.new("BillboardGui")
    bb.Name        = "_BackpackESP"
    bb.Size        = UDim2.new(0, ICON, 0, ICON * count + GAP * (count - 1))
    bb.StudsOffset = Vector3.new(3.5, 0, 0)
    bb.AlwaysOnTop = true
    bb.Adornee     = hrp
    bb.MaxDistance = 200
    bb.Parent      = char

    local layout = Instance.new("UIListLayout")
    layout.FillDirection       = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment   = Enum.VerticalAlignment.Top
    layout.Padding             = UDim.new(0, GAP)
    layout.Parent              = bb

    for _, data in ipairs(found) do
        local img = Instance.new("ImageLabel")
        img.Size               = UDim2.new(0, ICON, 0, ICON)
        img.BackgroundTransparency = 1
        img.Image              = data.texture ~= "" and data.texture or "rbxassetid://0"
        img.ScaleType          = Enum.ScaleType.Fit
        img.Parent             = bb
    end

    return bb
end

local function updateBackpackESP()
    if not _G.BackpackESP then
        if next(backpackEspInstances) then clearBackpackESP() end
        return
    end

    local activePlayers = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        activePlayers[p.UserId] = true

        -- Filtrer selon les sous-settings actifs
        local bp = p:FindFirstChild("Backpack")
        local found = {}
        if bp then
            for _, tool in ipairs(bp:GetChildren()) do
                if tool:IsA("Tool") then
                    if tool.Name == "Giant Potion"   and _G.ShowGiantPotion   then
                        table.insert(found, { name = tool.Name, texture = tool.TextureId or "" })
                    elseif tool.Name == "Flash Teleport" and _G.ShowFlashTeleport then
                        table.insert(found, { name = tool.Name, texture = tool.TextureId or "" })
                    elseif tool.Name == "Flying Carpet"  and _G.ShowFlyingCarpet  then
                        table.insert(found, { name = tool.Name, texture = tool.TextureId or "" })
                    end
                end
            end
        end

        if #found == 0 then
            if backpackEspInstances[p.UserId] then
                pcall(function() backpackEspInstances[p.UserId]:Destroy() end)
                backpackEspInstances[p.UserId] = nil
            end
            continue
        end

        -- Reconstruire si le contenu a changé ou si pas encore créé
        local existing = backpackEspInstances[p.UserId]
        local needRebuild = not existing or existing.Parent == nil or existing.Adornee ~= hrp

        if not needRebuild then
            -- Vérifier si le nombre d'items a changé
            local slots = 0
            for _, c in ipairs(existing:GetChildren()) do
                if c:IsA("Frame") then slots += 1 end
            end
            if slots ~= #found then needRebuild = true end
        end

        if needRebuild then
            if existing then pcall(function() existing:Destroy() end) end
            backpackEspInstances[p.UserId] = buildBackpackBillboard(char, hrp, found)
        end
    end

    -- Nettoyer les joueurs qui ont quitté
    for uid, bb in pairs(backpackEspInstances) do
        if not activePlayers[uid] then
            pcall(function() bb:Destroy() end)
            backpackEspInstances[uid] = nil
        end
    end
end

task.spawn(function()
    while true do
        pcall(updateBackpackESP)
        task.wait(0.5)
    end
end)

-- ===== TAB: VISUAL =====
sectionHeader(ScrollVisual, "  ESP  ")
toggleRow(ScrollVisual, "ESP Timer", _G.EspTimer, function(v)
    _G.EspTimer = v
    if not v then clearBaseESP() end
end)
sectionHeader(ScrollVisual, "  BACKPACK ESP  ")
do
    -- Toggle principal "Backpack ESP"
    local mainRow, mainRef = toggleRow(ScrollVisual, "Backpack ESP", _G.BackpackESP, function(v)
        _G.BackpackESP = v
        if not v then clearBackpackESP() clearAPESP() end
    end)

    -- Bouton ⚙ dans la row
    local gearBtn = Instance.new("TextButton")
    gearBtn.Size               = UDim2.new(0, 22, 0, 22)
    gearBtn.Position           = UDim2.new(1, -68, 0.5, -11)
    gearBtn.BackgroundColor3   = C.iconBg
    gearBtn.BorderSizePixel    = 0
    gearBtn.ZIndex             = 9
    gearBtn.Text               = "⚙"
    gearBtn.TextColor3         = C.textMute
    gearBtn.TextSize           = 13
    gearBtn.Font               = Enum.Font.GothamBold
    gearBtn.AutoButtonColor    = false
    gearBtn.Parent             = mainRow
    Instance.new("UICorner", gearBtn).CornerRadius = UDim.new(1, 0)

    -- Sous-panel settings (caché par défaut)
    sectionOrder += 1
    local subPanel = Instance.new("Frame")
    subPanel.Size              = UDim2.new(0.92, 0, 0, 0)
    subPanel.AnchorPoint       = Vector2.new(0.5, 0)
    subPanel.Position          = UDim2.new(0.5, 0, 0, 0)
    subPanel.BackgroundColor3  = C.card
    subPanel.BackgroundTransparency = 0.4
    subPanel.BorderSizePixel   = 0
    subPanel.ZIndex            = 4
    subPanel.LayoutOrder       = sectionOrder
    subPanel.ClipsDescendants  = true
    subPanel.Visible           = false
    subPanel.Parent            = ScrollVisual
    Instance.new("UICorner", subPanel).CornerRadius = UDim.new(0, 10)
    local ss = Instance.new("UIStroke", subPanel)
    ss.Color = C.strokeDim; ss.Thickness = 1; ss.Transparency = 0.5

    local subLayout = Instance.new("UIListLayout")
    subLayout.FillDirection        = Enum.FillDirection.Vertical
    subLayout.HorizontalAlignment  = Enum.HorizontalAlignment.Center
    subLayout.Padding              = UDim.new(0, 4)
    subLayout.Parent               = subPanel

    local subPad = Instance.new("UIPadding")
    subPad.PaddingTop    = UDim.new(0, 6)
    subPad.PaddingBottom = UDim.new(0, 6)
    subPad.Parent        = subPanel

    local ITEM_H_SUB = 26

    local function makeCheckRow(label, stateKey)
        local row = Instance.new("Frame")
        row.Size              = UDim2.new(0.9, 0, 0, ITEM_H_SUB)
        row.BackgroundTransparency = 1
        row.BorderSizePixel   = 0
        row.Parent            = subPanel

        local lbl = Instance.new("TextLabel")
        lbl.Size              = UDim2.new(1, -34, 1, 0)
        lbl.Position          = UDim2.new(0, 8, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text              = label
        lbl.TextColor3        = C.textBright
        lbl.TextSize          = 11
        lbl.Font              = Enum.Font.GothamMedium
        lbl.TextXAlignment    = Enum.TextXAlignment.Left
        lbl.Parent            = row

        local state = _G[stateKey] ~= false

        local box = Instance.new("TextButton")
        box.Size              = UDim2.new(0, 18, 0, 18)
        box.Position          = UDim2.new(1, -22, 0.5, -9)
        box.BackgroundColor3  = state and C.accent or C.trackOff
        box.BorderSizePixel   = 0
        box.ZIndex            = 6
        box.Text              = state and "✓" or ""
        box.TextColor3        = C.body
        box.TextSize          = 11
        box.Font              = Enum.Font.GothamBold
        box.AutoButtonColor   = false
        box.Parent            = row
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

        box.MouseButton1Click:Connect(function()
            state = not state
            _G[stateKey] = state
            box.BackgroundColor3 = state and C.accent or C.trackOff
            box.Text             = state and "✓" or ""
            if not state then
                if stateKey == "ShowAPESP" then clearAPESP()
                elseif stateKey == "ShowGiantPotion" or stateKey == "ShowFlashTeleport" or stateKey == "ShowFlyingCarpet" then
                    clearBackpackESP()
                end
            end
            saveSettings()
        end)
    end

    makeCheckRow("Admin Panel",    "ShowAPESP")
    makeCheckRow("Giant Potion",   "ShowGiantPotion")
    makeCheckRow("Flash Teleport", "ShowFlashTeleport")
    makeCheckRow("Flying Carpet",  "ShowFlyingCarpet")

    -- Mettre à jour la hauteur du sous-panel
    local function refreshSubSize()
        local count = 0
        for _, c in ipairs(subPanel:GetChildren()) do
            if c:IsA("Frame") then count += 1 end
        end
        subPanel.Size = UDim2.new(0.92, 0, 0, count * (ITEM_H_SUB + 4) + 16)
    end
    refreshSubSize()

    -- Toggle du sous-panel via ⚙
    local subOpen = false
    gearBtn.MouseButton1Click:Connect(function()
        subOpen = not subOpen
        subPanel.Visible = subOpen
        gearBtn.TextColor3 = subOpen and C.accent or C.textMute
    end)
end
sectionHeader(ScrollVisual, "  BRAINROT  ")
toggleRow(ScrollVisual, "Brainrot Highlight", _G.BrainrotHighlight, function(v)
    _G.BrainrotHighlight = v
    if not v then clearBrainrotHighlights() end
end)

toggleRow(ScrollVisual, "TP Path Visual", _G.TpPathVisual, function(v)
    _G.TpPathVisual = v
    if v and selectedPrompt and selectedSlotNumber and not isStealing and not autoStealEnabled then
        showTpPathVisual(selectedPrompt, selectedSlotNumber)
    else
        clearTpPathVisual()
    end
end)

dropdownRow(ScrollMisc, "Walk Item", WalkItemOptions, _G.WalkItem, function(choice)
    _G.WalkItem = choice
end)

-- ===== TOGGLE AIMBOT =====
toggleRow(ScrollMisc, "Aimbot", _G.AimbotEnabled or false, function(v)
    _G.ToggleAimbot(v)
end)

-- ============================================================
-- INTERACTIONS BOUTONS ACTIONS
-- ============================================================
local function hookButton(btn)
    local stroke = btn:FindFirstChildOfClass("UIStroke")
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = 0.3 }):Play()
        if stroke then TweenService:Create(stroke, TweenInfo.new(0.12), { Color = C.accent, Transparency = 0 }):Play() end
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = 0.6 }):Play()
        if stroke then TweenService:Create(stroke, TweenInfo.new(0.12), { Color = C.strokeDim, Transparency = 0.35 }):Play() end
    end)
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.06), { BackgroundTransparency = 0.1 }):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1),  { BackgroundTransparency = 0.3 }):Play()
    end)
end
hookButton(FLASHTP)
hookButton(BLOCK)
hookButton(RESET)
hookButton(_G._KayRejoinBtn)

local function flashBar(bar)
    bar.BackgroundColor3 = C.accentHi
    TweenService:Create(bar, TweenInfo.new(0.4), { BackgroundColor3 = C.stroke }):Play()
end

FLASHTP.MouseButton1Click:Connect(function()
    if selectedPrompt and selectedSlotNumber then
        if not isStealing and not autoStealEnabled then
            flashBar(flashAccent)
            startTripToPetSlot(selectedPrompt, selectedSlotNumber)
        end
    end
end)

BLOCK.MouseButton1Click:Connect(function()
    flashBar(blockAccent)
    local target = getNearestPlayer()
    if target then blockPlayer(target) end
end)

RESET.MouseButton1Click:Connect(function()
    flashBar(resetAccent)
    doReset()
end)

task.spawn(function()
    while task.wait(1.5) do
        if thisScriptStopped then break end
        updatePetList()
    end
end)
updatePetList()

local charAddedConnForReset = LocalPlayer.CharacterAdded:Connect(function(newChar)
    if _G.AutoFlashTP and selectedPrompt and selectedSlotNumber then
        task.delay(0.2, function()
            if not isStealing and not autoStealEnabled then
                startTripToPetSlot(selectedPrompt, selectedSlotNumber)
            end
        end)
    end
    _resetWasByBalloon = false
end)
table.insert(ActiveConnections, charAddedConnForReset)

local doRejoin -- forward declaration, assignée plus loin (section MISC)

local keybinds = {
    flash  = Enum.KeyCode.F,
    block  = Enum.KeyCode.B,
    reset  = Enum.KeyCode.R,
    rejoin = Enum.KeyCode.J,
}

local listeningAction = nil  -- non-nil quand on est en train d'écouter une touche
local justBound = false       -- true pendant 1 frame après avoir assigné une keybind

local kbConn = UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if listeningAction then return end
    if justBound then return end
    if inp.KeyCode == keybinds.flash then
        if selectedPrompt and selectedSlotNumber and not isStealing and not autoStealEnabled then
            startTripToPetSlot(selectedPrompt, selectedSlotNumber)
        end
    elseif inp.KeyCode == keybinds.block then
        local target = getNearestPlayer()
        if target then blockPlayer(target) end
    elseif inp.KeyCode == keybinds.reset then
        doReset()
    elseif inp.KeyCode == keybinds.rejoin then
        if doRejoin then doRejoin() end
    end
end)
table.insert(ActiveConnections, kbConn)

local keyNames = { flash = "F", block = "B", reset = "R", rejoin = "J" }

local KB_FILE = "kay_keybinds.json"

local function saveKeybinds()
    pcall(function()
        writefile(KB_FILE, game:GetService("HttpService"):JSONEncode({
            flash  = keyNames.flash,
            block  = keyNames.block,
            reset  = keyNames.reset,
            rejoin = keyNames.rejoin,
        }))
    end)
end

local function loadKeybinds()
    local ok, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(KB_FILE))
    end)
    if ok and type(data) == "table" then
        for _, action in ipairs({"flash", "block", "reset", "rejoin"}) do
            if data[action] then
                local ok2, kc = pcall(function() return Enum.KeyCode[data[action]] end)
                if ok2 and kc then
                    keybinds[action]  = kc
                    keyNames[action]  = data[action]
                end
            end
        end
    end
end

loadKeybinds()

task.defer(function()
    local lbl = FLASHTP:FindFirstChildOfClass("TextLabel")
    if lbl then lbl.Text = "FLASH TP [" .. keyNames.flash .. "]" end
    lbl = BLOCK:FindFirstChildOfClass("TextLabel")
    if lbl then lbl.Text = "BLOCK [" .. keyNames.block .. "]" end
    lbl = RESET:FindFirstChildOfClass("TextLabel")
    if lbl then lbl.Text = "RESET [" .. keyNames.reset .. "]" end
    local rejoinBtnRef = _G._KayRejoinBtn
    if rejoinBtnRef then
        lbl = rejoinBtnRef:FindFirstChildOfClass("TextLabel")
        if lbl then lbl.Text = "REJOIN [" .. keyNames.rejoin .. "]" end
    end
end)

-- ============================================================
-- KEYBIND PAR CLIC DROIT SUR LES BOUTONS ACTIONS
-- ============================================================
local function attachKeybindRightClick(btn, actionName, labelPrefix)
    btn.MouseEnter:Connect(function() end)
    btn.MouseLeave:Connect(function() end)

    btn.InputBegan:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
        if listeningAction then return end
        listeningAction = actionName

        local lbl = btn:FindFirstChildOfClass("TextLabel")
        if lbl then
            lbl.Text       = "Appuie sur une touche..."
            lbl.TextSize   = 10
            lbl.TextColor3 = C.accent
        end

        local conn
        conn = UserInputService.InputBegan:Connect(function(inp2, gpe)
            if gpe then return end
            if inp2.UserInputType ~= Enum.UserInputType.Keyboard then return end
            conn:Disconnect()
            -- Marquer justBound avant de remettre listeningAction à nil
            -- pour que kbConn (qui reçoit le même event) skip cette touche
            justBound = true
            listeningAction = nil
            task.defer(function() justBound = false end)

            keybinds[actionName] = inp2.KeyCode
            keyNames[actionName] = inp2.KeyCode.Name
            saveKeybinds()

            if lbl then
                lbl.Text       = labelPrefix .. " [" .. inp2.KeyCode.Name .. "]"
                lbl.TextSize   = isMob and 12 or 14
                lbl.TextColor3 = C.textBright
            end
        end)
    end)
end

task.defer(function()
    attachKeybindRightClick(FLASHTP, "flash", "FLASH TP")
    attachKeybindRightClick(BLOCK,   "block", "BLOCK")
    attachKeybindRightClick(RESET,   "reset", "RESET")

    local rejoinBtn = _G._KayRejoinBtn
    if rejoinBtn then
        rejoinBtn.MouseButton1Click:Connect(function()
            local acc = rejoinBtn:FindFirstChild("AccentBar")
            if acc then flashBar(acc) end
            if doRejoin then doRejoin() end
        end)
        attachKeybindRightClick(rejoinBtn, "rejoin", "REJOIN")
    end
end)

function doRejoin()
    pcall(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end)
end

TextLabel.TextColor3  = Color3.fromRGB(255, 255, 255)

-- ============================================================
-- Boutons de la section ACTIONS (FLASH TP / BLOCK / RESET) :
-- même couleur + même animation de dégradé que le titre "ACTIONS"
-- ============================================================
do
    local actionGradients = {}

    local function applyTitleStyle(btn)
        if not btn then return end
        local lbl = btn:FindFirstChildOfClass("TextLabel")
        if not lbl then return end
        lbl.TextColor3 = C.textBright
        local g = lbl:FindFirstChildOfClass("UIGradient")
        if not g then
            g = Instance.new("UIGradient")
            g.Parent = lbl
        end
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,  C.textBright),
            ColorSequenceKeypoint.new(.5, C.textMauve),
            ColorSequenceKeypoint.new(1,  C.textBright)
        })
        table.insert(actionGradients, g)
    end

    applyTitleStyle(FLASHTP)
    applyTitleStyle(BLOCK)
    applyTitleStyle(RESET)
    applyTitleStyle(_G._KayRejoinBtn)

    table.insert(ActiveConnections, RunService.Heartbeat:Connect(function()
        local rot = (tick()*100)%360
        for _, g in ipairs(actionGradients) do
            if g and g.Parent then
                g.Rotation = rot
            end
        end
        for _, g in ipairs(brainrotNameGradients) do
            if g and g.Parent then
                g.Rotation = rot
            end
        end
    end))
end
end

BuildHUB()
