-- VIS HUB / EL2B HUB · Safe edition
-- Interface standard Roblox + profil local + statut admin optionnel.
-- Aucune automatisation invasive, appel distant ou API d’exécuteur.

repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer
if not LP then
    warn("[EL2B HUB] LocalPlayer indisponible / unavailable")
    return
end
local PlayerGui = LP:WaitForChild("PlayerGui", 15) or LP:FindFirstChildOfClass("PlayerGui")
if not PlayerGui then
    warn("[EL2B HUB] PlayerGui indisponible / unavailable")
    return
end

local ENDPOINT = "https://el2bstatus-amhrowxg.manus.space/api/script-status"
local POLL_SECONDS = 15
local UPDATE_GUI_NAME = "EL2BUpdateGui"
local MAIN_GUI_NAME = "EL2BMainGui"
local function requestFn()
    return (syn and syn.request) or (http and http.request) or http_request or request
end
local function decodeStatus(body)
    local decoded, data = pcall(function() return HttpService:JSONDecode(body or "") end)
    return decoded and type(data) == "table" and data or nil
end
local function readStatus()
    local fn = requestFn()
    if type(fn) == "function" then
        local ok, response = pcall(fn, {Url = ENDPOINT, Method = "GET"})
        if ok and response and tonumber(response.StatusCode or response.status_code) == 200 then
            return decodeStatus(response.Body or response.body)
        end
    end
    local ok, body = pcall(function() return game:HttpGet(ENDPOINT) end)
    if ok and type(body) == "string" then return decodeStatus(body) end
    return nil
end
local function remove(name)
    local item = PlayerGui:FindFirstChild(name)
    if item then pcall(function() item:Destroy() end) end
end
remove(MAIN_GUI_NAME)
remove(UPDATE_GUI_NAME)

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = obj
end
local function makeLabel(parent, text, pos, size, textSize, color)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = pos
    label.Size = size
    label.Font = Enum.Font.Gotham
    label.TextColor3 = color or Color3.fromRGB(220, 220, 235)
    label.TextSize = textSize or 13
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = text
    label.Parent = parent
    return label
end

local mainGui = Instance.new("ScreenGui")
mainGui.Name = MAIN_GUI_NAME
mainGui.ResetOnSpawn = false
mainGui.IgnoreGuiInset = true
mainGui.Parent = PlayerGui
local main = Instance.new("Frame")
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.fromOffset(330, 260)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
main.BorderSizePixel = 0
main.Parent = mainGui
corner(main, 14)
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(190, 80, 230)
stroke.Transparency = 0.35
stroke.Parent = main
makeLabel(main, "EL2B HUB", UDim2.fromOffset(20, 18), UDim2.new(1, -40, 0, 30), 22, Color3.fromRGB(255, 255, 255)).Font = Enum.Font.GothamBold
makeLabel(main, "Safe edition · Admin status", UDim2.fromOffset(20, 50), UDim2.new(1, -40, 0, 20), 12, Color3.fromRGB(210, 135, 240))
local statusLabel = makeLabel(main, "Statut : vérification…", UDim2.fromOffset(20, 82), UDim2.new(1, -40, 0, 38), 14)
local scheduleLabel = makeLabel(main, "Admin Abuse : samedi 21:00–21:30 (UTC+2)", UDim2.fromOffset(20, 124), UDim2.new(1, -40, 0, 34), 12, Color3.fromRGB(255, 180, 220))
local profile = makeLabel(main, "Profil : " .. tostring(LP.DisplayName or LP.Name) .. "  ·  UserId " .. tostring(LP.UserId), UDim2.fromOffset(20, 166), UDim2.new(1, -40, 0, 35), 12, Color3.fromRGB(180, 180, 205))
local close = Instance.new("TextButton")
close.Position = UDim2.new(1, -112, 1, -42)
close.Size = UDim2.fromOffset(92, 28)
close.BackgroundColor3 = Color3.fromRGB(42, 28, 52)
close.BorderSizePixel = 0
close.Font = Enum.Font.GothamSemibold
close.TextColor3 = Color3.fromRGB(255, 220, 245)
close.TextSize = 12
close.Text = "Fermer / Close"
close.Parent = main
corner(close, 8)
local mainTransitionId = 0
local mainVisible = true
local function tweenMainVisible(visible)
    mainTransitionId += 1
    local transitionId = mainTransitionId
    if visible then
        mainVisible = true
        mainGui.Enabled = true
        main.Size = UDim2.fromOffset(316, 248)
        main.BackgroundTransparency = 1
        stroke.Transparency = 1
        for _, item in ipairs(main:GetDescendants()) do
            if item:IsA("TextLabel") or item:IsA("TextButton") then item.TextTransparency = 1 end
        end
        local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(main, tweenInfo, {Size = UDim2.fromOffset(330, 260), BackgroundTransparency = 0}):Play()
        TweenService:Create(stroke, tweenInfo, {Transparency = 0.35}):Play()
        for _, item in ipairs(main:GetDescendants()) do
            if item:IsA("TextLabel") or item:IsA("TextButton") then
                TweenService:Create(item, tweenInfo, {TextTransparency = 0}):Play()
            end
        end
    else
        mainVisible = false
        local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        TweenService:Create(main, tweenInfo, {Size = UDim2.fromOffset(316, 248), BackgroundTransparency = 1}):Play()
        TweenService:Create(stroke, tweenInfo, {Transparency = 1}):Play()
        for _, item in ipairs(main:GetDescendants()) do
            if item:IsA("TextLabel") or item:IsA("TextButton") then
                TweenService:Create(item, tweenInfo, {TextTransparency = 1}):Play()
            end
        end
        task.delay(0.2, function()
            if transitionId == mainTransitionId and not mainVisible then mainGui.Enabled = false end
        end)
    end
end
close.Activated:Connect(function() mainGui:Destroy() end)

tweenMainVisible(true)

local updateActive = false
local updateGeneration = 0
local function showUpdate(state)
    updateGeneration += 1
    local generation = updateGeneration
    if updateActive then return end
    updateActive = true
    remove(UPDATE_GUI_NAME)
    local gui = Instance.new("ScreenGui")
    gui.Name = UPDATE_GUI_NAME
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = PlayerGui
    local box = Instance.new("Frame")
    box.AnchorPoint = Vector2.new(0.5, 0.5)
    box.Position = UDim2.new(0.5, 0, 0.5, 0)
    box.Size = UDim2.fromOffset(340, 220)
    box.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    box.BorderSizePixel = 0
    box.Parent = gui
    corner(box, 14)
    local line = Instance.new("UIStroke")
    line.Color = Color3.fromRGB(255, 70, 185)
    line.Parent = box
    makeLabel(box, "EL2B HUB · MISE À JOUR", UDim2.fromOffset(20, 18), UDim2.new(1, -40, 0, 30), 19, Color3.fromRGB(255, 255, 255)).Font = Enum.Font.GothamBold
    makeLabel(box, "UPDATING / SCRIPT TEMPORAIREMENT DÉSACTIVÉ", UDim2.fromOffset(20, 50), UDim2.new(1, -40, 0, 22), 11, Color3.fromRGB(255, 180, 220))
    local msg = makeLabel(box, (state and state.updateMessageFr or "Mise à jour en cours.") .. "\n" .. (state and state.updateMessageEn or "Update in progress."), UDim2.fromOffset(20, 78), UDim2.new(1, -40, 0, 48), 13)
    local countdown = makeLabel(box, "État global actif", UDim2.fromOffset(20, 137), UDim2.new(1, -40, 0, 30), 16, Color3.fromRGB(255, 100, 190))
    local seconds = 0
    if state and state.scheduledMaintenance and state.scheduledMaintenance.active then
        seconds = tonumber(state.scheduledMaintenance.secondsRemaining) or 0
    end
    if seconds <= 0 then seconds = 12 end
    task.spawn(function()
        while gui.Parent and generation == updateGeneration and seconds > 0 do
            countdown.Text = string.format("Maintenance · %02d s", seconds)
            task.wait(1)
            seconds -= 1
        end
        if gui.Parent and generation == updateGeneration then countdown.Text = "Update in progress / Mise à jour en cours" end
        task.wait(1)
        if gui.Parent and generation == updateGeneration then gui:Destroy() end
        if generation == updateGeneration then updateActive = false end
    end)
end
local function applyState(state)
    local scheduled = state and state.scheduledMaintenance and state.scheduledMaintenance.active == true
    local enabled = state and state.enabled ~= false and not scheduled
    if enabled then
        updateGeneration += 1
        if mainGui.Parent then tweenMainVisible(true) end
        remove(UPDATE_GUI_NAME)
        updateActive = false
        statusLabel.Text = "Statut : script actif / script enabled"
        statusLabel.TextColor3 = Color3.fromRGB(100, 240, 150)
    elseif state then
        if mainGui.Parent then tweenMainVisible(false) end
        statusLabel.Text = "Statut : mise à jour / updating"
        statusLabel.TextColor3 = Color3.fromRGB(255, 160, 100)
        showUpdate(state)
    else
        updateGeneration += 1
        if mainGui.Parent then tweenMainVisible(true) end
        remove(UPDATE_GUI_NAME)
        updateActive = false
        statusLabel.Text = "Statut : website indisponible / unavailable"
        statusLabel.TextColor3 = Color3.fromRGB(255, 190, 90)
    end
end
local initial = readStatus()
applyState(initial)
task.spawn(function()
    while task.wait(POLL_SECONDS) do
        applyState(readStatus())
    end
end)
print("[EL2B HUB] Safe edition loaded successfully")
