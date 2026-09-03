-- EL2B ALL GEAR — version stable et sûre pour Roblox
-- VERSION: 1.0.0
-- Cette version est volontairement limitée à l’interface et aux informations visuelles.
-- Aucun RemoteEvent/RemoteFunction, téléportation, lagger, hook, commande admin,
-- anti-ragdoll, aimbot, quick pickup ou automatisation de gameplay n’est exécuté.

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
if not localPlayer then
    return
end

local playerGui = localPlayer:WaitForChild("PlayerGui")
local GUI_NAME = "EL2B_ALL_GEAR"
local CURRENT_VERSION = "1.0.0"
local VERSION_URL = "https://raw.githubusercontent.com/abdennouhethjgg-cloud/Script-hub/main/EL2B_VERSION.txt"
local SCRIPT_URL = "https://raw.githubusercontent.com/abdennouhethjgg-cloud/Script-hub/main/vis_hub_corrected.lua"
local oldGui = playerGui:FindFirstChild(GUI_NAME)
if oldGui then
    oldGui:Destroy()
end

local connections = {}
local destroyed = false

local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(connections, connection)
    return connection
end

local function make(className, properties, parent)
    local object = Instance.new(className)
    for property, value in pairs(properties) do
        object[property] = value
    end
    object.Parent = parent
    return object
end

local gui = make("ScreenGui", {
    Name = GUI_NAME,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 100,
}, playerGui)

local main = make("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(330, 425),
    BackgroundColor3 = Color3.fromRGB(18, 18, 25),
    BorderSizePixel = 0,
}, gui)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, main)
make("UIStroke", {
    Color = Color3.fromRGB(125, 85, 220),
    Thickness = 1.5,
    Transparency = 0.15,
}, main)

local header = make("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = Color3.fromRGB(28, 25, 40),
    BorderSizePixel = 0,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, header)
make("Frame", {
    Name = "HeaderFill",
    Position = UDim2.new(0, 0, 1, -10),
    Size = UDim2.new(1, 0, 0, 10),
    BackgroundColor3 = Color3.fromRGB(28, 25, 40),
    BorderSizePixel = 0,
}, header)

make("TextLabel", {
    Name = "Title",
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(16, 6),
    Size = UDim2.new(1, -62, 0, 23),
    Font = Enum.Font.GothamBold,
    Text = "EL2B ALL GEAR",
    TextColor3 = Color3.fromRGB(245, 240, 255),
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
}, header)

local closeButton = make("TextButton", {
    Name = "Close",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -10, 0.5, 0),
    Size = UDim2.fromOffset(28, 28),
    BackgroundColor3 = Color3.fromRGB(75, 45, 85),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "×",
    TextColor3 = Color3.fromRGB(255, 225, 255),
    TextSize = 20,
}, header)
make("UICorner", {CornerRadius = UDim.new(1, 0)}, closeButton)

make("TextLabel", {
    Name = "Subtitle",
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(16, 60),
    Size = UDim2.new(1, -32, 0, 22),
    Font = Enum.Font.Gotham,
    Text = "Mode stable — fonctions de gameplay désactivées",
    TextColor3 = Color3.fromRGB(190, 180, 205),
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
}, main)

local status = make("TextLabel", {
    Name = "Status",
    BackgroundColor3 = Color3.fromRGB(30, 65, 48),
    Position = UDim2.fromOffset(16, 92),
    Size = UDim2.new(1, -32, 0, 32),
    Font = Enum.Font.GothamMedium,
    Text = "● Interface active — aucun appel distant",
    TextColor3 = Color3.fromRGB(175, 255, 205),
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Center,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, status)

local playerCount = make("TextLabel", {
    Name = "PlayerCount",
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(16, 137),
    Size = UDim2.new(1, -32, 0, 24),
    Font = Enum.Font.GothamBold,
    TextColor3 = Color3.fromRGB(235, 230, 245),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
}, main)

local localProfileAvatar = make("ImageLabel", {
    Name = "LocalProfileAvatar",
    BackgroundColor3 = Color3.fromRGB(55, 38, 75),
    Position = UDim2.fromOffset(16, 163),
    Size = UDim2.fromOffset(44, 44),
    BorderSizePixel = 0,
    Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(localPlayer.UserId) .. "&w=150&h=150",
}, main)
make("UICorner", {CornerRadius = UDim.new(1, 0)}, localProfileAvatar)
local localProfileDetails = make("TextLabel", {
    Name = "SelectedProfileDetails",
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(70, 160),
    Size = UDim2.new(1, -86, 0, 52),
    Font = Enum.Font.GothamBold,
    Text = tostring(localPlayer.DisplayName or localPlayer.Name) .. "\n@" .. tostring(localPlayer.Name) .. "\nID: " .. tostring(localPlayer.UserId),
    TextColor3 = Color3.fromRGB(235, 230, 245),
    TextSize = 10,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
}, main)
local selectedPlayer
local function selectPlayerProfile(player)
    if not player or not player.Parent then return end
    selectedPlayer = player
    localProfileAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(player.UserId) .. "&w=150&h=150"
    localProfileDetails.Text = tostring(player.DisplayName or player.Name) .. "\n@" .. tostring(player.Name) .. "\nID: " .. tostring(player.UserId)
    status.Text = "● Profil sélectionné : @" .. tostring(player.Name)
end
local activeToast
local toastSerial = 0
local function showToast(message, success)
    if destroyed then return end
    toastSerial = toastSerial + 1
    local serial = toastSerial
    if activeToast then
        activeToast:Destroy()
        activeToast = nil
    end
    local toast = make("TextLabel", {
        Name = "CopyToast",
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -12),
        Size = UDim2.fromOffset(220, 32),
        BackgroundColor3 = success and Color3.fromRGB(35, 105, 65) or Color3.fromRGB(105, 35, 45),
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = tostring(message),
        TextColor3 = Color3.fromRGB(255, 245, 248),
        TextSize = 11,
        TextWrapped = true,
        ZIndex = 30,
    }, gui)
    activeToast = toast
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, toast)
    task.delay(2.5, function()
        if activeToast == toast and toastSerial == serial then
            activeToast = nil
            if toast.Parent then toast:Destroy() end
        end
    end)
end
local updateButton
local function checkForUpdate()
    local httpGet = game.HttpGet
    if type(httpGet) ~= "function" then
        return
    end
    local ok, remoteVersion = pcall(function()
        return game:HttpGet(VERSION_URL)
    end)
    if not ok or type(remoteVersion) ~= "string" then
        return
    end
    remoteVersion = remoteVersion:gsub("^%s+", ""):gsub("%s+$", "")
    if remoteVersion ~= "" and remoteVersion ~= CURRENT_VERSION then
        status.Text = "● Mise à jour disponible : v" .. remoteVersion
        updateButton.Text = "UPDATE AVAILABLE  •  v" .. remoteVersion
        showToast("Nouvelle GUI disponible : v" .. remoteVersion, true)
    else
        status.Text = "● GUI à jour : v" .. CURRENT_VERSION
        updateButton.Text = "CHECK UPDATE  •  v" .. CURRENT_VERSION
    end
end

local function copyToClipboard(value, label)
    local copied = false
    for _, clipboardFunction in ipairs({setclipboard, toclipboard, set_clipboard}) do
        if type(clipboardFunction) == "function" then
            copied = pcall(clipboardFunction, tostring(value))
            if copied then break end
        end
    end
    if copied then
        status.Text = "● " .. label .. " copié"
        showToast(label .. " copié", true)
    else
        status.Text = "● Copie indisponible : " .. label
        showToast("Copie indisponible : " .. label, false)
    end
end
updateButton = make("TextButton", {
    Name = "CheckUpdate",
    Position = UDim2.fromOffset(16, 133),
    Size = UDim2.new(1, -32, 0, 22),
    BackgroundColor3 = Color3.fromRGB(65, 35, 100),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "CHECK UPDATE  •  v" .. CURRENT_VERSION,
    TextColor3 = Color3.fromRGB(245, 235, 255),
    TextSize = 8,
    AutoButtonColor = false,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, updateButton)
connect(updateButton.Activated, checkForUpdate)

local copyUsernameButton = make("TextButton", {
    Name = "CopyUsername",
    Position = UDim2.fromOffset(70, 207),
    Size = UDim2.fromOffset(112, 22),
    BackgroundColor3 = Color3.fromRGB(125, 35, 55),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "COPY USERNAME",
    TextColor3 = Color3.fromRGB(255, 235, 240),
    TextSize = 8,
    AutoButtonColor = false,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, copyUsernameButton)
local copyIdButton = make("TextButton", {
    Name = "CopyUserId",
    Position = UDim2.fromOffset(188, 207),
    Size = UDim2.fromOffset(76, 22),
    BackgroundColor3 = Color3.fromRGB(125, 35, 55),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "COPY ID",
    TextColor3 = Color3.fromRGB(255, 235, 240),
    TextSize = 8,
    AutoButtonColor = false,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, copyIdButton)
copyUsernameButton.Activated:Connect(function()
    if selectedPlayer then copyToClipboard(selectedPlayer.Name, "Username") end
end)
copyIdButton.Activated:Connect(function()
    if selectedPlayer then copyToClipboard(selectedPlayer.UserId, "UserId") end
end)
local playerSearchBox = make("TextBox", {
    Name = "PlayerSearch",
    PlaceholderText = "Rechercher un joueur...",
    ClearTextOnFocus = false,
    Position = UDim2.fromOffset(16, 237),
    Size = UDim2.new(1, -32, 0, 24),
    BackgroundColor3 = Color3.fromRGB(30, 24, 40),
    BorderSizePixel = 0,
    Font = Enum.Font.Gotham,
    Text = "",
    TextColor3 = Color3.fromRGB(245, 240, 255),
    PlaceholderColor3 = Color3.fromRGB(160, 150, 175),
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 7)}, playerSearchBox)
local playerList = make("ScrollingFrame", {
    Name = "PlayerList",
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(16, 267),
    Size = UDim2.new(1, -32, 0, 84),
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Color3.fromRGB(125, 35, 55),
    CanvasSize = UDim2.fromOffset(0, 0),
}, main)

local function getFilteredPlayers()
    local players = Players:GetPlayers()
    local query = tostring(playerSearchBox.Text or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
    if query == "" then return players end
    local filtered = {}
    for _, player in ipairs(players) do
        local haystack = (tostring(player.DisplayName) .. " " .. tostring(player.Name) .. " " .. tostring(player.UserId)):lower()
        if string.find(haystack, query, 1, true) then table.insert(filtered, player) end
    end
    return filtered
end

local function refreshPlayers()
    if destroyed or not playerCount.Parent then
        return
    end
    local totalPlayers = #Players:GetPlayers()
    local players = getFilteredPlayers()
    playerCount.Text = string.format("Joueurs : %d/%d  •  Profil : @%s", #players, totalPlayers, tostring(localPlayer.Name))
    for _, child in ipairs(playerList:GetChildren()) do
        if child:GetAttribute("ServerPlayerCard") then
            child:Destroy()
        end
    end
    table.sort(players, function(a, b) return tostring(a.Name):lower() < tostring(b.Name):lower() end)
    for index, player in ipairs(players) do
        local card = make("Frame", {
            Name = "ServerPlayerCard",
            BackgroundColor3 = Color3.fromRGB(30, 24, 40),
            BorderSizePixel = 0,
            Size = UDim2.new(0.5, -6, 0, 44),
            Position = UDim2.new((index - 1) % 2 * 0.5, 4, 0, math.floor((index - 1) / 2) * 50 + 4),
        }, playerList)
        card:SetAttribute("ServerPlayerCard", true)
        make("UICorner", {CornerRadius = UDim.new(0, 7)}, card)
        local avatar = make("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(5, 5),
            Size = UDim2.fromOffset(34, 34),
            Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(player.UserId) .. "&w=150&h=150",
        }, card)
        make("UICorner", {CornerRadius = UDim.new(1, 0)}, avatar)
        make("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(44, 3),
            Size = UDim2.new(1, -84, 1, -6),
            Font = Enum.Font.GothamBold,
            Text = tostring(player.DisplayName or player.Name) .. "\n@" .. tostring(player.Name) .. "\nID: " .. tostring(player.UserId),
            TextColor3 = Color3.fromRGB(235, 230, 245),
            TextSize = 8,
            TextWrapped = true,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
        }, card)
        local viewButton = make("TextButton", {
            Name = "ViewProfile",
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -5, 0.5, 0),
            Size = UDim2.fromOffset(30, 30),
            BackgroundColor3 = Color3.fromRGB(125, 35, 55),
            BorderSizePixel = 0,
            Font = Enum.Font.GothamBold,
            Text = "VIEW",
            TextColor3 = Color3.fromRGB(255, 235, 240),
            TextSize = 7,
            AutoButtonColor = false,
        }, card)
        make("UICorner", {CornerRadius = UDim.new(1, 0)}, viewButton)
        viewButton.Activated:Connect(function() selectPlayerProfile(player) end)
    end
    playerList.CanvasSize = UDim2.fromOffset(0, math.max(0, math.ceil(#players / 2) * 50 + 4))
end

local function exportPlayers(format)
    local players = getFilteredPlayers()
    table.sort(players, function(a, b) return tostring(a.Name):lower() < tostring(b.Name):lower() end)
    local payload
    if format == "json" then
        local records = {}
        for _, player in ipairs(players) do
            table.insert(records, {
                DisplayName = tostring(player.DisplayName or player.Name),
                Username = tostring(player.Name),
                UserId = player.UserId,
            })
        end
        local ok, result = pcall(function() return HttpService:JSONEncode(records) end)
        payload = ok and result or nil
    else
        local lines = {"EL2B ALL GEAR - Liste des joueurs", ""}
        for _, player in ipairs(players) do
            table.insert(lines, string.format("%s (@%s) - UserId: %s", tostring(player.DisplayName or player.Name), tostring(player.Name), tostring(player.UserId)))
        end
        payload = table.concat(lines, "\n")
    end
    if payload then
        copyToClipboard(payload, format == "json" and "Export JSON" or "Export texte")
    else
        status.Text = "● Export JSON indisponible"
        showToast("Export JSON indisponible", false)
    end
end

local randomPlayerButton = make("TextButton", {
    Name = "RandomPlayer",
    Position = UDim2.fromOffset(16, 356),
    Size = UDim2.new(1, -32, 0, 22),
    BackgroundColor3 = Color3.fromRGB(125, 35, 55),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "RANDOM PLAYER",
    TextColor3 = Color3.fromRGB(255, 235, 240),
    TextSize = 8,
    AutoButtonColor = false,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, randomPlayerButton)
connect(randomPlayerButton.Activated, function()
    local players = getFilteredPlayers()
    if #players == 0 then
        status.Text = "● Aucun joueur trouvé"
        showToast("Aucun joueur trouvé", false)
        return
    end
    local chosen = players[math.random(1, #players)]
    selectPlayerProfile(chosen)
    showToast("Joueur choisi : @" .. tostring(chosen.Name), true)
end)

local exportJsonButton = make("TextButton", {
    Name = "ExportPlayersJson",
    Position = UDim2.fromOffset(16, 386),
    Size = UDim2.fromOffset(142, 22),
    BackgroundColor3 = Color3.fromRGB(95, 30, 52),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "EXPORT JSON",
    TextColor3 = Color3.fromRGB(255, 235, 240),
    TextSize = 8,
    AutoButtonColor = false,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, exportJsonButton)
local exportTextButton = make("TextButton", {
    Name = "ExportPlayersText",
    Position = UDim2.fromOffset(172, 386),
    Size = UDim2.fromOffset(142, 22),
    BackgroundColor3 = Color3.fromRGB(95, 30, 52),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "EXPORT TEXTE",
    TextColor3 = Color3.fromRGB(255, 235, 240),
    TextSize = 8,
    AutoButtonColor = false,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, exportTextButton)
connect(exportJsonButton.Activated, function() exportPlayers("json") end)
connect(exportTextButton.Activated, function() exportPlayers("text") end)
connect(playerSearchBox:GetPropertyChangedSignal("Text"), refreshPlayers)
task.delay(1.5, checkForUpdate)

local activeJoinNotification
local notificationSerial = 0
local function notifyPlayerJoined(player)
    if destroyed or not player or player == localPlayer then
        return
    end
    notificationSerial = notificationSerial + 1
    local serial = notificationSerial
    if activeJoinNotification then
        activeJoinNotification:Destroy()
        activeJoinNotification = nil
    end
    local notice = make("Frame", {
        Name = "PlayerJoinedNotification",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -12, 0, 12),
        Size = UDim2.fromOffset(224, 54),
        BackgroundColor3 = Color3.fromRGB(28, 25, 40),
        BorderSizePixel = 0,
        ZIndex = 20,
    }, gui)
    activeJoinNotification = notice
    make("UICorner", {CornerRadius = UDim.new(0, 9)}, notice)
    make("UIStroke", {Color = Color3.fromRGB(125, 85, 220), Thickness = 1.4}, notice)
    local avatar = make("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(7, 7),
        Size = UDim2.fromOffset(40, 40),
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(player.UserId) .. "&w=150&h=150",
        ZIndex = 21,
    }, notice)
    make("UICorner", {CornerRadius = UDim.new(1, 0)}, avatar)
    make("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(54, 5),
        Size = UDim2.new(1, -60, 1, -10),
        Font = Enum.Font.GothamBold,
        Text = "NOUVEAU JOUEUR\n" .. tostring(player.DisplayName or player.Name) .. " (@" .. tostring(player.Name) .. ")",
        TextColor3 = Color3.fromRGB(245, 240, 255),
        TextSize = 10,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 21,
    }, notice)
    task.delay(4, function()
        if activeJoinNotification == notice and notificationSerial == serial then
            activeJoinNotification = nil
            if notice.Parent then notice:Destroy() end
        end
    end)
end
local dragging = false
local dragStart
local startPosition
connect(header.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)
connect(UserInputService.InputChanged, function(input)
    if not dragging then
        return
    end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end
    local delta = input.Position - dragStart
    main.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
end)
connect(UserInputService.InputEnded, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

connect(closeButton.Activated, function()
    destroyed = true
    for _, connection in ipairs(connections) do
        if connection.Connected then
            connection:Disconnect()
        end
    end
    gui:Destroy()
end)

connect(Players.PlayerAdded, function(player)
    refreshPlayers()
    notifyPlayerJoined(player)
end)
connect(Players.PlayerRemoving, refreshPlayers)
task.spawn(function()
    while not destroyed and gui.Parent do
        refreshPlayers()
        task.wait(2)
    end
end)

refreshPlayers()
