--[[
    RemoteLister Pro
    Scanner local de RemoteEvent et RemoteFunction pour Roblox.
    Detection dynamique, recherche, filtres et analyse locale.
    Aucune requete HTTP, aucun webhook, aucune collecte distante.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
if not player then warn("[RemoteLister] LocalPlayer indisponible."); return end

local function safeClipboard(text)
    local fn = setclipboard or toclipboard
    if type(fn) ~= "function" then return false end
    return pcall(fn, text)
end

-- Analyse heuristique locale : elle classe les noms sans envoyer de donnees.
local function classify(name)
    local n = string.lower(name)
    local rules = {
        {"Combat", {"attack", "hit", "damage", "weapon", "shoot", "fire", "punch", "sword"}},
        {"Achat", {"buy", "purchase", "shop", "product", "crate", "trade", "gift"}},
        {"Quete", {"quest", "mission", "objective", "task", "reward"}},
        {"Teleport", {"teleport", "tp", "portal", "spawn", "travel"}},
        {"Joueur", {"player", "character", "equip", "inventory", "loadout"}},
        {"Interface", {"ui", "menu", "dialog", "button", "click", "prompt"}},
    }
    for _, rule in ipairs(rules) do
        for _, keyword in ipairs(rule[2]) do
            if string.find(n, keyword, 1, true) then return rule[1], 0.82 end
        end
    end
    return "Autre", 0.35
end

local records, index = {}, {}
local filterName, searchText, queued = "Tous", "", false
local function isRemote(obj) return obj and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) end

local function scan()
    local alive = {}
    for _, obj in ipairs(game:GetDescendants()) do
        if isRemote(obj) then
            alive[obj] = true
            if not index[obj] then
                local category, confidence = classify(obj.Name)
                index[obj] = {instance = obj, path = obj:GetFullName(), name = obj.Name, kind = obj.ClassName, category = category, confidence = confidence}
            else index[obj].path = obj:GetFullName() end
        end
    end
    for obj in pairs(index) do if not alive[obj] or not obj.Parent then index[obj] = nil end end
    records = {}
    for _, record in pairs(index) do table.insert(records, record) end
    table.sort(records, function(a, b) return a.path < b.path end)
end
scan()

local gui = Instance.new("ScreenGui")
gui.Name, gui.ResetOnSpawn, gui.ZIndexBehavior = "RemoteListerPro", false, Enum.ZIndexBehavior.Sibling
local ok, playerGui = pcall(function() return player:WaitForChild("PlayerGui", 10) end)
if not ok or not playerGui then warn("[RemoteLister] PlayerGui introuvable."); return end
gui.Parent = playerGui
local previousGui = playerGui:FindFirstChild("RemoteListerPro")
if previousGui and previousGui ~= gui then previousGui:Destroy() end

local function make(className, props, parent)
    local obj = Instance.new(className)
    for key, value in pairs(props or {}) do obj[key] = value end
    obj.Parent = parent
    return obj
end
local function round(obj, radius) make("UICorner", {CornerRadius = UDim.new(0, radius)}, obj) end

local root = make("Frame", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1}, gui)
local panel = make("Frame", {Size = UDim2.new(0, 640, 0, 570), Position = UDim2.new(.5, -320, .5, -285), BackgroundColor3 = Color3.fromRGB(15, 18, 28), BorderSizePixel = 0, ClipsDescendants = true}, root)
round(panel, 16)
make("UIStroke", {Color = Color3.fromRGB(71, 84, 122), Thickness = 1}, panel)
make("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(25, 30, 48), Color3.fromRGB(11, 14, 22)), Rotation = 90}, panel)

local top = make("Frame", {Size = UDim2.new(1, 0, 0, 78), BackgroundColor3 = Color3.fromRGB(47, 74, 145), BorderSizePixel = 0}, panel)
make("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(56, 101, 190), Color3.fromRGB(103, 51, 163)), Rotation = 20}, top)
make("TextLabel", {Size = UDim2.new(1, -150, 0, 30), Position = UDim2.new(0, 20, 0, 12), BackgroundTransparency = 1, Text = "REMOTE LISTER  /  PRO", TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold, TextSize = 20, TextXAlignment = Enum.TextXAlignment.Left}, top)
make("TextLabel", {Size = UDim2.new(1, -150, 0, 20), Position = UDim2.new(0, 21, 0, 43), BackgroundTransparency = 1, Text = "Scanner dynamique  •  Analyse locale intelligente", TextColor3 = Color3.fromRGB(205, 220, 255), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, top)
local close = make("TextButton", {Size = UDim2.new(0, 38, 0, 34), Position = UDim2.new(1, -54, 0, 15), BackgroundColor3 = Color3.fromRGB(201, 62, 81), Text = "X", TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold, TextSize = 20, BorderSizePixel = 0}, top)
round(close, 9)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local search = make("TextBox", {Size = UDim2.new(1, -40, 0, 38), Position = UDim2.new(0, 20, 0, 92), BackgroundColor3 = Color3.fromRGB(27, 32, 48), PlaceholderText = "Rechercher un nom, chemin ou categorie...", PlaceholderColor3 = Color3.fromRGB(135, 147, 176), Text = "", TextColor3 = Color3.fromRGB(240, 244, 255), Font = Enum.Font.Gotham, TextSize = 13, ClearTextOnFocus = false, BorderSizePixel = 0}, panel)
round(search, 9)
make("UIStroke", {Color = Color3.fromRGB(62, 78, 113), Thickness = 1}, search)
local stats = make("TextLabel", {Size = UDim2.new(.6, 0, 0, 27), Position = UDim2.new(0, 22, 0, 138), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(166, 183, 221), Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, panel)
local copy = make("TextButton", {Size = UDim2.new(0, 132, 0, 30), Position = UDim2.new(1, -152, 0, 136), BackgroundColor3 = Color3.fromRGB(41, 174, 125), Text = "Copier la liste", TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0}, panel)
round(copy, 8)

local filterBar = make("Frame", {Size = UDim2.new(1, -40, 0, 32), Position = UDim2.new(0, 20, 0, 168), BackgroundTransparency = 1}, panel)
make("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, filterBar)
local names = {"Tous", "RemoteEvent", "RemoteFunction", "Combat", "Achat", "Quete", "Autre"}
local buttons = {}
for i, name in ipairs(names) do
    local width = i <= 3 and 100 or 62
    local button = make("TextButton", {Size = UDim2.new(0, width, 0, 28), LayoutOrder = i, BackgroundColor3 = Color3.fromRGB(39, 47, 68), Text = name, TextColor3 = Color3.fromRGB(193, 204, 230), Font = Enum.Font.GothamMedium, TextSize = 11, BorderSizePixel = 0}, filterBar)
    round(button, 7); buttons[name] = button
    button.MouseButton1Click:Connect(function() filterName = name end)
end

local list = make("ScrollingFrame", {Size = UDim2.new(1, -40, 1, -218), Position = UDim2.new(0, 20, 0, 208), BackgroundColor3 = Color3.fromRGB(10, 13, 21), BackgroundTransparency = .1, BorderSizePixel = 0, ScrollBarThickness = 5, ScrollBarImageColor3 = Color3.fromRGB(81, 105, 175), CanvasSize = UDim2.new()}, panel)
round(list, 10)
local layout = make("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, list)
make("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8)}, list)

local function matches(record)
    local q = string.lower(searchText)
    local filterOk = filterName == "Tous" or record.kind == filterName or record.category == filterName
    local textOk = q == "" or string.find(string.lower(record.path), q, 1, true) or string.find(string.lower(record.category), q, 1, true)
    return filterOk and textOk
end

local function rebuild()
    for _, child in ipairs(list:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    local shown, eventCount, functionCount = 0, 0, 0
    for _, record in ipairs(records) do
        if record.kind == "RemoteEvent" then eventCount = eventCount + 1 else functionCount = functionCount + 1 end
        if matches(record) then
            shown = shown + 1
            local row = make("Frame", {Size = UDim2.new(1, 0, 0, 48), BackgroundColor3 = shown % 2 == 0 and Color3.fromRGB(25, 31, 46) or Color3.fromRGB(20, 25, 38), BorderSizePixel = 0}, list)
            round(row, 7)
            make("TextLabel", {Size = UDim2.new(1, -155, 0, 23), Position = UDim2.new(0, 12, 0, 5), BackgroundTransparency = 1, Text = record.path, TextColor3 = Color3.fromRGB(231, 237, 255), Font = Enum.Font.GothamMedium, TextSize = 12, TextTruncate = Enum.TextTruncate.AtEnd, TextXAlignment = Enum.TextXAlignment.Left}, row)
            make("TextLabel", {Size = UDim2.new(1, -155, 0, 16), Position = UDim2.new(0, 12, 0, 27), BackgroundTransparency = 1, Text = record.kind .. "  •  " .. record.category, TextColor3 = Color3.fromRGB(132, 155, 203), Font = Enum.Font.Gotham, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left}, row)
            local badge = make("TextLabel", {Size = UDim2.new(0, 120, 0, 22), Position = UDim2.new(1, -132, 0, 13), BackgroundColor3 = Color3.fromRGB(39, 55, 91), Text = string.format("IA %.0f%%", record.confidence * 100), TextColor3 = Color3.fromRGB(184, 210, 255), Font = Enum.Font.GothamBold, TextSize = 10, BorderSizePixel = 0}, row)
            round(badge, 6)
        end
    end
    list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
    stats.Text = string.format("%d affiches  •  %d RemoteEvent  •  %d RemoteFunction", shown, eventCount, functionCount)
    for name, button in pairs(buttons) do
        button.BackgroundColor3 = name == filterName and Color3.fromRGB(67, 94, 164) or Color3.fromRGB(39, 47, 68)
        button.TextColor3 = name == filterName and Color3.new(1, 1, 1) or Color3.fromRGB(193, 204, 230)
    end
end

local function queueRefresh()
    if queued then return end
    queued = true
    task.delay(.15, function() queued = false; scan(); rebuild() end)
end
game.DescendantAdded:Connect(function(obj) if isRemote(obj) then queueRefresh() end end)
game.DescendantRemoving:Connect(function(obj) if index[obj] then queueRefresh() end end)
search:GetPropertyChangedSignal("Text"):Connect(function() searchText = search.Text; rebuild() end)
copy.MouseButton1Click:Connect(function()
    local lines = {"-- RemoteLister Pro --"}
    for _, record in ipairs(records) do if matches(record) then table.insert(lines, string.format("[%s | %s] %s", record.kind, record.category, record.path)) end end
    local success = safeClipboard(table.concat(lines, "\n"))
    copy.Text = success and "Copie !" or "Clipboard indisponible"
    task.delay(1.5, function() if copy.Parent then copy.Text = "Copier la liste" end end)
end)

-- La barre superieure permet de deplacer la fenetre.
do
    local dragging, dragStart, startPosition
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragStart, startPosition = true, input.Position, panel.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            panel.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end)
end

rebuild()
print(string.format("[RemoteLister Pro] Pret a scanner %d remote(s).", #records))
