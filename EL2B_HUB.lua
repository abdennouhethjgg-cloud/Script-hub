--// ─────────────────────────────────────────────
--// SPIN BUTTON — Compatible Delta Executor
--// Bouton noir avec animations + fonction Spin
--// ─────────────────────────────────────────────

-- Nettoyage
if game.CoreGui:FindFirstChild("SpinButtonGui") then
    game.CoreGui.SpinButtonGui:Destroy()
end

local CoreGui        = game:GetService("CoreGui")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService     = game:GetService("RunService")
local Players        = game:GetService("Players")
local player         = Players.LocalPlayer

--// ── GUI principal ─────────────────────────────
local gui = Instance.new("ScreenGui")
gui.Name = "SpinButtonGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

--// ── Conteneur (draggable) ─────────────────────
local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(0, 90, 0, 90)
container.Position = UDim2.new(0, 30, 0.5, -45)
container.BackgroundTransparency = 1
container.Parent = gui

--// ── Spinner (frame qui tourne) ────────────────
local spinner = Instance.new("Frame")
spinner.Name = "Spinner"
spinner.Size = UDim2.new(1, 0, 1, 0)
spinner.BackgroundTransparency = 1
spinner.Parent = container

--// ── Halo pulsant ──────────────────────────────
local halo = Instance.new("Frame")
halo.Name = "Halo"
halo.Size = UDim2.new(1, 20, 1, 20)
halo.Position = UDim2.new(0, -10, 0, -10)
halo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
halo.BackgroundTransparency = 0.4
halo.BorderSizePixel = 0
halo.ZIndex = 0
halo.Parent = spinner

local haloCorner = Instance.new("UICorner")
haloCorner.CornerRadius = UDim.new(1, 0)
haloCorner.Parent = halo

TweenService:Create(halo, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
    BackgroundTransparency = 0.85,
    Size = UDim2.new(1, 30, 1, 30),
    Position = UDim2.new(0, -15, 0, -15)
}):Play()

--// ── Bouton ────────────────────────────────────
local button = Instance.new("TextButton")
button.Name = "SpinButton"
button.Size = UDim2.new(1, 0, 1, 0)
button.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
button.BorderSizePixel = 0
button.Text = "SPIN"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBlack
button.TextSize = 16
button.AutoButtonColor = false
button.Parent = spinner

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = button

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.6
stroke.Parent = button

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 45, 45))
})
gradient.Rotation = 45
gradient.Parent = button

-- Dégradé qui tourne en boucle
local gradRot = 45
RunService.RenderStepped:Connect(function(dt)
    gradRot = (gradRot + dt * 40) % 360
    gradient.Rotation = gradRot
end)

--// ── Hover ─────────────────────────────────────
button.MouseEnter:Connect(function()
    TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.1, Thickness = 2}):Play()
    TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
end)

button.MouseLeave:Connect(function()
    TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.6, Thickness = 1.5}):Play()
    TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(8, 8, 8)}):Play()
end)

--// ── FONCTION SPIN ─────────────────────────────
local spinning = false

local function doSpin()
    if spinning then return end
    spinning = true

    -- 1) Rotation du bouton
    local target = spinner.Rotation + 360
    TweenService:Create(spinner, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Rotation = target
    }):Play()

    -- 2) Flash lumineux
    local flash = TweenService:Create(stroke, TweenInfo.new(0.1), {Transparency = 0, Thickness = 3})
    flash:Play()
    flash.Completed:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.4), {Transparency = 0.6, Thickness = 1.5}):Play()
    end)

    -- 3) Rotation du personnage (client-side)
    task.spawn(function()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for _ = 1, 30 do
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(12), 0)
            task.wait(0.02)
        end
    end)

    task.delay(0.7, function()
        spinner.Rotation = spinner.Rotation % 360
        spinning = false
    end)
end

--// ── Click (avec détection de drag) ────────────
local dragStart, startPos
local dragging, dragMoved, dragInput = false, false, nil

button.MouseButton1Down:Connect(function()
    TweenService:Create(button, TweenInfo.new(0.08), {
        Size = UDim2.new(0.92, 0, 0.92, 0),
        Position = UDim2.new(0.04, 0, 0.04, 0)
    }):Play()
end)

button.MouseButton1Up:Connect(function()
    TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()
end)

button.MouseButton1Click:Connect(function()
    if not dragMoved then doSpin() end
    dragMoved = false
end)

--// ── Drag & Drop ───────────────────────────────
button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging   = true
        dragMoved  = false
        dragStart  = input.Position
        startPos   = container.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
            dragMoved = true
        end
        container.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

print("✅ Spin Button chargé ! (Delta Executor)")
