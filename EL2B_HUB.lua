-- ======================================================
--  Auto-Digging + Anti-Kick - Steal a Brainrot
--  Compatible Delta Executor
--  Remotes: RE/EventService/Digging/Dig + RE/UseItem
-- ======================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ======================================================
--  1. ANTI-KICK (Hook de la métaméthode __namecall)
-- ======================================================
-- Cette section intercepte les appels à `Kick` et les bloque.
-- Note : Un anti-kick ne peut pas bloquer un kick décidé côté serveur,
-- mais il empêche l'exécution locale de la fonction Kick.

local antiKickEnabled = true
local oldNamecall

local function setupAntiKick()
    local success, err = pcall(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        oldNamecall = mt.__namecall
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            
            -- Bloquer les kicks
            if antiKickEnabled and (method == "Kick" or tostring(method):lower() == "kick") then
                warn("[Anti-Kick] Tentative de kick interceptée :", self, ...)
                return nil -- On bloque l'appel
            end
            
            return oldNamecall(self, ...)
        end)
    end)
    
    if not success then
        warn("[Anti-Kick] Impossible d'installer le hook :", err)
    end
end

setupAntiKick()

-- Fonction pour désactiver/réactiver l'anti-kick si besoin
local function toggleAntiKick(state)
    antiKickEnabled = state
    print("[Anti-Kick] État :", state and "Activé" or "Désactivé")
end

-- ======================================================
--  2. RÉFÉRENCE AUX REMOTES (avec gestion d'erreur)
-- ======================================================

local Net, DigRemote, UseItem

local function initRemotes()
    local success, err = pcall(function()
        local packages = ReplicatedStorage:WaitForChild("Packages", 10)
        if not packages then error("Packages introuvable") end
        
        Net = packages:WaitForChild("Net", 10)
        if not Net then error("Net introuvable") end
        
        DigRemote = Net:WaitForChild("RE/EventService/Digging/Dig", 10)
        UseItem   = Net:WaitForChild("RE/UseItem", 10)
        
        if not DigRemote then error("DigRemote introuvable") end
        if not UseItem then error("UseItem introuvable") end
    end)
    
    if not success then
        warn("[Init] Erreur lors de la récupération des remotes :", err)
        return false
    end
    return true
end

local remotesReady = initRemotes()

-- ======================================================
--  3. CONFIGURATION
-- ======================================================

local CONFIG = {
    DIG_DELAY       = 0.25,   -- Intervalle entre les coups (secondes). Augmenter si kick.
    DIG_OFFSET      = Vector3.new(0, -3, 0),
    ANTI_KICK       = true,
    AUTO_RECONNECT  = true,
    MAX_ERRORS      = 5,      -- Nombre d'erreurs consécutives avant pause
    RECONNECT_DELAY = 5,      -- Secondes avant de tenter de se reconnecter
}

_G.AutoDigging = false
local hitCount = 0
local errorCount = 0

-- ======================================================
--  4. INTERFACE GRAPHIQUE
-- ======================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoDig_GUI_Pro"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 180)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
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
title.Text = "⚒ Auto Digging Pro"
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

local antiKickLabel = Instance.new("TextLabel")
antiKickLabel.Size = UDim2.new(1, 0, 0, 18)
antiKickLabel.Position = UDim2.new(0, 0, 1, -15)
antiKickLabel.BackgroundTransparency = 1
antiKickLabel.Text = "Anti-Kick: " .. (antiKickEnabled and "ON" or "OFF")
antiKickLabel.TextColor3 = antiKickEnabled and Color3.fromRGB(100, 220, 120) or Color3.fromRGB(200, 100, 100)
antiKickLabel.TextSize = 11
antiKickLabel.Font = Enum.Font.Gotham
antiKickLabel.Parent = mainFrame

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
                local success = pcall(function() t.Parent = char end)
                if success then return t end
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
--  6. BOUCLE D'AUTO-DIG (avec gestion d'erreurs)
-- ======================================================

task.spawn(function()
    while true do
        task.wait(CONFIG.DIG_DELAY)
        
        if not _G.AutoDigging then
            errorCount = 0
            continue
        end
        
        if not remotesReady then
            updateStatus("Remotes indisponibles", true)
            task.wait(2)
            remotesReady = initRemotes()
            continue
        end
        
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if not hrp then
            updateStatus("Personnage introuvable", true)
            continue
        end
        
        -- Équiper la pioche
        getPickaxe()
        
        local hitPos = hrp.Position + CONFIG.DIG_OFFSET
        
        -- Appel sécurisé des remotes
        local success, err = pcall(function()
            UseItem:FireServer()
            DigRemote:FireServer(hitPos)
        end)
        
        if success then
            hitCount = hitCount + 1
            errorCount = 0
            hitsLabel.Text = string.format("Coups: %d | Erreurs: %d", hitCount, errorCount)
        else
            errorCount = errorCount + 1
            hitsLabel.Text = string.format("Coups: %d | Erreurs: %d", hitCount, errorCount)
            warn("[Auto-Dig] Erreur d'appel remote :", err)
            
            if errorCount >= CONFIG.MAX_ERRORS then
                updateStatus("Trop d'erreurs, pause de 3s...", true)
                task.wait(3)
                errorCount = 0
                remotesReady = initRemotes() -- Retenter d'initialiser
            end
        end
    end
end)

-- ======================================================
--  7. BOUTON & RACCOURCI
-- ======================================================

local function updateButton()
    if _G.AutoDigging then
        toggleBtn.Text = "ACTIVÉ"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 170, 65)
        updateStatus("Auto-Dig en cours...", false)
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

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.R then
        _G.AutoDigging = not _G.AutoDigging
        updateButton()
    end
end)

updateButton()
print("[Auto-Dig Pro] GUI chargée. Anti-Kick:", antiKickEnabled and "ON" or "OFF")
