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

----------------------------------------------------------------
-- SETTINGS
----------------------------------------------------------------
local Settings = {
    AntiBatEnabled = false,
    AntiBatMode = 1,
    AntiTpBatEnabled = false,
    InfJumpEnabled = false,
    PingLaggerEnabled = false,
    Minimized = false,
    CurrentBackground = "rbxassetid://125478662519277",
    LagPower = 100000,
    LagInterval = 0.125,
}

local Backgrounds = {
    { Name = "Default", Image = "rbxassetid://125478662519277" },
    { Name = "Space 1", Image = "rbxassetid://76835310118322" },
    { Name = "Space 2", Image = "rbxassetid://116973894662847" }
}

local Colors = {
    Main = Color3.fromRGB(13, 13, 17),
    Panel = Color3.fromRGB(23, 23, 29),
    Button = Color3.fromRGB(34, 34, 41),
    Text = Color3.fromRGB(240, 234, 235),
    Muted = Color3.fromRGB(168, 161, 170),
    Accent = Color3.fromRGB(255, 174, 149),
    Inactive = Color3.fromRGB(247, 102, 115),
    Stroke = Color3.fromRGB(71, 56, 62),
    Green = Color3.fromRGB(90, 230, 140),
}

----------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------
local Connections = {}
local Snapshots = {}
local LastTriggers = {}
local ActiveThreats = {}
local ProtectedParts = {}
local HookedJumpButtons = setmetatable({}, { __mode = "k" })
local Dead = false
local AntiBatConnection
local MassShield
local MassShieldCharacter
local ScreenGui, Main, Picker, BackgroundImage
local StatusDot, StatusText
local ModeOneButton, ModeTwoButton, Content, MinimizeButton
local JumpHeld = false
local Busy = false
local ScanTime = 0

-- Ping Lagger
local LagRemote = nil
local LagThread = nil
local LagActive = false

local SpoofState = Environment.CursedAntiDropState
if type(SpoofState) \~= "table" then
    SpoofState = {}
    Environment.CursedAntiDropState = SpoofState
end
SpoofState.enabled = false
SpoofState.spoofedVelocity = Vector3.zero
SpoofState.IndexInstalled = SpoofState.IndexInstalled or false
SpoofState.NewIndexInstalled = SpoofState.NewIndexInstalled or false

----------------------------------------------------------------
-- UTILS
----------------------------------------------------------------
local function Connect(Signal, Callback)
    local c = Signal:Connect(Callback)
    table.insert(Connections, c)
    return c
end

local function New(Class, Props, Parent)
    local obj = Instance.new(Class)
    for k, v in pairs(Props or {}) do
        obj[k] = v
    end
    if Parent then obj.Parent = Parent end
    return obj
end

local function Corner(p, r)
    return New("UICorner", { CornerRadius = UDim.new(0, r or 8) }, p)
end

local function Stroke(p, t)
    return New("UIStroke", {
        Color = Colors.Stroke,
        Thickness = 1,
        Transparency = t or 0.2
    }, p)
end

local function Label(p, text, pos, size, fs, bold)
    return New("TextLabel", {
        BackgroundTransparency = 1,
        Text = text,
        Position = pos,
        Size = size,
        Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextSize = fs or 12,
        TextColor3 = Colors.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6
    }, p)
end

local function Button(p, text, pos, size, fs)
    local b = New("TextButton", {
        Text = text,
        Position = pos,
        Size = size,
        BackgroundColor3 = Colors.Button,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        TextColor3 = Colors.Text,
        TextSize = fs or 11,
        Font = Enum.Font.GothamBold,
        ZIndex = 8
    }, p)
    Corner(b, 6)
    return b
end

local function Animate(obj, props, dur)
    TweenService:Create(obj, TweenInfo.new(dur or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function GetCharacter()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return nil end
    return char, hum, root
end

local function IsOwnRoot(obj)
    local char = LocalPlayer.Character
    return char and typeof(obj) == "Instance" and obj:IsA("BasePart")
        and obj.Name == "HumanoidRootPart" and obj:IsDescendantOf(char)
end

----------------------------------------------------------------
-- VELOCITY SPOOF
----------------------------------------------------------------
local function InstallVelocitySpoof()
    if type(hookmetamethod) \~= "function" or type(newcclosure) \~= "function" or type(checkcaller) \~= "function" then
        return false
    end

    if not SpoofState.IndexInstalled then
        local old
        local ok, prev = pcall(function()
            return hookmetamethod(game, "__index", newcclosure(function(obj, key)
                if SpoofState.enabled and not checkcaller()
                    and (key == "Velocity" or key == "AssemblyLinearVelocity")
                    and IsOwnRoot(obj) then
                    return SpoofState.spoofedVelocity
                end
                return old(obj, key)
            end))
        end)
        if ok and type(prev) == "function" then
            old = prev
            SpoofState.IndexInstalled = true
        end
    end

    if not SpoofState.NewIndexInstalled then
        local old
        local ok, prev = pcall(function()
            return hookmetamethod(game, "__newindex", newcclosure(function(obj, key, val)
                if SpoofState.enabled and not checkcaller()
                    and (key == "Velocity" or key == "AssemblyLinearVelocity")
                    and IsOwnRoot(obj) and typeof(val) == "Vector3" then
                    SpoofState.spoofedVelocity = val
                    return
                end
                return old(obj, key, val)
            end))
        end)
        if ok and type(prev) == "function" then
            old = prev
            SpoofState.NewIndexInstalled = true
        end
    end

    return SpoofState.IndexInstalled or SpoofState.NewIndexInstalled
end

local function UpdateSpoof(hum, root)
    if not SpoofState.enabled then return end
    local dir = hum.MoveDirection
    local y = root.AssemblyLinearVelocity.Y
    if dir.Magnitude > 0.05 then
        SpoofState.spoofedVelocity = Vector3.new(dir.X * 16, y, dir.Z * 16)
    else
        SpoofState.spoofedVelocity = Vector3.new(0, y, 0)
    end
end

----------------------------------------------------------------
-- MASS SHIELD
----------------------------------------------------------------
local function DestroyMassShield()
    if MassShield then
        MassShield:Destroy()
        MassShield = nil
    end
    MassShieldCharacter = nil
end

local function EnsureMassShield(char, root)
    if MassShield and MassShield.Parent == char and MassShieldCharacter == char then return end
    DestroyMassShield()
    local model = New("Model", { Name = "CursedV2MassShield" }, char)
    for i = 1, 6 do
        local part = New("Part", {
            Name = "Mass" .. i,
            Size = Vector3.new(0.6, 0.6, 0.6),
            Transparency = 1,
            Anchored = false,
            Massless = false,
            CanCollide = false,
            CanTouch = false,
            CanQuery = false,
            CastShadow = false,
            CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0, 100, 100),
            CFrame = root.CFrame
        }, model)
        New("WeldConstraint", { Part0 = root, Part1 = part }, part)
    end
    MassShield = model
    MassShieldCharacter = char
end

----------------------------------------------------------------
-- ANTI BAT
----------------------------------------------------------------
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
        local char, hum, root = GetCharacter()
        if not char then
            DestroyMassShield()
            return
        end

        if Settings.AntiBatMode == 2 then
            EnsureMassShield(char, root)
        end
        UpdateSpoof(hum, root)

        if hum.MoveDirection.Magnitude <= 0.05 then return end

        Busy = true
        local mode = Settings.AntiBatMode
        local vel = root.AssemblyLinearVelocity
        local scale = mode == 1 and 50 or 60
        root.AssemblyLinearVelocity = Vector3.new(vel.X * scale, mode == 1 and 50 or 55, vel.Z * scale)
        RunService.RenderStepped:Wait()
        if not Dead and Settings.AntiBatEnabled and Settings.AntiBatMode == mode and root.Parent then
            root.AssemblyLinearVelocity = vel + Vector3.new(0, mode == 1 and 0.1 or 0.05, 0)
        end
        Busy = false
    end)
end

----------------------------------------------------------------
-- ANTI TP BAT
----------------------------------------------------------------
local function HasBat(plr)
    local char = plr.Character
    local bp = plr:FindFirstChildOfClass("Backpack")
    for _, container in ipairs({ char, bp }) do
        if container then
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") and string.find(string.lower(item.Name), "bat", 1, true) then
                    return true
                end
            end
        end
    end
    return false
end

local function RestorePart(part, original)
    if part and part.Parent then
        pcall(function()
            part.CanTouch = original.CanTouch
            part.CanCollide = original.CanCollide
            part.CanQuery = original.CanQuery
        end)
    end
end

local function RestoreAllParts()
    for part, original in pairs(ProtectedParts) do
        RestorePart(part, original)
        ProtectedParts[part] = nil
    end
end

local function ProtectPart(part, isTool, desired)
    if not part or not part:IsA("BasePart") then return end
    desired[part] = isTool or desired[part] or false
    if not ProtectedParts[part] then
        ProtectedParts[part] = {
            CanTouch = part.CanTouch,
            CanCollide = part.CanCollide,
            CanQuery = part.CanQuery
        }
    end
    pcall(function()
        part.CanTouch = false
        if isTool then
            part.CanCollide = false
            part.CanQuery = false
        end
    end)
end

local function ApplyThreatProtection(now)
    local desired = {}
    local any = false

    for plr, expiry in pairs(ActiveThreats) do
        if expiry <= now or plr.Parent \~= Players then
            ActiveThreats[plr] = nil
        else
            any = true
            local char = plr.Character
            if char then
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("BasePart") and obj:FindFirstAncestorOfClass("Tool") then
                        ProtectPart(obj, true, desired)
                    end
                end
            end
        end
    end

    if any then
        local char = LocalPlayer.Character
        if char then
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("BasePart") then
                    ProtectPart(obj, false, desired)
                end
            end
        end
    end

    for part, original in pairs(ProtectedParts) do
        if desired[part] == nil then
            RestorePart(part, original)
            ProtectedParts[part] = nil
        end
    end
end

local function ScanThreats(now)
    local char, _, root = GetCharacter()
    if not char then return end
    local pos = root.Position

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer then
            local otherChar = plr.Character
            local otherRoot = otherChar and otherChar:FindFirstChild("HumanoidRootPart")
            local otherHum = otherChar and otherChar:FindFirstChildOfClass("Humanoid")
            if otherRoot and otherHum and otherHum.Health > 0 then
                local otherPos = otherRoot.Position
                local dist = (pos - otherPos).Magnitude
                local snap = Snapshots[plr]
                local dangerous = dist <= 22 or (dist <= 60 and HasBat(plr))

                if snap and now - snap.Time <= 0.4 and now > snap.Time then
                    if (otherPos - snap.Position).Magnitude >= 26 and dist <= 60 then
                        dangerous = true
                    end
                end

                Snapshots[plr] = { Position = otherPos, Time = now }

                if dangerous and (not LastTriggers[plr] or now - LastTriggers[plr] >= 0.08) then
                    LastTriggers[plr] = now
                    ActiveThreats[plr] = now + 0.38
                end
            else
                Snapshots[plr] = nil
            end
        end
    end
end

----------------------------------------------------------------
-- PING LAGGER (from Sunburn + Galaxy)
----------------------------------------------------------------
local function FindLagRemote()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end

    local names = {"SetPlayerBlockList", "UpdatePlayerBlockList", "SetBlockList", "UpdateBlockList"}
    for _, name in ipairs(names) do
        local r = rrs:FindFirstChild(name)
        if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent")) then
            return r
        end
    end
    for _, c in ipairs(rrs:GetChildren()) do
        if (c:IsA("RemoteEvent") or c:IsA("UnreliableRemoteEvent")) and string.find(c.Name, "Block") then
            return c
        end
    end
    return nil
end

local function BuildLagPayload(power)
    local nested = {{}}
    local current = nested[1]
    for _ = 1, 186 do
        local n = {}
        table.insert(current, n)
        current = n
    end
    local mainT = {}
    local maxRep = math.min(math.floor(power / 188), 10000)
    for _ = 1, maxRep do
        table.insert(mainT, nested)
    end
    return mainT
end

local function StopPingLagger()
    LagActive = false
    if LagThread then
        pcall(task.cancel, LagThread)
        LagThread = nil
    end
end

local function StartPingLagger()
    StopPingLagger()
    if not Settings.PingLaggerEnabled then return end

    LagRemote = FindLagRemote()
    if not LagRemote then
        warn("[Cursed] Lag remote not found")
        Settings.PingLaggerEnabled = false
        return
    end

    pcall(function()
        game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
    end)

    LagActive = true
    LagThread = task.spawn(function()
        local delay = Settings.LagInterval
        while LagActive and Settings.PingLaggerEnabled and not Dead do
            local payload = BuildLagPayload(Settings.LagPower)
            local ok = pcall(function()
                LagRemote:FireServer(payload)
            end)
            if not ok then
                delay = math.min(delay * 1.4, 0.5)
            else
                delay = math.max(delay * 0.995, 0.04)
            end
            task.wait(delay)
        end
    end)
end

----------------------------------------------------------------
-- TOGGLES
----------------------------------------------------------------
local function SetAntiBat(enabled)
    Settings.AntiBatEnabled = enabled
    SpoofState.enabled = enabled
    if enabled then
        pcall(InstallVelocitySpoof)
    else
        SpoofState.spoofedVelocity = Vector3.zero
    end
    StartAntiBat()
end

local function SetAntiTpBat(enabled)
    Settings.AntiTpBatEnabled = enabled
    if not enabled then
        table.clear(ActiveThreats)
        table.clear(LastTriggers)
        table.clear(Snapshots)
        RestoreAllParts()
    end
end

local function SetInfJump(enabled)
    Settings.InfJumpEnabled = enabled
    if not enabled then JumpHeld = false end
end

local function SetPingLagger(enabled)
    Settings.PingLaggerEnabled = enabled
    if enabled then
        StartPingLagger()
    else
        StopPingLagger()
    end
end

----------------------------------------------------------------
-- GUI
----------------------------------------------------------------
local function CreateSwitch(parent, top, title)
    local row = New("Frame", {
        Position = UDim2.fromOffset(12, top),
        Size = UDim2.new(1, -24, 0, 40),
        BackgroundColor3 = Colors.Panel,
        BackgroundTransparency = 0.12,
        BorderSizePixel = 0,
        ZIndex = 4
    }, parent)
    Corner(row, 8)
    Label(row, title, UDim2.fromOffset(12, 9), UDim2.fromOffset(140, 22), 12, false)

    local track = New("Frame", {
        Position = UDim2.new(1, -56, 0.5, -10),
        Size = UDim2.fromOffset(40, 20),
        BackgroundColor3 = Colors.Button,
        BorderSizePixel = 0,
        ZIndex = 6
    }, row)
    Corner(track, 10)

    local dot = New("Frame", {
        Position = UDim2.fromOffset(3, 3),
        Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = Colors.Text,
        BorderSizePixel = 0,
        ZIndex = 7
    }, track)
    Corner(dot, 8)

    local trigger = Button(row, "", UDim2.new(1, -62, 0, 0), UDim2.fromOffset(52, 40))
    trigger.BackgroundTransparency = 1

    local function SetValue(on)
        Animate(track, { BackgroundColor3 = on and Colors.Accent or Colors.Button })
        Animate(dot, { Position = UDim2.fromOffset(on and 23 or 3, 3) })
    end
    return row, trigger, SetValue
end

local function BuildGui()
    local guiParent
    if type(gethui) == "function" then
        local ok, p = pcall(gethui)
        if ok and typeof(p) == "Instance" then guiParent = p end
    end
    if not guiParent then
        guiParent = game:GetService("CoreGui")
    end

    ScreenGui = New("ScreenGui", {
        Name = "CursedHub_AntiBat_Lag",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 200
    })

    local ok = pcall(function() ScreenGui.Parent = guiParent end)
    if not ok then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    for _, obj in ipairs(ScreenGui.Parent:GetChildren()) do
        if obj \~= ScreenGui and obj.Name == ScreenGui.Name then
            obj:Destroy()
        end
    end

    Main = New("Frame", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(300, 340),
        BackgroundColor3 = Colors.Main,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Active = true
    }, ScreenGui)
    Corner(Main, 14)
    Stroke(Main, 0.05)

    BackgroundImage = New("ImageLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Image = Settings.CurrentBackground,
        ImageTransparency = 0.66,
        ScaleType = Enum.ScaleType.Crop,
        ZIndex = 1
    }, Main)
    Corner(BackgroundImage, 14)

    local dim = New("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Colors.Main,
        BackgroundTransparency = 0.26,
        BorderSizePixel = 0,
        ZIndex = 2
    }, Main)
    Corner(dim, 14)

    -- Header
    local header = New("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        Active = true,
        ZIndex = 5
    }, Main)

    local icon = New("Frame", {
        Position = UDim2.fromOffset(14, 15),
        Size = UDim2.fromOffset(10, 10),
        BackgroundColor3 = Colors.Accent,
        BorderSizePixel = 0,
        ZIndex = 6
    }, header)
    Corner(icon, 10)

    Label(header, "ANTI BAT + LAG", UDim2.fromOffset(33, 7), UDim2.fromOffset(180, 20), 13, true)
    local sub = Label(header, "Cursed Hub · Fixed + Ping Lagger", UDim2.fromOffset(33, 27), UDim2.fromOffset(200, 14), 9, false)
    sub.TextColor3 = Colors.Muted

    local bgBtn = Button(header, "BG", UDim2.new(1, -78, 0, 12), UDim2.fromOffset(42, 26), 10)
    MinimizeButton = Button(header, "−", UDim2.new(1, -32, 0, 12), UDim2.fromOffset(24, 26), 16)

    Content = New("Frame", {
        Position = UDim2.fromOffset(0, 50),
        Size = UDim2.new(1, 0, 1, -50),
        BackgroundTransparency = 1,
        ZIndex = 4
    }, Main)

    -- Status
    local statusRow = New("Frame", {
        Position = UDim2.fromOffset(12, 4),
        Size = UDim2.new(1, -24, 0, 32),
        BackgroundColor3 = Colors.Panel,
        BackgroundTransparency = 0.12,
        BorderSizePixel = 0,
        ZIndex = 4
    }, Content)
    Corner(statusRow, 7)

    StatusDot = New("Frame", {
        Position = UDim2.fromOffset(12, 12),
        Size = UDim2.fromOffset(8, 8),
        BackgroundColor3 = Colors.Inactive,
        BorderSizePixel = 0,
        ZIndex = 6
    }, statusRow)
    Corner(StatusDot, 8)

    Label(statusRow, "Status", UDim2.fromOffset(28, 6), UDim2.fromOffset(80, 20), 11, false)
    StatusText = Label(statusRow, "INACTIVE", UDim2.new(1, -100, 0, 6), UDim2.fromOffset(88, 20), 11, true)
    StatusText.TextColor3 = Colors.Inactive
    StatusText.TextXAlignment = Enum.TextXAlignment.Right

    -- Switches
    local antiBatRow, antiBatTrigger, updateAntiBat = CreateSwitch(Content, 42, "Anti Bat")
    local antiTpRow, antiTpTrigger, updateAntiTp = CreateSwitch(Content, 88, "Anti TP Bat")
    local infJumpRow, infJumpTrigger, updateInfJump = CreateSwitch(Content, 134, "Infinite Jump")
    local lagRow, lagTrigger, updateLag = CreateSwitch(Content, 180, "Ping Lagger")

    ModeOneButton = Button(antiBatRow, "V1", UDim2.new(1, -120, 0.5, -9), UDim2.fromOffset(26, 18), 10)
    ModeTwoButton = Button(antiBatRow, "V2", UDim2.new(1, -90, 0.5, -9), UDim2.fromOffset(26, 18), 10)

    -- Lag presets
    local presetRow = New("Frame", {
        Position = UDim2.fromOffset(12, 226),
        Size = UDim2.new(1, -24, 0, 28),
        BackgroundTransparency = 1,
        ZIndex = 4
    }, Content)

    local function makePreset(name, power, interval, x)
        local b = Button(presetRow, name, UDim2.fromOffset(x, 0), UDim2.fromOffset(88, 26), 11)
        Connect(b.MouseButton1Click, function()
            Settings.LagPower = power
            Settings.LagInterval = interval
            if Settings.PingLaggerEnabled then
                StartPingLagger() -- restart with new values
            end
        end)
        return b
    end
    makePreset("LOW", 35000, 0.18, 0)
    makePreset("MED", 100000, 0.125, 94)
    makePreset("HIGH", 400000, 0.08, 188)

    local footer = Label(Content, "F2  •  Show / Hide", UDim2.fromOffset(14, 262), UDim2.new(1, -28, 0, 18), 10, false)
    footer.TextColor3 = Colors.Muted

    -- Background picker
    Picker = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(290, 176),
        BackgroundColor3 = Colors.Main,
        Visible = false,
        BorderSizePixel = 0,
        ZIndex = 20
    }, ScreenGui)
    Corner(Picker, 12)
    Stroke(Picker, 0)

    Label(Picker, "Change Background", UDim2.fromOffset(12, 9), UDim2.fromOffset(220, 28), 14, true).ZIndex = 22
    local closePicker = Button(Picker, "×", UDim2.new(1, -34, 0, 9), UDim2.fromOffset(26, 26), 18)
    closePicker.ZIndex = 23

    for i, bg in ipairs(Backgrounds) do
        local x = 10 + (i - 1) * 94
        local img = New("ImageButton", {
            Position = UDim2.fromOffset(x, 48),
            Size = UDim2.fromOffset(82, 86),
            BackgroundColor3 = Colors.Panel,
            BorderSizePixel = 0,
            Image = bg.Image,
            ScaleType = Enum.ScaleType.Crop,
            AutoButtonColor = false,
            ZIndex = 22
        }, Picker)
        Corner(img, 8)
        Stroke(img, 0.1)
        local t = Label(Picker, bg.Name, UDim2.fromOffset(x, 138), UDim2.fromOffset(82, 22), 11, false)
        t.ZIndex = 22
        t.TextXAlignment = Enum.TextXAlignment.Center
        Connect(img.MouseButton1Click, function()
            Settings.CurrentBackground = bg.Image
            BackgroundImage.Image = bg.Image
            Picker.Visible = false
        end)
    end

    local function UpdateStatus()
        local active = Settings.AntiBatEnabled or Settings.AntiTpBatEnabled
            or Settings.InfJumpEnabled or Settings.PingLaggerEnabled
        local col = active and Colors.Accent or Colors.Inactive
        StatusText.Text = active and "ACTIVE" or "INACTIVE"
        StatusText.TextColor3 = col
        StatusDot.BackgroundColor3 = col
    end

    local function UpdateModes()
        ModeOneButton.BackgroundColor3 = Settings.AntiBatMode == 1 and Colors.Accent or Colors.Button
        ModeTwoButton.BackgroundColor3 = Settings.AntiBatMode == 2 and Colors.Accent or Colors.Button
        ModeOneButton.TextColor3 = Settings.AntiBatMode == 1 and Colors.Main or Colors.Text
        ModeTwoButton.TextColor3 = Settings.AntiBatMode == 2 and Colors.Main or Colors.Text
    end

    -- Connections
    Connect(antiBatTrigger.MouseButton1Click, function()
        SetAntiBat(not Settings.AntiBatEnabled)
        updateAntiBat(Settings.AntiBatEnabled)
        UpdateStatus()
    end)
    Connect(ModeOneButton.MouseButton1Click, function()
        Settings.AntiBatMode = 1
        UpdateModes()
        StartAntiBat()
    end)
    Connect(ModeTwoButton.MouseButton1Click, function()
        Settings.AntiBatMode = 2
        UpdateModes()
        StartAntiBat()
    end)
    Connect(antiTpTrigger.MouseButton1Click, function()
        SetAntiTpBat(not Settings.AntiTpBatEnabled)
        updateAntiTp(Settings.AntiTpBatEnabled)
        UpdateStatus()
    end)
    Connect(infJumpTrigger.MouseButton1Click, function()
        SetInfJump(not Settings.InfJumpEnabled)
        updateInfJump(Settings.InfJumpEnabled)
        UpdateStatus()
    end)
    Connect(lagTrigger.MouseButton1Click, function()
        SetPingLagger(not Settings.PingLaggerEnabled)
        updateLag(Settings.PingLaggerEnabled)
        UpdateStatus()
    end)

    Connect(bgBtn.MouseButton1Click, function()
        Picker.Visible = not Picker.Visible
    end)
    Connect(closePicker.MouseButton1Click, function()
        Picker.Visible = false
    end)

    Connect(MinimizeButton.MouseButton1Click, function()
        Settings.Minimized = not Settings.Minimized
        Content.Visible = not Settings.Minimized
        Picker.Visible = false
        Main.Size = UDim2.fromOffset(300, Settings.Minimized and 50 or 340)
        MinimizeButton.Text = Settings.Minimized and "+" or "−"
    end)

    -- Drag
    local dragging, dragInput, dragStart, dragPos
    Connect(header.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            dragPos = Main.Position
            Connect(input.Changed, function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    Connect(header.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    Connect(UserInputService.InputChanged, function(input)
        if dragging and input == dragInput and dragStart and dragPos then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                dragPos.X.Scale, dragPos.X.Offset + delta.X,
                dragPos.Y.Scale, dragPos.Y.Offset + delta.Y
            )
        end
    end)

    Connect(UserInputService.InputBegan, function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode.F2 then
            Main.Visible = not Main.Visible
            Picker.Visible = false
        end
        if input.KeyCode == Enum.KeyCode.Space then
            JumpHeld = true
        end
    end)
    Connect(UserInputService.InputEnded, function(input)
        if input.KeyCode == Enum.KeyCode.Space then
            JumpHeld = false
        end
    end)

    updateAntiBat(false)
    updateAntiTp(false)
    updateInfJump(false)
    updateLag(false)
    UpdateModes()
    UpdateStatus()
end

----------------------------------------------------------------
-- JUMP BUTTON BIND
----------------------------------------------------------------
local function BindJumpButton(obj)
    if not obj:IsA("GuiButton") or obj.Name \~= "JumpButton" or HookedJumpButtons[obj] then return end
    HookedJumpButtons[obj] = true
    Connect(obj.MouseButton1Down, function() JumpHeld = true end)
    Connect(obj.MouseButton1Up, function() JumpHeld = false end)
    Connect(obj.MouseLeave, function() JumpHeld = false end)
end

----------------------------------------------------------------
-- CLEANUP
----------------------------------------------------------------
local function Cleanup()
    if Dead then return end
    Dead = true
    Settings.AntiBatEnabled = false
    Settings.AntiTpBatEnabled = false
    Settings.InfJumpEnabled = false
    Settings.PingLaggerEnabled = false
    SpoofState.enabled = false
    SpoofState.spoofedVelocity = Vector3.zero
    StopAntiBat()
    StopPingLagger()
    RestoreAllParts()
    for _, c in ipairs(Connections) do
        c:Disconnect()
    end
    table.clear(Connections)
    if ScreenGui then
        ScreenGui:Destroy()
        ScreenGui = nil
    end
    if Environment.CursedAntiBatRuntimeCleanup == Cleanup then
        Environment.CursedAntiBatRuntimeCleanup = nil
    end
end

Environment.CursedAntiBatRuntimeCleanup = Cleanup

----------------------------------------------------------------
-- INIT
----------------------------------------------------------------
BuildGui()

Connect(Players.PlayerRemoving, function(plr)
    Snapshots[plr] = nil
    LastTriggers[plr] = nil
    ActiveThreats[plr] = nil
end)

Connect(LocalPlayer.CharacterAdded, function()
    Busy = false
    DestroyMassShield()
    RestoreAllParts()
end)

Connect(RunService.PreSimulation, function()
    if Dead or not Settings.AntiTpBatEnabled then return end
    local now = time()
    if now - ScanTime >= 0.045 then
        ScanTime = now
        ScanThreats(now)
    end
    ApplyThreatProtection(now)
end)

Connect(RunService.Heartbeat, function()
    if Dead or not Settings.InfJumpEnabled then return end
    local char, hum, root = GetCharacter()
    if not char then return end
    local holding = JumpHeld or UserInputService:IsKeyDown(Enum.KeyCode.Space) or hum.Jump
    local vel = root.AssemblyLinearVelocity
    if holding and vel.Y < 40 then
        root.AssemblyLinearVelocity = Vector3.new(vel.X, 55, vel.Z)
    elseif vel.Y < -120 then
        root.AssemblyLinearVelocity = Vector3.new(vel.X, -120, vel.Z)
    end
end)

Connect(UserInputService.JumpRequest, function()
    if not Settings.InfJumpEnabled then return end
    local char, _, root = GetCharacter()
    if char then
        local vel = root.AssemblyLinearVelocity
        root.AssemblyLinearVelocity = Vector3.new(vel.X, 55, vel.Z)
    end
end)

task.defer(function()
    local pg = LocalPlayer:WaitForChild("PlayerGui", 10)
    if Dead or not pg then return end
    for _, obj in ipairs(pg:GetDescendants()) do
        BindJumpButton(obj)
    end
    Connect(pg.DescendantAdded, BindJumpButton)
end)
