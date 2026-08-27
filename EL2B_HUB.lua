--[[
    VIS HUB - Minimal Stable Edition
    Base compatible : aucune requête HTTP, aucun hook d'exécuteur,
    aucun RemoteEvent, aucune écriture fichier et aucune boucle lourde.
]]

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui", 30) or game:GetService("CoreGui")

local old = PlayerGui:FindFirstChild("VisHubMinimal")
if old then old:Destroy() end

local COLORS = {
    background = Color3.fromRGB(13, 13, 19),
    panel = Color3.fromRGB(23, 23, 32),
    button = Color3.fromRGB(34, 34, 48),
    accent = Color3.fromRGB(255, 32, 150),
    text = Color3.fromRGB(255, 255, 255),
    muted = Color3.fromRGB(170, 170, 190),
    success = Color3.fromRGB(70, 220, 125),
}

local function make(className, properties, parent)
    local object = Instance.new(className)
    for key, value in pairs(properties) do
        object[key] = value
    end
    object.Parent = parent
    return object
end

local gui = make("ScreenGui", {
    Name = "VisHubMinimal",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 100000,
}, PlayerGui)

local main = make("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(370, 300),
    BackgroundColor3 = COLORS.background,
    BorderSizePixel = 1,
    BorderColor3 = COLORS.accent,
}, gui)
make("UICorner", { CornerRadius = UDim.new(0, 12) }, main)

local titleBar = make("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = COLORS.panel,
    BorderSizePixel = 0,
}, main)

make("TextLabel", {
    Name = "Title",
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(16, 7),
    Size = UDim2.new(1, -70, 0, 20),
    Font = Enum.Font.GothamBold,
    Text = "VIS HUB",
    TextColor3 = COLORS.text,
    TextSize = 17,
    TextXAlignment = Enum.TextXAlignment.Left,
}, titleBar)

make("TextLabel", {
    Name = "Subtitle",
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(17, 27),
    Size = UDim2.new(1, -70, 0, 15),
    Font = Enum.Font.Gotham,
    Text = "Minimal stable edition / Version stable",
    TextColor3 = COLORS.muted,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
}, titleBar)

local close = make("TextButton", {
    Name = "Close",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -12, 0.5, 0),
    Size = UDim2.fromOffset(28, 28),
    BackgroundColor3 = COLORS.button,
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "×",
    TextColor3 = COLORS.text,
    TextSize = 18,
}, titleBar)
make("UICorner", { CornerRadius = UDim.new(1, 0) }, close)

local tabs = make("Frame", {
    Name = "Tabs",
    Position = UDim2.fromOffset(12, 60),
    Size = UDim2.new(1, -24, 0, 34),
    BackgroundTransparency = 1,
}, main)

local content = make("Frame", {
    Name = "Content",
    Position = UDim2.fromOffset(12, 104),
    Size = UDim2.new(1, -24, 1, -116),
    BackgroundColor3 = COLORS.panel,
    BorderSizePixel = 0,
}, main)
make("UICorner", { CornerRadius = UDim.new(0, 9) }, content)

local pages = {}
local tabButtons = {}
local function createPage(name)
    local page = make("Frame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false,
    }, content)
    pages[name] = page
    return page
end

local function createTab(name, index)
    local button = make("TextButton", {
        Name = name .. "Tab",
        Position = UDim2.new((index - 1) / 3, 0, 0, 0),
        Size = UDim2.new(1 / 3, -6, 1, 0),
        BackgroundColor3 = COLORS.button,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = name,
        TextColor3 = COLORS.muted,
        TextSize = 11,
    }, tabs)
    make("UICorner", { CornerRadius = UDim.new(0, 7) }, button)
    tabButtons[name] = button
    return button
end

local playerPage = createPage("Player")
local espPage = createPage("ESP")
local settingsPage = createPage("Settings")

local function addText(parent, text, y, color, size)
    return make("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(16, y),
        Size = UDim2.new(1, -32, 0, 26),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = color or COLORS.text,
        TextSize = size or 13,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, parent)
end

addText(playerPage, "Player / Joueur", 15, COLORS.accent, 15)
addText(playerPage, "GUI chargée avec succès.", 50, COLORS.success, 13)
addText(playerPage, "Aucune fonction externe active dans cette version stable.", 82, COLORS.muted, 12)
addText(playerPage, "Nom : " .. tostring(LP.DisplayName or LP.Name), 120, COLORS.text, 12)

addText(espPage, "ESP / Affichage", 15, COLORS.accent, 15)
addText(espPage, "Version minimale prête à recevoir des modules sûrs.", 50, COLORS.success, 13)
addText(espPage, "Les hooks et appels RemoteEvent ont été retirés.", 82, COLORS.muted, 12)

addText(settingsPage, "Settings / Paramètres", 15, COLORS.accent, 15)
addText(settingsPage, "Cette base privilégie la compatibilité et la visibilité.", 50, COLORS.text, 12)
addText(settingsPage, "Ferme la fenêtre avec ×. Relance le script pour la recréer.", 82, COLORS.muted, 12)

local function showPage(name)
    for pageName, page in pairs(pages) do
        page.Visible = pageName == name
    end
    for tabName, button in pairs(tabButtons) do
        button.BackgroundColor3 = tabName == name and COLORS.accent or COLORS.button
        button.TextColor3 = tabName == name and COLORS.text or COLORS.muted
    end
end

for name, button in pairs(tabButtons) do
    button.Activated:Connect(function() showPage(name) end)
end
showPage("Player")

close.Activated:Connect(function() gui:Destroy() end)

local dragging = false
local dragStart
local startPosition
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        UIS.InputChanged:Connect(function(changed)
            if dragging and changed == input then
                local delta = changed.Position - dragStart
                main.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
            end
        end)
    end
end)

print("[VIS HUB] Minimal stable GUI loaded")
