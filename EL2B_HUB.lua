-- EL2B HUB · Clean GUI Base
-- Base volontairement minimale avant réception de la prochaine script.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
if not player then
    warn("[EL2B HUB] Joueur local indisponible")
    return
end

local playerGui = player:WaitForChild("PlayerGui", 10)
if not playerGui then
    warn("[EL2B HUB] PlayerGui indisponible")
    return
end

local oldGui = playerGui:FindFirstChild("EL2BCleanBase")
if oldGui then
    oldGui:Destroy()
end

local function create(className, properties, parent)
    local object = Instance.new(className)
    for key, value in pairs(properties) do
        object[key] = value
    end
    object.Parent = parent
    return object
end

local function round(object, radius)
    create("UICorner", { CornerRadius = UDim.new(0, radius) }, object)
end

local gui = create("ScreenGui", {
    Name = "EL2BCleanBase",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 100,
}, playerGui)

local panel = create("Frame", {
    Name = "Panel",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(390, 220),
    BackgroundColor3 = Color3.fromRGB(18, 17, 25),
    BorderSizePixel = 0,
}, gui)
round(panel, 14)

local stroke = create("UIStroke", {
    Color = Color3.fromRGB(184, 76, 255),
    Thickness = 1.5,
    Transparency = 0.15,
}, panel)

local title = create("TextLabel", {
    Name = "Title",
    Position = UDim2.fromOffset(20, 18),
    Size = UDim2.new(1, -40, 0, 30),
    BackgroundTransparency = 1,
    Text = "EL2B HUB",
    TextColor3 = Color3.fromRGB(245, 238, 255),
    TextSize = 22,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
}, panel)

local status = create("TextLabel", {
    Name = "Status",
    Position = UDim2.fromOffset(20, 53),
    Size = UDim2.new(1, -40, 0, 22),
    BackgroundTransparency = 1,
    Text = "SAFE BASE · READY",
    TextColor3 = Color3.fromRGB(101, 255, 171),
    TextSize = 12,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
}, panel)

local message = create("TextLabel", {
    Name = "Message",
    Position = UDim2.fromOffset(20, 88),
    Size = UDim2.new(1, -40, 0, 48),
    BackgroundTransparency = 1,
    Text = "Base propre chargée.\nLes prochaines fonctions seront ajoutées séparément.",
    TextColor3 = Color3.fromRGB(191, 184, 204),
    TextSize = 13,
    Font = Enum.Font.Gotham,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
}, panel)

local close = create("TextButton", {
    Name = "Close",
    Position = UDim2.fromOffset(20, 155),
    Size = UDim2.new(1, -40, 0, 40),
    BackgroundColor3 = Color3.fromRGB(38, 29, 55),
    BorderSizePixel = 0,
    Text = "FERMER / CLOSE",
    TextColor3 = Color3.fromRGB(255, 244, 255),
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = true,
}, panel)
round(close, 9)

local mini = create("TextButton", {
    Name = "MiniButton",
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -18, 1, -18),
    Size = UDim2.fromOffset(72, 42),
    BackgroundColor3 = Color3.fromRGB(118, 43, 178),
    BorderSizePixel = 0,
    Text = "EL2B",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    Visible = false,
}, gui)
round(mini, 12)

local function showPanel()
    mini.Visible = false
    panel.Visible = true
    panel.Size = UDim2.fromOffset(370, 205)
    TweenService:Create(panel, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(390, 220),
    }):Play()
end

close.Activated:Connect(function()
    panel.Visible = false
    mini.Visible = true
end)

mini.Activated:Connect(showPanel)

local camera = workspace.CurrentCamera
local function fit()
    local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
    if viewport.Y > viewport.X then
        panel.Size = UDim2.fromOffset(math.max(280, viewport.X - 24), 205)
        close.Size = UDim2.new(1, -40, 0, 42)
    else
        panel.Size = UDim2.fromOffset(390, 220)
    end
end

fit()
if camera then
    camera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
end

print("[EL2B HUB] Clean GUI Base chargée")
