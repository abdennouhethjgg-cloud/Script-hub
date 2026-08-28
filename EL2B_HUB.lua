--[=[
    EL2B HUB · VIS MENU SAFE EDITION
    Menu visuel à onglets inspiré de VIS HUB.
    Les actions de jeu seront ajoutées et validées séparément.
]=]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local STATUS_URL = "https://el2bstatus-amhrowxg.manus.space/api/script-status"

local player = Players.LocalPlayer
if not player then
    warn("[EL2B HUB] Joueur local indisponible")
    return
end

local playerGui = player:WaitForChild("PlayerGui", 15)
if not playerGui then
    warn("[EL2B HUB] Interface joueur indisponible")
    return
end

local MAIN_NAME = "EL2BVisMenu"
local MINI_NAME = "EL2BVisMini"
local COLORS = {
    background = Color3.fromRGB(12, 12, 16),
    panel = Color3.fromRGB(22, 21, 29),
    panel2 = Color3.fromRGB(29, 27, 38),
    accent = Color3.fromRGB(255, 20, 147),
    purple = Color3.fromRGB(172, 92, 238),
    text = Color3.fromRGB(248, 245, 252),
    dim = Color3.fromRGB(166, 160, 181),
    green = Color3.fromRGB(76, 224, 133),
    yellow = Color3.fromRGB(255, 196, 92),
}

local function clear(name)
    local old = playerGui:FindFirstChild(name)
    if old then old:Destroy() end
end
clear(MAIN_NAME)
clear(MINI_NAME)

local function corner(parent, radius)
    local item = Instance.new("UICorner")
    item.CornerRadius = UDim.new(0, radius)
    item.Parent = parent
end

local function stroke(parent, color, transparency)
    local item = Instance.new("UIStroke")
    item.Color = color
    item.Transparency = transparency or 0
    item.Thickness = 1
    item.Parent = parent
end

local function label(parent, text, position, size, textSize, color)
    local item = Instance.new("TextLabel")
    item.BackgroundTransparency = 1
    item.Position = position
    item.Size = size
    item.Font = Enum.Font.Gotham
    item.Text = text
    item.TextColor3 = color or COLORS.text
    item.TextSize = textSize or 13
    item.TextWrapped = true
    item.TextXAlignment = Enum.TextXAlignment.Left
    item.Parent = parent
    return item
end

local function button(parent, text, position, size, color)
    local item = Instance.new("TextButton")
    item.AutoButtonColor = true
    item.BackgroundColor3 = color or COLORS.panel2
    item.BorderSizePixel = 0
    item.Font = Enum.Font.GothamSemibold
    item.Position = position
    item.Size = size
    item.Text = text
    item.TextColor3 = COLORS.text
    item.TextSize = 12
    item.Parent = parent
    corner(item, 8)
    stroke(item, COLORS.purple, 0.55)
    return item
end

local mainGui = Instance.new("ScreenGui")
mainGui.Name = MAIN_NAME
mainGui.ResetOnSpawn = false
mainGui.IgnoreGuiInset = true
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mainGui.Parent = playerGui

local panel = Instance.new("Frame")
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.new(0.5, 0, 0.5, 0)
panel.Size = UDim2.fromOffset(620, 430)
panel.BackgroundColor3 = COLORS.background
panel.BorderSizePixel = 0
panel.Parent = mainGui
corner(panel, 16)
stroke(panel, COLORS.purple, 0.2)
local panelScale = Instance.new("UIScale")
panelScale.Scale = 1
panelScale.Parent = panel

local top = Instance.new("Frame")
top.BackgroundColor3 = COLORS.panel
 top.BorderSizePixel = 0
top.Position = UDim2.fromOffset(1, 1)
top.Size = UDim2.new(1, -2, 0, 64)
top.Parent = panel
corner(top, 15)
label(top, "VIS HUB", UDim2.fromOffset(20, 8), UDim2.new(1, -160, 0, 28), 23, COLORS.text).Font = Enum.Font.GothamBold
label(top, "EL2B SAFE MENU · READY", UDim2.fromOffset(21, 37), UDim2.new(1, -160, 0, 18), 10, COLORS.purple)
local live = label(top, "LOCAL · STABLE", UDim2.new(1, -170, 0, 22), UDim2.fromOffset(108, 18), 9, COLORS.green)
live.TextXAlignment = Enum.TextXAlignment.Right
local metrics = label(top, "FPS --  ·  PING -- ms", UDim2.new(1, -250, 0, 43), UDim2.fromOffset(188, 16), 9, COLORS.dim)
metrics.TextXAlignment = Enum.TextXAlignment.Right
local close = button(top, "−", UDim2.new(1, -52, 0, 17), UDim2.fromOffset(34, 30), Color3.fromRGB(51, 25, 55))
close.TextSize = 20
local lockButton = button(top, "LOCK", UDim2.new(1, -112, 0, 17), UDim2.fromOffset(52, 30), Color3.fromRGB(42, 31, 55))
lockButton.TextSize = 9
local menuLocked = false

local side = Instance.new("Frame")
side.BackgroundColor3 = COLORS.panel
side.BorderSizePixel = 0
side.Position = UDim2.fromOffset(14, 78)
side.Size = UDim2.fromOffset(142, 330)
side.Parent = panel
corner(side, 12)
stroke(side, Color3.fromRGB(78, 65, 95), 0.35)

local content = Instance.new("ScrollingFrame")
content.BackgroundColor3 = COLORS.panel
content.BorderSizePixel = 0
content.Position = UDim2.fromOffset(170, 78)
content.Size = UDim2.new(1, -184, 1, -92)
content.CanvasSize = UDim2.fromOffset(0, 0)
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = COLORS.accent
content.ScrollingDirection = Enum.ScrollingDirection.Y
content.Active = true
content.Parent = panel
corner(content, 12)
stroke(content, Color3.fromRGB(78, 65, 95), 0.35)

local scrollHint = label(panel, "SCROLL ↓ · FAIS GLISSER POUR VOIR PLUS", UDim2.fromOffset(184, 409), UDim2.new(1, -204, 0, 16), 9, COLORS.purple)
scrollHint.TextXAlignment = Enum.TextXAlignment.Right
scrollHint.Visible = false

local noticeVersion = 0
local noticeHolder = Instance.new("Frame")
noticeHolder.Name = "NotificationHolder"
noticeHolder.AnchorPoint = Vector2.new(1, 0)
noticeHolder.BackgroundTransparency = 1
noticeHolder.Position = UDim2.new(1, -18, 0, 78)
noticeHolder.Size = UDim2.fromOffset(300, 110)
noticeHolder.Parent = mainGui

local function showNotice(titleText, bodyText, tone)
    noticeVersion += 1
    local version = noticeVersion
    local card = Instance.new("Frame")
    card.BackgroundColor3 = COLORS.panel2
    card.BorderSizePixel = 0
    card.Position = UDim2.new(1, 24, 0, 0)
    card.Size = UDim2.fromOffset(300, 78)
    card.Parent = noticeHolder
    card.ZIndex = 20
    corner(card, 12)
    stroke(card, tone or COLORS.purple, 0.15)
    local marker = Instance.new("Frame")
    marker.BackgroundColor3 = tone or COLORS.purple
    marker.BorderSizePixel = 0
    marker.Position = UDim2.fromOffset(12, 16)
    marker.Size = UDim2.fromOffset(6, 46)
    marker.Parent = card
    marker.ZIndex = 21
    corner(marker, 4)
    local title = label(card, titleText, UDim2.fromOffset(29, 11), UDim2.new(1, -72, 0, 22), 13, COLORS.text)
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 21
    local body = label(card, bodyText, UDim2.fromOffset(29, 36), UDim2.new(1, -72, 0, 30), 10, COLORS.dim)
    body.ZIndex = 21
    local dismiss = button(card, "×", UDim2.new(1, -38, 0, 17), UDim2.fromOffset(26, 26), Color3.fromRGB(51, 25, 55))
    dismiss.TextSize = 17
    dismiss.ZIndex = 21
    local function hide()
        if card.Parent then
            local tween = TweenService:Create(card, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 24, 0, 0)})
            tween:Play()
            tween.Completed:Connect(function() if card.Parent then card:Destroy() end end)
        end
    end
    dismiss.Activated:Connect(hide)
    TweenService:Create(card, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1, -300, 0, 0)}):Play()
    task.delay(3.5, function()
        if version == noticeVersion then hide() end
    end)
end

local miniGui
local updateGui = Instance.new("ScreenGui")
updateGui.Name = "EL2BUpdateGui"
updateGui.ResetOnSpawn = false
updateGui.IgnoreGuiInset = true
updateGui.Enabled = false
updateGui.Parent = playerGui

local updateCard = Instance.new("Frame")
updateCard.AnchorPoint = Vector2.new(0.5, 0.5)
updateCard.Position = UDim2.new(0.5, 0, 0.5, 0)
updateCard.Size = UDim2.fromOffset(390, 210)
updateCard.BackgroundColor3 = COLORS.panel2
updateCard.BorderSizePixel = 0
updateCard.Parent = updateGui
corner(updateCard, 16)
stroke(updateCard, COLORS.accent, 0.15)
label(updateCard, "EL2B HUB · UPDATE", UDim2.fromOffset(22, 18), UDim2.new(1, -44, 0, 27), 19, COLORS.text).Font = Enum.Font.GothamBold
local updateTitle = label(updateCard, "Mise à jour en cours / Update in progress", UDim2.fromOffset(22, 55), UDim2.new(1, -44, 0, 22), 12, COLORS.purple)
local updateBody = label(updateCard, "Le script est temporairement désactivé.\\nThe script is temporarily disabled.", UDim2.fromOffset(22, 84), UDim2.new(1, -44, 0, 42), 12, COLORS.dim)
local updateProgress = Instance.new("Frame")
updateProgress.BackgroundColor3 = COLORS.accent
updateProgress.BorderSizePixel = 0
updateProgress.Position = UDim2.fromOffset(22, 145)
updateProgress.Size = UDim2.fromOffset(0, 8)
updateProgress.Parent = updateCard
corner(updateProgress, 5)
local updateHint = label(updateCard, "En attente du website / Waiting for website", UDim2.fromOffset(22, 165), UDim2.new(1, -44, 0, 20), 10, COLORS.dim)

local function setUpdateVisible(visible, messageFr, messageEn, maintenance)
    if visible then
        mainGui.Enabled = false
        miniGui.Enabled = false
        updateGui.Enabled = true
        updateTitle.Text = maintenance and "Admin Abuse · Maintenance" or "Mise à jour en cours / Update in progress"
        updateBody.Text = (messageFr or "Le script est temporairement désactivé.") .. "\\n" .. (messageEn or "The script is temporarily disabled.")
        updateHint.Text = maintenance and "Samedi 21:00–21:30 UTC+2" or "En attente du website / Waiting for website"
        updateProgress.Size = UDim2.fromOffset(250, 8)
    else
        updateGui.Enabled = false
        mainGui.Enabled = true
        miniGui.Enabled = false
        updateProgress.Size = UDim2.fromOffset(0, 8)
    end
end

local antiLagEnabled = false
local savedVisualStates = {}
local savedLightingState
local visualClasses = {
    ParticleEmitter = true,
    Trail = true,
    Beam = true,
    Smoke = true,
    Fire = true,
    Sparkles = true,
}

local function setAntiLag(enabled)
    antiLagEnabled = enabled == true
    if antiLagEnabled then
        if not savedLightingState then
            savedLightingState = {
                GlobalShadows = Lighting.GlobalShadows,
                FogEnd = Lighting.FogEnd,
                Brightness = Lighting.Brightness,
                EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
                EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
                Effects = {},
            }
            for _, effect in ipairs(Lighting:GetChildren()) do
                if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") then
                    savedLightingState.Effects[effect] = effect.Enabled
                    effect.Enabled = false
                end
            end
        end
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1000000
        Lighting.Brightness = 1
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        for _, object in ipairs(workspace:GetDescendants()) do
            if visualClasses[object.ClassName] then
                if savedVisualStates[object] == nil then
                    savedVisualStates[object] = object.Enabled
                end
                object.Enabled = false
            end
        end
        live.Text = "ANTI LAG · ON"
        live.TextColor3 = COLORS.green
    else
        for object, wasEnabled in pairs(savedVisualStates) do
            if object and object.Parent then
                object.Enabled = wasEnabled
            end
        end
        savedVisualStates = {}
        if savedLightingState then
            Lighting.GlobalShadows = savedLightingState.GlobalShadows
            Lighting.FogEnd = savedLightingState.FogEnd
            Lighting.Brightness = savedLightingState.Brightness
            Lighting.EnvironmentDiffuseScale = savedLightingState.EnvironmentDiffuseScale
            Lighting.EnvironmentSpecularScale = savedLightingState.EnvironmentSpecularScale
            for effect, wasEnabled in pairs(savedLightingState.Effects) do
                if effect and effect.Parent then effect.Enabled = wasEnabled end
            end
            savedLightingState = nil
        end
        live.Text = "LOCAL · STABLE"
        live.TextColor3 = COLORS.green
    end
end

local fpsFrames = 0
local fpsStartedAt = os.clock()
local metricsConnection
local function readPing()
    local ok, value = pcall(function()
        return player:GetNetworkPing() * 1000
    end)
    if ok and type(value) == "number" then
        return math.max(0, math.floor(value + 0.5))
    end
    return nil
end

metricsConnection = RunService.RenderStepped:Connect(function()
    fpsFrames += 1
    local now = os.clock()
    local elapsed = now - fpsStartedAt
    if elapsed < 1 then return end
    local fps = math.floor((fpsFrames / elapsed) + 0.5)
    local ping = readPing()
    metrics.Text = string.format("FPS %d  ·  PING %s", fps, ping and (tostring(ping) .. " ms") or "N/A")
    metrics.TextColor3 = ping and (ping >= 180 and COLORS.yellow or COLORS.green) or COLORS.dim
    fpsFrames = 0
    fpsStartedAt = now
    if not mainGui.Parent then
        metricsConnection:Disconnect()
    end
end)

local websiteMode = "unknown"
local function syncWebsiteStatus()
    local ok, raw = pcall(function()
        return HttpService:GetAsync(STATUS_URL, true)
    end)
    if not ok then
        live.Text = "WEB · OFFLINE"
        live.TextColor3 = COLORS.yellow
        if websiteMode ~= "offline" then
            showNotice("Website indisponible", "La GUI principale reste ouverte / Main GUI stays open.", COLORS.yellow)
        end
        websiteMode = "offline"
        return false
    end

    local decoded, payload = pcall(function()
        return HttpService:JSONDecode(raw)
    end)
    if not decoded or type(payload) ~= "table" then
        live.Text = "WEB · INVALID"
        live.TextColor3 = COLORS.yellow
        websiteMode = "invalid"
        return false
    end

    local maintenance = type(payload.scheduledMaintenance) == "table" and payload.scheduledMaintenance.active == true
    local updateRequired = payload.enabled ~= true or maintenance
    if updateRequired then
        local mode = maintenance and "maintenance" or "update"
        setUpdateVisible(true, payload.updateMessageFr, payload.updateMessageEn, maintenance)
        if websiteMode ~= mode then
            showNotice(maintenance and "Admin Abuse actif" or "Script en mise à jour", maintenance and "La mini-GUI update reste affichée." or "Le statut du website demande une mise à jour.", COLORS.accent)
        end
        websiteMode = mode
        live.Text = maintenance and "WEB · UPDATE" or "WEB · DISABLED"
        live.TextColor3 = COLORS.yellow
    else
        setUpdateVisible(false)
        if websiteMode ~= "online" then
            showNotice("Website connecté", "Le script principal est disponible / Main script is ready.", COLORS.green)
        end
        websiteMode = "online"
        live.Text = "WEB · ON"
        live.TextColor3 = COLORS.green
    end
    return true
end

local installationId = string.format("el2b-%08x%08x%08x", math.random(0, 0xFFFFFF), math.random(0, 0xFFFFFF), math.random(0, 0xFFFFFF))
local heartbeatState = "unknown"
local function sendHeartbeat()
    local ok, response = pcall(function()
        return HttpService:RequestAsync({
            Url = STATUS_URL:gsub("/api/script%-status$", "/api/script-heartbeat"),
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({ installationId = installationId, idleNpcCount = 0 }),
        })
    end)
    if not ok or type(response) ~= "table" or response.Success ~= true then
        heartbeatState = "offline"
        return false
    end
    heartbeatState = "online"
    return true
end

local tabs = {"PLAYER", "ESP", "SETTINGS"}
local tabButtons = {}
local activeTab = "PLAYER"
local featureRows = {}

local function resetRows()
    for _, row in ipairs(featureRows) do row:Destroy() end
    featureRows = {}
    content.CanvasPosition = Vector2.new(0, 0)
    content.CanvasSize = UDim2.fromOffset(0, 0)
    scrollHint.Visible = false
end

local nextBaseCleanup
local function setNextEmptyBase(enabled)
    if nextBaseCleanup then
        nextBaseCleanup()
        nextBaseCleanup = nil
    end
    if not enabled then
        showNotice("Next Empty Base désactivé", "Le marqueur local a été retiré.", COLORS.yellow)
        return
    end

    local plots = workspace:FindFirstChild("Plots")
    if not plots then
        showNotice("Next Empty Base indisponible", "Le dossier Plots est absent dans cette partie.", COLORS.yellow)
        return
    end

    local positions = {
        Vector3.new(-342.439, 10.399, 113.107),
        Vector3.new(-342.439, 10.465, 6.107),
        Vector3.new(-476.752, 10.465, 114.107),
        Vector3.new(-476.752, 10.465, 7.107),
        Vector3.new(-342.440, 10.464, 220.107),
        Vector3.new(-476.752, 10.465, 221.107),
        Vector3.new(-342.439, 10.465, -100.893),
        Vector3.new(-476.752, 10.465, -99.893),
    }
    local bases, connected, connections = {}, {}, {}
    local anchor = Instance.new("Part")
    anchor.Name = "EL2BNextBaseAnchor"
    anchor.Anchored = true
    anchor.CanCollide, anchor.CanQuery, anchor.CanTouch = false, false, false
    anchor.Transparency = 1
    anchor.Size = Vector3.new(1, 1, 1)
    anchor.Parent = workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "EL2BNextBaseBillboard"
    billboard.Adornee = anchor
    billboard.Size = UDim2.fromOffset(210, 98)
    billboard.StudsOffset = Vector3.new(0, 8, 0)
    billboard.MaxDistance = 300
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.Enabled = false
    billboard.Parent = anchor
    local nextLabel = label(billboard, "▼  NEXT  ▼", UDim2.fromScale(0, 0.05), UDim2.fromScale(1, 0.45), 23, COLORS.green)
    nextLabel.TextXAlignment = Enum.TextXAlignment.Center
    nextLabel.Font = Enum.Font.GothamBlack
    nextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nextLabel.TextStrokeTransparency = 0
    local emptyLabel = label(billboard, "EMPTY BASE", UDim2.fromScale(0, 0.38), UDim2.fromScale(1, 0.28), 16, COLORS.text)
    emptyLabel.TextXAlignment = Enum.TextXAlignment.Center
    emptyLabel.Font = Enum.Font.GothamBlack
    emptyLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    emptyLabel.TextStrokeTransparency = 0
    local distanceLabel = label(billboard, "DISTANCE: -- m", UDim2.fromScale(0, 0.68), UDim2.fromScale(1, 0.24), 12, COLORS.yellow)
    distanceLabel.TextXAlignment = Enum.TextXAlignment.Center
    distanceLabel.Font = Enum.Font.GothamBold
    distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    distanceLabel.TextStrokeTransparency = 0
    local currentTarget
    local distanceTimer = 0
    local distanceConnection

    local function indexFor(model)
        local ok, box = pcall(function() return model:GetBoundingBox() end)
        if not ok or not box then return nil end
        local point = box.Position
        local bestIndex, bestDistance
        for index, basePosition in ipairs(positions) do
            local dx, dz = point.X - basePosition.X, point.Z - basePosition.Z
            local distance = math.sqrt(dx * dx + dz * dz)
            if not bestDistance or distance < bestDistance then
                bestIndex, bestDistance = index, distance
            end
        end
        return bestDistance and bestDistance <= 6 and bestIndex or nil
    end

    local function isEmpty(textLabel)
        local value = textLabel.Text:gsub("^%s+", ""):gsub("%s+$", "")
        return value == "Empty Base"
    end

    local function recompute()
        local target
        for index = 1, #positions do
            local base = bases[index]
            if base and base.textLabel and isEmpty(base.textLabel) then target = base break end
        end
        if target then
            currentTarget = target
            anchor.CFrame = target.cframe
            billboard.Enabled = true
        else
            currentTarget = nil
            billboard.Enabled = false
            distanceLabel.Text = "DISTANCE: -- m"
        end
    end

    distanceConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not billboard.Enabled or not currentTarget then return end
        distanceTimer += deltaTime
        if distanceTimer < 0.25 then return end
        distanceTimer = 0
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if root then
            local meters = math.floor(((root.Position - anchor.Position).Magnitude * 0.28) + 0.5)
            distanceLabel.Text = string.format("DISTANCE: %d m", meters)
        else
            distanceLabel.Text = "DISTANCE: -- m"
        end
    end)

    local function connectText(textLabel)
        if connected[textLabel] then return end
        connected[textLabel] = true
        table.insert(connections, textLabel:GetPropertyChangedSignal("Text"):Connect(recompute))
    end

    local function scan()
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local model = sign and sign:FindFirstChild("Model")
            local surface = sign and sign:FindFirstChild("SurfaceGui")
            local frame = surface and surface:FindFirstChild("Frame")
            local textLabel = frame and frame:FindFirstChild("TextLabel")
            if model and textLabel then
                local index = indexFor(model)
                if index then
                    local cframe = select(1, model:GetBoundingBox())
                    bases[index] = { textLabel = textLabel, cframe = cframe }
                    connectText(textLabel)
                end
            end
        end
        recompute()
    end

    scan()
    table.insert(connections, plots.ChildAdded:Connect(function() task.defer(scan) end))
    table.insert(connections, plots.DescendantAdded:Connect(function(item)
        if item:IsA("TextLabel") then task.defer(scan) end
    end))
    nextBaseCleanup = function()
        for _, connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
        if distanceConnection then pcall(function() distanceConnection:Disconnect() end) end
        if anchor and anchor.Parent then anchor:Destroy() end
    end
    showNotice("Next Empty Base activé", "Le marqueur apparaît sur la première base vide détectée.", COLORS.green)
end

local function addFeatureRow(name, detail, enabledByDefault)
    local index = #featureRows
    local row = Instance.new("Frame")
    row.BackgroundColor3 = index % 2 == 0 and Color3.fromRGB(27, 25, 35) or Color3.fromRGB(23, 22, 30)
    row.BorderSizePixel = 0
    row.Position = UDim2.fromOffset(14, 58 + index * 52)
    row.Size = UDim2.new(1, -28, 0, 43)
    row.Parent = content
    corner(row, 8)
    label(row, name, UDim2.fromOffset(12, 5), UDim2.new(1, -150, 0, 19), 12, COLORS.text)
    label(row, detail, UDim2.fromOffset(12, 24), UDim2.new(1, -150, 0, 15), 9, COLORS.dim)
    local isOn = enabledByDefault == true
    local state = button(row, isOn and "ON" or "OFF", UDim2.new(1, -132, 0, 8), UDim2.fromOffset(118, 27), isOn and Color3.fromRGB(35, 100, 62) or Color3.fromRGB(45, 39, 51))
    state.TextSize = 10
    state.TextColor3 = isOn and Color3.fromRGB(207, 255, 222) or COLORS.dim
    state.Activated:Connect(function()
        isOn = not isOn
        if name == "Anti Lag" then
            setAntiLag(isOn)
            state.Text = isOn and "ON" or "OFF"
            showNotice(isOn and "Anti Lag activé" or "Anti Lag désactivé", isOn and "Effets visuels réduits localement." or "Les effets visuels précédents sont restaurés.", isOn and COLORS.green or COLORS.yellow)
        elseif name == "Next Empty Base" then
            setNextEmptyBase(isOn)
            state.Text = isOn and "ON" or "OFF"
        else
            state.Text = isOn and "ON · UI" or "OFF"
            showNotice(name, isOn and "État visuel activé · action locale en attente." or "État visuel désactivé.", isOn and COLORS.purple or COLORS.yellow)
        end
        state.BackgroundColor3 = isOn and Color3.fromRGB(35, 100, 62) or Color3.fromRGB(45, 39, 51)
        state.TextColor3 = isOn and Color3.fromRGB(207, 255, 222) or COLORS.dim
    end)
    table.insert(featureRows, row)
    content.CanvasSize = UDim2.fromOffset(0, 78 + (#featureRows * 52))
    scrollHint.Visible = #featureRows > 5
end

local function renderPlayer()
    resetRows()
    label(content, "PLAYER", UDim2.fromOffset(14, 12), UDim2.new(1, -28, 0, 26), 18, COLORS.text).Font = Enum.Font.GothamBold
    label(content, "Fonctions visuelles préparées, sans automatisation active.", UDim2.fromOffset(14, 36), UDim2.new(1, -28, 0, 18), 10, COLORS.dim)
    addFeatureRow("Anti Gummy", "Protection locale · prêt pour validation", false)
    addFeatureRow("Anti Ragdoll", "État local · contrôle manuel", false)
    addFeatureRow("Anti Paintball", "État local · contrôle manuel", false)
    addFeatureRow("Anti Boogie", "État local · contrôle manuel", false)
    addFeatureRow("Speed · 3 modes", "Normal · Lagger · Custom", false)
    addFeatureRow("Drop Jump / Stand", "Commande locale à définir", false)
    addFeatureRow("Next Empty Base", "Marqueur local de base vide", false)
    addFeatureRow("Insta V1 / V2", "Commande locale à définir", false)
end

local function renderEsp()
    resetRows()
    label(content, "ESP", UDim2.fromOffset(14, 12), UDim2.new(1, -28, 0, 26), 18, COLORS.text).Font = Enum.Font.GothamBold
    label(content, "Prévisualisation des modules ESP, sans dessin ni suivi actif pour l’instant.", UDim2.fromOffset(14, 36), UDim2.new(1, -28, 0, 18), 10, COLORS.dim)
    addFeatureRow("Player ESP", "Module visuel à valider", false)
    addFeatureRow("Tracker", "Module visuel à valider", false)
    addFeatureRow("Anti Lag", "Réglage local à définir", false)
    addFeatureRow("Tool Aimbot", "Non activé dans la base sûre", false)
    addFeatureRow("Fonctions Steal", "Non activées dans la base sûre", false)
end

local settingsLocked = false
local function renderSettings()
    resetRows()
    label(content, "SETTINGS", UDim2.fromOffset(14, 12), UDim2.new(1, -28, 0, 26), 18, COLORS.text).Font = Enum.Font.GothamBold
    label(content, "Réglages de menu et affichage mobile.", UDim2.fromOffset(14, 36), UDim2.new(1, -28, 0, 18), 10, COLORS.dim)
    addFeatureRow("Mobile mode", "Compact · Standard · Large", true)
    addFeatureRow("Shape", "Box · Round · Square", true)
    addFeatureRow("Button size", "+ / − pour les boutons", true)
    addFeatureRow("Lock / Unlock", "Verrouiller la position du menu", true)
    addFeatureRow("Reset Mobile", "Restaurer les réglages visuels", true)
    addFeatureRow("Reset All", "Restaurer l’interface de base", true)
end

local function selectTab(name)
    activeTab = name
    for tabName, item in pairs(tabButtons) do
        item.BackgroundColor3 = tabName == name and COLORS.accent or COLORS.panel2
        item.TextColor3 = tabName == name and Color3.fromRGB(255, 255, 255) or COLORS.dim
    end
    if name == "PLAYER" then renderPlayer() elseif name == "ESP" then renderEsp() else renderSettings() end
end

for index, name in ipairs(tabs) do
    local tab = button(side, name, UDim2.fromOffset(12, 14 + (index - 1) * 48), UDim2.new(1, -24, 0, 36), COLORS.panel2)
    tab.TextSize = 11
    tabButtons[name] = tab
    tab.Activated:Connect(function() selectTab(name) end)
end

local footer = label(panel, "Base prête · les fonctions seront ajoutées après validation séparée", UDim2.fromOffset(18, 409), UDim2.new(1, -36, 0, 16), 10, COLORS.dim)

miniGui = Instance.new("ScreenGui")
miniGui.Name = MINI_NAME
miniGui.ResetOnSpawn = false
miniGui.IgnoreGuiInset = true
miniGui.Enabled = false
miniGui.Parent = playerGui
local mini = button(miniGui, "VIS", UDim2.new(1, -88, 1, -72), UDim2.fromOffset(68, 40), Color3.fromRGB(45, 23, 57))
mini.TextSize = 13
mini.Activated:Connect(function()
    miniGui.Enabled = false
    mainGui.Enabled = true
end)

local dragging = false
local dragStart
local panelStart
 top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if menuLocked then return end
        dragging = true
        dragStart = input.Position
        panelStart = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - dragStart
    panel.Position = UDim2.new(panelStart.X.Scale, panelStart.X.Offset + delta.X, panelStart.Y.Scale, panelStart.Y.Offset + delta.Y)
end)

close.Activated:Connect(function()
    if updateGui.Enabled then return end
    mainGui.Enabled = false
    miniGui.Enabled = true
end)

lockButton.Activated:Connect(function()
    menuLocked = not menuLocked
    lockButton.Text = menuLocked and "UNLOCK" or "LOCK"
    lockButton.BackgroundColor3 = menuLocked and Color3.fromRGB(35, 100, 62) or Color3.fromRGB(42, 31, 55)
    showNotice(menuLocked and "Menu verrouillé" or "Menu déverrouillé", menuLocked and "La position est maintenant fixe." or "Le menu peut à nouveau être déplacé.", menuLocked and COLORS.green or COLORS.yellow)
end)

local function refreshScale()
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
    local factor = math.min(viewport.X / 680, viewport.Y / 500)
    panelScale.Scale = math.clamp(factor, 0.72, 1)
    live.Text = viewport.X < 620 and "MOBILE · SAFE" or "LOCAL · STABLE"
end

selectTab("PLAYER")
refreshScale()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refreshScale)
end

task.spawn(function()
    task.wait(1)
    local lastHeartbeat = 0
    while playerGui.Parent and mainGui.Parent do
        syncWebsiteStatus()
        if os.clock() - lastHeartbeat >= 45 then
            sendHeartbeat()
            lastHeartbeat = os.clock()
        end
        task.wait(15)
    end
end)

print("[EL2B HUB] VIS menu safe loaded")
