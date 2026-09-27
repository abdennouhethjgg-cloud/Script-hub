-- =====================================================
-- MINI GUI STYLE STEAL A BZH / INSTA STEAL
-- Petite, animée, 3 boutons
-- =====================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Nettoyage ancienne GUI
pcall(function()
    local old = PlayerGui:FindFirstChild("MiniBZH_GUI")
    if old then old:Destroy() end
end)

-- ===================== COULEURS =====================
local COLORS = {
    Background = Color3.fromRGB(18, 18, 22),
    Panel = Color3.fromRGB(28, 28, 35),
    Accent = Color3.fromRGB(0, 170, 255),      -- Bleu cyan
    Accent2 = Color3.fromRGB(0, 120, 255),
    Button = Color3.fromRGB(40, 40, 50),
    ButtonHover = Color3.fromRGB(55, 55, 70),
    Text = Color3.fromRGB(240, 240, 245),
    Success = Color3.fromRGB(50, 200, 100),
    Danger = Color3.fromRGB(255, 70, 70),
}

-- ===================== CRÉATION GUI =====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MiniBZH_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Main Frame (petite)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 220, 0, 0) -- hauteur animée
Main.Position = UDim2.new(0.5, -110, 0.7, 0)
Main.BackgroundColor3 = COLORS.Panel
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = COLORS.Accent
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.4
MainStroke.Parent = Main

-- Gradient stroke
local StrokeGradient = Instance.new("UIGradient")
StrokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLORS.Accent),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 200, 255)),
    ColorSequenceKeypoint.new(1, COLORS.Accent)
})
StrokeGradient.Rotation = 45
StrokeGradient.Parent = MainStroke

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 36)
Header.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

-- Fix corner bas header
local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 12)
HeaderFix.Position = UDim2.new(0, 0, 1, -12)
HeaderFix.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "BZH • Insta"
Title.TextColor3 = COLORS.Text
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = COLORS.Text
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Content
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -20, 0, 140)
Content.Position = UDim2.new(0, 10, 0, 42)
Content.BackgroundTransparency = 1
Content.Parent = Main

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Parent = Content

-- ===================== FONCTION CRÉATION BOUTON =====================
local function CreateButton(text, order, color, callback)
    local Btn = Instance.new("TextButton")
    Btn.Name = text
    Btn.Size = UDim2.new(1, 0, 0, 36)
    Btn.BackgroundColor3 = COLORS.Button
    Btn.Text = ""
    Btn.AutoButtonColor = false
    Btn.LayoutOrder = order
    Btn.Parent = Content

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 9)
    BtnCorner.Parent = Btn

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = color or COLORS.Accent
    BtnStroke.Thickness = 1.2
    BtnStroke.Transparency = 0.6
    BtnStroke.Parent = Btn

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = COLORS.Text
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamMedium
    Label.Parent = Btn

    -- Hover animation
    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
            BackgroundColor3 = COLORS.ButtonHover
        }):Play()
        TweenService:Create(BtnStroke, TweenInfo.new(0.18), {
            Transparency = 0.2,
            Thickness = 1.6
        }):Play()
    end)

    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
            BackgroundColor3 = COLORS.Button
        }):Play()
        TweenService:Create(BtnStroke, TweenInfo.new(0.18), {
            Transparency = 0.6,
            Thickness = 1.2
        }):Play()
    end)

    -- Click animation + callback
    Btn.MouseButton1Click:Connect(function()
        -- Scale pop
        TweenService:Create(Btn, TweenInfo.new(0.08, Enum.EasingStyle.Back), {
            Size = UDim2.new(1, -4, 0, 32)
        }):Play()
        task.wait(0.08)
        TweenService:Create(Btn, TweenInfo.new(0.12, Enum.EasingStyle.Back), {
            Size = UDim2.new(1, 0, 0, 36)
        }):Play()

        if callback then
            callback()
        end
    end)

    return Btn
end

-- ===================== LES 3 BOUTONS =====================
local Btn1 = CreateButton("⚡ Instant Steal", 1, COLORS.Accent, function()
    -- Ici ton code Instant Steal
    print("Instant Steal activé")
    -- Exemple notification
    Title.Text = "Steal ✓"
    task.delay(1.2, function()
        Title.Text = "BZH • Insta"
    end)
end)

local Btn2 = CreateButton("🏠 TP Base", 2, Color3.fromRGB(100, 200, 100), function()
    print("TP Base")
    Title.Text = "TP Base ✓"
    task.delay(1.2, function()
        Title.Text = "BZH • Insta"
    end)
end)

local Btn3 = CreateButton("👻 Invisible", 3, Color3.fromRGB(180, 100, 255), function()
    print("Invisible")
    Title.Text = "Invis ✓"
    task.delay(1.2, function()
        Title.Text = "BZH • Insta"
    end)
end)

-- ===================== ANIMATION OUVERTURE =====================
Main.Size = UDim2.new(0, 220, 0, 0)
Main.BackgroundTransparency = 1

TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 220, 0, 190),
    BackgroundTransparency = 0.05
}):Play()

-- Animation stroke
TweenService:Create(MainStroke, TweenInfo.new(0.5), {
    Transparency = 0.35
}):Play()

-- ===================== CLOSE =====================
CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 220, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.28)
    ScreenGui:Destroy()
end)

-- Hover close
CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = COLORS.Danger
    }):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    }):Play()
end)

print("✅ Mini GUI BZH chargée !")
