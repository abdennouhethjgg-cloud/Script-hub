local playersService, Stats, RunService, TweenService, UserInputService, CoreGui, Lighting, TeleportService, workspaceService
local localPlayer, playerGui, attachGui, generateRandomGuiName, appState, findAdminCommandButton, cloneAdminButtonIcon, executeAdminCommand, executeAllAdminCommands, optimizeInstance
local applyPerformanceSettings, settings, saveSettings, restorePanelPosition, savePanelPosition, semiTeleportSettings, selectedSlot, baseLocations, stopAutoWalk, isEnemyBase
local semiTeleportState, runSemiTeleport, enableBalloonMonitor, disableBalloonMonitor, enableAntiTurret, disableAntiTurret, enableGameStretcher, disableGameStretcher, unlockBaseFloor, logoAsset
local mainGui, addGradientStroke, createUICorner, makeDraggable, hudWidth, hudHeight, controlButtonSize, controlButtonSpacing, layoutMargin, hudTopOffset
local hudFrame
local getCharacterRootPart, getNearestEnemyPlayer, isMobile
        local applyReplicationFlags, findFlightTool, targetPlayer, getBaseOwner, runStealBoosts, beginPromptHold, waitForPromptDelay, finishPromptHold, startAutoWalk, teleportRoutes
            local HttpService
            if not game:IsLoaded() then
                game.Loaded:Wait()
            end
            if setfpscap then
                setfpscap(9999)
            end
            playersService = game:GetService("Players")
            Stats = game:GetService("Stats")
            RunService = game:GetService("RunService")
            TweenService = game:GetService("TweenService")
            UserInputService = game:GetService("UserInputService")
            HttpService = game:GetService("HttpService")
            CoreGui = game:GetService("CoreGui")
            Lighting = game:GetService("Lighting")
            TeleportService = game:GetService("TeleportService")
            workspaceService = game:GetService("Workspace")
            localPlayer = playersService.LocalPlayer
            playerGui = localPlayer:WaitForChild("PlayerGui")
            math.randomseed(os.time() + tick() * 1000)
            getCharacterRootPart = function()
                local character = localPlayer.Character
                return character and character:FindFirstChild("HumanoidRootPart")
            end
            getNearestEnemyPlayer = function()
                local rootPart = getCharacterRootPart()
                if not rootPart then
                    return nil
                end
                local nearestPlayer = nil
                local nearestDistance = math.huge
                for _, player in ipairs(playersService:GetPlayers()) do
                    if player ~= localPlayer and player.Character then
                        local targetRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if targetRootPart and humanoid and humanoid.Health > 0 then
                            local distance = (targetRootPart.Position - rootPart.Position).Magnitude
                            if distance < nearestDistance then
                                nearestDistance = distance
                                nearestPlayer = player
                            end
                        end
                    end
                end
                return nearestPlayer
            end
                local function generateRandomIdentifier()
                    local randomCharacters = {}
                    for i = 1, 12 + math.random(0, 8) do
                        randomCharacters[i] = ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"):sub(
                            math.random(1, 62),
                            math.random(1, 62)
                    end
                    return table.concat(randomCharacters)
                end
                attachGui = function(gui)
                    local coreGui = game:GetService("CoreGui")
                    local fallbackPlayerGui = playersService.LocalPlayer:WaitForChild("PlayerGui")
                    for _, getterName in ipairs({
                    }) do
                        local hiddenGuiGetter = rawget(_G, getterName)
                        if type(hiddenGuiGetter) == "function" then
                            local ok, parent = pcall(hiddenGuiGetter)
                            if ok and typeof(parent) == "Instance" then
                                    pcall(function()
                                        gui.Parent = parent
                                    end) and gui.Parent == parent
                                then
                                    return true
                                end
                            end
                        end
                    end
                    local synApi = rawget(_G, "syn")
                    if synApi and type(synApi.protect_gui) == "function" then
                        if pcall(synApi.protect_gui, gui) then
                            pcall(function()
                                gui.Parent = coreGui
                            end)
                            if gui.Parent then
                                return true
                            end
                        end
                    end
                    for _, item87 in ipairs({
                    }) do
                        local rawgetResult88 = rawget(_G, item87)
                        if type(rawgetResult88) == "function" then
                            pcall(rawgetResult88, gui)
                        end
                    end
                    pcall(function()
                        gui.Parent = coreGui
                    end)
                    if not gui.Parent then
                        pcall(function()
                            gui.Parent = fallbackPlayerGui
                        end)
                    end
                    return gui.Parent ~= nil
                end
                generateRandomGuiName = generateRandomIdentifier
            end
            pcall(function()
                if getgenv().IceHubLoaded then
                    return
                end
                getgenv().IceHubLoaded = true
            end)
            appState = {
                adminRemote = nil,
                lastFired = {},
                defMode = "None",
                defLastPunish = {},
                defStealCounts = {},
                Connections = {},
                enemyPlots = {},
                stealCbCache = {},
                stealActive = false,
                stealBusy = false,
                lastTpTime = 0,
                allGradients = {},
                isMobile = false,
                redPos = nil,
                greenPos = nil,
                redDot = nil,
                greenDot = nil,
                guideLine = nil,
                sentryEnabled = false,
                sentryConn = nil,
                gameStretcherEnabled = false,
                gameStretcherConn = nil,
                AutoResetBalloonEnabled = false,
                balloonGuiConnections = {},
                balloonChildAddedConn = nil,
                menuOpen = false,
                screenGui = nil,
                statsLabel = nil,
                panel = nil,
                topButtons = {},
                tabButtons = {},
                tabContents = {},
                PANEL_W = 560,
                PANEL_H = 470,
                HUD_WIDTH = 310,
                HUD_HEIGHT = 74,
                COL_DARK = Color3.fromRGB(7, 13, 27),
                COL_WHITE = Color3.fromRGB(235, 245, 255),
                COL_DIM = Color3.fromRGB(105, 195, 255),
                local accentKeys = {}
                local colorKeypoint93 = ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 145, 255))
                local colorKeypoint94 = ColorSequenceKeypoint.new(0.2, Color3.fromRGB(115, 205, 255))
                local colorKeypoint95 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(235, 248, 255))
                local colorKeypoint96 = ColorSequenceKeypoint.new(0.6, Color3.fromRGB(90, 170, 255))
                local colorKeypoint97 = ColorSequenceKeypoint.new(0.8, Color3.fromRGB(45, 230, 255))
                accentKeys[1] = colorKeypoint93
                accentKeys[2] = colorKeypoint94
                accentKeys[3] = colorKeypoint95
                accentKeys[4] = colorKeypoint96
                accentKeys[5] = colorKeypoint97
                accentKeys[6] = ColorSequenceKeypoint.new(1, Color3.fromRGB(105, 190, 255))
                appState.ACCENT_KEYS = accentKeys
            end
                local bgKeys = {}
                local colorKeypoint100 = ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 10, 22))
                local colorKeypoint101 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 17, 34))
                bgKeys[1] = colorKeypoint100
                bgKeys[2] = colorKeypoint101
                bgKeys[3] = ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 16, 36))
                appState.BG_KEYS = bgKeys
            end
            appState.epFrame = nil
            appState.epContent = nil
            appState.openExecutePanel = nil
            appState.closeExecutePanel = nil
            appState.xpFrame = nil
            appState.xpContent = nil
            appState.openXrayPanel = nil
            appState.closeXrayPanel = nil
            appState.bpFrame = nil
            appState.bpContent = nil
            appState.openBoosterPanel = nil
            appState.closeBoosterPanel = nil
            appState.spFrame = nil
            appState.spContent = nil
            appState.openServerPanel = nil
            appState.closeServerPanel = nil
            appState.defFrame = nil
            appState.defContent = nil
            appState.openDefenderPanel = nil
            appState.closeDefenderPanel = nil
            appState.apFrame = nil
            appState.apContent = nil
            appState.openAPPanel = nil
            appState.closeAPPanel = nil
            appState.espFrame = nil
            appState.espContent = nil
            appState.openESPPanel = nil
            appState.closeESPPanel = nil
            appState.stretchFrame = nil
            appState.stretchContent = nil
            appState.openStretchPanel = nil
            appState.closeStretchPanel = nil
            appState.balloonFrame = nil
            appState.balloonContent = nil
            appState.openBalloonPanel = nil
            appState.closeBalloonPanel = nil
            appState.turretFrame = nil
            appState.turretContent = nil
            appState.openTurretPanel = nil
            appState.closeTurretPanel = nil
            appState.btFrame = nil
            appState.btContent = nil
            appState.openBTPanel = nil
            appState.closeBTPanel = nil
                local adminCommandBusy = false
                local function getAdminPanel()
                    local adminPanel = playerGui:FindFirstChild("AdminPanel")
                    if not adminPanel then
                        return nil
                    end
                    local adminPanel2 = adminPanel:FindFirstChild("AdminPanel")
                    if not adminPanel2 then
                        return nil
                    end
                    local profiles = adminPanel2:FindFirstChild("Profiles")
                    profiles = profiles and profiles:FindFirstChild("ScrollingFrame")
                    local scrollingFrame = adminPanel2:FindFirstChild("Commands")
                    scrollingFrame = scrollingFrame and scrollingFrame:FindFirstChild("ScrollingFrame")
                    if not profiles or not scrollingFrame then
                        return nil
                    end
                    return {
                        Gui = adminPanel,
                        Panel = adminPanel2,
                        Profiles = profiles,
                        Commands = scrollingFrame,
                end
                local function activateGuiButton(guiButton)
                    if not guiButton or not guiButton:IsA("GuiButton") then
                        return false
                    end
                    if type(firesignal) == "function" then
                            pcall(function()
                                firesignal(guiButton.Activated)
                            end)
                        then
                            return true
                        end
                            pcall(function()
                                firesignal(guiButton.MouseButton1Click)
                            end)
                        then
                            return true
                        end
                    end
                    if type(getconnections) == "function" then
                        for _, item114 in ipairs({
                            guiButton.Activated,
                        }) do
                            local ok, result = pcall(getconnections, item114)
                            if ok and type(result) == "table" then
                                for _, functionState118 in ipairs(result) do
                                    if type(functionState118.Function) == "function" then
                                        if pcall(functionState118.Function) then
                                            return true
                                        end
                                    end
                                    if functionState118.Fire then
                                            pcall(function()
                                                functionState118:Fire()
                                            end)
                                        then
                                            return true
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return false
                end
                findAdminCommandButton = function(commandName)
                    local getAdminPanelResult120 = getAdminPanel()
                    if not getAdminPanelResult120 then
                        return nil
                    end
                    local findFirstChildResult121 = getAdminPanelResult120.Commands:FindFirstChild(commandName)
                    if findFirstChildResult121 and findFirstChildResult121:IsA("GuiButton") then
                        return findFirstChildResult121
                    end
                    local lowerResult123 = tostring(commandName):lower()
                    for _, child in ipairs(getAdminPanelResult120.Commands:GetChildren()) do
                        if child:IsA("GuiButton") and child.Name ~= "Template" then
                            if child.Name:lower() == lowerResult123 then
                                return child
                            end
                            local command = child:FindFirstChild("Command")
                            if command and command:IsA("TextLabel") then
                                if tostring(command.Text):lower():gsub("^;", ""):gsub("%s+", "") == lowerResult123 then
                                    return child
                                end
                            end
                        end
                    end
                    return nil
                end
                cloneAdminButtonIcon = function(instance127, parent)
                    if not instance127 or not parent then
                        return false
                    end
                    local imageLabel = instance127:FindFirstChildWhichIsA("ImageLabel", true)
                        or instance127:FindFirstChildWhichIsA("ImageButton", true)
                    if not imageLabel then
                        return false
                    end
                    local clone = imageLabel:Clone()
                    clone.Name = "NativeIcon"
                    clone.AnchorPoint = Vector2.new(0.5, 0.5)
                    clone.Position = UDim2.fromScale(0.5, 0.5)
                    clone.Size = UDim2.new(1, -8, 1, -8)
                    clone.BackgroundTransparency = 1
                    clone.ZIndex = parent.ZIndex + 1
                    if clone:IsA("ImageButton") then
                        clone.AutoButtonColor = false
                        clone.Active = false
                    end
                    clone.Parent = parent
                    return true
                end
                local function findPlayerAdminButton(instance134)
                    if not instance134 then
                        return nil
                    end
                    local getAdminPanelResult135 = getAdminPanel()
                    if not getAdminPanelResult135 then
                        return nil
                    end
                    local findFirstChildResult136 = getAdminPanelResult135.Profiles:FindFirstChild(instance134.Name)
                    if findFirstChildResult136 and findFirstChildResult136:IsA("GuiButton") then
                        return findFirstChildResult136
                    end
                    for _, child in ipairs(getAdminPanelResult135.Profiles:GetChildren()) do
                        if child:IsA("GuiButton") and child.Name ~= "Template" then
                            if child.Name == instance134.Name then
                                return child
                            end
                            local playerName = child:FindFirstChild("playerName")
                            if playerName and playerName:IsA("TextLabel") and playerName.Text == instance134.Name then
                                return child
                            end
                        end
                    end
                    return nil
                end
                executeAdminCommand = function(instance140, index141)
                    if not instance140 or instance140.Parent ~= playersService then
                        return false
                    end
                    local calculatedValue142 = os.clock() + 1.5
                    while adminCommandBusy and os.clock() < calculatedValue142 do
                        task.wait()
                    end
                    if adminCommandBusy then
                        return false
                    end
                    adminCommandBusy = true
                    local commandExecuted = false
                    local ok = pcall(function()
                        local findAdminCommandButtonResult145 = findAdminCommandButton(index141)
                        local findPlayerAdminButtonResult146 = findPlayerAdminButton(instance140)
                        if not findAdminCommandButtonResult145 or not findPlayerAdminButtonResult146 then
                            return
                        end
                        if not activateGuiButton(findAdminCommandButtonResult145) then
                            return
                        end
                        task.wait(0.01)
                        if not activateGuiButton(findPlayerAdminButtonResult146) then
                            return
                        end
                        commandExecuted = true
                        appState.lastFired[index141] = tick()
                    end)
                    adminCommandBusy = false
                    return ok and commandExecuted
                end
            end
                local textOptions148 = {
                executeAllAdminCommands = function(player)
                    if not player then
                        return
                    end
                    for _, item151 in ipairs(textOptions148) do
                        executeAdminCommand(player, item151)
                        task.wait(0.02)
                    end
                end
            end
            optimizeInstance = function(instance152)
                pcall(function()
                    if instance152:IsA("ParticleEmitter") then
                        instance152.Enabled = false
                    elseif instance152:IsA("Decal") then
                        instance152.Transparency = 1
                    elseif instance152:IsA("BasePart") then
                        instance152.Material = Enum.Material.Plastic
                        instance152.Reflectance = 0
                        instance152.CastShadow = false
                    end
                end)
            end
            applyPerformanceSettings = function()
                pcall(function()
                    Lighting.GlobalShadows = false
                    Lighting.FogEnd = 9e9
                    Lighting.Brightness = 1
                    Lighting.EnvironmentDiffuseScale = 0
                    Lighting.EnvironmentSpecularScale = 0
                    for _, child in pairs(Lighting:GetChildren()) do
                        if child:IsA("BlurEffect") or child:IsA("BloomEffect") or child:IsA("SunRaysEffect") then
                            child.Enabled = false
                        end
                    end
                end)
            end
                local text157 = "Unknown"
                local isActive158 = false
                pcall(function()
                    if identifyexecutor then
                        text157 = 
                            isActive158 = true
                        end
                    end
                end)
                local lowerResult160 = text157:lower()
                    appState.isMobile = true
                elseif UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
                    appState.isMobile = true
                end
                if appState.isMobile then
                    if isActive158 then
                        appState.HUD_WIDTH = 390
                        appState.HUD_HEIGHT = 85
                        appState.PANEL_W = 480
                        appState.PANEL_H = 360
                    else
                        appState.HUD_WIDTH = 350
                        appState.HUD_HEIGHT = 90
                        appState.PANEL_W = 480
                        appState.PANEL_H = 390
                    end
                end
            end
            isMobile = appState.isMobile
            settings = {
                guiPositions = {
                    main = {
                        x = 0.5,
                        xOffset = 0,
                        y = 0.5,
                        yOffset = 0,
                    hud = {
                        x = 0.5,
                        xOffset = 0,
                        y = 0,
                        yOffset = 80,
                    semiTp = {
                        x = 0.02,
                        xOffset = 0,
                        y = 0.5,
                        yOffset = 0,
                    instaReset = {
                        x = 0.5,
                        xOffset = 0,
                        y = 0.5,
                        yOffset = 120,
                    autoDefense = {
                        x = 0.5,
                        xOffset = -230,
                        y = 0,
                        yOffset = 60,
                    friendPanel = {
                        x = 0.02,
                        xOffset = 270,
                        y = 0.5,
                        yOffset = -66,
                panels = {
                    semitp = {
                        x = 0.5,
                        xOffset = -100,
                        y = 0.5,
                        yOffset = -190,
                        visible = true,
                    xray = {
                        x = 0,
                        xOffset = 20,
                        y = 0.5,
                        yOffset = -60,
                        visible = true,
                    booster = {
                        x = 1,
                        xOffset = -225,
                        y = 0.5,
                        yOffset = -117,
                        visible = true,
                    server = {
                        x = 1,
                        xOffset = -220,
                        y = 0.5,
                        yOffset = 128,
                        visible = true,
                    defender = {
                        x = 1,
                        xOffset = -420,
                        y = 0.5,
                        yOffset = -60,
                        visible = true,
                    ap = {
                        x = 1,
                        xOffset = -420,
                        y = 0.5,
                        yOffset = 100,
                        visible = true,
                    esp = {
                        x = 1,
                        xOffset = -620,
                        y = 0.5,
                        yOffset = -60,
                        visible = true,
                    stretch = {
                        x = 1,
                        xOffset = -620,
                        y = 0.5,
                        yOffset = 100,
                        visible = true,
                    balloon = {
                        x = 0.5,
                        xOffset = 250,
                        y = 0.5,
                        yOffset = -60,
                        visible = true,
                    turret = {
                        x = 0.5,
                        xOffset = 250,
                        y = 0.5,
                        yOffset = 60,
                        visible = true,
                    baseTimer = {
                        x = 0.5,
                        xOffset = 450,
                        y = 0.5,
                        yOffset = -60,
                        visible = true,
                toggles = {
                    antiRagdoll = true,
                    unlockBase = true,
                    customFOV = true,
                    boosterPanel = true,
                    serverPanel = true,
                    xrayPanel = true,
                    defenderPanel = true,
                    apPanel = true,
                    espPanel = true,
                    stretchPanel = true,
                    balloonPanel = true,
                    turretPanel = true,
                    baseTimerPanel = true,
                    semiTpPanel = true,
                    showRejoinGui = true,
                    walkSpeed = false,
                    antiLag = false,
                    fpsBooster = false,
                    noParticles = false,
                    antiBee = false,
                    friendBaseESP = true,
                    gameStretcher = false,
                    autoResetBalloon = false,
                    antiTurret = false,
                    playerESP = false,
                    trapESP = false,
                    brainrotESP = false,
                    bestBrainrotESP = false,
                    lineESP = false,
                    playerChams = false,
                    selfChams = false,
                    brainrotChams = false,
                    trapMineChams = false,
                    defenderKick = false,
                    defenderNoKick = false,
                    intruderAlarm = false,
                    autoLeave = false,
                    baseTimerESP = false,
                autoLeaveCooldown = 2,
                ui = {
                    activeTab = "Stealer",
                    menuOpen = false,
                autoDefense = {
                    enabled = false,
                    balloon = true,
                    laser = false,
                    settingsOpen = false,
                semitp = {
                    autoPotion = true,
                    autoWalk = false,
                    speedBoost = false,
                    autoAdminSpam = false,
                    autoRetrySteal = false,
                    autoSemiOnTimer = false,
                    autoSemiOnFriends = false,
                    semiInstantMode = "Instant",
                    stealMethod = "Walk",
                    stealKey = "E",
                    selectedSlot = 1,
                    walkSpeed = 26,
                    speedBoostStealingSpeed = 26,
                    speedBoostGiantSpeed = 32,
                    tpCooldown = 0.8,
                local callback161 = nil
                callback161 = function(targetTable, sourceTable)
                    for k, item165 in pairs(sourceTable) do
                        local calculatedValue166 = type(item165) == "table"
                        local calculatedValue167
                        if calculatedValue166 then
                            calculatedValue167 = type(targetTable[k]) == "table"
                        else
                            calculatedValue167 = calculatedValue166
                        end
                        if calculatedValue167 then
                            callback161(targetTable[k], item165)
                        else
                            targetTable[k] = item165
                        end
                    end
                end
                saveSettings = function()
                    if writefile then
                        pcall(function()
                            writefile("IceHub_Settings.json", HttpService:JSONEncode(settings))
                        end)
                    end
                end
                local function loadData170()
                    if readfile and isfile then
                        pcall(function()
                            if isfile("IceHub_Settings.json") then
                                local data = HttpService:JSONDecode(readfile("IceHub_Settings.json"))
                                if type(data) == "table" then
                                    callback161(settings, data)
                                end
                            end
                        end)
                    end
                end
                loadData170()
            end
            settings.ui = settings.ui
                or {
                    activeTab = "Stealer",
                    menuOpen = false,
            settings.ui.activeTab = tostring(settings.ui.activeTab or "Stealer")
            settings.ui.menuOpen = settings.ui.menuOpen == true
            settings.autoDefense = settings.autoDefense
                or {
                    enabled = false,
                    balloon = true,
                    laser = false,
                    settingsOpen = false,
            if settings.autoDefense.balloon == nil then
                settings.autoDefense.balloon = true
            end
            appState.menuOpen = settings.ui.menuOpen
            restorePanelPosition = function(guiObject, panelId, position)
                if not guiObject then
                    return
                end
                local guiPositions = settings.guiPositions and settings.guiPositions[panelId]
                if guiPositions and type(guiPositions) == "table" then
                    guiObject.Position = UDim2.new(
                        tonumber(guiPositions.x) or position.X.Scale,
                        tonumber(guiPositions.xOffset) or position.X.Offset,
                        tonumber(guiPositions.y) or position.Y.Scale,
                        tonumber(guiPositions.yOffset) or position.Y.Offset
                else
                    guiObject.Position = position
                end
            end
            savePanelPosition = function(guiObject, panelId)
                if not guiObject or not panelId then
                    return
                end
                settings.guiPositions = settings.guiPositions or {}
                settings.guiPositions[panelId] = {
                    x = guiObject.Position.X.Scale,
                    xOffset = guiObject.Position.X.Offset,
                    y = guiObject.Position.Y.Scale,
                    yOffset = guiObject.Position.Y.Offset,
                saveSettings()
            end
            settings.semitp.speedBoostStealingSpeed = 26
            settings.semitp.walkSpeed = 26
            appState.sentryEnabled = settings.toggles.antiTurret or false
            appState.gameStretcherEnabled = settings.toggles.gameStretcher or false
            appState.AutoResetBalloonEnabled = settings.toggles.autoResetBalloon or false
            applyReplicationFlags = function()
                pcall(function()
                    if not setfflag then
                        return
                    end
                    for k, item183 in pairs({
                        GameNetPVHeaderRotationalVelocityZeroCutoffExponent = "-5000",
                        LargeReplicatorWrite5 = "true",
                        LargeReplicatorEnabled9 = "true",
                        AngularVelocityLimit = "360",
                        TimestepArbiterVelocityCriteriaThresholdTwoDt = "2147483646",
                        S2PhysicsSenderRate = "15000",
                        DisableDPIScale = "true",
                        MaxDataPacketPerSend = "2147483647",
                        PhysicsSenderMaxBandwidthBps = "20000",
                        TimestepArbiterHumanoidLinearVelThreshold = "21",
                        MaxMissedWorldStepsRemembered = "-2147483648",
                        PlayerHumanoidPropertyUpdateRestrict = "true",
                        SimDefaultHumanoidTimestepMultiplier = "0",
                        StreamJobNOUVolumeLengthCap = "2147483647",
                        DebugSendDistInSteps = "-2147483648",
                        GameNetDontSendRedundantNumTimes = "1",
                        InterpolationFrameRotVelocityThresholdMillionth = "5",
                        LargeReplicatorSerializeRead3 = "true",
                        ReplicationFocusNouExtentsSizeCutoffForPauseStuds = "-1",
                        WorldStepMax = "30",
                        CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth = "1",
                        InterpolationFrameVelocityThresholdMillionth = "5",
                        StreamJobNOUVolumeCap = "2147483647",
                        CheckPVCachedRotVelThresholdPercent = "10",
                        CheckPVCachedVelThresholdPercent = "10",
                        NextGenReplicatorEnabledWrite4 = "true",
                        InterpolationFramePositionThresholdMillionth = "1",
                        TimestepArbiterHumanoidTurningVelThreshold = "1",
                        CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth = "1",
                        GameNetPVHeaderLinearVelocityZeroCutoffExponent = "-5000",
                        SimOwnedNOUCountThresholdMillionth = "-1",
                        TimestepArbiterOmegaThou = "1073741823",
                        MaxAcceptableUpdateDelay = "1",
                        LargeReplicatorSerializeWrite4 = "true",
                    }) do
                        pcall(function()
                            setfflag(k, item183)
                        end)
                    end
                end)
            end
            applyReplicationFlags()
            localPlayer.CharacterAdded:Connect(function()
                task.wait(0.05)
                applyReplicationFlags()
            end)
            semiTeleportSettings = settings.semitp
            semiTeleportSettings.selectedSlot = tonumber(semiTeleportSettings.selectedSlot) or 1
            if semiTeleportSettings.selectedSlot ~= 1 and semiTeleportSettings.selectedSlot ~= 2 then
                semiTeleportSettings.selectedSlot = 1
            end
            selectedSlot = semiTeleportSettings.selectedSlot
                local textOptions184 = {
                local function findToolByName(container, toolName)
                    if not container then
                        return nil
                    end
                    local findFirstChildResult188 = container:FindFirstChild(toolName)
                    if findFirstChildResult188 and findFirstChildResult188:IsA("Tool") then
                        return findFirstChildResult188
                    end
                    local gsubResult189 = toolName:lower():gsub("[%s'%_%-]", "")
                    for _, child in ipairs(container:GetChildren()) do
                        if child:IsA("Tool") then
                            if child.Name:lower():gsub("[%s'%_%-]", "") == gsubResult189 then
                                return child
                            end
                        end
                    end
                    return nil
                end
                local function activateTool192(toolName)
                    local character = localPlayer.Character
                    if not character then
                        return nil
                    end
                    local foundBackpack195 = localPlayer:FindFirstChild("Backpack")
                    local findToolByNameResult196 = findToolByName(character, toolName)
                    if findToolByNameResult196 then
                        return findToolByNameResult196
                    end
                    local findToolByNameResult197 = findToolByName(foundBackpack195, toolName)
                    if findToolByNameResult197 then
                        local humanoid198 = character:FindFirstChildOfClass("Humanoid")
                        if humanoid198 then
                            humanoid198:EquipTool(findToolByNameResult197)
                        end
                        return findToolByNameResult197
                    end
                    return nil
                end
                findFlightTool = function()
                    for _, item200 in ipairs(textOptions184) do
                        local activateTool192Result201 = activateTool192(item200)
                        if activateTool192Result201 then
                            return activateTool192Result201
                        end
                    end
                    return nil
                end
            end
            targetPlayer = nil
            getBaseOwner = function(instance202)
                if not instance202 then
                    return nil
                end
                local foundPlotSign203 = instance202:FindFirstChild("PlotSign")
                local surfaceGui = foundPlotSign203 and foundPlotSign203:FindFirstChild("SurfaceGui")
                surfaceGui = surfaceGui and surfaceGui:FindFirstChild("Frame")
                local calculatedValue205 = surfaceGui and surfaceGui:FindFirstChild("TextLabel")
                if not calculatedValue205 then
                    return nil
                end
                local gsubResult206 = tostring(calculatedValue205.Text):gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
                if gsubResult206 == "" or gsubResult206 == "Empty Base" then
                    return nil
                end
                for _, player in ipairs(playersService:GetPlayers()) do
                    if player.Name == gsubResult206 or player.DisplayName == gsubResult206 then
                        return player
                    end
                end
                return nil
            end
            runStealBoosts = function()
                if semiTeleportSettings.autoPotion then
                    local character = localPlayer.Character
                    local backpack = localPlayer:FindFirstChild("Backpack")
                    local giantPotion = backpack and backpack:FindFirstChild("Giant Potion")
                        or character and character:FindFirstChild("Giant Potion")
                    if giantPotion and character then
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid:EquipTool(giantPotion)
                        end
                        pcall(function()
                            giantPotion:Activate()
                        end)
                    end
                end
                if semiTeleportSettings.autoAdminSpam then
                    task.spawn(function()
                        local calculatedValue214 = targetPlayer
                                and targetPlayer.Parent == playersService
                                and targetPlayer
                            or getNearestEnemyPlayer()
                        if calculatedValue214 then
                            executeAllAdminCommands(calculatedValue214)
                        end
                    end)
                end
            end
                local promptConnectionCache = setmetatable({}, {
                    __mode = "k",
                local function getPromptCallbacks(index218)
                    if type(getconnections) ~= "function" then
                        return nil
                    end
                    if promptConnectionCache[index218] then
                        return promptConnectionCache[index218]
                    end
                    local lookupTable220 = {
                        hold = {},
                        trigger = {},
                    local ok, result = pcall(getconnections, index218.PromptButtonHoldBegan)
                    if ok and type(result) == "table" then
                        for _, functionState224 in ipairs(result) do
                            if type(functionState224.Function) == "function" then
                                table.insert(lookupTable220.hold, functionState224.Function)
                            end
                        end
                    end
                    local ok2, result2 = pcall(getconnections, index218.Triggered)
                    if ok2 and type(result2) == "table" then
                        for _, functionState228 in ipairs(result2) do
                            if type(functionState228.Function) == "function" then
                                table.insert(lookupTable220.trigger, functionState228.Function)
                            end
                        end
                    end
                    if #lookupTable220.hold == 0 and #lookupTable220.trigger == 0 then
                        return nil
                    end
                    promptConnectionCache[index218] = lookupTable220
                    return lookupTable220
                end
                beginPromptHold = function(instance229)
                    if not instance229 or not instance229.Parent then
                        return nil
                    end
                    local getPromptCallbacksResult230 = getPromptCallbacks(instance229)
                    if getPromptCallbacksResult230 then
                        for _, callback232 in ipairs(getPromptCallbacksResult230.hold) do
                            task.spawn(callback232)
                        end
                        local now2 = tick()
                        return {
                            prompt = instance229,
                            cb = getPromptCallbacksResult230,
                            startedAt = now2,
                            holdBeganAt = now2,
                    end
                    return nil
                end
            end
        end
        waitForPromptDelay = function(promptState, minimumDuration)
            if not promptState then
                return
            end
            local calculatedValue236 = tick() - (promptState.startedAt or tick())
            if calculatedValue236 < minimumDuration then
                task.wait(minimumDuration - calculatedValue236)
            end
        end
        finishPromptHold = function(promptState)
            if not promptState then
                return false
            end
            local calculatedValue238 = tick() - (promptState.holdBeganAt or tick())
            if calculatedValue238 < 1.3 then
                task.wait(1.3 - calculatedValue238)
            end
            task.wait(0.02)
            for _, callback240 in ipairs(promptState.cb.trigger) do
                task.spawn(callback240)
            end
            return true
        end
        baseLocations = {
            b1 = {
                refVec = Vector3.new(-337, -5, 100),
                finalPos = Vector3.new(-337, -5, 103),
            b2 = {
                refVec = Vector3.new(-335, -5, 20),
                finalPos = Vector3.new(-334.8, -5.04, 18.9),
            local waypoints242 = {
                b1 = Vector3.new(-347.88534546, -6.90106964, 115.08060455),
                b2 = Vector3.new(-347.88534546, -6.90106964, 18.9),
            local thread = nil
            local numericValue244 = 0
            stopAutoWalk = function()
                numericValue244 += 1
                if thread then
                    pcall(function()
                        task.cancel(thread)
                    end)
                    thread = nil
                end
                local character = localPlayer.Character
                local calculatedValue246 = character and character:FindFirstChildOfClass("Humanoid")
                if calculatedValue246 then
                    pcall(function()
                        calculatedValue246:Move(Vector3.zero, false)
                    end)
                end
            end
            startAutoWalk = function(useAlternateRoute)
                if not semiTeleportSettings.autoWalk then
                    return
                end
                stopAutoWalk()
                local walkGeneration = numericValue244
                thread = task.spawn(function()
                    local now2 = tick()
                    while true do
                            and walkGeneration == numericValue244
                            and tick() - now2 < 3
                        then
                            if not localPlayer:GetAttribute("Stealing") then
                                task.wait(0.05)
                            end
                        end
                        break
                    end
                    if not semiTeleportSettings.autoWalk or walkGeneration ~= numericValue244 then
                        return
                    end
                    if not localPlayer:GetAttribute("Stealing") then
                        return
                    end
                    local calculatedValue250 = useAlternateRoute and waypoints242.b2 or waypoints242.b1
                    local now3 = tick()
                    local now4 = 0
                    while true do
                            and walkGeneration == numericValue244
                            and tick() - now3 < 20
                        then
                            local character = localPlayer.Character
                            local calculatedValue254 = character and character:FindFirstChildOfClass("Humanoid")
                            character = character and character:FindFirstChild("HumanoidRootPart")
                            if not (not calculatedValue254 or not character or calculatedValue254.Health <= 0) then
                                local vector =
                                    Vector3.new(calculatedValue250.X, character.Position.Y, calculatedValue250.Z)
                                    not (
                                            Vector3.new(
                                                character.Position.Z
                                            ) - vector
                                        ).Magnitude <= 2.5
                                then
                                    if 0.15 <= tick() - now4 then
                                        now4 = tick()
                                        pcall(function()
                                            calculatedValue254:MoveTo(calculatedValue250)
                                        end)
                                    end
                                    if not (not localPlayer:GetAttribute("Stealing") and tick() - now3 > 0.35) then
                                        RunService.Heartbeat:Wait()
                                    end
                                end
                            end
                        end
                        break
                    end
                    local character = localPlayer.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    if humanoid and walkGeneration == numericValue244 then
                        pcall(function()
                            humanoid:Move(Vector3.zero, false)
                        end)
                    end
                    if walkGeneration == numericValue244 then
                        thread = nil
                    end
                end)
            end
        end
        teleportRoutes = {
            podSlots = {
            local waypoints = {}
            local vector = Vector3.new(-352.9148864746094, -6.43, 6.89)
            local vector2 = Vector3.new(-352.9630432128906, -6.43282604217529, 113.64471435546875)
            local numericValue263 = -336
            waypoints[1] = vector
            waypoints[2] = vector2
            waypoints[3] = Vector3.new(numericValue263, -4.37325382232666, 101.64852142333984)
            b1258.waypoints = waypoints
            b1258.greenPos = Vector3.new(-349.43, -6.52218533, 103)
            teleportRoutes.b1 = b1258
        end
            local waypoints = {}
            local vector = Vector3.new(-352.76190185546875, -6.43, 28.59)
            local vector2 = Vector3.new(-352.15, -6.43, 28.59)
            waypoints[1] = vector
            waypoints[2] = vector2
            waypoints[3] = Vector3.new(-323.26, -4.82, 19.17)
            b2265.waypoints = waypoints
            b2265.greenPos = Vector3.new(-352.15, -6.43, 19.17)
            teleportRoutes.b2 = b2265
        end
        local findHumanoid271, createUIGradient
            local function performRaycast273(guiObject274, numericValue275)
                if not guiObject274 or not numericValue275 then
                    return false
                end
                local position = guiObject274.Position
                local filterDescendantsInstances = {
                    localPlayer.Character,
                for i = 1, 12 do
                    local calculatedValue279 = numericValue275 - position
                    if calculatedValue279.Magnitude <= 0.05 then
                        return true
                    end
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                    raycastParams.FilterDescendantsInstances = filterDescendantsInstances
                    raycastParams.IgnoreWater = true
                    local hit = workspaceService:Raycast(position, calculatedValue279, raycastParams)
                    if not hit then
                        return true
                    end
                    local instance = hit.Instance
                    if not instance then
                        return true
                    end
                    if instance:IsA("BasePart") and not instance.CanCollide then
                        table.insert(filterDescendantsInstances, instance)
                        position = hit.Position + calculatedValue279.Unit * 0.1
                    end
                    return (hit.Position - numericValue275).Magnitude <= 3
                end
                return false
            end
            local function moveCharacterToPoint(part285, vector286, calculatedValue287, calculatedValue288)
                if not part285 or not part285.Parent or not vector286 then
                    return
                end
                calculatedValue287 = calculatedValue287 or 120
                calculatedValue288 = calculatedValue288 or 3
                local controls = nil
                pcall(function()
                    controls = require(localPlayer.PlayerScripts:WaitForChild("PlayerModule", 2)):GetControls()
                end)
                if controls then
                    pcall(function()
                        controls:Disable()
                    end)
                end
                local now2 = tick()
                while true do
                    if part285 and part285.Parent then
                        local position = part285.Position
                        local calculatedValue293 = vector286 - Vector3.new(position.X, vector286.Y, position.Z)
                        if not (calculatedValue293.Magnitude <= calculatedValue288 or tick() - now2 > 6) then
                            findFlightTool()
                            local calculatedValue294 = calculatedValue293.Unit * calculatedValue287
                            part285.AssemblyLinearVelocity = Vector3.new(
                                calculatedValue294.Z
                            RunService.Heartbeat:Wait()
                        end
                    end
                    break
                end
                if part285 and part285.Parent then
                    part285.AssemblyLinearVelocity = Vector3.zero
                end
                if controls then
                    pcall(function()
                        controls:Enable()
                    end)
                end
            end
            isEnemyBase = function(instance295)
                if not instance295 or not instance295:IsA("Model") then
                    return false
                end
                local frame2 = instance295:FindFirstChild("PlotSign")
                frame2 = frame2 and frame2:FindFirstChild("SurfaceGui")
                frame2 = frame2 and frame2:FindFirstChild("Frame")
                local calculatedValue297 = frame2 and frame2:FindFirstChild("TextLabel")
                if not calculatedValue297 or calculatedValue297.Text == "Empty Base" then
                    return false
                end
                local gsubResult298 = calculatedValue297.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
                return gsubResult298 ~= localPlayer.Name and gsubResult298 ~= localPlayer.DisplayName
            end
            local function findStealPrompt(guiObject300, collection301)
                local plots = workspaceService:FindFirstChild("Plots")
                if not plots then
                    return nil
                end
                local huge = math.huge
                local dataTable304 = nil
                for _, child in ipairs(plots:GetChildren()) do
                    if isEnemyBase(child) then
                        local foundAnimalPodiums307 = child:FindFirstChild("AnimalPodiums")
                        if foundAnimalPodiums307 then
                            local position = nil
                            pcall(function()
                                position = child.PrimaryPart and child.PrimaryPart.Position or child:GetPivot().Position
                            end)
                            if not position then
                                local basePart = child:FindFirstChildWhichIsA("BasePart", true)
                                if basePart then
                                    position = basePart.Position
                                end
                            end
                            local isActive310 = true
                            if position then
                                isActive310 = (position - baseLocations.b1.refVec).Magnitude
                                    < (position - baseLocations.b2.refVec).Magnitude
                            end
                            for _, item312 in ipairs(collection301) do
                                local findFirstChildResult313 = foundAnimalPodiums307:FindFirstChild(item312)
                                local main = findFirstChildResult313
                                    and findFirstChildResult313:FindFirstChild("Claim")
                                    and findFirstChildResult313.Claim:FindFirstChild("Main")
                                if main then
                                    local magnitude = (guiObject300.Position - main.Position).Magnitude
                                    local spawn_ = findFirstChildResult313:FindFirstChild("Base")
                                        and findFirstChildResult313.Base:FindFirstChild("Spawn")
                                    spawn_ = spawn_ and spawn_:FindFirstChild("PromptAttachment")
                                    spawn_ = spawn_ and spawn_:FindFirstChildWhichIsA("ProximityPrompt")
                                    if spawn_ and magnitude < huge then
                                        dataTable304 = {
                                            plot = child,
                                            podiumName = item312,
                                            position = main.Position,
                                            prompt = spawn_,
                                            isEnemyBase1 = isActive310,
                                        huge = magnitude
                                    end
                                end
                            end
                        end
                    end
                end
                return dataTable304
            end
            semiTeleportState = {
                debounce = false,
                setSlot = function(numericValue317)
                    local selectedSlot2 = tonumber(numericValue317)
                    if selectedSlot2 == 1 or selectedSlot2 == 2 then
                        selectedSlot = selectedSlot2
                        semiTeleportSettings.selectedSlot = selectedSlot2
                        settings.semitp.selectedSlot = selectedSlot2
                        saveSettings()
                    end
                end,
                SSDoTeleport = function()
                    local character = localPlayer.Character
                    local calculatedValue320 = character and character:FindFirstChildOfClass("Humanoid")
                    character = character and character:FindFirstChild("HumanoidRootPart")
                    if not calculatedValue320 or not character then
                        return
                    end
                    applyReplicationFlags()
                    findFlightTool()
                    local findStealPromptResult321 =
                        findStealPrompt(character, selectedSlot == 2 and teleportRoutes.podSlots or {
                    if not findStealPromptResult321 then
                        return
                    end
                    targetPlayer = getBaseOwner(findStealPromptResult321.plot)
                    local isEnemyBase1 = findStealPromptResult321.isEnemyBase1
                    local waypoints, greenPos
                    if selectedSlot == 2 then
                        local calculatedValue325 = isEnemyBase1 and teleportRoutes.b1 or teleportRoutes.b2
                        waypoints = calculatedValue325.waypoints
                        greenPos = calculatedValue325.greenPos
                    else
                        if isEnemyBase1 then
                            waypoints = {}
                            local vector = Vector3.new(-352.51531982421875, -6.3530387878418, 6.8918328285217303)
                            local vector2 = Vector3.new(-353.1174621582031, -6.46261215209961, 113.28694152832031)
                            waypoints[1] = vector
                            waypoints[2] = vector2
                            waypoints[3] = Vector3.new(-334.8, -4.62324523925781, 100.70635986328125)
                        else
                            waypoints = isEnemyBase1
                        end
                        if not waypoints then
                            waypoints = {}
                            local vector = Vector3.new(-352.15, -6.3828, 114.0604)
                            local vector2 = Vector3.new(-351.49, -6.38, 7)
                            waypoints[1] = vector
                            waypoints[2] = vector2
                            waypoints[3] = Vector3.new(-334.8, -5.04, 18.9)
                        end
                        greenPos = isEnemyBase1 and Vector3.new(-349.43, -6.52218532562256, 82.971054077148438)
                            or Vector3.new(-349.42999267578125, -6.52218627929688, 18.9)
                    end
                    local parent = findStealPromptResult321.prompt and findStealPromptResult321.prompt.Parent
                    local promptState = nil
                    if parent then
                        findStealPromptResult321.prompt.RequiresLineOfSight = false
                        findStealPromptResult321.prompt.MaxActivationDistance = math.huge
                        local beginPromptHoldResult336 = beginPromptHold(findStealPromptResult321.prompt)
                        if not beginPromptHoldResult336 and fireproximityprompt then
                            task.spawn(function()
                                fireproximityprompt(findStealPromptResult321.prompt)
                            end)
                            promptState = beginPromptHoldResult336
                        else
                            promptState = beginPromptHoldResult336
                        end
                    end
                    if promptState then
                        waitForPromptDelay(promptState, 0.8)
                    end
                    local numericValue338 = 1
                    for i = #waypoints, 1, -1 do
                        if performRaycast273(character, waypoints[i]) then
                            numericValue338 = i
                            break
                        end
                    end
                    for i = numericValue338, #waypoints do
                        moveCharacterToPoint(character, waypoints[i], 180, 3)
                    end
                    task.wait(0.1)
                    runStealBoosts()
                    findFlightTool()
                    if findStealPromptResult321.prompt and findStealPromptResult321.prompt.Parent then
                        if greenPos then
                            if promptState then
                                waitForPromptDelay(promptState, 1.3)
                            end
                            character.CFrame = CFrame.new(greenPos)
                        end
                        if promptState then
                            finishPromptHold(promptState)
                        end
                    end
                    if semiTeleportSettings.autoWalk then
                        startAutoWalk(isEnemyBase1)
                    end
                    task.delay(1, function()
                        targetPlayer = nil
                    end)
                end,
                execute = function()
                    if localPlayer:GetAttribute("Stealing") then
                        return
                    end
                    if semiTeleportState.debounce then
                        return
                    end
                    semiTeleportState.debounce = true
                    task.spawn(function()
                        local ok = pcall(function()
                            applyReplicationFlags()
                            semiTeleportState.SSDoTeleport()
                        end)
                        task.wait(0.15)
                        semiTeleportState.debounce = false
                        if not ok then
                            appState.stealBusy = false
                        end
                        if semiTeleportSettings.autoRetrySteal then
                            task.delay(0.8, function()
                                    and not localPlayer:GetAttribute("Stealing")
                                    and not semiTeleportState.debounce
                                then
                                    semiTeleportState.execute()
                                end
                            end)
                        end
                    end)
                end,
        end
            local isActive343, thread, isActive345, cFrame, stopBalloonReset, bindEvents348
            runSemiTeleport = function()
                semiTeleportState.execute()
            end
            _G.HalfwaySteal = semiTeleportState
            _G.SSExecute = function()
                pcall(semiTeleportState.execute)
            end
            _G.SetSlot = function(slotNumber)
                semiTeleportState.setSlot(slotNumber)
            end
            semiTeleportSettings.speedBoost = false
            settings.semitp.speedBoost = false
            isActive343 = false
            thread = nil
            isActive345 = false
                local isActive350 = false
                cFrame = nil
                local connection = nil
                stopBalloonReset = function()
                    isActive350 = false
                    if connection then
                        connection:Disconnect()
                        connection = nil
                    end
                end
                bindEvents348 = function()
                    if connection then
                        return
                    end
                    isActive350 = true
                    connection = RunService.RenderStepped:Connect(function()
                        if isActive350 and cFrame and workspaceService.CurrentCamera then
                            workspaceService.CurrentCamera.CFrame = cFrame
                        end
                    end)
                end
            end
                local function findHumanoid352()
                    isActive345 = true
                    if thread then
                        pcall(function()
                            task.cancel(thread)
                        end)
                        thread = nil
                    end
                    isActive343 = false
                    stopBalloonReset()
                    local character = localPlayer.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        pcall(function()
                            humanoid.HipHeight = 2
                            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                            if humanoidRootPart then
                                humanoidRootPart.CanCollide = true
                            end
                            for _, child in ipairs(character:GetChildren()) do
                                if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
                                    child.CanCollide = true
                                end
                            end
                        end)
                    end
                end
                findHumanoid271 = function()
                    if isActive343 then
                        return
                    end
                    isActive343 = true
                    isActive345 = false
                    local character = localPlayer.Character
                    if not character then
                        isActive343 = false
                        return
                    end
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if not humanoid then
                        isActive343 = false
                        return
                    end
                    if workspaceService.CurrentCamera then
                        cFrame = workspaceService.CurrentCamera.CFrame
                        bindEvents348()
                    end
                    thread = task.spawn(function()
                        local hipHeight = humanoid.HipHeight
                        local numericValue362 = 0
                        while true do
                                character.Parent
                                and humanoid.Parent
                                and humanoid.Health > 0
                                and localPlayer.Character == character
                                and not isActive345
                            then
                                pcall(function()
                                    humanoid.HipHeight = 1e30
                                    humanoid.AutoRotate = true
                                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                                    if humanoidRootPart then
                                        humanoidRootPart.CanCollide = false
                                    end
                                    for _, child in ipairs(character:GetChildren()) do
                                        if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
                                            child.CanCollide = false
                                        end
                                    end
                                end)
                                numericValue362 += 1
                                if not (numericValue362 >= 40) then
                                    task.wait(0.05)
                                end
                            end
                            break
                        end
                        local calculatedValue366 = localPlayer.Character ~= character
                            or not character.Parent
                            or humanoid.Health <= 0
                        local isActive367 = false
                        if calculatedValue366 then
                            isActive367 = true
                        end
                            not isActive367
                            and character.Parent
                            and humanoid.Parent
                            and humanoid.Health > 0
                            and not isActive345
                        then
                            pcall(function()
                                humanoid.Health = 0
                            end)
                            task.wait(0.1)
                            isActive367 = not character.Parent
                                or humanoid.Health <= 0
                                or localPlayer.Character ~= character
                        end
                        if not isActive367 and character.Parent and humanoid.Parent then
                            pcall(function()
                                humanoid.HipHeight = hipHeight
                                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                                if humanoidRootPart then
                                    humanoidRootPart.CanCollide = true
                                end
                                for _, child in ipairs(character:GetChildren()) do
                                    if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
                                        child.CanCollide = true
                                    end
                                end
                                return
                            end)
                        end
                        stopBalloonReset()
                        isActive343 = false
                        thread = nil
                        isActive345 = false
                        return
                    end)
                end
                localPlayer.CharacterAdded:Connect(function()
                    findHumanoid352()
                    isActive345 = false
                end)
            end
        end
            local function handleBalloonNotification(messageText)
                if not appState.AutoResetBalloonEnabled then
                    return
                end
                if typeof(messageText) ~= "string" then
                    return
                end
                if not string.lower(messageText):find('ran "balloon" on you!') then
                    return
                end
                findHumanoid271()
            end
            local function bindEvents375(instance376)
                for _, descendant in ipairs(instance376:GetDescendants()) do
                    if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
                        handleBalloonNotification(descendant.Text)
                        pcall(function()
                            table.insert(
                                descendant:GetPropertyChangedSignal("Text"):Connect(function()
                                    handleBalloonNotification(descendant.Text)
                                end)
                        end)
                    end
                end
            end
            local function bindEvents379(descendantAddedState380)
                pcall(function()
                    table.insert(
                        descendantAddedState380.DescendantAdded:Connect(function(descendant)
                                descendant:IsA("TextLabel")
                                or descendant:IsA("TextButton")
                                or descendant:IsA("TextBox")
                            then
                                handleBalloonNotification(descendant.Text)
                                table.insert(
                                    descendant:GetPropertyChangedSignal("Text"):Connect(function()
                                        handleBalloonNotification(descendant.Text)
                                    end)
                            end
                        end)
                end)
            end
            enableBalloonMonitor = function()
                for _, balloonGuiConnection in ipairs(appState.balloonGuiConnections) do
                    pcall(function()
                        balloonGuiConnection:Disconnect()
                    end)
                end
                appState.balloonGuiConnections = {}
                if appState.balloonChildAddedConn then
                    pcall(function()
                        appState.balloonChildAddedConn:Disconnect()
                    end)
                end
                pcall(function()
                    local foundPlayerGui384 = localPlayer:WaitForChild("PlayerGui")
                    for _, child in ipairs(foundPlayerGui384:GetChildren()) do
                        bindEvents375(child)
                        bindEvents379(child)
                    end
                    appState.balloonChildAddedConn = foundPlayerGui384.ChildAdded:Connect(function(child)
                        bindEvents379(child)
                        bindEvents375(child)
                    end)
                end)
            end
        end
        disableBalloonMonitor = function()
            for _, balloonGuiConnection in ipairs(appState.balloonGuiConnections) do
                pcall(function()
                    balloonGuiConnection:Disconnect()
                end)
            end
            appState.balloonGuiConnections = {}
            if appState.balloonChildAddedConn then
                pcall(function()
                    appState.balloonChildAddedConn:Disconnect()
                end)
                appState.balloonChildAddedConn = nil
            end
            return
        end
        enableAntiTurret = function()
            if appState.sentryConn then
                appState.sentryConn:Disconnect()
            end
            appState.sentrySeen = setmetatable({}, {
                __mode = "k",
            appState.sentryConn = workspaceService.DescendantAdded:Connect(function(descendant)
                if not appState.sentryEnabled then
                    return
                end
                if not descendant:IsA("Model") and not descendant:IsA("BasePart") then
                    return
                end
                local part391 = descendant
                local name = part391.Name or ""
                if not string.find(name:lower(), "sentry", 1, true) and descendant:IsA("BasePart") then
                    local model = descendant:FindFirstAncestorOfClass("Model")
                    local find2Result396
                    if model then
                        local name2 = model.Name or ""
                        find2Result396 = string.find(name2:lower(), "sentry", 1, true)
                    else
                        find2Result396 = model
                    end
                    if find2Result396 then
                        part391 = model
                    end
                end
                if not string.find((part391.Name or ""):lower(), "sentry", 1, true) then
                    return
                end
                if appState.sentrySeen[part391] then
                    return
                end
                appState.sentrySeen[part391] = true
                for _, player in pairs(playersService:GetPlayers()) do
                    if player.Character and part391:IsDescendantOf(player.Character) and player == localPlayer then
                        return
                    end
                end
                task.delay(0.08, function()
                    if not part391.Parent or not appState.sentryEnabled then
                        return
                    end
                    local character = localPlayer.Character
                    local calculatedValue404 = character and character:FindFirstChild("HumanoidRootPart")
                    if not character or not calculatedValue404 then
                        return
                    end
                    local backpack = localPlayer:FindFirstChild("Backpack")
                    local bat = backpack and backpack:FindFirstChild("Bat") or character:FindFirstChild("Bat")
                    if not bat then
                        return
                    end
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if bat.Parent == backpack and humanoid then
                        humanoid:EquipTool(bat)
                        task.wait(0.12)
                    end
                    local calculatedValue408 = calculatedValue404.CFrame.LookVector * 3.5 + Vector3.new(0, 1.2, 0)
                    pcall(function()
                        if part391:IsA("Model") and part391.PrimaryPart then
                            part391:SetPrimaryPartCFrame(calculatedValue404.CFrame + calculatedValue408)
                        elseif part391:IsA("BasePart") then
                            part391.CFrame = calculatedValue404.CFrame + calculatedValue408
                        end
                    end)
                    if bat.Parent == character then
                        bat:Activate()
                    end
                    for i = 1, 5 do
                        if not (not appState.sentryEnabled or not part391.Parent) then
                            task.wait(0.12)
                            if part391.Parent then
                                bat:Activate()
                            end
                        end
                        break
                    end
                    if bat.Parent == character and backpack then
                        bat.Parent = backpack
                    end
                end)
            end)
        end
        disableAntiTurret = function()
            if appState.sentryConn then
                appState.sentryConn:Disconnect()
                appState.sentryConn = nil
            end
            appState.sentrySeen = nil
        end
        enableGameStretcher = function()
            appState.gameStretcherEnabled = true
            settings.toggles.gameStretcher = true
            saveSettings()
            if appState.gameStretcherConn then
                appState.gameStretcherConn:Disconnect()
            end
            pcall(function()
                appState.gameStretcherConn = RunService.RenderStepped:Connect(function()
                    if not appState.gameStretcherEnabled then
                        return
                    end
                    if workspaceService.CurrentCamera then
                        workspaceService.CurrentCamera.FieldOfView = 100
                    end
                end)
            end)
        end
        disableGameStretcher = function()
            appState.gameStretcherEnabled = false
            settings.toggles.gameStretcher = false
            saveSettings()
            if appState.gameStretcherConn then
                appState.gameStretcherConn:Disconnect()
                appState.gameStretcherConn = nil
            end
            if workspaceService.CurrentCamera then
                if settings.toggles.customFOV then
                    workspaceService.CurrentCamera.FieldOfView = 120
                elseif settings.toggles.antiBee then
                    workspaceService.CurrentCamera.FieldOfView = 70
                else
                    workspaceService.CurrentCamera.FieldOfView = 255
                end
            end
            return
        end
            local function findPlotSign413(plotName)
                local plots = workspaceService.Plots and workspaceService.Plots:FindFirstChild(plotName)
                if not plots then
                    return false
                end
                local plotSign = plots:FindFirstChild("PlotSign")
                if not plotSign then
                    return false
                end
                local yourBase = plotSign:FindFirstChild("YourBase")
                return yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled == true
            end
            unlockBaseFloor = function(index418)
                local getHRPResult420 = getCharacterRootPart()
                if not getHRPResult420 then
                    return
                end
                local plots = workspaceService:FindFirstChild("Plots")
                if not plots then
                    return
                end
                local huge = math.huge
                local instance423 = nil
                for _, child in pairs(plots:GetChildren()) do
                    if child:IsA("Model") and not findPlotSign413(child.Name) then
                        local magnitude = (
                            - (child.PrimaryPart and child.PrimaryPart.Position or child:GetPivot().Position)
                        ).Magnitude
                        if magnitude < huge then
                            huge = magnitude
                            instance423 = child
                        end
                    end
                end
                if instance423 and instance423:FindFirstChild("Unlock") then
                    local lookupTable427 = {}
                    for _, child in pairs(instance423.Unlock:GetChildren()) do
                        table.insert(lookupTable427, {
                            Obj = child,
                            Y = (child:IsA("Model") and child:GetPivot().Position or child.Position).Y,
                    end
                    table.sort(lookupTable427, function(vector430, vector431)
                        return vector430.Y < vector431.Y
                    end)
                    if lookupTable427[index418] then
                        for _, descendant in pairs(lookupTable427[index418].Obj:GetDescendants()) do
                            if descendant:IsA("ProximityPrompt") then
                                pcall(function()
                                    fireproximityprompt(descendant)
                                end)
                            end
                        end
                    end
                end
            end
        end
            local function clearOwnedGuis()
                local lookupTable435 = {
                    CoreGui,
                pcall(function()
                    if gethui then
                        local hui = gethui()
                        if hui then
                            table.insert(lookupTable435, hui)
                        end
                    end
                end)
                for _, instance439 in ipairs(lookupTable435) do
                    if instance439 then
                        for _, child in ipairs(instance439:GetChildren()) do
                            if child:IsA("ScreenGui") then
                                local calculatedValue442 = child:GetAttribute("IceHubOwned") == true
                                    or child.Name == "ICE_HUB_MAIN_GUI"
                                    or child.Name == "ICE_HUB_SEMITP_GUI"
                                if not calculatedValue442 then
                                    pcall(function()
                                        for _, descendant in ipairs(child:GetDescendants()) do
                                                (descendant:IsA("TextLabel") or descendant:IsA("TextButton"))
                                                and (
                                                    descendant.Text == "Ice Hub - Steal A Brainrot"
                                                    or descendant.Text == "https://discord.gg/TBBAUZu8cW"
                                            then
                                                calculatedValue442 = true
                                                break
                                            end
                                        end
                                    end)
                                end
                                if calculatedValue442 then
                                    pcall(function()
                                        child:Destroy()
                                    end)
                                end
                            end
                        end
                    end
                end
            end
            clearOwnedGuis()
        end
            local function decodeBase64(encodedData)
                return (
                        :gsub("[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=]", "")
                        :gsub(".", function(encodedCharacter)
                            if encodedCharacter == "=" then
                                return ""
                            end
                            local calculatedValue448 = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):find(
                                true
                            local text449 = ""
                            for i = 6, 1, -1 do
                                text449 ..= calculatedValue448 % 2 ^ i - calculatedValue448 % 2 ^ (i - 1) > 0 and "1" or "0"
                            end
                            return text449
                        end)
                        :gsub("%d%d%d?%d?%d?%d?%d?%d?", function(text451)
                            if #text451 ~= 8 then
                                return ""
                            end
                            local numericValue452 = 0
                            for i = 1, 8 do
                                numericValue452 += text451:sub(i, i) == "1" and 2 ^ (8 - i) or 0
                            end
                            return string.char(numericValue452)
                        end)
            end
            local function saveData454()
                local png = nil
                pcall(function()
                        if not (isfile and isfile("icehub_logo.png")) then
                            writefile(
                                "icehub_logo.png",
                                decodeBase64(
                        end
                        if not (isfile and isfile("icehub_logo.png")) then
                            writefile(
                                "icehub_logo.png",
                                decodeBase64(
                        end
                    end
                end)
                return png
            end
            logoAsset = saveData454()
        end
        appState.screenGui = Instance.new("ScreenGui")
        appState.screenGui.Name = "ICE_HUB_MAIN_GUI"
        appState.screenGui:SetAttribute("IceHubOwned", true)
        appState.screenGui.ResetOnSpawn = false
        appState.screenGui.DisplayOrder = 999
        appState.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        attachGui(appState.screenGui)
        mainGui = appState.screenGui
        createUIGradient = function(parent, gradientColors)
            local uiGradient = Instance.new("UIGradient")
            uiGradient.Color = ColorSequence.new(gradientColors or appState.ACCENT_KEYS)
            uiGradient.Rotation = 0
            uiGradient.Parent = parent
            table.insert(appState.allGradients, uiGradient)
            return uiGradient
        end
        addGradientStroke = function(parent, thickness)
            local instance = Instance.new("UIStroke")
            instance.Thickness = thickness or 2
            instance.Color = appState.COL_WHITE
            instance.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            instance.Parent = parent
            createUIGradient(instance)
            return instance
        end
        createUICorner = function(parent, cornerRadius)
            local uiCorner = Instance.new("UICorner")
            uiCorner.CornerRadius = UDim.new(0, cornerRadius or 10)
            uiCorner.Parent = parent
            return uiCorner
        end
        makeDraggable = function(guiObject470, inputBeganState471, index472)
            local isActive473 = false
            local dragInput = nil
            local position = nil
            local position2
            local function updateDragPosition(guiObject478)
                if not isActive473 then
                    return
                end
                local calculatedValue479 = guiObject478.Position - position
                guiObject470.Position = UDim2.new(
                    position2.X.Scale,
                    position2.X.Offset + calculatedValue479.X,
                    position2.Y.Scale,
                    position2.Y.Offset + calculatedValue479.Y
            end
            pcall(function()
                inputBeganState471.InputBegan:Connect(function(input)
                        input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch
                    then
                        isActive473 = true
                        position = input.Position
                        position2 = guiObject470.Position
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                isActive473 = false
                                if index472 then
                                    if settings.panels and settings.panels[index472] then
                                        settings.panels[index472].x = guiObject470.Position.X.Scale
                                        settings.panels[index472].xOffset = guiObject470.Position.X.Offset
                                        settings.panels[index472].y = guiObject470.Position.Y.Scale
                                        settings.panels[index472].yOffset = guiObject470.Position.Y.Offset
                                        saveSettings()
                                    else
                                        savePanelPosition(guiObject470, index472)
                                    end
                                end
                            end
                        end)
                    end
                end)
                inputBeganState471.InputChanged:Connect(function(input)
                        input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch
                    then
                        dragInput = input
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if input == dragInput and isActive473 then
                        updateDragPosition(input)
                    end
                end)
            end)
        end
            local minimizeKey = Enum.KeyCode.R
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then
                    return
                end
                if input.KeyCode == minimizeKey then
                    findHumanoid271()
                end
            end)
        end
            local windowToggleKey, isActive487, isActive488, calculatedValue489, calculatedValue490, instance, instance2
                local hotkeyGui = Instance.new("ScreenGui")
                hotkeyGui.Name = "ICE_HUB_INSTA_RESET_GUI"
                hotkeyGui:SetAttribute("IceHubOwned", true)
                hotkeyGui.ResetOnSpawn = false
                hotkeyGui.DisplayOrder = 1001
                hotkeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                attachGui(hotkeyGui)
                windowToggleKey = Enum.KeyCode.R
                isActive487 = false
                isActive488 = false
                calculatedValue489 = isMobile and 128 or 124
                calculatedValue490 = isMobile and 220 or 240
                instance = Instance.new("Frame")
                instance.Name = "InstaResetWindow"
                instance.Size = UDim2.new(0, calculatedValue490, 0, calculatedValue489)
                local udim2 = UDim2.new(0.5, -calculatedValue490 / 2, 0.5, isMobile and 90 or 120)
                restorePanelPosition(instance, "instaReset", udim2)
                instance.BackgroundColor3 = Color3.fromRGB(6, 14, 31)
                instance.BackgroundTransparency = 0.68
                instance.BorderSizePixel = 0
                instance.Active = true
                instance.ClipsDescendants = true
                instance.ZIndex = 20
                instance.Parent = hotkeyGui
            end
                local instance3
                createUICorner(instance, 12)
                addGradientStroke(instance, 2)
                instance3 = Instance.new("Frame")
                instance3.Size = UDim2.new(1, 0, 0, 36)
                instance3.BackgroundColor3 = Color3.fromRGB(18, 62, 126)
                instance3.BackgroundTransparency = 1
                instance3.BorderSizePixel = 0
                instance3.Active = true
                instance3.ZIndex = 31
                instance3.Parent = instance
                createUICorner(instance3, 12)
                    local frame2 = Instance.new("Frame")
                    frame2.Size = UDim2.new(1, 0, 0, 12)
                    frame2.Position = UDim2.new(0, 0, 1, -12)
                    frame2.BackgroundColor3 = Color3.fromRGB(18, 62, 126)
                    frame2.BackgroundTransparency = 1
                    frame2.BorderSizePixel = 0
                    frame2.ZIndex = 31
                    frame2.Parent = instance3
                end
                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(1, -44, 1, 0)
                    textLabel.Position = UDim2.new(0, 10, 0, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Text = "Ice Hub - Insta Reset"
                    textLabel.TextColor3 = appState.COL_WHITE
                    textLabel.TextSize = isMobile and 12 or 13
                    textLabel.Font = Enum.Font.GothamBlack
                    textLabel.TextXAlignment = Enum.TextXAlignment.Left
                    textLabel.ZIndex = 32
                    textLabel.Parent = instance3
                end
                instance2 = Instance.new("TextButton")
                instance2.Size = UDim2.new(0, 24, 0, 24)
                instance2.Position = UDim2.new(1, -31, 0.5, -12)
                instance2.BackgroundColor3 = Color3.fromRGB(18, 80, 112)
                instance2.BackgroundTransparency = 0.52
                instance2.BorderSizePixel = 0
                instance2.Text = "-"
                instance2.TextColor3 = appState.COL_WHITE
                instance2.TextSize = 13
                instance2.Font = Enum.Font.GothamBlack
                instance2.AutoButtonColor = false
                instance2.ZIndex = 33
                instance2.Parent = instance3
                createUICorner(instance2, 6)
                addGradientStroke(instance2, 1)
                makeDraggable(instance, instance3, "instaReset")
            end
                local textButton = Instance.new("TextButton")
                textButton.Size = UDim2.new(1, -20, 0, 34)
                textButton.Position = UDim2.new(0, 10, 0, 43)
                textButton.BackgroundColor3 = Color3.fromRGB(15, 31, 57)
                textButton.BackgroundTransparency = 0.45
                textButton.BorderSizePixel = 0
                textButton.Text = "Reset"
                textButton.TextColor3 = appState.COL_WHITE
                textButton.TextSize = isMobile and 12 or 13
                textButton.Font = Enum.Font.GothamBlack
                textButton.TextXAlignment = Enum.TextXAlignment.Left
                textButton.AutoButtonColor = false
                textButton.ZIndex = 31
                textButton.Parent = instance
                createUICorner(textButton, 7)
                addGradientStroke(textButton, 1)
                local uiPadding = Instance.new("UIPadding")
                uiPadding.PaddingLeft = UDim.new(0, 10)
                uiPadding.Parent = textButton
                textButton.MouseButton1Click:Connect(function()
                    findHumanoid271()
                end)
            end
            local frame2
            frame2 = Instance.new("Frame")
            frame2.Size = UDim2.new(1, -20, 0, 34)
            frame2.Position = UDim2.new(0, 10, 0, 55)
            frame2.BackgroundColor3 = Color3.fromRGB(15, 31, 57)
            frame2.BackgroundTransparency = 0.45
            frame2.BorderSizePixel = 0
            frame2.ZIndex = 31
            frame2.Parent = instance
            createUICorner(frame2, 7)
            addGradientStroke(frame2, 1)
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, -72, 1, 0)
                textLabel.Position = UDim2.new(0, 10, 0, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = "Keybind"
                textLabel.TextColor3 = appState.COL_WHITE
                textLabel.TextSize = isMobile and 11 or 12
                textLabel.Font = Enum.Font.GothamBold
                textLabel.TextXAlignment = Enum.TextXAlignment.Left
                textLabel.ZIndex = 32
                textLabel.Parent = frame2
            end
                local textButton = Instance.new("TextButton")
                textButton.Size = UDim2.new(0, 50, 0, 22)
                textButton.Position = UDim2.new(1, -58, 0.5, -11)
                textButton.BackgroundColor3 = Color3.fromRGB(12, 48, 90)
                textButton.BackgroundTransparency = 0.28
                textButton.BorderSizePixel = 0
                textButton.Text = "[R]"
                textButton.TextColor3 = appState.COL_WHITE
                textButton.TextSize = 10
                textButton.Font = Enum.Font.GothamBlack
                textButton.AutoButtonColor = false
                textButton.ZIndex = 32
                textButton.Parent = frame2
                createUICorner(textButton, 6)
                addGradientStroke(textButton, 1)
                textButton.MouseButton1Click:Connect(function()
                    if isActive487 then
                        return
                    end
                    isActive487 = true
                    textButton.Text = "..."
                    local connection = nil
                    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                        if gameProcessed or input.KeyCode == Enum.KeyCode.Unknown then
                            return
                        end
                        connection:Disconnect()
                        windowToggleKey = input.KeyCode
                        isActive487 = false
                        textButton.Text = "[" .. tostring(input.KeyCode):gsub("Enum%.KeyCode%.", "") .. "]"
                    end)
                end)
            end
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed or isActive487 then
                    return
                end
                if input.KeyCode == windowToggleKey then
                    findHumanoid271()
                end
            end)
            instance2.MouseButton1Click:Connect(function()
                isActive488 = not isActive488
                instance2.Text = isActive488 and "+" or "-"
                TweenService
                    :Create(instance, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
                        Size = UDim2.new(0, calculatedValue490, 0, isActive488 and 36 or calculatedValue489),
                    :Play()
            end)
        end
        hudWidth = isMobile and 320 or 340
        hudHeight = isMobile and 76 or 82
        controlButtonSize = isMobile and 48 or 42
        controlButtonSpacing = isMobile and 8 or 10
        layoutMargin = isMobile and 10 or 12
        hudTopOffset = layoutMargin + controlButtonSize + (isMobile and 6 or 8)
        appState.HUD_WIDTH = hudWidth
        appState.HUD_HEIGHT = hudHeight
        hudFrame = Instance.new("Frame")
        hudFrame.Name = generateRandomGuiName()
        hudFrame.Size = UDim2.new(0, hudWidth, 0, hudHeight)
        hudFrame.Position = UDim2.new(0.5, -hudWidth / 2, 0, hudTopOffset)
        hudFrame.BackgroundColor3 = Color3.fromRGB(7, 31, 61)
        hudFrame.BackgroundTransparency = 0.62
        hudFrame.BorderSizePixel = 0
        hudFrame.Visible = true
        hudFrame.ZIndex = 2
        hudFrame.Parent = mainGui
        hudFrame.Active = false
        createUICorner(hudFrame, 12)
            local uiGradient = Instance.new("UIGradient")
            local lookupTable512 = {}
            local colorKeypoint513 = ColorSequenceKeypoint.new(0, Color3.fromRGB(6, 25, 52))
            local colorKeypoint514 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(9, 85, 84))
            lookupTable512[1] = colorKeypoint513
            lookupTable512[2] = colorKeypoint514
            lookupTable512[3] = ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 24, 50))
            uiGradient.Color = ColorSequence.new(lookupTable512)
            uiGradient.Rotation = 90
            uiGradient.Parent = hudFrame
        end
        addGradientStroke(hudFrame, 2)
            local instance = Instance.new("TextLabel")
            instance.Size = UDim2.new(1, 0, 0, isMobile and 28 or 24)
            instance.Position = UDim2.new(0, 0, 0, 5)
            instance.BackgroundTransparency = 1
            instance.Text = "Ice Hub"
            instance.TextColor3 = appState.COL_WHITE
            instance.TextSize = isMobile and 19 or 20
            instance.Font = Enum.Font.GothamBlack
            instance.TextXAlignment = Enum.TextXAlignment.Center
            instance.ZIndex = 3
            instance.Parent = hudFrame
            createUIGradient(instance)
        end
    end
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0, 18)
    textLabel.Position = UDim2.new(0, 0, 0, isMobile and 29 or 31)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "https://discord.gg/TBBAUZu8cW"
    textLabel.TextColor3 = Color3.fromRGB(125, 205, 255)
    textLabel.TextSize = isMobile and 14 or 14
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextXAlignment = Enum.TextXAlignment.Center
    textLabel.ZIndex = 3
    textLabel.Parent = hudFrame
end
local calculatedValue521, frame2, textButton, stealerTab, helperTab, espTab, playerTab, worldTab, uiTab, serverTab
local createSectionHeader, createSavedToggle, createToggle, createActionButton, createPanelContainer, semiTeleportGui, espState, parseCurrency, findOwningPlot
    local calculatedValue540, frame3
    appState.statsLabel = Instance.new("TextLabel")
    appState.statsLabel.Size = UDim2.new(1, 0, 0, 18)
    appState.statsLabel.Position = UDim2.new(0, 0, 0, isMobile and 48 or 52)
    appState.statsLabel.BackgroundTransparency = 1
    appState.statsLabel.Text = "FPS: -- PING: --ms"
    appState.statsLabel.TextColor3 = appState.COL_WHITE
    appState.statsLabel.TextSize = isMobile and 12 or 13
    appState.statsLabel.Font = Enum.Font.GothamBold
    appState.statsLabel.TextXAlignment = Enum.TextXAlignment.Center
    appState.statsLabel.ZIndex = 3
    appState.statsLabel.Parent = hudFrame
    appState.topButtons = {}
    calculatedValue521 = 3 * controlButtonSize + 2 * controlButtonSpacing
    frame2 = Instance.new("Frame")
    frame2.Name = generateRandomGuiName()
    frame2.Size = UDim2.new(0, calculatedValue521, 0, controlButtonSize)
        local udim2 = UDim2.new(0.5, -calculatedValue521 / 2, 0, layoutMargin)
        restorePanelPosition(frame2, "topButtons", udim2)
    end
    frame2.BackgroundTransparency = 1
    frame2.BorderSizePixel = 0
    frame2.Active = true
    frame2.ZIndex = 4
    frame2.Parent = mainGui
    for i = 1, 3 do
            local instance = Instance.new("TextButton")
            instance.Name = generateRandomGuiName()
            instance.Size = UDim2.new(0, controlButtonSize, 0, controlButtonSize)
            instance.Position = UDim2.new(0, (i - 1) * (controlButtonSize + controlButtonSpacing), 0, 0)
            instance.BackgroundColor3 = Color3.fromRGB(8, 41, 72)
            instance.BackgroundTransparency = 0.42
            instance.BorderSizePixel = 0
            instance.Text = tostring(i)
            instance.TextColor3 = appState.COL_WHITE
            instance.TextSize = isMobile and 20 or 19
            instance.Font = Enum.Font.GothamBold
            instance.ZIndex = 5
            instance.AutoButtonColor = false
            instance.Active = true
            instance.Visible = settings.toggles.unlockBase
            instance.Parent = frame2
            createUICorner(instance, 9)
            addGradientStroke(instance, 2)
            appState.topButtons[i] = instance
            instance.MouseButton1Click:Connect(function()
                unlockBaseFloor(i)
            end)
        end
    end
        local isActive545 = false
        local dragInput = nil
        local position = nil
        local position2 = nil
        local function bindEvents549(input)
                input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch
            then
                isActive545 = true
                position = input.Position
                position2 = frame2.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        isActive545 = false
                        savePanelPosition(frame2, "topButtons")
                    end
                end)
            end
        end
        frame2.InputBegan:Connect(bindEvents549)
        for _, topButton in ipairs(appState.topButtons) do
            topButton.InputBegan:Connect(bindEvents549)
        end
        frame2.InputChanged:Connect(function(input)
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            then
                dragInput = input
            end
        end)
        for _, topButton in ipairs(appState.topButtons) do
            topButton.InputChanged:Connect(function(input)
                    input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch
                then
                    dragInput = input
                end
            end)
        end
        UserInputService.InputChanged:Connect(function(input)
            if not isActive545 or input ~= dragInput then
                return
            end
            local calculatedValue558 = input.Position - position
            frame2.Position = UDim2.new(
                position2.X.Scale,
                position2.X.Offset + calculatedValue558.X,
                position2.Y.Scale,
                position2.Y.Offset + calculatedValue558.Y
        end)
    end
    textButton = Instance.new("TextButton")
    textButton.Name = generateRandomGuiName()
    textButton.Size = UDim2.new(0, isMobile and 82 or 88, 0, isMobile and 27 or 28)
    textButton.Position = UDim2.new(0.5, -(isMobile and 41 or 44), 0, hudTopOffset + hudHeight + 5)
    textButton.BackgroundColor3 = Color3.fromRGB(13, 45, 90)
    textButton.BackgroundTransparency = 0.38
    textButton.BorderSizePixel = 0
    textButton.Text = isMobile and "Menu" or "Menu [T]"
    textButton.TextColor3 = appState.COL_WHITE
    textButton.TextSize = isMobile and 12 or 12
    textButton.Font = Enum.Font.GothamBold
    textButton.ZIndex = 4
    textButton.AutoButtonColor = false
    textButton.Active = true
    textButton.Parent = mainGui
    createUICorner(textButton, 7)
    addGradientStroke(textButton, 1)
    appState.panel = Instance.new("Frame")
    appState.panel.Name = generateRandomGuiName()
    appState.panel.Size = UDim2.new(0, appState.PANEL_W, 0, appState.PANEL_H)
        local udim2 = UDim2.new(0.5, -appState.PANEL_W / 2, 0.5, -appState.PANEL_H / 2)
        restorePanelPosition(appState.panel, "main", udim2)
    end
    appState.panel.BackgroundColor3 = Color3.fromRGB(6, 14, 31)
    appState.panel.BackgroundTransparency = 0.62
    appState.panel.BorderSizePixel = 0
    appState.panel.Visible = false
    appState.panel.ZIndex = 10
    appState.panel.Active = true
    appState.panel.Parent = mainGui
    createUICorner(appState.panel, 18)
    addGradientStroke(appState.panel, 2)
        local uiGradient = Instance.new("UIGradient")
        local lookupTable562 = {}
        local colorKeypoint563 = ColorSequenceKeypoint.new(0, Color3.fromRGB(6, 14, 31))
        local colorKeypoint564 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(8, 28, 59))
        lookupTable562[1] = colorKeypoint563
        lookupTable562[2] = colorKeypoint564
        lookupTable562[3] = ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 12, 28))
        uiGradient.Color = ColorSequence.new(lookupTable562)
        uiGradient.Rotation = 135
        uiGradient.Parent = appState.panel
    end
    calculatedValue540 = isMobile and 42 or 48
    frame3 = Instance.new("Frame")
    frame3.Size = UDim2.new(1, 0, 0, calculatedValue540)
    frame3.BackgroundColor3 = Color3.fromRGB(10, 27, 45)
    frame3.BackgroundTransparency = 1
    frame3.BorderSizePixel = 0
    frame3.ZIndex = 11
    frame3.Parent = appState.panel
    createUICorner(frame3, 18)
        local frame4 = Instance.new("Frame")
        frame4.Size = UDim2.new(1, 0, 0, 18)
        frame4.Position = UDim2.new(0, 0, 1, -18)
        frame4.BackgroundColor3 = Color3.fromRGB(10, 27, 55)
        frame4.BackgroundTransparency = 1
        frame4.BorderSizePixel = 0
        frame4.ZIndex = 12
        frame4.Parent = frame3
    end
        local frame4 = Instance.new("Frame")
        frame4.Size = UDim2.new(1, 0, 0, 2)
        frame4.Position = UDim2.new(0, 0, 1, -2)
        frame4.BackgroundColor3 = Color3.fromRGB(95, 175, 255)
        frame4.BackgroundTransparency = 1
        frame4.BorderSizePixel = 0
        frame4.ZIndex = 13
        frame4.Parent = frame3
        local uiGradient = Instance.new("UIGradient")
        local lookupTable573 = {}
        local colorKeypoint574 = ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 115, 235))
        local colorKeypoint575 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(235, 248, 255))
        lookupTable573[1] = colorKeypoint574
        lookupTable573[2] = colorKeypoint575
        lookupTable573[3] = ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 145, 255))
        uiGradient.Color = ColorSequence.new(lookupTable573)
        uiGradient.Parent = frame4
        table.insert(appState.allGradients, uiGradient)
    end
    local frame4
        local frame5, calculatedValue583, scrollingFrame
        if logoAsset then
            local imageLabel = Instance.new("ImageLabel")
            imageLabel.Size = UDim2.new(0, isMobile and 32 or 36, 0, isMobile and 32 or 36)
            imageLabel.Position = UDim2.new(0, 10, 0.5, isMobile and -16 or -18)
            imageLabel.BackgroundTransparency = 1
            imageLabel.Image = logoAsset
            imageLabel.ScaleType = Enum.ScaleType.Fit
            imageLabel.ZIndex = 15
            imageLabel.Parent = frame3
        else
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(0, isMobile and 32 or 36, 0, isMobile and 32 or 28)
            textLabel.Position = UDim2.new(0, 10, 0.5, isMobile and -16 or -18)
            textLabel.BackgroundColor3 = Color3.fromRGB(12, 45, 92)
            textLabel.BackgroundTransparency = 0.08
            textLabel.Text = "ICE"
            textLabel.TextColor3 = Color3.fromRGB(225, 242, 255)
            textLabel.TextSize = isMobile and 14 or 12
            textLabel.Font = Enum.Font.GothamBlack
            textLabel.BorderSizePixel = 0
            textLabel.ZIndex = 15
            textLabel.Parent = frame3
            createUICorner(textLabel, 9)
            addGradientStroke(textLabel, 1)
        end
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, -98, 1, 0)
            textLabel.Position = UDim2.new(0, isMobile and 54 or 54, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = "Ice Hub - Steal A Brainrot"
            textLabel.TextColor3 = appState.COL_WHITE
            textLabel.TextSize = isMobile and 13 or 16
            textLabel.Font = Enum.Font.GothamBlack
            textLabel.TextXAlignment = Enum.TextXAlignment.Left
            textLabel.ZIndex = 14
            textLabel.Parent = frame3
        end
            local textButton2 = Instance.new("TextButton")
            textButton2.Size = UDim2.new(0, isMobile and 25 or 28, 0, isMobile and 25 or 28)
            textButton2.Position = UDim2.new(1, isMobile and -33 or -38, 0.5, isMobile and -12 or -14)
            textButton2.BackgroundColor3 = Color3.fromRGB(15, 42, 78)
            textButton2.Text = "×"
            textButton2.TextColor3 = Color3.fromRGB(180, 225, 255)
            textButton2.TextSize = isMobile and 12 or 13
            textButton2.Font = Enum.Font.GothamBlack
            textButton2.BorderSizePixel = 0
            textButton2.AutoButtonColor = false
            textButton2.ZIndex = 15
            textButton2.Parent = frame3
            createUICorner(textButton2, 7)
            addGradientStroke(textButton2, 1)
            textButton2.MouseButton1Click:Connect(function()
                appState.menuOpen = false
                settings.ui.menuOpen = false
                saveSettings()
                appState.panel.Visible = false
            end)
        end
        makeDraggable(appState.panel, frame3, "main")
        frame5 = Instance.new("Frame")
        frame5.Size = UDim2.new(1, -16, 1, -(calculatedValue540 + 12))
        frame5.Position = UDim2.new(0, 8, 0, calculatedValue540 + 6)
        frame5.BackgroundTransparency = 1
        frame5.ZIndex = 12
        frame5.Parent = appState.panel
        calculatedValue583 = isMobile and 96 or 125
        frame4 = Instance.new("Frame")
        frame4.Size = UDim2.new(0, calculatedValue583, 1, 0)
        frame4.BackgroundColor3 = Color3.fromRGB(7, 11, 44)
        frame4.BackgroundTransparency = 0.62
        frame4.BorderSizePixel = 0
        frame4.ZIndex = 11
        frame4.Parent = frame5
        frame4.ClipsDescendants = true
        createUICorner(frame4, 11)
        scrollingFrame = Instance.new("ScrollingFrame")
        scrollingFrame.Size = UDim2.new(1, -6, 1, -94)
        scrollingFrame.Position = UDim2.new(0, 3, 0, 4)
        scrollingFrame.BackgroundTransparency = 1
        scrollingFrame.BorderSizePixel = 0
        scrollingFrame.ScrollBarThickness = 0
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scrollingFrame.ZIndex = 12
        scrollingFrame.Parent = frame4
            local uiListLayout = Instance.new("UIListLayout")
            uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            uiListLayout.Padding = UDim.new(0, 5)
            uiListLayout.Parent = scrollingFrame
        end
            local instance = Instance.new("UIPadding")
            instance.PaddingTop = UDim.new(0, 4)
            instance.PaddingLeft = UDim.new(0, 3)
            instance.PaddingRight = UDim.new(0, 3)
            instance.Parent = scrollingFrame
        end
            local frame6 = Instance.new("Frame")
            frame6.Size = UDim2.new(0, 2, 1, -6)
            frame6.Position = UDim2.new(0, calculatedValue583 + 5, 0, 3)
            frame6.BackgroundColor3 = Color3.fromRGB(80, 155, 255)
            frame6.BackgroundTransparency = 0.25
            frame6.BorderSizePixel = 0
            frame6.ZIndex = 12
            frame6.Parent = frame5
            local uiGradient = Instance.new("UIGradient")
            uiGradient.Color = ColorSequence.new(appState.ACCENT_KEYS)
            uiGradient.Parent = frame6
            table.insert(appState.allGradients, uiGradient)
        end
        local instance = Instance.new("Frame")
        instance.Size = UDim2.new(1, -calculatedValue583 - 15, 1, 0)
        instance.Position = UDim2.new(0, calculatedValue583 + 13, 0, 0)
        instance.BackgroundTransparency = 1
        instance.ZIndex = 11
        instance.Parent = frame5
        appState.tabButtons = {}
        appState.tabContents = {}
        for i, text595 in ipairs({
        }) do
            local textButton2, frame6, textLabel, scrollingFrame2
            textButton2 = Instance.new("TextButton")
            textButton2.Size = UDim2.new(1, -2, 0, isMobile and 31 or 32)
            textButton2.BackgroundColor3 = Color3.fromRGB(10, 31, 61)
            textButton2.BackgroundTransparency = settings.ui.activeTab == text595 and 0.28 or 0.48
            textButton2.BorderSizePixel = 0
            textButton2.Text = ""
            textButton2.AutoButtonColor = false
            textButton2.LayoutOrder = i
            textButton2.ZIndex = 13
            textButton2.Parent = scrollingFrame
            createUICorner(textButton2, 8)
            frame6 = Instance.new("Frame")
            frame6.Size = UDim2.new(0, 3, 0.68, 0)
            frame6.Position = UDim2.new(0, 0, 0.16, 0)
            frame6.BackgroundColor3 = Color3.fromRGB(90, 185, 255)
            frame6.BackgroundTransparency = settings.ui.activeTab == text595 and 0 or 1
            frame6.BorderSizePixel = 0
            frame6.ZIndex = 14
            frame6.Parent = textButton2
            createUICorner(frame6, 3)
            textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, -12, 1, 0)
            textLabel.Position = UDim2.new(0, 10, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = text595
            textLabel.TextColor3 = settings.ui.activeTab == text595 and appState.COL_WHITE or appState.COL_DIM
            textLabel.TextSize = isMobile and 10 or 12
            textLabel.Font = settings.ui.activeTab == text595 and Enum.Font.GothamBlack or Enum.Font.GothamBold
            textLabel.TextXAlignment = Enum.TextXAlignment.Left
            textLabel.ZIndex = 14
            textLabel.Parent = textButton2
            addGradientStroke(textButton2, 1).Transparency = settings.ui.activeTab == text595 and 0.25 or 0.8
            scrollingFrame2 = Instance.new("ScrollingFrame")
            scrollingFrame2.Name = generateRandomGuiName()
            scrollingFrame2.Size = UDim2.new(1, 0, 1, 0)
            scrollingFrame2.BackgroundTransparency = 1
            scrollingFrame2.BorderSizePixel = 0
            scrollingFrame2.ScrollBarThickness = isMobile and 4 or 3
            scrollingFrame2.ScrollBarImageColor3 = Color3.fromRGB(80, 120, 255)
            scrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 0)
            scrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y
            scrollingFrame2.Visible = settings.ui.activeTab == text595
            scrollingFrame2.ZIndex = 12
            scrollingFrame2.Parent = instance
                local uiListLayout = Instance.new("UIListLayout")
                uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                uiListLayout.Padding = UDim.new(0, 8)
                uiListLayout.Parent = scrollingFrame2
            end
                local uiPadding = Instance.new("UIPadding")
                uiPadding.PaddingTop = UDim.new(0, 6)
                uiPadding.PaddingBottom = UDim.new(0, 8)
                uiPadding.PaddingLeft = UDim.new(0, 6)
                uiPadding.PaddingRight = UDim.new(0, 8)
                uiPadding.Parent = scrollingFrame2
            end
            appState.tabButtons[i] = {
                button = textButton2,
                indicator = frame6,
                label = textLabel,
            appState.tabContents[i] = scrollingFrame2
            textButton2.MouseButton1Click:Connect(function()
                settings.ui.activeTab = text595
                saveSettings()
                for i2, tabButton in ipairs(appState.tabButtons) do
                    local visible = i2 == i
                    tabButton.button.BackgroundTransparency = visible and 0.28 or 0.48
                    tabButton.indicator.BackgroundTransparency = visible and 0 or 1
                    tabButton.label.TextColor3 = visible and appState.COL_WHITE or appState.COL_DIM
                    tabButton.label.Font = visible and Enum.Font.GothamBlack or Enum.Font.GothamBold
                    appState.tabContents[i2].Visible = visible
                end
            end)
        end
    end
        local instance
        instance = Instance.new("Frame")
        instance.Name = "IceHubSidebarFooter"
        instance.Size = UDim2.new(1, -8, 0, isMobile and 78 or 86)
        instance.Position = UDim2.new(0, 4, 1, isMobile and -82 or -90)
        instance.BackgroundColor3 = Color3.fromRGB(8, 24, 45)
        instance.BackgroundTransparency = 0.58
        instance.BorderSizePixel = 0
        instance.ClipsDescendants = true
        instance.ZIndex = 13
        instance.Parent = frame4
        createUICorner(instance, 9)
        addGradientStroke(instance, 1).Transparency = 0.5
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, -8, 0, 14)
            textLabel.Position = UDim2.new(0, 4, 0, 4)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = "Ice Hub"
            textLabel.TextColor3 = Color3.fromRGB(150, 205, 255)
            textLabel.TextSize = isMobile and 8 or 9
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextXAlignment = Enum.TextXAlignment.Left
            textLabel.ZIndex = 15
            textLabel.Parent = instance
        end
        if logoAsset then
            local imageLabel = Instance.new("ImageLabel")
            imageLabel.Size = UDim2.new(0, isMobile and 38 or 44, 0, isMobile and 38 or 44)
            imageLabel.AnchorPoint = Vector2.new(0.5, 0)
            imageLabel.Position = UDim2.new(0.5, 0, 0, isMobile and 17 or 18)
            imageLabel.BackgroundTransparency = 1
            imageLabel.Image = logoAsset
            imageLabel.ScaleType = Enum.ScaleType.Fit
            imageLabel.ZIndex = 15
            imageLabel.Parent = instance
        end
            local instance2 = Instance.new("TextLabel")
            instance2.Size = UDim2.new(1, -8, 0, 12)
            instance2.Position = UDim2.new(0, 4, 1, -14)
            instance2.BackgroundTransparency = 1
            instance2.Text = "https://discord.gg/TBBAUZu8cW"
            instance2.TextColor3 = appState.COL_DIM
            instance2.TextSize = isMobile and 6 or 8
            instance2.Font = Enum.Font.GothamBold
            instance2.TextXAlignment = Enum.TextXAlignment.Center
            instance2.TextTruncate = Enum.TextTruncate.AtEnd
            instance2.ZIndex = 15
            instance2.Parent = instance
        end
    end
end
stealerTab = appState.tabContents[1]
helperTab = appState.tabContents[2]
espTab = appState.tabContents[3]
playerTab = appState.tabContents[4]
worldTab = appState.tabContents[5]
uiTab = appState.tabContents[6]
serverTab = appState.tabContents[7]
createSectionHeader = function(parent, text)
    local instance = Instance.new("TextLabel")
    instance.Size = UDim2.new(1, 0, 0, isMobile and 28 or 32)
    instance.BackgroundTransparency = 1
    instance.Text = text
    instance.TextColor3 = appState.COL_WHITE
    instance.TextSize = isMobile and 14 or 12
    instance.Font = Enum.Font.GothamBold
    instance.TextXAlignment = Enum.TextXAlignment.Left
    instance.ZIndex = 12
    instance.LayoutOrder = #parent:GetChildren()
    instance.Parent = parent
    local instance2 = Instance.new("Frame")
    instance2.Size = UDim2.new(1, 0, 0, 1)
    instance2.Position = UDim2.new(0, 0, 1, -1)
    instance2.BackgroundColor3 = appState.COL_WHITE
    instance2.BorderSizePixel = 0
    instance2.ZIndex = 12
    instance2.Parent = instance
end
    local function createToggleRow(parent, text, enabled, callback617)
        local calculatedValue618 = isMobile and 42 or 36
        local frame3 = Instance.new("Frame")
        frame3.Size = UDim2.new(1, 0, 0, calculatedValue618)
        frame3.BackgroundColor3 = Color3.fromRGB(8, 27, 55)
        frame3.BackgroundTransparency = 0.42
        frame3.BorderSizePixel = 0
        frame3.ZIndex = 12
        frame3.LayoutOrder = #parent:GetChildren()
        frame3.Parent = parent
        createUICorner(frame3, 8)
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -60, 1, 0)
        textLabel.Position = UDim2.new(0, 10, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = text
        textLabel.TextColor3 = appState.COL_WHITE
        textLabel.TextSize = isMobile and 15 or 13
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.ZIndex = 13
        textLabel.Parent = frame3
        local calculatedValue621 = isMobile and 46 or 40
        local calculatedValue622 = isMobile and 24 or 20
        local calculatedValue623 = isMobile and 20 or 16
        local frame4 = Instance.new("Frame")
        frame4.Size = UDim2.new(0, calculatedValue621, 0, calculatedValue622)
        frame4.Position = UDim2.new(1, -calculatedValue621 - 8, 0.5, -calculatedValue622 / 2)
        frame4.BackgroundColor3 = Color3.fromRGB(28, 55, 88)
        frame4.BorderSizePixel = 0
        frame4.ZIndex = 13
        frame4.Parent = frame3
        createUICorner(frame4, calculatedValue622 / 2)
        local uiGradient = Instance.new("UIGradient")
        uiGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 55, 88)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 45, 88)),
        uiGradient.Parent = frame4
        local frame5 = Instance.new("Frame")
        frame5.Size = UDim2.new(0, calculatedValue623, 0, calculatedValue623)
        frame5.Position = enabled and UDim2.new(1, -calculatedValue623 - 2, 0.5, -calculatedValue623 / 2)
            or UDim2.new(0, 2, 0.5, -calculatedValue623 / 2)
        frame5.BackgroundColor3 = appState.COL_WHITE
        frame5.BorderSizePixel = 0
        frame5.ZIndex = 14
        frame5.Parent = frame4
        createUICorner(frame5, calculatedValue623 / 2)
        local function updateToggleVisuals(enabled)
            pcall(function()
                TweenService
                    :Create(frame5, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                        Position = enabled and UDim2.new(1, -calculatedValue623 - 2, 0.5, -calculatedValue623 / 2)
                            or UDim2.new(0, 2, 0.5, -calculatedValue623 / 2),
                        BackgroundColor3 = appState.COL_WHITE,
                    :Play()
            end)
            if enabled then
                uiGradient.Color = ColorSequence.new(appState.ACCENT_KEYS)
                table.insert(appState.allGradients, uiGradient)
            else
                uiGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 55, 88)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 45, 92)),
                for i, allGradient in ipairs(appState.allGradients) do
                    if allGradient == uiGradient then
                        table.remove(appState.allGradients, i)
                        break
                    end
                end
            end
        end
        updateToggleVisuals(enabled)
        local textButton2 = Instance.new("TextButton")
        textButton2.Size = UDim2.new(1, 0, 1, 0)
        textButton2.BackgroundTransparency = 1
        textButton2.Text = ""
        textButton2.ZIndex = 15
        textButton2.Parent = frame3
        textButton2.MouseButton1Click:Connect(function()
            enabled = not enabled
            updateToggleVisuals(enabled)
            if callback617 then
                callback617(enabled)
            end
        end)
        return frame3
    end
    createSavedToggle = function(parent, text, settingKey, callback642)
        return createToggleRow(parent, text, settings.toggles[settingKey] or false, function(enabled)
            settings.toggles[settingKey] = enabled
            saveSettings()
            if callback642 then
                callback642(enabled)
            end
        end)
    end
end
createToggle = function(parent, text, enabled, callback647)
    local calculatedValue648 = isMobile and 28 or 30
    local frame3 = Instance.new("Frame")
    frame3.Size = UDim2.new(1, -20, 0, calculatedValue648)
    frame3.BackgroundColor3 = Color3.fromRGB(8, 27, 55)
    frame3.BackgroundTransparency = 0.42
    frame3.BorderSizePixel = 0
    frame3.ZIndex = 11
    frame3.Parent = parent
    createUICorner(frame3, 6)
    local instance = Instance.new("TextLabel")
    instance.Size = UDim2.new(1, -50, 1, 0)
    instance.Position = UDim2.new(0, 8, 0, 0)
    instance.BackgroundTransparency = 1
    instance.Text = text
    instance.TextColor3 = appState.COL_WHITE
    instance.TextSize = isMobile and 12 or 12
    instance.Font = Enum.Font.GothamBold
    instance.TextXAlignment = Enum.TextXAlignment.Left
    instance.ZIndex = 12
    instance.Parent = frame3
    local calculatedValue651 = isMobile and 42 or 36
    local calculatedValue652 = isMobile and 22 or 18
    local calculatedValue653 = isMobile and 18 or 14
    local frame4 = Instance.new("Frame")
    frame4.Size = UDim2.new(0, calculatedValue651, 0, calculatedValue652)
    frame4.Position = UDim2.new(1, -calculatedValue651 - 6, 0.5, -calculatedValue652 / 2)
    frame4.BackgroundColor3 = Color3.fromRGB(28, 55, 88)
    frame4.BorderSizePixel = 0
    frame4.ZIndex = 12
    frame4.Parent = frame3
    createUICorner(frame4, calculatedValue652 / 2)
    local uiGradient = Instance.new("UIGradient")
    uiGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 55, 88)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 55, 92)),
    uiGradient.Parent = frame4
    local frame5 = Instance.new("Frame")
    frame5.Size = UDim2.new(0, calculatedValue653, 0, calculatedValue653)
    frame5.Position = enabled and UDim2.new(1, -calculatedValue653 - 2, 0.5, -calculatedValue653 / 2)
        or UDim2.new(0, 2, 0.5, -calculatedValue653 / 2)
    frame5.BackgroundColor3 = appState.COL_WHITE
    frame5.BorderSizePixel = 0
    frame5.ZIndex = 13
    frame5.Parent = frame4
    createUICorner(frame5, calculatedValue653 / 2)
    local isValid660 = enabled
    local function updateToggleVisuals(enabled)
        pcall(function()
            TweenService
                :Create(frame5, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                    Position = enabled and UDim2.new(1, -calculatedValue653 - 2, 0.5, -calculatedValue653 / 2)
                        or UDim2.new(0, 2, 0.5, -calculatedValue653 / 2),
                :Play()
        end)
        if enabled then
            uiGradient.Color = ColorSequence.new(appState.ACCENT_KEYS)
            table.insert(appState.allGradients, uiGradient)
        else
            uiGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 55, 88)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 45, 88)),
            for i, allGradient in ipairs(appState.allGradients) do
                if allGradient == uiGradient then
                    table.remove(appState.allGradients, i)
                    break
                end
            end
        end
        if callback647 then
            callback647(enabled)
        end
    end
    updateToggleVisuals(isValid660)
    local instance2 = Instance.new("TextButton")
    instance2.Size = UDim2.new(1, 0, 1, 0)
    instance2.BackgroundTransparency = 1
    instance2.Text = ""
    instance2.ZIndex = 12
    instance2.Parent = frame3
    instance2.MouseButton1Click:Connect(function()
        isValid660 = not isValid660
        updateToggleVisuals(isValid660)
    end)
    return frame3
end
createActionButton = function(parent, text, onClick)
    local frame3 = Instance.new("Frame")
    frame3.Size = UDim2.new(1, 0, 0, isMobile and 36 or 30)
    frame3.BackgroundColor3 = Color3.fromRGB(8, 27, 55)
    frame3.BackgroundTransparency = 0.42
    frame3.BorderSizePixel = 0
    frame3.ZIndex = 12
    frame3.LayoutOrder = #parent:GetChildren()
    frame3.Parent = parent
    createUICorner(frame3, 8)
    local instance = Instance.new("TextButton")
    instance.Size = UDim2.new(1, 0, 1, 0)
    instance.BackgroundTransparency = 1
    instance.Text = text
    instance.TextColor3 = appState.COL_WHITE
    instance.TextSize = isMobile and 14 or 12
    instance.Font = Enum.Font.GothamBold
    instance.ZIndex = 13
    instance.AutoButtonColor = false
    instance.Parent = frame3
    instance.MouseEnter:Connect(function()
        pcall(function()
            TweenService:Create(frame3, TweenInfo.new(0.1), {
                BackgroundTransparency = 0,
            }):Play()
        end)
    end)
    instance.MouseLeave:Connect(function()
        pcall(function()
            TweenService:Create(frame3, TweenInfo.new(0.1), {
                BackgroundTransparency = 0.2,
            }):Play()
        end)
    end)
    instance.MouseButton1Click:Connect(onClick)
    return frame3
end
createPanelContainer = function(panelTitle, panelId)
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Name = "ICE_HUB_PANEL_" .. tostring(panelId)
    scrollingFrame.Size = UDim2.new(1, 0, 0, 0)
    scrollingFrame.AutomaticSize = Enum.AutomaticSize.Y
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 0
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollingFrame.Visible = false
    scrollingFrame.Parent = nil
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.Padding = UDim.new(0, 6)
    uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListLayout.Parent = scrollingFrame
    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingTop = UDim.new(0, 6)
    uiPadding.PaddingBottom = UDim.new(0, 6)
    uiPadding.PaddingLeft = UDim.new(0, 0)
    uiPadding.PaddingRight = UDim.new(0, 0)
    uiPadding.Parent = scrollingFrame
    return nil, scrollingFrame, function() end, function() end
end
semiTeleportGui = Instance.new("ScreenGui")
semiTeleportGui.Name = "ICE_HUB_SEMITP_GUI"
semiTeleportGui:SetAttribute("IceHubOwned", true)
semiTeleportGui.ResetOnSpawn = false
semiTeleportGui.DisplayOrder = 1001
semiTeleportGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
attachGui(semiTeleportGui)
task.spawn(function()
    local calculatedValue680 = isMobile and 235 or 250
    local calculatedValue681 = isMobile and 305 or 320
    local frame3 = Instance.new("Frame")
    frame3.Name = "SemiTPWindow"
    frame3.Size = UDim2.new(0, calculatedValue680, 0, calculatedValue681)
    local udim2 = UDim2.new(0.02, 0, 0.5, -calculatedValue681 / 2)
    restorePanelPosition(frame3, "semiTp", udim2)
    frame3.BackgroundColor3 = Color3.fromRGB(6, 14, 31)
    frame3.BackgroundTransparency = 0.6
    frame3.BorderSizePixel = 0
    frame3.Active = true
    frame3.ZIndex = 20
    frame3.Parent = semiTeleportGui
    createUICorner(frame3, 16)
    addGradientStroke(frame3, 2)
    local uiGradient = Instance.new("UIGradient")
    local lookupTable686 = {}
    local colorKeypoint687 = ColorSequenceKeypoint.new(0, Color3.fromRGB(6, 14, 31))
    local colorKeypoint688 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(14, 31, 65))
    lookupTable686[1] = colorKeypoint687
    lookupTable686[2] = colorKeypoint688
    lookupTable686[3] = ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 12, 28))
    uiGradient.Color = ColorSequence.new(lookupTable686)
    uiGradient.Rotation = 135
    uiGradient.Parent = frame3
    local frame4 = Instance.new("Frame")
    frame4.Size = UDim2.new(1, 0, 0, 42)
    frame4.BackgroundColor3 = Color3.fromRGB(10, 27, 55)
    frame4.BackgroundTransparency = 1
    frame4.BorderSizePixel = 0
    frame4.ZIndex = 21
    frame4.Parent = frame3
    createUICorner(frame4, 16)
    local frame5 = Instance.new("Frame")
    frame5.Size = UDim2.new(1, 0, 0, 16)
    frame5.Position = UDim2.new(0, 0, 1, -16)
    frame5.BackgroundColor3 = Color3.fromRGB(10, 27, 55)
    frame5.BackgroundTransparency = 1
    frame5.BorderSizePixel = 0
    frame5.ZIndex = 21
    frame5.Parent = frame4
    if logoAsset then
        local imageLabel = Instance.new("ImageLabel")
        imageLabel.Size = UDim2.new(0, 28, 0, 28)
        imageLabel.Position = UDim2.new(0, 8, 0.5, -14)
        imageLabel.BackgroundTransparency = 1
        imageLabel.Image = logoAsset
        imageLabel.ScaleType = Enum.ScaleType.Fit
        imageLabel.ZIndex = 24
        imageLabel.Parent = frame4
    end
    local instance = Instance.new("TextLabel")
    instance.Size = UDim2.new(1, -74, 1, 0)
    instance.Position = UDim2.new(0, 42, 0, 0)
    instance.BackgroundTransparency = 1
    instance.Text = "Ice Hub - Semi TP"
    instance.TextColor3 = appState.COL_WHITE
    instance.TextSize = isMobile and 13 or 15
    instance.Font = Enum.Font.GothamBlack
    instance.TextXAlignment = Enum.TextXAlignment.Left
    instance.ZIndex = 22
    instance.Parent = frame4
    local textButton2 = Instance.new("TextButton")
    textButton2.Size = UDim2.new(0, 26, 0, 26)
    textButton2.Position = UDim2.new(1, -32, 0.5, -13)
    textButton2.BackgroundColor3 = Color3.fromRGB(14, 43, 82)
    textButton2.BackgroundTransparency = 0.15
    textButton2.BorderSizePixel = 0
    textButton2.Text = "−"
    textButton2.TextColor3 = appState.COL_WHITE
    textButton2.TextSize = 16
    textButton2.Font = Enum.Font.GothamBlack
    textButton2.ZIndex = 23
    textButton2.Parent = frame4
    createUICorner(textButton2, 7)
    addGradientStroke(textButton2, 1)
    local instance2 = Instance.new("ScrollingFrame")
    instance2.Size = UDim2.new(1, -18, 1, -54)
    instance2.Position = UDim2.new(0, 9, 0, 54)
    instance2.BackgroundTransparency = 1
    instance2.BorderSizePixel = 0
    instance2.ScrollBarThickness = 3
    instance2.ScrollBarImageColor3 = Color3.fromRGB(110, 195, 255)
    instance2.CanvasSize = UDim2.new(0, 0, 0, 0)
    instance2.AutomaticCanvasSize = Enum.AutomaticSize.Y
    instance2.ZIndex = 21
    instance2.Parent = frame3
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.Padding = UDim.new(0, 7)
    uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListLayout.Parent = instance2
    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingTop = UDim.new(0, 3)
    uiPadding.PaddingBottom = UDim.new(0, 5)
    uiPadding.Parent = instance2
    appState.epFrame = frame3
    appState.epContent = instance2
    local windowHeight = calculatedValue681
    local isActive702 = false
    appState.openExecutePanel = function()
        frame3.Visible = true
        isActive702 = false
        instance2.Visible = true
        TweenService:Create(frame3, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, calculatedValue680, 0, windowHeight),
        }):Play()
    end
    appState.closeExecutePanel = function()
        frame3.Visible = false
    end
    textButton2.MouseButton1Click:Connect(function()
        isActive702 = not isActive702
        instance2.Visible = not isActive702
        textButton2.Text = isActive702 and "+" or "−"
        TweenService:Create(frame3, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = isActive702 and UDim2.new(0, calculatedValue680, 0, 42)
                or UDim2.new(0, calculatedValue680, 0, windowHeight),
        }):Play()
    end)
    makeDraggable(frame3, frame4, "semiTp")
    local frame6 = Instance.new("Frame")
    frame6.Size = UDim2.new(1, -4, 0, isMobile and 42 or 44)
    frame6.BackgroundColor3 = Color3.fromRGB(10, 20, 60)
    frame6.BackgroundTransparency = 0.45
    frame6.BorderSizePixel = 0
    frame6.ZIndex = 22
    frame6.Parent = instance2
    createUICorner(frame6, 9)
    addGradientStroke(frame6, 2)
    local textButton3 = Instance.new("TextButton")
    textButton3.Size = UDim2.new(1, 0, 1, 0)
    textButton3.BackgroundTransparency = 1
    textButton3.Text = "▶ DO INSTANT STEAL"
    textButton3.TextColor3 = appState.COL_WHITE
    textButton3.TextSize = isMobile and 14 or 13
    textButton3.Font = Enum.Font.GothamBlack
    textButton3.ZIndex = 23
    textButton3.AutoButtonColor = false
    textButton3.Parent = frame6
    textButton3.MouseButton1Click:Connect(function()
        task.spawn(runSemiTeleport)
    end)
    local frame7 = Instance.new("Frame")
    frame7.Size = UDim2.new(1, -4, 0, isMobile and 36 or 32)
    frame7.BackgroundColor3 = Color3.fromRGB(12, 27, 52)
    frame7.BackgroundTransparency = 0.55
    frame7.BorderSizePixel = 0
    frame7.ZIndex = 22
    frame7.Parent = instance2
    createUICorner(frame7, 8)
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0.52, 0, 1, 0)
    textLabel.Position = UDim2.new(0, 10, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "SELECT SLOT"
    textLabel.TextColor3 = appState.COL_DIM
    textLabel.TextSize = isMobile and 12 or 11
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.ZIndex = 23
    textLabel.Parent = frame7
    local textButton4 = Instance.new("TextButton")
    textButton4.Size = UDim2.new(0, 74, 0, 22)
    textButton4.Position = UDim2.new(1, -8, 0.5, 0)
    textButton4.AnchorPoint = Vector2.new(1, 0.5)
    textButton4.BackgroundColor3 = Color3.fromRGB(9, 32, 67)
    textButton4.BackgroundTransparency = 0.38
    textButton4.BorderSizePixel = 0
    textButton4.Text = "Slot " .. tostring(selectedSlot)
    textButton4.Font = Enum.Font.GothamBold
    textButton4.TextSize = 11
    textButton4.TextColor3 = appState.COL_WHITE
    textButton4.AutoButtonColor = false
    textButton4.ZIndex = 23
    textButton4.Parent = frame7
    createUICorner(textButton4, 6)
    addGradientStroke(textButton4, 1)
    textButton4.MouseButton1Click:Connect(function()
        semiTeleportState.setSlot(selectedSlot == 1 and 2 or 1)
        textButton4.Text = "Slot " .. tostring(selectedSlot)
    end)
    local frame8 = Instance.new("Frame")
    frame8.Size = UDim2.new(1, -4, 0, isMobile and 36 or 32)
    frame8.BackgroundColor3 = Color3.fromRGB(12, 27, 52)
    frame8.BackgroundTransparency = 0.55
    frame8.BorderSizePixel = 0
    frame8.ZIndex = 22
    frame8.Parent = instance2
    createUICorner(frame8, 8)
    local instance3 = Instance.new("TextLabel")
    instance3.Size = UDim2.new(0.52, 0, 1, 0)
    instance3.Position = UDim2.new(0, 10, 0, 0)
    instance3.BackgroundTransparency = 1
    instance3.Text = "STEAL KEY"
    instance3.TextColor3 = appState.COL_DIM
    instance3.TextSize = isMobile and 12 or 11
    instance3.Font = Enum.Font.GothamBold
    instance3.TextXAlignment = Enum.TextXAlignment.Left
    instance3.ZIndex = 23
    instance3.Parent = frame8
    local textButton5 = Instance.new("TextButton")
    textButton5.Size = UDim2.new(0, 74, 0, 24)
    textButton5.Position = UDim2.new(1, -8, 0.5, 0)
    textButton5.AnchorPoint = Vector2.new(1, 0.5)
    textButton5.BackgroundColor3 = Color3.fromRGB(9, 32, 67)
    textButton5.BackgroundTransparency = 0.38
    textButton5.BorderSizePixel = 0
    textButton5.Text = "[ " .. semiTeleportSettings.stealKey .. " ]"
    textButton5.Font = Enum.Font.GothamBold
    textButton5.TextSize = 11
    textButton5.TextColor3 = appState.COL_WHITE
    textButton5.AutoButtonColor = false
    textButton5.ZIndex = 23
    textButton5.Parent = frame8
    createUICorner(textButton5, 6)
    addGradientStroke(textButton5, 1)
    local isActive711 = false
    textButton5.MouseButton1Click:Connect(function()
        if isActive711 then
            return
        end
        isActive711 = true
        textButton5.Text = "[ ... ]"
        local connection = nil
        connection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local stealKey = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                semiTeleportSettings.stealKey = stealKey
                settings.semitp.stealKey = stealKey
                isActive711 = false
                textButton5.Text = "[ " .. stealKey .. " ]"
                saveSettings()
                connection:Disconnect()
            end
        end)
        task.delay(5, function()
            if isActive711 then
                isActive711 = false
                textButton5.Text = "[ " .. semiTeleportSettings.stealKey .. " ]"
                if connection then
                    connection:Disconnect()
                end
            end
        end)
    end)
    local autoPotion = createToggle(instance2, "Auto Potion", semiTeleportSettings.autoPotion, function(autoPotion)
        semiTeleportSettings.autoPotion = autoPotion
        settings.semitp.autoPotion = autoPotion
        saveSettings()
    end)
    if autoPotion then
        autoPotion.BackgroundTransparency = 0.58
    end
    local createToggleResult718 = createToggle(instance2, "Auto Walk", semiTeleportSettings.autoWalk, function(autoWalk)
        semiTeleportSettings.autoWalk = autoWalk
        settings.semitp.autoWalk = autoWalk
        if not autoWalk then
            stopAutoWalk()
        end
        saveSettings()
    end)
    if createToggleResult718 then
        createToggleResult718.BackgroundTransparency = 0.58
    end
    local retryIfStealFails = createToggle(
        function(autoRetrySteal)
            semiTeleportSettings.autoRetrySteal = autoRetrySteal
            settings.semitp.autoRetrySteal = autoRetrySteal
            saveSettings()
        end
    if retryIfStealFails then
        retryIfStealFails.BackgroundTransparency = 0.58
    end
    local autoSemiOnTimer = createToggle(
        function(autoSemiOnTimer)
            semiTeleportSettings.autoSemiOnTimer = autoSemiOnTimer
            settings.semitp.autoSemiOnTimer = autoSemiOnTimer
            saveSettings()
        end
    if autoSemiOnTimer then
        autoSemiOnTimer.BackgroundTransparency = 0.58
    end
    createToggle(instance2, "Auto Semi On Friends", semiTeleportSettings.autoSemiOnFriends, function(autoSemiOnFriends)
        semiTeleportSettings.autoSemiOnFriends = autoSemiOnFriends
        settings.semitp.autoSemiOnFriends = autoSemiOnFriends
        saveSettings()
    end)
    local autoAdminSpam = createToggle(
        function(autoAdminSpam)
            semiTeleportSettings.autoAdminSpam = autoAdminSpam
            settings.semitp.autoAdminSpam = autoAdminSpam
            saveSettings()
        end
    if autoAdminSpam then
        autoAdminSpam.BackgroundTransparency = 0.58
    end
    task.spawn(function()
        local iceHubFriendToken = (getgenv().ICE_HUB_FRIEND_TOKEN or 0) + 1
        getgenv().ICE_HUB_FRIEND_TOKEN = iceHubFriendToken
        local lookupTable728 = {}
        local instance729 = nil
        local lookupTable732 = {
            hold = {},
            trigger = {},
        local isValid733 = nil
        local friendPrompt = nil
        local parent = nil
        local claimPartCache = setmetatable({}, {
            __mode = "k",
        local promptCache = setmetatable({}, {
            __mode = "k",
        local ownerLabelCache = setmetatable({}, {
            __mode = "kv",
        local friendStateElementCache = setmetatable({}, {
            __mode = "kv",
        local friendStateCache = setmetatable({}, {
            __mode = "k",
        local promptConnectionSets = setmetatable({}, {
            __mode = "k",
        local function isFriendPanelActive()
            return getgenv().ICE_HUB_FRIEND_TOKEN == iceHubFriendToken
        end
        local function findPlots743()
            return workspaceService:FindFirstChild("Plots")
        end
        local function resolvePlayerName(playerLabel, allowPlainName)
            local gsubResult747 = tostring(playerLabel or ""):gsub("^%s+", ""):gsub("%s+$", "")
            if gsubResult747 == "" then
                return nil
            end
            local lowerResult748 = gsubResult747:lower()
                lowerResult748 == "empty base"
                or lowerResult748 == "your base"
                or lowerResult748 == "base"
                or lowerResult748:find("friends:", 1, true)
                or lowerResult748 == "toggle"
                or lowerResult748 == "allow friends"
                or lowerResult748 == "disallow friends"
            then
                return nil
            end
            local match = gsubResult747:match("^(.-)'s [Bb]ase$")
            if not match then
                if not allowPlainName then
                    return nil
                end
                match = gsubResult747
            end
            local gsubResult750 = match:gsub("^%s+", ""):gsub("%s+$", "")
            if gsubResult750 == "" then
                return nil
            end
            local lowerResult751 = gsubResult750:lower()
            if lowerResult751 == "your base" or lowerResult751 == "empty base" then
                return nil
            end
            if #gsubResult750 == 36 and gsubResult750:match("^[%x%-]+$") then
                return nil
            end
            for _, player in ipairs(playersService:GetPlayers()) do
                if player.Name:lower() == lowerResult751 or player.DisplayName:lower() == lowerResult751 then
                    return player.Name
                end
            end
            return gsubResult750
        end
        local function readTextElement(textElement755)
            local isValid756 = not textElement755
            if not isValid756 then
                isValid756 = not (textElement755:IsA("TextLabel") or textElement755:IsA("TextButton"))
            end
            if isValid756 then
                return nil
            end
            return resolvePlayerName(textElement755.Text, false)
        end
        local function findPlotSign757(instance758)
            if not instance758 then
                return nil
            end
            local plotSign = instance758:FindFirstChild("PlotSign")
            if plotSign then
                local instance760 = ownerLabelCache[instance758]
                if instance760 and instance760.Parent and instance760:IsDescendantOf(plotSign) then
                    local readTextElementResult761 = readTextElement(instance760)
                    if readTextElementResult761 then
                        return readTextElementResult761
                    end
                end
                local surfaceGui = plotSign:FindFirstChild("SurfaceGui")
                surfaceGui = surfaceGui and surfaceGui:FindFirstChild("Frame")
                surfaceGui = surfaceGui and surfaceGui:FindFirstChild("TextLabel")
                if readTextElementResult763 then
                    ownerLabelCache[instance758] = surfaceGui
                    return readTextElementResult763
                end
                for _, descendant in ipairs(plotSign:GetDescendants()) do
                    if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                        local readTextElementResult766 = readTextElement(descendant)
                        if readTextElementResult766 then
                            ownerLabelCache[instance758] = descendant
                            return readTextElementResult766
                        end
                    end
                end
            end
            for _, getAttributeState768 in ipairs({
                instance758:FindFirstChild("Claim"),
            }) do
                if getAttributeState768 then
                    for _, item770 in ipairs({
                    }) do
                        local attribute = getAttributeState768:GetAttribute(item770)
                        if type(attribute) == "string" and attribute ~= "" then
                            local resolvePlayerNameResult772 = resolvePlayerName(attribute, true)
                            if resolvePlayerNameResult772 then
                                return resolvePlayerNameResult772
                            end
                        end
                    end
                    for _, item774 in ipairs({
                    }) do
                        local num = tonumber(getAttributeState768:GetAttribute(item774))
                        if num then
                            local playerByUserId = playersService:GetPlayerByUserId(num)
                            if playerByUserId then
                                return playerByUserId.Name
                            end
                        end
                    end
                end
            end
            return nil
        end
        local function findPlotSign777(instance778)
            if not instance778 then
                return false
            end
            local plotSign = instance778:FindFirstChild("PlotSign")
            plotSign = plotSign and plotSign:FindFirstChild("YourBase", true)
            if plotSign and plotSign:IsA("BillboardGui") and plotSign.Enabled then
                return true
            end
            local findPlotSign757Result780 = findPlotSign757(instance778)
            if not findPlotSign757Result780 then
                return false
            end
            local lowerResult781 = findPlotSign757Result780:lower()
            return lowerResult781 == localPlayer.Name:lower() or lowerResult781 == localPlayer.DisplayName:lower()
        end
        local function getPlotOwnerName(plot)
            if findPlotSign777(plot) then
                return localPlayer.Name
            end
            return findPlotSign757(plot) or "..."
        end
        local function findClaim784(instance785)
            if not instance785 then
                return nil
            end
            local instance786 = claimPartCache[instance785]
            if instance786 and instance786.Parent then
                return instance786
            end
            local foundClaim787 = instance785:FindFirstChild("Claim")
            if not foundClaim787 then
                return nil
            end
            local main = foundClaim787:FindFirstChild("Main")
            if main then
                claimPartCache[instance785] = main
            end
            return main
        end
        local function findProximityPrompt789(index790)
            if not index790 then
                return nil
            end
            local instance791 = promptCache[index790]
            if instance791 and instance791.Parent then
                return instance791
            end
            local findClaim784Result792 = findClaim784(index790)
            if not findClaim784Result792 then
                return nil
            end
            local proximityPrompt = findClaim784Result792:FindFirstChild("ProximityPrompt")
            if proximityPrompt and proximityPrompt:IsA("ProximityPrompt") then
                promptCache[index790] = proximityPrompt
                return proximityPrompt
            end
            return nil
        end
        local function readPromptFriendState(actionTextState795)
            if not actionTextState795 then
                return nil
            end
            local lowerResult796 = (tostring(actionTextState795.ActionText or "") .. " " .. tostring(
                actionTextState795.ObjectText or ""
            )):lower()
            if lowerResult796:find("disallow friends", 1, true) or lowerResult796:find("friends on", 1, true) then
                return true
            end
            if lowerResult796:find("allow friends", 1, true) or lowerResult796:find("friends off", 1, true) then
                return false
            end
            return nil
        end
        local function collectFriendPromptCallbacks(instance798)
            if not instance798 or not instance798:IsA("ProximityPrompt") then
                return
            end
            local readPromptFriendStateResult799 = readPromptFriendState(instance798)
            if readPromptFriendStateResult799 ~= nil then
                isValid733 = readPromptFriendStateResult799
            end
            if type(getconnections) ~= "function" then
                return
            end
            local lookupTable800 = {
                hold = {},
                trigger = {},
            local ok, result = pcall(getconnections, instance798.PromptButtonHoldBegan)
            if ok and type(result) == "table" then
                for _, functionState804 in ipairs(result) do
                    if type(functionState804.Function) == "function" then
                        table.insert(lookupTable800.hold, functionState804.Function)
                    end
                end
            end
            local ok2, result2 = pcall(getconnections, instance798.Triggered)
            if ok2 and type(result2) == "table" then
                for _, functionState809 in ipairs(result2) do
                    if type(functionState809.Function) == "function" then
                        table.insert(lookupTable800.trigger, functionState809.Function)
                    end
                end
            end
            if #lookupTable800.hold > 0 or #lookupTable800.trigger > 0 then
                lookupTable732 = lookupTable800
            end
        end
        local function configureFriendPrompt(instance811)
            if not instance811 or not instance811:IsA("ProximityPrompt") then
                return
            end
            collectFriendPromptCallbacks(instance811)
            friendPrompt = instance811
            parent = instance811.Parent or parent
            pcall(function()
                instance811.Style = Enum.ProximityPromptStyle.Custom
                instance811.RequiresLineOfSight = false
                instance811.MaxActivationDistance = math.huge
                instance811.HoldDuration = 0
                instance811.UIOffset = Vector2.new(100000, 100000)
                instance811.Enabled = true
            end)
        end
        local function hideFriendPrompt(instance813)
            if not instance813 or not instance813:IsA("ProximityPrompt") then
                return
            end
            pcall(function()
                instance813.Style = Enum.ProximityPromptStyle.Custom
                instance813.RequiresLineOfSight = false
                instance813.MaxActivationDistance = math.huge
                instance813.UIOffset = Vector2.new(100000, 100000)
            end)
        end
        local function parseBooleanState(text815)
            if type(text815) == "boolean" then
                return text815
            end
            if type(text815) == "number" then
                return text815 ~= 0
            end
            if type(text815) == "string" then
                local gsubResult817 = text815:lower():gsub("^%s+", ""):gsub("%s+$", "")
                local gsubResult818 = gsubResult817:gsub("%s+", "")
                    gsubResult818 == "true"
                    or gsubResult818 == "on"
                    or gsubResult818 == "allow"
                    or gsubResult818 == "enabled"
                    or gsubResult818 == "yes"
                    or gsubResult818 == "1"
                then
                    return true
                end
                    gsubResult818 == "false"
                    or gsubResult818 == "off"
                    or gsubResult818 == "disabled"
                    or gsubResult818 == "deny"
                    or gsubResult818 == "denied"
                    or gsubResult818 == "0"
                then
                    return false
                end
                    gsubResult817:find("disallow", 1, true)
                    or gsubResult817:find("disable friend", 1, true)
                    or gsubResult817:find("friends on", 1, true)
                then
                    return true
                end
                    gsubResult817:find("allow friends", 1, true)
                    or gsubResult817:find("enable friend", 1, true)
                    or gsubResult817:find("friends off", 1, true)
                then
                    return false
                end
            end
            return nil
        end
        local function isGreenColor(color)
            return color and color.G > color.R + 0.12 and color.G > color.B - 0.05
        end
        local function isRedColor(color)
            return color and color.R > color.G + 0.12 and color.R > color.B + 0.02
        end
        local function inferFriendState(textElement824)
            if not textElement824 or not textElement824.Parent then
                return nil
            end
                textElement824:IsA("BoolValue")
                or textElement824:IsA("StringValue")
                or textElement824:IsA("IntValue")
                or textElement824:IsA("NumberValue")
            then
                return parseBooleanState(textElement824.Value)
            end
            if textElement824:IsA("TextLabel") or textElement824:IsA("TextButton") or textElement824:IsA("TextBox") then
                local parseBooleanStateResult825 = parseBooleanState(textElement824.Text)
                if parseBooleanStateResult825 ~= nil then
                    return parseBooleanStateResult825
                end
            end
            local lookupTable826 = {}
            if textElement824:IsA("BasePart") then
                table.insert(lookupTable826, textElement824.Color)
            elseif textElement824:IsA("ImageLabel") or textElement824:IsA("ImageButton") then
                table.insert(lookupTable826, textElement824.ImageColor3)
                table.insert(lookupTable826, textElement824.BackgroundColor3)
            elseif
                textElement824:IsA("TextLabel")
                or textElement824:IsA("TextButton")
                or textElement824:IsA("TextBox")
            then
                table.insert(lookupTable826, textElement824.TextColor3)
                table.insert(lookupTable826, textElement824.BackgroundColor3)
            elseif textElement824:IsA("Frame") then
                table.insert(lookupTable826, textElement824.BackgroundColor3)
            elseif textElement824:IsA("UIStroke") then
                table.insert(lookupTable826, textElement824.Color)
            end
            for _, item828 in ipairs(lookupTable826) do
                if isGreenColor(item828) then
                    return true
                end
                if isRedColor(item828) then
                    return false
                end
            end
            return nil
        end
        local function cacheFriendState(plot, friendState)
            if plot and friendState ~= nil then
                friendStateCache[plot] = friendState
                if findPlotSign777(plot) then
                    isValid733 = friendState
                end
            end
            return friendState
        end
        local function findFriendStateIndicator(plot, container, fallbackContainer)
            if not container then
                return nil, nil
            end
            local primaryIndicator = nil
            local fallbackIndicator = nil
            for _, descendant in ipairs(container:GetDescendants()) do
                local lowerResult840 = tostring(descendant.Name or ""):lower()
                local pos = lowerResult840:find("friend", 1, true)
                local pos2
                if pos then
                    pos2 = lowerResult840:find("status", 1, true)
                        or lowerResult840:find("state", 1, true)
                        or lowerResult840:find("enabled", 1, true)
                        or lowerResult840:find("enabled", 1, true)
                        or lowerResult840:find("toggle", 1, true)
                else
                    pos2 = pos
                end
                    or lowerResult840 == "friends"
                    or lowerResult840 == "allowfriends"
                    or lowerResult840 == "friendsenabled"
                then
                        descendant:IsA("BoolValue")
                        or descendant:IsA("StringValue")
                        or descendant:IsA("IntValue")
                        or descendant:IsA("NumberValue")
                    then
                        local inferFriendStateResult843 = inferFriendState(descendant)
                        if inferFriendStateResult843 ~= nil then
                            friendStateElementCache[plot] = descendant
                            return descendant, inferFriendStateResult843
                        end
                    elseif descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
                        local lowerResult844 = tostring(descendant.Text or ""):lower()
                            lowerResult844:find("friend", 1, true)
                            or lowerResult844:find("enabled", 1, true)
                            or lowerResult844:find("disallow", 1, true)
                            or lowerResult844 == "on"
                            or lowerResult844 == "off"
                        then
                            local inferFriendStateResult845 = inferFriendState(descendant)
                            if inferFriendStateResult845 ~= nil then
                                friendStateElementCache[plot] = descendant
                                return descendant, inferFriendStateResult845
                            end
                        end
                    elseif
                        not primaryIndicator
                        and (lowerResult840:find("indicator", 1, true) or lowerResult840:find("light", 1, true))
                        and (descendant:IsA("BasePart") or descendant:IsA("GuiObject") or descendant:IsA("UIStroke"))
                    then
                        primaryIndicator = descendant
                    end
                end
                local isValid846 = not fallbackIndicator
                if isValid846 then
                    isValid846 = lowerResult840:find("icon", 1, true)
                        or lowerResult840:find("indicator", 1, true)
                        or lowerResult840:find("people", 1, true)
                        or lowerResult840:find("person", 1, true)
                        or lowerResult840:find("friend", 1, true)
                end
                if isValid846 then
                    if descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") or descendant:IsA("UIStroke") then
                        if inferFriendState(descendant) ~= nil then
                            fallbackIndicator = descendant
                        end
                    end
                end
            end
            if primaryIndicator then
                local inferFriendStateResult847 = inferFriendState(primaryIndicator)
                if inferFriendStateResult847 ~= nil then
                    friendStateElementCache[plot] = primaryIndicator
                    return primaryIndicator, inferFriendStateResult847
                end
            end
            if fallbackIndicator then
                local inferFriendStateResult848 = inferFriendState(fallbackIndicator)
                if inferFriendStateResult848 ~= nil then
                    friendStateElementCache[plot] = fallbackIndicator
                    return fallbackIndicator, inferFriendStateResult848
                end
            end
            for _, instance850 in ipairs({
            }) do
                if instance850 then
                    for _, descendant in ipairs(instance850:GetDescendants()) do
                        if descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
                            local inferFriendStateResult853 = inferFriendState(descendant)
                            if inferFriendStateResult853 ~= nil then
                                friendStateElementCache[plot] = descendant
                                return descendant, inferFriendStateResult853
                            end
                        end
                    end
                end
            end
            return nil, nil
        end
        local function findFriendPanel854(instance855)
            if not instance855 then
                return nil
            end
            if findPlotSign777(instance855) and isValid733 ~= nil then
                return cacheFriendState(instance855, isValid733)
            end
            local findProximityPrompt789Result856 = findProximityPrompt789(instance855)
            local findClaim784Result857 = findClaim784(instance855)
            local friendPanel = instance855:FindFirstChild("FriendPanel")
            if not findClaim784Result857 then
                return friendStateCache[instance855]
            end
            local textOptions859 = {
            for _, getAttributeState861 in ipairs({
            }) do
                if getAttributeState861 then
                    for _, item863 in ipairs(textOptions859) do
                        local attribute = getAttributeState861:GetAttribute(item863)
                        if attribute ~= nil then
                            local parseBooleanStateResult865 = parseBooleanState(attribute)
                            if parseBooleanStateResult865 ~= nil then
                                return cacheFriendState(instance855, parseBooleanStateResult865)
                            end
                        end
                    end
                end
            end
            if findProximityPrompt789Result856 then
                local readPromptFriendStateResult866 = readPromptFriendState(findProximityPrompt789Result856)
                if readPromptFriendStateResult866 ~= nil then
                    return cacheFriendState(instance855, readPromptFriendStateResult866)
                end
            end
            local instance867 = friendStateElementCache[instance855]
            if instance867 and instance867.Parent then
                local inferFriendStateResult868 = inferFriendState(instance867)
                if inferFriendStateResult868 ~= nil then
                    return cacheFriendState(instance855, inferFriendStateResult868)
                end
            end
            local findFriendStateIndicatorResult869, findFriendStateIndicatorResult870 =
                findFriendStateIndicator(instance855, friendPanel, findClaim784Result857)
            if findFriendStateIndicatorResult870 ~= nil then
                return cacheFriendState(instance855, findFriendStateIndicatorResult870)
            end
            return friendStateCache[instance855]
        end
        local function findLocalPlot()
            if instance729 and instance729.Parent then
                return instance729
            end
            local findPlots743Result872 = findPlots743()
            if not findPlots743Result872 then
                return nil
            end
            for _, child in ipairs(findPlots743Result872:GetChildren()) do
                if child:IsA("Model") and findPlotSign777(child) then
                    instance729 = child
                    return child
                end
            end
            return nil
        end
        local callback875 = nil
        local function triggerProximityPrompt876()
            local findLocalPlotResult877 = findLocalPlot()
            if not findLocalPlotResult877 then
                return false
            end
            local findClaim784Result878 = findClaim784(findLocalPlotResult877)
            local instance879 = friendPrompt
            if not instance879 or typeof(instance879) ~= "Instance" then
                instance879 = findProximityPrompt789(findLocalPlotResult877)
            end
            if not instance879 or not instance879:IsA("ProximityPrompt") then
                return false
            end
            collectFriendPromptCallbacks(instance879)
            local promptParent = parent
            local parent881
            if parent then
                parent881 = promptParent
            else
                parent881 = findClaim784Result878
            end
            if not parent881 then
                return false
            end
            local currentFriendState = isValid733
            if currentFriendState == nil then
                currentFriendState = readPromptFriendState(instance879)
            end
            if currentFriendState ~= nil then
                cacheFriendState(findLocalPlotResult877, currentFriendState)
            end
                not pcall(function()
                    instance879.Style = Enum.ProximityPromptStyle.Custom
                    instance879.Enabled = true
                    instance879.HoldDuration = 0
                    instance879.MaxActivationDistance = math.huge
                    instance879.RequiresLineOfSight = false
                    instance879.UIOffset = Vector2.new(100000, 100000)
                    instance879.Parent = parent881
                end)
            then
                return false
            end
            local isActive883 = false
            if type(fireproximityprompt) == "function" then
                isActive883 = pcall(function()
                    fireproximityprompt(instance879, 0)
                end) or pcall(function()
                    fireproximityprompt(instance879)
                end)
            end
            if not isActive883 and type(getconnections) == "function" then
                local callback884 = ipairs
                local hold = lookupTable732.hold or {}
                for _, item887 in callback884(hold) do
                    task.spawn(function()
                        pcall(item887, localPlayer)
                    end)
                    isActive883 = true
                end
                if isActive883 then
                    task.wait(0.02)
                end
                local callback888 = ipairs
                local trigger = lookupTable732.trigger or {}
                for _, item891 in callback888(trigger) do
                    task.spawn(function()
                        pcall(item891, localPlayer)
                    end)
                    isActive883 = true
                end
            end
            local calculatedValue892 = tick() + 0.45
            local readPromptFriendStateResult893
            while true do
                readPromptFriendStateResult893 = readPromptFriendState(instance879)
                    not (
                        currentFriendState ~= nil
                        and readPromptFriendStateResult893 ~= nil
                        and readPromptFriendStateResult893 ~= currentFriendState
                then
                    task.wait(0.03)
                    if not (tick() >= calculatedValue892) then
                    end
                end
                break
            end
                currentFriendState ~= nil
                and readPromptFriendStateResult893 ~= nil
                and readPromptFriendStateResult893 ~= currentFriendState
            then
                isValid733 = readPromptFriendStateResult893
            elseif isActive883 and currentFriendState ~= nil then
                isValid733 = not currentFriendState
            elseif readPromptFriendStateResult893 ~= nil then
                isValid733 = readPromptFriendStateResult893
            end
            if isValid733 ~= nil then
                cacheFriendState(findLocalPlotResult877, isValid733)
            end
            configureFriendPrompt(instance879)
            if lookupTable728[findLocalPlotResult877] then
                callback875(findLocalPlotResult877)
            end
            return isActive883
        end
        local function findBasePart894(plot)
            local findClaim784Result896 = findClaim784(plot)
            if not findClaim784Result896 then
                return nil
            end
            if findClaim784Result896:IsA("BasePart") or findClaim784Result896:IsA("Attachment") then
                return findClaim784Result896
            end
            if findClaim784Result896:IsA("Model") then
                return findClaim784Result896.PrimaryPart
                    or findClaim784Result896:FindFirstChildWhichIsA("BasePart", true)
            end
            return findClaim784Result896:FindFirstAncestorWhichIsA("BasePart")
        end
        local function removeFriendBillboard(index898)
            local guiState899 = lookupTable728[index898]
            if guiState899 and guiState899.gui then
                pcall(function()
                    guiState899.gui:Destroy()
                    return
                end)
            end
            lookupTable728[index898] = nil
        end
        callback875 = function(index900)
            local guiState901 = lookupTable728[index900]
            if not guiState901 then
                return
            end
            local adornee902 = findBasePart894(index900)
            if not adornee902 then
                removeFriendBillboard(index900)
                return
            end
            if guiState901.gui.Adornee ~= adornee902 then
                guiState901.gui.Adornee = adornee902
                guiState901.gui.Parent = adornee902
            end
            guiState901.owner.Text = getPlotOwnerName(index900)
            local findFriendPanel854Result903 = findFriendPanel854(index900)
            if findFriendPanel854Result903 == true then
                guiState901.status.Text = "FRIENDS: ON"
                guiState901.status.TextColor3 = Color3.fromRGB(70, 255, 135)
                guiState901.stroke.Color = Color3.fromRGB(70, 255, 135)
            elseif findFriendPanel854Result903 == false then
                guiState901.status.Text = "FRIENDS: OFF"
                guiState901.status.TextColor3 = Color3.fromRGB(255, 80, 80)
                guiState901.stroke.Color = Color3.fromRGB(255, 80, 80)
            else
                guiState901.status.Text = "FRIENDS: ..."
                guiState901.status.TextColor3 = Color3.fromRGB(150, 205, 255)
                guiState901.stroke.Color = Color3.fromRGB(90, 165, 255)
            end
        end
        local function createBillboardGui904(index905)
            if lookupTable728[index905] then
                return
            end
            local adornee906 = findBasePart894(index905)
            if not adornee906 then
                return
            end
            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Name = "ICE_HUB_FRIEND_BASE_ESP"
            billboardGui.Size = UDim2.new(0, 190, 0, 45)
            billboardGui.StudsOffset = Vector3.new(0, 3.1, 0)
            billboardGui.AlwaysOnTop = true
            billboardGui.LightInfluence = 0
            billboardGui.MaxDistance = 100000
            billboardGui.Adornee = adornee906
            billboardGui.Parent = adornee906
            local frame9 = Instance.new("Frame")
            frame9.Size = UDim2.new(1, 0, 1, 0)
            frame9.BackgroundColor3 = Color3.fromRGB(5, 14, 30)
            frame9.BackgroundTransparency = 0.18
            frame9.BorderSizePixel = 0
            frame9.Parent = billboardGui
            createUICorner(frame9, 8)
            local instance4 = Instance.new("UIStroke")
            instance4.Thickness = 1.4
            instance4.Transparency = 0.05
            instance4.Parent = frame9
            local instance5 = Instance.new("TextLabel")
            instance5.Size = UDim2.new(1, -10, 0, 22)
            instance5.Position = UDim2.new(0, 5, 0, 2)
            instance5.BackgroundTransparency = 1
            instance5.TextColor3 = appState.COL_WHITE
            instance5.TextSize = 12
            instance5.Font = Enum.Font.GothamBold
            instance5.Parent = frame9
            local textLabel2 = Instance.new("TextLabel")
            textLabel2.Size = UDim2.new(1, -10, 0, 17)
            textLabel2.Position = UDim2.new(0, 5, 0, 24)
            textLabel2.BackgroundTransparency = 1
            textLabel2.TextSize = 10
            textLabel2.Font = Enum.Font.GothamBold
            textLabel2.Parent = frame9
            lookupTable728[index905] = {
                gui = billboardGui,
                owner = instance5,
                status = textLabel2,
                stroke = instance4,
            callback875(index905)
        end
        local function bindEvents912(index913, index914)
            if not index913 or not index914 or promptConnectionSets[index914] then
                return
            end
            local lookupTable915 = {}
            promptConnectionSets[index914] = lookupTable915
            local function refreshFriendPromptState()
                if not isFriendPanelActive() then
                    return
                end
                local readPromptFriendStateResult917 = readPromptFriendState(index914)
                if readPromptFriendStateResult917 ~= nil then
                    cacheFriendState(index913, readPromptFriendStateResult917)
                end
                if lookupTable728[index913] then
                    callback875(index913)
                end
            end
            pcall(function()
                table.insert(
                    index914:GetPropertyChangedSignal("ActionText"):Connect(refreshFriendPromptState)
            end)
            pcall(function()
                table.insert(
                    index914:GetPropertyChangedSignal("ObjectText"):Connect(refreshFriendPromptState)
            end)
            pcall(function()
                table.insert(lookupTable915, index914.AttributeChanged:Connect(refreshFriendPromptState))
            end)
            refreshFriendPromptState()
        end
        local function refreshFriendBaseEsp()
            for k in pairs(lookupTable728) do
                removeFriendBillboard(k)
            end
            local findPlots743Result920 = findPlots743()
            if not findPlots743Result920 or not settings.toggles.friendBaseESP then
                return
            end
            for _, child in ipairs(findPlots743Result920:GetChildren()) do
                if child:IsA("Model") and findClaim784(child) then
                    createBillboardGui904(child)
                end
            end
        end
        local function findBasePart923(instance924)
            if not instance924 then
                return nil
            end
            local findClaim784Result925 = findClaim784(instance924)
            if findClaim784Result925 then
                if findClaim784Result925:IsA("BasePart") then
                    return findClaim784Result925.Position
                end
                    findClaim784Result925:IsA("Attachment")
                    and findClaim784Result925.Parent
                    and findClaim784Result925.Parent:IsA("BasePart")
                then
                    return findClaim784Result925.WorldPosition
                end
                if findClaim784Result925:IsA("Model") then
                    local ok, result = pcall(function()
                        return findClaim784Result925:GetPivot().Position
                    end)
                    if ok and result then
                        return result
                    end
                end
            end
            local position = nil
            pcall(function()
                position = instance924.PrimaryPart and instance924.PrimaryPart.Position
                    or instance924:GetPivot().Position
            end)
            if not position then
                local basePart = instance924:FindFirstChildWhichIsA("BasePart", true)
                if basePart then
                    position = basePart.Position
                end
            end
            return position
        end
        local findPlots743Result930 = findPlots743()
        if findPlots743Result930 then
            for _, descendant in ipairs(findPlots743Result930:GetDescendants()) do
                if descendant:IsA("BillboardGui") and descendant.Name == "ICE_HUB_FRIEND_BASE_ESP" then
                    pcall(function()
                        descendant:Destroy()
                    end)
                elseif descendant:IsA("BasePart") and descendant.Name == "IceHubFriendEspAnchor" then
                    pcall(function()
                        descendant:Destroy()
                    end)
                end
            end
        end
        local friendPanelGui = Instance.new("ScreenGui")
        friendPanelGui.Name = "ICE_HUB_FRIEND_PANEL"
        friendPanelGui:SetAttribute("IceHubOwned", true)
        friendPanelGui.ResetOnSpawn = false
        friendPanelGui.DisplayOrder = 1002
        friendPanelGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        attachGui(friendPanelGui)
        local calculatedValue934 = isMobile and 215 or 225
        local calculatedValue935 = isMobile and 126 or 132
        local frame9 = Instance.new("Frame")
        appState.friendFrame = frame9
        frame9.Name = "FriendWindow"
        frame9.Size = UDim2.new(0, calculatedValue934, 0, calculatedValue935)
        restorePanelPosition(frame9, "friendPanel", UDim2.new(0.02, 270, 0.5, -calculatedValue935 / 2))
        frame9.BackgroundColor3 = Color3.fromRGB(12, 38, 76)
        frame9.BackgroundTransparency = 0.24
        frame9.BorderSizePixel = 0
        frame9.Active = true
        frame9.ZIndex = 20
        frame9.Parent = friendPanelGui
        createUICorner(frame9, 14)
        addGradientStroke(frame9, 2)
        local uiGradient2 = Instance.new("UIGradient")
        local lookupTable939 = {}
        local colorKeypoint940 = ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 32, 67))
        local colorKeypoint941 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 66, 128))
        lookupTable939[1] = colorKeypoint940
        lookupTable939[2] = colorKeypoint941
        lookupTable939[3] = ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 28, 61))
        uiGradient2.Color = ColorSequence.new(lookupTable939)
        uiGradient2.Rotation = 135
        uiGradient2.Parent = frame9
        local frame10 = Instance.new("Frame")
        frame10.Size = UDim2.new(1, 0, 0, 36)
        frame10.BackgroundTransparency = 1
        frame10.BorderSizePixel = 0
        frame10.ZIndex = 21
        frame10.Parent = frame9
        if logoAsset then
            local imageLabel = Instance.new("ImageLabel")
            imageLabel.Size = UDim2.new(0, 24, 0, 24)
            imageLabel.Position = UDim2.new(0, 8, 0.5, -12)
            imageLabel.BackgroundTransparency = 1
            imageLabel.Image = logoAsset
            imageLabel.ScaleType = Enum.ScaleType.Fit
            imageLabel.ZIndex = 22
            imageLabel.Parent = frame10
        end
        local textLabel2 = Instance.new("TextLabel")
        textLabel2.Size = UDim2.new(1, -45, 1, 0)
        textLabel2.Position = UDim2.new(0, 38, 0, 0)
        textLabel2.BackgroundTransparency = 1
        textLabel2.Text = "Ice Hub - Friends"
        textLabel2.TextColor3 = appState.COL_WHITE
        textLabel2.TextSize = isMobile and 12 or 13
        textLabel2.Font = Enum.Font.GothamBlack
        textLabel2.TextXAlignment = Enum.TextXAlignment.Left
        textLabel2.ZIndex = 22
        textLabel2.Parent = frame10
        local frame11 = Instance.new("Frame")
        frame11.Size = UDim2.new(1, -16, 1, -43)
        frame11.Position = UDim2.new(0, 8, 0, 39)
        frame11.BackgroundTransparency = 1
        frame11.BorderSizePixel = 0
        frame11.ZIndex = 11
        frame11.Parent = frame9
        local uiListLayout2 = Instance.new("UIListLayout")
        uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout2.Padding = UDim.new(0, 6)
        uiListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
        uiListLayout2.Parent = frame11
        local toggleFriends = createActionButton(frame11, "TOGGLE FRIENDS", function()
            triggerProximityPrompt876()
        end)
        if toggleFriends then
            toggleFriends.Size = UDim2.new(1, 0, 0, isMobile and 34 or 32)
            toggleFriends.BackgroundColor3 = Color3.fromRGB(20, 34, 128)
            toggleFriends.BackgroundTransparency = 0.12
            addGradientStroke(toggleFriends, 1)
        end
        local baseEsp = createToggle(
            settings.toggles.friendBaseESP ~= false,
            function(friendBaseESP)
                settings.toggles.friendBaseESP = friendBaseESP
                saveSettings()
                refreshFriendBaseEsp()
            end
        if baseEsp then
            baseEsp.Size = UDim2.new(1, 0, 0, isMobile and 30 or 28)
            baseEsp.BackgroundColor3 = Color3.fromRGB(15, 50, 94)
            baseEsp.BackgroundTransparency = 0.18
        end
        makeDraggable(frame9, frame10, "friendPanel")
        refreshFriendBaseEsp()
        local findLocalPlotResult956 = findLocalPlot()
        local calculatedValue957 = findLocalPlotResult956 and findProximityPrompt789(findLocalPlotResult956)
        local friendPrompt
        if findLocalPlotResult956 and not calculatedValue957 and type(getnilinstances) == "function" then
            local parent960 = findClaim784(findLocalPlotResult956)
            if parent960 then
                local ok, result = pcall(getnilinstances)
                if ok and type(result) == "table" then
                    for _, instance964 in ipairs(result) do
                        if typeof(instance964) == "Instance" and instance964:IsA("ProximityPrompt") then
                            local lowerResult965 = (tostring(instance964.ActionText or "") .. " " .. tostring(
                                instance964.ObjectText or ""
                            )):lower()
                                lowerResult965:find("friend", 1, true)
                                or lowerResult965:find("allow friends", 1, true)
                                or lowerResult965:find("disallow friends", 1, true)
                            then
                                    pcall(function()
                                        instance964.Parent = parent960
                                    end)
                                then
                                    promptCache[findLocalPlotResult956] = instance964
                                    calculatedValue957 = instance964
                                    break
                                end
                            end
                        end
                    end
                end
            end
            friendPrompt = calculatedValue957
        else
            friendPrompt = calculatedValue957
        end
        if friendPrompt then
            configureFriendPrompt(friendPrompt)
        end
        if findLocalPlotResult956 then
            local findFriendPanel854Result966 = findFriendPanel854(findLocalPlotResult956)
            if findFriendPanel854Result966 ~= nil then
                cacheFriendState(findLocalPlotResult956, findFriendPanel854Result966)
            end
            if lookupTable728[findLocalPlotResult956] then
                callback875(findLocalPlotResult956)
            end
        end
        local findPlots743Result967 = findPlots743()
        local previousFriendStates = setmetatable({}, {
            __mode = "kv",
        local function processPlot(instance970)
            if not instance970 or not instance970:IsA("Model") then
                return
            end
            local findPlotSign777Result971 = findPlotSign777(instance970)
            if findPlotSign777Result971 then
                instance729 = instance970
            end
            local findProximityPrompt789Result972 = findProximityPrompt789(instance970)
            if findProximityPrompt789Result972 then
                bindEvents912(instance970, findProximityPrompt789Result972)
                if findPlotSign777Result971 then
                    configureFriendPrompt(findProximityPrompt789Result972)
                else
                    hideFriendPrompt(findProximityPrompt789Result972)
                end
            end
            if findClaim784(instance970) then
                local findFriendPanel854Result973 = findFriendPanel854(instance970)
                if findFriendPanel854Result973 ~= nil then
                    friendStateCache[instance970] = findFriendPanel854Result973
                end
                if settings.toggles.friendBaseESP then
                    if not lookupTable728[instance970] then
                        createBillboardGui904(instance970)
                    else
                        callback875(instance970)
                    end
                end
            end
        end
        local numericValue974 = 0
        local lastFriendState = nil
        local numericValue976 = 0
        if findPlots743Result967 then
            for _, child in ipairs(findPlots743Result967:GetChildren()) do
                processPlot(child)
            end
            findPlots743Result967.ChildAdded:Connect(function(child)
                task.defer(processPlot, child)
            end)
            findPlots743Result967.ChildRemoved:Connect(function(child)
                if instance729 == child then
                    instance729 = nil
                end
                if lookupTable728[child] then
                    removeFriendBillboard(child)
                end
            end)
            findPlots743Result967.DescendantAdded:Connect(function(descendant)
                if not descendant:IsA("ProximityPrompt") then
                    return
                end
                local plot = descendant
                while plot and plot.Parent ~= findPlots743Result967 do
                    plot = plot.Parent
                end
                if plot and plot.Parent == findPlots743Result967 then
                    promptCache[plot] = descendant
                    bindEvents912(plot, descendant)
                    if findPlotSign777(plot) then
                        configureFriendPrompt(descendant)
                    else
                        hideFriendPrompt(descendant)
                    end
                end
            end)
            lastFriendState = nil
        end
        while isFriendPanelActive() and task.wait(0.1) do
            numericValue974 += 1
            if numericValue974 >= 8 then
                numericValue974 = 0
                if settings.toggles.friendBaseESP then
                    for k in pairs(lookupTable728) do
                        if k.Parent then
                            callback875(k)
                        else
                            removeFriendBillboard(k)
                        end
                    end
                end
            end
            if semiTeleportSettings.autoSemiOnFriends then
                local character = localPlayer.Character
                character = character and character:FindFirstChild("HumanoidRootPart")
                if character and findPlots743Result967 then
                    local calculatedValue985 = (character.Position - baseLocations.b1.refVec).Magnitude
                        < (character.Position - baseLocations.b2.refVec).Magnitude
                    if lastFriendState ~= calculatedValue985 then
                        previousFriendStates = setmetatable({}, {
                            __mode = "kv",
                        lastFriendState = calculatedValue985
                    end
                    for _, child in ipairs(findPlots743Result967:GetChildren()) do
                        if child:IsA("Model") and not findPlotSign777(child) and findClaim784(child) then
                            local findBasePart923Result988 = findBasePart923(child)
                            if findBasePart923Result988 then
                                    (findBasePart923Result988 - baseLocations.b1.refVec).Magnitude
                                    < (findBasePart923Result988 - baseLocations.b2.refVec).Magnitude
                                    ~= calculatedValue985
                                then
                                    local findProximityPrompt789Result989 = findProximityPrompt789(child)
                                    findProximityPrompt789Result989 = findProximityPrompt789Result989
                                            and readPromptFriendState(findProximityPrompt789Result989)
                                        or nil
                                    if findProximityPrompt789Result989 == nil then
                                        local instance990 = friendStateElementCache[child]
                                        if instance990 and instance990.Parent then
                                            findProximityPrompt789Result989 = inferFriendState(instance990)
                                        end
                                    end
                                    if findProximityPrompt789Result989 == nil then
                                        findProximityPrompt789Result989 = friendStateCache[child]
                                    end
                                    if findProximityPrompt789Result989 == nil and numericValue974 == 0 then
                                        findProximityPrompt789Result989 = findFriendPanel854(child)
                                    end
                                        previousFriendStates[child] == false
                                        and findProximityPrompt789Result989 == true
                                    then
                                        local now2 = tick()
                                            now2 - numericValue976 >= 0.8
                                            and not semiTeleportState.debounce
                                            and not localPlayer:GetAttribute("Stealing")
                                        then
                                            task.spawn(function()
                                                pcall(semiTeleportState.execute)
                                            end)
                                            numericValue976 = now2
                                        end
                                    end
                                    if findProximityPrompt789Result989 ~= nil then
                                        previousFriendStates[child] = findProximityPrompt789Result989
                                    end
                                end
                            end
                        end
                    end
                end
            else
                previousFriendStates = setmetatable({}, {
                    __mode = "kv",
                lastFriendState = nil
            end
        end
        for k in pairs(lookupTable728) do
            removeFriendBillboard(k)
        end
        if friendPanelGui and friendPanelGui.Parent then
            pcall(function()
                friendPanelGui:Destroy()
            end)
        end
    end)
end)
task.spawn(function()
    local antiBalloon, balloonContent998, openBalloonPanel999, closeBalloonPanel1000 =
        createPanelContainer("Anti Balloon", "balloon")
    appState.balloonFrame = antiBalloon
    appState.balloonContent = balloonContent998
    appState.openBalloonPanel = openBalloonPanel999
    appState.closeBalloonPanel = closeBalloonPanel1000
    createToggle(
        function(autoResetBalloonEnabled)
            appState.AutoResetBalloonEnabled = autoResetBalloonEnabled
            settings.toggles.autoResetBalloon = autoResetBalloonEnabled
            saveSettings()
            if autoResetBalloonEnabled then
                enableBalloonMonitor()
            else
                disableBalloonMonitor()
            end
        end
end)
task.spawn(function()
    local antiTurret, turretContent1007, openTurretPanel1008, closeTurretPanel1009 =
        createPanelContainer("Anti Turret", "turret")
    appState.turretFrame = antiTurret
    appState.turretContent = turretContent1007
    appState.openTurretPanel = openTurretPanel1008
    appState.closeTurretPanel = closeTurretPanel1009
    createToggle(appState.turretContent, "Anti Turret", appState.sentryEnabled, function(sentryEnabled)
        appState.sentryEnabled = sentryEnabled
        settings.toggles.antiTurret = sentryEnabled
        saveSettings()
        if sentryEnabled then
            enableAntiTurret()
        else
            disableAntiTurret()
        end
    end)
end)
task.spawn(function()
    local gameStretcher, stretchContent1016, openStretchPanel1017, closeStretchPanel1018 =
        createPanelContainer("Game Stretcher", "stretch")
    appState.stretchFrame = gameStretcher
    appState.stretchContent = stretchContent1016
    appState.openStretchPanel = openStretchPanel1017
    appState.closeStretchPanel = closeStretchPanel1018
    createToggle(appState.stretchContent, "Game Stretcher", appState.gameStretcherEnabled, function(enabled)
        if enabled then
            enableGameStretcher()
        else
            disableGameStretcher()
        end
    end)
end)
task.spawn(function()
    local xpFrame1024, xpContent1025, openXrayPanel1026, closeXrayPanel1027 =
        createPanelContainer("FPS & Effects", "xray")
    appState.xpFrame = xpFrame1024
    appState.xpContent = xpContent1025
    appState.openXrayPanel = openXrayPanel1026
    appState.closeXrayPanel = closeXrayPanel1027
    createToggle(appState.xpContent, "Anti Lag", settings.toggles.antiLag or false, function(antiLag)
        settings.toggles.antiLag = antiLag
        saveSettings()
        if antiLag then
            applyPerformanceSettings()
            for _, descendant in pairs(workspaceService:GetDescendants()) do
                optimizeInstance(descendant)
            end
            if not _G.antiLagConn then
                _G.antiLagConn = workspaceService.DescendantAdded:Connect(function(descendant)
                    if settings.toggles.antiLag then
                        optimizeInstance(descendant)
                    end
                end)
            end
        elseif _G.antiLagConn then
            _G.antiLagConn:Disconnect()
            _G.antiLagConn = nil
        end
    end)
    createToggle(appState.xpContent, "FPS Booster", settings.toggles.fpsBooster or false, function(fpsBooster)
        settings.toggles.fpsBooster = fpsBooster
        saveSettings()
        if fpsBooster then
            applyPerformanceSettings()
            for _, descendant in pairs(workspaceService:GetDescendants()) do
                optimizeInstance(descendant)
            end
        end
    end)
    createToggle(appState.xpContent, "No Particles", settings.toggles.noParticles or false, function(noParticles)
        settings.toggles.noParticles = noParticles
        saveSettings()
        if noParticles then
            _G.noParticlesEnabled = true
            for _, descendant in pairs(workspaceService:GetDescendants()) do
                    descendant:IsA("ParticleEmitter")
                    or descendant:IsA("Smoke")
                    or descendant:IsA("Fire")
                    or descendant:IsA("Sparkles")
                then
                    pcall(function()
                        descendant.Enabled = false
                    end)
                end
            end
            _G.noParticlesConn = workspaceService.DescendantAdded:Connect(function(descendant)
                if not _G.noParticlesEnabled then
                    return
                end
                    descendant:IsA("ParticleEmitter")
                    or descendant:IsA("Smoke")
                    or descendant:IsA("Fire")
                    or descendant:IsA("Sparkles")
                then
                    pcall(function()
                        descendant.Enabled = false
                    end)
                end
            end)
        else
            _G.noParticlesEnabled = false
            if _G.noParticlesConn then
                _G.noParticlesConn:Disconnect()
                _G.noParticlesConn = nil
            end
        end
    end)
end)
task.spawn(function()
    local Booster, bpContent1044, openBoosterPanel1045, closeBoosterPanel1046 =
        createPanelContainer("Booster", "booster")
    appState.bpFrame = Booster
    appState.bpContent = bpContent1044
    appState.openBoosterPanel = openBoosterPanel1045
    appState.closeBoosterPanel = closeBoosterPanel1046
end)
espState = {
    enabled = false,
    folder = nil,
    thread = nil,
    bestPart = nil,
    nodes = {},
    conns = {},
    primed = false,
    dirty = true,
parseCurrency = function(currencyText)
    if not currencyText or currencyText == "" then
        return 0
    end
    local numberOptions1048 = {
        K = 1000,
        k = 1000,
        M = 1000000,
        m = 1000000,
        B = 1e9,
        b = 1e9,
        T = 1e12,
        t = 1e12,
    local match, matchResult1050 =
        tostring(currencyText):gsub("%s", ""):gsub(",", ""):gsub("%$", ""):match("([%d%.]+)([KkMmBbTt]?)")
    if match then
        match = (tonumber(match) or 0) * (numberOptions1048[matchResult1050] or 1)
    end
    return match or 0
end
    local function matchesLocalPlayer(candidateOwner)
        local lowerResult1053 = tostring(candidateOwner or ""):lower()
        return lowerResult1053:find(localPlayer.Name:lower(), 1, true) ~= nil
            or lowerResult1053:find(localPlayer.DisplayName:lower(), 1, true) ~= nil
            or lowerResult1053 == tostring(localPlayer.UserId)
    end
    local function findOwner1054(instance1055)
        if not instance1055 then
            return false
        end
        for _, item1057 in ipairs({
        }) do
            local attribute = instance1055:GetAttribute(item1057)
            if attribute ~= nil and matchesLocalPlayer(attribute) then
                return true
            end
        end
        local owner = instance1055:FindFirstChild("Owner", true)
        if owner then
            if owner:IsA("ObjectValue") and owner.Value == localPlayer then
                return true
            end
                (owner:IsA("StringValue") or owner:IsA("IntValue") or owner:IsA("NumberValue"))
                and matchesLocalPlayer(owner.Value)
            then
                return true
            end
        end
        local surfaceGui = instance1055:FindFirstChild("PlotSign")
        local yourBase = surfaceGui and surfaceGui:FindFirstChild("YourBase", true)
        if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled then
            return true
        end
        surfaceGui = surfaceGui and surfaceGui:FindFirstChild("SurfaceGui")
        local frame3 = surfaceGui and surfaceGui:FindFirstChild("Frame")
        frame3 = frame3 and frame3:FindFirstChild("TextLabel")
        if frame3 and frame3:IsA("TextLabel") and matchesLocalPlayer(frame3.Text) then
            return true
        end
        return false
    end
    findOwningPlot = function(guiObject1063)
        local plots = workspaceService:FindFirstChild("Plots")
        if not plots or not guiObject1063 then
            return nil, false
        end
        local parent = guiObject1063
        while parent and parent ~= workspaceService do
            if parent.Parent == plots and parent:IsA("Model") then
                return parent, findOwner1054(parent)
            end
            parent = parent.Parent
        end
        local position = guiObject1063.Position
        for _, child in ipairs(plots:GetChildren()) do
            local ok, result, result2 = pcall(function()
                return child:GetBoundingBox()
            end)
            if ok and result and result2 then
                local pointToObjectSpaceResult1072 = result:PointToObjectSpace(position)
                local calculatedValue1073 = result2.X / 2 + 5
                local calculatedValue1074 = math.abs(pointToObjectSpaceResult1072.X) <= calculatedValue1073
                if calculatedValue1074 then
                    local calculatedValue1075 = result2.Y / 2 + 50
                    calculatedValue1074 = math.abs(pointToObjectSpaceResult1072.Y) <= calculatedValue1075
                end
                if calculatedValue1074 then
                    local calculatedValue1076 = result2.Z / 2 + 5
                    calculatedValue1074 = math.abs(pointToObjectSpaceResult1072.Z) <= calculatedValue1076
                end
                if calculatedValue1074 then
                    return child, findOwner1054(child)
                end
            end
        end
        return nil, false
    end
end
local findDebris1077, createAttachment1078, adminPanelGui, createPanelSection, mergePanelSection, mergeEspSections
        local frame3
            local collectBrainrotEntries
                local function findSurfaceGui1085(instance1086)
                    local surfaceGui = instance1086 and instance1086:FindFirstChildWhichIsA("SurfaceGui", true)
                    if not surfaceGui then
                        return nil
                    end
                    local displayName = surfaceGui:FindFirstChild("DisplayName", true)
                    local generation = surfaceGui:FindFirstChild("Generation", true)
                        or surfaceGui:FindFirstChild("Speed", true)
                        not displayName
                        or not generation
                        or not displayName:IsA("TextLabel")
                        or not generation:IsA("TextLabel")
                    then
                        return nil
                    end
                    if displayName.Text == "" or displayName.Text == "Brainrot" or generation.Text == "" then
                        return nil
                    end
                    local adornee = surfaceGui.Adornee and surfaceGui.Adornee:IsA("BasePart") and surfaceGui.Adornee
                        or instance1086:IsA("BasePart") and instance1086
                        or instance1086:FindFirstChildWhichIsA("BasePart", true)
                    if not adornee then
                        return nil
                    end
                    return displayName.Text, generation.Text, parseCurrency(generation.Text), adornee
                end
                collectBrainrotEntries = function()
                    local lookupTable1091 = {}
                    for k in pairs(espState.nodes) do
                        if not k or not k.Parent or k.Name ~= "FastOverheadTemplate" then
                            espState.nodes[k] = nil
                        else
                            local findSurfaceGui1085Result1093, findSurfaceGui1085Result1094, findSurfaceGui1085Result1095, findSurfaceGui1085Result1096 =
                                findSurfaceGui1085(k)
                            if findSurfaceGui1085Result1093 then
                                local findOwningPlotResult1097, findOwningPlotResult1098 =
                                    findOwningPlot(findSurfaceGui1085Result1096)
                                local isValid1099 = not findOwningPlotResult1098
                                if isValid1099 then
                                    isValid1099 = not (
                                        localPlayer.Character
                                        and (
                                            k:IsDescendantOf(localPlayer.Character)
                                            or findSurfaceGui1085Result1096:IsDescendantOf(localPlayer.Character)
                                end
                                if isValid1099 then
                                    table.insert(lookupTable1091, {
                                        tp = k,
                                        name = findSurfaceGui1085Result1093,
                                        gen = findSurfaceGui1085Result1094,
                                        val = findSurfaceGui1085Result1095,
                                        ad = findSurfaceGui1085Result1096,
                                        plot = findOwningPlotResult1097,
                                end
                            end
                        end
                    end
                    return lookupTable1091
                end
            end
                local function createBillboardGui1100(adState1101, isBest)
                    if not espState.folder then
                        return
                    end
                    local billboardGui = Instance.new("BillboardGui")
                    billboardGui.Name = generateRandomGuiName()
                    billboardGui.Size = UDim2.new(0, 190, 0, 48)
                    billboardGui.AlwaysOnTop = true
                    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
                    billboardGui.Adornee = adState1101.ad
                    billboardGui.MaxDistance = 2000
                    billboardGui.Parent = espState.folder
                    local instance = Instance.new("Frame")
                    instance.Size = UDim2.new(1, 0, 1, 0)
                    instance.BackgroundColor3 = Color3.fromRGB(5, 18, 39)
                    instance.BackgroundTransparency = 0.14
                    instance.BorderSizePixel = 0
                    instance.Parent = billboardGui
                    createUICorner(instance, 8)
                    local instance2 = Instance.new("UIStroke")
                    instance2.Thickness = isBest and 2.2 or 1.4
                    instance2.Color = isBest and Color3.fromRGB(190, 230, 255) or Color3.fromRGB(75, 155, 255)
                    instance2.Transparency = 0.12
                    instance2.Parent = instance
                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(1, -10, 0, 22)
                    textLabel.Position = UDim2.new(0, 5, 0, 3)
                    textLabel.BackgroundTransparency = 1
                    textLabel.TextScaled = true
                    textLabel.Font = Enum.Font.GothamBlack
                    textLabel.Text = (isBest and "★ " or "") .. adState1101.name
                    textLabel.TextColor3 = isBest and Color3.fromRGB(255, 248, 255) or Color3.fromRGB(125, 195, 255)
                    textLabel.Parent = instance
                    local instance3 = Instance.new("TextLabel")
                    instance3.Size = UDim2.new(1, -10, 0, 18)
                    instance3.Position = UDim2.new(0, 5, 0, 26)
                    instance3.BackgroundTransparency = 1
                    instance3.TextScaled = true
                    instance3.Font = Enum.Font.GothamBold
                    instance3.Text = adState1101.gen
                    instance3.TextColor3 = Color3.fromRGB(185, 220, 255)
                    instance3.Parent = instance
                end
                local function refreshBrainrotEsp()
                    if not espState.folder then
                        return
                    end
                    espState.folder:ClearAllChildren()
                    espState.bestPart = nil
                    local collectBrainrotEntriesResult1109 = collectBrainrotEntries()
                    local numericValue1110 = -1
                    local adState1114 = nil
                    local numericValue1115 = -1
                    local bestUnownedBrainrot = nil
                    for _, valState1118 in ipairs(collectBrainrotEntriesResult1109) do
                        if valState1118.val > numericValue1110 then
                            numericValue1110 = valState1118.val
                            adState1114 = valState1118
                        end
                        if not valState1118.plot and valState1118.val > numericValue1115 then
                            numericValue1115 = valState1118.val
                            bestUnownedBrainrot = valState1118
                        end
                    end
                    if adState1114 then
                        espState.bestPart = adState1114.ad
                    end
                    if settings.toggles.brainrotESP then
                        for _, plotState1120 in ipairs(collectBrainrotEntriesResult1109) do
                            if plotState1120.plot or plotState1120 == bestUnownedBrainrot then
                                createBillboardGui1100(plotState1120, plotState1120 == adState1114)
                            end
                        end
                    elseif settings.toggles.bestBrainrotESP and adState1114 then
                        createBillboardGui1100(adState1114, true)
                    end
                end
                findDebris1077 = function()
                    if not espState.primed then
                        espState.primed = true
                        local function bindEvents1121(instance1122)
                            if not instance1122 then
                                return
                            end
                            for _, descendant in ipairs(instance1122:GetDescendants()) do
                                if descendant.Name == "FastOverheadTemplate" then
                                    espState.nodes[descendant] = true
                                end
                            end
                            table.insert(
                                espState.conns,
                                instance1122.DescendantAdded:Connect(function(descendant)
                                    if descendant.Name == "FastOverheadTemplate" then
                                        espState.nodes[descendant] = true
                                        espState.dirty = true
                                    end
                                end)
                            table.insert(
                                espState.conns,
                                instance1122.DescendantRemoving:Connect(function(descendant)
                                    if espState.nodes[descendant] then
                                        espState.nodes[descendant] = nil
                                        espState.dirty = true
                                    end
                                end)
                        end
                        bindEvents1121(workspaceService:FindFirstChild("Debris"))
                        bindEvents1121(workspaceService:FindFirstChild("Plots"))
                        table.insert(
                            espState.conns,
                            workspaceService.ChildAdded:Connect(function(child)
                                if child.Name == "Debris" or child.Name == "Plots" then
                                    bindEvents1121(child)
                                    espState.dirty = true
                                end
                            end)
                    end
                    espState.dirty = true
                    if espState.thread then
                        return
                    end
                    espState.thread = task.spawn(function()
                        while
                            or settings.toggles.bestBrainrotESP
                            or settings.toggles.lineESP
                            if espState.dirty then
                                espState.dirty = false
                                pcall(refreshBrainrotEsp)
                            end
                            task.wait(0.25)
                        end
                        espState.thread = nil
                        if espState.folder then
                            espState.folder:ClearAllChildren()
                        end
                    end)
                end
            end
        end
            local beam = nil
            local attachment = nil
            local attachment2 = nil
            local connection = nil
            local function clearBestBrainrotLine()
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
                if beam then
                    beam:Destroy()
                    beam = nil
                end
                if attachment then
                    attachment:Destroy()
                    attachment = nil
                end
                if attachment2 then
                    attachment2:Destroy()
                    attachment2 = nil
                end
            end
            createAttachment1078 = function()
                clearBestBrainrotLine()
                findDebris1077()
                connection = RunService.Heartbeat:Connect(function()
                    if not settings.toggles.lineESP then
                        return
                    end
                    local humanoidRootPart = localPlayer.Character
                        and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local bestPart = espState.bestPart
                    if not humanoidRootPart or not bestPart or not bestPart.Parent then
                        return
                    end
                    if not beam then
                        attachment = Instance.new("Attachment")
                        attachment.Name = generateRandomGuiName()
                        attachment.Parent = humanoidRootPart
                        attachment2 = Instance.new("Attachment")
                        attachment2.Name = generateRandomGuiName()
                        attachment2.Parent = bestPart
                        beam = Instance.new("Beam")
                        beam.Attachment0 = attachment
                        beam.Attachment1 = attachment2
                        beam.FaceCamera = true
                        beam.Width0 = 0.45
                        beam.Width1 = 0.45
                        beam.Color = ColorSequence.new(Color3.fromRGB(80, 165, 255), Color3.fromRGB(220, 245, 255))
                        beam.Transparency = NumberSequence.new(0.25)
                        beam.LightEmission = 1
                        beam.Parent = humanoidRootPart
                    elseif attachment2.Parent ~= bestPart then
                        attachment2.Parent = bestPart
                    end
                end)
            end
            task.spawn(function()
                local esp, espContent1142, openESPPanel1143, closeESPPanel1144 = createPanelContainer("ESP", "esp")
                appState.espFrame = esp
                appState.espContent = espContent1142
                appState.openESPPanel = openESPPanel1143
                appState.closeESPPanel = closeESPPanel1144
                if not espState.folder then
                    espState.folder = Instance.new("Folder")
                    espState.folder.Name = generateRandomGuiName()
                    espState.folder.Parent = mainGui
                end
                createToggle(
                    appState.espContent,
                    settings.toggles.brainrotESP or false,
                    function(brainrotESP)
                        settings.toggles.brainrotESP = brainrotESP
                        saveSettings()
                        if brainrotESP then
                            findDebris1077()
                        elseif espState.folder then
                            espState.folder:ClearAllChildren()
                        end
                    end
                createToggle(
                    appState.espContent,
                    settings.toggles.bestBrainrotESP or false,
                    function(bestBrainrotESP)
                        settings.toggles.bestBrainrotESP = bestBrainrotESP
                        saveSettings()
                        if bestBrainrotESP then
                            findDebris1077()
                        elseif not settings.toggles.brainrotESP and espState.folder then
                            espState.folder:ClearAllChildren()
                        end
                    end
                createToggle(
                    appState.espContent,
                    settings.toggles.lineESP or false,
                    function(lineESP)
                        settings.toggles.lineESP = lineESP
                        saveSettings()
                        if lineESP then
                            createAttachment1078()
                        else
                            clearBestBrainrotLine()
                        end
                    end
                local color = Color3.fromRGB(0, 120, 255)
                local color2 = Color3.fromRGB(80, 190, 255)
                local function createHighlight(adornee, name, fillTransparency)
                    if not adornee or not adornee.Parent then
                        return nil
                    end
                    local findFirstChildResult1154 = adornee:FindFirstChild(name)
                    if findFirstChildResult1154 and findFirstChildResult1154:IsA("Highlight") then
                        return findFirstChildResult1154
                    end
                    local highlight = Instance.new("Highlight")
                    highlight.Name = name
                    highlight.Adornee = adornee
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.FillColor = color
                    highlight.OutlineColor = color2
                    highlight.FillTransparency = fillTransparency or 0.55
                    highlight.OutlineTransparency = 0
                    highlight.Parent = adornee
                    return highlight
                end
                local function removeHighlight(instance1157, highlightName)
                    if not instance1157 then
                        return
                    end
                    for _, descendant in ipairs(instance1157:GetDescendants()) do
                        if descendant:IsA("Highlight") and descendant.Name == highlightName then
                            pcall(function()
                                descendant:Destroy()
                            end)
                        end
                    end
                    if instance1157:IsA("Model") then
                        local findFirstChildResult1161 = instance1157:FindFirstChild(highlightName)
                        if findFirstChildResult1161 and findFirstChildResult1161:IsA("Highlight") then
                            pcall(function()
                                findFirstChildResult1161:Destroy()
                            end)
                        end
                    end
                end
                createToggle(appState.espContent, "Player ESP", settings.toggles.playerESP or false, function(playerESP)
                    settings.toggles.playerESP = playerESP
                    saveSettings()
                    if playerESP then
                        _G.playerESPEnabled = true
                        _G.playerESPConns = _G.playerESPConns or {}
                        local function createBoolValue1163(player1164)
                            local character = player1164.Character
                            if not character or player1164 == localPlayer then
                                return
                            end
                            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                            local head = character:FindFirstChild("Head")
                            if not humanoidRootPart or not head or character:FindFirstChild("IceHub_ESP") then
                                return
                            end
                            Instance.new("BoolValue", character).Name = "IceHub_ESP"
                            local billboardGui = Instance.new("BillboardGui")
                            billboardGui.Name = "IceHub_ESP_Billboard"
                            billboardGui.Adornee = head
                            billboardGui.Size = UDim2.new(0, 200, 0, 40)
                            billboardGui.StudsOffset = Vector3.new(0, 3, 0)
                            billboardGui.AlwaysOnTop = true
                            billboardGui.Parent = character
                            local instance = Instance.new("TextLabel")
                            instance.Size = UDim2.new(1, 0, 1, 0)
                            instance.BackgroundTransparency = 1
                            instance.TextColor3 = color2
                            instance.TextStrokeTransparency = 0
                            instance.TextStrokeColor3 = Color3.new(0, 0, 0)
                            instance.TextScaled = true
                            instance.Font = Enum.Font.GothamBold
                            instance.Text = player1164.DisplayName or player1164.Name
                            instance.Parent = billboardGui
                            task.spawn(function()
                                while character.Parent and _G.playerESPEnabled do
                                    local character2 = localPlayer.Character
                                    local humanoidRootPart2 = character2
                                        and character2:FindFirstChild("HumanoidRootPart")
                                    if humanoidRootPart2 and humanoidRootPart and humanoidRootPart.Parent then
                                        instance.Text = (player1164.DisplayName or player1164.Name)
                                            .. math.floor(
                                                (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude + 0.5
                                            .. "m]"
                                    end
                                    task.wait(0.25)
                                end
                            end)
                        end
                        for _, player in pairs(playersService:GetPlayers()) do
                            if player ~= localPlayer and player.Character then
                                createBoolValue1163(player)
                            end
                            if player ~= localPlayer then
                                table.insert(
                                    _G.playerESPConns,
                                    player.CharacterAdded:Connect(function()
                                        if _G.playerESPEnabled then
                                            task.wait(0.1)
                                            createBoolValue1163(player)
                                        end
                                    end)
                            end
                        end
                    else
                        _G.playerESPEnabled = false
                        local callback1174 = pairs
                        local playerESPConns = _G.playerESPConns or {}
                        for _, playerESPConn in callback1174(playerESPConns) do
                            if playerESPConn and playerESPConn.Connected then
                                playerESPConn:Disconnect()
                            end
                        end
                        _G.playerESPConns = {}
                        for _, player in ipairs(playersService:GetPlayers()) do
                            if player.Character then
                                local iceHubEsp = player.Character:FindFirstChild("IceHub_ESP")
                                local iceHubEspBillboard = player.Character:FindFirstChild("IceHub_ESP_Billboard")
                                if iceHubEsp then
                                    iceHubEsp:Destroy()
                                end
                                if iceHubEspBillboard then
                                    iceHubEspBillboard:Destroy()
                                end
                            end
                        end
                    end
                end)
                local lookupTable1182 = {}
                local function applyPlayerChams(player1184)
                    if player1184 == localPlayer or not settings.toggles.playerChams then
                        return
                    end
                    local character = player1184.Character
                    if character then
                        createHighlight(character, "IceHub_PlayerChams", 0.62)
                    end
                end
                local function findPlayer1186()
                    for _, disconnectState1188 in ipairs(lookupTable1182) do
                        pcall(function()
                            disconnectState1188:Disconnect()
                        end)
                    end
                    lookupTable1182 = {}
                    for _, player in ipairs(playersService:GetPlayers()) do
                        if player.Character then
                            removeHighlight(player.Character, "IceHub_PlayerChams")
                        end
                    end
                end
                createToggle(
                    appState.espContent,
                    settings.toggles.playerChams or false,
                    function(playerChams)
                        settings.toggles.playerChams = playerChams
                        saveSettings()
                        findPlayer1186()
                        if playerChams then
                            for _, player in ipairs(playersService:GetPlayers()) do
                                if player ~= localPlayer then
                                    applyPlayerChams(player)
                                    table.insert(
                                        player.CharacterAdded:Connect(function()
                                            task.wait(0.15)
                                            applyPlayerChams(player)
                                        end)
                                end
                            end
                            table.insert(
                                playersService.PlayerAdded:Connect(function(player)
                                    table.insert(
                                        player.CharacterAdded:Connect(function()
                                            task.wait(0.15)
                                            applyPlayerChams(player)
                                        end)
                                end)
                        end
                    end
                local connection2 = nil
                local function applySelfChams(character)
                    if settings.toggles.selfChams and character then
                        createHighlight(character, "IceHub_SelfChams", 0.68)
                    end
                end
                createToggle(appState.espContent, "Self Chams", settings.toggles.selfChams or false, function(selfChams)
                    settings.toggles.selfChams = selfChams
                    saveSettings()
                    if connection2 then
                        connection2:Disconnect()
                        connection2 = nil
                    end
                    if localPlayer.Character then
                        removeHighlight(localPlayer.Character, "IceHub_SelfChams")
                    end
                    if selfChams then
                        applySelfChams(localPlayer.Character)
                        connection2 = localPlayer.CharacterAdded:Connect(function(character)
                            task.wait(0.15)
                            applySelfChams(character)
                        end)
                    end
                end)
                local connection3 = nil
                local function findAnimalOverhead1201(instance1202)
                    if not (not settings.toggles.brainrotChams or not instance1202 or not instance1202.Parent) then
                        local isModel = instance1202:IsA("Model") and instance1202
                            or instance1202:FindFirstAncestorOfClass("Model")
                        if not isModel then
                            return
                        end
                        if isModel:FindFirstChild("AnimalOverhead", true) then
                            createHighlight(isModel, "IceHub_BrainrotChams", 0.58)
                        end
                        return
                    end
                    return
                end
                local function findDebris1204()
                    local debris = workspaceService:FindFirstChild("Debris")
                    if not debris then
                        return
                    end
                    for _, child in ipairs(debris:GetChildren()) do
                        findAnimalOverhead1201(child)
                    end
                end
                createToggle(
                    appState.espContent,
                    settings.toggles.brainrotChams or false,
                    function(brainrotChams)
                        settings.toggles.brainrotChams = brainrotChams
                        saveSettings()
                        if connection3 then
                            connection3:Disconnect()
                            connection3 = nil
                        end
                        removeHighlight(workspaceService, "IceHub_BrainrotChams")
                        if brainrotChams then
                            findDebris1204()
                            connection3 = workspaceService.DescendantAdded:Connect(function(descendant)
                                if descendant.Name == "AnimalOverhead" then
                                    task.wait(0.05)
                                    findAnimalOverhead1201(descendant)
                                end
                            end)
                        end
                    end
                local connection4 = nil
                local function applyTrapChams(instance1212)
                    if not settings.toggles.trapMineChams or not instance1212 or not instance1212.Parent then
                        return
                    end
                    local lowerResult1213 = (instance1212.Name or ""):lower()
                    if lowerResult1213:find("mine") or lowerResult1213:find("trap") then
                        createHighlight(
                            instance1212:IsA("Model") and instance1212
                                or instance1212:FindFirstAncestorOfClass("Model")
                                or instance1212,
                    end
                    return
                end
                createToggle(
                    appState.espContent,
                    settings.toggles.trapMineChams or false,
                    function(trapMineChams)
                        settings.toggles.trapMineChams = trapMineChams
                        settings.toggles.trapESP = trapMineChams
                        saveSettings()
                        if connection4 then
                            connection4:Disconnect()
                            connection4 = nil
                        end
                        removeHighlight(workspaceService, "IceHub_TrapMineChams")
                        if trapMineChams then
                            for _, descendant in ipairs(workspaceService:GetDescendants()) do
                                applyTrapChams(descendant)
                            end
                            connection4 = workspaceService.DescendantAdded:Connect(function(descendant)
                                task.wait(0.03)
                                applyTrapChams(descendant)
                            end)
                        end
                    end
                task.defer(function()
                    if settings.toggles.playerChams then
                        for _, player in ipairs(playersService:GetPlayers()) do
                            if player ~= localPlayer then
                                applyPlayerChams(player)
                            end
                        end
                    end
                    if settings.toggles.selfChams then
                        applySelfChams(localPlayer.Character)
                    end
                    if settings.toggles.brainrotChams then
                        findDebris1204()
                    end
                    if settings.toggles.trapMineChams then
                        for _, descendant in ipairs(workspaceService:GetDescendants()) do
                            applyTrapChams(descendant)
                        end
                    end
                end)
            end)
        end
            local screenGui4 = Instance.new("ScreenGui")
            screenGui4.Name = "ICE_HUB_REJOIN_GUI"
            screenGui4:SetAttribute("IceHubOwned", true)
            screenGui4.ResetOnSpawn = false
            screenGui4.DisplayOrder = 1003
            screenGui4.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            attachGui(screenGui4)
            frame3 = Instance.new("Frame")
            frame3.Name = "RejoinWindow"
            frame3.Size = UDim2.new(0, isMobile and 160 or 150, 0, isMobile and 76 or 68)
            frame3.Position = UDim2.new(1, -(isMobile and 175 or 160), 0, 95)
            frame3.BackgroundColor3 = Color3.fromRGB(7, 20, 42)
            frame3.BackgroundTransparency = 0.42
            frame3.BorderSizePixel = 0
            frame3.Visible = settings.toggles.showRejoinGui ~= false
            frame3.Active = true
            frame3.Parent = screenGui4
        end
        createUICorner(frame3, 10)
        addGradientStroke(frame3, 1)
            local instance = Instance.new("TextLabel")
            instance.Name = "DragBar"
            instance.Size = UDim2.new(1, -8, 0, isMobile and 24 or 21)
            instance.Position = UDim2.new(0, 4, 0, 4)
            instance.BackgroundColor3 = Color3.fromRGB(12, 35, 68)
            instance.BackgroundTransparency = 0.25
            instance.BorderSizePixel = 0
            instance.Text = "REJOIN  •  DRAG"
            instance.TextColor3 = Color3.fromRGB(185, 225, 255)
            instance.TextSize = isMobile and 11 or 10
            instance.Font = Enum.Font.GothamBold
            instance.Active = true
            instance.Parent = frame3
            createUICorner(instance, 7)
            local textButton2 = Instance.new("TextButton")
            textButton2.Size = UDim2.new(1, -8, 1, -(isMobile and 36 or 33))
            textButton2.Position = UDim2.new(0, 4, 0, isMobile and 31 or 28)
            textButton2.BackgroundColor3 = Color3.fromRGB(16, 49, 92)
            textButton2.BackgroundTransparency = 0.22
            textButton2.BorderSizePixel = 0
            textButton2.Text = "REJOIN"
            textButton2.TextColor3 = appState.COL_WHITE
            textButton2.TextSize = isMobile and 13 or 12
            textButton2.Font = Enum.Font.GothamBlack
            textButton2.AutoButtonColor = false
            textButton2.Parent = frame3
            createUICorner(textButton2, 7)
            addGradientStroke(textButton2, 1)
            textButton2.MouseButton1Click:Connect(function()
                pcall(function()
                    TeleportService:Teleport(game.PlaceId, localPlayer)
                end)
            end)
                local isActive1225 = false
                local position = nil
                local position2 = nil
                instance.InputBegan:Connect(function(input)
                        input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch
                    then
                        isActive1225 = true
                        position = input.Position
                        position2 = frame3.Position
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if not isActive1225 then
                        return
                    end
                        input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch
                    then
                        local calculatedValue1230 = input.Position - position
                        frame3.Position = UDim2.new(
                            position2.X.Scale,
                            position2.X.Offset + calculatedValue1230.X,
                            position2.Y.Scale,
                            position2.Y.Offset + calculatedValue1230.Y
                    end
                    return
                end)
                UserInputService.InputEnded:Connect(function(input)
                        input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch
                    then
                        isActive1225 = false
                    end
                end)
            end
        end
        task.spawn(function()
            local spFrame1236, spContent1237, openServerPanel1238, closeServerPanel1239 =
                createPanelContainer("Server / Settings", "server")
            appState.spFrame = spFrame1236
            appState.spContent = spContent1237
            appState.openServerPanel = openServerPanel1238
            appState.closeServerPanel = closeServerPanel1239
            local textButton2 = Instance.new("TextButton")
            textButton2.Size = UDim2.new(1, -20, 0, isMobile and 38 or 34)
            textButton2.BackgroundColor3 = Color3.fromRGB(15, 31, 57)
            textButton2.BackgroundTransparency = 0.2
            textButton2.BorderSizePixel = 0
            textButton2.Text = "Rejoin Server"
            textButton2.TextColor3 = appState.COL_WHITE
            textButton2.TextSize = isMobile and 12 or 12
            textButton2.Font = Enum.Font.GothamBold
            textButton2.AutoButtonColor = false
            textButton2.ZIndex = 12
            textButton2.Parent = appState.spContent
            createUICorner(textButton2, 6)
            addGradientStroke(textButton2, 1)
            textButton2.MouseButton1Click:Connect(function()
                pcall(function()
                    TeleportService:Teleport(game.PlaceId, localPlayer)
                    return
                end)
            end)
            createToggle(
                appState.spContent,
                settings.toggles.showRejoinGui ~= false,
                function(showRejoinGui)
                    settings.toggles.showRejoinGui = showRejoinGui
                    frame3.Visible = showRejoinGui
                    saveSettings()
                end
        end)
        adminPanelGui = Instance.new("ScreenGui")
        adminPanelGui.Name = "ICE_HUB_ADMIN_GUI"
        adminPanelGui:SetAttribute("IceHubOwned", true)
        adminPanelGui.ResetOnSpawn = false
        adminPanelGui.DisplayOrder = 1002
        adminPanelGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        attachGui(adminPanelGui)
        task.spawn(function()
            local calculatedValue1242 = isMobile and 390 or 450
            local calculatedValue1243 = isMobile and 44 or 42
            local calculatedValue1244 = isMobile and 30 or 30
            local textOptions1245 = {
            local frame4 = Instance.new("Frame")
            frame4.Name = "AdminPanelWindow"
            frame4.Size = UDim2.new(0, calculatedValue1242, 0, 220)
            frame4.Position = UDim2.new(
                settings.panels.ap.x or 0.72,
                settings.panels.ap.xOffset or 0,
                settings.panels.ap.y or 0.5,
                settings.panels.ap.yOffset or -150
            frame4.BackgroundColor3 = Color3.fromRGB(7, 20, 42)
            frame4.BackgroundTransparency = 0.68
            frame4.BorderSizePixel = 0
            frame4.Active = true
            frame4.Visible = settings.panels.ap.visible ~= false
            frame4.ZIndex = 20
            frame4.Parent = adminPanelGui
            createUICorner(frame4, 14)
            addGradientStroke(frame4, 2)
            local uiGradient = Instance.new("UIGradient")
            local lookupTable1250 = {}
            local colorKeypoint1251 = ColorSequenceKeypoint.new(0, Color3.fromRGB(7, 14, 33))
            local colorKeypoint1252 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(10, 27, 55))
            lookupTable1250[1] = colorKeypoint1251
            lookupTable1250[2] = colorKeypoint1252
            lookupTable1250[3] = ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 10, 24))
            uiGradient.Color = ColorSequence.new(lookupTable1250)
            uiGradient.Rotation = 130
            uiGradient.Parent = frame4
            local frame5 = Instance.new("Frame")
            frame5.Size = UDim2.new(1, 0, 0, 42)
            frame5.BackgroundTransparency = 1
            frame5.BorderSizePixel = 0
            frame5.ZIndex = 21
            frame5.Parent = frame4
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, -90, 1, 0)
            textLabel.Position = UDim2.new(0, 13, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = "Admin Panel"
            textLabel.TextColor3 = Color3.fromRGB(225, 242, 255)
            textLabel.TextSize = isMobile and 14 or 16
            textLabel.Font = Enum.Font.GothamBlack
            textLabel.TextXAlignment = Enum.TextXAlignment.Left
            textLabel.ZIndex = 22
            textLabel.Parent = frame5
            local textButton2 = Instance.new("TextButton")
            textButton2.Size = UDim2.new(0, 58, 0, 26)
            textButton2.Position = UDim2.new(1, -92, 0.5, -13)
            textButton2.BackgroundColor3 = Color3.fromRGB(18, 65, 112)
            textButton2.BackgroundTransparency = 0.48
            textButton2.BorderSizePixel = 0
            textButton2.Text = "Refresh"
            textButton2.TextColor3 = Color3.fromRGB(205, 235, 255)
            textButton2.TextSize = 9
            textButton2.Font = Enum.Font.GothamBold
            textButton2.ZIndex = 23
            textButton2.Parent = frame5
            createUICorner(textButton2, 7)
            addGradientStroke(textButton2, 1)
            local textButton3 = Instance.new("TextButton")
            textButton3.Size = UDim2.new(0, 26, 0, 26)
            textButton3.Position = UDim2.new(1, -30, 0.5, -13)
            textButton3.BackgroundColor3 = Color3.fromRGB(18, 65, 112)
            textButton3.BackgroundTransparency = 0.48
            textButton3.BorderSizePixel = 0
            textButton3.Text = "×"
            textButton3.TextColor3 = Color3.fromRGB(200, 230, 255)
            textButton3.TextSize = 11
            textButton3.Font = Enum.Font.GothamBlack
            textButton3.ZIndex = 23
            textButton3.Parent = frame5
            createUICorner(textButton3, 7)
            addGradientStroke(textButton3, 1)
            local textLabel2 = Instance.new("TextLabel")
            textLabel2.Size = UDim2.new(1, -18, 0, 22)
            textLabel2.Position = UDim2.new(0, 9, 0, 44)
            textLabel2.BackgroundTransparency = 1
            textLabel2.Text = "Click player = spam all  |  icon = one function"
            textLabel2.TextColor3 = Color3.fromRGB(105, 185, 255)
            textLabel2.TextSize = 10
            textLabel2.Font = Enum.Font.GothamBold
            textLabel2.TextXAlignment = Enum.TextXAlignment.Left
            textLabel2.ZIndex = 22
            textLabel2.Parent = frame4
            local frame6 = Instance.new("Frame")
            frame6.Size = UDim2.new(1, -18, 0, 100)
            frame6.Position = UDim2.new(0, 9, 0, 70)
            frame6.BackgroundTransparency = 1
            frame6.ZIndex = 22
            frame6.Parent = frame4
            local uiListLayout = Instance.new("UIListLayout")
            uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            uiListLayout.Padding = UDim.new(0, 7)
            uiListLayout.Parent = frame6
            local function getAdminButton(commandName)
                return findAdminCommandButton(commandName)
            end
            local function resizeAdminPlayerList(playerCount)
                local maxResult1268 = math.max(1, playerCount)
                local calculatedValue1270 = maxResult1268 * calculatedValue1243 + math.max(0, maxResult1268 - 1) * 7
                frame6.Size = UDim2.new(1, -18, 0, calculatedValue1270)
                frame4.Size = UDim2.new(0, calculatedValue1242, 0, 82 + calculatedValue1270)
            end
            local function renderAdminPlayerList()
                for _, child in ipairs(frame6:GetChildren()) do
                    if child:IsA("Frame") then
                        child:Destroy()
                    end
                end
                local layoutOrder1274 = 0
                for _, player in ipairs(playersService:GetPlayers()) do
                    if player ~= localPlayer then
                        layoutOrder1274 += 1
                        local frame7 = Instance.new("Frame")
                        frame7.Size = UDim2.new(1, 0, 0, calculatedValue1243)
                        frame7.LayoutOrder = layoutOrder1274
                        frame7.BackgroundColor3 = Color3.fromRGB(12, 24, 49)
                        frame7.BackgroundTransparency = 0.45
                        frame7.BorderSizePixel = 0
                        frame7.ZIndex = 23
                        frame7.Parent = frame6
                        createUICorner(frame7, 7)
                        addGradientStroke(frame7, 1)
                        local calculatedValue1278 = #textOptions1245 * (calculatedValue1244 + 5) + 4
                        local instance = Instance.new("TextButton")
                        instance.Size = UDim2.new(1, -calculatedValue1278 - 8, 1, 0)
                        instance.Position = UDim2.new(0, 8, 0, 0)
                        instance.BackgroundTransparency = 1
                        instance.Text = (player.DisplayName or player.Name) .. "  (@" .. player.Name .. ")"
                        instance.TextColor3 = Color3.fromRGB(220, 255, 255)
                        instance.TextSize = isMobile and 10 or 12
                        instance.Font = Enum.Font.GothamBold
                        instance.TextXAlignment = Enum.TextXAlignment.Left
                        instance.TextTruncate = Enum.TextTruncate.AtEnd
                        instance.ZIndex = 24
                        instance.Parent = frame7
                        instance.MouseButton1Click:Connect(function()
                            task.spawn(function()
                                executeAllAdminCommands(player)
                            end)
                        end)
                        for i, text1281 in ipairs(textOptions1245) do
                            local textButton4 = Instance.new("TextButton")
                            textButton4.Name = "Quick_" .. text1281
                            textButton4.Size = UDim2.new(0, calculatedValue1244, 0, calculatedValue1244)
                            textButton4.Position = UDim2.new(
                                -((#textOptions1245 - i + 1) * (calculatedValue1244 + 5)) + 5,
                            textButton4.BackgroundColor3 = Color3.fromRGB(28, 23, 62)
                            textButton4.BackgroundTransparency = 0.02
                            textButton4.BorderSizePixel = 0
                            textButton4.Text = ""
                            textButton4.ZIndex = 25
                            textButton4.Parent = frame7
                            createUICorner(textButton4, 6)
                            addGradientStroke(textButton4, 1)
                            if not cloneAdminButtonIcon(getAdminButton(text1281), textButton4) then
                                textButton4.Text = "?"
                                textButton4.TextColor3 = Color3.fromRGB(235, 240, 255)
                                textButton4.TextSize = 12
                                textButton4.Font = Enum.Font.GothamBlack
                            end
                            textButton4.MouseButton1Click:Connect(function()
                                task.spawn(function()
                                    executeAdminCommand(player, text1281)
                                end)
                            end)
                        end
                    end
                end
                resizeAdminPlayerList(layoutOrder1274)
            end
            local isActive1283 = false
            local position = nil
            local position2 = nil
            frame5.InputBegan:Connect(function(input)
                    input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch
                then
                    isActive1283 = true
                    position = input.Position
                    position2 = frame4.Position
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                    and (
                        input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch
                then
                    local calculatedValue1288 = input.Position - position
                    frame4.Position = UDim2.new(
                        position2.X.Scale,
                        position2.X.Offset + calculatedValue1288.X,
                        position2.Y.Scale,
                        position2.Y.Offset + calculatedValue1288.Y
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                    input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch
                then
                    if isActive1283 then
                        isActive1283 = false
                        settings.panels.ap.x = frame4.Position.X.Scale
                        settings.panels.ap.xOffset = frame4.Position.X.Offset
                        settings.panels.ap.y = frame4.Position.Y.Scale
                        settings.panels.ap.yOffset = frame4.Position.Y.Offset
                        saveSettings()
                    end
                end
            end)
            local function openAPPanel()
                frame4.Visible = true
                settings.panels.ap.visible = true
                saveSettings()
                renderAdminPlayerList()
            end
            local function closeAPPanel()
                frame4.Visible = false
                settings.panels.ap.visible = false
                saveSettings()
            end
            appState.apFrame = frame4
            appState.apContent = frame6
            appState.openAPPanel = openAPPanel
            appState.closeAPPanel = closeAPPanel
            textButton3.MouseButton1Click:Connect(closeAPPanel)
            textButton2.MouseButton1Click:Connect(renderAdminPlayerList)
            playersService.PlayerAdded:Connect(function()
                task.wait(0.2)
                renderAdminPlayerList()
            end)
            playersService.PlayerRemoving:Connect(function()
                task.wait(0.2)
                renderAdminPlayerList()
            end)
            renderAdminPlayerList()
        end)
        task.spawn(function()
            local baseProtection, btContent1297, openBTPanel1298, closeBTPanel1299 =
                createPanelContainer("Base Protection", "baseTimer")
            appState.btFrame = baseProtection
            appState.btContent = btContent1297
            appState.openBTPanel = openBTPanel1298
            appState.closeBTPanel = closeBTPanel1299
            local intruderAlarm = settings.toggles.intruderAlarm or false
            local autoLeave = settings.toggles.autoLeave or false
            local autoLeaveCooldown = tonumber(settings.autoLeaveCooldown) or 2
            local isActive1303 = false
            local baseTimerESP = settings.toggles.baseTimerESP or false
            local lookupTable1305 = {}
            local baseTimerCache = setmetatable({}, {
                __mode = "kv",
            local instance1307 = nil
            local stealHitbox = nil
            local remainingTime = nil
            local numericValue1310 = 0
            local screenGui4 = Instance.new("ScreenGui")
            screenGui4.Name = "ICE_HUB_ALARM_GUI"
            screenGui4:SetAttribute("IceHubOwned", true)
            screenGui4.ResetOnSpawn = false
            screenGui4.DisplayOrder = 500
            screenGui4.Parent = playerGui
            local instance = Instance.new("TextLabel")
            instance.AnchorPoint = Vector2.new(0.5, 1)
            instance.Position = UDim2.new(0.5, 0, 0.92, 0)
            instance.Size = UDim2.new(0, 600, 0, 80)
            instance.BackgroundTransparency = 1
            instance.TextColor3 = Color3.fromRGB(255, 255, 70)
            instance.TextSize = 26
            instance.Font = Enum.Font.GothamBold
            instance.TextWrapped = true
            instance.TextStrokeTransparency = 0.3
            instance.TextStrokeColor3 = Color3.new(0, 0, 0)
            instance.Visible = false
            instance.Parent = screenGui4
            local function findPlots1313()
                if instance1307 and instance1307.Parent then
                    return instance1307
                end
                local plots = workspaceService:FindFirstChild("Plots")
                if not plots then
                    return nil
                end
                local lowerResult1315 = localPlayer.Name:lower()
                local lowerResult1316 = localPlayer.DisplayName:lower()
                for _, child in ipairs(plots:GetChildren()) do
                    local plotSign = child:FindFirstChild("PlotSign")
                    if plotSign then
                        local surfaceGui = plotSign:FindFirstChild("SurfaceGui")
                        surfaceGui = surfaceGui and surfaceGui:FindFirstChild("Frame")
                        surfaceGui = surfaceGui and surfaceGui:FindFirstChild("TextLabel")
                        local lowerResult1321
                        if surfaceGui then
                            lowerResult1321 = tostring(surfaceGui.Text or ""):lower()
                        else
                            lowerResult1321 = surfaceGui
                        end
                        local calculatedValue1322 = lowerResult1321 or ""
                        local yourBase = plotSign:FindFirstChild("YourBase", true)
                            calculatedValue1322:find(lowerResult1315, 1, true)
                            or calculatedValue1322:find(lowerResult1316, 1, true)
                            or yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled
                        then
                            instance1307 = child
                            return child
                        end
                    end
                end
                return nil
            end
            local function findStealHitbox1324()
                if stealHitbox and stealHitbox.Parent then
                    return stealHitbox
                end
                local findPlots1313Result1325 = findPlots1313()
                if not findPlots1313Result1325 then
                    return nil
                end
                stealHitbox = findPlots1313Result1325:FindFirstChild("StealHitbox", true)
                return stealHitbox
            end
            local function findPurchases1326()
                if remainingTime and remainingTime.Parent then
                    return remainingTime
                end
                local findPlots1313Result1327 = findPlots1313()
                if not findPlots1313Result1327 then
                    return nil
                end
                local purchases = findPlots1313Result1327:FindFirstChild("Purchases")
                purchases = purchases and purchases:FindFirstChild("PlotBlock")
                purchases = purchases and purchases:FindFirstChild("Main")
                purchases = purchases and purchases:FindFirstChild("BillboardGui")
                remainingTime = purchases and purchases:FindFirstChild("RemainingTime") or nil
                return remainingTime
            end
            local plots = workspaceService:FindFirstChild("Plots")
            if plots then
                plots.ChildAdded:Connect(function()
                    instance1307 = nil
                    stealHitbox = nil
                    remainingTime = nil
                end)
                plots.ChildRemoved:Connect(function(child)
                    if instance1307 == child then
                        instance1307 = nil
                        stealHitbox = nil
                        remainingTime = nil
                    end
                    baseTimerCache[child] = nil
                end)
            end
            local function parseTimerSeconds(timerText)
                local gsubResult1333 = tostring(timerText or ""):lower():gsub("%s+", "")
                local match, matchResult1335 = gsubResult1333:match("^(%d+):(%d+)$")
                if match and matchResult1335 then
                    return tonumber(match) * 60 + tonumber(matchResult1335)
                end
                local match2, matchResult1338, matchResult1339 = gsubResult1333:match("^(%d+):(%d+):(%d+)$")
                if match2 and matchResult1338 and matchResult1339 then
                    return tonumber(match2) * 3600 + tonumber(matchResult1338) * 60 + tonumber(matchResult1339)
                end
                local match3 = gsubResult1333:match("([%d%.]+)")
                return tonumber(match3)
            end
            local function updateVisibility1341()
                if isActive1303 then
                    return
                end
                isActive1303 = true
                instance.Text = "AUTO LEAVE • TIMER REACHED"
                instance.TextColor3 = Color3.fromRGB(80, 190, 255)
                instance.Visible = true
                task.spawn(function()
                    task.wait(0.05)
                    local isActive1342 = false
                    pcall(function()
                        if game.Shutdown then
                            game:Shutdown()
                            isActive1342 = true
                        end
                    end)
                    if not isActive1342 then
                        pcall(function()
                            localPlayer:Kick("Ice Hub • Auto Leave • Base timer reached")
                        end)
                    end
                end)
            end
            local function findPlayer1343()
                numericValue1310 += 1
                local monitorGeneration = numericValue1310
                task.spawn(function()
                    while intruderAlarm and monitorGeneration == numericValue1310 do
                        local findStealHitbox1324Result1345 = findStealHitbox1324()
                        if not findStealHitbox1324Result1345 then
                            instance.Visible = false
                        else
                            local cFrame = findStealHitbox1324Result1345.CFrame
                            local size = findStealHitbox1324Result1345.Size
                            local calculatedValue1348 = size.X * 0.5
                            local calculatedValue1349 = size.Z * 0.5
                            local lookupTable1350 = {}
                            for _, player in ipairs(playersService:GetPlayers()) do
                                if player ~= localPlayer and player.Character then
                                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                                    if humanoidRootPart then
                                        local pointToObjectSpaceResult1354 =
                                            cFrame:PointToObjectSpace(humanoidRootPart.Position)
                                            math.abs(pointToObjectSpaceResult1354.X) <= calculatedValue1348
                                            and math.abs(pointToObjectSpaceResult1354.Z) <= calculatedValue1349
                                        then
                                            table.insert(lookupTable1350, player.Name)
                                        end
                                    end
                                end
                            end
                            if #lookupTable1350 > 0 then
                                instance.TextColor3 = Color3.fromRGB(80, 190, 255)
                                instance.Text = "🚨 "
                                    .. #lookupTable1350
                                    .. " Player"
                                    .. (#lookupTable1350 > 1 and "s" or "")
                                    .. " in your Base! 🚨\n"
                                    .. table.concat(lookupTable1350, ", ")
                                instance.Visible = true
                            else
                                instance.Visible = false
                            end
                        end
                        task.wait(0.25)
                    end
                end)
            end
            local function clearBaseTimerEsp()
                for _, instance1357 in pairs(lookupTable1305) do
                    if instance1357 then
                        pcall(function()
                            instance1357:Destroy()
                        end)
                    end
                end
                lookupTable1305 = {}
            end
            local function readBaseTimerText(textElement1359)
                local isValid1360 = not textElement1359
                if not isValid1360 then
                    isValid1360 = not (
                        textElement1359:IsA("TextLabel")
                        or textElement1359:IsA("TextButton")
                        or textElement1359:IsA("TextBox")
                end
                if isValid1360 then
                    return false
                end
                local gsubResult1361 = tostring(textElement1359.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
                if gsubResult1361 == "" then
                    return false
                end
                local gsubResult1362 = gsubResult1361:gsub("%s+", "")
                if gsubResult1362:match("^%d+:%d+$") or gsubResult1362:match("^%d+:%d+:%d+$") then
                    return true
                end
                if gsubResult1362:lower():match("^%d+%.?%d*s$") then
                    return true
                end
                local lowerResult1363 = tostring(textElement1359.Name or ""):lower()
                        lowerResult1363:find("time", 1, true)
                        or lowerResult1363:find("lock", 1, true)
                        or lowerResult1363:find("cooldown", 1, true)
                        or lowerResult1363:find("open", 1, true)
                    ) and gsubResult1362:match("%d")
                then
                    return true
                end
                return false
            end
            local function createPart1364(parent)
                if not parent then
                    return nil, nil
                end
                local timerState1366 = baseTimerCache[parent]
                    and timerState1366.timer
                    and timerState1366.timer.Parent
                    and timerState1366.anchor
                    and timerState1366.anchor.Parent
                then
                    return timerState1366.timer, timerState1366.anchor
                end
                local purchases = parent:FindFirstChild("Purchases")
                purchases = purchases and purchases:FindFirstChild("PlotBlock")
                local main = purchases and purchases:FindFirstChild("Main")
                local billboardGui = main and main:FindFirstChild("BillboardGui")
                billboardGui = billboardGui and billboardGui:FindFirstChild("RemainingTime")
                    or parent:FindFirstChild("RemainingTime", true)
                if not billboardGui or not readBaseTimerText(billboardGui) then
                    return nil, nil
                end
                local iceHubTimerFloor1Anchor = parent:FindFirstChild("IceHubTimerFloor1Anchor")
                if not iceHubTimerFloor1Anchor or not iceHubTimerFloor1Anchor:IsA("BasePart") then
                    if iceHubTimerFloor1Anchor then
                        pcall(function()
                            iceHubTimerFloor1Anchor:Destroy()
                        end)
                    end
                    iceHubTimerFloor1Anchor = Instance.new("Part")
                    iceHubTimerFloor1Anchor.Name = "IceHubTimerFloor1Anchor"
                    iceHubTimerFloor1Anchor.Size = Vector3.new(0.2, 0.2, 0.2)
                    iceHubTimerFloor1Anchor.Anchored = true
                    iceHubTimerFloor1Anchor.CanCollide = false
                    iceHubTimerFloor1Anchor.CanTouch = false
                    iceHubTimerFloor1Anchor.CanQuery = false
                    iceHubTimerFloor1Anchor.Transparency = 1
                    iceHubTimerFloor1Anchor.Parent = parent
                end
                local position = parent:GetPivot().Position
                iceHubTimerFloor1Anchor.CFrame = CFrame.new(position.X, -6, position.Z)
                baseTimerCache[parent] = {
                    timer = billboardGui,
                    anchor = iceHubTimerFloor1Anchor,
                return billboardGui, iceHubTimerFloor1Anchor
            end
            local function refreshBaseTimerEsp()
                if not baseTimerESP then
                    clearBaseTimerEsp()
                    return
                end
                local plots2 = workspaceService:FindFirstChild("Plots")
                if not plots2 then
                    clearBaseTimerEsp()
                    return
                end
                local lookupTable1374 = {}
                for _, child in ipairs(plots2:GetChildren()) do
                    if child:IsA("Model") then
                        local createPart1364Result1377, adornee1378 = createPart1364(child)
                        if createPart1364Result1377 and adornee1378 then
                            lookupTable1374[child] = true
                            local instance2 = lookupTable1305[child]
                            if instance2 and instance2.Parent then
                                instance2.Adornee = adornee1378
                            end
                            if not instance2 or not instance2.Parent then
                                instance2 = Instance.new("BillboardGui")
                                instance2.Name = generateRandomGuiName()
                                instance2.Size = UDim2.new(0, 150, 0, 38)
                                instance2.StudsOffset = Vector3.new(0, 3, 0)
                                instance2.AlwaysOnTop = true
                                instance2.Adornee = adornee1378
                                instance2.MaxDistance = 2000
                                instance2.Parent = child
                                local textLabel = Instance.new("TextLabel")
                                textLabel.Name = "TimerText"
                                textLabel.Size = UDim2.new(1, 0, 1, 0)
                                textLabel.BackgroundTransparency = 1
                                textLabel.TextSize = 22
                                textLabel.Font = Enum.Font.GothamBlack
                                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                                textLabel.TextStrokeTransparency = 0
                                textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                                textLabel.Parent = instance2
                                lookupTable1305[child] = instance2
                            else
                                instance2.Adornee = adornee1378
                            end
                            local timerText = instance2:FindFirstChild("TimerText")
                            if timerText then
                                local text1382 = tostring(createPart1364Result1377.Text or "")
                                timerText.Text = text1382 ~= "" and text1382 or "0:00"
                            end
                        end
                    end
                end
                for k, instance1384 in pairs(lookupTable1305) do
                    if not lookupTable1374[k] or not k.Parent then
                        if instance1384 then
                            pcall(function()
                                instance1384:Destroy()
                            end)
                        end
                        lookupTable1305[k] = nil
                    end
                end
            end
            task.spawn(function()
                while true do
                    task.wait(autoLeave and 0.25 or baseTimerESP and 1 or 2)
                    if baseTimerESP then
                        pcall(refreshBaseTimerEsp)
                    end
                    if autoLeave and not isActive1303 then
                        pcall(function()
                            local findPurchases1326Result1385 = findPurchases1326()
                            if not findPurchases1326Result1385 then
                                return
                            end
                            local parseTimerSecondsResult1386 = parseTimerSeconds(findPurchases1326Result1385.Text)
                                and parseTimerSecondsResult1386 > 0
                                and parseTimerSecondsResult1386 <= autoLeaveCooldown
                            then
                                updateVisibility1341()
                            end
                        end)
                    end
                end
            end)
            createToggle(appState.btContent, "Intruder Alarm", intruderAlarm, function(intruderAlarm2)
                intruderAlarm = intruderAlarm2
                settings.toggles.intruderAlarm = intruderAlarm2
                saveSettings()
                if intruderAlarm2 then
                    findPlayer1343()
                else
                    numericValue1310 += 1
                    instance.Visible = false
                end
            end)
            createToggle(appState.btContent, "Auto Leave", autoLeave, function(autoLeave2)
                autoLeave = autoLeave2
                settings.toggles.autoLeave = autoLeave2
                saveSettings()
                if autoLeave2 then
                    isActive1303 = false
                end
            end)
            local frame4 = Instance.new("Frame")
            frame4.Size = UDim2.new(1, -20, 0, isMobile and 36 or 32)
            frame4.BackgroundColor3 = Color3.fromRGB(15, 31, 57)
            frame4.BackgroundTransparency = 0.2
            frame4.BorderSizePixel = 0
            frame4.ZIndex = 12
            frame4.Parent = appState.btContent
            createUICorner(frame4, 6)
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, -78, 1, 0)
            textLabel.Position = UDim2.new(0, 8, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = "Leave At Timer"
            textLabel.TextColor3 = appState.COL_WHITE
            textLabel.TextSize = isMobile and 13 or 11
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextXAlignment = Enum.TextXAlignment.Left
            textLabel.ZIndex = 13
            textLabel.Parent = frame4
            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(0, 58, 0, isMobile and 24 or 20)
            textBox.Position = UDim2.new(1, -66, 0.5, isMobile and -12 or -10)
            textBox.BackgroundColor3 = Color3.fromRGB(8, 22, 45)
            textBox.BackgroundTransparency = 0.15
            textBox.BorderSizePixel = 0
            textBox.Text = tostring(autoLeaveCooldown)
            textBox.TextColor3 = Color3.fromRGB(80, 205, 255)
            textBox.TextSize = isMobile and 12 or 10
            textBox.Font = Enum.Font.GothamBold
            textBox.ClearTextOnFocus = false
            textBox.ZIndex = 13
            textBox.Parent = frame4
            createUICorner(textBox, 5)
            addGradientStroke(textBox, 1)
            textBox.FocusLost:Connect(function()
                local num = tonumber(textBox.Text)
                if not num then
                    textBox.Text = tostring(autoLeaveCooldown)
                    return
                end
                local clampResult1393 = math.clamp(num, 0, 60)
                autoLeaveCooldown = math.floor(clampResult1393 * 10 + 0.5) / 10
                isActive1303 = false
                settings.autoLeaveCooldown = autoLeaveCooldown
                textBox.Text = tostring(autoLeaveCooldown)
                saveSettings()
            end)
            createToggle(appState.btContent, "Timer ESP", baseTimerESP, function(baseTimerESP2)
                baseTimerESP = baseTimerESP2
                settings.toggles.baseTimerESP = baseTimerESP2
                saveSettings()
                if not baseTimerESP2 then
                    clearBaseTimerEsp()
                end
            end)
            createActionButton(appState.btContent, "Clear All Timers", function()
                clearBaseTimerEsp()
            end)
        end)
        createPanelSection = function(parent, sectionTitle)
            local instance = Instance.new("Frame")
            instance.Name = generateRandomGuiName()
            instance.Size = UDim2.new(1, 0, 0, 0)
            instance.AutomaticSize = Enum.AutomaticSize.Y
            instance.BackgroundColor3 = Color3.fromRGB(7, 24, 50)
            instance.BackgroundTransparency = 0.48
            instance.BorderSizePixel = 0
            instance.ZIndex = 12
            instance.LayoutOrder = #parent:GetChildren()
            instance.Parent = parent
            createUICorner(instance, 10)
            local uiStroke = Instance.new("UIStroke")
            uiStroke.Color = Color3.fromRGB(65, 145, 255)
            uiStroke.Thickness = 1
            uiStroke.Transparency = 0.45
            uiStroke.Parent = instance
            local uiListLayout = Instance.new("UIListLayout")
            uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            uiListLayout.Padding = UDim.new(0, 5)
            uiListLayout.Parent = instance
            local instance2 = Instance.new("UIPadding")
            instance2.PaddingTop = UDim.new(0, 7)
            instance2.PaddingBottom = UDim.new(0, 8)
            instance2.PaddingLeft = UDim.new(0, 8)
            instance2.PaddingRight = UDim.new(0, 8)
            instance2.Parent = instance
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 0, isMobile and 24 or 21)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = string.upper(sectionTitle)
            textLabel.TextColor3 = Color3.fromRGB(130, 200, 255)
            textLabel.TextSize = isMobile and 13 or 11
            textLabel.Font = Enum.Font.GothamBlack
            textLabel.TextXAlignment = Enum.TextXAlignment.Left
            textLabel.ZIndex = 13
            textLabel.LayoutOrder = 1
            textLabel.Parent = instance
            local frame4 = Instance.new("Frame")
            frame4.Size = UDim2.new(1, 0, 0, 1)
            frame4.BackgroundColor3 = Color3.fromRGB(60, 145, 255)
            frame4.BackgroundTransparency = 0.45
            frame4.BorderSizePixel = 0
            frame4.ZIndex = 13
            frame4.LayoutOrder = 2
            frame4.Parent = instance
            local frame5 = Instance.new("Frame")
            frame5.Size = UDim2.new(1, 0, 0, 0)
            frame5.AutomaticSize = Enum.AutomaticSize.Y
            frame5.BackgroundTransparency = 1
            frame5.ZIndex = 12
            frame5.LayoutOrder = 3
            frame5.Parent = instance
            local uiListLayout2 = Instance.new("UIListLayout")
            uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
            uiListLayout2.Padding = UDim.new(0, isMobile and 6 or 5)
            uiListLayout2.Parent = frame5
            return frame5, instance
        end
            local function getGuiText(textElement1407)
                if textElement1407:IsA("TextButton") and textElement1407.Text and textElement1407.Text ~= "" then
                    return textElement1407.Text
                end
                for _, descendant in ipairs(textElement1407:GetDescendants()) do
                        (descendant:IsA("TextLabel") or descendant:IsA("TextButton"))
                        and descendant.Text
                        and descendant.Text ~= ""
                    then
                        return descendant.Text
                    end
                end
                return ""
            end
            local function moveGuiChildren(instance1411, parent)
                if not instance1411 or not parent then
                    return
                end
                local lookupTable1413 = {}
                for _, child in ipairs(instance1411:GetChildren()) do
                    if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                        table.insert(lookupTable1413, child)
                    end
                end
                for i, instance1417 in ipairs(lookupTable1413) do
                    if instance1417:IsA("GuiObject") then
                        instance1417.Size = UDim2.new(1, 0, instance1417.Size.Y.Scale, instance1417.Size.Y.Offset)
                        instance1417.LayoutOrder = i
                    end
                    instance1417.Parent = parent
                end
            end
            mergePanelSection = function(sourceContainer, instance1419, createPanelSectionResult1420, sectionTitle)
                if not sourceContainer or not createPanelSectionResult1420 then
                    return
                end
                if sectionTitle then
                    createPanelSectionResult1420 = createPanelSection(createPanelSectionResult1420, sectionTitle)
                end
                moveGuiChildren(sourceContainer, createPanelSectionResult1420)
                if instance1419 then
                    pcall(function()
                        instance1419:Destroy()
                    end)
                end
            end
            mergeEspSections = function(instance1422, instance1423, targetParent)
                if not instance1422 or not targetParent then
                    return
                end
                local playerEspFull = createPanelSection(targetParent, "Player ESP Full")
                local brainrotEspFull = createPanelSection(targetParent, "Brainrot ESP Full")
                local createPanelSectionResult1427 = createPanelSection(targetParent, "Trap / Mine ESP")
                local lookupTable1428 = {}
                for _, child in ipairs(instance1422:GetChildren()) do
                    if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                        table.insert(lookupTable1428, child)
                    end
                end
                local otherEspSection = nil
                for _, instance1433 in ipairs(lookupTable1428) do
                    local lowerResult1434 = string.lower(getGuiText(instance1433))
                    local otherEsp
                    if lowerResult1434:find("player", 1, true) or lowerResult1434:find("self chams", 1, true) then
                        otherEsp = playerEspFull
                    elseif
                        lowerResult1434:find("brainrot", 1, true)
                        or lowerResult1434:find("best brainrot", 1, true)
                        or lowerResult1434:find("line to best", 1, true)
                    then
                        otherEsp = brainrotEspFull
                    elseif lowerResult1434:find("trap", 1, true) or lowerResult1434:find("mine", 1, true) then
                        otherEsp = createPanelSectionResult1427
                    elseif not otherEspSection then
                        otherEsp = createPanelSection(targetParent, "Other ESP")
                        otherEspSection = otherEsp
                    else
                        otherEsp = otherEspSection
                    end
                    if instance1433:IsA("GuiObject") then
                        instance1433.Size = UDim2.new(1, 0, instance1433.Size.Y.Scale, instance1433.Size.Y.Offset)
                    end
                    instance1433.Parent = otherEsp
                end
                if instance1423 then
                    pcall(function()
                        instance1423:Destroy()
                    end)
                end
            end
        end
    end
    local createPanelSectionResult1436, isActive1437, isActive1438, triggerProximityPrompt1439
    createPanelSectionResult1436 = createPanelSection(stealerTab, "Stealer")
        local ProximityPromptService = game:GetService("ProximityPromptService")
        isActive1437 = false
        isActive1438 = false
        if getgenv().ICEHUB_INSTA_PROMPT then
            pcall(function()
                getgenv().ICEHUB_INSTA_PROMPT:Disconnect()
            end)
            getgenv().ICEHUB_INSTA_PROMPT = nil
        end
        triggerProximityPrompt1439 = function()
            if getgenv().ICEHUB_INSTA_PROMPT then
                pcall(function()
                    getgenv().ICEHUB_INSTA_PROMPT:Disconnect()
                end)
                getgenv().ICEHUB_INSTA_PROMPT = nil
            end
            isActive1437 = false
            local promptButtonHoldBegan = ProximityPromptService.PromptButtonHoldBegan
            getgenv().ICEHUB_INSTA_PROMPT = promptButtonHoldBegan:Connect(function(instance1442)
                if not isActive1438 or isActive1437 or not instance1442 or not instance1442.Parent then
                    return
                end
                local lowerResult1443 = tostring(instance1442.ActionText or ""):lower()
                local pos = lowerResult1443:find("grab", 1, true)
                local pos2 = lowerResult1443:find("place", 1, true)
                if not pos and not pos2 then
                    return
                end
                isActive1437 = true
                pcall(function()
                    if type(fireproximityprompt) == "function" then
                        fireproximityprompt(instance1442)
                    else
                        instance1442:InputHoldBegin()
                        task.wait(0.01)
                        instance1442:InputHoldEnd()
                    end
                end)
                task.delay(0.5, function()
                    isActive1437 = false
                end)
            end)
        end
    end
        local function setInstantPromptEnabled(enabled)
            isActive1438 = enabled and true or false
            isActive1437 = false
            if isActive1438 then
                triggerProximityPrompt1439()
            elseif getgenv().ICEHUB_INSTA_PROMPT then
                pcall(function()
                    getgenv().ICEHUB_INSTA_PROMPT:Disconnect()
                end)
                getgenv().ICEHUB_INSTA_PROMPT = nil
            end
        end
        createSavedToggle(createPanelSectionResult1436, "Insta Grab / Place", "instaGrabPrompt", function(enabled)
            setInstantPromptEnabled(enabled)
        end)
        if settings.toggles.instaGrabPrompt then
            setInstantPromptEnabled(true)
        end
    end
end
local HttpService, localPlayer2, genv, request_
    local quickHelper = createPanelSection(helperTab, "Quick Helper")
    createSavedToggle(quickHelper, "Unlock Base", "unlockBase", function(visible)
        for _, topButton in ipairs(appState.topButtons) do
            topButton.Visible = visible
        end
    end)
    appState.antiBeeApply = function(enabled)
        appState.antiBeeState = appState.antiBeeState
            or {
                enabled = false,
                lightingConn = nil,
                workspaceConn = nil,
                playerGuiConn = nil,
                cameraConn = nil,
                cameraChangedConn = nil,
        local function disconnectAntiBeeConnection(index1461)
            local disconnectState1462 = appState.antiBeeState[index1461]
            if disconnectState1462 then
                pcall(function()
                    disconnectState1462:Disconnect()
                end)
                appState.antiBeeState[index1461] = nil
            end
        end
        local function disconnectAntiBeeConnections()
            disconnectAntiBeeConnection("lightingConn")
            disconnectAntiBeeConnection("workspaceConn")
            disconnectAntiBeeConnection("playerGuiConn")
            disconnectAntiBeeConnection("cameraConn")
            disconnectAntiBeeConnection("cameraChangedConn")
        end
        local function isBeeRelated(parent1465)
            if not parent1465 then
                return false
            end
            for i = 1, 4 do
                if not parent1465 then
                    break
                end
                local lowerResult1467 = tostring(parent1465.Name or ""):lower()
                    lowerResult1467:find("bee", 1, true)
                    or lowerResult1467:find("honey", 1, true)
                    or lowerResult1467:find("sting", 1, true)
                    or lowerResult1467:find("swarm", 1, true)
                    or lowerResult1467:find("wasp", 1, true)
                then
                    return true
                end
                parent1465 = parent1465.Parent
            end
            return false
        end
        local function isBeeEffect(instance1469)
            return instance1469:IsA("BlurEffect")
                or instance1469:IsA("ColorCorrectionEffect")
                or instance1469:IsA("BloomEffect")
                or instance1469:IsA("SunRaysEffect")
                or instance1469:IsA("DepthOfFieldEffect")
                or instance1469:IsA("ParticleEmitter")
                or instance1469:IsA("Smoke")
                or instance1469:IsA("Fire")
                or instance1469:IsA("Sparkles")
                or instance1469:IsA("Beam")
                or instance1469:IsA("Trail")
                or instance1469:IsA("Highlight")
        end
        local function removeBeeEffect(instance1471)
            if not appState.antiBeeState.enabled or not instance1471 or not instance1471.Parent then
                return
            end
            if isBeeRelated(instance1471) and isBeeEffect(instance1471) then
                pcall(function()
                    instance1471:Destroy()
                end)
            end
        end
        local function shouldApplyAntiBee()
            if appState.antiBeeState.enabled then
                if settings.toggles.gameStretcher or appState.gameStretcherEnabled then
                    return false
                end
                if settings.toggles.customFOV then
                    return false
                end
                return true
            end
            return false
        end
        local function bindEvents1473()
            disconnectAntiBeeConnection("cameraConn")
            if workspaceService.CurrentCamera then
                if shouldApplyAntiBee() and workspaceService.CurrentCamera.FieldOfView ~= 70 then
                    workspaceService.CurrentCamera.FieldOfView = 70
                end
                appState.antiBeeState.cameraConn = workspaceService.CurrentCamera
                    :GetPropertyChangedSignal("FieldOfView")
                    :Connect(function()
                            shouldApplyAntiBee()
                            and workspaceService.CurrentCamera.Parent
                            and workspaceService.CurrentCamera.FieldOfView ~= 70
                        then
                            workspaceService.CurrentCamera.FieldOfView = 70
                        end
                    end)
                return
            end
            return
        end
        disconnectAntiBeeConnections()
        appState.antiBeeState.enabled = enabled == true
        if not appState.antiBeeState.enabled then
            if workspaceService.CurrentCamera then
                if settings.toggles.gameStretcher or appState.gameStretcherEnabled then
                    workspaceService.CurrentCamera.FieldOfView = 100
                elseif settings.toggles.customFOV then
                    workspaceService.CurrentCamera.FieldOfView = 120
                else
                    workspaceService.CurrentCamera.FieldOfView = 70
                end
            end
            return
        end
        appState.antiBeeState.lightingConn = Lighting.DescendantAdded:Connect(function(descendant)
            task.defer(removeBeeEffect, descendant)
        end)
        appState.antiBeeState.workspaceConn = workspaceService.DescendantAdded:Connect(function(descendant)
            task.defer(removeBeeEffect, descendant)
        end)
        appState.antiBeeState.playerGuiConn = playerGui.DescendantAdded:Connect(function(descendant)
            task.defer(removeBeeEffect, descendant)
        end)
        for _, instance1480 in ipairs({
            Lighting,
            localPlayer.Character,
            workspaceService.CurrentCamera,
        }) do
            if instance1480 then
                for _, descendant in ipairs(instance1480:GetDescendants()) do
                    removeBeeEffect(descendant)
                end
            end
        end
        bindEvents1473()
        appState.antiBeeState.cameraChangedConn = workspaceService
            :GetPropertyChangedSignal("CurrentCamera")
            :Connect(function()
                task.defer(bindEvents1473)
            end)
    end
    createSavedToggle(quickHelper, "Anti Bee", "antiBee", function(enabled)
        if appState.antiBeeApply then
            appState.antiBeeApply(enabled)
        end
    end)
end
    local function findSemiTPWindow1484()
        settings.guiPositions = {
            main = {
                x = 0.5,
                xOffset = -appState.PANEL_W / 2,
                y = 0.5,
                yOffset = -appState.PANEL_H / 2,
            hud = {
                x = 0.5,
                xOffset = -hudWidth / 2,
                y = 0,
                yOffset = hudTopOffset,
            semiTp = {
                x = 0.02,
                xOffset = 0,
                y = 0.5,
                yOffset = -(isMobile and 305 or 320) / 2,
            instaReset = {
                x = 0.5,
                xOffset = 0,
                y = 0.5,
                yOffset = 120,
            autoDefense = {
                x = 0.5,
                xOffset = -230,
                y = 0,
                yOffset = 60,
            friendPanel = {
                x = 0.02,
                xOffset = 270,
                y = 0.5,
                yOffset = -(isMobile and 126 or 132) / 2,
            topButtons = {
                x = 0.5,
                xOffset = -calculatedValue521 / 2,
                y = 0,
                yOffset = layoutMargin,
        settings.panels = settings.panels or {}
        for k, item1486 in pairs({
            semitp = {
                x = 0.5,
                xOffset = -100,
                y = 0.5,
                yOffset = -190,
                visible = true,
            xray = {
                x = 0,
                xOffset = 20,
                y = 0.5,
                yOffset = -60,
                visible = true,
            booster = {
                x = 1,
                xOffset = -225,
                y = 0.5,
                yOffset = -117,
                visible = true,
            server = {
                x = 1,
                xOffset = -220,
                y = 0.5,
                yOffset = 128,
                visible = true,
            defender = {
                x = 1,
                xOffset = -420,
                y = 0.5,
                yOffset = -60,
                visible = true,
            ap = {
                x = 1,
                xOffset = -420,
                y = 0.5,
                yOffset = 100,
                visible = true,
            esp = {
                x = 1,
                xOffset = -620,
                y = 0.5,
                yOffset = -60,
                visible = true,
            stretch = {
                x = 1,
                xOffset = -620,
                y = 0.5,
                yOffset = 100,
                visible = true,
            balloon = {
                x = 0.5,
                xOffset = 250,
                y = 0.5,
                yOffset = -60,
                visible = true,
            turret = {
                x = 0.5,
                xOffset = 250,
                y = 0.5,
                yOffset = 60,
                visible = true,
            baseTimer = {
                x = 0.5,
                xOffset = 450,
                y = 0.5,
                yOffset = -60,
                visible = true,
        }) do
            settings.panels[k] = item1486
        end
        if appState.panel then
            appState.panel.Position = UDim2.new(0.5, -appState.PANEL_W / 2, 0.5, -appState.PANEL_H / 2)
        end
        if hudFrame then
            hudFrame.Position = UDim2.new(0.5, -hudWidth / 2, 0, hudTopOffset)
        end
        if textButton then
            textButton.Position = UDim2.new(0.5, -(isMobile and 41 or 44), 0, hudTopOffset + hudHeight + 5)
        end
        if frame2 then
            frame2.Position = UDim2.new(0.5, -calculatedValue521 / 2, 0, layoutMargin)
        end
        if semiTeleportGui then
            local semiTPWindow = semiTeleportGui:FindFirstChild("SemiTPWindow")
            if semiTPWindow then
                semiTPWindow.Position = UDim2.new(0.02, 0, 0.5, -semiTPWindow.Size.Y.Offset / 2)
            end
        end
        if appState.friendFrame and appState.friendFrame.Parent then
            appState.friendFrame.Position = UDim2.new(0.02, 270, 0.5, -appState.friendFrame.Size.Y.Offset / 2)
        end
        local lookupTable1488 = {
            CoreGui,
        pcall(function()
            if gethui then
                local hui = gethui()
                if hui then
                    table.insert(lookupTable1488, hui)
                end
            end
        end)
        for _, instance1491 in ipairs(lookupTable1488) do
            if instance1491 then
                local iceHubAutoDefense = instance1491:FindFirstChild("ICE_HUB_AUTO_DEFENSE")
                if iceHubAutoDefense then
                    local frame1493 = iceHubAutoDefense:FindFirstChildWhichIsA("Frame")
                    if frame1493 then
                        frame1493.Position = UDim2.new(0.5, -115, 0, 60)
                    end
                end
            end
        end
        saveSettings()
    end
    createActionButton(createPanelSection(helperTab, "Reset GUI"), "Reset GUI Positions", function()
        findSemiTPWindow1484()
    end)
end
createSavedToggle(createPanelSection(playerTab, "Player Core"), "Anti Ragdoll", "antiRagdoll", function(enabled)
    if enabled then
        if appState.Connections.antiRagdoll then
            return
        end
        appState.Connections.antiRagdoll = RunService.Heartbeat:Connect(function()
            if not settings.toggles.antiRagdoll then
                return
            end
            local character = localPlayer.Character
            if not character then
                return
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoid or not humanoidRootPart then
                return
            end
            local state = humanoid:GetState()
            local calculatedValue1499 = state == Enum.HumanoidStateType.Physics
                or state == Enum.HumanoidStateType.Ragdoll
                or state == Enum.HumanoidStateType.FallingDown
            local attribute = localPlayer:GetAttribute("RagdollEndTime")
            if attribute and attribute - workspaceService:GetServerTimeNow() > 0 then
                calculatedValue1499 = true
            end
            if calculatedValue1499 then
                pcall(function()
                    localPlayer:SetAttribute("RagdollEndTime", workspaceService:GetServerTimeNow())
                end)
                for _, descendant in ipairs(character:GetDescendants()) do
                        descendant:IsA("BallSocketConstraint")
                        or descendant:IsA("Attachment")
                            and string.find(descendant.Name, "RagdollAttachment", 1, true)
                    then
                        pcall(function()
                            descendant:Destroy()
                        end)
                    end
                end
                for _, descendant in ipairs(character:GetDescendants()) do
                    if descendant:IsA("Motor6D") and not descendant.Enabled then
                        descendant.Enabled = true
                    end
                end
                if humanoid.Health > 0 then
                    pcall(function()
                        humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end)
                end
                if workspaceService.CurrentCamera then
                    workspaceService.CurrentCamera.CameraSubject = humanoid
                end
                humanoidRootPart.Anchored = false
                humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                return
            end
            return
        end)
    elseif appState.Connections.antiRagdoll then
        appState.Connections.antiRagdoll:Disconnect()
        appState.Connections.antiRagdoll = nil
    end
end)
createSavedToggle(createPanelSection(worldTab, "World"), "Custom FOV", "customFOV", function(enabled)
    if workspaceService.CurrentCamera then
        if settings.toggles.gameStretcher or appState.gameStretcherEnabled then
            workspaceService.CurrentCamera.FieldOfView = 100
        elseif enabled then
            workspaceService.CurrentCamera.FieldOfView = 120
        elseif settings.toggles.antiBee then
            workspaceService.CurrentCamera.FieldOfView = 70
        else
            workspaceService.CurrentCamera.FieldOfView = 70
        end
    end
end)
createSectionHeader(uiTab, "Keybinds")
createActionButton(uiTab, "Semi TP Key: " .. tostring(settings.semitp.stealKey or "E"), function()
    if appState.openExecutePanel then
        appState.openExecutePanel()
    end
end)
createActionButton(uiTab, "Menu Key: T", function() end)
    local function waitForPanel(callback1509, onReady)
        task.spawn(function()
            local calculatedValue1511 = tick() + 1.5
            local callback1509Result1512
            while true do
                callback1509Result1512 = callback1509()
                if callback1509Result1512 then
                    break
                else
                    task.wait(0.01)
                    if not (calculatedValue1511 <= tick()) then
                    end
                    break
                end
            end
            if callback1509Result1512 then
                pcall(onReady)
            end
        end)
    end
    waitForPanel(function()
        return appState.btContent
    end, function()
        mergePanelSection(appState.btContent, appState.btFrame, helperTab, "Base Protection")
    end)
    waitForPanel(function()
        return appState.defContent
    end, function()
        mergePanelSection(appState.defContent, appState.defFrame, helperTab, "Base Defender")
    end)
    waitForPanel(function()
        return appState.balloonContent
    end, function()
        mergePanelSection(appState.balloonContent, appState.balloonFrame, helperTab, "Anti Balloon")
    end)
    waitForPanel(function()
        return appState.turretContent
    end, function()
        mergePanelSection(appState.turretContent, appState.turretFrame, helperTab, "Anti Turret")
    end)
    waitForPanel(function()
        return appState.espContent
    end, function()
        mergeEspSections(appState.espContent, appState.espFrame, espTab)
    end)
    waitForPanel(function()
        return appState.bpContent
    end, function()
        mergePanelSection(appState.bpContent, appState.bpFrame, playerTab, "Movement / Booster")
    end)
    waitForPanel(function()
        return appState.xpContent
    end, function()
        mergePanelSection(appState.xpContent, appState.xpFrame, worldTab, "Performance")
    end)
    waitForPanel(function()
        return appState.stretchContent
    end, function()
        mergePanelSection(appState.stretchContent, appState.stretchFrame, worldTab, "Game Stretcher")
    end)
    waitForPanel(function()
        return appState.spContent
    end, function()
        mergePanelSection(appState.spContent, appState.spFrame, serverTab, "Server")
        return
    end)
end
appState.openBalloonPanel = function() end
appState.closeBalloonPanel = function() end
appState.openTurretPanel = function() end
appState.closeTurretPanel = function() end
appState.openStretchPanel = function() end
appState.closeStretchPanel = function() end
appState.openXrayPanel = function() end
appState.closeXrayPanel = function() end
appState.openBoosterPanel = function() end
appState.closeBoosterPanel = function() end
appState.openESPPanel = function() end
appState.closeESPPanel = function() end
appState.openServerPanel = function() end
appState.closeServerPanel = function() end
appState.openDefenderPanel = function() end
appState.closeDefenderPanel = function() end
appState.openBTPanel = function() end
appState.closeBTPanel = function() end
    local function updateVisibility1513()
        appState.menuOpen = true
        settings.ui.menuOpen = true
        saveSettings()
        appState.panel.Visible = true
        appState.panel.Size = UDim2.new(0, appState.PANEL_W, 0, 0)
        appState.panel.BackgroundTransparency = 1
        pcall(function()
            TweenService:Create(appState.panel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, appState.PANEL_W, 0, appState.PANEL_H),
                BackgroundTransparency = 0.62,
            }):Play()
        end)
    end
    local function updateVisibility1514()
        appState.menuOpen = false
        settings.ui.menuOpen = false
        saveSettings()
        pcall(function()
            local tween = TweenService:Create(
                appState.panel,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                    Size = UDim2.new(0, appState.PANEL_W, 0, 0),
                    BackgroundTransparency = 1,
            tween:Play()
            tween.Completed:Connect(function()
                if not appState.menuOpen then
                    appState.panel.Visible = false
                end
            end)
        end)
    end
    if appState.menuOpen then
        updateVisibility1513()
    end
    textButton.MouseButton1Click:Connect(function()
        appState.menuOpen = not appState.menuOpen
        if appState.menuOpen then
            updateVisibility1513()
        else
            updateVisibility1514()
        end
    end)
    if not isMobile then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if input.KeyCode == Enum.KeyCode.T then
                appState.menuOpen = not appState.menuOpen
                if appState.menuOpen then
                    updateVisibility1513()
                else
                    updateVisibility1514()
                end
            elseif not gameProcessed then
                local text1518 = tostring(input.KeyCode)
                if text1518:gsub("Enum.KeyCode.", "") == semiTeleportSettings.stealKey then
                    task.spawn(runSemiTeleport)
                end
            end
        end)
    end
end
task.spawn(function()
    task.wait(0.05)
    for _, fState1521 in ipairs({}) do
        if fState1521.f then
            local visible = settings.toggles[fState1521.toggle]
            if visible == nil then
                visible = true
            end
            fState1521.f.Visible = visible
        end
    end
    if settings.toggles.customFOV then
        if workspaceService.CurrentCamera then
            workspaceService.CurrentCamera.FieldOfView = 120
        end
    end
    if settings.toggles.gameStretcher then
        enableGameStretcher()
    end
    if settings.toggles.autoResetBalloon then
        enableBalloonMonitor()
    end
    if settings.toggles.antiTurret then
        enableAntiTurret()
    end
    if settings.toggles.brainrotESP or settings.toggles.bestBrainrotESP then
        findDebris1077()
    end
    if settings.toggles.lineESP then
        createAttachment1078()
    end
    if settings.toggles.antiRagdoll and not appState.Connections.antiRagdoll then
        appState.Connections.antiRagdoll = RunService.Heartbeat:Connect(function()
            if not settings.toggles.antiRagdoll then
                return
            end
            local character = localPlayer.Character
            if not character then
                return
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoid or not humanoidRootPart then
                return
            end
            local state = humanoid:GetState()
            local calculatedValue1528 = state == Enum.HumanoidStateType.Physics
                or state == Enum.HumanoidStateType.Ragdoll
                or state == Enum.HumanoidStateType.FallingDown
            local attribute = localPlayer:GetAttribute("RagdollEndTime")
            if attribute and attribute - workspaceService:GetServerTimeNow() > 0 then
                calculatedValue1528 = true
            end
            if not calculatedValue1528 then
                return
            end
            pcall(function()
                localPlayer:SetAttribute("RagdollEndTime", workspaceService:GetServerTimeNow())
            end)
            for _, descendant in ipairs(character:GetDescendants()) do
                    descendant:IsA("BallSocketConstraint")
                    or descendant:IsA("Attachment") and string.find(descendant.Name, "RagdollAttachment", 1, true)
                then
                    pcall(function()
                        descendant:Destroy()
                    end)
                end
            end
            for _, descendant in ipairs(character:GetDescendants()) do
                if descendant:IsA("Motor6D") and not descendant.Enabled then
                    descendant.Enabled = true
                end
            end
            if humanoid.Health > 0 then
                pcall(function()
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end
            if workspaceService.CurrentCamera then
                workspaceService.CurrentCamera.CameraSubject = humanoid
            end
            humanoidRootPart.Anchored = false
            humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
        end)
    end
    if settings.toggles.antiBee and appState.antiBeeApply then
        appState.antiBeeApply(true)
    end
    return
end)
task.spawn(function()
    local numericValue1535 = 0
    local now2 = tick()
    RunService.RenderStepped:Connect(function()
        numericValue1535 += 1
        local now3 = tick()
        if now3 - now2 >= 0.5 then
            local floorResult1538 = math.floor(numericValue1535 / (now3 - now2))
            numericValue1535 = 0
            now2 = now3
            local ok, result = pcall(function()
                return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            if ok and appState.statsLabel then
                appState.statsLabel.Text = string.format("FPS: %d PING: %dms", floorResult1538, result)
            end
        end
    end)
end)
task.spawn(function()
    local rotation = 0
    while true do
        rotation = (rotation + 8) % 360
        for i = 1, #appState.allGradients do
            pcall(function()
                if appState.allGradients[i] then
                    appState.allGradients[i].Rotation = rotation
                end
            end)
        end
        task.wait(0.2)
    end
end)
task.spawn(function()
    while true do
        task.wait(15)
        if appState.screenGui and not appState.screenGui.Parent then
            attachGui(appState.screenGui)
        end
        if semiTeleportGui and not semiTeleportGui.Parent then
            attachGui(semiTeleportGui)
        end
        if adminPanelGui and not adminPanelGui.Parent then
            attachGui(adminPanelGui)
        end
    end
end)
task.spawn(function()
    while true do
        task.wait(30)
        if appState.screenGui and appState.screenGui.Parent then
            appState.screenGui.Name = generateRandomGuiName()
        end
    end
end)
task.spawn(function()
    local ok, result = pcall(function()
        local Players = game:GetService("Players")
        game:GetService("RunService")
        local StarterGui = game:GetService("StarterGui")
        local TweenService2 = game:GetService("TweenService")
        local UserInputService2 = game:GetService("UserInputService")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local localPlayer3 = Players.LocalPlayer
        local calculatedValue1549 = settings.autoDefense.enabled == true
        local calculatedValue1550 = settings.autoDefense.balloon ~= false
        local calculatedValue1551 = settings.autoDefense.laser == true
        local settingsOpen = settings.autoDefense.settingsOpen == true
        local lookupTable1553 = {
            bg = Color3.fromRGB(7, 24, 50),
            panel = Color3.fromRGB(8, 27, 55),
            gold = Color3.fromRGB(130, 200, 255),
            white = appState.COL_WHITE,
            grey = Color3.fromRGB(170, 205, 235),
            dark = Color3.fromRGB(28, 55, 92),
            knobOff = appState.COL_WHITE,
            check = Color3.fromRGB(80, 145, 255),
        local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local function createRoundedCorner(parent, cornerRadius)
            local uiCorner = Instance.new("UICorner")
            uiCorner.CornerRadius = UDim.new(0, cornerRadius or 8)
            uiCorner.Parent = parent
            return uiCorner
        end
        local function addPanelStroke(parent, color, thickness, transparency)
            local instance = Instance.new("UIStroke")
            instance.Color = color or Color3.fromRGB(65, 145, 255)
            instance.Thickness = thickness or 1
            instance.Transparency = transparency == nil and 0.45 or transparency
            instance.Parent = parent
            return instance
        end
        pcall(function()
            local autoDefensePlayerGui = localPlayer3:FindFirstChild("PlayerGui")
            if autoDefensePlayerGui then
                local iceHubAutoDefense = autoDefensePlayerGui:FindFirstChild("ICE_HUB_AUTO_DEFENSE")
                if iceHubAutoDefense then
                    iceHubAutoDefense:Destroy()
                end
            end
            if gethui then
                local hui = gethui()
                hui = hui and hui:FindFirstChild("ICE_HUB_AUTO_DEFENSE")
                if hui then
                    hui:Destroy()
                end
            end
        end)
        local instance = Instance.new("ScreenGui")
        instance.Name = "ICE_HUB_AUTO_DEFENSE"
        instance.ResetOnSpawn = false
        instance.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        instance.Parent = gethui and gethui() or localPlayer3.PlayerGui
        local calculatedValue1569 = isMobile and 240 or 220
        local calculatedValue1570 = isMobile and 102 or 92
        local calculatedValue1571 = isMobile and 120 or 106
        local calculatedValue1572 = calculatedValue1570 + calculatedValue1571 + 8
        local calculatedValue1573 = isMobile and 36 or 30
        local calculatedValue1574 = isMobile and 42 or 36
        local calculatedValue1575 = isMobile and 22 or 18
        local calculatedValue1576 = isMobile and 18 or 12
        local instance2 = Instance.new("Frame")
        instance2.Size = UDim2.new(0, calculatedValue1569, 0, calculatedValue1570)
        local udim2 = UDim2.new(0.5, -calculatedValue1569 / 2, 0, 60)
        restorePanelPosition(instance2, "autoDefense", udim2)
        instance2.BackgroundColor3 = lookupTable1553.bg
        instance2.BackgroundTransparency = 0.45
        instance2.BorderSizePixel = 0
        instance2.Active = true
        instance2.Draggable = false
        instance2.ClipsDescendants = true
        instance2.Parent = instance
        createRoundedCorner(instance2, 10)
        addPanelStroke(instance2, Color3.fromRGB(80, 145, 255), 1, 0.45)
        local uiPadding = Instance.new("UIPadding")
        uiPadding.PaddingLeft = UDim.new(0, 10)
        uiPadding.PaddingRight = UDim.new(0, 10)
        uiPadding.Parent = instance2
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -30, 0, isMobile and 28 or 25)
        textLabel.Position = UDim2.new(0, 0, 0, 3)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = "AUTO DEFENSE"
        textLabel.TextColor3 = lookupTable1553.gold
        textLabel.TextSize = isMobile and 13 or 12
        textLabel.Font = Enum.Font.GothamBlack
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.ZIndex = 13
        textLabel.Parent = instance2
        makeDraggable(instance2, textLabel, "autoDefense")
        local textButton2 = Instance.new("TextButton")
        textButton2.Size = UDim2.new(0, 26, 0, 26)
        textButton2.Position = UDim2.new(1, -26, 0, 2)
        textButton2.BackgroundTransparency = 1
        textButton2.Text = "⚙"
        textButton2.TextColor3 = lookupTable1553.gold
        textButton2.TextSize = isMobile and 17 or 15
        textButton2.Font = Enum.Font.GothamBold
        textButton2.AutoButtonColor = false
        textButton2.ZIndex = 12
        textButton2.Parent = instance2
        local frame3 = Instance.new("Frame")
        frame3.Size = UDim2.new(1, 0, 0, 1)
        frame3.Position = UDim2.new(0, 0, 0, isMobile and 31 or 28)
        frame3.BackgroundColor3 = Color3.fromRGB(60, 145, 255)
        frame3.BackgroundTransparency = 0.45
        frame3.BorderSizePixel = 0
        frame3.ZIndex = 13
        frame3.Parent = instance2
        local frame4 = Instance.new("Frame")
        frame4.Size = UDim2.new(1, 0, 0, calculatedValue1573)
        frame4.Position = UDim2.new(0, 0, 0, isMobile and 40 or 28)
        frame4.BackgroundColor3 = lookupTable1553.panel
        frame4.BackgroundTransparency = 0.42
        frame4.BorderSizePixel = 0
        frame4.ZIndex = 12
        frame4.Parent = instance2
        createRoundedCorner(frame4, 8)
        local textLabel2 = Instance.new("TextLabel")
        textLabel2.Size = UDim2.new(1, -58, 1, 0)
        textLabel2.Position = UDim2.new(0, 8, 0, 0)
        textLabel2.BackgroundTransparency = 1
        textLabel2.Text = "Auto Defense"
        textLabel2.TextColor3 = lookupTable1553.white
        textLabel2.TextSize = isMobile and 14 or 12
        textLabel2.Font = Enum.Font.GothamBold
        textLabel2.TextXAlignment = Enum.TextXAlignment.Left
        textLabel2.ZIndex = 13
        textLabel2.Parent = frame4
        local frame5 = Instance.new("Frame")
        frame5.Size = UDim2.new(0, calculatedValue1574, 0, calculatedValue1575)
        frame5.Position = UDim2.new(1, -calculatedValue1574 - 6, 0.5, -calculatedValue1575 / 2)
        frame5.BackgroundColor3 = lookupTable1553.dark
        frame5.BorderSizePixel = 0
        frame5.ZIndex = 13
        frame5.Parent = frame4
        createRoundedCorner(frame5, calculatedValue1575 / 2)
        local uiGradient = Instance.new("UIGradient")
        uiGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, lookupTable1553.dark),
            ColorSequenceKeypoint.new(1, lookupTable1553.dark),
        uiGradient.Parent = frame5
        local frame6 = Instance.new("Frame")
        frame6.Size = UDim2.new(0, calculatedValue1576, 0, calculatedValue1576)
        frame6.Position = UDim2.new(0, 2, 0.5, -calculatedValue1576 / 2)
        frame6.BackgroundColor3 = lookupTable1553.white
        frame6.BorderSizePixel = 0
        frame6.ZIndex = 14
        frame6.Parent = frame5
        createRoundedCorner(frame6, calculatedValue1576 / 2)
        local textButton3 = Instance.new("TextButton")
        textButton3.Size = UDim2.new(1, 0, 1, 0)
        textButton3.BackgroundTransparency = 1
        textButton3.Text = ""
        textButton3.ZIndex = 15
        textButton3.Parent = frame4
        local frame7 = Instance.new("Frame")
        frame7.Size = UDim2.new(1, 0, 0, calculatedValue1571)
        frame7.Position = UDim2.new(0, 0, 0, calculatedValue1570)
        frame7.BackgroundColor3 = lookupTable1553.bg
        frame7.BackgroundTransparency = 0.45
        frame7.BorderSizePixel = 0
        frame7.Visible = false
        frame7.ZIndex = 20
        frame7.Parent = instance2
        createRoundedCorner(frame7, 10)
        addPanelStroke(frame7, Color3.fromRGB(65, 145, 255), 1, 0.45)
        local uiPadding2 = Instance.new("UIPadding")
        uiPadding2.PaddingLeft = UDim.new(0, 10)
        uiPadding2.PaddingRight = UDim.new(0, 10)
        uiPadding2.Parent = frame7
        local textLabel3 = Instance.new("TextLabel")
        textLabel3.Size = UDim2.new(1, 0, 0, isMobile and 26 or 23)
        textLabel3.Position = UDim2.new(0, 0, 0, 3)
        textLabel3.BackgroundTransparency = 1
        textLabel3.Text = "ACTIONS"
        textLabel3.TextColor3 = lookupTable1553.gold
        textLabel3.TextSize = isMobile and 13 or 12
        textLabel3.Font = Enum.Font.GothamBlack
        textLabel3.TextXAlignment = Enum.TextXAlignment.Left
        textLabel3.ZIndex = 21
        textLabel3.Parent = frame7
        local frame8 = Instance.new("Frame")
        frame8.Size = UDim2.new(1, 0, 0, 1)
        frame8.Position = UDim2.new(0, 0, 0, isMobile and 30 or 27)
        frame8.BackgroundColor3 = Color3.fromRGB(60, 145, 255)
        frame8.BackgroundTransparency = 0.45
        frame8.BorderSizePixel = 0
        frame8.ZIndex = 21
        frame8.Parent = frame7
        local function createDefenseToggle(parent, yOffset, text, visible, callback1598)
            local frame9 = Instance.new("Frame")
            frame9.Size = UDim2.new(1, 0, 0, calculatedValue1573)
            frame9.Position = UDim2.new(0, 0, 0, yOffset)
            frame9.BackgroundColor3 = lookupTable1553.panel
            frame9.BackgroundTransparency = 0.42
            frame9.BorderSizePixel = 0
            frame9.ZIndex = 11
            frame9.Parent = parent
            createRoundedCorner(frame9, 8)
            local textLabel4 = Instance.new("TextLabel")
            textLabel4.Size = UDim2.new(1, -42, 1, 0)
            textLabel4.Position = UDim2.new(0, 8, 0, 0)
            textLabel4.BackgroundTransparency = 1
            textLabel4.Text = text
            textLabel4.TextColor3 = lookupTable1553.white
            textLabel4.TextSize = isMobile and 12 or 12
            textLabel4.Font = Enum.Font.GothamBold
            textLabel4.TextXAlignment = Enum.TextXAlignment.Left
            textLabel4.ZIndex = 22
            textLabel4.Parent = frame9
            local instance3 = Instance.new("Frame")
            instance3.Size = UDim2.new(0, isMobile and 20 or 18, 0, isMobile and 20 or 18)
            instance3.Position = UDim2.new(1, -(isMobile and 24 or 22), 0.5, -(isMobile and 10 or 14))
            instance3.BackgroundColor3 = visible and lookupTable1553.check or lookupTable1553.dark
            instance3.BorderSizePixel = 0
            instance3.ZIndex = 24
            instance3.Parent = frame9
            createRoundedCorner(instance3, 5)
            addPanelStroke(instance3, Color3.fromRGB(65, 145, 255), 1, 0.35)
            local textLabel5 = Instance.new("TextLabel")
            textLabel5.Size = UDim2.new(1, 0, 1, 0)
            textLabel5.BackgroundTransparency = 1
            textLabel5.Text = "✓"
            textLabel5.TextColor3 = lookupTable1553.white
            textLabel5.TextSize = isMobile and 13 or 12
            textLabel5.Font = Enum.Font.GothamBold
            textLabel5.Visible = visible
            textLabel5.ZIndex = 23
            textLabel5.Parent = instance3
            local textButton4 = Instance.new("TextButton")
            textButton4.Size = UDim2.new(1, 0, 1, 0)
            textButton4.BackgroundTransparency = 1
            textButton4.Text = ""
            textButton4.ZIndex = 24
            textButton4.Parent = frame9
            local visible1604 = visible
            local function setDefenseToggle(enabled, notify)
                visible1604 = enabled
                    :Create(instance3, tweenInfo, {
                        BackgroundColor3 = visible1604 and lookupTable1553.check or lookupTable1553.dark,
                    :Play()
                textLabel5.Visible = visible1604
                if notify ~= false then
                    callback1598(visible1604)
                end
            end
            textButton4.MouseButton1Click:Connect(function()
                setDefenseToggle(not visible1604, true)
            end)
            return function(enabled)
                setDefenseToggle(enabled, false)
            end
        end
        local calculatedValue1609 = isMobile and 36 or 33
        createDefenseToggle(frame7, calculatedValue1609, "Balloon", calculatedValue1550, function(balloon)
            calculatedValue1550 = balloon
            settings.autoDefense.balloon = balloon
            saveSettings()
        end)
        createDefenseToggle(
            function(laser)
                calculatedValue1551 = laser
                settings.autoDefense.laser = laser
                saveSettings()
            end
        local function setAutoDefenseEnabled(enabled, saveChange)
            calculatedValue1549 = enabled
            if saveChange ~= false then
                settings.autoDefense.enabled = enabled
                saveSettings()
            end
            local dark = lookupTable1553.dark
            uiGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, lookupTable1553.dark),
                ColorSequenceKeypoint.new(1, dark),
            TweenService2:Create(frame6, tweenInfo, {
                Position = UDim2.new(0, 2, 0.5, -calculatedValue1576 / 2),
            }):Play()
            textLabel2.TextColor3 = lookupTable1553.white
        end
        setAutoDefenseEnabled(calculatedValue1549, false)
        textButton3.MouseButton1Click:Connect(function()
            setAutoDefenseEnabled(not calculatedValue1549, true)
        end)
        textButton2.MouseButton1Click:Connect(function()
            settingsOpen = not settingsOpen
            settings.autoDefense.settingsOpen = settingsOpen
            saveSettings()
            textButton2.TextColor3 = settingsOpen and lookupTable1553.white or lookupTable1553.gold
            if settingsOpen then
                frame7.Visible = true
                TweenService2:Create(instance2, tweenInfo, {
                    Size = UDim2.new(0, calculatedValue1569, 0, calculatedValue1572),
                }):Play()
            else
                local tween = TweenService2:Create(instance2, tweenInfo, {
                    Size = UDim2.new(0, calculatedValue1569, 0, calculatedValue1570),
                tween:Play()
                task.spawn(function()
                    tween.Completed:Wait()
                    if not settingsOpen then
                        frame7.Visible = false
                    end
                end)
            end
        end)
        if settingsOpen then
            frame7.Visible = true
            instance2.Size = UDim2.new(0, calculatedValue1569, 0, calculatedValue1572)
            textButton2.TextColor3 = lookupTable1553.white
        end
        local lookupTable1621 = {}
        local lookupTable1622 = {}
        local numericValue1623 = 0
        local lookupTable1624 = {}
        local connection = nil
        local textOptions1626 = {
        local function findUseItemRemote()
            local fhUseItemRemote = _G._FH_UseItemRemote
            if typeof(fhUseItemRemote) == "Instance" and fhUseItemRemote.Parent then
                return fhUseItemRemote
            end
            local getConnectionsFunction = getconnections
            local getconstants_ = debug and debug.getconstants or getconstants
            if type(getConnectionsFunction) ~= "function" or type(getconstants_) ~= "function" then
                return nil
            end
            local ok, result = pcall(function()
                return ReplicatedStorage:WaitForChild("Packages", 15):WaitForChild("Net", 15)
            end)
            if not ok or not result then
                return nil
            end
            local fHUseItemRemote1635 = nil
            for _, child in ipairs(result:GetChildren()) do
                if child:IsA("RemoteEvent") and not fHUseItemRemote1635 then
                    local ok2, result2 = pcall(getConnectionsFunction, child.OnClientEvent)
                    if ok2 and result2 then
                        for _, functionState1641 in ipairs(result2) do
                            if type(functionState1641.Function) == "function" then
                                local ok3, result3 = pcall(getconstants_, functionState1641.Function)
                                if ok3 and result3 then
                                    for _, item1645 in ipairs(result3) do
                                        if item1645 == "PaintballHitted" then
                                            fHUseItemRemote1635 = child
                                            break
                                        end
                                    end
                                end
                            end
                            if not fHUseItemRemote1635 then
                            end
                            break
                        end
                    end
                end
                if not fHUseItemRemote1635 then
                end
                break
            end
            if fHUseItemRemote1635 then
                _G._FH_UseItemRemote = fHUseItemRemote1635
            end
            return fHUseItemRemote1635
        end
        local function rebuildRemoteMap()
            local ok, result = pcall(function()
                return ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):GetChildren()
            end)
            if not ok or not result then
                return
            end
            lookupTable1621 = {}
            lookupTable1622 = {}
            for i, instance1650 in ipairs(result) do
                if instance1650:IsA("RemoteEvent") then
                    local pairedRemote = result[i + 1]
                    if pairedRemote then
                        lookupTable1621[instance1650.Name] = i + 1
                        lookupTable1622[i + 1] = pairedRemote
                    end
                end
            end
        end
        local function fireRemoteEvent1652(index1653, ...)
            if index1653 == "RE/UseItem" or index1653 == "UseItem" then
                local findUseItemRemoteResult1654 = findUseItemRemote()
                if findUseItemRemoteResult1654 then
                    findUseItemRemoteResult1654:FireServer(...)
                    return true
                end
            end
            local index1655 = lookupTable1621[index1653]
            if index1655 and lookupTable1622[index1655] then
                lookupTable1622[index1655]:FireServer(...)
                return true
            end
            return false
        end
        local function findHumanoid1656(calculatedValue1657)
            calculatedValue1657 = calculatedValue1657 and calculatedValue1657:FindFirstChildOfClass("Humanoid")
            return calculatedValue1657 and calculatedValue1657.Health > 0
        end
        local function findPlayer1658()
            local character = localPlayer3.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then
                return nil
            end
            local numericValue1661 = 800
            local selectedPlayer = nil
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= localPlayer3 then
                    local character2 = player.Character
                    local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart2 and findHumanoid1656(character2) then
                        local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude
                        if magnitude < numericValue1661 then
                            numericValue1661 = magnitude
                            selectedPlayer = player
                        end
                    end
                end
            end
            return selectedPlayer
        end
        local function findInstance1668(instance1669)
            for _, item1671 in pairs(textOptions1626) do
                local findFirstChildResult1672 = instance1669:FindFirstChild(item1671)
                if findFirstChildResult1672 then
                    return findFirstChildResult1672
                end
            end
            return nil
        end
        local function findHumanoidRootPart1673()
            local findPlayer1658Result1674 = findPlayer1658()
            if not findPlayer1658Result1674 then
                return
            end
            local character = findPlayer1658Result1674.Character
            if not character or not findHumanoid1656(character) then
                return
            end
            local findInstance1668Result1676 = findInstance1668(character)
            if not findInstance1668Result1676 then
                return
            end
            local vector = Vector3.zero
            pcall(function()
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    vector = humanoidRootPart.Velocity or Vector3.zero
                end
            end)
            local calculatedValue1679 = findInstance1668Result1676.Position + Vector3.new(0, 0.5, 0) + vector * 0.18
            if not (lookupTable1621["RE/UseItem"] or lookupTable1621.UseItem) then
                rebuildRemoteMap()
            end
            if not fireRemoteEvent1652("RE/UseItem", calculatedValue1679, findInstance1668Result1676) then
                rebuildRemoteMap()
                fireRemoteEvent1652("RE/UseItem", calculatedValue1679, findInstance1668Result1676)
            end
        end
        local function activateLaserCapeRemote()
            local now2 = tick()
            if now2 - numericValue1623 < 0.04 then
                return
            end
            numericValue1623 = now2
            findHumanoidRootPart1673()
        end
        local function findTool1682(activatedState1683)
            for _, disconnectState1685 in ipairs(lookupTable1624) do
                pcall(disconnectState1685.Disconnect, disconnectState1685)
            end
            lookupTable1624 = {}
            rebuildRemoteMap()
            table.insert(lookupTable1624, activatedState1683.Activated:Connect(activateLaserCapeRemote))
            table.insert(
                UserInputService2.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then
                        return
                    end
                    local character = localPlayer3.Character
                    local tool = character and character:FindFirstChildOfClass("Tool")
                    if not (tool and tool.Name == "Laser Cape") then
                        return
                    end
                        input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch
                    then
                        activateLaserCapeRemote()
                    end
                end)
        end
        local function disconnectLaserCape()
            for _, disconnectState1692 in ipairs(lookupTable1624) do
                pcall(disconnectState1692.Disconnect, disconnectState1692)
            end
            lookupTable1624 = {}
        end
        local function findTool1693(character)
            if connection then
                pcall(connection.Disconnect, connection)
            end
            local tool = character:FindFirstChildOfClass("Tool")
            if tool and tool.Name == "Laser Cape" then
                findTool1682(tool)
            end
            connection = character.ChildAdded:Connect(function(child)
                if child:IsA("Tool") and child.Name == "Laser Cape" then
                    findTool1682(child)
                end
            end)
            character.ChildRemoved:Connect(function(child)
                if child:IsA("Tool") and child.Name == "Laser Cape" then
                    disconnectLaserCape()
                end
            end)
        end
        if localPlayer3.Character then
            findTool1693(localPlayer3.Character)
        end
        localPlayer3.CharacterAdded:Connect(findTool1693)
        local instance1698 = nil
        local function findPlots1699()
            if instance1698 and instance1698.Parent then
                return instance1698
            end
            local plots = workspace:FindFirstChild("Plots")
            if not plots then
                return nil
            end
            for _, child in ipairs(plots:GetChildren()) do
                local surfaceGui = child:FindFirstChild("PlotSign")
                local yourBase = surfaceGui and surfaceGui:FindFirstChild("YourBase", true)
                if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled then
                    instance1698 = child
                    return child
                end
                surfaceGui = surfaceGui and surfaceGui:FindFirstChild("SurfaceGui")
                surfaceGui = surfaceGui and surfaceGui:FindFirstChild("Frame")
                surfaceGui = surfaceGui and surfaceGui:FindFirstChild("TextLabel")
                if surfaceGui and surfaceGui:IsA("TextLabel") then
                    local lowerResult1706 = tostring(surfaceGui.Text or ""):lower()
                        lowerResult1706:find(localPlayer3.Name:lower(), 1, true)
                        or lowerResult1706:find(localPlayer3.DisplayName:lower(), 1, true)
                    then
                        instance1698 = child
                        return child
                    end
                end
            end
            return nil
        end
        local function inspectBoundingBox1707(player1708)
            local findPlots1699Result1709 = findPlots1699()
            if not findPlots1699Result1709 then
                return false
            end
            local character = player1708.Character
            if not character then
                return false
            end
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local ok, result, result2 = pcall(function()
                    return findPlots1699Result1709:GetBoundingBox()
                end)
                if not ok then
                    return false
                end
                local pointToObjectSpaceResult1715 = result:PointToObjectSpace(humanoidRootPart.Position)
                local calculatedValue1716 = result2.X / 2
                local calculatedValue1717 = math.abs(pointToObjectSpaceResult1715.X) <= calculatedValue1716
                if calculatedValue1717 then
                    local calculatedValue1718 = result2.Y / 2
                    calculatedValue1717 = math.abs(pointToObjectSpaceResult1715.Y) <= calculatedValue1718
                end
                if calculatedValue1717 then
                    local calculatedValue1719 = result2.Z / 2
                    calculatedValue1717 = math.abs(pointToObjectSpaceResult1715.Z) <= calculatedValue1719
                end
                return calculatedValue1717
            end
            return false
        end
        local function balloonPlayer(instance1721)
            if not instance1721 or instance1721.Parent ~= Players then
                return
            end
            pcall(function()
                executeAdminCommand(instance1721, "balloon")
            end)
        end
        local function activateLaserCape()
            local character = localPlayer3.Character
            if not character then
                return
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then
                return
            end
            local instance1725 = nil
            local backpack = localPlayer3:FindFirstChild("Backpack")
            if backpack then
                for _, child in ipairs(backpack:GetChildren()) do
                    if child:IsA("Tool") and child.Name == "Laser Cape" then
                        instance1725 = child
                        break
                    end
                end
            end
            if not instance1725 then
                for _, child in ipairs(character:GetChildren()) do
                    if child:IsA("Tool") and child.Name == "Laser Cape" then
                        instance1725 = child
                        break
                    end
                end
            end
            if not instance1725 then
                return
            end
            if instance1725.Parent ~= character then
                pcall(function()
                    humanoid:EquipTool(instance1725)
                end)
                task.wait(0.1)
            end
            pcall(function()
                instance1725:Activate()
            end)
        end
        local function showDefenseStatus(statusText)
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "Ice Hub Auto Defense",
                    Text = statusText,
                    Duration = 2,
            end)
        end
        local lookupTable1733 = {}
        local lookupTable1734 = {}
        local function startWorker1735(player1736)
            if not calculatedValue1549 or not player1736 or player1736 == localPlayer3 then
                return
            end
            if player1736:GetAttribute("StealingPlayer") ~= true then
                return
            end
            if not inspectBoundingBox1707(player1736) then
                return
            end
            local userId = player1736.UserId
            local now2 = tick()
            if now2 - (lookupTable1733[userId] or 0) < 2 then
                return
            end
            lookupTable1733[userId] = now2
            if calculatedValue1550 and calculatedValue1551 then
                showDefenseStatus(player1736.Name .. " -> balloon + laser cape !")
            elseif calculatedValue1550 then
                showDefenseStatus(player1736.Name .. " -> balloon !")
            elseif calculatedValue1551 then
                showDefenseStatus(player1736.Name .. " -> laser cape !")
            end
            if calculatedValue1550 then
                task.spawn(balloonPlayer, player1736)
            end
            if calculatedValue1551 then
                task.spawn(activateLaserCape)
            end
        end
        local function bindEvents1740(player)
            if not player or player == localPlayer3 or lookupTable1734[player] then
                return
            end
            lookupTable1734[player] = player:GetAttributeChangedSignal("StealingPlayer"):Connect(function()
                startWorker1735(player)
            end)
            if player:GetAttribute("StealingPlayer") == true then
                task.defer(startWorker1735, player)
            end
        end
        for _, player in ipairs(Players:GetPlayers()) do
            bindEvents1740(player)
        end
        Players.PlayerAdded:Connect(bindEvents1740)
        Players.PlayerRemoving:Connect(function(player)
            lookupTable1733[player.UserId] = nil
            local disconnectState1746 = lookupTable1734[player]
            if disconnectState1746 then
                disconnectState1746:Disconnect()
                lookupTable1734[player] = nil
            end
        end)
        print("prince")
    end)
    if not ok then
    end
end)
task.spawn(function()
    local trackedPlot = nil
    local isActive1752 = false
    local closestBaseIndex = nil
    local instance1754 = nil
    local instance1755 = nil
    local function parseTimeSeconds(commandText)
        local gsubResult1758 = tostring(commandText or ""):gsub("%s+", "")
        local match, matchResult1760 = gsubResult1758:match("^(%d+):(%d+)$")
        if match and matchResult1760 then
            return tonumber(match) * 60 + tonumber(matchResult1760)
        end
        local match2, matchResult1762, matchResult1763 = gsubResult1758:match("^(%d+):(%d+):(%d+)$")
        if match2 and matchResult1762 and matchResult1763 then
            return tonumber(match2) * 3600 + tonumber(matchResult1762) * 60 + tonumber(matchResult1763)
        end
        return tonumber(gsubResult1758:match("(%d+%.?%d*)"))
    end
    local function findHumanoidRootPart1764()
        local character = localPlayer.Character
        character = character and character:FindFirstChild("HumanoidRootPart")
        local plots = workspaceService:FindFirstChild("Plots")
        if not character or not plots then
            return nil, nil
        end
        local calculatedValue1767 = (character.Position - baseLocations.b1.refVec).Magnitude
            < (character.Position - baseLocations.b2.refVec).Magnitude
        local calculatedValue1768 = calculatedValue1767 and 1 or 2
            closestBaseIndex == calculatedValue1768
            and instance1754
            and instance1754.Parent
            and instance1755
            and instance1755.Parent
        then
            return instance1754, instance1755
        end
        local refVec = calculatedValue1767 and baseLocations.b2.refVec or baseLocations.b1.refVec
        local huge = math.huge
        local instance1771 = nil
        for _, child in ipairs(plots:GetChildren()) do
            if child:IsA("Model") and isEnemyBase(child) then
                local position = nil
                pcall(function()
                    position = child.PrimaryPart and child.PrimaryPart.Position or child:GetPivot().Position
                end)
                if position then
                    local magnitude = (position - refVec).Magnitude
                    if magnitude < huge then
                        instance1771 = child
                        huge = magnitude
                    end
                end
            end
        end
        if not instance1771 then
            return nil, nil
        end
        local purchases = instance1771:FindFirstChild("Purchases")
        purchases = purchases and purchases:FindFirstChild("PlotBlock")
        purchases = purchases and purchases:FindFirstChild("Main")
        purchases = purchases and purchases:FindFirstChild("BillboardGui")
        purchases = purchases and purchases:FindFirstChild("RemainingTime")
        closestBaseIndex = calculatedValue1768
        instance1754 = instance1771
        instance1755 = purchases
        return instance1771, purchases
    end
    local numericValue1777
    while task.wait(0.1) do
        if not semiTeleportSettings.autoSemiOnTimer then
            numericValue1777 = nil
            trackedPlot = nil
            closestBaseIndex = nil
            instance1754 = nil
            instance1755 = nil
            isActive1752 = false
        else
            pcall(function()
                local findHumanoidRootPart1764Result1778, findHumanoidRootPart1764Result1779 =
                    findHumanoidRootPart1764()
                if findHumanoidRootPart1764Result1778 ~= trackedPlot then
                    trackedPlot = findHumanoidRootPart1764Result1778
                    numericValue1777 = nil
                    isActive1752 = false
                end
                if findHumanoidRootPart1764Result1779 and findHumanoidRootPart1764Result1779.Text ~= nil then
                    local parseTimeSecondsResult1780 = parseTimeSeconds(findHumanoidRootPart1764Result1779.Text)
                    if parseTimeSecondsResult1780 then
                        if parseTimeSecondsResult1780 > 0 then
                            isActive1752 = false
                        elseif numericValue1777 and numericValue1777 > 0 and not isActive1752 then
                            isActive1752 = true
                            semiTeleportState.execute()
                        end
                        numericValue1777 = parseTimeSecondsResult1780
                    end
                end
            end)
        end
    end
end)
repeat
    task.wait()
until game:IsLoaded()
    local Players = game:GetService("Players")
    HttpService = game:GetService("HttpService")
    localPlayer2 = Players.LocalPlayer or Players.PlayerAdded:Wait()
end
genv = type(getgenv) == "function" and getgenv() or _G
    local request_2 = request or http_request or syn and syn.request
    if request_2 then
        request_ = request_2
    else
        request_ = http and http.request
    end
end
local pabloPresenceBrainrot, text1788, text1789
if type(request_) ~= "function" then
    return
end
if type(genv.PABLO_PRESENCE_BRAINROT) == "table" then
    genv.PABLO_PRESENCE_BRAINROT.running = false
end
pabloPresenceBrainrot = {
    running = true,
    token = nil,
    tokenAt = 0,
genv.PABLO_PRESENCE_BRAINROT = pabloPresenceBrainrot
text1788 = "https://icehub.best/api/presence/brainrot/session"
text1789 = "https://icehub.best/api/presence/brainrot"
local encodeJson1791
    local function decodeJsonResponse(responseBody)
        if type(responseBody) ~= "string" or responseBody == "" then
            return nil
        end
        local ok, result = pcall(HttpService.JSONDecode, HttpService, responseBody)
        return ok and type(result) == "table" and result or nil
    end
    encodeJson1791 = function()
        local ok, result = pcall(request_, {
            Url = text1788,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                Accept = "application/json",
            Body = HttpService:JSONEncode({
                userId = tostring(localPlayer2.UserId),
        if not ok or type(result) ~= "table" then
            return false
        end
        local num = tonumber(result.StatusCode or result.Status) or 0
        if num < 200 or num >= 300 then
            return false
        end
        local decodeJsonResponseResult1799 = decodeJsonResponse(result.Body)
            not decodeJsonResponseResult1799
            or type(decodeJsonResponseResult1799.token) ~= "string"
            or #decodeJsonResponseResult1799.token < 20
        then
            return false
        end
        pabloPresenceBrainrot.token = decodeJsonResponseResult1799.token
        pabloPresenceBrainrot.tokenAt = os.clock()
        return true
    end
end
    local function isPresenceResponseSuccessful()
        if not pabloPresenceBrainrot.token and not encodeJson1791() then
            return false
        end
        local ok, result = pcall(request_, {
            Url = text1789,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                Accept = "application/json",
                Authorization = "Bearer " .. pabloPresenceBrainrot.token,
            Body = "{}",
        if not ok or type(result) ~= "table" then
            return false
        end
        local calculatedValue1803 = tonumber(result.StatusCode or result.Status) or 0
        if calculatedValue1803 == 401 or calculatedValue1803 == 403 then
            pabloPresenceBrainrot.token = nil
            return false
        end
        return calculatedValue1803 >= 200 and calculatedValue1803 < 300
    end
    task.spawn(function()
        isPresenceResponseSuccessful()
        while true do
            if pabloPresenceBrainrot.running and genv.PABLO_PRESENCE_BRAINROT == pabloPresenceBrainrot then
                task.wait(5)
                if not (not pabloPresenceBrainrot.running or genv.PABLO_PRESENCE_BRAINROT ~= pabloPresenceBrainrot) then
                    local token = pabloPresenceBrainrot.token
                    local calculatedValue1805
                    if token then
                        local tokenAt = pabloPresenceBrainrot.tokenAt
                        calculatedValue1805 = os.clock() - tokenAt >= 540
                    else
                        calculatedValue1805 = token
                    end
                    if calculatedValue1805 then
                        pabloPresenceBrainrot.token = nil
                    end
                    isPresenceResponseSuccessful()
                end
            end
            break
        end
    end)
end
return
