-- LocalScript (mets-le dans StarterPlayerScripts)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TradeHubGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Frame principale (taille proche du screenshot)
local main = Instance.new("Frame")
main.Name = "TradeHub"
main.Size = UDim2.new(0, 240, 0, 185)
main.Position = UDim2.new(0.5, -120, 0.42, 0)
main.BackgroundColor3 = Color3.fromRGB(48, 18, 92)
main.BorderSizePixel = 0
main.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(160, 80, 255)
stroke.Thickness = 1.8
stroke.Parent = main

-- Titre
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 34)
title.Position = UDim2.new(0, 14, 0, 6)
title.BackgroundTransparency = 1
title.Text = "⚡  TRADE HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- Bouton X
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -36, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(75, 30, 120)
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = 15
close.Parent = main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = close

close.MouseButton1Click:Connect(function()
	main.Visible = false
end)

-- Fonction création de bouton
local function makeButton(text, y, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -28, 0, 38)
	btn.Position = UDim2.new(0, 14, 0, y)
	btn.BackgroundColor3 = color
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 15
	btn.AutoButtonColor = false
	btn.Parent = main

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 9)
	c.Parent = btn

	-- Hover
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(
				math.min(color.R*255 + 30, 255),
				math.min(color.G*255 + 30, 255),
				math.min(color.B*255 + 30, 255)
			)
		}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()
	end)

	return btn
end

-- Les 3 boutons (exactement comme ton screenshot)
local btnFazer   = makeButton("⚡  FAZER TRADE",   48,  Color3.fromRGB(120, 55, 210))
local btnAuto    = makeButton("✓  AUTO ACEITAR",  94,  Color3.fromRGB(95, 40, 175))
local btnForce   = makeButton("🔥  FORCE TRADE",  140, Color3.fromRGB(140, 45, 170))

-- ===== ICI tu mets tes fonctions =====
btnFazer.MouseButton1Click:Connect(function()
	print("FAZER TRADE cliqué")
	-- ton code ici
end)

btnAuto.MouseButton1Click:Connect(function()
	print("AUTO ACEITAR cliqué")
	-- ton code ici
end)

btnForce.MouseButton1Click:Connect(function()
	print("FORCE TRADE cliqué")
	-- ton code ici
end)
