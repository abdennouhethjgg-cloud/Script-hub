-- EL2B HUB · Neutral starter
-- Cette base ne contient aucun système hérité. Elle sert uniquement à vérifier
-- que l’exécuteur peut afficher une interface Roblox standard.

local Players = game:GetService("Players")
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

local old = playerGui:FindFirstChild("EL2BNeutralGui")
if old then
    old:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "EL2BNeutralGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.Size = UDim2.fromOffset(300, 132)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(16, 16)
title.Size = UDim2.new(1, -32, 0, 28)
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Text = "EL2B HUB"
title.Parent = frame

local status = Instance.new("TextLabel")
status.BackgroundTransparency = 1
status.Position = UDim2.fromOffset(16, 50)
status.Size = UDim2.new(1, -32, 0, 22)
status.Font = Enum.Font.Gotham
status.TextColor3 = Color3.fromRGB(190, 190, 210)
status.TextSize = 13
status.Text = "Base neutre prête / Neutral base ready"
status.Parent = frame

local close = Instance.new("TextButton")
close.Position = UDim2.new(1, -92, 1, -38)
close.Size = UDim2.fromOffset(76, 26)
close.BackgroundColor3 = Color3.fromRGB(42, 32, 52)
close.BorderSizePixel = 0
close.Font = Enum.Font.GothamSemibold
close.TextColor3 = Color3.fromRGB(255, 210, 240)
close.TextSize = 11
close.Text = "Fermer / Close"
close.Parent = frame
close.Activated:Connect(function()
    gui:Destroy()
end)

print("[EL2B HUB] Neutral base loaded successfully")
