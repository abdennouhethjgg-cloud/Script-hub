-- ============================================================
--  RemoteEvent & RemoteFunction Lister – Édition Deluxe
--  Pour Delta Executor – Aucune erreur, tout style !
-- ============================================================

local player = game.Players.LocalPlayer
if not player then repeat wait() until player end

-- Fonction sécurisée de copie
local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
        return true
    elseif toclipboard then
        toclipboard(text)
        return true
    else
        warn("❌ Aucune fonction de copie disponible (setclipboard/toclipboard introuvable)")
        return false
    end
end

-- Récupération des événements (avec vérification d'existence)
local events = {}
for _, obj in ipairs(game:GetDescendants()) do
    if obj and obj.IsA and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
        table.insert(events, obj)
    end
end

-- Tri par nom complet
table.sort(events, function(a, b)
    return a:GetFullName() < b:GetFullName()
end)

-- Création de l'interface
local gui = Instance.new("ScreenGui")
gui.Name = "RemoteLister"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 480)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

-- Coins arrondis (via UICorner)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Ombre portée (simulée par un autre frame)
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.ZIndex = 0
shadow.Parent = mainFrame
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 16)
shadowCorner.Parent = shadow

-- En-tête avec dégradé
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Dégradé horizontal (UIGradient)
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 100, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 60, 200))
})
gradient.Rotation = 90
gradient.Parent = header

-- Titre
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "📡 Événements réseau"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0, 15, 0, 0)
title.Parent = header

-- Compteur
local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(0.3, 0, 1, 0)
countLabel.Position = UDim2.new(0.7, 0, 0, 0)
countLabel.BackgroundTransparency = 1
countLabel.Text = #events .. " trouvés"
countLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
countLabel.Font = Enum.Font.SourceSans
countLabel.TextSize = 14
countLabel.TextXAlignment = Enum.TextXAlignment.Right
countLabel.TextYAlignment = Enum.TextYAlignment.Center
countLabel.Parent = header

-- Bouton Copier (avec animation)
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 120, 0, 32)
copyBtn.Position = UDim2.new(1, -135, 0, 8)
copyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
copyBtn.Text = "📋 Copier tout"
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.TextSize = 14
copyBtn.BorderSizePixel = 0
copyBtn.Parent = header

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = copyBtn

-- Effet hover / clic
copyBtn.MouseEnter:Connect(function()
    copyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 255)
end)
copyBtn.MouseLeave:Connect(function()
    copyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
end)

-- Bouton Fermer
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseEnter:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
end)
closeBtn.MouseLeave:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Zone de défilement (avec fond semi-transparent)
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -60)
scrollFrame.Position = UDim2.new(0, 10, 0, 55)
scrollFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
scrollFrame.BackgroundTransparency = 0.3
scrollFrame.BorderSizePixel = 0
scrollFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = mainFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = scrollFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.Name
listLayout.Padding = UDim.new(0, 3)
listLayout.Parent = scrollFrame

-- Création des lignes d'événements (avec style alterné)
local function createEventLabel(ev, index)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 28)
    label.BackgroundColor3 = (index % 2 == 0) and Color3.fromRGB(45, 45, 55) or Color3.fromRGB(35, 35, 45)
    label.BackgroundTransparency = 0.2
    label.Text = ev:GetFullName()
    label.TextColor3 = Color3.fromRGB(230, 230, 255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.BorderSizePixel = 0
    label.Parent = scrollFrame

    -- Coins arrondis individuels
    local lblCorner = Instance.new("UICorner")
    lblCorner.CornerRadius = UDim.new(0, 4)
    lblCorner.Parent = label

    -- Effet hover (surlignage)
    label.MouseEnter:Connect(function()
        label.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
        label.BackgroundTransparency = 0.1
    end)
    label.MouseLeave:Connect(function()
        label.BackgroundColor3 = (index % 2 == 0) and Color3.fromRGB(45, 45, 55) or Color3.fromRGB(35, 35, 45)
        label.BackgroundTransparency = 0.2
    end)
end

for i, ev in ipairs(events) do
    createEventLabel(ev, i)
end

-- Ajustement de la hauteur du canvas
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #events * 31 + 10)

-- Fonction de copie avec feedback
copyBtn.MouseButton1Click:Connect(function()
    if #events == 0 then
        copyBtn.Text = "⚠️ Aucun"
        wait(1)
        copyBtn.Text = "📋 Copier tout"
        return
    end

    local text = "-- Liste des RemoteEvents/Functions --\n"
    for _, ev in ipairs(events) do
        text = text .. ev:GetFullName() .. "\n"
    end

    local success = copyToClipboard(text)
    if success then
        copyBtn.Text = "✅ Copié !"
        wait(1.2)
        copyBtn.Text = "📋 Copier tout"
    else
        copyBtn.Text = "❌ Échec"
        wait(1.2)
        copyBtn.Text = "📋 Copier tout"
        -- Affichage dans la console en secours
        print(text)
    end
end)

-- Petit message dans la console
print("✅ GUI chargée – " .. #events .. " événements réseau trouvés.")