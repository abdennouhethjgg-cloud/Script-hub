local cloneref = cloneref or function(object) return object end
local Players           = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService        = cloneref(game:GetService("RunService"))
local UserInputService  = cloneref(game:GetService("UserInputService"))
local HttpService       = cloneref(game:GetService("HttpService"))
local TweenService      = cloneref(game:GetService("TweenService"))  -- pour les animations
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Stop only a previous copy of this script.
if getgenv and type(getgenv().StopAura) == "function" then
    pcall(getgenv().StopAura)
end

-- CONFIGURATION SYSTEM --
local CONFIG_FILE = "ace_code_sniper_auto_redeem_test_config.json"
local savedConfig = {
    codeSniper = true,
    autoSubmit = true,
    submitAfter = 3,
    retypeInvalid = false,
    riddleSolver = false,
    externalAI = false,   -- [NEW]
}
pcall(function()
    if type(isfile) == "function" and type(readfile) == "function"
    and isfile(CONFIG_FILE) then
        local decoded = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if type(decoded) == "table" then
            if type(decoded.codeSniper) == "boolean" then savedConfig.codeSniper = decoded.codeSniper end
            if type(decoded.autoSubmit) == "boolean" then savedConfig.autoSubmit = decoded.autoSubmit end
            if type(decoded.submitAfter) == "number" then savedConfig.submitAfter = math.max(1, math.floor(decoded.submitAfter)) end
            if type(decoded.retypeInvalid) == "boolean" then savedConfig.retypeInvalid = decoded.retypeInvalid end
            if type(decoded.riddleSolver) == "boolean" then savedConfig.riddleSolver = decoded.riddleSolver end
            if type(decoded.externalAI) == "boolean" then savedConfig.externalAI = decoded.externalAI end
        end
    end
end)

local function saveConfig()
    if type(writefile) ~= "function" then return end
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode({
            codeSniper = savedConfig.codeSniper,
            autoSubmit = savedConfig.autoSubmit,
            submitAfter = savedConfig.submitAfter,
            retypeInvalid = savedConfig.retypeInvalid,
            riddleSolver = savedConfig.riddleSolver,
            externalAI = savedConfig.externalAI,
        }))
    end)
end

-- STATE VARIABLES --
local _enabled              = savedConfig.codeSniper
local _seen                 = {}
local _focused              = nil
local _lastBox              = nil
local _autoAccept           = savedConfig.autoSubmit
local _submitAfter          = savedConfig.submitAfter
local _capturedParts        = {}
local _lastWatchedBox       = nil
local _boxTextConn          = nil
local _boxAncestryConn      = nil
local _boxVisibilityConns   = {}
local _retypeInvalid        = savedConfig.retypeInvalid
local _riddleSolver         = savedConfig.riddleSolver
local _externalAI           = savedConfig.externalAI   -- [NEW]
local _lastNonBlankBoxText  = ""
local _pendingRejectedText  = nil
local _pendingRejectedBox   = nil
local _pendingRejectedUntil = 0
local _pendingRejectedToken = 0
local ACE_CASE_MODE         = "EXACT"
local ACE_WORD_COUNT        = 1

local getupvalues = (debug and debug.getupvalues) or getupvalues
local getconns    = getconnections or (debug and debug.getconnections)
local setupv      = (debug and debug.setupvalue) or setupvalue

-- Forward declarations
local COLORS
local setStatus, flashCode
local clearAceCapture, appendToBox, typeAndSubmitCode

-- Base locale extensible : ajoute ici les devinettes connues du jeu.
local BRAINROT_KNOWLEDGE = {
    { patterns = { "who am i", "what am i" }, answer = "PLAYER" },
    { patterns = { "yes or no", "is this a brainrot" }, answer = "YES" },
}

local function normalizeRiddleText(value)
    value = tostring(value or ""):lower()
    value = value:gsub("[àáâãäå]", "a"):gsub("[èéêë]", "e")
        :gsub("[ìíîï]", "i"):gsub("[òóôõö]", "o")
        :gsub("[ùúûü]", "u"):gsub("ç", "c")
    value = value:gsub("[%p]", " "):gsub("%s+", " ")
    return value:match("^%s*(.-)%s*$") or ""
end

local function riddlePatternMatches(text, pattern)
    local normalizedPattern = normalizeRiddleText(pattern)
    return normalizedPattern ~= "" and text:find(normalizedPattern, 1, true) ~= nil
end

local function extractRiddleNumber(message)
    local number = tostring(message or ""):match("[Rr]iddle%s*[#:]?%s*(%d+)")
    return number and tonumber(number) or nil
end

local function sanitizeAIAnswer(value)
    local answer = tostring(value or ""):gsub("[%c]", " "):gsub("%s+", " ")
    answer = answer:gsub("^%s+", ""):gsub("%s+$", "")
    answer = answer:gsub("^[`\"']+", ""):gsub("[`\"']+$", "")
    answer = answer:gsub("[%.,;:!?]+$", "")
    if answer == "" or #answer > 80 then return nil end
    if answer:lower():find("i cannot", 1, true) or answer:lower():find("i don't know", 1, true) then return nil end
    return answer:upper()
end

clearAceCapture = function()
    _capturedParts = {}
    _focused = nil
    _lastBox = nil
    _lastWatchedBox = nil
    _lastNonBlankBoxText = ""
    _pendingRejectedText = nil
    _pendingRejectedBox = nil
    _pendingRejectedUntil = 0
    _pendingRejectedToken += 1
    if _boxTextConn then _boxTextConn:Disconnect(); _boxTextConn = nil end
    if _boxAncestryConn then _boxAncestryConn:Disconnect(); _boxAncestryConn = nil end
    for box, connection in pairs(_boxVisibilityConns) do
        if connection then connection:Disconnect() end
        _boxVisibilityConns[box] = nil
    end
end

local FAST_SUBMIT_ENABLED = true
local FAST_SUBMIT_COOLDOWN = 0.12
local _lastFastSubmitAt = 0

appendToBox = function(box, text)
    if not box or not box:IsA("TextBox") then return false end
    local ok = pcall(function()
        box.Text = tostring(text or "")
        box:CaptureFocus()
        box.CursorPosition = -1
    end)
    return ok
end

local function isSubmitButton(instance)
    if not instance or not instance:IsA("GuiButton") then return false end
    local name = string.lower(tostring(instance.Name or ""))
    local text = ""
    if instance:IsA("TextButton") then
        text = string.lower(tostring(instance.Text or ""))
    end
    return name:find("submit", 1, true) or name:find("answer", 1, true)
        or name:find("confirm", 1, true) or name:find("send", 1, true)
        or text == "submit" or text == "answer" or text == "confirm"
        or text == "send" or text == "enter"
end

local function findSubmitButton(box)
    local current = box
    for _ = 1, 5 do
        if not current then break end
        for _, child in ipairs(current:GetDescendants()) do
            if isSubmitButton(child) and child.Visible and child.Active then return child end
        end
        current = current.Parent
    end
    return nil
end

local function activateSubmitButton(button)
    if not button then return false end
    local ok = pcall(function() button:Activate() end)
    return ok
end

typeAndSubmitCode = function(code, box)
    if not FAST_SUBMIT_ENABLED then return false end
    if not code or tostring(code) == "" then return false end
    if not box or not box:IsA("TextBox") then return false end
    local now = os.clock()
    if now - _lastFastSubmitAt < FAST_SUBMIT_COOLDOWN then return false end
    _lastFastSubmitAt = now
    if not appendToBox(box, code) then return false end
    local submitButton = findSubmitButton(box)
    if submitButton then
        task.defer(function()
            activateSubmitButton(submitButton)
            pcall(function() box:ReleaseFocus(true) end)
        end)
        return true
    end
    -- Fallback : envoie Enter si le jeu utilise FocusLost pour valider.
    task.defer(function()
        pcall(function() box:ReleaseFocus(true) end)
    end)
    return true
end

flashCode = function() end

-- ============================================================
--  OFFLINE RIDDLE SOLVER
--  La table locale est initialisée vide si aucune connaissance n'est fournie.
-- ============================================================

local function getHttpRequest()
    return (type(request) == "function" and request)
        or (syn and type(syn.request) == "function" and syn.request)
        or (http and type(http.request) == "function" and http.request)
        or (type(http_request) == "function" and http_request)
end

-- Soumission immédiate activée pour les réponses du quiz.
-- Le délai est volontairement court pour éviter les doubles activations, sans ajouter d’attente artificielle.
local SPIDERSAMMY_SYSTEM_PROMPT = [[
Tu es l'assistant officiel du quiz de SpiderSammy dans le jeu Roblox Steal a Brainrot.
Analyse uniquement la question reçue et donne la réponse attendue par le jeu.
Réponds uniquement avec la réponse finale, sans explication, sans guillemets, sans préfixe et sans phrase comme « la réponse est ».
Si plusieurs choix sont présents, renvoie uniquement le choix correct.
Si tu n'es pas certain, renvoie exactement UNKNOWN plutôt que d'inventer.
]]

local function queryOpenAI(question)
    local apiKey = ""
    local apiKeyFile = "openai_api_key.txt"
    local apiUrl = "https://api.openai.com/v1/chat/completions"
    local model = "gpt-4o-mini"
    if type(isfile) == "function" and type(readfile) == "function" then
        if isfile(apiKeyFile) then
            local ok, value = pcall(readfile, apiKeyFile)
            if ok then apiKey = tostring(value):gsub("%s+", "") end
        end
        if isfile("openai_api_url.txt") then
            local ok, value = pcall(readfile, "openai_api_url.txt")
            if ok and tostring(value):match("^https?://") then apiUrl = tostring(value):gsub("%s+$", "") end
        end
        if isfile("openai_model.txt") then
            local ok, value = pcall(readfile, "openai_model.txt")
            if ok and tostring(value):match("^%S+$") then model = tostring(value):gsub("%s+", "") end
        end
    end
    if apiKey == "" then
        setStatus("API key introuvable : " .. apiKeyFile, COLORS.Red)
        return nil
    end
    local httpRequest = getHttpRequest()
    if not httpRequest then
        setStatus("Aucun support HTTP avec en-têtes n'est disponible", COLORS.Red)
        return nil
    end

    local payload = {
        model = model,
        messages = {
            { role = "system", content = SPIDERSAMMY_SYSTEM_PROMPT },
            { role = "user", content = tostring(question) },
        },
        temperature = 0,
        max_tokens = 32,
    }
    local ok, response = pcall(httpRequest, {
        Url = apiUrl,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json", ["Authorization"] = "Bearer " .. apiKey },
        Body = HttpService:JSONEncode(payload),
    })
    if not ok or type(response) ~= "table" or tonumber(response.StatusCode) ~= 200 then
        setStatus("Échec de la requête IA externe", COLORS.Red)
        return nil
    end
    local decodedOk, data = pcall(function() return HttpService:JSONDecode(response.Body or "") end)
    if not decodedOk or type(data) ~= "table" or type(data.choices) ~= "table" or not data.choices[1] then
        setStatus("Réponse IA externe invalide", COLORS.Red)
        return nil
    end
    local content = data.choices[1].message and data.choices[1].message.content
    local answer = sanitizeAIAnswer(content)
    if answer == "UNKNOWN" then return nil end
    return answer
end

local _aiCache = {}
local _aiCacheTTL = 300
local _aiLastRequestAt = 0
local _aiRequestCooldown = 2

local function getCachedAIAnswer(key)
    local item = _aiCache[key]
    if type(item) ~= "table" then return nil end
    if os.clock() - item.time > _aiCacheTTL then _aiCache[key] = nil; return nil end
    return item.answer
end

-- Résolution prioritaire pour les questions de SpiderSammy : local, puis API externe.
local function solveOfflineRiddle(message)
    if not message or message == "" then return nil end

    -- 1. Recherche locale (BRAINROT_KNOWLEDGE)
    local normalized = normalizeRiddleText(message)
    if normalized == "" then return nil end
    for _, entry in ipairs(BRAINROT_KNOWLEDGE) do
        for _, pattern in ipairs(entry.patterns) do
            if riddlePatternMatches(normalized, pattern) then
                local answer = entry.answer
                answer = answer:gsub("%s+", "")
                return sanitizeAIAnswer(answer), extractRiddleNumber(message)
            end
        end
    end

    -- 2. Fallback local basique
    if normalized:find("who am i", 1, true) or normalized:find("what am i", 1, true) then
        return "PLAYER", extractRiddleNumber(message)
    end
    if normalized:find("yes or no", 1, true) and normalized:find("brainrot", 1, true) then
        return "YES", extractRiddleNumber(message)
    end

    -- 3. [NEW] IA externe si activée
    if _externalAI then
        local cacheKey = normalizeRiddleText(message)
        local cached = getCachedAIAnswer(cacheKey)
        if cached then return cached, extractRiddleNumber(message) end
        if os.clock() - _aiLastRequestAt < _aiRequestCooldown then return nil end
        _aiLastRequestAt = os.clock()
        local answer = queryOpenAI(message)
        if answer then
            _aiCache[cacheKey] = { answer = answer, time = os.clock() }
            return answer, extractRiddleNumber(message)
        end
    end

    return nil
end

-- Les fonctions riddle sont définies plus haut avec des valeurs sûres par défaut.

-- ============================================================
--  UTILITY & REDEEM LOGIC
-- ============================================================
-- Les fonctions de saisie sont définies plus haut ; aucun code absent n'est exécuté.

-- ============================================================
--  STYLING & GUI (version animée, thème Cyber Rog)
-- ============================================================

COLORS = {
    Window = Color3.fromRGB(10, 0, 20),
    Row = Color3.fromRGB(30, 5, 40),
    Control = Color3.fromRGB(80, 10, 60),
    Log = Color3.fromRGB(18, 2, 30),
    Border = Color3.fromRGB(255, 0, 150),
    White = Color3.fromRGB(255, 200, 230),
    Text = Color3.fromRGB(255, 100, 200),
    Dim = Color3.fromRGB(200, 100, 180),
    Accent = Color3.fromRGB(255, 0, 200),
    Green = Color3.fromRGB(0, 255, 200),
    Red = Color3.fromRGB(255, 50, 50),
}

local function addCorner(parent, radius)
    local value = Instance.new("UICorner")
    value.CornerRadius = UDim.new(0, radius)
    value.Parent = parent
    return value
end

local function addStroke(parent, color, thickness, transparency)
    local value = Instance.new("UIStroke")
    value.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    value.Color = color
    value.Thickness = thickness or 1
    value.Transparency = transparency or 0
    value.Parent = parent
    return value
end

local function makeLabel(parent, name, text, size, position, textSize, color, font)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextSize = textSize
    label.TextColor3 = color
    label.Font = font or Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = parent
    return label
end

-- Cleanup old GUIs
pcall(function()
    for _, name in ipairs({"ACECodeSniperUI", "AutoTypeCodesUI", "ACEPaste"}) do
        local previous = game.CoreGui:FindFirstChild(name)
        if previous then previous:Destroy() end
    end
end)
for _, name in ipairs({"ACECodeSniperUI", "AutoTypeCodesUI", "ACEPaste"}) do
    local previous = playerGui:FindFirstChild(name)
    if previous then previous:Destroy() end
end

-- MAIN GUI CREATION
local GUI = Instance.new("ScreenGui")
GUI.Name = "ACECodeSniperUI"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.DisplayOrder = 999
local guiParent = playerGui
pcall(function()
    local coreGui = cloneref(game:GetService("CoreGui"))
    if coreGui then guiParent = coreGui end
end)
local guiParentOk = pcall(function()
    GUI.Parent = guiParent
end)
if not guiParentOk or not GUI.Parent then
    pcall(function() GUI.Parent = playerGui end)
end

local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.fromOffset(310, 370)
Window.AnchorPoint = Vector2.new(1, 0)
Window.Position = UDim2.new(1, 30, 0, 8)  -- départ pour animation
Window.BackgroundColor3 = COLORS.Window
Window.BackgroundTransparency = 1        -- transparent pour l'animation
Window.BorderSizePixel = 0
Window.ClipsDescendants = true
Window.Parent = GUI
addCorner(Window, 14)
local stroke = addStroke(Window, COLORS.Border, 2, 0.5)

-- Apparition animée
task.defer(function()
    TweenService:Create(Window, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        Position = UDim2.new(1, -8, 0, 8)
    }):Play()
end)

-- Pulsation du stroke
if stroke then
    TweenService:Create(stroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Transparency = 0.2
    }):Play()
end

local InterfaceScale = Instance.new("UIScale")
InterfaceScale.Name = "InterfaceScale"
InterfaceScale.Scale = 0.92
InterfaceScale.Parent = Window

local viewportConnection
local function updateInterfaceScale()
    local camera = workspace.CurrentCamera
    if not camera then InterfaceScale.Scale = 0.92; return end
    local viewport = camera.ViewportSize
    local fitScale = math.min((viewport.X - 16) / 310, (viewport.Y - 16) / 370)
    if UserInputService.TouchEnabled then
        local mobileTarget = 0.72
        InterfaceScale.Scale = math.max(0.45, math.min(mobileTarget, fitScale))
    else
        InterfaceScale.Scale = 0.92
    end
end

local function watchViewport()
    if viewportConnection then viewportConnection:Disconnect(); viewportConnection = nil end
    local camera = workspace.CurrentCamera
    if camera then viewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateInterfaceScale) end
    updateInterfaceScale()
end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchViewport)
watchViewport()

local BackgroundImage = Instance.new("Frame")
BackgroundImage.Name = "ACEBackground"
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.Position = UDim2.fromOffset(0, 0)
BackgroundImage.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
BackgroundImage.BackgroundTransparency = 0
BackgroundImage.ZIndex = 1
BackgroundImage.Parent = Window
addCorner(BackgroundImage, 14)

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 150)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(150, 0, 200)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(80, 0, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 0, 20))
})
gradient.Rotation = 0
gradient.Parent = BackgroundImage

-- Animation du gradient (déplacement)
local gradOffset = 0
RunService.Heartbeat:Connect(function(dt)
    gradOffset = (gradOffset + dt * 0.03) % 1
    gradient.Offset = Vector2.new(gradOffset, 0)
end)

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 64)
Header.BackgroundTransparency = 1
Header.Active = true
Header.ZIndex = 3
Header.Parent = Window

-- Console (pour les logs)
local Console, ConsoleOutput, updateConsoleCanvas
local featureStates = {}
local CONSOLE_COLORS = {
    Dim = "rgb(200, 100, 180)",
    Amber = "rgb(255, 150, 200)",
    Green = "rgb(0, 255, 200)",
    Red = "rgb(255, 80, 80)",
    Cyan = "rgb(255, 200, 230)",
}

local function scrollConsoleToBottom()
    task.defer(function()
        task.wait()
        if not Console then return end
        if updateConsoleCanvas then updateConsoleCanvas() end
        local bottom = math.max(0, Console.AbsoluteCanvasSize.Y - Console.AbsoluteWindowSize.Y)
        Console.CanvasPosition = Vector2.new(0, bottom)
    end)
end

local function appendConsoleStatus(name, activated)
    if not ConsoleOutput then return end
    local state = activated and "ON" or "OFF"
    local stateColor = activated and CONSOLE_COLORS.Green or CONSOLE_COLORS.Red
    local line = '<font color="' .. CONSOLE_COLORS.Dim .. '">[setting]</font> '
        .. '<font color="' .. CONSOLE_COLORS.Amber .. '">' .. name .. "</font> "
        .. '<font color="' .. CONSOLE_COLORS.Dim .. '">-&gt;</font> '
        .. '<font color="' .. stateColor .. '">' .. state .. "</font>"
    if ConsoleOutput.Text == "" then ConsoleOutput.Text = line
    else ConsoleOutput.Text = ConsoleOutput.Text .. "\n\n" .. line end
    scrollConsoleToBottom()
end

-- Brand
local BrandMark = Instance.new("Frame")
BrandMark.Name = "BrandMark"
BrandMark.Size = UDim2.fromOffset(30, 30)
BrandMark.Position = UDim2.fromOffset(17, 15)
BrandMark.BackgroundColor3 = COLORS.Window
BrandMark.BackgroundTransparency = 1
BrandMark.BorderSizePixel = 0
BrandMark.ClipsDescendants = true
BrandMark.Parent = Header
addCorner(BrandMark, 15)

local BrandImage = Instance.new("ImageLabel")
BrandImage.Name = "Logo"
BrandImage.Size = UDim2.fromScale(1, 1)
BrandImage.BackgroundTransparency = 1
BrandImage.Image = "rbxassetid://73792644227694"  -- logo Havoc
BrandImage.ScaleType = Enum.ScaleType.Fit
BrandImage.Parent = BrandMark
addCorner(BrandImage, 15)

makeLabel(Header, "Title", "HAVOC CODE SNIPER", UDim2.fromOffset(180, 25), UDim2.fromOffset(56, 17), 15, COLORS.White, Enum.Font.GothamBold)

-- AutoWrite toggle avec animations
local AutoWriteButton = Instance.new("TextButton")
AutoWriteButton.Name = "AutoWrite"
AutoWriteButton.Size = UDim2.fromOffset(47, 24)
AutoWriteButton.Position = UDim2.new(1, -64, 0, 18)
AutoWriteButton.BackgroundColor3 = _enabled and COLORS.Accent or COLORS.Control
AutoWriteButton.BorderSizePixel = 0
AutoWriteButton.AutoButtonColor = false
AutoWriteButton.Active = true
AutoWriteButton.Text = ""
AutoWriteButton.ZIndex = 5
AutoWriteButton.Parent = Header
addCorner(AutoWriteButton, 12)

local AutoWriteStroke = addStroke(AutoWriteButton, COLORS.White, 1, _enabled and 0.62 or 0.88)
local AutoWriteKnob = Instance.new("Frame")
AutoWriteKnob.Name = "Knob"
AutoWriteKnob.Size = UDim2.fromOffset(20, 20)
AutoWriteKnob.Position = _enabled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
AutoWriteKnob.BackgroundColor3 = _enabled and COLORS.Window or COLORS.White
AutoWriteKnob.BorderSizePixel = 0
AutoWriteKnob.ZIndex = 6
AutoWriteKnob.Parent = AutoWriteButton
addCorner(AutoWriteKnob, 10)

-- Animations de survol pour AutoWriteButton
AutoWriteButton.MouseEnter:Connect(function()
    TweenService:Create(AutoWriteButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = (_enabled and COLORS.Accent or COLORS.Control):Lerp(Color3.fromRGB(255,200,255), 0.3)
    }):Play()
end)
AutoWriteButton.MouseLeave:Connect(function()
    TweenService:Create(AutoWriteButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = _enabled and COLORS.Accent or COLORS.Control
    }):Play()
end)

local lastToggleTime = 0
local function toggleAutoWrite()
    if tick() - lastToggleTime < 0.15 then return end
    lastToggleTime = tick()
    _enabled = not _enabled
    if not _enabled and clearAceCapture then clearAceCapture() end
    savedConfig.codeSniper = _enabled
    saveConfig()
    _lastStatusMsg = nil
    AutoWriteButton.BackgroundColor3 = _enabled and COLORS.Accent or COLORS.Control
    AutoWriteStroke.Transparency = _enabled and 0.62 or 0.88
    AutoWriteKnob.BackgroundColor3 = _enabled and COLORS.Window or COLORS.White
    AutoWriteKnob.Position = _enabled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    if ConsoleOutput then
        if _enabled then
            ConsoleOutput.Text = '<font color="' .. CONSOLE_COLORS.Amber .. '">&gt;</font> <font color="' .. CONSOLE_COLORS.Dim .. '">scanning for codes...</font>'
            for _, featureName in ipairs({"Auto submit", "AI riddles", "External AI", "Retype invalid"}) do
                if featureStates[featureName] then appendConsoleStatus(featureName, true) end
            end
        else
            ConsoleOutput.Text = '<font color="' .. CONSOLE_COLORS.Dim .. '">status:</font> <font color="' .. CONSOLE_COLORS.Red .. '">OFF</font>\n<font color="' .. CONSOLE_COLORS.Dim .. '">code sniper paused</font>'
        end
        scrollConsoleToBottom()
    end
end

AutoWriteButton.Activated:Connect(toggleAutoWrite)
AutoWriteButton.MouseButton1Click:Connect(toggleAutoWrite)
AutoWriteButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleAutoWrite()
    end
end)

local HeaderAccent = Instance.new("Frame")
HeaderAccent.Name = "TitleDivider"
HeaderAccent.Size = UDim2.new(1, -34, 0, 1)
HeaderAccent.Position = UDim2.fromOffset(17, 54)
HeaderAccent.BackgroundColor3 = COLORS.White
HeaderAccent.BackgroundTransparency = 0.72
HeaderAccent.BorderSizePixel = 0
HeaderAccent.Parent = Header

-- Settings
local Settings = Instance.new("Frame")
Settings.Name = "Settings"
Settings.Size = UDim2.new(1, 0, 0, 200)  -- agrandi pour accueillir External AI
Settings.Position = UDim2.fromOffset(0, 65)
Settings.BackgroundTransparency = 1
Settings.ZIndex = 3
Settings.Parent = Window

local function makeCard(name, position, size)
    local card = Instance.new("Frame")
    card.Name = name
    card.Position = position
    card.Size = size
    card.BackgroundColor3 = COLORS.Row
    card.BackgroundTransparency = 0.68
    card.BorderSizePixel = 0
    card.Parent = Settings
    addCorner(card, 9)
    addStroke(card, COLORS.White, 1, 0.76)
    return card
end

local function makeStateButton(parent, enabled, consoleName, onToggle)
    parent.Active = true
    featureStates[consoleName] = enabled
    local button = Instance.new("TextButton")
    button.Name = "State"
    button.Size = UDim2.fromOffset(42, 20)
    button.Position = UDim2.new(1, -50, 0.5, -10)
    button.BackgroundColor3 = enabled and COLORS.Accent or COLORS.Control
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Active = true
    button.Text = enabled and "ON" or "OFF"
    button.TextSize = 8
    button.TextColor3 = enabled and COLORS.Window or COLORS.Dim
    button.Font = Enum.Font.GothamBold
    button.ZIndex = 5
    button.Parent = parent
    addCorner(button, 6)
    local outline = addStroke(button, COLORS.White, 1, enabled and 0.62 or 0.88)
    local state = enabled
    local lastSubToggle = 0
    
    -- Animations de survol
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = (state and COLORS.Accent or COLORS.Control):Lerp(Color3.fromRGB(255,200,255), 0.3)
        }):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = state and COLORS.Accent or COLORS.Control
        }):Play()
    end)

    local function toggleState()
        if tick() - lastSubToggle < 0.15 then return end
        lastSubToggle = tick()
        state = not state
        featureStates[consoleName] = state
        button.Text = state and "ON" or "OFF"
        button.BackgroundColor3 = state and COLORS.Accent or COLORS.Control
        button.TextColor3 = state and COLORS.Window or COLORS.Dim
        outline.Transparency = state and 0.62 or 0.88
        if _enabled then appendConsoleStatus(consoleName, state) end
        if onToggle then onToggle(state) end
        -- Effet de rebond
        TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(44, 22)
        }):Play()
        task.wait(0.1)
        TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(42, 20)
        }):Play()
    end
    
    button.Activated:Connect(toggleState)
    button.MouseButton1Click:Connect(toggleState)
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggleState()
        end
    end)
    return button
end

local AutoCard = makeCard("AutoSubmit", UDim2.fromOffset(17, 0), UDim2.fromOffset(135, 50))
makeLabel(AutoCard, "Title", "Auto submit", UDim2.new(1, -58, 1, 0), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
makeStateButton(AutoCard, _autoAccept, "Auto submit", function(state)
    _autoAccept = state
    savedConfig.autoSubmit = state
    saveConfig()
end)

local AICard = makeCard("AIRiddles", UDim2.fromOffset(158, 0), UDim2.fromOffset(135, 50))
makeLabel(AICard, "Title", "AI riddles", UDim2.new(1, -58, 1, 0), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
makeStateButton(AICard, _riddleSolver, "AI riddles", function(state)
    _riddleSolver = state
    savedConfig.riddleSolver = state
    saveConfig()
end)

-- Nouvelle carte pour External AI
local ExtAICard = makeCard("ExternalAI", UDim2.fromOffset(17, 55), UDim2.fromOffset(135, 50))
makeLabel(ExtAICard, "Title", "External AI", UDim2.new(1, -58, 1, 0), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
makeStateButton(ExtAICard, _externalAI, "External AI", function(state)
    _externalAI = state
    savedConfig.externalAI = state
    saveConfig()
    if state then
        setStatus("🌐 External AI enabled (requires API key)", COLORS.Green)
    else
        setStatus("🌐 External AI disabled", COLORS.Dim)
    end
end)

local DelayCard = makeCard("SubmitAfter", UDim2.fromOffset(158, 55), UDim2.fromOffset(135, 50))
makeLabel(DelayCard, "Title", "Submit after", UDim2.new(1, -58, 1, 0), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
local CounterShell = Instance.new("Frame")
CounterShell.Name = "Counter"
CounterShell.Size = UDim2.fromOffset(96, 31)
CounterShell.Position = UDim2.new(1, -105, 0.5, -15)
CounterShell.BackgroundColor3 = COLORS.Window
CounterShell.BackgroundTransparency = 0.05
CounterShell.BorderSizePixel = 0
CounterShell.Parent = DelayCard
addCorner(CounterShell, 7)
addStroke(CounterShell, COLORS.White, 1, 0.86)

local Minus = Instance.new("TextButton")
Minus.Name = "Minus"
Minus.Size = UDim2.fromOffset(25, 25)
Minus.Position = UDim2.fromOffset(3, 3)
Minus.BackgroundColor3 = COLORS.Control
Minus.BorderSizePixel = 0
Minus.AutoButtonColor = false
Minus.Active = true
Minus.Text = "-"
Minus.TextSize = 16
Minus.TextColor3 = COLORS.Text
Minus.Font = Enum.Font.GothamBold
Minus.Parent = CounterShell
addCorner(Minus, 5)

local Count = makeLabel(CounterShell, "Count", tostring(_submitAfter), UDim2.fromOffset(28, 25), UDim2.fromOffset(34, 3), 17, COLORS.White, Enum.Font.GothamBold)
Count.TextXAlignment = Enum.TextXAlignment.Center

local Plus = Instance.new("TextButton")
Plus.Name = "Plus"
Plus.Size = UDim2.fromOffset(25, 25)
Plus.Position = UDim2.fromOffset(68, 3)
Plus.BackgroundColor3 = COLORS.Control
Plus.BorderSizePixel = 0
Plus.AutoButtonColor = false
Plus.Active = true
Plus.Text = "+"
Plus.TextSize = 16
Plus.TextColor3 = COLORS.Text
Plus.Font = Enum.Font.GothamBold
Plus.Parent = CounterShell
addCorner(Plus, 5)

-- Animations pour Minus et Plus
for _, btn in ipairs({Minus, Plus}) do
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = COLORS.Accent:Lerp(Color3.fromRGB(255,200,255), 0.3),
            Size = UDim2.fromOffset(28, 28)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = COLORS.Control,
            Size = UDim2.fromOffset(25, 25)
        }):Play()
    end)
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(22, 22)
        }):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(25, 25)
        }):Play()
    end)
end

local function decr()
    _submitAfter = math.max(1, _submitAfter - 1)
    Count.Text = tostring(_submitAfter)
    savedConfig.submitAfter = _submitAfter
    clearAceCapture()
    saveConfig()
end
local function incr()
    _submitAfter += 1
    Count.Text = tostring(_submitAfter)
    savedConfig.submitAfter = _submitAfter
    clearAceCapture()
    saveConfig()
end

Minus.Activated:Connect(decr)
Minus.MouseButton1Click:Connect(decr)
Plus.Activated:Connect(incr)
Plus.MouseButton1Click:Connect(incr)

local RetypeCard = makeCard("RetypeInvalid", UDim2.fromOffset(17, 110), UDim2.fromOffset(276, 38))
makeLabel(RetypeCard, "Title", "Retype invalid", UDim2.new(1, -65, 1, 0), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
local RetypeState = makeStateButton(RetypeCard, _retypeInvalid, "Retype invalid", function(state)
    _retypeInvalid = state
    savedConfig.retypeInvalid = state
    saveConfig()
end)
RetypeState.Position = UDim2.new(1, -50, 0.5, -10)

-- Console
Console = Instance.new("ScrollingFrame")
Console.Name = "Console"
Console.Size = UDim2.new(1, -34, 0, 127)
Console.Position = UDim2.fromOffset(17, 226)
Console.BackgroundColor3 = COLORS.Log
Console.BorderSizePixel = 0
Console.ClipsDescendants = true
Console.Active = true
Console.ScrollingEnabled = true
Console.ScrollingDirection = Enum.ScrollingDirection.Y
Console.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
Console.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
Console.CanvasSize = UDim2.new(0, 0, 0, 0)
Console.AutomaticCanvasSize = Enum.AutomaticSize.None
Console.ScrollBarThickness = 4
Console.ScrollBarImageColor3 = COLORS.Dim
Console.ZIndex = 3
Console.Parent = Window
addCorner(Console, 9)
addStroke(Console, COLORS.White, 1, 0.88)

ConsoleOutput = Instance.new("TextLabel")
ConsoleOutput.Name = "ConsoleOutput"
ConsoleOutput.Size = UDim2.new(1, -18, 0, 115)
ConsoleOutput.AutomaticSize = Enum.AutomaticSize.Y
ConsoleOutput.Position = UDim2.fromOffset(9, 6)
ConsoleOutput.BackgroundTransparency = 1
ConsoleOutput.RichText = true
if _enabled then
    ConsoleOutput.Text = '<font color="' .. CONSOLE_COLORS.Amber .. '">&gt;</font> <font color="' .. CONSOLE_COLORS.Dim .. '">scanning for codes...</font>'
else
    ConsoleOutput.Text = '<font color="' .. CONSOLE_COLORS.Dim .. '">status:</font> <font color="' .. CONSOLE_COLORS.Red .. '">OFF</font>\n<font color="' .. CONSOLE_COLORS.Dim .. '">code sniper paused</font>'
end
ConsoleOutput.TextSize = 14
ConsoleOutput.Font = Enum.Font.Code
ConsoleOutput.TextColor3 = COLORS.Dim
ConsoleOutput.TextXAlignment = Enum.TextXAlignment.Left
ConsoleOutput.TextYAlignment = Enum.TextYAlignment.Top
ConsoleOutput.TextWrapped = true
ConsoleOutput.ZIndex = 4
ConsoleOutput.Parent = Console

local CONSOLE_BOTTOM_PADDING = 30
updateConsoleCanvas = function()
    if not Console or not ConsoleOutput then return end
    local contentHeight = ConsoleOutput.Position.Y.Offset + ConsoleOutput.AbsoluteSize.Y + CONSOLE_BOTTOM_PADDING
    Console.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
end
ConsoleOutput:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateConsoleCanvas)
task.defer(updateConsoleCanvas)

local DiscordFooter = makeLabel(Window, "DiscordFooter", "discord.gg/aceduels", UDim2.fromOffset(140, 19), UDim2.new(0.5, -70, 0, 348), 10, COLORS.White, Enum.Font.GothamBold)
DiscordFooter.TextXAlignment = Enum.TextXAlignment.Center
DiscordFooter.BackgroundColor3 = COLORS.Window
DiscordFooter.BackgroundTransparency = 1
DiscordFooter.TextStrokeColor3 = COLORS.Window
DiscordFooter.TextStrokeTransparency = 0.45
DiscordFooter.ZIndex = 3

-- Déplacement de la fenêtre.
do
    local dragging = false
    local dragStart
    local startPosition
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = Window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStart
        Window.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end)
end

-- Fonctions d'état définies après la création de la console.
setStatus = function(message, color)
    if not ConsoleOutput then return end
    local text = tostring(message or "")
    local colorValue = color or COLORS.Dim
    local prefix = '<font color="' .. CONSOLE_COLORS.Cyan .. '">[status]</font> '
    local ok = pcall(function()
        ConsoleOutput.Text = prefix .. '<font color="rgb(' .. math.floor(colorValue.R * 255) .. ',' .. math.floor(colorValue.G * 255) .. ',' .. math.floor(colorValue.B * 255) .. ')">' .. text .. '</font>'
    end)
    if not ok then ConsoleOutput.Text = text end
    scrollConsoleToBottom()
end

appendToBox = appendToBox
flashCode = flashCode

-- Question watcher: détecte les textes de SpiderSammy et soumet la réponse.
local _questionConnections = {}
local _lastQuestionKey = ""
local _lastQuestionAt = 0

local function disconnectQuestionWatchers()
    for _, connection in ipairs(_questionConnections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(_questionConnections)
end

local function isLikelySpiderSammyQuestion(text)
    local raw = tostring(text or "")
    local value = normalizeRiddleText(raw)
    if #value < 4 or #value > 500 then return false end
    return value:find("spidersammy", 1, true) ~= nil
        or value:find("riddle", 1, true) ~= nil
        or value:find("question", 1, true) ~= nil
        or raw:find("?", 1, true) ~= nil
end

local function findAnswerBox(source)
    local current = source
    for _ = 1, 6 do
        if not current then break end
        for _, child in ipairs(current:GetDescendants()) do
            if child:IsA("TextBox") and child.Visible and child.Active and child ~= source then
                return child
            end
        end
        current = current.Parent
    end
    return nil
end

local function processSpiderSammyQuestion(source)
    if not _enabled or (not _riddleSolver and not _externalAI) then return end
    if not source or not source:IsA("TextLabel") then return end
    if source:IsDescendantOf(GUI) then return end
    local question = tostring(source.Text or "")
    if not isLikelySpiderSammyQuestion(question) then return end
    local key = normalizeRiddleText(question)
    if key == _lastQuestionKey and os.clock() - _lastQuestionAt < 2 then return end
    _lastQuestionKey = key
    _lastQuestionAt = os.clock()
    local answer, questionNumber = solveOfflineRiddle(question)
    if not answer then return end
    local answerBox = findAnswerBox(source)
    if answerBox and typeAndSubmitCode(answer, answerBox) then
        setStatus("SpiderSammy #" .. tostring(questionNumber or "?") .. " répondu", COLORS.Green)
    else
        setStatus("Réponse trouvée, champ Submit introuvable", COLORS.Dim)
    end
end

local function watchQuestionSource(instance)
    if not instance:IsA("TextLabel") then return end
    table.insert(_questionConnections, instance:GetPropertyChangedSignal("Text"):Connect(function()
        processSpiderSammyQuestion(instance)
    end))
    processSpiderSammyQuestion(instance)
end

local function startQuestionWatcher()
    disconnectQuestionWatchers()
    local roots = { playerGui }
    pcall(function() table.insert(roots, game:GetService("CoreGui")) end)
    for _, root in ipairs(roots) do
        for _, instance in ipairs(root:GetDescendants()) do
            watchQuestionSource(instance)
        end
        table.insert(_questionConnections, root.DescendantAdded:Connect(function(instance)
            watchQuestionSource(instance)
        end))
    end
    setStatus("SpiderSammy watcher actif", COLORS.Green)
end

task.defer(startQuestionWatcher)

if getgenv and type(getgenv) == "function" then
    getgenv().StopAura = function()
        _enabled = false
        clearAceCapture()
        disconnectQuestionWatchers()
        if GUI then GUI:Destroy() end
    end
end

-- ============================================================
--  FIN DU SCRIPT
-- ============================================================