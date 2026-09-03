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
    Size = UDim2.fromOffset(330, 245),
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
local playerList = make("TextLabel", {
    Name = "PlayerList",
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(70, 160),
    Size = UDim2.new(1, -86, 0, 66),
    Font = Enum.Font.Gotham,
    TextColor3 = Color3.fromRGB(185, 180, 195),
    TextSize = 12,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
}, main)

local function refreshPlayers()
    if destroyed or not playerCount.Parent then
        return
    end
    local players = Players:GetPlayers()
    playerCount.Text = string.format("Joueurs : %d  •  Profil : @%s", #players, tostring(localPlayer.Name))
    local names = {}
    for index, player in ipairs(players) do
        if index > 5 then
            table.insert(names, "…")
            break
        end
        table.insert(names, tostring(player.DisplayName or player.Name) .. " (@" .. tostring(player.Name) .. ")")
    end
    playerList.Text = table.concat(names, "  •  ")
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

connect(Players.PlayerAdded, refreshPlayers)
connect(Players.PlayerRemoving, refreshPlayers)
task.spawn(function()
    while not destroyed and gui.Parent do
        refreshPlayers()
        task.wait(2)
    end
end)

refreshPlayers()
