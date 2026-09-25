print("[EL2B HUB PVP] Script loading (lite)...")
task.wait(0.05)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local thisScriptStopped = false
local ActiveConnections = {}

-- ===== GLOBALS =====
_G.FlashSpeed = _G.FlashSpeed or 180
_G.TransportIndex = _G.TransportIndex or 1
_G.FPSBoostEnabled = _G.FPSBoostEnabled or false
_G.NoclipEnabled = _G.NoclipEnabled or false
_G.ReTPEnabled = _G.ReTPEnabled or true -- si TP après, re-téléporte

local Character = LocalPlayer.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
local Root = Character and Character:FindFirstChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(c)
    Character = c
    Humanoid = c:WaitForChild("Humanoid", 10)
    Root = c:WaitForChild("HumanoidRootPart", 10)
end)

-- ===== TRANSPORT =====
local TRANSPORT_OPTIONS = {
    "Flying Carpet",
    "Cupid's Wings",
    "Waverider",
    "Witch's Broom",
    "Santa's Sleigh",
}

local function findTool(name)
    local char = LocalPlayer.Character
    if not char then return nil end
    local lower = name:lower()
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") and t.Name:lower():find(lower, 1, true) then return t end
    end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find(lower, 1, true) then return t end
        end
    end
    return nil
end

local function equipTransport()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then return false end
    local idx = math.clamp(tonumber(_G.TransportIndex) or 1, 1, #TRANSPORT_OPTIONS)
    local tool = findTool(TRANSPORT_OPTIONS[idx])
        or findTool("carpet") or findTool("broom") or findTool("wing")
    if not tool then return false end
    pcall(function()
        hum:UnequipTools()
        task.wait(0.03)
        hum:EquipTool(tool)
    end)
    task.wait(0.08)
    return tool.Parent == char
end

-- ===== BRAINROT LIST =====
local selectedPrompt, selectedSlotNumber = nil, nil
local livePetPrompts = {}
local scrollListRef = nil
local currentMovement = nil
local autoStealEnabled = false
local isStealing = false

local function isMyPlot(plot)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yourBase = sign:FindFirstChild("YourBase")
        if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled then
            return true
        end
    end
    return false
end

local function isValidStealPrompt(prompt)
    if not prompt or not prompt.Parent or not prompt.Enabled then return false end
    local state = prompt:GetAttribute("State")
    local actionText = prompt.ActionText
    return state == "Steal" or state == "Grab" or actionText == "Steal" or actionText == "Grab"
end

local function firePromptConnections(prompt, signalName)
    if not getconnections then return end
    local connections = getconnections(prompt[signalName])
    for _, conn in ipairs(connections) do
        if conn.Function then task.spawn(conn.Function) end
    end
end

local function executeSteal(prompt)
    if isStealing or not prompt or not prompt.Parent then return end
    isStealing = true
    local hold = 0.1
    pcall(function()
        if prompt.HoldDuration and prompt.HoldDuration > 0 then
            hold = math.clamp(prompt.HoldDuration, 0.05, 1.5)
        end
    end)
    pcall(function()
        if fireproximityprompt then fireproximityprompt(prompt, hold) end
    end)
    pcall(function() firePromptConnections(prompt, "PromptButtonHoldBegan") end)
    task.wait(hold)
    pcall(function()
        firePromptConnections(prompt, "PromptButtonHoldEnded")
        firePromptConnections(prompt, "Triggered")
    end)
    pcall(function()
        if fireproximityprompt and prompt and prompt.Parent and prompt.Enabled then
            fireproximityprompt(prompt)
        end
    end)
    task.wait(0.05)
    isStealing = false
end

-- Slots (positions flash) — version courte, slots 1-10
local SlotsConfig = {
    [1] = { Positions = { Vector3.new(-345.4766, -6.0291, 1.5014) }, CamOffset = Vector3.new(-8.67, 10.06, 7.88), CamAngles = { -0.83, -0.64, -0.58 } },
    [2] = { Positions = { Vector3.new(-349.9259, -6.2791, -1.5767) }, CamOffset = Vector3.new(-13.28, 9.22, 4.88), CamAngles = { -1.01, -0.97, -0.92 } },
    [3] = { Positions = { Vector3.new(-349.9259, -6.2791, -1.5758) }, CamOffset = Vector3.new(-17.83, 10.60, 5.07), CamAngles = { -1.06, -1.04, -1.00 } },
    [4] = { Positions = { Vector3.new(-343.4199, -5.9197, 10.5505) }, CamOffset = Vector3.new(-15.67, 9.97, 10.45), CamAngles = { -0.68, -0.86, -0.55 } },
    [5] = { Positions = { Vector3.new(-343.7608, -6.3272, -9.7994) }, CamOffset = Vector3.new(-20.16, 5.93, 0.65), CamAngles = { -1.42, -1.35, -1.42 } },
}

local STOP_DIST, SLOW_DIST = 5, 20

-- ===== RE-TP : si après le flash tu es trop loin du target, re-téléporte =====
local lastFlashTarget = nil
local lastFlashSlot = nil
local reTPBusy = false

local function doReTP()
    if not _G.ReTPEnabled or reTPBusy then return end
    if not lastFlashTarget or not lastFlashTarget.Parent then return end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local targetPos = lastFlashTarget
    if typeof(targetPos) \~= "Vector3" then return end
    local dist = (root.Position - targetPos).Magnitude
    if dist < 12 then return end -- déjà proche
    reTPBusy = true
    pcall(function()
        root.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
        root.AssemblyLinearVelocity = Vector3.zero
    end)
    task.wait(0.15)
    -- re-grab
    if selectedPrompt and selectedPrompt.Parent then
        executeSteal(selectedPrompt)
    end
    reTPBusy = false
end

_G._175_ReTP = doReTP

-- ===== FLASH TP =====
local function startTripToPetSlot(prompt, slotNumber)
    local config = SlotsConfig[slotNumber] or {
        Positions = { prompt.Parent and (prompt.Parent:IsA("Attachment") and prompt.Parent.WorldPosition or Vector3.zero) or Vector3.zero },
        CamOffset = Vector3.new(-10, 8, 5),
        CamAngles = { 0, 0, 0 },
    }
    local targetPositions = config.Positions or { config.Position }
    if currentMovement then pcall(function() currentMovement:Disconnect() end) currentMovement = nil end

    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    autoStealEnabled = true
    lastFlashTarget = targetPositions[#targetPositions]
    lastFlashSlot = slotNumber

    local Speed = math.clamp(tonumber(_G.FlashSpeed) or 180, 20, 500)
    local grabStarted = false
    pcall(equipTransport)

    if root:FindFirstChild("LinearVelocity") then root.LinearVelocity:Destroy() end
    if root:FindFirstChild("Attachment") then root.Attachment:Destroy() end

    local Attachment = Instance.new("Attachment")
    Attachment.Parent = root
    local Velocity = Instance.new("LinearVelocity")
    Velocity.Attachment0 = Attachment
    Velocity.RelativeTo = Enum.ActuatorRelativeTo.World
    Velocity.MaxForce = math.huge
    Velocity.Parent = root

    local currentPosIndex = 1
    currentMovement = RunService.Heartbeat:Connect(function()
        if thisScriptStopped or not root.Parent or hum.Health <= 0 then
            if currentMovement then currentMovement:Disconnect() currentMovement = nil end
            return
        end
        local TargetPosition = targetPositions[currentPosIndex]
        if not TargetPosition then return end
        local rootPos = root.Position
        local dir = Vector3.new(TargetPosition.X - rootPos.X, 0, TargetPosition.Z - rootPos.Z)
        local dist = dir.Magnitude
        local finalPosition = targetPositions[#targetPositions]
        local finalDist = Vector3.new(finalPosition.X - rootPos.X, 0, finalPosition.Z - rootPos.Z).Magnitude

        if finalDist <= 70 and not grabStarted then
            grabStarted = true
            task.spawn(function()
                for _ = 1, 8 do
                    if thisScriptStopped or not prompt or not prompt.Parent then break end
                    if not isStealing then executeSteal(prompt) end
                    task.wait(0.35)
                end
            end)
        end

        local speedMult = 1
        if dist < SLOW_DIST then speedMult = math.max(0.15, dist / SLOW_DIST) end

        if dist <= STOP_DIST then
            if currentPosIndex < #targetPositions then
                currentPosIndex = currentPosIndex + 1
                return
            end
            Velocity.VectorVelocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.zero
            Velocity:Destroy()
            Attachment:Destroy()
            root.CFrame = CFrame.new(TargetPosition)
            if currentMovement then currentMovement:Disconnect() currentMovement = nil end

            task.wait(0.08)
            local flash = findTool("flash")
            if flash then
                hum:EquipTool(flash)
                task.wait(0.06)
                flash:Activate()
            end
            task.wait(0.15)

            -- RE-TP si après le flash on est encore loin
            if _G.ReTPEnabled then
                task.spawn(function()
                    task.wait(0.25)
                    doReTP()
                    task.wait(0.4)
                    doReTP() -- 2e tentative
                end)
            end

            task.spawn(function()
                task.wait(1.2)
                autoStealEnabled = false
            end)
            return
        end

        if dir.Magnitude > 0.1 then
            Velocity.VectorVelocity = Vector3.new(dir.Unit.X * Speed * speedMult, 0, dir.Unit.Z * Speed * speedMult)
        end
    end)
    table.insert(ActiveConnections, currentMovement)
end

-- ===== UPDATE PET LIST =====
local function updatePetList()
    if thisScriptStopped or not scrollListRef then return end
    local plotsFolder = Workspace:FindFirstChild("Plots")
    if not plotsFolder then return end

    local tempPets = {}
    for _, plot in ipairs(plotsFolder:GetChildren()) do
        if not isMyPlot(plot) then
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, podium in ipairs(podiums:GetChildren()) do
                    local slotNumber = tonumber(podium.Name:match("%d+")) or 1
                    local base = podium:FindFirstChild("Base") or podium
                    local spawnPoint = base:FindFirstChild("Spawn")
                    local attachment = spawnPoint and spawnPoint:FindFirstChild("PromptAttachment")
                    if attachment then
                        for _, child in ipairs(attachment:GetChildren()) do
                            if child:IsA("ProximityPrompt") and isValidStealPrompt(child) then
                                local petName = tostring(child.ObjectText or "Pet")
                                    :gsub("%s*%[.-%]%s*", ""):gsub("^%s+", ""):gsub("%s+$", "")
                                table.insert(tempPets, {
                                    prompt = child,
                                    slot = slotNumber,
                                    name = petName,
                                })
                            end
                        end
                    end
                end
            end
        end
    end
    table.sort(tempPets, function(a, b) return a.slot < b.slot end)

    livePetPrompts = {}
    for _, pet in ipairs(tempPets) do
        livePetPrompts[tostring(pet.slot) .. "_" .. pet.name] = pet
    end

    for _, child in ipairs(scrollListRef:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    for i, petData in ipairs(tempPets) do
        local rowKey = tostring(petData.slot) .. "_" .. petData.name
        local isSelected = (selectedPrompt == petData.prompt)
        local row = Instance.new("Frame")
        row.Name = rowKey
        row.Size = UDim2.new(1, -6, 0, 42)
        row.BackgroundColor3 = isSelected and Color3.fromRGB(80, 10, 10) or Color3.fromRGB(40, 14, 14)
        row.BorderSizePixel = 0
        row.LayoutOrder = i
        row.Parent = scrollListRef
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

        local nameL = Instance.new("TextLabel")
        nameL.Size = UDim2.new(1, -10, 0, 22)
        nameL.Position = UDim2.new(0, 8, 0, 4)
        nameL.BackgroundTransparency = 1
        nameL.Text = petData.name
        nameL.TextColor3 = Color3.fromRGB(255, 220, 220)
        nameL.Font = Enum.Font.GothamBold
        nameL.TextSize = 11
        nameL.TextXAlignment = Enum.TextXAlignment.Left
        nameL.Parent = row

        local slotL = Instance.new("TextLabel")
        slotL.Size = UDim2.new(1, -10, 0, 14)
        slotL.Position = UDim2.new(0, 8, 0, 24)
        slotL.BackgroundTransparency = 1
        slotL.Text = "Slot " .. petData.slot
        slotL.TextColor3 = Color3.fromRGB(255, 90, 100)
        slotL.Font = Enum.Font.Gotham
        slotL.TextSize = 10
        slotL.TextXAlignment = Enum.TextXAlignment.Left
        slotL.Parent = row

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = row
        btn.MouseButton1Click:Connect(function()
            local data = livePetPrompts[rowKey]
            if data and data.prompt and data.prompt.Parent then
                selectedPrompt = data.prompt
                selectedSlotNumber = data.slot
                updatePetList()
            end
        end)
    end
end

-- ===== NOCLIP =====
local noclipConn = nil
local function setNoclip(on)
    _G.NoclipEnabled = on and true or false
    if noclipConn then
        pcall(function() noclipConn:Disconnect() end)
        noclipConn = nil
    end
    if not on then
        -- restore collision
        local char = LocalPlayer.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    pcall(function() p.CanCollide = true end)
                end
            end
        end
        return
    end
    noclipConn = RunService.Stepped:Connect(function()
        if not _G.NoclipEnabled or thisScriptStopped then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end)
    table.insert(ActiveConnections, noclipConn)
end
_G._175_SetNoclip = setNoclip

-- ===== ANTI LAG / FPS BOOST =====
task.spawn(function()
    local Lighting = game:GetService("Lighting")
    local antiLagEnabled, nukeEnabled = false, false
    local antiLagDescConn = nil
    local _nukeConns = {}

    local function processAntiLagDescendant(obj)
        pcall(function()
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
                or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
                obj:Destroy()
            elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                obj:Destroy()
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                if not (obj.Name == "face" and obj.Parent and obj.Parent.Name == "Head") then
                    obj:Destroy()
                end
            end
        end)
    end

    local function enableAntiLag()
        antiLagEnabled = true
        for _, obj in ipairs(Workspace:GetDescendants()) do
            processAntiLagDescendant(obj)
        end
        if antiLagDescConn then antiLagDescConn:Disconnect() end
        antiLagDescConn = Workspace.DescendantAdded:Connect(function(obj)
            if antiLagEnabled then task.defer(processAntiLagDescendant, obj) end
        end)
    end

    local function disableAntiLag()
        antiLagEnabled = false
        if antiLagDescConn then antiLagDescConn:Disconnect() antiLagDescConn = nil end
    end

    local function enableNuke()
        if nukeEnabled then return end
        nukeEnabled = true
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            if setfpscap then setfpscap(999) end
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect")
                    or v:IsA("Atmosphere") or v:IsA("Clouds") then
                    v:Destroy()
                end
            end
        end)
        for _, obj in ipairs(Workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("BasePart") then
                    obj.CastShadow = false
                    obj.Material = Enum.Material.Plastic
                    obj.Reflectance = 0
                end
            end)
        end
    end

    local function disableNuke()
        nukeEnabled = false
        for _, c in ipairs(_nukeConns) do pcall(function() c:Disconnect() end) end
        _nukeConns = {}
    end

    _G.AceFPSBoost = {
        EnableAll = function()
            pcall(function()
                local cam = workspace.CurrentCamera
                if cam then
                    local cur = cam.ViewportSize
                    cam.ViewportSize = Vector2.new(math.floor(cur.X * 0.7), math.floor(cur.Y * 0.7))
                end
                if setfpscap then setfpscap(999) end
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            end)
            enableAntiLag()
            enableNuke()
        end,
        DisableAll = function()
            disableAntiLag()
            disableNuke()
        end,
    }

    if _G.FPSBoostEnabled then
        task.defer(function() _G.AceFPSBoost.EnableAll() end)
    end
end)

-- ===== GUI LITE =====
local function buildGUI()
    local old = PlayerGui:FindFirstChild("EL2B_LITE")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "EL2B_LITE"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999
    gui.Parent = PlayerGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 220, 0, 320)
    main.Position = UDim2.new(0.5, -110, 0.5, -160)
    main.BackgroundColor3 = Color3.fromRGB(18, 8, 8)
    main.BorderSizePixel = 0
    main.Active = true
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
    local st = Instance.new("UIStroke")
    st.Color = Color3.fromRGB(220, 25, 45)
    st.Thickness = 1.5
    st.Parent = main

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 28)
    title.BackgroundTransparency = 1
    title.Text = "EL2B LITE"
    title.TextColor3 = Color3.fromRGB(255, 220, 220)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.Parent = main

    -- Boutons
    local function mkBtn(text, y, color)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -16, 0, 28)
        b.Position = UDim2.new(0, 8, 0, y)
        b.BackgroundColor3 = color or Color3.fromRGB(40, 14, 14)
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 11
        b.BorderSizePixel = 0
        b.Parent = main
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        return b
    end

    local flashBtn = mkBtn("FLASH TP", 32, Color3.fromRGB(140, 25, 35))
    local retpBtn = mkBtn("RE-TP: ON", 64, Color3.fromRGB(50, 20, 20))
    local noclipBtn = mkBtn("NOCLIP: OFF", 96, Color3.fromRGB(50, 20, 20))
    local fpsBtn = mkBtn("ANTI LAG: OFF", 128, Color3.fromRGB(50, 20, 20))

    -- Liste brainrots
    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, -12, 0, 150)
    listFrame.Position = UDim2.new(0, 6, 0, 164)
    listFrame.BackgroundColor3 = Color3.fromRGB(24, 10, 10)
    listFrame.BorderSizePixel = 0
    listFrame.ScrollBarThickness = 3
    listFrame.ScrollBarImageColor3 = Color3.fromRGB(220, 25, 45)
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listFrame.Parent = main
    Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 6)
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 3)
    lay.Parent = listFrame
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 4)
    pad.Parent = listFrame
    scrollListRef = listFrame

    flashBtn.MouseButton1Click:Connect(function()
        if selectedPrompt and selectedSlotNumber and not autoStealEnabled then
            startTripToPetSlot(selectedPrompt, selectedSlotNumber)
        end
    end)

    retpBtn.MouseButton1Click:Connect(function()
        _G.ReTPEnabled = not _G.ReTPEnabled
        retpBtn.Text = _G.ReTPEnabled and "RE-TP: ON" or "RE-TP: OFF"
        retpBtn.BackgroundColor3 = _G.ReTPEnabled and Color3.fromRGB(40, 120, 50) or Color3.fromRGB(50, 20, 20)
    end)
    if _G.ReTPEnabled then
        retpBtn.Text = "RE-TP: ON"
        retpBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 50)
    end

    noclipBtn.MouseButton1Click:Connect(function()
        setNoclip(not _G.NoclipEnabled)
        noclipBtn.Text = _G.NoclipEnabled and "NOCLIP: ON" or "NOCLIP: OFF"
        noclipBtn.BackgroundColor3 = _G.NoclipEnabled and Color3.fromRGB(40, 120, 50) or Color3.fromRGB(50, 20, 20)
    end)

    fpsBtn.MouseButton1Click:Connect(function()
        _G.FPSBoostEnabled = not _G.FPSBoostEnabled
        if _G.AceFPSBoost then
            if _G.FPSBoostEnabled then _G.AceFPSBoost.EnableAll() else _G.AceFPSBoost.DisableAll() end
        end
        fpsBtn.Text = _G.FPSBoostEnabled and "ANTI LAG: ON" or "ANTI LAG: OFF"
        fpsBtn.BackgroundColor3 = _G.FPSBoostEnabled and Color3.fromRGB(40, 120, 50) or Color3.fromRGB(50, 20, 20)
    end)

    -- Drag
    local dragging, dragStart, startPos
    title.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Refresh liste
    task.spawn(function()
        while not thisScriptStopped do
            pcall(updatePetList)
            task.wait(1.2)
        end
    end)
    updatePetList()
end

buildGUI()
print("[EL2B HUB PVP] Lite chargé — Brainrots + Flash + ReTP + Noclip + AntiLag")
