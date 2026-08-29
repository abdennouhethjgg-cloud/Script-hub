-- VIS HUB · Safe Local Edition
-- Menu local : GUI, notifications, FPS/ping, Anti Lag visuel et Next Empty Base.
-- Les fonctions distantes ou invasives de la script fournie ne sont pas incluses.

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
if not player then
    warn("[VIS HUB] LocalPlayer indisponible")
    return
end
local playerGui = player:WaitForChild("PlayerGui", 10)
if not playerGui then
    warn("[VIS HUB] PlayerGui indisponible")
    return
end

local old = playerGui:FindFirstChild("VisHubSafeMenu")
if old then old:Destroy() end
local gui = Instance.new("ScreenGui")
gui.Name = "VisHubSafeMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 100
gui.Parent = playerGui

local C = {
    bg = Color3.fromRGB(9, 4, 15), panel = Color3.fromRGB(20, 7, 27), row = Color3.fromRGB(32, 9, 39),
    pink = Color3.fromRGB(255, 20, 170), purple = Color3.fromRGB(255, 45, 215), white = Color3.fromRGB(255, 235, 250),
    dim = Color3.fromRGB(195, 125, 180), green = Color3.fromRGB(74, 225, 125), yellow = Color3.fromRGB(255, 207, 83), red = Color3.fromRGB(255, 82, 145),
}
local function make(className, props, parent)
    local obj = Instance.new(className)
    for key, value in pairs(props) do obj[key] = value end
    obj.Parent = parent
    return obj
end
local function corner(obj, radius)
    make("UICorner", { CornerRadius = UDim.new(0, radius) }, obj)
end
local function text(parent, value, position, size, color, font)
    return make("TextLabel", { BackgroundTransparency = 1, Text = value, Position = position, Size = size, TextColor3 = color or C.white, TextSize = 12, Font = font or Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center }, parent)
end
local function btn(parent, value, position, size, color)
    local b = make("TextButton", { BackgroundColor3 = color or C.row, BorderSizePixel = 0, Text = value, Position = position, Size = size, TextColor3 = C.white, TextSize = 11, Font = Enum.Font.GothamBold, AutoButtonColor = true }, parent)
    corner(b, 8)
    return b
end

local configPath = "VisHub_local_config.json"
local config = { panelX = 0.5, panelY = 0.5, audio = true, volume = 0.25, soundId = "rbxassetid://113671164765342", memoryThreshold = 500 }
local hasFileStore = typeof(readfile) == "function" and typeof(writefile) == "function" and typeof(isfile) == "function"
if hasFileStore and isfile(configPath) then
    pcall(function()
        local saved = HttpService:JSONDecode(readfile(configPath))
        if type(saved) == "table" then for key in pairs(config) do if saved[key] ~= nil then config[key] = saved[key] end end end
    end)
end
local saveConfig
local panel = make("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(tonumber(config.panelX) or 0.5, tonumber(config.panelY) or 0.5), Size = UDim2.fromOffset(650, 430), BackgroundColor3 = C.panel, BorderSizePixel = 0 }, gui)
corner(panel, 14)
local panelStroke = make("UIStroke", { Color = C.purple, Thickness = 1.5, Transparency = 0.15 }, panel)
local header = make("Frame", { Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 0, 62), BackgroundColor3 = C.bg, BorderSizePixel = 0 }, panel)
corner(header, 14)
text(header, "VIS HUB", UDim2.fromOffset(18, 8), UDim2.fromOffset(180, 25), C.white, Enum.Font.GothamBlack).TextSize = 20
text(header, "SAFE LOCAL EDITION", UDim2.fromOffset(19, 34), UDim2.fromOffset(180, 16), C.pink, Enum.Font.GothamBold).TextSize = 9
local status = text(header, "LOCAL · READY", UDim2.new(1, -190, 0, 10), UDim2.fromOffset(120, 18), C.green, Enum.Font.GothamBold)
status.TextXAlignment = Enum.TextXAlignment.Right
local metrics = text(header, "FPS --  ·  PING -- ms", UDim2.new(1, -240, 0, 33), UDim2.fromOffset(170, 16), C.dim, Enum.Font.Gotham)
metrics.TextXAlignment = Enum.TextXAlignment.Right
local balance = text(header, "CASH --", UDim2.new(1, -360, 0, 10), UDim2.fromOffset(105, 18), C.pink, Enum.Font.GothamBold)
balance.TextXAlignment = Enum.TextXAlignment.Right
local memoryThreshold = math.max(50, tonumber(config.memoryThreshold) or 500)
local memoryAlertActive = false
local memory = text(header, "MEM -- MB", UDim2.new(1, -360, 0, 33), UDim2.fromOffset(105, 16), C.yellow, Enum.Font.GothamBold)
memory.TextXAlignment = Enum.TextXAlignment.Right
local close = btn(header, "×", UDim2.new(1, -43, 0, 14), UDim2.fromOffset(28, 28), C.row)
close.TextSize = 18

local tabsFrame = make("Frame", { Position = UDim2.fromOffset(14, 76), Size = UDim2.fromOffset(145, 330), BackgroundColor3 = C.bg, BorderSizePixel = 0 }, panel)
corner(tabsFrame, 10)
local content = make("ScrollingFrame", { Position = UDim2.fromOffset(173, 76), Size = UDim2.new(1, -187, 1, -98), BackgroundColor3 = C.bg, BorderSizePixel = 0, ScrollBarThickness = 5, ScrollBarImageColor3 = C.pink, CanvasSize = UDim2.fromOffset(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y }, panel)
corner(content, 10)
local hint = text(panel, "SCROLL · TOUCH / MOUSE", UDim2.new(1, -245, 1, -22), UDim2.fromOffset(220, 16), C.dim, Enum.Font.GothamBold)
hint.TextXAlignment = Enum.TextXAlignment.Right
local mini = btn(gui, "VIS", UDim2.new(1, -88, 1, -62), UDim2.fromOffset(70, 40), C.purple)
mini.Visible = false

local pages = {}
local tabButtons = {}
local activePage
local function newPage(name)
    local page = make("Frame", { Name = name, Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, Visible = false }, content)
    page.AutomaticSize = Enum.AutomaticSize.Y
    pages[name] = page
    return page
end
local playerPage = newPage("PLAYER")
local espPage = newPage("ESP")
local settingsPage = newPage("SETTINGS")

local function clear(page)
    for _, child in ipairs(page:GetChildren()) do child:Destroy() end
end
local featureState = { notifications = true, metrics = true, antiLag = false, nextBase = false, compact = false, audio = true }
local nextCleanup
local antiLagOriginal = {}

local notificationSoundId = tostring(config.soundId or "rbxassetid://113671164765342")
local notificationVolume = math.clamp(tonumber(config.volume) or 0.25, 0, 1)
local feedbackSound = Instance.new("Sound")
feedbackSound.Name = "VisHubFeedback"
feedbackSound.SoundId = notificationSoundId
feedbackSound.Volume = notificationVolume
feedbackSound.Looped = false
feedbackSound.Parent = gui
featureState.audio = config.audio ~= false
saveConfig = function()
    if not hasFileStore then return end
    config.panelX, config.panelY = panel.Position.X.Scale, panel.Position.Y.Scale
    config.audio, config.volume, config.soundId, config.memoryThreshold = featureState.audio, notificationVolume, notificationSoundId, memoryThreshold
    task.defer(function() pcall(function() writefile(configPath, HttpService:JSONEncode(config)) end) end)
end
local function playFeedback()
    if featureState.audio then pcall(function() feedbackSound:Play() end) end
end

local function notice(titleValue, bodyValue, color)
    if not featureState.notifications then return end
    playFeedback()
    local card = make("Frame", { AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -18, 1, 70), Size = UDim2.fromOffset(300, 70), BackgroundColor3 = C.panel, BorderSizePixel = 0, ZIndex = 20 }, gui)
    corner(card, 10)
    make("UIStroke", { Color = color or C.pink, Thickness = 1.2 }, card)
    text(card, titleValue, UDim2.fromOffset(14, 10), UDim2.new(1, -50, 0, 20), color or C.pink, Enum.Font.GothamBold).ZIndex = 21
    text(card, bodyValue, UDim2.fromOffset(14, 32), UDim2.new(1, -24, 0, 28), C.white, Enum.Font.Gotham).ZIndex = 21
    local x = btn(card, "×", UDim2.new(1, -31, 0, 9), UDim2.fromOffset(22, 22), C.row); x.ZIndex = 22
    local function remove() if card.Parent then card:Destroy() end end
    x.Activated:Connect(remove)
    TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(1, -18, 1, -18) }):Play()
    task.delay(3.5, remove)
end

local function clearNextBase()
    if nextCleanup then nextCleanup() end
    nextCleanup = nil
end
local function findEmptyBase()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        local label = sign and sign:FindFirstChild("TextLabel", true)
        if label and tostring(label.Text):lower():gsub("^%s+", ""):gsub("%s+$", "") == "empty base" then
            local source = sign:FindFirstChild("Model", true) or plot
            local ok, box = pcall(function() return source:GetBoundingBox() end)
            if ok and box then return box.Position end
        end
    end
    return nil
end
local function setNextBase(on)
    clearNextBase()
    if not on then notice("Next Empty Base OFF", "Marqueur retiré.", C.dim); return end
    local marker = make("Part", { Name = "VisHubNextBaseMarker", Anchored = true, CanCollide = false, Transparency = 1, Size = Vector3.new(1, 1, 1) }, workspace)
    local tag = make("BillboardGui", { Adornee = marker, Size = UDim2.fromOffset(220, 82), StudsOffset = Vector3.new(0, 7, 0), AlwaysOnTop = true, MaxDistance = math.huge, LightInfluence = 0 }, marker)
    text(tag, "▼ NEXT ▼", UDim2.fromScale(0, 0), UDim2.fromScale(1, 0.42), C.green, Enum.Font.GothamBlack).TextXAlignment = Enum.TextXAlignment.Center
    text(tag, "EMPTY BASE", UDim2.fromScale(0, 0.4), UDim2.fromScale(1, 0.3), C.white, Enum.Font.GothamBold).TextXAlignment = Enum.TextXAlignment.Center
    local dist = text(tag, "DISTANCE: -- m", UDim2.fromScale(0, 0.7), UDim2.fromScale(1, 0.25), C.yellow, Enum.Font.GothamBold); dist.TextXAlignment = Enum.TextXAlignment.Center
    local target = findEmptyBase()
    if target then marker.Position = target else tag.Enabled = false end
    local timer = 0
    local connection = RunService.Heartbeat:Connect(function(dt)
        timer += dt
        if timer < 0.4 then return end
        timer = 0
        local newTarget = findEmptyBase()
        if newTarget then
            marker.Position = newTarget
            tag.Enabled = true
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then dist.Text = string.format("DISTANCE: %d m", math.floor((root.Position - newTarget).Magnitude * 0.28 + 0.5)) end
        else tag.Enabled = false end
    end)
    nextCleanup = function() pcall(function() connection:Disconnect() end); if marker.Parent then marker:Destroy() end end
    notice("Next Empty Base ON", target and "Marqueur local activé." or "Aucune base vide détectée.", target and C.green or C.yellow)
end

local function setAntiLag(on)
    if on then
        antiLagOriginal = {}
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                antiLagOriginal[obj] = obj.Enabled
                obj.Enabled = false
            end
        end
        notice("Anti Lag ON", "Effets visuels locaux réduits.", C.green)
    else
        for obj, wasEnabled in pairs(antiLagOriginal) do if obj and obj.Parent then obj.Enabled = wasEnabled end end
        antiLagOriginal = {}
        notice("Anti Lag OFF", "Effets visuels restaurés.", C.yellow)
    end
end

local function row(page, name, detail, key, callback)
    local index = #page:GetChildren()
    local item = make("Frame", { Position = UDim2.fromOffset(10, 10 + index * 50), Size = UDim2.new(1, -20, 0, 42), BackgroundColor3 = C.row, BorderSizePixel = 0 }, page)
    corner(item, 8)
    text(item, name, UDim2.fromOffset(11, 3), UDim2.new(1, -105, 0, 18), C.white, Enum.Font.GothamBold).TextSize = 11
    text(item, detail, UDim2.fromOffset(11, 21), UDim2.new(1, -105, 0, 15), C.dim, Enum.Font.Gotham).TextSize = 9
    local toggle = btn(item, featureState[key] and "ON" or "OFF", UDim2.new(1, -82, 0, 8), UDim2.fromOffset(66, 26), featureState[key] and Color3.fromRGB(35, 110, 65) or C.bg)
    toggle.TextColor3 = featureState[key] and C.green or C.dim
    toggle.Activated:Connect(function()
        featureState[key] = not featureState[key]
        toggle.Text = featureState[key] and "ON" or "OFF"
        toggle.BackgroundColor3 = featureState[key] and Color3.fromRGB(35, 110, 65) or C.bg
        toggle.TextColor3 = featureState[key] and C.green or C.dim
        callback(featureState[key])
    end)
end
local function heading(page, titleValue, bodyValue)
    clear(page)
    text(page, titleValue, UDim2.fromOffset(12, 9), UDim2.new(1, -24, 0, 25), C.white, Enum.Font.GothamBlack).TextSize = 17
    text(page, bodyValue, UDim2.fromOffset(12, 34), UDim2.new(1, -24, 0, 18), C.dim, Enum.Font.Gotham).TextSize = 10
end
local selectedPlayer
local refreshPlayerList
local refreshPlayerStats
local statusFilter = "ALL"
local maxDistance = 0
local fpsHistory, pingHistory = {}, {}
local performanceChartRefresh
local RandomTools = {
    getPlayerCount = function() return #Players:GetPlayers() end,
    getGameName = function() return tostring(game.Name) end,
    getPlaceId = function() return tostring(game.PlaceId) end,
    getServerId = function() return string.sub(game.JobId, 1, 8) end,
    getLocalName = function() return player.DisplayName end,
    getUserId = function() return tostring(player.UserId) end,
    getPlayerNames = function() local names = {}; for _, p in ipairs(Players:GetPlayers()) do names[#names + 1] = p.Name end; return table.concat(names, ", ") end,
    getAliveCount = function() local n = 0; for _, p in ipairs(Players:GetPlayers()) do local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid"); if h and h.Health > 0 then n += 1 end end; return n end,
    getCharacterState = function() return player.Character and "READY" or "NO CHARACTER" end,
    getCameraWidth = function() local c = workspace.CurrentCamera; return c and math.floor(c.ViewportSize.X) or 0 end,
    getCameraHeight = function() local c = workspace.CurrentCamera; return c and math.floor(c.ViewportSize.Y) or 0 end,
    getViewportArea = function() local c = workspace.CurrentCamera; return c and math.floor(c.ViewportSize.X * c.ViewportSize.Y) or 0 end,
    getClock = function() return os.date("%H:%M:%S") end,
    getDate = function() return os.date("%Y-%m-%d") end,
    getTouchMode = function() return UserInputService.TouchEnabled end,
    getKeyboardMode = function() return UserInputService.KeyboardEnabled end,
    getAudioEnabled = function() return featureState.audio end,
    getAudioVolume = function() return math.floor(notificationVolume * 100 + 0.5) end,
    getSoundId = function() return notificationSoundId end,
    getNotificationsEnabled = function() return featureState.notifications end,
    getMetricsEnabled = function() return featureState.metrics end,
    getCompactEnabled = function() return featureState.compact end,
    getAntiLagEnabled = function() return featureState.antiLag end,
    getNextBaseEnabled = function() return featureState.nextBase end,
    getStatusFilter = function() return statusFilter end,
    getDistanceFilter = function() return maxDistance end,
    getSelectedPlayer = function() return selectedPlayer and selectedPlayer.Name or "NONE" end,
    getBalanceName = function() local s = player:FindFirstChild("leaderstats"); return s and (s:FindFirstChild("Cash") or s:FindFirstChild("Money") or s:FindFirstChild("Coins") or s:FindFirstChild("Points")) and "AVAILABLE" or "N/A" end,
    getBalanceValue = function() local s = player:FindFirstChild("leaderstats"); local v = s and (s:FindFirstChild("Cash") or s:FindFirstChild("Money") or s:FindFirstChild("Coins") or s:FindFirstChild("Points")); return v and tostring(v.Value) or "--" end,
    getNearestPlayer = function() local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart"); local best, bestD; if not root then return "NONE" end; for _, p in ipairs(Players:GetPlayers()) do if p ~= player then local r = p.Character and p.Character:FindFirstChild("HumanoidRootPart"); if r then local d = (root.Position - r.Position).Magnitude; if not bestD or d < bestD then best, bestD = p.Name, d end end end end; return best or "NONE" end,
    getNearestDistance = function() local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart"); local best; if not root then return "--" end; for _, p in ipairs(Players:GetPlayers()) do if p ~= player then local r = p.Character and p.Character:FindFirstChild("HumanoidRootPart"); if r then local d = (root.Position - r.Position).Magnitude; if not best or d < best then best = d end end end end; return best and math.floor(best + 0.5) or "--" end,
    getPlayersWithCharacters = function() local n = 0; for _, p in ipairs(Players:GetPlayers()) do if p.Character then n += 1 end end; return n end,
    getLocalPosition = function() local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart"); return r and tostring(r.Position) or "N/A" end,
    getJobIdLength = function() return #game.JobId end,
    getPlaceNameLength = function() return #tostring(game.Name) end,
    getGuiName = function() return gui.Name end,
    getPanelVisible = function() return panel.Visible end,
    getActivePage = function() return activePage or "NONE" end,
    getAccentColor = function() return string.format("%d,%d,%d", math.floor(C.pink.R * 255), math.floor(C.pink.G * 255), math.floor(C.pink.B * 255)) end,
    getMaxPlayers = function() return tostring(Players.MaxPlayers) end,
    getPlaceVersion = function() return tostring(game.PlaceVersion) end,
    getSafeMode = function() return "LOCAL ONLY" end,
    getScriptVersion = function() return "VIS HUB SAFE 1.0" end,
    getServerSummary = function() return string.format("%s · %d/%s", tostring(game.Name), #Players:GetPlayers(), tostring(Players.MaxPlayers)) end,
    getFilterSummary = function() return string.format("%s · %dm", statusFilter, maxDistance) end,
    getRandomTip = function() local tips = { "Menu local prêt.", "Préférences audio sauvegardées.", "Accent cyber rose actif.", "Aucune action distante exécutée." }; return tips[math.random(1, #tips)] end,
    getUptime = function() return string.format("%.0fs", os.clock()) end,
    getMemoryNote = function() local ok, value = pcall(function() return Stats:GetTotalMemoryUsageMb() end); return ok and string.format("%.1f MB", value) or "--" end,
    getConnectionNote = function() return "aucune connexion distante" end,
    getSelectionNote = function() return selectedPlayer and "joueur sélectionné" or "aucune sélection" end,
    getFilterMode = function() return maxDistance > 0 and "DISTANCE" or statusFilter ~= "ALL" and "STATUS" or "ALL" end,
    getWorldName = function() return tostring(workspace.Name) end,
    getCameraAvailable = function() return workspace.CurrentCamera ~= nil end,
    getCharacterParts = function() local c = player.Character; return c and #c:GetDescendants() or 0 end,
    getPlayerListState = function() return refreshPlayerList and "READY" or "WAITING" end,
    getRandomNumber = function() return math.random(1, 999) end,
    getLocalOnlyLabel = function() return "LOCAL" end,
    getAliveRatio = function() local total = #Players:GetPlayers(); return total > 0 and math.floor((RandomTools.getAliveCount() / total) * 100 + 0.5) or 0 end,
    getOwnHealth = function() local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid"); return h and math.floor(h.Health + 0.5) or 0 end,
    getOwnMaxHealth = function() local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid"); return h and math.floor(h.MaxHealth + 0.5) or 0 end,
    getOwnHumanoidState = function() local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid"); return h and h:GetState().Name or "NONE" end,
    getOwnRootHeight = function() local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart"); return r and math.floor(r.Position.Y + 0.5) or 0 end,
    getPanelPosition = function() return string.format("%.2f,%.2f", panel.Position.X.Scale, panel.Position.Y.Scale) end,
    getCurrentFilterCount = function() local count = 0; if refreshPlayerList then return #Players:GetPlayers() end; return count end,
    getAudioSummary = function() return featureState.audio and string.format("ON %d%%", math.floor(notificationVolume * 100 + 0.5)) or "OFF" end,
    getUiSummary = function() return string.format("%s · %s", activePage or "NONE", panel.Visible and "VISIBLE" or "HIDDEN") end,
    getSelectedDisplay = function() return selectedPlayer and selectedPlayer.DisplayName or "NONE" end,
}
local function renderPlayer()
    heading(playerPage, "PLAYER", "Outils locaux et diagnostics sûrs.")
    row(playerPage, "Notifications", "Messages bilingues du menu", "notifications", function(on) notice(on and "Notifications ON" or "Notifications OFF", "Préférence locale enregistrée.", on and C.green or C.yellow) end)
    row(playerPage, "FPS / Ping", "Métriques locales légères", "metrics", function(on) metrics.Visible = on; notice(on and "Metrics ON" or "Metrics OFF", "Affichage FPS/ping local.", on and C.green or C.yellow) end)

    local playersPanel = make("Frame", { Position = UDim2.fromOffset(10, 110), Size = UDim2.new(1, -20, 0, 254), BackgroundColor3 = C.row, BorderSizePixel = 0 }, playerPage)
    corner(playersPanel, 8)
    text(playersPanel, "PLAYERS · " .. tostring(game.Name), UDim2.fromOffset(11, 4), UDim2.new(1, -22, 0, 17), C.white, Enum.Font.GothamBold).TextSize = 10
    text(playersPanel, "PLACE " .. tostring(game.PlaceId) .. " · SERVER " .. string.sub(game.JobId, 1, 8), UDim2.fromOffset(11, 20), UDim2.new(1, -22, 0, 12), C.pink, Enum.Font.Gotham).TextSize = 8
    local distanceBox = make("TextBox", { Text = maxDistance > 0 and tostring(maxDistance) or "0", PlaceholderText = "MAX DIST", ClearTextOnFocus = false, Position = UDim2.fromOffset(8, 37), Size = UDim2.fromOffset(82, 24), BackgroundColor3 = C.bg, BorderSizePixel = 0, TextColor3 = C.white, PlaceholderColor3 = C.dim, TextSize = 9, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Center }, playersPanel)
    corner(distanceBox, 6)
    local statusButton = btn(playersPanel, "STATUS: " .. statusFilter, UDim2.fromOffset(96, 37), UDim2.fromOffset(118, 24), C.purple)
    statusButton.TextSize = 9
    local filterHint = text(playersPanel, "0 = distance illimitée", UDim2.fromOffset(218, 37), UDim2.new(1, -226, 0, 24), C.dim, Enum.Font.Gotham); filterHint.TextSize = 8
    local statsBar = make("Frame", { Position = UDim2.fromOffset(8, 66), Size = UDim2.new(1, -16, 0, 30), BackgroundTransparency = 1 }, playersPanel)
    local totalStat = text(statsBar, "TOTAL 0", UDim2.fromScale(0, 0), UDim2.fromScale(0.33, 1), C.pink, Enum.Font.GothamBold); totalStat.TextSize = 9
    local aliveStat = text(statsBar, "ALIVE 0", UDim2.fromScale(0.34, 0), UDim2.fromScale(0.33, 1), C.green, Enum.Font.GothamBold); aliveStat.TextSize = 9
    local averageStat = text(statsBar, "AVG --m", UDim2.fromScale(0.68, 0), UDim2.fromScale(0.32, 1), C.yellow, Enum.Font.GothamBold); averageStat.TextSize = 9; averageStat.TextXAlignment = Enum.TextXAlignment.Right
    local list = make("ScrollingFrame", { Position = UDim2.fromOffset(8, 101), Size = UDim2.new(1, -16, 1, -109), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = C.pink, CanvasSize = UDim2.fromOffset(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y }, playersPanel)
    local layout = make("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.Name }, list)
    refreshPlayerList = function()
        for _, child in ipairs(list:GetChildren()) do if not child:IsA("UIListLayout") then child:Destroy() end end
        local localRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local totalCount, aliveCount, distanceSum, distanceCount = #Players:GetPlayers(), 0, 0, 0
        for _, p in ipairs(Players:GetPlayers()) do local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid"); if h and h.Health > 0 then aliveCount += 1 end; local r = p.Character and p.Character:FindFirstChild("HumanoidRootPart"); if localRoot and r then distanceSum += (localRoot.Position - r.Position).Magnitude; distanceCount += 1 end end
        totalStat.Text, aliveStat.Text = "TOTAL " .. tostring(totalCount), "ALIVE " .. tostring(aliveCount)
        averageStat.Text = distanceCount > 0 and string.format("AVG %dm", math.floor(distanceSum / distanceCount + 0.5)) or "AVG --m"
        local visibleCount = 0
        for _, target in ipairs(Players:GetPlayers()) do
            local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
            local alive = humanoid and humanoid.Health > 0
            local distance = localRoot and targetRoot and (localRoot.Position - targetRoot.Position).Magnitude or nil
            local status = alive and "ALIVE" or "NO CHARACTER"
            local matchesDistance = maxDistance <= 0 or (distance and distance <= maxDistance)
            local matchesStatus = statusFilter == "ALL" or (statusFilter == "ALIVE" and alive) or (statusFilter == "NO CHARACTER" and not alive)
            if matchesDistance and matchesStatus then
            visibleCount += 1
            local item = make("Frame", { Name = target.Name, Size = UDim2.new(1, -4, 0, 28), BackgroundColor3 = target == selectedPlayer and C.pink or C.bg, BorderSizePixel = 0 }, list)
            corner(item, 7)
            local distanceText = distance and string.format(" · %dm", math.floor(distance + 0.5)) or " · --m"
            local label = text(item, target.DisplayName .. "  @" .. target.Name .. distanceText, UDim2.fromOffset(9, 0), UDim2.new(1, -48, 1, 0), C.white, Enum.Font.Gotham)
            label.TextSize = 9
            local info = btn(item, "i", UDim2.new(1, -34, 0.5, -11), UDim2.fromOffset(22, 22), C.purple)
            info.TextSize = 12
            info.Activated:Connect(function()
                selectedPlayer = target
                notice("Player selected", target.DisplayName .. " · local information only.", C.pink)
                if refreshPlayerList then refreshPlayerList() end
            end)
            end
        end
        if visibleCount == 0 then
            local empty = text(list, "Aucun joueur ne correspond au filtre.", UDim2.fromOffset(6, 0), UDim2.new(1, -12, 0, 24), C.dim, Enum.Font.Gotham)
            empty.TextSize = 9
        end
    end
    distanceBox.FocusLost:Connect(function()
        local value = tonumber(distanceBox.Text)
        maxDistance = value and math.max(0, value) or 0
        distanceBox.Text = maxDistance > 0 and tostring(math.floor(maxDistance)) or "0"
        refreshPlayerList()
    end)
    statusButton.Activated:Connect(function()
        statusFilter = statusFilter == "ALL" and "ALIVE" or statusFilter == "ALIVE" and "NO CHARACTER" or "ALL"
        statusButton.Text = "STATUS: " .. statusFilter
        refreshPlayerList()
    end)
    refreshPlayerList()
end
Players.PlayerAdded:Connect(function() if refreshPlayerList then refreshPlayerList() end end)
Players.PlayerRemoving:Connect(function(target) if target == selectedPlayer then selectedPlayer = nil end; if refreshPlayerList then refreshPlayerList() end end)
local function renderEsp()
    heading(espPage, "ESP / PERFORMANCE", "Outils locaux sans interaction distante.")
    row(espPage, "Anti Lag", "Effets visuels réversibles", "antiLag", setAntiLag)
    row(espPage, "Next Empty Base", "Marqueur local avec distance", "nextBase", setNextBase)
    local chart = make("Frame", { Position = UDim2.fromOffset(10, 110), Size = UDim2.new(1, -20, 0, 172), BackgroundColor3 = C.row, BorderSizePixel = 0 }, espPage)
    corner(chart, 8)
    local chartTitle = text(chart, "PERFORMANCE · FPS / PING", UDim2.fromOffset(10, 5), UDim2.new(1, -20, 0, 18), C.white, Enum.Font.GothamBold); chartTitle.TextSize = 10
    local current = text(chart, "FPS --   PING -- ms", UDim2.fromOffset(10, 24), UDim2.new(1, -20, 0, 16), C.pink, Enum.Font.Gotham); current.TextSize = 9
    local bars = {}
    for index = 1, 24 do
        local slot = make("Frame", { Position = UDim2.new((index - 1) / 24, 2, 0, 46), Size = UDim2.new(1 / 24, -4, 1, -54), BackgroundColor3 = C.bg, BorderSizePixel = 0 }, chart)
        corner(slot, 3)
        local fpsBar = make("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.fromScale(1, 0), BackgroundColor3 = C.pink, BorderSizePixel = 0 }, slot); corner(fpsBar, 3)
        local pingBar = make("Frame", { AnchorPoint = Vector2.new(1, 1), Position = UDim2.fromScale(1, 1), Size = UDim2.fromScale(0.42, 0), BackgroundColor3 = C.purple, BorderSizePixel = 0 }, slot); corner(pingBar, 3)
        bars[index] = { fps = fpsBar, ping = pingBar }
    end
    performanceChartRefresh = function()
        local lastFps, lastPing = fpsHistory[#fpsHistory] or 0, pingHistory[#pingHistory] or 0
        current.Text = string.format("FPS %s   PING %s ms", lastFps > 0 and tostring(lastFps) or "--", lastPing > 0 and tostring(lastPing) or "--")
        for index, pair in ipairs(bars) do
            local fps = fpsHistory[index] or 0
            local ping = pingHistory[index] or 0
            pair.fps.Size = UDim2.fromScale(1, math.clamp(fps / 120, 0, 1))
            pair.ping.Size = UDim2.fromScale(0.42, math.clamp(ping / 300, 0, 1))
        end
    end
    performanceChartRefresh()
end
local function renderSettings()
    heading(settingsPage, "SETTINGS", "Réglages d’affichage de la GUI.")
    row(settingsPage, "Compact mode", "Adaptation portrait mobile", "compact", function(on) panel.Size = on and UDim2.fromOffset(360, 390) or UDim2.fromOffset(650, 430); notice(on and "Compact ON" or "Compact OFF", "Taille du menu ajustée.", on and C.green or C.yellow) end)
    row(settingsPage, "Audio feedback", "Son local des notifications", "audio", function(on) if not on then pcall(function() feedbackSound:Stop() end) end; saveConfig(); notice(on and "Audio ON" or "Audio OFF", "Préférence audio locale.", on and C.green or C.yellow) end)

    local audioPanel = make("Frame", { Position = UDim2.fromOffset(10, 110), Size = UDim2.new(1, -20, 0, 92), BackgroundColor3 = C.row, BorderSizePixel = 0 }, settingsPage)
    corner(audioPanel, 8)
    text(audioPanel, "Custom notification sound", UDim2.fromOffset(11, 5), UDim2.new(1, -22, 0, 18), C.white, Enum.Font.GothamBold).TextSize = 11
    local soundBox = make("TextBox", { Text = notificationSoundId, PlaceholderText = "rbxassetid://...", ClearTextOnFocus = false, Position = UDim2.fromOffset(10, 29), Size = UDim2.new(1, -140, 0, 27), BackgroundColor3 = C.bg, BorderSizePixel = 0, TextColor3 = C.white, PlaceholderColor3 = C.dim, TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left }, audioPanel)
    corner(soundBox, 6)
    local applySound = btn(audioPanel, "APPLY", UDim2.new(1, -120, 0, 29), UDim2.fromOffset(52, 27), C.purple)
    local testSound = btn(audioPanel, "TEST", UDim2.new(1, -62, 0, 29), UDim2.fromOffset(52, 27), C.green)
    local volumeLabel = text(audioPanel, string.format("Volume: %d%%", math.floor(notificationVolume * 100 + 0.5)), UDim2.fromOffset(11, 62), UDim2.fromOffset(100, 20), C.dim, Enum.Font.Gotham)
    local minus = btn(audioPanel, "−", UDim2.fromOffset(120, 60), UDim2.fromOffset(26, 24), C.bg)
    local plus = btn(audioPanel, "+", UDim2.fromOffset(152, 60), UDim2.fromOffset(26, 24), C.bg)
    local function updateVolume(value)
        notificationVolume = math.clamp(value, 0, 1)
        feedbackSound.Volume = notificationVolume
        saveConfig()
        volumeLabel.Text = string.format("Volume: %d%%", math.floor(notificationVolume * 100 + 0.5))
    end
    applySound.Activated:Connect(function()
        local value = soundBox.Text:match("^%s*(.-)%s*$")
        if value and value ~= "" then
            notificationSoundId = value
            feedbackSound.SoundId = notificationSoundId
            config.soundId = notificationSoundId
            saveConfig()
            notice("Sound updated", "Identifiant audio local appliqué.", C.green)
        end
    end)
    testSound.Activated:Connect(function() playFeedback() end)
    minus.Activated:Connect(function() updateVolume(notificationVolume - 0.05) end)
    plus.Activated:Connect(function() updateVolume(notificationVolume + 0.05) end)
    local resetButton = btn(settingsPage, "RESET POSITION", UDim2.fromOffset(12, 218), UDim2.fromOffset(130, 28), C.bg)
    local accentButton = btn(settingsPage, "RANDOM ACCENT", UDim2.fromOffset(150, 218), UDim2.fromOffset(130, 28), C.purple)
    local refreshButton = btn(settingsPage, "REFRESH PLAYERS", UDim2.fromOffset(12, 252), UDim2.fromOffset(130, 28), C.bg)
    local randomNoticeButton = btn(settingsPage, "RANDOM NOTICE", UDim2.fromOffset(150, 252), UDim2.fromOffset(130, 28), C.pink)
    resetButton.Activated:Connect(function()
        panel.Position = UDim2.fromScale(0.5, 0.5)
        saveConfig()
        notice("Position reset", "Le panneau a été recentré.", C.pink)
    end)
    refreshButton.Activated:Connect(function()
        if refreshPlayerList then refreshPlayerList() end
        notice("Players refreshed", tostring(#Players:GetPlayers()) .. " joueur(s) dans ce serveur.", C.pink)
    end)
    randomNoticeButton.Activated:Connect(function()
        local tips = { "Menu local prêt.", "Préférences audio sauvegardées.", "Accent cyber rose actif.", "Aucune action distante exécutée." }
        notice("Random notice", RandomTools.getRandomTip() .. " · #" .. tostring(RandomTools.getRandomNumber()), C.pink)
    end)
    accentButton.Activated:Connect(function()
        local accents = { Color3.fromRGB(255, 20, 170), Color3.fromRGB(255, 55, 145), Color3.fromRGB(236, 46, 255), Color3.fromRGB(255, 105, 190) }
        local accent = accents[math.random(1, #accents)]
        C.pink, C.purple = accent, accent:Lerp(Color3.new(1, 1, 1), 0.18)
        panelStroke.Color = C.purple
        mini.BackgroundColor3, content.ScrollBarImageColor3 = C.purple, C.pink
        for tabName, tab in pairs(tabButtons) do tab.BackgroundColor3 = tabName == activePage and C.pink or C.row end
        notice("Cyber accent", "Accent rose aléatoire appliqué.", C.pink)
    end)
    local thresholdBox = make("TextBox", { Text = tostring(math.floor(memoryThreshold)), PlaceholderText = "500", ClearTextOnFocus = false, Position = UDim2.fromOffset(12, 326), Size = UDim2.fromOffset(110, 26), BackgroundColor3 = C.bg, BorderSizePixel = 0, TextColor3 = C.white, PlaceholderColor3 = C.dim, TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Center }, settingsPage)
    corner(thresholdBox, 6)
    local thresholdApply = btn(settingsPage, "MEM LIMIT (MB)", UDim2.fromOffset(130, 326), UDim2.fromOffset(140, 26), C.purple)
    thresholdApply.Activated:Connect(function()
        local value = tonumber(thresholdBox.Text)
        if value then memoryThreshold = math.max(50, value); thresholdBox.Text = tostring(math.floor(memoryThreshold)); saveConfig(); notice("Memory limit updated", "Alerte à " .. tostring(math.floor(memoryThreshold)) .. " MB.", C.pink) end
    end)
    local info = text(settingsPage, "Seuil mémoire local : l’indicateur passe en rouge et une notification apparaît lorsque la limite est dépassée.", UDim2.fromOffset(12, 360), UDim2.new(1, -24, 0, 42), C.dim, Enum.Font.Gotham); info.TextWrapped = true; info.TextSize = 10
end
local function select(name)
    activePage = name
    for tabName, tab in pairs(tabButtons) do tab.BackgroundColor3 = tabName == name and C.pink or C.row end
    for pageName, page in pairs(pages) do page.Visible = pageName == name end
    if name == "PLAYER" then renderPlayer() elseif name == "ESP" then renderEsp() else renderSettings() end
end
for index, name in ipairs({ "PLAYER", "ESP", "SETTINGS" }) do
    local tab = btn(tabsFrame, name, UDim2.fromOffset(10, 12 + (index - 1) * 52), UDim2.new(1, -20, 0, 38), C.row)
    tabButtons[name] = tab
    tab.Activated:Connect(function() select(name) end)
end
close.Activated:Connect(function() panel.Visible = false; mini.Visible = true end)
mini.Activated:Connect(function() mini.Visible = false; panel.Visible = true end)

local dragging, dragInput, dragStart, panelStart
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; panelStart = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(panelStart.X.Scale, panelStart.X.Offset + delta.X, panelStart.Y.Scale, panelStart.Y.Offset + delta.Y)
        saveConfig()
    end
end)

local frames, elapsed, balanceTimer, playerStatsTimer = 0, 0, 0, 0
local function updateBalance()
    local leaderstats = player:FindFirstChild("leaderstats")
    local value = leaderstats and (leaderstats:FindFirstChild("Cash") or leaderstats:FindFirstChild("Money") or leaderstats:FindFirstChild("Coins") or leaderstats:FindFirstChild("Points"))
    if value then balance.Text = "CASH " .. tostring(value.Value) else balance.Text = "CASH --" end
end
updateBalance()
RunService.Heartbeat:Connect(function(dt)
    frames += 1; elapsed += dt; balanceTimer += dt; playerStatsTimer += dt
    if balanceTimer >= 1 then
        balanceTimer = 0; updateBalance()
        local ok, value = pcall(function() return Stats:GetTotalMemoryUsageMb() end)
        if ok then
            local critical = value >= memoryThreshold
            memory.TextColor3 = critical and C.red or C.yellow
            memory.Text = critical and string.format("MEM ALERT %.1f", value) or string.format("MEM %.1f MB", value)
            if critical and not memoryAlertActive then notice("Memory critical", string.format("Utilisation %.1f MB · limite %d MB.", value, memoryThreshold), C.red) end
            memoryAlertActive = critical
        else
            memory.TextColor3, memory.Text = C.yellow, "MEM -- MB"
        end
    end
    if playerStatsTimer >= 1 then playerStatsTimer = 0; if refreshPlayerList then refreshPlayerList() end end
    if elapsed < 1 then return end
    local fps = math.floor(frames / elapsed + 0.5); frames, elapsed = 0, 0
    local pingValue = 0
    pcall(function() pingValue = math.floor(player:GetNetworkPing() * 1000 + 0.5) end)
    table.insert(fpsHistory, fps); table.insert(pingHistory, pingValue)
    if #fpsHistory > 24 then table.remove(fpsHistory, 1) end
    if #pingHistory > 24 then table.remove(pingHistory, 1) end
    if performanceChartRefresh then performanceChartRefresh() end
    metrics.Text = string.format("FPS %d  ·  PING %s ms", fps, pingValue > 0 and tostring(pingValue) or "--")
end)
local function fit()
    local camera = workspace.CurrentCamera
    local view = camera and camera.ViewportSize or Vector2.new(1280, 720)
    if view.Y > view.X then
        panel.Size = UDim2.fromOffset(math.max(300, view.X - 20), math.min(620, math.max(390, view.Y - 30)))
        tabsFrame.Position = UDim2.fromOffset(10, 76); tabsFrame.Size = UDim2.new(1, -20, 0, 48)
        content.Position = UDim2.fromOffset(10, 132); content.Size = UDim2.new(1, -20, 1, -154)
        for index, name in ipairs({ "PLAYER", "ESP", "SETTINGS" }) do local tab = tabButtons[name]; tab.Position = UDim2.new((index - 1) / 3, 6, 0, 6); tab.Size = UDim2.new(1 / 3, -12, 0, 36); tab.TextSize = 9 end
        hint.Visible = false
    else
        panel.Size = featureState.compact and UDim2.fromOffset(360, 390) or UDim2.fromOffset(650, 430)
        tabsFrame.Position = UDim2.fromOffset(14, 76); tabsFrame.Size = UDim2.fromOffset(145, 330)
        content.Position = UDim2.fromOffset(173, 76); content.Size = UDim2.new(1, -187, 1, -98)
        for index, name in ipairs({ "PLAYER", "ESP", "SETTINGS" }) do local tab = tabButtons[name]; tab.Position = UDim2.fromOffset(10, 12 + (index - 1) * 52); tab.Size = UDim2.new(1, -20, 0, 38); tab.TextSize = 11 end
        hint.Visible = true
    end
end
select("PLAYER")
fit()
local camera = workspace.CurrentCamera
if camera then camera:GetPropertyChangedSignal("ViewportSize"):Connect(fit) end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(fit)
notice("VIS HUB prêt", "Édition locale sûre chargée.", C.green)
print("[VIS HUB] Safe Local Edition chargée")
