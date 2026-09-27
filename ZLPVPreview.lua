-- ═══════════════════════════════════════════════════════════════════
--   EL2B SEMI TP — rebranded & patched
--   discord.gg/el2b
-- ═══════════════════════════════════════════════════════════════════
if not game:IsLoaded() then
    game.Loaded:Wait()
end

_G.El2b_Executed = true

local Workspace, RunService, TweenService, UserInputService, v, flag, playerGui, fn, gothamBold, color
local color2, color3, color4, color5, color6, color7, fn2, createUIStroke, fn3, fn4
local tbl, fn5, speedValue, keyCode, potionEnabled, autoWalkEnabled, apOnStealEnabled, autoTPOnAllowEnabled, autoActivateEnabled, kickAfterStealEnabled
local n, tpMethod, carpetSpeed, frame, textLabel, fn6, fn7, el2bHalfwaySteal

do
    local Players = game:GetService("Players")
    Workspace = game:GetService("Workspace")
    RunService = game:GetService("RunService")
    TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    UserInputService = game:GetService("UserInputService")
    local HttpService = game:GetService("HttpService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Stats = game:GetService("Stats")
    local localPlayer = Players.LocalPlayer

    if not localPlayer then
        repeat
            task.wait()
        until Players.LocalPlayer
        localPlayer = Players.LocalPlayer
    end

    v = localPlayer
    flag = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    local ok = pcall(function()
        local folder = Instance.new("Folder")
        folder.Parent = CoreGui
        folder:Destroy()
    end) and CoreGui

    if ok then
        playerGui = ok
    else
        playerGui = v:WaitForChild("PlayerGui", 5) or v.PlayerGui
    end

    fn = function()
        return gethui and gethui() or playerGui
    end

    pcall(function()
        for _, v2 in ipairs({
            "WhaleSemiTP",
            "El2bSemiTP",
            "El2b_ProgressBar",
            "El2b_Speed_Only",
            "El2b_APSpamGui",
            "El2b_AllowDisallow",
            "UI_Watermark",
            "El2b_Toggle",
        }) do
            local v3 = fn():FindFirstChild(v2)
            if v3 then
                v3:Destroy()
            end
        end
    end)

    gothamBold = Enum.Font.GothamBold
    color  = Color3.fromRGB(8, 18, 40)
    color2 = Color3.fromRGB(10, 14, 23)
    color3 = Color3.fromRGB(0, 120, 210)
    color4 = Color3.fromRGB(0, 200, 255)
    color5 = Color3.fromRGB(80, 120, 180)
    color6 = Color3.fromRGB(200, 220, 255)
    color7 = Color3.fromRGB(0, 160, 255)

    fn2 = function(parent, arg)
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, arg or 8)
        uiCorner.Parent = parent
    end

    createUIStroke = function(parent, c, thickness)
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Color = c or color3
        uiStroke.Thickness = thickness or 1
        uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        uiStroke.Parent = parent
        return uiStroke
    end

    fn3 = function(parent, thickness)
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Thickness = thickness or 1.5
        uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        uiStroke.Color = color4
        uiStroke.Parent = parent
        local uiGradient = Instance.new("UIGradient")
        uiGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,    Color3.fromRGB(0, 200, 255)),
            ColorSequenceKeypoint.new(0.35, Color3.fromRGB(8, 18, 40)),
            ColorSequenceKeypoint.new(0.65, Color3.fromRGB(8, 18, 40)),
            ColorSequenceKeypoint.new(1,    Color3.fromRGB(0, 200, 255)),
        })
        uiGradient.Rotation = 0
        uiGradient.Parent = uiStroke

        RunService.RenderStepped:Connect(function(deltaTime)
            if uiGradient and uiGradient.Parent then
                uiGradient.Rotation = (uiGradient.Rotation + 80 * deltaTime) % 360
            end
        end)

        return uiStroke, uiGradient
    end

    fn4 = function(arg, idle, hover)
        arg.MouseEnter:Connect(function()
            TweenService:Create(arg, TweenInfo.new(0.15), { BackgroundColor3 = hover }):Play()
        end)
        arg.MouseLeave:Connect(function()
            TweenService:Create(arg, TweenInfo.new(0.15), { BackgroundColor3 = idle }):Play()
        end)
    end

    -- ─── Watermark ────────────────────────────────────────────────
    local function createScreenGui()
        local hui = type(gethui) == "function" and gethui() or CoreGui
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "UI_Watermark"
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = false
        screenGui.Parent = hui

        local flag2 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
        local frame2 = Instance.new("Frame")
        frame2.Size = flag2 and UDim2.new(0, 240, 0, 70) or UDim2.new(0, 320, 0, 85)
        frame2.Position = UDim2.new(0.5, 0, 0, -30)
        frame2.AnchorPoint = Vector2.new(0.5, 0)
        frame2.BackgroundColor3 = Color3.fromRGB(10, 14, 23)
        frame2.BackgroundTransparency = 0.15
        frame2.Parent = screenGui
        fn2(frame2, 12)

        local uiStroke = Instance.new("UIStroke")
        uiStroke.Color = Color3.fromRGB(0, 120, 210)
        uiStroke.Thickness = 2
        uiStroke.Transparency = 0.2
        uiStroke.Parent = frame2

        local uiGradient = Instance.new("UIGradient")
        uiGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(0, 100, 200)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 200, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(80, 210, 255)),
        })
        uiGradient.Parent = uiStroke

        local uiListLayout = Instance.new("UIListLayout")
        uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        uiListLayout.Padding = UDim.new(0, 4)
        uiListLayout.Parent = frame2

        local uiPadding = Instance.new("UIPadding")
        uiPadding.PaddingTop = UDim.new(0, 8)
        uiPadding.PaddingBottom = UDim.new(0, 6)
        uiPadding.Parent = frame2

        local textLabel2 = Instance.new("TextLabel")
        textLabel2.Size = UDim2.new(1, -20, 0, flag2 and 22 or 28)
        textLabel2.BackgroundTransparency = 1
        textLabel2.Text = "EL2B SEMI TP"
        textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel2.TextSize = flag2 and 20 or 26
        textLabel2.Font = Enum.Font.GothamBlack
        textLabel2.Parent = frame2

        local uiGradient2 = Instance.new("UIGradient")
        uiGradient2.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(0, 100, 200)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 200, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(80, 210, 255)),
        })
        uiGradient2.Parent = textLabel2

        local textLabel3 = Instance.new("TextLabel")
        textLabel3.Size = UDim2.new(1, -20, 0, flag2 and 14 or 18)
        textLabel3.BackgroundTransparency = 1
        textLabel3.Text = "discord.gg/el2b"
        textLabel3.TextColor3 = Color3.fromRGB(0, 200, 255)
        textLabel3.TextSize = flag2 and 11 or 14
        textLabel3.Font = Enum.Font.GothamBold
        textLabel3.Parent = frame2

        local textLabel4 = Instance.new("TextLabel")
        textLabel4.Size = UDim2.new(1, -20, 0, flag2 and 16 or 20)
        textLabel4.BackgroundTransparency = 1
        textLabel4.RichText = true
        textLabel4.Text = "<font color='rgb(255,255,255)'>FPS: </font><font color='rgb(0,200,255)'>0</font>    <font color='rgb(255,255,255)'>PING: </font><font color='rgb(0,200,255)'>0ms</font>"
        textLabel4.TextSize = flag2 and 12 or 15
        textLabel4.Font = Enum.Font.GothamBold
        textLabel4.Parent = frame2

        local n2, now, n3 = 0, tick(), 0

        RunService.Heartbeat:Connect(function()
            n2 += 1
            local now2 = tick()
            if now2 - now >= 0.5 then
                n3 = math.floor(n2 / (now2 - now) + 0.5)
                n2 = 0
                now = now2
                pcall(function()
                    local n4 = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
                    textLabel4.Text = string.format("<font color=\"rgb(255,255,255)\">FPS: </font><font color=\"rgb(0,200,255)\">%d</font>    <font color=\"rgb(255,255,255)\">PING: </font><font color=\"rgb(0,200,255)\">%dms</font>", n3, n4)
                end)
            end
        end)

        task.spawn(function()
            while textLabel4 and textLabel4.Parent do
                task.wait(1)
                pcall(function()
                    local n4 = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
                    textLabel4.Text = string.format("<font color=\"rgb(255,255,255)\">FPS: </font><font color=\"rgb(0,200,255)\">%d</font>    <font color=\"rgb(255,255,255)\">PING: </font><font color=\"rgb(0,200,255)\">%dms</font>", n3, n4)
                end)
            end
        end)

        task.spawn(function()
            local rotation = 0
            while uiGradient and uiGradient.Parent do
                rotation = (rotation + 0.3) % 360
                uiGradient.Rotation = rotation
                if uiGradient2 and uiGradient2.Parent then
                    uiGradient2.Rotation = rotation
                end
                task.wait(0.05)
            end
        end)

        return screenGui
    end

    createScreenGui()

    tbl = {
        speedBoostEnabled = false,
        speedValue = 25,
        hexSpeedVisible = false,
        speedPos = { ScaleX = 0.98, OffsetX = 0, ScaleY = 0.02, OffsetY = 0 },
        stealKeybind = "E",
        potionEnabled = true,
        autoWalkEnabled = false,
        apOnStealEnabled = false,
        autoTPOnAllowEnabled = false,
        autoActivateEnabled = false,
        kickAfterStealEnabled = false,
        selectedSlot = 1,
        selectedGear = "Auto",
        tpMethod = "grapple",
        carpetSpeed = 800,
    }

    if isfile and isfile("El2b_Config.json") then
        local ok2, result = pcall(function()
            return HttpService:JSONDecode(readfile("El2b_Config.json"))
        end)
        if ok2 and result then
            for k, v2 in pairs(result) do
                if k ~= "selectedSlot" then
                    tbl[k] = v2
                end
            end
        end
    end

    tbl.selectedSlot = 1

    fn5 = function()
        if writefile then
            pcall(function()
                writefile("El2b_Config.json", HttpService:JSONEncode(tbl))
            end)
        end
    end

    _G.El2b_SpeedBoost = tbl.speedBoostEnabled
    speedValue        = tbl.speedValue or 25
    keyCode           = Enum.KeyCode[tbl.stealKeybind or "E"]
    potionEnabled     = tbl.potionEnabled
    autoWalkEnabled   = tbl.autoWalkEnabled
    apOnStealEnabled  = tbl.apOnStealEnabled
    autoTPOnAllowEnabled = tbl.autoTPOnAllowEnabled
    autoActivateEnabled  = tbl.autoActivateEnabled
    kickAfterStealEnabled = tbl.kickAfterStealEnabled
    n = 1
    tpMethod    = tbl.tpMethod or "grapple"
    carpetSpeed = tbl.carpetSpeed or 800

    local tbl2 = { "rocket", "tiny", "jumpscare", "morph", "inverse" }
    local tbl3 = {}
    for _, v2 in ipairs(tbl2) do
        tbl3[v2] = true
    end

    local function fn8()
        local adminPanel = localPlayer.PlayerGui:FindFirstChild("AdminPanel")
        if not adminPanel then return nil, nil end
        local adminPanel2 = adminPanel:FindFirstChild("AdminPanel")
        if not adminPanel2 then return nil, nil end
        local content  = adminPanel2:FindFirstChild("Content")
        local profiles = adminPanel2:FindFirstChild("Profiles")
        if not content or not profiles then return nil, nil end
        return content:FindFirstChild("ScrollingFrame"), profiles:FindFirstChild("ScrollingFrame")
    end

    local function fn9(arg, arg2)
        local v2, v3 = fn8()
        if not v2 or not v3 then return end
        local v4 = v3:FindFirstChild(arg.Name)
        local v5 = v2:FindFirstChild(arg2)
        if not v4 or not v5 then return end

        if firesignal then
            firesignal(v5.Activated)
            firesignal(v4.Activated)
        elseif getconnections then
            for _, v6 in ipairs(getconnections(v5.Activated)) do
                if v6.Function then task.spawn(v6.Function) end
            end
            for _, v6 in ipairs(getconnections(v4.Activated)) do
                if v6.Function then task.spawn(v6.Function) end
            end
        end
    end

    local n2 = 0
    local n3 = 0.15

    local function fn10()
        if tick() - n2 < n3 then return end
        n2 = tick()
        local tbl4 = {}
        for _, v2 in ipairs(tbl2) do
            if tbl3[v2] then table.insert(tbl4, v2) end
        end
        if #tbl4 == 0 then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                for _, v2 in ipairs(tbl4) do
                    fn9(player, v2)
                end
            end
        end
    end

    local tbl4 = {}

    local function fn11()
        for _, v2 in ipairs(tbl4) do
            if v2 then v2:Disconnect() end
        end
        tbl4 = {}
    end

    local function fn12(arg)
        fn11()
        local humanoid = arg:WaitForChild("Humanoid", 5)
        local humanoidRootPart = arg:WaitForChild("HumanoidRootPart", 5)
        if not (humanoid and humanoidRootPart) then return end
        local flag2 = false

        table.insert(tbl4, RunService.Heartbeat:Connect(function()
            if not arg or not arg.Parent then return end
            if _G.El2b_SpeedBoost then
                flag2 = true
                humanoid.UseJumpPower = true
                humanoid.JumpPower = 40
                if humanoid.MoveDirection.Magnitude > 0 then
                    local unit = Vector3.new(humanoid.MoveDirection.X, 0, humanoid.MoveDirection.Z).Unit
                    humanoidRootPart.Velocity = Vector3.new(unit.X * speedValue, humanoidRootPart.Velocity.Y, unit.Z * speedValue)
                end
            elseif flag2 then
                flag2 = false
                humanoid.JumpPower = 50
            end
        end))
    end

    if v.Character then task.spawn(fn12, v.Character) end
    v.CharacterAdded:Connect(function(character)
        task.wait(0.2)
        fn12(character)
    end)

    local n4 = 1.3
    frame = nil
    textLabel = nil

    local function fn13(arg)
        if frame then
            TweenService:Create(frame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Size = UDim2.new(math.clamp(arg, 0, 1), 0, 1, 0) }):Play()
        end
        if textLabel then
            textLabel.Text = math.floor(math.clamp(arg, 0, 1) * 100) .. "%"
        end
    end

    local function fn14()
        local now = tick()
        while v:GetAttribute("Stealing") == nil do
            if not (tick() - now >= 3) then
                task.wait(0.1)
                continue
            end
            break
        end
        if v:GetAttribute("Stealing") ~= nil then
            task.wait(0.5)
        end
    end

    fn6 = function()
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return nil end
        for _, child in pairs(plots:GetChildren()) do
            if child:IsA("Model") then
                for _, descendant in pairs(child:GetDescendants()) do
                    if descendant:IsA("TextLabel") and
                       (string.find(descendant.Text, v.Name) or string.find(descendant.Text, v.DisplayName)) then
                        return child
                    end
                end
            end
        end
    end

    local function fn15(arg)
        if not arg or not arg:IsA("Model") then return false end
        local plotSign = arg:FindFirstChild("PlotSign")
        local surfaceGui = plotSign and plotSign:FindFirstChild("SurfaceGui")
        surfaceGui = surfaceGui and surfaceGui:FindFirstChild("Frame")
        surfaceGui = surfaceGui and surfaceGui:FindFirstChild("TextLabel")
        if not surfaceGui or surfaceGui.Text == "Empty Base" then return false end
        local str = surfaceGui.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
        return str ~= v.Name and str ~= v.DisplayName
    end

    local connection = nil

    local function fn16()
        if connection then
            connection:Disconnect()
            connection = nil
        end
        local character = v.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        connection = RunService.Heartbeat:Connect(function()
            if not humanoid or not humanoid.Parent then
                if connection then connection:Disconnect() end
                return
            end
            local state = humanoid:GetState()
            if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
                pcall(function()
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                end)
            end
            humanoid.PlatformStand = false
        end)
    end

    v.CharacterAdded:Connect(function()
        task.wait(0.3)
        fn16()
    end)
    if v.Character then fn16() end

    local v2, v3 = nil, nil

    local function fn17(arg)
        local children = arg:GetChildren()
        if #children < 8 then return nil end
        local tbl5, tbl6 = {}, {}
        for _, child in ipairs(children) do
            local match, v4 = tostring(child.Name):match("^(R[EF])/(.+)$")
            if match and v4 and #v4 >= 32 and v4:match("^%x%x%x%x%x%x%x%x") then
                if match == "RE" then tbl5[v4] = child else tbl6[v4] = child end
            end
        end
        local n5, v4 = 0, nil
        for k, v5 in pairs(tbl5) do
            if tbl6[k] then
                n5 += 1
                v4 = v5
            end
        end
        if n5 ~= 1 then return nil end
        local v8 = nil
        for k, v9 in ipairs(children) do
            if v9 == v4 then
                v8 = k
                break
            else
                v8 = nil
            end
        end
        if not v8 or v8 < 2 then return nil end
        local v9 = children[v8 - 1]
        if not v9 or not v9:IsA("RemoteEvent") then return nil end
        return v9
    end

    task.spawn(function()
        local jobId = game.JobId
        local net = nil
        for i = 1, 3 do
            pcall(function()
                local packages = ReplicatedStorage:WaitForChild("Packages", 20)
                net = packages and packages:WaitForChild("Net", 15)
            end)
            if not net then
                task.wait(2)
                continue
            end
            break
        end
        if not net then return end
        local now = os.clock()
        while true do
            local v4 = fn17(net)
            if v4 then
                v2 = v4
                v3 = jobId
                return
            else
                task.wait(1)
                if not (os.clock() - now > 60) then continue end
                break
            end
        end
    end)

    _G.El2b_GanchoRemote = function()
        if v2 and v3 == game.JobId then return v2 end
    end

    _G.El2b_PMRefs = nil

    _G.El2b_GrappleFire = function(arg, arg2, target, arg3)
        local v4 = ReplicatedStorage
        local refs = _G.El2b_PMRefs
        if not refs then
            refs = {}
            local tbl5 = {}
            local function fn18(arg4)
                if type(arg4) == "table" and not tbl5[arg4] then
                    tbl5[arg4] = true
                    refs[#refs + 1] = arg4
                end
            end
            pcall(function() fn18(require(v4.Packages.PlayerMouse)) end)
            pcall(function()
                for _, v5 in ipairs(getgc(true)) do
                    if type(v5) == "table" and typeof(rawget(v5, "Hit")) == "CFrame" then
                        local n5 = 0
                        for k in pairs(v5) do n5 += 1 end
                        if n5 <= 3 then fn18(v5) end
                    end
                end
            end)
            _G.El2b_PMRefs = refs
        end

        local currentCamera = workspace.CurrentCamera
        local cFrame  = currentCamera and currentCamera.CFrame
        local cFrame2 = nil

        if currentCamera then
            pcall(function()
                local mouseLocation = UserInputService:GetMouseLocation()
                local unit = currentCamera.CFrame:VectorToObjectSpace(
                    currentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y).Direction).Unit
                local n5 = arg2 - currentCamera.CFrame.Position
                if n5.Magnitude > 0.01 then
                    local unit2 = n5.Unit
                    cFrame2 = CFrame.new(currentCamera.CFrame.Position)
                        * CFrame.lookAt(Vector3.zero, unit2)
                        * CFrame.lookAt(Vector3.zero, unit):Inverse()
                end
            end)
        end

        local cframe = CFrame.new(arg2)
        local tbl5 = {}
        for i, v5 in ipairs(refs) do
            tbl5[i] = { rawget(v5, "Hit"), rawget(v5, "Target") }
            pcall(function()
                v5.Hit = cframe
                v5.Target = target
            end)
        end

        if cFrame2 then currentCamera.CFrame = cFrame2 end

        local remote = _G.El2b_GanchoRemote and _G.El2b_GanchoRemote()
        arg3 = arg3 and arg3:FindFirstChild("HumanoidRootPart")

        if remote and arg3 then
            local magnitude = (arg2 - arg3.Position).Magnitude
            pcall(function()
                remote:FireServer(magnitude / 120, arg2)
            end)
        end

        task.spawn(function()
            for i = 1, 4 do
                if cFrame2 and currentCamera then currentCamera.CFrame = cFrame2 end
                for _, v5 in ipairs(refs) do
                    pcall(function()
                        v5.Hit = cframe
                        v5.Target = target
                    end)
                end
                RunService.Heartbeat:Wait()
            end
            if cFrame2 and currentCamera and cFrame then currentCamera.CFrame = cFrame end
            for i, v5 in ipairs(refs) do
                local v6 = tbl5[i]
                pcall(function()
                    v5.Hit = v6[1]
                    v5.Target = v6[2]
                end)
            end
        end)
    end

    -- ❌ loadstring externe SUPPRIMÉ (backdoor)

    local function fn18(arg, arg2)
        local humanoidRootPart = arg2 and arg2:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        local humanoid = arg2:FindFirstChildOfClass("Humanoid")
        local grappleHook = arg2:FindFirstChild("Grapple Hook")
        local v4

        if not grappleHook then
            local backpack = v:FindFirstChild("Backpack")
            local grappleHook2 = backpack and backpack:FindFirstChild("Grapple Hook")
            if grappleHook2 and humanoid then
                pcall(function() humanoid:EquipTool(grappleHook2) end)
                local now = os.clock()
                while true do
                    RunService.Heartbeat:Wait()
                    grappleHook = arg2:FindFirstChild("Grapple Hook")
                    if not (grappleHook or os.clock() - now > 0.5) then continue end
                    break
                end
            end
            v4 = grappleHook
        else
            v4 = grappleHook
        end

        if not v4 then return end

        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = { arg2 }

        local vector = Vector3.new(arg.X - humanoidRootPart.Position.X, 0, arg.Z - humanoidRootPart.Position.Z)
        if vector.Magnitude < 1 then return end
        local unit = vector.Unit
        local v5, position, instance = nil, nil, nil

        for _, v6 in ipairs({ 9, 10, 11, 12, 13, 14, 16, 18, 21, 24, 28, 32, 36, 40, 45 }) do
            local hit = workspace:Raycast(
                humanoidRootPart.Position + unit * v6 + Vector3.new(0, 3, 0),
                Vector3.new(0, -60, 0), raycastParams)
            if hit then
                local magnitude = (hit.Position - humanoidRootPart.Position).Magnitude
                if magnitude >= 10 and magnitude <= 50 then
                    if not v5 or magnitude < v5 then
                        position = hit.Position
                        instance = hit.Instance
                        v5 = magnitude
                    end
                end
            end
        end

        if not position then
            for _, v6 in ipairs({ 11, 14, 18, 24, 32, 42, 48 }) do
                local hit = workspace:Raycast(humanoidRootPart.Position, unit * v6, raycastParams)
                if hit then
                    local magnitude = (hit.Position - humanoidRootPart.Position).Magnitude
                    if magnitude >= 10 and magnitude <= 50 then
                        if not v5 or magnitude < v5 then
                            position = hit.Position
                            instance = hit.Instance
                            v5 = magnitude
                        end
                    end
                end
            end
        end

        if not position or not instance then return end
        _G.El2b_GrappleFire(v4, position, instance, arg2)
        task.wait(0.08)
    end

    local tbl5 = {
        "Flying Carpet", "FlyingCarpet",
        "Witch's Broom", "Witch'sBroom",
        "Cupid's Wings", "Cupid'sWings",
        "Santa's Sleigh", "Santa'sSleigh",
        "Waverider",
    }
    local tbl6 = {
        "Flying Carpet", "FlyingCarpet",
        "Witch's Broom", "Witch'sBroom", "WitchBroom",
        "Cupid's Wings", "Cupid'sWings", "CupidWings",
        "Santa's Sleigh", "Santa'sSleigh", "SantaSleigh",
        "Waverider",
    }

    local function fn19(arg, arg2)
        if not arg or not arg2 then return nil end
        local v4 = arg:FindFirstChild(arg2)
        if v4 and v4:IsA("Tool") then return v4 end
        local str = arg2:lower():gsub("[%s'%_%-]", "")
        for _, child in ipairs(arg:GetChildren()) do
            if child:IsA("Tool") and child.Name:lower():gsub("[%s'%_%-]", "") == str then
                return child
            end
        end
    end

    local function fn20(arg)
        local str = arg:lower():gsub("[%s'%_%-]", "")
        for _, v4 in ipairs({ "FlyingCarpet", "Witch'sBroom", "Cupid'sWings", "Santa'sSleigh", "Waverider" }) do
            if str == v4:lower():gsub("[%s'%_%-]", "") then return true end
        end
    end

    local function fn21(arg)
        local str = arg:lower():gsub("[%s'%_%-]", "")
        for i, v4 in ipairs(tbl6) do
            if str == v4:lower():gsub("[%s'%_%-]", "") then return i end
        end
        return 9999
    end

    fn7 = function()
        local tbl7, tbl8 = {}, {}
        local function fn22(arg)
            if not arg then return end
            for _, child in ipairs(arg:GetChildren()) do
                if child:IsA("Tool") and fn20(child.Name) and not tbl8[child.Name] then
                    tbl8[child.Name] = true
                    table.insert(tbl7, child.Name)
                end
            end
        end
        fn22(localPlayer:FindFirstChild("Backpack"))
        fn22(localPlayer.Character)
        table.sort(tbl7, function(a, b)
            local v4, v5 = fn21(a), fn21(b)
            return v4 ~= v5 and v4 < v5 or a < b
        end)
        return tbl7
    end

    local function fn22()
        local character = v.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not character or not humanoid then return end
        local selectedGear = tbl.selectedGear
        if selectedGear and selectedGear ~= "Auto" and selectedGear ~= "" and selectedGear ~= "Sin Gear" then
            local v4 = fn19(character, selectedGear) or fn19(v:FindFirstChild("Backpack"), selectedGear)
            if v4 then
                if v4.Parent ~= character then
                    pcall(function() humanoid:EquipTool(v4) end)
                end
                return selectedGear
            end
        end
        local backpack = v:FindFirstChild("Backpack")
        for _, v4 in ipairs(tbl5) do
            local v5 = character:FindFirstChild(v4) or backpack and backpack:FindFirstChild(v4)
            if v5 and v5:IsA("Tool") then
                if v5.Parent ~= character then
                    pcall(function() humanoid:EquipTool(v5) end)
                end
                return v4
            end
        end
    end

    local function fn23()
        local character = localPlayer.Character
        if not character then return end
        local selectedGear = tbl.selectedGear
        if selectedGear and selectedGear ~= "Auto" and selectedGear ~= "" and selectedGear ~= "Sin Gear" then
            local v4 = fn19(character, selectedGear) or fn19(localPlayer:FindFirstChild("Backpack"), selectedGear)
            if v4 then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid and v4.Parent ~= character then humanoid:EquipTool(v4) end
                return v4
            end
        end
        for _, v4 in ipairs(tbl6) do
            local v5 = fn19(character, v4) or fn19(localPlayer:FindFirstChild("Backpack"), v4)
            if v5 then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid and v5.Parent ~= character then humanoid:EquipTool(v5) end
                return v5
            end
        end
    end

    local n5 = 3
    local n6 = 60

    local function fn24(arg)
        if arg then
            arg.AssemblyLinearVelocity  = Vector3.zero
            arg.AssemblyAngularVelocity = Vector3.zero
        end
    end

    local function fn25(arg, arg2, arg3)
        if not arg or not arg.Parent or #arg2 == 0 then return end
        arg3 = arg3 or carpetSpeed

        local function fn26()
            local v4 = arg2[1]
            if not v4 then return end
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            local filterDescendantsInstances = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    table.insert(filterDescendantsInstances, player.Character)
                end
            end
            raycastParams.FilterDescendantsInstances = filterDescendantsInstances

            for i = 1, 3 do
                if not (not arg or not arg.Parent) then
                    local vector = Vector3.new(v4.X - arg.Position.X, 0, v4.Z - arg.Position.Z)
                    local magnitude = vector.Magnitude
                    if not (magnitude < 1) then
                        local n7 = arg.Position + vector.Unit * math.min(20, magnitude)
                        local hit = workspace:Raycast(arg.Position, n7 - arg.Position, raycastParams)
                        if not (hit and hit.Instance and hit.Instance.CanCollide) then
                            arg.CFrame = arg.CFrame - arg.CFrame.Position + n7
                            fn24(arg)
                            RunService.Heartbeat:Wait()
                            continue
                        end
                    end
                end
                break
            end
        end

        fn26()
        local n7 = 1
        local flag2 = false
        local connection2 = nil
        local huge = math.huge
        local n8 = 0

        local function fn27()
            if flag2 then return end
            flag2 = true
            if arg and arg.Parent then
                fn24(arg)
                local _, v5 = arg.CFrame:ToEulerAnglesYXZ()
                arg.CFrame = CFrame.new(arg2[#arg2]) * CFrame.Angles(0, v5, 0)
            end
            if connection2 then connection2:Disconnect() end
        end

        connection2 = RunService.Heartbeat:Connect(function()
            if not arg or not arg.Parent or flag2 then
                if connection2 then connection2:Disconnect() end
                return
            end
            fn22()
            local n9 = arg2[n7] - arg.Position
            local magnitude = n9.Magnitude
            if magnitude < n5 then
                n7 += 1
                if n7 > #arg2 then
                    fn27()
                    return
                end
                huge = math.huge
                n8 = 0
                n9 = arg2[n7] - arg.Position
                magnitude = n9.Magnitude
            end
            if huge - 0.05 < magnitude then n8 += 1 else n8 = 0 end
            huge = magnitude
            if n8 >= 25 then
                fn27()
                return
            end
            if magnitude >= 0.1 then
                local unit = n9.Unit
                if n9.Y > 5 then
                    local humanoid = v.Character and v.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local state = humanoid:GetState()
                        if state ~= Enum.HumanoidStateType.Jumping and state ~= Enum.HumanoidStateType.Freefall then
                            pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
                            pcall(function() humanoid.Jump = true end)
                        end
                    end
                end
                local n10 = unit.Y * arg3
                if n6 < n10 then n10 = 60 end
                arg.Velocity = Vector3.new(unit.X * arg3, n10, unit.Z * arg3)
            end
        end)

        local position = arg.Position
        local n9 = 0
        for _, v4 in ipairs(arg2) do
            n9 += (position - v4).Magnitude
            position = v4
        end
        local n10 = n9 / math.min(500, arg3) + 3
        local n11 = 0
        while not flag2 and n11 < n10 do
            task.wait(0.05)
            n11 += 0.05
        end
        if not flag2 then fn27() end
        fn24(arg)
    end

    local function fn26(arg, arg2)
        if not arg or not arg2 then return false end
        local position = arg.Position
        local filterDescendantsInstances = { v.Character }
        for i = 1, 12 do
            local n7 = arg2 - position
            if n7.Magnitude <= 0.05 then return true end
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            raycastParams.FilterDescendantsInstances = filterDescendantsInstances
            raycastParams.IgnoreWater = true
            local hit = Workspace:Raycast(position, n7, raycastParams)
            if not hit then return true end
            local instance = hit.Instance
            if not instance then return true end
            if instance:IsA("BasePart") and not instance.CanCollide then
                table.insert(filterDescendantsInstances, instance)
                position = hit.Position + n7.Unit * 0.1
                continue
            end
            return (hit.Position - arg2).Magnitude <= 3
        end
        return false
    end

    local function fn27(arg, arg2, arg3, arg4)
        if not arg or not arg.Parent or not arg2 then return end
        arg3 = arg3 or 180
        arg4 = arg4 or 3
        local flag2 = true
        local connection2 = nil
        local controls = nil
        pcall(function()
            controls = require(v.PlayerScripts:WaitForChild("PlayerModule", 2)):GetControls()
        end)
        if controls then
            pcall(function() controls:Disable() end)
        end
        connection2 = RunService.Heartbeat:Connect(function()
            if not arg or not arg.Parent or not flag2 then
                if connection2 then connection2:Disconnect() end
                return
            end
            local n7 = arg2 - Vector3.new(arg.Position.X, arg2.Y, arg.Position.Z)
            if n7.Magnitude <= arg4 then
                flag2 = false
                connection2:Disconnect()
                arg.Velocity = Vector3.zero
                return
            end
            fn23()
            local n8 = n7.Unit * arg3
            arg.Velocity = Vector3.new(n8.X, arg.Velocity.Y, n8.Z)
        end)
        local now = tick()
        while flag2 do
            if not (tick() - now > 8) then
                task.wait()
                continue
            end
            break
        end
        if controls then pcall(function() controls:Enable() end) end
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "El2b_Podium_Highlight"
    highlight.FillColor = Color3.fromRGB(5, 25, 100)
    highlight.OutlineColor = Color3.fromRGB(0, 110, 255)
    highlight.FillTransparency = 0.35
    highlight.OutlineTransparency = 0

    local function fn28(arg)
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return nil end
        local humanoidRootPart = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
        local tbl7 = ({ { "1", "10" }, { "2", "9" }, { "3", "8" }, { "4", "7" }, { "5", "6" } })[arg] or { "1", "10" }
        local huge = math.huge
        local v4 = nil
        for _, child in ipairs(plots:GetChildren()) do
            if arg == 1 then
                local displayName = v.DisplayName
                local plotSign = child:FindFirstChild("PlotSign")
                local textLabel2 = plotSign and plotSign:FindFirstChild("SurfaceGui")
                    and plotSign.SurfaceGui:FindFirstChild("Frame")
                    and plotSign.SurfaceGui.Frame:FindFirstChild("TextLabel")
                if textLabel2 and textLabel2.Text ~= "Empty Base" then
                    local str = textLabel2.Text:gsub("'s Base$", ""):gsub("'s base$", ""):gsub("%s+$", "")
                    if str ~= displayName and str ~= v.Name then
                        local animalPodiums = child:FindFirstChild("AnimalPodiums")
                        if animalPodiums then
                            for _, v5 in ipairs(tbl7) do
                                local v6 = animalPodiums:FindFirstChild(v5)
                                if v6 then
                                    local main = v6:FindFirstChild("Claim") and v6.Claim:FindFirstChild("Main")
                                    if main then
                                        local magnitude = humanoidRootPart and
                                            (humanoidRootPart.Position - main.Position).Magnitude or 0
                                        if magnitude < huge then
                                            huge = magnitude
                                            v4 = v6
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            elseif fn15(child) then
                local animalPodiums = child:FindFirstChild("AnimalPodiums")
                if animalPodiums then
                    for _, v5 in ipairs(tbl7) do
                        local v6 = animalPodiums:FindFirstChild(v5)
                        if v6 then
                            local main = v6:FindFirstChild("Claim") and v6.Claim:FindFirstChild("Main")
                            if main then
                                local magnitude = humanoidRootPart and
                                    (humanoidRootPart.Position - main.Position).Magnitude or 0
                                if magnitude < huge then
                                    huge = magnitude
                                    v4 = v6
                                end
                            end
                        end
                    end
                end
            end
        end
        return v4
    end

    task.spawn(function()
        while task.wait(0.25) do
            local v4 = fn28(n)
            if v4 then
                if highlight.Adornee ~= v4 or highlight.Parent ~= v4 then
                    highlight.Adornee = v4
                    highlight.Parent = v4
                end
            else
                highlight.Adornee = nil
                highlight.Parent = nil
            end
        end
    end)

    local function fn29()
        local v4 = fn6()
        if not v4 then return nil end
        local humanoidRootPart = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
        humanoidRootPart = humanoidRootPart and humanoidRootPart.Position or v4:GetPivot().Position
        local huge = math.huge
        local v5 = nil
        for _, descendant in pairs(v4:GetDescendants()) do
            if descendant.Name == "DeliveryHitbox" then
                local position = descendant:IsA("BasePart") and descendant.Position
                    or descendant:IsA("Model") and descendant:GetPivot().Position
                if position then
                    local magnitude = (position - humanoidRootPart).Magnitude
                    if magnitude < huge then
                        huge = magnitude
                        v5 = position
                    end
                end
            end
        end
        if not v5 then
            for _, descendant in pairs(Workspace:GetDescendants()) do
                if descendant.Name == "DeliveryHitbox" then
                    local position = descendant:IsA("BasePart") and descendant.Position
                        or descendant:IsA("Model") and descendant:GetPivot().Position
                    if position then
                        local magnitude = (position - humanoidRootPart).Magnitude
                        if magnitude < huge then
                            huge = magnitude
                            v5 = position
                        end
                    end
                end
            end
        end
        return v5
    end

    local function fn30(arg, arg2)
        if not arg or not arg2 then return false end
        local v4 = arg.CFrame:PointToObjectSpace(arg2)
        local size = arg.Size
        local n7 = size.X / 2
        local flag2 = math.abs(v4.X) <= n7
        if flag2 then
            local n8 = size.Y / 2
            flag2 = math.abs(v4.Y) <= n8
        end
        if flag2 then
            local n8 = size.Z / 2
            flag2 = math.abs(v4.Z) <= n8
        end
        return flag2
    end

    RunService.Heartbeat:Connect(function()
        if not kickAfterStealEnabled then return end
        if not v:GetAttribute("Stealing") then return end
        local deliveryHitbox = fn6()
        deliveryHitbox = deliveryHitbox and deliveryHitbox:FindFirstChild("DeliveryHitbox", true)
        if not deliveryHitbox then return end
        local character = v.Character
        character = character and character:FindFirstChild("HumanoidRootPart")
        if character and fn30(deliveryHitbox, character.Position) then
            task.wait(0.2)
            localPlayer:Destroy()
        end
    end)

    local tbl7 = {
        GameNetPVHeaderRotationalVelocityZeroCutoffExponent = -5000,
        LargeReplicatorWrite5 = true,
        LargeReplicatorEnabled9 = true,
        AngularVelociryLimit = 360,
        TimestepArbiterVelocityCriteriaThresholdTwoDt = 2147483646,
        S2PhysicsSenderRate = 15000,
        DisableDPIScale = true,
        MaxDataPacketPerSend = 2147483647,
        PhysicsSenderMaxBandwidthBps = 20000,
        TimestepArbiterHumanoidLinearVelThreshold = 21,
        MaxMissedWorldStepsRemembered = -2147483648,
        PlayerHumanoidPropertyUpdateRestrict = true,
        SimDefaultHumanoidTimestepMultiplier = 0,
        StreamJobNOUVolumeLengthCap = 2147483647,
        DebugSendDistInSteps = -2147483648,
        GameNetDontSendRedundantNumTimes = 1,
        CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent = 1,
        CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth = 1,
        LargeReplicatorSerializeRead3 = true,
        ReplicationFocusNouExtentsSizeCutoffForPauseStuds = 2147483647,
        CheckPVCachedVelThresholdPercent = 10,
        CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth = 1,
        GameNetDontSendRedundantDeltaPositionMillionth = 1,
        InterpolationFrameVelocityThresholdMillionth = 5,
        StreamJobNOUVolumeCap = 2147483647,
        InterpolationFrameRotVelocityThresholdMillionth = 5,
        CheckPVCachedRotVelThresholdPercent = 10,
        WorldStepMax = 30,
        InterpolationFramePositionThresholdMillionth = 5,
        TimestepArbiterHumanoidTurningVelThreshold = 1,
        SimOwnedNOUCountThresholdMillionth = 2147483647,
        GameNetPVHeaderLinearVelocityZeroCutoffExponent = -5000,
        NextGenReplicatorEnabledWrite4 = true,
        TimestepArbiterOmegaThou = 1073741823,
        MaxAcceptableUpdateDelay = 1,
        LargeReplicatorSerializeWrite4 = true,
    }

    local function fn31()
        if type(setfflag) ~= "function" then return end
        for k, v4 in pairs(tbl7) do
            pcall(function()
                setfflag(tostring(k), tostring(v4))
            end)
        end
    end

    local obj = setmetatable({}, { __mode = "k" })

    local function fn32(arg)
        if type(getconnections) ~= "function" then return nil end
        if obj[arg] then return obj[arg] end
        local tbl8 = { hold = {}, trigger = {} }
        local ok2, result = pcall(getconnections, arg.PromptButtonHoldBegan)
        if ok2 then
            for _, v4 in ipairs(result) do
                if type(v4.Function) == "function" then
                    table.insert(tbl8.hold, v4.Function)
                end
            end
        end
        local ok3, result2 = pcall(getconnections, arg.Triggered)
        if ok3 then
            for _, v4 in ipairs(result2) do
                if type(v4.Function) == "function" then
                    table.insert(tbl8.trigger, v4.Function)
                end
            end
        end
        if #tbl8.hold == 0 and #tbl8.trigger == 0 then return nil end
        obj[arg] = tbl8
        return tbl8
    end

    local tbl8 = {
        startStealHold = function(arg)
            if not arg or not arg.Parent then return nil end
            local v4 = fn32(arg)
            if not v4 then return nil end
            for _, v5 in ipairs(v4.hold) do task.spawn(v5) end
            local now = tick()
            return { prompt = arg, cb = v4, ragdollFireTime = now, startedAt = now, holdBeganAt = now, holdDone = true }
        end,
        waitForStealTime = function(arg, arg2)
            if not arg or arg2 >= 1 then return end
            local n7 = tick() - arg.ragdollFireTime
            if n7 < arg2 then task.wait(arg2 - n7) end
        end,
        finishStealHold = function(arg)
            if not arg then return false end
            if not arg.holdBeganAt then
                for _, v4 in ipairs(arg.cb.hold) do task.spawn(v4) end
                arg.holdBeganAt = tick()
                task.wait(1.3)
                arg.holdDone = true
            end
            local n7 = tick() - (arg.holdBeganAt or tick())
            if n7 < 1.3 then task.wait(1.3 - n7) end
            task.wait(0.02)
            for _, v4 in ipairs(arg.cb.trigger) do task.spawn(v4) end
            return true
        end,
    }

    local tbl9 = { b1 = { refVec = Vector3.new(-337, -5, 100) }, b2 = { refVec = Vector3.new(-335, -5, 20) } }

    local tbl10 = {
        {
            podSlots = { "1", "10" },
            b1 = {
                waypoints = {
                    Vector3.new(-352.51, -6.35, 6.89),
                    Vector3.new(-353.11, -6.46, 113.28),
                    Vector3.new(-333.95, -4.62, 100.7),
                },
                greenPos = Vector3.new(-349.87, -6.52, 82.97),
            },
            b2 = {
                waypoints = {
                    Vector3.new(-352.76, -6.38, 114.06),
                    Vector3.new(-351.49, -6.38, 7),
                    Vector3.new(-334.8, -5.04, 18.9),
                },
                greenPos = Vector3.new(-349.42, -6.52, 37.47),
            },
        },
        {
            podSlots = { "2", "9" },
            b1 = {
                waypoints = {
                    Vector3.new(-352.91, -6.43, 6.73),
                    Vector3.new(-352.96, -6.43, 113.64),
                    Vector3.new(-326.07, -4.37, 101.64),
                },
                greenPos = Vector3.new(-352.76, -6.52, 91.01),
            },
            b2 = {
                waypoints = {
                    Vector3.new(-352.76, -6.38, 114.06),
                    Vector3.new(-351.15, -7.03, 28.59),
                    Vector3.new(-323.26, -4.82, 19.17),
                },
                greenPos = Vector3.new(-352.15, -7.03, 28.59),
            },
        },
        {
            podSlots = { "3", "8" },
            b1 = {
                waypoints = {
                    Vector3.new(-352.56, -6.35, 6.43),
                    Vector3.new(-352.5, -6.35, 113.92),
                    Vector3.new(-319.34, -4.62, 99.2),
                },
                greenPos = Vector3.new(-345, -6.52, 92),
            },
            b2 = {
                waypoints = {
                    Vector3.new(-352.76, -6.38, 114.06),
                    Vector3.new(-352.72, -6.38, 6.3),
                    Vector3.new(-319.81, -4.62, 20.98),
                },
                greenPos = Vector3.new(-344, -6.52, 29),
            },
        },
        {
            podSlots = { "4", "7" },
            b1 = {
                waypoints = {
                    Vector3.new(-352.7, -6.38, 6.47),
                    Vector3.new(-352.59, -6.35, 113.35),
                    Vector3.new(-311.25, -4.57, 98.98),
                },
                greenPos = Vector3.new(-337.58, -4.42, 91.88),
                midPos = Vector3.new(-346.51, -6.52, 94.05),
            },
            b2 = {
                waypoints = {
                    Vector3.new(-352.76, -6.38, 114.06),
                    Vector3.new(-352.75, -6.38, 6.15),
                    Vector3.new(-312.58, -4.62, 20.83),
                },
                greenPos = Vector3.new(-336.7, -4.62, 28.2),
                midPos = Vector3.new(-345.94, -6.52, 26.71),
            },
        },
        {
            podSlots = { "5", "6" },
            b1 = {
                waypoints = {
                    Vector3.new(-352.76, -6.74, 7.06),
                    Vector3.new(-352.76, -6.74, 114.06),
                    Vector3.new(-303.58, -4.78, 102),
                },
                greenPos = Vector3.new(-331.29, -4.58, 93.19),
                midPos = Vector3.new(-346.51, -6.52, 94.05),
            },
            b2 = {
                waypoints = {
                    Vector3.new(-352.76, -6.74, 114.06),
                    Vector3.new(-352.76, -6.74, 7.06),
                    Vector3.new(-303.48, -4.83, 17.91),
                },
                greenPos = Vector3.new(-330.39, -4.53, 26.6),
                midPos = Vector3.new(-345.94, -6.52, 26.71),
            },
        },
    }

    local function fn33()
        if potionEnabled or apOnStealEnabled then
            local giantPotion = v.Backpack:FindFirstChild("Giant Potion")
                or v.Character:FindFirstChild("Giant Potion")
            if giantPotion then
                v.Character.Humanoid:EquipTool(giantPotion)
                giantPotion:Activate()
            end
        end
        if apOnStealEnabled then task.spawn(fn10) end
    end

    local function fn34()
        local character = v.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then return end
        local flag2 = false
        local tbl11 = {}
        table.insert(tbl11, humanoid.Died:Connect(function() flag2 = true end))
        table.insert(tbl11, character.AncestryChanged:Connect(function(_, parent)
            if not parent then flag2 = true end
        end))
        table.insert(tbl11, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= 0 then flag2 = true end
        end))
        task.spawn(function()
            local n7 = 0
            while not flag2 and n7 < 500 and character and character.Parent do
                n7 += 1
                pcall(function()
                    humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 1000000, 0)
                end)
                task.wait(0.1)
            end
            for _, v4 in ipairs(tbl11) do v4:Disconnect() end
        end)
    end

    local function fn35(arg, arg2, arg3, arg4, arg5)
        local character = v.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        local connection2 = RunService.Heartbeat:Connect(function()
            if not humanoid or not humanoid.Parent then return end
            local state = humanoid:GetState()
            if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
                pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            end
            humanoid.PlatformStand = false
        end)

        local connection3 = RunService.Heartbeat:Connect(function()
            if not arg or not arg.Parent then return end
            local assemblyLinearVelocity = arg.AssemblyLinearVelocity
            if assemblyLinearVelocity.Magnitude > 350 then
                arg.AssemblyLinearVelocity = assemblyLinearVelocity.Unit * 350
            end
        end)

        if tpMethod == "grapple" then
            fn18(arg2.position, character)
        end

        local parent = arg2 and arg2.prompt and arg2.prompt.Parent
        local v4 = nil

        if parent then
            arg2.prompt.RequiresLineOfSight = false
            arg2.prompt.MaxActivationDistance = math.huge
            if type(getconnections) == "function" then
                v4 = tbl8.startStealHold(arg2.prompt)
            else
                task.spawn(function()
                    if fireproximityprompt then fireproximityprompt(arg2.prompt) end
                end)
                v4 = nil
            end
        end

        if v4 then tbl8.waitForStealTime(v4, 0.8) end

        if tpMethod == "grapple" then
            fn25(arg, arg3, carpetSpeed)
        else
            local n7 = 1
            for i = #arg3, 1, -1 do
                if fn26(arg, arg3[i]) then
                    n7 = i
                    break
                end
            end
            for i = n7, #arg3 do
                fn27(arg, arg3[i], 180)
            end
        end

        task.wait(0.25)
        fn33()
        fn23()

        if arg2 and arg2.prompt and arg2.prompt.Parent then
            if arg4 then
                if v4 then tbl8.waitForStealTime(v4, 1.3) end
                arg.CFrame = CFrame.new(arg4)
                fn24(arg)
            end
            if v4 then tbl8.finishStealHold(v4) end
        end

        connection2:Disconnect()
        connection3:Disconnect()

        if autoWalkEnabled then
            fn14()
            local v5 = fn29()
            if v5 then
                local boosted = _G.El2b_SpeedBoost
                _G.El2b_SpeedBoost = false
                local n7 = potionEnabled and 33.5 or 28
                pcall(function()
                    local humanoid2 = v.Character and v.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid2 then humanoid2:UnequipTools() end
                end)
                local tbl11 = {}
                if arg5 then table.insert(tbl11, arg5) end
                table.insert(tbl11, v5)
                if tpMethod == "grapple" then
                    fn25(arg, tbl11, n7)
                else
                    for _, v6 in ipairs(tbl11) do
                        fn27(arg, v6, n7)
                    end
                end
                _G.El2b_SpeedBoost = boosted
            end
        end
    end

    el2bHalfwaySteal = {
        debounce = false,
        setSlot = function(selectedSlot)
            if selectedSlot >= 1 and selectedSlot <= 5 then
                n = selectedSlot
                tbl.selectedSlot = selectedSlot
                fn5()
            end
        end,
        SSDoTeleport = function()
            local character = v.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            if not humanoid or not humanoidRootPart then return end
            fn31()
            fn23()
            local plots = Workspace:FindFirstChild("Plots")
            if not plots then return end
            local v4 = tbl10[n]
            if not v4 then return end
            local tbl11 = {}
            for _, child in ipairs(plots:GetChildren()) do
                if n == 1 then
                    local displayName = v.DisplayName
                    local plotSign = child:FindFirstChild("PlotSign")
                    local textLabel2 = plotSign and plotSign:FindFirstChild("SurfaceGui")
                        and plotSign.SurfaceGui:FindFirstChild("Frame")
                        and plotSign.SurfaceGui.Frame:FindFirstChild("TextLabel")
                    if textLabel2 and textLabel2.Text ~= "Empty Base" then
                        if textLabel2.Text:gsub("'s Base$", ""):gsub("'s base$", ""):gsub("%s+$", "") ~= displayName then
                            table.insert(tbl11, child)
                        end
                    end
                elseif fn15(child) then
                    table.insert(tbl11, child)
                end
            end
            if #tbl11 == 0 then return end
            local tbl12 = nil
            local huge = math.huge
            for _, v5 in ipairs(tbl11) do
                local animalPodiums = v5:FindFirstChild("AnimalPodiums")
                if animalPodiums then
                    local position = nil
                    pcall(function()
                        position = v5.PrimaryPart and v5.PrimaryPart.Position or v5:GetPivot().Position
                    end)
                    if not position then
                        local basePart = v5:FindFirstChildWhichIsA("BasePart", true)
                        if basePart then position = basePart.Position end
                    end
                    local flag2 = true
                    if position then
                        flag2 = (position - tbl9.b1.refVec).Magnitude < (position - tbl9.b2.refVec).Magnitude
                    end
                    for _, podSlot in ipairs(v4.podSlots) do
                        local v6 = animalPodiums:FindFirstChild(podSlot)
                        if v6 then
                            local main = v6:FindFirstChild("Claim") and v6.Claim:FindFirstChild("Main")
                            if main then
                                local magnitude = (humanoidRootPart.Position - main.Position).Magnitude
                                if magnitude < huge then
                                    local spawn = v6:FindFirstChild("Base") and v6.Base:FindFirstChild("Spawn")
                                    spawn = spawn and spawn:FindFirstChild("PromptAttachment")
                                    spawn = spawn and spawn:FindFirstChildWhichIsA("ProximityPrompt")
                                    if spawn then
                                        tbl12 = {
                                            plot = v5,
                                            podiumName = podSlot,
                                            position = main.Position,
                                            prompt = spawn,
                                            distance = magnitude,
                                            isBase1 = flag2,
                                        }
                                    end
                                    huge = magnitude
                                end
                            end
                        end
                    end
                end
            end
            if not tbl12 then return end
            local b1 = tbl12.isBase1 and v4.b1 or v4.b2
            task.spawn(function()
                pcall(function()
                    fn35(humanoidRootPart, tbl12, b1.waypoints, b1.greenPos, b1.midPos)
                end)
            end)
        end,
        execute = function()
            if v:GetAttribute("Stealing") or el2bHalfwaySteal.debounce then return end
            el2bHalfwaySteal.debounce = true
            task.spawn(function()
                local now = tick()
                while tick() - now < n4 do
                    fn13(math.clamp((tick() - now) / n4, 0, 1))
                    task.wait()
                end
                fn13(1)
                task.wait(0.3)
                fn13(0)
            end)
            task.spawn(function()
                fn31()
                el2bHalfwaySteal.SSDoTeleport()
                task.wait(0.1)
                el2bHalfwaySteal.debounce = false
            end)
        end,
        activate = function()
            task.spawn(function()
                fn31()
                fn34()
            end)
        end,
    }

    local function fn36()
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return false end
        for _, descendant in ipairs(Workspace:GetDescendants()) do
            if descendant:IsA("ProximityPrompt") and string.find(descendant.ObjectText, "Disallow") then
                local parent = descendant.Parent:IsA("BasePart") and descendant.Parent
                    or descendant.Parent:FindFirstChildWhichIsA("BasePart", true)
                if parent then
                    for _, child in ipairs(plots:GetChildren()) do
                        if child:IsA("Model") and parent:IsDescendantOf(child) and fn15(child) then
                            return true
                        end
                    end
                end
            end
        end
        return false
    end

    local flag2 = false
    task.spawn(function()
        while task.wait(0.5) do
            if fn36() then
                if autoTPOnAllowEnabled and not flag2 and not el2bHalfwaySteal.debounce
                    and not v:GetAttribute("Stealing") then
                    flag2 = true
                    el2bHalfwaySteal.execute()
                end
            else
                flag2 = false
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════
--   ALLOW / DISALLOW PANEL
-- ═══════════════════════════════════════════════════════════════════
do
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "El2b_AllowDisallow"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.Parent = playerGui

    local function fn8(parent)
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Thickness = 1.2
        uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        uiStroke.Color = color3
        uiStroke.Parent = parent
        local uiGradient = Instance.new("UIGradient")
        uiGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, color7),
            ColorSequenceKeypoint.new(1, color3),
        })
        uiGradient.Parent = uiStroke
        RunService.RenderStepped:Connect(function(deltaTime)
            if uiStroke and uiStroke.Parent then
                uiGradient.Rotation = uiGradient.Rotation + 500 * deltaTime
            end
        end)
    end

    local textButton = Instance.new("TextButton")
    textButton.Size = UDim2.new(0, 84, 0, 48)
    textButton.Position = UDim2.new(0.65, 36, 0, 15)
    textButton.BackgroundColor3 = color
    textButton.BackgroundTransparency = 0.2
    textButton.Text = "WAITING"
    textButton.TextColor3 = color6
    textButton.Font = gothamBold
    textButton.TextSize = 10
    textButton.Parent = screenGui
    fn2(textButton, 8)
    fn8(textButton)

    local flag2, position, position2, v2 = nil, nil, nil, nil

    textButton.InputBegan:Connect(function(input)
        if not flag2 and (input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch) then
            flag2 = true
            v2 = input
            position = input.Position
            position2 = textButton.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    flag2 = false
                    v2 = nil
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if flag2 and input == v2 and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local n2 = input.Position - position
            textButton.Position = UDim2.new(
                position2.X.Scale, position2.X.Offset + n2.X,
                position2.Y.Scale, position2.Y.Offset + n2.Y)
        end
    end)

    local tbl2 = {}

    local function fn9(adornee, text)
        if tbl2[adornee] then return end
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Size = UDim2.new(0, 40, 0, 10)
        billboardGui.Adornee = adornee
        billboardGui.AlwaysOnTop = true
        billboardGui.ExtentsOffset = Vector3.new(0, 2.5, 0)
        billboardGui.Parent = screenGui
        local frame2 = Instance.new("Frame")
        frame2.Size = UDim2.new(1, 0, 1, 0)
        frame2.BackgroundColor3 = color
        frame2.BackgroundTransparency = 0.2
        frame2.BorderSizePixel = 0
        frame2.Parent = billboardGui
        fn2(frame2, 6)
        fn8(frame2)
        local textLabel2 = Instance.new("TextLabel")
        textLabel2.Size = UDim2.new(1, 0, 1, 0)
        textLabel2.BackgroundTransparency = 1
        textLabel2.Text = text
        textLabel2.TextColor3 = color6
        textLabel2.TextSize = 18
        textLabel2.Font = gothamBold
        textLabel2.Parent = frame2
        tbl2[adornee] = billboardGui
    end

    task.spawn(function()
        while task.wait(0.5) do
            local tbl3 = {}
            local v3 = fn6()
            local huge = math.huge
            local v4 = nil
            for _, descendant in pairs(Workspace:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") then
                    local v5 = string.find(descendant.ObjectText, "Allow Friends")
                    local v6 = string.find(descendant.ObjectText, "Disallow Friends")
                    if v5 or v6 then
                        local parent = descendant.Parent:IsA("BasePart") and descendant.Parent
                            or descendant.Parent:FindFirstChildWhichIsA("BasePart", true)
                        if parent then
                            tbl3[parent] = true
                            if not tbl2[parent] then
                                fn9(parent, v5 and "X" or "X")
                            end
                            if v3 and parent:IsDescendantOf(v3) then
                                local humanoidRootPart = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                                if humanoidRootPart then
                                    local magnitude = (humanoidRootPart.Position - parent.Position).Magnitude
                                    if magnitude < huge then
                                        huge = magnitude
                                        v4 = descendant
                                    end
                                end
                            end
                        end
                    end
                end
            end
            textButton.Text = v4 and (string.find(v4.ObjectText, "Disallow") and "DISALLOW" or "ALLOW") or "NO BASE"
            for k, v5 in pairs(tbl2) do
                if not tbl3[k] then
                    v5:Destroy()
                    tbl2[k] = nil
                end
            end
        end
    end)

    textButton.MouseButton1Click:Connect(function()
        local humanoidRootPart = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
        local v3 = fn6()
        local huge = math.huge
        local v4 = nil
        for _, descendant in pairs(Workspace:GetDescendants()) do
            if descendant:IsA("ProximityPrompt")
                and (string.find(descendant.ObjectText, "Allow") or string.find(descendant.ObjectText, "Disallow")) then
                local parent = descendant.Parent:IsA("BasePart") and descendant.Parent
                    or descendant.Parent:FindFirstChildWhichIsA("BasePart", true)
                if parent and humanoidRootPart and v3 and parent:IsDescendantOf(v3) then
                    local magnitude = (humanoidRootPart.Position - parent.Position).Magnitude
                    if magnitude < huge then
                        huge = magnitude
                        v4 = descendant
                    end
                end
            end
        end
        if v4 then
            fireproximityprompt(v4)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════
--   PROGRESS BAR
-- ═══════════════════════════════════════════════════════════════════
do
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "El2b_ProgressBar"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.Parent = playerGui

    local frame2 = Instance.new("Frame")
    frame2.Size = UDim2.new(0, 240, 0, 18)
    frame2.Position = UDim2.new(0.5, -120, 1, -100)
    frame2.BackgroundColor3 = color
    frame2.BorderSizePixel = 0
    frame2.ClipsDescendants = true
    frame2.Parent = screenGui
    fn2(frame2, 9)

    local uiStroke = Instance.new("UIStroke", frame2)
    uiStroke.Thickness = 1.5
    uiStroke.Color = color3

    frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 0, 1, 0)
    frame.BackgroundColor3 = color4
    frame.BorderSizePixel = 0
    frame.Parent = frame2
    fn2(frame, 9)

    textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "0%"
    textLabel.TextColor3 = color6
    textLabel.Font = gothamBold
    textLabel.TextSize = 11
    textLabel.ZIndex = 3
    textLabel.Parent = frame2
end

-- ═══════════════════════════════════════════════════════════════════
--   MAIN MENU
-- ═══════════════════════════════════════════════════════════════════
local frame2

do
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "El2bSemiTP"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.Parent = playerGui

    local n2 = flag and 220 or 200
    local n3 = flag and 210 or 200

    frame2 = Instance.new("Frame")
    frame2.Size = UDim2.new(0, n2, 0, n3)
    frame2.AnchorPoint = Vector2.new(1, 0)
    frame2.Position = flag and UDim2.new(0.88, 0, 0.05, 0) or UDim2.new(0.84, 0, 0.02, 0)
    frame2.BackgroundColor3 = color
    frame2.BorderSizePixel = 0
    frame2.Active = true
    frame2.ClipsDescendants = false
    frame2.Parent = screenGui
end

fn2(frame2, 12)
fn3(frame2, 1.6)

do
    local frame3 = Instance.new("Frame")
    frame3.Size = UDim2.new(1, 0, 0, 36)
    frame3.BackgroundColor3 = color2
    frame3.BorderSizePixel = 0
    frame3.Parent = frame2
    fn2(frame3, 12)

    local frame4 = Instance.new("Frame")
    frame4.Size = UDim2.new(1, 0, 0, 8)
    frame4.Position = UDim2.new(0, 0, 1, -8)
    frame4.BackgroundColor3 = color2
    frame4.BorderSizePixel = 0
    frame4.Parent = frame3

    local frame5 = Instance.new("Frame")
    frame5.Size = UDim2.new(1, 0, 0, 1)
    frame5.Position = UDim2.new(0, 0, 1, 0)
    frame5.BackgroundColor3 = color3
    frame5.BorderSizePixel = 0
    frame5.Parent = frame3

    local flag2, position, position2 = false, nil, nil

    frame3.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            flag2 = true
            position = input.Position
            position2 = frame2.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if flag2 and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local n2 = input.Position - position
            frame2.Position = UDim2.new(
                position2.X.Scale, position2.X.Offset + n2.X,
                position2.Y.Scale, position2.Y.Offset + n2.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            flag2 = false
        end
    end)

    local frame6 = Instance.new("Frame")
    frame6.Size = UDim2.fromOffset(2, 18)
    frame6.Position = UDim2.fromOffset(10, 9)
    frame6.BackgroundColor3 = color4
    frame6.BorderSizePixel = 0
    frame6.Parent = frame3
    fn2(frame6, 2)

    local textLabel2 = Instance.new("TextLabel")
    textLabel2.Size = UDim2.new(1, -18, 1, 0)
    textLabel2.Position = UDim2.new(0, 18, 0, 0)
    textLabel2.BackgroundTransparency = 1
    textLabel2.Text = "EL2B SEMI TP"
    textLabel2.TextColor3 = color6
    textLabel2.Font = Enum.Font.GothamBlack
    textLabel2.TextSize = 12
    textLabel2.TextXAlignment = Enum.TextXAlignment.Left
    textLabel2.Parent = frame3

    local uiGradient = Instance.new("UIGradient")
    uiGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(0, 100, 200)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(80, 210, 255)),
    })
    uiGradient.Parent = textLabel2

    task.spawn(function()
        local rotation = 0
        while uiGradient and uiGradient.Parent do
            rotation = (rotation + 0.3) % 360
            uiGradient.Rotation = rotation
            task.wait(0.05)
        end
    end)
end

local Main, v2, Utilities, v3

do
    local frame3 = Instance.new("Frame")
    frame3.Size = UDim2.new(1, -16, 0, 24)
    frame3.Position = UDim2.new(0, 8, 0, 44)
    frame3.BackgroundColor3 = color2
    frame3.BorderSizePixel = 0
    frame3.Parent = frame2
    fn2(frame3, 7)
    createUIStroke(frame3, color3, 1)

    local uiListLayout = Instance.new("UIListLayout", frame3)
    uiListLayout.FillDirection = Enum.FillDirection.Horizontal
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function fn8(text, layoutOrder)
        local textButton = Instance.new("TextButton")
        textButton.Size = UDim2.new(0.5, 0, 1, 0)
        textButton.BackgroundTransparency = 1
        textButton.Text = text
        textButton.TextColor3 = color5
        textButton.Font = gothamBold
        textButton.TextSize = 10
        textButton.LayoutOrder = layoutOrder
        textButton.Parent = frame3
        local frame4 = Instance.new("Frame")
        frame4.Size = UDim2.new(1, -6, 0, 2)
        frame4.Position = UDim2.new(0, 3, 1, -2)
        frame4.BackgroundColor3 = color4
        frame4.BackgroundTransparency = 1
        frame4.BorderSizePixel = 0
        frame4.Parent = textButton
        fn2(frame4, 2)
        return textButton, frame4
    end

    Main, v2 = fn8("Main", 1)
    Utilities, v3 = fn8("Utilities", 2)
end

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -12, 1, -76)
scrollingFrame.Position = UDim2.new(0, 6, 0, 72)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 2
scrollingFrame.ScrollBarImageColor3 = color5
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollingFrame.ClipsDescendants = true
scrollingFrame.Parent = frame2

local uiListLayout = Instance.new("UIListLayout", scrollingFrame)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 5)

local createFrame
createFrame = function(arg, layoutOrder)
    local frame3 = Instance.new("Frame")
    frame3.Size = UDim2.new(1, -2, 0, arg)
    frame3.BackgroundColor3 = color2
    frame3.BorderSizePixel = 0
    frame3.LayoutOrder = layoutOrder or 1
    frame3.Parent = scrollingFrame
    fn2(frame3, 7)
    createUIStroke(frame3, color3, 1)
    return frame3
end

local fn8
fn8 = function(parent, text, arg, arg2)
    local textLabel2 = Instance.new("TextLabel")
    textLabel2.Size = UDim2.new(0.62, 0, 1, 0)
    textLabel2.Position = UDim2.new(0, 8, 0, 0)
    textLabel2.BackgroundTransparency = 1
    textLabel2.Text = text
    textLabel2.TextColor3 = color6
    textLabel2.Font = gothamBold
    textLabel2.TextSize = 10
    textLabel2.TextXAlignment = Enum.TextXAlignment.Left
    textLabel2.Parent = parent

    local textButton = Instance.new("TextButton")
    textButton.Size = UDim2.new(0, 32, 0, 16)
    textButton.Position = UDim2.new(1, -40, 0.5, -8)
    textButton.BackgroundColor3 = arg and color4 or color3
    textButton.BorderSizePixel = 0
    textButton.Text = ""
    textButton.Parent = parent
    fn2(textButton, 8)

    local frame3 = Instance.new("Frame")
    frame3.Size = UDim2.new(0, 12, 0, 12)
    frame3.Position = arg and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    frame3.BackgroundColor3 = arg and color or color5
    frame3.BorderSizePixel = 0
    frame3.Parent = textButton
    fn2(frame3, 6)

    local flag2 = arg
    textButton.MouseButton1Click:Connect(function()
        flag2 = not flag2
        if flag2 then
            TweenService:Create(textButton, TweenInfo.new(0.18), { BackgroundColor3 = color4 }):Play()
            TweenService:Create(frame3, TweenInfo.new(0.18), {
                Position = UDim2.new(1, -14, 0.5, -6),
                BackgroundColor3 = color,
            }):Play()
        else
            TweenService:Create(textButton, TweenInfo.new(0.18), { BackgroundColor3 = color3 }):Play()
            TweenService:Create(frame3, TweenInfo.new(0.18), {
                Position = UDim2.new(0, 2, 0.5, -6),
                BackgroundColor3 = color5,
            }):Play()
        end
        arg2(flag2)
    end)
    return textButton, frame3
end

local v4 = createFrame(28, 1)
local textLabel2 = Instance.new("TextLabel")
textLabel2.Size = UDim2.new(0.4, 0, 1, 0)
textLabel2.Position = UDim2.new(0, 8, 0, 0)
textLabel2.BackgroundTransparency = 1
textLabel2.Text = "Select Slot"
textLabel2.TextColor3 = color6
textLabel2.Font = gothamBold
textLabel2.TextSize = 10
textLabel2.TextXAlignment = Enum.TextXAlignment.Left
textLabel2.Parent = v4

do
    local frame3 = Instance.new("Frame")
    frame3.Size = UDim2.new(0, 90, 0, 18)
    frame3.Position = UDim2.new(1, -97, 0.5, -9)
    frame3.BackgroundTransparency = 1
    frame3.Parent = v4

    local textButton = Instance.new("TextButton")
    textButton.Size = UDim2.new(0, 18, 1, 0)
    textButton.BackgroundColor3 = Color3.fromRGB(20, 35, 60)
    textButton.Text = "<"
    textButton.TextColor3 = color6
    textButton.Font = gothamBold
    textButton.TextSize = 11
    textButton.Parent = frame3
    fn2(textButton, 5)
    createUIStroke(textButton, color3, 1)
    fn4(textButton, Color3.fromRGB(20, 35, 60), Color3.fromRGB(35, 55, 80))

    local textLabel3 = Instance.new("TextLabel")
    textLabel3.Size = UDim2.new(0, 44, 1, 0)
    textLabel3.Position = UDim2.new(0, 22, 0, 0)
    textLabel3.BackgroundColor3 = Color3.fromRGB(18, 30, 50)
    textLabel3.Text = "Slot " .. n
    textLabel3.TextColor3 = color6
    textLabel3.Font = gothamBold
    textLabel3.TextSize = 9
    textLabel3.Parent = frame3
    fn2(textLabel3, 5)
    createUIStroke(textLabel3, color3, 1)

    local textButton2 = Instance.new("TextButton")
    textButton2.Size = UDim2.new(0, 18, 1, 0)
    textButton2.Position = UDim2.new(1, -18, 0, 0)
    textButton2.BackgroundColor3 = Color3.fromRGB(20, 35, 60)
    textButton2.Text = ">"
    textButton2.TextColor3 = color6
    textButton2.Font = gothamBold
    textButton2.TextSize = 11
    textButton2.Parent = frame3
    fn2(textButton2, 5)
    createUIStroke(textButton2, color3, 1)
    fn4(textButton2, Color3.fromRGB(20, 35, 60), Color3.fromRGB(35, 55, 80))

    local function fn9(arg)
        n = arg
        textLabel3.Text = "Slot " .. arg
        el2bHalfwaySteal.setSlot(arg)
    end

    textButton.MouseButton1Click:Connect(function()
        local n2 = n - 1
        if n2 < 1 then n2 = 5 end
        fn9(n2)
    end)
    textButton2.MouseButton1Click:Connect(function()
        local n2 = n + 1
        if n2 > 5 then n2 = 1 end
        fn9(n2)
    end)
end

local v5 = createFrame(28, 2)
do
    local textButton = Instance.new("TextButton")
    textButton.Size = UDim2.new(1, 0, 1, 0)
    textButton.BackgroundColor3 = Color3.fromRGB(20, 35, 60)
    textButton.BorderSizePixel = 0
    textButton.Text = "Activate (Reset)"
    textButton.TextColor3 = color6
    textButton.Font = gothamBold
    textButton.TextSize = 10
    textButton.Parent = v5
    fn2(textButton, 7)
    fn4(textButton, Color3.fromRGB(20, 35, 60), Color3.fromRGB(35, 55, 80))
    textButton.MouseButton1Click:Connect(function()
        el2bHalfwaySteal.activate()
    end)
end

do
    local v6 = createFrame(30, 3)
    local textButton = Instance.new("TextButton")
    textButton.Size = UDim2.new(1, 0, 1, 0)
    textButton.BackgroundColor3 = color4
    textButton.BorderSizePixel = 0
    textButton.Text = "Steal Now"
    textButton.TextColor3 = color
    textButton.Font = gothamBold
    textButton.TextSize = 11
    textButton.Parent = v6
    fn2(textButton, 7)
    fn4(textButton, color4, Color3.fromRGB(80, 200, 255))
    textButton.MouseButton1Click:Connect(function()
        el2bHalfwaySteal.execute()
    end)

    local v7 = createFrame(26, 10)
    fn8(v7, "Auto Activate", autoActivateEnabled, function(val)
        autoActivateEnabled = val
        tbl.autoActivateEnabled = val
        fn5()
    end)

    local v8 = createFrame(26, 11)
    fn8(v8, "Auto Potion", potionEnabled, function(val)
        potionEnabled = val
        tbl.potionEnabled = val
        fn5()
    end)

    local v9 = createFrame(26, 12)
    fn8(v9, "Auto Walk", autoWalkEnabled, function(val)
        autoWalkEnabled = val
        tbl.autoWalkEnabled = val
        fn5()
    end)

    local v10 = createFrame(26, 13)
    fn8(v10, "Auto TP on Allow", autoTPOnAllowEnabled, function(val)
        autoTPOnAllowEnabled = val
        tbl.autoTPOnAllowEnabled = val
        fn5()
    end)

    local v11 = createFrame(26, 14)
    fn8(v11, "AP on Steal", apOnStealEnabled, function(val)
        apOnStealEnabled = val
        tbl.apOnStealEnabled = val
        fn5()
    end)

    local v12 = createFrame(26, 15)
    fn8(v12, "Kick After Steal", kickAfterStealEnabled, function(val)
        kickAfterStealEnabled = val
        tbl.kickAfterStealEnabled = val
        fn5()
    end)

    local v13 = createFrame(26, 16)
    local textLabel3 = Instance.new("TextLabel")
    textLabel3.Size = UDim2.new(0.45, 0, 1, 0)
    textLabel3.Position = UDim2.new(0, 8, 0, 0)
    textLabel3.BackgroundTransparency = 1
    textLabel3.Text = "Method"
    textLabel3.TextColor3 = color6
    textLabel3.Font = gothamBold
    textLabel3.TextSize = 10
    textLabel3.TextXAlignment = Enum.TextXAlignment.Left
    textLabel3.Parent = v13

    local textButton2 = Instance.new("TextButton")
    textButton2.Size = UDim2.new(0, 80, 0, 18)
    textButton2.Position = UDim2.new(1, -87, 0.5, -9)
    textButton2.BackgroundColor3 = Color3.fromRGB(20, 35, 60)
    textButton2.Text = tpMethod == "grapple" and "Grapple" or "Classic"
    textButton2.TextColor3 = color4
    textButton2.Font = gothamBold
    textButton2.TextSize = 9
    textButton2.Parent = v13
    fn2(textButton2, 5)
    createUIStroke(textButton2, color3, 1)
    fn4(textButton2, Color3.fromRGB(20, 35, 60), Color3.fromRGB(35, 55, 80))

    local v14 = createFrame(36, 17)

    textButton2.MouseButton1Click:Connect(function()
        tpMethod = tpMethod == "grapple" and "classic" or "grapple"
        textButton2.Text = tpMethod == "grapple" and "Grapple" or "Classic"
        tbl.tpMethod = tpMethod
        fn5()
        v14.Visible = tpMethod == "grapple" -- ✅ FIX RowSpeed → v14
    end)

    local textLabel4 = Instance.new("TextLabel")
    textLabel4.Size = UDim2.new(1, 0, 0, 14)
    textLabel4.Position = UDim2.new(0, 8, 0, 2)
    textLabel4.BackgroundTransparency = 1
    textLabel4.Text = "Carpet Speed: " .. carpetSpeed
    textLabel4.TextColor3 = color6
    textLabel4.Font = gothamBold
    textLabel4.TextSize = 9
    textLabel4.TextXAlignment = Enum.TextXAlignment.Left
    textLabel4.Parent = v14

    local frame3 = Instance.new("Frame")
    frame3.Size = UDim2.new(1, -16, 0, 4)
    frame3.Position = UDim2.new(0, 8, 0, 22)
    frame3.BackgroundColor3 = color3
    frame3.BorderSizePixel = 0
    frame3.Parent = v14
    fn2(frame3, 3)

    local frame4 = Instance.new("Frame")
    frame4.Size = UDim2.new((carpetSpeed - 100) / 900, 0, 1, 0)
    frame4.BackgroundColor3 = color4
    frame4.BorderSizePixel = 0
    frame4.Parent = frame3
    fn2(frame4, 3)

    local frame5 = Instance.new("Frame")
    frame5.Size = UDim2.fromOffset(12, 12)
    frame5.AnchorPoint = Vector2.new(0.5, 0.5)
    frame5.Position = UDim2.new((carpetSpeed - 100) / 900, 0, 0.5, 0)
    frame5.BackgroundColor3 = color4
    frame5.BorderSizePixel = 0
    frame5.Parent = frame3
    fn2(frame5, 6)

    local flag2 = false
    local function fn9(arg)
        local n2 = math.clamp((arg - frame3.AbsolutePosition.X) / frame3.AbsoluteSize.X, 0, 1)
        local carpetSpeed2 = math.floor(100 + 900 * n2)
        carpetSpeed = carpetSpeed2
        tbl.carpetSpeed = carpetSpeed2
        fn5()
        frame4.Size = UDim2.new(n2, 0, 1, 0)
        frame5.Position = UDim2.new(n2, 0, 0.5, 0)
        textLabel4.Text = "Carpet Speed: " .. carpetSpeed2
    end

    frame3.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            flag2 = true
            fn9(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            flag2 = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if flag2 and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            fn9(input.Position.X)
        end
    end)

    v14.Visible = tpMethod == "grapple"

    local v15 = createFrame(26, 18)
    local textLabel5 = Instance.new("TextLabel")
    textLabel5.Size = UDim2.new(0.42, 0, 1, 0)
    textLabel5.Position = UDim2.new(0, 8, 0, 0)
    textLabel5.BackgroundTransparency = 1
    textLabel5.Text = "Select Gear"
    textLabel5.TextColor3 = color6
    textLabel5.Font = gothamBold
    textLabel5.TextSize = 10
    textLabel5.TextXAlignment = Enum.TextXAlignment.Left
    textLabel5.Parent = v15

    local v16 = fn7()
    if #v16 > 0 then
        local found = false
        for _, v17 in ipairs(v16) do
            if v17 == tbl.selectedGear then found = true break end
        end
        if not found then
            tbl.selectedGear = v16[1]
            fn5()
        end
    else
        tbl.selectedGear = "Sin Gear"
    end

    local textButton3 = Instance.new("TextButton")
    textButton3.Size = UDim2.new(0, 90, 0, 18)
    textButton3.Position = UDim2.new(1, -97, 0.5, -9)
    textButton3.BackgroundColor3 = Color3.fromRGB(20, 35, 60)
    textButton3.Text = tbl.selectedGear
    textButton3.TextColor3 = color4
    textButton3.Font = gothamBold
    textButton3.TextSize = 8
    textButton3.ZIndex = 8
    textButton3.Parent = v15
    fn2(textButton3, 5)
    createUIStroke(textButton3, color3, 1)
    fn4(textButton3, Color3.fromRGB(20, 35, 60), Color3.fromRGB(35, 55, 80))

    textButton3.MouseButton1Click:Connect(function()
        local v17 = fn7()
        if #v17 == 0 then
            textButton3.Text = "Sin Gear"
            tbl.selectedGear = "Sin Gear"
            fn5()
            return
        end
        local n2 = 0
        for i, v18 in ipairs(v17) do
            if v18 == tbl.selectedGear then n2 = i break end
        end
        local v18 = v17[n2 % #v17 + 1]
        textButton3.Text = v18
        tbl.selectedGear = v18
        fn5()
    end)

    local v17 = createFrame(26, 19)
    if flag then v17.Visible = false end

    local textLabel6 = Instance.new("TextLabel")
    textLabel6.Size = UDim2.new(0.5, 0, 1, 0)
    textLabel6.Position = UDim2.new(0, 8, 0, 0)
    textLabel6.BackgroundTransparency = 1
    textLabel6.Text = "Steal Keybind"
    textLabel6.TextColor3 = color6
    textLabel6.Font = gothamBold
    textLabel6.TextSize = 10
    textLabel6.TextXAlignment = Enum.TextXAlignment.Left
    textLabel6.Parent = v17

    local textButton4 = Instance.new("TextButton")
    textButton4.Size = UDim2.new(0, 46, 0, 18)
    textButton4.Position = UDim2.new(1, -53, 0.5, -9)
    textButton4.BackgroundColor3 = Color3.fromRGB(20, 35, 60)
    textButton4.Text = keyCode.Name
    textButton4.TextColor3 = color6
    textButton4.Font = gothamBold
    textButton4.TextSize = 9
    textButton4.Parent = v17
    fn2(textButton4, 5)
    createUIStroke(textButton4, color3, 1)

    local flag3 = false
    textButton4.MouseButton1Click:Connect(function()
        flag3 = true
        textButton4.Text = "..."
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if flag3 and input.UserInputType == Enum.UserInputType.Keyboard then
            flag3 = false
            keyCode = input.KeyCode
            textButton4.Text = input.KeyCode.Name
            tbl.stealKeybind = input.KeyCode.Name
            fn5()
        elseif not flag3 and input.KeyCode == keyCode then
            if not el2bHalfwaySteal.debounce and not v:GetAttribute("Stealing") then
                el2bHalfwaySteal.execute()
            end
        end
    end)

    local v18 = createFrame(26, 20)
    local v19 = nil
    fn8(v18, "Speed Panel", tbl.hexSpeedVisible, function(visible)
        if v19 then v19.Visible = visible end
        tbl.hexSpeedVisible = visible
        fn5()
    end)

    local function fn10(arg)
        scrollingFrame.CanvasPosition = Vector2.new(0, 0)
        if arg == "Main" then
            Main.TextColor3 = color6
            Utilities.TextColor3 = color5
            TweenService:Create(v2, TweenInfo.new(0.15), { BackgroundTransparency = 0 }):Play()
            TweenService:Create(v3, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
            v4.Visible  = true
            v5.Visible  = true
            v6.Visible  = true
            v7.Visible  = false
            v8.Visible  = false
            v9.Visible  = false
            v10.Visible = false
            v11.Visible = false
            v12.Visible = false
            v13.Visible = false
            v14.Visible = false
            v15.Visible = false
            v17.Visible = false
            v18.Visible = false
        elseif arg == "Utils" then
            Utilities.TextColor3 = color6
            Main.TextColor3 = color5
            TweenService:Create(v3, TweenInfo.new(0.15), { BackgroundTransparency = 0 }):Play()
            TweenService:Create(v2, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
            v4.Visible  = false
            v5.Visible  = false
            v6.Visible  = false
            v7.Visible  = true
            v8.Visible  = true
            v9.Visible  = true
            v10.Visible = true
            v11.Visible = true
            v12.Visible = true
            v13.Visible = true
            v14.Visible = tpMethod == "grapple"
            v15.Visible = true
            v18.Visible = true
            v17.Visible = not flag
        end
    end

    Main.MouseButton1Click:Connect(function() fn10("Main") end)
    Utilities.MouseButton1Click:Connect(function() fn10("Utils") end)
    fn10("Main")

    -- ─── Speed Panel ───────────────────────────────────────────────
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "El2b_Speed_Only"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui

    local frame6 = Instance.new("Frame")
    frame6.Name = "El2bSpeed"
    frame6.Size = UDim2.new(0, 180, 0, 100)
    frame6.BackgroundColor3 = color
    frame6.BorderSizePixel = 0
    frame6.Visible = tbl.hexSpeedVisible
    frame6.ZIndex = 5
    frame6.AnchorPoint = Vector2.new(1, 0)
    frame6.Parent = screenGui

    if tbl.speedPos and tbl.speedPos.ScaleX ~= 0.5 then
        frame6.Position = UDim2.new(tbl.speedPos.ScaleX, tbl.speedPos.OffsetX, tbl.speedPos.ScaleY, tbl.speedPos.OffsetY)
    else
        frame6.Position = UDim2.new(0.98, 0, 0.02, 0)
    end

    fn2(frame6, 10)
    fn3(frame6, 1.4)
    v19 = frame6

    local textLabel7 = Instance.new("TextLabel")
    textLabel7.Size = UDim2.new(1, 0, 0, 28)
    textLabel7.BackgroundTransparency = 1
    textLabel7.Text = "SPEED PANEL"
    textLabel7.TextColor3 = color6
    textLabel7.Font = gothamBold
    textLabel7.TextSize = 10
    textLabel7.ZIndex = 6
    textLabel7.Parent = frame6

    local function fn11(parent, arg, text, arg2)
        local textButton5 = Instance.new("TextButton")
        textButton5.Size = UDim2.new(1, -10, 0, 26)
        textButton5.Position = UDim2.new(0, 5, 0, arg)
        textButton5.AutoButtonColor = false
        textButton5.Text = ""
        textButton5.BackgroundColor3 = color2
        textButton5.BorderSizePixel = 0
        textButton5.ZIndex = 3
        textButton5.Parent = parent
        fn2(textButton5, 6)
        createUIStroke(textButton5, color3, 1)

        local textLabel8 = Instance.new("TextLabel")
        textLabel8.Size = UDim2.new(1, -28, 1, 0)
        textLabel8.Position = UDim2.new(0, 7, 0, 0)
        textLabel8.BackgroundTransparency = 1
        textLabel8.Text = text
        textLabel8.TextColor3 = color6
        textLabel8.Font = gothamBold
        textLabel8.TextSize = 9
        textLabel8.TextXAlignment = Enum.TextXAlignment.Left
        textLabel8.ZIndex = 4
        textLabel8.Parent = textButton5

        local frame7 = Instance.new("Frame")
        frame7.Size = UDim2.new(0, 7, 0, 7)
        frame7.Position = UDim2.new(1, -14, 0.5, -3.5)
        frame7.BorderSizePixel = 0
        frame7.ZIndex = 4
        frame7.Parent = textButton5
        fn2(frame7, 4)

        local function fn12(arg3)
            local on = _G[arg2]
            local strokeColor = on and color4 or color3
            local bgColor = on and Color3.fromRGB(28, 45, 70) or color2
            if arg3 then
                TweenService:Create(frame7, TweenInfo.new(0.15), { BackgroundColor3 = strokeColor }):Play()
                TweenService:Create(textButton5, TweenInfo.new(0.15), { BackgroundColor3 = bgColor }):Play()
            else
                frame7.BackgroundColor3 = strokeColor
                textButton5.BackgroundColor3 = bgColor
            end
        end

        fn12(false)
        textButton5.MouseButton1Click:Connect(function()
            _G[arg2] = not _G[arg2]
            tbl[arg2] = _G[arg2]
            fn5()
            fn12(true)
        end)
    end

    local function fn12(parent, arg, text, min, max, def, cb)
        local frame7 = Instance.new("Frame")
        frame7.Size = UDim2.new(1, -10, 0, 26)
        frame7.Position = UDim2.new(0, 5, 0, arg)
        frame7.BackgroundColor3 = color2
        frame7.Parent = parent
        fn2(frame7, 6)
        createUIStroke(frame7, color3, 1)

        local textLabel8 = Instance.new("TextLabel")
        textLabel8.Size = UDim2.new(0.62, 0, 1, 0)
        textLabel8.Position = UDim2.new(0, 7, 0, 0)
        textLabel8.BackgroundTransparency = 1
        textLabel8.Text = text
        textLabel8.TextColor3 = color6
        textLabel8.Font = gothamBold
        textLabel8.TextSize = 9
        textLabel8.TextXAlignment = Enum.TextXAlignment.Left
        textLabel8.Parent = frame7

        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(0.3, 0, 0, 16)
        textBox.Position = UDim2.new(0.68, -2, 0.5, -8)
        textBox.BackgroundColor3 = color
        textBox.Text = tostring(def)
        textBox.TextColor3 = color6
        textBox.Font = gothamBold
        textBox.TextSize = 9
        textBox.ClearTextOnFocus = false
        textBox.Parent = frame7
        fn2(textBox, 4)
        createUIStroke(textBox, color3, 1)

        textBox.FocusLost:Connect(function()
            local num = tonumber(textBox.Text)
            if num then
                local n2 = math.clamp(num, min, max)
                textBox.Text = tostring(n2)
                cb(n2)
            else
                textBox.Text = tostring(def)
            end
        end)
    end

    fn11(frame6, 30, "Speed Boost", "El2b_SpeedBoost")
    fn12(frame6, 62, "Steal Speed", 16, 100, speedValue, function(val)
        speedValue = val
        tbl.speedValue = val
        fn5()
    end)

    local flag4, position, position2 = false, nil, nil
    textLabel7.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            flag4 = true
            position = input.Position
            position2 = frame6.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        local move = flag4
        if flag4 then
            move = input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
        end
        if move then
            local n2 = input.Position - position
            frame6.Position = UDim2.new(
                position2.X.Scale, position2.X.Offset + n2.X,
                position2.Y.Scale, position2.Y.Offset + n2.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function()
        if flag4 then
            flag4 = false
            tbl.speedPos = {
                ScaleX = frame6.Position.X.Scale,
                OffsetX = frame6.Position.X.Offset,
                ScaleY = frame6.Position.Y.Scale,
                OffsetY = frame6.Position.Y.Offset,
            }
            fn5()
        end
    end)

    local currentCamera = workspace.CurrentCamera
    local tbl2 = {}
    local function fn13(parent)
        local uiScale = parent:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
        uiScale.Parent = parent
        table.insert(tbl2, uiScale)
    end
    fn13(frame2)
    fn13(frame6)

    local function fn14()
        if not currentCamera then return end
        local viewportSize = currentCamera.ViewportSize
        local vector2 = Vector2.new(800, 450)
        local n2 = math.min(viewportSize.X / vector2.X, viewportSize.Y / vector2.Y)
        local scale = flag and math.clamp(n2 * 1.15, 0.95, 1.4) or math.clamp(n2 * 0.85, 0.75, 1.2)
        for _, v20 in ipairs(tbl2) do
            v20.Scale = scale
        end
    end
    fn14()
    if currentCamera then
        currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fn14)
    end
end

_G.El2b_HalfwaySteal = el2bHalfwaySteal
_G.El2b_Execute      = function() pcall(el2bHalfwaySteal.execute) end
_G.El2b_SetSlot      = function(arg) el2bHalfwaySteal.setSlot(arg) end

el2bHalfwaySteal.debounce = false

if autoActivateEnabled then
    task.spawn(function()
        task.wait(0.5)
        el2bHalfwaySteal.activate()
    end)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "El2b_APSpamGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 15
screenGui.Enabled = false
screenGui.Parent = fn()

-- ═══════════════════════════════════════════════════════════════════
--   EL2B — TOGGLE BUTTON (ouvrir / fermer le menu)
-- ═══════════════════════════════════════════════════════════════════
do
    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "El2b_Toggle"
    ToggleGui.ResetOnSpawn = false
    ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ToggleGui.DisplayOrder = 100
    ToggleGui.Parent = fn()

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 52, 0, 52)
    btn.Position = UDim2.new(0, 20, 0.5, -26)
    btn.BackgroundColor3 = Color3.fromRGB(8, 18, 40)
    btn.BorderSizePixel = 0
    btn.Text = "EL2B"
    btn.TextColor3 = Color3.fromRGB(0, 200, 255)
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 13
    btn.AutoButtonColor = false
    btn.Active = true
    btn.Draggable = true
    btn.Parent = ToggleGui

    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(0, 200, 255)
    stroke.Thickness = 1.8
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 110, 210)),
    })
    grad.Parent = stroke

    task.spawn(function()
        local t = 0
        while btn.Parent do
            t += 0.05
            stroke.Transparency = 0.3 + math.sin(t * 2) * 0.3
            task.wait(0.05)
        end
    end)

    local menuOpen = true
    local MENU_NAMES = {
        ["El2bSemiTP"]          = true,
        ["El2b_AllowDisallow"]  = true,
        ["El2b_ProgressBar"]    = true,
        ["El2b_Speed_Only"]     = true,
        ["El2b_APSpamGui"]      = true,
        ["UI_Watermark"]        = true,
    }

    local function setMenuVisible(state)
        menuOpen = state
        for _, gui in ipairs(fn():GetChildren()) do
            if gui:IsA("ScreenGui") and MENU_NAMES[gui.Name] then
                gui.Enabled = state
            end
        end
    end

    btn.MouseButton1Click:Connect(function()
        setMenuVisible(not menuOpen)
        btn.Text = menuOpen and "EL2B" or "X"
        btn.TextColor3 = menuOpen
            and Color3.fromRGB(0, 200, 255)
            or Color3.fromRGB(255, 80, 80)
        stroke.Color = menuOpen
            and Color3.fromRGB(0, 200, 255)
            or Color3.fromRGB(255, 80, 80)
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(15, 30, 60),
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(8, 18, 40),
        }):Play()
    end)
end
