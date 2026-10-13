-- ============================================================
-- RARA HUB - VERSION FINALE COMPLETE
-- Aimbot ON par défaut | Auto Destroy OFF | GUI optimisée
-- Keybinds fonctionnels | Boutons mobiles draggables
-- Boutons carrés avec bords arrondis
-- Flèche de rétrécissement/agrandissement améliorée
-- + Sauvegarde complète des configurations (positions incluses)
-- + INSTANT RESET (FunnyHub) intégré
-- + AUTO SAVE CONFIG intégré
-- ============================================================

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Lighting = game:GetService("Lighting")
    local player = Players.LocalPlayer
    local camera = workspace.CurrentCamera

    if player:WaitForChild("PlayerGui"):FindFirstChild("RARAHUB") then
        player.PlayerGui.RARAHUB:Destroy()
    end
    if player:WaitForChild("PlayerGui"):FindFirstChild("FunnyHubInstantReset") then
        player.PlayerGui.FunnyHubInstantReset:Destroy()
    end

    -- ============================================================
    --  SYSTEME DE SAUVEGARDE / CHARGEMENT DES CONFIGS
    -- ============================================================
    local function saveConfigsToFile(data)
        if not writefile then
            _G.AllGearSettings = data
            return false
        end
        local success, err = pcall(function()
            local json = game:GetService("HttpService"):JSONEncode(data)
            writefile("RARA_HUB_Config.json", json)
        end)
        if not success then
            warn("Erreur lors de la sauvegarde du fichier :", err)
            _G.AllGearSettings = data
        end
        return success
    end

    local function loadConfigsFromFile()
        if not readfile then
            return _G.AllGearSettings
        end
        local success, content = pcall(function()
            return readfile("RARA_HUB_Config.json")
        end)
        if not success or not content then return nil end
        local ok, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(content)
        end)
        if ok and type(data) == "table" then
            return data
        end
        return nil
    end

    -- ============================================================
    --  CONFIGURATIONS PAR DÉFAUT
    -- ============================================================
    _G.AllGearSettings = _G.AllGearSettings or {}
    local Settings = _G.AllGearSettings
    local function getSetting(k, d) if Settings[k]==nil then Settings[k]=d end return Settings[k] end
    local function setSetting(k,v) Settings[k]=v _G.AllGearSettings=Settings end

    -- CONFIG (Steal)
    local Config = {AutoSteal=true, STEAL_RADIUS=200, STEAL_DURATION=1.3}
    local isStealing, stealStartTime, progressConnection, floatBar = false
    local StealData, Connections = {}, {}
    local savedPosition, moving = false, nil
    local MIN_HEIGHT_REQUIRED, tpKeybind, awaitingKeybind = 50, Enum.KeyCode.X, false
    local TPButton, keybindTPBtn

    -- UI table (valeurs par défaut)
    local UI = {
        aimbotState = true,
        InfJumpEnabled = true,
        AntiRagdollEnabled = true,
        antiGummyEnabled = getSetting("antiGummy", true),
        antiBoogieEnabled = getSetting("antiBoogie", true),
        antiBeeEnabled = getSetting("antiBee", true),
        carpetBoostEnabled = false,
        carpetSpeed = getSetting("carpetSpeed", 50),
        antiDeathEnabled = true,
        resetEnabled = true,
        tpDownEnabled = true,
        dropBrainrotEnabled = false,
        showMobileButtons = getSetting("showMobileButtons", true),
    }

    -- États des boutons mobiles
    local mobileBtnStates = {
        reset = getSetting("mobileBtnReset", true),
        tpDown = getSetting("mobileBtnTpDown", true),
        drop = getSetting("mobileBtnDrop", true),
        tpBest = getSetting("mobileBtnTpBest", true),
        destroy = getSetting("mobileBtnDestroy", true),
    }

    -- Verrouillage des boutons mobiles
    local mobileButtonsLocked = getSetting("mobileButtonsLocked", false)

    -- Variables pour TP 2
    local tp2Enabled = false
    local tp2Gui = nil
    local tp2Keybind = Enum.KeyCode.T
    local tp2AwaitingKeybind = false

    -- Variables pour RESET (keybind UI)
    local resetKeybind = Enum.KeyCode.R
    local resetAwaitingKeybind = false

    -- Variables pour TP DOWN
    local tpDownKeybind = Enum.KeyCode.E
    local tpDownAwaitingKeybind = false
    local TP_DOWN_Y = -6.84

    -- Variables pour DROP BRAINROT
    local dropBrainrotKeybind = Enum.KeyCode.H
    local dropBrainrotAwaitingKeybind = false
    local dropBrainrotActive = false
    local dropBrainrotConns = {}

    -- Variables pour CARPET BOOST
    local carpetKeybind = Enum.KeyCode.M
    local carpetKeybindStr = getSetting("carpetKeybind", "M")
    pcall(function() carpetKeybind = Enum.KeyCode[carpetKeybindStr] end)
    local carpetAwaitingKeybind = false

    -- ESP Linia
    local espEnabled = getSetting("espEnabled", true)
    local espTransparency = getSetting("espTransparency", 0.3)
    local espConnection = nil
    local espData = {}
    local espColors = {
        w = Color3.fromRGB(255,255,255),
        k = Color3.fromRGB(20,20,20),
        g = Color3.fromRGB(120,120,120),
        l = Color3.fromRGB(200,200,200),
        h = Color3.fromRGB(100,100,100),
        o = Color3.fromRGB(150,150,150),
        d = Color3.fromRGB(180,180,180),
        b = Color3.fromRGB(40,40,40)
    }

    -- AUTO SENTRY
    local autoSentryEnabled = false
    local resizedBat

    -- AUTO DESTROY V2
    local autoDestroyV2Enabled = false
    local destroyV2Running = false
    local destroyV2Task = nil
    local activeAttackCount = 0
    local turretAttackBusy = setmetatable({}, { __mode = "k" })
    local turretAttackQueued = setmetatable({}, { __mode = "k" })
    local turretAttackCooldownUntil = setmetatable({}, { __mode = "k" })
    local MAX_CONCURRENT = 2
    local MAX_ATTEMPTS = 18
    local MAX_DISTANCE = 250
    local TURRET_ATTACK_RETRY_DELAY = 0.15
    local ATTACK_INTERVAL = 0.045

    -- Anti Bee
    local AntiBeeModule = nil

    -- Carpet Boost
    local carpetBoostConn = nil
    local isCarpetEquipped = false

    -- Variables pour les boutons mobiles
    local mobileButtons = {}
    local mobileButtonsVisible = true

    -- Variables pour la GUI principale
    local mainGuiFrame = nil
    local mainResizeBtn = nil
    local mainFrameExpanded = true
    local savedMainSize = UDim2.new(0, 550, 0, 480)
    local savedMainPos = UDim2.new(0.5, -275, 0.5, -240)

    -- Positions sauvegardées des boutons mobiles
    local savedMobileBtnPositions = nil

    -- ============================================================
    --  AUTO SAVE CONFIG - VARIABLES
    -- ============================================================
    local autoSaveEnabled = getSetting("autoSaveEnabled", true)
    local autoSaveInterval = getSetting("autoSaveInterval", 30)
    local autoSaveTask = nil
    local autoSaveLastTime = 0

    -- ============================================================
    --  INSTANT RESET (FunnyHub) - Variables & Fonction
    -- ============================================================
    local CAM_BIND = "FunnyHubInstaResetCam"
    local FLING_TIME = 0.4
    local FLING_POWER = 50000
    local USE_VOID = true
    local VOID_TIME = 0.6
    local RESET_TIMEOUT = 6
    local resetting = false

    local function hide_locally(obj)
        if obj:IsA("BasePart") or obj:IsA("Decal") then
            obj.LocalTransparencyModifier = 1
        end
    end

    local function insta_reset()
        if resetting then return end
        local char = player.Character
        if not char or not char.Parent then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local hrp = hum.RootPart or char:FindFirstChild("HumanoidRootPart")
        resetting = true

        task.spawn(function()
            local cam = workspace.CurrentCamera
            local frozen = cam.CFrame
            local old_type = cam.CameraType
            pcall(function()
                cam.CameraType = Enum.CameraType.Scriptable
                RunService:BindToRenderStep(CAM_BIND, Enum.RenderPriority.Camera.Value + 1, function()
                    cam.CFrame = frozen
                end)
            end)

            local added
            pcall(function()
                for _, obj in ipairs(char:GetDescendants()) do pcall(hide_locally, obj) end
                added = char.DescendantAdded:Connect(function(obj) pcall(hide_locally, obj) end)
            end)

            local new_char
            local respawned = player.CharacterAdded:Connect(function(c) new_char = c end)

            local function unlock()
                pcall(function() hum.PlatformStand = false end)
                pcall(function() hum.Sit = false end)
                pcall(function() hum.AutoRotate = true end)
            end
            unlock()

            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("BasePart") then
                    pcall(function() obj.Anchored = false end)
                    pcall(function() obj.CanCollide = false end)
                elseif obj.Name == "SeatWeld" then
                    pcall(function() obj:Destroy() end)
                end
            end

            local started = os.clock()
            local function alive_hrp()
                if hrp and hrp.Parent then return hrp end
                hrp = hum.RootPart or char:FindFirstChild("HumanoidRootPart")
                if hrp and hrp.Parent then return hrp end
                return nil
            end

            local fling_until = os.clock() + FLING_TIME
            while not new_char and os.clock() < fling_until and hum.Parent do
                unlock()
                pcall(function() hum.HipHeight = 1e30 end)
                local root = alive_hrp()
                if root then
                    pcall(function() root.Anchored = false end)
                    pcall(function() root.AssemblyLinearVelocity = Vector3.new(0, FLING_POWER, 0) end)
                    pcall(function() root.Velocity = Vector3.new(0, FLING_POWER, 0) end)
                end
                RunService.Heartbeat:Wait()
            end

            if USE_VOID and not new_char then
                local floor = -500
                pcall(function() floor = workspace.FallenPartsDestroyHeight end)
                local void_until = os.clock() + VOID_TIME
                while not new_char and os.clock() < void_until do
                    local root = alive_hrp()
                    if not root then break end
                    pcall(function() root.CFrame = CFrame.new(0, floor - 500, 0) end)
                    pcall(function() root.AssemblyLinearVelocity = Vector3.new(0, -FLING_POWER, 0) end)
                    RunService.Heartbeat:Wait()
                end
            end

            while not new_char and os.clock() - started < RESET_TIMEOUT do
                if hum.Parent then
                    pcall(function() hum.Health = 0 end)
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Dead) end)
                end
                if char.Parent then pcall(function() char:BreakJoints() end) end
                task.wait(0.1)
            end

            pcall(function() respawned:Disconnect() end)
            if added then pcall(function() added:Disconnect() end) end
            pcall(function() RunService:UnbindFromRenderStep(CAM_BIND) end)
            pcall(function()
                cam.CameraType = old_type == Enum.CameraType.Scriptable and Enum.CameraType.Custom or old_type
                if new_char then
                    local new_hum = new_char:FindFirstChildOfClass("Humanoid")
                        or new_char:WaitForChild("Humanoid", 5)
                    if new_hum then cam.CameraSubject = new_hum end
                end
            end)
            resetting = false
        end)
    end

    -- Alias pour compatibilité
    local function doReset()
        if not UI.resetEnabled then return end
        insta_reset()
    end

    -- ============================================================
    --  CHARGEMENT DES CONFIGS SAUVEGARDEES
    -- ============================================================
    local function loadAllConfigs()
        local data = loadConfigsFromFile()
        if not data then return false end

        UI.aimbotState = data.aimbotState ~= nil and data.aimbotState or true
        UI.InfJumpEnabled = data.InfJumpEnabled ~= nil and data.InfJumpEnabled or true
        UI.AntiRagdollEnabled = data.AntiRagdollEnabled ~= nil and data.AntiRagdollEnabled or true
        UI.antiGummyEnabled = data.antiGummyEnabled ~= nil and data.antiGummyEnabled or true
        UI.antiBoogieEnabled = data.antiBoogieEnabled ~= nil and data.antiBoogieEnabled or true
        UI.antiBeeEnabled = data.antiBeeEnabled ~= nil and data.antiBeeEnabled or true
        UI.carpetBoostEnabled = data.carpetBoostEnabled ~= nil and data.carpetBoostEnabled or false
        UI.carpetSpeed = data.carpetSpeed ~= nil and data.carpetSpeed or 50
        UI.antiDeathEnabled = data.antiDeathEnabled ~= nil and data.antiDeathEnabled or true
        UI.resetEnabled = data.resetEnabled ~= nil and data.resetEnabled or true
        UI.tpDownEnabled = data.tpDownEnabled ~= nil and data.tpDownEnabled or true
        UI.dropBrainrotEnabled = data.dropBrainrotEnabled ~= nil and data.dropBrainrotEnabled or false
        UI.showMobileButtons = data.showMobileButtons ~= nil and data.showMobileButtons or true

        tp2Enabled = data.tp2Enabled ~= nil and data.tp2Enabled or false

        if data.mobileBtnStates then
            for k, v in pairs(data.mobileBtnStates) do
                mobileBtnStates[k] = v
            end
        end
        mobileButtonsLocked = data.mobileButtonsLocked ~= nil and data.mobileButtonsLocked or false

        espEnabled = data.espEnabled ~= nil and data.espEnabled or true
        espTransparency = data.espTransparency ~= nil and data.espTransparency or 0.3

        autoSentryEnabled = data.autoSentryEnabled ~= nil and data.autoSentryEnabled or false
        autoDestroyV2Enabled = data.autoDestroyV2Enabled ~= nil and data.autoDestroyV2Enabled or false

        -- AUTO SAVE CONFIG
        autoSaveEnabled = data.autoSaveEnabled ~= nil and data.autoSaveEnabled or true
        autoSaveInterval = data.autoSaveInterval ~= nil and data.autoSaveInterval or 30

        Config.AutoSteal = data.AutoSteal ~= nil and data.AutoSteal or true
        Config.STEAL_RADIUS = data.STEAL_RADIUS ~= nil and data.STEAL_RADIUS or 200
        Config.STEAL_DURATION = data.STEAL_DURATION ~= nil and data.STEAL_DURATION or 1.3

        if data.tpKeybind then
            local success, k = pcall(function() return Enum.KeyCode[data.tpKeybind] end)
            if success and k then tpKeybind = k end
        end
        if data.resetKeybind then
            local success, k = pcall(function() return Enum.KeyCode[data.resetKeybind] end)
            if success and k then resetKeybind = k end
        end
        if data.tpDownKeybind then
            local success, k = pcall(function() return Enum.KeyCode[data.tpDownKeybind] end)
            if success and k then tpDownKeybind = k end
        end
        if data.carpetKeybind then
            local success, k = pcall(function() return Enum.KeyCode[data.carpetKeybind] end)
            if success and k then carpetKeybind = k end
        end
        if data.dropBrainrotKeybind then
            local success, k = pcall(function() return Enum.KeyCode[data.dropBrainrotKeybind] end)
            if success and k then dropBrainrotKeybind = k end
        end
        if data.tp2Keybind then
            local success, k = pcall(function() return Enum.KeyCode[data.tp2Keybind] end)
            if success and k then tp2Keybind = k end
        end

        if data.mobileBtnPositions then
            savedMobileBtnPositions = data.mobileBtnPositions
        end

        _G.AllGearSettings = data
        return true
    end

    loadAllConfigs()

    -- ============================================================
    --  FONCTION DE SAUVEGARDE COMPLETE
    -- ============================================================
    local function saveAllConfigs()
        local config = {
            aimbotState = UI.aimbotState,
            InfJumpEnabled = UI.InfJumpEnabled,
            AntiRagdollEnabled = UI.AntiRagdollEnabled,
            antiGummyEnabled = UI.antiGummyEnabled,
            antiBoogieEnabled = UI.antiBoogieEnabled,
            antiBeeEnabled = UI.antiBeeEnabled,
            carpetBoostEnabled = UI.carpetBoostEnabled,
            carpetSpeed = UI.carpetSpeed,
            antiDeathEnabled = UI.antiDeathEnabled,
            resetEnabled = UI.resetEnabled,
            tpDownEnabled = UI.tpDownEnabled,
            dropBrainrotEnabled = UI.dropBrainrotEnabled,
            showMobileButtons = UI.showMobileButtons,
            tp2Enabled = tp2Enabled,
            mobileBtnStates = mobileBtnStates,
            mobileButtonsLocked = mobileButtonsLocked,
            espEnabled = espEnabled,
            espTransparency = espTransparency,
            autoSentryEnabled = autoSentryEnabled,
            autoDestroyV2Enabled = autoDestroyV2Enabled,
            autoSaveEnabled = autoSaveEnabled,
            autoSaveInterval = autoSaveInterval,
            AutoSteal = Config.AutoSteal,
            STEAL_RADIUS = Config.STEAL_RADIUS,
            STEAL_DURATION = Config.STEAL_DURATION,
            tpKeybind = tostring(tpKeybind),
            resetKeybind = tostring(resetKeybind),
            tpDownKeybind = tostring(tpDownKeybind),
            carpetKeybind = tostring(carpetKeybind),
            dropBrainrotKeybind = tostring(dropBrainrotKeybind),
            tp2Keybind = tostring(tp2Keybind),
        }

        local positions = {}
        for _, btn in ipairs(mobileButtons) do
            if btn and btn.Parent then
                positions[btn.Name] = {
                    X = { Scale = btn.Position.X.Scale, Offset = btn.Position.X.Offset },
                    Y = { Scale = btn.Position.Y.Scale, Offset = btn.Position.Y.Offset }
                }
            end
        end
        if next(positions) then
            config.mobileBtnPositions = positions
        end

        _G.AllGearSettings = config
        saveConfigsToFile(config)
        print("✅ Toutes les configurations sauvegardées !")
    end

    -- ============================================================
    --  AUTO SAVE CONFIG - FONCTIONS
    -- ============================================================
    local function startAutoSave()
        if autoSaveTask then return end
        autoSaveLastTime = tick()
        autoSaveTask = task.spawn(function()
            while autoSaveEnabled do
                task.wait(1)
                if not autoSaveEnabled then break end
                if tick() - autoSaveLastTime >= autoSaveInterval then
                    autoSaveLastTime = tick()
                    local ok, err = pcall(saveAllConfigs)
                    if ok then
                        print("💾 [AutoSave] Configurations sauvegardées automatiquement.")
                    else
                        warn("⚠️ [AutoSave] Erreur:", err)
                    end
                end
            end
        end)
    end

    local function stopAutoSave()
        if autoSaveTask then
            task.cancel(autoSaveTask)
            autoSaveTask = nil
        end
    end

    -- ============================================================
    --  REFRESH UI
    -- ============================================================
    local function refreshAllUI()
        if keybindTPBtn then
            local keyName = tpKeybind.Name:gsub("KeyCode.", "")
            keybindTPBtn.Text = "Key: " .. keyName
        end
        if UI.ResetKeybindBtn then UI.ResetKeybindBtn.Text = resetKeybind.Name end
        if UI.TpDownKeybindBtn then UI.TpDownKeybindBtn.Text = tpDownKeybind.Name end
        if UI.CarpetKeybindBtn then UI.CarpetKeybindBtn.Text = carpetKeybind.Name end
        if UI.DropKeybindBtn then UI.DropKeybindBtn.Text = dropBrainrotKeybind.Name end
        if UI.Tp2KeybindBtn then UI.Tp2KeybindBtn.Text = tp2Keybind.Name end

        -- AUTO SAVE UI
        if UI.autoSaveStatus then
            UI.autoSaveStatus.Text = autoSaveEnabled and "ON" or "OFF"
            UI.autoSaveStatus.TextColor3 = autoSaveEnabled and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        end
        if UI.autoSavePillBg then
            UI.autoSavePillBg.BackgroundColor3 = autoSaveEnabled and UI.Colors.accent or UI.Colors.inactive
        end
        if UI.autoSavePillCircle then
            UI.autoSavePillCircle.Position = autoSaveEnabled and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        end
        if UI.autoSaveCardAccent then
            UI.autoSaveCardAccent.BackgroundColor3 = autoSaveEnabled and UI.Colors.accent or UI.Colors.dim
        end
        if UI.autoSaveIntervalBox then
            UI.autoSaveIntervalBox.Text = tostring(autoSaveInterval)
        end

        print("✅ Interface mise à jour.")
    end

    -- ============================================================
    --  INFINITE JUMP
    -- ============================================================
    local infJumpEnabled = true
    local infJumpHeartbeat = nil

    UserInputService.JumpRequest:Connect(function()
        if not infJumpEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
        end
    end)

    infJumpHeartbeat = RunService.Heartbeat:Connect(function()
        if not infJumpEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local jumpHeld = UserInputService:IsKeyDown(Enum.KeyCode.Space) or (hum and hum.Jump == true)
        if jumpHeld and root.Velocity.Y < 30 then
            root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
        end
        if root.Velocity.Y < -120 then
            root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z)
        end
    end)

    local function setInfinityJump(on)
        infJumpEnabled = on
        UI.InfJumpEnabled = on
        if UI.InfJumpStatus then
            UI.InfJumpStatus.Text = on and "ON" or "OFF"
            UI.InfJumpStatus.TextColor3 = on and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        end
        if UI.InfJumpPillBg then
            TweenService:Create(UI.InfJumpPillBg, TweenInfo.new(0.25), {BackgroundColor3 = on and UI.Colors.accent or UI.Colors.inactive}):Play()
        end
        if UI.InfJumpPillCircle then
            TweenService:Create(UI.InfJumpPillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
                Position = on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
            }):Play()
        end
    end

    -- ============================================================
    --  DROP BRAINROT
    -- ============================================================
    local function runDropBrainrot()
        if dropBrainrotActive then return end
        dropBrainrotActive = true

        local colConn = RunService.Stepped:Connect(function()
            if not dropBrainrotActive then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    for _, part in ipairs(p.Character:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end
        end)
        table.insert(dropBrainrotConns, colConn)

        local flingThread = coroutine.create(function()
            while dropBrainrotActive do
                RunService.Heartbeat:Wait()
                local c = player.Character
                local root = c and c:FindFirstChild("HumanoidRootPart")
                if not root then break end
                local vel = root.Velocity
                root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if root and root.Parent then root.Velocity = vel end
                RunService.Stepped:Wait()
                if root and root.Parent then root.Velocity = vel + Vector3.new(0, 0.1, 0) end
            end
        end)
        table.insert(dropBrainrotConns, flingThread)
        coroutine.resume(flingThread)

        task.delay(0.1, function()
            dropBrainrotActive = false
            for _, c in ipairs(dropBrainrotConns) do
                if typeof(c) == "RBXScriptConnection" then
                    c:Disconnect()
                elseif type(c) == "thread" then
                    pcall(coroutine.close, c)
                end
            end
            dropBrainrotConns = {}
        end)
    end

    -- ============================================================
    --  ANTI-DEATH
    -- ============================================================
    local antiDeathConn = nil

    local function _adHarden(hum)
        pcall(function() hum.BreakJointsOnDeath=false end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead,false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false) end)
    end

    local function startAntiDeath()
        if antiDeathConn then return end
        antiDeathConn = RunService.Heartbeat:Connect(function()
            if not UI.antiDeathEnabled then return end
            local char = player.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then return end
            _adHarden(hum)
            local st = hum:GetState()
            if hum.Health <= 0 then hum.Health = hum.MaxHealth end
            if st == Enum.HumanoidStateType.Dead or st == Enum.HumanoidStateType.Ragdoll then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end

    local function stopAntiDeath()
        if antiDeathConn then
            antiDeathConn:Disconnect()
            antiDeathConn = nil
        end
    end

    -- ============================================================
    --  ANTI-RAGDOLL
    -- ============================================================
    local AntiRagdollConn = nil
    local resetCooldown = 0

    local function forceReset()
        local char = player.Character
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
            local PM = player.PlayerScripts:FindFirstChild("PlayerModule")
            if PM then
                local CM = require(PM:FindFirstChild("ControlModule"))
                if CM then CM:Enable() end
            end
            hum.AutoRotate = true
            hum.PlatformStand = false
            hum.Sit = false
        end)
    end

    local function startAntiRagdoll()
        if AntiRagdollConn then return end
        AntiRagdollConn = RunService.Heartbeat:Connect(function()
            if not UI.AntiRagdollEnabled then return end
            local char = player.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then return end
            local state = hum:GetState()
            local isRagdolled = (
                state == Enum.HumanoidStateType.Physics or
                state == Enum.HumanoidStateType.Ragdoll or
                state == Enum.HumanoidStateType.FallingDown
            )
            if isRagdolled then
                local now = tick()
                if now - resetCooldown > 0.15 then
                    resetCooldown = now
                    forceReset()
                end
            end
        end)
    end

    local function stopAntiRagdoll()
        if AntiRagdollConn then
            AntiRagdollConn:Disconnect()
            AntiRagdollConn = nil
        end
    end

    -- ============================================================
    --  TP DOWN
    -- ============================================================
    local function doTpDown()
        if not UI.tpDownEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local pos = root.Position
        root.CFrame = CFrame.new(pos.X, TP_DOWN_Y, pos.Z)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end

    -- ============================================================
    --  ANTI BEE MODULE
    -- ============================================================
    do
        local function buildAntiBee()
            local Data = {
                running = false,
                connections = {},
                originalMoveFunction = nil,
                controlsProtected = false,
                badLightingNames = { Blue = true, DiscoEffect = true, BeeBlur = true, ColorCorrection = true },
            }
            local function nuke(obj)
                if not obj or not obj.Parent then return end
                if Data.badLightingNames[obj.Name] then
                    pcall(function() obj:Destroy() end)
                end
            end
            local function disconnectAll()
                for _, conn in ipairs(Data.connections) do
                    if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
                end
                Data.connections = {}
            end
            local function protectControls()
                if Data.controlsProtected then return end
                pcall(function()
                    local PlayerModule = player.PlayerScripts:FindFirstChild("PlayerModule")
                    if not PlayerModule then return end
                    local Controls = require(PlayerModule):GetControls()
                    if not Controls then return end
                    if not Data.originalMoveFunction then
                        Data.originalMoveFunction = Controls.moveFunction
                    end
                    local function protectedMove(self, moveVector, relativeToCamera)
                        if Data.originalMoveFunction then
                            Data.originalMoveFunction(self, moveVector, relativeToCamera)
                        end
                    end
                    local acc = 0
                    table.insert(Data.connections, RunService.Heartbeat:Connect(function(dt)
                        if not Data.running then return end
                        acc = acc + dt
                        if acc < 0.25 then return end
                        acc = 0
                        if Controls.moveFunction ~= protectedMove then
                            Controls.moveFunction = protectedMove
                        end
                    end))
                    Controls.moveFunction = protectedMove
                    Data.controlsProtected = true
                end)
            end
            local function restoreControls()
                if not Data.controlsProtected then return end
                pcall(function()
                    local PlayerModule = player.PlayerScripts:FindFirstChild("PlayerModule")
                    if not PlayerModule then return end
                    local Controls = require(PlayerModule):GetControls()
                    if Controls and Data.originalMoveFunction then
                        Controls.moveFunction = Data.originalMoveFunction
                        Data.controlsProtected = false
                    end
                end)
            end
            local function blockBuzzing()
                pcall(function()
                    local beeScript = player.PlayerScripts:FindFirstChild("Bee", true)
                    if beeScript then
                        local buzzing = beeScript:FindFirstChild("Buzzing")
                        if buzzing and buzzing:IsA("Sound") then
                            buzzing:Stop()
                            buzzing.Volume = 0
                        end
                    end
                end)
            end
            local function lockFOV()
                local cam = workspace.CurrentCamera
                if cam then cam.FieldOfView = 70 end
            end
            local function enable()
                if Data.running then return end
                Data.running = true
                for _, inst in ipairs(Lighting:GetDescendants()) do nuke(inst) end
                table.insert(Data.connections, Lighting.DescendantAdded:Connect(function(obj)
                    if Data.running then nuke(obj) end
                end))
                protectControls()
                local buzzAcc = 0
                table.insert(Data.connections, RunService.Heartbeat:Connect(function(dt)
                    if not Data.running then return end
                    buzzAcc = buzzAcc + dt
                    if buzzAcc < 0.25 then return end
                    buzzAcc = 0
                    blockBuzzing()
                    lockFOV()
                end))
            end
            local function disable()
                if not Data.running then return end
                Data.running = false
                restoreControls()
                disconnectAll()
            end
            return { set = function(state) if state then enable() else disable() end end }
        end
        AntiBeeModule = buildAntiBee()
    end

    -- ============================================================
    --  FONCTIONS STEAL
    -- ============================================================
    local function isMyPlotByName(pn)
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return false end
        local plot = plots:FindFirstChild(pn)
        if not plot then return false end
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local yb = sign:FindFirstChild("YourBase")
            if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
        end
        return false
    end

    local function findNearestPrompt()
        local char = player.Character
        local h = char and char:FindFirstChild("HumanoidRootPart")
        if not h then return nil end
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return nil end
        local nearestPrompt, nearestDist, nearestName = nil, math.huge, nil
        for _, plot in ipairs(plots:GetChildren()) do
            if isMyPlotByName(plot.Name) then continue end
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if not podiums then continue end
            for _, pod in ipairs(podiums:GetChildren()) do
                pcall(function()
                    local base = pod:FindFirstChild("Base")
                    local spawn = base and base:FindFirstChild("Spawn")
                    if spawn then
                        local dist = (spawn.Position - h.Position).Magnitude
                        if dist < nearestDist and dist <= Config.STEAL_RADIUS then
                            local att = spawn:FindFirstChild("PromptAttachment")
                            if att then
                                for _, ch in ipairs(att:GetChildren()) do
                                    if ch:IsA("ProximityPrompt") then
                                        nearestPrompt, nearestDist, nearestName = ch, dist, pod.Name
                                        break
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end
        return nearestPrompt, nearestDist, nearestName
    end

    local function ResetProgressBar()
        if floatBar then
            if floatBar.label then floatBar.label.Text = "READY" end
            if floatBar.percent then floatBar.percent.Text = "" end
            if floatBar.fill then floatBar.fill.Size = UDim2.new(0,0,1,0) end
        end
    end

    local function executeSteal(prompt, name)
        if isStealing then return end
        if not StealData[prompt] then
            StealData[prompt] = {hold={}, trigger={}, ready=true}
            pcall(function()
                if getconnections then
                    for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                        if c.Function then table.insert(StealData[prompt].hold, c.Function) end
                    end
                    for _, c in ipairs(getconnections(prompt.Triggered)) do
                        if c.Function then table.insert(StealData[prompt].trigger, c.Function) end
                    end
                end
            end)
        end
        local data = StealData[prompt]
        if not data.ready then return end
        data.ready = false
        isStealing = true
        stealStartTime = tick()
        if floatBar and floatBar.label then floatBar.label.Text = name or "STEALING..." end
        if progressConnection then progressConnection:Disconnect() end
        progressConnection = RunService.Heartbeat:Connect(function()
            if not isStealing then progressConnection:Disconnect() return end
            local prog = math.clamp((tick() - stealStartTime) / Config.STEAL_DURATION, 0, 1)
            if floatBar then
                if floatBar.fill then floatBar.fill.Size = UDim2.new(prog,0,1,0) end
                if floatBar.percent then floatBar.percent.Text = math.floor(prog*100).."%" end
            end
        end)
        task.spawn(function()
            for _, f in ipairs(data.hold) do task.spawn(f) end
            task.wait(Config.STEAL_DURATION)
            for _, f in ipairs(data.trigger) do task.spawn(f) end
            if progressConnection then progressConnection:Disconnect() end
            ResetProgressBar()
            data.ready = true
            isStealing = false
        end)
    end

    local function startAutoSteal()
        if Connections.autoSteal then return end
        Connections.autoSteal = RunService.Heartbeat:Connect(function()
            if not Config.AutoSteal or isStealing then return end
            local prompt, _, name = findNearestPrompt()
            if prompt then executeSteal(prompt, name) end
        end)
    end

    local function stopAutoSteal()
        if Connections.autoSteal then Connections.autoSteal:Disconnect(); Connections.autoSteal=nil end
        isStealing = false
        ResetProgressBar()
    end

    -- ============================================================
    --  ANTI GUMMY / DISCO
    -- ============================================================
    local function clearGummy(char)
        if not char then char = player.Character end
        for _, obj in ipairs({player, char}) do
            if obj then
                if obj:GetAttribute("BlockTools") then obj:SetAttribute("BlockTools", false) end
                if obj:GetAttribute("Web") then obj:SetAttribute("Web", false) end
            end
        end
        if char:GetAttribute("BackpackReady") == false then char:SetAttribute("BackpackReady", true) end
    end

    local function clearBoogie()
        for _, child in pairs(Lighting:GetChildren()) do
            if child.Name == "DiscoEffect" then child:Destroy() end
        end
        local controllers = ReplicatedStorage:FindFirstChild("Controllers")
        if controllers then
            local boogie = controllers:FindFirstChild("BoogieBombController")
            if boogie then
                local boom = boogie:FindFirstChild("BOOM")
                if boom then boom:Stop() end
            end
        end
    end

    -- ============================================================
    --  TP BEST
    -- ============================================================
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local hum = character and character:FindFirstChild("Humanoid")

    local function setupCharacter(char)
        character = char
        hrp = char:FindFirstChild("HumanoidRootPart")
        hum = char:FindFirstChild("Humanoid")
    end
    if player.Character then setupCharacter(player.Character) end
    player.CharacterAdded:Connect(setupCharacter)

    local function equipCarpet()
        if not character or not hum then return end
        local tool = character:FindFirstChild("Flying Carpet") or player.Backpack:FindFirstChild("Flying Carpet")
        if tool then hum:EquipTool(tool) end
    end

    local function savePosition()
        if not hrp then return end
        savedPosition = hrp.Position
        TPButton.Text = "Location Saved"
        TPButton.BackgroundColor3 = Color3.fromRGB(40,140,40)
        task.wait(1.5)
        updateTPButtonText()
    end

    local function teleportToBest()
        if moving or not hrp then return end
        if not savedPosition then
            TPButton.Text = "No position saved"
            task.wait(1); updateTPButtonText(); return
        end
        moving = true
        TPButton.Text = "GOING UP..."
        TPButton.BackgroundColor3 = Color3.fromRGB(60,20,120)
        equipCarpet()
        local duration = 0.3
        local upwardSpeed = 300
        local startTime = tick()
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if not hrp or not hrp.Parent then connection:Disconnect(); moving=false; updateTPButtonText(); return end
            if tick() - startTime >= duration then
                local currentY = hrp.Position.Y
                local savedY = savedPosition.Y
                if currentY >= savedY + MIN_HEIGHT_REQUIRED then hrp.CFrame = CFrame.new(savedPosition) end
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                connection:Disconnect()
                moving = false
                updateTPButtonText()
                return
            end
            hrp.AssemblyLinearVelocity = Vector3.new(0, upwardSpeed, 0)
        end)
    end

    local function updateTPButtonText()
        if TPButton then TPButton.Text = "Save Position"; TPButton.BackgroundColor3 = Color3.fromRGB(100,30,200) end
    end

    -- ============================================================
    --  CARPET BOOST
    -- ============================================================
    local function checkCarpetTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local name = tool.Name:lower()
        return name:find("flying carpet") or name:find("carpet") or name:find("flyingcarpet")
    end

    local function updateCarpetStatus()
        local char = player.Character
        if not char then isCarpetEquipped = false; return end
        local tool = char:FindFirstChildOfClass("Tool")
        isCarpetEquipped = checkCarpetTool(tool)
    end

    local function enableCarpetBoost()
        if carpetBoostConn then return end
        carpetBoostConn = RunService.Heartbeat:Connect(function()
            if not UI.carpetBoostEnabled then return end
            if not isCarpetEquipped then return end
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then return end
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                local flatDir = Vector3.new(moveDir.X, 0, moveDir.Z).Unit
                hrp.Velocity = Vector3.new(flatDir.X * UI.carpetSpeed, hrp.Velocity.Y, flatDir.Z * UI.carpetSpeed)
            end
        end)
    end

    local function disableCarpetBoost()
        if carpetBoostConn then carpetBoostConn:Disconnect(); carpetBoostConn = nil end
    end

    local function refreshCarpetBoost()
        if UI.carpetBoostEnabled then
            disableCarpetBoost()
            task.delay(0.1, function()
                if UI.carpetBoostEnabled then
                    updateCarpetStatus()
                    enableCarpetBoost()
                end
            end)
        else
            disableCarpetBoost()
        end
    end

    local function setupCarpetCharacter(char)
        task.wait(0.3)
        if UI.carpetBoostEnabled then
            updateCarpetStatus()
            enableCarpetBoost()
        end
        char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                task.wait()
                updateCarpetStatus()
                if UI.carpetBoostEnabled then refreshCarpetBoost() end
            end
        end)
        char.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then
                updateCarpetStatus()
                if UI.carpetBoostEnabled then refreshCarpetBoost() end
            end
        end)
    end
    player.CharacterAdded:Connect(setupCarpetCharacter)
    if player.Character then setupCarpetCharacter(player.Character) end

    -- ============================================================
    --  TOGGLES
    -- ============================================================
    local function toggleInfJump()
        setInfinityJump(not infJumpEnabled)
    end

    local function toggleAntiRagdoll()
        UI.AntiRagdollEnabled = not UI.AntiRagdollEnabled
        if UI.AntiRagdollEnabled then startAntiRagdoll() else stopAntiRagdoll() end
        if UI.AntiRagdollStatus then
            UI.AntiRagdollStatus.Text = UI.AntiRagdollEnabled and "ON" or "OFF"
            UI.AntiRagdollStatus.TextColor3 = UI.AntiRagdollEnabled and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        end
        if UI.AntiRagdollPillBg then TweenService:Create(UI.AntiRagdollPillBg, TweenInfo.new(0.25), {BackgroundColor3 = UI.AntiRagdollEnabled and UI.Colors.accent or UI.Colors.inactive}):Play() end
        if UI.AntiRagdollPillCircle then TweenService:Create(UI.AntiRagdollPillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = UI.AntiRagdollEnabled and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}):Play() end
    end

    local function toggleAntiDeath()
        UI.antiDeathEnabled = not UI.antiDeathEnabled
        if UI.antiDeathEnabled then startAntiDeath() else stopAntiDeath() end
        if UI.AntiDeathStatus then
            UI.AntiDeathStatus.Text = UI.antiDeathEnabled and "ON" or "OFF"
            UI.AntiDeathStatus.TextColor3 = UI.antiDeathEnabled and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        end
        if UI.AntiDeathPillBg then TweenService:Create(UI.AntiDeathPillBg, TweenInfo.new(0.25), {BackgroundColor3 = UI.antiDeathEnabled and UI.Colors.accent or UI.Colors.inactive}):Play() end
        if UI.AntiDeathPillCircle then TweenService:Create(UI.AntiDeathPillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = UI.antiDeathEnabled and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}):Play() end
        if UI.AntiDeathCardAccent then TweenService:Create(UI.AntiDeathCardAccent, TweenInfo.new(0.15), {BackgroundColor3 = UI.antiDeathEnabled and UI.Colors.accent or UI.Colors.dim}):Play() end
    end

    local function toggleReset()
        UI.resetEnabled = not UI.resetEnabled
        local on = UI.resetEnabled
        if UI.ResetStatus then
            UI.ResetStatus.Text = on and "ON" or "OFF"
            UI.ResetStatus.TextColor3 = on and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        end
        if UI.ResetPillBg then TweenService:Create(UI.ResetPillBg, TweenInfo.new(0.25), {BackgroundColor3 = on and Color3.fromRGB(50,150,255) or UI.Colors.inactive}):Play() end
        if UI.ResetPillCircle then TweenService:Create(UI.ResetPillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}):Play() end
        if UI.ResetCardAccent then TweenService:Create(UI.ResetCardAccent, TweenInfo.new(0.15), {BackgroundColor3 = on and Color3.fromRGB(50,150,255) or UI.Colors.dim}):Play() end
    end

    local function toggleTpDown()
        UI.tpDownEnabled = not UI.tpDownEnabled
        local on = UI.tpDownEnabled
        if UI.TpDownStatus then
            UI.TpDownStatus.Text = on and "ON" or "OFF"
            UI.TpDownStatus.TextColor3 = on and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        end
        if UI.TpDownPillBg then TweenService:Create(UI.TpDownPillBg, TweenInfo.new(0.25), {BackgroundColor3 = on and Color3.fromRGB(200,100,0) or UI.Colors.inactive}):Play() end
        if UI.TpDownPillCircle then TweenService:Create(UI.TpDownPillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}):Play() end
        if UI.TpDownCardAccent then TweenService:Create(UI.TpDownCardAccent, TweenInfo.new(0.15), {BackgroundColor3 = on and Color3.fromRGB(200,100,0) or UI.Colors.dim}):Play() end
    end

    local function toggleAntiGummy()
        UI.antiGummyEnabled = not UI.antiGummyEnabled
        setSetting("antiGummy", UI.antiGummyEnabled)
        local on = UI.antiGummyEnabled
        if UI.AntiGummyStatus then
            UI.AntiGummyStatus.Text = on and "ON" or "OFF"
            UI.AntiGummyStatus.TextColor3 = on and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        end
        if UI.AntiGummyPillBg then TweenService:Create(UI.AntiGummyPillBg, TweenInfo.new(0.25), {BackgroundColor3 = on and UI.Colors.accent or UI.Colors.inactive}):Play() end
        if UI.AntiGummyPillCircle then TweenService:Create(UI.AntiGummyPillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = on and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,3,0.5,-8)}):Play() end
    end

    local function toggleAntiBoogie()
        UI.antiBoogieEnabled = not UI.antiBoogieEnabled
        setSetting("antiBoogie", UI.antiBoogieEnabled)
        local on = UI.antiBoogieEnabled
        if UI.AntiBoogieStatus then
            UI.AntiBoogieStatus.Text = on and "ON" or "OFF"
            UI.AntiBoogieStatus.TextColor3 = on and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        end
        if UI.AntiBoogiePillBg then TweenService:Create(UI.AntiBoogiePillBg, TweenInfo.new(0.25), {BackgroundColor3 = on and UI.Colors.accent or UI.Colors.inactive}):Play() end
        if UI.AntiBoogiePillCircle then TweenService:Create(UI.AntiBoogiePillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = on and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,3,0.5,-8)}):Play() end
    end

    local function toggleAntiBee()
        UI.antiBeeEnabled = not UI.antiBeeEnabled
        setSetting("antiBee", UI.antiBeeEnabled)
        AntiBeeModule.set(UI.antiBeeEnabled)
        local on = UI.antiBeeEnabled
        if UI.AntiBeeStatus then
            UI.AntiBeeStatus.Text = on and "ON" or "OFF"
            UI.AntiBeeStatus.TextColor3 = on and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        end
        if UI.AntiBeePillBg then TweenService:Create(UI.AntiBeePillBg, TweenInfo.new(0.25), {BackgroundColor3 = on and UI.Colors.accent or UI.Colors.inactive}):Play() end
        if UI.AntiBeePillCircle then TweenService:Create(UI.AntiBeePillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = on and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,3,0.5,-8)}):Play() end
    end

    local function toggleCarpetBoost()
        UI.carpetBoostEnabled = not UI.carpetBoostEnabled
        setSetting("carpetBoostEnabled", UI.carpetBoostEnabled)
        local on = UI.carpetBoostEnabled
        if on then
            updateCarpetStatus()
            enableCarpetBoost()
        else
            disableCarpetBoost()
            isCarpetEquipped = false
        end
        if UI.CarpetStatus then
            UI.CarpetStatus.Text = on and "ON" or "OFF"
            UI.CarpetStatus.TextColor3 = on and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        end
        if UI.CarpetPillBg then
            TweenService:Create(UI.CarpetPillBg, TweenInfo.new(0.25), {BackgroundColor3 = on and UI.Colors.accent or UI.Colors.inactive}):Play()
        end
        if UI.CarpetPillCircle then
            TweenService:Create(UI.CarpetPillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
                Position = on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
            }):Play()
        end
        if UI.CarpetCardAccent then
            TweenService:Create(UI.CarpetCardAccent, TweenInfo.new(0.15), {
                BackgroundColor3 = on and UI.Colors.accent or UI.Colors.dim
            }):Play()
        end
        if UI.CarpetCard then
            TweenService:Create(UI.CarpetCard, TweenInfo.new(0.15), {
                BackgroundColor3 = on and Color3.fromRGB(255,255,255) or UI.Colors.card
            }):Play()
            if UI.CarpetNameLabel then
                UI.CarpetNameLabel.TextColor3 = on and Color3.fromRGB(0,0,0) or UI.Colors.text
            end
            if UI.CarpetStatus then
                UI.CarpetStatus.TextColor3 = on and Color3.fromRGB(0,0,0) or UI.Colors.textDim
            end
            if UI.CarpetSpeedBox then
                UI.CarpetSpeedBox.TextColor3 = on and Color3.fromRGB(0,0,0) or UI.Colors.text
                UI.CarpetSpeedBox.BackgroundColor3 = on and Color3.fromRGB(220,220,220) or Color3.fromRGB(30,30,30)
            end
            if UI.CarpetKeybindBtn then
                UI.CarpetKeybindBtn.TextColor3 = on and Color3.fromRGB(0,0,0) or UI.Colors.text
            end
            if UI.CarpetKeybindLabel then
                UI.CarpetKeybindLabel.TextColor3 = on and Color3.fromRGB(0,0,0) or UI.Colors.textDim
            end
        end
    end

    -- ============================================================
    --  TP 2 : fonction de création de l'interface
    -- ============================================================
    local function createTp2UI()
        local existing = game.CoreGui:FindFirstChild("Tp2_AnimeUI")
        if existing then
            existing.Visible = true
            return existing
        end

        local currentKeybind = tp2Keybind
        local isSettingKeybind = false

        local function _0xMARKER_CREATE(pos, col)
            local part = Instance.new("Part")
            part.Shape = Enum.PartType.Ball
            part.Size = Vector3.new(2.5,2.5,2.5)
            part.Material = Enum.Material.Neon
            part.Anchored = true
            part.CanCollide = false
            part.Position = pos + Vector3.new(0,2,0)
            part.Color = col
            part.Name = "MarkerPoint"
            part.Parent = workspace
            return part
        end

        local _0xSCREEN = Instance.new("ScreenGui")
        _0xSCREEN.Name = "Tp2_AnimeUI"
        _0xSCREEN.Parent = game.CoreGui

        local _0xMAIN = Instance.new("ImageLabel")
        _0xMAIN.Parent = _0xSCREEN
        _0xMAIN.Size = UDim2.new(0,230,0,270)
        _0xMAIN.Position = UDim2.new(0.5,-115,0.5,-135)
        _0xMAIN.Image = ""
        _0xMAIN.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        _0xMAIN.BackgroundTransparency = 0
        _0xMAIN.ScaleType = Enum.ScaleType.Crop
        _0xMAIN.Active = true
        _0xMAIN.Draggable = true

        Instance.new("UICorner", _0xMAIN).CornerRadius = UDim.new(0,16)

        local _0xSTROKE = Instance.new("UIStroke")
        _0xSTROKE.Parent = _0xMAIN
        _0xSTROKE.Color = Color3.fromRGB(0, 0, 0)
        _0xSTROKE.Thickness = 3

        local _0xTITLE = Instance.new("TextLabel")
        _0xTITLE.Parent = _0xMAIN
        _0xTITLE.Size = UDim2.new(1,0,0,35)
        _0xTITLE.BackgroundTransparency = 1
        _0xTITLE.Text = "⚡ TP 2 ⚡"
        _0xTITLE.TextColor3 = Color3.fromRGB(255, 255, 255)
        _0xTITLE.Font = Enum.Font.FredokaOne
        _0xTITLE.TextSize = 22
        _0xTITLE.TextStrokeTransparency = 0.5
        _0xTITLE.TextStrokeColor3 = Color3.fromRGB(0,0,0)

        local _0xCLOSE = Instance.new("TextButton")
        _0xCLOSE.Parent = _0xMAIN
        _0xCLOSE.Size = UDim2.new(0,24,0,24)
        _0xCLOSE.Position = UDim2.new(0,8,0,6)
        _0xCLOSE.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        _0xCLOSE.Text = "X"
        _0xCLOSE.TextColor3 = Color3.fromRGB(255, 255, 255)
        _0xCLOSE.Font = Enum.Font.GothamBold
        _0xCLOSE.TextSize = 14
        Instance.new("UICorner", _0xCLOSE).CornerRadius = UDim.new(1,0)

        local closeStroke = Instance.new("UIStroke")
        closeStroke.Parent = _0xCLOSE
        closeStroke.Color = Color3.fromRGB(0, 0, 0)
        closeStroke.Thickness = 2

        local function _0xCREATE_BTN(text, pos, color)
            local btn = Instance.new("TextButton")
            btn.Parent = _0xMAIN
            btn.Size = UDim2.new(0,195,0,38)
            btn.Position = pos
            btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
            btn.BackgroundTransparency = 0
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 15
            btn.TextStrokeTransparency = 1

            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

            local btnStroke = Instance.new("UIStroke")
            btnStroke.Parent = btn
            btnStroke.Color = Color3.fromRGB(0, 0, 0)
            btnStroke.Thickness = 2

            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 160, 210)}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 130, 180)}):Play()
            end)

            return btn
        end

        local _0xBTN1 = _0xCREATE_BTN("Base", UDim2.new(0.5,-97,0,50), Color3.fromRGB(70, 130, 180))
        local _0xBTN2 = _0xCREATE_BTN("brainrot", UDim2.new(0.5,-97,0,100), Color3.fromRGB(70, 130, 180))
        local _0xBTN3 = _0xCREATE_BTN("🧪 Auto Potion : OFF", UDim2.new(0.5,-97,0,150), Color3.fromRGB(70, 130, 180))
        local _0xBTN4 = _0xCREATE_BTN("⚡ TP [" .. currentKeybind.Name .. "]", UDim2.new(0.5,-97,0,200), Color3.fromRGB(70, 130, 180))

        local btn4Stroke = Instance.new("UIStroke")
        btn4Stroke.Parent = _0xBTN4
        btn4Stroke.Color = Color3.fromRGB(0, 0, 0)
        btn4Stroke.Thickness = 2

        local _0xAUTOPOT = false
        _0xBTN3.MouseButton1Click:Connect(function()
            _0xAUTOPOT = not _0xAUTOPOT
            if _0xAUTOPOT then
                _0xBTN3.Text = "🧪 Auto Potion : ON"
                _0xBTN3.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                _0xBTN3.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                _0xBTN3.Text = "🧪 Auto Potion : OFF"
                _0xBTN3.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
                _0xBTN3.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end)

        local _0xMINI = false
        _0xCLOSE.MouseButton1Click:Connect(function()
            _0xMINI = not _0xMINI
            if _0xMINI then
                _0xBTN1.Visible = false
                _0xBTN2.Visible = false
                _0xBTN3.Visible = false
                _0xMAIN.Size = UDim2.new(0,230,0,95)
                _0xBTN4.Position = UDim2.new(0.5,-97,0,45)
                _0xCLOSE.Text = "+"
            else
                _0xBTN1.Visible = true
                _0xBTN2.Visible = true
                _0xBTN3.Visible = true
                _0xMAIN.Size = UDim2.new(0,230,0,270)
                _0xBTN4.Position = UDim2.new(0.5,-97,0,200)
                _0xCLOSE.Text = "X"
            end
        end)

        _0xBTN1.MouseButton1Click:Connect(function()
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                _G.Tp2Pos1 = hrp.Position
                if _G.Tp2Marker1 then _G.Tp2Marker1:Destroy() end
                _G.Tp2Marker1 = _0xMARKER_CREATE(_G.Tp2Pos1, Color3.fromRGB(0, 0, 0))
                _0xBTN1.Text = "⚡ Sauvegardé ⚡"
                _0xBTN1.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                task.wait(0.8)
                _0xBTN1.Text = "Base"
                _0xBTN1.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
            end
        end)

        _0xBTN2.MouseButton1Click:Connect(function()
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                _G.Tp2Pos2 = hrp.Position
                if _G.Tp2Marker2 then _G.Tp2Marker2:Destroy() end
                _G.Tp2Marker2 = _0xMARKER_CREATE(_G.Tp2Pos2, Color3.fromRGB(0, 0, 0))
                _0xBTN2.Text = "⚡ Sauvegardé ⚡"
                _0xBTN2.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                task.wait(0.8)
                _0xBTN2.Text = "brainrot"
                _0xBTN2.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
            end
        end)

        local function _0xEQUIP_CAR()
            local char = player.Character
            local bp = player:FindFirstChild("Backpack")
            if not char or not bp then return false end
            for _,tool in pairs(char:GetChildren()) do
                if tool:IsA("Tool") then tool.Parent = bp end
            end
            for _,tool in pairs(bp:GetChildren()) do
                if tool:IsA("Tool") and string.find(tool.Name:lower(),"carpet") then
                    tool.Parent = char
                    return true
                end
            end
            return false
        end

        local function DO_TELEPORT()
            if not _G.Tp2Pos1 or not _G.Tp2Pos2 then
                _0xBTN4.Text = "❌ Points manquants"
                _0xBTN4.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                task.wait(1)
                _0xBTN4.Text = "⚡ TP [" .. currentKeybind.Name .. "]"
                _0xBTN4.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
                return
            end

            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            _0xBTN4.Text = "💫 TP en cours..."
            _0xBTN4.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
            _0xEQUIP_CAR()

            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(_G.Tp2Pos1 + Vector3.new(0,3,0))
            task.wait(0.1)
            hrp.CFrame = CFrame.new(_G.Tp2Pos2 + Vector3.new(0,3,0))

            _0xBTN4.Text = "⭐ TP x2 réussi ⭐"
            _0xBTN4.BackgroundColor3 = Color3.fromRGB(50, 200, 50)

            if _0xAUTOPOT then
                local bp = player:FindFirstChild("Backpack")
                task.wait(0.15)
                for _,tool in pairs(bp:GetChildren()) do
                    if tool:IsA("Tool") then
                        local n = tool.Name:lower()
                        if n:find("giant") or n:find("huge") or n:find("gigant") then
                            tool.Parent = player.Character
                            task.wait(0.1)
                            tool:Activate()
                            break
                        end
                    end
                end
            end

            task.wait(0.8)
            _0xBTN4.Text = "⚡ TP [" .. currentKeybind.Name .. "]"
            _0xBTN4.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        end

        _0xBTN4.MouseButton1Click:Connect(function()
            if not isSettingKeybind then
                DO_TELEPORT()
            end
        end)

        _0xBTN4.MouseButton2Click:Connect(function()
            if not isSettingKeybind then
                isSettingKeybind = true
                _0xBTN4.Text = "⚡ Appuyez sur une touche..."
                _0xBTN4.BackgroundColor3 = Color3.fromRGB(100, 160, 210)
            end
        end)

        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if isSettingKeybind and input.UserInputType == Enum.UserInputType.Keyboard then
                currentKeybind = input.KeyCode
                isSettingKeybind = false
                _0xBTN4.Text = "⚡ TP [" .. currentKeybind.Name .. "]"
                _0xBTN4.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
                return
            end
            if input.KeyCode == currentKeybind and not isSettingKeybind then
                DO_TELEPORT()
            end
        end)

        print("TP 2 Anime UI chargé ! ⚡")
        return _0xSCREEN
    end

    -- ============================================================
    --  ESP LINIA
    -- ============================================================
    local function createESPObjectsForPlayer(p)
        if p == player then return end
        if espData[p] then return end
        local d = {}
        d.l = Drawing.new("Line")
        d.l.Thickness = 0.1
        d.l.Transparency = 1 - espTransparency * 0.7
        d.l.Color = espColors.l

        local function N() local x = Drawing.new("Line"); x.Thickness = 2; x.Color = espColors.w; x.Visible = false; return x end
        local function S() local x = Drawing.new("Square"); x.Thickness = 1.5; x.Filled = false; x.Color = espColors.g; x.Visible = false; return x end
        local function T() local x = Drawing.new("Text"); x.Size = 11; x.Center = true; x.Outline = true; x.OutlineColor = espColors.k; x.Visible = false; return x end

        d.b = S()
        d.i = S()
        d.i.Thickness = 1
        d.i.Color = espColors.k
        d.c = {N(), N(), N(), N(), N(), N(), N(), N()}
        d.n = T(); d.n.Size = 13; d.n.Color = espColors.w
        d.t = T(); d.t.Color = espColors.d
        d.h = T(); d.h.Color = espColors.w
        d.p = Drawing.new("Square"); d.p.Filled = true; d.p.Color = espColors.b; d.p.Visible = false
        d.f = Drawing.new("Square"); d.f.Filled = true; d.f.Color = espColors.w; d.f.Visible = false
        espData[p] = d
    end

    local function addHighlightToCharacter(ch)
        if not ch then return end
        if ch:FindFirstChild("LiniaHighlight") then return end
        local h = Instance.new("Highlight")
        h.Name = "LiniaHighlight"
        h.FillColor = espColors.h
        h.FillTransparency = espTransparency
        h.OutlineColor = espColors.o
        h.OutlineTransparency = 0.2
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = ch
    end

    local function removeHighlightFromCharacter(ch)
        if not ch then return end
        local h = ch:FindFirstChild("LiniaHighlight")
        if h then h:Destroy() end
    end

    local function updateHighlightTransparency()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                local ch = plr.Character
                if ch then
                    local h = ch:FindFirstChild("LiniaHighlight")
                    if h then h.FillTransparency = espTransparency end
                end
            end
        end
    end

    local function setupLiniaESP()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                createESPObjectsForPlayer(p)
                if p.Character then
                    task.wait(0.1)
                    addHighlightToCharacter(p.Character)
                end
            end
        end

        Players.PlayerAdded:Connect(function(p)
            createESPObjectsForPlayer(p)
            p.CharacterAdded:Connect(function(ch)
                task.wait(0.1)
                addHighlightToCharacter(ch)
            end)
        end)

        Players.PlayerRemoving:Connect(function(p)
            if espData[p] then
                for k, v in pairs(espData[p]) do
                    if k ~= "HL" and v then pcall(function() v:Remove() end) end
                end
                espData[p] = nil
            end
            if p.Character then removeHighlightFromCharacter(p.Character) end
        end)

        espConnection = RunService.RenderStepped:Connect(function()
            camera = workspace.CurrentCamera
            if not espEnabled then
                for p, d in pairs(espData) do
                    for k, v in pairs(d) do
                        if k ~= "HL" and v then v.Visible = false end
                    end
                end
                return
            end
            for p, d in pairs(espData) do
                local ch = p.Character
                local hr = ch and ch:FindFirstChild("HumanoidRootPart")
                local hm = ch and ch:FindFirstChildOfClass("Humanoid")
                local hd = ch and ch:FindFirstChild("Head")

                if ch and hm and hm.Health > 0 then
                    addHighlightToCharacter(ch)
                else
                    removeHighlightFromCharacter(ch)
                end

                if hr and hm and hd and hm.Health > 0 then
                    local t = (hr.Position - camera.CFrame.Position).Magnitude
                    local ps, vs = camera:WorldToViewportPoint(hr.Position)
                    if vs and t <= 5000 then
                        local hps = camera:WorldToViewportPoint(hd.Position + Vector3.new(0, 0.5, 0))
                        local fps = camera:WorldToViewportPoint(hr.Position - Vector3.new(0, 3, 0))
                        local h = math.abs(hps.Y - fps.Y)
                        local w = h * 0.5
                        local x = ps.X - w / 2
                        local y = ps.Y - h / 2
                        local s = 6
                        pcall(function()
                            d.l.Visible = true
                            d.l.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                            d.l.To = Vector2.new(ps.X, ps.Y)
                        end)
                        pcall(function()
                            d.b.Visible = true
                            d.b.Size = Vector2.new(w, h)
                            d.b.Position = Vector2.new(x, y)
                        end)
                        pcall(function()
                            d.i.Visible = true
                            d.i.Size = Vector2.new(w - 4, h - 4)
                            d.i.Position = Vector2.new(x + 2, y + 2)
                        end)
                        local function cn(i, a, b) d.c[i].Visible = true; d.c[i].From = a; d.c[i].To = b end
                        cn(1, Vector2.new(x, y), Vector2.new(x + s, y))
                        cn(2, Vector2.new(x, y), Vector2.new(x, y + s))
                        cn(3, Vector2.new(x + w, y), Vector2.new(x + w - s, y))
                        cn(4, Vector2.new(x + w, y), Vector2.new(x + w, y + s))
                        cn(5, Vector2.new(x, y + h), Vector2.new(x + s, y + h))
                        cn(6, Vector2.new(x, y + h), Vector2.new(x, y + h - s))
                        cn(7, Vector2.new(x + w, y + h), Vector2.new(x + w - s, y + h))
                        cn(8, Vector2.new(x + w, y + h), Vector2.new(x + w, y + h - s))
                        pcall(function()
                            d.n.Visible = true
                            d.n.Position = Vector2.new(ps.X, y - 18)
                            d.n.Text = p.DisplayName or p.Name
                        end)
                        pcall(function()
                            d.t.Visible = true
                            d.t.Position = Vector2.new(ps.X, y - 32)
                            d.t.Text = math.floor(t) .. " studs"
                        end)
                        local hp = hm.Health / hm.MaxHealth
                        pcall(function()
                            d.h.Visible = true
                            d.h.Position = Vector2.new(ps.X, y + h + 6)
                            d.h.Text = math.floor(hm.Health) .. "/" .. math.floor(hm.MaxHealth)
                        end)
                        pcall(function()
                            d.p.Visible = true
                            d.p.Size = Vector2.new(w, 4)
                            d.p.Position = Vector2.new(x, y + h + 2)
                        end)
                        pcall(function()
                            d.f.Visible = true
                            d.f.Size = Vector2.new(w * hp, 4)
                            d.f.Position = Vector2.new(x, y + h + 2)
                        end)
                    else
                        for k, v in pairs(d) do
                            if k ~= "HL" and v then v.Visible = false end
                        end
                    end
                else
                    for k, v in pairs(d) do
                        if k ~= "HL" and v then v.Visible = false end
                    end
                end
            end
        end)

        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    addHighlightToCharacter(p.Character)
                end
            end
        end)
    end

    local function startLiniaESP()
        if espConnection then return end
        setupLiniaESP()
    end

    local function stopLiniaESP()
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        for p, d in pairs(espData) do
            for k, v in pairs(d) do
                if k ~= "HL" and v then pcall(function() v.Visible = false end) end
            end
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                local ch = plr.Character
                if ch then removeHighlightFromCharacter(ch) end
            end
        end
    end

    local function toggleESPPlayers()
        espEnabled = not espEnabled
        setSetting("espEnabled", espEnabled)
        local on = espEnabled
        if UI.EspStatusLabel then
            UI.EspStatusLabel.Text = on and "ON" or "OFF"
            UI.EspStatusLabel.TextColor3 = on and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        end
        if UI.EspPillBg then
            TweenService:Create(UI.EspPillBg, TweenInfo.new(0.25), {BackgroundColor3 = on and UI.Colors.accent or UI.Colors.inactive}):Play()
        end
        if UI.EspPillCircle then
            TweenService:Create(UI.EspPillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}):Play()
        end
        if UI.EspCardStroke then
            TweenService:Create(UI.EspCardStroke, TweenInfo.new(0.15), {Color = on and UI.Colors.borderHi or UI.Colors.border}):Play()
        end
        if UI.EspCardAccent then
            TweenService:Create(UI.EspCardAccent, TweenInfo.new(0.15), {BackgroundColor3 = on and UI.Colors.accent or UI.Colors.dim}):Play()
        end
        if on then startLiniaESP() else stopLiniaESP() end
    end

    local function setESPTransparency(newTrans)
        espTransparency = math.clamp(newTrans, 0, 1)
        setSetting("espTransparency", espTransparency)
        if UI.EspTransparencyLabel then
            UI.EspTransparencyLabel.Text = "Intensité: " .. string.format("%.1f", espTransparency)
        end
        updateHighlightTransparency()
        for p, d in pairs(espData) do
            if d.l then d.l.Transparency = 1 - espTransparency * 0.7 end
        end
    end

    -- ============================================================
    --  ANTI-LAG
    -- ============================================================
    local antiLagEnabled = false
    local antiLagDescConn = nil
    local removeAccessoriesEnabled = false

    local function applyAntiLagDerender(obj)
        pcall(function()
            if obj:IsA("Accessory") or obj:IsA("Hat") then
                obj:Destroy()
            elseif obj:IsA("BasePart") then
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
                obj.CastShadow = false
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj.Enabled = false
            elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
                for _, t in ipairs(obj:GetPlayingAnimationTracks()) do
                    pcall(function() t:Stop(0) end)
                end
            end
        end)
    end

    local function enableAntiLag()
        antiLagEnabled = true
        removeAccessoriesEnabled = true
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e10
        Lighting.Brightness = 1
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        for _, e in ipairs(Lighting:GetChildren()) do
            pcall(function()
                if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                    e.Enabled = false
                end
            end)
        end
        for _, obj in ipairs(workspace:GetDescendants()) do
            applyAntiLagDerender(obj)
        end
        if antiLagDescConn then antiLagDescConn:Disconnect() end
        antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
            if removeAccessoriesEnabled then applyAntiLagDerender(obj) end
        end)
        if UI.AntiLagStatus then
            UI.AntiLagStatus.Text = "ON"
            UI.AntiLagStatus.TextColor3 = Color3.fromRGB(80,255,80)
        end
        if UI.AntiLagPillBg then TweenService:Create(UI.AntiLagPillBg, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(0,180,0)}):Play() end
        if UI.AntiLagPillCircle then TweenService:Create(UI.AntiLagPillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = UDim2.new(1,-21,0.5,-9)}):Play() end
        if UI.AntiLagCardAccent then TweenService:Create(UI.AntiLagCardAccent, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0,180,0)}):Play() end
    end

    local function disableAntiLag()
        antiLagEnabled = false
        removeAccessoriesEnabled = false
        if antiLagDescConn then
            antiLagDescConn:Disconnect()
            antiLagDescConn = nil
        end
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 10000
        Lighting.Brightness = 2
        Lighting.EnvironmentDiffuseScale = 1
        Lighting.EnvironmentSpecularScale = 1
        if UI.AntiLagStatus then
            UI.AntiLagStatus.Text = "OFF"
            UI.AntiLagStatus.TextColor3 = UI.Colors.textDim
        end
        if UI.AntiLagPillBg then TweenService:Create(UI.AntiLagPillBg, TweenInfo.new(0.25), {BackgroundColor3 = UI.Colors.inactive}):Play() end
        if UI.AntiLagPillCircle then TweenService:Create(UI.AntiLagPillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = UDim2.new(0,3,0.5,-9)}):Play() end
        if UI.AntiLagCardAccent then TweenService:Create(UI.AntiLagCardAccent, TweenInfo.new(0.15), {BackgroundColor3 = UI.Colors.dim}):Play() end
    end

    local function toggleAntiLag()
        if antiLagEnabled then disableAntiLag() else enableAntiLag() end
    end

    -- ============================================================
    --  AUTO SENTRY
    -- ============================================================
    local function getBat()
        if resizedBat and resizedBat.Parent then return resizedBat end
        local Backpack = player:FindFirstChild("Backpack")
        if Backpack then
            for _, tool in ipairs(Backpack:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:lower() == "bat" then
                    if tool:FindFirstChild("Handle") then
                        tool.Handle.Size = Vector3.new(1000,1000,1000)
                        resizedBat = tool; return tool
                    end
                end
            end
        end
        if player.Character then
            for _, tool in ipairs(player.Character:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:lower() == "bat" then
                    if tool:FindFirstChild("Handle") then
                        tool.Handle.Size = Vector3.new(1000,1000,1000)
                        resizedBat = tool; return tool
                    end
                end
            end
        end
        return nil
    end

    local function attackSentry(sentry)
        task.wait(4)
        while sentry.Parent and autoSentryEnabled do
            local bat = getBat()
            if bat and player.Character and player.Character:FindFirstChild("Humanoid") then
                if player.Character.Humanoid.Health > 0 then player.Character.Humanoid:EquipTool(bat) end
                bat:Activate()
            end
            task.wait(0.1)
        end
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:UnequipTools()
        end
    end

    local function toggleAutoSentry(value)
        autoSentryEnabled = value
        if UI.sentryToggleBtn then UI.sentryToggleBtn.Text = autoSentryEnabled and "🤖 Auto Destroy Sentry: ON" or "🤖 Auto Destroy Sentry: OFF" end
        if UI.sentryStatusLabel then
            UI.sentryStatusLabel.Text = autoSentryEnabled and "ON" or "OFF"
            UI.sentryStatusLabel.TextColor3 = autoSentryEnabled and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        end
        if UI.sentryPillBg then TweenService:Create(UI.sentryPillBg, TweenInfo.new(0.25), {BackgroundColor3 = autoSentryEnabled and UI.Colors.accent or UI.Colors.inactive}):Play() end
        if UI.sentryPillCircle then TweenService:Create(UI.sentryPillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = autoSentryEnabled and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}):Play() end
        if UI.sentryCardAccent then TweenService:Create(UI.sentryCardAccent, TweenInfo.new(0.15), {BackgroundColor3 = autoSentryEnabled and UI.Colors.accent or UI.Colors.dim}):Play() end
        if value then
            task.spawn(function()
                while autoSentryEnabled do
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj.Name:sub(1,6):lower() == "sentry" then
                            if not obj.Name:find(tostring(player.UserId)) then
                                task.spawn(function() attackSentry(obj) end)
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end

    -- ============================================================
    --  AUTO DESTROY V2
    -- ============================================================
    local function isEnemyTurret(obj)
        if not obj or not obj:IsA("BasePart") then return false end
        local name = obj.Name
        local nameLower = name:lower()
        local ownerId = nil
        ownerId = name:match("^Sentry_(%d+)$") or name:match("^sentry_(%d+)$")
        if not ownerId then
            ownerId = name:match("^CandySentry_(%d+)$")
                or name:match("^Candy_Sentry_(%d+)$")
                or name:match("^candy_sentry_(%d+)$")
                or name:match("^candysentry_(%d+)$")
                or nameLower:match("^candy[_%-]?sentry_(%d+)$")
        end
        if not ownerId and nameLower:find("candy") and nameLower:find("sentry") then
            ownerId = name:match("(%d+)$")
        end
        if not ownerId then ownerId = name:match("^[Tt]urret_(%d+)$") end
        if not ownerId and nameLower:find("sentry") then ownerId = name:match("(%d+)$") end
        return ownerId ~= nil and tostring(ownerId) ~= tostring(player.UserId)
    end

    local function setTurretNoClip(turret)
        if not isEnemyTurret(turret) then return end
        pcall(function()
            turret.CanCollide = false
            turret.Anchored = true
            turret.AssemblyLinearVelocity = Vector3.zero
            turret.AssemblyAngularVelocity = Vector3.zero
        end)
    end

    local function getTurretTimeLabel(turret)
        if not turret or not turret.Parent then return nil end
        local setupFrame = turret:FindFirstChild("SetupFrame")
        local mainFrame = setupFrame and setupFrame:FindFirstChild("MainFrame")
        local timeLabel = mainFrame and mainFrame:FindFirstChild("Time")
        if timeLabel and timeLabel:IsA("TextLabel") then return timeLabel end
        for _, d in ipairs(turret:GetDescendants()) do
            if d:IsA("TextLabel") then
                local n = d.Name:lower()
                if n == "time" or n == "timer" or n == "countdown" then return d end
            end
        end
        return nil
    end

    local function shouldAttackTurret(turret)
        if player:GetAttribute("Stealing") ~= nil then return false end
        if not isEnemyTurret(turret) then return false end
        setTurretNoClip(turret)
        local timeLabel = getTurretTimeLabel(turret)
        if timeLabel then
            local ok, text = pcall(function() return timeLabel.Text end)
            if not ok then return false end
            text = tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
            if text == "" then return false end
            if string.find(text, "^%d+%s*[sS]!?$") then return true end
            if string.find(text, "^%d+$") then return true end
            return false
        end
        return true
    end

    local function bringTurretInFront(turret, hrp)
        if not turret or not hrp then return end
        local forward = hrp.CFrame.LookVector
        local targetPos = hrp.Position + forward * 2.8 + Vector3.new(0, 1.15, 0)
        local targetCf = CFrame.lookAt(targetPos, targetPos + forward)
        pcall(function()
            turret.AssemblyLinearVelocity = Vector3.zero
            turret.AssemblyAngularVelocity = Vector3.zero
            turret.CFrame = targetCf
        end)
    end

    local function findBatV2()
        local char = player.Character
        if not char then return nil end
        local bat = char:FindFirstChild("Bat") or player.Backpack:FindFirstChild("Bat")
        if bat then return bat end
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find("bat") then return t end
        end
        for _, t in ipairs(player.Backpack:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find("bat") then return t end
        end
        return nil
    end

    local function ensureBatEquippedV2(hum, char)
        if not hum or not char then return nil end
        local held = char:FindFirstChildOfClass("Tool")
        if held and (held.Name == "Bat" or held.Name:lower():find("bat")) then return held end
        local bat = findBatV2()
        if not bat then return nil end
        pcall(function() hum:EquipTool(bat) end)
        return char:FindFirstChild("Bat") or bat
    end

    local function attackTurretV2(turret)
        local now = os.clock()
        if turretAttackBusy[turret] or turretAttackQueued[turret] then return end
        if activeAttackCount >= MAX_CONCURRENT then return end
        if not shouldAttackTurret(turret) then return end
        if (turretAttackCooldownUntil[turret] or 0) > now then return end
        turretAttackQueued[turret] = true
        turretAttackCooldownUntil[turret] = now + TURRET_ATTACK_RETRY_DELAY
        task.spawn(function()
            turretAttackQueued[turret] = nil
            if activeAttackCount >= MAX_CONCURRENT then return end
            if turretAttackBusy[turret] or not shouldAttackTurret(turret) then return end
            activeAttackCount = activeAttackCount + 1
            turretAttackBusy[turret] = true
            local ok, err = xpcall(function()
                local attempts = 0
                local batReady = false
                while attempts < MAX_ATTEMPTS and autoDestroyV2Enabled do
                    if not turret or not turret.Parent or not shouldAttackTurret(turret) then break end
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if not hrp or not hum or hum.Health <= 0 then break end
                    local okDistance, distance = pcall(function() return (turret.Position - hrp.Position).Magnitude end)
                    if okDistance and distance > MAX_DISTANCE then break end
                    setTurretNoClip(turret)
                    bringTurretInFront(turret, hrp)
                    local bat
                    if not batReady then
                        bat = ensureBatEquippedV2(hum, char)
                        batReady = bat ~= nil
                    else
                        bat = char:FindFirstChild("Bat") or findBatV2()
                        local held = char:FindFirstChildOfClass("Tool")
                        if held and held.Name ~= "Bat" and not held.Name:lower():find("bat") then break end
                    end
                    if bat then pcall(function() bat:Activate() end) end
                    attempts = attempts + 1
                    task.wait(ATTACK_INTERVAL)
                end
            end, debug.traceback)
            turretAttackBusy[turret] = nil
            activeAttackCount = math.max(0, activeAttackCount - 1)
            if not ok then warn("Destroy V2 error:", err) end
        end)
    end

    local function startDestroyV2Loop()
        if destroyV2Task then return end
        destroyV2Running = true
        destroyV2Task = task.spawn(function()
            while destroyV2Running do
                if autoDestroyV2Enabled then
                    local pending = {}
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if isEnemyTurret(obj) then
                            setTurretNoClip(obj)
                            if shouldAttackTurret(obj) and not turretAttackBusy[obj] then
                                table.insert(pending, obj)
                            end
                        end
                    end
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp and #pending > 0 then
                        table.sort(pending, function(a, b)
                            local da = (a.Position - hrp.Position).Magnitude
                            local db = (b.Position - hrp.Position).Magnitude
                            return da < db
                        end)
                        for i = 1, math.min(MAX_CONCURRENT, #pending) do
                            attackTurretV2(pending[i])
                        end
                    end
                end
                task.wait(0.25)
            end
        end)
    end

    local function stopDestroyV2Loop()
        destroyV2Running = false
        if destroyV2Task then task.cancel(destroyV2Task); destroyV2Task = nil end
        activeAttackCount = 0
        for k in pairs(turretAttackBusy) do turretAttackBusy[k]=nil end
        for k in pairs(turretAttackQueued) do turretAttackQueued[k]=nil end
        for k in pairs(turretAttackCooldownUntil) do turretAttackCooldownUntil[k]=nil end
    end

    local function toggleAutoDestroyV2()
        autoDestroyV2Enabled = not autoDestroyV2Enabled
        local on = autoDestroyV2Enabled
        if UI.destroyV2StatusLabel then
            UI.destroyV2StatusLabel.Text = on and "ON" or "OFF"
            UI.destroyV2StatusLabel.TextColor3 = on and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        end
        if UI.destroyV2PillBg then TweenService:Create(UI.destroyV2PillBg, TweenInfo.new(0.25), {BackgroundColor3 = on and UI.Colors.accent or UI.Colors.inactive}):Play() end
        if UI.destroyV2PillCircle then TweenService:Create(UI.destroyV2PillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}):Play() end
        if UI.destroyV2CardAccent then TweenService:Create(UI.destroyV2CardAccent, TweenInfo.new(0.15), {BackgroundColor3 = on and UI.Colors.accent or UI.Colors.dim}):Play() end
        for _, btn in ipairs(mobileButtons) do
            if btn and btn.Name == "DestroyBtn" then
                if on then
                    TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 200, 50)}):Play()
                    btn.Text = "ON"
                    task.delay(0.5, function() if btn and btn.Parent then btn.Text = "DESTROY\nV2" end end)
                else
                    TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(150, 0, 150)}):Play()
                    btn.Text = "OFF"
                    task.delay(0.5, function() if btn and btn.Parent then btn.Text = "DESTROY\nV2" end end)
                end
            end
        end
        if on then startDestroyV2Loop() else stopDestroyV2Loop() end
    end

    -- ============================================================
    --  BOUCLES ANTI GUMMY & DISCO
    -- ============================================================
    RunService.Heartbeat:Connect(function()
        if UI.antiGummyEnabled and player.Character then clearGummy(player.Character) end
        if UI.antiBoogieEnabled then clearBoogie() end
    end)
    player.CharacterAdded:Connect(function(char)
        task.wait(0.6)
        if UI.antiGummyEnabled then clearGummy(char) end
    end)

    -- ============================================================
    --  AIMBOT
    -- ============================================================
    local LOCK_RANGE, LOCK_FOV = 100, 200
    local TOOLS = {["Web Slinger"]=true, ["Paintball Gun"]=true, ["Laser Cape"]=true}
    local hookedTools, currentEnemy, lastUpdate, PlayerMouseModule = {}, nil, 0, nil

    local function getPlayerMouse()
        if PlayerMouseModule then return PlayerMouseModule end
        local success, result = pcall(function()
            local packages = ReplicatedStorage:FindFirstChild("Packages")
            if not packages then return nil end
            return require(packages:WaitForChild("PlayerMouse", 5))
        end)
        if success and result then PlayerMouseModule = result; return result end
        return nil
    end

    local function findBestEnemy()
        local localChar = player.Character
        if not localChar or not localChar.Parent then return nil end
        local localRoot = localChar:FindFirstChild("HumanoidRootPart")
        local camera = workspace.CurrentCamera
        if not localRoot or not camera then return nil end
        local cameraPos = camera.CFrame.Position
        local cameraDir = camera.CFrame.LookVector
        local bestRoot, bestScore = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr == player then continue end
            local char = plr.Character
            if not char or not char.Parent then continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not root or not hum or hum.Health <= 0 then continue end
            local dist = (root.Position - localRoot.Position).Magnitude
            if dist > LOCK_RANGE then continue end
            local dirToEnemy = (root.Position - cameraPos).Unit
            local angle = cameraDir:Dot(dirToEnemy)
            local angleDeg = math.deg(math.acos(math.clamp(angle, -1, 1)))
            local score = dist
            if angleDeg > LOCK_FOV then score = score + 1000 end
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            raycastParams.FilterDescendantsInstances = {localChar, camera}
            local raycastResult = workspace:Raycast(cameraPos, (root.Position - cameraPos) * 0.95, raycastParams)
            local visible = not raycastResult or raycastResult.Instance:IsDescendantOf(char)
            if visible then score = score - 50 end
            if score < bestScore then bestScore = score; bestRoot = root end
        end
        return bestRoot
    end

    local function overrideMouse()
        if not UI.aimbotState then return end
        local PlayerMouse = getPlayerMouse()
        if not PlayerMouse then return end
        local enemy = findBestEnemy()
        if enemy and enemy.Parent and enemy.Parent:FindFirstChildOfClass("Humanoid") then
            local hum = enemy.Parent:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local pos = enemy.Position
                local velocity = enemy.AssemblyLinearVelocity or Vector3.new(0,0,0)
                local predictedPos = pos + velocity * 0.1
                pcall(function()
                    PlayerMouse.Hit = CFrame.new(predictedPos)
                    PlayerMouse.Target = enemy
                end)
                currentEnemy = enemy
            end
        end
    end

    local function hookTool(tool)
        if hookedTools[tool] then return end
        if not tool or not tool.Parent then return end
        hookedTools[tool] = true
        local conn1 = tool.Activated:Connect(function() overrideMouse() end)
        local conn2
        conn2 = tool.Equipped:Connect(function()
            task.wait(0.1)
            local PlayerMouse = getPlayerMouse()
            if PlayerMouse and UI.aimbotState then
                local oldFunc = PlayerMouse.Button1Down
                PlayerMouse.Button1Down = function(...)
                    overrideMouse()
                    if oldFunc then oldFunc(...) end
                end
            end
        end)
        local conn3 = tool.Unequipped:Connect(function() end)
        tool.Destroying:Connect(function()
            hookedTools[tool] = nil
            conn1:Disconnect()
            if conn2 then conn2:Disconnect() end
            if conn3 then conn3:Disconnect() end
        end)
    end

    local function watchForTool(parent)
        if not parent then return end
        for _, child in ipairs(parent:GetChildren()) do
            if TOOLS[child.Name] and not hookedTools[child] then hookTool(child) end
        end
        parent.ChildAdded:Connect(function(child)
            task.wait(0.05)
            if TOOLS[child.Name] and not hookedTools[child] then hookTool(child) end
        end)
    end

    local function setupCharacterAimbot(char)
        if not char then return end
        local maxWait = 20; local waitCount = 0
        while not char.Parent and waitCount < maxWait do task.wait(0.1); waitCount=waitCount+1 end
        task.wait(0.2)
        watchForTool(char)
        watchForTool(player.Backpack)
    end

    local function initializeAimbot()
        watchForTool(player.Backpack)
        if player.Character and player.Character.Parent then setupCharacterAimbot(player.Character) end
        player.CharacterAdded:Connect(setupCharacterAimbot)
    end

    RunService.RenderStepped:Connect(function()
        if not UI.aimbotState then return end
        local now = tick()
        if now - lastUpdate > 0.1 then lastUpdate=now; findBestEnemy() end
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then overrideMouse() end
    end)

    local function toggleAimbot()
        UI.aimbotState = not UI.aimbotState
        local on = UI.aimbotState
        if UI.AimbotStatusLabel then
            UI.AimbotStatusLabel.Text = on and "ON" or "OFF"
            UI.AimbotStatusLabel.TextColor3 = on and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        end
        if UI.AimbotPillBg then TweenService:Create(UI.AimbotPillBg, TweenInfo.new(0.25), {BackgroundColor3 = on and UI.Colors.accent or UI.Colors.inactive}):Play() end
        if UI.AimbotPillCircle then TweenService:Create(UI.AimbotPillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}):Play() end
        if UI.AimbotCardStroke then TweenService:Create(UI.AimbotCardStroke, TweenInfo.new(0.15), {Color = on and UI.Colors.borderHi or UI.Colors.border}):Play() end
        if UI.AimbotCardAccent then TweenService:Create(UI.AimbotCardAccent, TweenInfo.new(0.15), {BackgroundColor3 = on and UI.Colors.accent or UI.Colors.dim}):Play() end
    end

    -- ============================================================
    --  CRÉATION DE LA GUI
    -- ============================================================
    local function buildUI()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "RARAHUB"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = player:WaitForChild("PlayerGui")
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        UI.Colors = {
            bg = Color3.fromRGB(18,18,30),
            accent = Color3.fromRGB(100,50,200),
            accentLight = Color3.fromRGB(130,80,220),
            text = Color3.fromRGB(255,255,255),
            textDim = Color3.fromRGB(150,150,180),
            card = Color3.fromRGB(26,26,46),
            border = Color3.fromRGB(52,52,72),
            borderHi = Color3.fromRGB(120,120,120),
            active = Color3.fromRGB(200,200,220),
            inactive = Color3.fromRGB(42,42,62),
            dim = Color3.fromRGB(80,80,100)
        }

        local barSize = UDim2.new(0, 380, 0, 55)
        local minBarWidth = 200
        local maxBarWidth = 600
        local minBarHeight = 30
        local maxBarHeight = 80

        local function createProgressBar(parent, pos, size)
            local container = Instance.new("Frame", parent)
            container.Size = size or barSize
            container.Position = pos or UDim2.new(0.5,-190,0,10)
            container.BackgroundColor3 = Color3.fromRGB(10,10,20)
            container.ClipsDescendants = true
            Instance.new("UICorner", container).CornerRadius = UDim.new(0,8)
            container.Visible = false

            local dragging = false
            local dragStart, dragStartPos

            container.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    dragStartPos = container.Position
                    container.ZIndex = 20
                end
            end)
            container.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - dragStart
                    container.Position = UDim2.new(
                        dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
                        dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
                    )
                end
            end)
            container.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                    container.ZIndex = 1
                end
            end)

            local stroke = Instance.new("UIStroke", container)
            stroke.Thickness = 1.5; stroke.Color = UI.Colors.accent

            local resizeBtn = Instance.new("TextButton", container)
            resizeBtn.Size = UDim2.new(0, 20, 0, 20)
            resizeBtn.Position = UDim2.new(1, -22, 1, -22)
            resizeBtn.BackgroundColor3 = UI.Colors.accent
            resizeBtn.BackgroundTransparency = 0.3
            resizeBtn.Text = "↘"
            resizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
            resizeBtn.TextSize = 12
            resizeBtn.Font = Enum.Font.GothamBold
            resizeBtn.BorderSizePixel = 0
            Instance.new("UICorner", resizeBtn).CornerRadius = UDim.new(0, 4)
            resizeBtn.ZIndex = 10

            local resizing = false
            local startPos, startSize

            resizeBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    resizing = true
                    startPos = input.Position
                    startSize = container.Size
                    resizeBtn.BackgroundTransparency = 0
                    container.ZIndex = 20
                end
            end)
            resizeBtn.InputChanged:Connect(function(input)
                if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local deltaX = input.Position.X - startPos.X
                    local deltaY = input.Position.Y - startPos.Y
                    local newWidth = math.clamp(startSize.X.Offset + deltaX, minBarWidth, maxBarWidth)
                    local newHeight = math.clamp(startSize.Y.Offset + deltaY, minBarHeight, maxBarHeight)
                    container.Size = UDim2.new(0, newWidth, 0, newHeight)
                    local label = container:FindFirstChild("Label")
                    if label then
                        label.Size = UDim2.new(0, newWidth * 0.35, 0.5, 0)
                        label.TextSize = math.max(10, math.min(14, newHeight * 0.35))
                    end
                    local percent = container:FindFirstChild("Percent")
                    if percent then
                        percent.Size = UDim2.new(0, newWidth * 0.55, 0.5, 0)
                        percent.Position = UDim2.new(0.35, 0, 0, 0)
                        percent.TextSize = math.max(12, math.min(16, newHeight * 0.4))
                    end
                    local track = container:FindFirstChild("Track")
                    if track then
                        track.Size = UDim2.new(0.96, 0, 0, math.max(4, math.min(10, newHeight * 0.12)))
                        track.Position = UDim2.new(0.02, 0, 1, -math.max(8, math.min(16, newHeight * 0.2)))
                    end
                end
            end)
            resizeBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    resizing = false
                    resizeBtn.BackgroundTransparency = 0.3
                    container.ZIndex = 1
                    barSize = container.Size
                end
            end)

            local tooltip = Instance.new("TextLabel", resizeBtn)
            tooltip.Name = "Tooltip"
            tooltip.Size = UDim2.new(0, 80, 0, 18)
            tooltip.Position = UDim2.new(-0.5, -40, 1.2, 0)
            tooltip.BackgroundColor3 = Color3.fromRGB(20,20,30)
            tooltip.BackgroundTransparency = 0.8
            tooltip.TextColor3 = Color3.fromRGB(200,200,200)
            tooltip.TextSize = 9
            tooltip.Font = Enum.Font.Gotham
            tooltip.Text = "Redimensionner"
            tooltip.Visible = false
            Instance.new("UICorner", tooltip).CornerRadius = UDim.new(0, 4)

            resizeBtn.MouseEnter:Connect(function() tooltip.Visible = true end)
            resizeBtn.MouseLeave:Connect(function() tooltip.Visible = false end)

            local label = Instance.new("TextLabel", container)
            label.Name = "Label"
            label.Size = UDim2.new(0.35,0,0.5,0); label.Position = UDim2.new(0,10,0,0)
            label.BackgroundTransparency = 1; label.Text = "READY"
            label.TextColor3 = UI.Colors.text; label.Font = Enum.Font.GothamBold; label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left

            local percent = Instance.new("TextLabel", container)
            percent.Name = "Percent"
            percent.Size = UDim2.new(0.6,0,0.5,0); percent.Position = UDim2.new(0.35,0,0,0)
            percent.BackgroundTransparency = 1; percent.Text = ""
            percent.TextColor3 = UI.Colors.accentLight; percent.Font = Enum.Font.GothamBold; percent.TextSize = 14
            percent.TextXAlignment = Enum.TextXAlignment.Center

            local track = Instance.new("Frame", container)
            track.Name = "Track"
            track.Size = UDim2.new(0.96,0,0,6); track.Position = UDim2.new(0.02,0,1,-12)
            track.BackgroundColor3 = Color3.fromRGB(8,8,18)
            Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)

            local fill = Instance.new("Frame", track)
            fill.Name = "Fill"
            fill.Size = UDim2.new(0,0,1,0); fill.BackgroundColor3 = UI.Colors.accent
            Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

            return {container=container, label=label, percent=percent, fill=fill}
        end

        floatBar = createProgressBar(screenGui, UDim2.new(0.5,-190,0,10), UDim2.new(0,380,0,55))

        -- MAIN FRAME
        local mainFrame = Instance.new("Frame", screenGui)
        mainFrame.Size = UDim2.new(0,550,0,480)
        mainFrame.Position = UDim2.new(0.5,-275,0.5,-240)
        mainFrame.BackgroundColor3 = UI.Colors.bg
        mainFrame.BackgroundTransparency = 0.2
        mainFrame.Active = true; mainFrame.Draggable = true
        Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,12)
        mainGuiFrame = mainFrame

        mainResizeBtn = Instance.new("TextButton", mainFrame)
        mainResizeBtn.Size = UDim2.new(0, 26, 0, 26)
        mainResizeBtn.Position = UDim2.new(1, -30, 1, -30)
        mainResizeBtn.BackgroundColor3 = UI.Colors.accent
        mainResizeBtn.BackgroundTransparency = 0.2
        mainResizeBtn.Text = "⤡"
        mainResizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
        mainResizeBtn.TextSize = 16
        mainResizeBtn.Font = Enum.Font.GothamBold
        mainResizeBtn.BorderSizePixel = 0
        Instance.new("UICorner", mainResizeBtn).CornerRadius = UDim.new(0, 6)
        mainResizeBtn.ZIndex = 10

        mainResizeBtn.MouseEnter:Connect(function()
            TweenService:Create(mainResizeBtn, TweenInfo.new(0.15), {
                BackgroundTransparency = 0,
                Size = UDim2.new(0, 30, 0, 30)
            }):Play()
        end)
        mainResizeBtn.MouseLeave:Connect(function()
            TweenService:Create(mainResizeBtn, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.2,
                Size = UDim2.new(0, 26, 0, 26)
            }):Play()
        end)

        local mainResizing = false
        local mainStartPos, mainStartSize
        local mainMinWidth = 160
        local mainMaxWidth = 800
        local mainMinHeight = 40
        local mainMaxHeight = 700

        mainResizeBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                mainResizing = true
                mainStartPos = input.Position
                mainStartSize = mainFrame.Size
                mainResizeBtn.BackgroundTransparency = 0.1
                mainFrame.ZIndex = 20
            end
        end)
        mainResizeBtn.InputChanged:Connect(function(input)
            if mainResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local deltaX = input.Position.X - mainStartPos.X
                local deltaY = input.Position.Y - mainStartPos.Y
                local newWidth = math.clamp(mainStartSize.X.Offset + deltaX, mainMinWidth, mainMaxWidth)
                local newHeight = math.clamp(mainStartSize.Y.Offset + deltaY, mainMinHeight, mainMaxHeight)
                savedMainSize = UDim2.new(0, newWidth, 0, newHeight)
                savedMainPos = UDim2.new(0.5, -newWidth/2, 0.5, -newHeight/2)
                mainFrame.Size = savedMainSize
                mainFrame.Position = savedMainPos
            end
        end)
        mainResizeBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                mainResizing = false
                mainResizeBtn.BackgroundTransparency = 0.2
                mainFrame.ZIndex = 1
            end
        end)

        local mainResizeTooltip = Instance.new("TextLabel", mainResizeBtn)
        mainResizeTooltip.Name = "Tooltip"
        mainResizeTooltip.Size = UDim2.new(0, 100, 0, 20)
        mainResizeTooltip.Position = UDim2.new(-0.5, -50, 1.3, 0)
        mainResizeTooltip.BackgroundColor3 = Color3.fromRGB(20,20,30)
        mainResizeTooltip.BackgroundTransparency = 0.85
        mainResizeTooltip.TextColor3 = Color3.fromRGB(220,220,220)
        mainResizeTooltip.TextSize = 10
        mainResizeTooltip.Font = Enum.Font.Gotham
        mainResizeTooltip.Text = "Redimensionner"
        mainResizeTooltip.Visible = false
        Instance.new("UICorner", mainResizeTooltip).CornerRadius = UDim.new(0, 4)

        mainResizeBtn.MouseEnter:Connect(function() mainResizeTooltip.Visible = true end)
        mainResizeBtn.MouseLeave:Connect(function() mainResizeTooltip.Visible = false end)

        local bgImage = Instance.new("ImageLabel", mainFrame)
        bgImage.Size = UDim2.new(1,0,1,0)
        bgImage.Position = UDim2.new(0,0,0,0)
        bgImage.BackgroundTransparency = 1
        bgImage.Image = "rbxassetid://98823767422017"
        bgImage.ScaleType = Enum.ScaleType.Crop
        bgImage.ZIndex = 0
        bgImage.ImageTransparency = 0.3

        local mainStroke = Instance.new("UIStroke", mainFrame)
        mainStroke.Thickness = 2
        local strokeGrad = Instance.new("UIGradient", mainStroke)
        strokeGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, UI.Colors.accent),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60,30,120)),
            ColorSequenceKeypoint.new(1, UI.Colors.accent)
        })
        task.spawn(function()
            local r = 0
            while mainFrame.Parent do
                r = (r + 1.5) % 360
                strokeGrad.Rotation = r
                task.wait(0.03)
            end
        end)

        local title = Instance.new("TextLabel", mainFrame)
        title.Size = UDim2.new(1,0,0,40); title.Position = UDim2.new(0,0,0,0)
        title.BackgroundTransparency = 1; title.Text = "RARA HUB"
        title.TextColor3 = UI.Colors.text; title.Font = Enum.Font.GothamBold; title.TextSize = 22
        title.TextScaled = true

        local collapseBtn = Instance.new("TextButton", mainFrame)
        collapseBtn.Size = UDim2.new(0, 44, 0, 40)
        collapseBtn.Position = UDim2.new(1, -48, 0, 0)
        collapseBtn.BackgroundTransparency = 1
        collapseBtn.Text = "◀"
        collapseBtn.TextSize = 22
        collapseBtn.TextColor3 = Color3.fromRGB(255,215,0)
        collapseBtn.Font = Enum.Font.GothamBold

        collapseBtn.MouseEnter:Connect(function()
            TweenService:Create(collapseBtn, TweenInfo.new(0.15), {
                TextSize = 26,
                TextColor3 = Color3.fromRGB(255,230,50)
            }):Play()
        end)
        collapseBtn.MouseLeave:Connect(function()
            TweenService:Create(collapseBtn, TweenInfo.new(0.15), {
                TextSize = 22,
                TextColor3 = Color3.fromRGB(255,215,0)
            }):Play()
        end)

        local tabContainer = Instance.new("Frame", mainFrame)
        tabContainer.Size = UDim2.new(0,110,0,240); tabContainer.Position = UDim2.new(0,8,0,45)
        tabContainer.BackgroundTransparency = 1

        local tabs = {"Steal","Player","Esp","Misc","Visual"}
        local tabButtons = {}
        local selectedTab = "Steal"

        for i, name in ipairs(tabs) do
            local btn = Instance.new("TextButton", tabContainer)
            btn.Size = UDim2.new(1,0,0,32); btn.Position = UDim2.new(0,0,0,(i-1)*38)
            btn.BackgroundColor3 = Color3.fromRGB(30,30,50)
            btn.Text = name; btn.TextColor3 = UI.Colors.text
            btn.Font = Enum.Font.GothamBold; btn.TextSize = 14
            btn.BorderSizePixel = 0
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
            btn.MouseButton1Click:Connect(function()
                selectedTab = name
                for _, b in pairs(tabButtons) do b.BackgroundColor3 = Color3.fromRGB(30,30,50) end
                btn.BackgroundColor3 = Color3.fromRGB(70,50,120)
                updateContent()
            end)
            table.insert(tabButtons, btn)
        end
        tabButtons[1].BackgroundColor3 = Color3.fromRGB(70,50,120)

        local contentFrame = Instance.new("Frame", mainFrame)
        contentFrame.Size = UDim2.new(1,-130,0,240); contentFrame.Position = UDim2.new(0,120,0,45)
        contentFrame.BackgroundTransparency = 1

        -- STEAL
        local stealContent = Instance.new("Frame", contentFrame)
        stealContent.Size = UDim2.new(1,0,1,0); stealContent.BackgroundTransparency = 1; stealContent.Visible = true

        local scrollFrameSteal = Instance.new("ScrollingFrame", stealContent)
        scrollFrameSteal.Size = UDim2.new(1,0,1,0); scrollFrameSteal.BackgroundTransparency = 1
        scrollFrameSteal.BorderSizePixel = 0; scrollFrameSteal.ScrollBarThickness = 6
        scrollFrameSteal.ScrollBarImageColor3 = UI.Colors.accent
        scrollFrameSteal.CanvasSize = UDim2.new(0,0,0,0)
        scrollFrameSteal.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scrollFrameSteal.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

        local scrollContentSteal = Instance.new("Frame", scrollFrameSteal)
        scrollContentSteal.Size = UDim2.new(1,0,0,0)
        scrollContentSteal.BackgroundTransparency = 1
        local stealLayout = Instance.new("UIListLayout", scrollContentSteal)
        stealLayout.SortOrder = Enum.SortOrder.LayoutOrder
        stealLayout.Padding = UDim.new(0,6)

        -- Auto Steal
        local controls = Instance.new("Frame", scrollContentSteal)
        controls.Size = UDim2.new(1,-10,0,80); controls.Position = UDim2.new(0,5,0,0)
        controls.BackgroundTransparency = 1

        local toggleRow = Instance.new("Frame", controls)
        toggleRow.Size = UDim2.new(1,0,0,35); toggleRow.BackgroundTransparency = 1

        local toggleLabel = Instance.new("TextLabel", toggleRow)
        toggleLabel.Size = UDim2.new(0.55,0,1,0); toggleLabel.Position = UDim2.new(0,8,0,0)
        toggleLabel.BackgroundTransparency = 1; toggleLabel.Text = "AUTO STEAL"
        toggleLabel.TextColor3 = UI.Colors.text; toggleLabel.Font = Enum.Font.GothamBold; toggleLabel.TextSize = 13
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left

        local stealToggleBg = Instance.new("Frame", toggleRow)
        stealToggleBg.Size = UDim2.new(0,48,0,24); stealToggleBg.Position = UDim2.new(1,-56,0.5,-12)
        stealToggleBg.BackgroundColor3 = UI.Colors.accent
        Instance.new("UICorner", stealToggleBg).CornerRadius = UDim.new(1,0)
        UI.stealToggleBg = stealToggleBg

        local stealToggleCircle = Instance.new("Frame", stealToggleBg)
        stealToggleCircle.Size = UDim2.new(0,19,0,19); stealToggleCircle.Position = UDim2.new(1,-21,0.5,-9.5)
        stealToggleCircle.BackgroundColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", stealToggleCircle).CornerRadius = UDim.new(1,0)
        UI.stealToggleCircle = stealToggleCircle

        local toggleBtn = Instance.new("TextButton", toggleRow)
        toggleBtn.Size = UDim2.new(1,0,1,0); toggleBtn.BackgroundTransparency = 1; toggleBtn.Text = ""
        toggleBtn.MouseButton1Click:Connect(function()
            Config.AutoSteal = not Config.AutoSteal
            TweenService:Create(stealToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Config.AutoSteal and UI.Colors.accent or UI.Colors.inactive}):Play()
            TweenService:Create(stealToggleCircle, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Position = Config.AutoSteal and UDim2.new(1,-21,0.5,-9.5) or UDim2.new(0,3,0.5,-9.5)}):Play()
            floatBar.container.Visible = Config.AutoSteal
            if Config.AutoSteal then startAutoSteal() else stopAutoSteal() end
        end)

        local radiusRow = Instance.new("Frame", controls)
        radiusRow.Size = UDim2.new(1,0,0,35); radiusRow.Position = UDim2.new(0,0,0,40)
        radiusRow.BackgroundTransparency = 1

        local radiusLabel = Instance.new("TextLabel", radiusRow)
        radiusLabel.Size = UDim2.new(0.3,0,1,0); radiusLabel.Position = UDim2.new(0,8,0,0)
        radiusLabel.BackgroundTransparency = 1; radiusLabel.Text = "Radius:"
        radiusLabel.TextColor3 = UI.Colors.text; radiusLabel.Font = Enum.Font.GothamBold; radiusLabel.TextSize = 13
        radiusLabel.TextXAlignment = Enum.TextXAlignment.Left

        local RadiusInput = Instance.new("TextBox", radiusRow)
        RadiusInput.Size = UDim2.new(0.2,0,0.7,0); RadiusInput.Position = UDim2.new(0.3,0,0.15,0)
        RadiusInput.BackgroundColor3 = Color3.fromRGB(30,25,45)
        RadiusInput.TextColor3 = UI.Colors.text; RadiusInput.Font = Enum.Font.GothamBold; RadiusInput.TextSize = 13
        RadiusInput.Text = tostring(Config.STEAL_RADIUS); RadiusInput.ClearTextOnFocus = false
        Instance.new("UICorner", RadiusInput).CornerRadius = UDim.new(0,6)
        RadiusInput.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                local val = tonumber(RadiusInput.Text)
                if val and val > 0 then Config.STEAL_RADIUS = val; RadiusInput.Text = tostring(val)
                else RadiusInput.Text = tostring(Config.STEAL_RADIUS) end
            end
        end)

        local sep1 = Instance.new("Frame", scrollContentSteal)
        sep1.Size = UDim2.new(1,-20,0,1)
        sep1.BackgroundColor3 = UI.Colors.accent; sep1.BackgroundTransparency = 0.5; sep1.BorderSizePixel = 0

        -- TP BEST
        local tpBestCard = Instance.new("Frame", scrollContentSteal)
        tpBestCard.Size = UDim2.new(1,-10,0,120)
        tpBestCard.BackgroundTransparency = 1

        local tpLabel = Instance.new("TextLabel", tpBestCard)
        tpLabel.Size = UDim2.new(1,0,0,20); tpLabel.Position = UDim2.new(0,0,0,0)
        tpLabel.BackgroundTransparency = 1; tpLabel.Text = "Save Position (TP via Keybind X)"
        tpLabel.TextColor3 = UI.Colors.accentLight; tpLabel.Font = Enum.Font.GothamBold; tpLabel.TextSize = 13
        tpLabel.TextXAlignment = Enum.TextXAlignment.Center

        local tpContainer = Instance.new("Frame", tpBestCard)
        tpContainer.Size = UDim2.new(1,0,0,80); tpContainer.Position = UDim2.new(0,0,0,25)
        tpContainer.BackgroundTransparency = 1

        local rowTP = Instance.new("Frame", tpContainer)
        rowTP.Size = UDim2.new(1,0,0,35); rowTP.BackgroundTransparency = 1

        TPButton = Instance.new("TextButton", rowTP)
        TPButton.Size = UDim2.new(1,0,0.8,0); TPButton.Position = UDim2.new(0,0,0.1,0)
        TPButton.BackgroundColor3 = Color3.fromRGB(100,30,200)
        TPButton.Text = "Save Position"; TPButton.TextColor3 = UI.Colors.text
        TPButton.Font = Enum.Font.GothamBold; TPButton.TextSize = 14
        Instance.new("UICorner", TPButton).CornerRadius = UDim.new(0,6)
        TPButton.MouseButton1Click:Connect(savePosition)

        local rowKeybindTP = Instance.new("Frame", tpContainer)
        rowKeybindTP.Size = UDim2.new(1,0,0,25); rowKeybindTP.Position = UDim2.new(0,0,0,40)
        rowKeybindTP.BackgroundTransparency = 1

        keybindTPBtn = Instance.new("TextButton", rowKeybindTP)
        keybindTPBtn.Size = UDim2.new(0.3,0,0.8,0); keybindTPBtn.Position = UDim2.new(0.7,0,0.1,0)
        keybindTPBtn.BackgroundColor3 = Color3.fromRGB(0,80,160)
        keybindTPBtn.Text = "Key: X"; keybindTPBtn.TextColor3 = UI.Colors.text
        keybindTPBtn.Font = Enum.Font.GothamBold; keybindTPBtn.TextSize = 12
        Instance.new("UICorner", keybindTPBtn).CornerRadius = UDim.new(0,6)

        local function updateKeybindDisplay()
            local keyName = tpKeybind.Name:gsub("KeyCode.", "")
            keybindTPBtn.Text = "Key: " .. keyName
        end

        keybindTPBtn.MouseButton1Click:Connect(function()
            if awaitingKeybind then return end
            awaitingKeybind = true
            keybindTPBtn.Text = "Press..."
            keybindTPBtn.BackgroundColor3 = Color3.fromRGB(200,200,0)
        end)

        updateKeybindDisplay()

        local sep2 = Instance.new("Frame", scrollContentSteal)
        sep2.Size = UDim2.new(1,-20,0,1)
        sep2.BackgroundColor3 = UI.Colors.accent; sep2.BackgroundTransparency = 0.5; sep2.BorderSizePixel = 0

        -- TP 2
        local tp2Card = Instance.new("Frame", scrollContentSteal)
        tp2Card.Size = UDim2.new(1,-10,0,65)
        tp2Card.BackgroundTransparency = 1

        local tp2ToggleCard = Instance.new("TextButton")
        tp2ToggleCard.Text = ""
        tp2ToggleCard.Size = UDim2.new(1,0,1,0)
        tp2ToggleCard.BackgroundColor3 = UI.Colors.card
        tp2ToggleCard.BorderSizePixel = 0
        tp2ToggleCard.AutoButtonColor = false
        tp2ToggleCard.Parent = tp2Card
        Instance.new("UICorner", tp2ToggleCard).CornerRadius = UDim.new(0,10)

        local tp2CardStroke = Instance.new("UIStroke", tp2ToggleCard)
        tp2CardStroke.Color = UI.Colors.border
        tp2CardStroke.Thickness = 1

        local tp2CardAccent = Instance.new("Frame", tp2ToggleCard)
        tp2CardAccent.Size = UDim2.new(0,3,0.5,0)
        tp2CardAccent.Position = UDim2.new(0,0,0.25,0)
        tp2CardAccent.BackgroundColor3 = UI.Colors.dim
        tp2CardAccent.BorderSizePixel = 0
        Instance.new("UICorner", tp2CardAccent).CornerRadius = UDim.new(0,2)

        local tp2NameLabel = Instance.new("TextLabel", tp2ToggleCard)
        tp2NameLabel.Text = "⚡ TP 2 (Téléportation x2)"
        tp2NameLabel.BackgroundTransparency = 1
        tp2NameLabel.TextColor3 = UI.Colors.text
        tp2NameLabel.TextSize = 14
        tp2NameLabel.Font = Enum.Font.GothamBold
        tp2NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        tp2NameLabel.Size = UDim2.new(1,-14,0,20)
        tp2NameLabel.Position = UDim2.new(0,12,0,10)

        UI.tp2StatusLabel = Instance.new("TextLabel", tp2ToggleCard)
        UI.tp2StatusLabel.Text = tp2Enabled and "ON" or "OFF"
        UI.tp2StatusLabel.BackgroundTransparency = 1
        UI.tp2StatusLabel.TextColor3 = tp2Enabled and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        UI.tp2StatusLabel.TextSize = 13
        UI.tp2StatusLabel.Font = Enum.Font.GothamBold
        UI.tp2StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
        UI.tp2StatusLabel.Size = UDim2.new(1,-14,0,20)
        UI.tp2StatusLabel.Position = UDim2.new(0,12,0,38)

        UI.tp2PillBg = Instance.new("Frame", tp2ToggleCard)
        UI.tp2PillBg.Size = UDim2.new(0,46,0,24)
        UI.tp2PillBg.Position = UDim2.new(1,-54,0.5,-12)
        UI.tp2PillBg.BackgroundColor3 = tp2Enabled and UI.Colors.accent or UI.Colors.inactive
        UI.tp2PillBg.BorderSizePixel = 0
        Instance.new("UICorner", UI.tp2PillBg).CornerRadius = UDim.new(1,0)

        UI.tp2PillCircle = Instance.new("Frame", UI.tp2PillBg)
        UI.tp2PillCircle.Size = UDim2.new(0,18,0,18)
        UI.tp2PillCircle.Position = tp2Enabled and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        UI.tp2PillCircle.BackgroundColor3 = Color3.new(1,1,1)
        UI.tp2PillCircle.BorderSizePixel = 0
        Instance.new("UICorner", UI.tp2PillCircle).CornerRadius = UDim.new(1,0)

        UI.tp2CardAccent = tp2CardAccent

        local tp2KeybindRow = Instance.new("Frame", tp2ToggleCard)
        tp2KeybindRow.Size = UDim2.new(1,-24,0,20)
        tp2KeybindRow.Position = UDim2.new(0,12,0,45)
        tp2KeybindRow.BackgroundTransparency = 1

        local tp2KeybindLabel = Instance.new("TextLabel", tp2KeybindRow)
        tp2KeybindLabel.Size = UDim2.new(0.3,0,1,0)
        tp2KeybindLabel.BackgroundTransparency = 1
        tp2KeybindLabel.Text = "Key:"
        tp2KeybindLabel.TextColor3 = UI.Colors.textDim
        tp2KeybindLabel.TextSize = 11
        tp2KeybindLabel.Font = Enum.Font.GothamBold
        tp2KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

        UI.Tp2KeybindBtn = Instance.new("TextButton", tp2KeybindRow)
        UI.Tp2KeybindBtn.Size = UDim2.new(0.25,0,0.8,0)
        UI.Tp2KeybindBtn.Position = UDim2.new(0.3,0,0.1,0)
        UI.Tp2KeybindBtn.BackgroundColor3 = Color3.fromRGB(50,50,200)
        UI.Tp2KeybindBtn.TextColor3 = UI.Colors.text
        UI.Tp2KeybindBtn.Font = Enum.Font.GothamBold
        UI.Tp2KeybindBtn.TextSize = 11
        UI.Tp2KeybindBtn.Text = tp2Keybind.Name
        Instance.new("UICorner", UI.Tp2KeybindBtn).CornerRadius = UDim.new(0,4)

        UI.Tp2KeybindBtn.MouseButton1Click:Connect(function()
            if tp2AwaitingKeybind then return end
            tp2AwaitingKeybind = true
            UI.Tp2KeybindBtn.Text = "..."
            UI.Tp2KeybindBtn.BackgroundColor3 = Color3.fromRGB(200,200,0)
        end)

        local function toggleTp2()
            tp2Enabled = not tp2Enabled
            if tp2Enabled then
                if not tp2Gui or not tp2Gui.Parent then
                    tp2Gui = createTp2UI()
                else
                    tp2Gui.Visible = true
                end
                if UI.tp2StatusLabel then
                    UI.tp2StatusLabel.Text = "ON"
                    UI.tp2StatusLabel.TextColor3 = Color3.fromRGB(80,255,80)
                end
                if UI.tp2PillBg then
                    TweenService:Create(UI.tp2PillBg, TweenInfo.new(0.25), {BackgroundColor3 = UI.Colors.accent}):Play()
                end
                if UI.tp2PillCircle then
                    TweenService:Create(UI.tp2PillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = UDim2.new(1,-21,0.5,-9)}):Play()
                end
                if UI.tp2CardAccent then
                    TweenService:Create(UI.tp2CardAccent, TweenInfo.new(0.15), {BackgroundColor3 = UI.Colors.accent}):Play()
                end
            else
                if tp2Gui and tp2Gui.Parent then
                    tp2Gui:Destroy()
                    tp2Gui = nil
                end
                if _G.Tp2Pos1 then _G.Tp2Marker1:Destroy(); _G.Tp2Pos1 = nil end
                if _G.Tp2Pos2 then _G.Tp2Marker2:Destroy(); _G.Tp2Pos2 = nil end
                if UI.tp2StatusLabel then
                    UI.tp2StatusLabel.Text = "OFF"
                    UI.tp2StatusLabel.TextColor3 = UI.Colors.textDim
                end
                if UI.tp2PillBg then
                    TweenService:Create(UI.tp2PillBg, TweenInfo.new(0.25), {BackgroundColor3 = UI.Colors.inactive}):Play()
                end
                if UI.tp2PillCircle then
                    TweenService:Create(UI.tp2PillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = UDim2.new(0,3,0.5,-9)}):Play()
                end
                if UI.tp2CardAccent then
                    TweenService:Create(UI.tp2CardAccent, TweenInfo.new(0.15), {BackgroundColor3 = UI.Colors.dim}):Play()
                end
            end
        end

        tp2ToggleCard.MouseButton1Click:Connect(toggleTp2)

        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if tp2AwaitingKeybind then
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local newKey = input.KeyCode
                    if newKey ~= Enum.KeyCode.Unknown then
                        tp2Keybind = newKey
                        if UI.Tp2KeybindBtn then
                            UI.Tp2KeybindBtn.Text = tp2Keybind.Name
                            UI.Tp2KeybindBtn.BackgroundColor3 = Color3.fromRGB(50,50,200)
                        end
                    end
                    tp2AwaitingKeybind = false
                end
                return
            end
        end)

        local sep3 = Instance.new("Frame", scrollContentSteal)
        sep3.Size = UDim2.new(1,-20,0,1)
        sep3.BackgroundColor3 = UI.Colors.accent; sep3.BackgroundTransparency = 0.5; sep3.BorderSizePixel = 0

        -- DROP BRAINROT
        local dropBrainrotCard = Instance.new("Frame", scrollContentSteal)
        dropBrainrotCard.Size = UDim2.new(1,-10,0,85)
        dropBrainrotCard.BackgroundTransparency = 1

        local dropTopRow = Instance.new("Frame", dropBrainrotCard)
        dropTopRow.Size = UDim2.new(1,0,0,35)
        dropTopRow.Position = UDim2.new(0,0,0,0)
        dropTopRow.BackgroundTransparency = 1

        local dropToggleLabel = Instance.new("TextLabel", dropTopRow)
        dropToggleLabel.Size = UDim2.new(0.4,0,1,0)
        dropToggleLabel.Position = UDim2.new(0,12,0,0)
        dropToggleLabel.BackgroundTransparency = 1
        dropToggleLabel.Text = "DROP BRAINROT"
        dropToggleLabel.TextColor3 = UI.Colors.text
        dropToggleLabel.TextSize = 13
        dropToggleLabel.Font = Enum.Font.GothamBold
        dropToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

        UI.DropPillBg = Instance.new("Frame", dropTopRow)
        UI.DropPillBg.Size = UDim2.new(0,46,0,24)
        UI.DropPillBg.Position = UDim2.new(1,-54,0.5,-12)
        UI.DropPillBg.BackgroundColor3 = UI.dropBrainrotEnabled and UI.Colors.accent or UI.Colors.inactive
        UI.DropPillBg.BorderSizePixel = 0
        Instance.new("UICorner", UI.DropPillBg).CornerRadius = UDim.new(1,0)

        UI.DropPillCircle = Instance.new("Frame", UI.DropPillBg)
        UI.DropPillCircle.Size = UDim2.new(0,18,0,18)
        UI.DropPillCircle.Position = UI.dropBrainrotEnabled and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        UI.DropPillCircle.BackgroundColor3 = Color3.new(1,1,1)
        UI.DropPillCircle.BorderSizePixel = 0
        Instance.new("UICorner", UI.DropPillCircle).CornerRadius = UDim.new(1,0)

        local dropToggleBtn = Instance.new("TextButton", dropTopRow)
        dropToggleBtn.Size = UDim2.new(0,46,0,24)
        dropToggleBtn.Position = UDim2.new(1,-54,0.5,-12)
        dropToggleBtn.BackgroundTransparency = 1
        dropToggleBtn.Text = ""

        local function toggleDropBrainrot()
            UI.dropBrainrotEnabled = not UI.dropBrainrotEnabled
            local on = UI.dropBrainrotEnabled
            if on then
                TweenService:Create(UI.DropPillBg, TweenInfo.new(0.25), {BackgroundColor3 = UI.Colors.accent}):Play()
                TweenService:Create(UI.DropPillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = UDim2.new(1,-21,0.5,-9)}):Play()
            else
                TweenService:Create(UI.DropPillBg, TweenInfo.new(0.25), {BackgroundColor3 = UI.Colors.inactive}):Play()
                TweenService:Create(UI.DropPillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = UDim2.new(0,3,0.5,-9)}):Play()
            end
        end

        dropToggleBtn.MouseButton1Click:Connect(toggleDropBrainrot)

        local dropBottomRow = Instance.new("Frame", dropBrainrotCard)
        dropBottomRow.Size = UDim2.new(1,0,0,40)
        dropBottomRow.Position = UDim2.new(0,0,0,40)
        dropBottomRow.BackgroundTransparency = 1

        local dropActionBtn = Instance.new("TextButton", dropBottomRow)
        dropActionBtn.Size = UDim2.new(0.7,0,0.8,0)
        dropActionBtn.Position = UDim2.new(0.05,0,0.1,0)
        dropActionBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
        dropActionBtn.TextColor3 = UI.Colors.text
        dropActionBtn.Text = "DROP NOW!"
        dropActionBtn.Font = Enum.Font.GothamBold
        dropActionBtn.TextSize = 14
        Instance.new("UICorner", dropActionBtn).CornerRadius = UDim.new(0,6)

        dropActionBtn.MouseButton1Click:Connect(function()
            if UI.dropBrainrotEnabled then
                runDropBrainrot()
                dropActionBtn.BackgroundColor3 = Color3.fromRGB(50,200,50)
                task.delay(0.3, function()
                    dropActionBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
                end)
            end
        end)

        local dropKeybindRow = Instance.new("Frame", dropBottomRow)
        dropKeybindRow.Size = UDim2.new(0.2,0,0.8,0)
        dropKeybindRow.Position = UDim2.new(0.78,0,0.1,0)
        dropKeybindRow.BackgroundTransparency = 1

        local dropKeybindLabel = Instance.new("TextLabel", dropKeybindRow)
        dropKeybindLabel.Size = UDim2.new(0.3,0,1,0)
        dropKeybindLabel.BackgroundTransparency = 1
        dropKeybindLabel.Text = "Key:"
        dropKeybindLabel.TextColor3 = UI.Colors.textDim
        dropKeybindLabel.TextSize = 11
        dropKeybindLabel.Font = Enum.Font.GothamBold
        dropKeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

        UI.DropKeybindBtn = Instance.new("TextButton", dropKeybindRow)
        UI.DropKeybindBtn.Size = UDim2.new(0.65,0,0.8,0)
        UI.DropKeybindBtn.Position = UDim2.new(0.35,0,0.1,0)
        UI.DropKeybindBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
        UI.DropKeybindBtn.TextColor3 = UI.Colors.text
        UI.DropKeybindBtn.Font = Enum.Font.GothamBold
        UI.DropKeybindBtn.TextSize = 11
        UI.DropKeybindBtn.Text = dropBrainrotKeybind.Name
        Instance.new("UICorner", UI.DropKeybindBtn).CornerRadius = UDim.new(0,4)

        UI.DropKeybindBtn.MouseButton1Click:Connect(function()
            if dropBrainrotAwaitingKeybind then return end
            dropBrainrotAwaitingKeybind = true
            UI.DropKeybindBtn.Text = "..."
            UI.DropKeybindBtn.BackgroundColor3 = Color3.fromRGB(200,200,0)
        end)

        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if dropBrainrotAwaitingKeybind then
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local newKey = input.KeyCode
                    if newKey ~= Enum.KeyCode.Unknown then
                        dropBrainrotKeybind = newKey
                        if UI.DropKeybindBtn then
                            UI.DropKeybindBtn.Text = dropBrainrotKeybind.Name
                            UI.DropKeybindBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
                        end
                    end
                    dropBrainrotAwaitingKeybind = false
                end
                return
            end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == dropBrainrotKeybind and UI.dropBrainrotEnabled then
                    runDropBrainrot()
                    dropActionBtn.BackgroundColor3 = Color3.fromRGB(50,200,50)
                    task.delay(0.3, function()
                        dropActionBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
                    end)
                end
            end
        end)

        stealLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollFrameSteal.CanvasSize = UDim2.new(0, 0, 0, stealLayout.AbsoluteContentSize.Y + 20)
        end)
        task.wait(0.1)
        scrollFrameSteal.CanvasSize = UDim2.new(0, 0, 0, stealLayout.AbsoluteContentSize.Y + 20)

        -- PLAYER
        local playerContent = Instance.new("Frame", contentFrame)
        playerContent.Size = UDim2.new(1,0,1,0); playerContent.BackgroundTransparency = 1; playerContent.Visible = false

        local scrollFramePlayer = Instance.new("ScrollingFrame", playerContent)
        scrollFramePlayer.Size = UDim2.new(1,0,1,0); scrollFramePlayer.BackgroundTransparency = 1
        scrollFramePlayer.BorderSizePixel = 0; scrollFramePlayer.ScrollBarThickness = 6
        scrollFramePlayer.ScrollBarImageColor3 = UI.Colors.accent
        scrollFramePlayer.CanvasSize = UDim2.new(0,0,0,500)
        scrollFramePlayer.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

        local scrollContentPlayer = Instance.new("Frame", scrollFramePlayer)
        scrollContentPlayer.Size = UDim2.new(1,0,0,500); scrollContentPlayer.BackgroundTransparency = 1

        local function createPlayerCard(parent, yPos, title, toggleFunc, initialState)
            local card = Instance.new("TextButton")
            card.Text = ""
            card.Size = UDim2.new(0.92,0,0,65); card.Position = UDim2.new(0.04,0,0,yPos)
            card.BackgroundColor3 = UI.Colors.card; card.BorderSizePixel = 0; card.AutoButtonColor = false
            card.Parent = parent
            Instance.new("UICorner", card).CornerRadius = UDim.new(0,10)
            local cardStroke = Instance.new("UIStroke", card); cardStroke.Color = UI.Colors.border; cardStroke.Thickness = 1
            local cardAccent = Instance.new("Frame", card)
            cardAccent.Size = UDim2.new(0,3,0.5,0); cardAccent.Position = UDim2.new(0,0,0.25,0)
            cardAccent.BackgroundColor3 = initialState and UI.Colors.accent or UI.Colors.dim
            cardAccent.BorderSizePixel = 0
            Instance.new("UICorner", cardAccent).CornerRadius = UDim.new(0,2)
            local nameLabel = Instance.new("TextLabel", card)
            nameLabel.Text = title; nameLabel.BackgroundTransparency = 1
            nameLabel.TextColor3 = UI.Colors.text; nameLabel.TextSize = 14; nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Size = UDim2.new(1,-14,0,20); nameLabel.Position = UDim2.new(0,12,0,10)
            local statusLabel = Instance.new("TextLabel", card)
            statusLabel.Text = initialState and "ON" or "OFF"; statusLabel.BackgroundTransparency = 1
            statusLabel.TextColor3 = initialState and Color3.fromRGB(80,255,80) or UI.Colors.textDim
            statusLabel.TextSize = 13; statusLabel.Font = Enum.Font.GothamBold
            statusLabel.TextXAlignment = Enum.TextXAlignment.Left
            statusLabel.Size = UDim2.new(1,-14,0,20); statusLabel.Position = UDim2.new(0,12,0,38)
            local pillBg = Instance.new("Frame", card)
            pillBg.Size = UDim2.new(0,46,0,24); pillBg.Position = UDim2.new(1,-54,0.5,-12)
            pillBg.BackgroundColor3 = initialState and UI.Colors.accent or UI.Colors.inactive
            pillBg.BorderSizePixel = 0
            Instance.new("UICorner", pillBg).CornerRadius = UDim.new(1,0)
            local pillCircle = Instance.new("Frame", pillBg)
            pillCircle.Size = UDim2.new(0,18,0,18)
            pillCircle.Position = initialState and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
            pillCircle.BackgroundColor3 = Color3.new(1,1,1); pillCircle.BorderSizePixel = 0
            Instance.new("UICorner", pillCircle).CornerRadius = UDim.new(1,0)
            card.MouseButton1Click:Connect(toggleFunc)
            return {
                card = card,
                statusLabel = statusLabel,
                pillBg = pillBg,
                pillCircle = pillCircle,
                cardStroke = cardStroke,
                cardAccent = cardAccent
            }
        end

        local antiRagdollCard = createPlayerCard(scrollContentPlayer, 10, "ANTI-RAGDOLL", toggleAntiRagdoll, UI.AntiRagdollEnabled)
        UI.AntiRagdollStatus = antiRagdollCard.statusLabel
        UI.AntiRagdollPillBg = antiRagdollCard.pillBg
        UI.AntiRagdollPillCircle = antiRagdollCard.pillCircle

        local infJumpCard = createPlayerCard(scrollContentPlayer, 85, "INFINITY JUMP (HOLD)", toggleInfJump, UI.InfJumpEnabled)
        UI.InfJumpStatus = infJumpCard.statusLabel
        UI.InfJumpPillBg = infJumpCard.pillBg
        UI.InfJumpPillCircle = infJumpCard.pillCircle

        local antiDeathCard = createPlayerCard(scrollContentPlayer, 160, "ANTI-DEATH (🛡️)", toggleAntiDeath, UI.antiDeathEnabled)
        UI.AntiDeathStatus = antiDeathCard.statusLabel
        UI.AntiDeathPillBg = antiDeathCard.pillBg
        UI.AntiDeathPillCircle = antiDeathCard.pillCircle
        UI.AntiDeathCardAccent = antiDeathCard.cardAccent

        local antiGummyCard = createPlayerCard(scrollContentPlayer, 235, "ANTI GUMMY", toggleAntiGummy, UI.antiGummyEnabled)
        UI.AntiGummyStatus = antiGummyCard.statusLabel
        UI.AntiGummyPillBg = antiGummyCard.pillBg
        UI.AntiGummyPillCircle = antiGummyCard.pillCircle

        local antiBoogieCard = createPlayerCard(scrollContentPlayer, 310, "ANTI DISCO", toggleAntiBoogie, UI.antiBoogieEnabled)
        UI.AntiBoogieStatus = antiBoogieCard.statusLabel
        UI.AntiBoogiePillBg = antiBoogieCard.pillBg
        UI.AntiBoogiePillCircle = antiBoogieCard.pillCircle

        local antiBeeCard = createPlayerCard(scrollContentPlayer, 385, "ANTI BEE", toggleAntiBee, UI.antiBeeEnabled)
        UI.AntiBeeStatus = antiBeeCard.statusLabel
        UI.AntiBeePillBg = antiBeeCard.pillBg
        UI.AntiBeePillCircle = antiBeeCard.pillCircle

        local spacer = Instance.new("Frame", scrollContentPlayer)
        spacer.Size = UDim2.new(1,0,0,10); spacer.Position = UDim2.new(0,0,0,460)
        spacer.BackgroundTransparency = 1

        -- ESP
        local espContent = Instance.new("Frame", contentFrame)
        espContent.Size = UDim2.new(1,0,1,0); espContent.BackgroundTransparency = 1; espContent.Visible = false

        local espCard = Instance.new("TextButton")
        espCard.Text = ""
        espCard.Size = UDim2.new(0.92,0,0,65); espCard.Position = UDim2.new(0.04,0,0,5)
        espCard.BackgroundColor3 = UI.Colors.card; espCard.BorderSizePixel = 0; espCard.AutoButtonColor = false
        espCard.Parent = espContent
        Instance.new("UICorner", espCard).CornerRadius = UDim.new(0,10)

        UI.EspCardStroke = Instance.new("UIStroke", espCard); UI.EspCardStroke.Color = UI.Colors.border; UI.EspCardStroke.Thickness = 1
        UI.EspCardAccent = Instance.new("Frame", espCard)
        UI.EspCardAccent.Size = UDim2.new(0,3,0.5,0); UI.EspCardAccent.Position = UDim2.new(0,0,0.25,0)
        UI.EspCardAccent.BackgroundColor3 = espEnabled and UI.Colors.accent or UI.Colors.dim
        UI.EspCardAccent.BorderSizePixel = 0
        Instance.new("UICorner", UI.EspCardAccent).CornerRadius = UDim.new(0,2)

        local espNameLabel = Instance.new("TextLabel", espCard)
        espNameLabel.Text = "Linia ESP (Boîtes, Vie, Distance)"
        espNameLabel.BackgroundTransparency = 1
        espNameLabel.TextColor3 = UI.Colors.text
        espNameLabel.TextSize = 14
        espNameLabel.Font = Enum.Font.GothamBold
        espNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        espNameLabel.Size = UDim2.new(1,-14,0,20)
        espNameLabel.Position = UDim2.new(0,12,0,10)

        UI.EspStatusLabel = Instance.new("TextLabel", espCard)
        UI.EspStatusLabel.Text = espEnabled and "ON" or "OFF"
        UI.EspStatusLabel.BackgroundTransparency = 1
        UI.EspStatusLabel.TextColor3 = espEnabled and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        UI.EspStatusLabel.TextSize = 13
        UI.EspStatusLabel.Font = Enum.Font.GothamBold
        UI.EspStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
        UI.EspStatusLabel.Size = UDim2.new(1,-14,0,20)
        UI.EspStatusLabel.Position = UDim2.new(0,12,0,38)

        UI.EspPillBg = Instance.new("Frame", espCard)
        UI.EspPillBg.Size = UDim2.new(0,46,0,24)
        UI.EspPillBg.Position = UDim2.new(1,-54,0.5,-12)
        UI.EspPillBg.BackgroundColor3 = espEnabled and UI.Colors.accent or UI.Colors.inactive
        UI.EspPillBg.BorderSizePixel = 0
        Instance.new("UICorner", UI.EspPillBg).CornerRadius = UDim.new(1,0)

        UI.EspPillCircle = Instance.new("Frame", UI.EspPillBg)
        UI.EspPillCircle.Size = UDim2.new(0,18,0,18)
        UI.EspPillCircle.Position = espEnabled and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        UI.EspPillCircle.BackgroundColor3 = Color3.new(1,1,1)
        UI.EspPillCircle.BorderSizePixel = 0
        Instance.new("UICorner", UI.EspPillCircle).CornerRadius = UDim.new(1,0)

        espCard.MouseButton1Click:Connect(toggleESPPlayers)

        local transSection = Instance.new("Frame", espContent)
        transSection.Size = UDim2.new(0.92,0,0,40); transSection.Position = UDim2.new(0.04,0,0,80)
        transSection.BackgroundColor3 = UI.Colors.card
        Instance.new("UICorner", transSection).CornerRadius = UDim.new(0,8)

        UI.EspTransparencyLabel = Instance.new("TextLabel", transSection)
        UI.EspTransparencyLabel.Size = UDim2.new(0.5,0,1,0); UI.EspTransparencyLabel.Position = UDim2.new(0,10,0,0)
        UI.EspTransparencyLabel.BackgroundTransparency = 1
        UI.EspTransparencyLabel.Text = "Intensité: " .. string.format("%.1f", espTransparency)
        UI.EspTransparencyLabel.TextColor3 = UI.Colors.text
        UI.EspTransparencyLabel.Font = Enum.Font.GothamBold
        UI.EspTransparencyLabel.TextSize = 14
        UI.EspTransparencyLabel.TextXAlignment = Enum.TextXAlignment.Left
        UI.EspTransparencyLabel.TextYAlignment = Enum.TextYAlignment.Center

        local minusTrans = Instance.new("TextButton", transSection)
        minusTrans.Size = UDim2.new(0,35,0,28); minusTrans.Position = UDim2.new(1,-80,0.5,-14)
        minusTrans.BackgroundColor3 = UI.Colors.inactive
        minusTrans.Text = "-"; minusTrans.TextColor3 = UI.Colors.text; minusTrans.Font = Enum.Font.GothamBold
        minusTrans.TextSize = 20
        Instance.new("UICorner", minusTrans).CornerRadius = UDim.new(0,4)
        minusTrans.MouseButton1Click:Connect(function() setESPTransparency(espTransparency - 0.1) end)

        local plusTrans = Instance.new("TextButton", transSection)
        plusTrans.Size = UDim2.new(0,35,0,28); plusTrans.Position = UDim2.new(1,-35,0.5,-14)
        plusTrans.BackgroundColor3 = UI.Colors.inactive
        plusTrans.Text = "+"; plusTrans.TextColor3 = UI.Colors.text; plusTrans.Font = Enum.Font.GothamBold
        plusTrans.TextSize = 20
        Instance.new("UICorner", plusTrans).CornerRadius = UDim.new(0,4)
        plusTrans.MouseButton1Click:Connect(function() setESPTransparency(espTransparency + 0.1) end)

        -- MISC
        local miscContent = Instance.new("ScrollingFrame", contentFrame)
        miscContent.Size = UDim2.new(1,0,1,0); miscContent.BackgroundTransparency = 1
        miscContent.Visible = false
        miscContent.BorderSizePixel = 0
        miscContent.ScrollBarThickness = 6
        miscContent.ScrollBarImageColor3 = UI.Colors.accent
        miscContent.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

        local scrollContentMisc = Instance.new("Frame", miscContent)
        scrollContentMisc.Size = UDim2.new(1,0,0,0)
        scrollContentMisc.BackgroundTransparency = 1

        -- Aimbot
        local aimbotCard = Instance.new("TextButton")
        aimbotCard.Text = ""
        aimbotCard.Size = UDim2.new(0.92,0,0,65); aimbotCard.Position = UDim2.new(0.04,0,0,5)
        aimbotCard.BackgroundColor3 = UI.Colors.card; aimbotCard.BorderSizePixel = 0; aimbotCard.AutoButtonColor = false
        aimbotCard.Parent = scrollContentMisc
        Instance.new("UICorner", aimbotCard).CornerRadius = UDim.new(0,10)

        UI.AimbotCardStroke = Instance.new("UIStroke", aimbotCard); UI.AimbotCardStroke.Color = UI.Colors.border; UI.AimbotCardStroke.Thickness = 1
        UI.AimbotCardAccent = Instance.new("Frame", aimbotCard)
        UI.AimbotCardAccent.Size = UDim2.new(0,3,0.5,0); UI.AimbotCardAccent.Position = UDim2.new(0,0,0.25,0)
        UI.AimbotCardAccent.BackgroundColor3 = UI.aimbotState and UI.Colors.accent or UI.Colors.dim
        UI.AimbotCardAccent.BorderSizePixel = 0
        Instance.new("UICorner", UI.AimbotCardAccent).CornerRadius = UDim.new(0,2)

        local aimbotNameLabel = Instance.new("TextLabel", aimbotCard)
        aimbotNameLabel.Text = "AIMBOT"; aimbotNameLabel.BackgroundTransparency = 1
        aimbotNameLabel.TextColor3 = UI.Colors.text; aimbotNameLabel.TextSize = 14; aimbotNameLabel.Font = Enum.Font.GothamBold
        aimbotNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        aimbotNameLabel.Size = UDim2.new(1,-14,0,20); aimbotNameLabel.Position = UDim2.new(0,12,0,10)

        UI.AimbotStatusLabel = Instance.new("TextLabel", aimbotCard)
        UI.AimbotStatusLabel.Text = UI.aimbotState and "ON" or "OFF"
        UI.AimbotStatusLabel.BackgroundTransparency = 1
        UI.AimbotStatusLabel.TextColor3 = UI.aimbotState and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        UI.AimbotStatusLabel.TextSize = 13; UI.AimbotStatusLabel.Font = Enum.Font.GothamBold
        UI.AimbotStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
        UI.AimbotStatusLabel.Size = UDim2.new(1,-14,0,20); UI.AimbotStatusLabel.Position = UDim2.new(0,12,0,38)

        UI.AimbotPillBg = Instance.new("Frame", aimbotCard)
        UI.AimbotPillBg.Size = UDim2.new(0,46,0,24); UI.AimbotPillBg.Position = UDim2.new(1,-54,0.5,-12)
        UI.AimbotPillBg.BackgroundColor3 = UI.aimbotState and UI.Colors.accent or UI.Colors.inactive
        UI.AimbotPillBg.BorderSizePixel = 0
        Instance.new("UICorner", UI.AimbotPillBg).CornerRadius = UDim.new(1,0)

        UI.AimbotPillCircle = Instance.new("Frame", UI.AimbotPillBg)
        UI.AimbotPillCircle.Size = UDim2.new(0,18,0,18); UI.AimbotPillCircle.Position = UI.aimbotState and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        UI.AimbotPillCircle.BackgroundColor3 = Color3.new(1,1,1); UI.AimbotPillCircle.BorderSizePixel = 0
        Instance.new("UICorner", UI.AimbotPillCircle).CornerRadius = UDim.new(1,0)

        aimbotCard.MouseButton1Click:Connect(toggleAimbot)

        -- Auto Destroy Sentry
        UI.sentryToggleBtn = Instance.new("TextButton", scrollContentMisc)
        UI.sentryToggleBtn.Text = ""
        UI.sentryToggleBtn.Size = UDim2.new(0.92,0,0,65); UI.sentryToggleBtn.Position = UDim2.new(0.04,0,0,80)
        UI.sentryToggleBtn.BackgroundColor3 = UI.Colors.card; UI.sentryToggleBtn.BorderSizePixel = 0; UI.sentryToggleBtn.AutoButtonColor = false
        UI.sentryToggleBtn.Parent = scrollContentMisc
        Instance.new("UICorner", UI.sentryToggleBtn).CornerRadius = UDim.new(0,10)

        local sentryCardStroke = Instance.new("UIStroke", UI.sentryToggleBtn); sentryCardStroke.Color = UI.Colors.border; sentryCardStroke.Thickness = 1
        UI.sentryCardAccent = Instance.new("Frame", UI.sentryToggleBtn)
        UI.sentryCardAccent.Size = UDim2.new(0,3,0.5,0); UI.sentryCardAccent.Position = UDim2.new(0,0,0.25,0)
        UI.sentryCardAccent.BackgroundColor3 = autoSentryEnabled and UI.Colors.accent or UI.Colors.dim
        UI.sentryCardAccent.BorderSizePixel = 0
        Instance.new("UICorner", UI.sentryCardAccent).CornerRadius = UDim.new(0,2)

        local sentryNameLabel = Instance.new("TextLabel", UI.sentryToggleBtn)
        sentryNameLabel.Text = "🤖 Auto Destroy Sentry"; sentryNameLabel.BackgroundTransparency = 1
        sentryNameLabel.TextColor3 = UI.Colors.text; sentryNameLabel.TextSize = 14; sentryNameLabel.Font = Enum.Font.GothamBold
        sentryNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        sentryNameLabel.Size = UDim2.new(1,-14,0,20); sentryNameLabel.Position = UDim2.new(0,12,0,10)

        UI.sentryStatusLabel = Instance.new("TextLabel", UI.sentryToggleBtn)
        UI.sentryStatusLabel.Text = autoSentryEnabled and "ON" or "OFF"
        UI.sentryStatusLabel.BackgroundTransparency = 1
        UI.sentryStatusLabel.TextColor3 = autoSentryEnabled and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        UI.sentryStatusLabel.TextSize = 13
        UI.sentryStatusLabel.Font = Enum.Font.GothamBold
        UI.sentryStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
        UI.sentryStatusLabel.Size = UDim2.new(1,-14,0,20); UI.sentryStatusLabel.Position = UDim2.new(0,12,0,38)

        UI.sentryPillBg = Instance.new("Frame", UI.sentryToggleBtn)
        UI.sentryPillBg.Size = UDim2.new(0,46,0,24); UI.sentryPillBg.Position = UDim2.new(1,-54,0.5,-12)
        UI.sentryPillBg.BackgroundColor3 = autoSentryEnabled and UI.Colors.accent or UI.Colors.inactive
        UI.sentryPillBg.BorderSizePixel = 0
        Instance.new("UICorner", UI.sentryPillBg).CornerRadius = UDim.new(1,0)

        UI.sentryPillCircle = Instance.new("Frame", UI.sentryPillBg)
        UI.sentryPillCircle.Size = UDim2.new(0,18,0,18); UI.sentryPillCircle.Position = autoSentryEnabled and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        UI.sentryPillCircle.BackgroundColor3 = Color3.new(1,1,1); UI.sentryPillCircle.BorderSizePixel = 0
        Instance.new("UICorner", UI.sentryPillCircle).CornerRadius = UDim.new(1,0)

        UI.sentryToggleBtn.MouseButton1Click:Connect(function()
            toggleAutoSentry(not autoSentryEnabled)
        end)

        -- Auto Destroy V2
        UI.destroyV2ToggleBtn = Instance.new("TextButton", scrollContentMisc)
        UI.destroyV2ToggleBtn.Text = ""
        UI.destroyV2ToggleBtn.Size = UDim2.new(0.92,0,0,65); UI.destroyV2ToggleBtn.Position = UDim2.new(0.04,0,0,155)
        UI.destroyV2ToggleBtn.BackgroundColor3 = UI.Colors.card; UI.destroyV2ToggleBtn.BorderSizePixel = 0; UI.destroyV2ToggleBtn.AutoButtonColor = false
        UI.destroyV2ToggleBtn.Parent = scrollContentMisc
        Instance.new("UICorner", UI.destroyV2ToggleBtn).CornerRadius = UDim.new(0,10)

        local destroyV2CardStroke = Instance.new("UIStroke", UI.destroyV2ToggleBtn); destroyV2CardStroke.Color = UI.Colors.border; destroyV2CardStroke.Thickness = 1
        UI.destroyV2CardAccent = Instance.new("Frame", UI.destroyV2ToggleBtn)
        UI.destroyV2CardAccent.Size = UDim2.new(0,3,0.5,0); UI.destroyV2CardAccent.Position = UDim2.new(0,0,0.25,0)
        UI.destroyV2CardAccent.BackgroundColor3 = autoDestroyV2Enabled and UI.Colors.accent or UI.Colors.dim
        UI.destroyV2CardAccent.BorderSizePixel = 0
        Instance.new("UICorner", UI.destroyV2CardAccent).CornerRadius = UDim.new(0,2)

        local destroyV2NameLabel = Instance.new("TextLabel", UI.destroyV2ToggleBtn)
        destroyV2NameLabel.Text = "🤖 Auto Destroy Turret V2"; destroyV2NameLabel.BackgroundTransparency = 1
        destroyV2NameLabel.TextColor3 = UI.Colors.text; destroyV2NameLabel.TextSize = 14; destroyV2NameLabel.Font = Enum.Font.GothamBold
        destroyV2NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        destroyV2NameLabel.Size = UDim2.new(1,-14,0,20); destroyV2NameLabel.Position = UDim2.new(0,12,0,10)

        UI.destroyV2StatusLabel = Instance.new("TextLabel", UI.destroyV2ToggleBtn)
        UI.destroyV2StatusLabel.Text = autoDestroyV2Enabled and "ON" or "OFF"
        UI.destroyV2StatusLabel.BackgroundTransparency = 1
        UI.destroyV2StatusLabel.TextColor3 = autoDestroyV2Enabled and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        UI.destroyV2StatusLabel.TextSize = 13
        UI.destroyV2StatusLabel.Font = Enum.Font.GothamBold
        UI.destroyV2StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
        UI.destroyV2StatusLabel.Size = UDim2.new(1,-14,0,20); UI.destroyV2StatusLabel.Position = UDim2.new(0,12,0,38)

        UI.destroyV2PillBg = Instance.new("Frame", UI.destroyV2ToggleBtn)
        UI.destroyV2PillBg.Size = UDim2.new(0,46,0,24); UI.destroyV2PillBg.Position = UDim2.new(1,-54,0.5,-12)
        UI.destroyV2PillBg.BackgroundColor3 = autoDestroyV2Enabled and UI.Colors.accent or UI.Colors.inactive
        UI.destroyV2PillBg.BorderSizePixel = 0
        Instance.new("UICorner", UI.destroyV2PillBg).CornerRadius = UDim.new(1,0)

        UI.destroyV2PillCircle = Instance.new("Frame", UI.destroyV2PillBg)
        UI.destroyV2PillCircle.Size = UDim2.new(0,18,0,18); UI.destroyV2PillCircle.Position = autoDestroyV2Enabled and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        UI.destroyV2PillCircle.BackgroundColor3 = Color3.new(1,1,1); UI.destroyV2PillCircle.BorderSizePixel = 0
        Instance.new("UICorner", UI.destroyV2PillCircle).CornerRadius = UDim.new(1,0)

        UI.destroyV2ToggleBtn.MouseButton1Click:Connect(toggleAutoDestroyV2)

        -- Carpet Speed Boost
        local carpetCard = Instance.new("TextButton")
        carpetCard.Text = ""
        carpetCard.Size = UDim2.new(0.92,0,0,100)
        carpetCard.Position = UDim2.new(0.04,0,0,230)
        carpetCard.BackgroundColor3 = UI.Colors.card
        carpetCard.BorderSizePixel = 0
        carpetCard.AutoButtonColor = false
        carpetCard.Parent = scrollContentMisc
        Instance.new("UICorner", carpetCard).CornerRadius = UDim.new(0,10)
        UI.CarpetCard = carpetCard

        local carpetCardStroke = Instance.new("UIStroke", carpetCard)
        carpetCardStroke.Color = UI.Colors.border
        carpetCardStroke.Thickness = 1
        UI.CarpetCardStroke = carpetCardStroke

        UI.CarpetCardAccent = Instance.new("Frame", carpetCard)
        UI.CarpetCardAccent.Size = UDim2.new(0,3,0.5,0)
        UI.CarpetCardAccent.Position = UDim2.new(0,0,0.25,0)
        UI.CarpetCardAccent.BackgroundColor3 = UI.carpetBoostEnabled and UI.Colors.accent or UI.Colors.dim
        UI.CarpetCardAccent.BorderSizePixel = 0
        Instance.new("UICorner", UI.CarpetCardAccent).CornerRadius = UDim.new(0,2)

        UI.CarpetNameLabel = Instance.new("TextLabel", carpetCard)
        UI.CarpetNameLabel.Text = "🚀 Carpet Speed Boost"
        UI.CarpetNameLabel.BackgroundTransparency = 1
        UI.CarpetNameLabel.TextColor3 = UI.carpetBoostEnabled and Color3.fromRGB(0,0,0) or UI.Colors.text
        UI.CarpetNameLabel.TextSize = 14
        UI.CarpetNameLabel.Font = Enum.Font.GothamBold
        UI.CarpetNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        UI.CarpetNameLabel.Size = UDim2.new(1,-14,0,20)
        UI.CarpetNameLabel.Position = UDim2.new(0,12,0,6)

        UI.CarpetStatus = Instance.new("TextLabel", carpetCard)
        UI.CarpetStatus.Text = UI.carpetBoostEnabled and "ON" or "OFF"
        UI.CarpetStatus.BackgroundTransparency = 1
        UI.CarpetStatus.TextColor3 = UI.carpetBoostEnabled and Color3.fromRGB(0,0,0) or UI.Colors.textDim
        UI.CarpetStatus.TextSize = 13
        UI.CarpetStatus.Font = Enum.Font.GothamBold
        UI.CarpetStatus.TextXAlignment = Enum.TextXAlignment.Left
        UI.CarpetStatus.Size = UDim2.new(1,-14,0,20)
        UI.CarpetStatus.Position = UDim2.new(0,12,0,32)

        UI.CarpetPillBg = Instance.new("Frame", carpetCard)
        UI.CarpetPillBg.Size = UDim2.new(0,46,0,24)
        UI.CarpetPillBg.Position = UDim2.new(1,-54,0.5,-12)
        UI.CarpetPillBg.BackgroundColor3 = UI.carpetBoostEnabled and UI.Colors.accent or UI.Colors.inactive
        UI.CarpetPillBg.BorderSizePixel = 0
        Instance.new("UICorner", UI.CarpetPillBg).CornerRadius = UDim.new(1,0)

        UI.CarpetPillCircle = Instance.new("Frame", UI.CarpetPillBg)
        UI.CarpetPillCircle.Size = UDim2.new(0,18,0,18)
        UI.CarpetPillCircle.Position = UI.carpetBoostEnabled and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        UI.CarpetPillCircle.BackgroundColor3 = Color3.new(1,1,1)
        UI.CarpetPillCircle.BorderSizePixel = 0
        Instance.new("UICorner", UI.CarpetPillCircle).CornerRadius = UDim.new(1,0)

        local speedRow = Instance.new("Frame", carpetCard)
        speedRow.Size = UDim2.new(1,-24,0,22)
        speedRow.Position = UDim2.new(0,12,0,58)
        speedRow.BackgroundTransparency = 1

        local speedLabel = Instance.new("TextLabel", speedRow)
        speedLabel.Size = UDim2.new(0.4,0,1,0)
        speedLabel.BackgroundTransparency = 1
        speedLabel.Text = "Vitesse"
        speedLabel.TextColor3 = UI.Colors.textDim
        speedLabel.TextSize = 12
        speedLabel.Font = Enum.Font.GothamBold
        speedLabel.TextXAlignment = Enum.TextXAlignment.Left

        UI.CarpetSpeedBox = Instance.new("TextBox", speedRow)
        UI.CarpetSpeedBox.Size = UDim2.new(0.35,0,0.8,0)
        UI.CarpetSpeedBox.Position = UDim2.new(0.55,0,0.1,0)
        UI.CarpetSpeedBox.BackgroundColor3 = UI.carpetBoostEnabled and Color3.fromRGB(220,220,220) or Color3.fromRGB(30,30,30)
        UI.CarpetSpeedBox.TextColor3 = UI.carpetBoostEnabled and Color3.fromRGB(0,0,0) or UI.Colors.text
        UI.CarpetSpeedBox.Font = Enum.Font.GothamBold
        UI.CarpetSpeedBox.TextSize = 12
        UI.CarpetSpeedBox.Text = tostring(UI.carpetSpeed)
        UI.CarpetSpeedBox.ClearTextOnFocus = false
        Instance.new("UICorner", UI.CarpetSpeedBox).CornerRadius = UDim.new(0,4)

        UI.CarpetSpeedBox.FocusLost:Connect(function(enter)
            if enter then
                local val = tonumber(UI.CarpetSpeedBox.Text)
                if val and val > 0 then
                    UI.carpetSpeed = val
                    setSetting("carpetSpeed", val)
                    UI.CarpetSpeedBox.Text = tostring(val)
                    if UI.carpetBoostEnabled then refreshCarpetBoost() end
                else
                    UI.CarpetSpeedBox.Text = tostring(UI.carpetSpeed)
                end
            end
        end)

        local carpetKeybindRow = Instance.new("Frame", carpetCard)
        carpetKeybindRow.Size = UDim2.new(1,-24,0,22)
        carpetKeybindRow.Position = UDim2.new(0,12,0,78)
        carpetKeybindRow.BackgroundTransparency = 1

        UI.CarpetKeybindLabel = Instance.new("TextLabel", carpetKeybindRow)
        UI.CarpetKeybindLabel.Size = UDim2.new(0.4,0,1,0)
        UI.CarpetKeybindLabel.BackgroundTransparency = 1
        UI.CarpetKeybindLabel.Text = "Keybind"
        UI.CarpetKeybindLabel.TextColor3 = UI.carpetBoostEnabled and Color3.fromRGB(0,0,0) or UI.Colors.textDim
        UI.CarpetKeybindLabel.TextSize = 12
        UI.CarpetKeybindLabel.Font = Enum.Font.GothamBold
        UI.CarpetKeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

        UI.CarpetKeybindBtn = Instance.new("TextButton", carpetKeybindRow)
        UI.CarpetKeybindBtn.Size = UDim2.new(0.35,0,0.8,0)
        UI.CarpetKeybindBtn.Position = UDim2.new(0.55,0,0.1,0)
        UI.CarpetKeybindBtn.BackgroundColor3 = Color3.fromRGB(0,80,160)
        UI.CarpetKeybindBtn.TextColor3 = UI.carpetBoostEnabled and Color3.fromRGB(0,0,0) or UI.Colors.text
        UI.CarpetKeybindBtn.Font = Enum.Font.GothamBold
        UI.CarpetKeybindBtn.TextSize = 12
        UI.CarpetKeybindBtn.Text = carpetKeybind.Name
        Instance.new("UICorner", UI.CarpetKeybindBtn).CornerRadius = UDim.new(0,4)

        UI.CarpetKeybindBtn.MouseButton1Click:Connect(function()
            if carpetAwaitingKeybind then return end
            carpetAwaitingKeybind = true
            UI.CarpetKeybindBtn.Text = "..."
            UI.CarpetKeybindBtn.BackgroundColor3 = Color3.fromRGB(200,200,0)
        end)

        carpetCard.MouseButton1Click:Connect(function()
            toggleCarpetBoost()
        end)

        -- RESET
        local resetCard = Instance.new("TextButton")
        resetCard.Text = ""
        resetCard.Size = UDim2.new(0.92,0,0,65)
        resetCard.Position = UDim2.new(0.04,0,0,340)
        resetCard.BackgroundColor3 = UI.Colors.card
        resetCard.BorderSizePixel = 0
        resetCard.AutoButtonColor = false
        resetCard.Parent = scrollContentMisc
        Instance.new("UICorner", resetCard).CornerRadius = UDim.new(0,10)

        local resetCardStroke = Instance.new("UIStroke", resetCard)
        resetCardStroke.Color = UI.Colors.border
        resetCardStroke.Thickness = 1

        UI.ResetCardAccent = Instance.new("Frame", resetCard)
        UI.ResetCardAccent.Size = UDim2.new(0,3,0.5,0)
        UI.ResetCardAccent.Position = UDim2.new(0,0,0.25,0)
        UI.ResetCardAccent.BackgroundColor3 = UI.resetEnabled and Color3.fromRGB(50,150,255) or UI.Colors.dim
        UI.ResetCardAccent.BorderSizePixel = 0
        Instance.new("UICorner", UI.ResetCardAccent).CornerRadius = UDim.new(0,2)

        local resetNameLabel = Instance.new("TextLabel", resetCard)
        resetNameLabel.Text = "🔄 RESET (INSTANT)"
        resetNameLabel.BackgroundTransparency = 1
        resetNameLabel.TextColor3 = UI.Colors.text
        resetNameLabel.TextSize = 14
        resetNameLabel.Font = Enum.Font.GothamBold
        resetNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        resetNameLabel.Size = UDim2.new(1,-14,0,20)
        resetNameLabel.Position = UDim2.new(0,12,0,10)

        UI.ResetStatus = Instance.new("TextLabel", resetCard)
        UI.ResetStatus.Text = UI.resetEnabled and "ON" or "OFF"
        UI.ResetStatus.BackgroundTransparency = 1
        UI.ResetStatus.TextColor3 = UI.resetEnabled and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        UI.ResetStatus.TextSize = 13
        UI.ResetStatus.Font = Enum.Font.GothamBold
        UI.ResetStatus.TextXAlignment = Enum.TextXAlignment.Left
        UI.ResetStatus.Size = UDim2.new(1,-14,0,20)
        UI.ResetStatus.Position = UDim2.new(0,12,0,38)

        UI.ResetPillBg = Instance.new("Frame", resetCard)
        UI.ResetPillBg.Size = UDim2.new(0,46,0,24)
        UI.ResetPillBg.Position = UDim2.new(1,-54,0.5,-12)
        UI.ResetPillBg.BackgroundColor3 = UI.resetEnabled and Color3.fromRGB(50,150,255) or UI.Colors.inactive
        UI.ResetPillBg.BorderSizePixel = 0
        Instance.new("UICorner", UI.ResetPillBg).CornerRadius = UDim.new(1,0)

        UI.ResetPillCircle = Instance.new("Frame", UI.ResetPillBg)
        UI.ResetPillCircle.Size = UDim2.new(0,18,0,18)
        UI.ResetPillCircle.Position = UI.resetEnabled and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        UI.ResetPillCircle.BackgroundColor3 = Color3.new(1,1,1)
        UI.ResetPillCircle.BorderSizePixel = 0
        Instance.new("UICorner", UI.ResetPillCircle).CornerRadius = UDim.new(1,0)

        local resetKeybindRow = Instance.new("Frame", resetCard)
        resetKeybindRow.Size = UDim2.new(1,-24,0,20)
        resetKeybindRow.Position = UDim2.new(0,12,0,45)
        resetKeybindRow.BackgroundTransparency = 1

        local resetKeybindLabel = Instance.new("TextLabel", resetKeybindRow)
        resetKeybindLabel.Size = UDim2.new(0.3,0,1,0)
        resetKeybindLabel.BackgroundTransparency = 1
        resetKeybindLabel.Text = "Key:"
        resetKeybindLabel.TextColor3 = UI.Colors.textDim
        resetKeybindLabel.TextSize = 11
        resetKeybindLabel.Font = Enum.Font.GothamBold
        resetKeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

        UI.ResetKeybindBtn = Instance.new("TextButton", resetKeybindRow)
        UI.ResetKeybindBtn.Size = UDim2.new(0.25,0,0.8,0)
        UI.ResetKeybindBtn.Position = UDim2.new(0.3,0,0.1,0)
        UI.ResetKeybindBtn.BackgroundColor3 = Color3.fromRGB(50,150,255)
        UI.ResetKeybindBtn.TextColor3 = UI.Colors.text
        UI.ResetKeybindBtn.Font = Enum.Font.GothamBold
        UI.ResetKeybindBtn.TextSize = 11
        UI.ResetKeybindBtn.Text = resetKeybind.Name
        Instance.new("UICorner", UI.ResetKeybindBtn).CornerRadius = UDim.new(0,4)

        UI.ResetKeybindBtn.MouseButton1Click:Connect(function()
            if resetAwaitingKeybind then return end
            resetAwaitingKeybind = true
            UI.ResetKeybindBtn.Text = "..."
            UI.ResetKeybindBtn.BackgroundColor3 = Color3.fromRGB(200,200,0)
        end)

        resetCard.MouseButton1Click:Connect(toggleReset)

        -- TP DOWN
        local tpDownCard = Instance.new("TextButton")
        tpDownCard.Text = ""
        tpDownCard.Size = UDim2.new(0.92,0,0,65)
        tpDownCard.Position = UDim2.new(0.04,0,0,415)
        tpDownCard.BackgroundColor3 = UI.Colors.card
        tpDownCard.BorderSizePixel = 0
        tpDownCard.AutoButtonColor = false
        tpDownCard.Parent = scrollContentMisc
        Instance.new("UICorner", tpDownCard).CornerRadius = UDim.new(0,10)

        local tpDownCardStroke = Instance.new("UIStroke", tpDownCard)
        tpDownCardStroke.Color = UI.Colors.border
        tpDownCardStroke.Thickness = 1

        UI.TpDownCardAccent = Instance.new("Frame", tpDownCard)
        UI.TpDownCardAccent.Size = UDim2.new(0,3,0.5,0)
        UI.TpDownCardAccent.Position = UDim2.new(0,0,0.25,0)
        UI.TpDownCardAccent.BackgroundColor3 = UI.tpDownEnabled and Color3.fromRGB(200,100,0) or UI.Colors.dim
        UI.TpDownCardAccent.BorderSizePixel = 0
        Instance.new("UICorner", UI.TpDownCardAccent).CornerRadius = UDim.new(0,2)

        local tpDownNameLabel = Instance.new("TextLabel", tpDownCard)
        tpDownNameLabel.Text = "⬇️ TP DOWN"
        tpDownNameLabel.BackgroundTransparency = 1
        tpDownNameLabel.TextColor3 = UI.Colors.text
        tpDownNameLabel.TextSize = 14
        tpDownNameLabel.Font = Enum.Font.GothamBold
        tpDownNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        tpDownNameLabel.Size = UDim2.new(1,-14,0,20)
        tpDownNameLabel.Position = UDim2.new(0,12,0,10)

        UI.TpDownStatus = Instance.new("TextLabel", tpDownCard)
        UI.TpDownStatus.Text = UI.tpDownEnabled and "ON" or "OFF"
        UI.TpDownStatus.BackgroundTransparency = 1
        UI.TpDownStatus.TextColor3 = UI.tpDownEnabled and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        UI.TpDownStatus.TextSize = 13
        UI.TpDownStatus.Font = Enum.Font.GothamBold
        UI.TpDownStatus.TextXAlignment = Enum.TextXAlignment.Left
        UI.TpDownStatus.Size = UDim2.new(1,-14,0,20)
        UI.TpDownStatus.Position = UDim2.new(0,12,0,38)

        UI.TpDownPillBg = Instance.new("Frame", tpDownCard)
        UI.TpDownPillBg.Size = UDim2.new(0,46,0,24)
        UI.TpDownPillBg.Position = UDim2.new(1,-54,0.5,-12)
        UI.TpDownPillBg.BackgroundColor3 = UI.tpDownEnabled and Color3.fromRGB(200,100,0) or UI.Colors.inactive
        UI.TpDownPillBg.BorderSizePixel = 0
        Instance.new("UICorner", UI.TpDownPillBg).CornerRadius = UDim.new(1,0)

        UI.TpDownPillCircle = Instance.new("Frame", UI.TpDownPillBg)
        UI.TpDownPillCircle.Size = UDim2.new(0,18,0,18)
        UI.TpDownPillCircle.Position = UI.tpDownEnabled and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        UI.TpDownPillCircle.BackgroundColor3 = Color3.new(1,1,1)
        UI.TpDownPillCircle.BorderSizePixel = 0
        Instance.new("UICorner", UI.TpDownPillCircle).CornerRadius = UDim.new(1,0)

        local tpDownKeybindRow = Instance.new("Frame", tpDownCard)
        tpDownKeybindRow.Size = UDim2.new(1,-24,0,20)
        tpDownKeybindRow.Position = UDim2.new(0,12,0,45)
        tpDownKeybindRow.BackgroundTransparency = 1

        local tpDownKeybindLabel = Instance.new("TextLabel", tpDownKeybindRow)
        tpDownKeybindLabel.Size = UDim2.new(0.3,0,1,0)
        tpDownKeybindLabel.BackgroundTransparency = 1
        tpDownKeybindLabel.Text = "Key:"
        tpDownKeybindLabel.TextColor3 = UI.Colors.textDim
        tpDownKeybindLabel.TextSize = 11
        tpDownKeybindLabel.Font = Enum.Font.GothamBold
        tpDownKeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

        UI.TpDownKeybindBtn = Instance.new("TextButton", tpDownKeybindRow)
        UI.TpDownKeybindBtn.Size = UDim2.new(0.25,0,0.8,0)
        UI.TpDownKeybindBtn.Position = UDim2.new(0.3,0,0.1,0)
        UI.TpDownKeybindBtn.BackgroundColor3 = Color3.fromRGB(200,100,0)
        UI.TpDownKeybindBtn.TextColor3 = UI.Colors.text
        UI.TpDownKeybindBtn.Font = Enum.Font.GothamBold
        UI.TpDownKeybindBtn.TextSize = 11
        UI.TpDownKeybindBtn.Text = tpDownKeybind.Name
        Instance.new("UICorner", UI.TpDownKeybindBtn).CornerRadius = UDim.new(0,4)

        UI.TpDownKeybindBtn.MouseButton1Click:Connect(function()
            if tpDownAwaitingKeybind then return end
            tpDownAwaitingKeybind = true
            UI.TpDownKeybindBtn.Text = "..."
            UI.TpDownKeybindBtn.BackgroundColor3 = Color3.fromRGB(200,200,0)
        end)

        tpDownCard.MouseButton1Click:Connect(toggleTpDown)

        -- ANTI-LAG
        local antiLagCard = Instance.new("TextButton")
        antiLagCard.Text = ""
        antiLagCard.Size = UDim2.new(0.92,0,0,65)
        antiLagCard.Position = UDim2.new(0.04,0,0,490)
        antiLagCard.BackgroundColor3 = UI.Colors.card
        antiLagCard.BorderSizePixel = 0
        antiLagCard.AutoButtonColor = false
        antiLagCard.Parent = scrollContentMisc
        Instance.new("UICorner", antiLagCard).CornerRadius = UDim.new(0,10)

        local antiLagCardStroke = Instance.new("UIStroke", antiLagCard)
        antiLagCardStroke.Color = UI.Colors.border
        antiLagCardStroke.Thickness = 1

        UI.AntiLagCardAccent = Instance.new("Frame", antiLagCard)
        UI.AntiLagCardAccent.Size = UDim2.new(0,3,0.5,0)
        UI.AntiLagCardAccent.Position = UDim2.new(0,0,0.25,0)
        UI.AntiLagCardAccent.BackgroundColor3 = UI.Colors.dim
        UI.AntiLagCardAccent.BorderSizePixel = 0
        Instance.new("UICorner", UI.AntiLagCardAccent).CornerRadius = UDim.new(0,2)

        local antiLagNameLabel = Instance.new("TextLabel", antiLagCard)
        antiLagNameLabel.Text = "🔧 ANTI-LAG (Optimisation)"
        antiLagNameLabel.BackgroundTransparency = 1
        antiLagNameLabel.TextColor3 = UI.Colors.text
        antiLagNameLabel.TextSize = 14
        antiLagNameLabel.Font = Enum.Font.GothamBold
        antiLagNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        antiLagNameLabel.Size = UDim2.new(1,-14,0,20)
        antiLagNameLabel.Position = UDim2.new(0,12,0,10)

        UI.AntiLagStatus = Instance.new("TextLabel", antiLagCard)
        UI.AntiLagStatus.Text = "OFF"
        UI.AntiLagStatus.BackgroundTransparency = 1
        UI.AntiLagStatus.TextColor3 = UI.Colors.textDim
        UI.AntiLagStatus.TextSize = 13
        UI.AntiLagStatus.Font = Enum.Font.GothamBold
        UI.AntiLagStatus.TextXAlignment = Enum.TextXAlignment.Left
        UI.AntiLagStatus.Size = UDim2.new(1,-14,0,20)
        UI.AntiLagStatus.Position = UDim2.new(0,12,0,38)

        UI.AntiLagPillBg = Instance.new("Frame", antiLagCard)
        UI.AntiLagPillBg.Size = UDim2.new(0,46,0,24)
        UI.AntiLagPillBg.Position = UDim2.new(1,-54,0.5,-12)
        UI.AntiLagPillBg.BackgroundColor3 = UI.Colors.inactive
        UI.AntiLagPillBg.BorderSizePixel = 0
        Instance.new("UICorner", UI.AntiLagPillBg).CornerRadius = UDim.new(1,0)

        UI.AntiLagPillCircle = Instance.new("Frame", UI.AntiLagPillBg)
        UI.AntiLagPillCircle.Size = UDim2.new(0,18,0,18)
        UI.AntiLagPillCircle.Position = UDim2.new(0,3,0.5,-9)
        UI.AntiLagPillCircle.BackgroundColor3 = Color3.new(1,1,1)
        UI.AntiLagPillCircle.BorderSizePixel = 0
        Instance.new("UICorner", UI.AntiLagPillCircle).CornerRadius = UDim.new(1,0)

        antiLagCard.MouseButton1Click:Connect(toggleAntiLag)

        local totalHeight = 65 + 75 + 65 + 75 + 65 + 75 + 100 + 75 + 65 + 75 + 65 + 75
        scrollContentMisc.Size = UDim2.new(1,0,0,totalHeight)
        miscContent.CanvasSize = UDim2.new(0,0,0,totalHeight + 20)

        -- VISUAL
        local visualContent = Instance.new("ScrollingFrame", contentFrame)
        visualContent.Size = UDim2.new(1,0,1,0); visualContent.BackgroundTransparency = 1
        visualContent.Visible = false
        visualContent.BorderSizePixel = 0
        visualContent.ScrollBarThickness = 6
        visualContent.ScrollBarImageColor3 = UI.Colors.accent
        visualContent.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

        local scrollContentVisual = Instance.new("Frame", visualContent)
        scrollContentVisual.Size = UDim2.new(1,0,0,0)
        scrollContentVisual.BackgroundTransparency = 1
        local visualLayout = Instance.new("UIListLayout", scrollContentVisual)
        visualLayout.SortOrder = Enum.SortOrder.LayoutOrder
        visualLayout.Padding = UDim.new(0,6)

        -- FOV
        local fovRow = Instance.new("Frame", scrollContentVisual)
        fovRow.Size = UDim2.new(0.92,0,0,50)
        fovRow.BackgroundColor3 = UI.Colors.card
        Instance.new("UICorner", fovRow).CornerRadius = UDim.new(0,8)

        local fovLabel = Instance.new("TextLabel", fovRow)
        fovLabel.Size = UDim2.new(0.5,0,1,0); fovLabel.Position = UDim2.new(0,10,0,0)
        fovLabel.BackgroundTransparency = 1
        fovLabel.Text = "FOV : 70"
        fovLabel.TextColor3 = UI.Colors.text
        fovLabel.Font = Enum.Font.GothamBold
        fovLabel.TextSize = 18
        fovLabel.TextXAlignment = Enum.TextXAlignment.Left
        fovLabel.TextYAlignment = Enum.TextYAlignment.Center

        local minusBtn = Instance.new("TextButton", fovRow)
        minusBtn.Size = UDim2.new(0,35,0,30); minusBtn.Position = UDim2.new(1,-80,0.5,-15)
        minusBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
        minusBtn.Text = "-"; minusBtn.TextColor3 = UI.Colors.text; minusBtn.Font = Enum.Font.GothamBold; minusBtn.TextSize = 20
        Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0,6)

        local plusBtn = Instance.new("TextButton", fovRow)
        plusBtn.Size = UDim2.new(0,35,0,30); plusBtn.Position = UDim2.new(1,-35,0.5,-15)
        plusBtn.BackgroundColor3 = Color3.fromRGB(50,200,50)
        plusBtn.Text = "+"; plusBtn.TextColor3 = UI.Colors.text; plusBtn.Font = Enum.Font.GothamBold; plusBtn.TextSize = 20
        Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0,6)

        local fovResetBtn = Instance.new("TextButton", fovRow)
        fovResetBtn.Size = UDim2.new(0,35,0,30); fovResetBtn.Position = UDim2.new(1,-125,0.5,-15)
        fovResetBtn.BackgroundColor3 = Color3.fromRGB(50,50,200)
        fovResetBtn.Text = "R"; fovResetBtn.TextColor3 = UI.Colors.text; fovResetBtn.Font = Enum.Font.GothamBold; fovResetBtn.TextSize = 16
        Instance.new("UICorner", fovResetBtn).CornerRadius = UDim.new(0,6)

        local currentFOV = 70
        pcall(function() currentFOV = camera.FieldOfView or 70 end)
        fovLabel.Text = "FOV : " .. math.floor(currentFOV)

        local function updateFOV(value)
            currentFOV = math.clamp(value, 1, 120)
            pcall(function() camera.FieldOfView = currentFOV end)
            fovLabel.Text = "FOV : " .. math.floor(currentFOV)
        end

        minusBtn.MouseButton1Click:Connect(function() updateFOV(currentFOV - 5) end)
        plusBtn.MouseButton1Click:Connect(function() updateFOV(currentFOV + 5) end)
        fovResetBtn.MouseButton1Click:Connect(function() updateFOV(70) end)

        -- SHOW BUTTONS
        local showButtonsCard = Instance.new("TextButton", scrollContentVisual)
        showButtonsCard.Text = ""
        showButtonsCard.Size = UDim2.new(0.92,0,0,65)
        showButtonsCard.BackgroundColor3 = UI.Colors.card
        showButtonsCard.BorderSizePixel = 0
        showButtonsCard.AutoButtonColor = false
        Instance.new("UICorner", showButtonsCard).CornerRadius = UDim.new(0,10)

        local showButtonsCardStroke = Instance.new("UIStroke", showButtonsCard)
        showButtonsCardStroke.Color = UI.Colors.border
        showButtonsCardStroke.Thickness = 1

        UI.showButtonsCardAccent = Instance.new("Frame", showButtonsCard)
        UI.showButtonsCardAccent.Size = UDim2.new(0,3,0.5,0)
        UI.showButtonsCardAccent.Position = UDim2.new(0,0,0.25,0)
        UI.showButtonsCardAccent.BackgroundColor3 = UI.showMobileButtons and UI.Colors.accent or UI.Colors.dim
        UI.showButtonsCardAccent.BorderSizePixel = 0
        Instance.new("UICorner", UI.showButtonsCardAccent).CornerRadius = UDim.new(0,2)

        local showButtonsNameLabel = Instance.new("TextLabel", showButtonsCard)
        showButtonsNameLabel.Text = "👁️ SHOW BUTTONS"
        showButtonsNameLabel.BackgroundTransparency = 1
        showButtonsNameLabel.TextColor3 = UI.Colors.text
        showButtonsNameLabel.TextSize = 14
        showButtonsNameLabel.Font = Enum.Font.GothamBold
        showButtonsNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        showButtonsNameLabel.Size = UDim2.new(1,-14,0,20)
        showButtonsNameLabel.Position = UDim2.new(0,12,0,10)

        UI.showButtonsStatus = Instance.new("TextLabel", showButtonsCard)
        UI.showButtonsStatus.Text = UI.showMobileButtons and "ON" or "OFF"
        UI.showButtonsStatus.BackgroundTransparency = 1
        UI.showButtonsStatus.TextColor3 = UI.showMobileButtons and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        UI.showButtonsStatus.TextSize = 13
        UI.showButtonsStatus.Font = Enum.Font.GothamBold
        UI.showButtonsStatus.TextXAlignment = Enum.TextXAlignment.Left
        UI.showButtonsStatus.Size = UDim2.new(1,-14,0,20)
        UI.showButtonsStatus.Position = UDim2.new(0,12,0,38)

        UI.showButtonsPillBg = Instance.new("Frame", showButtonsCard)
        UI.showButtonsPillBg.Size = UDim2.new(0,46,0,24)
        UI.showButtonsPillBg.Position = UDim2.new(1,-54,0.5,-12)
        UI.showButtonsPillBg.BackgroundColor3 = UI.showMobileButtons and UI.Colors.accent or UI.Colors.inactive
        UI.showButtonsPillBg.BorderSizePixel = 0
        Instance.new("UICorner", UI.showButtonsPillBg).CornerRadius = UDim.new(1,0)

        UI.showButtonsPillCircle = Instance.new("Frame", UI.showButtonsPillBg)
        UI.showButtonsPillCircle.Size = UDim2.new(0,18,0,18)
        UI.showButtonsPillCircle.Position = UI.showMobileButtons and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        UI.showButtonsPillCircle.BackgroundColor3 = Color3.new(1,1,1)
        UI.showButtonsPillCircle.BorderSizePixel = 0
        Instance.new("UICorner", UI.showButtonsPillCircle).CornerRadius = UDim.new(1,0)

        local function toggleShowButtons()
            UI.showMobileButtons = not UI.showMobileButtons
            setSetting("showMobileButtons", UI.showMobileButtons)
            local on = UI.showMobileButtons
            if UI.showButtonsStatus then
                UI.showButtonsStatus.Text = on and "ON" or "OFF"
                UI.showButtonsStatus.TextColor3 = on and Color3.fromRGB(80,255,80) or UI.Colors.textDim
            end
            if UI.showButtonsPillBg then
                TweenService:Create(UI.showButtonsPillBg, TweenInfo.new(0.25), {BackgroundColor3 = on and UI.Colors.accent or UI.Colors.inactive}):Play()
            end
            if UI.showButtonsPillCircle then
                TweenService:Create(UI.showButtonsPillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}):Play()
            end
            if UI.showButtonsCardAccent then
                TweenService:Create(UI.showButtonsCardAccent, TweenInfo.new(0.15), {BackgroundColor3 = on and UI.Colors.accent or UI.Colors.dim}):Play()
            end
            mobileButtonsVisible = on
            for _, btn in ipairs(mobileButtons) do
                if btn and btn.Parent then btn.Visible = on end
            end
        end

        showButtonsCard.MouseButton1Click:Connect(toggleShowButtons)

        -- BOUTONS DE SÉLECTION DES BOUTONS MOBILES
        local mobileSelectTitle = Instance.new("TextLabel", scrollContentVisual)
        mobileSelectTitle.Size = UDim2.new(0.92,0,0,20)
        mobileSelectTitle.BackgroundTransparency = 1
        mobileSelectTitle.Text = "Boutons mobiles à afficher :"
        mobileSelectTitle.TextColor3 = UI.Colors.text
        mobileSelectTitle.TextSize = 12
        mobileSelectTitle.Font = Enum.Font.GothamBold
        mobileSelectTitle.TextXAlignment = Enum.TextXAlignment.Left

        local function createMobileToggle(parent, label, key, defaultState)
            local row = Instance.new("Frame", parent)
            row.Size = UDim2.new(0.92,0,0,30)
            row.BackgroundTransparency = 1

            local lbl = Instance.new("TextLabel", row)
            lbl.Size = UDim2.new(0.6,0,1,0)
            lbl.Position = UDim2.new(0,5,0,0)
            lbl.BackgroundTransparency = 1
            lbl.Text = label
            lbl.TextColor3 = UI.Colors.textDim
            lbl.TextSize = 11
            lbl.Font = Enum.Font.Gotham
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local pillBg = Instance.new("Frame", row)
            pillBg.Size = UDim2.new(0,35,0,18)
            pillBg.Position = UDim2.new(1,-40,0.5,-9)
            pillBg.BackgroundColor3 = defaultState and UI.Colors.accent or UI.Colors.inactive
            pillBg.BorderSizePixel = 0
            Instance.new("UICorner", pillBg).CornerRadius = UDim.new(1,0)

            local pillCircle = Instance.new("Frame", pillBg)
            pillCircle.Size = UDim2.new(0,14,0,14)
            pillCircle.Position = defaultState and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
            pillCircle.BackgroundColor3 = Color3.new(1,1,1)
            pillCircle.BorderSizePixel = 0
            Instance.new("UICorner", pillCircle).CornerRadius = UDim.new(1,0)

            local btn = Instance.new("TextButton", row)
            btn.Size = UDim2.new(1,0,1,0)
            btn.BackgroundTransparency = 1
            btn.Text = ""

            btn.MouseButton1Click:Connect(function()
                mobileBtnStates[key] = not mobileBtnStates[key]
                setSetting("mobileBtn" .. key:gsub("^%l", string.upper), mobileBtnStates[key])
                local on = mobileBtnStates[key]
                TweenService:Create(pillBg, TweenInfo.new(0.2), {BackgroundColor3 = on and UI.Colors.accent or UI.Colors.inactive}):Play()
                TweenService:Create(pillCircle, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Position = on and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)}):Play()

                local btnNameMap = {
                    reset = "ResetBtn",
                    tpDown = "TpDownBtn",
                    drop = "DropBtn",
                    tpBest = "TpBestBtn",
                    destroy = "DestroyBtn",
                }
                local name = btnNameMap[key]
                for _, mb in ipairs(mobileButtons) do
                    if mb and mb.Name == name then
                        mb.Visible = on and UI.showMobileButtons
                    end
                end
            end)

            return {pillBg = pillBg, pillCircle = pillCircle}
        end

        local toggles = {
            {key = "reset", label = "🔄 RESET"},
            {key = "tpDown", label = "⬇️ TP DOWN"},
            {key = "drop", label = "💀 DROP"},
            {key = "tpBest", label = "⭐ TP BEST"},
            {key = "destroy", label = "💥 DESTROY V2"},
        }

        for _, t in ipairs(toggles) do
            createMobileToggle(scrollContentVisual, t.label, t.key, mobileBtnStates[t.key])
        end

        -- BOUTON LOCK/UNLOCK
        local lockCard = Instance.new("TextButton", scrollContentVisual)
        lockCard.Text = ""
        lockCard.Size = UDim2.new(0.92,0,0,45)
        lockCard.Position = UDim2.new(0.04,0,0,205)
        lockCard.BackgroundColor3 = UI.Colors.card
        lockCard.BorderSizePixel = 0
        lockCard.AutoButtonColor = false
        Instance.new("UICorner", lockCard).CornerRadius = UDim.new(0,10)

        local lockCardStroke = Instance.new("UIStroke", lockCard)
        lockCardStroke.Color = UI.Colors.border
        lockCardStroke.Thickness = 1

        local lockCardAccent = Instance.new("Frame", lockCard)
        lockCardAccent.Size = UDim2.new(0,3,0.5,0)
        lockCardAccent.Position = UDim2.new(0,0,0.25,0)
        lockCardAccent.BackgroundColor3 = mobileButtonsLocked and Color3.fromRGB(255,50,50) or Color3.fromRGB(50,255,50)
        lockCardAccent.BorderSizePixel = 0
        Instance.new("UICorner", lockCardAccent).CornerRadius = UDim.new(0,2)

        local lockNameLabel = Instance.new("TextLabel", lockCard)
        lockNameLabel.Text = mobileButtonsLocked and "🔒 LOCKED" or "🔓 UNLOCKED"
        lockNameLabel.BackgroundTransparency = 1
        lockNameLabel.TextColor3 = mobileButtonsLocked and Color3.fromRGB(255,100,100) or Color3.fromRGB(100,255,100)
        lockNameLabel.TextSize = 14
        lockNameLabel.Font = Enum.Font.GothamBold
        lockNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        lockNameLabel.Size = UDim2.new(1,-14,0,20)
        lockNameLabel.Position = UDim2.new(0,12,0,12)

        local lockPillBg = Instance.new("Frame", lockCard)
        lockPillBg.Size = UDim2.new(0,46,0,24)
        lockPillBg.Position = UDim2.new(1,-54,0.5,-12)
        lockPillBg.BackgroundColor3 = mobileButtonsLocked and Color3.fromRGB(255,50,50) or Color3.fromRGB(50,255,50)
        lockPillBg.BorderSizePixel = 0
        Instance.new("UICorner", lockPillBg).CornerRadius = UDim.new(1,0)

        local lockPillCircle = Instance.new("Frame", lockPillBg)
        lockPillCircle.Size = UDim2.new(0,18,0,18)
        lockPillCircle.Position = mobileButtonsLocked and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        lockPillCircle.BackgroundColor3 = Color3.new(1,1,1)
        lockPillCircle.BorderSizePixel = 0
        Instance.new("UICorner", lockPillCircle).CornerRadius = UDim.new(1,0)

        local function toggleLock()
            mobileButtonsLocked = not mobileButtonsLocked
            setSetting("mobileButtonsLocked", mobileButtonsLocked)
            lockNameLabel.Text = mobileButtonsLocked and "🔒 LOCKED" or "🔓 UNLOCKED"
            lockNameLabel.TextColor3 = mobileButtonsLocked and Color3.fromRGB(255,100,100) or Color3.fromRGB(100,255,100)
            TweenService:Create(lockCardAccent, TweenInfo.new(0.25), {
                BackgroundColor3 = mobileButtonsLocked and Color3.fromRGB(255,50,50) or Color3.fromRGB(50,255,50)
            }):Play()
            TweenService:Create(lockPillBg, TweenInfo.new(0.25), {
                BackgroundColor3 = mobileButtonsLocked and Color3.fromRGB(255,50,50) or Color3.fromRGB(50,255,50)
            }):Play()
            TweenService:Create(lockPillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
                Position = mobileButtonsLocked and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
            }):Play()
            for _, btn in ipairs(mobileButtons) do
                if btn and btn.Parent then
                    if mobileButtonsLocked then
                        btn.Active = false
                        btn.Draggable = false
                    else
                        btn.Active = true
                        btn.Draggable = true
                    end
                end
            end
        end

        lockCard.MouseButton1Click:Connect(toggleLock)

        -- SAVE CONFIGS
        local saveConfigsCard = Instance.new("TextButton", scrollContentVisual)
        saveConfigsCard.Text = ""
        saveConfigsCard.Size = UDim2.new(0.92,0,0,45)
        saveConfigsCard.BackgroundColor3 = UI.Colors.card
        saveConfigsCard.BorderSizePixel = 0
        saveConfigsCard.AutoButtonColor = false
        Instance.new("UICorner", saveConfigsCard).CornerRadius = UDim.new(0,10)

        local saveCardStroke = Instance.new("UIStroke", saveConfigsCard)
        saveCardStroke.Color = UI.Colors.border
        saveCardStroke.Thickness = 1

        local saveCardAccent = Instance.new("Frame", saveConfigsCard)
        saveCardAccent.Size = UDim2.new(0,3,0.5,0)
        saveCardAccent.Position = UDim2.new(0,0,0.25,0)
        saveCardAccent.BackgroundColor3 = Color3.fromRGB(0,200,150)
        saveCardAccent.BorderSizePixel = 0
        Instance.new("UICorner", saveCardAccent).CornerRadius = UDim.new(0,2)

        local saveNameLabel = Instance.new("TextLabel", saveConfigsCard)
        saveNameLabel.Text = "💾 SAVE CONFIGS"
        saveNameLabel.BackgroundTransparency = 1
        saveNameLabel.TextColor3 = UI.Colors.text
        saveNameLabel.TextSize = 14
        saveNameLabel.Font = Enum.Font.GothamBold
        saveNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        saveNameLabel.Size = UDim2.new(1,-14,0,20)
        saveNameLabel.Position = UDim2.new(0,12,0,12)

        local saveStatusLabel = Instance.new("TextLabel", saveConfigsCard)
        saveStatusLabel.Text = "✅ Sauvegarder"
        saveStatusLabel.BackgroundTransparency = 1
        saveStatusLabel.TextColor3 = UI.Colors.textDim
        saveStatusLabel.TextSize = 12
        saveStatusLabel.Font = Enum.Font.Gotham
        saveStatusLabel.TextXAlignment = Enum.TextXAlignment.Right
        saveStatusLabel.Size = UDim2.new(0.4,0,1,0)
        saveStatusLabel.Position = UDim2.new(0.6,0,0,0)

        local function onSaveConfigs()
            saveAllConfigs()
            saveStatusLabel.Text = "✅ Sauvegardé !"
            saveStatusLabel.TextColor3 = Color3.fromRGB(80,255,80)
            TweenService:Create(saveConfigsCard, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30,70,40)}):Play()
            TweenService:Create(saveCardAccent, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,255,80)}):Play()
            task.delay(1.5, function()
                saveStatusLabel.Text = "✅ Sauvegarder"
                saveStatusLabel.TextColor3 = UI.Colors.textDim
                TweenService:Create(saveConfigsCard, TweenInfo.new(0.2), {BackgroundColor3 = UI.Colors.card}):Play()
                TweenService:Create(saveCardAccent, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0,200,150)}):Play()
            end)
        end

        saveConfigsCard.MouseButton1Click:Connect(onSaveConfigs)

        -- AUTO SAVE CONFIG CARD
        local autoSaveCard = Instance.new("TextButton", scrollContentVisual)
        autoSaveCard.Text = ""
        autoSaveCard.Size = UDim2.new(0.92,0,0,65)
        autoSaveCard.BackgroundColor3 = UI.Colors.card
        autoSaveCard.BorderSizePixel = 0
        autoSaveCard.AutoButtonColor = false
        Instance.new("UICorner", autoSaveCard).CornerRadius = UDim.new(0,10)

        local autoSaveCardStroke = Instance.new("UIStroke", autoSaveCard)
        autoSaveCardStroke.Color = UI.Colors.border
        autoSaveCardStroke.Thickness = 1

        UI.autoSaveCardAccent = Instance.new("Frame", autoSaveCard)
        UI.autoSaveCardAccent.Size = UDim2.new(0,3,0.5,0)
        UI.autoSaveCardAccent.Position = UDim2.new(0,0,0.25,0)
        UI.autoSaveCardAccent.BackgroundColor3 = autoSaveEnabled and UI.Colors.accent or UI.Colors.dim
        UI.autoSaveCardAccent.BorderSizePixel = 0
        Instance.new("UICorner", UI.autoSaveCardAccent).CornerRadius = UDim.new(0,2)

        local autoSaveNameLabel = Instance.new("TextLabel", autoSaveCard)
        autoSaveNameLabel.Text = "💾 AUTO SAVE CONFIG"
        autoSaveNameLabel.BackgroundTransparency = 1
        autoSaveNameLabel.TextColor3 = UI.Colors.text
        autoSaveNameLabel.TextSize = 14
        autoSaveNameLabel.Font = Enum.Font.GothamBold
        autoSaveNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        autoSaveNameLabel.Size = UDim2.new(1,-14,0,20)
        autoSaveNameLabel.Position = UDim2.new(0,12,0,10)

        UI.autoSaveStatus = Instance.new("TextLabel", autoSaveCard)
        UI.autoSaveStatus.Text = autoSaveEnabled and "ON" or "OFF"
        UI.autoSaveStatus.BackgroundTransparency = 1
        UI.autoSaveStatus.TextColor3 = autoSaveEnabled and Color3.fromRGB(80,255,80) or UI.Colors.textDim
        UI.autoSaveStatus.TextSize = 13
        UI.autoSaveStatus.Font = Enum.Font.GothamBold
        UI.autoSaveStatus.TextXAlignment = Enum.TextXAlignment.Left
        UI.autoSaveStatus.Size = UDim2.new(1,-14,0,20)
        UI.autoSaveStatus.Position = UDim2.new(0,12,0,38)

        UI.autoSavePillBg = Instance.new("Frame", autoSaveCard)
        UI.autoSavePillBg.Size = UDim2.new(0,46,0,24)
        UI.autoSavePillBg.Position = UDim2.new(1,-54,0.5,-12)
        UI.autoSavePillBg.BackgroundColor3 = autoSaveEnabled and UI.Colors.accent or UI.Colors.inactive
        UI.autoSavePillBg.BorderSizePixel = 0
        Instance.new("UICorner", UI.autoSavePillBg).CornerRadius = UDim.new(1,0)

        UI.autoSavePillCircle = Instance.new("Frame", UI.autoSavePillBg)
        UI.autoSavePillCircle.Size = UDim2.new(0,18,0,18)
        UI.autoSavePillCircle.Position = autoSaveEnabled and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        UI.autoSavePillCircle.BackgroundColor3 = Color3.new(1,1,1)
        UI.autoSavePillCircle.BorderSizePixel = 0
        Instance.new("UICorner", UI.autoSavePillCircle).CornerRadius = UDim.new(1,0)

        local function toggleAutoSaveFunc()
            autoSaveEnabled = not autoSaveEnabled
            setSetting("autoSaveEnabled", autoSaveEnabled)
            local on = autoSaveEnabled
            if UI.autoSaveStatus then
                UI.autoSaveStatus.Text = on and "ON" or "OFF"
                UI.autoSaveStatus.TextColor3 = on and Color3.fromRGB(80,255,80) or UI.Colors.textDim
            end
            if UI.autoSavePillBg then
                TweenService:Create(UI.autoSavePillBg, TweenInfo.new(0.25), {BackgroundColor3 = on and UI.Colors.accent or UI.Colors.inactive}):Play()
            end
            if UI.autoSavePillCircle then
                TweenService:Create(UI.autoSavePillCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}):Play()
            end
            if UI.autoSaveCardAccent then
                TweenService:Create(UI.autoSaveCardAccent, TweenInfo.new(0.15), {BackgroundColor3 = on and UI.Colors.accent or UI.Colors.dim}):Play()
            end
            if on then startAutoSave() else stopAutoSave() end
        end

        autoSaveCard.MouseButton1Click:Connect(toggleAutoSaveFunc)

        -- AUTO SAVE INTERVAL ROW
        local autoSaveIntervalRow = Instance.new("Frame", scrollContentVisual)
        autoSaveIntervalRow.Size = UDim2.new(0.92,0,0,40)
        autoSaveIntervalRow.BackgroundColor3 = UI.Colors.card
        Instance.new("UICorner", autoSaveIntervalRow).CornerRadius = UDim.new(0,8)

        local autoSaveIntervalLabel = Instance.new("TextLabel", autoSaveIntervalRow)
        autoSaveIntervalLabel.Size = UDim2.new(0.5,0,1,0)
        autoSaveIntervalLabel.Position = UDim2.new(0,10,0,0)
        autoSaveIntervalLabel.BackgroundTransparency = 1
        autoSaveIntervalLabel.Text = "Intervalle (sec) :"
        autoSaveIntervalLabel.TextColor3 = UI.Colors.text
        autoSaveIntervalLabel.Font = Enum.Font.GothamBold
        autoSaveIntervalLabel.TextSize = 13
        autoSaveIntervalLabel.TextXAlignment = Enum.TextXAlignment.Left
        autoSaveIntervalLabel.TextYAlignment = Enum.TextYAlignment.Center

        UI.autoSaveIntervalBox = Instance.new("TextBox", autoSaveIntervalRow)
        UI.autoSaveIntervalBox.Size = UDim2.new(0,60,0,28)
        UI.autoSaveIntervalBox.Position = UDim2.new(1,-80,0.5,-14)
        UI.autoSaveIntervalBox.BackgroundColor3 = Color3.fromRGB(30,30,50)
        UI.autoSaveIntervalBox.TextColor3 = UI.Colors.text
        UI.autoSaveIntervalBox.Font = Enum.Font.GothamBold
        UI.autoSaveIntervalBox.TextSize = 13
        UI.autoSaveIntervalBox.Text = tostring(autoSaveInterval)
        UI.autoSaveIntervalBox.ClearTextOnFocus = false
        Instance.new("UICorner", UI.autoSaveIntervalBox).CornerRadius = UDim.new(0,4)

        UI.autoSaveIntervalBox.FocusLost:Connect(function(enter)
            if enter then
                local val = tonumber(UI.autoSaveIntervalBox.Text)
                if val and val >= 5 then
                    autoSaveInterval = math.floor(val)
                    setSetting("autoSaveInterval", autoSaveInterval)
                    UI.autoSaveIntervalBox.Text = tostring(autoSaveInterval)
                    autoSaveLastTime = tick()
                else
                    UI.autoSaveIntervalBox.Text = tostring(autoSaveInterval)
                end
            end
        end)

        visualLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            visualContent.CanvasSize = UDim2.new(0, 0, 0, visualLayout.AbsoluteContentSize.Y + 20)
        end)
        task.wait(0.1)
        visualContent.CanvasSize = UDim2.new(0, 0, 0, visualLayout.AbsoluteContentSize.Y + 20)

        function updateContent()
            stealContent.Visible = (selectedTab == "Steal")
            playerContent.Visible = (selectedTab == "Player")
            espContent.Visible = (selectedTab == "Esp")
            miscContent.Visible = (selectedTab == "Misc")
            visualContent.Visible = (selectedTab == "Visual")
        end

        local expanded = true
        collapseBtn.MouseButton1Click:Connect(function()
            expanded = not expanded
            if expanded then
                TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    Size = savedMainSize,
                    Position = savedMainPos
                }):Play()
                title.Size = UDim2.new(1,0,0,40); title.Position = UDim2.new(0,0,0,0); title.TextSize = 22
                contentFrame.Visible = true; tabContainer.Visible = true
                collapseBtn.Text = "◀"
                mainResizeBtn.Visible = true
                title.Text = "RARA HUB"
            else
                savedMainSize = mainFrame.Size
                savedMainPos = mainFrame.Position
                TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(0,160,0,40),
                    Position = UDim2.new(0.5,-80,0.5,-20)
                }):Play()
                title.Size = UDim2.new(1,-50,0,40); title.Position = UDim2.new(0,5,0,0); title.TextSize = 16
                contentFrame.Visible = false; tabContainer.Visible = false
                collapseBtn.Text = "▶"
                mainResizeBtn.Visible = false
                title.Text = "☰"
            end
        end)

        -- BOUTONS MOBILES
        local function createMobileButtons()
            local mobileGui = Instance.new("ScreenGui")
            mobileGui.Name = "MobileShortcuts"
            mobileGui.ResetOnSpawn = false
            mobileGui.Parent = player:WaitForChild("PlayerGui")
            mobileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

            local function createFloatingButton(text, color, callback, defaultPos, btnName, key)
                local btn = Instance.new("TextButton", mobileGui)
                btn.Name = btnName or "MobileBtn"
                btn.Size = UDim2.new(0, 60, 0, 60)
                btn.Position = defaultPos or UDim2.new(0, 10, 0, 10)
                btn.BackgroundColor3 = color
                btn.Text = text
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 10
                btn.TextWrapped = true
                btn.ClipsDescendants = true
                btn.ZIndex = 10
                btn.AutoButtonColor = false
                local state = mobileBtnStates[key or btnName:gsub("Btn$", ""):lower()]
                if state == nil then state = true end
                btn.Visible = UI.showMobileButtons and state
                btn.Active = not mobileButtonsLocked
                btn.Draggable = not mobileButtonsLocked
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

                local shadow = Instance.new("ImageLabel", btn)
                shadow.Size = UDim2.new(1.2, 0, 1.2, 0)
                shadow.Position = UDim2.new(-0.1, 0, -0.1, 0)
                shadow.BackgroundTransparency = 1
                shadow.Image = "rbxassetid://13160460753"
                shadow.ImageTransparency = 0.5
                shadow.ZIndex = 0

                local stroke = Instance.new("UIStroke", btn)
                stroke.Color = Color3.fromRGB(255, 255, 255)
                stroke.Thickness = 1.5
                stroke.Transparency = 0.5

                if savedMobileBtnPositions and savedMobileBtnPositions[btnName or "MobileBtn"] then
                    local pos = savedMobileBtnPositions[btnName or "MobileBtn"]
                    btn.Position = UDim2.new(pos.X.Scale or 0, pos.X.Offset or 0, pos.Y.Scale or 0, pos.Y.Offset or 0)
                end

                local dragging = false
                local dragStart, dragStartPos

                btn.InputBegan:Connect(function(input)
                    if mobileButtonsLocked then return end
                    if mainGuiFrame and mainGuiFrame.AbsoluteSize then
                        local mousePos = input.Position
                        local guiPos = mainGuiFrame.AbsolutePosition
                        local guiSize = mainGuiFrame.AbsoluteSize
                        if mousePos.X >= guiPos.X and mousePos.X <= guiPos.X + guiSize.X and
                           mousePos.Y >= guiPos.Y and mousePos.Y <= guiPos.Y + guiSize.Y then
                            return
                        end
                    end
                    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        dragStart = input.Position
                        dragStartPos = btn.Position
                        btn.ZIndex = 20
                    end
                end)

                btn.InputChanged:Connect(function(input)
                    if mobileButtonsLocked then return end
                    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
                        if mainGuiFrame and mainGuiFrame.AbsoluteSize then
                            local mousePos = input.Position
                            local guiPos = mainGuiFrame.AbsolutePosition
                            local guiSize = mainGuiFrame.AbsoluteSize
                            if mousePos.X >= guiPos.X and mousePos.X <= guiPos.X + guiSize.X and
                               mousePos.Y >= guiPos.Y and mousePos.Y <= guiPos.Y + guiSize.Y then
                                return
                            end
                        end
                        local delta = input.Position - dragStart
                        btn.Position = UDim2.new(
                            dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
                            dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
                        )
                    end
                end)

                btn.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                        btn.ZIndex = 10
                    end
                end)

                btn.MouseButton1Click:Connect(callback)
                btn.TouchTap:Connect(callback)

                btn.MouseEnter:Connect(function()
                    TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0, 65, 0, 65)}):Play()
                end)
                btn.MouseLeave:Connect(function()
                    TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0, 60, 0, 60)}):Play()
                end)

                table.insert(mobileButtons, btn)
                return btn
            end

            local spacing = 72
            local baseX = 10
            local baseY = 250

            local viewport = workspace.CurrentCamera.ViewportSize
            if viewport and viewport.Y > 0 then
                baseY = viewport.Y - 200
            end

            local resetBtn = createFloatingButton("RESET", Color3.fromRGB(50, 150, 255), function()
                if UI.resetEnabled then
                    doReset()
                    TweenService:Create(resetBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(80, 255, 80)}):Play()
                    task.delay(0.3, function()
                        TweenService:Create(resetBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 150, 255)}):Play()
                    end)
                end
            end, UDim2.new(0, baseX, 0, baseY), "ResetBtn", "reset")

            local tpDownBtn = createFloatingButton("TP\nDOWN", Color3.fromRGB(200, 100, 0), function()
                if UI.tpDownEnabled then
                    doTpDown()
                    TweenService:Create(tpDownBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(80, 255, 80)}):Play()
                    task.delay(0.3, function()
                        TweenService:Create(tpDownBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 100, 0)}):Play()
                    end)
                end
            end, UDim2.new(0, baseX + spacing * 1, 0, baseY), "TpDownBtn", "tpDown")

            local dropBtn = createFloatingButton("DROP", Color3.fromRGB(200, 50, 50), function()
                if UI.dropBrainrotEnabled then
                    runDropBrainrot()
                    TweenService:Create(dropBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(80, 255, 80)}):Play()
                    task.delay(0.3, function()
                        TweenService:Create(dropBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
                    end)
                end
            end, UDim2.new(0, baseX + spacing * 2, 0, baseY), "DropBtn", "drop")

            local tpBestBtn = createFloatingButton("TP\nBEST", Color3.fromRGB(100, 30, 200), function()
                teleportToBest()
                TweenService:Create(tpBestBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(80, 255, 80)}):Play()
                task.delay(0.3, function()
                    TweenService:Create(tpBestBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(100, 30, 200)}):Play()
                end)
            end, UDim2.new(0, baseX + spacing * 3, 0, baseY), "TpBestBtn", "tpBest")

            local destroyBtn = createFloatingButton("DESTROY\nV2", Color3.fromRGB(150, 0, 150), function()
                toggleAutoDestroyV2()
            end, UDim2.new(0, baseX + spacing * 4, 0, baseY), "DestroyBtn", "destroy")

            if UserInputService.TouchEnabled then
                resetBtn.Size = UDim2.new(0, 70, 0, 70)
                tpDownBtn.Size = UDim2.new(0, 70, 0, 70)
                dropBtn.Size = UDim2.new(0, 70, 0, 70)
                tpBestBtn.Size = UDim2.new(0, 70, 0, 70)
                destroyBtn.Size = UDim2.new(0, 70, 0, 70)
                resetBtn.TextSize = 12
                tpDownBtn.TextSize = 12
                dropBtn.TextSize = 12
                tpBestBtn.TextSize = 12
                destroyBtn.TextSize = 12
            end

            if autoDestroyV2Enabled then
                TweenService:Create(destroyBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 200, 50)}):Play()
            else
                TweenService:Create(destroyBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(150, 0, 150)}):Play()
            end
        end

        createMobileButtons()
    end

    -- ============================================================
    --  LANCEMENT
    -- ============================================================
    buildUI()

    if Config.AutoSteal then
        floatBar.container.Visible = true
        startAutoSteal()
    else
        floatBar.container.Visible = false
    end

    if UI.antiDeathEnabled then startAntiDeath() end
    if UI.AntiRagdollEnabled then startAntiRagdoll() end

    setInfinityJump(UI.InfJumpEnabled)
    initializeAimbot()

    if espEnabled then
        startLiniaESP()
    else
        stopLiniaESP()
    end

    AntiBeeModule.set(UI.antiBeeEnabled)

    if UI.carpetBoostEnabled then
        updateCarpetStatus()
        enableCarpetBoost()
    end

    if autoSentryEnabled then
        toggleAutoSentry(true)
    end
    if autoDestroyV2Enabled then
        startDestroyV2Loop()
    end

    if tp2Enabled then
        if not tp2Gui or not tp2Gui.Parent then
            tp2Gui = createTp2UI()
        else
            tp2Gui.Visible = true
        end
    end

    refreshAllUI()

    -- Démarrer l'auto-save si activé
    if autoSaveEnabled then
        startAutoSave()
    end

    -- ============================================================
    --  KEYBINDS
    -- ============================================================
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

        local key = input.KeyCode

        if key == resetKeybind and UI.resetEnabled then
            doReset()
            return
        end

        if key == tpDownKeybind and UI.tpDownEnabled then
            doTpDown()
            return
        end

        if key == carpetKeybind then
            local focused = false
            for _, obj in pairs(player.PlayerGui:GetDescendants()) do
                if obj:IsA("TextBox") and obj:IsFocused() then
                    focused = true
                    break
                end
            end
            if not focused then
                toggleCarpetBoost()
            end
            return
        end

        if key == tpKeybind or key == Enum.KeyCode.X then
            teleportToBest()
            return
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if resetAwaitingKeybind then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local newKey = input.KeyCode
                if newKey ~= Enum.KeyCode.Unknown then
                    resetKeybind = newKey
                    if UI.ResetKeybindBtn then
                        UI.ResetKeybindBtn.Text = resetKeybind.Name
                        UI.ResetKeybindBtn.BackgroundColor3 = Color3.fromRGB(50,150,255)
                    end
                end
                resetAwaitingKeybind = false
            end
            return
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if tpDownAwaitingKeybind then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local newKey = input.KeyCode
                if newKey ~= Enum.KeyCode.Unknown then
                    tpDownKeybind = newKey
                    if UI.TpDownKeybindBtn then
                        UI.TpDownKeybindBtn.Text = tpDownKeybind.Name
                        UI.TpDownKeybindBtn.BackgroundColor3 = Color3.fromRGB(200,100,0)
                    end
                end
                tpDownAwaitingKeybind = false
            end
            return
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if carpetAwaitingKeybind then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local newKey = input.KeyCode
                if newKey ~= Enum.KeyCode.Unknown then
                    carpetKeybind = newKey
                    if UI.CarpetKeybindBtn then
                        UI.CarpetKeybindBtn.Text = carpetKeybind.Name
                        UI.CarpetKeybindBtn.BackgroundColor3 = Color3.fromRGB(0,80,160)
                    end
                    setSetting("carpetKeybind", carpetKeybind.Name)
                end
                carpetAwaitingKeybind = false
            end
            return
        end
    end)

    -- Sauvegarde automatique quand le joueur quitte
    game:BindToClose(function()
        if autoSaveEnabled then
            pcall(saveAllConfigs)
        end
    end)

    print("RARA HUB chargé - Instant Reset + Auto Save intégrés.")
    print("Keybinds: R=Reset | E=TP Down | M=Carpet Boost | X=TP Best")
    print("Cliquez sur un bouton Key: dans le GUI pour changer le keybind")
    print("✅ Bouton 'Save Configs' sauvegarde manuellement.")
    print("✅ Auto Save Config sauvegarde automatiquement toutes les X secondes.")
end
