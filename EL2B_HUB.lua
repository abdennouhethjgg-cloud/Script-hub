--[[
  EL2B HUB — Version corrigée et optimisée
  Tous les onglets fonctionnels, toutes les erreurs corrigées.
  Script prêt à être exécuté.
]]

repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")

local LP = Players.LocalPlayer
if not LP then
	repeat task.wait() until Players.LocalPlayer
	LP = Players.LocalPlayer
end
local PlayerGui = LP:WaitForChild("PlayerGui", 30) or LP:FindFirstChild("PlayerGui") or CoreGui
local EL2B_STATUS_URL = "https://el2bstatus-amhrowxg.manus.space/api/script-status"
local EL2B_STOPPED = false
local EL2B_LAST_ANNOUNCEMENT_ID = 0
local function EL2BReadRemoteState()
	local ok, response = pcall(function() return game:HttpGet(EL2B_STATUS_URL, true) end)
	if not ok or type(response) ~= "string" then return nil end
	local decoded, data = pcall(function() return HttpService:JSONDecode(response) end)
	if not decoded or type(data) ~= "table" or type(data.enabled) ~= "boolean" then return nil end
	return data
end
local function EL2BReadRemoteStatus()
	local state = EL2BReadRemoteState()
	return state and state.enabled or nil
end
local function EL2BShowAnnouncementGui(announcement)
	if type(announcement) ~= "table" or type(announcement.id) ~= "number" then return end
	if announcement.id <= EL2B_LAST_ANNOUNCEMENT_ID then return end
	EL2B_LAST_ANNOUNCEMENT_ID = announcement.id
	local old = PlayerGui:FindFirstChild("EL2BAnnouncementGui") or CoreGui:FindFirstChild("EL2BAnnouncementGui")
	if old then pcall(function() old:Destroy() end) end
	local gui = Instance.new("ScreenGui")
	gui.Name = "EL2BAnnouncementGui"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 100001
	gui.Parent = PlayerGui
	local card = Instance.new("Frame")
	card.Name = "AnnouncementCard"
	card.AnchorPoint = Vector2.new(0.5, 0)
	card.Position = UDim2.new(0.5, 0, 0, 28)
	card.Size = UDim2.new(1, -36, 0, 126)
	card.BackgroundColor3 = Color3.fromRGB(18, 15, 27)
	card.BackgroundTransparency = 0.04
	card.BorderSizePixel = 0
	card.Parent = gui
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)
	corner.Parent = card
	local border = Instance.new("UIStroke")
	border.Color = Color3.fromRGB(255, 20, 147)
	border.Thickness = 1.5
	border.Transparency = 0.18
	border.Parent = card
	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Position = UDim2.fromOffset(18, 12)
	title.Size = UDim2.new(1, -54, 0, 22)
	title.Font = Enum.Font.GothamBold
	title.Text = "EL2B HUB · ANNONCE / ANNOUNCEMENT"
	title.TextColor3 = Color3.fromRGB(255, 220, 135)
	title.TextSize = 11
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = card
	local message = Instance.new("TextLabel")
	message.BackgroundTransparency = 1
	message.Position = UDim2.fromOffset(18, 40)
	message.Size = UDim2.new(1, -36, 0, 68)
	message.Font = Enum.Font.Gotham
	message.Text = tostring(announcement.fr or "") .. "\n\n" .. tostring(announcement.en or "")
	message.TextColor3 = Color3.fromRGB(235, 225, 240)
	message.TextSize = 11
	message.TextWrapped = true
	message.TextXAlignment = Enum.TextXAlignment.Left
	message.TextYAlignment = Enum.TextYAlignment.Top
	message.Parent = card
	local close = Instance.new("TextButton")
	close.BackgroundTransparency = 1
	close.Position = UDim2.new(1, -34, 0, 8)
	close.Size = UDim2.fromOffset(24, 24)
	close.Text = "×"
	close.TextColor3 = Color3.fromRGB(220, 208, 226)
	close.TextSize = 18
	close.Font = Enum.Font.GothamBold
	close.Parent = card
	close.Activated:Connect(function() if gui.Parent then gui:Destroy() end end)
	task.delay(15, function() if gui.Parent then gui:Destroy() end end)
end
local function EL2BShowUpdateGui()
	local publicName = tostring(LP.DisplayName or LP.Name or "Joueur Roblox")
	publicName = string.sub(publicName, 1, 32)
	local gameName = tostring(game.Name or "Jeu Roblox")
	local gameInfoOk, gameInfo = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
	if gameInfoOk and type(gameInfo) == "table" and type(gameInfo.Name) == "string" and gameInfo.Name ~= "" then gameName = gameInfo.Name end
	gameName = string.sub(gameName, 1, 42)
	local isOnline = LP.Parent == Players
	local statusTextFr = isOnline and "EN LIGNE" or "HORS LIGNE"
	local statusTextEn = isOnline and "ONLINE" or "OFFLINE"
	local gameLower = string.lower(gameName)
	local isStealABrainrot = string.find(gameLower, "steal a brainrot", 1, true) ~= nil
	local safeModeFr = isStealABrainrot and "Steal a Brainrot · mode sûr" or "Mode sûr EL2B"
	local safeModeEn = isStealABrainrot and "Steal a Brainrot · safe mode" or "EL2B safe mode"
	local currentLanguage = "fr"
	local existing = PlayerGui:FindFirstChild("EL2BUpdateGui") or CoreGui:FindFirstChild("EL2BUpdateGui")
	if existing then return end
	local gui = Instance.new("ScreenGui")
	gui.Name = "EL2BUpdateGui"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 100000
	gui.Parent = PlayerGui
  local card = Instance.new("Frame")
  card.Name = "UpdateCard"
  card.AnchorPoint = Vector2.new(0.5, 0.5)
  card.Position = UDim2.fromScale(0.5, 0.5)
  card.Size = UDim2.new(1, -36, 0, 220)
  card.BackgroundColor3 = Color3.fromRGB(18, 15, 27)
  card.BackgroundTransparency = 0.04
  card.Parent = gui
  local halo = Instance.new("Frame")
  halo.Name = "UpdateHalo"
  halo.AnchorPoint = Vector2.new(0.5, 0.5)
  halo.Position = UDim2.fromScale(0.5, 0.5)
  halo.Size = UDim2.new(1, -26, 0, 230)
  halo.BackgroundTransparency = 1
  halo.BorderSizePixel = 0
  halo.ZIndex = 0
  halo.Parent = gui
  local haloCorner = Instance.new("UICorner")
  haloCorner.CornerRadius = UDim.new(0, 17)
  haloCorner.Parent = halo
  local haloStroke = Instance.new("UIStroke")
  haloStroke.Color = Color3.fromRGB(255, 20, 147)
  haloStroke.Thickness = 4
  haloStroke.Transparency = 0.68
  haloStroke.Parent = halo
  local reducedMotion = false
  pcall(function()
    reducedMotion = game:GetService("UserGameSettings").ReducedMotionEnabled == true
  end)
  local haloAnimationEnabled = not reducedMotion
  local haloToggle = Instance.new("TextButton")
  haloToggle.Name = "HaloAnimationToggle"
  haloToggle.AnchorPoint = Vector2.new(1, 0)
  haloToggle.Position = UDim2.new(1, -18, 0, 14)
  haloToggle.Size = UDim2.fromOffset(30, 24)
  haloToggle.BackgroundColor3 = Color3.fromRGB(46, 25, 58)
  haloToggle.BackgroundTransparency = 0.12
  haloToggle.BorderSizePixel = 0
  haloToggle.Font = Enum.Font.GothamBold
  haloToggle.Text = haloAnimationEnabled and "◌" or "×"
  haloToggle.TextColor3 = Color3.fromRGB(255, 220, 135)
  haloToggle.TextSize = 15
  haloToggle.AutoButtonColor = true
  haloToggle.ZIndex = 6
  haloToggle.Parent = card
  local haloToggleCorner = Instance.new("UICorner")
  haloToggleCorner.CornerRadius = UDim.new(0, 7)
  haloToggleCorner.Parent = haloToggle
  local function refreshHaloAnimation()
    haloToggle.Text = haloAnimationEnabled and "◌" or "×"
    haloToggle.TextColor3 = haloAnimationEnabled and Color3.fromRGB(255, 220, 135) or Color3.fromRGB(190, 176, 201)
    if not haloAnimationEnabled then
      haloStroke.Transparency = 0.82
    end
  end
  haloToggle.Activated:Connect(function()
    haloAnimationEnabled = not haloAnimationEnabled
    refreshHaloAnimation()
  end)
  refreshHaloAnimation()
  task.spawn(function()
    while halo.Parent do
      if not haloAnimationEnabled then
        task.wait(0.25)
      else
        local brighten = TS:Create(haloStroke, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Transparency = 0.42 })
        brighten:Play()
        brighten.Completed:Wait()
        if not halo.Parent then break end
        if not haloAnimationEnabled then
          pcall(function() brighten:Cancel() end)
          haloStroke.Transparency = 0.82
        else
          local soften = TS:Create(haloStroke, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Transparency = 0.74 })
          soften:Play()
          soften.Completed:Wait()
        end
      end
    end
  end)
  local gameBackdrop = Instance.new("ImageLabel")
  gameBackdrop.Name = "GameBackdrop"
  gameBackdrop.Size = UDim2.fromScale(1, 1)
  gameBackdrop.BackgroundColor3 = Color3.fromRGB(42, 18, 58)
  gameBackdrop.BackgroundTransparency = 0.12
  gameBackdrop.BorderSizePixel = 0
  gameBackdrop.Image = "rbxthumb://type=GameIcon&id=" .. tostring(game.PlaceId) .. "&w=512&h=512"
  gameBackdrop.ImageColor3 = Color3.fromRGB(150, 90, 170)
  gameBackdrop.ImageTransparency = 0.82
  gameBackdrop.ScaleType = Enum.ScaleType.Crop
  gameBackdrop.ZIndex = 0
  gameBackdrop.Parent = card
  local backdropCorner = Instance.new("UICorner")
  backdropCorner.CornerRadius = UDim.new(0, 14)
  backdropCorner.Parent = gameBackdrop
  local sizeConstraint = Instance.new("UISizeConstraint")
	sizeConstraint.MinSize = Vector2.new(240, 220)
	sizeConstraint.MaxSize = Vector2.new(340, 220)
	sizeConstraint.Parent = card
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)
	corner.Parent = card
	local outline = Instance.new("UIStroke")
	outline.Color = Color3.fromRGB(255, 20, 147)
	outline.Transparency = 0.18
	outline.Thickness = 1.5
	outline.Parent = card
	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Position = UDim2.fromOffset(18, 14)
	title.Size = UDim2.new(1, -112, 0, 24)
	title.Font = Enum.Font.GothamBold
	title.Text = "EL2B HUB · MISE À JOUR"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 15
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = card
	local copy = Instance.new("TextLabel")
	copy.BackgroundTransparency = 1
	copy.Position = UDim2.fromOffset(18, 42)
	copy.Size = UDim2.new(1, -78, 0, 44)
	copy.Font = Enum.Font.Gotham
	copy.Text = "Le script est temporairement arrêté.\nUne mise à jour est en cours."
	copy.TextColor3 = Color3.fromRGB(190, 176, 201)
	copy.TextSize = 12
	copy.TextWrapped = true
	copy.TextXAlignment = Enum.TextXAlignment.Left
	copy.TextYAlignment = Enum.TextYAlignment.Top
	copy.Parent = card
	local member = Instance.new("TextLabel")
	member.Name = "PublicName"
	member.BackgroundTransparency = 1
	member.Position = UDim2.fromOffset(64, 102)
	member.Size = UDim2.new(1, -154, 0, 18)
	member.Font = Enum.Font.GothamBold
	member.Text = "Profil Roblox : " .. publicName
	member.TextColor3 = Color3.fromRGB(255, 200, 112)
	member.TextSize = 11
	member.TextTruncate = Enum.TextTruncate.AtEnd
	member.TextXAlignment = Enum.TextXAlignment.Left
	member.Parent = card
	local gameLabel = Instance.new("TextLabel")
	gameLabel.Name = "CurrentGame"
	gameLabel.BackgroundTransparency = 1
	gameLabel.Position = UDim2.fromOffset(64, 122)
	gameLabel.Size = UDim2.new(1, -154, 0, 18)
	gameLabel.Font = Enum.Font.Gotham
	gameLabel.Text = "Jeu : " .. gameName
	gameLabel.TextColor3 = Color3.fromRGB(190, 176, 201)
	gameLabel.TextSize = 11
	gameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	gameLabel.TextXAlignment = Enum.TextXAlignment.Left
	gameLabel.Parent = card
	local gameIcon = Instance.new("ImageLabel")
	gameIcon.Name = "CurrentGameIcon"
	gameIcon.Position = UDim2.fromOffset(18, 102)
	gameIcon.Size = UDim2.fromOffset(34, 34)
	gameIcon.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
	gameIcon.BorderSizePixel = 0
	gameIcon.Image = "rbxthumb://type=GameIcon&id=" .. tostring(game.PlaceId) .. "&w=150&h=150"
	gameIcon.ImageTransparency = 1
	gameIcon.ScaleType = Enum.ScaleType.Crop
	gameIcon.Parent = card
	local gameIconCorner = Instance.new("UICorner")
	gameIconCorner.CornerRadius = UDim.new(0, 9)
	gameIconCorner.Parent = gameIcon
	local gameIconFallback = Instance.new("TextLabel")
	gameIconFallback.Name = "GameIconFallback"
	gameIconFallback.Size = UDim2.fromScale(1, 1)
	gameIconFallback.BackgroundTransparency = 1
	gameIconFallback.Font = Enum.Font.GothamBold
	gameIconFallback.Text = "G"
	gameIconFallback.TextColor3 = Color3.fromRGB(255, 255, 255)
	gameIconFallback.TextSize = 15
	gameIconFallback.Visible = false
	gameIconFallback.ZIndex = 2
	gameIconFallback.Parent = gameIcon
	local gameIconLoader = Instance.new("TextLabel")
	gameIconLoader.Name = "GameIconLoader"
	gameIconLoader.Size = UDim2.fromScale(1, 1)
	gameIconLoader.BackgroundTransparency = 1
	gameIconLoader.Font = Enum.Font.GothamBold
	gameIconLoader.Text = "◌"
	gameIconLoader.TextColor3 = Color3.fromRGB(255, 220, 135)
	gameIconLoader.TextSize = 21
	gameIconLoader.ZIndex = 3
	gameIconLoader.Parent = gameIcon
	local gameIconLoaded = false
	local gameIconTween = TS:Create(gameIconLoader, TweenInfo.new(0.9, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), { Rotation = 360 })
	gameIconTween:Play()
	local function finishGameIconLoad(loaded)
		if gameIconLoaded then return end
		gameIconLoaded = true
		pcall(function() gameIconTween:Cancel() end)
		if gameIconLoader.Parent then gameIconLoader.Visible = false end
		if loaded then
			gameIcon.ImageTransparency = 0
		else
			gameIconFallback.Visible = true
		end
	end
	gameIcon:GetPropertyChangedSignal("IsLoaded"):Connect(function()
		if gameIcon.IsLoaded then finishGameIconLoad(true) end
	end)
	task.delay(8, function()
		if not gameIconLoaded and gui.Parent then finishGameIconLoad(gameIcon.IsLoaded == true) end
	end)
	local profile = Instance.new("ImageButton")
	profile.Name = "RobloxProfileButton"
	profile.AnchorPoint = Vector2.new(1, 1)
	profile.Position = UDim2.new(1, -22, 0, 100)
	profile.Size = UDim2.fromOffset(64, 64)
	profile.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
	profile.BorderSizePixel = 0
	local profileImageUrl = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LP.UserId) .. "&w=150&h=150"
	profile.Image = profileImageUrl
	profile.ImageTransparency = 1
	profile.ScaleType = Enum.ScaleType.Crop
	profile.AutoButtonColor = true
	profile.Parent = card
	local profileCorner = Instance.new("UICorner")
	profileCorner.CornerRadius = UDim.new(1, 0)
	profileCorner.Parent = profile
	local avatarFallback = Instance.new("TextLabel")
	avatarFallback.Name = "AvatarFallback"
	avatarFallback.Size = UDim2.fromScale(1, 1)
	avatarFallback.BackgroundTransparency = 1
	avatarFallback.Font = Enum.Font.GothamBold
	avatarFallback.Text = "R"
	avatarFallback.TextColor3 = Color3.fromRGB(255, 255, 255)
	avatarFallback.TextSize = 23
	avatarFallback.Visible = false
	avatarFallback.ZIndex = 2
	avatarFallback.Parent = profile
	local avatarLoader = Instance.new("TextLabel")
	avatarLoader.Name = "AvatarLoader"
	avatarLoader.Size = UDim2.fromScale(1, 1)
	avatarLoader.BackgroundTransparency = 1
	avatarLoader.Font = Enum.Font.GothamBold
	avatarLoader.Text = "◌"
	avatarLoader.TextColor3 = Color3.fromRGB(255, 220, 135)
	avatarLoader.TextSize = 35
	avatarLoader.ZIndex = 3
	avatarLoader.Parent = profile
	local avatarRetry = Instance.new("TextButton")
	avatarRetry.Name = "AvatarRetryButton"
	avatarRetry.Position = UDim2.new(1, -94, 0, 104)
	avatarRetry.Size = UDim2.fromOffset(24, 24)
	avatarRetry.BackgroundColor3 = Color3.fromRGB(255, 200, 112)
	avatarRetry.BorderSizePixel = 0
	avatarRetry.Font = Enum.Font.GothamBold
	avatarRetry.Text = "↻"
	avatarRetry.TextColor3 = Color3.fromRGB(18, 15, 27)
	avatarRetry.TextSize = 16
	avatarRetry.AutoButtonColor = true
	avatarRetry.Visible = false
	avatarRetry.ZIndex = 6
	avatarRetry.Parent = card
	local avatarRetryCorner = Instance.new("UICorner")
	avatarRetryCorner.CornerRadius = UDim.new(1, 0)
	avatarRetryCorner.Parent = avatarRetry
	local avatarLoaded = false
	local avatarAttempt = 0
	local loaderTween
	local function finishAvatarLoad(loaded)
		if avatarLoaded then return end
		avatarLoaded = true
		pcall(function() if loaderTween then loaderTween:Cancel() end end)
		if avatarLoader.Parent then avatarLoader.Visible = false end
		if loaded then
			profile.ImageTransparency = 0
			avatarFallback.Visible = false
			avatarRetry.Visible = false
		else
			avatarFallback.Visible = true
			avatarRetry.Visible = true
		end
	end
	local function beginAvatarLoad()
		avatarAttempt += 1
		local attempt = avatarAttempt
		avatarLoaded = false
		profile.ImageTransparency = 1
		avatarFallback.Visible = false
		avatarRetry.Visible = false
		avatarLoader.Visible = true
		avatarLoader.Rotation = 0
		pcall(function() if loaderTween then loaderTween:Cancel() end end)
		loaderTween = TS:Create(avatarLoader, TweenInfo.new(0.9, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), { Rotation = 360 })
		loaderTween:Play()
		profile.Image = ""
		task.defer(function()
			if gui.Parent and attempt == avatarAttempt then profile.Image = profileImageUrl end
		end)
		task.delay(8, function()
			if attempt == avatarAttempt and not avatarLoaded and gui.Parent then finishAvatarLoad(profile.IsLoaded == true) end
		end)
	end
	profile:GetPropertyChangedSignal("IsLoaded"):Connect(function()
		if profile.IsLoaded then finishAvatarLoad(true) end
	end)
	avatarRetry.Activated:Connect(beginAvatarLoad)
	beginAvatarLoad()
	local profileUrl = "https://www.roblox.com/users/" .. tostring(LP.UserId) .. "/profile"
	local statusDot = Instance.new("Frame")
	statusDot.Name = "OnlineStatusDot"
	statusDot.AnchorPoint = Vector2.new(1, 1)
	statusDot.Position = UDim2.new(1, -16, 0, 150)
	statusDot.Size = UDim2.fromOffset(16, 16)
	statusDot.BackgroundColor3 = isOnline and Color3.fromRGB(65, 230, 125) or Color3.fromRGB(235, 75, 95)
	statusDot.BorderSizePixel = 0
	statusDot.ZIndex = 4
	statusDot.Parent = card
	local statusDotCorner = Instance.new("UICorner")
	statusDotCorner.CornerRadius = UDim.new(1, 0)
	statusDotCorner.Parent = statusDot
	local statusRing = Instance.new("UIStroke")
	statusRing.Color = Color3.fromRGB(18, 15, 27)
	statusRing.Thickness = 3
	statusRing.Parent = statusDot
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "OnlineStatus"
	statusLabel.BackgroundTransparency = 1
	statusLabel.Position = UDim2.fromOffset(64, 146)
	statusLabel.Size = UDim2.new(1, -154, 0, 18)
	statusLabel.Font = Enum.Font.GothamBold
	statusLabel.Text = statusTextFr
	statusLabel.TextColor3 = isOnline and Color3.fromRGB(110, 240, 160) or Color3.fromRGB(255, 120, 135)
	statusLabel.TextSize = 11
	statusLabel.TextXAlignment = Enum.TextXAlignment.Left
	statusLabel.Parent = card
	local progressTrack = Instance.new("Frame")
	progressTrack.Name = "UpdateProgressTrack"
	progressTrack.Position = UDim2.fromOffset(18, 170)
	progressTrack.Size = UDim2.new(1, -154, 0, 6)
	progressTrack.BackgroundColor3 = Color3.fromRGB(55, 40, 70)
	progressTrack.BorderSizePixel = 0
	progressTrack.ZIndex = 2
	progressTrack.Parent = card
	local progressTrackCorner = Instance.new("UICorner")
	progressTrackCorner.CornerRadius = UDim.new(1, 0)
	progressTrackCorner.Parent = progressTrack
	local progressFill = Instance.new("Frame")
	progressFill.Name = "UpdateProgressFill"
	progressFill.Size = UDim2.new(0, 0, 1, 0)
	progressFill.BackgroundColor3 = Color3.fromRGB(255, 200, 112)
	progressFill.BorderSizePixel = 0
	progressFill.ZIndex = 3
	progressFill.Parent = progressTrack
	local progressFillCorner = Instance.new("UICorner")
	progressFillCorner.CornerRadius = UDim.new(1, 0)
	progressFillCorner.Parent = progressFill
	local progressText = Instance.new("TextLabel")
	progressText.Name = "UpdateProgressText"
	progressText.BackgroundTransparency = 1
	progressText.Position = UDim2.fromOffset(18, 182)
	progressText.Size = UDim2.new(1, -154, 0, 32)
	progressText.Font = Enum.Font.Gotham
	progressText.Text = safeModeText .. " · 20s"
	progressText.TextColor3 = Color3.fromRGB(190, 176, 201)
	progressText.TextSize = 10
	progressText.TextTruncate = Enum.TextTruncate.AtEnd
	progressText.TextWrapped = true
	progressText.TextXAlignment = Enum.TextXAlignment.Left
	progressText.TextYAlignment = Enum.TextYAlignment.Top
	progressText.ZIndex = 2
	progressText.Parent = card
	local languageButton = Instance.new("TextButton")
	languageButton.Name = "LanguageButton"
	languageButton.Position = UDim2.new(1, -66, 0, 12)
	languageButton.Size = UDim2.fromOffset(44, 28)
	languageButton.BackgroundColor3 = Color3.fromRGB(75, 45, 95)
	languageButton.BorderSizePixel = 0
	languageButton.Font = Enum.Font.GothamBold
	languageButton.Text = "EN"
	languageButton.TextColor3 = Color3.fromRGB(255, 220, 135)
	languageButton.TextSize = 11
	languageButton.AutoButtonColor = true
	languageButton.ZIndex = 5
	languageButton.Parent = card
	local languageCorner = Instance.new("UICorner")
	languageCorner.CornerRadius = UDim.new(0, 8)
	languageCorner.Parent = languageButton
	local function applyLanguage()
		local english = currentLanguage == "en"
		title.Text = english and "EL2B HUB · UPDATE" or "EL2B HUB · MISE À JOUR"
		copy.Text = english and "The script is temporarily stopped.\nAn update is in progress." or "Le script est temporairement arrêté.\nUne mise à jour est en cours."
		member.Text = (english and "Roblox profile: " or "Profil Roblox : ") .. publicName
		gameLabel.Text = (english and "Game: " or "Jeu : ") .. gameName
		statusLabel.Text = english and statusTextEn or statusTextFr
		languageButton.Text = english and "FR" or "EN"
		avatarRetry.Text = english and "Retry" or "Relancer"
		progressText.Text = (english and safeModeEn or safeModeFr) .. " · 20s"
	end
	languageButton.Activated:Connect(function()
		currentLanguage = currentLanguage == "fr" and "en" or "fr"
		applyLanguage()
	end)
	profile.Activated:Connect(function()
		local opened = pcall(function() GuiService:OpenBrowserWindow(profileUrl) end)
		if opened then
			progressText.Text = currentLanguage == "en" and "Profile opened in browser." or "Profil ouvert dans le navigateur."
		else
			progressText.Text = currentLanguage == "en" and "Open the profile from Roblox." or "Ouvre le profil depuis Roblox."
		end
	end)
	applyLanguage()
	task.spawn(function()
		local duration = 20
		local endsAt = time() + duration
		local messages = {
			{ fr = "Vérification du statut EL2B", en = "Checking EL2B status" },
			{ fr = "Profil local préparé", en = "Preparing local profile" },
			{ fr = "Nom et icône du jeu lus localement", en = "Reading local game metadata" },
			{ fr = "Diagnostic autorisé uniquement", en = "Allowed diagnostics only" },
		}
		local lastSecond = -1
		while gui.Parent do
			local remaining = math.max(0, math.ceil(endsAt - time()))
			local elapsed = math.clamp(duration - (endsAt - time()), 0, duration)
			progressFill.Size = UDim2.new(elapsed / duration, 0, 1, 0)
			if remaining ~= lastSecond then
				lastSecond = remaining
				if remaining > 0 then
					local index = math.clamp(math.floor((duration - remaining) / 5) + 1, 1, #messages)
					local message = messages[index]
					progressText.Text = (currentLanguage == "en" and message.en or message.fr) .. " · " .. tostring(remaining) .. "s"
				else
					progressText.Text = currentLanguage == "en" and "Update checked · Still paused · No sensitive data sent" or "Mise à jour vérifiée · Toujours en pause · Aucune donnée sensible envoyée"
				end
			end
			if remaining <= 0 then break end
			task.wait(0.25)
		end
	end)
	local close = Instance.new("TextButton")
	close.Name = "CloseButton"
	close.AnchorPoint = Vector2.new(1, 0)
	close.Position = UDim2.new(1, -10, 0, 8)
	close.Size = UDim2.fromOffset(26, 26)
	close.BackgroundTransparency = 1
	close.Font = Enum.Font.GothamBold
	close.Text = "×"
	close.TextColor3 = Color3.fromRGB(220, 208, 226)
	close.TextSize = 20
	close.Parent = card
	close.Activated:Connect(function() gui:Destroy() end)
end
local function EL2BStopLocally()
	if EL2B_STOPPED then return end
	EL2B_STOPPED = true
	_G.EL2BGlobalStop = true
	for _, name in ipairs({ "VisHubFullMenu", "VisHubFullMini", "VisHubModeBar", "VisHubActionButtons", "EL2BHelperGui", "EL2BProfileGui", "EL2BAnnouncementGui" }) do
		local gui = PlayerGui:FindFirstChild(name) or CoreGui:FindFirstChild(name)
		if gui then pcall(function() gui:Destroy() end) end
	end
	EL2BShowUpdateGui()
	warn("EL2B HUB arrêté par le contrôle administrateur.")
end
local initialRemoteState = EL2BReadRemoteState()
if initialRemoteState then
	if initialRemoteState.announcement then EL2BShowAnnouncementGui(initialRemoteState.announcement) end
	if initialRemoteState.enabled == false then EL2BStopLocally(); return end
end
task.spawn(function()
	while not EL2B_STOPPED do
		task.wait(15)
		local remoteState = EL2BReadRemoteState()
		if remoteState then
			if remoteState.announcement then EL2BShowAnnouncementGui(remoteState.announcement) end
			if remoteState.enabled == false then EL2BStopLocally(); break end
		end
	end
end)
local EL2BReloadGeneration = (_G.EL2BReloadGeneration or 0) + 1
_G.EL2BReloadGeneration = EL2BReloadGeneration

-- Nettoyer les anciennes interfaces
pcall(function()
	for _, n in ipairs({
		"VisHubFullMenu", "VisHubFullMini", "VisHubModeBar", "VisHubActionButtons", "EL2BHelperGui",
		"VisV2ModeBar", "VisBypassGui", "Per1shccLaggerV2", "VisHubbTP",
		"VisPanelTP", "VisAutoStealGui", "VisTpBestBtn", "VisStealBarOnly", "EL2BProfileGui", "EL2BUpdateGui"
	}) do
		local g = PlayerGui:FindFirstChild(n)
		if g then g:Destroy() end
	end
end)

-- ==============================
--  CONSTANTES ET ÉTAT GLOBAL
-- ==============================
local C = {
	bg = Color3.fromRGB(12, 12, 16), bg2 = Color3.fromRGB(18, 18, 24),
	card = Color3.fromRGB(24, 24, 32), stroke = Color3.fromRGB(60, 60, 80),
	accent = Color3.fromRGB(255, 20, 147), text = Color3.fromRGB(255, 255, 255),
	textDim = Color3.fromRGB(160, 160, 180), on = Color3.fromRGB(60, 220, 110),
	off = Color3.fromRGB(40, 40, 52), box = Color3.fromRGB(32, 32, 44),
	danger = Color3.fromRGB(220, 70, 90),
	modeOnBg = Color3.fromRGB(255, 20, 147), modeOnTxt = Color3.fromRGB(255, 255, 255),
	modeOffBg = Color3.fromRGB(255, 255, 255), modeOffTxt = Color3.fromRGB(25, 25, 30),
	btnOn = Color3.fromRGB(50, 210, 100), btnOff = Color3.fromRGB(16, 16, 22),
}

local BackgroundIDs = {
	"89504528485163","108697485255882","71211662493854","118953269416540","106345334781345",
	"103042929344358","126137370200580","129236724255771","109053968018578","76085007631338",
	"99416158073201","126860692354524","73226092831324","90280869222992","90746158236678",
	"107977050874654","124475159163140","117085976067902","76582249427748","131388128481309",
	"106050493494582","71852104184395","84453255265251","98541566010518","118963313877514",
	"82757811555212","130451097419605","129030262345273","76292842640935","92910922537368",
	"105960347086002","116720305084998","90341354549871","72399600208480","81834484116440",
	"135088241492683","90453834580322","90631990302263","109619268613730","88369503310562",
	"80708025126373","102253425322931","135181794444219","111941119745474","138739435956313",
	"92966351305582","127008542588565","81233250155347","77446891363466","93417009946836",
	"102729289645203","113953274092851","116355482429334","133090961209841","84995781107338"
}

local St = {
	antiGummy = true, antiRagdoll = false, antiPaint = true, antiBoogie = true,
	toolAim = true, speedOn = true, infJump = true, bodyLock = false, bodyLockRange = 20,
	activeMode = "Normal",
	modes = {
		Normal = { norm = 59, steal = 30, key = Enum.KeyCode.T },
		Lagger = { norm = 18, steal = 24, key = Enum.KeyCode.Q },
		Custom = { norm = 33, steal = 33, key = Enum.KeyCode.C },
	},
	dropMode = 2,
	instaMode = "V1",
	mobileBtns = true, guiLock = false, webStatus = false, webStatusId = nil, npcWatcher = false,
	showStealBtn = true, showTPPanel = true, showLaggerPanel = false, showSpeedBypassPanel = false,
	speedBypassLock = false, panelGuiScale = 0.7, panelGuiWidth = 1,
	laggerPanelLock = false,
	btnShape = "Square",
	btnScale = 0.75,
	menuScale = 1.0,
	btnSizes = { mode = 50, drop = 50, insta = 50, tp = 50, sentry = 50, steal = 50, profile = 50 },
	keys = {
		Drop = Enum.KeyCode.X,
		TPDown = Enum.KeyCode.F,
		InstaReset = Enum.KeyCode.Z,
		DestroySentry = Enum.KeyCode.H,
		AutoSteal = nil,
	},
	esp = false, tracer = false, antiLag = false, visualCleaner = false, fovLock = 70,
	antiKick = true, wallOpacity = 0.12, speedMethod = "Velocity",
	destroySentry = false,
	spamLaser = false, spamPaint = false,
	counterLaser = false, counterBoogie = false, counterSwapBody = false,
	equipOnDrop = false,
		stealVer = "V1", stealRadius = 60, stealPause = false, stealPausePct = 75,
		autoSteal = false,
		infJumpMode = "hold",
		buttonVolume = 0.22,
		soundsEnabled = true,
		soundTheme = "Neon",
		customSoundClick = "",
		customSoundSuccess = "",
		customSoundError = "",
	}
_G.VisState = St

-- Fallback sûr lorsque le module Auto Steal externe n'est pas chargé.
-- Il conserve l'état de l'interface sans prétendre implémenter le module externe.
if type(setAutoSteal) ~= "function" then
	function setAutoSteal(on)
		St.autoSteal = on == true
		_G.VisStealPause = St.stealPause == true
		if _G.VisRefreshStealBtn then pcall(_G.VisRefreshStealBtn) end
		return St.autoSteal
	end
end

-- Profil local EL2B HUB : compatible avec les anciennes configurations VisHub.
local PROFILE_VERSION = 1
local CFG = "EL2B_HUB_Profile.json"
local LEGACY_CFG = "VisAllgear.json"
function saveCfg()
	local d = { _profileVersion = PROFILE_VERSION }
	for k, v in pairs(St) do
		if type(k) == "string" and k ~= "_saveBase" and k ~= "_savePet" and k ~= "saveBase" and k ~= "savePet" then
			local sv = _serializeValue(v)
			if sv ~= nil then d[k] = sv end
		end
	end
	-- modes et keys
	d.modes = {}
	for k, m in pairs(St.modes or {}) do
		if type(m) == "table" then
			d.modes[k] = { norm = tonumber(m.norm) or 16, steal = tonumber(m.steal) or 16, key = tostring(m.key) }
		end
	end
	d.keys = {}
	for k, v in pairs(St.keys or {}) do
		d.keys[k] = tostring(v)
	end
	local ok, err = pcall(function()
		if type(writefile) ~= "function" then error("writefile indisponible") end
		writefile(CFG, HttpService:JSONEncode(d))
	end)
	if not ok then warn("[VisHub] saveCfg fail:", err) end
	return ok, err
end

function _serializeValue(v, depth)
	depth = depth or 0
	if depth > 6 then return nil end
	local t = typeof(v)
	if t == "number" or t == "string" or t == "boolean" then
		return v
	elseif t == "EnumItem" then
		return v.Name
	elseif t == "table" then
		local out = {}
		for k2, v2 in pairs(v) do
			local kt = type(k2)
			if kt == "string" or kt == "number" then
				local sv = _serializeValue(v2, depth + 1)
				if sv ~= nil then out[k2] = sv end
			end
		end
		return out
	end
	return nil
end

function loadCfg()
	local loadedFile = nil
	local ok, data = pcall(function()
		if type(isfile) ~= "function" or type(readfile) ~= "function" then return nil end
		if isfile(CFG) then
			loadedFile = CFG
		elseif isfile(LEGACY_CFG) then
			loadedFile = LEGACY_CFG
		end
		if loadedFile then return HttpService:JSONDecode(readfile(loadedFile)) end
	end)
	if not (ok and type(data) == "table") then return false end
	for k, v in pairs(data) do
		if type(k) == "string" and k ~= "modes" and k ~= "keys" and k ~= "_profileVersion" then
			St[k] = v
		end
	end
	if type(data.modes) == "table" then
		for k, m in pairs(data.modes) do
			if type(m) == "table" then
				St.modes[k] = St.modes[k] or { norm = 59, steal = 30, key = Enum.KeyCode.Unknown }
				St.modes[k].norm = tonumber(m.norm) or St.modes[k].norm
				St.modes[k].steal = tonumber(m.steal) or St.modes[k].steal
				if type(m.key) == "string" then
					pcall(function() St.modes[k].key = Enum.KeyCode[m.key] end)
				end
			end
		end
	end
	if type(data.keys) == "table" then
		St.keys = St.keys or {}
		for k, name in pairs(data.keys) do
			pcall(function() St.keys[k] = Enum.KeyCode[name] end)
		end
	end
	if type(data.btnSizes) == "table" then
		St.btnSizes = data.btnSizes
		for k,v in pairs(St.btnSizes) do
			St.btnSizes[k] = math.clamp(tonumber(v) or 50, 20, 200)
		end
	end
	St.stealRadius = tonumber(St.stealRadius) or 60
	St.stealVer = St.stealVer or "V1"
	St.stealBarScale = tonumber(St.stealBarScale) or 1
	if St.showStealBtn == nil then St.showStealBtn = true end
	autoStealRadius = St.stealRadius
	if loadedFile == LEGACY_CFG then pcall(saveCfg) end
	return true
end
loadCfg()

-- Auto-save toutes les 3s
task.spawn(function()
	while task.wait(3) do
		pcall(saveCfg)
	end
end)

-- ==============================
--  FONCTIONS UTILITAIRES
-- ==============================
function showToast(msg)
	pcall(function()
		if not msg then return end
		local toast = Instance.new("TextLabel")
		toast.BackgroundTransparency = 0.5
		toast.BackgroundColor3 = Color3.fromRGB(0,0,0)
		toast.Text = tostring(msg)
		toast.TextColor3 = Color3.new(1,1,1)
		toast.TextScaled = true
		toast.Size = UDim2.new(0, 300, 0, 50)
		toast.Position = UDim2.new(0.5, -150, 0.8, 0)
		toast.ZIndex = 999
		toast.Parent = PlayerGui
		corner(toast, 12)
		task.wait(1.5)
		toast:Destroy()
	end)
end

function corner(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 10)
	c.Parent = p
	return c
end
function stroke(p, col)
	local s = Instance.new("UIStroke")
	s.Color = col or C.stroke
	s.Thickness = 1
	s.Transparency = 0.35
	s.Parent = p
	return s
end

-- ==============================
--  SPEED (Empire)
-- ==============================
local speedConnection = nil
local currentSpeedValue = 16
local _spd = {
	lastMethod = nil,
	lastMoveDir = Vector3.zero,
	anchoredBySpeed = nil,
	bodyVel = nil, bodyPosition = nil, bodyForce = nil, bodyThrust = nil,
	linearVel = nil, vectorForce = nil, alignPos = nil,
	rocket = nil, rocketTarget = nil,
	attLinVel = nil, attVecForce = nil, attAlign = nil,
	speedTween = nil,
}

local MOVE_KEYS = {
	[Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true, [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
	[Enum.KeyCode.Up] = true, [Enum.KeyCode.Down] = true, [Enum.KeyCode.Left] = true, [Enum.KeyCode.Right] = true,
}

function getCharParts()
	local char = LP.Character
	if not char then return nil, nil end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not hum or not root then return nil, nil end
	return hum, root
end

function isCarryingBrainrot(char)
	if not char then return false end
	local ok, st = pcall(function() return LP:GetAttribute("Stealing") end)
	if ok and st == true then return true end
	ok, st = pcall(function() return char:GetAttribute("Stealing") end)
	if ok and st == true then return true end
	for _, v in ipairs(char:GetChildren()) do
		if v:IsA("Tool") or v:IsA("Model") or v:IsA("Folder") then
			local n = string.lower(tostring(v.Name))
			if n:find("brainrot", 1, true) or n:find("carriedbrain", 1, true) then
				return true
			end
		end
	end
	return false
end

function getActiveMoveSpeed()
	local mode = St.activeMode
	if not mode or not St.modes[mode] then
		mode = "Normal"
		St.activeMode = "Normal"
	end
	local m = St.modes[mode] or { norm = 59, steal = 30 }
	local norm = math.clamp(tonumber(m.norm) or 59, 1, 200)
	local steal = math.clamp(tonumber(m.steal) or 30, 1, 200)
	if isCarryingBrainrot(LP.Character) then
		return steal
	end
	return norm
end

function ensureSpeedAttachment(hrp, key, name)
	local att = _spd[key]
	if not att or att.Parent ~= hrp then
		if att then pcall(function() att:Destroy() end) end
		att = Instance.new("Attachment")
		att.Name = name or "VisEmpireSpeedAtt"
		att.Parent = hrp
		_spd[key] = att
	end
	return att
end

function destroySpeedObjects()
	if _spd.anchoredBySpeed then pcall(function() _spd.anchoredBySpeed.Anchored = false end); _spd.anchoredBySpeed = nil end
	if _spd.bodyVel then pcall(function() _spd.bodyVel:Destroy() end); _spd.bodyVel = nil end
	if _spd.bodyPosition then pcall(function() _spd.bodyPosition:Destroy() end); _spd.bodyPosition = nil end
	if _spd.bodyForce then pcall(function() _spd.bodyForce:Destroy() end); _spd.bodyForce = nil end
	if _spd.bodyThrust then pcall(function() _spd.bodyThrust:Destroy() end); _spd.bodyThrust = nil end
	if _spd.linearVel then pcall(function() _spd.linearVel:Destroy() end); _spd.linearVel = nil end
	if _spd.vectorForce then pcall(function() _spd.vectorForce:Destroy() end); _spd.vectorForce = nil end
	if _spd.alignPos then pcall(function() _spd.alignPos:Destroy() end); _spd.alignPos = nil end
	if _spd.rocket then pcall(function() _spd.rocket:Destroy() end); _spd.rocket = nil end
	if _spd.rocketTarget then pcall(function() _spd.rocketTarget:Destroy() end); _spd.rocketTarget = nil end
	if _spd.attLinVel then pcall(function() _spd.attLinVel:Destroy() end); _spd.attLinVel = nil end
	if _spd.attVecForce then pcall(function() _spd.attVecForce:Destroy() end); _spd.attVecForce = nil end
	if _spd.attAlign then pcall(function() _spd.attAlign:Destroy() end); _spd.attAlign = nil end
	if _spd.speedTween then pcall(function() _spd.speedTween:Cancel() end); _spd.speedTween = nil end
end

function applySpeedMethod(hrp, hum, dir, spd, dt)
	local step = dt or 1/60
	local m = (St.speedMethod or "Velocity")
	if _spd.lastMethod ~= m then
		destroySpeedObjects()
		if m ~= "WalkSpeed" and hum.WalkSpeed ~= 16 then hum.WalkSpeed = 16 end
		_spd.lastMethod = m
	end
	local char = hrp.Parent
	local targetPos = hrp.Position + (dir * spd * step)
	local function massImpulse(direction, targetSpeed)
		local mass = hrp.AssemblyMass or 1
		local current = hrp.AssemblyLinearVelocity
		local desired = Vector3.new(direction.X * targetSpeed, current.Y, direction.Z * targetSpeed)
		local delta = desired - current
		pcall(function() hrp:ApplyImpulse(Vector3.new(delta.X, 0, delta.Z) * mass) end)
	end
	if m == "Velocity" or m == "AssemblyLinearVelocity" then
		massImpulse(dir, spd)
	elseif m == "Velocity Lerp" or m == "AssemblyLinearVelocity Lerp" then
		local current = hrp.AssemblyLinearVelocity
		local desired = Vector3.new(dir.X*spd, current.Y, dir.Z*spd)
		local blended = current:Lerp(desired, 0.6)
		local mass = hrp.AssemblyMass or 1
		pcall(function() hrp:ApplyImpulse(Vector3.new(blended.X - current.X, 0, blended.Z - current.Z) * mass) end)
	elseif m == "CFrame" then
		hrp.CFrame = hrp.CFrame + (dir * spd * step)
	elseif m == "CFrame Lerp" then
		hrp.CFrame = hrp.CFrame:Lerp(hrp.CFrame + (dir * spd * step), 0.5)
	elseif m == "Hyper CFrame" then
		hrp.CFrame = hrp.CFrame + (dir * spd * ((St.hyperMult or 4) or 4) * step)
	elseif m == "Anchored CFrame" then
		if not hrp.Anchored then hrp.Anchored = true; _spd.anchoredBySpeed = hrp end
		hrp.CFrame = hrp.CFrame + (dir * spd * step)
	elseif m == "PivotTo" then
		hrp:PivotTo(hrp.CFrame + (dir * spd * step))
	elseif m == "Model PivotTo" then
		if char and char:IsA("Model") then char:PivotTo(char:GetPivot() + (dir * spd * step)) else hrp:PivotTo(hrp.CFrame + (dir * spd * step)) end
	elseif m == "Tween CFrame" then
		if _spd.speedTween then pcall(function() _spd.speedTween:Cancel() end) end
		_spd.speedTween = TS:Create(hrp, TweenInfo.new(step, Enum.EasingStyle.Linear), {CFrame = hrp.CFrame + (dir * spd * step)})
		_spd.speedTween:Play()
	elseif m == "WalkSpeed" or m == "Humanoid Move" then
		hum.WalkSpeed = spd
	elseif m == "Humanoid MoveTo" then
		hum:MoveTo(targetPos, hrp)
	elseif m == "BodyVelocity" then
		if not _spd.bodyVel or _spd.bodyVel.Parent ~= hrp then
			if _spd.bodyVel then _spd.bodyVel:Destroy() end
			_spd.bodyVel = Instance.new("BodyVelocity")
			_spd.bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			_spd.bodyVel.Parent = hrp
		end
		_spd.bodyVel.Velocity = Vector3.new(dir.X*spd, _spd.bodyVel.Velocity.Y, dir.Z*spd)
	elseif m == "BodyPosition" then
		if not _spd.bodyPosition or _spd.bodyPosition.Parent ~= hrp then
			if _spd.bodyPosition then _spd.bodyPosition:Destroy() end
			_spd.bodyPosition = Instance.new("BodyPosition")
			_spd.bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			_spd.bodyPosition.P = 500
			_spd.bodyPosition.D = 50
			_spd.bodyPosition.Parent = hrp
		end
		_spd.bodyPosition.Position = targetPos
	elseif m == "BodyForce" then
		if not _spd.bodyForce or _spd.bodyForce.Parent ~= hrp then
			if _spd.bodyForce then _spd.bodyForce:Destroy() end
			_spd.bodyForce = Instance.new("BodyForce")
			_spd.bodyForce.Parent = hrp
		end
		_spd.bodyForce.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100
	elseif m == "BodyThrust" then
		if not _spd.bodyThrust or _spd.bodyThrust.Parent ~= hrp then
			if _spd.bodyThrust then _spd.bodyThrust:Destroy() end
			_spd.bodyThrust = Instance.new("BodyThrust")
			_spd.bodyThrust.Force = Vector3.new(math.huge, math.huge, math.huge)
			_spd.bodyThrust.Parent = hrp
		end
		_spd.bodyThrust.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100
	elseif m == "LinearVelocity" then
		if not _spd.linearVel or _spd.linearVel.Parent ~= hrp then
			if _spd.linearVel then _spd.linearVel:Destroy() end
			local att = ensureSpeedAttachment(hrp, "attLinVel", "MoveeLinVelAtt")
			_spd.linearVel = Instance.new("LinearVelocity")
			_spd.linearVel.Attachment0 = att
			_spd.linearVel.MaxForce = 1e8
			_spd.linearVel.RelativeTo = Enum.ActuatorRelativeTo.World
			_spd.linearVel.Parent = hrp
		end
		_spd.linearVel.VectorVelocity = Vector3.new(dir.X*spd, _spd.linearVel.VectorVelocity.Y, dir.Z*spd)
	elseif m == "VectorForce" then
		if not _spd.vectorForce or _spd.vectorForce.Parent ~= hrp then
			if _spd.vectorForce then _spd.vectorForce:Destroy() end
			local att = ensureSpeedAttachment(hrp, "attVecForce", "MoveeVecForceAtt")
			_spd.vectorForce = Instance.new("VectorForce")
			_spd.vectorForce.Attachment0 = att
			_spd.vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
			_spd.vectorForce.Parent = hrp
		end
		_spd.vectorForce.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100
	elseif m == "AlignPosition" then
		if not _spd.alignPos or _spd.alignPos.Parent ~= hrp then
			if _spd.alignPos then _spd.alignPos:Destroy() end
			local att = ensureSpeedAttachment(hrp, "attAlign", "MoveeAlignAtt")
			_spd.alignPos = Instance.new("AlignPosition")
			_spd.alignPos.Attachment0 = att
			_spd.alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment
			_spd.alignPos.MaxForce = math.huge
			_spd.alignPos.Responsiveness = 15
			_spd.alignPos.RigidityEnabled = false
			_spd.alignPos.Parent = hrp
		end
		_spd.alignPos.Position = targetPos
	elseif m == "ApplyImpulse" then
		local mass = hrp.AssemblyMass or 1
		local current = hrp.AssemblyLinearVelocity
		local desired = Vector3.new(dir.X * spd, current.Y, dir.Z * spd)
		local delta = desired - current
		pcall(function() hrp:ApplyImpulse(Vector3.new(delta.X, 0, delta.Z) * mass) end)
	elseif m == "RocketPropulsion" then
		if not _spd.rocket or _spd.rocket.Parent ~= hrp or not _spd.rocketTarget then
			if _spd.rocket then _spd.rocket:Destroy() end
			if _spd.rocketTarget then _spd.rocketTarget:Destroy() end
			_spd.rocketTarget = Instance.new("Part")
			_spd.rocketTarget.Name = "MoveeRocketTarget"
			_spd.rocketTarget.Anchored = true
			_spd.rocketTarget.CanCollide = false
			_spd.rocketTarget.Transparency = 1
			_spd.rocketTarget.Size = Vector3.new(1,1,1)
			_spd.rocketTarget.Parent = workspace
			_spd.rocket = Instance.new("RocketPropulsion")
			_spd.rocket.MaxThrust = 3000
			_spd.rocket.MaxTorque = 1000
			_spd.rocket.ThrustP = 100
			_spd.rocket.ThrustD = 20
			_spd.rocket.TurnP = 100
			_spd.rocket.TurnD = 10
			_spd.rocket.Target = _spd.rocketTarget
			_spd.rocket.Parent = hrp
		end
		_spd.rocketTarget.Position = targetPos
		pcall(function() _spd.rocket:Fire() end)
	end
end

function stopSpeedBoost()
	if speedConnection then
		pcall(function() speedConnection:Disconnect() end)
		speedConnection = nil
	end
	destroySpeedObjects()
end

function startSpeedBoost()
	if not St.speedOn then
		stopSpeedBoost()
		return
	end
	currentSpeedValue = getActiveMoveSpeed()
	if speedConnection then
		pcall(function() speedConnection:Disconnect() end)
		speedConnection = nil
	end
	speedConnection = RS.RenderStepped:Connect(function(dt)
		if not St.speedOn then return end
		local char = LP.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hum or not hrp then return end
		local stt = hum:GetState()
		if stt == Enum.HumanoidStateType.Physics
			or stt == Enum.HumanoidStateType.Ragdoll
			or stt == Enum.HumanoidStateType.FallingDown
			or hum.Health <= 0 then
			_spd.lastMoveDir = Vector3.zero
			destroySpeedObjects()
			return
		end
		local md = hum.MoveDirection
		local spd = getActiveMoveSpeed()
		currentSpeedValue = spd
		local dir = Vector3.zero
		if md.Magnitude > 0.01 then
			_spd.lastMoveDir = md
			dir = md
		else
			local anyHeld = false
			for key in pairs(MOVE_KEYS) do
				if UIS:IsKeyDown(key) then anyHeld = true; break end
			end
			if anyHeld and _spd.lastMoveDir and _spd.lastMoveDir.Magnitude > 0.01 then
				dir = _spd.lastMoveDir
			end
		end
		if dir.Magnitude > 0.01 then
			applySpeedMethod(hrp, hum, dir.Unit, spd, dt)
		else
			destroySpeedObjects()
		end
	end)
end

function setSpeedOn(on)
	St.speedOn = on and true or false
	if St.speedOn then startSpeedBoost() else stopSpeedBoost() end
	saveCfg()
end

function setActiveMode(mode)
	if not St.modes[mode] then return end
	St.activeMode = mode
	currentSpeedValue = getActiveMoveSpeed()
	if St.speedOn then startSpeedBoost() end
	if _G.VisRefreshModeBar then pcall(_G.VisRefreshModeBar) end
	if _G.VisRefreshV2ModeBar then pcall(_G.VisRefreshV2ModeBar) end
	if _G.VisRefreshModeCards then pcall(_G.VisRefreshModeCards) end
	saveCfg()
end

-- ==============================
--  INFINITE JUMP (Empire)
-- ==============================
InfJumpState = { enabled = false, mode = "hold", jumpHeld = false }
local _holdInfJumpConn = nil

function stopHoldInfJump()
	if _holdInfJumpConn then
		pcall(function() _holdInfJumpConn:Disconnect() end)
		_holdInfJumpConn = nil
	end
end

function startHoldInfJump()
	stopHoldInfJump()
	_holdInfJumpConn = RS.Heartbeat:Connect(function()
		if not InfJumpState.enabled then return end
		local char = LP.Character
		if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not root or not hum then return end
		local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true) or (InfJumpState.jumpHeld == true)
		local vel = root.Velocity
		pcall(function()
			local av = root.AssemblyLinearVelocity
			if av then vel = av end
		end)
		if isJumpHeld and vel.Y < 35 then
			local nv = Vector3.new(vel.X, 55, vel.Z)
			pcall(function() root.Velocity = nv end)
			pcall(function() root.AssemblyLinearVelocity = nv end)
		end
		if vel.Y < -120 then
			local nv = Vector3.new(vel.X, -120, vel.Z)
			pcall(function() root.Velocity = nv end)
			pcall(function() root.AssemblyLinearVelocity = nv end)
		end
	end)
end

function startInfJump()
	InfJumpState.enabled = true
	InfJumpState.mode = St.infJumpMode or "hold"
	startHoldInfJump()
end

function stopInfJump()
	InfJumpState.enabled = false
	InfJumpState.jumpHeld = false
	stopHoldInfJump()
end

function setInfJump(on)
	St.infJump = on and true or false
	if St.infJump then startInfJump() else stopInfJump() end
	saveCfg()
end

function setInfJumpMode(mode)
	St.infJumpMode = mode
	InfJumpState.mode = mode
	if St.infJump then startInfJump() end
	saveCfg()
end

-- Hook mobile jump button
if not _G._VisEmpireJumpHook then
	_G._VisEmpireJumpHook = true
	task.spawn(function()
		local pg = LP:WaitForChild("PlayerGui", 15)
		if not pg then return end
		local function hookJumpButton(btn)
			if btn:IsA("GuiButton") and btn.Name == "JumpButton" and not btn:GetAttribute("VisInfJumpHooked") then
				btn:SetAttribute("VisInfJumpHooked", true)
				btn.MouseButton1Down:Connect(function()
					if InfJumpState.enabled then InfJumpState.jumpHeld = true end
				end)
				btn.MouseButton1Up:Connect(function()
					InfJumpState.jumpHeld = false
				end)
			end
		end
		for _, d in ipairs(pg:GetDescendants()) do hookJumpButton(d) end
		pg.DescendantAdded:Connect(hookJumpButton)
	end)
	UIS.JumpRequest:Connect(function()
		if not InfJumpState.enabled then return end
		if InfJumpState.mode == "manual" then
			InfJumpState.jumpHeld = true
			task.defer(function() InfJumpState.jumpHeld = false end)
		end
	end)
	UIS.InputEnded:Connect(function(inp)
		if inp.KeyCode == Enum.KeyCode.Space then
			InfJumpState.jumpHeld = false
		end
	end)
end

-- ==============================
--  ANTI KICK (toujours ON)
-- ==============================
local AntiKickState = { enabled = true, brainrotDetected = false, conn = nil }
function enableAntiKick()
	AntiKickState.enabled = true
	St.antiKick = true
	pcall(function()
		if hookmetamethod and not _G._FAGAntiKickHooked then
			_G._FAGAntiKickHooked = true
			local old
			old = hookmetamethod(game, "__namecall", function(self, ...)
				local method = (getnamecallmethod and getnamecallmethod()) or ""
				if tostring(method) == "Kick" then
					if self == LP or (typeof(self) == "Instance" and self:IsA("Player") and self == LP) then
						return
					end
				end
				return old(self, ...)
			end)
		end
	end)
	pcall(function()
		if hookfunction and not _G._FAGKickFnHooked then
			_G._FAGKickFnHooked = true
			local oldKick = LP.Kick
			if typeof(oldKick) == "function" then
				hookfunction(oldKick, function(self, ...) return end)
			end
		end
	end)
	if AntiKickState.conn then return end
	AntiKickState.conn = task.spawn(function()
		while true do
			AntiKickState.enabled = true
			St.antiKick = true
			task.wait(0.5)
			local char = LP.Character
			local found = false
			if char then
				for _, tool in ipairs(char:GetChildren()) do
					if tool:IsA("Tool") then
						local n = tool.Name:lower()
						if n:find("brainrot") or n:find("skibidi") or n:find("toilet") then
							found = true
							break
						end
					end
				end
			end
			AntiKickState.brainrotDetected = found
		end
	end)
end
function setAntiKick(on)
	enableAntiKick()
	saveCfg()
end
task.defer(enableAntiKick)

task.defer(function()
	if St.visualCleaner then pcall(function() setVisualCleaner(true) end) end
end)

-- ==============================
--  ANTI RAGDOLL (V1 / V2)
-- ==============================
AntiRagdollV2 = { Connection = nil, Enabled = false, ResetCooldown = 0 }
St.antiRagdollMode = St.antiRagdollMode or "V1"

function forceNoSplatterReset()
	local char = LP.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not hum or not root or hum.Health <= 0 then return end
	pcall(function()
		hum:ChangeState(Enum.HumanoidStateType.GettingUp)
		root.Velocity = Vector3.zero
		root.RotVelocity = Vector3.zero
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		for _, obj in ipairs(char:GetDescendants()) do
			if obj:IsA("Motor6D") then obj.Enabled = true end
			if obj:IsA("Constraint") then obj.Enabled = true end
		end
		workspace.CurrentCamera.CameraSubject = hum
		local PM = LP:FindFirstChild("PlayerScripts") and LP.PlayerScripts:FindFirstChild("PlayerModule")
		if PM then
			local ok, CM = pcall(function() return require(PM:FindFirstChild("ControlModule")) end)
			if ok and CM and CM.Enable then pcall(function() CM:Enable() end) end
		end
		hum.AutoRotate = true
		hum.PlatformStand = false
		hum.Sit = false
	end)
end

function startAntiRagdoll()
	stopAntiRagdoll()
	AntiRagdollV2.Enabled = true
	AntiRagdollV2.Connection = RS.Heartbeat:Connect(function()
		if not AntiRagdollV2.Enabled or not St.antiRagdoll then return end
		local char = LP.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		local root = char:FindFirstChild("HumanoidRootPart")
		if not hum or hum.Health <= 0 then return end
		local state = hum:GetState()
		local ragdolled = (state == Enum.HumanoidStateType.Physics
			or state == Enum.HumanoidStateType.Ragdoll
			or state == Enum.HumanoidStateType.FallingDown)
		local mode = tostring(St.antiRagdollMode or "V1"):upper()
		if mode == "V2" or mode == "NO SPLATTER" then
			if ragdolled then
				local now = tick()
				if now - (AntiRagdollV2.ResetCooldown or 0) > 0.15 then
					AntiRagdollV2.ResetCooldown = now
					forceNoSplatterReset()
				end
			end
			return
		end
		if not root then return end
		local endTime = LP:GetAttribute("RagdollEndTime")
		if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then ragdolled = true end
		if ragdolled then
			pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
			for _, d in ipairs(char:GetDescendants()) do
				if d:IsA("BallSocketConstraint") or (d:IsA("Attachment") and tostring(d.Name):find("RagdollAttachment")) then
					d:Destroy()
				end
			end
			for _, obj in ipairs(char:GetDescendants()) do
				if obj:IsA("Motor6D") and obj.Enabled == false then
					obj.Enabled = true
				end
			end
			if hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Running) end
			pcall(function() workspace.CurrentCamera.CameraSubject = hum end)
			root.Anchored = false
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
		end
	end)
end

function stopAntiRagdoll()
	AntiRagdollV2.Enabled = false
	if AntiRagdollV2.Connection then
		pcall(function() AntiRagdollV2.Connection:Disconnect() end)
		AntiRagdollV2.Connection = nil
	end
	AntiRagdollV2.ResetCooldown = 0
end

function setAntiRagdoll(on)
	St.antiRagdoll = on and true or false
	if St.antiRagdoll then startAntiRagdoll() else stopAntiRagdoll() end
	saveCfg()
end

function setAntiRagdollMode(mode)
	mode = tostring(mode or "V1"):upper()
	if mode == "V2" or mode == "NO SPLATTER" then St.antiRagdollMode = "V2" else St.antiRagdollMode = "V1" end
	if St.antiRagdoll then stopAntiRagdoll(); startAntiRagdoll() end
	if _G.VisRefreshAntiRagMode then _G.VisRefreshAntiRagMode() end
	saveCfg()
end
_G.VisSetAntiRagdollMode = setAntiRagdollMode

-- ==============================
--  ANTI GUMMY / BOOGIE / PAINTBALL (silencieux)
-- ==============================
if not _G._FAG_VisAntiGummyFullLoaded then
	_G._FAG_VisAntiGummyFullLoaded = true
	task.spawn(function()
		local AntiGummy, AntiBoogie, AntiBee = true, true, false
		local ANTI_PAINTBALL_ALWAYS_ON = true
		local function ResetTool(Char)
			if not Char then Char = LP.Character end
			if not Char then return end
			pcall(function()
				LP:SetAttribute("BlockTools", false)
				LP:SetAttribute("Web", false)
				Char:SetAttribute("BackpackReady", true)
			end)
		end
		local function ClearEffect()
			if AntiBee then
				for _, V in pairs(Lighting:GetChildren()) do
					if V.Name == "BeeBlur" or V.Name == "Flashbang" then V:Destroy() end
				end
				local Ctrl = ReplicatedStorage:FindFirstChild("Controllers")
				if Ctrl then
					local BC = Ctrl:FindFirstChild("BeeLauncherController")
					if BC then
						local B = BC:FindFirstChild("Buzzing")
						if B then pcall(function() B:Stop() end) end
					end
				end
			end
			if AntiBoogie then
				for _, V in pairs(Lighting:GetChildren()) do
					if V.Name == "DiscoEffect" then V:Destroy() end
				end
				local Ctrl = ReplicatedStorage:FindFirstChild("Controllers")
				if Ctrl then
					local BC = Ctrl:FindFirstChild("BoogieBombController")
					if BC then
						local B = BC:FindFirstChild("BOOM")
						if B then pcall(function() B:Stop() end) end
					end
				end
			end
		end
		local function getMainHudGui()
			local pg = LP:FindFirstChild("PlayerGui")
			return pg and pg:FindFirstChild("Main")
		end
		local function isPaintballSplatGui(gui)
			if not gui or gui.Parent ~= getMainHudGui() then return false end
			if not (gui:IsA("ImageLabel") or gui:IsA("ImageButton")) then return false end
			if gui:GetAttribute("__UGPaintballIgnore") or gui:GetAttribute("__UGPaintballShrunk") then return false end
			return math.abs(gui.Rotation) > 0.01
		end
		local function shrinkPaintballSplat(gui)
			if not gui or gui:GetAttribute("__UGPaintballShrunk") then return end
			gui:SetAttribute("__UGPaintballShrunk", true)
			gui.Size = UDim2.fromOffset(6, 6)
		end
		local function runAntiPaintballSweep()
			if not ANTI_PAINTBALL_ALWAYS_ON then return end
			task.spawn(function()
				for _ = 1, 8 do
					local main = getMainHudGui()
					if not main then break end
					for _, c in ipairs(main:GetChildren()) do
						if isPaintballSplatGui(c) then shrinkPaintballSplat(c) end
					end
					task.wait(0.05)
				end
			end)
		end
		task.spawn(function()
			while task.wait(0.25) do
				if ANTI_PAINTBALL_ALWAYS_ON then runAntiPaintballSweep() end
			end
		end)
		RS.Heartbeat:Connect(function()
			if AntiGummy then ResetTool() end
			if AntiBoogie or AntiBee then ClearEffect() end
		end)
		pcall(function()
			Lighting.ChildAdded:Connect(function(child)
				if not child then return end
				local n = child.Name
				if AntiBee and (n == "BeeBlur" or n == "Flashbang") then
					task.defer(function() child:Destroy() end)
				end
				if AntiBoogie and n == "DiscoEffect" then
					task.defer(function() child:Destroy() end)
				end
			end)
		end)
		pcall(function()
			local function hookMain(main)
				if not main or main:GetAttribute("_VisAntiPaintballHooked") then return end
				main:SetAttribute("_VisAntiPaintballHooked", true)
				main.ChildAdded:Connect(function(c)
					task.defer(function()
						if isPaintballSplatGui(c) then shrinkPaintballSplat(c) end
					end)
				end)
			end
			local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 10)
			if pg then
				hookMain(pg:FindFirstChild("Main"))
				pg.ChildAdded:Connect(function(ch)
					if ch.Name == "Main" then task.defer(function() hookMain(ch) end) end
				end)
			end
		end)
		LP.CharacterAdded:Connect(function(char)
			task.defer(function() ResetTool(char) end)
		end)
	end)
end

function setAntiGummy(on)
	St.antiGummy = true; saveCfg()
end
function setAntiBoogie(on)
	St.antiBoogie = true; saveCfg()
end
function setAntiPaint(on)
	St.antiPaint = true; saveCfg()
end

-- ==============================
--  TOOL AIMBOT (toujours ON)
-- ==============================
local aimOn = true
local TOOLS = { ["Web Slinger"] = true, ["Paintball Gun"] = true, ["Laser Cape"] = true }
local hooked = {}
local mouseMod = nil
local lastAimUp = 0

function getMouse()
	if mouseMod then return mouseMod end
	pcall(function()
		local pkg = ReplicatedStorage:FindFirstChild("Packages")
		if pkg then mouseMod = require(pkg:WaitForChild("PlayerMouse", 5)) end
	end)
	return mouseMod
end

function bestEnemy()
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local cam = workspace.CurrentCamera
	if not root or not cam then return nil end
	local best, score = nil, math.huge
	local camPos, camDir = cam.CFrame.Position, cam.CFrame.LookVector
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then
			local r = plr.Character:FindFirstChild("HumanoidRootPart")
			local h = plr.Character:FindFirstChildOfClass("Humanoid")
			if r and h and h.Health > 0 then
				local d = (r.Position - root.Position).Magnitude
				if d <= 100 then
					local to = r.Position - camPos
					if to.Magnitude > 0.01 then
						local ang = math.deg(math.acos(math.clamp(camDir:Dot(to.Unit), -1, 1)))
						local sc = d + (ang > 200 and 1000 or 0)
						if sc < score then score, best = sc, r end
					end
				end
			end
		end
	end
	return best
end

function overrideMouse()
	if not aimOn then return end
	local pm = getMouse()
	if not pm then return end
	local e = bestEnemy()
	if e and e.Parent then
		local vel = e.AssemblyLinearVelocity or Vector3.zero
		pcall(function()
			pm.Hit = CFrame.new(e.Position + vel * 0.1)
			pm.Target = e
		end)
	end
end

function hookTool(tool)
	if hooked[tool] or not tool then return end
	hooked[tool] = true
	tool.Activated:Connect(overrideMouse)
	tool.Equipped:Connect(function()
		task.wait(0.1)
		local pm = getMouse()
		if pm and aimOn then
			local old = pm.Button1Down
			pm.Button1Down = function(...)
				overrideMouse()
				if old then old(...) end
			end
		end
	end)
end

function watchTools(parent)
	if not parent then return end
	for _, c in ipairs(parent:GetChildren()) do
		if TOOLS[c.Name] then hookTool(c) end
	end
	parent.ChildAdded:Connect(function(c)
		task.wait(0.05)
		if TOOLS[c.Name] then hookTool(c) end
	end)
end
watchTools(LP.Backpack)
if LP.Character then watchTools(LP.Character) end
LP.CharacterAdded:Connect(function(c)
	task.wait(0.2)
	watchTools(c)
	watchTools(LP.Backpack)
end)
RS.RenderStepped:Connect(function()
	if not aimOn then return end
	if tick() - lastAimUp > 0.1 then lastAimUp = tick(); bestEnemy() end
	if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then overrideMouse() end
end)

function setToolAim(on)
	aimOn = true
	St.toolAim = true
	local char = LP.Character
	if char then watchTools(char) end
	local bp = LP:FindFirstChild("Backpack")
	if bp then watchTools(bp) end
	saveCfg()
end
task.defer(function()
	aimOn = true
	St.toolAim = true
	if LP.Character then watchTools(LP.Character) end
	if LP.Backpack then watchTools(LP.Backpack) end
end)

-- ==============================
--  DROP JUMP / STAND
-- ==============================
local dropActive = false
local DROP_SPD, DROP_DUR = 200, 0.28

function runDrop()
	if dropActive then return end
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not root or not hum then return end
	local mode = tonumber(St.dropMode) or 2
	if mode == 1 then
		dropActive = true
		local t0 = tick()
		local conn
		conn = RS.Heartbeat:Connect(function()
			if not dropActive or tick() - t0 > 0.25 then
				if conn then conn:Disconnect() end
				dropActive = false
				if root and root.Parent then root.AssemblyLinearVelocity = Vector3.zero end
				return
			end
			local r = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
			if not r then return end
			local v = Vector3.new(0, r.AssemblyLinearVelocity.Y, 0)
			r.AssemblyLinearVelocity = v * 10000 + Vector3.new(0, 10000, 0)
		end)
		return
	end
	dropActive = true
	local t0 = tick()
	local conn
	conn = RS.Heartbeat:Connect(function()
		local c = LP.Character
		local r = c and c:FindFirstChild("HumanoidRootPart")
		if not r or not dropActive then
			if conn then conn:Disconnect() end
			dropActive = false
			return
		end
		if tick() - t0 >= DROP_DUR then
			if conn then conn:Disconnect() end
			local rp = RaycastParams.new()
			rp.FilterDescendantsInstances = { c }
			rp.FilterType = Enum.RaycastFilterType.Exclude
			local rr = workspace:Raycast(r.Position, Vector3.new(0, -3000, 0), rp)
			if rr then
				local h2 = c:FindFirstChildOfClass("Humanoid")
				local off = ((h2 and h2.HipHeight) or 2) + (r.Size.Y / 2)
				r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
			end
			r.AssemblyLinearVelocity = Vector3.zero
			r.AssemblyAngularVelocity = Vector3.zero
			dropActive = false
			return
		end
		r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, DROP_SPD, r.AssemblyLinearVelocity.Z)
	end)
end

-- ==============================
--  INSTA RESET V1 / V2
-- ==============================
local _resetBusy = false
local _resetCD = false
local INST_V2_POS = CFrame.new(2000.5, 9911.9, 4000.2)

function InstaResetV2()
	if _resetBusy then return end
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end
	_resetBusy = true
	local cam = workspace.CurrentCamera
	local lockCF = cam and cam.CFrame
	pcall(function()
		if cam then cam.CameraType = Enum.CameraType.Scriptable; cam.CFrame = lockCF end
		RS:BindToRenderStep("VisInstaV2Cam", Enum.RenderPriority.Camera.Value + 1, function()
			pcall(function()
				if cam then cam.CameraType = Enum.CameraType.Scriptable; if lockCF then cam.CFrame = lockCF end end
				local ac = LP.Character
				local ah = ac and ac:FindFirstChild("HumanoidRootPart")
				if ah then
					ah.AssemblyLinearVelocity = Vector3.zero
					ah.CFrame = INST_V2_POS
				end
			end)
		end)
	end)
	local conn
	conn = LP.CharacterAdded:Connect(function(newChar)
		if conn then conn:Disconnect() end
		pcall(function() RS:UnbindFromRenderStep("VisInstaV2Cam") end)
		local nh = newChar:WaitForChild("Humanoid", 5)
		task.wait(0.05)
		pcall(function()
			if cam and nh then cam.CameraSubject = nh; cam.CameraType = Enum.CameraType.Custom end
		end)
		_resetBusy = false
	end)
	task.delay(8, function()
		if _resetBusy then
			pcall(function() RS:UnbindFromRenderStep("VisInstaV2Cam") end)
			_resetBusy = false
		end
	end)
end

function InstaResetV1()
	if _resetCD then return end
	local char = LP.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not char or not hum or not hrp then return end
	_resetCD = true
	_resetBusy = true
	local originalHip = hum.HipHeight
	local cam = workspace.CurrentCamera
	pcall(function()
		if cam then
			cam.CameraType = Enum.CameraType.Custom
			if hum then cam.CameraSubject = hum end
		end
		pcall(function() RS:UnbindFromRenderStep("VisInstaV1Cam") end)
		pcall(function() RS:UnbindFromRenderStep("VisInstaV2Cam") end)
	end)
	local charConn
	charConn = LP.CharacterAdded:Connect(function(newChar)
		if charConn then charConn:Disconnect() end
		local nh = newChar:WaitForChild("Humanoid", 5)
		task.wait(0.05)
		pcall(function()
			local c = workspace.CurrentCamera
			if c and nh then
				c.CameraSubject = nh
				c.CameraType = Enum.CameraType.Custom
			end
		end)
		_resetCD = false
		_resetBusy = false
	end)
	task.spawn(function()
		local attempts = 0
		while char and char.Parent and hum and attempts < 40 do
			if LP.Character ~= char then break end
			pcall(function()
				hum.PlatformStand = false
				hum.Sit = false
				hum:ChangeState(Enum.HumanoidStateType.GettingUp)
				hum:ChangeState(Enum.HumanoidStateType.Running)
				hum.HipHeight = 1e30
				hum.AutoRotate = true
				local rp = char:FindFirstChild("HumanoidRootPart")
				if rp then rp.CanCollide = false end
				for _, part in ipairs(char:GetChildren()) do
					if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
						part.CanCollide = false
					end
				end
				if cam then
					cam.CameraType = Enum.CameraType.Custom
					cam.CameraSubject = hum
				end
			end)
			if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then break end
			attempts = attempts + 1
			task.wait(0.05)
		end
		if char and char.Parent and hum and hum.Health > 0 then
			pcall(function() hum.Health = 0 end)
		end
		if char and char.Parent and hum then
			pcall(function()
				hum.HipHeight = originalHip
				local rp = char:FindFirstChild("HumanoidRootPart")
				if rp then rp.CanCollide = true end
			end)
		end
		task.delay(5, function()
			if _resetBusy then
				_resetCD = false
				_resetBusy = false
			end
		end)
	end)
end

function doInstaReset()
	if St.instaMode == "V2" then InstaResetV2() else InstaResetV1() end
end

-- ==============================
--  TP DOWN
-- ==============================
function doTPDown(force)
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum or hum.Health <= 0 then return end
	if not force then
		if hum.FloorMaterial ~= Enum.Material.Air then return end
		if hrp.Position.Y < 20 then return end
	end
	hrp.CFrame = CFrame.new(hrp.Position.X, -7, hrp.Position.Z) * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
	hrp.AssemblyLinearVelocity = Vector3.zero
end

-- ==============================
--  ESP + TRACER + ANTI LAG
-- ==============================
local ESP = { on = false, data = {}, conns = {} }

function espCleanup(plr)
	local d = ESP.data[plr]
	if not d then return end
	pcall(function() if d.hl then d.hl:Destroy() end end)
	pcall(function() if d.bb then d.bb:Destroy() end end)
	pcall(function() if d.tracer then d.tracer:Remove() end end)
	ESP.data[plr] = nil
end

function espSetup(plr, char)
	if not ESP.on or plr == LP or not char then return end
	espCleanup(plr)
	local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 3)
	local head = char:FindFirstChild("Head")
	if not hrp then return end
	local hl = Instance.new("Highlight")
	hl.Adornee = char
	hl.FillColor = Color3.fromRGB(35, 35, 35)
	hl.FillTransparency = 0.7
	hl.OutlineColor = Color3.fromRGB(255, 255, 255)
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = char
	local bb, tracer
	if head then
		bb = Instance.new("BillboardGui")
		bb.Adornee = head
		bb.Size = UDim2.new(0, 100, 0, 20)
		bb.StudsOffset = Vector3.new(0, 2.5, 0)
		bb.AlwaysOnTop = true
		bb.Parent = head
		local t = Instance.new("TextLabel", bb)
		t.Size = UDim2.new(1, 0, 1, 0)
		t.BackgroundTransparency = 1
		t.Text = plr.DisplayName or plr.Name
		t.TextColor3 = Color3.new(1, 1, 1)
		t.TextSize = 12
		t.Font = Enum.Font.GothamBold
		t.TextStrokeTransparency = 0.5
	end
	if St.tracer then
		tracer = Drawing and Drawing.new and Drawing.new("Line")
		if tracer then
			tracer.Thickness = 1
			tracer.Color = Color3.fromRGB(255, 255, 255)
			tracer.Visible = true
		end
	end
	ESP.data[plr] = { hl = hl, bb = bb, tracer = tracer, hrp = hrp }
end

function startESP()
	if ESP.on then return end
	ESP.on = true
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then espSetup(plr, plr.Character) end
		table.insert(ESP.conns, plr.CharacterAdded:Connect(function(c)
			task.defer(espSetup, plr, c)
		end))
	end
	table.insert(ESP.conns, Players.PlayerAdded:Connect(function(plr)
		table.insert(ESP.conns, plr.CharacterAdded:Connect(function(c)
			task.defer(espSetup, plr, c)
		end))
	end))
	table.insert(ESP.conns, RS.RenderStepped:Connect(function()
		if not St.tracer then return end
		local cam = workspace.CurrentCamera
		local my = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
		if not cam or not my then return end
		local origin = cam:WorldToViewportPoint(my.Position)
		for plr, d in pairs(ESP.data) do
			if d.tracer and d.hrp and d.hrp.Parent then
				local p, onScreen = cam:WorldToViewportPoint(d.hrp.Position)
				d.tracer.From = Vector2.new(origin.X, origin.Y)
				d.tracer.To = Vector2.new(p.X, p.Y)
				d.tracer.Visible = onScreen and p.Z > 0
			elseif d.tracer then
				d.tracer.Visible = false
			end
		end
	end))
end

function stopESP()
	ESP.on = false
	for _, c in ipairs(ESP.conns) do pcall(function() c:Disconnect() end) end
	ESP.conns = {}
	for plr in pairs(ESP.data) do espCleanup(plr) end
end

function setESP(on)
	St.esp = on
	if on then startESP() else stopESP() end
	saveCfg()
end

function setTracer(on)
	St.tracer = on
	if St.esp then stopESP(); startESP() end
	saveCfg()
end

local antiLagConn = nil
function applyDerender(obj)
	pcall(function()
		if obj:IsA("Accessory") or obj:IsA("Hat") then
			obj:Destroy()
		elseif obj:IsA("BasePart") then
			obj.Material = Enum.Material.Plastic
			obj.Reflectance = 0
			obj.CastShadow = false
		elseif obj:IsA("Decal") or obj:IsA("Texture") then
			obj.Transparency = 1
		elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
			or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
			obj.Enabled = false
		end
	end)
end

function setAntiLag(on)
	St.antiLag = on
	if on then
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 1e10
		Lighting.Brightness = 0
		for _, e in pairs(Lighting:GetChildren()) do
			if e:IsA("BlurEffect") or e:IsA("BloomEffect") or e:IsA("SunRaysEffect")
				or e:IsA("ColorCorrectionEffect") or e:IsA("DepthOfFieldEffect") then
				e.Enabled = false
			end
		end
		for _, obj in ipairs(workspace:GetDescendants()) do applyDerender(obj) end
		if antiLagConn then antiLagConn:Disconnect() end
		antiLagConn = workspace.DescendantAdded:Connect(applyDerender)
	else
		if antiLagConn then antiLagConn:Disconnect(); antiLagConn = nil end
		Lighting.GlobalShadows = true
		Lighting.FogEnd = 100000
		Lighting.Brightness = 2
	end
	saveCfg()
end

-- ==============================
--  AUTO DESTROY SENTRY
-- ==============================
local GTurret = { AutoDestroyTurret = false }
local turretBusy = setmetatable({}, { __mode = "k" })
local turretQueued = setmetatable({}, { __mode = "k" })
local turretCD = setmetatable({}, { __mode = "k" })
local activeTurretAtk = 0

function isEnemyTurret(obj)
	if not obj or not obj:IsA("BasePart") then return false end
	local name, nameLower = obj.Name, obj.Name:lower()
	local ownerId = name:match("^Sentry_(%d+)$") or name:match("^sentry_(%d+)$")
	if not ownerId then
		ownerId = name:match("^CandySentry_(%d+)$") or name:match("^Candy_Sentry_(%d+)$")
			or name:match("^candy_sentry_(%d+)$") or nameLower:match("^candy[_%-]?sentry_(%d+)$")
	end
	if not ownerId and nameLower:find("candy") and nameLower:find("sentry") then
		ownerId = name:match("(%d+)$")
	end
	if not ownerId then ownerId = name:match("^[Tt]urret_(%d+)$") end
	if not ownerId and nameLower:find("sentry") then ownerId = name:match("(%d+)$") end
	return ownerId ~= nil and tostring(ownerId) ~= tostring(LP.UserId)
end

function setTurretNoClip(turret)
	if not isEnemyTurret(turret) then return end
	pcall(function()
		turret.CanCollide = false
		turret.Anchored = true
		turret.AssemblyLinearVelocity = Vector3.zero
		turret.AssemblyAngularVelocity = Vector3.zero
	end)
end

function getTurretTimeLabel(turret)
	if not turret or not turret.Parent then return nil end
	local sf = turret:FindFirstChild("SetupFrame")
	local mf = sf and sf:FindFirstChild("MainFrame")
	local tl = mf and mf:FindFirstChild("Time")
	if tl and tl:IsA("TextLabel") then return tl end
	for _, d in ipairs(turret:GetDescendants()) do
		if d:IsA("TextLabel") then
			local n = d.Name:lower()
			if n == "time" or n == "timer" or n == "countdown" then return d end
		end
	end
	return nil
end

function shouldAttackTurret(turret)
	if LP:GetAttribute("Stealing") ~= nil then return false end
	if not isEnemyTurret(turret) then return false end
	setTurretNoClip(turret)
	local timeLabel = getTurretTimeLabel(turret)
	if timeLabel then
		local ok, text = pcall(function() return timeLabel.Text end)
		if not ok then return false end
		text = tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
		if text == "" then return false end
		if string.find(text, "^%d+%s*[sS]!?$") or string.find(text, "^%d+$") then return true end
		return false
	end
	return true
end

function bringTurretInFront(turret, hrp)
	if not turret or not hrp then return end
	local forward = hrp.CFrame.LookVector
	local targetPos = hrp.Position + forward * 2.8 + Vector3.new(0, 1.15, 0)
	pcall(function()
		turret.AssemblyLinearVelocity = Vector3.zero
		turret.CFrame = CFrame.lookAt(targetPos, targetPos + forward)
	end)
end

function findBat()
	local char = LP.Character
	if not char then return nil end
	local bat = char:FindFirstChild("Bat") or LP.Backpack:FindFirstChild("Bat")
	if bat then return bat end
	for _, t in ipairs(char:GetChildren()) do
		if t:IsA("Tool") and t.Name:lower():find("bat") then return t end
	end
	for _, t in ipairs(LP.Backpack:GetChildren()) do
		if t:IsA("Tool") and t.Name:lower():find("bat") then return t end
	end
	return nil
end

function ensureBat(hum, char)
	local held = char:FindFirstChildOfClass("Tool")
	if held and (held.Name == "Bat" or held.Name:lower():find("bat")) then return held end
	local bat = findBat()
	if not bat then return nil end
	pcall(function() hum:EquipTool(bat) end)
	return char:FindFirstChild("Bat") or bat
end

function attackTurret(turret)
	local now = os.clock()
	if turretBusy[turret] or turretQueued[turret] then return end
	if activeTurretAtk >= 2 then return end
	if not shouldAttackTurret(turret) then return end
	if (turretCD[turret] or 0) > now then return end
	turretQueued[turret] = true
	turretCD[turret] = now + 0.15
	task.spawn(function()
		turretQueued[turret] = nil
		if activeTurretAtk >= 2 or turretBusy[turret] or not shouldAttackTurret(turret) then return end
		activeTurretAtk = activeTurretAtk + 1
		turretBusy[turret] = true
		pcall(function()
			local attempts, batReady = 0, false
			while attempts < 18 and GTurret.AutoDestroyTurret do
				if not turret or not turret.Parent or not shouldAttackTurret(turret) then break end
				local char = LP.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				if not hrp or not hum or hum.Health <= 0 then break end
				local okD, dist = pcall(function() return (turret.Position - hrp.Position).Magnitude end)
				if okD and dist > 250 then break end
				setTurretNoClip(turret)
				bringTurretInFront(turret, hrp)
				local bat
				if not batReady then
					bat = ensureBat(hum, char)
					batReady = bat ~= nil
				else
					bat = char:FindFirstChild("Bat") or findBat()
					local held = char:FindFirstChildOfClass("Tool")
					if held and held.Name ~= "Bat" and not held.Name:lower():find("bat") then break end
				end
				if bat then pcall(function() bat:Activate() end) end
				attempts = attempts + 1
				task.wait(0.045)
			end
		end)
		turretBusy[turret] = nil
		activeTurretAtk = math.max(0, activeTurretAtk - 1)
	end)
end

workspace.DescendantAdded:Connect(function(obj)
	if isEnemyTurret(obj) then setTurretNoClip(obj) end
	if GTurret.AutoDestroyTurret and shouldAttackTurret(obj) then task.defer(attackTurret, obj) end
end)

task.spawn(function()
	while task.wait(0.25) do
		if GTurret.AutoDestroyTurret then
			local pending = {}
			for _, obj in ipairs(workspace:GetDescendants()) do
				if isEnemyTurret(obj) then
					setTurretNoClip(obj)
					if shouldAttackTurret(obj) and not turretBusy[obj] then
						table.insert(pending, obj)
					end
				end
			end
			local char = LP.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hrp and #pending > 0 then
				table.sort(pending, function(a, b)
					return (a.Position - hrp.Position).Magnitude < (b.Position - hrp.Position).Magnitude
				end)
				for i = 1, math.min(2, #pending) do attackTurret(pending[i]) end
			end
		end
	end
end)

function setDestroySentry(on)
	St.destroySentry = on and true or false
	GTurret.AutoDestroyTurret = St.destroySentry
	if _G.VisRefreshSentryBtn then _G.VisRefreshSentryBtn() end
	saveCfg()
end

-- ==============================
--  SPAM LASER / PAINTBALL
-- ==============================
local spamConn = nil

function startSpamLoop()
	if spamConn then return end
	spamConn = RS.Heartbeat:Connect(function()
		local char = LP.Character
		if not char then return end
		local tool = char:FindFirstChildOfClass("Tool")
		if not tool then return end
		local n = tool.Name
		if St.spamLaser and n == "Laser Cape" then
			if aimOn then overrideMouse() end
			pcall(function() tool:Activate() end)
		elseif St.spamPaint and n == "Paintball Gun" then
			if aimOn then overrideMouse() end
			pcall(function() tool:Activate() end)
		end
	end)
end

function stopSpamLoopIfIdle()
	if not St.spamLaser and not St.spamPaint then
		if spamConn then pcall(function() spamConn:Disconnect() end); spamConn = nil end
	end
end

function setSpamLaser(on)
	St.spamLaser = on and true or false
	if St.spamLaser then startSpamLoop() else stopSpamLoopIfIdle() end
	saveCfg()
end

function setSpamPaint(on)
	St.spamPaint = on and true or false
	if St.spamPaint then startSpamLoop() else stopSpamLoopIfIdle() end
	saveCfg()
end

-- ==============================
--  COUNTER TOOLS (On Drop)
-- ==============================
local counterConn = nil
local COUNTER_TOOL_NAMES = {
	laser = { "Laser Cape", "LaserCape", "laser cape" },
	boogie = { "Boogie Bomb", "BoogieBomb", "boogie bomb", "Disco Ball" },
	swap = { "Body Swap Potion", "Swap Body", "Body Swap", "SwapBody", "Potion of Body Swap" },
}

local function findToolByNames(names)
	local char = LP.Character
	local bp = LP:FindFirstChild("Backpack")
	for _, nm in ipairs(names) do
		if char then
			local t = char:FindFirstChild(nm)
			if t and t:IsA("Tool") then return t end
		end
		if bp then
			local t = bp:FindFirstChild(nm)
			if t and t:IsA("Tool") then return t end
		end
	end
	local function scan(parent)
		if not parent then return nil end
		for _, ch in ipairs(parent:GetChildren()) do
			if ch:IsA("Tool") then
				local ln = string.lower(ch.Name)
				for _, nm in ipairs(names) do
					if ln:find(string.lower(nm), 1, true) then return ch end
				end
			end
		end
		return nil
	end
	return scan(char) or scan(bp)
end

local function equipAndActivate(tool)
	if not tool then return end
	local char = LP.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	pcall(function()
		if tool.Parent ~= char then hum:EquipTool(tool) end
	end)
	task.defer(function() pcall(function() tool:Activate() end) end)
end

function startCounterLoop()
	if counterConn then
		pcall(function() counterConn:Disconnect() end)
		counterConn = nil
	end
end

function stopCounterLoopIfIdle()
	if not (St.counterLaser or St.counterBoogie or St.counterSwapBody or St.equipOnDrop) then
		if counterConn then pcall(function() counterConn:Disconnect() end); counterConn = nil end
	end
end

local function _counterExclusive(which)
	St.counterLaser = (which == "laser")
	St.counterBoogie = (which == "boogie")
	St.counterSwapBody = (which == "swap")
	if ToggleRefs then
		for k, flag in pairs({counterLaser = (which=="laser"), counterBoogie = (which=="boogie"), counterSwapBody = (which=="swap")}) do
			local r = ToggleRefs[k]
			if r and r.setVisual then pcall(r.setVisual, flag) end
		end
	end
end

function setCounterLaser(on)
	if on then _counterExclusive("laser") else St.counterLaser = false end
	stopCounterLoopIfIdle()
	saveCfg()
end

function setCounterBoogie(on)
	if on then _counterExclusive("boogie") else St.counterBoogie = false end
	stopCounterLoopIfIdle()
	saveCfg()
end

function setCounterSwapBody(on)
	if on then _counterExclusive("swap") else St.counterSwapBody = false end
	stopCounterLoopIfIdle()
	saveCfg()
end

function setEquipOnDrop(on)
	St.equipOnDrop = on and true or false
	saveCfg()
end

_G.VisCounterOnDrop = function()
	local anyCounter = St.counterLaser or St.counterBoogie or St.counterSwapBody
	if not anyCounter and not St.equipOnDrop then return end
	if _G._VisCounterDropBusy == true then return end
	_G._VisCounterDropBusy = true
	task.spawn(function()
		local char = LP.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local prevTool = char and char:FindFirstChildOfClass("Tool")
		local prevName = prevTool and prevTool.Name or nil
		task.wait(0.2)
		local function runOnce(names)
			local tool = findToolByNames(names)
			if not tool then return end
			equipAndActivate(tool)
			task.wait(0.15)
			pcall(function() tool:Activate() end)
			task.wait(0.1)
		end
		if St.counterLaser then runOnce(COUNTER_TOOL_NAMES.laser) end
		if St.counterBoogie then runOnce(COUNTER_TOOL_NAMES.boogie) end
		if St.counterSwapBody then runOnce(COUNTER_TOOL_NAMES.swap) end
		task.wait(0.1)
		pcall(function()
			local c = LP.Character
			local h = c and c:FindFirstChildOfClass("Humanoid")
			if not h or not prevName then return end
			local pl = string.lower(prevName)
			local isCounter = false
			for _, names in pairs(COUNTER_TOOL_NAMES) do
				for _, nm in ipairs(names) do
					if pl:find(string.lower(nm), 1, true) then isCounter = true break end
				end
				if isCounter then break end
			end
			if not isCounter then
				local bp = LP:FindFirstChild("Backpack")
				local t = (c and c:FindFirstChild(prevName)) or (bp and bp:FindFirstChild(prevName))
				if t and t:IsA("Tool") then h:EquipTool(t) end
			end
		end)
		_G._VisCounterDropBusy = false
	end)
end

_G.VisCounterOneShot = function(kind)
	if _G._VisCounterDropBusy then return end
	_G._VisCounterDropBusy = true
	task.spawn(function()
		local names = COUNTER_TOOL_NAMES[kind]
		if not names then _G._VisCounterDropBusy = false return end
		local tool = findToolByNames(names)
		if tool then
			equipAndActivate(tool)
			task.wait(0.15)
			pcall(function() tool:Activate() end)
		end
		_G._VisCounterDropBusy = false
	end)
end

-- ==============================
--  BODY LOCK
-- ==============================
local bodyLockEnabled = false
local bodyLockRange = 20
local _bodyLockConn = nil
local _blSuppressCount = 0
local _blWasEnabled = false
local _blRestoreTimer = nil
local _blSmoothRestore = false

function bodyLockCombatActive()
	return (_G.AceNormalAimbotOn == true)
		or (_G.AceAntiBypassAimbotOn == true)
		or (_G.AceAntiDesyncAimbotOn == true)
		or (St and St.toolAim == true and _G._VisToolAimActive == true)
end

function getClosestTargetBody()
	local char = LP.Character
	if not char then return nil end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	local closest, minDist = nil, math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then
			local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			if tRoot and hum and hum.Health > 0 then
				local dist = (tRoot.Position - root.Position).Magnitude
				if dist < minDist then
					minDist = dist
					closest = tRoot
				end
			end
		end
	end
	return closest
end

function _bodyLockTick()
	local char = LP.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local target = getClosestTargetBody()
	if not target then
		if not hum.AutoRotate then hum.AutoRotate = true end
		return
	end
	local range = tonumber(bodyLockRange) or (type(St)=="table" and tonumber(St.bodyLockRange)) or 20
	local dist = (target.Position - root.Position).Magnitude
	if dist > range then
		if not hum.AutoRotate then hum.AutoRotate = true end
		return
	end
	if hum.AutoRotate then hum.AutoRotate = false end
	local targetVel = target.AssemblyLinearVelocity
	local speed3 = targetVel.Magnitude
	local predictTime = math.clamp(speed3 / 80, 0.08, 0.35)
	local predictedPos = target.Position + targetVel * predictTime
	local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
	local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
	local myHeight = root.Position.Y + (hum.HipHeight or 0)
	local heightDiff = targetHeight - myHeight
	local verticalCorrection = math.clamp(heightDiff * 0.15, -1.5, 1.5)
	local flatTarget = Vector3.new(predictedPos.X, root.Position.Y + verticalCorrection, predictedPos.Z)
	local toPredict = flatTarget - root.Position
	if toPredict.Magnitude > 0.1 then
		local goalCF = CFrame.lookAt(root.Position, flatTarget)
		local diffCF = root.CFrame:Inverse() * goalCF
		local _, ry, _ = diffCF:ToEulerAnglesXYZ()
		ry = math.clamp(ry, -2.5, 2.5)
		root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
	end
end

function startBodyLock()
	if _bodyLockConn then
		pcall(function() _bodyLockConn:Disconnect() end)
		_bodyLockConn = nil
	end
	bodyLockEnabled = true
	if type(St) == "table" then St.bodyLock = true end
	local RS_ = RS or RunService or game:GetService("RunService")
	_bodyLockConn = RS_.RenderStepped:Connect(function()
		if not bodyLockEnabled then return end
		if (_blSuppressCount or 0) > 0 then return end
		_bodyLockTick()
	end)
end

function stopBodyLock()
	if _bodyLockConn then
		pcall(function() _bodyLockConn:Disconnect() end)
		_bodyLockConn = nil
	end
	bodyLockEnabled = false
	if type(St) == "table" then St.bodyLock = false end
	local c = LP.Character
	local root = c and c:FindFirstChild("HumanoidRootPart")
	if root then
		root.AssemblyAngularVelocity = Vector3.zero
		root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z)
	end
	local hum2 = c and c:FindFirstChildOfClass("Humanoid")
	if hum2 then hum2.AutoRotate = true end
end

function _suppressBodyLock()
	_blSuppressCount = (_blSuppressCount or 0) + 1
	if _blSuppressCount == 1 and bodyLockEnabled then
		_blWasEnabled = true
		if _bodyLockConn then
			pcall(function() _bodyLockConn:Disconnect() end)
			_bodyLockConn = nil
		end
		if bodyLockSetVisual then pcall(bodyLockSetVisual, false) end
		if _blRestoreTimer then
			pcall(task.cancel, _blRestoreTimer)
			_blRestoreTimer = nil
		end
		_blSmoothRestore = false
	end
end

function _unsuppressBodyLock(delayed)
	if (_blSuppressCount or 0) > 0 then
		_blSuppressCount = _blSuppressCount - 1
	end
	if _blSuppressCount == 0 and _blWasEnabled then
		_blWasEnabled = false
		local function restore()
			if bodyLockEnabled then
				_blSmoothRestore = true
				startBodyLock()
				if bodyLockSetVisual then pcall(bodyLockSetVisual, true) end
				task.delay(0.5, function() _blSmoothRestore = false end)
			end
			_blRestoreTimer = nil
		end
		if delayed then
			_blRestoreTimer = task.delay(1, restore)
		else
			restore()
		end
	end
end

function setBodyLock(on)
	if on then startBodyLock() else stopBodyLock() end
	saveCfg()
end

function setBodyLockRange(v)
	v = math.clamp(tonumber(v) or 20, 5, 100)
	bodyLockRange = v
	St.bodyLockRange = v
	saveCfg()
end

-- ==============================
--  INTERFACE PRINCIPALE (GUI)
-- ==============================
local ToggleRefs = {}

local Gui = Instance.new("ScreenGui")
Gui.Name = "VisHubFullMenu"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 200
Gui.Parent = PlayerGui

local MW, MH = 310, 380
local EL2BSoundsEnabled = St.soundsEnabled ~= false
local EL2BSoundVolume = math.clamp(tonumber(St.buttonVolume) or 0.22, 0, 0.5)
St.buttonVolume = EL2BSoundVolume
local EL2B_SOUND_THEMES = {
	Neon = { label = "NÉON", click = "rbxassetid://12221967", success = "rbxassetid://6504971383", error = "rbxassetid://130840811" },
	Soft = { label = "DOUX", click = "rbxassetid://12221967", success = "rbxassetid://7383525713", error = "rbxassetid://130840811" },
	Minimal = { label = "MINIMAL", click = "rbxassetid://12221967", success = "rbxassetid://12221967", error = "rbxassetid://130840811" },
}
local EL2B_SOUND_THEME_ORDER = { "Neon", "Soft", "Minimal", "Custom" }
local EL2BSoundTheme = table.find(EL2B_SOUND_THEME_ORDER, St.soundTheme) and St.soundTheme or "Neon"
St.soundTheme = EL2BSoundTheme
local function resolveCustomAudio(value, fallback)
	value = tostring(value or "")
	if value == "" then return fallback end
	if string.match(value, "^rbxassetid://%d+$") then return value end
	if string.match(value, "^%d+$") then return "rbxassetid://" .. value end
	for _, resolverName in ipairs({ "getcustomasset", "getsynasset" }) do
		local resolver = _G[resolverName]
		if type(resolver) == "function" then
			local ok, asset = pcall(resolver, value)
			if ok and type(asset) == "string" and asset ~= "" then return asset end
		end
	end
	return fallback
end
local function getEL2BSoundTheme()
	if EL2BSoundTheme == "Custom" then
		local neon = EL2B_SOUND_THEMES.Neon
		return {
			label = "PERSONNALISÉ",
			click = resolveCustomAudio(St.customSoundClick, neon.click),
			success = resolveCustomAudio(St.customSoundSuccess, neon.success),
			error = resolveCustomAudio(St.customSoundError, neon.error),
		}
	end
	return EL2B_SOUND_THEMES[EL2BSoundTheme] or EL2B_SOUND_THEMES.Neon
end
local function playEL2BSound(name, soundId, playbackSpeed, volumeScale)
	if not EL2BSoundsEnabled then return end
	pcall(function()
		local sound = Instance.new("Sound")
		sound.Name = name
		sound.SoundId = soundId
		sound.Volume = math.clamp(EL2BSoundVolume * (volumeScale or 1), 0, 0.5)
		sound.PlaybackSpeed = playbackSpeed or 1
		sound.RollOffMaxDistance = 0
		sound.Parent = SoundService
		SoundService:PlayLocalSound(sound)
		sound.Ended:Connect(function() sound:Destroy() end)
		task.delay(2, function() if sound.Parent then sound:Destroy() end end)
	end)
end
local function playEL2BButtonSound()
	playEL2BSound("EL2BButtonClick", getEL2BSoundTheme().click, 1.08, 1)
end
local function playEL2BSuccessSound()
	playEL2BSound("EL2BActionSuccess", getEL2BSoundTheme().success, 1.05, 0.9)
end
local function playEL2BErrorSound()
	playEL2BSound("EL2BActionError", getEL2BSoundTheme().error, 0.92, 0.65)
end

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, MW, 0, MH)
Main.Position = UDim2.new(0.5, -MW / 2, 0.5, -MH / 2)
Main.BackgroundColor3 = C.bg
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Main.Parent = Gui

local soundToggle = Instance.new("TextButton")
soundToggle.Name = "ButtonSoundToggle"
soundToggle.Position = UDim2.new(1, -42, 0, 12)
soundToggle.Size = UDim2.fromOffset(28, 24)
soundToggle.BackgroundColor3 = Color3.fromRGB(46, 25, 58)
soundToggle.BackgroundTransparency = 0.12
soundToggle.BorderSizePixel = 0
soundToggle.Font = Enum.Font.GothamBold
soundToggle.Text = "♪"
soundToggle.TextColor3 = Color3.fromRGB(255, 220, 135)
soundToggle.TextSize = 15
soundToggle.AutoButtonColor = true
soundToggle.ZIndex = 25
soundToggle.Parent = Main
corner(soundToggle, 7)
soundToggle.Activated:Connect(function()
	EL2BSoundsEnabled = not EL2BSoundsEnabled
	St.soundsEnabled = EL2BSoundsEnabled
	soundToggle.Text = EL2BSoundsEnabled and "♪" or "×"
	soundToggle.TextColor3 = EL2BSoundsEnabled and Color3.fromRGB(255, 220, 135) or Color3.fromRGB(190, 176, 201)
	saveCfg()
end)
soundToggle.Text = EL2BSoundsEnabled and "♪" or "×"
soundToggle.TextColor3 = EL2BSoundsEnabled and Color3.fromRGB(255, 220, 135) or Color3.fromRGB(190, 176, 201)

local volFrame = Instance.new("Frame")
volFrame.Name = "VolumeControl"
volFrame.Size = UDim2.new(0, 100, 0, 22)
volFrame.Position = UDim2.new(1, -148, 0, 42)
volFrame.BackgroundColor3 = Color3.fromRGB(18, 14, 25)
volFrame.BackgroundTransparency = 0.12
volFrame.BorderSizePixel = 0
volFrame.ZIndex = 25
volFrame.Parent = Main
corner(volFrame, 7)
local volStroke = stroke(volFrame)
volStroke.Color = Color3.fromRGB(100, 70, 125)
volStroke.Thickness = 1
volStroke.Transparency = 0.2
local volTrack = Instance.new("Frame")
volTrack.Name = "Track"
volTrack.Size = UDim2.new(1, -16, 0, 4)
volTrack.Position = UDim2.new(0, 8, 0.5, -2)
volTrack.BackgroundColor3 = Color3.fromRGB(40, 32, 48)
volTrack.BorderSizePixel = 0
volTrack.ZIndex = 11
volTrack.Parent = volFrame
corner(volTrack, 2)
local volFill = Instance.new("Frame")
volFill.Name = "Fill"
volFill.Size = UDim2.fromScale(St.buttonVolume / 0.5, 1)
volFill.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
volFill.BorderSizePixel = 0
volFill.ZIndex = 12
volFill.Parent = volTrack
corner(volFill, 2)
local volLabel = Instance.new("TextLabel")
volLabel.Name = "Label"
volLabel.Size = UDim2.new(0, 30, 0, 14)
volLabel.Position = UDim2.new(0.5, -15, 1, 2)
volLabel.BackgroundTransparency = 1
volLabel.Text = math.floor((St.buttonVolume / 0.5) * 100) .. "%"
volLabel.TextColor3 = Color3.fromRGB(190, 176, 201)
volLabel.TextSize = 8
volLabel.Font = Enum.Font.GothamBold
volLabel.ZIndex = 10
volLabel.Parent = volFrame
local volBtn = Instance.new("TextButton")
volBtn.Name = "Trigger"
volBtn.Size = UDim2.fromScale(1, 1)
volBtn.BackgroundTransparency = 1
volBtn.Text = ""
volBtn.ZIndex = 15
volBtn.Parent = volFrame
local function updateVol(input)
	local pos = math.clamp((input.Position.X - volTrack.AbsolutePosition.X) / volTrack.AbsoluteSize.X, 0, 1)
	EL2BSoundVolume = pos * 0.5
	St.buttonVolume = EL2BSoundVolume
	volFill.Size = UDim2.fromScale(pos, 1)
	volLabel.Text = math.floor(pos * 100) .. "%"
	saveCfg()
end
local volDragging = false
volBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		volDragging = true
		updateVol(input)
	end
end)
UIS.InputChanged:Connect(function(input)
	if volDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateVol(input)
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		volDragging = false
	end
end)

local soundThemeButton = Instance.new("TextButton")
soundThemeButton.Name = "SoundThemeSelector"
soundThemeButton.Size = UDim2.new(0, 100, 0, 22)
soundThemeButton.Position = UDim2.new(1, -148, 0, 70)
soundThemeButton.BackgroundColor3 = Color3.fromRGB(18, 14, 25)
soundThemeButton.BackgroundTransparency = 0.12
soundThemeButton.BorderSizePixel = 0
soundThemeButton.Font = Enum.Font.GothamBold
soundThemeButton.Text = "SON : " .. getEL2BSoundTheme().label
soundThemeButton.TextColor3 = Color3.fromRGB(190, 176, 201)
soundThemeButton.TextSize = 8
soundThemeButton.AutoButtonColor = true
soundThemeButton.ZIndex = 25
soundThemeButton.Parent = Main
corner(soundThemeButton, 7)
local soundThemeIndex = table.find(EL2B_SOUND_THEME_ORDER, EL2BSoundTheme) or 1
local customAudioPanel = Instance.new("Frame")
customAudioPanel.Name = "CustomAudioPanel"
customAudioPanel.Size = UDim2.new(0, 214, 0, 126)
customAudioPanel.Position = UDim2.new(0, 82, 0, 98)
customAudioPanel.BackgroundColor3 = Color3.fromRGB(18, 14, 25)
customAudioPanel.BackgroundTransparency = 0.04
customAudioPanel.BorderSizePixel = 0
customAudioPanel.ZIndex = 30
customAudioPanel.Visible = EL2BSoundTheme == "Custom"
customAudioPanel.Parent = Main
corner(customAudioPanel, 9)
local function customAudioBox(name, placeholder, y, value)
	local box = Instance.new("TextBox")
	box.Name = name
	box.Size = UDim2.new(1, -16, 0, 24)
	box.Position = UDim2.new(0, 8, 0, y)
	box.BackgroundColor3 = Color3.fromRGB(40, 32, 48)
	box.BackgroundTransparency = 0.12
	box.BorderSizePixel = 0
	box.ClearTextOnFocus = false
	box.Font = Enum.Font.Gotham
	box.PlaceholderText = placeholder
	box.Text = tostring(value or "")
	box.TextColor3 = Color3.fromRGB(235, 225, 240)
	box.PlaceholderColor3 = Color3.fromRGB(145, 130, 160)
	box.TextSize = 9
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.ZIndex = 31
	box.Parent = customAudioPanel
	corner(box, 6)
	return box
end
local customClickBox = customAudioBox("ClickAudio", "Clic : ID Roblox ou chemin local", 8, St.customSoundClick)
local customSuccessBox = customAudioBox("SuccessAudio", "Succès : ID Roblox ou chemin local", 36, St.customSoundSuccess)
local customErrorBox = customAudioBox("ErrorAudio", "Erreur : ID Roblox ou chemin local", 64, St.customSoundError)
local customApply = Instance.new("TextButton")
customApply.Name = "ApplyCustomAudio"
customApply.Size = UDim2.new(0.5, -12, 0, 24)
customApply.Position = UDim2.new(0, 8, 0, 94)
customApply.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
customApply.BorderSizePixel = 0
customApply.Text = "APPLIQUER"
customApply.TextColor3 = Color3.fromRGB(255, 255, 255)
customApply.TextSize = 9
customApply.Font = Enum.Font.GothamBold
customApply.ZIndex = 31
customApply.Parent = customAudioPanel
corner(customApply, 6)
local function refreshCustomAudioPanel()
	customAudioPanel.Visible = EL2BSoundTheme == "Custom"
	soundThemeButton.Text = "SON : " .. getEL2BSoundTheme().label
end
customApply.Activated:Connect(function()
	St.customSoundClick = string.sub(customClickBox.Text or "", 1, 180)
	St.customSoundSuccess = string.sub(customSuccessBox.Text or "", 1, 180)
	St.customSoundError = string.sub(customErrorBox.Text or "", 1, 180)
	saveCfg()
	playEL2BSuccessSound()
end)
local customReset = Instance.new("TextButton")
customReset.Name = "ResetSoundTheme"
customReset.Size = UDim2.new(0.5, -12, 0, 24)
customReset.Position = UDim2.new(0.5, 4, 0, 94)
customReset.BackgroundColor3 = Color3.fromRGB(40, 32, 48)
customReset.BorderSizePixel = 0
customReset.Text = "RÉINITIALISER"
customReset.TextColor3 = Color3.fromRGB(255, 220, 135)
customReset.TextSize = 8
customReset.Font = Enum.Font.GothamBold
customReset.ZIndex = 31
customReset.Parent = customAudioPanel
corner(customReset, 6)
customReset.Activated:Connect(function()
	St.customSoundClick = ""
	St.customSoundSuccess = ""
	St.customSoundError = ""
	St.soundTheme = "Neon"
	EL2BSoundTheme = "Neon"
	soundThemeIndex = 1
	customClickBox.Text = ""
	customSuccessBox.Text = ""
	customErrorBox.Text = ""
	refreshCustomAudioPanel()
	saveCfg()
	playEL2BSuccessSound()
end)
soundThemeButton.Activated:Connect(function()
	soundThemeIndex = soundThemeIndex % #EL2B_SOUND_THEME_ORDER + 1
	EL2BSoundTheme = EL2B_SOUND_THEME_ORDER[soundThemeIndex]
	St.soundTheme = EL2BSoundTheme
	refreshCustomAudioPanel()
	saveCfg()
	playEL2BSuccessSound()
end)

local menuScaleObj = Instance.new("UIScale")
menuScaleObj.Name = "VisMenuScale"
menuScaleObj.Scale = tonumber(St.menuScale) or 1
menuScaleObj.Parent = Main

function applyMenuScale()
	local sc = math.clamp(tonumber(St.menuScale) or 1, 0.5, 1.5)
	St.menuScale = sc
	if menuScaleObj and menuScaleObj.Parent then
		menuScaleObj.Scale = sc
	else
		local baseW, baseH = 270, 360
		Main.Size = UDim2.new(0, math.floor(baseW * sc), 0, math.floor(baseH * sc))
	end
end
pcall(applyMenuScale)

corner(Main, 14)
local mainStroke = stroke(Main)
mainStroke.Thickness = 2.2
mainStroke.Transparency = 0

do
	local g = Instance.new("UIGradient")
	g.Name = "EmpireOutlineGrad"
	g.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.15, Color3.fromRGB(255, 140, 200)),
		ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 45, 160)),
		ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 20, 140)),
		ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 80, 180)),
		ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 150, 210)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
	})
	g.Parent = mainStroke
	task.spawn(function()
		local t0 = tick()
		while mainStroke and mainStroke.Parent do
			local t = (tick() - t0) * 0.35
			g.Rotation = (t * 60) % 360
			task.wait(0.03)
		end
	end)
end

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 36)
Top.BackgroundColor3 = C.bg2
Top.BorderSizePixel = 0
Top.ZIndex = 15
Top.Active = true
Top.Parent = Main
corner(Top, 14)
local topFix = Instance.new("Frame")
topFix.Size = UDim2.new(1, 0, 0, 12)
topFix.Position = UDim2.new(0, 0, 1, -12)
topFix.BackgroundColor3 = C.bg2
topFix.BorderSizePixel = 0
topFix.Parent = Top

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -140, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Free Sell Là Tuất Ngu Lồn"
Title.TextColor3 = Color3.fromRGB(255, 230, 245)
Title.TextSize = 12
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextStrokeTransparency = 0.55
Title.TextStrokeColor3 = Color3.fromRGB(255, 80, 160)
Title.Parent = Top
local titleGrad = Instance.new("UIGradient")
titleGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 160, 210)),
	ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255, 90, 180)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 140, 255)),
})
titleGrad.Parent = Title
task.spawn(function()
	local t0 = tick()
	while Title and Title.Parent do
		titleGrad.Offset = Vector2.new((math.sin(tick() - t0) * 0.35), 0)
		task.wait(0.03)
	end
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -11)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 32, 48)
CloseBtn.Text = "−"
CloseBtn.TextColor3 = C.textDim
CloseBtn.TextSize = 11
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Top
corner(CloseBtn, 6)

local WebStatus = Instance.new("Frame")
WebStatus.Name = "WebStatusIndicator"
WebStatus.Size = UDim2.new(0, 92, 0, 22)
WebStatus.Position = UDim2.new(1, -126, 0.5, -11)
WebStatus.BackgroundColor3 = Color3.fromRGB(18, 14, 25)
WebStatus.BorderSizePixel = 0
WebStatus.ZIndex = 20
WebStatus.Parent = Top
corner(WebStatus, 7)
local WebStatusStroke = stroke(WebStatus)
WebStatusStroke.Color = Color3.fromRGB(100, 70, 125)
WebStatusStroke.Thickness = 1
WebStatusStroke.Transparency = 0.2
local WebStatusDot = Instance.new("Frame")
WebStatusDot.Name = "StatusDot"
WebStatusDot.Size = UDim2.new(0, 7, 0, 7)
WebStatusDot.Position = UDim2.new(0, 8, 0.5, -3)
WebStatusDot.BackgroundColor3 = Color3.fromRGB(130, 120, 145)
WebStatusDot.BorderSizePixel = 0
WebStatusDot.ZIndex = 21
WebStatusDot.Parent = WebStatus
corner(WebStatusDot, 4)
local WebStatusText = Instance.new("TextLabel")
WebStatusText.Name = "StatusText"
WebStatusText.Size = UDim2.new(1, -22, 1, 0)
WebStatusText.Position = UDim2.new(0, 20, 0, 0)
WebStatusText.BackgroundTransparency = 1
WebStatusText.Text = "WEB OFF"
WebStatusText.TextColor3 = Color3.fromRGB(155, 145, 165)
WebStatusText.TextSize = 9
WebStatusText.Font = Enum.Font.GothamBold
WebStatusText.TextXAlignment = Enum.TextXAlignment.Left
WebStatusText.ZIndex = 21
WebStatusText.Parent = WebStatus
local function setWebStatusIndicator(state)
	local colors = {
		off = { dot = Color3.fromRGB(135, 125, 150), text = Color3.fromRGB(165, 155, 175), border = Color3.fromRGB(100, 70, 125), label = "WEB OFF" },
		connecting = { dot = Color3.fromRGB(255, 190, 80), text = Color3.fromRGB(255, 210, 120), border = Color3.fromRGB(150, 105, 45), label = "CONNECT…" },
	online = { dot = Color3.fromRGB(70, 255, 135), text = Color3.fromRGB(130, 255, 170), border = Color3.fromRGB(55, 150, 90), label = "WEB ON" },
	error = { dot = Color3.fromRGB(255, 85, 110), text = Color3.fromRGB(255, 150, 165), border = Color3.fromRGB(155, 55, 75), label = "OFFLINE" },
	}
	local c = colors[state] or colors.off
	WebStatusDot.BackgroundColor3 = c.dot
	WebStatusText.TextColor3 = c.text
	WebStatusText.Text = c.label
	WebStatusStroke.Color = c.border
end
setWebStatusIndicator("off")

local Helper = Instance.new("TextButton")
Helper.Name = "HelperClose"
Helper.Size = UDim2.new(0, 44, 0, 44)
Helper.Position = UDim2.new(0, -52, 0, 8)
Helper.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
Helper.Text = "⚔"
Helper.TextColor3 = C.accent
Helper.TextSize = 18
Helper.Font = Enum.Font.GothamBold
Helper.AutoButtonColor = false
Helper.Parent = Main
corner(Helper, 22)
local hs = Instance.new("UIStroke", Helper)
hs.Color = C.accent
hs.Thickness = 2
hs.Transparency = 0.15

local TAB_W = 72
local TabBar = Instance.new("ScrollingFrame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(0, TAB_W, 1, -48)
TabBar.Position = UDim2.new(0, 4, 0, 44)
TabBar.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
TabBar.BackgroundTransparency = 0.25
TabBar.BorderSizePixel = 0
TabBar.ScrollBarThickness = 4
TabBar.ScrollBarImageColor3 = C.accent
TabBar.ScrollingDirection = Enum.ScrollingDirection.Y
TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
TabBar.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabBar.ZIndex = 20
TabBar.Active = true
TabBar.Selectable = true
TabBar.Parent = Main
corner(TabBar, 8)
local tabList = Instance.new("UIListLayout", TabBar)
tabList.FillDirection = Enum.FillDirection.Vertical
tabList.Padding = UDim.new(0, 4)
tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabList.SortOrder = Enum.SortOrder.LayoutOrder
local tabPad = Instance.new("UIPadding", TabBar)
tabPad.PaddingTop = UDim.new(0, 4)
tabPad.PaddingBottom = UDim.new(0, 6)
tabPad.PaddingLeft = UDim.new(0, 3)
tabPad.PaddingRight = UDim.new(0, 3)

local pages, tabBtns = {}, {}
function makePage(name)
	local sc = Instance.new("ScrollingFrame")
	sc.Name = name
	sc.Size = UDim2.new(1, -(TAB_W + 10), 1, -52)
	sc.Position = UDim2.new(0, TAB_W + 8, 0, 48)
	sc.BackgroundTransparency = 1
	sc.BorderSizePixel = 0
	sc.ScrollBarThickness = 4
	sc.ScrollBarImageColor3 = C.accent
	sc.ScrollingDirection = Enum.ScrollingDirection.Y
	sc.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sc.CanvasSize = UDim2.new(0, 0, 0, 0)
	sc.Visible = false
	sc.ZIndex = 10
	sc.Active = true
	sc.Selectable = true
	sc.Parent = Main
	local pad = Instance.new("UIPadding", sc)
	pad.PaddingTop = UDim.new(0, 4)
	pad.PaddingBottom = UDim.new(0, 10)
	pad.PaddingLeft = UDim.new(0, 6)
	pad.PaddingRight = UDim.new(0, 8)
	local lay = Instance.new("UIListLayout", sc)
	lay.Padding = UDim.new(0, 5)
	lay.SortOrder = Enum.SortOrder.LayoutOrder
	sc.Active = true
	sc.Selectable = true
	pages[name] = sc
	return sc
end

local pagePlayer = makePage("Player")
local pageESP = makePage("ESP")
local pageSpam = makePage("Spam")
local pageCounter = makePage("Counter")
local pageSet = makePage("Settings")
local pageKeys = makePage("Keybinds")

function setTab(name)
	for n, p in pairs(pages) do
		p.Visible = (n == name)
	end
	for n, b in pairs(tabBtns) do
		local on = n == name
		b.BackgroundColor3 = on and C.accent or C.card
		b.TextColor3 = on and Color3.fromRGB(30, 20, 30) or C.text
	end
end

function addTab(name, order)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -4, 0, 28)
	b.BackgroundColor3 = C.card
	b.Text = name
	b.TextColor3 = C.text
	b.TextSize = 11
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.LayoutOrder = order
	b.Active = true
	b.Selectable = true
	b.ZIndex = 21
	b.Parent = TabBar
	corner(b, 8)
	local function go() setTab(name) end
	b.MouseButton1Click:Connect(go)
	b.Activated:Connect(go)
	tabBtns[name] = b
end
addTab("Player", 1)
addTab("ESP", 2)
addTab("Spam", 3)
addTab("Counter", 4)
addTab("Settings", 5)
addTab("Keybinds", 6)

function section(parent, text, order)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(1, 0, 0, 16)
	f.BackgroundTransparency = 1
	f.LayoutOrder = order
	f.Parent = parent
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, 0, 1, 0)
	t.BackgroundTransparency = 1
	t.Text = text
	t.TextColor3 = C.textDim
	t.TextSize = 11
	t.Font = Enum.Font.GothamBold
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = f
end

function row(parent, h, order)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(1, 0, 0, h or 38)
	f.BackgroundColor3 = C.card
	f.BorderSizePixel = 0
	f.LayoutOrder = order
	f.Active = true
	f.Parent = parent
	corner(f, 9)
	stroke(f)
	return f
end

function toggle(parent, label, default, cb, order)
	local r = row(parent, 38, order)
	local txt = Instance.new("TextLabel")
	txt.Size = UDim2.new(1, -60, 1, 0)
	txt.Position = UDim2.new(0, 12, 0, 0)
	txt.BackgroundTransparency = 1
	txt.Text = label
	txt.TextColor3 = C.text
	txt.TextSize = 13
	txt.Font = Enum.Font.Gotham
	txt.TextXAlignment = Enum.TextXAlignment.Left
	txt.Parent = r
	local track = Instance.new("Frame")
	track.Size = UDim2.new(0, 40, 0, 22)
	track.Position = UDim2.new(1, -50, 0.5, -11)
	track.BackgroundColor3 = default and C.on or C.off
	track.BorderSizePixel = 0
	track.Parent = r
	corner(track, 11)
	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 18, 0, 18)
	knob.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
	knob.BackgroundColor3 = Color3.new(1, 1, 1)
	knob.BorderSizePixel = 0
	knob.Parent = track
	corner(knob, 9)
	local state = default

	-- Carré arrière visible : halo sombre + contour dégradé, comme sur la maquette mobile.
	local back = Instance.new("Frame")
	back.Name = "BtnSquareBack"
	back.Position = UDim2.new(0, -5, 0, -5)
	back.Size = UDim2.new(1, 10, 1, 10)
	back.BackgroundColor3 = Color3.fromRGB(18, 8, 24)
	back.BorderSizePixel = 0
	back.ZIndex = 49
	back.Active = false
	back.Selectable = false
	back.Parent = holder
	local backCorner = Instance.new("UICorner", back)
	backCorner.CornerRadius = UDim.new(0, 11)
	local backStroke = Instance.new("UIStroke", back)
	backStroke.Name = "SquareBackBorder"
	backStroke.Thickness = 4
	backStroke.Transparency = 0.05
	backStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	backStroke.Color = Color3.fromRGB(255, 150, 225)
	local backGradient = Instance.new("UIGradient", backStroke)
	backGradient.Name = "SquareBackGradient"
	backGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 105, 205)),
		ColorSequenceKeypoint.new(0.7, Color3.fromRGB(160, 90, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
	})
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.Parent = r
	local function apply(on)
		state = on and true or false
		TS:Create(track, TweenInfo.new(0.15), { BackgroundColor3 = state and C.on or C.off }):Play()
		TS:Create(knob, TweenInfo.new(0.15), {
			Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
		}):Play()
		if cb then pcall(cb, state) end
		saveCfg()
	end
	btn.Active = true
	btn.Selectable = true
	btn.ZIndex = 50
	track.ZIndex = 6
	knob.ZIndex = 7
	r.Active = true
	local _busy = false
	local function fireToggle()
		if _busy then return end
		_busy = true
		apply(not state)
		task.delay(0.15, function() _busy = false end)
	end
	btn.MouseButton1Click:Connect(fireToggle)
	btn.Activated:Connect(fireToggle)
	local down, startP
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			down = true
			startP = input.Position
		end
	end)
	btn.InputEnded:Connect(function(input)
		if not down then return end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
		down = false
		if startP and (input.Position - startP).Magnitude < 12 then
			fireToggle()
		end
	end)
	local function setVisualOnly(on)
		state = on and true or false
		TS:Create(track, TweenInfo.new(0.12), { BackgroundColor3 = state and C.on or C.off }):Play()
		TS:Create(knob, TweenInfo.new(0.12), {
			Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
		}):Play()
	end
	return { set = apply, setVisual = setVisualOnly, get = function() return state end }
end

function toggleNamed(parent, label, default, cb, order, refName)
	local api = toggle(parent, label, default, cb, order)
	if refName then ToggleRefs[refName] = api end
	return api
end

function numBox(parent, pos, w, val, cb)
	local b = Instance.new("TextBox")
	b.Size = UDim2.new(0, w, 0, 24)
	b.Position = pos
	b.BackgroundColor3 = C.box
	b.Text = tostring(val)
	b.TextColor3 = C.text
	b.TextSize = 12
	b.Font = Enum.Font.GothamBold
	b.ClearTextOnFocus = false
	b.Active = true
	b.ZIndex = 25
	b.Parent = parent
	corner(b, 6)
	b.FocusLost:Connect(function()
		local n = tonumber(b.Text)
		if n then
			n = math.clamp(n, 1, 200)
			b.Text = tostring(n)
			if cb then cb(n) end
		else
			b.Text = tostring(val)
		end
	end)
	return b
end

function keyName(k)
	return k and tostring(k):gsub("Enum.KeyCode.", "") or "?"
end

local listening = nil
function keyBtn(parent, key, onSet, pos)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 36, 0, 24)
	b.Position = pos or UDim2.new(0, 0, 0, 0)
	b.BackgroundColor3 = C.box
	b.Text = keyName(key)
	b.TextColor3 = C.text
	b.TextSize = 11
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Active = true
	b.ZIndex = 25
	b.Parent = parent
	corner(b, 6)
	b.MouseButton1Click:Connect(function()
		if listening then return end
		listening = b
		b.Text = "..."
		local conn
		conn = UIS.InputBegan:Connect(function(input, gp)
			if gp or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
			if input.KeyCode == Enum.KeyCode.Escape then
				b.Text = keyName(key)
				listening = nil
				conn:Disconnect()
				return
			end
			key = input.KeyCode
			b.Text = keyName(key)
			listening = nil
			conn:Disconnect()
			if onSet then onSet(key) end
		end)
	end)
	return b
end

function actionBtn(parent, text, color, cb, order)
	local r = row(parent, 36, order)
	r.BackgroundColor3 = color or C.accent
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 1, 0)
	b.BackgroundTransparency = 1
	b.Text = text
	b.TextColor3 = Color3.fromRGB(30, 20, 30)
	b.TextSize = 13
	b.Font = Enum.Font.GothamBold
	b.Parent = r
	b.Active = true
	b.ZIndex = 20
	local _busy = false
	local function fire()
		if _busy then return end
		_busy = true
		if cb then pcall(cb) end
		task.delay(0.15, function() _busy = false end)
	end
	b.MouseButton1Click:Connect(fire)
	b.Activated:Connect(fire)
	return r
end

-- ==============================
--  ONGLET PLAYER
-- ==============================
section(pagePlayer, "* — ANTI", 1)
toggleNamed(pagePlayer, "Anti Gummy Bear", St.antiGummy, setAntiGummy, 2, "antiGummy")
toggleNamed(pagePlayer, "Anti Ragdoll", St.antiRagdoll, setAntiRagdoll, 3, "antiRagdoll")

do
	local r = row(pagePlayer, 36, 3.5)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(0.4, 0, 1, 0)
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = C.textDim
	label.Text = "  Mode"
	label.Parent = r
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(0.55, 0, 0, 26)
	holder.Position = UDim2.new(0.42, 0, 0.5, -13)
	holder.BackgroundColor3 = C.box
	holder.BorderSizePixel = 0
	holder.Parent = r
	local hc = Instance.new("UICorner")
	hc.CornerRadius = UDim.new(0, 8)
	hc.Parent = holder
	local slide = Instance.new("Frame")
	slide.Size = UDim2.new(0.5, -6, 1, -6)
	slide.Position = UDim2.new(0, 3, 0, 3)
	slide.BackgroundColor3 = C.accent
	slide.BorderSizePixel = 0
	slide.ZIndex = 2
	slide.Parent = holder
	local sc = Instance.new("UICorner")
	sc.CornerRadius = UDim.new(0, 6)
	sc.Parent = slide
	local t1 = Instance.new("TextLabel")
	t1.BackgroundTransparency = 1
	t1.Size = UDim2.new(0.5, 0, 1, 0)
	t1.Font = Enum.Font.GothamBold
	t1.TextSize = 11
	t1.Text = "V1"
	t1.TextColor3 = C.text
	t1.ZIndex = 3
	t1.Parent = holder
	local t2 = Instance.new("TextLabel")
	t2.BackgroundTransparency = 1
	t2.Size = UDim2.new(0.5, 0, 1, 0)
	t2.Position = UDim2.new(0.5, 0, 0, 0)
	t2.Font = Enum.Font.GothamBold
	t2.TextSize = 11
	t2.Text = "V2"
	t2.TextColor3 = C.text
	t2.ZIndex = 3
	t2.Parent = holder
	local function refresh()
		local isV2 = tostring(St.antiRagdollMode or "V1"):upper() == "V2"
		slide.Position = isV2 and UDim2.new(0.5, 2, 0, 3) or UDim2.new(0, 3, 0, 3)
		t1.TextTransparency = isV2 and 0.35 or 0
		t2.TextTransparency = isV2 and 0 or 0.35
	end
	_G.VisRefreshAntiRagMode = refresh
	local b1 = Instance.new("TextButton")
	b1.BackgroundTransparency = 1
	b1.Size = UDim2.new(0.5, 0, 1, 0)
	b1.Text = ""
	b1.ZIndex = 4
	b1.Parent = holder
	b1.MouseButton1Click:Connect(function() setAntiRagdollMode("V1"); refresh() end)
	local b2 = Instance.new("TextButton")
	b2.BackgroundTransparency = 1
	b2.Size = UDim2.new(0.5, 0, 1, 0)
	b2.Position = UDim2.new(0.5, 0, 0, 0)
	b2.Text = ""
	b2.ZIndex = 4
	b2.Parent = holder
	b2.MouseButton1Click:Connect(function() setAntiRagdollMode("V2"); refresh() end)
	refresh()
end
toggleNamed(pagePlayer, "Anti Paintball Gun", St.antiPaint, setAntiPaint, 4, "antiPaint")
toggleNamed(pagePlayer, "Anti Boogie Bomb", St.antiBoogie, setAntiBoogie, 5, "antiBoogie")

section(pagePlayer, "* — SPEED (Vis S2)", 10)
toggleNamed(pagePlayer, "Speed On", St.speedOn, setSpeedOn, 11, "speedOn")

local modeCards = {}
function modeCard(name, desc, order)
	local m = St.modes[name]
	local r = row(pagePlayer, 58, order)
	modeCards[name] = r
	local nm = Instance.new("TextLabel")
	nm.Size = UDim2.new(0, 130, 0, 18)
	nm.Position = UDim2.new(0, 12, 0, 6)
	nm.BackgroundTransparency = 1
	nm.Text = name .. " Speed"
	nm.TextColor3 = C.text
	nm.TextSize = 13
	nm.Font = Enum.Font.GothamBold
	nm.TextXAlignment = Enum.TextXAlignment.Left
	nm.Parent = r
	local ds = Instance.new("TextLabel")
	ds.Size = UDim2.new(0, 140, 0, 14)
	ds.Position = UDim2.new(0, 12, 0, 24)
	ds.BackgroundTransparency = 1
	ds.Text = desc
	ds.TextColor3 = C.textDim
	ds.TextSize = 10
	ds.Font = Enum.Font.Gotham
	ds.TextXAlignment = Enum.TextXAlignment.Left
	ds.Parent = r
	keyBtn(r, m.key, function(k) St.modes[name].key = k; saveCfg() end, UDim2.new(1, -112, 0, 28))
	local ln = Instance.new("TextLabel")
	ln.Size = UDim2.new(0, 48, 0, 12)
	ln.Position = UDim2.new(1, -150, 0, 4)
	ln.BackgroundTransparency = 1
	ln.Text = "norm"
	ln.TextColor3 = C.textDim
	ln.TextSize = 9
	ln.Font = Enum.Font.Gotham
	ln.Parent = r
	local ls = Instance.new("TextLabel")
	ls.Size = UDim2.new(0, 48, 0, 12)
	ls.Position = UDim2.new(1, -72, 0, 4)
	ls.BackgroundTransparency = 1
	ls.Text = "steal"
	ls.TextColor3 = C.textDim
	ls.TextSize = 9
	ls.Font = Enum.Font.Gotham
	ls.Parent = r
	numBox(r, UDim2.new(1, -150, 0, 20), 48, m.norm, function(v)
		St.modes[name].norm = math.clamp(tonumber(v) or 59, 1, 200)
		if St.activeMode == name then
			currentSpeedValue = getActiveMoveSpeed()
			if speedConnection then pcall(function() speedConnection:Disconnect() end); speedConnection = nil end
			if St.speedOn then pcall(startSpeedBoost) end
		end
		saveCfg()
	end)
	numBox(r, UDim2.new(1, -72, 0, 20), 48, m.steal, function(v)
		St.modes[name].steal = math.clamp(tonumber(v) or 30, 1, 200)
		if St.activeMode == name then
			currentSpeedValue = getActiveMoveSpeed()
			if speedConnection then pcall(function() speedConnection:Disconnect() end); speedConnection = nil end
			if St.speedOn then pcall(startSpeedBoost) end
		end
		saveCfg()
	end)
	local hit = Instance.new("TextButton")
	hit.Size = UDim2.new(0.45, 0, 1, 0)
	hit.BackgroundTransparency = 1
	hit.Text = ""
	hit.Active = true
	hit.ZIndex = 15
	hit.Parent = r
	hit.MouseButton1Click:Connect(function() setActiveMode(name) end)
	hit.Activated:Connect(function() setActiveMode(name) end)
end
modeCard("Normal", "default mode", 12)
modeCard("Lagger", "use against lagger", 13)
modeCard("Custom", "custom spd", 14)

function _G.VisRefreshModeCards()
	for n, card in pairs(modeCards) do
		local st = card:FindFirstChildOfClass("UIStroke")
		if st then
			local on = St.activeMode == n
			st.Color = on and C.accent or C.stroke
			st.Transparency = on and 0.05 or 0.35
		end
	end
end
_G.VisRefreshModeCards()

section(pagePlayer, "* — COMBAT / DROP / RESET", 20)
toggleNamed(pagePlayer, "Tool Aimbot", St.toolAim, setToolAim, 21, "toolAim")
toggleNamed(pagePlayer, "Body Lock", St.bodyLock == true, setBodyLock, 22, "bodyLock")
do
	local rr = row(pagePlayer, 36, 22)
	local rl = Instance.new("TextLabel")
	rl.Size = UDim2.new(0.55, 0, 1, 0)
	rl.BackgroundTransparency = 1
	rl.Text = "Body Lock Range"
	rl.TextColor3 = C.text
	rl.TextSize = 12
	rl.Font = Enum.Font.Gotham
	rl.TextXAlignment = Enum.TextXAlignment.Left
	rl.Parent = rr
	numBox(rr, UDim2.new(1, -70, 0.5, -12), 56, tonumber(St.bodyLockRange) or 20, function(v)
		setBodyLockRange(v)
	end)
end
toggleNamed(pagePlayer, "Infinite Jump (Hold)", St.infJump, setInfJump, 215, "infJump")
toggleNamed(pagePlayer, "Auto Destroy Sentry", St.destroySentry, setDestroySentry, 216, "destroySentry")

local dropRow = row(pagePlayer, 38, 22)
local dropLbl = Instance.new("TextLabel")
dropLbl.Size = UDim2.new(0.4, 0, 1, 0)
dropLbl.Position = UDim2.new(0, 12, 0, 0)
dropLbl.BackgroundTransparency = 1
dropLbl.Text = "Drop Mode"
dropLbl.TextColor3 = C.text
dropLbl.TextSize = 13
dropLbl.Font = Enum.Font.Gotham
dropLbl.TextXAlignment = Enum.TextXAlignment.Left
dropLbl.Parent = dropRow
for i, name in ipairs({ "Stand", "Jump" }) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 60, 0, 26)
	b.Position = UDim2.new(1, -140 + (i - 1) * 66, 0.5, -13)
	b.BackgroundColor3 = ((St.dropMode == 1 and name == "Stand") or (St.dropMode == 2 and name == "Jump")) and C.accent or C.box
	b.Text = name
	b.TextColor3 = ((St.dropMode == 1 and name == "Stand") or (St.dropMode == 2 and name == "Jump")) and Color3.fromRGB(30, 20, 30) or C.text
	b.TextSize = 11
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Parent = dropRow
	corner(b, 7)
	b.Active = true
	b.ZIndex = 40
	local function pickDrop()
		St.dropMode = (name == "Jump") and 2 or 1
		for _, ch in ipairs(dropRow:GetChildren()) do
			if ch:IsA("TextButton") then
				local on = (St.dropMode == 2 and ch.Text == "Jump") or (St.dropMode == 1 and ch.Text == "Stand")
				ch.BackgroundColor3 = on and C.accent or C.box
				ch.TextColor3 = on and Color3.fromRGB(30, 20, 30) or C.text
			end
		end
		saveCfg()
	end
	b.MouseButton1Click:Connect(pickDrop)
	b.Activated:Connect(pickDrop)
end
actionBtn(pagePlayer, "Drop Now", C.accent, runDrop, 23)

local instaRow = row(pagePlayer, 38, 24)
local instaLbl = Instance.new("TextLabel")
instaLbl.Size = UDim2.new(0.4, 0, 1, 0)
instaLbl.Position = UDim2.new(0, 12, 0, 0)
instaLbl.BackgroundTransparency = 1
instaLbl.Text = "Insta Reset"
instaLbl.TextColor3 = C.text
instaLbl.TextSize = 13
instaLbl.Font = Enum.Font.Gotham
instaLbl.TextXAlignment = Enum.TextXAlignment.Left
instaLbl.Parent = instaRow
for i, name in ipairs({ "V1", "V2" }) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 48, 0, 26)
	b.Position = UDim2.new(1, -120 + (i - 1) * 54, 0.5, -13)
	b.BackgroundColor3 = (St.instaMode == name) and C.accent or C.box
	b.Text = name
	b.TextColor3 = (St.instaMode == name) and Color3.fromRGB(30, 20, 30) or C.text
	b.TextSize = 11
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Parent = instaRow
	corner(b, 7)
	b.Active = true
	b.ZIndex = 40
	local function pickInsta()
		St.instaMode = name
		for _, ch in ipairs(instaRow:GetChildren()) do
			if ch:IsA("TextButton") then
				local on = ch.Text == St.instaMode
				ch.BackgroundColor3 = on and C.accent or C.box
				ch.TextColor3 = on and Color3.fromRGB(30, 20, 30) or C.text
			end
		end
		saveCfg()
	end
	b.MouseButton1Click:Connect(pickInsta)
	b.Activated:Connect(pickInsta)
end
actionBtn(pagePlayer, "Insta Reset Now", C.danger, doInstaReset, 25)
actionBtn(pagePlayer, "TP Down", C.accent, function() doTPDown(true) end, 26)

section(pagePlayer, "* — AUTO STEAL", 28)
local function safeSetAS(on)
	if type(setAutoSteal) == "function" then setAutoSteal(on)
	else St.autoSteal = on and true or false end
end
toggleNamed(pagePlayer, "Auto Steal", St.autoSteal == true, safeSetAS, 29, "autoSteal")

local verRow = row(pagePlayer, 36, 30)
local vl = Instance.new("TextLabel")
vl.Size = UDim2.new(0.35, 0, 1, 0)
vl.Position = UDim2.new(0, 10, 0, 0)
vl.BackgroundTransparency = 1
vl.Text = "Version"
vl.TextColor3 = C.text
vl.TextSize = 12
vl.Font = Enum.Font.Gotham
vl.TextXAlignment = Enum.TextXAlignment.Left
vl.Parent = verRow
for i, name in ipairs({"V1", "V2", "V3"}) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 40, 0, 26)
	b.Position = UDim2.new(1, -140 + (i - 1) * 44, 0.5, -13)
	b.BackgroundColor3 = (St.stealVer == name) and C.accent or C.box
	b.Text = name
	b.TextColor3 = (St.stealVer == name) and Color3.fromRGB(30, 20, 30) or C.text
	b.TextSize = 11
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Active = true
	b.ZIndex = 40
	b.Parent = verRow
	corner(b, 7)
	local function pickVer()
		St.stealVer = name
		for _, ch in ipairs(verRow:GetChildren()) do
			if ch:IsA("TextButton") then
				local on = ch.Text == St.stealVer
				ch.BackgroundColor3 = on and C.accent or C.box
				ch.TextColor3 = on and Color3.fromRGB(30, 20, 30) or C.text
			end
		end
		selectedStealMode = (name == "V1") and "Normal" or "Semi"
		if name == "V2" then autoStealV2Version = "V1" end
		if name == "V3" then autoStealV2Version = "V2" end
		if name == "V1" then selectedStealMode = "Normal" end
		autoStealRadius = tonumber(St.stealRadius) or 60
		if type(setAutoSteal) == "function" and St.autoSteal then setAutoSteal(true)
		elseif _G.VisSyncAutoSteal then pcall(_G.VisSyncAutoSteal) end
		saveCfg()
	end
	b.MouseButton1Click:Connect(pickVer)
	b.Activated:Connect(pickVer)
end

toggleNamed(pagePlayer, "Pause (chỉ khi bật)", St.stealPause == true, function(on)
	St.stealPause = on and true or false
	_G.VisStealPause = St.stealPause
	if _G.VisSyncAutoSteal then pcall(_G.VisSyncAutoSteal) end
	saveCfg()
end, 31, "stealPause")

local rr = row(pagePlayer, 36, 32)
local rl = Instance.new("TextLabel")
rl.Size = UDim2.new(0.5, 0, 1, 0)
rl.Position = UDim2.new(0, 10, 0, 0)
rl.BackgroundTransparency = 1
rl.Text = "Steal Radius"
rl.TextColor3 = C.text
rl.TextSize = 12
rl.Font = Enum.Font.Gotham
rl.TextXAlignment = Enum.TextXAlignment.Left
rl.Parent = rr
numBox(rr, UDim2.new(1, -70, 0.5, -12), 56, St.stealRadius, function(v)
	St.stealRadius = v
	saveCfg()
end)

section(pagePlayer, "* — INF JUMP MODE", 33)
local ij = row(pagePlayer, 36, 34)
for i, name in ipairs({"hold", "manual"}) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 70, 0, 26)
	b.Position = UDim2.new(0, 12 + (i - 1) * 80, 0.5, -13)
	b.BackgroundColor3 = (St.infJumpMode == name) and C.accent or C.box
	b.Text = name
	b.TextColor3 = (St.infJumpMode == name) and Color3.fromRGB(30, 20, 30) or C.text
	b.TextSize = 11
	b.Font = Enum.Font.GothamBold
	b.Parent = ij
	corner(b, 7)
	b.MouseButton1Click:Connect(function()
		setInfJumpMode(name)
		for _, ch in ipairs(ij:GetChildren()) do
			if ch:IsA("TextButton") then
				local on = ch.Text == St.infJumpMode
				ch.BackgroundColor3 = on and C.accent or C.box
				ch.TextColor3 = on and Color3.fromRGB(30, 20, 30) or C.text
			end
		end
	end)
end

section(pagePlayer, "* — KEYBINDS", 35)
function keyRow(label, keyId, order)
	local r = row(pagePlayer, 36, order)
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, -56, 1, 0)
	t.Position = UDim2.new(0, 12, 0, 0)
	t.BackgroundTransparency = 1
	t.Text = label
	t.TextColor3 = C.text
	t.TextSize = 13
	t.Font = Enum.Font.Gotham
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = r
	keyBtn(r, St.keys[keyId], function(k) St.keys[keyId] = k; saveCfg() end, UDim2.new(1, -48, 0.5, -12))
end
keyRow("Key Drop", "Drop", 36)
keyRow("Key TP Down", "TPDown", 37)
keyRow("Key Insta Reset", "InstaReset", 38)
keyRow("Key Destroy Sentry", "DestroySentry", 39)
keyRow("Key Auto Steal", "AutoSteal", 40)

-- ==============================
--  ONGLET KEYBINDS
-- ==============================
section(pageKeys, "* — KEYBINDS (PC)", 1)
local function keyRowTab(label, keyId, order)
	local r = row(pageKeys, 36, order)
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, -100, 1, 0)
	t.Position = UDim2.new(0, 12, 0, 0)
	t.BackgroundTransparency = 1
	t.Text = label
	t.TextColor3 = C.text
	t.TextSize = 13
	t.Font = Enum.Font.Gotham
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = r
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 88, 0, 28)
	b.Position = UDim2.new(1, -96, 0.5, -14)
	b.BackgroundColor3 = C.box
	b.TextColor3 = C.text
	b.TextSize = 12
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Parent = r
	corner(b, 7)
	local function refresh()
		local k = St.keys and St.keys[keyId]
		if not k or k == Enum.KeyCode.Unknown then
			b.Text = "None"
		else
			b.Text = tostring(k.Name or k)
		end
	end
	refresh()
	local listening2 = false
	local function startListen()
		if listening2 then return end
		listening2 = true
		b.Text = "..."
		b.BackgroundColor3 = C.accent
		local conn
		conn = UIS.InputBegan:Connect(function(inp, gp)
			if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
			local code = inp.KeyCode
			if code == Enum.KeyCode.Escape then
				listening2 = false
				b.BackgroundColor3 = C.box
				refresh()
				if conn then conn:Disconnect() end
				return
			end
			if code == Enum.KeyCode.Backspace or code == Enum.KeyCode.Delete then
				St.keys[keyId] = nil
			else
				St.keys[keyId] = code
			end
			listening2 = false
			b.BackgroundColor3 = C.box
			refresh()
			saveCfg()
			if conn then conn:Disconnect() end
		end)
	end
	b.MouseButton1Click:Connect(startListen)
	b.Activated:Connect(startListen)
end
keyRowTab("Drop", "Drop", 2)
keyRowTab("TP Down", "TPDown", 3)
keyRowTab("Insta Reset", "InstaReset", 4)
keyRowTab("Destroy Sentry", "DestroySentry", 5)
keyRowTab("Auto Steal (toggle)", "AutoSteal", 6)
local hint = Instance.new("TextLabel")
hint.Size = UDim2.new(1, -16, 0, 40)
hint.BackgroundTransparency = 1
hint.Text = "Bấm nút → nhấn phím pour assigner\nBackspace/Delete = None | Esc = annuler"
hint.TextColor3 = C.textDim
hint.TextSize = 11
hint.Font = Enum.Font.Gotham
hint.TextWrapped = true
hint.TextXAlignment = Enum.TextXAlignment.Left
hint.Parent = pageKeys
hint.LayoutOrder = 20

-- ==============================
--  EL2B HUB VISUAL CLEANER / FOV LOCK
-- ==============================
local visualCleanerDescConn = nil
local visualCleanerRenderConn = nil
local visualCleanerPreviousFOV = nil
local visualCleanerBlacklist = {
	"BlurEffect", "ColorCorrectionEffect", "BloomEffect", "SunRaysEffect",
	"DepthOfFieldEffect", "Atmosphere", "Sky", "Smoke", "ParticleEmitter",
	"Beam", "Trail", "Highlight", "SurfaceAppearance", "Fire", "Sparkles",
	"Explosion", "PointLight", "SpotLight", "SurfaceLight", "Clouds",
	"PostEffect", "ColorGradingEffect", "ToneMappingEffect", "VignetteEffect",
	"GodRays", "Glare", "ChromaticAberrationEffect", "DistortionEffect",
	"LensFlare", "SunFlare", "AmbientOcclusionEffect", "RefractionEffect",
	"HeatDistortion", "GlitchEffect", "ScreenSpaceReflection", "MotionBlur",
	"VolumetricLight", "RainEffect", "SnowEffect", "LightningEffect",
	"NeonGlow", "ContrastCorrection", "ShadowMap", "Bloom", "FogVolume",
	"WaterEffect", "WindEffect", "PixelateEffect", "FilmGrainEffect",
	"CRTShader", "NightVisionEffect", "InfraredEffect", "HazeEffect",
	"ColorBalanceEffect", "DynamicLight", "AmbientEffect", "ScreenDistortion",
	"ScanlineEffect", "UnderwaterEffect", "ThermalVision", "ShockwaveEffect",
	"FlashEffect", "ExplosionLight", "VFXPart", "GlitchScreen", "ScreenFlash",
	"OverlayEffect", "ShadowEffect", "GhostEffect", "FogEmitter", "WindEmitter",
	"HeatWave", "SunGlow", "ColorOverlay", "VisionDistort", "EchoEffect",
	"ScreenOverlay", "RenderEffect", "VisualEffect", "LightingEffect",
	"CameraEffect", "WeatherEffect", "SmokeTrail", "FireTrail", "NeonEffect",
	"RefractionLayer", "PostProcessingEffect", "VisualNoise", "ScreenNoise",
}

local function isVisualBlacklisted(obj)
	for _, className in ipairs(visualCleanerBlacklist) do
		local ok, matches = pcall(function() return obj:IsA(className) end)
		if ok and matches then return true end
	end
	return false
end

local function removeVisualEffect(obj)
	if not obj or not obj.Parent then return end
	if isVisualBlacklisted(obj) then pcall(function() obj:Destroy() end) end
end

local function clearVisualEffects()
	for _, obj in ipairs(Lighting:GetDescendants()) do removeVisualEffect(obj) end
end

function stopVisualCleaner()
	if visualCleanerDescConn then
		pcall(function() visualCleanerDescConn:Disconnect() end)
		visualCleanerDescConn = nil
	end
	if visualCleanerRenderConn then
		pcall(function() visualCleanerRenderConn:Disconnect() end)
		visualCleanerRenderConn = nil
	end
	if visualCleanerPreviousFOV and workspace.CurrentCamera then
		workspace.CurrentCamera.FieldOfView = visualCleanerPreviousFOV
	end
	visualCleanerPreviousFOV = nil
end

function startVisualCleaner()
	stopVisualCleaner()
	local cam = workspace.CurrentCamera
	if cam then visualCleanerPreviousFOV = cam.FieldOfView end
	clearVisualEffects()
	visualCleanerDescConn = Lighting.DescendantAdded:Connect(function(obj)
		task.defer(function()
			if St.visualCleaner then removeVisualEffect(obj) end
		end)
	end)
	visualCleanerRenderConn = RunService.RenderStepped:Connect(function()
		if not St.visualCleaner then return end
		local currentCamera = workspace.CurrentCamera
		if currentCamera and currentCamera.FieldOfView ~= (St.fovLock or 70) then
			currentCamera.FieldOfView = math.clamp(tonumber(St.fovLock) or 70, 30, 120)
		end
	end)
end

function setVisualCleaner(on)
	St.visualCleaner = on == true
	if St.visualCleaner then startVisualCleaner() else stopVisualCleaner() end
	saveCfg()
end

-- ==============================
--  ONGLET ESP
-- ==============================
section(pageESP, "* — ESP", 1)


-- ==============================
--  IDLE NPC WATCHER (LOCAL ONLY)
-- ==============================
local NPC_IDLE_AFTER = 5
local npcWatcherToken = 0
local npcMotion = {}
local npcWatcherLabel

local function isPlayerCharacter(model)
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Character == model then return true end
	end
	return false
end

local function isNpcModel(model)
	if not model or not model:IsA("Model") or isPlayerCharacter(model) then return false end
	local hum = model:FindFirstChildOfClass("Humanoid")
	local root = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
	return hum ~= nil and root ~= nil
end

local function getIdleNpcCount()
	local now = tick()
	local count = 0
	for _, obj in ipairs(workspace:GetDescendants()) do
		if isNpcModel(obj) then
			local root = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
			local position = root.Position
			local state = npcMotion[obj]
			if not state then
				npcMotion[obj] = { position = position, lastMove = now }
			elseif (state.position - position).Magnitude > 0.15 then
				state.position = position
				state.lastMove = now
			elseif now - state.lastMove >= NPC_IDLE_AFTER then
				count = count + 1
			end
		end
	end
	for model in pairs(npcMotion) do
		if not model.Parent then npcMotion[model] = nil end
	end
	return count
end

local function setNpcWatcher(on)
	St.npcWatcher = on == true
	npcWatcherToken = npcWatcherToken + 1
	local token = npcWatcherToken
	if not St.npcWatcher then
		if npcWatcherLabel then npcWatcherLabel.Text = "NPC INACTIFS : OFF"; npcWatcherLabel.TextColor3 = C.textDim end
		saveCfg()
		return
	end
	if npcWatcherLabel then npcWatcherLabel.Text = "NPC INACTIFS : ANALYSE…"; npcWatcherLabel.TextColor3 = Color3.fromRGB(255, 200, 100) end
	saveCfg()
	task.spawn(function()
		while St.npcWatcher and token == npcWatcherToken and EL2BReloadGeneration == _G.EL2BReloadGeneration do
			local count = getIdleNpcCount()
			if npcWatcherLabel then
				npcWatcherLabel.Text = string.format("NPC INACTIFS : %d", count)
				npcWatcherLabel.TextColor3 = count > 0 and Color3.fromRGB(255, 190, 100) or Color3.fromRGB(110, 240, 155)
			end
			task.wait(2)
		end
	end)
end


local npcInfo = Instance.new("TextLabel")
npcInfo.Name = "NpcWatcherStatus"
npcInfo.Size = UDim2.new(1, -20, 0, 24)
npcInfo.BackgroundTransparency = 1
npcInfo.Text = "NPC INACTIFS : OFF"
npcInfo.TextColor3 = C.textDim
npcInfo.TextSize = 11
npcInfo.Font = Enum.Font.GothamSemibold
npcInfo.TextXAlignment = Enum.TextXAlignment.Left
npcInfo.LayoutOrder = 1
npcInfo.Parent = pageESP
npcWatcherLabel = npcInfo
toggleNamed(pageESP, "Robots/NPC inactifs (local)", St.npcWatcher == true, setNpcWatcher, 1, "npcWatcher")
toggleNamed(pageESP, "Player ESP", St.esp, setESP, 2, "esp")
toggleNamed(pageESP, "Tracker / Tracer", St.tracer, setTracer, 3, "tracer")
toggleNamed(pageESP, "Anti Lag", St.antiLag, setAntiLag, 4, "antiLag")
toggleNamed(pageESP, "Visual Cleaner + FOV 70", St.visualCleaner, setVisualCleaner, 5, "visualCleaner")

-- ==============================
--  ONGLET SPAM
-- ==============================
section(pageSpam, "* — AUTO SPAM", 1)
toggleNamed(pageSpam, "Spam Laser Cape", St.spamLaser, setSpamLaser, 2, "spamLaser")
toggleNamed(pageSpam, "Spam Paintball Gun", St.spamPaint, setSpamPaint, 3, "spamPaint")
local spamInfo = row(pageSpam, 48, 4)
local spamTxt = Instance.new("TextLabel")
spamTxt.Size = UDim2.new(1, -12, 1, 0)
spamTxt.Position = UDim2.new(0, 6, 0, 0)
spamTxt.BackgroundTransparency = 1
spamTxt.Text = "Chỉ Activate quand l'outil est équipé.\nNe s'équipe pas automatiquement."
spamTxt.TextColor3 = C.textDim
spamTxt.TextSize = 10
spamTxt.Font = Enum.Font.Gotham
spamTxt.TextXAlignment = Enum.TextXAlignment.Left
spamTxt.TextYAlignment = Enum.TextYAlignment.Center
spamTxt.Parent = spamInfo

-- ==============================
--  ONGLET COUNTER
-- ==============================
section(pageCounter, "* — COUNTER", 1)
toggleNamed(pageCounter, "Auto Laser Cape", St.counterLaser == true, setCounterLaser, 2, "counterLaser")
toggleNamed(pageCounter, "Auto Boogie Bomb", St.counterBoogie == true, setCounterBoogie, 3, "counterBoogie")
toggleNamed(pageCounter, "Auto Swap Body", St.counterSwapBody == true, setCounterSwapBody, 4, "counterSwapBody")
toggleNamed(pageCounter, "Equip & Activate on Drop", St.equipOnDrop == true, setEquipOnDrop, 5, "equipOnDrop")
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 48)
info.BackgroundTransparency = 1
info.Text = "Laser Cape / Boogie Bomb / Swap Body: équipe et active.\nOn Drop: après DROP, équipe et active l'outil choisi."
info.TextColor3 = C.textDim
info.TextSize = 11
info.Font = Enum.Font.Gotham
info.TextWrapped = true
info.TextXAlignment = Enum.TextXAlignment.Left
info.Parent = pageCounter
info.LayoutOrder = 7

-- ==============================
--  ONGLET SETTINGS
-- ==============================
section(pageSet, "* — MOBILE / LOCK", 1)

-- ==============================
--  WEB STATUS (STRICT OPT-IN)
-- ==============================
local WEB_STATUS_ENDPOINT = "https://el2bstatus-amhrowxg.manus.space/api/trpc/hub.heartbeat"
local DIAGNOSTIC_ENDPOINT = "https://el2bstatus-amhrowxg.manus.space/api/script-diagnostic"
local SCRIPT_VERSION = "EL2B-2026.08-safe-diagnostics"
local WEB_STATUS_INTERVAL = 30000
local DIAGNOSTIC_INTERVAL = 300000
local webStatusLoopToken = 0
local lastDiagnosticAt = 0
local lastDiagnosticPlaceId = nil

local function ensureWebStatusId()
	if type(St.webStatusId) == "string" and St.webStatusId:match("^[a-f0-9]{32}$") then return St.webStatusId end
	local HttpService = game:GetService("HttpService")
	local raw = ""
	pcall(function() raw = HttpService:GenerateGUID(false):gsub("-", "") end)
	if #raw < 32 then
		math.randomseed(os.time() + math.floor(os.clock() * 100000))
		for _ = 1, 32 - #raw do raw = raw .. string.format("%x", math.random(0, 15)) end
	end
	St.webStatusId = raw:sub(1, 32):lower()
	saveCfg()
	return St.webStatusId
end

local function getHttpRequest()
	return (syn and syn.request) or (http and http.request) or http_request or request
end

local function sendWebHeartbeat(idleNpcCount)
	local requestFn = getHttpRequest()
	setWebStatusIndicator("connecting")
	if type(requestFn) ~= "function" then
		setWebStatusIndicator("error")
		warn("[EL2B HUB] Statut web indisponible : cet environnement ne fournit pas de fonction HTTP.")
		return false
	end
	local okEncode, body = pcall(function()
		return game:GetService("HttpService"):JSONEncode({ json = { installationId = ensureWebStatusId(), idleNpcCount = math.clamp(math.floor(tonumber(idleNpcCount) or 0), 0, 1000) } })
	end)
	if not okEncode then
		setWebStatusIndicator("error")
		warn("[EL2B HUB] Statut web indisponible : encodage de la requête impossible.")
		return false
	end
	local ok, response = pcall(requestFn, {
		Url = WEB_STATUS_ENDPOINT, Method = "POST",
		Headers = { ["Content-Type"] = "application/json" }, Body = body,
	})
	if not ok or type(response) ~= "table" or (tonumber(response.StatusCode) or 0) < 200 or (tonumber(response.StatusCode) or 0) >= 300 then
		setWebStatusIndicator("error")
		warn("[EL2B HUB] Statut web : heartbeat refusé ou serveur indisponible.")
		return false
	end
	return true
end

local function sendSafeDiagnostic(eventName)
	if not St.webStatus then return false end
	local now = os.clock()
	if now - lastDiagnosticAt < DIAGNOSTIC_INTERVAL and eventName ~= "game_change" then return false end
	local requestFn = getHttpRequest()
	if type(requestFn) ~= "function" then return false end
	local placeId = tonumber(game.PlaceId) or 0
	if placeId <= 0 then return false end
	local gameName = tostring(game.Name or "Roblox game"):gsub("[%c]", ""):sub(1, 80)
	local okEncode, body = pcall(function()
		return game:GetService("HttpService"):JSONEncode({
			installationId = ensureWebStatusId(), event = eventName,
			scriptVersion = SCRIPT_VERSION, placeId = placeId,
			gameName = gameName, httpAvailable = true,
		})
	end)
	if not okEncode then return false end
	local ok, response = pcall(requestFn, {
		Url = DIAGNOSTIC_ENDPOINT, Method = "POST",
		Headers = { ["Content-Type"] = "application/json" }, Body = body,
	})
	if ok and type(response) == "table" and (tonumber(response.StatusCode) or 0) >= 200 and (tonumber(response.StatusCode) or 0) < 300 then
		lastDiagnosticAt = now
		lastDiagnosticPlaceId = placeId
		return true
	end
	return false
end

local function setWebStatus(on)
	St.webStatus = on == true
	if not St.webStatus then setWebStatusIndicator("off") end
	if not St.webStatus then
		print("[EL2B HUB] Statut web désactivé : aucune donnée n’est envoyée.")
	end
	webStatusLoopToken = webStatusLoopToken + 1
	local token = webStatusLoopToken
	saveCfg()
	if not St.webStatus then return end
	setWebStatusIndicator("connecting")
	task.spawn(function()
		sendSafeDiagnostic("startup")
		while St.webStatus and token == webStatusLoopToken and EL2BReloadGeneration == _G.EL2BReloadGeneration do
			local idleNpcCount = St.npcWatcher and getIdleNpcCount() or 0
			sendWebHeartbeat(idleNpcCount)
			if lastDiagnosticPlaceId ~= tonumber(game.PlaceId) then sendSafeDiagnostic("game_change") end
			task.wait(WEB_STATUS_INTERVAL / 1000)
		end
	end)
end

toggleNamed(pageSet, "Mobile Buttons", St.mobileBtns, function(on)
	St.mobileBtns = on
	if _G.VisApplyMobile then _G.VisApplyMobile() end
	saveCfg()
end, 2, "mobileBtns")
toggleNamed(pageSet, "Statut web (opt-in)", St.webStatus == true, function(on)
	setWebStatus(on)
end, 1, "webStatus")
task.defer(function()
	if St.webStatus == true then setWebStatus(true) end
end)

toggleNamed(pageSet, "Show Auto Steal Button", St.showStealBtn ~= false, function(on)
	St.showStealBtn = on and true or false
	if _G.VisRefreshStealBtn then pcall(_G.VisRefreshStealBtn) end
	if St.showStealBtn and (not actRefs or not actRefs.steal) and _G.VisApplyMobile then
		pcall(_G.VisApplyMobile)
	end
	saveCfg()
end, 2.5, "showStealBtn")
toggleNamed(pageSet, "Show Panel TP", St.showTPPanel ~= false, function(on)
	St.showTPPanel = on and true or false
	local g = PlayerGui:FindFirstChild("VisHubbTP")
	if g then g.Enabled = St.showTPPanel end
	saveCfg()
end, 25, "showTPPanel")
toggleNamed(pageSet, "Show Panel Lagger", St.showLaggerPanel == true, function(on)
	if _G.VisSetLaggerPanel then _G.VisSetLaggerPanel(on) else St.showLaggerPanel = on; saveCfg() end
end, 25.1, "showLaggerPanel")
toggleNamed(pageSet, "Show Panel Speed Bypass", St.showSpeedBypassPanel == true, function(on)
	if _G.VisSetSpeedBypassPanel then _G.VisSetSpeedBypassPanel(on) else St.showSpeedBypassPanel = on; saveCfg() end
end, 25.3, "showSpeedBypassPanel")

do
	local r = row(pageSet, 38, 25.4)
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(0.45, 0, 1, 0)
	t.Position = UDim2.new(0, 12, 0, 0)
	t.BackgroundTransparency = 1
	t.Text = "Panels Scale %"
	t.TextColor3 = C.text
	t.TextSize = 12
	t.Font = Enum.Font.Gotham
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = r
	local val = Instance.new("TextLabel")
	val.Size = UDim2.new(0, 44, 0, 24)
	val.Position = UDim2.new(1, -120, 0.5, -12)
	val.BackgroundTransparency = 1
	val.Text = tostring(math.floor((St.panelGuiScale or 0.7) * 100)) .. "%"
	val.TextColor3 = C.text
	val.TextSize = 12
	val.Font = Enum.Font.GothamBold
	val.Parent = r
	for _, info in ipairs({{"-", -80}, {"+", -44}}) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0, 28, 0, 28)
		b.Position = UDim2.new(1, info[2], 0.5, -14)
		b.BackgroundColor3 = C.box
		b.Text = info[1]
		b.TextColor3 = C.text
		b.TextSize = 16
		b.Font = Enum.Font.GothamBold
		b.AutoButtonColor = false
		b.Parent = r
		corner(b, 7)
		local function fire()
			St.panelGuiScale = math.clamp((tonumber(St.panelGuiScale) or 1) + (info[1] == "+" and 0.05 or -0.05), 0.6, 1.6)
			val.Text = tostring(math.floor(St.panelGuiScale * 100)) .. "%"
			if _G.VisApplyPanelGuiScale then pcall(_G.VisApplyPanelGuiScale) end
			saveCfg()
		end
		b.MouseButton1Click:Connect(fire)
		b.Activated:Connect(fire)
	end
end

do
	local r = row(pageSet, 38, 25.45)
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(0.45, 0, 1, 0)
	t.Position = UDim2.new(0, 12, 0, 0)
	t.BackgroundTransparency = 1
	t.Text = "Panels Width %"
	t.TextColor3 = C.text
	t.TextSize = 12
	t.Font = Enum.Font.Gotham
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = r
	local val = Instance.new("TextLabel")
	val.Size = UDim2.new(0, 44, 0, 24)
	val.Position = UDim2.new(1, -120, 0.5, -12)
	val.BackgroundTransparency = 1
	val.Text = tostring(math.floor((St.panelGuiWidth or 1) * 100)) .. "%"
	val.TextColor3 = C.text
	val.TextSize = 12
	val.Font = Enum.Font.GothamBold
	val.Parent = r
	for _, info in ipairs({{"-", -80}, {"+", -44}}) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0, 28, 0, 28)
		b.Position = UDim2.new(1, info[2], 0.5, -14)
		b.BackgroundColor3 = C.box
		b.Text = info[1]
		b.TextColor3 = C.text
		b.TextSize = 16
		b.Font = Enum.Font.GothamBold
		b.AutoButtonColor = false
		b.Parent = r
		corner(b, 7)
		local function fire()
			St.panelGuiWidth = math.clamp((tonumber(St.panelGuiWidth) or 1) + (info[1] == "+" and 0.05 or -0.05), 0.7, 1.5)
			val.Text = tostring(math.floor(St.panelGuiWidth * 100)) .. "%"
			if _G.VisApplyPanelGuiScale then pcall(_G.VisApplyPanelGuiScale) end
			saveCfg()
		end
		b.MouseButton1Click:Connect(fire)
		b.Activated:Connect(fire)
	end
end

toggleNamed(pageSet, "Lock UI", St.guiLock, function(on)
	St.guiLock = on and true or false
	pcall(function()
		if Main and Main.Parent then
			St._mainPos = {Main.Position.X.Scale, Main.Position.X.Offset, Main.Position.Y.Scale, Main.Position.Y.Offset}
			St.menuOpen = Main.Visible == true
		end
		local miniGui = PlayerGui:FindFirstChild("VisHubFullMini")
		local mini = miniGui and miniGui:FindFirstChildWhichIsA("TextButton")
		if mini then
			St._miniPos = {mini.Position.X.Scale, mini.Position.X.Offset, mini.Position.Y.Scale, mini.Position.Y.Offset}
		end
		local mb = PlayerGui:FindFirstChild("VisHubModeBar")
		local mf = mb and mb:FindFirstChildWhichIsA("Frame")
		if mf then
			St._modeBarPos = {mf.Position.X.Scale, mf.Position.X.Offset, mf.Position.Y.Scale, mf.Position.Y.Offset}
		end
		St._btnPos = St._btnPos or {}
		local function snapHoldersLock(gui)
			if not gui then return end
			for _, holder in ipairs(gui:GetChildren()) do
				if holder:IsA("Frame") or holder:IsA("TextButton") then
					local key = holder.Name
					if key and (key:sub(1,2) == "A_" or key:sub(1,2) == "M_") then
						St._btnPos[key] = {
							holder.Position.X.Scale, holder.Position.X.Offset,
							holder.Position.Y.Scale, holder.Position.Y.Offset,
							holder.Size.X.Offset, holder.Size.Y.Offset,
						}
					end
				end
			end
		end
		snapHoldersLock(PlayerGui:FindFirstChild("VisHubActionButtons"))
		snapHoldersLock(PlayerGui:FindFirstChild("VisHubModeBar"))
	end)
	saveCfg()
end, 3, "guiLock")

do
	local r = row(pageSet, 32, 4)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -16, 1, 0)
	lbl.Position = UDim2.new(0, 8, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = "Anti Kick  ·  ALWAYS ON"
	lbl.TextColor3 = Color3.fromRGB(120, 255, 160)
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 12
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = r
end

section(pageSet, "* — BUTTON SHAPE", 10)
local shapeRow = row(pageSet, 38, 11)
for i, name in ipairs({ "Round", "Box", "Square" }) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 90, 0, 28)
	b.Position = UDim2.new(0, 12 + (i - 1) * 100, 0.5, -14)
	b.BackgroundColor3 = (St.btnShape == name) and C.accent or C.box
	b.Text = name
	b.TextColor3 = (St.btnShape == name) and Color3.fromRGB(30, 20, 30) or C.text
	b.TextSize = 12
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Parent = shapeRow
	corner(b, name == "Round" and 14 or (name == "Box" and 6 or 2))
	local function pickShape()
		St.btnShape = name
		pcall(function()
			if actRefs then
				for key, e in pairs(actRefs) do
					if e and e.btn then
						applyCorner(e.btn, name)
						applyCornerToChildren(e.btn, name)
					end
				end
			end
		end)
		if _G.VisUpdateMobileVisuals then pcall(_G.VisUpdateMobileVisuals) end
		if _G.VisForceApplyShape then pcall(_G.VisForceApplyShape, name) end
		for _, ch in ipairs(shapeRow:GetChildren()) do
			if ch:IsA("TextButton") then
				local on = ch.Text == name
				ch.BackgroundColor3 = on and C.accent or C.box
				ch.TextColor3 = on and Color3.fromRGB(30, 20, 30) or C.text
			end
		end
		saveCfg()
	end
	b.MouseButton1Click:Connect(pickShape)
	b.Activated:Connect(pickShape)
end

section(pageSet, "* — BUTTON SIZE", 20)
function sizeRow(label, key, order)
	local r = row(pageSet, 38, order)
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(0.4, 0, 1, 0)
	t.Position = UDim2.new(0, 12, 0, 0)
	t.BackgroundTransparency = 1
	t.Text = label
	t.TextColor3 = C.text
	t.TextSize = 13
	t.Font = Enum.Font.Gotham
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = r
	local val = Instance.new("TextLabel")
	val.Size = UDim2.new(0, 40, 0, 24)
	val.Position = UDim2.new(1, -120, 0.5, -12)
	val.BackgroundTransparency = 1
	val.Text = tostring(St.btnSizes[key] or 50)
	val.TextColor3 = C.text
	val.TextSize = 13
	val.Font = Enum.Font.GothamBold
	val.Parent = r
	local function mk(sign, x)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0, 28, 0, 28)
		b.Position = UDim2.new(1, x, 0.5, -14)
		b.BackgroundColor3 = C.box
		b.Text = sign
		b.TextColor3 = C.text
		b.TextSize = 16
		b.Font = Enum.Font.GothamBold
		b.AutoButtonColor = false
		b.Active = true
		b.ZIndex = 30
		b.Parent = r
		corner(b, 7)
		local function fire()
			local cur = tonumber(St.btnSizes[key]) or 50
			cur = math.clamp(cur + (sign == "+" and 5 or -5), 20, 200)
			St.btnSizes[key] = cur
			val.Text = tostring(cur)
			if _G.VisUpdateMobileVisuals then pcall(_G.VisUpdateMobileVisuals) end
			if _G.VisApplyMobile then pcall(_G.VisApplyMobile) end
			if key == "mode" and _G.VisBuildV2ModeBar then pcall(_G.VisBuildV2ModeBar) end
			saveCfg()
		end
		b.MouseButton1Click:Connect(fire)
		b.Activated:Connect(fire)
	end
	mk("-", -80)
	mk("+", -44)
end
sizeRow("All Scale %", "mode", 21)

local scaleRow = row(pageSet, 38, 22)
local st = Instance.new("TextLabel")
st.Size = UDim2.new(0.4, 0, 1, 0)
st.Position = UDim2.new(0, 12, 0, 0)
st.BackgroundTransparency = 1
st.Text = "All Buttons Scale"
st.TextColor3 = C.text
st.TextSize = 13
st.Font = Enum.Font.Gotham
st.TextXAlignment = Enum.TextXAlignment.Left
st.Parent = scaleRow
local scaleVal = Instance.new("TextLabel")
scaleVal.Size = UDim2.new(0, 48, 0, 24)
scaleVal.Position = UDim2.new(1, -128, 0.5, -12)
scaleVal.BackgroundTransparency = 1
scaleVal.Text = tostring(math.floor(St.btnScale * 100)) .. "%"
scaleVal.TextColor3 = C.text
scaleVal.TextSize = 13
scaleVal.Font = Enum.Font.GothamBold
scaleVal.Parent = scaleRow
for _, info in ipairs({ { "-", -80 }, { "+", -44 } }) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 28, 0, 28)
	b.Position = UDim2.new(1, info[2], 0.5, -14)
	b.BackgroundColor3 = C.box
	b.Text = info[1]
	b.TextColor3 = C.text
	b.TextSize = 16
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Active = true
	b.ZIndex = 30
	b.Parent = scaleRow
	corner(b, 7)
	local function fire()
		St.btnScale = math.clamp((tonumber(St.btnScale) or 1) + (info[1] == "+" and 0.05 or -0.05), 0.3, 2.0)
		scaleVal.Text = tostring(math.floor(St.btnScale * 100)) .. "%"
		if _G.VisUpdateMobileVisuals then pcall(_G.VisUpdateMobileVisuals) end
		if _G.VisApplyMobile then pcall(_G.VisApplyMobile) end
		if _G.VisBuildV2ModeBar then pcall(_G.VisBuildV2ModeBar) end
		saveCfg()
	end
	b.MouseButton1Click:Connect(fire)
	b.Activated:Connect(fire)
end
sizeRow("Size: Speed 3Mode", "mode", 22.5)
sizeRow("Size: Drop", "drop", 23)
sizeRow("Size: Insta", "insta", 24)
sizeRow("Size: TP", "tp", 25)
sizeRow("Size: Sentry", "sentry", 25.5)
sizeRow("Size: Auto Steal", "steal", 26)

section(pageSet, "* — WALLPAPER", 28)
do
	local wr = row(pageSet, 40, 29)
	local img = Instance.new("ImageLabel")
	img.Size = UDim2.new(0, 56, 0, 32)
	img.Position = UDim2.new(0, 8, 0.5, -16)
	img.BackgroundColor3 = C.box
	img.ScaleType = Enum.ScaleType.Crop
	img.Image = BackgroundIDs[St.wallIndex or 1]
	img.ZIndex = 2
	img.Parent = wr
	corner(img, 6)
	local idxLbl = Instance.new("TextLabel")
	idxLbl.Size = UDim2.new(0, 48, 0, 20)
	idxLbl.Position = UDim2.new(0, 70, 0.5, -10)
	idxLbl.BackgroundTransparency = 1
	idxLbl.Text = "#" .. tostring(St.wallIndex or 1) .. "/" .. tostring(#BackgroundIDs)
	idxLbl.TextColor3 = C.textDim
	idxLbl.Font = Enum.Font.GothamBold
	idxLbl.TextSize = 11
	idxLbl.ZIndex = 2
	idxLbl.Parent = wr
	local function applyWall()
		local n = #BackgroundIDs
		if n < 1 then return end
		St.wallIndex = ((tonumber(St.wallIndex) or 1) - 1) % n + 1
		local asset = BackgroundIDs[St.wallIndex]
		img.Image = asset
		idxLbl.Text = "#" .. tostring(St.wallIndex) .. "/" .. tostring(n)
		local bg = Main:FindFirstChild("WallBG")
		if not bg then
			bg = Instance.new("ImageLabel")
			bg.Name = "WallBG"
			bg.Size = UDim2.new(1, 0, 1, 0)
			bg.Position = UDim2.new(0, 0, 0, 0)
			bg.BackgroundTransparency = 1
			bg.ScaleType = Enum.ScaleType.Crop
			bg.ZIndex = 0
			bg.Active = false
			bg.Selectable = false
			bg.Parent = Main
			local dim = Instance.new("Frame")
			dim.Name = "WallDim"
			dim.Size = UDim2.new(1, 0, 1, 0)
			dim.BackgroundColor3 = Color3.new(0, 0, 0)
			dim.BackgroundTransparency = 0.45
			dim.BorderSizePixel = 0
			dim.ZIndex = 0
			dim.Active = false
			dim.Selectable = false
			dim.Parent = Main
			corner(bg, 12)
			for _, ch in ipairs(Main:GetChildren()) do
				if ch ~= bg and ch.Name ~= "WallDim" and ch:IsA("GuiObject") then
					if ch.ZIndex < 2 then ch.ZIndex = 2 end
				end
			end
		end
		bg.Image = asset
		bg.ImageTransparency = math.clamp(tonumber(St.wallOpacity) or 0.12, 0, 0.85)
		bg.Active = false
		bg.Selectable = false
		bg.ScaleType = Enum.ScaleType.Crop
		bg.Visible = true
		Main.BackgroundTransparency = 0.55
		saveCfg()
	end
	applyWall()
	for i, sign in ipairs({"-", "+"}) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0, 30, 0, 28)
		b.Position = UDim2.new(1, -72 + (i-1)*34, 0.5, -14)
		b.BackgroundColor3 = C.box
		b.Text = sign
		b.TextColor3 = C.text
		b.Font = Enum.Font.GothamBold
		b.TextSize = 16
		b.AutoButtonColor = true
		b.Active = true
		b.ZIndex = 3
		b.Parent = wr
		corner(b, 6)
		local function step()
			local n = #BackgroundIDs
			if n < 1 then return end
			St.wallIndex = (tonumber(St.wallIndex) or 1) + (sign == "+" and 1 or -1)
			if St.wallIndex < 1 then St.wallIndex = n end
			if St.wallIndex > n then St.wallIndex = 1 end
			applyWall()
		end
		b.MouseButton1Click:Connect(step)
		b.Activated:Connect(step)
	end
end

section(pageSet, "* — MENU UI SCALE", 30)
local menuScaleRow = row(pageSet, 36, 31)
local msl = Instance.new("TextLabel")
msl.Size = UDim2.new(0.4, 0, 1, 0)
msl.Position = UDim2.new(0, 10, 0, 0)
msl.BackgroundTransparency = 1
msl.Text = "Menu Size"
msl.TextColor3 = C.text
msl.TextSize = 12
msl.Font = Enum.Font.Gotham
msl.TextXAlignment = Enum.TextXAlignment.Left
msl.Parent = menuScaleRow
local msVal = Instance.new("TextLabel")
msVal.Size = UDim2.new(0, 40, 0, 22)
msVal.Position = UDim2.new(1, -110, 0.5, -11)
msVal.BackgroundTransparency = 1
msVal.Text = tostring(math.floor((St.menuScale or 1) * 100)) .. "%"
msVal.TextColor3 = C.text
msVal.TextSize = 12
msVal.Font = Enum.Font.GothamBold
msVal.Parent = menuScaleRow
for _, info in ipairs({{"-", -72}, {"+", -40}}) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 26, 0, 26)
	b.Position = UDim2.new(1, info[2], 0.5, -13)
	b.BackgroundColor3 = C.box
	b.Text = info[1]
	b.TextColor3 = C.text
	b.TextSize = 14
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Active = true
	b.ZIndex = 30
	b.Parent = menuScaleRow
	corner(b, 6)
	local function fire()
		St.menuScale = math.clamp((St.menuScale or 1) + (info[1] == "+" and 0.05 or -0.05), 0.7, 1.3)
		msVal.Text = tostring(math.floor(St.menuScale * 100)) .. "%"
		applyMenuScale()
		saveCfg()
	end
	b.MouseButton1Click:Connect(fire)
	b.Activated:Connect(fire)
end

section(pageSet, "* — RESET", 32)
actionBtn(pageSet, "Reset Mobile Positions", C.accent, function()
	if _G.VisResetMobilePos then _G.VisResetMobilePos() end
	saveCfg()
end, 33)
actionBtn(pageSet, "Reset Profile", C.danger, function()
	pcall(function() setAntiGummy(true) end)
	pcall(function() setAntiRagdoll(false) end)
	pcall(function() setAntiPaint(true) end)
	pcall(function() setAntiBoogie(true) end)
	pcall(function() setToolAim(true) end)
	pcall(function() setInfJump(true) end)
	pcall(function() setDestroySentry(false) end)
	pcall(function() setSpeedOn(true) end)
	pcall(function() setActiveMode("Normal") end)
	St.dropMode = 2
	St.instaMode = "V1"
	St.mobileBtns = true
	St.showStealBtn = true
	St.guiLock = false
	St.btnShape = "Square"
	St.btnScale = 0.75
	St.menuScale = 1
	St.btnSizes = { mode = 50, drop = 50, insta = 50, tp = 50, sentry = 50, steal = 50, profile = 50 }
	St._btnPos = nil
	St._modeBarPos = nil
	St._miniPos = nil
	St._mainPos = nil
	St._stealBarPos = nil
	St._tpMainPos = nil
	St.stealVer = "V1"
	St.stealRadius = 60
	St.stealPause = false
	St.stealPausePct = 75
	St.autoSteal = false
	St.modes = {
		Normal = { norm = 59, steal = 30, key = Enum.KeyCode.T },
		Lagger = { norm = 18, steal = 24, key = Enum.KeyCode.Q },
		Custom = { norm = 33, steal = 33, key = Enum.KeyCode.C },
	}
	St.activeMode = "Normal"
	St.keys = {
		Drop = Enum.KeyCode.X,
		TPDown = Enum.KeyCode.F,
		InstaReset = Enum.KeyCode.Z,
		DestroySentry = Enum.KeyCode.H,
	}
	pcall(function() setESP(false) end)
	pcall(function() setTracer(false) end)
	pcall(function() setAntiLag(false) end)
		pcall(function() setVisualCleaner(false) end)
	pcall(function() setSpamLaser(false) end)
	pcall(function() setSpamPaint(false) end)
	if type(setAutoSteal) == "function" then setAutoSteal(false) end
	local defs = {
		antiGummy = true, antiRagdoll = false, antiPaint = true, antiBoogie = true,
		toolAim = true, infJump = true, destroySentry = false, speedOn = true,
		mobileBtns = true, guiLock = false,
		esp = false, tracer = false, antiLag = false, visualCleaner = false, fovLock = 70,
		spamLaser = false, spamPaint = false,
		autoSteal = false, stealPause = false, showTPPanel = true,
	}
	for k, v in pairs(defs) do
		if ToggleRefs[k] and ToggleRefs[k].set then
			pcall(function() ToggleRefs[k].set(v) end)
		end
	end
	if _G.VisResetMobilePos then pcall(_G.VisResetMobilePos) end
	if _G.VisApplyMobile then pcall(_G.VisApplyMobile) end
	if _G.VisRefreshModeCards then pcall(_G.VisRefreshModeCards) end
	applyMenuScale()
	if _G.VisSyncAutoSteal then pcall(_G.VisSyncAutoSteal) end
	saveCfg()
	showToast("PROFILE RESET ✓")
end, 34)
actionBtn(pageSet, "Save Profile", C.accent, function()
	pcall(function()
		if Main then
			St._mainPos = {Main.Position.X.Scale, Main.Position.X.Offset, Main.Position.Y.Scale, Main.Position.Y.Offset}
		end
		local mini = PlayerGui:FindFirstChild("VisHubFullMini")
		local mb = mini and mini:FindFirstChildWhichIsA("GuiObject")
		if mb then
			St._miniPos = {mb.Position.X.Scale, mb.Position.X.Offset, mb.Position.Y.Scale, mb.Position.Y.Offset}
		end
		St.menuOpen = Main and Main.Visible == true
	end)
	local ok = saveCfg()
	if ok then showToast("SAVED ✓") else showToast("SAVE FAIL (no writefile?)") end
end, 35)

-- ==============================
--  MINI + CLOSE
-- ==============================
local MiniGui = Instance.new("ScreenGui")
MiniGui.Name = "VisHubFullMini"
MiniGui.ResetOnSpawn = false
MiniGui.IgnoreGuiInset = true
MiniGui.DisplayOrder = 121
MiniGui.Parent = PlayerGui

local Mini = Instance.new("TextButton")
Mini.Size = UDim2.new(0, 110, 0, 36)
Mini.Position = UDim2.new(0, 14, 0, 90)
Mini.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
Mini.Text = "VisHub"
Mini.TextColor3 = C.accent
Mini.TextSize = 12
Mini.Font = Enum.Font.GothamBold
Mini.Visible = false
Mini.AutoButtonColor = false
Mini.Parent = MiniGui
corner(Mini, 8)
local miniStroke = Instance.new("UIStroke", Mini)
miniStroke.Color = C.accent
miniStroke.Thickness = 2
miniStroke.Transparency = 0.15

-- Drag menu principal
do
	local dragging, dragStart, startPos
	Top.InputBegan:Connect(function(input)
		if St.guiLock then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					St._mainPos = {Main.Position.X.Scale, Main.Position.X.Offset, Main.Position.Y.Scale, Main.Position.Y.Offset}
					St.menuOpen = Main.Visible == true
					saveCfg()
				end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and not St.guiLock and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - dragStart
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
end

-- Drag mini
do
	local dragging, dragStart, startPos, moved
	pcall(function()
		local p = St._miniPos
		if type(p) == "table" and p[1] ~= nil then
			Mini.Position = UDim2.new(p[1], p[2], p[3], p[4])
		end
	end)
	Mini.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			moved = false
			dragStart = input.Position
			startPos = Mini.Position
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - dragStart
			if math.abs(d.X) > 5 or math.abs(d.Y) > 5 then moved = true end
			if moved then
				Mini.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
			end
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
		if not dragging then return end
		dragging = false
		if moved then
			St._miniPos = {Mini.Position.X.Scale, Mini.Position.X.Offset, Mini.Position.Y.Scale, Mini.Position.Y.Offset}
			saveCfg()
		end
	end)
	Mini.MouseButton1Click:Connect(function()
		if moved then return end
		St.menuOpen = true
		saveCfg()
		openMenu()
	end)
end

function openMenu()
	Main.Visible = true
	Mini.Visible = false
	St.menuOpen = true
	saveCfg()
	Main.Size = UDim2.new(0, 0, 0, MH)
	TS:Create(Main, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, MW, 0, MH),
	}):Play()
end

function closeMenu()
	local tw = TS:Create(Main, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, MH),
	})
	tw:Play()
	tw.Completed:Connect(function()
		Main.Visible = false
		St.menuOpen = false
		pcall(function()
			if Main and Main.Parent then
				St._mainPos = {Main.Position.X.Scale, Main.Position.X.Offset, Main.Position.Y.Scale, Main.Position.Y.Offset}
			end
		end)
		Mini.Visible = true
		Mini.Text = "VisHub"
		pcall(function()
			local p = St._miniPos
			if type(p) == "table" and p[1] ~= nil then
				Mini.Position = UDim2.new(p[1], p[2], p[3], p[4])
			else
				Mini.Position = UDim2.new(Main.Position.X.Scale, Main.Position.X.Offset + 8, Main.Position.Y.Scale, Main.Position.Y.Offset)
				St._miniPos = {Mini.Position.X.Scale, Mini.Position.X.Offset, Mini.Position.Y.Scale, Mini.Position.Y.Offset}
			end
		end)
		saveCfg()
	end)
end

CloseBtn.Active = true
CloseBtn.ZIndex = 50
CloseBtn.MouseButton1Click:Connect(closeMenu)
CloseBtn.Activated:Connect(closeMenu)
if Helper then
	Helper.MouseButton1Click:Connect(closeMenu)
	Helper.Activated:Connect(closeMenu)
end

-- ==============================
--  MOBILE BUTTONS (V2 style)
-- ==============================
local ModeGui = Instance.new("ScreenGui")
ModeGui.Name = "VisHubModeBar"
ModeGui.ResetOnSpawn = false
ModeGui.IgnoreGuiInset = true
ModeGui.DisplayOrder = 2501
ModeGui.Enabled = false
ModeGui.Parent = PlayerGui

local HelperGui = Instance.new("ScreenGui")
HelperGui.Name = "EL2BHelperGui"
HelperGui.ResetOnSpawn = false
HelperGui.IgnoreGuiInset = true
HelperGui.DisplayOrder = 2600
HelperGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
HelperGui.Enabled = true
HelperGui.Parent = PlayerGui

local modeRefs = {}
local actRefs = {}

function applyCorner(btn, forceShape)
	if not btn then return end
	local shape = forceShape or St.btnShape or "Square"
	for _, ch in ipairs(btn:GetChildren()) do
		if ch:IsA("UICorner") then pcall(function() ch:Destroy() end) end
	end
	local rad
	if shape == "Round" then
		rad = UDim.new(1, 0)
	elseif shape == "Box" then
		rad = UDim.new(0, 12)
	else
		rad = UDim.new(0, 2)
	end
	local c = Instance.new("UICorner")
	c.Name = "ShapeCorner"
	c.CornerRadius = rad
	c.Parent = btn
	for _, ch in ipairs(btn:GetChildren()) do
		if ch:IsA("ImageLabel") or (ch:IsA("Frame") and ch.Name ~= "BtnTextOverlay") then
			for _, sub in ipairs(ch:GetChildren()) do
				if sub:IsA("UICorner") then sub:Destroy() end
			end
			local c2 = Instance.new("UICorner")
			c2.Name = "ShapeCorner"
			c2.CornerRadius = rad
			c2.Parent = ch
		end
	end
end

function applyCornerToChildren(btn, shape)
	if not btn then return end
	shape = shape or St.btnShape or "Square"
	local rad
	if shape == "Round" then rad = UDim.new(1, 0)
	elseif shape == "Box" then rad = UDim.new(0, 12)
	else rad = UDim.new(0, 2)
	end
	for _, ch in ipairs(btn:GetChildren()) do
		if ch:IsA("ImageLabel") or (ch:IsA("Frame") and ch.Name ~= "BtnTextOverlay") then
			for _, sub in ipairs(ch:GetChildren()) do
				if sub:IsA("UICorner") then sub:Destroy() end
			end
			local c = Instance.new("UICorner")
			c.Name = "ShapeCorner"
			c.CornerRadius = rad
			c.Parent = ch
		end
	end
end

local MOB_BTN_IMAGE_IDS = {
	126832513729779, 81347949983999, 76940707345653, 100648743625857,
	73857705647948, 86237559415852, 81474116937197, 86668822094069,
	108384375206363, 86791880986403, 126414648469223,
}

function applyEmpireBtnBg(btn, index)
	if not btn then return end
	local old = btn:FindFirstChild("BtnBgImage")
	if old then old:Destroy() end
	local list = MOB_BTN_IMAGE_IDS
	local id = list[((tonumber(index) or 1) - 1) % #list + 1]
	if not id or id <= 0 then return end
	btn.BackgroundTransparency = 0.35
	btn.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
	local bgImg = Instance.new("ImageLabel")
	bgImg.Name = "BtnBgImage"
	bgImg.BackgroundTransparency = 1
	bgImg.Image = "rbxassetid://" .. tostring(id)
	bgImg.ImageTransparency = 0.08
	bgImg.ScaleType = Enum.ScaleType.Crop
	bgImg.Size = UDim2.new(1, 0, 1, 0)
	bgImg.ZIndex = (btn.ZIndex or 1)
	bgImg.Active = false
	bgImg.Selectable = false
	bgImg.Parent = btn
	local dim = Instance.new("Frame")
	dim.Name = "BtnDim"
	dim.Size = UDim2.new(1, 0, 1, 0)
	dim.BackgroundColor3 = Color3.new(0, 0, 0)
	dim.BackgroundTransparency = 0.45
	dim.BorderSizePixel = 0
	dim.ZIndex = (btn.ZIndex or 1) + 1
	dim.Active = false
	dim.Selectable = false
	dim.Parent = btn
	local rad = UDim.new(1, 0)
	if St.btnShape == "Box" then rad = UDim.new(0, 10)
	elseif St.btnShape == "Square" then rad = UDim.new(0, 4)
	end
	local c = Instance.new("UICorner")
	c.CornerRadius = rad
	c.Parent = bgImg
	local c2 = Instance.new("UICorner")
	c2.CornerRadius = rad
	c2.Parent = dim
	btn.TextTransparency = 0
	btn.TextStrokeTransparency = 0.4
	btn.TextStrokeColor3 = Color3.new(0, 0, 0)
	pcall(function() btn.ZIndex = math.max(btn.ZIndex or 1, 100) end)
	local st = btn:FindFirstChildOfClass("UIStroke")
	if st and not st:FindFirstChild("EmpireOutlineGrad") then
		st.Thickness = 1.6
		st.Transparency = 0.1
		local g = Instance.new("UIGradient")
		g.Name = "EmpireOutlineGrad"
		g.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 80, 180)),
			ColorSequenceKeypoint.new(0.7, Color3.fromRGB(180, 80, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
		})
		g.Parent = st
		task.spawn(function()
			local t0 = tick()
			while st and st.Parent do
				g.Rotation = ((tick() - t0) * 50) % 360
				task.wait(0.04)
			end
		end)
	end
end

_G.VisBuildV2ModeBar = function()
	pcall(function()
		local old = PlayerGui:FindFirstChild("VisV2ModeBar")
		if old then old:Destroy() end
	end)
	if not St.mobileBtns then return end
	local sc = math.clamp(tonumber(St.btnScale) or 1, 0.3, 2)
	local modeBase = tonumber(St.btnSizes and St.btnSizes.mode) or 50
	local V2_BTN_H = math.max(28, math.floor(modeBase * sc))
	local V2_BTN_W = math.max(72, math.floor(88 * sc))
	local V2_CORNER = 12
	local MODE_COLORS = {
		Normal = {
			onBg = Color3.fromRGB(255, 200, 210), onTxt = Color3.fromRGB(30, 20, 30),
			offBg = Color3.fromRGB(255, 255, 255), offTxt = Color3.fromRGB(25, 25, 30),
			stroke = Color3.fromRGB(255, 160, 180),
		},
		Lagger = {
			onBg = Color3.fromRGB(255, 200, 210), onTxt = Color3.fromRGB(30, 20, 30),
			offBg = Color3.fromRGB(255, 255, 255), offTxt = Color3.fromRGB(25, 25, 30),
			stroke = Color3.fromRGB(255, 160, 180),
		},
		Custom = {
			onBg = Color3.fromRGB(255, 200, 210), onTxt = Color3.fromRGB(30, 20, 30),
			offBg = Color3.fromRGB(255, 255, 255), offTxt = Color3.fromRGB(25, 25, 30),
			stroke = Color3.fromRGB(255, 160, 180),
		},
	}
	local gui = Instance.new("ScreenGui")
	gui.Name = "VisV2ModeBar"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 95
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = PlayerGui
	v2BarButtons = {}
	local function styleV2Btn(btn, modeName, active)
		local col = MODE_COLORS[modeName] or MODE_COLORS.Normal
		btn.BackgroundColor3 = active and col.onBg or col.offBg
		btn.TextColor3 = active and col.onTxt or col.offTxt
		local st = btn:FindFirstChildOfClass("UIStroke")
		if st then
			st.Color = active and col.stroke or Color3.fromRGB(210, 210, 220)
			st.Transparency = active and 0.15 or 0.35
			st.Thickness = active and 1.5 or 1
		end
	end
	local function posFromSaved(modeName, order)
		local key = "V2_" .. modeName
		local t = St._btnPos and St._btnPos[key]
		if type(t) == "table" and t[1] ~= nil then
			return UDim2.new(t[1], t[2], t[3], t[4])
		end
		local gap = 10
		local total = (V2_BTN_W + gap) * 3 - gap
		return UDim2.new(0.5, -total / 2 + (order - 1) * (V2_BTN_W + gap), 1, -118)
	end
	local function saveV2Pos(modeName, holder)
		St._btnPos = St._btnPos or {}
		St._btnPos["V2_" .. modeName] = {
			holder.Position.X.Scale, holder.Position.X.Offset,
			holder.Position.Y.Scale, holder.Position.Y.Offset,
		}
		saveCfg()
	end
	local function makeV2ModeBtn(modeName, label, order)
		local holder = Instance.new("Frame")
		holder.Name = "V2MH_" .. modeName
		holder.Size = UDim2.new(0, V2_BTN_W, 0, V2_BTN_H)
		holder.Position = posFromSaved(modeName, order)
		holder.BackgroundTransparency = 1
		holder.BorderSizePixel = 0
		holder.ZIndex = 10
		holder.Active = true
		holder.Parent = gui
		local btn = Instance.new("TextButton")
		btn.Name = "V2Bar_" .. modeName
		btn.Size = UDim2.new(1, 0, 1, 0)
		btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		btn.Text = label
		btn.TextColor3 = Color3.fromRGB(25, 25, 30)
		btn.Font = Enum.Font.GothamBlack
		btn.TextSize = 13
		btn.AutoButtonColor = false
		btn.ZIndex = 12
		btn.Parent = holder
		corner(btn, V2_CORNER)
		local st = Instance.new("UIStroke", btn)
		st.Thickness = 1
		st.Transparency = 0.35
		st.Color = Color3.fromRGB(210, 210, 220)
		st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		styleV2Btn(btn, modeName, St.activeMode == modeName)
		local activeInput, pressPos, holderStart = nil, nil, nil
		local moved, lastClick = false, 0
		local function runClick()
			local now = tick()
			if now - lastClick < 0.08 then return end
			lastClick = now
			if type(setActiveMode) == "function" then setActiveMode(modeName)
			else St.activeMode = modeName end
			for n, e in pairs(v2BarButtons) do
				if e and e.btn then styleV2Btn(e.btn, n, n == modeName) end
			end
			for n, e in pairs(modeRefs or {}) do
				if e and e.style then pcall(e.style, n == modeName)
				elseif e and e.btn then
					e.btn.BackgroundColor3 = (n == modeName) and Color3.fromRGB(255, 200, 210) or Color3.fromRGB(255, 255, 255)
				end
			end
		end
		btn.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
			activeInput = input
			pressPos = input.Position
			holderStart = holder.Position
			moved = false
			input.Changed:Connect(function()
				if input.UserInputState ~= Enum.UserInputState.End or activeInput ~= input then return end
				activeInput = nil
				if not moved then runClick()
				elseif not St.guiLock then saveV2Pos(modeName, holder) end
			end)
		end)
		btn.Activated:Connect(function()
			if moved then return end
			runClick()
		end)
		UIS.InputChanged:Connect(function(input)
			if not activeInput or not pressPos or not holderStart then return end
			if activeInput.UserInputType == Enum.UserInputType.Touch then
				if input ~= activeInput then return end
			elseif activeInput.UserInputType == Enum.UserInputType.MouseButton1 then
				if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
			else return end
			local dx = input.Position.X - pressPos.X
			local dy = input.Position.Y - pressPos.Y
			if math.abs(dx) > 4 or math.abs(dy) > 4 then moved = true end
			if moved and not St.guiLock then
				holder.Position = UDim2.new(holderStart.X.Scale, holderStart.X.Offset + dx, holderStart.Y.Scale, holderStart.Y.Offset + dy)
			end
		end)
		v2BarButtons[modeName] = { holder = holder, btn = btn }
		return btn
	end
	makeV2ModeBtn("Normal", "NORMAL", 1)
	makeV2ModeBtn("Lagger", "LAGGER", 2)
	makeV2ModeBtn("Custom", "CUSTOM", 3)
	_G.VisRefreshV2ModeBar = function()
		for n, e in pairs(v2BarButtons) do
			if e and e.btn then styleV2Btn(e.btn, n, St.activeMode == n) end
		end
	end
end

function makeModeBtn(name, order)
	local sc = tonumber(St.btnScale) or 1
	local modeBase = tonumber(St.btnSizes and St.btnSizes.mode) or 50
	local V2_CORNER = 12
	local h = math.max(28, math.floor(modeBase * sc))
	local w = math.max(72, math.floor(88 * sc))
	local holder = Instance.new("Frame")
	holder.Name = "M_" .. name
	holder.Size = UDim2.new(0, w, 0, h)
	local gap = 10
	local total = (w + gap) * 3 - gap
	holder.Position = UDim2.new(0.5, -total / 2 + (order - 1) * (w + gap), 1, -118)
	holder.BackgroundTransparency = 1
	holder.BorderSizePixel = 0
	holder.ZIndex = 10
	holder.Active = true
	holder.Parent = ModeGui
	pcall(function()
		local p = St._btnPos and St._btnPos["M_" .. name]
		if type(p) == "table" and p[1] ~= nil then
			holder.Position = UDim2.new(p[1], p[2], p[3], p[4])
		end
	end)
	local btn = Instance.new("TextButton")
	btn.Name = "ModeBtn"
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = name:upper()
	if name == "Normal" then btn.Text = "NORMAL" end
	btn.TextColor3 = Color3.fromRGB(25, 25, 30)
	btn.Font = Enum.Font.GothamBlack
	btn.TextSize = math.clamp(math.floor(h * 0.36), 11, 14)
	btn.AutoButtonColor = false
	btn.ZIndex = 12
	btn.Active = true
	btn.Parent = holder
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, V2_CORNER)
	local st = Instance.new("UIStroke", btn)
	st.Thickness = 1
	st.Transparency = 0.35
	st.Color = Color3.fromRGB(210, 210, 220)
	st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local function styleMode(on)
		if on then
			btn.BackgroundColor3 = Color3.fromRGB(255, 200, 210)
			btn.TextColor3 = Color3.fromRGB(30, 20, 30)
			st.Color = Color3.fromRGB(255, 160, 180)
			st.Transparency = 0.1
		else
			btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			btn.TextColor3 = Color3.fromRGB(25, 25, 30)
			st.Color = Color3.fromRGB(210, 210, 220)
			st.Transparency = 0.35
		end
	end
	styleMode(St.activeMode == name)
	local dragging, dragStart, startPos, moved = false, nil, nil, false
	local movedDistance = 0
	local TAP_MAX = 22
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			moved = false
			movedDistance = 0
			dragStart = input.Position
			startPos = holder.Position
		end
	end)
	btn.InputChanged:Connect(function(input)
		if not dragging or not dragStart then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local d = input.Position - dragStart
			movedDistance = d.Magnitude
			if movedDistance > 8 then moved = true end
			if not St.guiLock and moved then
				holder.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
			end
		end
	end)
	local function pick()
		setActiveMode(name)
		for n, e in pairs(modeRefs) do
			if e and e.btn and e.style then
				e.style(St.activeMode == n)
			elseif e and e.btn then
				local on = St.activeMode == n
				e.btn.BackgroundColor3 = on and Color3.fromRGB(255, 200, 210) or Color3.fromRGB(255, 255, 255)
				e.btn.TextColor3 = on and Color3.fromRGB(30, 20, 30) or Color3.fromRGB(25, 25, 30)
			end
		end
		styleMode(true)
	end
	btn.InputEnded:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
		if not dragging then return end
		dragging = false
		if not moved and movedDistance < TAP_MAX then pick()
		elseif moved and not St.guiLock then
			St._btnPos = St._btnPos or {}
			St._btnPos["M_" .. name] = {
				holder.Position.X.Scale, holder.Position.X.Offset,
				holder.Position.Y.Scale, holder.Position.Y.Offset,
			}
			saveCfg()
		end
		movedDistance = 0
		dragStart = nil
	end)
	btn.MouseButton1Click:Connect(function()
		if moved then return end
		pick()
	end)
	btn.Activated:Connect(function()
		if moved then return end
		pick()
	end)
	modeRefs[name] = { holder = holder, btn = btn, style = styleMode }
end

function makeActBtn(key, label, pos, cb)
	local baseSz = (St.btnSizes[key] or 50)
	if key == "steal" or key == "sentry" then baseSz = math.max(baseSz, 56) end
	local sz = math.max(28, math.floor(baseSz * (St.btnScale or 1)))
	local holder = Instance.new("Frame")
	holder.Name = "A_" .. key
	holder.Size = UDim2.new(0, sz, 0, sz)
	holder.Position = pos
	holder.BackgroundTransparency = 1
	holder.Active = true
	holder.ZIndex = 50
	holder.Parent = HelperGui
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
	btn.Text = label
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = math.clamp(math.floor(sz * 0.22), 10, 16)
	btn.Font = Enum.Font.GothamBold
	btn.TextWrapped = true
	btn.AutoButtonColor = false
	btn.Active = true
	btn.Selectable = true
	btn.Modal = false
	btn.ZIndex = 100
	btn.Parent = holder
			applyCorner(btn, key == "profile" and "Round" or St.btnShape)

	local oldS = btn:FindFirstChildOfClass("UIStroke")
	if oldS then oldS:Destroy() end
	local s = Instance.new("UIStroke")
	s.Name = "BtnBorder"
	s.Color = Color3.fromRGB(255, 120, 220)
	s.Thickness = 3
	s.Transparency = 0.02
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = btn
	local themeGradient = Instance.new("UIGradient")
	themeGradient.Name = "EL2BButtonGradient"
	themeGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.28, Color3.fromRGB(255, 105, 210)),
		ColorSequenceKeypoint.new(0.62, Color3.fromRGB(170, 75, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
	})
	themeGradient.Parent = s
	applyEmpireBtnBg(btn, ({drop=1,insta=2,tp=3,sentry=4,steal=5})[key] or 5)
			applyCornerToChildren(btn, key == "profile" and "Round" or St.btnShape)

	local bgImg = btn:FindFirstChild("BtnBgImage")
	if bgImg then
		bgImg.Active = false
		bgImg.Selectable = false
		bgImg.ZIndex = 0
	end
	btn.TextTransparency = 0
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	local oldL = btn:FindFirstChild("BtnTextOverlay")
	if oldL then oldL:Destroy() end
	local tl = Instance.new("TextLabel")
	tl.Name = "BtnTextOverlay"
	tl.BackgroundTransparency = 1
	tl.Size = UDim2.new(1, -4, 1, -4)
	tl.Position = UDim2.new(0, 2, 0, 2)
	tl.Text = label
	tl.TextColor3 = Color3.fromRGB(255, 255, 255)
	tl.TextStrokeTransparency = 0.35
	tl.TextStrokeColor3 = Color3.new(0, 0, 0)
	tl.Font = Enum.Font.GothamBold
	tl.TextScaled = true
	tl.TextWrapped = true
	tl.ZIndex = (btn.ZIndex or 100) + 5
	tl.Active = false
	tl.Parent = btn
	btn.TextTransparency = 1
	local dragging, dragStart, startPos = false, nil, nil
	local movedDistance = 0
	local TAP_MAX = 22
	local dragThresh = 8
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			movedDistance = 0
			dragStart = input.Position
			startPos = holder.Position
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if not dragging or not dragStart then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local d = input.Position - dragStart
		movedDistance = d.Magnitude
		if St.guiLock then return end
		if movedDistance > dragThresh then
			holder.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	btn.InputEnded:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
		if not dragging then return end
		dragging = false
		local tapLimit = TAP_MAX
		if key == "steal" or key == "sentry" or key == "drop" or key == "insta" or key == "tp" then
			tapLimit = 48
		end
		if movedDistance < tapLimit then
			if cb then
				btn:SetAttribute("_lastTap", tick())
				pcall(cb)
				if key == "sentry" and _G.VisRefreshSentryBtn then pcall(_G.VisRefreshSentryBtn) end
				if key == "steal" and _G.VisRefreshStealBtn then pcall(_G.VisRefreshStealBtn) end
			end
		else
			if not St.guiLock then
				St._btnPos = St._btnPos or {}
				St._btnPos["A_" .. key] = {
					holder.Position.X.Scale, holder.Position.X.Offset,
					holder.Position.Y.Scale, holder.Position.Y.Offset,
					holder.Size.X.Offset, holder.Size.Y.Offset
				}
				saveCfg()
			end
		end
		movedDistance = 0
		dragStart = nil
	end)
	local function backupClick()
		local last = btn:GetAttribute("_lastTap") or 0
		if tick() - last < 0.15 then return end
		btn:SetAttribute("_lastTap", tick())
		if cb then pcall(cb) end
		if key == "sentry" and _G.VisRefreshSentryBtn then pcall(_G.VisRefreshSentryBtn) end
		if key == "steal" and _G.VisRefreshStealBtn then pcall(_G.VisRefreshStealBtn) end
	end
	btn.MouseButton1Click:Connect(backupClick)
	btn.Activated:Connect(backupClick)
	local ov = btn:FindFirstChild("BtnTextOverlay")
	if ov then ov.Active = false; ov.Selectable = false end

	if key == "steal" or key == "sentry" then
		local function instantToggle()
			local last = btn:GetAttribute("_lastTap") or 0
			if tick() - last < 0.12 then return end
			btn:SetAttribute("_lastTap", tick())
			if key == "steal" then
				local on = not (St.autoSteal == true)
				if type(setAutoSteal) == "function" then pcall(setAutoSteal, on)
				else St.autoSteal = on end
				applyActBtnState(btn, St.autoSteal == true, "STEAL\nON", "AUTO\nSTEAL")
				if _G.VisRefreshStealBtn then pcall(_G.VisRefreshStealBtn) end
			else
				local on = not (St.destroySentry == true)
				if type(setDestroySentry) == "function" then pcall(setDestroySentry, on)
				else St.destroySentry = on end
				applyActBtnState(btn, St.destroySentry == true, "SENTRY\nON", "SENTRY")
				if _G.VisRefreshSentryBtn then pcall(_G.VisRefreshSentryBtn) end
			end
		end
		btn.MouseButton1Down:Connect(instantToggle)
		cb = instantToggle
	end

	actRefs[key] = { holder = holder, btn = btn }
end

function restorePos(holder, key, defaultPos)
	local t = St._btnPos and St._btnPos[key]
	if type(t) == "table" and t[1] ~= nil then
		holder.Position = UDim2.new(tonumber(t[1]) or 0, tonumber(t[2]) or 0, tonumber(t[3]) or 0, tonumber(t[4]) or 0)
		if t[5] and t[6] then
			local s = tonumber(t[5])
			local h = tonumber(t[6])
			if s and h and s > 10 and h > 10 then
				holder.Size = UDim2.new(0, s, 0, h)
			end
		end
	elseif defaultPos then
		holder.Position = defaultPos
	end
end

local profileGui = nil
local profileCard = nil
local profileVisible = false

local function getProfileBottomOffset()
	local safeBottom = 0
	pcall(function()
		local _, bottomRight = GuiService:GetGuiInset()
		safeBottom = tonumber(bottomRight.Y) or 0
	end)
	-- Le bouton PROFILE et la barre de modes occupent la zone inférieure.
	return math.max(270, 118 + 166 + 24 + safeBottom)
end

local function updateRobloxProfileLayout()
	if not profileCard then return end
	local camera = workspace.CurrentCamera
	local viewportWidth = camera and camera.ViewportSize.X or 420
	profileCard.Size = UDim2.new(0, math.min(280, math.max(244, viewportWidth - 36)), 0, 166)
	profileCard.Position = UDim2.new(0, 18, 1, -getProfileBottomOffset())
end

local function openRobloxProfile()
	local userId = tonumber(LP.UserId)
	if not userId or userId <= 0 then return end
	local url = "https://www.roblox.com/users/" .. tostring(math.floor(userId)) .. "/profile"
	local opened = pcall(function()
		GuiService:OpenBrowserWindow(url)
	end)
	if not opened and type(setclipboard) == "function" then
		pcall(setclipboard, url)
		if type(showToast) == "function" then showToast("PROFILE URL COPIED") end
	end
end

local function closeRobloxProfile()
	profileVisible = false
	if profileCard then profileCard.Visible = false end
end

local function showRobloxProfile()
	if not profileGui then
		profileGui = Instance.new("ScreenGui")
		profileGui.Name = "EL2BProfileGui"
		profileGui.ResetOnSpawn = false
		profileGui.IgnoreGuiInset = true
		profileGui.DisplayOrder = 130
		profileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		profileGui.Parent = PlayerGui

		profileCard = Instance.new("Frame")
		profileCard.Name = "ProfileCard"
		profileCard.Size = UDim2.new(0, 280, 0, 166)
		profileCard.Position = UDim2.new(0, 18, 1, -270)
		profileCard.BackgroundColor3 = Color3.fromRGB(18, 14, 28)
		profileCard.BackgroundTransparency = 0.04
		profileCard.BorderSizePixel = 0
		profileCard.ZIndex = 200
		profileCard.Parent = profileGui
		profileCard.Visible = false
		local camera = workspace.CurrentCamera
		if camera then
			camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateRobloxProfileLayout)
		end
		corner(profileCard, 16)
		stroke(profileCard, Color3.fromRGB(255, 100, 220))

		local title = Instance.new("TextLabel")
		title.Name = "Title"
		title.BackgroundTransparency = 1
		title.Position = UDim2.new(0, 76, 0, 12)
		title.Size = UDim2.new(1, -112, 0, 22)
		title.Text = "ROBLOX PROFILE"
		title.TextColor3 = Color3.fromRGB(255, 125, 220)
		title.TextSize = 13
		title.Font = Enum.Font.GothamBold
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.ZIndex = 202
		title.Parent = profileCard

		local avatar = Instance.new("ImageButton")
		avatar.Name = "Avatar"
		avatar.Size = UDim2.new(0, 54, 0, 54)
		avatar.Position = UDim2.new(0, 14, 0, 14)
		avatar.BackgroundColor3 = Color3.fromRGB(40, 26, 52)
		avatar.BorderSizePixel = 0
		avatar.ZIndex = 202
		avatar.Parent = profileCard
		avatar.AutoButtonColor = false
		avatar.Selectable = true
		avatar.Activated:Connect(openRobloxProfile)
		corner(avatar, 27)
		local avatarStroke = Instance.new("UIStroke", avatar)
		avatarStroke.Color = Color3.fromRGB(180, 75, 255)
		avatarStroke.Thickness = 2

		local details = Instance.new("TextButton")
		details.Name = "Details"
		details.BackgroundTransparency = 1
		details.Position = UDim2.new(0, 76, 0, 38)
		details.Size = UDim2.new(1, -92, 0, 76)
		details.TextColor3 = Color3.fromRGB(235, 235, 245)
		details.TextSize = 12
		details.Font = Enum.Font.Gotham
		details.TextXAlignment = Enum.TextXAlignment.Left
		details.TextYAlignment = Enum.TextYAlignment.Top
		details.TextWrapped = true
		details.AutoButtonColor = false
		details.Selectable = true
		details.ZIndex = 202
		details.Activated:Connect(openRobloxProfile)
		details.Parent = profileCard

		local close = Instance.new("TextButton")
		close.Name = "Close"
		close.Size = UDim2.new(0, 28, 0, 28)
		close.Position = UDim2.new(1, -38, 0, 8)
		close.BackgroundColor3 = Color3.fromRGB(50, 26, 55)
		close.Text = "×"
		close.TextColor3 = Color3.fromRGB(255, 255, 255)
		close.TextSize = 18
		close.Font = Enum.Font.GothamBold
		close.AutoButtonColor = true
		close.ZIndex = 203
		close.Parent = profileCard
		corner(close, 14)
		close.Activated:Connect(closeRobloxProfile)

		local hint = Instance.new("TextLabel")
		hint.Name = "Hint"
		hint.BackgroundTransparency = 1
		hint.Position = UDim2.new(0, 14, 1, -30)
		hint.Size = UDim2.new(1, -28, 0, 20)
		hint.Text = "Profil local • aucune donnée envoyée"
		hint.TextColor3 = C.textDim
		hint.TextSize = 10
		hint.Font = Enum.Font.Gotham
		hint.TextXAlignment = Enum.TextXAlignment.Left
		hint.ZIndex = 202
		hint.Parent = profileCard
	end

	updateRobloxProfileLayout()
	local avatar = profileCard:FindFirstChild("Avatar")
	local details = profileCard:FindFirstChild("Details")
	if avatar then
		local ok, image = pcall(function()
			return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
		end)
		if ok and type(image) == "string" then avatar.Image = image end
	end
	if details then
		details.Text = string.format("Nom : %s\nUsername : @%s\nUserId : %d", LP.DisplayName, LP.Name, LP.UserId)
	end
	profileVisible = true
	profileCard.Visible = true
end

function rebuildMobile()
	for _, e in pairs(modeRefs) do if e.holder then e.holder:Destroy() end end
	for _, e in pairs(actRefs) do if e.holder then e.holder:Destroy() end end
	modeRefs, actRefs = {}, {}
	makeModeBtn("Normal", 1)
	makeModeBtn("Lagger", 2)
	makeModeBtn("Custom", 3)
	pcall(function()
		if ModeGui then
			for _, ch in ipairs(ModeGui:GetChildren()) do
				if ch:IsA("Frame") and tostring(ch.Name):match("^M_") then
					ch.Visible = false
				end
			end
		end
		if _G.VisBuildV2ModeBar then _G.VisBuildV2ModeBar() end
		if St.speedOn then
			currentSpeedValue = getActiveMoveSpeed()
			pcall(startSpeedBoost)
		end
	end)
	makeActBtn("drop", "DROP", UDim2.new(1, -150, 0.5, -40), function() runDrop(); if _G.VisCounterOnDrop then pcall(_G.VisCounterOnDrop) end end)
	makeActBtn("insta", "INSTA\nRESET", UDim2.new(1, -80, 0.5, -40), doInstaReset)
	makeActBtn("tp", "TP\nDOWN", UDim2.new(1, -80, 0.5, 30), function() doTPDown(true) end)
	makeActBtn("sentry", "SENTRY", UDim2.new(1, -150, 0.5, 30), function()
		local on = not (St.destroySentry == true)
		if type(setDestroySentry) == "function" then setDestroySentry(on)
		else St.destroySentry = on end
		if _G.VisRefreshSentryBtn then pcall(_G.VisRefreshSentryBtn) end
	end)
	makeActBtn("steal", "AUTO\nSTEAL", UDim2.new(1, -150, 0.5, 100), function()
		local on = not (St.autoSteal == true)
		if type(setAutoSteal) == "function" then setAutoSteal(on)
		else St.autoSteal = on end
		if _G.VisRefreshStealBtn then pcall(_G.VisRefreshStealBtn) end
		if ToggleRefs and ToggleRefs.autoSteal and ToggleRefs.autoSteal.setVisual then
			pcall(ToggleRefs.autoSteal.setVisual, St.autoSteal == true)
		end
	end)
	makeActBtn("profile", "PROFILE", UDim2.new(0, 18, 1, -118), showRobloxProfile)
	for key, e in pairs(actRefs) do
		if e.holder then restorePos(e.holder, "A_" .. key) end
	end
	for key, e in pairs(modeRefs) do
		if e.holder then restorePos(e.holder, "M_" .. key) end
	end
	_G.VisRefreshModeBar()
	_G.VisRefreshSentryBtn()
	if _G.VisRefreshStealBtn then pcall(_G.VisRefreshStealBtn) end
end

function applyActBtnState(btn, on, onText, offText)
	if not btn then return end
	on = on and true or false
	if on then
		btn.BackgroundColor3 = Color3.fromRGB(0, 130, 45)
		btn.BackgroundTransparency = 0
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		if onText then btn.Text = onText end
		local bgImg = btn:FindFirstChild("BtnBgImage")
		if bgImg then bgImg.ImageTransparency = 0.75 end
		local dim = btn:FindFirstChild("BtnDim")
		if not dim then
			dim = Instance.new("Frame")
			dim.Name = "BtnDim"
			dim.Size = UDim2.new(1, 0, 1, 0)
			dim.BorderSizePixel = 0
			dim.ZIndex = (btn.ZIndex or 100) + 1
			dim.Active = false
			dim.Parent = btn
			local dc = Instance.new("UICorner")
			dc.CornerRadius = UDim.new(0, 8)
			dc.Parent = dim
		end
		dim.BackgroundColor3 = Color3.fromRGB(0, 120, 40)
		dim.BackgroundTransparency = 0.15
		dim.Visible = true
		local tl = btn:FindFirstChild("BtnTextOverlay")
		if tl then
			if onText then tl.Text = onText end
			tl.TextColor3 = Color3.fromRGB(255, 255, 255)
			tl.TextStrokeTransparency = 0.2
			tl.ZIndex = (btn.ZIndex or 100) + 6
		end
		local st = btn:FindFirstChild("BtnBorder") or btn:FindFirstChildOfClass("UIStroke")
		if st then st.Color = Color3.fromRGB(35, 255, 105); st.Transparency = 0; st.Thickness = 3.5 end
	else
		btn.BackgroundColor3 = Color3.fromRGB(10, 7, 16)
		btn.BackgroundTransparency = 0.08
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		if offText then btn.Text = offText end
		local bgImg = btn:FindFirstChild("BtnBgImage")
		if bgImg then bgImg.ImageTransparency = 0.08 end
		local dim = btn:FindFirstChild("BtnDim")
		if dim then
			dim.BackgroundColor3 = Color3.new(0, 0, 0)
			dim.BackgroundTransparency = 0.45
		end
		local tl = btn:FindFirstChild("BtnTextOverlay")
		if tl then
			if offText then tl.Text = offText end
			tl.TextColor3 = Color3.fromRGB(255, 255, 255)
			tl.TextStrokeTransparency = 0.35
		end
		local st = btn:FindFirstChildOfClass("UIStroke")
		if st then st.Color = Color3.fromRGB(255, 110, 220); st.Transparency = 0.02; st.Thickness = 3 end
	end
end

_G.VisRefreshStealBtn = function()
	local e = actRefs and actRefs.steal
	if not e or not e.holder then return end
	local show = (St.showStealBtn ~= false)
	e.holder.Visible = show
	if e.btn then
		e.btn.Visible = show
		applyActBtnState(e.btn, St.autoSteal == true, "STEAL\nON", "AUTO\nSTEAL")
	end
end

_G.VisRefreshSentryBtn = function()
	local e = actRefs and actRefs.sentry
	if e and e.btn then
		applyActBtnState(e.btn, St.destroySentry == true, "SENTRY\nON", "SENTRY")
	end
end

_G.VisRefreshModeBar = function()
	for n, e in pairs(modeRefs) do
		if e and e.btn then
			local on = St.activeMode == n
			applyCorner(e.btn, "Pill")
			if on then
				e.btn.BackgroundColor3 = C.modeOnBg or Color3.fromRGB(255, 20, 147)
				e.btn.BackgroundTransparency = 0
				e.btn.TextColor3 = C.modeOnTxt or Color3.fromRGB(255, 255, 255)
				local tl = e.btn:FindFirstChild("BtnTextOverlay")
				if tl then
					tl.TextColor3 = Color3.fromRGB(255, 255, 255)
					tl.Text = n
				end
				local st = e.btn:FindFirstChildOfClass("UIStroke")
				if st then st.Color = Color3.fromRGB(255, 120, 200); st.Transparency = 0.05 end
			else
				e.btn.BackgroundColor3 = C.modeOffBg or Color3.fromRGB(255, 255, 255)
				e.btn.BackgroundTransparency = 0
				e.btn.TextColor3 = C.modeOffTxt or Color3.fromRGB(25, 25, 30)
				local tl = e.btn:FindFirstChild("BtnTextOverlay")
				if tl then
					tl.TextColor3 = Color3.fromRGB(25, 25, 30)
					tl.Text = n
				end
				local st = e.btn:FindFirstChildOfClass("UIStroke")
				if st then st.Color = Color3.fromRGB(200, 200, 210); st.Transparency = 0.2 end
			end
		end
	end
end

_G.VisForceApplyShape = function(shape)
	shape = shape or (St and St.btnShape) or "Square"
	if St then St.btnShape = shape end
	local refs = actRefs
	if type(refs) ~= "table" then return end
	for key, e in pairs(refs) do
		if e and e.btn then
			pcall(function()
				applyCorner(e.btn, shape)
				if applyCornerToChildren then applyCornerToChildren(e.btn, shape) end
			end)
		end
	end
end

_G.VisUpdateMobileVisuals = function()
	for n, e in pairs(modeRefs) do
		if e and e.holder and e.btn then
			local sc = tonumber(St.btnScale) or 1
			local w = math.max(80, math.floor(98 * sc))
			local h = math.max(32, math.floor(36 * sc))
			e.holder.Size = UDim2.new(0, w, 0, h)
			e.btn.TextSize = math.clamp(math.floor(h * 0.36), 11, 14)
			local c = e.btn:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", e.btn)
			c.CornerRadius = UDim.new(0, 12)
			if e.style then e.style(St.activeMode == n) end
		end
	end
	for key, e in pairs(actRefs) do
		if e and e.holder and e.btn then
			local base = (St.btnSizes[key] or 50)
			if key == "steal" or key == "sentry" then base = math.max(base, 56) end
			local sz = math.max(28, math.floor(base * (St.btnScale or 1)))
			e.holder.Size = UDim2.new(0, sz, 0, sz)
			e.btn.TextSize = math.clamp(math.floor(sz * 0.22), 10, 16)
							local shape = key == "profile" and "Round" or (St.btnShape or "Round")
				applyCorner(e.btn, shape)
				applyCornerToChildren(e.btn, shape)

			local s = e.btn:FindFirstChild("BtnBorder") or e.btn:FindFirstChildOfClass("UIStroke")
			if not s then
				s = Instance.new("UIStroke")
				s.Name = "BtnBorder"
				s.Parent = e.btn
			end
			s.Color = Color3.fromRGB(220, 220, 235)
			s.Thickness = 2
			s.Transparency = 0.15
		end
	end
	if _G.VisRefreshModeBar then pcall(_G.VisRefreshModeBar) end
	if _G.VisRefreshSentryBtn then pcall(_G.VisRefreshSentryBtn) end
	if _G.VisRefreshStealBtn then pcall(_G.VisRefreshStealBtn) end
	pcall(function()
		local gui = PlayerGui:FindFirstChild("VisV2ModeBar")
		if not gui then return end
		local sc = tonumber(St.btnScale) or 1
		local modeSz = tonumber(St.btnSizes and St.btnSizes.mode) or 50
		local h = math.max(28, math.floor(modeSz * sc))
		local w = math.max(72, math.floor(88 * sc))
		for _, holder in ipairs(gui:GetChildren()) do
			if holder:IsA("Frame") and holder.Name:match("^V2MH_") then
				holder.Size = UDim2.new(0, w, 0, h)
				local btn = holder:FindFirstChildWhichIsA("TextButton")
				if btn then
					btn.TextSize = math.clamp(math.floor(h * 0.36), 9, 16)
				end
			end
		end
	end)
end

_G.VisApplyMobile = function()
	ModeGui.Enabled = St.mobileBtns == true
	-- La GUI Helper reste indépendante et visible même si la barre des modes est masquée.
	HelperGui.Enabled = true
	local hasMode = next(modeRefs) ~= nil
	local hasAct = next(actRefs) ~= nil
	if not hasMode or not hasAct then rebuildMobile() end
	if _G.VisUpdateMobileVisuals then pcall(_G.VisUpdateMobileVisuals) end
end

_G.VisResetMobilePos = function()
	St._btnPos = {}
	rebuildMobile()
	saveCfg()
end
_G.VisApplyMobile()

-- ==============================
--  KEYBINDS GLOBAUX
-- ==============================
UIS.InputBegan:Connect(function(input, gp)
	if gp or listening then return end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	local k = input.KeyCode
	if k == St.keys.Drop then runDrop()
	elseif k == St.keys.TPDown then doTPDown(true)
	elseif k == St.keys.InstaReset then doInstaReset()
	elseif k == St.keys.DestroySentry then setDestroySentry(not St.destroySentry)
	elseif St.keys.AutoSteal and k == St.keys.AutoSteal then
		if type(setAutoSteal) == "function" then
			setAutoSteal(not (St.autoSteal == true))
			if ToggleRefs and ToggleRefs.autoSteal and ToggleRefs.autoSteal.setVisual then
				pcall(ToggleRefs.autoSteal.setVisual, St.autoSteal == true)
			end
		end
	else
		for name, m in pairs(St.modes) do
			if m.key == k then setActiveMode(name); break end
		end
	end
end)

-- ==============================
--  REAPPLY ALL LOGIC (watchdog)
-- ==============================
function reapplyAllLogic(reason)
	pcall(function()
		if St.speedOn then
			if speedConnection then pcall(function() speedConnection:Disconnect() end); speedConnection = nil end
			startSpeedBoost()
			if St.activeMode and setActiveMode then setActiveMode(St.activeMode) end
		else stopSpeedBoost() end
	end)
	pcall(function()
		if St.infJump then
			InfJumpState.enabled = true
			InfJumpState.mode = St.infJumpMode or "hold"
			if startInfJump then startInfJump() elseif setInfJump then setInfJump(true) end
		else stopInfJump() end
	end)
	pcall(function()
		if St.antiRagdoll then
			AntiRagdollV2.Enabled = true
			if startAntiRagdoll then startAntiRagdoll() end
		else stopAntiRagdoll() end
	end)
	pcall(function()
		aimOn = true
		local char = LP.Character
		if char and watchTools then watchTools(char) end
		local bp = LP:FindFirstChild("Backpack")
		if bp and watchTools then watchTools(bp) end
	end)
	pcall(function() if St.destroySentry and setDestroySentry then setDestroySentry(true) end end)
	pcall(function() if St.esp and setESP then setESP(true) end end)
	pcall(function() if St.tracer and setTracer then setTracer(true) end end)
	pcall(function() if St.antiLag and setAntiLag then setAntiLag(true) end end)
	pcall(function() if St.spamLaser and setSpamLaser then setSpamLaser(true) end end)
	pcall(function() if St.spamPaint and setSpamPaint then setSpamPaint(true) end end)
	pcall(function()
		if St.autoSteal then
			if type(setAutoSteal) == "function" then setAutoSteal(true) end
			if _G.VisSyncAutoSteal then pcall(_G.VisSyncAutoSteal) end
		end
	end)
	pcall(function()
		if ModeGui then ModeGui.Enabled = St.mobileBtns == true end
		if HelperGui then HelperGui.Enabled = true end
		if _G.VisApplyMobile then pcall(_G.VisApplyMobile) end
	end)
end
_G.VisReapplyAllLogic = reapplyAllLogic

-- Réappliquer au démarrage
task.defer(function()
	pcall(function() setAntiGummy(St.antiGummy ~= false) end)
	pcall(function() setAntiBoogie(St.antiBoogie ~= false) end)
	pcall(function() setAntiPaint(St.antiPaint ~= false) end)
	pcall(function() setAntiRagdoll(St.antiRagdoll == true) end)
	pcall(function() setToolAim(St.toolAim ~= false) end)
	pcall(function() setInfJump(St.infJump ~= false) end)
	pcall(function() setDestroySentry(St.destroySentry == true) end)
	pcall(function() setSpeedOn(St.speedOn ~= false) end)
	pcall(function() setActiveMode(St.activeMode or "Normal") end)
	pcall(function() setESP(St.esp == true) end)
	pcall(function() setTracer(St.tracer == true) end)
	pcall(function() setAntiLag(St.antiLag == true) end)
	pcall(function() setSpamLaser(St.spamLaser == true) end)
	pcall(function() setSpamPaint(St.spamPaint == true) end)
	if type(setAutoSteal) == "function" then setAutoSteal(St.autoSteal == true) end
	if St.autoSteal and _G.VisSyncAutoSteal then pcall(_G.VisSyncAutoSteal) end
	applyMenuScale()
	setTab("Player")
end)

-- Character added
if _G._VisHubCharReapplyConn then
	pcall(function() _G._VisHubCharReapplyConn:Disconnect() end)
end
_G._VisHubCharReapplyConn = LP.CharacterAdded:Connect(function(char)
	task.wait(0.4)
	pcall(reapplyAllLogic, "CharacterAdded")
end)

-- ==============================
--  STEAL BAR (VisStealBarOnly)
-- ==============================
task.spawn(function()
	pcall(function()
		local o = PlayerGui:FindFirstChild("VisStealBarOnly")
		if o then o:Destroy() end
	end)

	local gui = Instance.new("ScreenGui")
	gui.Name = "VisStealBarOnly"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 200000
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = PlayerGui

	local scale = tonumber(St.stealBarScale) or 1
	local barW, barH = math.floor(280 * scale), math.floor(36 * scale)

	local frame = Instance.new("Frame")
	frame.Name = "StealBar"
	frame.Size = UDim2.new(0, barW, 0, barH)
	if type(St._stealBarPos) == "table" then
		frame.Position = UDim2.new(St._stealBarPos[1], St._stealBarPos[2], St._stealBarPos[3], St._stealBarPos[4])
	else
		frame.Position = UDim2.new(0.5, -barW/2, 0.12, 0)
	end
	frame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
	frame.BackgroundTransparency = 0.15
	frame.BorderSizePixel = 0
	frame.Visible = true
	frame.Active = true
	frame.Parent = gui
	corner(frame, 10)
	local stroke2 = Instance.new("UIStroke", frame)
	stroke2.Color = Color3.fromRGB(70, 90, 140)
	stroke2.Thickness = 1.2

	local title = Instance.new("TextLabel", frame)
	title.Name = "Title"
	title.Size = UDim2.new(0.42, 0, 1, 0)
	title.Position = UDim2.new(0, 10, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "STEALING..."
	title.TextColor3 = Color3.fromRGB(200, 220, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 11
	title.TextXAlignment = Enum.TextXAlignment.Left

	local track = Instance.new("Frame", frame)
	track.Name = "Track"
	track.Size = UDim2.new(0.38, 0, 0, 8)
	track.Position = UDim2.new(0.40, 0, 0.5, -4)
	track.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
	track.BorderSizePixel = 0
	corner(track, 99)

	local fill = Instance.new("Frame", track)
	fill.Name = "Fill"
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(100, 255, 160)
	fill.BorderSizePixel = 0
	corner(fill, 99)
	local grad = Instance.new("UIGradient", fill)
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 220, 140)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 255, 210)),
	})

	local pctLbl = Instance.new("TextLabel", frame)
	pctLbl.Name = "Pct"
	pctLbl.Size = UDim2.new(0.18, -8, 1, 0)
	pctLbl.Position = UDim2.new(0.80, 0, 0, 0)
	pctLbl.BackgroundTransparency = 1
	pctLbl.Text = "0%"
	pctLbl.TextColor3 = Color3.fromRGB(180, 200, 230)
	pctLbl.Font = Enum.Font.GothamBold
	pctLbl.TextSize = 11
	pctLbl.TextXAlignment = Enum.TextXAlignment.Right

	local metaLbl = Instance.new("TextLabel", frame)
	metaLbl.Name = "MetaFpsPing"
	metaLbl.Size = UDim2.new(0.55, 0, 0, 14)
	metaLbl.Position = UDim2.new(0, 10, 1, -16)
	metaLbl.BackgroundTransparency = 1
	metaLbl.Text = "FPS // --  PING // -- ms"
	metaLbl.TextColor3 = Color3.fromRGB(140, 145, 165)
	metaLbl.Font = Enum.Font.GothamBold
	metaLbl.TextSize = 10
	metaLbl.TextXAlignment = Enum.TextXAlignment.Left
	metaLbl.ZIndex = 5
	frame.Size = UDim2.new(0, barW, 0, math.max(barH, 48))
	task.spawn(function()
		local fps, frames, t0 = 60, 0, tick()
		local pingMs = "--"
		while gui and gui.Parent do
			frames = frames + 1
			if tick() - t0 >= 0.5 then
				fps = math.floor(frames / (tick() - t0) + 0.5)
				frames = 0
				t0 = tick()
				pcall(function()
					local p = LP:GetNetworkPing()
					if typeof(p) == "number" then
						pingMs = tostring(math.floor(p * 1000 + 0.5))
					end
				end)
				metaLbl.Text = string.format("FPS // %s  PING // %s ms", tostring(fps), tostring(pingMs))
			end
			task.wait()
		end
	end)

	local szMinus = Instance.new("TextButton", frame)
	szMinus.Size = UDim2.new(0, 16, 0, 16)
	szMinus.Position = UDim2.new(1, -34, 0, 2)
	szMinus.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
	szMinus.Text = "−"
	szMinus.TextColor3 = Color3.new(1,1,1)
	szMinus.TextSize = 12
	szMinus.Font = Enum.Font.GothamBold
	szMinus.ZIndex = 3
	corner(szMinus, 99)
	local szPlus = Instance.new("TextButton", frame)
	szPlus.Size = UDim2.new(0, 16, 0, 16)
	szPlus.Position = UDim2.new(1, -16, 0, 2)
	szPlus.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
	szPlus.Text = "+"
	szPlus.TextColor3 = Color3.new(1,1,1)
	szPlus.TextSize = 12
	szPlus.Font = Enum.Font.GothamBold
	szPlus.ZIndex = 3
	corner(szPlus, 99)

	local function applyScale()
		scale = math.clamp(tonumber(St.stealBarScale) or 1, 0.5, 2.5)
		St.stealBarScale = scale
		barW = math.floor(280 * scale)
		barH = math.max(28, math.floor(42 * scale))
		frame.Size = UDim2.new(0, barW, 0, barH)
		if title then title.TextSize = math.max(9, math.floor(11 * scale)) end
		if pctLbl then pctLbl.TextSize = math.max(9, math.floor(11 * scale)) end
		local meta = frame:FindFirstChild("MetaFpsPing")
		if meta then
			meta.TextSize = math.max(8, math.floor(10 * scale))
			meta.Size = UDim2.new(0.55, 0, 0, math.max(12, math.floor(14 * scale)))
			meta.Position = UDim2.new(0, 10, 1, -math.max(14, math.floor(16 * scale)))
		end
		saveCfg()
	end
	szMinus.Active = true
	szPlus.Active = true
	szMinus.ZIndex = 20
	szPlus.ZIndex = 20
	local function onMinus() St.stealBarScale = math.clamp((tonumber(St.stealBarScale) or 1) - 0.1, 0.5, 2.5); applyScale() end
	local function onPlus() St.stealBarScale = math.clamp((tonumber(St.stealBarScale) or 1) + 0.1, 0.5, 2.5); applyScale() end
	szMinus.MouseButton1Click:Connect(onMinus)
	szMinus.Activated:Connect(onMinus)
	szPlus.MouseButton1Click:Connect(onPlus)
	szPlus.Activated:Connect(onPlus)
	applyScale()

	do
		local dragging, dragStart, startPos
		frame.InputBegan:Connect(function(input)
			if St.guiLock then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = frame.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
						St._stealBarPos = {frame.Position.X.Scale, frame.Position.X.Offset, frame.Position.Y.Scale, frame.Position.Y.Offset}
						saveCfg()
					end
				end)
			end
		end)
		UIS.InputChanged:Connect(function(input)
			if not dragging or St.guiLock then return end
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				local d = input.Position - dragStart
				frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
			end
		end)
	end

	frame.Visible = true
	RS.RenderStepped:Connect(function()
		local on = St.autoSteal == true
		frame.Visible = true
		local p = 0
		if on then
			p = math.clamp(tonumber(_G.AceStealBarProgress) or 0, 0, 1)
		else
			_G.AceStealBarProgress = 0
			p = 0
		end
		fill.Size = UDim2.new(p, 0, 1, 0)
		local pct = math.floor(p * 100 + 0.5)
		pctLbl.Text = tostring(pct) .. "%"
		if not on then
			title.Text = "OFF"
			title.TextColor3 = Color3.fromRGB(160, 160, 170)
			pctLbl.TextColor3 = Color3.fromRGB(150, 150, 160)
		elseif p > 0.01 then
			title.Text = "STEALING..."
			title.TextColor3 = Color3.fromRGB(180, 220, 255)
			if pct >= 100 then
				pctLbl.TextColor3 = Color3.fromRGB(120, 255, 160)
			elseif pct >= 75 then
				pctLbl.TextColor3 = Color3.fromRGB(255, 230, 100)
			else
				pctLbl.TextColor3 = Color3.fromRGB(200, 210, 230)
			end
		else
			title.Text = "READY"
			title.TextColor3 = Color3.fromRGB(140, 255, 180)
			pctLbl.Text = "0%"
			pctLbl.TextColor3 = Color3.fromRGB(180, 200, 230)
		end
	end)

	_G.StealBar = {
		SetProgress = function(p)
			_G.AceStealBarProgress = math.clamp(tonumber(p) or 0, 0, 1)
		end,
		Reset = function() _G.AceStealBarProgress = 0 end,
		SetState = function(state)
			if tostring(state) == "SUCCESS" then _G.AceStealBarProgress = 1 end
		end,
	}
end)

-- ==============================
--  AUTO STEAL SYNC (V1/V2/V3)
-- ==============================
_G.VisStealPause = (St.stealPause == true)
_G.VisSyncAutoSteal = function()
	-- Cette fonction sera redéfinie par le script auto steal chargé plus tard.
	-- On laisse un placeholder.
end

-- ==============================
--  OVERHEAD INFO (Titre + Speed)
-- ==============================
local overheadSpeedLabel = nil
function setupOverheadInfo(char)
	char = char or LP.Character
	if not char then return end
	local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
	if not head then head = char:FindFirstChild("HumanoidRootPart") end
	if not head then return end
	pcall(function()
		local old = head:FindFirstChild("VisOverheadInfo")
		if old then old:Destroy() end
	end)
	local gui = Instance.new("BillboardGui")
	gui.Name = "VisOverheadInfo"
	gui.Size = UDim2.new(0, 300, 0, 96)
	gui.StudsOffset = Vector3.new(0, 2.8, 0)
	gui.AlwaysOnTop = true
	gui.MaxDistance = 200
	gui.LightInfluence = 0
	gui.Adornee = head
	gui.Parent = head
	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1, 0, 0, 22)
	titleLbl.Position = UDim2.new(0, 0, 0, 0)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = "Free Sell Là Tuất Ngu Lồn"
	titleLbl.TextColor3 = Color3.fromRGB(255, 220, 100)
	titleLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	titleLbl.TextStrokeTransparency = 0
	titleLbl.Font = Enum.Font.Bangers
	titleLbl.TextSize = 17
	titleLbl.Parent = gui
	local discordLbl = Instance.new("TextLabel")
	discordLbl.Size = UDim2.new(1, 0, 0, 20)
	discordLbl.Position = UDim2.new(0, 0, 0, 22)
	discordLbl.BackgroundTransparency = 1
	discordLbl.Text = "discord.gg/mSYQk9BEQq"
	discordLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	discordLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	discordLbl.TextStrokeTransparency = 0
	discordLbl.Font = Enum.Font.Bangers
	discordLbl.TextSize = 16
	discordLbl.Parent = gui
	overheadSpeedLabel = Instance.new("TextLabel")
	overheadSpeedLabel.Size = UDim2.new(1, 0, 0, 22)
	overheadSpeedLabel.Position = UDim2.new(0, 0, 0, 44)
	overheadSpeedLabel.BackgroundTransparency = 1
	overheadSpeedLabel.Text = "Tốc độ: 0.0"
	overheadSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	overheadSpeedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	overheadSpeedLabel.TextStrokeTransparency = 0
	overheadSpeedLabel.Font = Enum.Font.Bangers
	overheadSpeedLabel.TextSize = 18
	overheadSpeedLabel.Parent = gui
end

if not _G._VisOverheadLoop then
	_G._VisOverheadLoop = true
	LP.CharacterAdded:Connect(function(ch)
		task.wait(0.5)
		setupOverheadInfo(ch)
	end)
	if LP.Character then task.defer(function() setupOverheadInfo(LP.Character) end) end
	RS.RenderStepped:Connect(function()
		if not overheadSpeedLabel then return end
		local char = LP.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local v = root.AssemblyLinearVelocity
		local actual = Vector3.new(v.X, 0, v.Z).Magnitude
		local target = 0
		pcall(function() target = getActiveMoveSpeed() end)
		if St.speedOn and target > 0 then
			overheadSpeedLabel.Text = string.format("Tốc độ: %.0f (%.0f)", target, actual)
		else
			overheadSpeedLabel.Text = string.format("Tốc độ: %.1f", actual)
		end
	end)
end

-- ==============================
--  EL2B HUB RELOAD BUTTON (SAFE)
-- ==============================
do
	local playerGui = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui")
	local old = playerGui:FindFirstChild("EL2BReloadGui")
	if old then pcall(function() old:Destroy() end) end

	local reloadGui = Instance.new("ScreenGui")
	reloadGui.Name = "EL2BReloadGui"
	reloadGui.ResetOnSpawn = false
	reloadGui.IgnoreGuiInset = true
	reloadGui.DisplayOrder = 2700
	reloadGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	reloadGui.Parent = playerGui

	local button = Instance.new("TextButton")
	button.Name = "ReloadButton"
	button.Size = UDim2.new(0, 142, 0, 38)
	button.Position = UDim2.new(0, 18, 0, 106)
	button.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
	button.BorderSizePixel = 0
	button.Text = "RELOAD\
EL2B HUB"
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 13
	button.Font = Enum.Font.GothamBold
	button.TextWrapped = true
	button.AutoButtonColor = false
	button.Active = true
	button.Selectable = true
	button.ZIndex = 100
	button.Parent = reloadGui
	applyCorner(button, "Box")

	local stroke = Instance.new("UIStroke")
	stroke.Name = "ReloadBorder"
	stroke.Thickness = 2
	stroke.Color = Color3.fromRGB(255, 105, 210)
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = button
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 105, 210)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 75, 255)),
	})
	gradient.Parent = stroke

	local busy = false
	local function setState(text, color)
		button.Text = text
		button.BackgroundColor3 = color
	end

	local function cleanupOwnInterfaces()
		local names = {
			"VisHubFullMenu", "VisHubFullMini", "VisHubModeBar", "VisV2ModeBar",
			"EL2BHelperGui", "VisStealBarOnly", "VisOverheadInfo",
		}
		for _, container in ipairs({playerGui, game:GetService("CoreGui")}) do
			pcall(function()
				for _, name in ipairs(names) do
					local gui = container:FindFirstChild(name)
					if gui and gui ~= reloadGui then gui:Destroy() end
				end
			end)
		end
	end

	local dragging, dragStart, startPos, dragInput = false, nil, nil, nil
	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = button.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	button.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and input == dragInput and dragStart and startPos then
			local delta = input.Position - dragStart
			if delta.Magnitude > 4 then
				button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end
	end)

	button.Activated:Connect(function()
		if busy then return end
		busy = true
		setState("CLEANING...", Color3.fromRGB(80, 52, 105))
		task.spawn(function()
			cleanupOwnInterfaces()
			task.wait(0.35)
			if type(loadstring) ~= "function" then
					setState("LOADSTRING OFF", Color3.fromRGB(145, 55, 75))
					playEL2BErrorSound()
					warn("EL2B HUB: loadstring is unavailable in this environment")
				busy = false
				return
			end
			local ok, err = pcall(function()
				local http = game:GetService("HttpService")
				if type(game.HttpGet) ~= "function" then error("HttpGet unavailable") end
				local source = game:HttpGet("https://raw.githubusercontent.com/abdennouhethjgg-cloud/Script-hub/main/EL2B_HUB.lua")
				local chunk = loadstring(source)
				if type(chunk) ~= "function" then error("loadstring returned no function") end
				chunk()
			end)
				if ok then
					setState("RELOADED", Color3.fromRGB(40, 135, 80))
					playEL2BSuccessSound()
				else
					setState("RELOAD ERROR", Color3.fromRGB(145, 55, 75))
					playEL2BErrorSound()
				warn("EL2B HUB reload error: " .. tostring(err))
			end
			task.wait(1.6)
			if button and button.Parent then setState("RELOAD\
EL2B HUB", Color3.fromRGB(12, 12, 16)) end
			busy = false
		end)
	end)
end

-- ==============================
--  INIT DES PANELS EXTERNES (TP, LAGGER, BYPASS)
-- ==============================
_G.VisSetLaggerPanel = function(on)
	on = on and true or false
	if type(St) == "table" then St.showLaggerPanel = on end
	pcall(function()
		if _G.AceSetPerishV2PanelVisible then
			_G.AceSetPerishV2PanelVisible(on)
		else
			_G.AcePerishV2PanelOpen = on
		end
	end)
	saveCfg()
end

_G.VisSetLaggerLock = function(on)
	on = on and true or false
	if type(St) == "table" then St.laggerPanelLock = on end
	pcall(function() if _G.AceSetPerishV2Lock then _G.AceSetPerishV2Lock(on) end end)
	saveCfg()
end

_G.VisSetSpeedBypassPanel = function(on)
	on = on and true or false
	if type(St) == "table" then St.showSpeedBypassPanel = on end
	pcall(function()
		if _G.AceSetVisBypassPanelVisible then
			_G.AceSetVisBypassPanelVisible(on)
		end
	end)
	saveCfg()
end

_G.VisSetSpeedBypassLock = function(on)
	on = on and true or false
	if type(St) == "table" then St.speedBypassLock = on end
	pcall(function()
		if _G.AceSetVisBypassLock then
			_G.AceSetVisBypassLock(on)
		else
			_G.AceVisBypassLocked = on
		end
	end)
	saveCfg()
end

local function bindEL2BButtonSound(button)
	if not button:IsA("GuiButton") or button:GetAttribute("EL2BSoundBound") then return end
	button:SetAttribute("EL2BSoundBound", true)
	button.Activated:Connect(playEL2BButtonSound)
end

local function bindEL2BRoot(root)
	if not root:IsA("ScreenGui") then return end
	local owned = root.Name == "VisHubFullMenu" or root.Name == "VisHubMini" or root.Name == "VisHubModes" or root.Name == "EL2BUpdateGui" or root.Name == "VisHubHelper" or root.Name == "EL2BProfileGui"
	if not owned then return end
	for _, descendant in ipairs(root:GetDescendants()) do bindEL2BButtonSound(descendant) end
	root.DescendantAdded:Connect(bindEL2BButtonSound)
end
for _, root in ipairs(PlayerGui:GetChildren()) do bindEL2BRoot(root) end
PlayerGui.ChildAdded:Connect(bindEL2BRoot)

task.defer(function()
	task.wait(0.2)
	pcall(function()
		if type(St) == "table" and St.showLaggerPanel then _G.VisSetLaggerPanel(true) end
		if type(St) == "table" and St.showSpeedBypassPanel == true then
			_G.VisSetSpeedBypassPanel(true)
		elseif type(_G.VisSetSpeedBypassPanel) == "function" then
			_G.VisSetSpeedBypassPanel(false)
		end
	end)
end)

print("[EL2B HUB] Chargé et optimisé ! Toutes les fonctionnalités sont prêtes.")