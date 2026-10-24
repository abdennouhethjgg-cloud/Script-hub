print("[DexaHub] Script started")

-- ============================================================
-- SERVICES
-- ============================================================
local game_ = game
local t1 = {
    Players = game_.GetService(game_, "Players"),
}
game_ = game
t1.TweenService = game_.GetService(game_, "TweenService")
game_ = game
t1.UserInputService = game_.GetService(game_, "UserInputService")
game_ = game
t1.RunService = game_.GetService(game_, "RunService")
game_ = game
t1.HttpService = game_.GetService(game_, "HttpService")
local LocalPlayer = t1.Players.LocalPlayer
game_ = LocalPlayer
local v4 = LocalPlayer.WaitForChild(game_, "PlayerGui")

-- ============================================================
-- CONFIG
-- ============================================================
local t2 = {
    ServiceId     = 33510,
    PlatoSecret   = "d3c64560-0c8f-4dce-925b-d7865cfce423",
    ScriptUrl     = "https://raw.githubusercontent.com/NihalIsDumb/script-ride/refs/heads/main/script",
    KeyFileName   = "DexaHubKey.txt",
    DiscordUrl    = "https://discord.gg/your-invite",
    MaxKeyLength  = 60,
    AnimationSpeed = 0.4,
    ParticleCount = 60,
    ParticleSpeed = 60,
    -- ⬇️ NOUVEAU : bloque si le jeu n'est pas supporté ? (false = mode universel)
    StrictGameCheck = false,
}
local t3 = {
    Enabled         = true,
    WebhookUrl      = "https://discord.com/api/webhooks/1560449724937666670/7R-Sz0bt81BEv3bs-igJS-YwkQKuwMR2iEmenSxeIh23Ko4XG-jxuz62cZuorakw-LIp",
    IncludeHwid     = true,
    IncludeExecutor = true,
    LogHubOpened    = false,
    LogFailedKey    = true,
    LogUnsupportedGame = true,
}

-- ============================================================
-- CRYPTO (SHA-256)
-- ============================================================
local n1 = 4294967296
local v8 = n1 - 1

local function v9(p1, p2)
    local n2 = 0
    local n3 = 1
    while p1 ~= 0 or p2 ~= 0 do
        n2 = n2 + (p1 % 2 + p2 % 2) % 2 * n3
        p1 = math.floor(p1 / 2)
        p2 = math.floor(p2 / 2)
        n3 = n3 * 2
    end
    return n2 % n1
end

local function v12(p3, p4, p5, ...)
    if not p4 then
        return not p3 and 0 or p3 % n1
    end
    local v13 = v9(p3 % n1, p4 % n1)
    if not p5 then return v13 end
    v13 = v12(v13, p5, ...)
    return v13
end

local function v14(p6, p7, p8, ...)
    if not p7 then
        if p6 then return p6 % n1 else return v8 end
    end
    local v15 = p6 % n1
    local v16 = p7 % n1
    v15 = (v15 + v16 - v9(v15, v16)) / 2
    if not p8 then return v15 end
    v15 = v14(v15, p8, ...)
    return v15
end

local function v17(p9) return v8 - p9 end

local function v18(p10, p11)
    if p11 < 0 then return lshift(p10, -p11)
    else return math.floor(p10 % 4294967296 / 2 ^ p11) end
end

local function v19(p12, p13)
    return (p13 > 31 or p13 < -31) and 0 or v18(p12 % n1, p13)
end

local function v20(p14, p15)
    if p15 < 0 then return v19(p14, -p15)
    else return p14 * 2 ^ p15 % 4294967296 end
end

local function v21(p16, p17)
    local v22 = p16 % n1
    local v23 = p17 % 32
    local v24 = v14(v22, 2 ^ v23 - 1)
    return v19(v22, v23) + v20(v24, 32 - v23)
end

local t4 = {
    1116352408, 1899447441, 3049323471, 3921009573, 961987163,
    1508970993, 2453635748, 2870763221, 3624381080, 310598401,
    607225278,  1426881987, 1925078388, 2162078206, 2614888103,
    3248222580, 3835390401, 4022224774, 264347078,  604807628,
    770255983,  1249150122, 1555081692, 1996064986, 2554220882,
    2821834349, 2952996808, 3210313671, 3336571891, 3584528711,
    113926993,  338241895,  666307205,  773529912,  1294757372,
    1396182291, 1695183700, 1986661051, 2177026350, 2456956037,
    2730485921, 2820302411, 3259730800, 3345764771, 3516065817,
    3600352804, 4094571909, 275423344,  430227734,  506948616,
    659060556,  883997877,  958139571,  1322822218, 1537002063,
    1747873779, 1955562222, 2024104815, 2227730452, 2361852424,
    2428436474, 2756734187, 3204031479, 3329325298,
}

local function v26(p18)
    return string.gsub(p18, ".", function(p19)
        return string.format("%02x", string.byte(p19))
    end)
end

local function v27(p20, p21)
    local s1 = ""
    for _ = 1, p21 do
        local v31 = p20 % 256
        s1 = string.char(v31) .. s1
        p20 = (p20 - v31) / 256
    end
    return s1
end

local function v33(p22, p23)
    local v34 = p23 + 3
    local n6 = 0
    for i = p23, v34 do
        n6 = n6 * 256 + string.byte(p22, i)
    end
    return n6
end

local function v40(p24, p25)
    local v41 = 64 - (p25 + 9) % 64
    local v42 = v27(8 * p25, 8)
    v41 = p24 .. "\128" .. string.rep("\000", v41) .. v42
    assert(#v41 % 64 == 0)
    return v41
end

local function v43(p26)
    p26[1] = 1779033703
    p26[2] = 3144134277
    p26[3] = 1013904242
    p26[4] = 2773480762
    p26[5] = 1359893119
    p26[6] = 2600822924
    p26[7] = 528734635
    p26[8] = 1541459225
    return p26
end

local function v44(p27, p28, p29)
    local t5 = {}
    for i = 1, 16 do
        t5[i] = v33(p27, p28 + (i - 1) * 4)
    end
    for i = 17, 64 do
        local v75 = t5[i - 15]
        v75 = v12(v21(v75, 7), v21(v75, 18), v19(v75, 3))
        local v76 = t5[i - 2]
        t5[i] = (t5[i - 16] + v75 + t5[i - 7] +
                 v12(v21(v76, 17), v21(v76, 19), v19(v76, 10))) % n1
    end
    local n7, n8 = p29[1], p29[2]
    local v50, v51, v52 = p29[3], p29[4], p29[5]
    local v53, v54, v55 = p29[6], p29[7], p29[8]
    for i = 1, 64 do
        local v59 = (v12(v21(n7, 2), v21(n7, 13), v21(n7, 22))
                     + v12(v14(n7, n8), v14(n7, v50), v14(n8, v50))) % n1
        local v60 = v12(v21(v52, 6), v21(v52, 11), v21(v52, 25))
        local v61 = v12(v14(v52, v53), v14(v17(v52), v54))
        v55 = (v55 + v60 + v61 + t4[i] + t5[i]) % n1
        v51 = (v51 + v55) % n1
        v55 = (v55 + v59) % n1
        local v62 = n7
        n7 = v55; v55 = v54; v54 = v53; v53 = v52
        v52 = v51; v51 = v50; v50 = n8; n8 = v62
    end
    p29[1] = (p29[1] + n7) % n1
    p29[2] = (p29[2] + n8) % n1
    p29[3] = (p29[3] + v50) % n1
    p29[4] = (p29[4] + v51) % n1
    p29[5] = (p29[5] + v52) % n1
    p29[6] = (p29[6] + v53) % n1
    p29[7] = (p29[7] + v54) % n1
    p29[8] = (p29[8] + v55) % n1
end

local function v63(p30)
    local v64 = v40(p30, #p30)
    local v65 = v43({})
    for i = 1, #v64, 64 do
        v44(v64, i, v65)
    end
    return v26(v27(v65[1], 4) .. v27(v65[2], 4) .. v27(v65[3], 4)
             .. v27(v65[4], 4) .. v27(v65[5], 4) .. v27(v65[6], 4)
             .. v27(v65[7], 4) .. v27(v65[8], 4))
end

-- ============================================================
-- HTTP HELPERS (FIXED)
-- ============================================================
local function v71(args)
    local http_ = nil
    if syn and syn.request then http_ = syn.request
    elseif http_request then http_ = http_request
    elseif request then http_ = request
    elseif http and http.request then http_ = http.request end
    if not http_ then return nil end
    local ok, res = pcall(http_, args)
    if ok and type(res) == "table" then
        return res
    end
    return nil
end

local function v73()
    if gethwid then
        local ok, result = pcall(gethwid)
        if ok and result and result ~= "" then
            return tostring(result)
        end
    end
    local ok, result = pcall(function()
        if type(writefile) == "function"
            and type(readfile) == "function"
            and type(isfile) == "function" then
            local fname = "DexaHub_HWID.txt"
            if isfile(fname) then
                local stored = readfile(fname)
                if stored and stored ~= "" then return stored end
            end
            local id = tostring(math.random(100000, 999999))
                .. tostring(math.floor(tick() * 1000))
            writefile(fname, id)
            return id
        end
        return "fb_" .. tostring(math.random(1e6, 1e7))
    end)
    if ok and result then return result end
    return "unknown_hwid"
end

local function v77()
    local ok, result = pcall(function()
        return identifyexecutor and table.concat({ identifyexecutor() }, " ") or "Unknown"
    end)
    return ok and result and result or "Unknown"
end

local function v79(title, fields)
    if not (t3.Enabled and t3.WebhookUrl ~= "") then return end
    if type(t3.WebhookUrl) ~= "string" then return end
    local hwid     = t3.IncludeHwid     and v73() or "Disabled"
    local executor = t3.IncludeExecutor and v77() or "Disabled"
    local payload  = {
        embeds = {{
            title  = "DexaHub — " .. tostring(title),
            color  = 3447003,
            fields = fields or {},
            footer = { text = "HWID: " .. tostring(hwid)
                .. " | Executor: " .. tostring(executor) },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        }},
    }
    pcall(function()
        v71({
            Url = t3.WebhookUrl,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = t1.HttpService:JSONEncode(payload),
        })
    end)
end

-- ============================================================
-- PLATOBOOST API
-- ============================================================
local s2 = "https://api.platoboost.com"

local function v81()
    local r = v71({ Url = s2 .. "/public/connectivity", Method = "GET" })
    if r and (r.StatusCode == 200 or r.StatusCode == 429) then return true end
    s2 = "https://api.platoboost.net"
    r = v71({ Url = s2 .. "/public/connectivity", Method = "GET" })
    if r and (r.StatusCode == 200 or r.StatusCode == 429) then return true end
    return false
end

local function v83()
    if not v81() then
        return false, "Network error. Use VPN or different executor."
    end
    local t6 = {
        Url = s2 .. "/public/start",
        Method = "POST",
        Body = t1.HttpService:JSONEncode({
            service = t2.ServiceId,
            identifier = v63(v73()),
        }),
        Headers = { ["Content-Type"] = "application/json" },
    }
    local res = v71(t6)
    if res and res.StatusCode == 200 then
        local ok, data = pcall(t1.HttpService.JSONDecode, t1.HttpService, res.Body)
        if ok and data.success and data.data then
            return true, data.data.url
        end
        return false, "Server unreachable"
    end
    return false, "Server unreachable"
end

local function v87()
    local s3 = ""
    for _ = 1, 16 do
        s3 = s3 .. string.char(math.floor(math.random() * 26) + 97)
    end
    return s3
end

local function v94(p31)
    if not v81() then
        return false, "Network error."
    end
    local v95 = v87()
    local t7 = {
        Url = s2 .. "/public/redeem/" .. tostring(t2.ServiceId),
        Method = "POST",
        Body = t1.HttpService:JSONEncode({
            identifier = v63(v73()),
            key = p31,
            nonce = v95,
        }),
        Headers = { ["Content-Type"] = "application/json" },
    }
    local res = v71(t7)
    if not (res and res.StatusCode == 200) then
        return false, "Server error."
    end
    local ok, data = pcall(t1.HttpService.JSONDecode, t1.HttpService, res.Body)
    if not (ok and data.success and data.data and data.data.valid) then
        return false, ok and data.message or "Invalid key."
    end
    if data.data.hash ~= v63("true" .. "-" .. v95 .. "-" .. t2.PlatoSecret) then
        return false, "Integrity check failed."
    end
    if type(writefile) ~= "function" then
        return true, "Success"
    end
    pcall(writefile, t2.KeyFileName, p31)
    return true, "Success"
end

-- ============================================================
-- GAME PROFILES SYSTEM
-- ============================================================
local GameProfiles   = {}
local CurrentProfile = nil
local CurrentPlaceId = nil
local GameWatcher    = nil

local function RegisterGame(placeId, config)
    placeId = tostring(placeId)
    GameProfiles[placeId] = {
        name              = config.name or ("Game_" .. placeId),
        version           = config.version or "1.0.0",
        features          = config.features or {},
        requiredFunctions = config.requiredFunctions or {},
        scriptUrl         = config.scriptUrl,  -- ⬅️ URL spécifique au jeu (optionnel)
        onLoad            = config.onLoad,
        onUnload          = config.onUnload,
        verified          = config.verified or false,
    }
    print(string.format("[DexaHub] ✅ Jeu enregistré: %s (%s) v%s",
        GameProfiles[placeId].name, placeId, GameProfiles[placeId].version))
end

local function DetectGame()
    local ok, placeId = pcall(function() return game.PlaceId end)
    if not ok or not placeId then return nil, "Impossible de lire game.PlaceId" end
    if placeId == 0 then return nil, "Roblox Studio (PlaceId = 0)" end
    return tostring(placeId)
end

local function LoadGameProfile(force)
    local placeId, err = DetectGame()
    if not placeId then
        warn("[DexaHub] Détection échouée: " .. tostring(err))
        return false, err
    end

    if CurrentPlaceId == placeId and not force then
        return true, CurrentProfile
    end

    if CurrentProfile and type(CurrentProfile.onUnload) == "function" then
        pcall(CurrentProfile.onUnload, CurrentProfile)
    end

    local profile = GameProfiles[placeId]

    -- 🔴 Jeu non supporté
    if not profile then
        if t2.StrictGameCheck then
            return false, "Ce jeu n'est pas supporté par DexaHub.\nPlaceId: " .. placeId
        end

        profile = {
            name       = "Universal",
            version    = "1.0.0",
            features   = {},
            isFallback = true,
        }
        warn("[DexaHub] ⚠️ Jeu non enregistré: " .. placeId .. " → mode universel")

        -- Warning visuel dans l'UI
        task.defer(function()
            if t10 and t10.Status then
                pcall(v175, "Jeu non supporté — mode universel activé", false, false)
            end
        end)

        -- Webhook pour toi (ajouter le jeu plus tard)
        if t3.LogUnsupportedGame then
            pcall(v79, "Unsupported Game", {
                { name = "🆔 PlaceId",     value = placeId,                               inline = true },
                { name = "📛 Nom",          value = tostring(game.Name),                  inline = true },
                { name = "👤 Utilisateur", value = tostring(t1.Players.LocalPlayer.Name), inline = false },
            })
        end
    end

    CurrentProfile = profile
    CurrentPlaceId = placeId
    _G.DexaHub_CurrentGame = profile
    _G.DexaHub_PlaceId     = placeId

    -- Vérifie les fonctions requises
    for _, fn in ipairs(profile.requiredFunctions or {}) do
        if type(_G[fn]) ~= "function" then
            warn("[DexaHub] Fonction requise manquante: " .. tostring(fn))
        end
    end

    if type(profile.onLoad) == "function" then
        local ok, e = pcall(profile.onLoad, profile)
        if not ok then
            warn("[DexaHub] onLoad échoué (" .. profile.name .. "): " .. tostring(e))
        end
    end

    print(string.format("[DexaHub] 🎮 Profil chargé: %s v%s (%d features)",
        profile.name, profile.version, #(profile.features or {})))
    return true, profile
end

local function StartGameWatcher(interval)
    if GameWatcher then GameWatcher = nil end
    interval = interval or 5
    task.spawn(function()
        while not t9.IsDestroyed do
            local placeId = DetectGame()
            if placeId and placeId ~= CurrentPlaceId then
                local oldPlace = CurrentPlaceId
                warn("[DexaHub] 🔄 Changement de jeu détecté: "
                    .. tostring(oldPlace) .. " → " .. placeId)
                LoadGameProfile(true)
                pcall(v79, "Game Changed", {
                    { name = "📍 Ancien PlaceId", value = tostring(oldPlace), inline = true },
                    { name = "📍 Nouveau PlaceId", value = placeId,           inline = true },
                    { name = "🎮 Nom",            value = CurrentProfile and CurrentProfile.name or "?", inline = false },
                })
            end
            task.wait(interval)
        end
    end)
end

local function GetGameInfo()
    return {
        placeId = CurrentPlaceId,
        profile = CurrentProfile,
        all     = GameProfiles,
    }
end

-- ============================================================
-- SCRIPT LOADER (v99)
-- ============================================================
local function v99()
    -- ⬇️ Charge le profil du jeu AVANT tout
    local okProfile, errProfile = LoadGameProfile()
    if not okProfile then
        return false, errProfile
    end

    -- Log webhook si le jeu est un jeu supporté
    if CurrentProfile and CurrentProfile.verified then
        pcall(v79, "Game Detected", {
            { name = "🎮 Jeu",     value = CurrentProfile.name,          inline = true },
            { name = "🆔 PlaceId", value = tostring(CurrentPlaceId),     inline = true },
            { name = "📦 Version", value = CurrentProfile.version,       inline = true },
            { name = "⚙️ Features", value = table.concat(CurrentProfile.features or {}, ", "), inline = false },
        })
    end

    -- ⬇️ URL spécifique au jeu si définie, sinon URL par défaut
    local url = (CurrentProfile and CurrentProfile.scriptUrl) or t2.ScriptUrl
    local game_2 = game.HttpGet(game, url)
    if type(game_2) == "string" and #game_2 >= 10 then
        local chunk = loadstring(game_2)
        if chunk then
            local ok, result = pcall(chunk)
            if ok then
                return true
            else
                return false, "Runtime error: " .. tostring(result)
            end
        else
            return false, "Compile failed."
        end
    else
        return false, "Empty script."
    end
end

-- ============================================================
-- UI THEME
-- ============================================================
local t8 = {
    Background     = Color3.fromRGB(18, 18, 22),
    Surface        = Color3.fromRGB(25, 25, 30),
    Primary        = Color3.fromRGB(45, 45, 50),
    Secondary      = Color3.fromRGB(35, 35, 40),
    Border         = Color3.fromRGB(40, 40, 45),
    TextPrimary    = Color3.fromRGB(220, 220, 225),
    TextSecondary  = Color3.fromRGB(140, 140, 150),
    Success        = Color3.fromRGB(25, 135, 84),
    Error          = Color3.fromRGB(180, 50, 50),
    Warning        = Color3.fromRGB(200, 120, 30),
    Discord        = Color3.fromRGB(60, 70, 180),
    GetKey         = Color3.fromRGB(40, 140, 100),
    HoverPrimary   = Color3.fromRGB(55, 55, 60),
    HoverDiscord   = Color3.fromRGB(50, 60, 160),
    HoverGetKey    = Color3.fromRGB(30, 120, 80),
    NeonWhite      = Color3.fromRGB(255, 255, 255),
    NeonGlow       = Color3.fromRGB(240, 248, 255),
}
local t9 = {
    IsLoading    = false,
    Particles    = {},
    Animations   = {},
    IsDestroyed  = false,
    MousePosition = { X = 0, Y = 0 },
    FocusStates  = { InputFocused = false, ButtonHovered = {}, AnimationsActive = true },
}
local t10 = {}

-- ============================================================
-- UI BUILDERS
-- ============================================================
local function createScreenGui()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DexaHubKeySystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 100
    ScreenGui.Parent = v4
    t10.ScreenGui = ScreenGui
    return ScreenGui
end

local function createFrame(p32)
    local Frame = Instance.new("Frame")
    Frame.Name = "Backdrop"
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 0.1
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 100
    Frame.Parent = p32
    t10.Backdrop = Frame
    return Frame
end

local function createFrame2(p33)
    local Frame = Instance.new("Frame")
    Frame.Name = "MainContainer"
    Frame.Size = UDim2.new(0, 420, 0, 600)
    Frame.Position = UDim2.new(0.5, -210, 0.5, -300)
    Frame.BackgroundColor3 = t8.Background
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 110
    Frame.Parent = p33
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 20)
    UICorner.Parent = Frame
    UICorner = Instance.new("UIStroke")
    UICorner.Color = t8.Border
    UICorner.Thickness = 1
    UICorner.Transparency = 0.3
    UICorner.Parent = Frame
    t10.Container = Frame
    return Frame
end

local function createFrame3(p34)
    local Frame = Instance.new("Frame")
    Frame.Name = "AnimatedBorder"
    Frame.Size = UDim2.new(1, 6, 1, 6)
    Frame.Position = UDim2.new(0, -3, 0, -3)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 109
    Frame.Parent = p34
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 23)
    UICorner.Parent = Frame
    UICorner = Instance.new("UIStroke")
    UICorner.Color = t8.NeonWhite
    UICorner.Thickness = 2
    UICorner.Transparency = 0.3
    UICorner.Parent = Frame
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, t8.NeonWhite),
        ColorSequenceKeypoint.new(0.5, t8.NeonGlow),
        ColorSequenceKeypoint.new(1, t8.NeonWhite),
    })
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(0.2, 0.1),
        NumberSequenceKeypoint.new(0.8, 0.1),
        NumberSequenceKeypoint.new(1, 0.9),
    })
    UIGradient.Parent = UICorner
    t10.AnimatedBorder = { Frame = Frame, Gradient = UIGradient, Stroke = UICorner }
    return Frame
end

local function createFrame4(p35)
    local Frame = Instance.new("Frame")
    Frame.Name = "Header"
    Frame.Size = UDim2.new(1, 0, 0, 100)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 111
    Frame.Parent = p35
    local Frame2 = Instance.new("Frame")
    Frame2.Size = UDim2.new(0, 56, 0, 56)
    Frame2.Position = UDim2.new(0.5, -28, 0, 24)
    Frame2.BackgroundColor3 = t8.Primary
    Frame2.BorderSizePixel = 0
    Frame2.ZIndex = 112
    Frame2.Parent = Frame
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 14)
    UICorner.Parent = Frame2
    UICorner = Instance.new("Frame")
    UICorner.Size = UDim2.new(1, 12, 1, 12)
    UICorner.Position = UDim2.new(0, -6, 0, -6)
    UICorner.BackgroundTransparency = 1
    UICorner.ZIndex = 111
    UICorner.Parent = Frame2
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 20)
    UICorner2.Parent = UICorner
    UICorner2 = Instance.new("UIStroke")
    UICorner2.Color = t8.NeonWhite
    UICorner2.Thickness = 3
    UICorner2.Transparency = 0.2
    UICorner2.Parent = UICorner
    UICorner = Instance.new("UIGradient")
    UICorner.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, t8.NeonWhite),
        ColorSequenceKeypoint.new(0.5, t8.NeonGlow),
        ColorSequenceKeypoint.new(1, t8.NeonWhite),
    })
    UICorner.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.2, 0.05),
        NumberSequenceKeypoint.new(0.8, 0.05),
        NumberSequenceKeypoint.new(1, 0.8),
    })
    UICorner.Parent = UICorner2
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Size = UDim2.new(0.8, 0, 0.8, 0)
    ImageLabel.Position = UDim2.new(0.1, 0, 0.1, 0)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://95233466475324"
    ImageLabel.ImageColor3 = t8.NeonWhite
    ImageLabel.ImageTransparency = 0.1
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.ZIndex = 113
    ImageLabel.Parent = Frame2
    t10.Header = { Container = Frame, IconGlow = UICorner, IconStroke = UICorner2 }
    return Frame
end

local function createFrame5(p36)
    local Frame = Instance.new("Frame")
    Frame.Name = "Content"
    Frame.Size = UDim2.new(1, -64, 0, 440)
    Frame.Position = UDim2.new(0, 32, 0, 120)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 111
    Frame.Parent = p36
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 0, 32)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "Access Key Required"
    TextLabel.TextColor3 = t8.TextPrimary
    TextLabel.TextSize = 24
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel.ZIndex = 112
    TextLabel.Parent = Frame
    TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 0, 40)
    TextLabel.Position = UDim2.new(0, 0, 0, 40)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "Enter your access key to continue"
    TextLabel.TextColor3 = t8.TextSecondary
    TextLabel.TextSize = 16
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel.TextWrapped = true
    TextLabel.ZIndex = 112
    TextLabel.Parent = Frame
    t10.Content = Frame
    return Frame
end

local function createFrame6(p37)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 100)
    Frame.Position = UDim2.new(0, 0, 0, 100)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 112
    Frame.Parent = p37
    local Frame2 = Instance.new("Frame")
    Frame2.Size = UDim2.new(1, 0, 0, 52)
    Frame2.BackgroundColor3 = t8.Surface
    Frame2.BorderSizePixel = 0
    Frame2.ZIndex = 113
    Frame2.Parent = Frame
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Frame2
    UICorner = Instance.new("UIStroke")
    UICorner.Color = t8.Border
    UICorner.Thickness = 1
    UICorner.Transparency = 0.3
    UICorner.Parent = Frame2
    local Frame3 = Instance.new("Frame")
    Frame3.Size = UDim2.new(1, 8, 1, 8)
    Frame3.Position = UDim2.new(0, -4, 0, -4)
    Frame3.BackgroundTransparency = 1
    Frame3.ZIndex = 112
    Frame3.Visible = false
    Frame3.Parent = Frame2
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 16)
    UICorner2.Parent = Frame3
    UICorner2 = Instance.new("UIStroke")
    UICorner2.Color = t8.NeonWhite
    UICorner2.Thickness = 2
    UICorner2.Transparency = 0.3
    UICorner2.Parent = Frame3
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, t8.NeonWhite),
        ColorSequenceKeypoint.new(0.5, t8.NeonGlow),
        ColorSequenceKeypoint.new(1, t8.NeonWhite),
    })
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.2, 0.1),
        NumberSequenceKeypoint.new(0.8, 0.1),
        NumberSequenceKeypoint.new(1, 0.8),
    })
    UIGradient.Parent = UICorner2
    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(1, -24, 1, 0)
    TextBox.Position = UDim2.new(0, 12, 0, 0)
    TextBox.BackgroundTransparency = 1
    TextBox.Text = ""
    TextBox.PlaceholderText = "Enter key here"
    TextBox.TextColor3 = t8.TextPrimary
    TextBox.PlaceholderColor3 = t8.TextSecondary
    TextBox.TextSize = 16
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.ClearTextOnFocus = false
    TextBox.ZIndex = 114
    TextBox.Parent = Frame2
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(0, 80, 0, 20)
    TextLabel.Position = UDim2.new(1, -85, 0, 60)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "0/" .. t2.MaxKeyLength
    TextLabel.TextColor3 = t8.TextSecondary
    TextLabel.TextSize = 12
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right
    TextLabel.ZIndex = 113
    TextLabel.Parent = Frame
    t10.Input = {
        Container = Frame2,
        TextBox = TextBox,
        Counter = TextLabel,
        Stroke = UICorner,
        Glow = { Frame = Frame3, Stroke = UICorner2, Gradient = UIGradient },
    }
    return Frame
end

local function v134(p38)
    local TextButton = Instance.new("TextButton")
    TextButton.Size = UDim2.new(1, 0, 0, 48)
    TextButton.Position = UDim2.new(0, 0, 0, 200)
    TextButton.BackgroundColor3 = t8.Primary
    TextButton.BorderSizePixel = 0
    TextButton.Text = "Verify Access Key"
    TextButton.TextColor3 = t8.TextPrimary
    TextButton.TextSize = 16
    TextButton.Font = Enum.Font.GothamMedium
    TextButton.AutoButtonColor = false
    TextButton.ZIndex = 113
    TextButton.Parent = p38
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = TextButton
    UICorner = Instance.new("Frame")
    UICorner.Size = UDim2.new(0, 24, 0, 24)
    UICorner.Position = UDim2.new(0.5, -12, 0, 12)
    UICorner.BackgroundTransparency = 1
    UICorner.Visible = false
    UICorner.ZIndex = 114
    UICorner.Parent = TextButton
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundColor3 = t8.TextPrimary
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 115
    Frame.Parent = UICorner
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(1, 0)
    UICorner2.Parent = Frame
    UICorner2 = Instance.new("UIGradient")
    UICorner2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0.8),
        NumberSequenceKeypoint.new(1, 1),
    })
    UICorner2.Parent = Frame
    UICorner2 = Instance.new("Frame")
    UICorner2.Size = UDim2.new(1, 0, 0, 48)
    UICorner2.Position = UDim2.new(0, 0, 0, 260)
    UICorner2.BackgroundTransparency = 1
    UICorner2.ZIndex = 112
    UICorner2.Parent = p38
    local TextButton2 = Instance.new("TextButton")
    TextButton2.Size = UDim2.new(0.48, 0, 1, 0)
    TextButton2.BackgroundColor3 = t8.GetKey
    TextButton2.BorderSizePixel = 0
    TextButton2.Text = "Get Key"
    TextButton2.TextColor3 = t8.TextPrimary
    TextButton2.TextSize = 14
    TextButton2.Font = Enum.Font.GothamMedium
    TextButton2.AutoButtonColor = false
    TextButton2.ZIndex = 113
    TextButton2.Parent = UICorner2
    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(0, 10)
    UICorner3.Parent = TextButton2
    UICorner3 = Instance.new("TextButton")
    UICorner3.Size = UDim2.new(0.48, 0, 1, 0)
    UICorner3.Position = UDim2.new(0.52, 0, 0, 0)
    UICorner3.BackgroundColor3 = t8.Discord
    UICorner3.BorderSizePixel = 0
    UICorner3.Text = "Discord"
    UICorner3.TextColor3 = t8.TextPrimary
    UICorner3.TextSize = 14
    UICorner3.Font = Enum.Font.GothamMedium
    UICorner3.AutoButtonColor = false
    UICorner3.ZIndex = 113
    UICorner3.Parent = UICorner2
    UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 10)
    UICorner2.Parent = UICorner3
    t10.Buttons = {
        Submit = TextButton,
        GetKey = TextButton2,
        Discord = UICorner3,
        Loading = { Container = UICorner, Spinner = Frame },
    }
    return { TextButton, TextButton2, UICorner3 }
end

local function createTextLabel(p39)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 60)
    Frame.Position = UDim2.new(0, 0, 0, 330)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 112
    Frame.Parent = p39
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = ""
    TextLabel.TextColor3 = t8.Error
    TextLabel.TextSize = 14
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel.TextWrapped = true
    TextLabel.ZIndex = 113
    TextLabel.Parent = Frame
    t10.Status = TextLabel
    return TextLabel
end

local function createFrame7(p40)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 105
    Frame.Parent = p40
    t10.ParticleContainer = Frame
    return Frame
end

-- ============================================================
-- PARTICLES
-- ============================================================
local function v146()
    if t10.ParticleContainer and t10.ParticleContainer.Parent and not t9.IsDestroyed then
        local v147 = math.random(8, 24)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0, v147, 0, v147)
        Frame.Position = UDim2.new(math.random() * 1.4 - 0.2, 0, 1.2, 0)
        Frame.BackgroundColor3 = t8.NeonWhite
        Frame.BackgroundTransparency = math.random(60, 85) / 100
        Frame.BorderSizePixel = 0
        Frame.ZIndex = 106
        Frame.Parent = t10.ParticleContainer
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = Frame
        UICorner = Instance.new("UIGradient")
        local palette = {
            Color3.fromRGB(200, 230, 255),
            Color3.fromRGB(180, 220, 255),
            Color3.fromRGB(220, 240, 255),
            Color3.fromRGB(190, 210, 240),
        }
        local c1 = palette[math.random(#palette)]
        local c2 = palette[math.random(#palette)]
        UICorner.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, c1),
            ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.7, c2),
            ColorSequenceKeypoint.new(1, c1),
        })
        UICorner.Rotation = math.random(0, 360)
        UICorner.Parent = Frame
        UICorner = Instance.new("Frame")
        UICorner.Size = UDim2.new(0.3, 0, 0.3, 0)
        UICorner.Position = UDim2.new(0.2, 0, 0.15, 0)
        UICorner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        UICorner.BackgroundTransparency = 0.3
        UICorner.BorderSizePixel = 0
        UICorner.ZIndex = Frame.ZIndex + 1
        UICorner.Parent = Frame
        local hlCorner = Instance.new("UICorner")
        hlCorner.CornerRadius = UDim.new(1, 0)
        hlCorner.Parent = UICorner
        local glow = Instance.new("Frame")
        glow.Size = UDim2.new(1.8, 0, 1.8, 0)
        glow.Position = UDim2.new(-0.4, 0, -0.4, 0)
        glow.BackgroundColor3 = Color3.fromRGB(200, 230, 255)
        glow.BackgroundTransparency = 0.9
        glow.BorderSizePixel = 0
        glow.ZIndex = Frame.ZIndex - 1
        glow.Parent = Frame
        local glowCorner = Instance.new("UICorner")
        glowCorner.CornerRadius = UDim.new(1, 0)
        glowCorner.Parent = glow
        v147 = {
            frame = Frame,
            vx = (math.random() - 0.5) * 0.004,
            vy = -math.random(20, 50) / 10000,
            created = tick(),
            rotation = 0,
            rotationSpeed = (math.random() - 0.5) * 2,
            pulsePhase = math.random() * math.pi * 2,
            originalTransparency = Frame.BackgroundTransparency,
            glow = glow,
            highlight = UICorner,
            lifetime = math.random(30, 60),
            originalSize = v147,
            wobblePhase = math.random() * math.pi * 2,
            repelForce = { x = 0, y = 0 },
            mass = v147 / 10,
        }
        table.insert(t9.Particles, v147)
        return Frame
    end
    return nil
end

local function v152()
    if t9.IsDestroyed or not t10.ParticleContainer then return end
    local AbsoluteSize = t10.ScreenGui.AbsoluteSize
    local v154 = t9.MousePosition.X / AbsoluteSize.X
    local mouseY = t9.MousePosition.Y / AbsoluteSize.Y
    for i = #t9.Particles, 1, -1 do
        local frame = t9.Particles[i]
        if frame and frame.frame and frame.frame.Parent then
            local pos = frame.frame.Position
            local age = tick() - frame.created
            if pos.Y.Scale < -0.3 or frame.lifetime < age then
                frame.frame:Destroy()
                table.remove(t9.Particles, i)
            else
                local dist = math.sqrt((pos.X.Scale - v154) ^ 2 + (pos.Y.Scale - mouseY) ^ 2)
                local force = 0.08
                local fx, fy = 0, 0
                if dist < 0.15 and dist > 0 then
                    force = (0.15 - dist) / 0.15 * force / frame.mass
                    fx = (pos.X.Scale - v154) / dist * force
                    fy = (pos.Y.Scale - mouseY) / dist * force
                end
                frame.repelForce.x = frame.repelForce.x * 0.85 + fx * 0.15
                frame.repelForce.y = frame.repelForce.y * 0.85 + fy * 0.15
                local newX = pos.X.Scale + frame.vx + frame.repelForce.x
                local newY = pos.Y.Scale + frame.vy + frame.repelForce.y
                newX = newX <= -0.2 and 1.2 or (newX >= 1.2 and -0.2 or newX)
                local wobble = tick() * 1.5 + frame.wobblePhase
                newX = newX + math.sin(wobble) * 0.002
                newY = newY + math.cos(wobble * 0.7) * 0.001
                newX = newX + (math.random() - 0.5) * 0.0008
                newY = newY + (math.random() - 0.5) * 0.0005
                frame.rotation = frame.rotation + frame.rotationSpeed
                frame.frame.Rotation = frame.rotation
                local pulse = math.sin(tick() * 2.5 + frame.pulsePhase) * 0.1 + 1
                pulse = frame.originalSize * pulse
                frame.frame.Size = UDim2.new(0, pulse, 0, pulse)
                pulse = math.sin(tick() * 3 + frame.pulsePhase) * 0.1
                pulse = math.max(0.5, math.min(0.95, frame.originalTransparency + pulse))
                frame.frame.BackgroundTransparency = pulse
                age = age >= 0.2 and 0.9 or 0.7 + age / 0.2 * 0.2
                frame.glow.BackgroundTransparency = age
                age = math.sin(tick() * 4 + frame.pulsePhase) * 0.2 + 0.3
                frame.highlight.BackgroundTransparency = age
                frame.vx = frame.vx * 0.995
                frame.vy = frame.vy * 0.998
                frame.frame.Position = UDim2.new(newX, 0, newY, 0)
            end
        else
            table.remove(t9.Particles, i)
        end
    end
end

-- ============================================================
-- UI HELPERS
-- ============================================================
local function v164(p41, p42, p43)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 8, 1, 8)
    Frame.Position = UDim2.new(0, -4, 0, -4)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = p41.ZIndex - 1
    Frame.Visible = false
    Frame.Parent = p41
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 14)
    UICorner.Parent = Frame
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = t8.NeonWhite
    UIStroke.Thickness = 2
    UIStroke.Transparency = 0.3
    UIStroke.Parent = Frame
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, t8.NeonWhite),
        ColorSequenceKeypoint.new(0.5, t8.NeonGlow),
        ColorSequenceKeypoint.new(1, t8.NeonWhite),
    })
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.2, 0.1),
        NumberSequenceKeypoint.new(0.8, 0.1),
        NumberSequenceKeypoint.new(1, 0.8),
    })
    UIGradient.Parent = UIStroke
    local spinTween = nil
    local btnId = tostring(p41)
    p41.MouseEnter:Connect(function()
        t9.FocusStates.ButtonHovered[btnId] = true
        Frame.Visible = true
        t1.TweenService:Create(p41, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = p42,
        }):Play()
        t1.TweenService:Create(UIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Transparency = 0.1,
        }):Play()
        if spinTween then spinTween:Cancel() end
        spinTween = t1.TweenService:Create(UIGradient, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
            Rotation = 360,
        })
        spinTween:Play()
    end)
    p41.MouseLeave:Connect(function()
        t9.FocusStates.ButtonHovered[btnId] = false
        t1.TweenService:Create(p41, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = p43,
        }):Play()
        t1.TweenService:Create(UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Transparency = 0.8,
        }):Play()
        if spinTween then
            spinTween:Cancel()
            UIGradient.Rotation = 0
        end
        task.spawn(function()
            task.wait(0.3)
            if Frame and Frame.Parent then
                Frame.Visible = false
            end
        end)
    end)
    return { Frame, UIStroke, UIGradient }
end

local function v175(p44, p45, p46)
    if not t10.Status then return end
    t10.Status.Text = p44
    if p46 then
        t10.Status.TextColor3 = t8.Success
    elseif p45 then
        t10.Status.TextColor3 = t8.Error
    else
        t10.Status.TextColor3 = t8.Warning
    end
    t10.Status.TextTransparency = 1
    t1.TweenService:Create(t10.Status, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        TextTransparency = 0,
    }):Play()
end

local function v177()
    if not t10.Status then return end
    t1.TweenService:Create(t10.Status, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        TextTransparency = 1,
    }):Play()
end

local function v179(p47)
    t9.IsLoading = p47
    if not t10.Buttons then return end
    t10.Buttons.Loading.Container.Visible = p47
    t10.Buttons.Submit.Text = p47 and "" or "Verify Access Key"
    if p47 then
        local tw = t1.TweenService:Create(t10.Buttons.Loading.Spinner,
            TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
            { Rotation = 360 })
        tw:Play()
        t9.Animations.SpinTween = tw
    else
        if t9.Animations.SpinTween then
            t9.Animations.SpinTween:Cancel()
            t10.Buttons.Loading.Spinner.Rotation = 0
        end
    end
end

local function v181()
    if not t10.Input then return end
    local len = string.len(t10.Input.TextBox.Text)
    t10.Input.Counter.Text = len .. "/" .. t2.MaxKeyLength
    if len >= t2.MaxKeyLength then
        t10.Input.Counter.TextColor3 = t8.Error
    elseif len >= t2.MaxKeyLength * 0.8 then
        t10.Input.Counter.TextColor3 = t8.Warning
    else
        t10.Input.Counter.TextColor3 = t8.TextSecondary
    end
end

local function v183(p48, p49)
    pcall(function()
        if setclipboard then
            setclipboard(p48)
            v175(p49, false, true)
        else
            v175("Link: " .. p48, false, true)
        end
    end)
end

local function v184()
    if t9.IsLoading then return end
    local Text = t10.Input.TextBox.Text
    if Text == "" then
        v175("Please enter an access key.", true)
        t10.Input.TextBox:CaptureFocus()
        return
    end
    v179(true)
    v175("Verifying key...", false, false)
    task.spawn(function()
        local ok, msg = v94(Text)
        if ok then
            v175("Key verified! Loading script...", false, true)
            pcall(v79, "Key Verified", {
                { name = "🔑 Key", value = "`" .. string.sub(Text, 1, 25) .. "...`", inline = false },
            })
            task.wait(0.5)
            local loaded, loadErr = v99()
            if loaded then
                pcall(v79, "Script Executed", {})
                t9.IsDestroyed = true
                if t10.ScreenGui then t10.ScreenGui:Destroy() end
            else
                v175("Script failed: " .. tostring(loadErr), true)
                v179(false)
            end
        else
            v175(tostring(msg), true)
            v179(false)
            if t3.LogFailedKey then
                pcall(v79, "Failed Key", {
                    { name = "🔑 Tentative", value = "`" .. string.sub(Text, 1, 25) .. "...`", inline = true },
                    { name = "❌ Raison",    value = tostring(msg), inline = false },
                })
            end
        end
    end)
end

local function v186()
    t1.UserInputService.InputChanged:Connect(function(input, _)
        if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        t9.MousePosition.X = input.Position.X
        t9.MousePosition.Y = input.Position.Y
    end)

    t10.Input.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        local Text = t10.Input.TextBox.Text
        if string.len(Text) > t2.MaxKeyLength then
            t10.Input.TextBox.Text = string.sub(Text, 1, t2.MaxKeyLength)
            v175("Maximum character limit reached (" .. t2.MaxKeyLength .. ")", true)
        end
        v181()
    end)

    local glowTween = nil
    t10.Input.TextBox.Focused:Connect(function()
        t9.FocusStates.InputFocused = true
        t10.Input.Glow.Frame.Visible = true
        t1.TweenService:Create(t10.Input.Stroke, TweenInfo.new(0.2), {
            Color = t8.NeonWhite, Transparency = 0.1,
        }):Play()
        t1.TweenService:Create(t10.Input.Glow.Stroke, TweenInfo.new(0.2), {
            Transparency = 0.1,
        }):Play()
        if glowTween then glowTween:Cancel() end
        glowTween = t1.TweenService:Create(t10.Input.Glow.Gradient,
            TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
            { Rotation = 360 })
        glowTween:Play()
        t9.Animations.InputGlowTween = glowTween
        v177()
    end)

    t10.Input.TextBox.FocusLost:Connect(function()
        t9.FocusStates.InputFocused = false
        t1.TweenService:Create(t10.Input.Stroke, TweenInfo.new(0.2), {
            Color = t8.Border, Transparency = 0.3,
        }):Play()
        t1.TweenService:Create(t10.Input.Glow.Stroke, TweenInfo.new(0.3), {
            Transparency = 0.8,
        }):Play()
        if glowTween then
            glowTween:Cancel()
            t10.Input.Glow.Gradient.Rotation = 0
        end
        task.spawn(function()
            task.wait(0.3)
            if t10.Input.Glow.Frame and t10.Input.Glow.Frame.Parent then
                t10.Input.Glow.Frame.Visible = false
            end
        end)
    end)

    t1.UserInputService.InputBegan:Connect(function(input, processed)
        if processed or t9.IsDestroyed then return end
        if input.KeyCode ~= Enum.KeyCode.Return then return end
        if not t10.Input.TextBox:IsFocused() then return end
        v184()
    end)

    t10.Buttons.Submit.MouseButton1Click:Connect(v184)

    t10.Buttons.GetKey.MouseButton1Click:Connect(function()
        v175("Fetching key link...", false, false)
        task.spawn(function()
            local ok, url = v83()
            if ok then
                v183(url, "Platoboost link copied!")
            else
                v175(url or "Failed to get link.", true)
            end
        end)
    end)

    t10.Buttons.Discord.MouseButton1Click:Connect(function()
        v175("Opening Discord invite...", false, false)
        v183(t2.DiscordUrl, "Discord link copied to clipboard!")
    end)
end

local function v196()
    t9.FocusStates.AnimationsActive = true

    -- Spawn particles
    task.spawn(function()
        for _ = 1, 25 do
            if t9.IsDestroyed or not t10.ScreenGui.Parent then return end
            v146()
            task.wait(math.random(20, 100) / 1000)
        end
        while not t9.IsDestroyed and t10.ScreenGui.Parent do
            if #t9.Particles < t2.ParticleCount then v146() end
            task.wait(math.random(400, 1200) / 1000)
        end
    end)

    -- Update particles
    task.spawn(function()
        while not t9.IsDestroyed and t10.ScreenGui.Parent do
            pcall(v152)
            task.wait(1 / t2.ParticleSpeed)
        end
    end)

    -- Animated border
    task.spawn(function()
        while not t9.IsDestroyed and t10.AnimatedBorder and t10.AnimatedBorder.Frame.Parent do
            if t9.Animations.BorderTween then
                t9.Animations.BorderTween:Cancel()
            end
            local rot = t10.AnimatedBorder.Gradient.Rotation
            local tw = t1.TweenService:Create(t10.AnimatedBorder.Gradient,
                TweenInfo.new(4, Enum.EasingStyle.Linear), { Rotation = rot + 360 })
            t9.Animations.BorderTween = tw
            tw:Play()
            local ok = pcall(function() tw.Completed:Wait() end)
            if not ok then task.wait(4) end
            if t10.AnimatedBorder and t10.AnimatedBorder.Gradient and t10.AnimatedBorder.Gradient.Parent then
                t10.AnimatedBorder.Gradient.Rotation = t10.AnimatedBorder.Gradient.Rotation % 360
            end
            task.wait(0.1)
        end
    end)

    -- Icon glow
    task.spawn(function()
        while not t9.IsDestroyed and t10.Header and t10.Header.IconGlow and t10.Header.IconGlow.Parent do
            if t9.Animations.IconTween then
                t9.Animations.IconTween:Cancel()
            end
            local rot = t10.Header.IconGlow.Rotation
            t9.Animations.IconTween = t1.TweenService:Create(t10.Header.IconGlow,
                TweenInfo.new(3, Enum.EasingStyle.Linear), { Rotation = rot + 360 })
            t9.Animations.IconTween:Play()
            local ok = pcall(function() t9.Animations.IconTween.Completed:Wait() end)
            if not ok then task.wait(3) end
            if t10.Header and t10.Header.IconGlow and t10.Header.IconGlow.Parent then
                t10.Header.IconGlow.Rotation = t10.Header.IconGlow.Rotation % 360
            end
            task.wait(0.1)
        end
    end)
end

local function v209()
    t10.Container.Size = UDim2.new(0, 0, 0, 0)
    t10.Container.BackgroundTransparency = 1
    t10.Backdrop.BackgroundTransparency = 1
    t1.TweenService:Create(t10.Backdrop, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 0.1,
    }):Play()
    task.wait(0.1)
    t1.TweenService:Create(t10.Container,
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 420, 0, 600), BackgroundTransparency = 0 }):Play()
    task.wait(0.5)
    t10.Input.TextBox:CaptureFocus()
end

-- ============================================================
-- MAIN
-- ============================================================
local function main()
    local gui = createScreenGui()
    createFrame7(createFrame(gui))
    local container = createFrame2(gui)
    createFrame3(container)
    createFrame4(container)
    local content = createFrame5(container)
    createFrame6(content)
    v134(content)
    createTextLabel(content)

    v164(t10.Buttons.Submit, t8.HoverPrimary, t8.Primary)
    v164(t10.Buttons.GetKey, t8.HoverGetKey, t8.GetKey)
    v164(t10.Buttons.Discord, t8.HoverDiscord, t8.Discord)

    v181()
    v186()
    v196()
    StartGameWatcher(5) -- ⬅️ watcher de changements de jeu
    v209()

    -- Footer
    local footer = Instance.new("TextLabel", t10.Container)
    footer.Size = UDim2.new(1, -20, 0, 16)
    footer.Position = UDim2.new(0, 10, 1, -22)
    footer.BackgroundTransparency = 1
    footer.Text = "By verifying a key, your Roblox username is logged for security."
    footer.TextColor3 = Color3.fromRGB(100, 100, 110)
    footer.TextSize = 10
    footer.Font = Enum.Font.Gotham
    footer.TextXAlignment = Enum.TextXAlignment.Center
    footer.ZIndex = 111

    if t3.LogHubOpened then
        pcall(v79, "Hub Opened", {})
    end

    -- Auto-login si clé sauvegardée
    if type(isfile) ~= "function" or type(readfile) ~= "function" then return end
    if not isfile(t2.KeyFileName) then return end
    local savedKey = readfile(t2.KeyFileName)
    if not (savedKey and savedKey ~= "") then return end

    v175("Found saved key, verifying...", false, false)
    t10.Input.TextBox.Text = savedKey
    v181()

    task.spawn(function()
        local ok, msg = v94(savedKey)
        if ok then
            v175("Auto-login success!", false, true)
            pcall(v79, "Auto-Login", {
                { name = "🔑 Key Used", value = "`" .. string.sub(savedKey, 1, 25) .. "...`", inline = false },
            })
            task.wait(0.8)
            local loaded, loadErr = v99()
            if loaded then
                pcall(v79, "Script Executed", {})
                t9.IsDestroyed = true
                if t10.ScreenGui then t10.ScreenGui:Destroy() end
            else
                v175("Script failed: " .. tostring(loadErr), true)
            end
        else
            v175("Saved key invalid: " .. tostring(msg), true)
        end
    end)
end

-- ============================================================
-- 📌 ENREGISTREMENT DES JEUX
-- Ajoute tes jeux ici. PlaceId → https://www.roblox.com/games/PLACEID
-- ============================================================

-- Example : Blox Fruits
-- RegisterGame(2753915549, {
--     name     = "Blox Fruits",
--     version  = "1.0.0",
--     verified = true,
--     features = { "autoFarm", "autoQuest" },
--     -- scriptUrl = "https://raw.githubusercontent.com/toi/repo/main/bloxfruits.lua",
--     onLoad = function(profile)
--         _G.AutoFarm = function() print("AutoFarm activé") end
--         _G.AutoQuest = function() print("AutoQuest activé") end
--     end,
--     onUnload = function()
--         _G.AutoFarm = nil
--         _G.AutoQuest = nil
--     end,
-- })

-- Example : BedWars
-- RegisterGame(6872265039, {
--     name     = "BedWars",
--     version  = "1.0.0",
--     features = { "autoKill", "autoBridge" },
--     onLoad = function()
--         _G.AutoKill   = function() print("AutoKill activé") end
--         _G.AutoBridge = function() print("AutoBridge activé") end
--     end,
-- })

-- ============================================================
-- EXECUTION
-- ============================================================
local ok, err = pcall(main)
if ok then
    print("[DexaHub] Loaded OK")
else
    warn("[DexaHub] FATAL: " .. tostring(err))
    print("[DexaHub] FATAL: " .. tostring(err))
end
