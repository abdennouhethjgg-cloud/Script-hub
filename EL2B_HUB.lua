-- ======================================================
--  Auto-Digging GUI - Steal a Brainrot
--  Compatible Delta Executor
--  Remotes: RE/EventService/Digging/Dig + RE/UseItem
-- ======================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Référence aux remotes
local Net       = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
local DigRemote = Net:WaitForChild("RE/EventService/Digging/Dig")
local UseItem   = Net:WaitForChild("RE/UseItem")

-- Config
local DIG_DELAY  = 0.15   -- secondes entre chaque coup (0.15 = rapide mais safe)
local DIG_OFFSET = Vector3.new(0, -3, 0) -- point de frappe (au sol devant le joueur)

_G.AutoDigging = false

-- ======================================================
--  INTERFACE GRAPHIQUE
-- ======================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoDig_GUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 150)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(90, 90, 120)
stroke.Thickness = 1
stroke.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 32)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
title.BorderSizePixel = 0
title.Text = "⚒ Auto Digging"
title.TextColor3 = Color3.fromRGB(220, 220, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.85, 0, 0, 42)
toggleBtn.Position = UDim2.new(0.075, 0, 0, 45)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "DÉSACTIVÉ"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 14
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = mainFrame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 1, -42)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Prêt"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

local hitsLabel = Instance.new("TextLabel")
hitsLabel.Size = UDim2.new(1, 0, 0, 20)
hitsLabel.Position = UDim2.new(0, 0, 1, -22)
hitsLabel.BackgroundTransparency = 1
hitsLabel.Text = "Coups: 0"
hitsLabel.TextColor3 = Color3.fromRGB(120, 200, 150)
hitsLabel.TextSize = 12
hitsLabel.Font = Enum.Font.Gotham
hitsLabel.Parent = mainFrame

-- ======================================================
--  FONCTION AUTO-DIG
-- ======================================================

local hitCount = 0

local function getPickaxe()
    local char = player.Character
    if not char then return nil end
    local bp = player:FindFirstChild("Backpack")

    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") then return t end
    end
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                t.Parent = char
                return t
            end
        end
    end
    return nil
end

-- Boucle d'auto-dig
task.spawn(function()
    while true do
        task.wait(DIG_DELAY)
        if not _G.AutoDigging then continue end

        local char = player.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            statusLabel.Text = "Personnage introuvable"
            continue
        end

        -- Équiper la pioche si besoin
        getPickaxe()

        -- Position de frappe (au sol devant le joueur)
        local hitPos = hrp.Position + DIG_OFFSET

        -- Appel des deux remotes
        pcall(function()
            UseItem:FireServer()
            DigRemote:FireServer(hitPos)
        end)

        hitCount = hitCount + 1
        hitsLabel.Text = "Coups: " .. hitCount
    end
end)

-- ======================================================
--  BOUTON & RACCOURCI
-- ======================================================

local function updateButton()
    if _G.AutoDigging then
        toggleBtn.Text = "ACTIVÉ"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 170, 65)
        statusLabel.Text = "Auto-Dig en cours..."
        statusLabel.TextColor3 = Color3.fromRGB(120, 220, 140)
    else
        toggleBtn.Text = "DÉSACTIVÉ"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusLabel.Text = "Prêt"
        statusLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    _G.AutoDigging = not _G.AutoDigging
    updateButton()
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.R then
        _G.AutoDigging = not _G.AutoDigging
        updateButton()
    end
end)

updateButton()
print("[Auto-Dig] GUI chargée — Touche R ou bouton pour activer.")
