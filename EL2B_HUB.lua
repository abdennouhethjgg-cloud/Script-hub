if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end

local Environment = type(getgenv) == "function" and getgenv() or _G

if type(Environment.CursedAntiBatRuntimeCleanup) == "function" then
    pcall(Environment.CursedAntiBatRuntimeCleanup)
end

local Settings = {
    AntiBatEnabled = false,
    AntiBatMode = 1,
    AntiTpBatEnabled = false,
    InfJumpEnabled = false,
    Minimized = false,
    CurrentBackground = "rbxassetid://125478662519277"
}

local Backgrounds = {
    { Name = "Default", Image = "rbxassetid://125478662519277" },
    { Name = "Space 1", Image = "rbxassetid://76835310118322" },
    { Name = "Space 2", Image = "rbxassetid://116973894662847" }
}

local Colors = {
    Main     = Color3.fromRGB(13, 13, 17),
    Panel    = Color3.fromRGB(23, 23, 29),
    Button   = Color3.fromRGB(34, 34, 41),
    Text     = Color3.fromRGB(240, 234, 235),
    Muted    = Color3.fromRGB(168, 161, 170),
    Accent   = Color3.fromRGB(255, 174, 149),
    Inactive = Color3.fromRGB(247, 102, 115),
    Stroke   = Color3.fromRGB(71, 56, 62)
}

local Connections       = {}
local Snapshots         = {}
local LastTriggers      = {}
local ActiveThreats     = {}
local ProtectedParts    = {}
local HookedJumpButtons = setmetatable({}, { __mode = "k" })
local Dead              = false
local AntiBatConnection
local MassShield
local MassShieldCharacter
local ScreenGui, Main, Picker, BackgroundImage
local StatusDot, StatusText
local ModeOneButton, ModeTwoButton, Content, MinimizeButton
local JumpHeld = false
local Busy     = false
local ScanTime = 0

-- FIX #1 : ne pas écraser l'état d'un autre script
local SpoofState = Environment.CursedAntiDropState
if type(SpoofState) ~= "table" then
    SpoofState = {}
    Environment.CursedAntiDropState = SpoofState
end
if type(SpoofState.enabled) ~= "boolean" then
    SpoofState.enabled = false
end
if typeof(SpoofState.spoofedVelocity) ~= "Vector3" then
    SpoofState.spoofedVelocity = Vector3.zero
end

local function Connect(Signal, Callback)
    local Connection = Signal:Connect(Callback)
    Connections[#Connections + 1] = Connection
    return Connection
end

local function New(ClassName, Properties, Parent)
    local Object = Instance.new(ClassName)
    for Name, Value in pairs(Properties or {}) do
        Object[Name] = Value
    end
    if Parent then Object.Parent = Parent end
    return Object
end

local function Corner(Parent, Radius)
    return New("UICorner", { CornerRadius = UDim.new(0, Radius or 8) }, Parent)
end

local function Stroke(Parent, Transparency)
    return New("UIStroke", { Color = Colors.Stroke, Thickness = 1, Transparency = Transparency or 0.2 }, Parent)
end

local function Label(Parent, Value, Position, Size, FontSize, Bold)
    return New("TextLabel", {
        BackgroundTransparency = 1, Text = Value, Position = Position, Size = Size,
        Font = Bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextSize = FontSize or 12, TextColor3 = Colors.Text,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6
    }, Parent)
end

local function Button(Parent, Value, Position, Size, FontSize)
    local Object = New("TextButton", {
        Text = Value, Position = Position, Size = Size,
        BackgroundColor3 = Colors.Button, BorderSizePixel = 0,
        AutoButtonColor = false, TextColor3 = Colors.Text,
        TextSize = FontSize or 11, Font = Enum.Font.GothamBold, ZIndex = 8
    }, Parent)
    Corner(Object, 6)
    return Object
end

local function Animate(Object, Properties, Duration)
    TweenService:Create(Object, TweenInfo.new(Duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), Properties):Play()
end

local function GetCharacter()
    local Character = LocalPlayer.Character
    if not Character then return nil end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local Root     = Character:FindFirstChild("HumanoidRootPart")
    if not Humanoid or not Root or Humanoid.Health <= 0 then return nil end
    return Character, Humanoid, Root
end

local function IsOwnRoot(Object)
    local Character = LocalPlayer.Character
    return Character ~= nil and typeof(Object) == "Instance"
        and Object:IsA("BasePart")
        and Object.Name == "HumanoidRootPart"
        and Object:IsDescendantOf(Character)
end

-- FIX #2 : suppression de "installed" incohérent
local function InstallVelocitySpoof()
    if type(hookmetamethod) ~= "function" or type(newcclosure) ~= "function" or type(checkcaller) ~= "function" then
        return false
    end

    if not SpoofState.IndexInstalled then
        local OldIndex
        local Success, Previous = pcall(function()
            return hookmetamethod(game, "__index", newcclosure(function(Object, Key)
                if SpoofState.enabled and not checkcaller()
                    and (Key == "Velocity" or Key == "AssemblyLinearVelocity")
                    and IsOwnRoot(Object) then
                    return SpoofState.spoofedVelocity
                end
                return OldIndex(Object, Key)
            end))
        end)
        if Success and type(Previous) == "function" then
            OldIndex = Previous
            SpoofState.IndexInstalled = true
        end
    end

    if not SpoofState.NewIndexInstalled then
        local OldNewIndex
        local Success, Previous = pcall(function()
            return hookmetamethod(game, "__newindex", newcclosure(function(Object, Key, Value)
                if SpoofState.enabled and not checkcaller()
                    and (Key == "Velocity" or Key == "AssemblyLinearVelocity")
                    and IsOwnRoot(Object) and typeof(Value) == "Vector3" then
                    SpoofState.spoofedVelocity = Value
                    return
                end
                return OldNewIndex(Object, Key, Value)
            end))
        end)
        if Success and type(Previous) == "function" then
            OldNewIndex = Previous
            SpoofState.NewIndexInstalled = true
        end
    end

    return SpoofState.IndexInstalled == true or SpoofState.NewIndexInstalled == true
end

local function UpdateSpoof(Humanoid, Root)
    if not SpoofState.enabled then return end
    local Direction = Humanoid.MoveDirection
    local Vertical  = Root.AssemblyLinearVelocity.Y
    if Direction.Magnitude > 0.05 then
        SpoofState.spoofedVelocity = Vector3.new(Direction.X * 16, Vertical, Direction.Z * 16)
    else
        SpoofState.spoofedVelocity = Vector3.new(0, Vertical, 0)
    end
end

local function DestroyMassShield()
    if MassShield then
        MassShield:Destroy()
        MassShield = nil
    end
    MassShieldCharacter = nil
end

local function EnsureMassShield(Character, Root)
    if MassShield and MassShield.Parent == Character and MassShieldCharacter == Character then
        return
    end
    DestroyMassShield()
    local Model = New("Model", { Name = "CursedV2MassShield" }, Character)
    for Index = 1, 6 do
        local Part = New("Part", {
            Name = "Mass" .. Index,
            Size = Vector3.new(0.6, 0.6, 0.6),
            Transparency = 1, Anchored = false, Massless = false,
            CanCollide = false, CanTouch = false, CanQuery = false, CastShadow = false,
            CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0, 100, 100),
            CFrame = Root.CFrame
        }, Model)
        New("WeldConstraint", { Part0 = Root, Part1 = Part }, Part)
    end
    MassShield = Model
    MassShieldCharacter = Character
end

local function StopAntiBat()
    if AntiBatConnection then
        AntiBatConnection:Disconnect()
        AntiBatConnection = nil
    end
    Busy = false
    DestroyMassShield()
end

local function StartAntiBat()
    StopAntiBat()
    if not Settings.AntiBatEnabled then return end

    AntiBatConnection = Connect(RunService.Heartbeat, function()
        if Dead or Busy or not Settings.AntiBatEnabled then return end

        local Character, Humanoid, Root = GetCharacter()
        if not Character then
            DestroyMassShield()
            return
        end

        if Settings.AntiBatMode == 2 then
            EnsureMassShield(Character, Root)
        end

        UpdateSpoof(Humanoid, Root)

        if Humanoid.MoveDirection.Magnitude <= 0.05 then return end

        -- FIX #3 : pcall pour garantir la remise à zéro de Busy
        Busy = true
        local Mode = Settings.AntiBatMode
        local Velocity = Root.AssemblyLinearVelocity
        local Scale = Mode == 1 and 50 or 60

        local ok = pcall(function()
            Root.AssemblyLinearVelocity = Vector3.new(Velocity.X * Scale, Mode == 1 and 50 or 55, Velocity.Z * Scale)
        end)

        if ok then
            pcall(function() RunService.RenderStepped:Wait() end)
            if not Dead and Settings.AntiBatEnabled and Settings.AntiBatMode == Mode and Root.Parent then
                pcall(function()
                    Root.AssemblyLinearVelocity = Velocity + Vector3.new(0, Mode == 1 and 0.1 or 0.05, 0)
                end)
            end
        end
        Busy = false
    end)
end

local function HasBat(Player)
    local Character = Player.Character
    local Backpack  = Player:FindFirstChildOfClass("Backpack")
    for _, Container in ipairs({ Character, Backpack }) do
        if Container then
            for _, Item in ipairs(Container:GetChildren()) do
                if Item:IsA("Tool") and string.find(string.lower(Item.Name), "bat", 1, true) then
                    return true
                end
            end
        end
    end
    return false
end

local function RestorePart(Part, Original)
    if Part and Part.Parent then
        pcall(function()
            Part.CanTouch   = Original.CanTouch
            Part.CanCollide = Original.CanCollide
            Part.CanQuery   = Original.CanQuery
        end)
    end
end

local function RestoreAllParts()
    for Part, Original in pairs(ProtectedParts) do
        RestorePart(Part, Original)
        ProtectedParts[Part] = nil
    end
end

local function ProtectPart(Part, IsTool, Desired)
    if not Part or not Part:IsA("BasePart") then return end
    Desired[Part] = IsTool or Desired[Part] or false
    if not ProtectedParts[Part] then
        ProtectedParts[Part] = {
            CanTouch   = Part.CanTouch,
            CanCollide = Part.CanCollide,
            CanQuery   = Part.CanQuery
        }
    end
    pcall(function()
        Part.CanTouch = false
        if IsTool then
            Part.CanCollide = false
            Part.CanQuery   = false
        end
    end)
end

local function ApplyThreatProtection(Now)
    local Desired   = {}
    local AnyThreat = false

    for Player, Expiry in pairs(ActiveThreats) do
        if Expiry <= Now or Player.Parent ~= Players then
            ActiveThreats[Player] = nil
        else
            AnyThreat = true
            local Character = Player.Character
            if Character then
                for _, Object in ipairs(Character:GetDescendants()) do
                    if Object:IsA("BasePart") and Object:FindFirstAncestorOfClass("Tool") then
                        ProtectPart(Object, true, Desired)
                    end
                end
            end
        end
    end

    if AnyThreat then
        local Character = LocalPlayer.Character
        if Character then
            for _, Object in ipairs(Character:GetDescendants()) do
                if Object:IsA("BasePart") then
                    ProtectPart(Object, false, Desired)
                end
            end
        end
    end

    for Part, Original in pairs(ProtectedParts) do
        if Desired[Part] == nil then
            RestorePart(Part, Original)
            ProtectedParts[Part] = nil
        end
    end
end

local function ScanThreats(Now)
    local Character, Humanoid, Root = GetCharacter()
    if not Character then return end
    local Position = Root.Position

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local OtherCharacter = Player.Character
            local OtherRoot      = OtherCharacter and OtherCharacter:FindFirstChild("HumanoidRootPart")
            local OtherHumanoid  = OtherCharacter and OtherCharacter:FindFirstChildOfClass("Humanoid")
            if OtherRoot and OtherHumanoid and OtherHumanoid.Health > 0 then
                local OtherPosition = OtherRoot.Position
                local Distance  = (Position - OtherPosition).Magnitude
                local Snapshot  = Snapshots[Player]
                local Dangerous = Distance <= 22 or (Distance <= 60 and HasBat(Player))

                if Snapshot and Now - Snapshot.Time <= 0.4 and Now > Snapshot.Time then
                    if (OtherPosition - Snapshot.Position).Magnitude >= 26 and Distance <= 60 then
                        Dangerous = true
                    end
                end

                Snapshots[Player] = { Position = OtherPosition, Time = Now }

                if Dangerous and (not LastTriggers[Player] or Now - LastTriggers[Player] >= 0.08) then
                    LastTriggers[Player] = Now
                    ActiveThreats[Player] = Now + 0.38
                end
            else
                Snapshots[Player] = nil
            end
        end
    end
end

local function SetAntiBat(Enabled)
    Settings.AntiBatEnabled = Enabled
    SpoofState.enabled      = Enabled
    if Enabled then
        pcall(InstallVelocitySpoof)
    else
        SpoofState.spoofedVelocity = Vector3.zero
    end
    StartAntiBat()
end

local function SetAntiTpBat(Enabled)
    Settings.AntiTpBatEnabled = Enabled
    if not Enabled then
        table.clear(ActiveThreats)
        table.clear(LastTriggers)
        table.clear(Snapshots)
        RestoreAllParts()
    end
end

local function SetInfJump(Enabled)
    Settings.InfJumpEnabled = Enabled
    if not Enabled then JumpHeld = false end
end

local function CreateSwitch(Parent, Top, Title)
    local Row = New("Frame", {
        Position = UDim2.fromOffset(12, Top),
        Size = UDim2.new(1, -24, 0, 44),
        BackgroundColor3 = Colors.Panel, BackgroundTransparency = 0.12,
        BorderSizePixel = 0, ZIndex = 4
    }, Parent)
    Corner(Row, 8)
    Label(Row, Title, UDim2.fromOffset(12, 10), UDim2.fromOffset(146, 24), 12, false)

    local Track = New("Frame", {
        Position = UDim2.new(1, -60, 0.5, -11),
        Size = UDim2.fromOffset(44, 22),
        BackgroundColor3 = Colors.Button, BorderSizePixel = 0, ZIndex = 6
    }, Row)
    Corner(Track, 11)

    local Dot = New("Frame", {
        Position = UDim2.fromOffset(3, 3),
        Size = UDim2.fromOffset(16, 16),
        BackgroundColor3 = Colors.Text, BorderSizePixel = 0, ZIndex = 7
    }, Track)
    Corner(Dot, 10)

    local Trigger = Button(Row, "", UDim2.new(1, -66, 0, 0), UDim2.fromOffset(56, 44))
    Trigger.BackgroundTransparency = 1

    local function SetValue(Enabled)
        Animate(Track, { BackgroundColor3 = Enabled and Colors.Accent or Colors.Button })
        Animate(Dot, { Position = UDim2.fromOffset(Enabled and 25 or 3, 3) })
    end
    return Row, Trigger, SetValue
end

local function BuildGui()
    local GuiParent
    if type(gethui) == "function" then
        local Success, Parent = pcall(gethui)
        if Success and typeof(Parent) == "Instance" then GuiParent = Parent end
    end
    if not GuiParent then GuiParent = game:GetService("CoreGui") end

    ScreenGui = New("ScreenGui", {
        Name = "Cursed Hub Anti Bat",
        ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 200
    })
    local Success = pcall(function() ScreenGui.Parent = GuiParent end)
    if not Success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    for _, Object in ipairs(ScreenGui.Parent:GetChildren()) do
        if Object ~= ScreenGui and Object.Name == ScreenGui.Name then
            Object:Destroy()
        end
    end

    Main = New("Frame", {
        Name = "Main", AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(300, 280),
        BackgroundColor3 = Colors.Main, BorderSizePixel = 0,
        ClipsDescendants = true, Active = true
    }, ScreenGui)
    Corner(Main, 14)
    Stroke(Main, 0.05)

    BackgroundImage = New("ImageLabel", {
        Name = "Background", Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1, Image = Settings.CurrentBackground,
        ImageTransparency = 0.66, ScaleType = Enum.ScaleType.Crop, ZIndex = 1
    }, Main)
    Corner(BackgroundImage, 14)

    local Dim = New("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = Colors.Main,
        BackgroundTransparency = 0.26, BorderSizePixel = 0, ZIndex = 2
    }, Main)
    Corner(Dim, 14)

    local Header = New("Frame", {
        Name = "Header", Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1, Active = true, ZIndex = 5
    }, Main)

    local HeaderIcon = New("Frame", {
        Position = UDim2.fromOffset(14, 15), Size = UDim2.fromOffset(10, 10),
        BackgroundColor3 = Colors.Accent, BorderSizePixel = 0, ZIndex = 6
    }, Header)
    Corner(HeaderIcon, 10)

    Label(Header, "ANTI BAT", UDim2.fromOffset(33, 7), UDim2.fromOffset(160, 20), 13, true)
    local Subtitle = Label(Header, "Cursed Hub Anti Bat", UDim2.fromOffset(33, 27), UDim2.fromOffset(175, 14), 9, false)
    Subtitle.TextColor3 = Colors.Muted

    local BackgroundButton = Button(Header, "BG", UDim2.new(1, -78, 0, 12), UDim2.fromOffset(42, 26), 10)
    local Minimize = Button(Header, "−", UDim2.new(1, -32, 0, 12), UDim2.fromOffset(24, 26), 16)
    MinimizeButton = Minimize

    Content = New("Frame", {
        Name = "Content", Position = UDim2.fromOffset(0, 50),
        Size = UDim2.new(1, 0, 1, -50), BackgroundTransparency = 1, ZIndex = 4
    }, Main)

    local StatusRow = New("Frame", {
        Position = UDim2.fromOffset(12, 2), Size = UDim2.new(1, -24, 0, 36),
        BackgroundColor3 = Colors.Panel, BackgroundTransparency = 0.12,
        BorderSizePixel = 0, ZIndex = 4
    }, Content)
    Corner(StatusRow, 7)

    StatusDot = New("Frame", {
        Position = UDim2.fromOffset(14, 14), Size = UDim2.fromOffset(8, 8),
        BackgroundColor3 = Colors.Inactive, BorderSizePixel = 0, ZIndex = 6
    }, StatusRow)
    Corner(StatusDot, 8)

    Label(StatusRow, "Status", UDim2.fromOffset(33, 8), UDim2.fromOffset(100, 20), 11, false)
    StatusText = Label(StatusRow, "INACTIVE", UDim2.new(1, -112, 0, 8), UDim2.fromOffset(98, 20), 11, true)
    StatusText.TextColor3 = Colors.Inactive
    StatusText.TextXAlignment = Enum.TextXAlignment.Right

    local AntiBatRow, AntiBatTrigger, UpdateAntiBat = CreateSwitch(Content, 45, "Anti Bat")
    local AntiTpRow,  AntiTpTrigger,  UpdateAntiTp  = CreateSwitch(Content, 96, "Anti TP Bat")
    local InfJumpRow, InfJumpTrigger, UpdateInfJump = CreateSwitch(Content, 147, "Infinite Jump")

    ModeOneButton = Button(AntiBatRow, "V1", UDim2.new(1, -132, 0.5, -10), UDim2.fromOffset(26, 20), 10)
    ModeTwoButton = Button(AntiBatRow, "V2", UDim2.new(1, -103, 0.5, -10), UDim2.fromOffset(26, 20), 10)

    local Footer = Label(Content, "F2  •  Show / Hide", UDim2.fromOffset(14, 198), UDim2.new(1, -28, 0, 19), 10, false)
    Footer.TextColor3 = Colors.Muted

    Picker = New("Frame", {
        Name = "BackgroundPicker", AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(290, 176),
        BackgroundColor3 = Colors.Main, Visible = false,
        BorderSizePixel = 0, ZIndex = 20
    }, ScreenGui)
    Corner(Picker, 12)
    Stroke(Picker, 0)

    local PickerTitle = Label(Picker, "Change Background", UDim2.fromOffset(12, 9), UDim2.fromOffset(220, 28), 14, true)
    PickerTitle.ZIndex = 22
    local ClosePicker = Button(Picker, "×", UDim2.new(1, -34, 0, 9), UDim2.fromOffset(26, 26), 18)
    ClosePicker.ZIndex = 23

    for Index, Background in ipairs(Backgrounds) do
        local X = 10 + (Index - 1) * 94
        local ImageButton = New("ImageButton", {
            Name = Background.Name, Position = UDim2.fromOffset(X, 48),
            Size = UDim2.fromOffset(82, 86), BackgroundColor3 = Colors.Panel,
            BorderSizePixel = 0, Image = Background.Image,
            ScaleType = Enum.ScaleType.Crop, AutoButtonColor = false, ZIndex = 22
        }, Picker)
        Corner(ImageButton, 8)
        Stroke(ImageButton, 0.1)
        local BackgroundTitle = Label(Picker, Background.Name, UDim2.fromOffset(X, 138), UDim2.fromOffset(82, 22), 11, false)
        BackgroundTitle.ZIndex = 22
        BackgroundTitle.TextXAlignment = Enum.TextXAlignment.Center
        Connect(ImageButton.MouseButton1Click, function()
            Settings.CurrentBackground = Background.Image
            BackgroundImage.Image = Background.Image
            Picker.Visible = false
        end)
    end

    local function UpdateStatus()
        local Active = Settings.AntiBatEnabled or Settings.AntiTpBatEnabled or Settings.InfJumpEnabled
        local Color  = Active and Colors.Accent or Colors.Inactive
        StatusText.Text       = Active and "ACTIVE" or "INACTIVE"
        StatusText.TextColor3 = Color
        StatusDot.BackgroundColor3 = Color
    end

    local function UpdateModes()
        ModeOneButton.BackgroundColor3 = Settings.AntiBatMode == 1 and Colors.Accent or Colors.Button
        ModeTwoButton.BackgroundColor3 = Settings.AntiBatMode == 2 and Colors.Accent or Colors.Button
        ModeOneButton.TextColor3 = Settings.AntiBatMode == 1 and Colors.Main or Colors.Text
        ModeTwoButton.TextColor3 = Settings.AntiBatMode == 2 and Colors.Main or Colors.Text
    end

    Connect(AntiBatTrigger.MouseButton1Click, function()
        SetAntiBat(not Settings.AntiBatEnabled)
        UpdateAntiBat(Settings.AntiBatEnabled)
        UpdateStatus()
    end)

    Connect(ModeOneButton.MouseButton1Click, function()
        Settings.AntiBatMode = 1
        DestroyMassShield() -- FIX #4
        UpdateModes()
        StartAntiBat()
    end)

    Connect(ModeTwoButton.MouseButton1Click, function()
        Settings.AntiBatMode = 2
        UpdateModes()
        StartAntiBat()
    end)

    Connect(AntiTpTrigger.MouseButton1Click, function()
        SetAntiTpBat(not Settings.AntiTpBatEnabled)
        UpdateAntiTp(Settings.AntiTpBatEnabled)
        UpdateStatus()
    end)

    Connect(InfJumpTrigger.MouseButton1Click, function()
        SetInfJump(not Settings.InfJumpEnabled)
        UpdateInfJump(Settings.InfJumpEnabled)
        UpdateStatus()
    end)

    Connect(BackgroundButton.MouseButton1Click, function()
        Picker.Visible = not Picker.Visible
    end)

    Connect(ClosePicker.MouseButton1Click, function()
        Picker.Visible = false
    end)

    Connect(Minimize.MouseButton1Click, function()
        Settings.Minimized = not Settings.Minimized
        Content.Visible = not Settings.Minimized
        Picker.Visible  = false
        Main.Size = UDim2.fromOffset(300, Settings.Minimized and 50 or 280)
        MinimizeButton.Text = Settings.Minimized and "+" or "−"
    end)

    -- FIX #5 : drag sans fuite de connexion
    local Dragging     = false
    local DragInput    = nil
    local DragStart    = nil
    local DragPosition = nil

    Connect(Header.InputBegan, function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging     = true
            DragStart    = Input.Position
            DragPosition = Main.Position
        end
    end)

    Connect(UserInputService.InputEnded, function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)

    Connect(Header.InputChanged, function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement
            or Input.UserInputType == Enum.UserInputType.Touch then
            DragInput = Input
        end
    end)

    Connect(UserInputService.InputChanged, function(Input)
        if Dragging and Input == DragInput and DragStart and DragPosition then
            local Delta = Input.Position - DragStart
            Main.Position = UDim2.new(
                DragPosition.X.Scale, DragPosition.X.Offset + Delta.X,
                DragPosition.Y.Scale, DragPosition.Y.Offset + Delta.Y
            )
        end
    end)

    Connect(UserInputService.InputBegan, function(Input, GameProcessed)
        if not GameProcessed and Input.KeyCode == Enum.KeyCode.F2 then
            Main.Visible   = not Main.Visible
            Picker.Visible = false
        end
        if Input.KeyCode == Enum.KeyCode.Space then
            JumpHeld = true
        end
    end)

    Connect(UserInputService.InputEnded, function(Input)
        if Input.KeyCode == Enum.KeyCode.Space then
            JumpHeld = false
        end
    end)

    -- FIX #6 : utiliser les Settings au lieu de false codé en dur
    UpdateAntiBat(Settings.AntiBatEnabled)
    UpdateAntiTp(Settings.AntiTpBatEnabled)
    UpdateInfJump(Settings.InfJumpEnabled)
    UpdateModes()
    UpdateStatus()
end

local function BindJumpButton(Object)
    if not Object:IsA("GuiButton") or Object.Name ~= "JumpButton" or HookedJumpButtons[Object] then
        return
    end
    HookedJumpButtons[Object] = true
    Connect(Object.MouseButton1Down, function() JumpHeld = true  end)
    Connect(Object.MouseButton1Up,   function() JumpHeld = false end)
    Connect(Object.MouseLeave,       function() JumpHeld = false end)
end

local function Cleanup()
    if Dead then return end
    Dead = true
    Settings.AntiBatEnabled = false
    Settings.AntiTpBatEnabled = false
    Settings.InfJumpEnabled = false
    SpoofState.enabled = false
    SpoofState.spoofedVelocity = Vector3.zero
    StopAntiBat()
    RestoreAllParts()
    for _, Connection in ipairs(Connections) do
        pcall(function() Connection:Disconnect() end)
    end
    table.clear(Connections)
    -- FIX #8 : nettoyer les boutons saut hookés
    for Object in pairs(HookedJumpButtons) do
        HookedJumpButtons[Object] = nil
    end
    if ScreenGui then ScreenGui:Destroy() ScreenGui = nil end
    if Environment.CursedAntiBatRuntimeCleanup == Cleanup then
        Environment.CursedAntiBatRuntimeCleanup = nil
    end
end

Environment.CursedAntiBatRuntimeCleanup = Cleanup

BuildGui()

Connect(Players.PlayerRemoving, function(Player)
    Snapshots[Player]    = nil
    LastTriggers[Player] = nil
    ActiveThreats[Player] = nil
end)

Connect(LocalPlayer.CharacterAdded, function()
    Busy = false
    DestroyMassShield()
    RestoreAllParts()
end)

Connect(RunService.PreSimulation, function()
    if Dead or not Settings.AntiTpBatEnabled then return end
    local Now = time()
    if Now - ScanTime >= 0.045 then
        ScanTime = Now
        ScanThreats(Now)
    end
    ApplyThreatProtection(Now)
end)

Connect(RunService.Heartbeat, function()
    if Dead or not Settings.InfJumpEnabled then return end
    local Character, Humanoid, Root = GetCharacter()
    if not Character then return end
    local Holding  = JumpHeld or UserInputService:IsKeyDown(Enum.KeyCode.Space) or Humanoid.Jump
    local Velocity = Root.AssemblyLinearVelocity
    if Holding and Velocity.Y < 40 then
        Root.AssemblyLinearVelocity = Vector3.new(Velocity.X, 55, Velocity.Z)
    elseif Velocity.Y < -120 then
        Root.AssemblyLinearVelocity = Vector3.new(Velocity.X, -120, Velocity.Z)
    end
end)

Connect(UserInputService.JumpRequest, function()
    if not Settings.InfJumpEnabled then return end
    local Character, Humanoid, Root = GetCharacter()
    if Character then
        local Velocity = Root.AssemblyLinearVelocity
        Root.AssemblyLinearVelocity = Vector3.new(Velocity.X, 55, Velocity.Z)
    end
end)

task.defer(function()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
    if Dead or not PlayerGui then return end
    for _, Object in ipairs(PlayerGui:GetDescendants()) do
        BindJumpButton(Object)
    end
    Connect(PlayerGui.DescendantAdded, BindJumpButton)
end)

-- FIX #10 : loadstring distant retiré (URL inexistante + risque de dropper)
-- Si tu veux vraiment charger du code distant, utilise ton propre hébergement et vérifie le contenu.
