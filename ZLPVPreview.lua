repeat task.wait() until game:IsLoaded()

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")

-- Nettoyage ancienne GUI
pcall(function()
    for _, n in ipairs({"Space X Hook", "Space X Hook Anti Bat", "Space_X_Hook_Anti_Bat"}) do
        local old = PlayerGui:FindFirstChild(n)
        if old then old:Destroy() end
    end
end)

local CONFIG_FILE = "SpaceX_Hook_Config.json"

local InfiniteJumpEnabled = false
local CurrentKeybind      = Enum.KeyCode.N
local WaitingForKeybind   = false
local CurrentBG           = "rbxassetid://114138477258742"
local minimized           = false

local AntiRagdollConn = nil

-- ====== CONFIG ======
local function saveConfig()
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode({
            Keybind    = CurrentKeybind.Name,
            Background = CurrentBG,
            InfJump    = InfiniteJumpEnabled,
        }))
    end)
end

local function loadConfig()
    local ok, result = pcall(function()
        if isfile and isfile(CONFIG_FILE) then
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end
    end)
    if ok and type(result) == "table" then
        if result.Keybind and Enum.KeyCode[result.Keybind] then
            CurrentKeybind = Enum.KeyCode[result.Keybind]
        end
        if result.Background then
            CurrentBG = result.Background
        end
        if result.InfJump ~= nil then
            InfiniteJumpEnabled = result.InfJump == true
        end
    end
end
pcall(loadConfig)

-- ====== INF JUMP (normal) ======
local function doJump()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

UserInputService.JumpRequest:Connect(function()
    if not InfiniteJumpEnabled then return end
    doJump()
end)

-- Support mobile : détecte l'appui sur le bouton jump mobile
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if not InfiniteJumpEnabled then return end
    if input.KeyCode == Enum.KeyCode.Space then
        doJump()
    end
end)

-- ====== ANTI RAGDOLL ======
local function startAntiRagdoll()
    if AntiRagdollConn then return end
    AntiRagdollConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if hum then
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Physics
                or st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.FallingDown then
                hum:ChangeState(Enum.HumanoidStateType.Running)
                workspace.CurrentCamera.CameraSubject = hum
                pcall(function()
                    local pm = LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")
                    if pm then
                        local cm = pm:FindFirstChild("ControlModule")
                        if cm then require(cm):Enable() end
                    end
                end)
                if root then
                    root.Velocity = Vector3.zero
                    root.RotVelocity = Vector3.zero
                end
            end
        end
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") and not obj.Enabled then
                obj.Enabled = true
            end
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    startAntiRagdoll()
end)

-- ====== GUI ======
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Space X Hook"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 10
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Active = true
Main.ClipsDescendants = true
Main.Position = UDim2.new(0.5, -135, 0.5, -100)
Main.Size = UDim2.new(0, 270, 0, 200)
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local SpaceBackground = Instance.new("ImageLabel")
SpaceBackground.Name = "SpaceBackground"
SpaceBackground.ZIndex = 0
SpaceBackground.Size = UDim2.new(1, 0, 1, 0)
SpaceBackground.BackgroundTransparency = 1
SpaceBackground.Image = CurrentBG
SpaceBackground.ScaleType = Enum.ScaleType.Crop
SpaceBackground.Parent = Main
Instance.new("UICorner", SpaceBackground).CornerRadius = UDim.new(0, 16)

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Active = true
Header.ZIndex = 2
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundTransparency = 1
Header.Parent = Main

local HeaderIcon = Instance.new("Frame")
HeaderIcon.Name = "HeaderIcon"
HeaderIcon.ZIndex = 5
HeaderIcon.Position = UDim2.new(0, 16, 0.5, -5)
HeaderIcon.Size = UDim2.new(0, 10, 0, 10)
HeaderIcon.BackgroundColor3 = Color3.fromRGB(120, 120, 130)
HeaderIcon.BorderSizePixel = 0
HeaderIcon.Parent = Header
Instance.new("UICorner", HeaderIcon).CornerRadius = UDim.new(1, 0)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.ZIndex = 5
Title.Position = UDim2.new(0, 36, 0, 6)
Title.Size = UDim2.new(1, -130, 0, 18)
Title.BackgroundTransparency = 1
Title.Text = "SPACE X HOOK"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.ZIndex = 5
SubTitle.Position = UDim2.new(0, 36, 0, 26)
SubTitle.Size = UDim2.new(1, -130, 0, 14)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Space X Hook"
SubTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

local BgBtn = Instance.new("TextButton")
BgBtn.Name = "BgBtn"
BgBtn.ZIndex = 5
BgBtn.AnchorPoint = Vector2.new(1, 0.5)
BgBtn.Position = UDim2.new(1, -60, 0.5, 0)
BgBtn.Size = UDim2.new(0, 42, 0, 22)
BgBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
BgBtn.BackgroundTransparency = 0.15
BgBtn.Text = "BG"
BgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BgBtn.TextSize = 10
BgBtn.Font = Enum.Font.GothamBlack
BgBtn.AutoButtonColor = false
BgBtn.Parent = Header
Instance.new("UICorner", BgBtn).CornerRadius = UDim.new(0, 6)
local BgStroke = Instance.new("UIStroke")
BgStroke.Color = Color3.fromRGB(120, 120, 130)
BgStroke.Transparency = 0.15
BgStroke.Parent = BgBtn

local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.ZIndex = 5
MinBtn.AnchorPoint = Vector2.new(1, 0.5)
MinBtn.Position = UDim2.new(1, -12, 0.5, 0)
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MinBtn.BackgroundTransparency = 0.5
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.GothamBlack
MinBtn.AutoButtonColor = false
MinBtn.Parent = Header
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local ContentHolder = Instance.new("Frame")
ContentHolder.Name = "ContentHolder"
ContentHolder.ZIndex = 2
ContentHolder.ClipsDescendants = true
ContentHolder.Position = UDim2.new(0, 0, 0, 48)
ContentHolder.Size = UDim2.new(1, 0, 1, -48)
ContentHolder.BackgroundTransparency = 1
ContentHolder.Parent = Main

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.ZIndex = 2
Content.Size = UDim2.new(1, 0, 1, 0)
Content.BackgroundTransparency = 1
Content.Parent = ContentHolder

-- STATUS ROW
local StatusRow = Instance.new("Frame")
StatusRow.Name = "StatusRow"
StatusRow.ZIndex = 4
StatusRow.Position = UDim2.new(0, 12, 0, 6)
StatusRow.Size = UDim2.new(1, -24, 0, 32)
StatusRow.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
StatusRow.BackgroundTransparency = 0.5
StatusRow.Parent = Content
Instance.new("UICorner", StatusRow).CornerRadius = UDim.new(0, 12)

local StatusDot = Instance.new("Frame")
StatusDot.Name = "StatusDot"
StatusDot.ZIndex = 6
StatusDot.Position = UDim2.new(0, 14, 0.5, -4)
StatusDot.Size = UDim2.new(0, 8, 0, 8)
StatusDot.BackgroundColor3 = Color3.fromRGB(255, 70, 90)
StatusDot.BorderSizePixel = 0
StatusDot.Parent = StatusRow
Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.ZIndex = 6
StatusLabel.Position = UDim2.new(0, 30, 0, 0)
StatusLabel.Size = UDim2.new(0, 100, 1, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.GothamBlack
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusRow

local StatusValue = Instance.new("TextLabel")
StatusValue.Name = "StatusValue"
StatusValue.ZIndex = 6
StatusValue.Position = UDim2.new(1, -114, 0, 0)
StatusValue.Size = UDim2.new(0, 100, 1, 0)
StatusValue.BackgroundTransparency = 1
StatusValue.Text = "INACTIVE"
StatusValue.TextColor3 = Color3.fromRGB(255, 70, 90)
StatusValue.TextSize = 14
StatusValue.Font = Enum.Font.GothamBlack
StatusValue.TextXAlignment = Enum.TextXAlignment.Right
StatusValue.Parent = StatusRow

-- INF JUMP ROW
local InfJumpRow = Instance.new("Frame")
InfJumpRow.Name = "InfJumpRow"
InfJumpRow.ZIndex = 4
InfJumpRow.Position = UDim2.new(0, 12, 0, 46)
InfJumpRow.Size = UDim2.new(1, -24, 0, 50)
InfJumpRow.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
InfJumpRow.BackgroundTransparency = 0.5
InfJumpRow.Parent = Content
Instance.new("UICorner", InfJumpRow).CornerRadius = UDim.new(0, 12)

local InfJumpLabel = Instance.new("TextLabel")
InfJumpLabel.Name = "InfJumpLabel"
InfJumpLabel.ZIndex = 6
InfJumpLabel.Position = UDim2.new(0, 14, 0.5, -8)
InfJumpLabel.Size = UDim2.new(0, 150, 0, 18)
InfJumpLabel.BackgroundTransparency = 1
InfJumpLabel.Text = "Inf Jump"
InfJumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfJumpLabel.TextSize = 14
InfJumpLabel.Font = Enum.Font.GothamBlack
InfJumpLabel.TextXAlignment = Enum.TextXAlignment.Left
InfJumpLabel.Parent = InfJumpRow

local InfToggleBg = Instance.new("Frame")
InfToggleBg.Name = "InfToggleBg"
InfToggleBg.ZIndex = 6
InfToggleBg.Position = UDim2.new(1, -58, 0.5, -11)
InfToggleBg.Size = UDim2.new(0, 44, 0, 22)
InfToggleBg.BackgroundColor3 = Color3.fromRGB(52, 52, 58)
InfToggleBg.BorderSizePixel = 0
InfToggleBg.Parent = InfJumpRow
Instance.new("UICorner", InfToggleBg).CornerRadius = UDim.new(1, 0)

local InfToggleDot = Instance.new("Frame")
InfToggleDot.Name = "InfToggleDot"
InfToggleDot.ZIndex = 7
InfToggleDot.Position = UDim2.new(0, 3, 0.5, -8)
InfToggleDot.Size = UDim2.new(0, 16, 0, 16)
InfToggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InfToggleDot.BorderSizePixel = 0
InfToggleDot.Parent = InfToggleBg
Instance.new("UICorner", InfToggleDot).CornerRadius = UDim.new(1, 0)

local InfJumpClick = Instance.new("TextButton")
InfJumpClick.Name = "InfJumpClick"
InfJumpClick.ZIndex = 10
InfJumpClick.Position = UDim2.new(1, -65, 0, 0)
InfJumpClick.Size = UDim2.new(0, 50, 0, 50)
InfJumpClick.BackgroundTransparency = 1
InfJumpClick.Text = ""
InfJumpClick.Parent = InfJumpRow

-- KEYBIND ROW
local KeybindRow = Instance.new("Frame")
KeybindRow.Name = "KeybindRow"
KeybindRow.ZIndex = 4
KeybindRow.Position = UDim2.new(0, 12, 0, 104)
KeybindRow.Size = UDim2.new(1, -24, 0, 32)
KeybindRow.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
KeybindRow.BackgroundTransparency = 0.5
KeybindRow.Parent = Content
Instance.new("UICorner", KeybindRow).CornerRadius = UDim.new(0, 12)

local KeybindLabel = Instance.new("TextLabel")
KeybindLabel.Name = "KeybindLabel"
KeybindLabel.ZIndex = 6
KeybindLabel.Position = UDim2.new(0, 14, 0, 0)
KeybindLabel.Size = UDim2.new(0, 80, 1, 0)
KeybindLabel.BackgroundTransparency = 1
KeybindLabel.Text = "Keybind"
KeybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindLabel.TextSize = 12
KeybindLabel.Font = Enum.Font.GothamBlack
KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
KeybindLabel.Parent = KeybindRow

local KeybindBtn = Instance.new("TextButton")
KeybindBtn.Name = "KeybindBtn"
KeybindBtn.ZIndex = 10
KeybindBtn.AnchorPoint = Vector2.new(1, 0.5)
KeybindBtn.Position = UDim2.new(1, -14, 0.5, 0)
KeybindBtn.Size = UDim2.new(0, 50, 0, 20)
KeybindBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeybindBtn.BackgroundTransparency = 0.5
KeybindBtn.Text = CurrentKeybind.Name
KeybindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindBtn.TextSize = 12
KeybindBtn.Font = Enum.Font.GothamBlack
KeybindBtn.AutoButtonColor = false
KeybindBtn.Parent = KeybindRow
Instance.new("UICorner", KeybindBtn).CornerRadius = UDim.new(0, 6)

-- BACKGROUND PICKER
local BackgroundPicker = Instance.new("Frame")
BackgroundPicker.Name = "BackgroundPicker"
BackgroundPicker.Visible = false
BackgroundPicker.ZIndex = 20
BackgroundPicker.AnchorPoint = Vector2.new(0.5, 0.5)
BackgroundPicker.Position = UDim2.new(0.5, 0, 0.5, 0)
BackgroundPicker.Size = UDim2.new(0, 260, 0, 180)
BackgroundPicker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BackgroundPicker.BorderSizePixel = 0
BackgroundPicker.Parent = ScreenGui
Instance.new("UICorner", BackgroundPicker).CornerRadius = UDim.new(0, 12)
local BPStroke = Instance.new("UIStroke")
BPStroke.Color = Color3.fromRGB(110, 110, 120)
BPStroke.Thickness = 1.5
BPStroke.Transparency = 0.15
BPStroke.Parent = BackgroundPicker

local Header2 = Instance.new("Frame")
Header2.Name = "Header"
Header2.ZIndex = 21
Header2.Size = UDim2.new(1, 0, 0, 38)
Header2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Header2.BackgroundTransparency = 0.15
Header2.BorderSizePixel = 0
Header2.Parent = BackgroundPicker
Instance.new("UICorner", Header2).CornerRadius = UDim.new(0, 12)

local BPTitle = Instance.new("TextLabel")
BPTitle.ZIndex = 22
BPTitle.Position = UDim2.new(0, 12, 0, 0)
BPTitle.Size = UDim2.new(1, -54, 1, 0)
BPTitle.BackgroundTransparency = 1
BPTitle.Text = "Change Background"
BPTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
BPTitle.TextSize = 16
BPTitle.Font = Enum.Font.GothamBlack
BPTitle.TextXAlignment = Enum.TextXAlignment.Left
BPTitle.Parent = Header2

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.ZIndex = 22
Close.AnchorPoint = Vector2.new(1, 0.5)
Close.Position = UDim2.new(1, -9, 0.5, 0)
Close.Size = UDim2.new(0, 28, 0, 25)
Close.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Close.BackgroundTransparency = 0.1
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 18
Close.Font = Enum.Font.GothamBlack
Close.AutoButtonColor = false
Close.Parent = Header2
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 7)

local BackgroundGrid = Instance.new("Frame")
BackgroundGrid.Name = "BackgroundGrid"
BackgroundGrid.ZIndex = 21
BackgroundGrid.Position = UDim2.new(0, 12, 0, 48)
BackgroundGrid.Size = UDim2.new(1, -24, 1, -60)
BackgroundGrid.BackgroundTransparency = 1
BackgroundGrid.Parent = BackgroundPicker

local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
UIGridLayout.CellSize = UDim2.new(0, 72, 0, 72)
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.FillDirectionMaxCells = 3
UIGridLayout.Parent = BackgroundGrid

local bgIds = {
    "rbxassetid://118100574986629",
    "rbxassetid://76835310118322",
    "rbxassetid://114138477258742",
}

for i, id in ipairs(bgIds) do
    local btn = Instance.new("ImageButton")
    btn.ZIndex = 22
    btn.LayoutOrder = i
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.BackgroundTransparency = 0.1
    btn.Image = id
    btn.ScaleType = Enum.ScaleType.Crop
    btn.AutoButtonColor = false
    btn.Parent = BackgroundGrid
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(120, 120, 130)
    s.Transparency = 0.1
    s.Parent = btn
    btn.MouseButton1Click:Connect(function()
        CurrentBG = id
        SpaceBackground.Image = id
        BackgroundPicker.Visible = false
        saveConfig()
    end)
end

-- ====== LOGIC ======
local function setToggle(knob, bg, enabled)
    TweenService:Create(knob, TweenInfo.new(0.15), {
        Position = enabled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = enabled and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255),
    }):Play()
    TweenService:Create(bg, TweenInfo.new(0.15), {
        BackgroundColor3 = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(52, 52, 58),
    }):Play()
end

local function updateStatus()
    if InfiniteJumpEnabled then
        StatusValue.Text = "ACTIVE"
        StatusValue.TextColor3 = Color3.fromRGB(80, 255, 100)
        StatusDot.BackgroundColor3 = Color3.fromRGB(80, 255, 100)
    else
        StatusValue.Text = "INACTIVE"
        StatusValue.TextColor3 = Color3.fromRGB(255, 70, 90)
        StatusDot.BackgroundColor3 = Color3.fromRGB(255, 70, 90)
    end
end

local function setInfJump(on)
    InfiniteJumpEnabled = on == true
    setToggle(InfToggleDot, InfToggleBg, InfiniteJumpEnabled)
    updateStatus()
    saveConfig()
end

InfJumpClick.MouseButton1Click:Connect(function()
    setInfJump(not InfiniteJumpEnabled)
end)

KeybindBtn.MouseButton1Click:Connect(function()
    if WaitingForKeybind then return end
    WaitingForKeybind = true
    KeybindBtn.Text = "..."
    KeybindBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if WaitingForKeybind then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            CurrentKeybind = input.KeyCode
            WaitingForKeybind = false
            KeybindBtn.Text = CurrentKeybind.Name
            KeybindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            saveConfig()
        end
        return
    end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == CurrentKeybind then
        setInfJump(not InfiniteJumpEnabled)
    end
end)

BgBtn.MouseButton1Click:Connect(function()
    BackgroundPicker.Visible = not BackgroundPicker.Visible
end)

Close.MouseButton1Click:Connect(function()
    BackgroundPicker.Visible = false
end)

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        ContentHolder.Visible = false
        BgBtn.Visible = false
        BackgroundPicker.Visible = false
        Main.Size = UDim2.new(0, 270, 0, 48)
        MinBtn.Text = "+"
    else
        ContentHolder.Visible = true
        BgBtn.Visible = true
        Main.Size = UDim2.new(0, 270, 0, 200)
        MinBtn.Text = "-"
    end
end)

-- ====== DRAG ======
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ====== INIT ======
startAntiRagdoll()
setToggle(InfToggleDot, InfToggleBg, InfiniteJumpEnabled)
updateStatus()
KeybindBtn.Text = CurrentKeybind.Name

print("[Space X Hook] Loaded ✅")
