-- VIS HUB / EL2B HUB · Safe edition
-- Interface standard Roblox + profil local + statut admin optionnel.
-- Aucune automatisation invasive, appel distant ou API d’exécuteur.

repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
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
local function readStatus()
    local fn = requestFn()
    if type(fn) ~= "function" then return nil end
    local ok, response = pcall(fn, {Url = ENDPOINT, Method = "GET"})
    if not ok or not response or tonumber(response.StatusCode or response.status_code) ~= 200 then return nil end
    local decoded, data = pcall(function() return HttpService:JSONDecode(response.Body or response.body or "") end)
    return decoded and type(data) == "table" and data or nil
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
close.Activated:Connect(function() mainGui:Destroy() end)

local updateActive = false
local function showUpdate(state)
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
        while gui.Parent and seconds > 0 do
            countdown.Text = string.format("Maintenance · %02d s", seconds)
            task.wait(1)
            seconds -= 1
        end
        if gui.Parent then countdown.Text = "Update in progress / Mise à jour en cours" end
        task.wait(1)
        if gui.Parent then gui:Destroy() end
        updateActive = false
    end)
end
local function applyState(state)
    local scheduled = state and state.scheduledMaintenance and state.scheduledMaintenance.active == true
    local enabled = state and state.enabled ~= false and not scheduled
    if enabled then
        if mainGui.Parent then mainGui.Enabled = true end
        remove(UPDATE_GUI_NAME)
        updateActive = false
        statusLabel.Text = "Statut : script actif / script enabled"
        statusLabel.TextColor3 = Color3.fromRGB(100, 240, 150)
    elseif state then
        if mainGui.Parent then mainGui.Enabled = false end
        statusLabel.Text = "Statut : mise à jour / updating"
        statusLabel.TextColor3 = Color3.fromRGB(255, 160, 100)
        showUpdate(state)
    else
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
