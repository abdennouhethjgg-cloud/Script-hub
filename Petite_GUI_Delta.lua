-- Petite_GUI_Delta.lua
-- GUI locale, légère et non invasive.
-- Utilisation : coller le contenu dans Delta ou un autre exécuteur compatible.

local Players = game:GetService("Players")
local player = Players.LocalPlayer

if not player then
    warn("[Petite GUI] LocalPlayer introuvable.")
    return
end

local playerGui = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui", 10)
if not playerGui then
    warn("[Petite GUI] PlayerGui introuvable.")
    return
end

local oldGui = playerGui:FindFirstChild("PetiteGuiDelta")
if oldGui then
    oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "PetiteGuiDelta"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Fenetre"
main.Size = UDim2.fromOffset(260, 145)
main.Position = UDim2.new(0.5, -130, 0.5, -72)
main.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(85, 91, 115)
stroke.Thickness = 1
stroke.Parent = main

local title = Instance.new("TextLabel")
title.Name = "Titre"
title.Size = UDim2.new(1, -52, 0, 38)
title.Position = UDim2.fromOffset(14, 4)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Petite GUI"
title.TextColor3 = Color3.fromRGB(245, 245, 250)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local close = Instance.new("TextButton")
close.Name = "Fermer"
close.Size = UDim2.fromOffset(32, 28)
close.Position = UDim2.new(1, -40, 0, 9)
close.BackgroundColor3 = Color3.fromRGB(190, 65, 75)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.TextSize = 14
close.Font = Enum.Font.GothamBold
close.AutoButtonColor = true
close.Parent = main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 7)
closeCorner.Parent = close

local status = Instance.new("TextLabel")
status.Name = "Statut"
status.Size = UDim2.new(1, -28, 0, 30)
status.Position = UDim2.fromOffset(14, 48)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.Text = "Statut : actif"
status.TextColor3 = Color3.fromRGB(170, 220, 180)
status.TextSize = 14
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

local hide = Instance.new("TextButton")
hide.Name = "Masquer"
hide.Size = UDim2.new(1, -28, 0, 38)
hide.Position = UDim2.fromOffset(14, 92)
hide.BackgroundColor3 = Color3.fromRGB(65, 90, 150)
hide.Text = "Masquer la fenêtre"
hide.TextColor3 = Color3.fromRGB(255, 255, 255)
hide.TextSize = 14
hide.Font = Enum.Font.GothamSemibold
hide.AutoButtonColor = true
hide.Parent = main

local hideCorner = Instance.new("UICorner")
hideCorner.CornerRadius = UDim.new(0, 7)
hideCorner.Parent = hide

hide.MouseButton1Click:Connect(function()
    main.Visible = false
    local reopen = Instance.new("TextButton")
    reopen.Name = "Rouvrir"
    reopen.Size = UDim2.fromOffset(120, 36)
    reopen.Position = UDim2.new(0, 18, 0.5, -18)
    reopen.BackgroundColor3 = Color3.fromRGB(65, 90, 150)
    reopen.Text = "Rouvrir GUI"
    reopen.TextColor3 = Color3.fromRGB(255, 255, 255)
    reopen.TextSize = 14
    reopen.Font = Enum.Font.GothamSemibold
    reopen.Parent = gui

    local reopenCorner = Instance.new("UICorner")
    reopenCorner.CornerRadius = UDim.new(0, 7)
    reopenCorner.Parent = reopen

    reopen.MouseButton1Click:Connect(function()
        reopen:Destroy()
        main.Visible = true
    end)
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("[Petite GUI] Interface chargée avec succès.")
