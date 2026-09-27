local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local sg = Instance.new("ScreenGui")
sg.Name = "AdminPanel"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.Parent = pg

local TITLE_H = 38
local BAR_H = 40
local PAD = 5
local BTN_SIZE = 32
local BTN_GAP = 4
local NUM_BTNS = 6
local BTNS_TOTAL = NUM_BTNS * (BTN_SIZE + BTN_GAP) - BTN_GAP + 14
local BAR_MIN_W = BTNS_TOTAL + 10

local currentScalePercent = 45
local currentTransparencyPercent = 35
local saveSettingsEnabled = true
local savedXOffset = nil
local savedYOffset = nil
local FILE_NAME = "AdminPanel_Config.json"

-- ═══════════════ ÉTAT DES ANIMATIONS ═══════════════
local ANIM_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local ANIM_MED  = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local ANIM_SOFT = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- ═══════════════ SAUVEGARDE / CHARGEMENT ═══════════════
local function loadSettings()
    if not saveSettingsEnabled then return end
    if readfile and isfile and isfile(FILE_NAME) then
        local success, content = pcall(readfile, FILE_NAME)
        if success and content then
            local success2, data = pcall(function() return HttpService:JSONDecode(content) end)
            if success2 and data then
                if data.SaveEnabled ~= nil then saveSettingsEnabled = data.SaveEnabled end
                if saveSettingsEnabled then
                    if data.Scale then currentScalePercent = data.Scale end
                    if data.Trans then currentTransparencyPercent = data.Trans end
                    if data.XOffset then savedXOffset = data.XOffset end
                    if data.YOffset then savedYOffset = data.YOffset end
                end
            end
        end
    end
end

local function saveCurrentSettings()
    if writefile then
        local data = {
            SaveEnabled = saveSettingsEnabled,
            Scale = currentScalePercent,
            Trans = currentTransparencyPercent,
            XOffset = savedXOffset,
            YOffset = savedYOffset
        }
        local success, content = pcall(function() return HttpService:JSONEncode(data) end)
        if success then pcall(writefile, FILE_NAME, content) end
    end
end

loadSettings()

local function getFullWidth()
    local minW = BAR_MIN_W + 10
    local maxW = 550
    return minW + ((maxW - minW) * (currentScalePercent / 100))
end

local namesShown = true
local function getCurrentWidth()
    return namesShown and getFullWidth() or (BAR_MIN_W + 10)
end

local function getTransparencyValue()
    return currentTransparencyPercent / 100
end

-- ═══════════════ FRAME PRINCIPAL ═══════════════
local frame = Instance.new("Frame")
frame.BackgroundColor3 = Color3.fromRGB(10, 12, 28)
frame.BorderSizePixel = 0
frame.Active = true
frame.ClipsDescendants = true
frame.Parent = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local fs = Instance.new("UIStroke", frame)
fs.Color = Color3.fromRGB(15, 60, 160)
fs.Thickness = 2

-- ═══════════════ BARRE DE TITRE ═══════════════
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, TITLE_H)
titleBar.BackgroundColor3 = Color3.fromRGB(12, 14, 32)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -130, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Admin Panel"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Animation du titre : pulse de couleur
task.spawn(function()
    local colors = {
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(120, 200, 255),
        Color3.fromRGB(150, 120, 255),
        Color3.fromRGB(255, 255, 255),
    }
    while titleLabel.Parent do
        for i = 1, #colors - 1 do
            local t = TS:Create(titleLabel, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {TextColor3 = colors[i + 1]})
            t:Play()
            t.Completed:Wait()
        end
        task.wait(0.5)
    end
end)

task.spawn(function()
    task.wait(4)
    local fadeOut = TS:Create(titleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 1})
    fadeOut:Play(); fadeOut.Completed:Wait()
    titleLabel.Text = "singe311"
    local fadeIn = TS:Create(titleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 0})
    fadeIn:Play()
end)

-- Fonction utilitaire pour animer un bouton de titre
local function stylizeTitleBtn(btn, text)
    btn.Size = UDim2.new(0, 26, 0, 26)
    btn.BackgroundColor3 = Color3.fromRGB(25, 35, 75)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 220, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = titleBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    btn.MouseEnter:Connect(function()
        TS:Create(btn, ANIM_FAST, {BackgroundColor3 = Color3.fromRGB(40, 70, 150), Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset - 1, 0.5, -14)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TS:Create(btn, ANIM_FAST, {BackgroundColor3 = Color3.fromRGB(25, 35, 75), Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset + 1, 0.5, -13)}):Play()
    end)
    return btn
end

local minBtn = stylizeTitleBtn(Instance.new("TextButton"), "–")
minBtn.Position = UDim2.new(1, -92, 0.5, -13)

local settingsBtn = stylizeTitleBtn(Instance.new("TextButton"), "⚙️")
settingsBtn.Position = UDim2.new(1, -62, 0.5, -13)
settingsBtn.TextSize = 13

local lockBtn = stylizeTitleBtn(Instance.new("TextButton"), "🔓")
lockBtn.Position = UDim2.new(1, -32, 0.5, -13)

-- ═══════════════ PANNEAU SETTINGS ═══════════════
local SETTINGS_HEIGHT = 142
local settingsFrame = Instance.new("Frame")
settingsFrame.Size = UDim2.new(1, -10, 0, SETTINGS_HEIGHT)
settingsFrame.BackgroundColor3 = Color3.fromRGB(13, 17, 34)
settingsFrame.BorderSizePixel = 0
settingsFrame.Visible = false
settingsFrame.ClipsDescendants = true
settingsFrame.Parent = frame
Instance.new("UICorner", settingsFrame).CornerRadius = UDim.new(0, 12)

local ss = Instance.new("UIStroke", settingsFrame)
ss.Color = Color3.fromRGB(20, 45, 100)
ss.Thickness = 1

local function makeLabel(text, y, size, font)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -40, 0, size or 14)
    l.Position = UDim2.new(0, 20, 0, y)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.TextSize = 10
    l.Font = font or Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Center
    l.Parent = settingsFrame
    return l
end

makeLabel("SIZE CONFIG", 8)
local sizeSub = makeLabel(currentScalePercent .. "%", 21, 12)
sizeSub.TextSize = 9

local sizeValBtn = Instance.new("TextButton")
sizeValBtn.Size = UDim2.new(0, 32, 0, 20)
sizeValBtn.Position = UDim2.new(1, -52, 0, 22)
sizeValBtn.BackgroundColor3 = Color3.fromRGB(18, 24, 47)
sizeValBtn.Text = tostring(currentScalePercent)
sizeValBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeValBtn.TextSize = 9
sizeValBtn.Font = Enum.Font.GothamBold
sizeValBtn.AutoButtonColor = false
sizeValBtn.Parent = settingsFrame
Instance.new("UICorner", sizeValBtn).CornerRadius = UDim.new(0, 4)

local sBord = Instance.new("UIStroke", sizeValBtn)
sBord.Color = Color3.fromRGB(30, 50, 95)

local sizeInput = Instance.new("TextBox")
sizeInput.Size = UDim2.new(1, 0, 1, 0)
sizeInput.BackgroundTransparency = 1
sizeInput.Text = ""
sizeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeInput.TextSize = 9
sizeInput.Font = Enum.Font.GothamBold
sizeInput.Visible = false
sizeInput.ClearTextOnFocus = true
sizeInput.Parent = sizeValBtn

-- Fonction slider générique
local function makeSlider(y, initialPct)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -84, 0, 2)
    bg.Position = UDim2.new(0, 20, 0, y)
    bg.BackgroundColor3 = Color3.fromRGB(22, 28, 53)
    bg.BorderSizePixel = 0
    bg.Parent = settingsFrame
    Instance.new("UICorner", bg)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(initialPct/100, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(20, 85, 215)
    fill.BorderSizePixel = 0
    fill.Parent = bg
    Instance.new("UICorner", fill)

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new(initialPct/100, -4, 0.5, -4)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.Parent = bg
    Instance.new("UICorner", dot)

    return bg, fill, dot
end

local sizeSliderBg, sizeSliderFill, sizeDot = makeSlider(32, currentScalePercent)

makeLabel("TRANSPARENCY CONFIG", 52)
local transSub = makeLabel(currentTransparencyPercent .. "%", 65, 12)
transSub.TextSize = 9

local transValBtn = Instance.new("TextButton")
transValBtn.Size = UDim2.new(0, 32, 0, 20)
transValBtn.Position = UDim2.new(1, -52, 0, 66)
transValBtn.BackgroundColor3 = Color3.fromRGB(18, 24, 47)
transValBtn.Text = tostring(currentTransparencyPercent)
transValBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
transValBtn.TextSize = 9
transValBtn.Font = Enum.Font.GothamBold
transValBtn.AutoButtonColor = false
transValBtn.Parent = settingsFrame
Instance.new("UICorner", transValBtn).CornerRadius = UDim.new(0, 4)

local tBord = Instance.new("UIStroke", transValBtn)
tBord.Color = Color3.fromRGB(30, 50, 95)

local transInput = Instance.new("TextBox")
transInput.Size = UDim2.new(1, 0, 1, 0)
transInput.BackgroundTransparency = 1
transInput.Text = ""
transInput.TextColor3 = Color3.fromRGB(255, 255, 255)
transInput.TextSize = 9
transInput.Font = Enum.Font.GothamBold
transInput.Visible = false
transInput.ClearTextOnFocus = true
transInput.Parent = transValBtn

local transSliderBg, transSliderFill, transDot = makeSlider(76, currentTransparencyPercent)

-- ═══════════════ TOGGLE SAVE ═══════════════
local saveContainer = Instance.new("Frame")
saveContainer.Size = UDim2.new(1, -84, 0, 26)
saveContainer.Position = UDim2.new(0, 20, 0, 104)
saveContainer.BackgroundColor3 = Color3.fromRGB(15, 22, 45)
saveContainer.BorderSizePixel = 0
saveContainer.Parent = settingsFrame
Instance.new("UICorner", saveContainer).CornerRadius = UDim.new(0, 13)

local scS = Instance.new("UIStroke", saveContainer)
scS.Color = Color3.fromRGB(25, 70, 160)
scS.Thickness = 1.1

local saveTextLabel = Instance.new("TextLabel")
saveTextLabel.Size = UDim2.new(1, -50, 1, 0)
saveTextLabel.Position = UDim2.new(0, 12, 0, 0)
saveTextLabel.BackgroundTransparency = 1
saveTextLabel.Text = "SAVE CONFIG"
saveTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
saveTextLabel.TextSize = 9
saveTextLabel.Font = Enum.Font.GothamBold
saveTextLabel.TextXAlignment = Enum.TextXAlignment.Left
saveTextLabel.Parent = saveContainer

local toggleBg = Instance.new("TextButton")
toggleBg.Size = UDim2.new(0, 30, 0, 14)
toggleBg.Position = UDim2.new(1, -38, 0.5, -7)
toggleBg.Text = ""
toggleBg.BorderSizePixel = 0
toggleBg.AutoButtonColor = false
toggleBg.Parent = saveContainer
Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

local toggleBall = Instance.new("Frame")
toggleBall.Size = UDim2.new(0, 10, 0, 10)
toggleBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleBall.BorderSizePixel = 0
toggleBall.Parent = toggleBg
Instance.new("UICorner", toggleBall)

local function updateSaveToggleVisual(animate)
    local targetBgColor = saveSettingsEnabled and Color3.fromRGB(20, 85, 215) or Color3.fromRGB(35, 42, 65)
    local targetBallPos = saveSettingsEnabled and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
    if animate then
        TS:Create(toggleBg, ANIM_FAST, {BackgroundColor3 = targetBgColor}):Play()
        TS:Create(toggleBall, ANIM_FAST, {Position = targetBallPos}):Play()
    else
        toggleBg.BackgroundColor3 = targetBgColor
        toggleBall.Position = targetBallPos
    end
end

updateSaveToggleVisual(false)

toggleBg.MouseButton1Click:Connect(function()
    saveSettingsEnabled = not saveSettingsEnabled
    updateSaveToggleVisual(true)
    saveCurrentSettings()
end)

-- ═══════════════ LOCK ═══════════════
local locked = false
lockBtn.MouseButton1Click:Connect(function()
    locked = not locked
    lockBtn.Text = locked and "🔒" or "🔓"
    TS:Create(lockBtn, ANIM_FAST, {BackgroundColor3 = locked and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(25, 35, 75)}):Play()
end)

-- ═══════════════ DRAG ═══════════════
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(i)
    if locked then return end
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = i.Position; startPos = frame.Position
    end
end)

UIS.InputChanged:Connect(function(i)
    if dragging and not locked and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            dragging = false
            savedXOffset = frame.Position.X.Offset
            savedYOffset = frame.Position.Y.Offset
            saveCurrentSettings()
        end
    end
end)

-- ═══════════════ SYSTÈME DE COMMANDES ═══════════════
local function getAdminPanel()
    local ap = lp.PlayerGui:FindFirstChild("AdminPanel")
    if not ap then return nil, nil end
    local panel = ap:FindFirstChild("AdminPanel")
    if not panel then return nil, nil end
    local content = panel:FindFirstChild("Content")
    local profiles = panel:FindFirstChild("Profiles")
    if not content or not profiles then return nil, nil end
    return content:FindFirstChild("ScrollingFrame"), profiles:FindFirstChild("ScrollingFrame")
end

local commandCache = {}
local profileCache = {}

local function getConnections(button)
    local conns = {}
    local ok, list = pcall(getconnections, button.Activated)
    if ok and type(list) == "table" then
        for _, conn in ipairs(list) do
            if type(conn.Function) == "function" then
                table.insert(conns, conn.Function)
            end
        end
    end
    return conns
end

local function cacheButton(button, cache)
    if cache[button] then return cache[button] end
    cache[button] = getConnections(button)
    return cache[button]
end

local function fireCached(cached)
    for _, fn in ipairs(cached) do
        task.spawn(fn)
    end
end

local function sendAdminCommand(targetPlayer, commandName)
    local cmdFrame, profileFrame = getAdminPanel()
    if not cmdFrame or not profileFrame then return false end
    local profileBtn = profileFrame:FindFirstChild(targetPlayer.Name)
    local commandBtn = cmdFrame:FindFirstChild(commandName)
    if not profileBtn or not commandBtn then return false end
    local profileCached = cacheButton(profileBtn, profileCache)
    local commandCached = cacheButton(commandBtn, commandCache)
    fireCached(profileCached)
    task.wait(0.05)
    fireCached(commandCached)
    return true
end

local commands = {
    {emoji = "🔄", cmd = "control", cooldown = 60},
    {emoji = "🔬", cmd = "tiny",    cooldown = 60},
    {emoji = "🔒", cmd = "jail",    cooldown = 60},
    {emoji = "🚀", cmd = "rocket",  cooldown = 120},
    {emoji = "🤾", cmd = "ragdoll", cooldown = 30},
    {emoji = "🎈", cmd = "balloon", cooldown = 30},
}

local settingsShown = false
local bars = {}
local cooldownEndTimes = {}

local function getFrameH()
    local count = 0
    for _ in pairs(bars) do count = count + 1 end
    local h = TITLE_H + count * (BAR_H + PAD) + PAD
    if settingsShown then h = h + (SETTINGS_HEIGHT + 5) end
    return h
end

local function applyVisualUpdates()
    local transValue = getTransparencyValue()
    frame.BackgroundTransparency = transValue
    titleBar.BackgroundTransparency = transValue
    local fW = getCurrentWidth()
    frame.Size = UDim2.new(0, fW, 0, getFrameH())

    local i = 0
    for _, b in pairs(bars) do
        local yPos = TITLE_H + PAD + i * (BAR_H + PAD)
        if settingsShown then yPos = yPos + (SETTINGS_HEIGHT + 5) end
        b.outer.Position = UDim2.new(0, 5, 0, yPos)
        b.bar.BackgroundTransparency = transValue
        local outerW = namesShown and (getFullWidth() - 10) or BAR_MIN_W
        b.bar.Size = UDim2.new(0, outerW, 1, 0)
        i = i + 1
    end

    if settingsShown then
        settingsFrame.Position = UDim2.new(0, 5, 0, TITLE_H + PAD)
        settingsFrame.Size = UDim2.new(1, -10, 0, SETTINGS_HEIGHT)
    end
end

-- ═══════════════ SLIDERS ═══════════════
local function setupSlider(sliderBg, sliderFill, sliderDot, subText, valBtn, callback)
    local isSliding = false
    local function updateSlider(input)
        local rect = sliderBg.AbsoluteSize
        if rect.X == 0 then return end
        local posX = input.Position.X - sliderBg.AbsolutePosition.X
        local pct = math.clamp(posX / rect.X, 0, 1)
        sliderFill.Size = UDim2.new(pct, 0, 1, 0)
        sliderDot.Position = UDim2.new(pct, -4, 0.5, -4)
        local finalPercent = math.round(pct * 100)
        subText.Text = finalPercent .. "%"
        valBtn.Text = finalPercent
        callback(finalPercent)
    end
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = true; updateSlider(input)
            TS:Create(sliderDot, ANIM_FAST, {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(sliderDot.Position.X.Scale, -6, 0.5, -6)}):Play()
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if isSliding then
                isSliding = false; saveCurrentSettings()
                TS:Create(sliderDot, ANIM_FAST, {Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(sliderDot.Position.X.Scale, -4, 0.5, -4)}):Play()
            end
        end
    end)
end

setupSlider(sizeSliderBg, sizeSliderFill, sizeDot, sizeSub, sizeValBtn, function(pct) currentScalePercent = pct; applyVisualUpdates() end)
setupSlider(transSliderBg, transSliderFill, transDot, transSub, transValBtn, function(pct) currentTransparencyPercent = pct; applyVisualUpdates() end)

local function setupDirectInput(valBtn, inputTextBox, sliderFill, sliderDot, subText, callback)
    valBtn.MouseButton1Click:Connect(function()
        valBtn.Text = ""; inputTextBox.Visible = true; inputTextBox:CaptureFocus()
    end)
    inputTextBox.FocusLost:Connect(function()
        inputTextBox.Visible = false
        local num = tonumber(inputTextBox.Text)
        if num then
            num = math.clamp(math.round(num), 0, 100)
            valBtn.Text = num
            subText.Text = num .. "%"
            sliderFill.Size = UDim2.new(num/100, 0, 1, 0)
            sliderDot.Position = UDim2.new(num/100, -4, 0.5, -4)
            callback(num); saveCurrentSettings()
        else
            valBtn.Text = math.round(sliderFill.Size.X.Scale * 100)
        end
        inputTextBox.Text = ""
    end)
end

setupDirectInput(sizeValBtn, sizeInput, sizeSliderFill, sizeDot, sizeSub, function(num) currentScalePercent = num; applyVisualUpdates() end)
setupDirectInput(transValBtn, transInput, transSliderFill, transDot, transSub, function(num) currentTransparencyPercent = num; applyVisualUpdates() end)

-- ═══════════════ AJOUT D'UNE BARRE JOUEUR (avec animations) ═══════════════
local function addBar(p)
    cooldownEndTimes[p.UserId] = {}
    local isLocal = (p == lp)

    local barOuter = Instance.new("Frame")
    barOuter.Size = UDim2.new(1, -10, 0, BAR_H)
    barOuter.BackgroundTransparency = 1
    barOuter.ClipsDescendants = true
    barOuter.Parent = frame

    local bar = Instance.new("Frame")
    -- Couleur spéciale pour toi-même
    bar.BackgroundColor3 = isLocal and Color3.fromRGB(20, 30, 65) or Color3.fromRGB(10, 10, 22)
    bar.BorderSizePixel = 0
    bar.ClipsDescendants = true
    bar.Parent = barOuter
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 10)

    local bs = Instance.new("UIStroke", bar)
    bs.Color = isLocal and Color3.fromRGB(80, 160, 255) or Color3.fromRGB(20, 50, 140)
    bs.Thickness = isLocal and 1.6 or 1.2

    local grad = Instance.new("UIGradient", bar)
    if isLocal then
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 40, 90)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 80, 170)),
        })
    else
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 8, 20)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 25, 65)),
        })
    end
    grad.Rotation = 90

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 140, 1, 0)
    nameLabel.Position = UDim2.new(0, 10, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = (isLocal and "⭐ " or "") .. p.DisplayName .. " (@" .. p.Name .. ")"
    nameLabel.TextColor3 = isLocal and Color3.fromRGB(160, 220, 255) or Color3.fromRGB(220, 230, 255)
    nameLabel.TextSize = 10
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 5
    nameLabel.Parent = bar

    for i, data in ipairs(commands) do
        local cmdBtn = Instance.new("TextButton")
        cmdBtn.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
        cmdBtn.Position = UDim2.new(1, -(BTNS_TOTAL) + (i-1)*(BTN_SIZE+BTN_GAP), 0.5, -BTN_SIZE/2)
        cmdBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 50)
        cmdBtn.BorderSizePixel = 0
        cmdBtn.Text = data.emoji
        cmdBtn.TextSize = 17
        cmdBtn.Font = Enum.Font.GothamBold
        cmdBtn.AutoButtonColor = false
        cmdBtn.ZIndex = 5
        cmdBtn.Parent = bar
        Instance.new("UICorner", cmdBtn).CornerRadius = UDim.new(0, 8)

        -- Animation hover : grow + glow
        cmdBtn.MouseEnter:Connect(function()
            local now = os.clock()
            if not cooldownEndTimes[p.UserId][i] or now >= cooldownEndTimes[p.UserId][i] then
                TS:Create(cmdBtn, ANIM_FAST, {
                    BackgroundColor3 = Color3.fromRGB(25, 90, 200),
                    Size = UDim2.new(0, BTN_SIZE + 3, 0, BTN_SIZE + 3),
                    Position = UDim2.new(1, -(BTNS_TOTAL) + (i-1)*(BTN_SIZE+BTN_GAP) - 1.5, 0.5, -(BTN_SIZE+3)/2)
                }):Play()
            end
        end)

        cmdBtn.MouseLeave:Connect(function()
            local now = os.clock()
            if not cooldownEndTimes[p.UserId][i] or now >= cooldownEndTimes[p.UserId][i] then
                TS:Create(cmdBtn, ANIM_FAST, {
                    BackgroundColor3 = Color3.fromRGB(20, 25, 50),
                    Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE),
                    Position = UDim2.new(1, -(BTNS_TOTAL) + (i-1)*(BTN_SIZE+BTN_GAP), 0.5, -BTN_SIZE/2)
                }):Play()
            end
        end)

        -- Animation click : press effect
        cmdBtn.MouseButton1Down:Connect(function()
            TS:Create(cmdBtn, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, BTN_SIZE - 3, 0, BTN_SIZE - 3),
                Position = UDim2.new(1, -(BTNS_TOTAL) + (i-1)*(BTN_SIZE+BTN_GAP) + 1.5, 0.5, -(BTN_SIZE-3)/2)
            }):Play()
        end)

        cmdBtn.MouseButton1Up:Connect(function()
            TS:Create(cmdBtn, ANIM_SOFT, {
                Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE),
                Position = UDim2.new(1, -(BTNS_TOTAL) + (i-1)*(BTN_SIZE+BTN_GAP), 0.5, -BTN_SIZE/2)
            }):Play()
        end)

        cmdBtn.MouseButton1Click:Connect(function()
            local now = os.clock()
            if cooldownEndTimes[p.UserId][i] and now < cooldownEndTimes[p.UserId][i] then return end
            local clickTime = os.clock()
            task.spawn(function()
                local success = sendAdminCommand(p, data.cmd)
                if success then
                    local elapsed = os.clock() - clickTime
                    local remaining = math.max(0.1, data.cooldown - elapsed)
                    cooldownEndTimes[p.UserId][i] = os.clock() + remaining
                    -- Flash rouge de cooldown
                    TS:Create(cmdBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 30, 30)}):Play()
                    task.delay(remaining, function()
                        if cmdBtn and cmdBtn.Parent then
                            cooldownEndTimes[p.UserId][i] = nil
                            TS:Create(cmdBtn, ANIM_MED, {BackgroundColor3 = Color3.fromRGB(20, 25, 50)}):Play()
                        end
                    end)
                else
                    -- Flash gris si échec
                    TS:Create(cmdBtn, ANIM_MED, {BackgroundColor3 = Color3.fromRGB(20, 25, 50)}):Play()
                end
            end)
        end)
    end

    bars[p.UserId] = {outer = barOuter, bar = bar, name = nameLabel}

    -- ═══ ANIMATION D'ENTRÉE : fade + slide depuis la gauche ═══
    bar.BackgroundTransparency = 1
    nameLabel.TextTransparency = 1
    applyVisualUpdates()
    -- Position initiale décalée (slide)
    local finalBarPos = bar.Position
    local finalOuterPos = barOuter.Position
    bar.Position = UDim2.new(finalBarPos.X.Scale, finalBarPos.X.Offset - 60, finalBarPos.Y.Scale, finalBarPos.Y.Offset)
    -- Fade du fond
    local targetTrans = getTransparencyValue()
    TS:Create(bar, ANIM_MED, {BackgroundTransparency = targetTrans}):Play()
    TS:Create(nameLabel, ANIM_MED, {TextTransparency = 0}):Play()
    TS:Create(bar, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = finalBarPos
    }):Play()
end

local function removeBar(p)
    if bars[p.UserId] then
        local data = bars[p.UserId]
        bars[p.UserId] = nil
        cooldownEndTimes[p.UserId] = nil
        -- Animation de sortie
        local t1 = TS:Create(data.bar, ANIM_MED, {BackgroundTransparency = 1})
        local t2 = TS:Create(data.name, ANIM_MED, {TextTransparency = 1})
        t1:Play(); t2:Play()
        t1.Completed:Wait()
        if data.outer then data.outer:Destroy() end
        applyVisualUpdates()
    end
end

-- ═══════════════ AFFICHER TOUS LES JOUEURS (y compris soi-même) ═══════════════
for _, p in ipairs(Players:GetPlayers()) do
    addBar(p)  -- plus de filtre
end

Players.PlayerAdded:Connect(function(p)
    addBar(p)  -- plus de filtre
end)

Players.PlayerRemoving:Connect(removeBar)

-- ═══════════════ BOUTONS DU TITRE ═══════════════
minBtn.MouseButton1Click:Connect(function()
    namesShown = not namesShown
    minBtn.Text = namesShown and "–" or "+"
    local targetW = getCurrentWidth()
    TS:Create(frame, ANIM_MED, {Size = UDim2.new(0, targetW, 0, getFrameH())}):Play()
    for _, data in pairs(bars) do
        local outerW = namesShown and (getFullWidth() - 10) or BAR_MIN_W
        data.name.Visible = namesShown
        TS:Create(data.bar, ANIM_MED, {Size = UDim2.new(0, outerW, 1, 0)}):Play()
    end
end)

settingsBtn.MouseButton1Click:Connect(function()
    settingsShown = not settingsShown
    settingsFrame.Visible = settingsShown
    local targetW = getCurrentWidth()
    TS:Create(frame, ANIM_MED, {Size = UDim2.new(0, targetW, 0, getFrameH())}):Play()

    -- Animation d'ouverture du panneau settings
    if settingsShown then
        settingsFrame.Size = UDim2.new(1, -10, 0, 0)
        TS:Create(settingsFrame, ANIM_MED, {Size = UDim2.new(1, -10, 0, SETTINGS_HEIGHT)}):Play()
    end

    applyVisualUpdates()
end)

-- ═══════════════ POSITION INITIALE ═══════════════
if savedXOffset and savedYOffset then
    frame.Position = UDim2.new(0, savedXOffset, 0, savedYOffset)
else
    frame.Position = UDim2.new(0.5, -getFullWidth()/2, 0, 50)
end

applyVisualUpdates()

-- ═══ ANIMATION D'ENTRÉE GLOBALE du panneau ═══
frame.BackgroundTransparency = 1
titleBar.BackgroundTransparency = 1
local finalFrameSize = frame.Size
frame.Size = UDim2.new(0, finalFrameSize.X.Offset, 0, 0)
TS:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = finalFrameSize
}):Play()
TS:Create(frame, ANIM_MED, {BackgroundTransparency = getTransparencyValue()}):Play()
TS:Create(titleBar, ANIM_MED, {BackgroundTransparency = getTransparencyValue()}):Play()
