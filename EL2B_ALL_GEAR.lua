-- EL2B ALL GEAR — version stable et sûre pour Roblox
-- Cette version est volontairement limitée à l’interface et aux informations visuelles.
-- Aucun RemoteEvent/RemoteFunction, téléportation, lagger, hook, commande admin,
-- anti-ragdoll, aimbot, quick pickup ou automatisation de gameplay n’est exécuté.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
if not localPlayer then
    return
end

local playerGui = localPlayer:WaitForChild("PlayerGui")
local GUI_NAME = "EL2B_ALL_GEAR"
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
    Size = UDim2.fromOffset(330, 330),
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
local playerList = make("ScrollingFrame", {
    Name = "PlayerList",
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(16, 215),
    Size = UDim2.new(1, -32, 0, 98),
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Color3.fromRGB(125, 35, 55),
    CanvasSize = UDim2.fromOffset(0, 0),
}, main)

local function refreshPlayers()
    if destroyed or not playerCount.Parent then
        return
    end
    local players = Players:GetPlayers()
    playerCount.Text = string.format("Joueurs : %d  •  Profil : @%s", #players, tostring(localPlayer.Name))
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
            Size = UDim2.new(1, -48, 1, -6),
            Font = Enum.Font.GothamBold,
            Text = tostring(player.DisplayName or player.Name) .. "\n@" .. tostring(player.Name) .. "\nID: " .. tostring(player.UserId),
            TextColor3 = Color3.fromRGB(235, 230, 245),
            TextSize = 8,
            TextWrapped = true,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
        }, card)
    end
    playerList.CanvasSize = UDim2.fromOffset(0, math.max(0, math.ceil(#players / 2) * 50 + 4))
end

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
