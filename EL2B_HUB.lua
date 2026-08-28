--[=[
    EL2B HUB · GUI BASE SAFE EDITION
    Base visuelle prête pour recevoir des fonctions validées une par une.
    Cette version reste locale et visuelle, sans accès réseau,
    injection de code, automatisation de jeu ou déconnexion automatique.
]=]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
if not player then
    warn("[EL2B HUB] LocalPlayer indisponible / unavailable")
    return
end

local playerGui = player:WaitForChild("PlayerGui", 15)
if not playerGui then
    warn("[EL2B HUB] PlayerGui indisponible / unavailable")
    return
end

local MAIN_NAME = "EL2BHubBaseGui"
local MINI_NAME = "EL2BHubBaseMini"

local function destroyIfPresent(name)
    local old = playerGui:FindFirstChild(name)
    if old then
        old:Destroy()
    end
end

destroyIfPresent(MAIN_NAME)
destroyIfPresent(MINI_NAME)

local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function addStroke(parent, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Transparency = transparency or 0
    stroke.Thickness = 1
    stroke.Parent = parent
    return stroke
end

local function addLabel(parent, text, position, size, textSize, color)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = position
    label.Size = size
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = color
    label.TextSize = textSize
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local function addButton(parent, text, position, size)
    local button = Instance.new("TextButton")
    button.AutoButtonColor = true
    button.BackgroundColor3 = Color3.fromRGB(32, 25, 48)
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamSemibold
    button.Position = position
    button.Size = size
    button.Text = text
    button.TextColor3 = Color3.fromRGB(245, 226, 255)
    button.TextSize = 12
    button.Parent = parent
    addCorner(button, 8)
    addStroke(button, Color3.fromRGB(151, 76, 197), 0.45)
    return button
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
panel.Size = UDim2.fromOffset(350, 250)
panel.BackgroundColor3 = Color3.fromRGB(13, 12, 19)
panel.BorderSizePixel = 0
panel.Parent = mainGui
addCorner(panel, 16)
addStroke(panel, Color3.fromRGB(210, 74, 238), 0.25)

local header = Instance.new("Frame")
header.BackgroundColor3 = Color3.fromRGB(25, 19, 35)
header.BorderSizePixel = 0
header.Position = UDim2.fromOffset(1, 1)
header.Size = UDim2.new(1, -2, 0, 58)
header.Parent = panel
addCorner(header, 15)

addLabel(header, "EL2B HUB", UDim2.fromOffset(18, 8), UDim2.new(1, -72, 0, 24), 21, Color3.fromRGB(255, 255, 255)).Font = Enum.Font.GothamBold
addLabel(header, "GUI BASE · SAFE / READY", UDim2.fromOffset(19, 32), UDim2.new(1, -72, 0, 17), 10, Color3.fromRGB(206, 139, 238))

local closeButton = addButton(header, "−", UDim2.new(1, -48, 0, 13), UDim2.fromOffset(34, 30))
closeButton.TextSize = 20

local statusDot = Instance.new("Frame")
statusDot.BackgroundColor3 = Color3.fromRGB(75, 224, 133)
statusDot.BorderSizePixel = 0
statusDot.Position = UDim2.fromOffset(20, 82)
statusDot.Size = UDim2.fromOffset(8, 8)
statusDot.Parent = panel
addCorner(statusDot, 8)

addLabel(panel, "Interface démarrée / Interface started", UDim2.fromOffset(36, 73), UDim2.new(1, -56, 0, 24), 14, Color3.fromRGB(238, 231, 245))
addLabel(panel, "Cette base est prête. Les fonctions seront ajoutées après validation.", UDim2.fromOffset(20, 108), UDim2.new(1, -40, 0, 38), 12, Color3.fromRGB(166, 158, 181))
addLabel(panel, "This base is ready. Features will be added after validation.", UDim2.fromOffset(20, 145), UDim2.new(1, -40, 0, 28), 11, Color3.fromRGB(137, 129, 151))

local readyButton = addButton(panel, "BASE ACTIVE · READY", UDim2.fromOffset(20, 190), UDim2.new(1, -40, 0, 36))
readyButton.BackgroundColor3 = Color3.fromRGB(41, 91, 68)
readyButton.TextColor3 = Color3.fromRGB(210, 255, 225)
readyButton.Activated:Connect(function()
    readyButton.Text = "EN ATTENTE DES FONCTIONS · WAITING"
    task.delay(2, function()
        if readyButton.Parent then
            readyButton.Text = "BASE ACTIVE · READY"
        end
    end)
end)

local miniGui = Instance.new("ScreenGui")
miniGui.Name = MINI_NAME
miniGui.ResetOnSpawn = false
miniGui.IgnoreGuiInset = true
miniGui.Enabled = false
miniGui.Parent = playerGui

local miniButton = addButton(miniGui, "EL2B", UDim2.new(1, -88, 1, -74), UDim2.fromOffset(68, 42))
miniButton.BackgroundColor3 = Color3.fromRGB(29, 19, 42)
miniButton.TextSize = 13
miniButton.Activated:Connect(function()
    miniGui.Enabled = false
    mainGui.Enabled = true
    panel.Size = UDim2.fromOffset(330, 236)
    TweenService:Create(panel, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(350, 250)}):Play()
end)

local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end
    local delta = input.Position - dragStart
    panel.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
end)

closeButton.Activated:Connect(function()
    mainGui.Enabled = false
    miniGui.Enabled = true
end)

print("[EL2B HUB] GUI base safe loaded / GUI de base chargée")
