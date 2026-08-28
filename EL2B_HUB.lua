--[=[
    EL2B HUB · VIS MENU SAFE EDITION
    Menu visuel à onglets inspiré de VIS HUB.
    Les actions de jeu seront ajoutées et validées séparément.
]=]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

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

local top = Instance.new("Frame")
top.BackgroundColor3 = COLORS.panel
 top.BorderSizePixel = 0
top.Position = UDim2.fromOffset(1, 1)
top.Size = UDim2.new(1, -2, 0, 64)
top.Parent = panel
corner(top, 15)
label(top, "VIS HUB", UDim2.fromOffset(20, 8), UDim2.new(1, -160, 0, 28), 23, COLORS.text).Font = Enum.Font.GothamBold
label(top, "EL2B SAFE MENU · READY", UDim2.fromOffset(21, 37), UDim2.new(1, -160, 0, 18), 10, COLORS.purple)
local close = button(top, "−", UDim2.new(1, -52, 0, 17), UDim2.fromOffset(34, 30), Color3.fromRGB(51, 25, 55))
close.TextSize = 20

local side = Instance.new("Frame")
side.BackgroundColor3 = COLORS.panel
side.BorderSizePixel = 0
side.Position = UDim2.fromOffset(14, 78)
side.Size = UDim2.fromOffset(142, 330)
side.Parent = panel
corner(side, 12)
stroke(side, Color3.fromRGB(78, 65, 95), 0.35)

local content = Instance.new("Frame")
content.BackgroundColor3 = COLORS.panel
content.BorderSizePixel = 0
content.Position = UDim2.fromOffset(170, 78)
content.Size = UDim2.new(1, -184, 1, -92)
content.Parent = panel
corner(content, 12)
stroke(content, Color3.fromRGB(78, 65, 95), 0.35)

local tabs = {"PLAYER", "ESP", "SETTINGS"}
local tabButtons = {}
local activeTab = "PLAYER"
local featureRows = {}

local function resetRows()
    for _, row in ipairs(featureRows) do row:Destroy() end
    featureRows = {}
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
    local state = button(row, enabledByDefault and "READY" or "SAFE PLACEHOLDER", UDim2.new(1, -132, 0, 8), UDim2.fromOffset(118, 27), enabledByDefault and Color3.fromRGB(35, 79, 56) or Color3.fromRGB(45, 39, 51))
    state.TextSize = 10
    state.TextColor3 = enabledByDefault and Color3.fromRGB(207, 255, 222) or COLORS.dim
    state.Activated:Connect(function()
        if enabledByDefault then
            state.Text = state.Text == "READY" and "LOCAL ON" or "READY"
        else
            state.Text = "À VALIDER"
        end
    end)
    table.insert(featureRows, row)
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

local miniGui = Instance.new("ScreenGui")
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
    mainGui.Enabled = false
    miniGui.Enabled = true
end)

selectTab("PLAYER")
print("[EL2B HUB] VIS menu safe loaded")
