-- EL2B ALL GEAR — version stable et sûre pour Roblox
-- VERSION: 2.2.0
-- Cette version est volontairement limitée à l’interface et aux informations visuelles.
-- Aucun RemoteEvent/RemoteFunction, téléportation, lagger, hook, commande admin,
-- anti-ragdoll, aimbot, quick pickup ou automatisation de gameplay n’est exécuté.

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local localPlayer = Players.LocalPlayer
if not localPlayer then
    return
end

local playerGui = localPlayer:WaitForChild("PlayerGui")
local GUI_NAME = "EL2B_ALL_GEAR"
local CURRENT_VERSION = "2.2.0"
local THEME_FILE = "EL2B_THEME.json"
local themePresets = {
    DARK = {main=Color3.fromRGB(18,18,25), panel=Color3.fromRGB(28,25,40), card=Color3.fromRGB(30,24,40), accent=Color3.fromRGB(125,35,55), text=Color3.fromRGB(245,240,255), muted=Color3.fromRGB(190,180,205), input=Color3.fromRGB(30,24,40)},
    LIGHT = {main=Color3.fromRGB(242,242,247), panel=Color3.fromRGB(255,255,255), card=Color3.fromRGB(232,232,240), accent=Color3.fromRGB(170,45,70), text=Color3.fromRGB(35,30,45), muted=Color3.fromRGB(95,85,110), input=Color3.fromRGB(225,225,235)},
    RED = {main=Color3.fromRGB(22,10,14), panel=Color3.fromRGB(45,16,24), card=Color3.fromRGB(55,20,29), accent=Color3.fromRGB(190,35,55), text=Color3.fromRGB(255,235,238), muted=Color3.fromRGB(220,155,165), input=Color3.fromRGB(45,16,24)},
    CYBERPUNK = {main=Color3.fromRGB(12,12,28), panel=Color3.fromRGB(25,18,48), card=Color3.fromRGB(30,24,58), accent=Color3.fromRGB(0,220,190), text=Color3.fromRGB(235,255,250), muted=Color3.fromRGB(150,205,205), input=Color3.fromRGB(25,18,48)},
    NEON = {main=Color3.fromRGB(8,12,18), panel=Color3.fromRGB(14,30,42), card=Color3.fromRGB(18,42,52), accent=Color3.fromRGB(0,190,255), text=Color3.fromRGB(225,250,255), muted=Color3.fromRGB(145,200,220), input=Color3.fromRGB(14,30,42)},
    PASTEL = {main=Color3.fromRGB(42,35,50), panel=Color3.fromRGB(70,56,78), card=Color3.fromRGB(82,65,90), accent=Color3.fromRGB(225,125,175), text=Color3.fromRGB(255,245,252), muted=Color3.fromRGB(220,190,215), input=Color3.fromRGB(70,56,78)},
    RETRO = {main=Color3.fromRGB(28,24,18), panel=Color3.fromRGB(58,45,27), card=Color3.fromRGB(72,55,30), accent=Color3.fromRGB(225,155,45), text=Color3.fromRGB(255,244,205), muted=Color3.fromRGB(205,180,125), input=Color3.fromRGB(58,45,27)},
}
local function parseHexColor(value)
    local hex = tostring(value or ""):gsub("#", "")
    if not hex:match("^%x%x%x%x%x%x$") then return nil end
    return Color3.fromRGB(tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16))
end
local customThemeHex = {main="#121219", panel="#1C1928", card="#1E1828", accent="#7D2337", text="#F5F0FF", muted="#BEB4CD", input="#1E1828"}
local customTheme = {}
for key, value in pairs(customThemeHex) do customTheme[key] = parseHexColor(value) end
local activeThemeName = "DARK"
local musicVolume = 0.18
local sfxVolume = 0.12
local musicEnabled = true
local themeButton
local modeButton
local visualToggle
local audioPanel
local musicTracks = {
    {name = "EL2B Loading", id = "rbxassetid://76650356472656"},
    {name = "Classic Ambient", id = "rbxassetid://1843529603"},
    {name = "Night Pulse", id = "rbxassetid://1837879082"},
}
local selectedMusicIndex = 1
local function saveThemeSettings()
    if type(writefile) ~= "function" then return end
    pcall(function() writefile(THEME_FILE, HttpService:JSONEncode({theme=activeThemeName, customColors=customThemeHex, musicVolume=musicVolume, sfxVolume=sfxVolume, musicEnabled=musicEnabled, selectedMusicIndex=selectedMusicIndex})) end)
end
if type(isfile) == "function" and type(readfile) == "function" and isfile(THEME_FILE) then
    pcall(function()
        local saved = HttpService:JSONDecode(readfile(THEME_FILE))
        if saved and (themePresets[saved.theme] or saved.theme == "CUSTOM") then activeThemeName = saved.theme end
        if saved and type(saved.customColors) == "table" then
            for key, value in pairs(saved.customColors) do
                local parsed = parseHexColor(value)
                if parsed and customTheme[key] then customThemeHex[key] = tostring(value); customTheme[key] = parsed end
            end
        end
        if saved and type(saved.musicVolume) == "number" then musicVolume = math.clamp(saved.musicVolume, 0, 1) end
        if saved and type(saved.sfxVolume) == "number" then sfxVolume = math.clamp(saved.sfxVolume, 0, 1) end
        if saved and type(saved.musicEnabled) == "boolean" then musicEnabled = saved.musicEnabled end
        if saved and type(saved.selectedMusicIndex) == "number" and musicTracks[saved.selectedMusicIndex] then selectedMusicIndex = saved.selectedMusicIndex end
    end)
end
local VERSION_URL = "https://raw.githubusercontent.com/abdennouhethjgg-cloud/Script-hub/main/EL2B_VERSION.txt"
local SCRIPT_URL = "https://raw.githubusercontent.com/abdennouhethjgg-cloud/Script-hub/main/vis_hub_corrected.lua"
local oldGui = playerGui:FindFirstChild(GUI_NAME)
if oldGui then
    oldGui:Destroy()
end
local oldLoadingMusic = SoundService:FindFirstChild("EL2B_ALL_GEAR_LoadingMusic")
if oldLoadingMusic then
    oldLoadingMusic:Stop()
    oldLoadingMusic:Destroy()
end

local connections = {}
local destroyed = false

local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(connections, connection)
    return connection
end

local function make(className, properties, parent)
    local object = Instance.new(className)
    for property, value in pairs(properties) do
        object[property] = value
    end
    object.Parent = parent
    return object
end

local gui = make("ScreenGui", {
    Name = GUI_NAME,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 100,
}, playerGui)

local loadingOverlay = make("Frame", {
    Name = "LoadingOverlay",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(8, 8, 12),
    BorderSizePixel = 0,
    ZIndex = 100,
}, gui)
local loadingPanel = make("Frame", {
    Name = "LoadingPanel",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(280, 150),
    BackgroundColor3 = Color3.fromRGB(22, 12, 18),
    BorderSizePixel = 0,
    ZIndex = 101,
}, loadingOverlay)
make("UICorner", {CornerRadius = UDim.new(0, 14)}, loadingPanel)
make("UIStroke", {Color = Color3.fromRGB(190, 35, 55), Thickness = 1.5}, loadingPanel)
make("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 13, 23)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 10, 18)),
    }),
    Rotation = 35,
}, loadingPanel)
local loadingMusic = make("Sound", {
    Name = "EL2B_ALL_GEAR_LoadingMusic",
    SoundId = musicTracks[selectedMusicIndex].id,
    Volume = musicVolume,
    Looped = true,
}, SoundService)
local CLICK_SFX_ID = "rbxassetid://12221967"
local clickSfx = make("Sound", {
    Name = "EL2B_ALL_GEAR_ClickSFX",
    SoundId = CLICK_SFX_ID,
    Volume = sfxVolume,
    PlaybackSpeed = 1,
}, SoundService)
local function playClickSfx()
    if destroyed or not clickSfx.Parent then return end
    pcall(function()
        clickSfx.Volume = sfxVolume
        clickSfx:Stop()
        clickSfx.TimePosition = 0
        clickSfx:Play()
    end)
end
local function bindButtonSfx(button)
    if not button or button:GetAttribute("ClickSfxBound") then return end
    button:SetAttribute("ClickSfxBound", true)
    connect(button.Activated, playClickSfx)
end
make("TextLabel", {
    Name = "LoadingTitle",
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(16, 18),
    Size = UDim2.new(1, -32, 0, 30),
    Font = Enum.Font.GothamBold,
    Text = "EL2B ALL GEAR",
    TextColor3 = Color3.fromRGB(255, 235, 238),
    TextSize = 22,
    ZIndex = 102,
}, loadingPanel)
local loadingSpinner = make("TextLabel", {
    Name = "LoadingSpinner",
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 54),
    Size = UDim2.fromOffset(34, 28),
    Font = Enum.Font.GothamBold,
    Text = "◌",
    TextColor3 = Color3.fromRGB(235, 55, 75),
    TextSize = 28,
    ZIndex = 102,
}, loadingPanel)
local loadingStatus = make("TextLabel", {
    Name = "LoadingStatus",
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(16, 90),
    Size = UDim2.new(1, -32, 0, 20),
    Font = Enum.Font.Gotham,
    Text = "Initialisation de l’interface...",
    TextColor3 = Color3.fromRGB(210, 165, 175),
    TextSize = 10,
    ZIndex = 102,
}, loadingPanel)
local loadingTrack = make("Frame", {
    Name = "LoadingTrack",
    Position = UDim2.fromOffset(24, 122),
    Size = UDim2.new(1, -48, 0, 6),
    BackgroundColor3 = Color3.fromRGB(55, 25, 32),
    BorderSizePixel = 0,
    ZIndex = 102,
}, loadingPanel)
make("UICorner", {CornerRadius = UDim.new(1, 0)}, loadingTrack)
local loadingFill = make("Frame", {
    Name = "LoadingFill",
    Size = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(205, 35, 55),
    BorderSizePixel = 0,
    ZIndex = 103,
}, loadingTrack)
make("UICorner", {CornerRadius = UDim.new(1, 0)}, loadingFill)

local main = make("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(330, 480),
    BackgroundColor3 = Color3.fromRGB(18, 18, 25),
    BorderSizePixel = 0,
    Visible = false,
}, gui)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, main)
make("UIStroke", {
    Color = Color3.fromRGB(125, 85, 220),
    Thickness = 1.5,
    Transparency = 0.15,
}, main)

local header = make("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = Color3.fromRGB(28, 25, 40),
    BorderSizePixel = 0,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, header)
make("Frame", {
    Name = "HeaderFill",
    Position = UDim2.new(0, 0, 1, -10),
    Size = UDim2.new(1, 0, 0, 10),
    BackgroundColor3 = Color3.fromRGB(28, 25, 40),
    BorderSizePixel = 0,
}, header)

make("TextLabel", {
    Name = "Title",
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(16, 6),
    Size = UDim2.new(1, -62, 0, 23),
    Font = Enum.Font.GothamBold,
    Text = "EL2B ALL GEAR",
    TextColor3 = Color3.fromRGB(245, 240, 255),
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
}, header)

local closeButton = make("TextButton", {
    Name = "Close",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -10, 0.5, 0),
    Size = UDim2.fromOffset(28, 28),
    BackgroundColor3 = Color3.fromRGB(75, 45, 85),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "×",
    TextColor3 = Color3.fromRGB(255, 225, 255),
    TextSize = 20,
}, header)
make("UICorner", {CornerRadius = UDim.new(1, 0)}, closeButton)

make("TextLabel", {
    Name = "Subtitle",
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(16, 60),
    Size = UDim2.new(1, -32, 0, 22),
    Font = Enum.Font.Gotham,
    Text = "Mode stable — fonctions de gameplay désactivées",
    TextColor3 = Color3.fromRGB(190, 180, 205),
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
}, main)

local status = make("TextLabel", {
    Name = "Status",
    BackgroundColor3 = Color3.fromRGB(30, 65, 48),
    Position = UDim2.fromOffset(16, 92),
    Size = UDim2.new(1, -32, 0, 32),
    Font = Enum.Font.GothamMedium,
    Text = "● Interface active — aucun appel distant",
    TextColor3 = Color3.fromRGB(175, 255, 205),
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Center,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, status)

local playerCount = make("TextLabel", {
    Name = "PlayerCount",
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(16, 137),
    Size = UDim2.new(1, -32, 0, 24),
    Font = Enum.Font.GothamBold,
    TextColor3 = Color3.fromRGB(235, 230, 245),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
}, main)
local playerCountBaseText = ""
local lastCoordinateText = ""
local coordinateInterval = UserInputService.TouchEnabled and 0.6 or 0.35
local function updateCoordinates()
    if destroyed or not playerCount or not playerCount.Parent then return end
    local character = localPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local coordinateText
    if root then
        local position = root.Position
        coordinateText = string.format("  •  XYZ: %.1f, %.1f, %.1f", position.X, position.Y, position.Z)
    else
        coordinateText = "  •  XYZ: indisponibles"
    end
    local nextText = playerCountBaseText .. coordinateText
    if nextText ~= lastCoordinateText then
        lastCoordinateText = nextText
        playerCount.Text = nextText
    end
end

local localProfileAvatar = make("ImageLabel", {
    Name = "LocalProfileAvatar",
    BackgroundColor3 = Color3.fromRGB(55, 38, 75),
    Position = UDim2.fromOffset(16, 163),
    Size = UDim2.fromOffset(44, 44),
    BorderSizePixel = 0,
    Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(localPlayer.UserId) .. "&w=150&h=150",
}, main)
make("UICorner", {CornerRadius = UDim.new(1, 0)}, localProfileAvatar)
local localProfileDetails = make("TextLabel", {
    Name = "SelectedProfileDetails",
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(70, 160),
    Size = UDim2.new(1, -86, 0, 52),
    Font = Enum.Font.GothamBold,
    Text = tostring(localPlayer.DisplayName or localPlayer.Name) .. "\n@" .. tostring(localPlayer.Name) .. "\nID: " .. tostring(localPlayer.UserId),
    TextColor3 = Color3.fromRGB(235, 230, 245),
    TextSize = 10,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
}, main)
local selectedPlayer
local function selectPlayerProfile(player)
    if not player or not player.Parent then return end
    selectedPlayer = player
    localProfileAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(player.UserId) .. "&w=150&h=150"
    localProfileDetails.Text = tostring(player.DisplayName or player.Name) .. "\n@" .. tostring(player.Name) .. "\nID: " .. tostring(player.UserId)
    status.Text = "● Profil sélectionné : @" .. tostring(player.Name)
end
local activeToast
local toastSerial = 0
local function showToast(message, success)
    if destroyed then return end
    toastSerial = toastSerial + 1
    local serial = toastSerial
    if activeToast then
        activeToast:Destroy()
        activeToast = nil
    end
    local toast = make("TextLabel", {
        Name = "CopyToast",
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -12),
        Size = UDim2.fromOffset(220, 32),
        BackgroundColor3 = success and Color3.fromRGB(35, 105, 65) or Color3.fromRGB(105, 35, 45),
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = tostring(message),
        TextColor3 = Color3.fromRGB(255, 245, 248),
        TextSize = 11,
        TextWrapped = true,
        ZIndex = 30,
    }, gui)
    activeToast = toast
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, toast)
    task.delay(2.5, function()
        if activeToast == toast and toastSerial == serial then
            activeToast = nil
            if toast.Parent then toast:Destroy() end
        end
    end)
end

visualToggle = make("TextButton", {
    Name = "VisualToggle",
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -18, 1, -72),
    Size = UDim2.fromOffset(40, 40),
    BackgroundColor3 = Color3.fromRGB(125, 35, 55),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "◉",
    TextColor3 = Color3.fromRGB(255, 235, 240),
    TextSize = 18,
    ZIndex = 40,
    AutoButtonColor = false,
}, gui)
make("UICorner", {CornerRadius = UDim.new(1, 0)}, visualToggle)
make("UIStroke", {Color = Color3.fromRGB(255, 205, 215), Thickness = 1}, visualToggle)
local visualEnabled = true
connect(visualToggle.Activated, function()
    visualEnabled = not visualEnabled
    main.Visible = visualEnabled
    if not visualEnabled and audioPanel then audioPanel.Visible = false end
    visualToggle.Text = visualEnabled and "◉" or "○"
    visualToggle:SetAttribute("VisualEnabled", visualEnabled)
    if visualEnabled then
        showToast("Interface visuelle activée", true)
    end
end)

local updateButton
local function checkForUpdate()
    local httpGet = game.HttpGet
    if type(httpGet) ~= "function" then
        return
    end
    local ok, remoteVersion = pcall(function()
        return game:HttpGet(VERSION_URL)
    end)
    if not ok or type(remoteVersion) ~= "string" then
        return
    end
    remoteVersion = remoteVersion:gsub("^%s+", ""):gsub("%s+$", "")
    if remoteVersion ~= "" and remoteVersion ~= CURRENT_VERSION then
        status.Text = "● Mise à jour disponible : v" .. remoteVersion
        updateButton.Text = "UPDATE AVAILABLE  •  v" .. remoteVersion
        showToast("Nouvelle GUI disponible : v" .. remoteVersion, true)
    else
        status.Text = "● GUI à jour : v" .. CURRENT_VERSION
        updateButton.Text = "CHECK UPDATE  •  v" .. CURRENT_VERSION
    end
end

local function copyToClipboard(value, label)
    local copied = false
    for _, clipboardFunction in ipairs({setclipboard, toclipboard, set_clipboard}) do
        if type(clipboardFunction) == "function" then
            copied = pcall(clipboardFunction, tostring(value))
            if copied then break end
        end
    end
    if copied then
        status.Text = "● " .. label .. " copié"
        showToast(label .. " copié", true)
    else
        status.Text = "● Copie indisponible : " .. label
        showToast("Copie indisponible : " .. label, false)
    end
end
updateButton = make("TextButton", {
    Name = "CheckUpdate",
    Position = UDim2.fromOffset(16, 133),
    Size = UDim2.new(1, -32, 0, 22),
    BackgroundColor3 = Color3.fromRGB(65, 35, 100),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "CHECK UPDATE  •  v" .. CURRENT_VERSION,
    TextColor3 = Color3.fromRGB(245, 235, 255),
    TextSize = 8,
    AutoButtonColor = false,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, updateButton)
connect(updateButton.Activated, checkForUpdate)

local copyUsernameButton = make("TextButton", {
    Name = "CopyUsername",
    Position = UDim2.fromOffset(70, 207),
    Size = UDim2.fromOffset(112, 22),
    BackgroundColor3 = Color3.fromRGB(125, 35, 55),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "COPY USERNAME",
    TextColor3 = Color3.fromRGB(255, 235, 240),
    TextSize = 8,
    AutoButtonColor = false,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, copyUsernameButton)
local copyIdButton = make("TextButton", {
    Name = "CopyUserId",
    Position = UDim2.fromOffset(188, 207),
    Size = UDim2.fromOffset(76, 22),
    BackgroundColor3 = Color3.fromRGB(125, 35, 55),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "COPY ID",
    TextColor3 = Color3.fromRGB(255, 235, 240),
    TextSize = 8,
    AutoButtonColor = false,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, copyIdButton)
copyUsernameButton.Activated:Connect(function()
    if selectedPlayer then copyToClipboard(selectedPlayer.Name, "Username") end
end)
copyIdButton.Activated:Connect(function()
    if selectedPlayer then copyToClipboard(selectedPlayer.UserId, "UserId") end
end)
local playerSearchBox = make("TextBox", {
    Name = "PlayerSearch",
    PlaceholderText = "Rechercher un joueur...",
    ClearTextOnFocus = false,
    Position = UDim2.fromOffset(16, 237),
    Size = UDim2.new(1, -32, 0, 24),
    BackgroundColor3 = Color3.fromRGB(30, 24, 40),
    BorderSizePixel = 0,
    Font = Enum.Font.Gotham,
    Text = "",
    TextColor3 = Color3.fromRGB(245, 240, 255),
    PlaceholderColor3 = Color3.fromRGB(160, 150, 175),
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 7)}, playerSearchBox)
local playerList = make("ScrollingFrame", {
    Name = "PlayerList",
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(16, 267),
    Size = UDim2.new(1, -32, 0, 84),
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Color3.fromRGB(125, 35, 55),
    CanvasSize = UDim2.fromOffset(0, 0),
}, main)

local function getFilteredPlayers()
    local players = Players:GetPlayers()
    local query = tostring(playerSearchBox.Text or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
    if query == "" then return players end
    local filtered = {}
    for _, player in ipairs(players) do
        local haystack = (tostring(player.DisplayName) .. " " .. tostring(player.Name) .. " " .. tostring(player.UserId)):lower()
        if string.find(haystack, query, 1, true) then table.insert(filtered, player) end
    end
    return filtered
end

local lastPlayerSignature = ""
local function refreshPlayers(force)
    if destroyed or not playerCount.Parent then
        return
    end
    local allPlayers = Players:GetPlayers()
    local signatureParts = {}
    for _, player in ipairs(allPlayers) do table.insert(signatureParts, tostring(player.UserId)) end
    table.sort(signatureParts)
    local playerSignature = table.concat(signatureParts, ":")
    if not force and playerSignature == lastPlayerSignature then
        return
    end
    lastPlayerSignature = playerSignature
    local totalPlayers = #allPlayers
    local players = getFilteredPlayers()
    playerCountBaseText = string.format("Joueurs : %d/%d  •  Profil : @%s", #players, totalPlayers, tostring(localPlayer.Name))
    updateCoordinates()
    for _, child in ipairs(playerList:GetChildren()) do
        if child:GetAttribute("ServerPlayerCard") then
            child:Destroy()
        end
    end
    table.sort(players, function(a, b) return tostring(a.Name):lower() < tostring(b.Name):lower() end)
    for index, player in ipairs(players) do
        local card = make("Frame", {
            Name = "ServerPlayerCard",
            BackgroundColor3 = themePresets[activeThemeName].card,
            BorderSizePixel = 0,
            Size = UDim2.new(0.5, -6, 0, 44),
            Position = UDim2.new((index - 1) % 2 * 0.5, 4, 0, math.floor((index - 1) / 2) * 50 + 4),
        }, playerList)
        card:SetAttribute("ServerPlayerCard", true)
        make("UICorner", {CornerRadius = UDim.new(0, 7)}, card)
        local avatar = make("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(5, 5),
            Size = UDim2.fromOffset(34, 34),
            Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(player.UserId) .. "&w=150&h=150",
        }, card)
        make("UICorner", {CornerRadius = UDim.new(1, 0)}, avatar)
        make("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(44, 3),
            Size = UDim2.new(1, -84, 1, -6),
            Font = Enum.Font.GothamBold,
            Text = tostring(player.DisplayName or player.Name) .. "\n@" .. tostring(player.Name) .. "\nID: " .. tostring(player.UserId),
            TextColor3 = Color3.fromRGB(235, 230, 245),
            TextSize = 8,
            TextWrapped = true,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
        }, card)
        local viewButton = make("TextButton", {
            Name = "ViewProfile",
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -5, 0.5, 0),
            Size = UDim2.fromOffset(30, 30),
            BackgroundColor3 = themePresets[activeThemeName].accent,
            BorderSizePixel = 0,
            Font = Enum.Font.GothamBold,
            Text = "VIEW",
            TextColor3 = Color3.fromRGB(255, 235, 240),
            TextSize = 7,
            AutoButtonColor = false,
        }, card)
        make("UICorner", {CornerRadius = UDim.new(1, 0)}, viewButton)
        connect(viewButton.Activated, function() selectPlayerProfile(player) end)
        bindButtonSfx(viewButton)
    end
    playerList.CanvasSize = UDim2.fromOffset(0, math.max(0, math.ceil(#players / 2) * 50 + 4))
end

local function exportPlayers(format)
    local players = getFilteredPlayers()
    table.sort(players, function(a, b) return tostring(a.Name):lower() < tostring(b.Name):lower() end)
    local payload
    if format == "json" then
        local records = {}
        for _, player in ipairs(players) do
            table.insert(records, {
                DisplayName = tostring(player.DisplayName or player.Name),
                Username = tostring(player.Name),
                UserId = player.UserId,
            })
        end
        local ok, result = pcall(function() return HttpService:JSONEncode(records) end)
        payload = ok and result or nil
    else
        local lines = {"EL2B ALL GEAR - Liste des joueurs", ""}
        for _, player in ipairs(players) do
            table.insert(lines, string.format("%s (@%s) - UserId: %s", tostring(player.DisplayName or player.Name), tostring(player.Name), tostring(player.UserId)))
        end
        payload = table.concat(lines, "\n")
    end
    if payload then
        copyToClipboard(payload, format == "json" and "Export JSON" or "Export texte")
    else
        status.Text = "● Export JSON indisponible"
        showToast("Export JSON indisponible", false)
    end
end

local randomPlayerButton = make("TextButton", {
    Name = "RandomPlayer",
    Position = UDim2.fromOffset(16, 356),
    Size = UDim2.new(1, -32, 0, 22),
    BackgroundColor3 = Color3.fromRGB(125, 35, 55),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "RANDOM PLAYER",
    TextColor3 = Color3.fromRGB(255, 235, 240),
    TextSize = 8,
    AutoButtonColor = false,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, randomPlayerButton)
connect(randomPlayerButton.Activated, function()
    local players = getFilteredPlayers()
    if #players == 0 then
        status.Text = "● Aucun joueur trouvé"
        showToast("Aucun joueur trouvé", false)
        return
    end
    local chosen = players[math.random(1, #players)]
    selectPlayerProfile(chosen)
    showToast("Joueur choisi : @" .. tostring(chosen.Name), true)
end)

local exportJsonButton = make("TextButton", {
    Name = "ExportPlayersJson",
    Position = UDim2.fromOffset(16, 386),
    Size = UDim2.fromOffset(142, 22),
    BackgroundColor3 = Color3.fromRGB(95, 30, 52),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "EXPORT JSON",
    TextColor3 = Color3.fromRGB(255, 235, 240),
    TextSize = 8,
    AutoButtonColor = false,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, exportJsonButton)
local exportTextButton = make("TextButton", {
    Name = "ExportPlayersText",
    Position = UDim2.fromOffset(172, 386),
    Size = UDim2.fromOffset(142, 22),
    BackgroundColor3 = Color3.fromRGB(95, 30, 52),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "EXPORT TEXTE",
    TextColor3 = Color3.fromRGB(255, 235, 240),
    TextSize = 8,
    AutoButtonColor = false,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, exportTextButton)
connect(exportJsonButton.Activated, function() exportPlayers("json") end)
connect(exportTextButton.Activated, function() exportPlayers("text") end)

local themeOrder = {"DARK", "LIGHT", "RED", "CYBERPUNK", "NEON", "PASTEL", "RETRO", "CUSTOM"}
local applyTheme
local function nextTheme()
    local currentIndex = 1
    for index, name in ipairs(themeOrder) do
        if name == activeThemeName then currentIndex = index break end
    end
    activeThemeName = themeOrder[currentIndex % #themeOrder + 1]
    applyTheme(activeThemeName)
    saveThemeSettings()
end
local function toggleLightDark()
    activeThemeName = activeThemeName == "LIGHT" and "DARK" or "LIGHT"
    applyTheme(activeThemeName)
    saveThemeSettings()
end

themeButton = make("TextButton", {
    Name = "ThemePreset",
    Position = UDim2.fromOffset(16, 416),
    Size = UDim2.fromOffset(142, 22),
    BackgroundColor3 = Color3.fromRGB(95, 30, 52),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "THEME : " .. activeThemeName,
    TextColor3 = Color3.fromRGB(255, 235, 240),
    TextSize = 8,
    AutoButtonColor = false,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, themeButton)
modeButton = make("TextButton", {
    Name = "LightDarkMode",
    Position = UDim2.fromOffset(172, 416),
    Size = UDim2.fromOffset(142, 22),
    BackgroundColor3 = Color3.fromRGB(95, 30, 52),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "MODE CLAIR / SOMBRE",
    TextColor3 = Color3.fromRGB(255, 235, 240),
    TextSize = 8,
    AutoButtonColor = false,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, modeButton)

local audioButton = make("TextButton", {
    Name = "AudioSettings",
    Position = UDim2.fromOffset(16, 444),
    Size = UDim2.new(1, -32, 0, 22),
    BackgroundColor3 = Color3.fromRGB(95, 30, 52),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "AUDIO SETTINGS",
    TextColor3 = Color3.fromRGB(255, 235, 240),
    TextSize = 8,
    AutoButtonColor = false,
}, main)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, audioButton)

audioPanel = make("Frame", {
    Name = "AudioPanel",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(270, 335),
    BackgroundColor3 = Color3.fromRGB(28, 25, 40),
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 50,
}, gui)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, audioPanel)
make("UIStroke", {Color = Color3.fromRGB(125, 35, 55), Thickness = 1.3}, audioPanel)
make("TextLabel", {
    Name = "AudioTitle",
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(14, 10),
    Size = UDim2.new(1, -28, 0, 22),
    Font = Enum.Font.GothamBold,
    Text = "AUDIO & THEME CONFIGURATION",
    TextColor3 = Color3.fromRGB(245, 240, 255),
    TextSize = 14,
    ZIndex = 51,
}, audioPanel)
local musicVolumeBox = make("TextBox", {
    Name = "MusicVolume",
    Position = UDim2.fromOffset(14, 48),
    Size = UDim2.fromOffset(88, 25),
    BackgroundColor3 = Color3.fromRGB(30, 24, 40),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = tostring(math.floor(musicVolume * 100)) .. "%",
    TextColor3 = Color3.fromRGB(245, 240, 255),
    TextSize = 10,
    ClearTextOnFocus = false,
    ZIndex = 51,
}, audioPanel)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, musicVolumeBox)
make("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(112, 48), Size = UDim2.new(1, -126, 0, 25), Font = Enum.Font.Gotham, Text = "Musique loading (%)", TextColor3 = Color3.fromRGB(210, 200, 220), TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 51}, audioPanel)
local sfxVolumeBox = make("TextBox", {
    Name = "SfxVolume",
    Position = UDim2.fromOffset(14, 82),
    Size = UDim2.fromOffset(88, 25),
    BackgroundColor3 = Color3.fromRGB(30, 24, 40),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = tostring(math.floor(sfxVolume * 100)) .. "%",
    TextColor3 = Color3.fromRGB(245, 240, 255),
    TextSize = 10,
    ClearTextOnFocus = false,
    ZIndex = 51,
}, audioPanel)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, sfxVolumeBox)
make("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(112, 82), Size = UDim2.new(1, -126, 0, 25), Font = Enum.Font.Gotham, Text = "Effets de clic (%)", TextColor3 = Color3.fromRGB(210, 200, 220), TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 51}, audioPanel)
local musicToggle = make("TextButton", {
    Name = "MusicToggle",
    Position = UDim2.fromOffset(14, 120),
    Size = UDim2.new(1, -28, 0, 25),
    BackgroundColor3 = Color3.fromRGB(125, 35, 55),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = musicEnabled and "MUSIQUE : ON" or "MUSIQUE : OFF",
    TextColor3 = Color3.fromRGB(255, 235, 240),
    TextSize = 9,
    AutoButtonColor = false,
    ZIndex = 51,
}, audioPanel)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, musicToggle)
local musicTrackButton = make("TextButton", {Name = "MusicTrackSelector", Position = UDim2.fromOffset(14, 150), Size = UDim2.new(1, -28, 0, 24), BackgroundColor3 = Color3.fromRGB(125, 35, 55), BorderSizePixel = 0, Font = Enum.Font.GothamBold, Text = "PISTE : " .. musicTracks[selectedMusicIndex].name, TextColor3 = Color3.fromRGB(255, 235, 240), TextSize = 9, AutoButtonColor = false, ZIndex = 51}, audioPanel)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, musicTrackButton)
connect(musicTrackButton.Activated, function()
    selectedMusicIndex = selectedMusicIndex % #musicTracks + 1
    local track = musicTracks[selectedMusicIndex]
    loadingMusic.SoundId = track.id
    musicTrackButton.Text = "PISTE : " .. track.name
    if musicEnabled then pcall(function() loadingMusic:Play() end) end
    saveThemeSettings()
    showToast("Piste sélectionnée : " .. track.name, true)
end)
local function makeColorBox(name, y, label, key)
    local box = make("TextBox", {Name = name, Position = UDim2.fromOffset(14, y), Size = UDim2.fromOffset(88, 24), BackgroundColor3 = Color3.fromRGB(30, 24, 40), BorderSizePixel = 0, Font = Enum.Font.GothamBold, Text = customThemeHex[key], TextColor3 = Color3.fromRGB(245, 240, 255), TextSize = 10, ClearTextOnFocus = false, ZIndex = 51}, audioPanel)
    make("UICorner", {CornerRadius = UDim.new(0, 6)}, box)
    make("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(112, y), Size = UDim2.new(1, -126, 0, 24), Font = Enum.Font.Gotham, Text = label .. " (#RRGGBB)", TextColor3 = Color3.fromRGB(210, 200, 220), TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 51}, audioPanel)
    connect(box.FocusLost, function()
        local value = tostring(box.Text):upper()
        if not value:match("^#%x%x%x%x%x%x$") then
            box.Text = customThemeHex[key]
            showToast("Couleur invalide : " .. label, false)
            return
        end
        local parsed = parseHexColor(value)
        customThemeHex[key] = value
        customTheme[key] = parsed
        if key == "panel" then customTheme.card = parsed; customTheme.input = parsed end
        if key == "text" then customTheme.muted = parsed end
        activeThemeName = "CUSTOM"
        applyTheme("CUSTOM")
        saveThemeSettings()
        showToast("Couleur personnalisée appliquée", true)
    end)
    return box
end
local customMainBox = makeColorBox("CustomMainColor", 180, "Fond", "main")
local customPanelBox = makeColorBox("CustomPanelColor", 208, "Panneaux", "panel")
local customAccentBox = makeColorBox("CustomAccentColor", 236, "Accent", "accent")
local customTextBox = makeColorBox("CustomTextColor", 264, "Texte", "text")
local audioClose = make("TextButton", {Name = "CloseAudio", Position = UDim2.fromOffset(14, 302), Size = UDim2.new(1, -28, 0, 20), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = "FERMER", TextColor3 = Color3.fromRGB(210, 200, 220), TextSize = 9, ZIndex = 51}, audioPanel)
local function setAudioVolume(box, kind)
    local number = tonumber(tostring(box.Text):gsub("%%", ""))
    if not number then number = kind == "music" and musicVolume * 100 or sfxVolume * 100 end
    number = math.clamp(number, 0, 100)
    local value = number / 100
    if kind == "music" then musicVolume = value; loadingMusic.Volume = value else sfxVolume = value; clickSfx.Volume = value end
    box.Text = tostring(math.floor(number + 0.5)) .. "%"
    saveThemeSettings()
end
connect(audioButton.Activated, function() audioPanel.Visible = not audioPanel.Visible end)
connect(audioClose.Activated, function() audioPanel.Visible = false end)
connect(musicVolumeBox.FocusLost, function() setAudioVolume(musicVolumeBox, "music") end)
connect(sfxVolumeBox.FocusLost, function() setAudioVolume(sfxVolumeBox, "sfx") end)
connect(musicToggle.Activated, function()
    musicEnabled = not musicEnabled
    musicToggle.Text = musicEnabled and "MUSIQUE : ON" or "MUSIQUE : OFF"
    if musicEnabled then pcall(function() loadingMusic:Play() end) else pcall(function() loadingMusic:Stop() end) end
    saveThemeSettings()
end)

for _, object in ipairs(gui:GetDescendants()) do
    if object:IsA("TextButton") then bindButtonSfx(object) end
end

applyTheme = function(themeName)
    local palette = themeName == "CUSTOM" and customTheme or (themePresets[themeName] or themePresets.DARK)
    main.BackgroundColor3 = palette.main
    header.BackgroundColor3 = palette.panel
    local headerFill = header:FindFirstChild("HeaderFill")
    if headerFill then headerFill.BackgroundColor3 = palette.panel end
    local stroke = main:FindFirstChildOfClass("UIStroke")
    if stroke then stroke.Color = palette.accent end
    status.BackgroundColor3 = palette.card
    status.TextColor3 = palette.text
    playerCount.TextColor3 = palette.text
    local title = header:FindFirstChild("Title")
    if title then title.TextColor3 = palette.text end
    for _, object in ipairs(main:GetDescendants()) do
        if object:IsA("TextLabel") or object:IsA("TextButton") then
            object.TextColor3 = palette.text
        end
        if object:IsA("TextBox") then
            object.BackgroundColor3 = palette.input
            object.TextColor3 = palette.text
            object.PlaceholderColor3 = palette.muted
        elseif object:IsA("Frame") and object:GetAttribute("ServerPlayerCard") then
            object.BackgroundColor3 = palette.card
        elseif object:IsA("TextButton") then
            object.BackgroundColor3 = palette.accent
        end
    end
    themeButton.Text = "THEME : " .. themeName
    modeButton.Text = themeName == "LIGHT" and "MODE CLAIR  •  ACTIF" or "MODE SOMBRE  •  ACTIF"
    visualToggle.BackgroundColor3 = palette.accent
    visualToggle.TextColor3 = palette.text
    audioPanel.BackgroundColor3 = palette.panel
    for _, object in ipairs(audioPanel:GetDescendants()) do
        if object:IsA("TextBox") then
            object.BackgroundColor3 = palette.input
            object.TextColor3 = palette.text
        elseif object:IsA("TextLabel") then
            object.TextColor3 = palette.text
        elseif object:IsA("TextButton") then
            object.BackgroundColor3 = palette.accent
            object.TextColor3 = palette.text
        end
    end
end
connect(themeButton.Activated, nextTheme)
connect(modeButton.Activated, toggleLightDark)
applyTheme(activeThemeName)
connect(playerSearchBox:GetPropertyChangedSignal("Text"), function() refreshPlayers(true) end)
task.delay(1.5, checkForUpdate)

local activeJoinNotification
local notificationSerial = 0
local function notifyPlayerJoined(player)
    if destroyed or not player or player == localPlayer then
        return
    end
    notificationSerial = notificationSerial + 1
    local serial = notificationSerial
    if activeJoinNotification then
        activeJoinNotification:Destroy()
        activeJoinNotification = nil
    end
    local notice = make("Frame", {
        Name = "PlayerJoinedNotification",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -12, 0, 12),
        Size = UDim2.fromOffset(224, 54),
        BackgroundColor3 = Color3.fromRGB(28, 25, 40),
        BorderSizePixel = 0,
        ZIndex = 20,
    }, gui)
    activeJoinNotification = notice
    make("UICorner", {CornerRadius = UDim.new(0, 9)}, notice)
    make("UIStroke", {Color = Color3.fromRGB(125, 85, 220), Thickness = 1.4}, notice)
    local avatar = make("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(7, 7),
        Size = UDim2.fromOffset(40, 40),
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(player.UserId) .. "&w=150&h=150",
        ZIndex = 21,
    }, notice)
    make("UICorner", {CornerRadius = UDim.new(1, 0)}, avatar)
    make("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(54, 5),
        Size = UDim2.new(1, -60, 1, -10),
        Font = Enum.Font.GothamBold,
        Text = "NOUVEAU JOUEUR\n" .. tostring(player.DisplayName or player.Name) .. " (@" .. tostring(player.Name) .. ")",
        TextColor3 = Color3.fromRGB(245, 240, 255),
        TextSize = 10,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 21,
    }, notice)
    task.delay(4, function()
        if activeJoinNotification == notice and notificationSerial == serial then
            activeJoinNotification = nil
            if notice.Parent then notice:Destroy() end
        end
    end)
end
local dragging = false
local dragStart
local startPosition
connect(header.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)
connect(UserInputService.InputChanged, function(input)
    if not dragging then
        return
    end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end
    local delta = input.Position - dragStart
    main.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
end)
connect(UserInputService.InputEnded, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

connect(closeButton.Activated, function()
    destroyed = true
    pcall(function() loadingMusic:Stop() end)
    if loadingMusic.Parent then loadingMusic:Destroy() end
    pcall(function() clickSfx:Stop() end)
    if clickSfx.Parent then clickSfx:Destroy() end
    for _, connection in ipairs(connections) do
        if connection.Connected then
            connection:Disconnect()
        end
    end
    gui:Destroy()
end)

connect(Players.PlayerAdded, function(player)
    refreshPlayers(true)
    notifyPlayerJoined(player)
end)
connect(Players.PlayerRemoving, function() refreshPlayers(true) end)
task.spawn(function()
    local playerRefreshInterval = UserInputService.TouchEnabled and 4 or 3
    while not destroyed and gui.Parent do
        refreshPlayers(false)
        task.wait(playerRefreshInterval)
    end
end)
task.spawn(function()
    while not destroyed and gui.Parent do
        updateCoordinates()
        task.wait(coordinateInterval)
    end
end)
refreshPlayers()

local loadingDuration = 60
local loadingFinished = false
local loadingProgress = TweenService:Create(loadingFill, TweenInfo.new(loadingDuration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
local loadingSpin = TweenService:Create(loadingSpinner, TweenInfo.new(0.75, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), {Rotation = 360})
local skipButton = make("TextButton", {
    Name = "SkipLoading",
    AnchorPoint = Vector2.new(0.5, 1),
    Position = UDim2.new(0.5, 0, 1, -12),
    Size = UDim2.fromOffset(130, 24),
    BackgroundColor3 = Color3.fromRGB(125, 35, 55),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "SKIP  •  60s",
    TextColor3 = Color3.fromRGB(255, 235, 240),
    TextSize = 9,
    AutoButtonColor = false,
    ZIndex = 102,
}, loadingPanel)
make("UICorner", {CornerRadius = UDim.new(0, 7)}, skipButton)
bindButtonSfx(skipButton)
local function finishLoading()
    if loadingFinished or destroyed or not gui.Parent then return end
    loadingFinished = true
    loadingStatus.Text = "Interface prête"
    main.Visible = true
    loadingOverlay.Visible = false
    loadingProgress:Cancel()
    loadingSpin:Cancel()
    pcall(function() loadingMusic:Stop() end)
    if loadingMusic.Parent then loadingMusic:Destroy() end
    if loadingOverlay.Parent then loadingOverlay:Destroy() end
end
connect(skipButton.Activated, finishLoading)
if musicEnabled then pcall(function() loadingMusic:Play() end) end
loadingProgress:Play()
loadingSpin:Play()
task.spawn(function()
    local startedAt = os.clock()
    while not loadingFinished and not destroyed and gui.Parent do
        local remaining = math.max(0, math.ceil(loadingDuration - (os.clock() - startedAt)))
        skipButton.Text = "SKIP  •  " .. tostring(remaining) .. "s"
        loadingStatus.Text = "Chargement de l’interface... " .. tostring(remaining) .. "s"
        if remaining <= 0 then
            finishLoading()
            break
        end
        task.wait(1)
    end
end)
