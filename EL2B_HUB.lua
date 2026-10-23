--// ─────────────────────────────────────────────
--// SPIN MASTER — Steal a Brainrot
--// Compatible Delta Executor (Mobile & PC)
--// Inclut : Spin Bot (perso) + Auto Spin (RNG)
--// ─────────────────────────────────────────────

if game.CoreGui:FindFirstChild("SpinMasterGui") then
    game.CoreGui.SpinMasterGui:Destroy()
end

local CoreGui          = game:GetService("CoreGui")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local player           = Players.LocalPlayer

--// ── ÉTAT ──────────────────────────────────────
local spinBotActive = false
local spinSpeed = 360 -- degrés par seconde
local autoSpinActive = false
local autoSpinDelay = 1.5 -- secondes entre chaque spin RNG

--// ── GUI PRINCIPAL ─────────────────────────────
local gui = Instance.new("ScreenGui")
gui.Name = "SpinMasterGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

--// ── CONTENEUR DRAGGABLE ───────────────────────
local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(0, 150, 0, 180)
container.Position = UDim2.new(0, 30, 0.5, -90)
container.BackgroundTransparency = 1
container.Parent = gui

--// ── HALO ANIMÉ ────────────────────────────────
local halo = Instance.new("Frame")
halo.Size = UDim2.new(1, 30, 1, 30)
halo.Position = UDim2.new(0, -15, 0, -15)
halo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
halo.BackgroundTransparency = 0.5
halo.BorderSizePixel = 0
halo.ZIndex = 0
halo.Parent = container

Instance.new("UICorner", halo).CornerRadius = UDim.new(1, 0)

TweenService:Create(halo, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
    BackgroundTransparency = 0.9,
    Size = UDim2.new(1, 50, 1, 50),
    Position = UDim2.new(0, -25, 0, -25)
}):Play()

--// ── TITRE ─────────────────────────────────────
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 24)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "SPIN MASTER"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.ZIndex = 2
title.Parent = container

--// ── BOUTON PRINCIPAL (SPIN BOT) ───────────────
local mainBtn = Instance.new("TextButton")
mainBtn.Name = "SpinBotButton"
mainBtn.Size = UDim2.new(1, 0, 0, 70)
mainBtn.Position = UDim2.new(0, 0, 0, 30)
mainBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainBtn.BorderSizePixel = 0
mainBtn.Text = "SPIN BOT\nDÉSACTIVÉ"
mainBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
mainBtn.Font = Enum.Font.GothamBold
mainBtn.TextSize = 16
mainBtn.AutoButtonColor = false
mainBtn.ZIndex = 2
mainBtn.Parent = container

Instance.new("UICorner", mainBtn).CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 255, 255)
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.7
mainStroke.Parent = mainBtn

-- Dégradé animé sur le bouton principal
local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
})
grad.Rotation = 0
grad.Parent = mainBtn

RunService.RenderStepped:Connect(function(dt)
    grad.Rotation = (grad.Rotation + dt * 50) % 360
end)

--// ── BOUTON SECONDAIRE (AUTO SPIN RNG) ─────────
local rngBtn = Instance.new("TextButton")
rngBtn.Name = "AutoSpinRng"
rngBtn.Size = UDim2.new(1, 0, 0, 40)
rngBtn.Position = UDim2.new(0, 0, 0, 108)
rngBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
rngBtn.BorderSizePixel = 0
rngBtn.Text = "AUTO SPIN RNG"
rngBtn.TextColor3 = Color3.fromRGB(150, 200, 255)
rngBtn.Font = Enum.Font.GothamBold
rngBtn.TextSize = 14
rngBtn.AutoButtonColor = false
rngBtn.ZIndex = 2
rngBtn.Parent = container

Instance.new("UICorner", rngBtn).CornerRadius = UDim.new(0, 10)
local rngStroke = Instance.new("UIStroke")
rngStroke.Color = Color3.fromRGB(100, 150, 255)
rngStroke.Thickness = 1
rngStroke.Transparency = 0.6
rngStroke.Parent = rngBtn

--// ── LABEL VITESSE ─────────────────────────────
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0, 152)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Vitesse: 360 °/s"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 12
speedLabel.ZIndex = 2
speedLabel.Parent = container

--// ── LOGIQUE SPIN BOT (ROTATION CONTINUE) ──────
RunService.Heartbeat:Connect(function(dt)
    if not spinBotActive then return end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed * dt), 0)
    end
end)

--// ── TOGGLE SPIN BOT ───────────────────────────
mainBtn.MouseButton1Click:Connect(function()
    spinBotActive = not spinBotActive

    if spinBotActive then
        mainBtn.Text = "SPIN BOT\nACTIVÉ"
        mainBtn.TextColor3 = Color3.fromRGB(100, 255, 150)
        TweenService:Create(mainStroke, TweenInfo.new(0.2), {Transparency = 0.2, Thickness = 2.5, Color = Color3.fromRGB(100, 255, 150)}):Play()
        TweenService:Create(mainBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(5, 20, 5)}):Play()
    else
        mainBtn.Text = "SPIN BOT\nDÉSACTIVÉ"
        mainBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TweenService:Create(mainStroke, TweenInfo.new(0.2), {Transparency = 0.7, Thickness = 1.5, Color = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(mainBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(10, 10, 10)}):Play()
    end

    -- Petite rotation de feedback
    mainBtn.Rotation = 0
    TweenService:Create(mainBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = 360}):Play()
end)

--// ── LOGIQUE AUTO SPIN RNG (SIMULÉE) ───────────
-- Note : L'automatisation précise de la machine RNG dépend de son implémentation exacte.
-- Ce bloc tente de cliquer sur l'interface si elle est détectable, sinon il envoie un clic au centre de l'écran.
task.spawn(function()
    while true do
        task.wait(autoSpinDelay)
        if not autoSpinActive then continue end

        -- Tentative de trouver le bouton de spin de la machine RNG
        local rngButton = nil
        for _, obj in ipairs(game:GetService("CoreGui"):GetDescendants()) do
            if obj:IsA("TextButton") and (string.find(string.lower(obj.Text), "spin") or string.find(string.lower(obj.Name), "spin")) then
                rngButton = obj
                break
            end
        end

        if rngButton then
            rngButton:Click()
        else
            -- Fallback : clic virtuel au centre de l'écran (approximatif)
            local vim = game:GetService("VirtualInputManager")
            vim:SendMouseButtonEvent(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2, 0, true, game, 1)
            task.wait(0.1)
            vim:SendMouseButtonEvent(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2, 0, false, game, 1)
        end
    end
end)

--// ── TOGGLE AUTO SPIN RNG ──────────────────────
rngBtn.MouseButton1Click:Connect(function()
    autoSpinActive = not autoSpinActive

    if autoSpinActive then
        rngBtn.Text = "AUTO SPIN: ON"
        rngBtn.TextColor3 = Color3.fromRGB(100, 255, 150)
        TweenService:Create(rngStroke, TweenInfo.new(0.2), {Transparency = 0.2, Color = Color3.fromRGB(100, 255, 150)}):Play()
    else
        rngBtn.Text = "AUTO SPIN RNG"
        rngBtn.TextColor3 = Color3.fromRGB(150, 200, 255)
        TweenService:Create(rngStroke, TweenInfo.new(0.2), {Transparency = 0.6, Color = Color3.fromRGB(100, 150, 255)}):Play()
    end
end)

--// ── HOVER EFFECTS ─────────────────────────────
mainBtn.MouseEnter:Connect(function()
    TweenService:Create(mainStroke, TweenInfo.new(0.15), {Transparency = 0.1, Thickness = 2}):Play()
end)
mainBtn.MouseLeave:Connect(function()
    if not spinBotActive then
        TweenService:Create(mainStroke, TweenInfo.new(0.15), {Transparency = 0.7, Thickness = 1.5}):Play()
    end
end)

--// ── DRAG & DROP ───────────────────────────────
local dragging, dragStart, startPos, dragInput = false, nil, nil, nil
local dragTargets = {title, mainBtn, rngBtn, speedLabel}

for _, obj in ipairs(dragTargets) do
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = container.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
end

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("✅ Spin Master (Steal a Brainrot) chargé !")
print("🔄 Spin Bot : fais tourner ton personnage.")
print("🎰 Auto Spin RNG : tente d'automatiser la machine RNG.")
