-- StealAnEgg_GUI.lua
-- Interface locale, légère et non invasive pour Steal an Egg.
-- Aucun auto-farm, aucune collecte automatique et aucun appel distant.

local Players = game:GetService("Players")
local player = Players.LocalPlayer

if not player then
    warn("[Steal an Egg GUI] LocalPlayer introuvable. Lance le script après être entré dans le jeu.")
    return
end

local playerGui = player:FindFirstChildOfClass("PlayerGui")
if not playerGui then
    local ok, result = pcall(function()
        return player:WaitForChild("PlayerGui", 10)
    end)
    if ok then
        playerGui = result
    end
end

if not playerGui then
    warn("[Steal an Egg GUI] PlayerGui introuvable.")
    return
end

local oldGui = playerGui:FindFirstChild("StealAnEggGUI")
if oldGui then
    oldGui:Destroy()
end

local function rounded(parent, radius)
    local item = Instance.new("UICorner")
    item.CornerRadius = UDim.new(0, radius)
    item.Parent = parent
    return item
end

local gui = Instance.new("ScreenGui")
gui.Name = "StealAnEggGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 20
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Fenetre"
main.Size = UDim2.fromOffset(280, 155)
main.Position = UDim2.new(0.5, -140, 0.5, -77)
main.BackgroundColor3 = Color3.fromRGB(39, 31, 25)
main.BorderSizePixel = 0
main.Parent = gui
rounded(main, 10)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(190, 135, 55)
stroke.Thickness = 1
stroke.Parent = main

local title = Instance.new("TextLabel")
title.Name = "Titre"
title.Size = UDim2.new(1, -52, 0, 38)
title.Position = UDim2.fromOffset(14, 4)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Steal an Egg"
title.TextColor3 = Color3.fromRGB(255, 229, 164)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local close = Instance.new("TextButton")
close.Name = "Fermer"
close.Size = UDim2.fromOffset(32, 28)
close.Position = UDim2.new(1, -40, 0, 9)
close.BackgroundColor3 = Color3.fromRGB(180, 65, 55)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.TextSize = 14
close.Font = Enum.Font.GothamBold
close.AutoButtonColor = true
close.Parent = main
rounded(close, 7)

local status = Instance.new("TextLabel")
status.Name = "Statut"
status.Size = UDim2.new(1, -28, 0, 28)
status.Position = UDim2.fromOffset(14, 48)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.Text = "Statut : interface active"
status.TextColor3 = Color3.fromRGB(180, 230, 175)
status.TextSize = 14
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

local info = Instance.new("TextLabel")
info.Name = "InfoJeu"
info.Size = UDim2.new(1, -28, 0, 22)
info.Position = UDim2.fromOffset(14, 74)
info.BackgroundTransparency = 1
info.Font = Enum.Font.Gotham
info.Text = "Jeu : " .. tostring(game.Name)
info.TextColor3 = Color3.fromRGB(220, 205, 180)
info.TextSize = 12
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextTruncate = Enum.TextTruncate.AtEnd
info.Parent = main

local hide = Instance.new("TextButton")
hide.Name = "Masquer"
hide.Size = UDim2.new(1, -28, 0, 38)
hide.Position = UDim2.fromOffset(14, 106)
hide.BackgroundColor3 = Color3.fromRGB(145, 95, 40)
hide.Text = "Masquer la fenêtre"
hide.TextColor3 = Color3.fromRGB(255, 255, 255)
hide.TextSize = 14
hide.Font = Enum.Font.GothamSemibold
hide.AutoButtonColor = true
hide.Parent = main
rounded(hide, 7)

local reopen
local function showReopenButton()
    if reopen and reopen.Parent then
        return
    end

    reopen = Instance.new("TextButton")
    reopen.Name = "Rouvrir"
    reopen.Size = UDim2.fromOffset(125, 36)
    reopen.Position = UDim2.new(0, 18, 0.5, -18)
    reopen.BackgroundColor3 = Color3.fromRGB(145, 95, 40)
    reopen.Text = "Rouvrir GUI"
    reopen.TextColor3 = Color3.fromRGB(255, 255, 255)
    reopen.TextSize = 14
    reopen.Font = Enum.Font.GothamSemibold
    reopen.AutoButtonColor = true
    reopen.Parent = gui
    rounded(reopen, 7)

    reopen.Activated:Connect(function()
        if reopen then
            reopen:Destroy()
            reopen = nil
        end
        main.Visible = true
    end)
end

hide.Activated:Connect(function()
    main.Visible = false
    showReopenButton()
end)

close.Activated:Connect(function()
    gui:Destroy()
end)

print("[Steal an Egg GUI] Interface chargée avec succès.")
