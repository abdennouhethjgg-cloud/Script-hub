-- ======================================================
--  STEAL A BRAINROT - AUTO DIG (ULTRA SAFE VERSION)
--  Compatible : Delta Executor
--  Remotes : Dig, Carve, SpawnFacing, DropPiece, UseItem
-- ======================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ======================================================
--  1. ANTI-KICK (Bypass local)
-- ======================================================
local antiKickEnabled = true
local oldNamecall

local function setupAntiKick()
    local success, err = pcall(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        oldNamecall = mt.__namecall
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            -- Bloquer les kicks locaux
            if antiKickEnabled and (method == "Kick" or tostring(method):lower() == "kick") then
                warn("[Anti-Kick] Tentative de kick bloquée !")
                return nil
            end
            return oldNamecall(self, ...)
        end)
    end)
    if not success then warn("[Anti-Kick] Erreur d'installation :", err) end
end

setupAntiKick()

-- ======================================================
--  2. RÉCUPÉRATION SÉCURISÉE DES REMOTES
-- ======================================================
local remotes = {}
local remotesReady = false

local function initRemotes()
    local success, err = pcall(function()
        local Net = ReplicatedStorage:WaitForChild("Packages", 10):WaitForChild("Net", 10)
        
        -- RE (RemoteEvents) -> FireServer
        remotes.Dig         = Net:WaitForChild("RE/EventService/Digging/Dig", 10)
        remotes.Carve       = Net:WaitForChild("RE/EventService/Digging/Carve", 10)
        remotes.SpawnFacing = Net:WaitForChild("RE/EventService/Digging/SpawnFacing", 10)
        remotes.UseItem     = Net:WaitForChild("RE/UseItem", 10)
        
        -- RF (RemoteFunction) -> InvokeServer (TRÈS IMPORTANT)
        remotes.DropPiece   = Net:WaitForChild("RF/EventService/Digging/DropPiece", 10)
    end)
    
    if success then
        remotesReady = true
        return true
    else
        warn("[Init] Erreur lors de la récupération des remotes :", err)
        remotesReady = false
        return false
    end
end

initRemotes()

-- ======================================================
--  3. CONFIGURATION
-- ======================================================
local CONFIG = {
    DIG_DELAY  = 0.5, -- Délai entre chaque coup (0.5 = safe, 0.3 = risqué)
    DIG_OFFSET = Vector3.new(0, -3, 0) -- Point de frappe au sol
}

_G.AutoDigging = false
local hitCount = 0
local errorCount = 0
local maxErrors = 5

-- ======================================================
--  4. CRÉATION DE L'INTERFACE (GUI)
-- ======================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoDig_GUI_Pro"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 160)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(90, 90, 120)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 32)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
title.BorderSizePixel = 0
title.Text = "⚒ Auto Digging Safe"
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
statusLabel.Position = UDim2.new(0, 0, 1, -55)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Prêt"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

local hitsLabel = Instance.new("TextLabel")
hitsLabel.Size = UDim2.new(1, 0, 0, 20)
hitsLabel.Position = UDim2.new(0, 0, 1, -35)
hitsLabel.BackgroundTransparency = 1
hitsLabel.Text = "Coups: 0 | Erreurs: 0"
hitsLabel.TextColor3 = Color3.fromRGB(120, 200, 150)
hitsLabel.TextSize = 12
hitsLabel.Font = Enum.Font.Gotham
hitsLabel.Parent = mainFrame

-- ======================================================
--  5. FONCTIONS UTILITAIRES
-- ======================================================
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
                pcall(function() t.Parent = char end)
                return t
            end
        end
    end
    return nil
end

local function updateStatus(msg, isError)
    statusLabel.Text = msg
    statusLabel.TextColor3 = isError and Color3.fromRGB(220, 100, 100) or Color3.fromRGB(150, 150, 170)
end

-- ======================================================
--  6. BOUCLE D'AUTO-DIG (SÉCURISÉE)
-- ======================================================
task.spawn(function()
    while true do
        task.wait(CONFIG.DIG_DELAY)
        
        if not _G.AutoDigging then
            errorCount = 0
            continue
        end
        
        if not remotesReady then
            updateStatus("Reconnexion aux remotes...", true)
            initRemotes()
            continue
        end
        
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if not hrp then
            updateStatus("Personnage introuvable", true)
            continue
        end
        
        -- Équiper l'outil
        getPickaxe()
        
        local targetPos = hrp.Position + CONFIG.DIG_OFFSET
        
        -- Exécution sécurisée (pcall)
        local success, err = pcall(function()
            -- 1. Utiliser l'item (si nécessaire)
            remotes.UseItem:FireServer()
            
            -- 2. Frapper
            remotes.Dig:FireServer(targetPos)
            
            -- 3. Creuser le terrain
            remotes.Carve:FireServer(targetPos)
            
            -- 4. Orientation
            remotes.SpawnFacing:FireServer(targetPos)
            
            -- 5. Récupérer la pièce (C'EST UN RF ! On utilise InvokeServer)
            remotes.DropPiece:InvokeServer()
        end)
        
        if success then
            hitCount = hitCount + 1
            errorCount = 0
            hitsLabel.Text = string.format("Coups: %d | Erreurs: %d", hitCount, errorCount)
        else
            errorCount = errorCount + 1
            hitsLabel.Text = string.format("Coups: %d | Erreurs: %d", hitCount, errorCount)
            warn("[Auto-Dig] Erreur remote :", err)
            
            -- Si trop d'erreurs consécutives, on met en pause pour éviter le kick
            if errorCount >= maxErrors then
                updateStatus("Trop d'erreurs ! Pause de 3s...", true)
                task.wait(3)
                errorCount = 0
                initRemotes() -- On réinitialise les remotes au cas où
            end
        end
    end
end)

-- ======================================================
--  7. GESTION DU BOUTON
-- ======================================================
local function updateButton()
    if _G.AutoDigging then
        toggleBtn.Text = "ACTIVÉ"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 170, 65)
        updateStatus("Minage en cours...", false)
    else
        toggleBtn.Text = "DÉSACTIVÉ"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        updateStatus("Prêt", false)
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    _G.AutoDigging = not _G.AutoDigging
    updateButton()
end)

-- Raccourci clavier (Touche R)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.R then
        _G.AutoDigging = not _G.AutoDigging
        updateButton()
    end
end)

updateButton()
print("[Auto-Dig] Script chargé avec succès !")
