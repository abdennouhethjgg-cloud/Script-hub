-- EL2B HUB — Clean launcher
-- Base vide volontairement : les fonctions seront ajoutées sur demande.

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player and player:WaitForChild("PlayerGui", 30)

if not playerGui then
    warn("[EL2B HUB] PlayerGui introuvable / PlayerGui unavailable")
    return
end

local oldGui = playerGui:FindFirstChild("EL2BHubLauncher")
if oldGui then
    oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "EL2BHubLauncher"
gui.ResetOnSpawn = false
gui.DisplayOrder = 100000
gui.Parent = playerGui

local label = Instance.new("TextLabel")
label.Name = "Ready"
label.AnchorPoint = Vector2.new(0.5, 0.5)
label.Position = UDim2.fromScale(0.5, 0.5)
label.Size = UDim2.fromOffset(280, 58)
label.BackgroundColor3 = Color3.fromRGB(24, 20, 34)
label.BorderSizePixel = 1
label.BorderColor3 = Color3.fromRGB(255, 32, 150)
label.Font = Enum.Font.GothamBold
label.Text = "EL2B HUB prêt / ready"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextSize = 16
label.TextWrapped = true
label.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = label

print("[EL2B HUB] Clean launcher loaded")
