-- DEMON DUELS
-- Discord: https://discord.gg/XPkQEMpU3w
-- Full red theme · New intro · No images · No songs · No logger

-- ========== DEMON DUELS INTRO (custom) ==========
task.spawn(function()
-- ========================================================
-- INTRO EDITOR • ULTRA v4 (working source)
-- Name: Duels | Theme: Red | BG: Gradient
-- ========================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

local INTRO_NAME = "Demon Duels"
local FIRST_LINE = "DEMON"
local LOADING_TEXT = "ON TOP"
local ACCENT = Color3.fromRGB(220, 40, 40)
local ACCENT2 = Color3.fromRGB(160, 20, 20)
local BG1 = Color3.fromRGB(30, 5, 10)
local BG2 = Color3.fromRGB(60, 10, 20)
local SPEED = 1.00
local FADE = 0.60
local TEXT_STYLE = "SlideUp"
local LOGO_ANIM = "FlyIn"
local BG_STYLE = "Gradient"
local ENABLE_PARTICLES = true
local ENABLE_GLOW = true
local ENABLE_IMAGE = false
local IMAGE_ASSET = ""
local ENABLE_SHAKE = true
local BG_TRANSPARENCY = 0.00
local CINEMATIC_BARS = true
local GLITCH_EFFECT = false
local CAMERA_SHAKE = true
local RAINBOW_SHIFT = true
local TEXT_WAVE = false
local NEON_PULSE = true
local LIGHTNING_FLASH = true
local BLUR_BG = false
local SOUND_ENABLED = false
local SOUND_ID = ""
local MATRIX_RAIN = false
local PROGRESS_BAR = true
local PROGRESS_DURATION = 3.50

local old = playerGui:FindFirstChild("DemonDuelsIntro")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "DemonDuelsIntro"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 200
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local blurEffect = nil
if BLUR_BG then
    blurEffect = Instance.new("BlurEffect")
    blurEffect.Size = 16
    blurEffect.Parent = Lighting
end

local function clearBlur()
    if blurEffect then blurEffect:Destroy() blurEffect = nil end
end

local function softShake(obj, intensity, duration)
    if not obj or not obj.Parent then return end
    local origin = obj.Position
    local t0 = tick()
    local conn
    conn = RunService.RenderStepped:Connect(function()
        local t = tick() - t0
        if t >= duration or not obj.Parent then
            conn:Disconnect()
            if obj.Parent then obj.Position = origin end
            return
        end
        local decay = 1 - (t / duration)
        obj.Position = UDim2.new(
            origin.X.Scale, origin.X.Offset + (math.random()-0.5)*2*intensity*decay,
            origin.Y.Scale, origin.Y.Offset + (math.random()-0.5)*2*intensity*decay
        )
    end)
end

local camConn = nil
local function startCamShake(intensity, duration)
    if camConn then camConn:Disconnect() camConn = nil end
    local t0 = tick()
    camConn = RunService.RenderStepped:Connect(function()
        local t = tick() - t0
        if t >= duration then
            camConn:Disconnect()
            camConn = nil
            return
        end
        local decay = 1 - (t / duration)
        camera.CFrame = camera.CFrame * CFrame.new(
            (math.random()-0.5)*intensity*decay/20,
            (math.random()-0.5)*intensity*decay/20,
            0
        )
    end)
end

if SOUND_ENABLED and SOUND_ID ~= "" then
    local snd = Instance.new("Sound")
    snd.SoundId = SOUND_ID
    snd.Volume = 0.6
    snd.Parent = SoundService
    pcall(function() snd:Play() end)
    task.delay(8, function() if snd then snd:Destroy() end end)
end

-- Background
local bg = Instance.new("Frame")
bg.Size = UDim2.fromScale(1, 1)
bg.BackgroundColor3 = BG1
bg.BorderSizePixel = 0
bg.BackgroundTransparency = 1
bg.Parent = gui

local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, BG1),
    ColorSequenceKeypoint.new(1, BG2)
})
bgGrad.Rotation = 45
bgGrad.Parent = bg

if BG_STYLE == "Starfield" or BG_STYLE == "Pulse" then
    for i = 1, 30 do
        local star = Instance.new("Frame")
        local sz = math.random(2, 4)
        star.Size = UDim2.fromOffset(sz, sz)
        star.Position = UDim2.new(math.random(), 0, math.random(), 0)
        star.BackgroundColor3 = Color3.new(1, 1, 1)
        star.BackgroundTransparency = 0.3
        star.BorderSizePixel = 0
        star.Parent = bg
        Instance.new("UICorner", star).CornerRadius = UDim.new(1, 0)
        TweenService:Create(star, TweenInfo.new((1.5+math.random())/SPEED, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            BackgroundTransparency = 0.9
        }):Play()
    end
elseif BG_STYLE == "Grid" then
    for x = 0, 20 do
        local line = Instance.new("Frame")
        line.Size = UDim2.new(0, 1, 1, 0)
        line.Position = UDim2.new(x/20, 0, 0, 0)
        line.BackgroundColor3 = ACCENT
        line.BackgroundTransparency = 0.92
        line.BorderSizePixel = 0
        line.Parent = bg
    end
elseif BG_STYLE == "Waves" or BG_STYLE == "Aurora" then
    for i = 1, 5 do
        local wave = Instance.new("Frame")
        wave.Size = UDim2.new(1.2, 0, 0.2, 0)
        wave.Position = UDim2.new(-0.1, 0, 0.1 + i*0.15, 0)
        wave.BackgroundColor3 = ACCENT
        wave.BackgroundTransparency = 0.85
        wave.Rotation = -8 + i
        wave.BorderSizePixel = 0
        wave.Parent = bg
        TweenService:Create(wave, TweenInfo.new((3+i)/SPEED, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            Position = UDim2.new(-0.05, 0, 0.12 + i*0.15, 0)
        }):Play()
    end
elseif BG_STYLE == "Diagonal" then
    for i = 1, 8 do
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1.5, 0, 0, 18)
        bar.Position = UDim2.new(-0.2, 0, i*0.12, 0)
        bar.BackgroundColor3 = ACCENT
        bar.BackgroundTransparency = 0.9
        bar.Rotation = -20
        bar.BorderSizePixel = 0
        bar.Parent = bg
    end
end

TweenService:Create(bg, TweenInfo.new(FADE*0.6/SPEED), {BackgroundTransparency = BG_TRANSPARENCY}):Play()

if LIGHTNING_FLASH then
    local flash = Instance.new("Frame")
    flash.Size = UDim2.fromScale(1, 1)
    flash.BackgroundColor3 = Color3.new(1, 1, 1)
    flash.BackgroundTransparency = 1
    flash.BorderSizePixel = 0
    flash.ZIndex = 50
    flash.Parent = gui
    TweenService:Create(flash, TweenInfo.new(0.05), {BackgroundTransparency = 0.25}):Play()
    task.delay(0.1, function()
        TweenService:Create(flash, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    end)
end

local topBar, botBar
if CINEMATIC_BARS then
    topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 0)
    topBar.BackgroundColor3 = Color3.new(0, 0, 0)
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 40
    topBar.Parent = gui
    TweenService:Create(topBar, TweenInfo.new(0.5), {Size = UDim2.new(1, 0, 0.1, 0)}):Play()
    botBar = Instance.new("Frame")
    botBar.Size = UDim2.new(1, 0, 0, 0)
    botBar.Position = UDim2.new(0, 0, 1, 0)
    botBar.BackgroundColor3 = Color3.new(0, 0, 0)
    botBar.BorderSizePixel = 0
    botBar.ZIndex = 40
    botBar.Parent = gui
    TweenService:Create(botBar, TweenInfo.new(0.5), {
        Size = UDim2.new(1, 0, 0.1, 0), Position = UDim2.new(0, 0, 0.9, 0)
    }):Play()
end

-- FIRST LINE (customizable title)
local first = Instance.new("TextLabel")
first.Size = UDim2.new(1, -40, 0, 60)
first.Position = UDim2.new(0, 20, 0.28, -30)
first.BackgroundTransparency = 1
first.Text = FIRST_LINE
first.Font = Enum.Font.GothamBlack
first.TextSize = 42
first.TextColor3 = ACCENT
first.TextTransparency = 1
first.TextStrokeTransparency = 0.4
first.TextStrokeColor3 = Color3.new(0, 0, 0)
first.ZIndex = 20
first.Parent = gui

local logoDur = 1.0 / SPEED
local rest = UDim2.new(0, 20, 0.28, -30)
if LOGO_ANIM == "ZoomIn" then
    first.TextSize = 4
    TweenService:Create(first, TweenInfo.new(logoDur, Enum.EasingStyle.Back), {
        TextSize = 42, TextTransparency = 0
    }):Play()
elseif LOGO_ANIM == "DropIn" then
    first.Position = UDim2.new(0, 20, -0.2, 0)
    TweenService:Create(first, TweenInfo.new(logoDur, Enum.EasingStyle.Bounce), {
        TextTransparency = 0, Position = rest
    }):Play()
elseif LOGO_ANIM == "SpinIn" then
    first.TextSize = 4; first.Rotation = -180
    TweenService:Create(first, TweenInfo.new(logoDur, Enum.EasingStyle.Back), {
        TextSize = 42, TextTransparency = 0, Rotation = 0
    }):Play()
elseif LOGO_ANIM == "SlideLeft" then
    first.Position = UDim2.new(0, -400, 0.28, -30)
    TweenService:Create(first, TweenInfo.new(logoDur, Enum.EasingStyle.Quart), {
        TextTransparency = 0, Position = rest
    }):Play()
elseif LOGO_ANIM == "SlideRight" then
    first.Position = UDim2.new(1, 100, 0.28, -30)
    TweenService:Create(first, TweenInfo.new(logoDur, Enum.EasingStyle.Quart), {
        TextTransparency = 0, Position = rest
    }):Play()
elseif LOGO_ANIM == "FadeUp" then
    first.Position = UDim2.new(0, 20, 0.55, 0)
    TweenService:Create(first, TweenInfo.new(logoDur, Enum.EasingStyle.Quint), {
        TextTransparency = 0, Position = rest
    }):Play()
elseif LOGO_ANIM == "Pulse" then
    first.TextTransparency = 0; first.TextSize = 10
    TweenService:Create(first, TweenInfo.new(0.35/SPEED, Enum.EasingStyle.Back), {TextSize = 50}):Play()
    task.delay(0.35/SPEED, function()
        if first.Parent then
            TweenService:Create(first, TweenInfo.new(0.2/SPEED), {TextSize = 42}):Play()
        end
    end)
elseif LOGO_ANIM == "Elastic" then
    first.TextSize = 2; first.Rotation = 15
    TweenService:Create(first, TweenInfo.new(logoDur, Enum.EasingStyle.Elastic), {
        TextSize = 42, TextTransparency = 0, Rotation = 0
    }):Play()
elseif LOGO_ANIM == "GlitchIn" then
    first.TextTransparency = 0.4
    task.spawn(function()
        for _ = 1, 10 do
            if not first.Parent then break end
            first.TextColor3 = Color3.fromRGB(255, 0, 100); task.wait(0.03)
            first.TextColor3 = Color3.fromRGB(0, 255, 255); task.wait(0.03)
            first.TextColor3 = ACCENT; task.wait(0.03)
        end
        TweenService:Create(first, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
    end)
else -- FlyIn default
    first.TextSize = 4
    first.Position = UDim2.new(0.5, 0, 0.5, -30)
    TweenService:Create(first, TweenInfo.new(logoDur, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        TextSize = 42, TextTransparency = 0, Position = rest
    }):Play()
end

-- Optional image
local logoImg = nil
if ENABLE_IMAGE and IMAGE_ASSET ~= "" then
    logoImg = Instance.new("ImageLabel")
    logoImg.Size = UDim2.fromOffset(72, 72)
    logoImg.Position = UDim2.new(0.5, -36, 0.12, 0)
    logoImg.BackgroundTransparency = 1
    logoImg.Image = IMAGE_ASSET
    logoImg.ImageTransparency = 1
    logoImg.ScaleType = Enum.ScaleType.Fit
    logoImg.ZIndex = 15
    logoImg.Parent = gui
    Instance.new("UICorner", logoImg).CornerRadius = UDim.new(0, 12)
    TweenService:Create(logoImg, TweenInfo.new(0.6/SPEED, Enum.EasingStyle.Back), {
        ImageTransparency = 0
    }):Play()
end

-- Game name (second line)
local titleY = ENABLE_IMAGE and 0.48 or 0.42
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 48)
title.Position = UDim2.new(0, 20, titleY, -24)
title.BackgroundTransparency = 1
title.Text = INTRO_NAME
title.Font = Enum.Font.GothamBlack
title.TextSize = 36
title.TextColor3 = ACCENT
title.TextTransparency = 1
title.TextStrokeTransparency = 0.45
title.TextStrokeColor3 = Color3.new(0, 0, 0)
title.ZIndex = 25
title.Parent = gui

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -40, 0, 22)
subtitle.Position = UDim2.new(0, 20, titleY, 28)
subtitle.BackgroundTransparency = 1
subtitle.Text = LOADING_TEXT
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 16
subtitle.TextColor3 = Color3.fromRGB(170, 170, 190)
subtitle.TextTransparency = 1
subtitle.ZIndex = 25
subtitle.Parent = gui

-- Particles
local particles = {}
if ENABLE_PARTICLES then
    for i = 1, 16 do
        local p = Instance.new("Frame")
        local sz = math.random(2, 5)
        p.Size = UDim2.fromOffset(sz, sz)
        p.Position = UDim2.new(math.random(), 0, math.random(), 0)
        p.BackgroundColor3 = ACCENT
        p.BackgroundTransparency = 0.2
        p.BorderSizePixel = 0
        p.Parent = gui
        Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
        table.insert(particles, p)
        TweenService:Create(p, TweenInfo.new((1.4+math.random())/SPEED, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            Position = UDim2.new(math.random(), 0, math.random(), 0),
            BackgroundTransparency = 0.95
        }):Play()
    end
end

-- Progress bar
local progTrack, progFill
if PROGRESS_BAR then
    progTrack = Instance.new("Frame")
    progTrack.Size = UDim2.new(0.45, 0, 0, 6)
    progTrack.Position = UDim2.new(0.275, 0, 0.88, 0)
    progTrack.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    progTrack.BorderSizePixel = 0
    progTrack.ZIndex = 30
    progTrack.Parent = gui
    Instance.new("UICorner", progTrack).CornerRadius = UDim.new(0, 3)
    progFill = Instance.new("Frame")
    progFill.Size = UDim2.new(0, 0, 1, 0)
    progFill.BackgroundColor3 = ACCENT
    progFill.BorderSizePixel = 0
    progFill.Parent = progTrack
    Instance.new("UICorner", progFill).CornerRadius = UDim.new(0, 3)
end

local titleDelay = 1.4
task.delay(titleDelay/SPEED, function()
    if not gui.Parent then return end
    TweenService:Create(first, TweenInfo.new(0.35/SPEED), {TextTransparency = 0.25, TextSize = 34}):Play()

    if TEXT_STYLE == "SlideUp" then
        title.Position = UDim2.new(0, 20, 0.7, 0)
        TweenService:Create(title, TweenInfo.new(0.65/SPEED, Enum.EasingStyle.Quart), {
            TextTransparency = 0, Position = UDim2.new(0, 20, titleY, -24)
        }):Play()
    elseif TEXT_STYLE == "ZoomIn" then
        title.TextSize = 6
        TweenService:Create(title, TweenInfo.new(0.65/SPEED, Enum.EasingStyle.Back), {
            TextTransparency = 0, TextSize = 36
        }):Play()
    elseif TEXT_STYLE == "BounceIn" then
        title.TextTransparency = 0
        title.Position = UDim2.new(0, 20, titleY - 0.15, -24)
        TweenService:Create(title, TweenInfo.new(0.7/SPEED, Enum.EasingStyle.Bounce), {
            Position = UDim2.new(0, 20, titleY, -24)
        }):Play()
    elseif TEXT_STYLE == "BlurIn" then
        title.TextTransparency = 0.8; title.TextSize = 48
        TweenService:Create(title, TweenInfo.new(0.7/SPEED, Enum.EasingStyle.Quint), {
            TextTransparency = 0, TextSize = 36
        }):Play()
    elseif TEXT_STYLE == "Typewriter" then
        title.Text = ""; title.TextTransparency = 0
        task.spawn(function()
            for i = 1, #INTRO_NAME do
                if not title.Parent then break end
                title.Text = string.sub(INTRO_NAME, 1, i)
                task.wait(0.035/SPEED)
            end
        end)
    else -- FadeScale
        title.TextSize = 8
        TweenService:Create(title, TweenInfo.new(0.7/SPEED, Enum.EasingStyle.Back), {
            TextTransparency = 0, TextSize = 36
        }):Play()
    end

    if ENABLE_SHAKE then
        task.delay(0.1/SPEED, function() softShake(title, 4, 0.35) end)
    end
    if CAMERA_SHAKE then startCamShake(2.2, 0.7/SPEED) end

    if RAINBOW_SHIFT then
        task.spawn(function()
            local step = 0
            while title.Parent do
                step = step + 0.02
                title.TextColor3 = Color3.fromHSV(step % 1, 0.8, 1)
                task.wait(0.05)
            end
        end)
    end
    if TEXT_WAVE then
        task.spawn(function()
            local step = 0
            while title.Parent do
                step = step + 0.1
                title.TextSize = 36 * (1 + math.sin(step)*0.05)
                task.wait(0.05)
            end
        end)
    end
    if GLITCH_EFFECT then
        task.spawn(function()
            local oc = title.TextColor3
            local op = title.Position
            local n = 0
            while title.Parent do
                n = n + 1
                if n % 8 == 0 then
                    title.TextColor3 = Color3.fromRGB(255, 0, 0); task.wait(0.03)
                    title.TextColor3 = Color3.fromRGB(0, 255, 255); task.wait(0.03)
                    title.TextColor3 = oc
                    title.Position = UDim2.new(op.X.Scale, op.X.Offset+(math.random()-0.5)*8, op.Y.Scale, op.Y.Offset+(math.random()-0.5)*4)
                    task.wait(0.04)
                    title.Position = op
                end
                task.wait(0.05)
            end
        end)
    end
end)

task.delay((titleDelay+0.45)/SPEED, function()
    if gui.Parent then
        TweenService:Create(subtitle, TweenInfo.new(0.4/SPEED), {TextTransparency = 0}):Play()
    end
    if PROGRESS_BAR and progFill then
        TweenService:Create(progFill, TweenInfo.new(PROGRESS_DURATION/SPEED, Enum.EasingStyle.Quad), {
            Size = UDim2.new(1, 0, 1, 0)
        }):Play()
    end
end)

local endAt = titleDelay + (PROGRESS_BAR and PROGRESS_DURATION or 2.8) + 0.6
task.delay(endAt/SPEED, function()
    if not gui.Parent then return end
    local fadeT = FADE / SPEED
    TweenService:Create(bg, TweenInfo.new(fadeT), {BackgroundTransparency = 1}):Play()
    TweenService:Create(first, TweenInfo.new(fadeT), {TextTransparency = 1}):Play()
    TweenService:Create(title, TweenInfo.new(fadeT), {TextTransparency = 1}):Play()
    TweenService:Create(subtitle, TweenInfo.new(fadeT), {TextTransparency = 1}):Play()
    if logoImg then TweenService:Create(logoImg, TweenInfo.new(fadeT), {ImageTransparency = 1}):Play() end
    if progTrack then TweenService:Create(progTrack, TweenInfo.new(fadeT), {BackgroundTransparency = 1}):Play() end
    if progFill then TweenService:Create(progFill, TweenInfo.new(fadeT), {BackgroundTransparency = 1}):Play() end
    for _, p in ipairs(particles) do
        TweenService:Create(p, TweenInfo.new(fadeT), {BackgroundTransparency = 1}):Play()
    end
    if topBar then TweenService:Create(topBar, TweenInfo.new(0.4), {Size = UDim2.new(1,0,0,0)}):Play() end
    if botBar then TweenService:Create(botBar, TweenInfo.new(0.4), {Size = UDim2.new(1,0,0,0), Position = UDim2.new(0,0,1,0)}):Play() end
    task.wait(fadeT + 0.1)
    clearBlur()
    if camConn then camConn:Disconnect() camConn = nil end
    if gui then gui:Destroy() end
end)

end)

-- ========== HUB ==========


if _G.DemonDuelsRunning then
    warn("[Demon Duels] Instancia previa detectada. Se recomienda rejoin si hay comportamiento errático.")
end
_G.DemonDuelsRunning = false
_G.__DemonDuelsMainOriginalPos = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer
if not LP then
    local _lpConn
    _lpConn = Players.PlayerAdded:Connect(function(p) LP = p end)
    local _t0 = tick()
    while not LP and tick() - _t0 < 15 do task.wait(0.1) end
    if _lpConn then _lpConn:Disconnect() end
end
if not LP then
    warn("[Demon Duels] LocalPlayer no disponible en 15s. Abortando.")
    return
end

local pgui = LP:WaitForChild("PlayerGui", 20)
if not pgui then
    warn("[Demon Duels] PlayerGui no cargó en 20s. Abortando.")
    return
end

local camera = Workspace.CurrentCamera

_G.DemonDuelsRunning = true
_G.DemonDuelsSession = (_G.DemonDuelsSession or 0) + 1
local _mySession = _G.DemonDuelsSession

local DEMONDUELS_LANGUAGE = "en"

local DEMONDUELS_TRANSLATIONS = {
    es = { ["RESET ALL SETTINGS"]="RESTABLECER TODO", ["SETTINGS RESET"]="AJUSTES RESTABLECIDOS", ["CONFIRM?"]="¿CONFIRMAR?", ["ERROR"]="ERROR", ["RESET"]="RESTABLECER", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARGAR", ["Lagger Mode"]="MODO LAG", ["Auto Left"]="AUTO IZQUIERDA", ["Auto Right"]="AUTO DERECHA", ["Auto Bat"]="AUTO BATE", ["TP Down"]="TP ABAJO", ["Drop Brainrot"]="SOLTAR BRAINROT", ["Hide GUI"]="OCULTAR MENÚ", ["Normal Speed"]="VELOCIDAD NORMAL", ["Carry Speed"]="VELOCIDAD CARGAR", ["Current Mode"]="MODO ACTUAL", ["ACTIVATE"]="ACTIVAR" },
    pt = { ["RESET ALL SETTINGS"]="REDEFINIR TUDO", ["SETTINGS RESET"]="CONFIGURAÇÕES REDEFINIDAS", ["CONFIRM?"]="CONFIRMAR?", ["ERROR"]="ERRO", ["RESET"]="REDEFINIR", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARREGAR", ["Auto Left"]="AUTO ESQUERDA", ["Auto Right"]="AUTO DIREITA", ["Hide GUI"]="OCULTAR MENU", ["Normal Speed"]="VELOCIDADE NORMAL", ["Carry Speed"]="VELOCIDADE CARREGAR", ["ACTIVATE"]="ATIVAR" },
    fr = { ["RESET ALL SETTINGS"]="RÉINITIALISER", ["SETTINGS RESET"]="PARAMÈTRES RÉINITIALISÉS", ["CONFIRM?"]="CONFIRMER ?", ["ERROR"]="ERREUR", ["RESET"]="RÉINITIALISER", ["Keybinds"]="RACCOURCIS", ["Carry Mode"]="MODE PORTER", ["Auto Left"]="AUTO GAUCHE", ["Auto Right"]="AUTO DROITE", ["Hide GUI"]="MASQUER LE MENU", ["Normal Speed"]="VITESSE NORMALE", ["Carry Speed"]="VITESSE PORTER", ["ACTIVATE"]="ACTIVER" },
    de = { ["RESET ALL SETTINGS"]="ALLES ZURÜCKSETZEN", ["SETTINGS RESET"]="EINSTELLUNGEN ZURÜCKGESETZT", ["CONFIRM?"]="BESTÄTIGEN?", ["ERROR"]="FEHLER", ["RESET"]="ZURÜCKSETZEN", ["Keybinds"]="TASTEN", ["Carry Mode"]="TRAGEMODUS", ["Auto Left"]="AUTO LINKS", ["Auto Right"]="AUTO RECHTS", ["Hide GUI"]="MENÜ AUSBLENDEN", ["Normal Speed"]="NORMALE GESCHWINDIGKEIT", ["Carry Speed"]="TRAGEGESCHWINDIGKEIT", ["ACTIVATE"]="AKTIVIEREN" },
}

local function localizeDemonDuelsInterface(root)
    local dictionary = DEMONDUELS_TRANSLATIONS[DEMONDUELS_LANGUAGE]
    if not dictionary or not root then return end
    for _, object in ipairs(root:GetDescendants()) do
        if object:IsA("TextLabel") or object:IsA("TextButton") then
            local source = object:GetAttribute("DemonDuelsSourceText") or object.Text
            object:SetAttribute("DemonDuelsSourceText", source)
            local translated = dictionary[source]
            if translated then object.Text = translated end
        end
    end
end

local function demonDuelsTranslate(source)
    local dictionary = DEMONDUELS_TRANSLATIONS[DEMONDUELS_LANGUAGE]
    return (dictionary and dictionary[source]) or source
end

local _tick          = tick
local _clamp         = math.clamp
local _floor         = math.floor
local _abs           = math.abs
local _huge          = math.huge
local _sqrt          = math.sqrt
local _V3new         = Vector3.new
local _V3zero        = Vector3.zero
local _CFnew         = CFrame.new
local _CFlookAt      = CFrame.lookAt
local _RayParams_new = RaycastParams.new

local _GetPlayersCached
do
    local cache, cacheTime = nil, 0
    _GetPlayersCached = function()
        local now = _tick()
        if cache and now - cacheTime < 0.03 then return cache end
        cache = Players:GetPlayers()
        cacheTime = now
        return cache
    end
end

local function waitForCharReady(char, timeout)
    timeout = timeout or 5
    local deadline = _tick() + timeout
    while (not char) or (not char.Parent)
          or (not char:FindFirstChild("HumanoidRootPart"))
          or (not char:FindFirstChildOfClass("Humanoid")) do
        if _tick() > deadline then return false end
        task.wait(0.05)
    end
    return true
end

NS = 60
CS = 29
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 58
BYPASS_AIMBOT_SPEED = 60
local State = {
    bypassBatEnabled = false,
    bypassBatSpeed = BYPASS_AIMBOT_SPEED,
}
CONFIG_FILE = "DemonDuels_" .. tostring(LP.UserId) .. ".json"

-- external loader removed

BAT_V2_HIT_DIST = 4.5
_isDraggingButton = false

backgroundIndex = 1
backgroundImages = {
    -- images removed
}

backgroundImageTransparency = 0
backgroundMode = "Background 1"
backgroundSelectorLabel = nil
miniBackgroundImage = nil
floatingButtonScale = 1
_floatingUIScales = {}

TPBatState = TPBatState or {
    enabled = false,
    connection = nil,
    hitCooldown = false,
    antiDieConnections = {},
}
TPBatState.enabled = false

_bgAssetCache = _bgAssetCache or {}
_bgAssetPending = _bgAssetPending or {}
_bgAssetOk = _bgAssetOk or {}

-- Comprueba de verdad si una imagen carga (descarga + decodificacion)
function _bgLoads(url)
    local good = false
    local img = Instance.new("ImageLabel")
    img.Image = url
    pcall(function()
        game:GetService("ContentProvider"):PreloadAsync({img}, function(_, status)
            if status == Enum.AssetFetchStatus.Success then good = true end
        end)
    end)
    local t = 0
    while not img.IsLoaded and t < 8 do task.wait(0.1); t = t + 0.1 end
    local loaded = img.IsLoaded
    pcall(function() img:Destroy() end)
    return good and loaded
end

-- Descarga la miniatura real del asset (sirve para Decals e imagenes) y la carga desde un archivo local
function _bgHttpGet(url)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and type(res) == "string" and #res > 0 then return res end
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if req then
        local ok2, r = pcall(req, {Url = url, Method = "GET"})
        if ok2 and r and (r.Success or r.StatusCode == 200) and type(r.Body) == "string" and #r.Body > 0 then
            return r.Body
        end
    end
    return nil
end

function _bgDownloadThumb(id)
    local getAsset = getcustomasset or getsynasset
    if not (writefile and getAsset) then return nil end
    local HttpService = game:GetService("HttpService")
    local imageUrl
    for attempt = 1, 4 do
        local body = _bgHttpGet("https://thumbnails.roblox.com/v1/assets?assetIds=" .. id .. "&returnPolicy=PlaceHolder&size=420x420&format=Png&isCircular=false")
        if body then
            local okJ, data = pcall(function() return HttpService:JSONDecode(body) end)
            local item = okJ and data and data.data and data.data[1]
            if item and item.imageUrl and item.imageUrl ~= "" and item.state == "Completed" then
                imageUrl = item.imageUrl
                break
            end
        end
        task.wait(1)
    end
    if not imageUrl then return nil end
    local bytes = _bgHttpGet(imageUrl)
    if not bytes or #bytes < 100 then return nil end
    local path = "DemonDuels_bg_" .. id .. ".png"
    local okW = pcall(writefile, path, bytes)
    if not okW then return nil end
    local okA, asset = pcall(getAsset, path)
    if okA and asset and asset ~= "" then return asset end
    return nil
end

function _bgAsset(id)
    if id == nil then return "" end
    id = tostring(id)
    local raw = "rbxassetid://" .. id
    local cached = _bgAssetCache[id]
    if cached then return cached end
    if not _bgAssetPending[id] then
        _bgAssetPending[id] = true
        task.spawn(function()
            local candidates = {}

            -- 1) GetObjects: si el ID es un Decal/Texture saca la imagen real
            local ok, objs = pcall(function() return game:GetObjects(raw) end)
            if ok and type(objs) == "table" and objs[1] then
                local item = objs[1]
                local found
                local function pick(o)
                    if o:IsA("Decal") or o:IsA("Texture") then return o.Texture end
                    if o:IsA("ImageLabel") or o:IsA("ImageButton") then return o.Image end
                    return nil
                end
                found = pick(item)
                if not found or found == "" then
                    for _, d in ipairs(item:GetDescendants()) do
                        local t = pick(d)
                        if t and t ~= "" then found = t; break end
                    end
                end
                if found and found ~= "" then table.insert(candidates, found) end
                for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
            end

            -- 2) Respaldo: consulta a assetdelivery (Decal -> id de la imagen real)
            if #candidates == 0 then
                pcall(function()
                    local body = game:HttpGet("https://assetdelivery.roblox.com/v2/assetId/" .. id)
                    local data = game:GetService("HttpService"):JSONDecode(body)
                    local loc = data and data.locations and data.locations[1] and data.locations[1].location
                    if data and data.assetTypeId == 13 and loc then
                        local xml = game:HttpGet(loc)
                        local texId = xml:match("rbxassetid://(%d+)") or xml:match("asset/%?id=(%d+)") or xml:match("id=(%d+)")
                        if texId then table.insert(candidates, "rbxassetid://" .. texId) end
                    end
                end)
            end

            -- 3) El ID tal cual + formas alternativas de cargar el mismo ID
            table.insert(candidates, raw)
            table.insert(candidates, "rbxthumb://type=Asset&id=" .. id .. "&w=420&h=420")
            table.insert(candidates, "http://www.roblox.com/asset/?id=" .. id)

            -- Se queda con el primero que de verdad carga
            local resolved, loadedOk = raw, false
            for attempt = 1, 2 do
                for _, c in ipairs(candidates) do
                    if _bgLoads(c) then resolved = c; loadedOk = true; break end
                end
                if loadedOk then break end
                task.wait(1)
            end
            -- Ultimo recurso: bajar la miniatura real y cargarla como archivo local
            if not loadedOk then
                local okD, custom = pcall(_bgDownloadThumb, id)
                if okD and custom then resolved = custom; loadedOk = true end
            end
            if not loadedOk then
                warn("[DemonDuels] La imagen de fondo " .. id .. " no carga (privada, sin aprobar o no es una imagen).")
            end

            _bgAssetCache[id] = resolved
            _bgAssetOk[id] = loadedOk
            _bgAssetPending[id] = nil
            if applyBackgroundMode then pcall(applyBackgroundMode, backgroundMode) end
        end)
    end
    return raw
end

function applyBackgroundMode(mode)
    if mode == "None" or #backgroundImages == 0 then
        backgroundMode = "None"
    else
        local n = tonumber(string.match(tostring(mode), "^Background%s+(%d+)$"))
        if not n or n < 1 or n > #backgroundImages then
            n = backgroundIndex
        end
        backgroundIndex = _clamp(n, 1, #backgroundImages)
        backgroundMode = "Background " .. backgroundIndex
    end

    if main then
        main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        local _curBgId = tostring(backgroundImages[backgroundIndex])
        main.BackgroundTransparency = (backgroundMode == "None") and 0 or 1
        local bgImage = main:FindFirstChild("BackgroundImage")
        if bgImage then
            bgImage.Image = _bgAsset(backgroundImages[backgroundIndex])
            bgImage.ImageTransparency = backgroundMode == "None" and 1 or backgroundImageTransparency
        end
    end
    if miniBackgroundImage then
        miniBackgroundImage.Image = _bgAsset(backgroundImages[backgroundIndex])
        miniBackgroundImage.ImageTransparency = backgroundMode == "None" and 1 or math.clamp(backgroundImageTransparency + 0.25, 0, 1)
    end
    if backgroundSelectorLabel then backgroundSelectorLabel.Text = backgroundMode end
end

task.spawn(function()
    for i = 1, #backgroundImages do
        pcall(_bgAsset, backgroundImages[i])
    end
end)

local COLOR_THEMES = {
    ["Red"]    = Color3.fromRGB(220, 40, 40),
    ["Red2"]   = Color3.fromRGB(160, 20, 20),
    ["Orange"] = Color3.fromRGB(220, 40, 40),
    ["Gray"]   = Color3.fromRGB(170, 170, 170),
    ["White"]  = Color3.fromRGB(240, 245, 255),
}

DEMON_TITLE_THEMES = {
    ["Red"]    = { color = Color3.fromRGB(220, 40, 40),  stroke = nil },
    ["White"]  = { color = Color3.fromRGB(255, 255, 255), stroke = nil },
    ["Black"]  = { color = Color3.fromRGB(0, 0, 0),       stroke = Color3.fromRGB(255, 255, 255) },
    ["Silver"] = { color = Color3.fromRGB(192, 197, 206), stroke = nil },
}
currentDemonTitleTheme = "Red"
scriptLogoRef = nil
demonTitleSelectorLabel = nil

function applyDemonTitleTheme(themeName, noSave)
    local t = DEMON_TITLE_THEMES[themeName]
    if not t then return end
    currentDemonTitleTheme = themeName
    if scriptLogoRef and scriptLogoRef.Parent then
        local old = scriptLogoRef:FindFirstChildOfClass("UIGradient")
        if old then old:Destroy() end
        scriptLogoRef.TextColor3 = t.color
        if t.stroke then
            scriptLogoRef.TextStrokeColor3 = t.stroke
            scriptLogoRef.TextStrokeTransparency = 0.35
        else
            scriptLogoRef.TextStrokeTransparency = 1
        end
    end
    if demonTitleSelectorLabel then
        demonTitleSelectorLabel.Text = themeName
    end
    if not noSave and saveAllSettings then pcall(saveAllSettings) end
end

currentColorTheme = "Red"
selectedColor = COLOR_THEMES["Red"]

function getThemeColor() return selectedColor end
ESP_ORANGE = Color3.fromRGB(220, 40, 40)

function demonDuelsGradient(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.55)),
        ColorSequenceKeypoint.new(0.45, c),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.35)),
    })
end

function demonDuelsGradientSoft(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.75)),
        ColorSequenceKeypoint.new(0.50, c:Lerp(Color3.new(1,1,1), 0.25)),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.15)),
    })
end

function demonDuelsGradientDark(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.fromRGB(0,0,0), 0.35)),
        ColorSequenceKeypoint.new(0.55, c:Lerp(Color3.fromRGB(0,0,0), 0.65)),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.fromRGB(0,0,0), 0.80)),
    })
end

function applyDemonDuelsGradientToLabel(label, c)
    if not label then return end
    local grad = label:FindFirstChildOfClass("UIGradient")
    if not grad then
        grad = Instance.new("UIGradient", label)
    end
    grad.Rotation = 0
    grad.Color = demonDuelsGradient(c)
end

local _lastThemeUpdate = 0
local _lastThemeColor = nil

function applyColorTheme(themeName)
    local color = COLOR_THEMES[themeName]
    if not color then return end
    currentColorTheme = themeName
    selectedColor = color
    updateAllUIThemeColors(color)
    saveAllSettings()
end

_uicStroke = nil
_uicAvatarStroke = nil
_uicHandle = nil
_uicLine = nil

function updateAllUIThemeColors(color)
    local now = _tick()
    if color == _lastThemeColor and now - _lastThemeUpdate < 0.1 then return end
    _lastThemeUpdate = now
    _lastThemeColor = color

    if pbFrame then
        local border = pbFrame:FindFirstChild("OuterStroke")
        if border then border.Color = Color3.fromRGB(255, 80, 80) end
        local fpsNeon = pbFrame:FindFirstChild("FPSNeon", true)
        if fpsNeon then fpsNeon.TextColor3 = color end
        local pingNeon = pbFrame:FindFirstChild("PingNeon", true)
        if pingNeon then pingNeon.TextColor3 = color end
        local divider = pbFrame:FindFirstChild("Divider", true)
        if divider and divider:IsA("Frame") then divider.BackgroundColor3 = color end

        pbFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        pbFrame.BackgroundTransparency = 0
    end

    if _uicStroke then _uicStroke.Color = color end
    if _uicAvatarStroke then _uicAvatarStroke.Color = color end
    if _uicHandle then _uicHandle.TextColor3 = color end
    if _uicLine then _uicLine.BackgroundColor3 = color end

    local function searchAndUpdateText(parent)
        for _, child in ipairs(parent:GetDescendants()) do
            if child:IsA("TextLabel") then
                if child.Name == "DiscordText" then
                    child.TextColor3 = color
                    local grad = child:FindFirstChildOfClass("UIGradient")
                    if grad then
                        grad.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0.00, color),
                            ColorSequenceKeypoint.new(0.30, Color3.fromRGB(200,200,200)),
                            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
                            ColorSequenceKeypoint.new(0.70, Color3.fromRGB(200,200,200)),
                            ColorSequenceKeypoint.new(1.00, color),
                        })
                    end
                elseif child.Name == "SpeedLabel" then
                    local orange = Color3.fromRGB(255, 140, 30)
                    local silver = Color3.fromRGB(240, 245, 255)
                    child.TextColor3 = orange
                    local grad = child:FindFirstChildOfClass("UIGradient")
                    if grad then
                        grad.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0.00, orange),
                            ColorSequenceKeypoint.new(0.30, silver),
                            ColorSequenceKeypoint.new(0.50, orange),
                            ColorSequenceKeypoint.new(0.70, silver),
                            ColorSequenceKeypoint.new(1.00, orange),
                        })
                    end
                end
            end
            if child:IsA("UIStroke") then
                if child.Color == Color3.fromRGB(180, 180, 190) then child.Color = color end
            end
        end
    end
    if gui then searchAndUpdateText(gui) end
    for _, tab in ipairs(tabButtons or {}) do
        local isActive = tab:FindFirstChild("Underline") and tab.Underline.Visible
        if isActive then
            tab.TextColor3 = Color3.fromRGB(245, 245, 255)
            tab.BackgroundColor3 = color
            tab.BackgroundTransparency = 0.15
            local tg = tab:FindFirstChild("TabBgGrad")
            if tg then tg.Color = demonDuelsGradient(color) end
        else
            tab.TextColor3 = Color3.fromRGB(150, 150, 165)
            tab.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
            tab.BackgroundTransparency = 1
        end
        local ul = tab:FindFirstChild("Underline")
        if ul then ul.BackgroundColor3 = color end
        local s = tab:FindFirstChild("TabStroke")
        if s then s.Color = color end
    end
    if _G.__DemonDuelsRefreshESPTheme then pcall(_G.__DemonDuelsRefreshESPTheme, color) end
    if main then
        local titleFrame = main:FindFirstChild("Frame")
        if titleFrame then
            for _, child in ipairs(titleFrame:GetDescendants()) do
                if child:IsA("UIStroke") and child.Color == Color3.fromRGB(180, 180, 190) then
                    child.Color = color
                end
            end
        end
    end
    if colorSelectorLabel then
        colorSelectorLabel.Text = currentColorTheme
        colorSelectorLabel.TextColor3 = color
    end

    if _G._demonDuelsStealSlide then
        _G._demonDuelsStealSlide.BackgroundColor3 = color
        local sg = _G._demonDuelsStealSlide:FindFirstChildOfClass("UIGradient")
        if sg then sg.Color = demonDuelsGradient(color) end
        local ss = _G._demonDuelsStealSlide:FindFirstChildOfClass("UIStroke")
        if ss then ss.Color = color end
    end

    if miniBtn then
        local stroke = miniBtn:FindFirstChildOfClass("UIStroke")
        if stroke then
            stroke.Color = Color3.fromRGB(255, 150, 40)
            stroke.Transparency = 0.05
        end
        local rim = miniBtn:FindFirstChild("Rim")
        if rim then
            local rimStroke = rim:FindFirstChildOfClass("UIStroke")
            if rimStroke then
                rimStroke.Color = Color3.fromRGB(255, 150, 40)
                rimStroke.Transparency = 0.05
            end
        end
    end

    if MobilePanel then
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") and btn:FindFirstChild("BtnGrad") then
                paintFloatingBtn(btn, btn:GetAttribute("MobActive") == true)
            end
        end
    end
end

local HOMERO_CFG = {
    body = { 10725826963, 86500008, 86500054, 86500036, 86500064, 86500078 },
    aplicarCuerpo = true,
    items = {
        { id = 103227700418, offset = _CFnew(0,0,0) },
        { id = 84952305140948,   offset = _CFnew(0,0,0) },
        { id = 122465238537030,  offset = _CFnew(0,0,0) },
    },
    shirt = nil,
    pants = "rbxassetid://78591690208112",
    skinColor = Color3.fromRGB(234,184,146),
    headColor = Color3.fromRGB(0,0,0),
}

local TAG = "LocalOutfit_"

local function loadObjects(id)
    local ok, res = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(id))
    end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function()
        return game:GetService("InsertService"):LoadAsset(id)
    end)
    if ok and res then return { res } end
    return nil
end

local function collectParts(objs)
    local out = {}
    for _, o in ipairs(objs) do
        if o:IsA("BasePart") then out[#out + 1] = o end
        for _, d in ipairs(o:GetDescendants()) do
            if d:IsA("BasePart") then out[#out + 1] = d end
        end
    end
    return out
end

local function findAtt(char, name)
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("Attachment") and p.Name == name and p.Parent:IsA("BasePart") then
            return p
        end
    end
end

local function applyBody(char)
    local total = 0
    for _, id in ipairs(HOMERO_CFG.body) do
        local objs = loadObjects(id)
        if objs then
            for _, mp in ipairs(collectParts(objs)) do
                local orig = char:FindFirstChild(mp.Name)
                if orig and orig:IsA("BasePart") then
                    local c = mp:Clone()
                    c.Name = TAG .. "body_" .. mp.Name
                    c.CanCollide = false
                    c.Anchored = false
                    c.Massless = true
                    c.Size = orig.Size
                    c.CFrame = orig.CFrame
                    c.Parent = char
                    local w = Instance.new("WeldConstraint")
                    w.Part0 = orig
                    w.Part1 = c
                    w.Parent = c
                    if orig:GetAttribute("DemonDuelsOutfitOriginalTransparency") == nil then
                        orig:SetAttribute("DemonDuelsOutfitOriginalTransparency", orig.Transparency)
                    end
                    orig.Transparency = 1
                    total = total + 1
                end
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    return total
end

local function attachItem(char, entry)
    local objs = loadObjects(entry.id)
    if not objs then return false end

    local handle
    for _, p in ipairs(collectParts(objs)) do
        if p.Name == "Handle" then handle = p; break end
        if not handle then handle = p end
    end
    if not handle then
        for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        return false
    end

    local H = handle:Clone()
    for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end

    H.Name = TAG .. "item_" .. tostring(entry.id)
    H.CanCollide = false
    H.Anchored = false
    H.Massless = true

    local wrap = H:FindFirstChildWhichIsA("WrapLayer")
    local target, c0, c1

    if wrap then
        target = char:FindFirstChild("UpperTorso")
              or char:FindFirstChild("Torso")
              or char:FindFirstChild("HumanoidRootPart")
        c0 = entry.offset or _CFnew()
        c1 = _CFnew()
    else
        local hAtt = H:FindFirstChildOfClass("Attachment")
        local bAtt = hAtt and findAtt(char, hAtt.Name)
        if bAtt then
            target = bAtt.Parent
            c0 = bAtt.CFrame * (entry.offset or _CFnew())
            c1 = hAtt.CFrame
        else
            target = char:FindFirstChild("Head")
            c0 = entry.offset or _CFnew(0, 1.4, 0)
            c1 = _CFnew()
        end
    end

    if not target then H:Destroy(); return false end

    H.CFrame = target.CFrame * c0 * c1:Inverse()
    H.Parent = char

    local w = Instance.new("Weld")
    w.Part0 = target
    w.Part1 = H
    w.C0 = c0
    w.C1 = c1
    w.Parent = H
    return true
end

function applyHomeroOutfit(char)
    if not char then char = LP.Character end
    if not char then return end
    char:WaitForChild("Humanoid", 10)
    char:WaitForChild("Head", 10)
    task.wait(0.4)

    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #TAG) == TAG then pcall(function() d:Destroy() end) end
    end

    if HOMERO_CFG.skinColor then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        bc.HeadColor3 = HOMERO_CFG.headColor or HOMERO_CFG.skinColor
        bc.TorsoColor3 = HOMERO_CFG.skinColor
        bc.LeftArmColor3, bc.RightArmColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
        bc.LeftLegColor3, bc.RightLegColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
        bc.Parent = char
    end

    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle")
            if h then h.Transparency = 1 end
        end
    end

    if HOMERO_CFG.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"
        s.ShirtTemplate = HOMERO_CFG.shirt
        s.Parent = char
    end
    if HOMERO_CFG.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"
        p.PantsTemplate = HOMERO_CFG.pants
        p.Parent = char
    end
    if HOMERO_CFG.aplicarCuerpo then applyBody(char) end
    for _, e in ipairs(HOMERO_CFG.items) do attachItem(char, e) end
end

local _originalAppearance = nil

local function captureOriginalAppearance(char)
    if not char or _originalAppearance then return end
    local data = {
        bodyColors = nil,
        shirt = nil,
        pants = nil,
        headMesh = nil,
        headTexture = nil,
    }
    local bc = char:FindFirstChildWhichIsA("BodyColors")
    if bc then
        data.bodyColors = {
            head = bc.HeadColor3,
            torso = bc.TorsoColor3,
            leftArm = bc.LeftArmColor3,
            rightArm = bc.RightArmColor3,
            leftLeg = bc.LeftLegColor3,
            rightLeg = bc.RightLegColor3,
        }
    end
    local sh = char:FindFirstChildWhichIsA("Shirt")
    if sh then data.shirt = sh.ShirtTemplate end
    local pa = char:FindFirstChildWhichIsA("Pants")
    if pa then data.pants = pa.PantsTemplate end
    local head = char:FindFirstChild("Head")
    if head then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm and sm.MeshType == Enum.MeshType.FileMesh then
            data.headMesh = sm.MeshId
            data.headTexture = sm.TextureId
        end
    end
    _originalAppearance = data
end

local function clearPreviousOutfitAssets(char)
    if not char then return end
    do
        local headForFace = char:FindFirstChild("Head")
        local f = headForFace and headForFace:FindFirstChild("face")
        if f then
            local otr = f:GetAttribute("DemonDuelsOriginalFaceTransparency")
            if otr ~= nil then
                pcall(function() f.Transparency = otr end)
                f:SetAttribute("DemonDuelsOriginalFaceTransparency", nil)
            end
        end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child.Name:sub(1, #TAG) == TAG
        or child.Name == "AuFfitAccessory"
        or child.Name == "BubbleSkinChanger_Hair"
        or child.Name == "BubbleSkinChanger_Hat"
        or child.Name == "Korblox_RightLeg" then
            pcall(function() child:Destroy() end)
        elseif child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
            pcall(function() child:Destroy() end)
        end
    end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local originalTransparency = part:GetAttribute("DemonDuelsOutfitOriginalTransparency")
            if originalTransparency ~= nil then
                part.Transparency = originalTransparency
                part:SetAttribute("DemonDuelsOutfitOriginalTransparency", nil)
            end
            local originalLocalTransparency = part:GetAttribute("DemonDuelsOutfitOriginalLocalTransparency")
            if originalLocalTransparency ~= nil then
                part.LocalTransparencyModifier = originalLocalTransparency
                part:SetAttribute("DemonDuelsOutfitOriginalLocalTransparency", nil)
            end
        end
    end
    if _originalAppearance and _originalAppearance.bodyColors then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        local o = _originalAppearance.bodyColors
        bc.HeadColor3, bc.TorsoColor3 = o.head, o.torso
        bc.LeftArmColor3, bc.RightArmColor3 = o.leftArm, o.rightArm
        bc.LeftLegColor3, bc.RightLegColor3 = o.leftLeg, o.rightLeg
        bc.Parent = char
    end
    local head = char:FindFirstChild("Head")
    if head and head:IsA("MeshPart") and head:GetAttribute("DemonDuelsOutfitModifiedMeshPart") then
        pcall(function()
            head.MeshId = head:GetAttribute("DemonDuelsOutfitOriginalMeshId") or ""
            head.TextureID =
... (534 Ko restants)
