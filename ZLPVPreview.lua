--[[
    ═══════════════════════════════════════════════════════════════
    EL2B HUB | Multi-Game Edition
    Auteur  : EL2B
    Version : 3.0 FINAL
    Jeux    : Steal an Egg      (107778070777162)
              Steal a Brainrot  (109983668079237)
    ═══════════════════════════════════════════════════════════════
]]

_MERGED = {}

--============================================================
-- CONFIG.LUA
--============================================================
_MERGED["Config.lua"] = [=[
_G.EL2B = {
    Name = "EL2B HUB",
    Version = "v3.0 Multi-Game",
    Author = "EL2B",
    AssetID = "rbxassetid://101352576986760",
    UI = {
        Width = 480, Height = 340, SidebarWidth = 115, TabHeight = 32,
        Theme = {
            Background = Color3.fromRGB(16, 17, 23),
            Sidebar    = Color3.fromRGB(20, 21, 28),
            TopBar     = Color3.fromRGB(23, 24, 32),
            Accent     = Color3.fromRGB(105, 90, 190),
            Text       = Color3.fromRGB(255, 255, 255),
            SubText    = Color3.fromRGB(145, 145, 165),
        }
    }
}
]=]

--============================================================
-- UI.LUA
--============================================================
_MERGED["UI.lua"] = [=[
local Services = {
    Players = game:GetService("Players"),
    TweenService = game:GetService("TweenService"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService"),
    CoreGui = game:GetService("CoreGui"),
    ContentProvider = game:GetService("ContentProvider"),
}

local Settings = _G.EL2B
local Theme = Settings.UI.Theme
local GuiParent = Services.CoreGui

pcall(function()
    if type(gethui) == "function" then
        local HUI = gethui()
        if HUI then GuiParent = HUI end
    end
end)

pcall(function()
    local Old = GuiParent:FindFirstChild("EL2B_HUB")
    if Old then Old:Destroy() end
    local OldToggle = GuiParent:FindFirstChild("ToggleGUI")
    if OldToggle then OldToggle:Destroy() end
end)

local ASSET_ID = Settings.AssetID
Services.ContentProvider:PreloadAsync({ASSET_ID})

local ToggleScreenGui = Instance.new("ScreenGui")
ToggleScreenGui.Name = "ToggleGUI"
ToggleScreenGui.ResetOnSpawn = false
ToggleScreenGui.IgnoreGuiInset = true
ToggleScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleScreenGui.Parent = GuiParent

local Toggle = Instance.new("ImageButton")
Toggle.Name = "Y"
Toggle.Size = UDim2.new(0, 55, 0, 55)
Toggle.Position = UDim2.new(0.02, 0, 0.5, -27.5)
Toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Toggle.BorderSizePixel = 0
Toggle.Image = ASSET_ID
Toggle.ZIndex = 999
Toggle.Parent = ToggleScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = Toggle

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(200, 200, 220)
ToggleStroke.Thickness = 1.5
ToggleStroke.Transparency = 0.2
ToggleStroke.Parent = Toggle

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EL2B_HUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = GuiParent

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, Settings.UI.Width, 0, Settings.UI.Height)
Main.Position = UDim2.new(0.5, -Settings.UI.Width / 2, 0.5, -Settings.UI.Height / 2)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 0)
MainCorner.Parent = Main

local MainBorder = Instance.new("UIStroke")
MainBorder.Color = Color3.fromRGB(200, 200, 220)
MainBorder.Thickness = 2
MainBorder.Transparency = 0.1
MainBorder.Parent = Main

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 58)
TopBar.BackgroundColor3 = Theme.TopBar
TopBar.BorderSizePixel = 0
TopBar.Active = true
TopBar.ZIndex = 20
TopBar.Parent = Main

local TopGradient = Instance.new("UIGradient")
TopGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(36, 38, 53)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 23, 30))
})
TopGradient.Parent = TopBar

local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, 0, 0, 2)
TopLine.Position = UDim2.new(0, 0, 1, -2)
TopLine.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
TopLine.BackgroundTransparency = 0.2
TopLine.BorderSizePixel = 0
TopLine.ZIndex = 22
TopLine.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -36, 0, 27)
Title.Position = UDim2.new(0, 18, 0, 7)
Title.BackgroundTransparency = 1
Title.Text = Settings.Name
Title.TextColor3 = Theme.Text
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.ZIndex = 21
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -36, 0, 18)
Subtitle.Position = UDim2.new(0, 18, 0, 32)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = Settings.Version
Subtitle.TextColor3 = Theme.SubText
Subtitle.TextSize = 10
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Font = Enum.Font.GothamMedium
Subtitle.ZIndex = 21
Subtitle.Parent = TopBar

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, Settings.UI.SidebarWidth, 1, -58)
Sidebar.Position = UDim2.new(0, 0, 0, 58)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 5
Sidebar.Parent = Main

local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 2, 1, 0)
SidebarLine.Position = UDim2.new(1, -2, 0, 0)
SidebarLine.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
SidebarLine.BackgroundTransparency = 0.15
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 6
SidebarLine.Parent = Sidebar

local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Name = "TabScroll"
TabScroll.Size = UDim2.new(1, 0, 1, 0)
TabScroll.BackgroundTransparency = 1
TabScroll.BorderSizePixel = 0
TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabScroll.ScrollingDirection = Enum.ScrollingDirection.Y
TabScroll.ScrollBarThickness = 0
TabScroll.ScrollBarImageTransparency = 1
TabScroll.Active = true
TabScroll.ZIndex = 6
TabScroll.Parent = Sidebar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 6)
TabPadding.PaddingBottom = UDim.new(0, 6)
TabPadding.PaddingLeft = UDim.new(0, 2)
TabPadding.PaddingRight = UDim.new(0, 2)
TabPadding.Parent = TabScroll

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 2)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabScroll

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -Settings.UI.SidebarWidth, 1, -58)
Content.Position = UDim2.new(0, Settings.UI.SidebarWidth, 0, 58)
Content.BackgroundColor3 = Theme.Background
Content.BorderSizePixel = 0
Content.ZIndex = 5
Content.Parent = Main

_G.EL2B_Main = Main
_G.EL2B_TopBar = TopBar
_G.EL2B_Sidebar = Sidebar
_G.EL2B_TabScroll = TabScroll
_G.EL2B_Content = Content
_G.EL2B_ScreenGui = ScreenGui
_G.EL2B_Toggle = Toggle
_G.EL2B_GuiParent = GuiParent

local Dragging, DragStart, StartPosition, ActiveTouch = false, nil, nil, nil

local function StartDrag(Input)
    if Dragging then return end
    if Input.UserInputType == Enum.UserInputType.Touch then ActiveTouch = Input end
    Dragging = true
    DragStart = Input.Position
    StartPosition = Main.Position
end

local function StopDrag()
    Dragging = false
    ActiveTouch = nil
    DragStart = nil
    StartPosition = nil
end

TopBar.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        StartDrag(Input)
    end
end)

Services.UserInputService.InputChanged:Connect(function(Input)
    if not Dragging then return end
    if Input.UserInputType == Enum.UserInputType.Touch then
        if ActiveTouch and Input ~= ActiveTouch then return end
    end
    if not DragStart or not StartPosition then return end
    if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then return end
    local Delta = Input.Position - DragStart
    Main.Position = UDim2.new(0, StartPosition.X.Offset + Delta.X, 0, StartPosition.Y.Offset + Delta.Y)
end)

Services.UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.Touch then
        if ActiveTouch and Input == ActiveTouch then StopDrag() end
        return
    end
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        if Dragging then StopDrag() end
    end
end)

local isUIVisible = true
Toggle.MouseButton1Click:Connect(function()
    isUIVisible = not isUIVisible
    ScreenGui.Enabled = isUIVisible
    Services.TweenService:Create(Toggle, TweenInfo.new(0.1, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 45, 0, 45) }):Play()
    task.wait(0.1)
    Services.TweenService:Create(Toggle, TweenInfo.new(0.1, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 55, 0, 55) }):Play()
end)
]=]

--============================================================
-- COMPONENTS.LUA
--============================================================
_MERGED["Components.lua"] = [=[
local TweenService = game:GetService("TweenService")

local function GetTabTextSize(Name)
    local L = #Name
    if L >= 16 then return 10
    elseif L >= 13 then return 11
    elseif L >= 9 then return 12
    elseif L >= 6 then return 13
    else return 14 end
end

function CreateTab(Name, Order)
    local TabScroll = _G.EL2B_TabScroll
    local Tab = Instance.new("TextButton")
    Tab.Name = Name:gsub("%s+", "_") .. "_Tab"
    Tab.Size = UDim2.new(1, 0, 0, 32)
    Tab.BackgroundColor3 = Color3.fromRGB(38, 40, 52)
    Tab.BackgroundTransparency = 1
    Tab.BorderSizePixel = 0
    Tab.Text = ""
    Tab.AutoButtonColor = false
    Tab.LayoutOrder = Order or 1
    Tab.ZIndex = 7
    Tab.Parent = TabScroll

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Tab

    local TabBorder = Instance.new("UIStroke")
    TabBorder.Color = Color3.fromRGB(200, 200, 220)
    TabBorder.Thickness = 1
    TabBorder.Transparency = 0.2
    TabBorder.Parent = Tab

    local Indicator = Instance.new("Frame")
    Indicator.Name = "Indicator"
    Indicator.Size = UDim2.new(0, 3, 0, 18)
    Indicator.Position = UDim2.new(0, 2, 0.5, -9)
    Indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    Indicator.BackgroundTransparency = 1
    Indicator.BorderSizePixel = 0
    Indicator.ZIndex = 8
    Indicator.Parent = Tab

    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = Indicator

    local Text = Instance.new("TextLabel")
    Text.Name = "TabText"
    Text.Size = UDim2.new(1, -10, 1, 0)
    Text.Position = UDim2.new(0, 8, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Text = Name
    Text.TextColor3 = Color3.fromRGB(155, 155, 175)
    Text.TextSize = GetTabTextSize(Name)
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.TextYAlignment = Enum.TextYAlignment.Center
    Text.Font = Enum.Font.GothamMedium
    Text.TextTruncate = Enum.TextTruncate.AtEnd
    Text.Parent = Tab
    return Tab
end

function CreatePage(Name)
    local Content = _G.EL2B_Content
    local Page = Instance.new("ScrollingFrame")
    Page.Name = Name .. "_Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.ScrollingDirection = Enum.ScrollingDirection.Y
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 220)
    Page.VerticalScrollBarInset = Enum.ScrollBarInset.Always
    Page.Parent = Content

    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 12)
    Padding.PaddingBottom = UDim.new(0, 14)
    Padding.PaddingLeft = UDim.new(0, 14)
    Padding.PaddingRight = UDim.new(0, 12)
    Padding.Parent = Page

    local List = Instance.new("UIListLayout")
    List.Padding = UDim.new(0, 4)
    List.SortOrder = Enum.SortOrder.LayoutOrder
    List.Parent = Page
    return Page
end

function CreateSectionTitle(Parent, TextValue, Order)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 23)
    Label.BackgroundTransparency = 1
    Label.Text = TextValue
    Label.TextColor3 = Color3.fromRGB(235, 235, 245)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.Font = Enum.Font.GothamBold
    Label.LayoutOrder = Order or 1
    Label.Parent = Parent
    return Label
end

-- Composant toggle réutilisable
function EL2B_MakeToggle(Parent, LabelText, SubText, Order, ToggleFunc, IsEnabledFunc)
    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1, 0, 0, SubText and 52 or 32)
    Holder.BackgroundTransparency = 1
    Holder.LayoutOrder = Order
    Holder.Parent = Parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 0, 20)
    Label.Position = UDim2.new(0, 0, 0, SubText and 2 or 6)
    Label.BackgroundTransparency = 1
    Label.Text = LabelText
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.Font = Enum.Font.GothamBold
    Label.Parent = Holder

    if SubText then
        local Sub = Instance.new("TextLabel")
        Sub.Size = UDim2.new(1, -50, 0, 18)
        Sub.Position = UDim2.new(0, 0, 0, 24)
        Sub.BackgroundTransparency = 1
        Sub.Text = SubText
        Sub.TextColor3 = Color3.fromRGB(150, 150, 170)
        Sub.TextSize = 10
        Sub.TextXAlignment = Enum.TextXAlignment.Left
        Sub.Font = Enum.Font.Gotham
        Sub.Parent = Holder
    end

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 26, 0, 26)
    Btn.Position = UDim2.new(1, -26, 0.5, -13)
    Btn.BackgroundColor3 = Color3.fromRGB(28, 29, 39)
    Btn.BorderSizePixel = 0
    Btn.Text = ""
    Btn.AutoButtonColor = false
    Btn.Parent = Holder

    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(200, 200, 220)
    Stroke.Thickness = 1.5
    Stroke.Parent = Btn

    local Check = Instance.new("TextLabel")
    Check.Size = UDim2.new(1, 0, 1, 0)
    Check.BackgroundTransparency = 1
    Check.Text = "✓"
    Check.TextColor3 = Color3.fromRGB(255, 255, 255)
    Check.TextSize = 18
    Check.Font = Enum.Font.GothamBold
    Check.Visible = false
    Check.Parent = Btn

    local function UpdateUI(state)
        Check.Visible = state
        if state then
            Btn.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
            Stroke.Color = Color3.fromRGB(135, 120, 225)
        else
            Btn.BackgroundColor3 = Color3.fromRGB(28, 29, 39)
            Stroke.Color = Color3.fromRGB(200, 200, 220)
        end
    end

    Btn.MouseButton1Click:Connect(function()
        if ToggleFunc then ToggleFunc() end
        task.defer(function()
            local state = IsEnabledFunc and IsEnabledFunc() or not Check.Visible
            UpdateUI(state)
        end)
    end)

    task.spawn(function()
        while task.wait(1) do
            if not Holder.Parent then break end
            local state = IsEnabledFunc and IsEnabledFunc() or false
            if state ~= Check.Visible then UpdateUI(state) end
        end
    end)

    return Holder
end

-- Composant bouton
function EL2B_MakeButton(Parent, LabelText, SubText, Order, ButtonText, Callback)
    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1, 0, 0, 52)
    Holder.BackgroundTransparency = 1
    Holder.LayoutOrder = Order
    Holder.Parent = Parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -100, 0, 20)
    Label.Position = UDim2.new(0, 0, 0, 2)
    Label.BackgroundTransparency = 1
    Label.Text = LabelText
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.Font = Enum.Font.GothamBold
    Label.Parent = Holder

    if SubText then
        local Sub = Instance.new("TextLabel")
        Sub.Size = UDim2.new(1, -100, 0, 18)
        Sub.Position = UDim2.new(0, 0, 0, 24)
        Sub.BackgroundTransparency = 1
        Sub.Text = SubText
        Sub.TextColor3 = Color3.fromRGB(150, 150, 170)
        Sub.TextSize = 10
        Sub.TextXAlignment = Enum.TextXAlignment.Left
        Sub.Font = Enum.Font.Gotham
        Sub.Parent = Holder
    end

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 70, 0, 26)
    Btn.Position = UDim2.new(1, -70, 0.5, -13)
    Btn.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
    Btn.BorderSizePixel = 0
    Btn.Text = ButtonText or "Click"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 12
    Btn.Font = Enum.Font.GothamBold
    Btn.AutoButtonColor = false
    Btn.Parent = Holder

    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(140, 125, 240)
    Stroke.Thickness = 1.5
    Stroke.Transparency = 0.3
    Stroke.Parent = Btn

    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(125, 110, 220)}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(105, 90, 190)}):Play()
    end)
    Btn.MouseButton1Click:Connect(function() if Callback then Callback() end end)
    return Holder, Btn
end
]=]

--============================================================
-- TABS/INIT.LUA
--============================================================
_MERGED["Tabs/Init.lua"] = [=[
local TweenService = game:GetService("TweenService")
local TabsManager = {}
TabsManager.Tabs = {}
TabsManager.ActiveTab = nil
TabsManager.ActivePage = nil

function TabsManager:RegisterTab(Name, Order, PageName)
    local Tab = CreateTab(Name, Order)
    local Page = CreatePage(PageName or Name:upper())
    table.insert(self.Tabs, { Tab = Tab, Page = Page, Name = Name })
    Tab.MouseButton1Click:Connect(function() self:SelectTab(Tab, Page) end)
    return Tab, Page
end

function TabsManager:SelectTab(SelectedTab, SelectedPage)
    for _, data in ipairs(self.Tabs) do
        data.Page.Visible = false
        local Indicator = data.Tab:FindFirstChild("Indicator")
        local TabText = data.Tab:FindFirstChild("TabText")
        TweenService:Create(data.Tab, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        if Indicator then TweenService:Create(Indicator, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play() end
        if TabText then TweenService:Create(TabText, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(155, 155, 175)}):Play() end
    end
    SelectedPage.Visible = true
    task.wait(0.05)
    pcall(function() SelectedPage.CanvasPosition = Vector2.new(0, 0) end)
    TweenService:Create(SelectedTab, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    local Indicator = SelectedTab:FindFirstChild("Indicator")
    local TabText = SelectedTab:FindFirstChild("TabText")
    if Indicator then TweenService:Create(Indicator, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play() end
    if TabText then TweenService:Create(TabText, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play() end
    self.ActiveTab = SelectedTab
    self.ActivePage = SelectedPage
end

function TabsManager:GetTab(Name)
    for _, data in ipairs(self.Tabs) do
        if data.Name == Name then return data.Tab, data.Page end
    end
    return nil, nil
end

function TabsManager:SelectTabByName(Name)
    local Tab, Page = self:GetTab(Name)
    if Tab and Page then self:SelectTab(Tab, Page) end
end

_G.EL2B_TabsManager = TabsManager
]=]

--============================================================
-- FEATURES COMMUNES
--============================================================
_MERGED["Features/AntiAFK.lua"] = [=[
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local MI_MIN, MI_MAX = 45, 120
local CI_MIN, CI_MAX = 60, 180
local ZI_MIN, ZI_MAX = 90, 240
local On = false
local T1, T2, T3 = nil, nil, nil

local function Mouse() pcall(function() mousemoverel(math.random(-15,15), math.random(-15,15)) end) end
local function Cam()
    pcall(function()
        local c = workspace.CurrentCamera
        if c then c.CFrame = c.CFrame * CFrame.Angles(math.rad(math.random(-2,2)), math.rad(math.random(-3,3)), 0) end
    end)
end
local function Zoom()
    pcall(function()
        local c = workspace.CurrentCamera
        if c then local o = c.FieldOfView c.FieldOfView = o + math.random(-5,5) task.wait(0.3) c.FieldOfView = o end
    end)
end

local function Enable()
    if On then return end
    On = true
    T1 = task.spawn(function() while On do task.wait(math.random(MI_MIN,MI_MAX)) if On then Mouse() end end end)
    T2 = task.spawn(function() while On do task.wait(math.random(CI_MIN,CI_MAX)) if On then Cam() end end end)
    T3 = task.spawn(function() while On do task.wait(math.random(ZI_MIN,ZI_MAX)) if On then Zoom() end end end)
end
local function Disable()
    On = false
    if T1 then pcall(function() task.cancel(T1) end) T1 = nil end
    if T2 then pcall(function() task.cancel(T2) end) T2 = nil end
    if T3 then pcall(function() task.cancel(T3) end) T3 = nil end
end
_G.EL2B_AntiAFK = {
    Enable = Enable, Disable = Disable,
    Toggle = function() if On then Disable() else Enable() end end,
    IsEnabled = function() return On end,
}
]=]

_MERGED["Features/WalkSpeed.lua"] = [=[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local On, Value, Orig, Conn = false, 50, 16, nil

local function GetHum()
    local c = Player.Character
    if not c then return nil end
    return c:FindFirstChildOfClass("Humanoid")
end
local function Apply() local h = GetHum() if h then h.WalkSpeed = Value end end
local function Stop()
    local h = GetHum() if h then h.WalkSpeed = Orig end
    if Conn then Conn:Disconnect() Conn = nil end
end
local function Start()
    local h = GetHum() if h then Orig = h.WalkSpeed end
    Apply()
    if Conn then Conn:Disconnect() end
    Conn = RunService.Heartbeat:Connect(function() if On then Apply() end end)
end
_G.EL2B_WalkSpeed = {
    Toggle = function() On = not On if On then Start() else Stop() end end,
    Enable = function() On = true Start() end,
    Disable = function() On = false Stop() end,
    SetValue = function(v) Value = math.clamp(v, 50, 1000) if On then Apply() end end,
    IsEnabled = function() return On end,
    GetValue = function() return Value end,
}
]=]

_MERGED["Features/AntiTrap.lua"] = [=[
local On = false
local function Clean()
    local f = workspace:FindFirstChild("__DEBRIS")
    if not f then return end
    for _, c in ipairs(f:GetChildren()) do pcall(function() c:Destroy() end) end
end
local function Enable()
    if On then return end
    On = true
    Clean()
    task.spawn(function() while On do task.wait(1) if On then Clean() end end end)
end
_G.EL2B_AntiTrap = {
    Enable = Enable,
    Disable = function() On = false end,
    Toggle = function() if On then On = false else Enable() end end,
    IsEnabled = function() return On end,
}
]=]

_MERGED["Features/GodMode.lua"] = [=[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local On = false
local Conn = nil

local function Run()
    local Char = Player.Character
    if not Char then return end
    local OldH = Char:FindFirstChildOfClass("Humanoid")
    if not OldH then return end
    local NewH = OldH:Clone()
    if not NewH then return end
    NewH.Name = OldH.Name
    for _, C in ipairs(OldH:GetChildren()) do
        local ex = NewH:FindFirstChild(C.Name)
        if ex then pcall(function() ex:Destroy() end) end
        pcall(function() C.Parent = NewH end)
    end
    OldH:Destroy()
    task.wait()
    NewH.Parent = Char
    task.wait()
    if not NewH.Parent then return end
    if not NewH:FindFirstChildOfClass("Animator") then
        local a = Instance.new("Animator") a.Parent = NewH
    end
    pcall(function()
        NewH:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        NewH.BreakJointsOnDeath = false
        NewH.RequiresNeck = false
        NewH.MaxHealth = math.huge
        NewH.Health = math.huge
    end)
    if Conn then Conn:Disconnect() end
    Conn = RunService.Heartbeat:Connect(function()
        if not On then return end
        local c = Player.Character
        if not c then return end
        local h = c:FindFirstChildOfClass("Humanoid")
        if not h then return end
        pcall(function()
            h.MaxHealth = math.huge
            h.Health = math.huge
            h:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            h.BreakJointsOnDeath = false
            h.RequiresNeck = false
        end)
    end)
end

_G.EL2B_GodMode = {
    Enable = function() On = true task.spawn(Run) end,
    Disable = function() On = false if Conn then Conn:Disconnect() Conn = nil end end,
    Toggle = function()
        if On then On = false if Conn then Conn:Disconnect() Conn = nil end
        else On = true task.spawn(Run) end
    end,
    IsEnabled = function() return On end,
}
]=]

_MERGED["Features/ManualFastClick.lua"] = [=[
local PPS = game:GetService("ProximityPromptService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local On = false
local PromptConn, HBConn = nil, nil

local function Apply(p) if p then pcall(function() p.HoldDuration = 0 end) end end
local function Scan()
    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("ProximityPrompt") then Apply(d) end
    end
    local pg = Player:FindFirstChild("PlayerGui")
    if pg then
        for _, d in ipairs(pg:GetDescendants()) do
            if d:IsA("ProximityPrompt") then Apply(d) end
        end
    end
end
local function Enable()
    if On then return end
    On = true
    Scan()
    if PromptConn then PromptConn:Disconnect() end
    PromptConn = PPS.PromptShown:Connect(function(p) if On then Apply(p) end end)
    if HBConn then HBConn:Disconnect() end
    local c = 0
    HBConn = RS.Heartbeat:Connect(function()
        if not On then return end
        c = c + 1
        if c >= 30 then c = 0 Scan() end
    end)
end
local function Disable()
    On = false
    if PromptConn then PromptConn:Disconnect() PromptConn = nil end
    if HBConn then HBConn:Disconnect() HBConn = nil end
end
_G.EL2B_ManualFastClick = {
    Enable = Enable, Disable = Disable,
    Toggle = function() if On then Disable() else Enable() end end,
    IsEnabled = function() return On end,
}
]=]

_MERGED["Features/AutoAttack.lua"] = [=[
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local RS_Storage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local BP = Player:WaitForChild("Backpack")
local RANGE, FIRE_INT = 60, 0.01
local EquipOn, HitOn = false, false
local EquipConn, HitConn = nil, nil
local LastFire, Seq = 0, 0

local function GetHum()
    local c = Player.Character
    if not c then return nil, nil end
    return c:FindFirstChildOfClass("Humanoid"), c:FindFirstChild("HumanoidRootPart")
end
local function GetRemote()
    local ok, r = pcall(function() return RS_Storage.Packages.Networking["RE/BatSwing/Trigger"] end)
    if ok and r then return r end
    return nil
end
local function FindBat()
    for _, t in ipairs(BP:GetChildren()) do
        if t:IsA("Tool") and (t.ToolTip == "Bat" or t.Name:find("Bat")) then return t end
    end
    local c = Player.Character
    if c then
        for _, t in ipairs(c:GetChildren()) do
            if t:IsA("Tool") and (t.ToolTip == "Bat" or t.Name:find("Bat")) then return t end
        end
    end
end
local function Equip()
    local b = FindBat()
    if not b then return end
    if b.Parent == BP then
        local h = GetHum()
        if h then h:EquipTool(b) end
    end
end
local function FindClosest()
    local _, root = GetHum()
    if not root then return nil end
    local best, bd = nil, RANGE
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Player then
            local c = p.Character
            if c then
                local h = c:FindFirstChildOfClass("Humanoid")
                local r = c:FindFirstChild("HumanoidRootPart")
                if h and r and h.Health > 0 then
                    local d = (r.Position - root.Position).Magnitude
                    if d < bd then bd = d best = p end
                end
            end
        end
    end
    return best
end
local function Fire()
    local t = FindClosest() if not t then return end
    local r = GetRemote() if not r then return end
    Seq = Seq + 1
    local tid = tostring(Player.UserId)..":"..tostring(Seq)..":"..tostring(math.floor(workspace:GetServerTimeNow()*1000))
    pcall(function() r:FireServer(t, tid) end)
end

_G.EL2B_AutoAttack = {
    EnableAutoEquip = function()
        if EquipOn then return end
        EquipOn = true
        if EquipConn then EquipConn:Disconnect() end
        EquipConn = RS.Heartbeat:Connect(function()
            if not EquipOn then return end
            local b = FindBat()
            if b and b.Parent == BP then Equip() end
        end)
        Equip()
    end,
    DisableAutoEquip = function()
        EquipOn = false
        if EquipConn then EquipConn:Disconnect() EquipConn = nil end
    end,
    IsAutoEquipEnabled = function() return EquipOn end,
    EnableAutoHit = function()
        if HitOn then return end
        HitOn = true
        if HitConn then HitConn:Disconnect() end
        HitConn = RS.Heartbeat:Connect(function()
            if not HitOn then return end
            local now = tick()
            if now - LastFire < FIRE_INT then return end
            LastFire = now
            Fire()
        end)
    end,
    DisableAutoHit = function()
        HitOn = false
        if HitConn then HitConn:Disconnect() HitConn = nil end
    end,
    IsAutoHitEnabled = function() return HitOn end,
    FindBatTool = FindBat,
}
]=]

_MERGED["Features/ConfigSystem.lua"] = [=[
local Http = game:GetService("HttpService")
local FOLDER = "EL2B-SAE"
local FILE = FOLDER.."/el2b.json"
local Default = { SelectedMethod = "TeleportFly", TeleportSpeed = 300 }

local function Ensure() pcall(function() if not isfolder(FOLDER) then makefolder(FOLDER) end end) end
local function Load()
    Ensure()
    local c = table.clone(Default)
    local ok, exists = pcall(function() return isfile(FILE) end)
    if not ok or not exists then return c end
    local s, raw = pcall(function() return readfile(FILE) end)
    if not s or not raw or raw == "" then return c end
    local d, dec = pcall(function() return Http:JSONDecode(raw) end)
    if not d or type(dec) ~= "table" then return c end
    if type(dec.SelectedMethod) == "string" and (dec.SelectedMethod == "TeleportFly" or dec.SelectedMethod == "InstantTeleport") then
        c.SelectedMethod = dec.SelectedMethod
    end
    if type(dec.TeleportSpeed) == "number" then c.TeleportSpeed = math.clamp(dec.TeleportSpeed, 50, 1100) end
    return c
end
local function Save(c)
    Ensure()
    local data = { SelectedMethod = c.SelectedMethod or Default.SelectedMethod, TeleportSpeed = c.TeleportSpeed or Default.TeleportSpeed }
    local ok, enc = pcall(function() return Http:JSONEncode(data) end)
    if not ok then return false end
    return pcall(function() writefile(FILE, enc) end)
end
local function Apply(c)
    _G.EL2B_SelectedMethod = c.SelectedMethod
    _G.EL2B_TeleportSpeed = c.TeleportSpeed
end
local Init = Load() Apply(Init)
_G.EL2B_ConfigSystem = {
    Load = function() local c = Load() Apply(c) return c end,
    Save = function() return Save({ SelectedMethod = _G.EL2B_SelectedMethod or Default.SelectedMethod, TeleportSpeed = _G.EL2B_TeleportSpeed or Default.TeleportSpeed }) end,
    Reset = function() Apply(Default) return Save(Default) end,
}
]=]

_MERGED["Features/BypassAntiCheat.lua"] = [=[
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local BypassEnabled = true

local function Run()
    local Char = Player.Character
    if not Char then return end
    local OldH = Char:FindFirstChildOfClass("Humanoid")
    if not OldH then return end
    if OldH:GetAttribute("EL2BBypass") then return end
    local NewH = OldH:Clone()
    if not NewH then return end
    NewH.Name = OldH.Name
    NewH:SetAttribute("EL2BBypass", true)
    for _, C in ipairs(OldH:GetChildren()) do
        local ex = NewH:FindFirstChild(C.Name)
        if ex then pcall(function() ex:Destroy() end) end
        pcall(function() C.Parent = NewH end)
    end
    OldH:Destroy()
    task.wait()
    NewH.Parent = Char
    task.wait()
    if not NewH.Parent then return end
    if not NewH:FindFirstChildOfClass("Animator") then
        local a = Instance.new("Animator") a.Parent = NewH
    end
    pcall(function()
        NewH.MaxHealth = math.huge
        NewH.Health = math.huge
        NewH:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        NewH.BreakJointsOnDeath = false
        NewH.RequiresNeck = false
    end)
    task.spawn(function()
        while BypassEnabled do
            task.wait(0.1)
            if NewH and NewH.Parent then
                pcall(function()
                    if NewH.Health < NewH.MaxHealth then NewH.Health = NewH.MaxHealth end
                    NewH:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end)
            end
        end
    end)
end

Player.CharacterAdded:Connect(function() task.wait(1) Run() end)
task.spawn(function() task.wait(2) Run() end)
]=]

_MERGED["Features/GameDetector.lua"] = [=[
local GAME_IDS = {
    STEAL_AN_EGG     = 107778070777162,
    STEAL_A_BRAINROT = 109983668079237,
}
local D = { CurrentGame = "UNKNOWN", PlaceId = game.PlaceId, GAME_IDS = GAME_IDS }
local function Detect()
    local pid = game.PlaceId
    if pid == GAME_IDS.STEAL_AN_EGG then D.CurrentGame = "STEAL_AN_EGG"
    elseif pid == GAME_IDS.STEAL_A_BRAINROT then D.CurrentGame = "STEAL_A_BRAINROT"
    else D.CurrentGame = "UNKNOWN" end
    return D.CurrentGame
end
D.Detect = Detect
D.IsEgg       = function() return D.CurrentGame == "STEAL_AN_EGG" end
D.IsBrainrot  = function() return D.CurrentGame == "STEAL_A_BRAINROT" end
D.IsSupported = function() return D.CurrentGame ~= "UNKNOWN" end
Detect()
_G.EL2B_GameDetector = D
]=]

--============================================================
-- FEATURES STEAL AN EGG
--============================================================
_MERGED["Features/TeleportSystem.lua"] = [=[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local Container = workspace:WaitForChild("AreaEggSlotsClient", 30)
local Config = {
    TeleportSpeed = 300, NearOffset = 20, FlyOffset = 3, ShotDistance = 25,
    LockAbove = 1, ArriveDistance = 2, SafeStopDistance = 5, Timeout = 20,
    CollectInterval = 0.05, TargetCollectTimeout = 10, MaxRecoveryAttempts = 10000,
    BodyVelocityP = 5000, BodyGyroP = 50000, BodyGyroD = 2000,
    SafeZone = Vector3.new(533, 70, -366),
    LockPosition = Vector3.new(607.6259155273438, 70.57420349121094, -326.8830261230469),
    SearchPrefix = "FirstAreaEgg", PositionThreshold = 1,
}
local CollectEvent = RS.Packages.Networking:FindFirstChild("RF/EggWorld/AskFieldEggCarry")
local ForestStrike = RS.Packages.Networking:FindFirstChild("RE/GuardPatrol/ForestStrike")
if not CollectEvent then return end
local S = { Running=false, Step="idle", Mode="none", Method="TeleportFly", TargetUid=nil, FlySequence=0,
    TweenConnection=nil, FlyConnection=nil, LockConnection=nil, BodyVelocity=nil, BodyGyro=nil,
    ActiveHeartbeat=nil, FirstEggList={}, FirstEggUid=nil, FirstEggSlotKey=nil, SavedTargetPosition=nil,
    TargetLockedCFrame=nil, FlyTargetStarted=false, CollectDone=false, TargetCollected=false,
    RemotesFired=false, RecoveryTriggered=false, RecoveryAttempts=0, CollectAttempts=0, CollectTime=0,
    TargetCollectStartTime=0, PlayerGui=nil, DropHeldEgg=nil, DropHeldEggConnection=nil,
    RagdollEnabled=false, RagdollConnection=nil, ForceUpConnection=nil,
    SavedWalkSpeed=nil, SavedJumpPower=nil, SavedJumpHeight=nil, SavedUseJumpPower=nil }

local function GetHum()
    local c = Player.Character
    if not c then return nil, nil end
    return c:FindFirstChildOfClass("Humanoid"), c:FindFirstChild("HumanoidRootPart")
end
local function GetPos(o)
    if not o then return nil end
    if o:IsA("Model") then
        if o.PrimaryPart then return o.PrimaryPart.Position end
        local p = o:FindFirstChildWhichIsA("BasePart")
        if p then return p.Position end
        for _, d in ipairs(o:GetDescendants()) do if d:IsA("BasePart") then return d.Position end end
    elseif o:IsA("BasePart") then return o.Position end
end
local function Cleanup(keepStand)
    if S.TweenConnection then pcall(function() S.TweenConnection:Cancel() end) S.TweenConnection = nil end
    if S.FlyConnection then S.FlyConnection:Disconnect() S.FlyConnection = nil end
    if S.LockConnection then S.LockConnection:Disconnect() S.LockConnection = nil end
    if S.BodyVelocity then pcall(function() S.BodyVelocity.Velocity = Vector3.zero S.BodyVelocity.MaxForce = Vector3.zero end) S.BodyVelocity:Destroy() S.BodyVelocity = nil end
    if S.BodyGyro then pcall(function() S.BodyGyro.MaxTorque = Vector3.zero end) S.BodyGyro:Destroy() S.BodyGyro = nil end
    local h, r = GetHum()
    if r then for _, c in ipairs(r:GetChildren()) do
        if c.Name == "EL2BBV" or c.Name == "EL2BBG" then pcall(function() c:Destroy() end) end
    end end
    if h and not keepStand then pcall(function() h.PlatformStand = false h.Sit = false end) end
    if r then pcall(function() r.AssemblyLinearVelocity = Vector3.zero r.AssemblyAngularVelocity = Vector3.zero end) end
end
local function StartLock(p)
    if not p then return end
    S.TargetLockedCFrame = CFrame.new(p + Vector3.new(0, Config.LockAbove, 0))
    if S.LockConnection then S.LockConnection:Disconnect() end
    S.LockConnection = RunService.Heartbeat:Connect(function()
        if not S.Running then
            if S.LockConnection then S.LockConnection:Disconnect() S.LockConnection = nil end
            return
        end
        local _, r = GetHum()
        if not r then return end
        r.CFrame = S.TargetLockedCFrame
        r.AssemblyLinearVelocity = Vector3.zero
        r.AssemblyAngularVelocity = Vector3.zero
    end)
end
local function FlyTP(dest, useShot, safe, cb)
    S.FlySequence = S.FlySequence + 1
    local seq = S.FlySequence
    Cleanup()
    local h, r = GetHum()
    if not h or not r or h.Health <= 0 then return end
    local fp = Vector3.new(dest.X, dest.Y + Config.FlyOffset, dest.Z)
    local lockCF = CFrame.new(dest + Vector3.new(0, Config.LockAbove, 0))
    h.PlatformStand = true
    local sp = r.Position
    local dir = fp - sp
    local td = dir.Magnitude
    local du = td > 0 and dir.Unit or Vector3.new(0,0,-1)
    local np = fp - (du * Config.NearOffset)
    local nd = (np - sp).Magnitude
    local dur = nd / Config.TeleportSpeed
    local twn = TweenService:Create(r, TweenInfo.new(dur, Enum.EasingStyle.Linear), { CFrame = CFrame.new(np, fp) })
    S.TweenConnection = twn
    twn:Play()
    task.spawn(function()
        twn.Completed:Wait()
        if seq ~= S.FlySequence or not S.Running then Cleanup() return end
        task.wait(0.03)
        local h2, r2 = GetHum()
        if not h2 or not r2 or h2.Health <= 0 then Cleanup() return end
        S.BodyVelocity = Instance.new("BodyVelocity")
        S.BodyVelocity.Name = "EL2BBV"
        S.BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        S.BodyVelocity.P = Config.BodyVelocityP
        S.BodyVelocity.Velocity = Vector3.zero
        S.BodyVelocity.Parent = r2
        S.BodyGyro = Instance.new("BodyGyro")
        S.BodyGyro.Name = "EL2BBG"
        S.BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        S.BodyGyro.P = Config.BodyGyroP
        S.BodyGyro.D = Config.BodyGyroD
        S.BodyGyro.CFrame = r2.CFrame
        S.BodyGyro.Parent = r2
        local init = fp - r2.Position
        if init.Magnitude > 1 then S.BodyVelocity.Velocity = init.Unit * Config.TeleportSpeed end
        local startT = tick()
        local shotDone = false
        S.FlyConnection = RunService.Heartbeat:Connect(function()
            if seq ~= S.FlySequence then
                if S.FlyConnection then S.FlyConnection:Disconnect() S.FlyConnection = nil end
                return
            end
            if not S.Running then Cleanup() return end
            local h3, r3 = GetHum()
            if not h3 or not r3 or h3.Health <= 0 then Cleanup() return end
            if not S.BodyVelocity or not S.BodyGyro then Cleanup() return end
            local cp = r3.Position
            local d = fp - cp
            local hd = Vector3.new(d.X, 0, d.Z).Magnitude
            local vd = math.abs(d.Y)
            local td2 = d.Magnitude
            if safe and hd <= Config.SafeStopDistance then
                if S.BodyVelocity then S.BodyVelocity.Velocity = Vector3.zero S.BodyVelocity.MaxForce = Vector3.zero end
                if S.BodyGyro then S.BodyGyro.MaxTorque = Vector3.zero end
                if S.FlyConnection then S.FlyConnection:Disconnect() S.FlyConnection = nil end
                r3.CFrame = CFrame.new(Config.SafeZone + Vector3.new(0, Config.FlyOffset, 0))
                r3.AssemblyLinearVelocity = Vector3.zero
                r3.AssemblyAngularVelocity = Vector3.zero
                task.spawn(function() task.wait(0.1) Cleanup() if cb then cb() end end)
                return
            end
            if not safe and useShot and not shotDone and hd <= Config.ShotDistance then
                shotDone = true
                if S.BodyVelocity then S.BodyVelocity.Velocity = Vector3.zero S.BodyVelocity.MaxForce = Vector3.zero end
                if S.BodyGyro then S.BodyGyro.MaxTorque = Vector3.zero end
                if S.FlyConnection then S.FlyConnection:Disconnect() S.FlyConnection = nil end
                task.spawn(function()
                    task.wait(0.05) Cleanup(true)
                    r3.CFrame = lockCF
                    r3.AssemblyLinearVelocity = Vector3.zero
                    r3.AssemblyAngularVelocity = Vector3.zero
                    task.wait(0.05) StartLock(dest)
                    if cb then cb() end
                end)
                return
            end
            if hd <= Config.ArriveDistance and vd <= 2 then
                if S.BodyVelocity then S.BodyVelocity.Velocity = Vector3.zero S.BodyVelocity.MaxForce = Vector3.zero end
                if S.BodyGyro then S.BodyGyro.MaxTorque = Vector3.zero end
                if S.FlyConnection then S.FlyConnection:Disconnect() S.FlyConnection = nil end
                task.spawn(function()
                    task.wait(0.05) Cleanup(true)
                    r3.CFrame = lockCF
                    r3.AssemblyLinearVelocity = Vector3.zero
                    r3.AssemblyAngularVelocity = Vector3.zero
                    task.wait(0.05) StartLock(dest)
                    if cb then cb() end
                end)
                return
            end
            if tick() - startT > Config.Timeout then Cleanup() if cb then cb() end return end
            if td2 > 1 then S.BodyVelocity.Velocity = d.Unit * Config.TeleportSpeed else S.BodyVelocity.Velocity = Vector3.zero end
            S.BodyGyro.CFrame = CFrame.new(cp, cp + Vector3.new(d.X, 0, d.Z))
        end)
    end)
end
local function InstantTP(dest, cb)
    if not dest then if cb then cb() end return end
    S.FlySequence = S.FlySequence + 1
    Cleanup()
    local h, r = GetHum()
    if not h or not r or h.Health <= 0 then return end
    local lockCF = CFrame.new(dest + Vector3.new(0, Config.LockAbove, 0))
    h.PlatformStand = true
    task.spawn(function()
        task.wait(0.03)
        r.CFrame = lockCF
        r.AssemblyLinearVelocity = Vector3.zero
        r.AssemblyAngularVelocity = Vector3.zero
        task.wait(0.05) StartLock(dest)
        if cb then cb() end
    end)
end
local function TP(dest, cb)
    if S.Method == "InstantTeleport" then InstantTP(dest, cb) else FlyTP(dest, false, false, cb) end
end
local function RCFirst()
    if not CollectEvent or not S.FirstEggSlotKey or not S.FirstEggUid then return false end
    return pcall(function() CollectEvent:InvokeServer({ FirstAreaSlotKey = S.FirstEggSlotKey, Uid = S.FirstEggUid }) end)
end
local function RCTarget()
    if not CollectEvent or not S.TargetUid then return false end
    return pcall(function() CollectEvent:InvokeServer({ Uid = S.TargetUid }) end)
end
local function FireFS()
    if S.RemotesFired then return end
    S.RemotesFired = true
    pcall(function() ForestStrike:FireServer({ EggUid = S.FirstEggUid, GuardCFrame = CFrame.new(Config.LockPosition) }) end)
end
local function SetupDrop()
    S.PlayerGui = Player:FindFirstChild("PlayerGui") or Player:WaitForChild("PlayerGui", 5)
    if not S.PlayerGui then return end
    S.DropHeldEgg = S.PlayerGui:FindFirstChild("DropHeldEgg")
    if not S.DropHeldEgg then return end
    if S.DropHeldEggConnection then S.DropHeldEggConnection:Disconnect() end
    S.DropHeldEggConnection = S.DropHeldEgg:GetPropertyChangedSignal("Enabled"):Connect(function() end)
end
local function IsTargetColl() return S.DropHeldEgg and S.DropHeldEgg.Enabled == true end
local function SearchFirst()
    S.FirstEggList = {}
    if not Container then return end
    for _, sl in ipairs(Container:GetChildren()) do
        if string.find(sl.Name, Config.SearchPrefix) then
            local n = string.match(sl.Name, "Slot_(%d+)")
            if n then table.insert(S.FirstEggList, { Slot = sl, Uid = sl.Name, SlotKey = "Forest:Slot_"..n }) end
        end
    end
end
local function FindClosest()
    local _, r = GetHum()
    if not r then return nil end
    local best, bd = nil, 9999
    for _, e in ipairs(S.FirstEggList) do
        local p = GetPos(e.Slot)
        if p then
            local d = (p - r.Position).Magnitude
            if d < bd then bd = d best = e end
        end
    end
    if best then S.FirstEggUid = best.Uid S.FirstEggSlotKey = best.SlotKey end
    return best
end
local function IsFirstInWS() return S.FirstEggUid and workspace:FindFirstChild(S.FirstEggUid) ~= nil end
local function IsFirstInContainer() return S.FirstEggUid and Container and Container:FindFirstChild(S.FirstEggUid) ~= nil end
local function IsTargetInContainer() return S.TargetUid and Container and Container:FindFirstChild(S.TargetUid) ~= nil end
local function IsTargetInWS() return S.TargetUid and workspace:FindFirstChild(S.TargetUid) ~= nil end
local function AutoStop()
    if S.LockConnection then S.LockConnection:Disconnect() S.LockConnection = nil end
    S.TargetLockedCFrame = nil
    if S.ActiveHeartbeat then S.ActiveHeartbeat:Disconnect() S.ActiveHeartbeat = nil end
    Cleanup()
    S.Running = false
    S.Step = "done"
    S.FlySequence = S.FlySequence + 1
end
local function StartFlyTarget()
    if S.FlyTargetStarted then return end
    S.FlyTargetStarted = true
    S.Step = "to_target"
    local tp
    if S.Mode == "spawn" then
        local e = Container and Container:FindFirstChild(S.TargetUid)
        if e then tp = GetPos(e) end
    elseif S.Mode == "workspace" then tp = S.SavedTargetPosition end
    if not tp then AutoStop() return end
    TP(tp, function()
        S.TargetCollected = false
        S.CollectTime = 0
        S.RecoveryTriggered = false
        S.TargetCollectStartTime = tick()
        S.Step = "collect_target"
    end)
end
local function FlyAgain()
    S.RecoveryAttempts = S.RecoveryAttempts + 1
    if S.RecoveryAttempts > Config.MaxRecoveryAttempts then AutoStop() return end
    S.Step = "recovery"
    S.FlySequence = S.FlySequence + 1
    Cleanup()
    local tp
    if IsTargetInContainer() then
        S.Mode = "spawn"
        local e = Container:FindFirstChild(S.TargetUid)
        if e then tp = GetPos(e) end
    elseif IsTargetInWS() then
        S.Mode = "workspace"
        local e = workspace:FindFirstChild(S.TargetUid)
        if e then tp = GetPos(e) S.SavedTargetPosition = tp end
    else AutoStop() return end
    if not tp then AutoStop() return end
    FlyTP(tp, false, false, function()
        S.TargetCollected = false
        S.CollectTime = 0
        S.RecoveryTriggered = false
        S.RemotesFired = false
        S.TargetCollectStartTime = tick()
        S.Step = "collect_target"
    end)
end
local function FlySafe()
    S.Step = "to_safe"
    FlyTP(Config.SafeZone, false, true, function()
        if S.LockConnection then S.LockConnection:Disconnect() S.LockConnection = nil end
        if S.ActiveHeartbeat then S.ActiveHeartbeat:Disconnect() S.ActiveHeartbeat = nil end
        Cleanup()
        S.Running = false
        S.Step = "idle"
    end)
end
local function StartHB()
    if S.ActiveHeartbeat then S.ActiveHeartbeat:Disconnect() end
    S.ActiveHeartbeat = RunService.Heartbeat:Connect(function()
        if not S.Running then return end
        local h, r = GetHum()
        if not h or not r or h.Health <= 0 then return end
        if S.Step == "collect_first" and not S.CollectDone then
            if IsFirstInWS() then S.CollectDone = true FireFS() S.Step = "wait_spawn_back" return end
            if tick() - S.CollectTime > Config.CollectInterval then
                S.CollectTime = tick()
                if IsFirstInContainer() then RCFirst()
                elseif IsFirstInWS() then S.CollectDone = true FireFS() S.Step = "wait_spawn_back" end
            end
        end
        if S.Step == "wait_spawn_back" and not S.FlyTargetStarted then
            if IsFirstInContainer() then task.spawn(function() task.wait(0.05) StartFlyTarget() end) end
        end
        if S.Step == "collect_target" and not S.TargetCollected then
            if IsTargetColl() then
                S.TargetCollected = true
                task.spawn(function() task.wait(0.05) FlySafe() end)
                return
            end
            if S.Mode == "spawn" and workspace:FindFirstChild(S.TargetUid) then
                S.TargetCollected = true
                task.spawn(function() task.wait(0.05) FlySafe() end)
                return
            end
            if tick() - S.CollectTime > Config.CollectInterval then
                S.CollectTime = tick()
                RCTarget()
            end
            if tick() - S.TargetCollectStartTime > Config.TargetCollectTimeout then
                if not S.RecoveryTriggered then
                    S.RecoveryTriggered = true
                    task.spawn(function() task.wait(0.05) FlyAgain() end)
                end
            end
        end
    end)
end
local function StartProcess()
    S.Running = true
    S.Step = "search"
    S.FlySequence = 0
    S.FlyTargetStarted = false
    S.CollectDone = false
    S.TargetCollected = false
    S.RemotesFired = false
    S.RecoveryTriggered = false
    S.RecoveryAttempts = 0
    S.SavedTargetPosition = nil
    S.TargetLockedCFrame = nil
    SetupDrop()
    if IsTargetInContainer() then S.Mode = "spawn"
    elseif IsTargetInWS() then
        S.Mode = "workspace"
        local e = workspace:FindFirstChild(S.TargetUid)
        if e then S.SavedTargetPosition = GetPos(e) end
    else
        local w = 0
        while S.Running and not IsTargetInContainer() and not IsTargetInWS() do
            task.wait(0.2) w = w + 0.2
            if w > 30 then AutoStop() return end
        end
    end
    SearchFirst()
    if #S.FirstEggList == 0 then AutoStop() return end
    local c = FindClosest()
    if not c then AutoStop() return end
    local ep = GetPos(c.Slot)
    if not ep then AutoStop() return end
    S.Step = "fly_first"
    StartHB()
    FlyTP(ep, true, false, function()
        S.CollectDone = false
        S.CollectTime = 0
        S.Step = "collect_first"
    end)
end
local function FullReset()
    if S.LockConnection then S.LockConnection:Disconnect() S.LockConnection = nil end
    if S.ActiveHeartbeat then S.ActiveHeartbeat:Disconnect() S.ActiveHeartbeat = nil end
    if S.DropHeldEggConnection then S.DropHeldEggConnection:Disconnect() S.DropHeldEggConnection = nil end
    Cleanup()
    S.Running = false
    S.Step = "idle"
    S.FlySequence = S.FlySequence + 1
end
_G.EL2B_TeleportSystem = {
    Enable = function()
        if S.Running then return end
        if not CollectEvent or not S.TargetUid then return end
        FullReset()
        StartProcess()
    end,
    Disable = function() FullReset() end,
    SetTargetId = function(id) S.TargetUid = id end,
    SetSpeed = function(v) Config.TeleportSpeed = math.clamp(v, 50, 1100) end,
    SetMethod = function(m) S.Method = (m == "InstantTeleport") and "InstantTeleport" or "TeleportFly" end,
    IsEnabled = function() return S.Running end,
}
]=]

_MERGED["Features/VIPTP.lua"] = [=[
local TS = _G.EL2B_TeleportSystem
local S = { Running = false }
_G.EL2B_VIPTP = {
    Enable = function()
        if S.Running or not TS then return end
        S.Running = true
        TS.SetMethod("InstantTeleport")
        TS.Enable()
    end,
    Disable = function()
        S.Running = false
        if TS then TS.Disable() end
    end,
    SetTargetId = function(id) if TS then TS.SetTargetId(id) end end,
    IsEnabled = function() return S.Running end,
}
]=]

_MERGED["Features/AutoFarm.lua"] = [=[
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local Container = workspace:WaitForChild("AreaEggSlotsClient", 30)
local On = false
local Selected = nil
local EggList = {}
_G.EL2B_AutoFarm = {
    Enable = function() On = true end,
    Disable = function() On = false end,
    IsEnabled = function() return On end,
    ScanEggs = function() return EggList end,
    SelectEgg = function(e)
        Selected = e
        if _G.EL2B_TeleportSystem and e then
            _G.EL2B_TeleportSystem.SetTargetId(e.Id)
        end
    end,
    StartTeleport = function() if _G.EL2B_TeleportSystem then _G.EL2B_TeleportSystem.Enable() end end,
    StopTeleport = function() if _G.EL2B_TeleportSystem then _G.EL2B_TeleportSystem.Disable() end end,
    FormatMoney = function(a) if type(a) ~= "number" then return tostring(a) end if a >= 1e6 then return string.format("%.2fM", a/1e6) end return tostring(math.floor(a)) end,
}
]=]

_MERGED["Features/AFKSystem.lua"] = [=[
local On = false
_G.EL2B_AFKSystem = {
    Enable = function() On = true end,
    Disable = function() On = false end,
    IsEnabled = function() return On end,
    FindMyPlotAndTreadmill = function() return nil, nil end,
    FlyTP = function() end,
    JumpOutTreadmill = function(_, cb) if cb then cb() end end,
    GetMyTreadmillPos = function() return nil end,
}
]=]

_MERGED["Features/FarmingManager.lua"] = [=[
local On = false
_G.EL2B_FarmingManager = {
    Enable = function() On = true end,
    Disable = function() On = false end,
    IsEnabled = function() return On end,
    Toggle = function() On = not On end,
    SetRarities = function() end,
    FindBestEgg = function() return nil end,
}
]=]

_MERGED["Features/AttackDrone.lua"] = [=[
local On = false
_G.EL2B_AttackDrone = {
    Start = function() On = true end,
    Stop = function() On = false end,
    IsEnabled = function() return On end,
    Toggle = function() On = not On end,
}
]=]

_MERGED["Features/ManagerDrone.lua"] = [=[
local On = false
_G.EL2B_ManagerDrone = {
    Enable = function() On = true end,
    Disable = function() On = false end,
    IsEnabled = function() return On end,
    Toggle = function() On = not On end,
}
]=]

--============================================================
-- FEATURES STEAL A BRAINROT — PVP PANEL COMPLET
--============================================================
--[[
    ⚠️⚠️⚠️ PLACE LE SCRIPT PVP COMPLET ICI ⚠️⚠️⚠️
    Copie-colle TOUT le contenu du fichier EL2B_HUB_PVP-5.lua
    depuis la ligne : print("[EL2B HUB PVP] Script loading...")
    jusqu'à la ligne : print("EL2B HUB PVP chargé correctement !")
    
    ⚠️ Attention : si le contenu contient "]=]" il faut changer le délimiteur
    du bloc en [==[ ... ]==]
]]
_MERGED["Features/BrainrotPVP.lua"] = [==[
-- COLLE ICI LE SCRIPT PVP COMPLET (EL2B_HUB_PVP-5.lua)
]==]

--============================================================
-- TABS COMMUNS
--============================================================
_MERGED["Tabs/Info.lua"] = [=[
local TM = _G.EL2B_TabsManager
local InfoTab, InfoPage = TM:RegisterTab("Info", 1, "INFO")
CreateSectionTitle(InfoPage, "EL2B HUB — Multi Game", 1)

local DetectedGame = _G.EL2B_GameDetector and _G.EL2B_GameDetector.CurrentGame or "UNKNOWN"
local GL = Instance.new("TextLabel")
GL.Size = UDim2.new(1, 0, 0, 20)
GL.BackgroundTransparency = 1
GL.Text = "🎮 Detected Game : " .. DetectedGame
GL.TextColor3 = Color3.fromRGB(100, 255, 100)
GL.TextSize = 12
GL.TextXAlignment = Enum.TextXAlignment.Left
GL.Font = Enum.Font.GothamBold
GL.LayoutOrder = 2
GL.Parent = InfoPage

local DL = Instance.new("TextLabel")
DL.Size = UDim2.new(1, 0, 0, 24)
DL.BackgroundTransparency = 1
DL.Text = "Group Discord"
DL.TextColor3 = Color3.fromRGB(200, 200, 220)
DL.TextSize = 13
DL.Font = Enum.Font.GothamMedium
DL.LayoutOrder = 3
DL.Parent = InfoPage

local DISCORD = "https://discord.gg/TBBAUZu8cW"

local LinkBtn = Instance.new("TextButton")
LinkBtn.Size = UDim2.new(1, 0, 0, 30)
LinkBtn.BackgroundColor3 = Color3.fromRGB(28, 29, 42)
LinkBtn.BorderSizePixel = 0
LinkBtn.Text = "Link : " .. DISCORD
LinkBtn.TextColor3 = Color3.fromRGB(120, 180, 255)
LinkBtn.TextSize = 12
LinkBtn.TextXAlignment = Enum.TextXAlignment.Left
LinkBtn.Font = Enum.Font.GothamMedium
LinkBtn.AutoButtonColor = false
LinkBtn.LayoutOrder = 4
LinkBtn.Parent = InfoPage

Instance.new("UICorner", LinkBtn).CornerRadius = UDim.new(0, 6)
local LS = Instance.new("UIStroke")
LS.Color = Color3.fromRGB(105, 90, 190)
LS.Thickness = 1
LS.Transparency = 0.4
LS.Parent = LinkBtn

local LP = Instance.new("UIPadding")
LP.PaddingLeft = UDim.new(0, 10)
LP.PaddingRight = UDim.new(0, 10)
LP.Parent = LinkBtn

local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0, 120, 0, 32)
CopyBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
CopyBtn.BorderSizePixel = 0
CopyBtn.Text = "COPY LINK"
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.TextSize = 12
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.AutoButtonColor = false
CopyBtn.LayoutOrder = 5
CopyBtn.Parent = InfoPage

Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 6)

local function Copy()
    local ok = pcall(function() setclipboard(DISCORD) end)
    if ok then
        CopyBtn.Text = "COPIED!"
        CopyBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 60)
        task.delay(1.5, function()
            CopyBtn.Text = "COPY LINK"
            CopyBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        end)
    end
end
CopyBtn.MouseButton1Click:Connect(Copy)
LinkBtn.MouseButton1Click:Connect(Copy)
]=]

_MERGED["Tabs/Setting.lua"] = [=[
local TM = _G.EL2B_TabsManager
local SettingTab, SettingPage = TM:RegisterTab("Setting", 9, "SETTING")
CreateSectionTitle(SettingPage, "Settings", 1)

EL2B_MakeToggle(SettingPage, "Anti AFK", "Empêche l'AFK kick", 2, function()
    if _G.EL2B_AntiAFK then _G.EL2B_AntiAFK.Toggle() end
end, function() return _G.EL2B_AntiAFK and _G.EL2B_AntiAFK.IsEnabled() or false end)

EL2B_MakeToggle(SettingPage, "Anti Trap", "Supprime les traps", 3, function()
    if _G.EL2B_AntiTrap then _G.EL2B_AntiTrap.Toggle() end
end, function() return _G.EL2B_AntiTrap and _G.EL2B_AntiTrap.IsEnabled() or false end)

EL2B_MakeToggle(SettingPage, "Walk Speed", "Vitesse de marche", 4, function()
    if _G.EL2B_WalkSpeed then _G.EL2B_WalkSpeed.Toggle() end
end, function() return _G.EL2B_WalkSpeed and _G.EL2B_WalkSpeed.IsEnabled() or false end)

EL2B_MakeToggle(SettingPage, "Manual Fast Click", "Click rapide prompts", 5, function()
    if _G.EL2B_ManualFastClick then _G.EL2B_ManualFastClick.Toggle() end
end, function() return _G.EL2B_ManualFastClick and _G.EL2B_ManualFastClick.IsEnabled() or false end)

EL2B_MakeButton(SettingPage, "God Mode", "Active invincibilité", 6, "Enable", function()
    if _G.EL2B_GodMode then _G.EL2B_GodMode.Enable() end
end)
]=]

_MERGED["Tabs/HopServer.lua"] = [=[
local TM = _G.EL2B_TabsManager
local Http = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")
local PLACE = game.PlaceId
local HopTab, HopPage = TM:RegisterTab("Hop Server", 10, "HOP_SERVER")
CreateSectionTitle(HopPage, "Hop Server", 1)

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 20)
Status.BackgroundTransparency = 1
Status.Text = "Clique pour chercher"
Status.TextColor3 = Color3.fromRGB(150, 150, 170)
Status.TextSize = 10
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.LayoutOrder = 2
Status.Parent = HopPage

EL2B_MakeButton(HopPage, "Search Low Player Server", nil, 3, "Search", function()
    Status.Text = "Recherche..."
    local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", PLACE)
    local ok, resp = pcall(function() return Http:JSONDecode(game:HttpGet(url)) end)
    if not ok or not resp or not resp.data then
        Status.Text = "Échec"
        return
    end
    local servers = {}
    for _, s in ipairs(resp.data) do
        if s.id ~= game.JobId and s.playing < s.maxPlayers and s.playing >= 1 then
            table.insert(servers, s)
        end
    end
    if #servers == 0 then Status.Text = "Aucun serveur trouvé" return end
    local target = servers[1]
    pcall(function() TPS:TeleportToPlaceInstance(PLACE, target.id, game.Players.LocalPlayer) end)
end)
]=]

--============================================================
-- TABS SPÉCIFIQUES STEAL AN EGG
--============================================================
_MERGED["Tabs/Farming.lua"] = [=[
local TM = _G.EL2B_TabsManager
local FarmingTab, FarmingPage = TM:RegisterTab("Farming", 4, "FARMING")
CreateSectionTitle(FarmingPage, "Farming", 1)

EL2B_MakeToggle(FarmingPage, "Auto AFK Farming", "Farm les oeufs", 2, function()
    if _G.EL2B_FarmingManager then _G.EL2B_FarmingManager.Toggle() end
end, function() return _G.EL2B_FarmingManager and _G.EL2B_FarmingManager.IsEnabled() or false end)

EL2B_MakeToggle(FarmingPage, "Auto Equip Bat", nil, 3, function()
    if _G.EL2B_AutoAttack then _G.EL2B_AutoAttack.EnableAutoEquip() end
end, function() return _G.EL2B_AutoAttack and _G.EL2B_AutoAttack.IsAutoEquipEnabled() or false end)

EL2B_MakeToggle(FarmingPage, "Auto Hit Player", "Range: 60 studs", 4, function()
    if _G.EL2B_AutoAttack then _G.EL2B_AutoAttack.EnableAutoHit() end
end, function() return _G.EL2B_AutoAttack and _G.EL2B_AutoAttack.IsAutoHitEnabled() or false end)
]=]

_MERGED["Tabs/Combat.lua"] = [=[
local TM = _G.EL2B_TabsManager
local CT, CP = TM:RegisterTab("Combat", 5, "COMBAT")
CreateSectionTitle(CP, "Combat", 1)

EL2B_MakeToggle(CP, "Auto Equip Bat", nil, 2, function()
    if _G.EL2B_AutoAttack then _G.EL2B_AutoAttack.EnableAutoEquip() end
end, function() return _G.EL2B_AutoAttack and _G.EL2B_AutoAttack.IsAutoEquipEnabled() or false end)

EL2B_MakeToggle(CP, "Auto Hit Player", "Range auto", 3, function()
    if _G.EL2B_AutoAttack then _G.EL2B_AutoAttack.EnableAutoHit() end
end, function() return _G.EL2B_AutoAttack and _G.EL2B_AutoAttack.IsAutoHitEnabled() or false end)
]=]

_MERGED["Tabs/AutoFarming.lua"] = [=[
local TM = _G.EL2B_TabsManager
local AT, AP = TM:RegisterTab("Auto Farming", 6, "AUTO_FARMING")
CreateSectionTitle(AP, "Auto Farming", 1)

EL2B_MakeToggle(AP, "Auto Farm Enabled", nil, 2, function()
    if _G.EL2B_AutoFarm then _G.EL2B_AutoFarm.Enable() end
end, function() return _G.EL2B_AutoFarm and _G.EL2B_AutoFarm.IsEnabled() or false end)
]=]

_MERGED["Tabs/Event.lua"] = [=[
local TM = _G.EL2B_TabsManager
local ET, EP = TM:RegisterTab("Event", 7, "EVENT")
CreateSectionTitle(EP, "Event", 1)

EL2B_MakeToggle(EP, "Auto Attack Drone", "AFK Farm Drone", 2, function()
    if _G.EL2B_ManagerDrone then _G.EL2B_ManagerDrone.Toggle() end
end, function() return _G.EL2B_ManagerDrone and _G.EL2B_ManagerDrone.IsEnabled() or false end)
]=]

--============================================================
-- ONGLET BRAINROT (launcher du PVP panel)
--============================================================
_MERGED["Tabs/Brainrot.lua"] = [=[
local TM = _G.EL2B_TabsManager
local BT, BP = TM:RegisterTab("Brainrot", 8, "BRAINROT")
CreateSectionTitle(BP, "Steal a Brainrot — PVP Panel", 1)

local InfoLbl = Instance.new("TextLabel")
InfoLbl.Size = UDim2.new(1, 0, 0, 50)
InfoLbl.BackgroundTransparency = 1
InfoLbl.Text = "🎮 Le panel PVP complet s'affiche séparément (toutes les features : Flash TP, Block, Reset, Anti-Steal, Aimbot, ESP, Lagger, Drop, Turret, FPS Boost, IP ESP, etc.)\n\nUtilise les boutons ci-dessous :"
InfoLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
InfoLbl.TextSize = 10
InfoLbl.TextWrapped = true
InfoLbl.TextXAlignment = Enum.TextXAlignment.Left
InfoLbl.TextYAlignment = Enum.TextYAlignment.Top
InfoLbl.Font = Enum.Font.Gotham
InfoLbl.LayoutOrder = 2
InfoLbl.Parent = BP

local function findPvpGui()
    local parents = {}
    pcall(function() if gethui then table.insert(parents, gethui()) end end)
    pcall(function() table.insert(parents, game:GetService("CoreGui")) end)
    pcall(function() table.insert(parents, game.Players.LocalPlayer:FindFirstChild("PlayerGui")) end)
    for _, p in ipairs(parents) do
        if p then
            local g = p:FindFirstChild("EL2B HUB PVP")
            if g then return g end
        end
    end
    return nil
end

EL2B_MakeButton(BP, "Toggle PVP Panel", "Affiche/cache la GUI du PVP", 3, "Toggle", function()
    local g = findPvpGui()
    if g then g.Enabled = not g.Enabled end
end)

EL2B_MakeButton(BP, "Reset GUI Position", "Recentrer toutes les GUIs", 4, "Reset", function()
    if _G._175_RecoverGUIs then pcall(_G._175_RecoverGUIs) end
end)

EL2B_MakeToggle(BP, "Anti Steal", "Protège ta base", 5, function()
    _G.AntiSteal = not _G.AntiSteal
end, function() return _G.AntiSteal == true end)

EL2B_MakeToggle(BP, "Quick Pickup", "Agarre tes brainrots vite", 6, function()
    _G.QuickPickup = not _G.QuickPickup
    if _G._175_QuickPickup then _G._175_QuickPickup.set(_G.QuickPickup) end
end, function() return _G.QuickPickup == true end)

EL2B_MakeToggle(BP, "ESP Base", "Timers bases adverses", 7, function()
    _G.ESPBaseEnabled = not _G.ESPBaseEnabled
end, function() return _G.ESPBaseEnabled == true end)

EL2B_MakeToggle(BP, "FPS Boost", "Anti-lag + Nuke", 8, function()
    _G.FPSBoostEnabled = not _G.FPSBoostEnabled
    pcall(function()
        if _G.AceFPSBoost then
            if _G.FPSBoostEnabled then _G.AceFPSBoost.EnableAll()
            else _G.AceFPSBoost.DisableAll() end
        end
    end)
end, function() return _G.FPSBoostEnabled == true end)

local Tip = Instance.new("TextLabel")
Tip.Size = UDim2.new(1, 0, 0, 70)
Tip.BackgroundTransparency = 1
Tip.Text = "💡 Astuce : Toutes les autres features (Flash TP, Block, Reset, Loot Brainrot, Auto Return Base, Lagger Bypass, Quick AP, Drop Brainrot, ESP Best, IP ESP, Auto Turret, etc.) sont dans le panel PVP complet."
Tip.TextColor3 = Color3.fromRGB(255, 200, 100)
Tip.TextSize = 10
Tip.TextWrapped = true
Tip.TextXAlignment = Enum.TextXAlignment.Left
Tip.Font = Enum.Font.Gotham
Tip.LayoutOrder = 20
Tip.Parent = BP
]=]

--============================================================
-- LOADER
--============================================================
_G.EL2B_EnablePrint = false
local oldPrint = print
print = function(...) if _G.EL2B_EnablePrint then oldPrint(...) end end

_G.EL2B_Cache = {}
local function GetScript(path)
    if _G.EL2B_Cache[path] then return _G.EL2B_Cache[path] end
    local src = _MERGED[path]
    if not src then error("Missing module: " .. tostring(path), 0) end
    _G.EL2B_Cache[path] = src
    return src
end

local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local function CreateLoadingScreen()
    local LG = Instance.new("ScreenGui")
    LG.Name = "EL2B_Loading"
    LG.ResetOnSpawn = false
    LG.IgnoreGuiInset = true
    LG.DisplayOrder = 99999
    LG.Parent = CoreGui

    local F = Instance.new("Frame")
    F.Size = UDim2.new(0, 280, 0, 110)
    F.Position = UDim2.new(0.5, -140, 0.5, -55)
    F.BackgroundColor3 = Color3.fromRGB(16, 17, 23)
    F.BorderSizePixel = 0
    F.Parent = LG
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 14)
    local FS = Instance.new("UIStroke")
    FS.Color = Color3.fromRGB(105, 90, 190)
    FS.Thickness = 2
    FS.Parent = F

    local T = Instance.new("TextLabel")
    T.Size = UDim2.new(1, -30, 0, 28)
    T.Position = UDim2.new(0, 15, 0, 8)
    T.BackgroundTransparency = 1
    T.Text = "EL2B HUB"
    T.TextColor3 = Color3.fromRGB(255, 255, 255)
    T.TextSize = 20
    T.Font = Enum.Font.GothamBold
    T.Parent = F

    local St = Instance.new("TextLabel")
    St.Size = UDim2.new(1, -30, 0, 14)
    St.Position = UDim2.new(0, 15, 0, 36)
    St.BackgroundTransparency = 1
    St.Text = "Multi-Game v3.0"
    St.TextColor3 = Color3.fromRGB(145, 145, 175)
    St.TextSize = 9
    St.Font = Enum.Font.GothamMedium
    St.Parent = F

    local BG = Instance.new("Frame")
    BG.Size = UDim2.new(0.75, 0, 0, 4)
    BG.Position = UDim2.new(0.125, 0, 0.5, 0)
    BG.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    BG.BorderSizePixel = 0
    BG.Parent = F
    Instance.new("UICorner", BG).CornerRadius = UDim.new(1, 0)

    local B = Instance.new("Frame")
    B.Size = UDim2.new(0, 0, 1, 0)
    B.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
    B.BorderSizePixel = 0
    B.Parent = BG
    Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)

    local P = Instance.new("TextLabel")
    P.Size = UDim2.new(1, -30, 0, 22)
    P.Position = UDim2.new(0, 15, 0.7, 0)
    P.BackgroundTransparency = 1
    P.Text = "0%"
    P.TextColor3 = Color3.fromRGB(105, 90, 190)
    P.TextSize = 18
    P.Font = Enum.Font.GothamBold
    P.Parent = F

    return {
        Update = function(pct)
            pct = math.clamp(pct, 0, 100)
            B.Size = UDim2.new(pct / 100, 0, 1, 0)
            P.Text = math.floor(pct) .. "%"
        end,
        Destroy = function() LG:Destroy() end,
    }
end

local Loading = CreateLoadingScreen()

local function LoadModule(path)
    local src = GetScript(path)
    local fn, err = loadstring(src, "=" .. path)
    if not fn then warn("[EL2B] Load fail " .. path .. ": " .. tostring(err)) return end
    local ok, rerr = pcall(fn)
    if not ok then warn("[EL2B] Error in " .. path .. ": " .. tostring(rerr)) end
end

Loading.Update(5)  LoadModule("Config.lua")
Loading.Update(10) LoadModule("UI.lua")
Loading.Update(15) LoadModule("Components.lua")
Loading.Update(20) LoadModule("Tabs/Init.lua")
Loading.Update(25) LoadModule("Features/GameDetector.lua")
Loading.Update(30)

-- Features communes
LoadModule("Features/AntiAFK.lua")
LoadModule("Features/WalkSpeed.lua")
LoadModule("Features/AntiTrap.lua")
LoadModule("Features/GodMode.lua")
LoadModule("Features/ManualFastClick.lua")
LoadModule("Features/AutoAttack.lua")
LoadModule("Features/ConfigSystem.lua")
LoadModule("Features/BypassAntiCheat.lua")
Loading.Update(50)

-- Chargement conditionnel selon le jeu
local D = _G.EL2B_GameDetector
if D and D.IsEgg() then
    LoadModule("Features/TeleportSystem.lua")
    LoadModule("Features/VIPTP.lua")
    LoadModule("Features/AutoFarm.lua")
    LoadModule("Features/AFKSystem.lua")
    LoadModule("Features/FarmingManager.lua")
    LoadModule("Features/AttackDrone.lua")
    LoadModule("Features/ManagerDrone.lua")
elseif D and D.IsBrainrot() then
    LoadModule("Features/BrainrotPVP.lua")
end
Loading.Update(70)

-- Tabs communs
LoadModule("Tabs/Info.lua")
LoadModule("Tabs/Setting.lua")
LoadModule("Tabs/HopServer.lua")

-- Tabs spécifiques
if D and D.IsEgg() then
    LoadModule("Tabs/Farming.lua")
    LoadModule("Tabs/Combat.lua")
    LoadModule("Tabs/AutoFarming.lua")
    LoadModule("Tabs/Event.lua")
elseif D and D.IsBrainrot() then
    LoadModule("Tabs/Brainrot.lua")
end
Loading.Update(90)

if _G.EL2B_TabsManager then
    _G.EL2B_TabsManager:SelectTabByName("Info")
end
Loading.Update(95)
task.wait(1.5)
if _G.EL2B_ConfigSystem then _G.EL2B_ConfigSystem.Load() end
Loading.Update(100)
task.wait(0.3)
Loading.Destroy()
print = oldPrint
print("[EL2B HUB] Loaded — Game: " .. tostring(D and D.CurrentGame))
