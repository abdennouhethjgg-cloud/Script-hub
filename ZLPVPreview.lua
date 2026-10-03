--[[
    ═══════════════════════════════════════════════════════════════
    EL2B HUB | Multi-Game (Steal an Egg / Steal a Brainrot)
    Auteur  : EL2B
    Version : 2.0
    Jeux    : 107778070777162 (Steal an Egg)
              109983668079237 (Steal a Brainrot)
    ═══════════════════════════════════════════════════════════════
]]

--============================================================
-- MERGED MODULES
--============================================================
_MERGED = {}

_MERGED["Config.lua"] = [=[
_G.EL2B = {
    Name = "EL2B HUB",
    Version = "telegram : @maibigber",
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

local function CreateDragZone(Name, Position, Size)
    local Zone = Instance.new("Frame")
    Zone.Name = Name
    Zone.Position = Position
    Zone.Size = Size
    Zone.BackgroundTransparency = 1
    Zone.Active = true
    Zone.ZIndex = 50
    Zone.Parent = Main
    Zone.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            StartDrag(Input)
        end
    end)
end

CreateDragZone("DragTop", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 5))
CreateDragZone("DragBottom", UDim2.new(0, 0, 1, -5), UDim2.new(1, 0, 0, 5))
CreateDragZone("DragLeft", UDim2.new(0, 0, 0, 0), UDim2.new(0, 5, 1, 0))
CreateDragZone("DragRight", UDim2.new(1, -5, 0, 0), UDim2.new(0, 5, 1, 0))

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
    Services.TweenService:Create(Toggle, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 45, 0, 45) }):Play()
    task.wait(0.1)
    Services.TweenService:Create(Toggle, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 55, 0, 55) }):Play()
end)
]=]

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
    Text.Active = false
    Text.Selectable = false
    Text.ZIndex = 8
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
    Page.ScrollBarImageTransparency = 0.1
    Page.VerticalScrollBarInset = Enum.ScrollBarInset.Always
    Page.Active = true
    Page.Selectable = true
    Page.ZIndex = 6
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

-- Composant checkbox générique réutilisable
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

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn

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
        local state = IsEnabledFunc and IsEnabledFunc() or not Check.Visible
        UpdateUI(state)
    end)

    task.spawn(function()
        while task.wait(1) do
            local state = IsEnabledFunc and IsEnabledFunc() or false
            if state ~= Check.Visible then UpdateUI(state) end
        end
    end)

    return Holder, Btn, Check
end

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

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn

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
    Btn.MouseButton1Click:Connect(function()
        if Callback then Callback() end
    end)

    return Holder, Btn
end
]=]

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
    Tab.MouseButton1Click:Connect(function()
        self:SelectTab(Tab, Page)
    end)
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

local function Apply()
    local h = GetHum()
    if h then h.WalkSpeed = Value end
end

local function Stop()
    local h = GetHum()
    if h then h.WalkSpeed = Orig end
    if Conn then Conn:Disconnect() Conn = nil end
end

local function Start()
    local h = GetHum()
    if h then Orig = h.WalkSpeed end
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
    pcall(function() NewH:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
    pcall(function() NewH.BreakJointsOnDeath = false end)
    pcall(function() NewH.RequiresNeck = false end)
    pcall(function() NewH.MaxHealth = math.huge NewH.Health = math.huge end)

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
    Toggle = function() if On then On = false if Conn then Conn:Disconnect() Conn = nil end else On = true task.spawn(Run) end end,
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
    local t = FindClosest()
    if not t then return end
    local r = GetRemote()
    if not r then return end
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

local function Ensure()
    pcall(function() if not isfolder(FOLDER) then makefolder(FOLDER) end end)
end

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
    if type(dec.TeleportSpeed) == "number" then
        c.TeleportSpeed = math.clamp(dec.TeleportSpeed, 50, 1100)
    end
    return c
end

local function Save(c)
    Ensure()
    local data = { SelectedMethod = c.SelectedMethod or Default.SelectedMethod, TeleportSpeed = c.TeleportSpeed or Default.TeleportSpeed }
    local ok, enc = pcall(function() return Http:JSONEncode(data) end)
    if not ok then return false end
    local w = pcall(function() writefile(FILE, enc) end)
    return w
end

local function Apply(c)
    _G.EL2B_SelectedMethod = c.SelectedMethod
    _G.EL2B_TeleportSpeed = c.TeleportSpeed
end

local Init = Load()
Apply(Init)

_G.EL2B_ConfigSystem = {
    Load = function()
        local c = Load()
        Apply(c)
        task.spawn(function()
            task.wait(0.5)
            if _G.EL2B_RefreshSettingUI then _G.EL2B_RefreshSettingUI() end
        end)
        return c
    end,
    Save = function()
        return Save({
            SelectedMethod = _G.EL2B_SelectedMethod or Default.SelectedMethod,
            TeleportSpeed = _G.EL2B_TeleportSpeed or Default.TeleportSpeed
        })
    end,
    Reset = function() Apply(Default) return Save(Default) end,
}
]=]

_MERGED["Features/BypassAntiCheat.lua"] = [=[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
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

Player.CharacterAdded:Connect(function(c)
    task.wait(1)
    Run()
end)

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
-- FEATURES EGG
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
    if r then
        for _, c in ipairs(r:GetChildren()) do
            if c.Name == "EL2BBV" or c.Name == "EL2BBG" then pcall(function() c:Destroy() end) end
        end
    end
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
        task.wait(0.05)
        StartLock(dest)
        if cb then cb() end
    end)
end

local function TP(dest, cb)
    if S.Method == "InstantTeleport" then InstantTP(dest, cb) else FlyTP(dest, false, false, cb) end
end

local function RCFirst()
    if not CollectEvent or not S.FirstEggSlotKey or not S.FirstEggUid then return false end
    return pcall(function()
        CollectEvent:InvokeServer({ FirstAreaSlotKey = S.FirstEggSlotKey, Uid = S.FirstEggUid })
    end)
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
            if n then
                table.insert(S.FirstEggList, { Slot = sl, Uid = sl.Name, SlotKey = "Forest:Slot_"..n })
            end
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
    S.FirstEggList = {}
    S.FirstEggUid = nil
    S.FirstEggSlotKey = nil
    S.RecoveryAttempts = 0
    S.RemotesFired = false
end

local function StartFlyTarget()
    if S.FlyTargetStarted then return end
    S.FlyTargetStarted = true
    S.Step = "to_target"
    local tp
    if S.Mode == "spawn" then
        local e = Container and Container:FindFirstChild(S.TargetUid)
        if e then tp = GetPos(e) end
    elseif S.Mode == "workspace" then
        tp = S.SavedTargetPosition
    end
    if not tp then AutoStop() return end
    TP(tp, function()
        S.TargetCollected = false
        S.CollectTime = 0
        S.CollectAttempts = 0
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
    S.RecoveryTriggered = false
    S.TargetCollected = false
    FlyTP(tp, false, false, function()
        S.TargetCollected = false
        S.CollectTime = 0
        S.CollectAttempts = 0
        S.RecoveryTriggered = false
        S.RemotesFired = false
        S.TargetCollectStartTime = tick()
        S.Step = "collect_target"
    end)
end

local function FlySafe()
    S.Step = "to_safe"
    S.RecoveryTriggered = false
    S.TargetCollected = false
    FlyTP(Config.SafeZone, false, true, function()
        if S.LockConnection then S.LockConnection:Disconnect() S.LockConnection = nil end
        S.TargetLockedCFrame = nil
        if S.ActiveHeartbeat then S.ActiveHeartbeat:Disconnect() S.ActiveHeartbeat = nil end
        Cleanup()
        S.Running = false
        S.Step = "idle"
        S.Mode = "none"
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
    S.Mode = "none"
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
-- VIPTP : réutilise TeleportSystem avec InstantTeleport
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

local Cache = { MeshIdMap = {}, Built = false, PetData = {}, UidCat = {} }
local On = false
local Selected = nil
local EggList = {}

local Assets = RS:WaitForChild("Data", 10)
if Assets then Assets = Assets:WaitForChild("Assets", 10) end
local Configs = Assets and Assets:FindFirstChild("Configs")
local EggModels = RS:FindFirstChild("Assets")
if EggModels then EggModels = EggModels:FindFirstChild("Models") end
if EggModels then EggModels = EggModels:FindFirstChild("Eggs") end

local Mut = nil
pcall(function() Mut = require(RS.Shared.Modules.Mutations) end)

local function Build()
    if Cache.Built or not Configs or not EggModels then return end
    for _, c in ipairs(Configs:GetChildren()) do
        local ok, M = pcall(function() return require(c) end)
        if ok and M and M.Egg then
            local mn = M.Egg.ModelName or c.Name
            local t = EggModels:FindFirstChild(mn)
            if t then
                for _, d in ipairs(t:GetDescendants()) do
                    if (d:IsA("MeshPart") or d:IsA("SpecialMesh")) and d.MeshId ~= "" then
                        Cache.MeshIdMap[d.MeshId] = c.Name
                    end
                end
            end
        end
    end
    Cache.Built = true
end
Build()

local function GetPetData(cat)
    if not cat or not Configs then return nil end
    if Cache.PetData[cat] then return Cache.PetData[cat] end
    local cfg = Configs:FindFirstChild(cat)
    if not cfg then return nil end
    local d = { Name = cat, DisplayName = cat, EarningRate = 0, Icon = nil }
    local ok, M = pcall(function() return require(cfg) end)
    if ok and M then
        d.DisplayName = M.DisplayName or cat
        d.EarningRate = M.EarningRate or 0
        d.Icon = M.Icon
    end
    Cache.PetData[cat] = d
    return d
end

local function FindCat(m)
    if not m then return nil end
    local u = m.Name
    if Cache.UidCat[u] then return Cache.UidCat[u] end
    for _, d in ipairs(m:GetDescendants()) do
        if (d:IsA("MeshPart") or d:IsA("SpecialMesh")) and d.MeshId ~= "" then
            local c = Cache.MeshIdMap[d.MeshId]
            if c then Cache.UidCat[u] = c return c end
        end
    end
end

local function FormatMoney(a)
    if type(a) ~= "number" then return tostring(a) end
    if a >= 1e12 then return string.format("%.2fT", a / 1e12) end
    if a >= 1e9 then return string.format("%.2fB", a / 1e9) end
    if a >= 1e6 then return string.format("%.2fM", a / 1e6) end
    if a >= 1e3 then return string.format("%.2fK", a / 1e3) end
    return tostring(math.floor(a))
end

local function CalcRate(r, s, muts)
    local pf = (s <= 5) and (s ^ 1.85) or ((s/5)^1.2 * 19.637875755794113)
    local mm = 1
    if muts and #muts > 0 and Mut then
        local ok, res = pcall(function() return Mut.EarningsFor(muts) end)
        if ok then mm = res end
    end
    return math.round(r * pf * mm)
end

local function Scan()
    EggList = {}
    if not Container then return EggList end
    for _, c in ipairs(Container:GetChildren()) do
        if c:IsA("Model") then
            local cat = FindCat(c)
            if cat then
                local d = GetPetData(cat)
                if d then
                    local sc = c:GetAttribute("AssetScale") or 1
                    local muts = c:GetAttribute("Mutations") or {}
                    local rr = CalcRate(d.EarningRate, sc, muts)
                    table.insert(EggList, { Id = c.Name, Category = cat, DisplayName = d.DisplayName, Icon = d.Icon, EarningRate = rr, Model = c })
                end
            end
        end
    end
    table.sort(EggList, function(a, b) return a.EarningRate > b.EarningRate end)
    return EggList
end

_G.EL2B_AutoFarm = {
    Enable = function() On = true end,
    Disable = function() On = false end,
    IsEnabled = function() return On end,
    ScanEggs = Scan,
    SelectEgg = function(e)
        Selected = e
        if _G.EL2B_TeleportSystem and e then
            _G.EL2B_TeleportSystem.SetMethod(_G.EL2B_SelectedMethod or "TeleportFly")
            _G.EL2B_TeleportSystem.SetSpeed(_G.EL2B_TeleportSpeed or 300)
            _G.EL2B_TeleportSystem.SetTargetId(e.Id)
        end
    end,
    StartTeleport = function() if _G.EL2B_TeleportSystem then _G.EL2B_TeleportSystem.Enable() end end,
    StopTeleport = function() if _G.EL2B_TeleportSystem then _G.EL2B_TeleportSystem.Disable() end end,
    GetSelectedEgg = function() return Selected end,
    FormatMoney = FormatMoney,
}
]=]

_MERGED["Features/AFKSystem.lua"] = [=[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local FLY_SPEED, ARRIVE_TIMEOUT = 350, 15
local SAFE_ZONE = Vector3.new(533, 70, -366)
local On = false
local Plot, Treadmill, TreadmillPos = nil, nil, nil
local Conn, BV, BG = nil, nil, nil
local DistThread = nil

local function GetHum()
    local c = Player.Character
    if not c then return nil, nil end
    return c:FindFirstChildOfClass("Humanoid"), c:FindFirstChild("HumanoidRootPart")
end

local function Cleanup()
    if Conn then Conn:Disconnect() Conn = nil end
    if BV then pcall(function() BV.Velocity = Vector3.zero BV.MaxForce = Vector3.zero end) BV:Destroy() BV = nil end
    if BG then pcall(function() BG.MaxTorque = Vector3.zero end) BG:Destroy() BG = nil end
    local h, r = GetHum()
    if h then pcall(function() h.PlatformStand = false h.Sit = false end) end
    if r then pcall(function() r.AssemblyLinearVelocity = Vector3.zero r.AssemblyAngularVelocity = Vector3.zero end) end
end

local function FindMy()
    local P = workspace:FindFirstChild("Plots")
    if not P then return nil, nil end
    for _, plot in ipairs(P:GetChildren()) do
        if plot:IsA("Model") then
            local s = plot:FindFirstChild("PlotSign")
            if s then
                local ps = s:FindFirstChild("PlayerPlotSign")
                if ps then
                    local f = ps:FindFirstChild("Frame")
                    if f then
                        local n = f:FindFirstChild("PlayerName")
                        if n and n:IsA("TextLabel") then
                            if n.Text == Player.Name or n.Text == Player.DisplayName then
                                return plot, plot:FindFirstChild("TreadmillBottom")
                            end
                        end
                    end
                end
            end
        end
    end
end

local function FlyTP(dest, cb)
    Cleanup()
    local h, r = GetHum()
    if not h or not r or h.Health <= 0 then if cb then cb() end return end
    h.PlatformStand = true
    BV = Instance.new("BodyVelocity")
    BV.Name = "EL2BBV"
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BV.P = 1250
    BV.Velocity = Vector3.zero
    BV.Parent = r
    BG = Instance.new("BodyGyro")
    BG.Name = "EL2BBG"
    BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    BG.P = 3000
    BG.D = 500
    BG.CFrame = r.CFrame
    BG.Parent = r
    local st = tick()
    Conn = RunService.Heartbeat:Connect(function()
        if not On then Cleanup() return end
        local h2, r2 = GetHum()
        if not h2 or not r2 or h2.Health <= 0 then Cleanup() return end
        if not BV or not BG then Cleanup() return end
        local d = dest - r2.Position
        if math.floor(d.Magnitude) <= 2 then Cleanup() if cb then cb() end return end
        if tick() - st > ARRIVE_TIMEOUT then Cleanup() if cb then cb() end return end
        BV.Velocity = d.Unit * FLY_SPEED
        BG.CFrame = CFrame.new(r2.Position, dest)
    end)
end

local function JumpOut(pos, cb)
    local h, r = GetHum()
    if not h or not r or not pos then if cb then cb() end return end
    task.spawn(function()
        local a = 0
        while On and a < 50 do
            local h2, r2 = GetHum()
            if not h2 or not r2 then break end
            if math.floor((r2.Position - pos).Magnitude) > 5 then if cb then cb() end return end
            pcall(function() h2.Jump = true end)
            a = a + 1
            task.wait(0.2)
        end
        if cb then cb() end
    end)
end

local function StartCheck()
    if DistThread then pcall(function() task.cancel(DistThread) end) DistThread = nil end
    DistThread = task.spawn(function()
        while On do
            task.wait(4)
            if not On then break end
            local _, r = GetHum()
            if r and TreadmillPos then
                if math.floor((r.Position - TreadmillPos).Magnitude) > 5 then FlyTP(TreadmillPos) end
            end
        end
    end)
end

_G.EL2B_AFKSystem = {
    Enable = function()
        if On then return end
        On = true
        Plot, Treadmill = FindMy()
        if not Treadmill then On = false return end
        TreadmillPos = Treadmill.Position
        FlyTP(SAFE_ZONE, function()
            task.wait(1)
            FlyTP(TreadmillPos, function() StartCheck() end)
        end)
    end,
    Disable = function()
        if not On then return end
        On = false
        if DistThread then pcall(function() task.cancel(DistThread) end) DistThread = nil end
        Cleanup()
    end,
    IsEnabled = function() return On end,
    FindMyPlotAndTreadmill = FindMy,
    FlyTP = FlyTP,
    JumpOutTreadmill = JumpOut,
    GetMyTreadmillPos = function() return TreadmillPos end,
}
]=]

_MERGED["Features/FarmingManager.lua"] = [=[
local On = false

_G.EL2B_FarmingManager = {
    Enable = function() On = true end,
    Disable = function() On = false end,
    IsEnabled = function() return On end,
    SetRarities = function() end,
    FindBestEgg = function() return nil end,
    OnVIPTPComplete = function() end,
    GetState = function() return "IDLE" end,
    GetPhase = function() return "UNKNOWN" end,
}
]=]

_MERGED["Features/AttackDrone.lua"] = [=[
local On = false
_G.EL2B_AttackDrone = {
    Start = function() On = true end,
    Stop = function() On = false end,
    Enable = function() On = true end,
    Disable = function() On = false end,
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
-- FEATURES BRAINROT
--============================================================
_MERGED["Features/StealABrainrot.lua"] = [=[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

local Config = {
    AutoStealRadius = 300,
    FlySpeed = 350,
    StealInterval = 0.5,
    ReturnDelay = 0.4,
}

local State = {
    Running = false,
    AutoStealOn = false,
    AutoCollectOn = false,
    ESPOn = false,
    BV = nil, BG = nil, FlyConn = nil,
    Highlights = {},
    ESPConn = nil,
    StealThread = nil,
    CollectThread = nil,
}

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
    elseif o:IsA("BasePart") then
        return o.Position
    end
end

local function Cleanup()
    if State.FlyConn then State.FlyConn:Disconnect() State.FlyConn = nil end
    if State.BV then pcall(function() State.BV.Velocity = Vector3.zero State.BV.MaxForce = Vector3.zero end) State.BV:Destroy() State.BV = nil end
    if State.BG then pcall(function() State.BG.MaxTorque = Vector3.zero end) State.BG:Destroy() State.BG = nil end
    local h, r = GetHum()
    if h then pcall(function() h.PlatformStand = false end) end
    if r then pcall(function() r.AssemblyLinearVelocity = Vector3.zero r.AssemblyAngularVelocity = Vector3.zero end) end
end

local function FlyTo(dest, cb)
    Cleanup()
    local h, r = GetHum()
    if not h or not r or h.Health <= 0 then if cb then cb() end return end
    h.PlatformStand = true
    State.BV = Instance.new("BodyVelocity")
    State.BV.Name = "EL2BBV_BR"
    State.BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    State.BV.P = 1250
    State.BV.Velocity = Vector3.zero
    State.BV.Parent = r
    State.BG = Instance.new("BodyGyro")
    State.BG.Name = "EL2BBG_BR"
    State.BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    State.BG.P = 3000
    State.BG.D = 500
    State.BG.CFrame = r.CFrame
    State.BG.Parent = r
    local st = tick()
    State.FlyConn = RunService.Heartbeat:Connect(function()
        if not State.Running then Cleanup() return end
        local h2, r2 = GetHum()
        if not h2 or not r2 then Cleanup() return end
        if not State.BV or not State.BG then Cleanup() return end
        local d = (dest - r2.Position).Magnitude
        if d <= 3 or tick() - st > 15 then Cleanup() if cb then cb() end return end
        State.BV.Velocity = (dest - r2.Position).Unit * Config.FlySpeed
        State.BG.CFrame = CFrame.new(r2.Position, dest)
    end)
end

local function IsBrainrot(o)
    if not o or not o:IsA("Model") then return false end
    if o:GetAttribute("IsBrainrot") or o:GetAttribute("BrainrotName") or o:GetAttribute("UnitName") then return true end
    local n = o.Name
    if n:match("Brainrot") or n:match("_BR$") or n:match("^Unit_") then return true end
    return false
end

local function FindNearest()
    local _, r = GetHum()
    if not r then return nil end
    local mp = r.Position
    local best, bd = nil, Config.AutoStealRadius
    for _, o in ipairs(workspace:GetDescendants()) do
        if IsBrainrot(o) then
            local p = GetPos(o)
            if p then
                local d = (p - mp).Magnitude
                if d < bd then bd = d best = o end
            end
        end
    end
    return best
end

local STEAL_REMOTES = {
    "RE/Steal/Attempt", "RE/Brainrot/Steal", "RE/StealBrainrot",
    "RF/Steal/Attempt", "RE/Base/Steal", "StealRemote", "StealBrainrot",
}

local COLLECT_REMOTES = {
    "RE/Collect/Claim", "RE/Base/Collect", "RF/Collect/Money",
    "RE/Brainrot/Collect", "CollectMoney", "ClaimIncome",
}

local function FireRemotes(names, arg)
    local net = RS:FindFirstChild("Packages")
    if net then net = net:FindFirstChild("Networking") end
    local fired = false
    local function Try(remote)
        if not remote then return end
        pcall(function()
            if remote:IsA("RemoteEvent") then
                if arg ~= nil then remote:FireServer(arg) else remote:FireServer() end
            elseif remote:IsA("RemoteFunction") then
                if arg ~= nil then remote:InvokeServer(arg) else remote:InvokeServer() end
            end
            fired = true
        end)
    end
    if net then
        for _, n in ipairs(names) do Try(net:FindFirstChild(n)) if fired then return true end end
    end
    for _, n in ipairs(names) do Try(RS:FindFirstChild(n, true)) if fired then return true end end
    return fired
end

local function DoStealOnce()
    local br = FindNearest()
    if not br then return false end
    local pos = GetPos(br)
    if not pos then return false end
    local done = false
    FlyTo(pos, function() done = true end)
    local t = tick() + 5
    while not done and tick() < t and State.Running do task.wait(0.05) end
    if not State.Running then return false end
    FireRemotes(STEAL_REMOTES, br)
    task.wait(Config.ReturnDelay)
    local base = workspace:FindFirstChild("MyBase") or workspace:FindFirstChild("PlayerBase")
    if base then
        local bp = GetPos(base)
        if bp then
            local back = false
            FlyTo(bp, function() back = true end)
            local t2 = tick() + 5
            while not back and tick() < t2 and State.Running do task.wait(0.05) end
        end
    end
    return true
end

local function StartAutoSteal()
    if State.AutoStealOn then return end
    State.AutoStealOn = true
    State.Running = true
    State.StealThread = task.spawn(function()
        while State.AutoStealOn do
            pcall(DoStealOnce)
            task.wait(Config.StealInterval)
        end
    end)
end

local function StopAutoSteal()
    State.AutoStealOn = false
    State.Running = false
    if State.StealThread then pcall(function() task.cancel(State.StealThread) end) State.StealThread = nil end
    Cleanup()
end

local function StartAutoCollect()
    if State.AutoCollectOn then return end
    State.AutoCollectOn = true
    State.CollectThread = task.spawn(function()
        while State.AutoCollectOn do
            pcall(function() FireRemotes(COLLECT_REMOTES, nil) end)
            task.wait(1)
        end
    end)
end

local function StopAutoCollect()
    State.AutoCollectOn = false
    if State.CollectThread then pcall(function() task.cancel(State.CollectThread) end) State.CollectThread = nil end
end

local function RefreshESP()
    if not State.ESPOn then return end
    local seen = {}
    for _, o in ipairs(workspace:GetDescendants()) do
        if IsBrainrot(o) then
            seen[o] = true
            if not State.Highlights[o] then
                local hl = Instance.new("Highlight")
                hl.FillColor = Color3.fromRGB(255, 80, 80)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.5
                hl.OutlineTransparency = 0
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Adornee = o
                hl.Parent = o
                State.Highlights[o] = hl
            end
        end
    end
    for o, hl in pairs(State.Highlights) do
        if not seen[o] or not o.Parent then
            if hl then hl:Destroy() end
            State.Highlights[o] = nil
        end
    end
end

local function StartESP()
    if State.ESPOn then return end
    State.ESPOn = true
    if State.ESPConn then State.ESPConn:Disconnect() end
    State.ESPConn = RunService.Heartbeat:Connect(function()
        if not State.ESPOn then return end
        RefreshESP()
    end)
end

local function StopESP()
    State.ESPOn = false
    if State.ESPConn then State.ESPConn:Disconnect() State.ESPConn = nil end
    for o, hl in pairs(State.Highlights) do
        if hl then hl:Destroy() end
        State.Highlights[o] = nil
    end
end

local function TeleportToMyBase()
    local base = workspace:FindFirstChild("MyBase") or workspace:FindFirstChild("PlayerBase") or workspace:FindFirstChild("Base")
    if not base then return end
    local p = GetPos(base)
    if not p then return end
    State.Running = true
    FlyTo(p, function() State.Running = false end)
end

_G.EL2B_StealABrainrot = {
    ToggleAutoSteal = function() if State.AutoStealOn then StopAutoSteal() else StartAutoSteal() end end,
    EnableAutoSteal = StartAutoSteal,
    DisableAutoSteal = StopAutoSteal,
    IsAutoStealEnabled = function() return State.AutoStealOn end,

    ToggleAutoCollect = function() if State.AutoCollectOn then StopAutoCollect() else StartAutoCollect() end end,
    EnableAutoCollect = StartAutoCollect,
    DisableAutoCollect = StopAutoCollect,
    IsAutoCollectEnabled = function() return State.AutoCollectOn end,

    ToggleESP = function() if State.ESPOn then StopESP() else StartESP() end end,
    EnableESP = StartESP,
    DisableESP = StopESP,
    IsESPEnabled = function() return State.ESPOn end,

    TeleportToMyBase = TeleportToMyBase,
    FindNearestBrainrot = FindNearest,
    DoStealOnce = DoStealOnce,
}
]=]

--============================================================
-- TABS
--============================================================
_MERGED["Tabs/Info.lua"] = [=[
local TM = _G.EL2B_TabsManager
local TS = game:GetService("TweenService")
local InfoTab, InfoPage = TM:RegisterTab("Info", 1, "INFO")
CreateSectionTitle(InfoPage, "EL2B HUB — Multi Game", 1)

local TL = Instance.new("TextLabel")
TL.Size = UDim2.new(1, 0, 0, 26)
TL.BackgroundTransparency = 1
TL.Text = "Join Group For Notification Update Script"
TL.TextColor3 = Color3.fromRGB(255, 255, 255)
TL.TextSize = 13
TL.TextXAlignment = Enum.TextXAlignment.Left
TL.Font = Enum.Font.GothamBold
TL.LayoutOrder = 2
TL.Parent = InfoPage

local GL = Instance.new("TextLabel")
GL.Size = UDim2.new(1, 0, 0, 24)
GL.BackgroundTransparency = 1
GL.Text = "Group Discord"
GL.TextColor3 = Color3.fromRGB(200, 200, 220)
GL.TextSize = 13
GL.TextXAlignment = Enum.TextXAlignment.Left
GL.Font = Enum.Font.GothamMedium
GL.LayoutOrder = 3
GL.Parent = InfoPage

local DetectedGame = _G.EL2B_GameDetector and _G.EL2B_GameDetector.CurrentGame or "UNKNOWN"
local GL2 = Instance.new("TextLabel")
GL2.Size = UDim2.new(1, 0, 0, 20)
GL2.BackgroundTransparency = 1
GL2.Text = "Detected Game : " .. DetectedGame
GL2.TextColor3 = Color3.fromRGB(100, 255, 100)
GL2.TextSize = 12
GL2.TextXAlignment = Enum.TextXAlignment.Left
GL2.Font = Enum.Font.GothamBold
GL2.LayoutOrder = 4
GL2.Parent = InfoPage

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
LinkBtn.LayoutOrder = 5
LinkBtn.Parent = InfoPage

local LC = Instance.new("UICorner")
LC.CornerRadius = UDim.new(0, 6)
LC.Parent = LinkBtn

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
CopyBtn.LayoutOrder = 6
CopyBtn.Parent = InfoPage

local CC = Instance.new("UICorner")
CC.CornerRadius = UDim.new(0, 6)
CC.Parent = CopyBtn

local CS = Instance.new("UIStroke")
CS.Color = Color3.fromRGB(120, 130, 255)
CS.Thickness = 1.5
CS.Transparency = 0.3
CS.Parent = CopyBtn

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
local TS = game:GetService("TweenService")
local SettingTab, SettingPage = TM:RegisterTab("Setting", 2, "SETTING")
CreateSectionTitle(SettingPage, "Settings", 1)

-- WalkSpeed
local WSH = Instance.new("Frame")
WSH.Size = UDim2.new(1, 0, 0, 32)
WSH.BackgroundTransparency = 1
WSH.LayoutOrder = 2
WSH.Parent = SettingPage

local WSL = Instance.new("TextLabel")
WSL.Size = UDim2.new(0, 100, 1, 0)
WSL.BackgroundTransparency = 1
WSL.Text = "Walk Speed"
WSL.TextColor3 = Color3.fromRGB(255, 255, 255)
WSL.TextSize = 12
WSL.TextXAlignment = Enum.TextXAlignment.Left
WSL.TextYAlignment = Enum.TextYAlignment.Center
WSL.Font = Enum.Font.GothamMedium
WSL.Parent = WSH

local WST = Instance.new("TextBox")
WST.Size = UDim2.new(0, 60, 1, -6)
WST.Position = UDim2.new(0, 105, 0, 3)
WST.BackgroundColor3 = Color3.fromRGB(30, 31, 45)
WST.BorderSizePixel = 0
WST.Text = "50"
WST.TextColor3 = Color3.fromRGB(255, 255, 255)
WST.TextSize = 12
WST.TextXAlignment = Enum.TextXAlignment.Center
WST.Font = Enum.Font.GothamMedium
WST.Parent = WSH

local WSC = Instance.new("UICorner")
WSC.CornerRadius = UDim.new(0, 4)
WSC.Parent = WST

EL2B_MakeToggle(SettingPage, "Enable WalkSpeed", nil, 3, function()
    if _G.EL2B_WalkSpeed then _G.EL2B_WalkSpeed.Toggle() end
end, function()
    return _G.EL2B_WalkSpeed and _G.EL2B_WalkSpeed.IsEnabled() or false
end)

WST.FocusLost:Connect(function()
    local v = tonumber(WST.Text)
    if v and _G.EL2B_WalkSpeed then
        v = math.clamp(v, 50, 1000)
        WST.Text = tostring(v)
        _G.EL2B_WalkSpeed.SetValue(v)
    else
        WST.Text = "50"
    end
end)

EL2B_MakeToggle(SettingPage, "Anti AFK", "Click when AFK", 4, function()
    if _G.EL2B_AntiAFK then _G.EL2B_AntiAFK.Toggle() end
end, function() return _G.EL2B_AntiAFK and _G.EL2B_AntiAFK.IsEnabled() or false end)

EL2B_MakeToggle(SettingPage, "Anti Trap", "Remove trap debris", 5, function()
    if _G.EL2B_AntiTrap then _G.EL2B_AntiTrap.Toggle() end
end, function() return _G.EL2B_AntiTrap and _G.EL2B_AntiTrap.IsEnabled() or false end)

EL2B_MakeToggle(SettingPage, "Manual Fast Click", "Enable fast prompt click", 6, function()
    if _G.EL2B_ManualFastClick then _G.EL2B_ManualFastClick.Toggle() end
end, function() return _G.EL2B_ManualFastClick and _G.EL2B_ManualFastClick.IsEnabled() or false end)

EL2B_MakeButton(SettingPage, "God Mode", "Enable God Mode", 7, "Click", function()
    if _G.EL2B_GodMode then _G.EL2B_GodMode.Enable() end
end)
]=]

_MERGED["Tabs/HopServer.lua"] = [=[
local TM = _G.EL2B_TabsManager
local Http = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")
local PLACE = game.PlaceId
local HopTab, HopPage = TM:RegisterTab("Hop Server", 3, "HOP_SERVER")
CreateSectionTitle(HopPage, "Hop Server", 1)

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 20)
Status.BackgroundTransparency = 1
Status.Text = "Click to search servers"
Status.TextColor3 = Color3.fromRGB(150, 150, 170)
Status.TextSize = 10
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.LayoutOrder = 2
Status.Parent = HopPage

EL2B_MakeButton(HopPage, "Search Servers", "Low player servers", 3, "Search", function()
    Status.Text = "Searching..."
    local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", PLACE)
    local ok, resp = pcall(function() return Http:JSONDecode(game:HttpGet(url)) end)
    if not ok or not resp or not resp.data then
        Status.Text = "Failed to fetch"
        return
    end
    local servers = {}
    for _, s in ipairs(resp.data) do
        if s.id ~= game.JobId and s.playing < s.maxPlayers and s.playing >= 1 then
            table.insert(servers, s)
        end
    end
    if #servers == 0 then Status.Text = "No servers found" return end
    local target = servers[1]
    pcall(function() TPS:TeleportToPlaceInstance(PLACE, target.id, game.Players.LocalPlayer) end)
end)
]=]

_MERGED["Tabs/Farming.lua"] = [=[
local TM = _G.EL2B_TabsManager
local FarmingTab, FarmingPage = TM:RegisterTab("Farming", 4, "FARMING")
CreateSectionTitle(FarmingPage, "Farming", 1)

EL2B_MakeToggle(FarmingPage, "Auto AFK Farming Egg", "Auto farm egg during night", 2, function()
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

EL2B_MakeToggle(CP, "Auto Hit Player", "Auto hit nearest player", 3, function()
    if _G.EL2B_AutoAttack then _G.EL2B_AutoAttack.EnableAutoHit() end
end, function() return _G.EL2B_AutoAttack and _G.EL2B_AutoAttack.IsAutoHitEnabled() or false end)
]=]

_MERGED["Tabs/AutoFarming.lua"] = [=[
local TM = _G.EL2B_TabsManager
local AT, AP = TM:RegisterTab("Auto Farming", 6, "AUTO_FARMING")
CreateSectionTitle(AP, "Auto Farming", 1)

EL2B_MakeButton(AP, "Scan Eggs", "Scan all eggs nearby", 2, "Scan", function()
    if _G.EL2B_AutoFarm then
        local list = _G.EL2B_AutoFarm.ScanEggs()
        if list and #list > 0 then
            _G.EL2B_AutoFarm.SelectEgg(list[1])
        end
    end
end)

EL2B_MakeToggle(AP, "Auto Farm Enabled", nil, 3, function()
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

_MERGED["Tabs/Brainrot.lua"] = [=[
local TM = _G.EL2B_TabsManager
local BT, BP = TM:RegisterTab("Brainrot", 8, "BRAINROT")
CreateSectionTitle(BP, "Steal a Brainrot", 1)

while not _G.EL2B_StealABrainrot do task.wait(0.1) end
local M = _G.EL2B_StealABrainrot

EL2B_MakeToggle(BP, "Auto Steal Brainrot", "Vole automatiquement les brainrots", 2, M.ToggleAutoSteal, M.IsAutoStealEnabled)

EL2B_MakeToggle(BP, "Auto Collect Money", "Récupère automatiquement l'argent", 3, M.ToggleAutoCollect, M.IsAutoCollectEnabled)

EL2B_MakeToggle(BP, "ESP Brainrot", "Surligne tous les brainrots", 4, M.ToggleESP, M.IsESPEnabled)

EL2B_MakeButton(BP, "Teleport to My Base", "Retour à ta base", 5, "TP", M.TeleportToMyBase)
]=]

--============================================================
-- LOADER
--============================================================
_G.EL2B_EnablePrint = false
local oldPrint = print
print = function(...)
    if _G.EL2B_EnablePrint then oldPrint(...) end
end

_G.EL2B_Cache = _G.EL2B_Cache or {}

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
    LG.DisplayOrder = 9999
    LG.Parent = CoreGui

    local F = Instance.new("Frame")
    F.Size = UDim2.new(0, 280, 0, 110)
    F.Position = UDim2.new(0.5, -140, 0.5, -55)
    F.BackgroundColor3 = Color3.fromRGB(16, 17, 23)
    F.BackgroundTransparency = 0.1
    F.BorderSizePixel = 0
    F.Parent = LG

    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 14)
    FC.Parent = F

    local FS = Instance.new("UIStroke")
    FS.Color = Color3.fromRGB(105, 90, 190)
    FS.Thickness = 2
    FS.Transparency = 0.2
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
    St.Text = "Multi Game"
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

    local BGC = Instance.new("UICorner")
    BGC.CornerRadius = UDim.new(1, 0)
    BGC.Parent = BG

    local B = Instance.new("Frame")
    B.Size = UDim2.new(0, 0, 1, 0)
    B.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
    B.BorderSizePixel = 0
    B.Parent = BG

    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(1, 0)
    BC.Parent = B

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
    if not fn then
        warn("[EL2B] Load fail " .. path .. ": " .. tostring(err))
        return
    end
    local ok, rerr = pcall(fn)
    if not ok then warn("[EL2B] Error in " .. path .. ": " .. tostring(rerr)) end
end

-- Chargement progressif
Loading.Update(5)
LoadModule("Config.lua")
Loading.Update(10)
LoadModule("UI.lua")
Loading.Update(15)
LoadModule("Components.lua")
Loading.Update(20)
LoadModule("Tabs/Init.lua")
Loading.Update(25)

-- Détecteur de jeu
LoadModule("Features/GameDetector.lua")
Loading.Update(30)

-- Modules communs
LoadModule("Features/AntiAFK.lua")
LoadModule("Features/WalkSpeed.lua")
LoadModule("Features/AntiTrap.lua")
LoadModule("Features/GodMode.lua")
LoadModule("Features/ManualFastClick.lua")
LoadModule("Features/AutoAttack.lua")
LoadModule("Features/ConfigSystem.lua")
LoadModule("Features/BypassAntiCheat.lua")
Loading.Update(50)

-- Modules spécifiques au jeu
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
    LoadModule("Features/StealABrainrot.lua")
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
