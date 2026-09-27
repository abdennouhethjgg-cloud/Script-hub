-- leak by FS│https://discord.gg/TBBAUZu8cW

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local tradeAccepting = true
local tradeCount = 0
local guiVisible = true

local RED_GRADIENT = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 20, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 80))
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoAccept175"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 170)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -85)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainGradient = Instance.new("UIGradient", MainFrame)
MainGradient.Color = RED_GRADIENT
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2
local StrokeGrad = Instance.new("UIGradient", MainStroke)
StrokeGrad.Color = RED_GRADIENT

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -60, 0, 32)
Title.Position = UDim2.new(0, 8, 0, 4)
Title.BackgroundTransparency = 1
Title.Text = "175 Auto Accept"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBlack

local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0, 26, 0, 26)
MinBtn.Position = UDim2.new(1, -34, 0, 4)
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.BackgroundTransparency = 0.2
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MinBtn.TextScaled = true
MinBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)

local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, 0, 1, -36)
Content.Position = UDim2.new(0, 0, 0, 36)
Content.BackgroundTransparency = 1

local toggleRow = Instance.new("Frame", Content)
toggleRow.Size = UDim2.new(1, -16, 0, 32)
toggleRow.Position = UDim2.new(0, 8, 0, 4)
toggleRow.BackgroundTransparency = 1

local toggleLabel = Instance.new("TextLabel", toggleRow)
toggleLabel.Size = UDim2.new(0.5, 0, 1, 0)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Text = "Accept Trades"
toggleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleLabel.TextScaled = true
toggleLabel.Font = Enum.Font.GothamSemibold
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left

local switchBtn = Instance.new("TextButton", toggleRow)
switchBtn.Size = UDim2.new(0, 50, 0, 26)
switchBtn.Position = UDim2.new(1, -50, 0.5, -13)
switchBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 70)
switchBtn.BorderSizePixel = 0
switchBtn.Text = "ON"
switchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
switchBtn.TextSize = 11
switchBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", switchBtn).CornerRadius = UDim.new(0, 6)

local statusRow = Instance.new("Frame", Content)
statusRow.Size = UDim2.new(1, -16, 0, 24)
statusRow.Position = UDim2.new(0, 8, 0, 42)
statusRow.BackgroundTransparency = 1

local statusDot = Instance.new("Frame", statusRow)
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(0, 2, 0.5, -4)
statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
statusDot.BorderSizePixel = 0
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local statusLabel = Instance.new("TextLabel", statusRow)
statusLabel.Size = UDim2.new(0.8, 0, 1, 0)
statusLabel.Position = UDim2.new(0, 14, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Active"
statusLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- CONTADOR DE TRADES
local counterRow = Instance.new("Frame", Content)
counterRow.Size = UDim2.new(1, -16, 0, 24)
counterRow.Position = UDim2.new(0, 8, 0, 72)
counterRow.BackgroundTransparency = 1

local counterLabel = Instance.new("TextLabel", counterRow)
counterLabel.Size = UDim2.new(1, 0, 1, 0)
counterLabel.BackgroundTransparency = 1
counterLabel.Text = "Trades: 0"
counterLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
counterLabel.TextScaled = true
counterLabel.Font = Enum.Font.GothamBold
counterLabel.TextXAlignment = Enum.TextXAlignment.Center

local discordLabel = Instance.new("TextLabel", Content)
discordLabel.Size = UDim2.new(0.92, 0, 0, 18)
discordLabel.Position = UDim2.new(0.04, 0, 0, 102)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "discord.gg/TVVqMnMXK"
discordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
discordLabel.TextScaled = true
discordLabel.Font = Enum.Font.Gotham

local function updateStatus(active)
    if active then
        statusLabel.Text = "Active"
        statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        switchBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 70)
        switchBtn.Text = "ON"
    else
        statusLabel.Text = "Paused"
        statusDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        switchBtn.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
        switchBtn.Text = "OFF"
    end
end

local function updateCounter()
    counterLabel.Text = "Trades: " .. tradeCount
end

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 220, 0, 36)
        Content.Visible = false
        MinBtn.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 220, 0, 170)
        Content.Visible = true
        MinBtn.Text = "-"
    end
end)

switchBtn.MouseButton1Click:Connect(function()
    tradeAccepting = not tradeAccepting
    updateStatus(tradeAccepting)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

updateStatus(tradeAccepting)
updateCounter()

-- ==================== DETECCION DE TRADES COMPLETADOS ====================
task.delay(5, function()
    local container = player.PlayerGui.DuelsMachinePrompt.DuelsMachinePrompt

    local function createAFKTag()
        local character = player.Character or player.CharacterAdded:Wait()
        local head = character:WaitForChild("Head")
        if head:FindFirstChild("AFKTag") then return end
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "AFKTag"
        billboard.Size = UDim2.new(0, 180, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = "Auto Accept 175 AFK"
        textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        textLabel.TextStrokeTransparency = 0
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.GothamBold
        textLabel.Parent = billboard
    end

    createAFKTag()
    player.CharacterAdded:Connect(function()
        task.wait(1)
        createAFKTag()
    end)

    local function clickYes(prompt)
        if not tradeAccepting then return end
        local yesButton = prompt:FindFirstChild("Yes", true)
        if yesButton then
            if firesignal then
                firesignal(yesButton.Activated)
            else
                local VirtualInputManager = game:GetService("VirtualInputManager")
                local pos = yesButton.AbsolutePosition + (yesButton.AbsoluteSize / 2)
                VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
                VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
            end
        end
    end

    local function Accept()
        if not tradeAccepting then return end
        firesignal(player.PlayerGui.TradeLiveTrade.TradeLiveTrade.Other.ReadyButton.Activated)
    end

    -- DETECTAR TRADE COMPLETADO
    local function detectTradeComplete()
        -- Buscar en el chat
        local chat = player.PlayerGui:FindFirstChild("Chat")
        if chat then
            for _, child in ipairs(chat:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextBox") then
                    local text = child.Text or ""
                    if string.find(text, "Trade with @") and string.find(text, "completed!") then
                        tradeCount = tradeCount + 1
                        updateCounter()
                        -- Marcar como procesado para no contar duplicados
                        child.Text = text .. " [PROCESSED]"
                    end
                end
            end
        end
    end

    task.spawn(function()
        while task.wait(0.5) do
            Accept()
            detectTradeComplete()
        end
    end)

    container.ChildAdded:Connect(function(child)
        if child.Name == "Prompt" then
            local label = child:FindFirstChild("Label", true)
            if label and label.Text == "Trade Request" then
                clickYes(child)
            end
        end
    end)

    -- DETECTAR CUANDO APARECE EL MENSAJE DE TRADE COMPLETADO
    local function onNewGuiObject(obj)
        if obj:IsA("TextLabel") or obj:IsA("TextBox") then
            local text = obj.Text or ""
            if string.find(text, "Trade with @") and string.find(text, "completed!") then
                tradeCount = tradeCount + 1
                updateCounter()
            end
        end
    end

    -- Escuchar nuevos objetos en toda la GUI del jugador
    player.PlayerGui.DescendantAdded:Connect(onNewGuiObject)

    -- Tambien escuchar cambios en el texto
    local function onTextChanged(obj)
        if obj:IsA("TextLabel") or obj:IsA("TextBox") then
            local text = obj.Text or ""
            if string.find(text, "Trade with @") and string.find(text, "completed!") then
                tradeCount = tradeCount + 1
                updateCounter()
            end
        end
    end

    player.PlayerGui.DescendantAdded:Connect(function(obj)
        if obj:IsA("TextLabel") or obj:IsA("TextBox") then
            obj:GetPropertyChangedSignal("Text"):Connect(function()
                onTextChanged(obj)
            end)
        end
    end)
end)
