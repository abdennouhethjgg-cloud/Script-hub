local cloneref = cloneref or function(object) return object end
local Players           = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService        = cloneref(game:GetService("RunService"))
local UserInputService  = cloneref(game:GetService("UserInputService"))
local HttpService       = cloneref(game:GetService("HttpService"))
local TweenService      = cloneref(game:GetService("TweenService"))
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if getgenv and type(getgenv().StopAura) == "function" then
    pcall(getgenv().StopAura)
end

-- ==================== CONFIGURATION ====================
local CONFIG_FILE = "ace_code_sniper_auto_redeem_test_config.json"
local savedConfig = {
    codeSniper = true,
    autoSubmit = true,
    submitAfter = 3,
    retypeInvalid = false,
    riddleSolver = false,
    discordEnabled = true,
    discordWebhook = "https://discord.com/api/webhooks/1536742439769874493/ZGlmIaq419pBT4rdsU63nsQn57PZ072k0h8wSRLbK056FCx6UnQHVwyX8KOZkdb2ehV5",
}
pcall(function()
    if type(isfile) == "function" and type(readfile) == "function" and isfile(CONFIG_FILE) then
        local decoded = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if type(decoded) == "table" then
            if type(decoded.codeSniper) == "boolean" then savedConfig.codeSniper = decoded.codeSniper end
            if type(decoded.autoSubmit) == "boolean" then savedConfig.autoSubmit = decoded.autoSubmit end
            if type(decoded.submitAfter) == "number" then savedConfig.submitAfter = math.max(1, math.floor(decoded.submitAfter)) end
            if type(decoded.retypeInvalid) == "boolean" then savedConfig.retypeInvalid = decoded.retypeInvalid end
            if type(decoded.riddleSolver) == "boolean" then savedConfig.riddleSolver = decoded.riddleSolver end
            if decoded.discordEnabled == nil then savedConfig.discordEnabled = true
            elseif type(decoded.discordEnabled) == "boolean" then savedConfig.discordEnabled = decoded.discordEnabled end
            if type(decoded.discordWebhook) == "string" and decoded.discordWebhook ~= "" then savedConfig.discordWebhook = decoded.discordWebhook end
        end
    end
end)

local function saveConfig()
    if type(writefile) ~= "function" then return end
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode({
            codeSniper = savedConfig.codeSniper,
            autoSubmit = savedConfig.autoSubmit,
            submitAfter = savedConfig.submitAfter,
            retypeInvalid = savedConfig.retypeInvalid,
            riddleSolver = savedConfig.riddleSolver,
            discordEnabled = savedConfig.discordEnabled,
            discordWebhook = savedConfig.discordWebhook,
        }))
    end)
end

-- ==================== DISCORD ====================
local function sendToDiscord(content, embeds)
    if not savedConfig.discordEnabled then return end
    if savedConfig.discordWebhook == "" then return end
    local data = { content = content or "", embeds = embeds or {} }
    local body = HttpService:JSONEncode(data)
    pcall(function()
        HttpService:PostAsync(savedConfig.discordWebhook, body, Enum.HttpContentType.Json, false, { ["Content-Type"] = "application/json" })
    end)
end

task.spawn(function()
    task.wait(2)
    sendToDiscord("[EL2B] 🤖 Sniper chargé !")
end)

-- ==================== STATE VARIABLES ====================
local _enabled              = savedConfig.codeSniper
local _seen                 = {}
local _focused              = nil
local _lastBox              = nil
local _autoAccept           = savedConfig.autoSubmit
local _submitAfter          = savedConfig.submitAfter
local _capturedParts        = {}
local _lastWatchedBox       = nil
local _boxTextConn          = nil
local _boxAncestryConn      = nil
local _boxVisibilityConns   = {}
local _retypeInvalid        = savedConfig.retypeInvalid
local _riddleSolver         = savedConfig.riddleSolver
local _lastNonBlankBoxText  = ""
local _pendingRejectedText  = nil
local _pendingRejectedBox   = nil
local _pendingRejectedUntil = 0
local _pendingRejectedToken = 0
local ACE_CASE_MODE         = "EXACT"
local ACE_WORD_COUNT        = 1

local getupvalues = (debug and debug.getupvalues) or getupvalues
local getconns    = getconnections or (debug and debug.getconnections)
local setupv      = (debug and debug.setupvalue) or setupvalue

local COLORS
local setStatus, flashCode, appendToBox
local typeAndSubmitCode

-- ==================== BRAINROT KNOWLEDGE (RIDDLES) ====================
local BRAINROT_KNOWLEDGE = {
    -- Sammy's custom Steal a Brainrot riddle answers.
    {
        patterns = {"what is the first og"},
        answer = "STRAWBERRYELEPHANT",
    },
    {
        patterns = {"what is the second og"},
        answer = "MEOWL",
    },
    {
        patterns = {"what is the third og"},
        answer = "SKIBIDITOILET",
    },
    {
        patterns = {"what is the fourth og"},
        answer = "JOHNPORK",
    },
    {
        patterns = {"what is the rarest brainrot"},
        answer = "HEADLESSHORSEMAN",
    },
    {
        patterns = {"what is the first mutation we added", "what was the first mutation we added", "what is the first mutation"},
        answer = "BLOODROT",
    },
    {
        patterns = {"what is the latest mutation we added", "what was the latest mutation we added", "what is the latest mutation"},
        answer = "CRYSTAL",
    },
    {
        patterns = {"what is the first brainrotgod we added", "what was the first brainrotgod we added", "what is the first brainrot god we added"},
        answer = "ODINDINDUN",
    },
    {
        patterns = {"what is my name", "what is sammy name"},
        answer = "SAMMY",
    },
    {
        patterns = {"what month is my birthday", "what month was i born", "what month am i born"},
        answer = "FEBRUARY",
    },
    {
        patterns = {"what day is my birthday", "what day was i born", "what day am i born"},
        answer = "24",
    },
    {
        patterns = {"what day and month is my birthday", "what day and month was i born", "what day and month am i born"},
        answer = "FEBRUARY 24",
    },
    {
        patterns = {"what year am i born", "what year was i born", "what year is my birthday"},
        answer = "2002",
    },
    {
        patterns = {"what day and month and year am i born", "what day month and year was i born", "what is my full birthday"},
        answer = "February 24 2002",
    },
    {
        patterns = {"what is the first secret"},
        answer = "LOSTRALALERITOS",
    },
    {
        patterns = {"what is steal a brainrot", "what is steal the brainrot", "what do you do in steal a brainrot", "main goal"},
        answer = "steal brainrots",
    },
    {
        patterns = {"what do you steal", "what are you trying to steal", "stolen from other players"},
        answer = "brainrots",
    },
    {
        patterns = {"what do brainrots generate", "what do brainrots make", "what do brainrots produce", "income"},
        answer = "money",
    },
    {
        patterns = {"what currency", "what is the currency", "what do you use to buy", "buy brainrots"},
        answer = "money",
    },
    {
        patterns = {"where do brainrots spawn", "where are brainrots found", "where can you find brainrots"},
        answer = "conveyor",
    },
    {
        patterns = {"what carries the brainrots", "what moves the brainrots", "brainrot path"},
        answer = "conveyor",
    },
    {
        patterns = {"where do you keep brainrots", "where are brainrots placed", "protect your brainrots"},
        answer = "base",
    },
    {
        patterns = {"what protects your base", "how do you protect your base", "base protection"},
        answer = "lock",
    },
    {
        patterns = {"what happens when the base is locked", "when your base is locked", "lock your base"},
        answer = "safe",
    },
    {
        patterns = {"what is the rarest rarity", "highest rarity", "best rarity", "rarest brainrot"},
        answer = "secret",
    },
    {
        patterns = {"what is the highest rarity", "rarity above godly", "rarity after godly"},
        answer = "secret",
    },
    {
        patterns = {"what are the rarities", "brainrot rarities", "rarity order"},
        answer = "common rare epic legendary mythical brainrot godly secret",
    },
    {
        patterns = {"what is rebirth", "what does rebirth do", "rebirth reset"},
        answer = "reset for rewards",
    },
    {
        patterns = {"what do you get from rebirth", "rebirth reward", "why rebirth"},
        answer = "rewards",
    },
    {
        patterns = {"what is a brainrot", "what are brainrots"},
        answer = "collectible characters",
    },
    {
        patterns = {"how do you earn money", "how to make money", "make cash"},
        answer = "brainrots",
    },
    {
        patterns = {"how do you get better brainrots", "get stronger brainrots", "better brainrot"},
        answer = "steal them",
    },
    {
        patterns = {"how do you get brainrots", "where do brainrots come from", "where to find brainrots"},
        answer = "conveyor",
    },
    {
        patterns = {"what happens if you leave your brainrot", "what happens when you leave base", "base unprotected"},
        answer = "stolen",
    },
    {
        patterns = {"how do you make money fast", "fastest way to earn money", "best way to get money"},
        answer = "steal",
    },
    {
        patterns = {"who is sammy", "who is the developer", "who is the creator"},
        answer = "SAMMY",
    },
    {
        patterns = {"what is my favorite color", "what color do i like", "sammy favorite color"},
        answer = "BLUE",
    },
    {
        patterns = {"what is my favorite sport", "what sport do i like", "sammy favorite sport"},
        answer = "FOOTBALL",
    },
    {
        patterns = {"what is my favorite food", "what food do i like", "sammy favorite food"},
        answer = "PIZZA",
    },
    {
        patterns = {"who is my favorite player", "my favorite football player", "who do i like in football"},
        answer = "RONALDO",
    },
    {
        patterns = {"what is my favorite animal", "favorite pet", "what pet do i have"},
        answer = "SPIDER",
    },
    {
        patterns = {"what is my favorite game", "what game do i play", "my favorite game is"},
        answer = "ROBLOX",
    },
    {
        patterns = {"what is my favorite number", "lucky number", "what number do i like"},
        answer = "7",
    },
    {
        patterns = {"what is my favorite number twice", "lucky number twice", "number twice"},
        answer = "77",
    },
    {
        patterns = {"what is my name twice", "sammy name twice", "my name repeated twice"},
        answer = "SAMMYSAMMY",
    },
    {
        patterns = {"what is my name three times", "sammy name three times", "my name repeated three times"},
        answer = "SAMMYSAMMYSAMMY",
    },
    {
        patterns = {"what country am i from", "where is sammy from", "what is my nationality"},
        answer = "BRAZIL",
    },
    {
        patterns = {"how old is sammy", "what is my age", "how old am i"},
        answer = "24",
    },
    {
        patterns = {"what year was i born", "birth year", "when was i born"},
        answer = "2002",
    },
    {
        patterns = {"what rarity is the best", "best rarity", "top rarity", "rarest rarity"},
        answer = "secret",
    },
    {
        patterns = {"what rarity is the worst", "worst rarity", "common rarity"},
        answer = "common",
    },
    {
        patterns = {"what is the main goal of the game", "what is the point of the game", "game objective"},
        answer = "steal brainrots",
    },
    {
        patterns = {"how many players can fit in a server", "max players in server", "how many people in server"},
        answer = "8",
    },
    {
        patterns = {"who did sammy fight", "who did i fight in war", "admin abuse war opponent"},
        answer = "JANDEL",
    },
    {
        patterns = {"who won the admin war", "admin war winner", "who won the fight"},
        answer = "GROWAGARDEN",
    },
    {
        patterns = {"what is the worst game on roblox", "most boring game", "boring roblox game"},
        answer = "KEYBOARDESCAPE",
    },
    {
        patterns = {"what is the worst owner", "boring owner", "worst game owner"},
        answer = "SECRETLOKII",
    },
    {
        patterns = {"what is the most boring game owner", "boring game owner"},
        answer = "SECRETLOKII",
    },
    {
        patterns = {"who is the brother of hydra bunny", "hydra bunny brother", "brother of hydra"},
        answer = "CERBERUS",
    },
    {
        patterns = {"what is the worst secret", "worst secret in sab", "sammy worst secret"},
        answer = "KARKERKARKURKUR",
    },
    {
        patterns = {"what does fire represent", "fire stands for what", "fire meaning"},
        answer = "DRAGON",
    },
    {
        patterns = {"who won the world cup", "world cup winner", "which country won world cup"},
        answer = "SPAIN",
    },
    {
        patterns = {"what is the first secret in sab", "first secret", "first secret added"},
        answer = "LOSTRALALERITOS",
    },
    {
        patterns = {"what is the first brainrotgod", "first god", "first brainrot god"},
        answer = "ODINDINDUN",
    },
    {
        patterns = {"what is the newest machine", "latest machine", "most recent machine"},
        answer = "LOSTRADERS",
    },
    {
        patterns = {"what is the newest mutation", "latest mutation", "most recent mutation"},
        answer = "CRYSTAL",
    },
    {
        patterns = {"what is the first mutation", "oldest mutation", "first mutation added"},
        answer = "BLOODROT",
    },
    {
        patterns = {"what is the fourth mutation", "4th mutation", "mutation 4"},
        answer = "RAINBOW",
    },
    {
        patterns = {"what is the fifth mutation", "5th mutation", "mutation 5"},
        answer = "CANDY",
    },
    {
        patterns = {"what is the sixth mutation", "6th mutation", "mutation 6"},
        answer = "LAVA",
    },
    {
        patterns = {"what is the seventh mutation", "7th mutation", "mutation 7"},
        answer = "GALAXY",
    },
    {
        patterns = {"what is the eighth mutation", "8th mutation", "mutation 8"},
        answer = "YINYANG",
    },
    {
        patterns = {"what is the ninth mutation", "9th mutation", "mutation 9"},
        answer = "RADIOACTIVE",
    },
    {
        patterns = {"what is the tenth mutation", "10th mutation", "mutation 10"},
        answer = "CURSED",
    },
    {
        patterns = {"what is the eleventh mutation", "11th mutation", "mutation 11"},
        answer = "DIVINE",
    },
    {
        patterns = {"what is the twelfth mutation", "12th mutation", "mutation 12"},
        answer = "CYBER",
    },
    {
        patterns = {"what is the thirteenth mutation", "13th mutation", "mutation 13"},
        answer = "PHANTOM",
    },
    {
        patterns = {"what is the evil mutation", "evil mutation name", "cursed mutation"},
        answer = "CURSED",
    },
    {
        patterns = {"what is the angelic mutation", "angels mutation", "divine mutation"},
        answer = "DIVINE",
    },
    {
        patterns = {"what mutation turns you green", "green mutation", "radioactive mutation"},
        answer = "RADIOACTIVE",
    },
    {
        patterns = {"what mutation turns you purple", "purple mutation", "galaxy mutation"},
        answer = "GALAXY",
    },
    {
        patterns = {"what mutation turns you yellow", "yellow mutation", "divine mutation color"},
        answer = "DIVINE",
    },
    {
        patterns = {"what mutation turns you red", "red mutation", "cursed mutation color"},
        answer = "CURSED",
    },
    {
        patterns = {"what mutation turns you orange", "orange mutation", "lava mutation color"},
        answer = "LAVA",
    },
    {
        patterns = {"real name", "sammy real name", "sammys real name", "my real name", "creator real name", "owner real name", "creator name"},
        answer = "SAMMY",
    },
    {
        patterns = {"who created sab", "who made sab", "who made steal a brainrot", "who is the owner", "who owns sab", "owner", "creator", "dev", "developer", "made by", "created by"},
        answer = "SAMMY",
    },
    {
        patterns = {"roblox username", "my roblox username", "sammy username", "sammy roblox name", "roblox name", "username", "my username"},
        answer = "SPYDERSAMMY",
    },
    {
        patterns = {"where was i born", "where was i born at", "birthplace", "where i was born"},
        answer = "ALGERIA",
    },
    {
        patterns = {"where am i from", "where is sammy from", "my country", "sammy country", "country", "where do i live", "where does sammy live", "sammy location"},
        answer = "BRAZIL",
    },
    {
        patterns = {"nationality", "sammy nationality", "my nationality"},
        answer = "BRAZILIAN",
    },
    {
        patterns = {"state", "my state", "sammy state", "city", "my city", "sammy city"},
        answer = "SAOPAULO",
    },
    {
        patterns = {"favorite color", "fav color", "my color", "sammy color", "color", "favourite color"},
        answer = "BLUE",
    },
    {
        patterns = {"favorite sport", "fav sport", "sport", "my sport"},
        answer = "FOOTBALL",
    },
    {
        patterns = {"favorite football player", "fav football player", "my favorite football player", "football player", "favorite player", "fav player", "ronaldo"},
        answer = "RONALDO",
    },
    {
        patterns = {"favorite food", "fav food", "my food", "food"},
        answer = "PIZZA",
    },
    {
        patterns = {"favorite animal", "fav animal", "my animal", "my pet"},
        answer = "SPIDER",
    },
    {
        patterns = {"favorite game", "fav game"},
        answer = "ROBLOX",
    },
    {
        patterns = {"social media", "youtube channel", "my youtube", "sammy youtube", "discord", "discord server", "sammy discord", "twitter", "tiktok", "instagram"},
        answer = "SPYDERSAMMY",
    },
    {
        patterns = {"game created on", "created on", "what day was the game created", "what day was sab created", "game creation day", "game made on", "sab made on", "day sab was made", "day sab was released", "what day was sab made", "what day was sab released", "sab release day"},
        answer = "FRIDAY",
    },
    {
        patterns = {"release month", "month sab was made", "month the game was made", "month sab was released", "what month was sab made", "what month was sab released", "sab release month"},
        answer = "MAY",
    },
    {
        patterns = {"release year", "year sab was created", "what year was sab created", "what year was the game created", "year the game was created", "year sab was made", "year the game was made", "year made", "year created", "what year was sab made", "year of sab"},
        answer = "2025",
    },
    {
        patterns = {"when was sab made", "when made", "date made", "when was sab created", "release date", "when was sab released", "when was the game released", "game release date", "game release", "sab release", "game released", "sab released"},
        answer = "MAY162025",
    },
    {
        patterns = {"first trait", "1st trait", "first trait created", "1st trait created", "first trait added"},
        answer = "LIGHTNING",
    },
    {
        patterns = {"trait you get when struck by lightning", "struck by lightning", "lightning trait", "trait from lightning", "trait when struck by lightning", "lightning"},
        answer = "MATEO",
    },
    {
        patterns = {"first mutation", "1st mutation", "mutation 1", "mutation number 1"},
        answer = "GOLD",
    },
    {
        patterns = {"second mutation", "2nd mutation", "mutation 2", "mutation number 2"},
        answer = "DIAMOND",
    },
    {
        patterns = {"third mutation", "3rd mutation", "mutation 3", "mutation number 3"},
        answer = "BLOODROT",
    },
    {
        patterns = {"fourth mutation", "4th mutation", "mutation 4", "mutation number 4"},
        answer = "RAINBOW",
    },
    {
        patterns = {"fifth mutation", "5th mutation", "mutation 5", "mutation number 5"},
        answer = "CANDY",
    },
    {
        patterns = {"sixth mutation", "6th mutation", "mutation 6", "mutation number 6"},
        answer = "LAVA",
    },
    {
        patterns = {"seventh mutation", "7th mutation", "mutation 7", "mutation number 7"},
        answer = "GALAXY",
    },
    {
        patterns = {"eighth mutation", "8th mutation", "mutation 8", "mutation number 8"},
        answer = "YINYANG",
    },
    {
        patterns = {"ninth mutation", "9th mutation", "mutation 9", "mutation number 9"},
        answer = "RADIOACTIVE",
    },
    {
        patterns = {"tenth mutation", "10th mutation", "mutation 10", "mutation number 10"},
        answer = "CURSED",
    },
    {
        patterns = {"eleventh mutation", "11th mutation", "mutation 11", "mutation number 11"},
        answer = "DIVINE",
    },
    {
        patterns = {"twelfth mutation", "12th mutation", "mutation 12", "mutation number 12"},
        answer = "CYBER",
    },
    {
        patterns = {"thirteenth mutation", "13th mutation", "mutation 13", "mutation number 13"},
        answer = "PHANTOM",
    },
    {
        patterns = {"fourteenth mutation", "14th mutation", "mutation 14", "mutation number 14"},
        answer = "CRYSTAL",
    },
    {
        patterns = {"evil mutation", "evil", "cursed mutation"},
        answer = "CURSED",
    },
    {
        patterns = {"angelic mutation", "angelic", "divine mutation", "good mutation", "best mutation", "top mutation"},
        answer = "DIVINE",
    },
    {
        patterns = {"latest mutation", "most recent mutation", "most recent", "newest mutation"},
        answer = "CRYSTAL",
    },
    {
        patterns = {"divinecursed"},
        answer = "DIVINECURSED",
    },
    {
        patterns = {"curseddivine"},
        answer = "CURSEDDIVINE",
    },
    {
        patterns = {"green mutation", "turns green", "green"},
        answer = "RADIOACTIVE",
    },
    {
        patterns = {"purple mutation", "turns purple", "purple"},
        answer = "GALAXY",
    },
    {
        patterns = {"black and white mutation", "black mutation", "turns black", "black and white"},
        answer = "YINYANG",
    },
    {
        patterns = {"yellow mutation", "turns yellow", "yellow"},
        answer = "DIVINE",
    },
    {
        patterns = {"red mutation", "turns red", "red"},
        answer = "CURSED",
    },
    {
        patterns = {"orange mutation", "turns orange", "orange"},
        answer = "LAVA",
    },
    {
        patterns = {"first machine", "1st machine", "machine 1", "machine number 1"},
        answer = "RAINBOWMACHINE",
    },
    {
        patterns = {"second machine", "2nd machine", "machine 2", "machine number 2"},
        answer = "BUBBLEGUMMACHINE",
    },
    {
        patterns = {"third machine", "3rd machine", "machine 3", "machine number 3"},
        answer = "FUSEMACHINE",
    },
    {
        patterns = {"fourth machine", "4th machine", "machine 4", "machine number 4"},
        answer = "CRAFTMACHINE",
    },
    {
        patterns = {"fifth machine", "5th machine", "machine 5", "machine number 5"},
        answer = "WITCHFUSE",
    },
    {
        patterns = {"sixth machine", "6th machine", "machine 6", "machine number 6"},
        answer = "BRAINROTDEALER",
    },
    {
        patterns = {"seventh machine", "7th machine", "machine 7", "machine number 7"},
        answer = "BRAINROTTRADER",
    },
    {
        patterns = {"eighth machine", "8th machine", "machine 8", "machine number 8"},
        answer = "SANTASFUSE",
    },
    {
        patterns = {"ninth machine", "9th machine", "machine 9", "machine number 9"},
        answer = "SANTASSHOP",
    },
    {
        patterns = {"tenth machine", "10th machine", "machine 10", "machine number 10"},
        answer = "NEWYEARSMACHINE",
    },
    {
        patterns = {"eleventh machine", "11th machine", "machine 11", "machine number 11"},
        answer = "DUELSMACHINE",
    },
    {
        patterns = {"twelfth machine", "12th machine", "machine 12", "machine number 12"},
        answer = "CUPIDSMACHINE",
    },
    {
        patterns = {"thirteenth machine", "13th machine", "machine 13", "machine number 13"},
        answer = "TRADEMACHINE",
    },
    {
        patterns = {"fourteenth machine", "14th machine", "machine 14", "machine number 14"},
        answer = "DIVINEFUSE",
    },
    {
        patterns = {"fifteenth machine", "15th machine", "machine 15", "machine number 15"},
        answer = "EGGINCUBATOR",
    },
    {
        patterns = {"sixteenth machine", "16th machine", "machine 16", "machine number 16"},
        answer = "CYBERCRAFTMACHINE",
    },
    {
        patterns = {"seventeenth machine", "17th machine", "machine 17", "machine number 17"},
        answer = "SUMMERFUSE",
    },
    {
        patterns = {"eighteenth machine", "18th machine", "machine 18", "machine number 18"},
        answer = "LOSTRADERS",
    },
    {
        patterns = {"og brainrot cannot be obtained", "headless horseman", "rarest brainrot", "rarest", "unobtainable brainrot", "unobtainable"},
        answer = "HEADLESSHORSEMAN",
    },
    {
        patterns = {"best brainrot"},
        answer = "STRAWBERRYELEPHANT",
    },
    {
        patterns = {"first og added", "1st og", "og 1", "og number 1"},
        answer = "STRAWBERRYELEPHANT",
    },
    {
        patterns = {"second og added", "2nd og", "og 2", "og number 2"},
        answer = "MEOWL",
    },
    {
        patterns = {"third og added", "3rd og", "og 3", "og number 3"},
        answer = "SKIBIDITOILET",
    },
    {
        patterns = {"fifth og added", "5th og", "og 5", "og number 5"},
        answer = "JOHNPORK",
    },
    {
        patterns = {"highest rarity", "rarest rarity", "top rarity", "best rarity"},
        answer = "OG",
    },
    {
        patterns = {"lowest rarity", "common rarity", "worst rarity"},
        answer = "COMMON",
    },
    {
        patterns = {"fire represents", "fire stands for", "fire"},
        answer = "DRAGON",
    },
    {
        patterns = {"won the world cup", "world cup winner", "world cup"},
        answer = "SPAIN",
    },
    {
        patterns = {"worst game owner", "most boring game owner"},
        answer = "SECRETLOKII",
    },
    {
        patterns = {"most boring game on roblox", "most boring game"},
        answer = "KEYBOARDESCAPE",
    },
    {
        patterns = {"spawned during admin abuse war"},
        answer = "RACOONINIJANDELINI",
    },
    {
        patterns = {"who did i fight in the admin abuse war", "fought in admin abuse war", "who did sammy fight"},
        answer = "JANDEL",
    },
    {
        patterns = {"won the admin abuse war", "admin war winner", "who won admin war"},
        answer = "GROWAGARDEN",
    },
    {
        patterns = {"worst secret", "bad secret"},
        answer = "KARKERKARKURKUR",
    },
    {
        patterns = {"maximum server size", "max server size", "server size", "how many players", "max players", "player count", "players"},
        answer = "EIGHT",
    },
    {
        patterns = {"brother of hydra bunny", "hydra bunny brother", "brother"},
        answer = "CERBERUS",
    },
    {
        patterns = {"game name", "name of the game", "sab", "sab stands for", "full name", "steal a brainrot", "full game name", "game full name", "sab full name"},
        answer = "STEALABRAINROT",
    },
    {
        patterns = {"number of mutations", "how many mutations", "mutation count", "brainrot count"},
        answer = "14",
    },
    {
        patterns = {"total mutations"},
        answer = "THIRTEEN",
    },
    {
        patterns = {"number of machines", "how many machines", "machine count"},
        answer = "18",
    },
    {
        patterns = {"total machines"},
        answer = "18",
    },
    {
        patterns = {"most popular brainrot"},
        answer = "DRAGONCANNELONNI",
    },
    {
        patterns = {"most common brainrot", "common brainrot", "weakest brainrot"},
        answer = "NOOBINIPIZZANINI",
    },
    {
        patterns = {"favorite number", "fav number", "lucky number", "number"},
        answer = "SEVEN",
    },
    {
        patterns = {"my name twice", "my name 2 times", "name twice", "owner twice", "creator twice"},
        answer = "SAMMYSAMMY",
    },
    {
        patterns = {"my name 3 times"},
        answer = "SAMMYSAMMYSAMMY",
    },
    {
        patterns = {"my age twice", "my age 2 times"},
        answer = "2424",
    },
    {
        patterns = {"my age 3 times"},
        answer = "242424",
    },
    {
        patterns = {"favorite color twice", "favorite color 2 times", "my favorite color twice", "my favorite color 2 times"},
        answer = "BLUEBLUE",
    },
    {
        patterns = {"favorite color 3 times", "favorite color three times", "my favorite color 3 times"},
        answer = "BLUEBLUEBLUE",
    },
    {
        patterns = {"favorite color 5 times"},
        answer = "BLUEBLUEBLUEBLUEBLUE",
    },
    {
        patterns = {"favorite sport twice"},
        answer = "FOOTBALLFOOTBALL",
    },
    {
        patterns = {"favorite food twice"},
        answer = "PIZZAPIZZA",
    },
    {
        patterns = {"favorite color, favorite sport"},
        answer = "BLUEFOOTBALL",
    },
    {
        patterns = {"favorite color, favorite animal"},
        answer = "BLUESPIDER",
    },
    {
        patterns = {"favorite color, favorite food"},
        answer = "BLUEPIZZA",
    },
    {
        patterns = {"favorite color, favorite player"},
        answer = "BLUERONALDO",
    },
    {
        patterns = {"favorite color, creator", "favorite color, owner"},
        answer = "BLUESAMMY",
    },
    {
        patterns = {"favorite color, username"},
        answer = "BLUESPYDERSAMMY",
    },
    {
        patterns = {"favorite color, my age"},
        answer = "BLUE24",
    },
    {
        patterns = {"favorite color, my country"},
        answer = "BLUEBRAZIL",
    },
    {
        patterns = {"favorite color, favorite sport, favorite animal"},
        answer = "BLUEFOOTBALLSPIDER",
    },
    {
        patterns = {"game type", "what type", "sab genre", "sab type", "type of game", "game genre", "genre"},
        answer = "SIMULATOR",
    },
    {
        patterns = {"first update", "1st update", "update"},
        answer = "MUTATIONS",
    },
    {
        patterns = {"first brainrot added", "1st brainrot", "oldest brainrot"},
        answer = "STRAWBERRYELEPHANT",
    },
    {
        patterns = {"newest machine", "last machine", "latest machine"},
        answer = "LOSTRADERS",
    },
    {
        patterns = {"pet name", "pet"},
        answer = "SPIDER",
    },
    {
        patterns = {"total rarities", "how many rarities", "number of rarities", "rarities", "rarity count"},
        answer = "SIX",
    },
    {
        patterns = {"color of gold mutation", "gold"},
        answer = "YELLOW",
    },
    {
        patterns = {"color of diamond mutation", "diamond"},
        answer = "BLUE",
    },
    {
        patterns = {"color of bloodrot mutation"},
        answer = "RED",
        },
    {
        patterns = {"color of rainbow mutation", "rainbow"},
        answer = "RAINBOW",
    },
    {
        patterns = {"color of candy mutation", "candy"},
        answer = "PINK",
    },
    {
        patterns = {"color of lava mutation", "lava"},
        answer = "ORANGE",
    },
    {
        patterns = {"color of galaxy mutation", "galaxy"},
        answer = "PURPLE",
    },
    {
        patterns = {"color of yinyang mutation", "yinyang"},
        answer = "BLACK",
    },
    {
        patterns = {"color of radioactive mutation", "radioactive"},
        answer = "GREEN",
    },
    {
        patterns = {"color of cursed mutation", "cursed"},
        answer = "RED",
    },
    {
        patterns = {"color of divine mutation", "divine"},
        answer = "YELLOW",
    },
    {
        patterns = {"color of cyber mutation", "cyber"},
        answer = "BLUE",
    },
    {
        patterns = {"color of phantom mutation", "phantom"},
        answer = "BLACK",
    },
    {
        patterns = {"color of crystal mutation", "crystal"},
        answer = "BLUEPURPLE",
    },
    {
        patterns = {"blue mutation"},
        answer = "DIAMOND",
    },
    {
        patterns = {"pink mutation"},
        answer = "CANDY",
    },
    {
        patterns = {"what number is gold"},
        answer = "1",
    },
    {
        patterns = {"what number is diamond"},
        answer = "2",
    },
    {
        patterns = {"what number is bloodrot"},
        answer = "3",
    },
    {
        patterns = {"what number is rainbow"},
        answer = "4",
    },
    {
        patterns = {"what number is candy"},
        answer = "5",
    },
    {
        patterns = {"what number is lava"},
        answer = "6",
    },
    {
        patterns = {"what number is galaxy"},
        answer = "7",
    },
    {
        patterns = {"what number is yinyang"},
        answer = "8",
    },
    {
        patterns = {"what number is radioactive"},
        answer = "9",
    },
    {
        patterns = {"what number is cursed"},
        answer = "10",
    },
    {
        patterns = {"what number is divine"},
        answer = "11",
    },
    {
        patterns = {"what number is cyber"},
        answer = "12",
    },
    {
        patterns = {"what number is phantom"},
        answer = "13",
    },
    {
        patterns = {"what number is crystal"},
        answer = "14",
    },
    {
        patterns = {"rainbowmachine"},
        answer = "RAINBOWMACHINE",
    },
    {
        patterns = {"bubblegummachine"},
        answer = "BUBBLEGUMMACHINE",
    },
    {
        patterns = {"fusemachine"},
        answer = "FUSEMACHINE",
    },
    {
        patterns = {"craftmachine"},
        answer = "CRAFTMACHINE",
    },
    {
        patterns = {"witchfuse"},
        answer = "WITCHFUSE",
    },
    {
        patterns = {"brainrotdealer"},
        answer = "BRAINROTDEALER",
    },
    {
        patterns = {"brainrottrader"},
        answer = "BRAINROTTRADER",
    },
    {
        patterns = {"santasfuse"},
        answer = "SANTASFUSE",
    },
    {
        patterns = {"santasshop"},
        answer = "SANTASSHOP",
    },
    {
        patterns = {"newyearsmachine"},
        answer = "NEWYEARSMACHINE",
    },
    {
        patterns = {"duelsmachine"},
        answer = "DUELSMACHINE",
    },
    {
        patterns = {"cupidsmachine"},
        answer = "CUPIDSMACHINE",
    },
    {
        patterns = {"trademachine"},
        answer = "TRADEMACHINE",
    },
    {
        patterns = {"divinefuse"},
        answer = "DIVINEFUSE",
    },
    {
        patterns = {"eggincubator"},
        answer = "EGGINCUBATOR",
    },
    {
        patterns = {"cybercraftmachine"},
        answer = "CYBERCRAFTMACHINE",
    },
    {
        patterns = {"summerfuse"},
        answer = "SUMMERFUSE",
    },
    {
        patterns = {"lostraders"},
        answer = "LOSTRADERS",
    },
    {
        patterns = {"1st rarity", "first rarity"},
        answer = "COMMON",
    },
    {
        patterns = {"2nd rarity", "second rarity"},
        answer = "UNCOMMON",
    },
    {
        patterns = {"3rd rarity", "third rarity"},
        answer = "RARE",
    },
    {
        patterns = {"4th rarity", "fourth rarity"},
        answer = "EPIC",
    },
    {
        patterns = {"5th rarity", "fifth rarity"},
        answer = "LEGENDARY",
    },
    {
        patterns = {"6th rarity", "sixth rarity"},
        answer = "OG",
    },
    {
        patterns = {"uncommon"},
        answer = "UNCOMMON",
    },
    {
        patterns = {"rare"},
        answer = "RARE",
    },
    {
        patterns = {"epic"},
        answer = "EPIC",
    },
    {
        patterns = {"legendary"},
        answer = "LEGENDARY",
    },
    {
        patterns = {"og"},
        answer = "OG",
    },
    {
        patterns = {"common"},
        answer = "COMMON",
    },
    {
        patterns = {"sammy name", "game owner", "sammys name"},
        answer = "SAMMY",
    },
    {
        patterns = {"birth country", "born in", "lives in", "comes from"},
        answer = "BRAZIL",
    },
    {
        patterns = {"channel", "handle"},
        answer = "SPYDERSAMMY",
    },
    {
        patterns = {"how many players in server", "server capacity", "players per server", "max server"},
        answer = "EIGHT",
    },
    {
        patterns = {"day game released", "day released", "what day was it released", "what day was it created"},
        answer = "FRIDAY",
    },
    {
        patterns = {"sab creation year", "creation year", "when created", "when released", "date released", "date created"},
        answer = "MAY162025",
    },
    {
        patterns = {"trait added first"},
        answer = "LIGHTNING",
    },
    {
        patterns = {"what trait", "lightning strike trait", "get struck by lightning", "lightning gives", "struck by lightning trait", "mateo"},
        answer = "MATEO",
    },
    {
        patterns = {"fire symbol", "fire meaning", "fire brainrot"},
        answer = "DRAGON",
    },
    {
        patterns = {"won world cup", "football world cup"},
        answer = "SPAIN",
    },
    {
        patterns = {"boring owner", "most boring owner"},
        answer = "SECRETLOKII",
    },
    {
        patterns = {"boring game", "boring roblox game"},
        answer = "KEYBOARDESCAPE",
    },
    {
        patterns = {"admin abuse war", "admin war", "who won admin war"},
        answer = "GROWAGARDEN",
    },
    {
        patterns = {"sammy fought", "fight in admin war"},
        answer = "JANDEL",
    },
    {
        patterns = {"admin war brainrot", "spawned in admin war"},
        answer = "RACOONINIJANDELINI",
    },
    {
        patterns = {"secret"},
        answer = "KARKERKARKURKUR",
    },
    {
        patterns = {"cerberus brother", "brother of hydra"},
        answer = "CERBERUS",
    },
    {
        patterns = {"how many brainrots", "number brainrots", "brainrot count"},
        answer = "THIRTEEN",
    },
    {
        patterns = {"how many og brainrots", "total og brainrots", "og count"},
        answer = "FIVE",
    },
}

-- ==================== RIDDLE HELPERS ====================
local function normalizeCode(s)
    return (tostring(s or "")):match("^%s*(.-)%s*$") or ""
end

local function normalizeRiddleText(text)
    text = tostring(text or ""):lower()
    text = text:gsub("1st", "first"):gsub("2nd", "second")
    text = text:gsub("3rd", "third"):gsub("4th", "fourth")
    text = text:gsub("[^%w%s]", " ")
    text = text:gsub("%s+", " ")
    return text:match("^%s*(.-)%s*$") or ""
end

local function stemRiddleWord(word)
    word = tostring(word or ""):lower()
    if #word > 4 and word:sub(-3) == "ing" then word = word:sub(1, -4) end
    if #word > 4 and word:sub(-2) == "ed" then word = word:sub(1, -3) end
    if #word > 4 and word:sub(-2) == "es" then word = word:sub(1, -3) end
    if #word > 3 and word:sub(-1) == "s" then word = word:sub(1, -2) end
    local aliases = {
        original = "og",
        earliest = "first",
        newest = "latest",
        recent = "latest",
        made = "add",
        added = "add",
        created = "add",
        born = "birth",
        birthday = "birth",
        called = "name",
    }
    word = aliases[word] or word
    return word
end

local RIDDLE_FILLER_WORDS = {
    what = true, is = true, the = true, a = true, an = true,
    ["do"] = true, does = true, did = true, you = true, are = true,
    was = true, were = true, am = true, i = true, my = true,
    me = true, we = true, our = true, of = true, to = true,
    ["in"] = true, on = true, at = true, ["and"] = true, ["or"] = true,
    have = true, has = true, it = true, ["for"] = true, how = true,
    where = true, who = true, when = true, which = true, can = true,
    s = true,
    will = true, would = true, could = true, please = true,
}

local function riddleWords(text)
    local words = {}
    for word in normalizeRiddleText(text):gmatch("%w+") do
        local stem = stemRiddleWord(word)
        if stem ~= "" and not RIDDLE_FILLER_WORDS[stem] and not stem:match("^%d+$") then
            words[stem] = true
        end
    end
    if words.brainrot and words.god then words.brainrotgod = true end
    if words.brainrotgod then
        words.brainrot = true
        words.god = true
    end
    return words
end

local function riddlePatternMatches(messageText, pattern)
    local phrase = normalizeRiddleText(pattern)
    if messageText:find(phrase, 1, true) then return true end
    if messageText:gsub("%s+", ""):find(phrase:gsub("%s+", ""), 1, true) then return true end

    local wanted = riddleWords(pattern)
    local received = riddleWords(messageText)
    local wantedCount = 0
    for word in pairs(wanted) do
        wantedCount = wantedCount + 1  -- CORRECTION: += remplacé par = +1
        if not received[word] then return false end
    end
    return wantedCount > 0
end

local function extractRiddleNumber(message, knownAnswer)
    local answerNumbers = {}
    for number in tostring(knownAnswer or ""):gmatch("%d+") do
        answerNumbers[number] = true
    end
    local lastNumber
    for number in tostring(message or ""):gmatch("%d+") do
        if not answerNumbers[number] then lastNumber = number end
    end
    return lastNumber
end

local function solveOfflineRiddle(message)
    if not message or message == "" then return nil end
    local combinedAnswers = {}
    local parts = {}
    local function splitByAnd(str)
        local result = {}
        local lower = str:lower()
        local pos = 1
        while true do
            local startPos, endPos = lower:find(" and ", pos, true)
            if not startPos then
                local remaining = str:sub(pos)
                if remaining ~= "" then
                    table.insert(result, remaining)
                end
                break
            end
            local part = str:sub(pos, startPos - 1)
            if part ~= "" then
                table.insert(result, part)
            end
            pos = endPos + 1
        end
        return result
    end
    local temp = message:gsub("%s*[&,]", " and ")
    parts = splitByAnd(temp)
    if #parts > 1 then
        local foundAny = false
        for _, part in ipairs(parts) do
            local trimmed = part:match("^%s*(.-)%s*$")
            if trimmed ~= "" and #trimmed > 2 then
                local normalizedPart = normalizeRiddleText(trimmed)
                local found = false
                for _, entry in ipairs(BRAINROT_KNOWLEDGE) do
                    for _, pattern in ipairs(entry.patterns) do
                        if riddlePatternMatches(normalizedPart, pattern) then
                            local answer = entry.answer:gsub("%s+", "")
                            table.insert(combinedAnswers, answer:upper())
                            found = true
                            foundAny = true
                            break
                        end
                    end
                    if found then break end
                end
                if not found then
                    if normalizedPart:find("who am i", 1, true) or normalizedPart:find("what am i", 1, true) then
                        table.insert(combinedAnswers, "PLAYER")
                        foundAny = true
                    elseif normalizedPart:find("yes or no", 1, true) and normalizedPart:find("brainrot", 1, true) then
                        table.insert(combinedAnswers, "YES")
                        foundAny = true
                    end
                end
            end
        end
        if foundAny and #combinedAnswers > 1 then
            local combined = table.concat(combinedAnswers)
            local suffix = extractRiddleNumber(message, "")
            if suffix and #suffix > 0 then
                combined = combined .. suffix
            end
            return combined, suffix
        end
    end
    local normalized = normalizeRiddleText(message)
    if normalized == "" then return nil end
    for _, entry in ipairs(BRAINROT_KNOWLEDGE) do
        for _, pattern in ipairs(entry.patterns) do
            if riddlePatternMatches(normalized, pattern) then
                local answer = entry.answer:gsub("%s+", "")
                return answer:upper(), extractRiddleNumber(message, entry.answer)
            end
        end
    end
    if normalized:find("who am i", 1, true) or normalized:find("what am i", 1, true) then
        return "PLAYER", extractRiddleNumber(message, "player")
    end
    if normalized:find("yes or no", 1, true) and normalized:find("brainrot", 1, true) then
        return "YES", extractRiddleNumber(message, "yes")
    end
    return nil
end

local _solving = 0
local _solvedCount = 0
local _lastTypedSeq = 0
local _riddleSeq = 0

local function solveRiddle(message, seq)
    if not _riddleSolver or not _enabled then return end
    _solving = _solving + 1
    if setStatus then setStatus("AI riddles: thinking...", COLORS and COLORS.Text or Color3.fromRGB(100,200,255)) end
    task.spawn(function()
        task.wait()
        _solving = math.max(0, _solving - 1)
        if not _enabled or not _riddleSolver then return end
        local answer, suffix = solveOfflineRiddle(message)
        local top = normalizeCode(answer)
        top = top:gsub("%s+", "")
        if top and #top > 0 and suffix and #suffix > 0 then
            top = top .. suffix
        end
        if top and #top > 0 and seq >= _lastTypedSeq then
            _lastTypedSeq = seq
            _solvedCount = _solvedCount + 1
            if setStatus then setStatus("Answer: " .. top, COLORS and COLORS.Green or Color3.fromRGB(70,210,100)) end
            if flashCode then flashCode(top) end
            appendToBox(top)
        elseif not top or #top == 0 then
            if setStatus then setStatus("No answer found", COLORS and COLORS.Red or Color3.fromRGB(255,70,70)) end
        end
    end)
end

local rememberPendingSubmission, clearPendingSubmission, handleRedemptionFeedback
local clearAceCapture
local _lastStatusMsg = nil

-- ==================== UTILITY & REDEEM LOGIC ====================
local function isOurGui(instance)
    local p = instance
    for _ = 1, 10 do
        if not p then break end
        if p.Name == "ACECodeSniperUI" or p.Name == "SourcesHubRedeemerGui" then return true end
        p = p.Parent
    end
    return false
end

local function isVisibleChain(inst)
    local current = inst
    while current do
        if current:IsA("GuiObject") and not current.Visible then return false end
        if current:IsA("ScreenGui") then return current.Enabled end
        current = current.Parent
    end
    return true
end

local function findAllTextBoxes(pg)
    local boxes = {}
    for _, gui in ipairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled and not isOurGui(gui) then
            for _, d in ipairs(gui:GetDescendants()) do
                if d:IsA("TextBox") and not isOurGui(d) then
                    boxes[#boxes+1] = d
                end
            end
        end
    end
    return boxes
end

local function findCodeButtons(pg)
    local btns = {}
    for _, gui in ipairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled and not isOurGui(gui) then
            for _, d in ipairs(gui:GetDescendants()) do
                if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
                    local n  = d.Name:lower()
                    local pn = (d.Parent and d.Parent.Name or ""):lower()
                    if (n:find("code") or n:find("redeem") or pn:find("code") or pn:find("redeem"))
                        and isVisibleChain(d) then
                        btns[#btns+1] = d
                    end
                end
            end
        end
    end
    return btns
end

local function clickButton(btn)
    if not btn then return false end
    local methods = {}
    methods[#methods+1] = function() btn.MouseButton1Click:Fire() end
    methods[#methods+1] = function() btn.Activated:Fire() end
    if typeof(firesignal) == "function" then
        methods[#methods+1] = function() firesignal(btn.MouseButton1Click) end
        methods[#methods+1] = function() firesignal(btn.Activated) end
    end
    if typeof(getconns) == "function" then
        methods[#methods+1] = function()
            local ok, cs = pcall(getconns, btn.MouseButton1Click)
            if ok and type(cs) == "table" then
                for _, c in ipairs(cs) do pcall(function() c:Fire() end) end
            end
            local ok2, cs2 = pcall(getconns, btn.Activated)
            if ok2 and type(cs2) == "table" then
                for _, c in ipairs(cs2) do pcall(function() c:Fire() end) end
            end
        end
    end
    if typeof(fireclick) == "function" then
        methods[#methods+1] = function() fireclick(btn) end
    end
    local anyOk = false
    for _, fn in ipairs(methods) do
        local ok = pcall(fn)
        anyOk = anyOk or ok
    end
    return anyOk
end

local function fireBoxFocusLost(box)
    if not box then return false end
    local anyFired = false
    if typeof(firesignal) == "function" then
        local ok = pcall(firesignal, box.FocusLost, true)
        anyFired = anyFired or ok
    end
    if typeof(getconns) == "function" then
        local ok, cs = pcall(getconns, box.FocusLost)
        if ok and type(cs) == "table" then
            for _, c in ipairs(cs) do
                local fn
                pcall(function() fn = c.Function end)
                if fn and typeof(getupvalues) == "function" and typeof(setupv) == "function" then
                    local uOk, ups = pcall(getupvalues, fn)
                    if uOk and type(ups) == "table" then
                        for i, v in pairs(ups) do
                            if type(v) == "boolean" and v == true then
                                pcall(setupv, fn, i, false)
                            end
                        end
                    end
                end
                local fOk = pcall(function()
                    if c.Enabled ~= false then c:Fire(true) end
                end)
                anyFired = anyFired or fOk
            end
        end
    end
    return anyFired
end

typeAndSubmitCode = function(code)
    local pg = playerGui or player:FindFirstChildOfClass("PlayerGui")
    if not pg then return false, "no PlayerGui" end

    local codesGui = pg:FindFirstChild("Codes")
    if codesGui then
        if codesGui:IsA("ScreenGui") then codesGui.Enabled = true end
        local codesFrame = codesGui:FindFirstChild("Codes") or codesGui
        if codesFrame then
            if codesFrame:IsA("GuiObject") then codesFrame.Visible = true end
            local cur = codesFrame
            while cur and cur ~= codesGui do
                if cur:IsA("GuiObject") then cur.Visible = true end
                cur = cur.Parent
            end

            local box = nil
            for _, d in ipairs(codesFrame:GetDescendants()) do
                if d:IsA("TextBox") and not isOurGui(d) then
                    box = d
                    break
                end
            end

            local submitBtn = nil
            for _, d in ipairs(codesFrame:GetDescendants()) do
                if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
                    local n = d.Name:lower()
                    local txt = ""
                    pcall(function() txt = d.Text:lower() end)
                    if n:find("submit") or txt:find("submit") or n:find("redeem") or txt:find("redeem") or n:find("claim") or txt:find("confirm") or n:find("enter") then
                        submitBtn = d
                        break
                    end
                end
            end
            if not submitBtn then
                for _, d in ipairs(codesFrame:GetDescendants()) do
                    if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
                        local n = d.Name:lower()
                        if not n:find("close") and not n:find("x") and not n:find("toggle") then
                            submitBtn = d
                            break
                        end
                    end
                end
            end

            if box then
                pcall(function() box.Text = code end)
                task.wait(0.05)
                if submitBtn then clickButton(submitBtn) end
                fireBoxFocusLost(box)
                return true, "submitted via PlayerGui.Codes"
            end
        end
    end

    local btns = findCodeButtons(pg)
    for _, btn in ipairs(btns) do
        clickButton(btn)
        task.wait(0.05)
    end

    task.wait(0.2)

    local box = nil
    local deadline = tick() + 2
    while tick() < deadline do
        local allBoxes = findAllTextBoxes(pg)
        for _, d in ipairs(allBoxes) do
            if isVisibleChain(d) then
                local n  = d.Name:lower()
                local pn = (d.Parent and d.Parent.Name or ""):lower()
                if n:find("code") or pn:find("code") or n:find("redeem") or pn:find("redeem") or n:find("input") or pn:find("textbox") or n:find("enter") then
                    box = d
                    break
                end
            end
        end
        if not box then
            for _, d in ipairs(allBoxes) do
                if isVisibleChain(d) then box = d; break end
            end
        end
        if box then break end
        task.wait(0.1)
    end

    if not box then return false, "no codebox visible" end

    pcall(function() box.Text = code end)
    task.wait(0.05)

    local redeemBtn = nil
    local searchNames = {"submit","redeem","claim","confirm","enter","send","apply","ok","use","go","check"}
    local p = box.Parent
    for _ = 1, 8 do
        if not p then break end
        for _, d in ipairs(p:GetDescendants()) do
            if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) and d ~= box then
                local n = d.Name:lower()
                local txt = ""
                pcall(function() txt = d.Text:lower() end)
                for _, sn in ipairs(searchNames) do
                    if n:find(sn) or txt:find(sn) then
                        if isVisibleChain(d) then
                            redeemBtn = d
                            break
                        end
                    end
                end
                if redeemBtn then break end
            end
        end
        if redeemBtn then break end
        p = p.Parent
    end

    if redeemBtn then clickButton(redeemBtn) end
    fireBoxFocusLost(box)

    return true, "submitted via dynamic search"
end

local function aceCodeBox()
    local pg = playerGui
    local allBoxes = findAllTextBoxes(pg)
    for _, box in ipairs(allBoxes) do
        if isVisibleChain(box) then return box end
    end
    return nil
end

-- ==================== STYLING & UI ====================
COLORS = {
    Window = Color3.fromRGB(8, 12, 20),
    Row = Color3.fromRGB(12, 20, 35),
    Control = Color3.fromRGB(40, 30, 50),    -- OFF: couleur plus sombre mais visible
    Log = Color3.fromRGB(6, 10, 18),
    Border = Color3.fromRGB(0, 200, 255),
    White = Color3.fromRGB(255, 255, 255),
    Text = Color3.fromRGB(180, 220, 255),
    Dim = Color3.fromRGB(150, 180, 210),
    Accent = Color3.fromRGB(0, 212, 255),    -- ON: cyan vif
    Green = Color3.fromRGB(70, 210, 100),
    Red = Color3.fromRGB(255, 70, 70),
}

local function addCorner(parent, radius)
    local value = Instance.new("UICorner")
    value.CornerRadius = UDim.new(0, radius)
    value.Parent = parent
    return value
end

local function addStroke(parent, color, thickness, transparency)
    local value = Instance.new("UIStroke")
    value.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    value.Color = color
    value.Thickness = thickness or 1
    value.Transparency = transparency or 0
    value.Parent = parent
    return value
end

local function makeLabel(parent, name, text, size, position, textSize, color, font)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextSize = textSize
    label.TextColor3 = color
    label.Font = font or Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = parent
    return label
end

-- Animation functions
local function animateButton(button, hoverColor, normalColor, scale)
    local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local hoverTween = TweenService:Create(button, tweenInfo, {BackgroundColor3 = hoverColor})
    local normalTween = TweenService:Create(button, tweenInfo, {BackgroundColor3 = normalColor})
    local scaleTweenIn = TweenService:Create(button, tweenInfo, {Size = UDim2.fromOffset(button.Size.X.Offset * (scale or 1.05), button.Size.Y.Offset * (scale or 1.05))})
    local scaleTweenOut = TweenService:Create(button, tweenInfo, {Size = UDim2.fromOffset(button.Size.X.Offset, button.Size.Y.Offset)})

    button.MouseEnter:Connect(function()
        hoverTween:Play()
        scaleTweenIn:Play()
    end)
    button.MouseLeave:Connect(function()
        normalTween:Play()
        scaleTweenOut:Play()
    end)
    button.MouseButton1Down:Connect(function()
        local pressTween = TweenService:Create(button, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(button.Size.X.Offset * 0.95, button.Size.Y.Offset * 0.95)})
        pressTween:Play()
        pressTween.Completed:Connect(function()
            local releaseTween = TweenService:Create(button, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(button.Size.X.Offset, button.Size.Y.Offset)})
            releaseTween:Play()
        end)
    end)
end

local function animateStateChange(button, newState, accentColor, controlColor)
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local targetColor = newState and accentColor or controlColor
    local colorTween = TweenService:Create(button, tweenInfo, {BackgroundColor3 = targetColor})
    colorTween:Play()
    local pulseTween = TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(button.Size.X.Offset * 1.1, button.Size.Y.Offset * 1.1)})
    pulseTween:Play()
    pulseTween.Completed:Connect(function()
        local backTween = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(button.Size.X.Offset, button.Size.Y.Offset)})
        backTween:Play()
    end)
end

-- CLEANUP
pcall(function()
    for _, name in ipairs({"ACECodeSniperUI", "AutoTypeCodesUI", "ACEPaste"}) do
        local previous = game.CoreGui:FindFirstChild(name)
        if previous then previous:Destroy() end
    end
end)
for _, name in ipairs({"ACECodeSniperUI", "AutoTypeCodesUI", "ACEPaste"}) do
    local previous = playerGui:FindFirstChild(name)
    if previous then previous:Destroy() end
end

-- MAIN GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "ACECodeSniperUI"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.DisplayOrder = 999
local guiParent = playerGui
pcall(function()
    local coreGui = cloneref(game:GetService("CoreGui"))
    if coreGui then guiParent = coreGui end
end)
local guiParentOk = pcall(function()
    GUI.Parent = guiParent
end)
if not guiParentOk or not GUI.Parent then
    pcall(function() GUI.Parent = playerGui end)
end

local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.fromOffset(310, 410)
Window.AnchorPoint = Vector2.new(1, 0)
Window.Position = UDim2.new(1, -8, 0, 8)
Window.BackgroundColor3 = COLORS.Window
Window.BorderSizePixel = 0
Window.ClipsDescendants = true
Window.Parent = GUI
addCorner(Window, 14)
addStroke(Window, COLORS.Border, 2, 0.3)

local InterfaceScale = Instance.new("UIScale")
InterfaceScale.Name = "InterfaceScale"
InterfaceScale.Scale = 0.92
InterfaceScale.Parent = Window

local viewportConnection
local function updateInterfaceScale()
    local camera = workspace.CurrentCamera
    if not camera then InterfaceScale.Scale = 0.92; return end
    local viewport = camera.ViewportSize
    local fitScale = math.min((viewport.X - 16) / 310, (viewport.Y - 16) / 410)
    if UserInputService.TouchEnabled then
        local mobileTarget = 0.72
        InterfaceScale.Scale = math.max(0.45, math.min(mobileTarget, fitScale))
    else
        InterfaceScale.Scale = 0.92
    end
end

local function watchViewport()
    if viewportConnection then viewportConnection:Disconnect(); viewportConnection = nil end
    local camera = workspace.CurrentCamera
    if camera then viewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateInterfaceScale) end
    updateInterfaceScale()
end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchViewport)
watchViewport()

local BackgroundImage = Instance.new("Frame")
BackgroundImage.Name = "ACEBackground"
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.Position = UDim2.fromOffset(0, 0)
BackgroundImage.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
BackgroundImage.BackgroundTransparency = 0
BackgroundImage.ZIndex = 1
BackgroundImage.Parent = Window
addCorner(BackgroundImage, 14)

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 255)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(0, 60, 180)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 30, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 12, 20))
})
gradient.Rotation = 0
gradient.Parent = BackgroundImage

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 64)
Header.BackgroundTransparency = 1
Header.Active = true
Header.ZIndex = 3
Header.Parent = Window

local Console, ConsoleOutput, updateConsoleCanvas
local featureStates = {}
local CONSOLE_COLORS = {
    Dim = "rgb(100, 180, 255)",
    Amber = "rgb(150, 220, 255)",
    Green = "rgb(105, 190, 132)",
    Red = "rgb(218, 105, 105)",
    Cyan = "rgb(0, 200, 255)",
}

local function scrollConsoleToBottom()
    task.defer(function()
        task.wait()
        if not Console then return end
        if updateConsoleCanvas then updateConsoleCanvas() end
        local bottom = math.max(0, Console.AbsoluteCanvasSize.Y - Console.AbsoluteWindowSize.Y)
        Console.CanvasPosition = Vector2.new(0, bottom)
    end)
end

local function appendConsoleStatus(name, activated)
    if not ConsoleOutput then return end
    local state = activated and "ON" or "OFF"
    local stateColor = activated and CONSOLE_COLORS.Green or CONSOLE_COLORS.Red
    local line = '<font color="' .. CONSOLE_COLORS.Dim .. '">[setting]</font> '
        .. '<font color="' .. CONSOLE_COLORS.Amber .. '">' .. name .. "</font> "
        .. '<font color="' .. CONSOLE_COLORS.Dim .. '">-&gt;</font> '
        .. '<font color="' .. stateColor .. '">' .. state .. "</font>"
    if ConsoleOutput.Text == "" then ConsoleOutput.Text = line else ConsoleOutput.Text = ConsoleOutput.Text .. "\n\n" .. line end
    scrollConsoleToBottom()
end

local BrandMark = Instance.new("Frame")
BrandMark.Name = "BrandMark"
BrandMark.Size = UDim2.fromOffset(30, 30)
BrandMark.Position = UDim2.fromOffset(17, 15)
BrandMark.BackgroundColor3 = COLORS.Window
BrandMark.BackgroundTransparency = 1
BrandMark.BorderSizePixel = 0
BrandMark.ClipsDescendants = true
BrandMark.Parent = Header
addCorner(BrandMark, 15)
addStroke(BrandMark, COLORS.Border, 1, 0.5)

local BrandImage = Instance.new("ImageLabel")
BrandImage.Name = "Logo"
BrandImage.Size = UDim2.fromScale(1, 1)
BrandImage.BackgroundTransparency = 1
BrandImage.Image = "rbxassetid://73792644227694"
BrandImage.ScaleType = Enum.ScaleType.Fit
BrandImage.Parent = BrandMark
addCorner(BrandImage, 15)

makeLabel(Header, "Title", "EL2B CODE SNIPER", UDim2.fromOffset(180, 25), UDim2.fromOffset(56, 17), 15, COLORS.White, Enum.Font.GothamBold)

-- Toggle ON/OFF principal
local AutoWriteButton = Instance.new("TextButton")
AutoWriteButton.Name = "AutoWrite"
AutoWriteButton.Size = UDim2.fromOffset(47, 24)
AutoWriteButton.Position = UDim2.new(1, -64, 0, 18)
AutoWriteButton.BackgroundColor3 = COLORS.Accent
AutoWriteButton.BorderSizePixel = 0
AutoWriteButton.AutoButtonColor = false
AutoWriteButton.Active = true
AutoWriteButton.Text = ""
AutoWriteButton.ZIndex = 5
AutoWriteButton.Parent = Header
addCorner(AutoWriteButton, 12)
addStroke(AutoWriteButton, COLORS.Border, 1.5, 0.2)

local AutoWriteStroke = addStroke(AutoWriteButton, COLORS.White, 1, 0.62)
local AutoWriteKnob = Instance.new("Frame")
AutoWriteKnob.Name = "Knob"
AutoWriteKnob.Size = UDim2.fromOffset(20, 20)
AutoWriteKnob.Position = UDim2.new(1, -22, 0.5, -10)
AutoWriteKnob.BackgroundColor3 = COLORS.Window
AutoWriteKnob.BorderSizePixel = 0
AutoWriteKnob.ZIndex = 6
AutoWriteKnob.Parent = AutoWriteButton
addCorner(AutoWriteKnob, 10)
addStroke(AutoWriteKnob, COLORS.Border, 1, 0.2)

local autoWriteEnabled = _enabled
_enabled = autoWriteEnabled
AutoWriteButton.BackgroundColor3 = autoWriteEnabled and COLORS.Accent or COLORS.Control
AutoWriteStroke.Transparency = autoWriteEnabled and 0.62 or 0.88
AutoWriteKnob.BackgroundColor3 = autoWriteEnabled and COLORS.Window or COLORS.White
AutoWriteKnob.Position = autoWriteEnabled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)

animateButton(AutoWriteButton, COLORS.Border, AutoWriteButton.BackgroundColor3, 1.05)

local lastToggleTime = 0
local function toggleAutoWrite()
    if tick() - lastToggleTime < 0.15 then return end
    lastToggleTime = tick()
    autoWriteEnabled = not autoWriteEnabled
    _enabled = autoWriteEnabled
    if not autoWriteEnabled and clearAceCapture then clearAceCapture() end
    savedConfig.codeSniper = autoWriteEnabled
    saveConfig()
    _lastStatusMsg = nil
    local newColor = autoWriteEnabled and COLORS.Accent or COLORS.Control
    local knobColor = autoWriteEnabled and COLORS.Window or COLORS.White
    local knobPos = autoWriteEnabled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local bgTween = TweenService:Create(AutoWriteButton, tweenInfo, {BackgroundColor3 = newColor})
    bgTween:Play()
    local knobTween = TweenService:Create(AutoWriteKnob, tweenInfo, {BackgroundColor3 = knobColor, Position = knobPos})
    knobTween:Play()
    AutoWriteStroke.Transparency = autoWriteEnabled and 0.62 or 0.88

    if ConsoleOutput then
        if autoWriteEnabled then
            ConsoleOutput.Text = '<font color="' .. CONSOLE_COLORS.Amber .. '">&gt;</font> <font color="' .. CONSOLE_COLORS.Dim .. '">scanning for codes...</font>'
            for _, featureName in ipairs({"Auto submit", "AI riddles", "Retype invalid", "Discord logs"}) do
                if featureStates[featureName] then appendConsoleStatus(featureName, true) end
            end
        else
            ConsoleOutput.Text = '<font color="' .. CONSOLE_COLORS.Dim .. '">status:</font> <font color="' .. CONSOLE_COLORS.Red .. '">OFF</font>\n<font color="' .. CONSOLE_COLORS.Dim .. '">code sniper paused</font>'
        end
        scrollConsoleToBottom()
    end
end

AutoWriteButton.Activated:Connect(toggleAutoWrite)
AutoWriteButton.MouseButton1Click:Connect(toggleAutoWrite)
AutoWriteButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleAutoWrite()
    end
end)

local HeaderAccent = Instance.new("Frame")
HeaderAccent.Name = "TitleDivider"
HeaderAccent.Size = UDim2.new(1, -34, 0, 1)
HeaderAccent.Position = UDim2.fromOffset(17, 54)
HeaderAccent.BackgroundColor3 = COLORS.Border
HeaderAccent.BackgroundTransparency = 0.3
HeaderAccent.BorderSizePixel = 0
HeaderAccent.Parent = Header

local Settings = Instance.new("Frame")
Settings.Name = "Settings"
Settings.Size = UDim2.new(1, 0, 0, 196)
Settings.Position = UDim2.fromOffset(0, 65)
Settings.BackgroundTransparency = 1
Settings.ZIndex = 3
Settings.Parent = Window

local function makeCard(name, position, size)
    local card = Instance.new("Frame")
    card.Name = name
    card.Position = position
    card.Size = size
    card.BackgroundColor3 = COLORS.Row
    card.BackgroundTransparency = 0.5
    card.BorderSizePixel = 0
    card.Parent = Settings
    addCorner(card, 9)
    addStroke(card, COLORS.Border, 1, 0.4)
    return card
end

local function makeStateButton(parent, enabled, consoleName, onToggle)
    parent.Active = true
    featureStates[consoleName] = enabled
    local button = Instance.new("TextButton")
    button.Name = "State"
    button.Size = UDim2.fromOffset(42, 22)   -- plus grand
    button.Position = UDim2.new(1, -50, 0.5, -11)
    button.BackgroundColor3 = enabled and COLORS.Accent or COLORS.Control
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Active = true
    button.Text = enabled and "ON" or "OFF"
    button.TextSize = 10                     -- plus lisible
    button.TextColor3 = enabled and COLORS.White or Color3.fromRGB(200, 200, 220)
    button.Font = Enum.Font.GothamBold
    button.ZIndex = 5
    button.Parent = parent
    addCorner(button, 6)
    local outline = addStroke(button, COLORS.Border, 1.5, enabled and 0.4 or 0.7)
    local state = enabled
    local lastSubToggle = 0

    animateButton(button, COLORS.Border, button.BackgroundColor3, 1.1)

    local function toggleState()
        if tick() - lastSubToggle < 0.15 then return end
        lastSubToggle = tick()
        state = not state
        featureStates[consoleName] = state
        button.Text = state and "ON" or "OFF"
        local newColor = state and COLORS.Accent or COLORS.Control
        local newTextColor = state and COLORS.White or Color3.fromRGB(200, 200, 220)
        outline.Transparency = state and 0.4 or 0.7
        animateStateChange(button, state, COLORS.Accent, COLORS.Control)
        button.TextColor3 = newTextColor
        if autoWriteEnabled then appendConsoleStatus(consoleName, state) end
        if onToggle then onToggle(state) end
    end

    button.Activated:Connect(toggleState)
    button.MouseButton1Click:Connect(toggleState)
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggleState()
        end
    end)
    return button
end

-- Cards
local AutoCard = makeCard("AutoSubmit", UDim2.fromOffset(17, 0), UDim2.fromOffset(135, 50))
makeLabel(AutoCard, "Title", "Auto submit", UDim2.new(1, -58, 1, 0), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
makeStateButton(AutoCard, _autoAccept, "Auto submit", function(state)
    _autoAccept = state
    savedConfig.autoSubmit = state
    saveConfig()
end)

local AICard = makeCard("AIRiddles", UDim2.fromOffset(158, 0), UDim2.fromOffset(135, 50))
makeLabel(AICard, "Title", "AI riddles", UDim2.new(1, -58, 1, 0), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
makeStateButton(AICard, _riddleSolver, "AI riddles", function(state)
    _riddleSolver = state
    savedConfig.riddleSolver = state
    saveConfig()
end)

local DelayCard = makeCard("SubmitAfter", UDim2.fromOffset(17, 57), UDim2.fromOffset(276, 43))
makeLabel(DelayCard, "Title", "Submit after msgs", UDim2.fromOffset(145, 43), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
local CounterShell = Instance.new("Frame")
CounterShell.Name = "Counter"
CounterShell.Size = UDim2.fromOffset(96, 31)
CounterShell.Position = UDim2.new(1, -105, 0.5, -15)
CounterShell.BackgroundColor3 = COLORS.Window
CounterShell.BackgroundTransparency = 0.2
CounterShell.BorderSizePixel = 0
CounterShell.Parent = DelayCard
addCorner(CounterShell, 7)
addStroke(CounterShell, COLORS.Border, 1, 0.5)

local Minus = Instance.new("TextButton")
Minus.Name = "Minus"
Minus.Size = UDim2.fromOffset(25, 25)
Minus.Position = UDim2.fromOffset(3, 3)
Minus.BackgroundColor3 = COLORS.Control
Minus.BorderSizePixel = 0
Minus.AutoButtonColor = false
Minus.Active = true
Minus.Text = "-"
Minus.TextSize = 16
Minus.TextColor3 = COLORS.Text
Minus.Font = Enum.Font.GothamBold
Minus.Parent = CounterShell
addCorner(Minus, 5)
animateButton(Minus, COLORS.Border, COLORS.Control, 1.1)

local Count = makeLabel(CounterShell, "Count", tostring(_submitAfter), UDim2.fromOffset(28, 25), UDim2.fromOffset(34, 3), 17, COLORS.White, Enum.Font.GothamBold)
Count.TextXAlignment = Enum.TextXAlignment.Center

local Plus = Instance.new("TextButton")
Plus.Name = "Plus"
Plus.Size = UDim2.fromOffset(25, 25)
Plus.Position = UDim2.fromOffset(68, 3)
Plus.BackgroundColor3 = COLORS.Control
Plus.BorderSizePixel = 0
Plus.AutoButtonColor = false
Plus.Active = true
Plus.Text = "+"
Plus.TextSize = 16
Plus.TextColor3 = COLORS.Text
Plus.Font = Enum.Font.GothamBold
Plus.Parent = CounterShell
addCorner(Plus, 5)
animateButton(Plus, COLORS.Border, COLORS.Control, 1.1)

local function decr()
    _submitAfter = math.max(1, _submitAfter - 1)
    Count.Text = tostring(_submitAfter)
    savedConfig.submitAfter = _submitAfter
    clearAceCapture()
    saveConfig()
    local tween = TweenService:Create(Count, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextSize = 20})
    tween:Play()
    tween.Completed:Connect(function()
        local back = TweenService:Create(Count, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextSize = 17})
        back:Play()
    end)
end
local function incr()
    _submitAfter = _submitAfter + 1
    Count.Text = tostring(_submitAfter)
    savedConfig.submitAfter = _submitAfter
    clearAceCapture()
    saveConfig()
    local tween = TweenService:Create(Count, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextSize = 20})
    tween:Play()
    tween.Completed:Connect(function()
        local back = TweenService:Create(Count, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextSize = 17})
        back:Play()
    end)
end

Minus.Activated:Connect(decr)
Minus.MouseButton1Click:Connect(decr)
Plus.Activated:Connect(incr)
Plus.MouseButton1Click:Connect(incr)

local RetypeCard = makeCard("RetypeInvalid", UDim2.fromOffset(17, 103), UDim2.fromOffset(276, 38))
makeLabel(RetypeCard, "Title", "Retype invalid", UDim2.new(1, -65, 1, 0), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
local RetypeState = makeStateButton(RetypeCard, _retypeInvalid, "Retype invalid", function(state)
    _retypeInvalid = state
    savedConfig.retypeInvalid = state
    saveConfig()
end)
RetypeState.Position = UDim2.new(1, -50, 0.5, -10)

local DiscordCard = makeCard("DiscordLogs", UDim2.fromOffset(17, 148), UDim2.fromOffset(276, 38))
makeLabel(DiscordCard, "Title", "Discord logs", UDim2.new(1, -65, 1, 0), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
local DiscordState = makeStateButton(DiscordCard, savedConfig.discordEnabled, "Discord logs", function(state)
    savedConfig.discordEnabled = state
    saveConfig()
end)
DiscordState.Position = UDim2.new(1, -50, 0.5, -10)

Console = Instance.new("ScrollingFrame")
Console.Name = "Console"
Console.Size = UDim2.new(1, -34, 0, 127)
Console.Position = UDim2.fromOffset(17, 260)
Console.BackgroundColor3 = COLORS.Log
Console.BorderSizePixel = 0
Console.ClipsDescendants = true
Console.Active = true
Console.ScrollingEnabled = true
Console.ScrollingDirection = Enum.ScrollingDirection.Y
Console.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
Console.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
Console.CanvasSize = UDim2.new(0, 0, 0, 0)
Console.AutomaticCanvasSize = Enum.AutomaticSize.None
Console.ScrollBarThickness = 4
Console.ScrollBarImageColor3 = COLORS.Border
Console.ZIndex = 3
Console.Parent = Window
addCorner(Console, 9)
addStroke(Console, COLORS.Border, 1, 0.4)

ConsoleOutput = Instance.new("TextLabel")
ConsoleOutput.Name = "ConsoleOutput"
ConsoleOutput.Size = UDim2.new(1, -18, 0, 115)
ConsoleOutput.AutomaticSize = Enum.AutomaticSize.Y
ConsoleOutput.Position = UDim2.fromOffset(9, 6)
ConsoleOutput.BackgroundTransparency = 1
ConsoleOutput.RichText = true
if autoWriteEnabled then
    ConsoleOutput.Text = '<font color="' .. CONSOLE_COLORS.Amber .. '">&gt;</font> <font color="' .. CONSOLE_COLORS.Dim .. '">scanning for codes...</font>'
else
    ConsoleOutput.Text = '<font color="' .. CONSOLE_COLORS.Dim .. '">status:</font> <font color="' .. CONSOLE_COLORS.Red .. '">OFF</font>\n<font color="' .. CONSOLE_COLORS.Dim .. '">code sniper paused</font>'
end
ConsoleOutput.TextSize = 14
ConsoleOutput.Font = Enum.Font.Code
ConsoleOutput.TextColor3 = COLORS.Dim
ConsoleOutput.TextXAlignment = Enum.TextXAlignment.Left
ConsoleOutput.TextYAlignment = Enum.TextYAlignment.Top
ConsoleOutput.TextWrapped = true
ConsoleOutput.ZIndex = 4
ConsoleOutput.Parent = Console

local CONSOLE_BOTTOM_PADDING = 30
updateConsoleCanvas = function()
    if not Console or not ConsoleOutput then return end
    local contentHeight = ConsoleOutput.Position.Y.Offset + ConsoleOutput.AbsoluteSize.Y + CONSOLE_BOTTOM_PADDING
    Console.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
end
ConsoleOutput:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateConsoleCanvas)
task.defer(updateConsoleCanvas)

local DiscordFooter = makeLabel(Window, "DiscordFooter", "EL2B SNIPER", UDim2.fromOffset(140, 19), UDim2.new(0.5, -70, 0, 388), 10, COLORS.White, Enum.Font.GothamBold)
DiscordFooter.TextXAlignment = Enum.TextXAlignment.Center
DiscordFooter.BackgroundColor3 = COLORS.Window
DiscordFooter.BackgroundTransparency = 1
DiscordFooter.TextStrokeColor3 = COLORS.Border
DiscordFooter.TextStrokeTransparency = 0.2
DiscordFooter.ZIndex = 3

-- WINDOW DRAGGING
do
    local dragging = false
    local activeDragInput
    local dragStart
    local startPosition
    local dragMoved = false
    local DRAG_THRESHOLD = UserInputService.TouchEnabled and 10 or 3

    local function isOverHeaderControl(position)
        local btnPos = AutoWriteButton.AbsolutePosition
        local btnSize = AutoWriteButton.AbsoluteSize
        return position.X >= (btnPos.X - 10) and position.X <= (btnPos.X + btnSize.X + 10) and position.Y >= (btnPos.Y - 10) and position.Y <= (btnPos.Y + btnSize.Y + 10)
    end

    local function stopDragging(input)
        if input ~= activeDragInput then return end
        dragging = false
        activeDragInput = nil
        dragStart = nil
        startPosition = nil
    end

    Header.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if dragging or isOverHeaderControl(input.Position) then return end
        dragging = true
        activeDragInput = input
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        startPosition = Window.Position
        dragMoved = false
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End or input.UserInputState == Enum.UserInputState.Cancel then
                stopDragging(input)
            end
        end)
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging or not activeDragInput then return end
        local isTrackedTouch = activeDragInput.UserInputType == Enum.UserInputType.Touch and input == activeDragInput
        local isTrackedMouse = activeDragInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement
        if not isTrackedTouch and not isTrackedMouse then return end
        local current = Vector2.new(input.Position.X, input.Position.Y)
        local delta = current - dragStart
        if not dragMoved then
            if delta.Magnitude < DRAG_THRESHOLD then return end
            dragMoved = true
        end
        Window.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end)
end

local function col3ToRich(col)
    if col == COLORS.Green then return CONSOLE_COLORS.Green end
    if col == COLORS.Red then return CONSOLE_COLORS.Red end
    if col == COLORS.Text then return CONSOLE_COLORS.Amber end
    if col == COLORS.White then return CONSOLE_COLORS.Cyan end
    if col == COLORS.Dim then return CONSOLE_COLORS.Dim end
    return string.format("rgb(%d,%d,%d)", math.floor(col.R * 255 + 0.5), math.floor(col.G * 255 + 0.5), math.floor(col.B * 255 + 0.5))
end

function setStatus(msg, col)
    if not ConsoleOutput or not _enabled then return end
    if msg == _lastStatusMsg then return end
    _lastStatusMsg = msg
    col = col or COLORS.Dim
    local line = '<font color="' .. col3ToRich(col) .. '">' .. tostring(msg) .. "</font>"
    if ConsoleOutput.Text == "" then ConsoleOutput.Text = line else ConsoleOutput.Text = ConsoleOutput.Text .. "\n\n" .. line end
    scrollConsoleToBottom()
end

function flashCode(code, col)
    if not code or code == "" or code == "—" then return end
    setStatus("[code] -> " .. tostring(code), col or COLORS.White)
end

local function resetPasteCounter() _capturedParts = {} end
clearAceCapture = function() _capturedParts = {} end

local function clearBoxWatchers()
    if _boxTextConn then pcall(function() _boxTextConn:Disconnect() end) end
    if _boxAncestryConn then pcall(function() _boxAncestryConn:Disconnect() end) end
    for _, connection in ipairs(_boxVisibilityConns) do pcall(function() connection:Disconnect() end) end
    _boxTextConn = nil
    _boxAncestryConn = nil
    _boxVisibilityConns = {}
    _lastWatchedBox = nil
end

local function watchBoxForBlankReset(box)
    if not box or _lastWatchedBox == box then return end
    clearBoxWatchers()
    _lastWatchedBox = box
    if box.Text ~= "" then _lastNonBlankBoxText = box.Text end
    _boxTextConn = box:GetPropertyChangedSignal("Text"):Connect(function()
        if box.Text == "" then resetPasteCounter() else _lastNonBlankBoxText = box.Text end
    end)
    _boxAncestryConn = box.AncestryChanged:Connect(function(_, parent)
        if not parent then resetPasteCounter(); clearBoxWatchers() end
    end)
end

UserInputService.TextBoxFocused:Connect(function(box)
    if box:IsDescendantOf(GUI) then return end
    if box ~= aceCodeBox() then return end
    _focused = box
    _lastBox = box
    watchBoxForBlankReset(box)
    if _enabled then setStatus("Ready", COLORS.Green) end
end)

UserInputService.TextBoxFocusReleased:Connect(function(box)
    if box:IsDescendantOf(GUI) then return end
    local codeBox = aceCodeBox()
    if box ~= codeBox and box ~= _lastBox then return end
    if _retypeInvalid and rememberPendingSubmission and (box == codeBox or box == _lastBox) then
        local submittedText = box.Text ~= "" and box.Text or _lastNonBlankBoxText
        rememberPendingSubmission(box, submittedText, false)
    end
    if _focused == box then
        _focused = nil
        if _enabled then
            setStatus((_lastBox and _lastBox.Parent) and "Ready" or "Click code box first", (_lastBox and _lastBox.Parent) and COLORS.Green or COLORS.Dim)
        end
    end
end)

clearPendingSubmission = function()
    _pendingRejectedToken = _pendingRejectedToken + 1
    _pendingRejectedText = nil
    _pendingRejectedBox = nil
    _pendingRejectedUntil = 0
end

rememberPendingSubmission = function(box, text, replaceExisting)
    if not _retypeInvalid or not text or text == "" then return end
    if not replaceExisting and _pendingRejectedText and os.clock() <= _pendingRejectedUntil then return end
    _pendingRejectedToken = _pendingRejectedToken + 1
    local token = _pendingRejectedToken
    _pendingRejectedText = text
    _pendingRejectedBox = box
    _pendingRejectedUntil = os.clock() + 8
    task.delay(8, function()
        if token == _pendingRejectedToken then clearPendingSubmission() end
    end)
end

local function restoreRejectedText(box, previousText)
    if not _retypeInvalid or not previousText or previousText == "" then return false end
    RunService.Heartbeat:Wait()
    local repasteBox = aceCodeBox() or box
    if not repasteBox or not isVisibleChain(repasteBox) then return false end
    local restored = pcall(function() repasteBox.Text = previousText end)
    if restored then
        _lastBox = repasteBox
        watchBoxForBlankReset(repasteBox)
    end
    return restored
end

handleRedemptionFeedback = function(text, feedbackObject)
    if not _retypeInvalid or not _pendingRejectedText then return end
    if os.clock() > _pendingRejectedUntil then clearPendingSubmission(); return end
    if feedbackObject and feedbackObject:IsDescendantOf(GUI) then return end
    local lower = tostring(text or ""):lower()
    local rejected = lower:find("invalid code", 1, true)
        or lower:find("code is invalid", 1, true)
        or lower:find("expired", 1, true)
        or lower:find("already redeemed", 1, true)
        or lower:find("already used", 1, true)
        or lower:find("doesn't exist", 1, true)
        or lower:find("does not exist", 1, true)
        or lower:find("not found", 1, true)
        or lower:find("rejected", 1, true)
    if not rejected then return end
    local previousText = _pendingRejectedText
    local previousBox = _pendingRejectedBox
    local restored = restoreRejectedText(previousBox, previousText)
    clearPendingSubmission()
    if restored then
        setStatus("Invalid - repasted: " .. previousText, COLORS.Text)
        flashCode(previousText, COLORS.Red)
    end
end

function appendToBox(text)
    if not text or text == "" then return end
    if _lastWatchedBox and not isVisibleChain(_lastWatchedBox) then
        resetPasteCounter()
        clearBoxWatchers()
    end
    local box = aceCodeBox()
    _capturedParts[#_capturedParts + 1] = text
    local combinedCode = table.concat(_capturedParts)
    local capturedCount = #_capturedParts

    if box then
        _lastBox = box
        watchBoxForBlankReset(box)
        local boxWasFocused = UserInputService:GetFocusedTextBox() == box
        box.Text = combinedCode
        if boxWasFocused then
            pcall(function()
                local caretEnd = #combinedCode + 1
                box.CursorPosition = caretEnd
                box.SelectionStart = caretEnd
            end)
        end
    else
        setStatus("Captured; opening & searching UI...", COLORS.Text)
    end

    setStatus("Pasted " .. tostring(capturedCount) .. "/" .. tostring(_submitAfter), COLORS.Green)
    flashCode(combinedCode, COLORS.Green)

    if capturedCount >= _submitAfter then
        _capturedParts = {}
        if _autoAccept then
            rememberPendingSubmission(box, combinedCode, true)
            local ok, statusMsg = typeAndSubmitCode(combinedCode)
            if ok then
                setStatus("Redeemed: " .. combinedCode, COLORS.Green)
                sendToDiscord("[EL2B] 🎉 **" .. player.Name .. "** a réclamé le code **" .. combinedCode .. "** avec succès !")
            else
                local restored = restoreRejectedText(box, combinedCode)
                clearPendingSubmission()
                if restored then
                    setStatus("Invalid - repasted: " .. combinedCode, COLORS.Text)
                    flashCode(combinedCode, COLORS.Red)
                else
                    setStatus("Failed: " .. tostring(statusMsg), COLORS.Red)
                    sendToDiscord("[EL2B] ❌ **" .. player.Name .. "** a échoué à réclamer **" .. combinedCode .. "** (Raison : " .. tostring(statusMsg) .. ")")
                end
            end
        end
    end
end

local function watchRedemptionFeedbackObject(obj)
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton")) then return end
    handleRedemptionFeedback(obj.Text or "", obj)
    obj:GetPropertyChangedSignal("Text"):Connect(function()
        handleRedemptionFeedback(obj.Text or "", obj)
    end)
end

for _, obj in ipairs(playerGui:GetDescendants()) do watchRedemptionFeedbackObject(obj) end
playerGui.DescendantAdded:Connect(function(obj)
    task.wait(0.04)
    watchRedemptionFeedbackObject(obj)
end)

-- ==================== ANNOUNCEMENT NOTIFICATION LISTENER ====================
local function resolveNotifyRemote()
    if _G.PhiNotifyRemote then return _G.PhiNotifyRemote end
    local Packages = ReplicatedStorage:FindFirstChild("Packages")
    local Net = Packages and Packages:FindFirstChild("Net")
    if not Net then return nil end
    local getinfo = debug and (debug.getinfo or debug.info)
    if getgc and getinfo and getconnections then
        for _, d in ipairs(Net:GetDescendants()) do
            if d:IsA("RemoteEvent") then
                local ok, cs = pcall(getconnections, d.OnClientEvent)
                if ok then
                    for _, c in ipairs(cs) do
                        local f, fn = pcall(function() return c.Function end)
                        if f and type(fn) == "function" then
                            local i, info = pcall(getinfo, fn)
                            if i and tostring(info.short_src or info.source or ""):find("NotificationController", 1, true) then
                                return d
                            end
                        end
                    end
                end
            end
        end
    end
    return nil
end

local function aceStripRich(text)
    if type(text) ~= "string" then return tostring(text) end
    return (text:gsub("<[^>]*>", ""))  -- CORRECTION: regex corrigé
end

local function aceTokenize(text)
    local words = {}
    for word in text:gmatch("[%w_]+") do
        words[#words + 1] = word
    end
    return words
end

local aceCollectBuffer = {}
local function onAceAnnouncement(...)
    local text = aceStripRich(tostring((...) or ""))
    text = text:match("^%s*(.-)%s*$") or ""
    if text == "" then return end

    if _riddleSolver and text:find("%s") then
        _riddleSeq = _riddleSeq + 1
        solveRiddle(text, _riddleSeq)
        return
    end

    if text:find("%s") then return end

    for _, word in ipairs(aceTokenize(text)) do
        aceCollectBuffer[#aceCollectBuffer + 1] = word
    end

    local parts = {}
    for index = 1, math.min(#aceCollectBuffer, ACE_WORD_COUNT) do
        parts[index] = aceCollectBuffer[index]
    end
    if #aceCollectBuffer < ACE_WORD_COUNT then return end
    aceCollectBuffer = {}

    local captured = table.concat(parts)
    if captured == "" or _seen[captured] then return end
    _seen[captured] = true
    task.delay(1.25, function() _seen[captured] = nil end)
    appendToBox(captured)
end

local aceNotifyRemote = resolveNotifyRemote()
local aceListenConnection
if aceNotifyRemote then
    if getgenv then
        local previous = getgenv().ACECodeSniperNotifyConnection
        if previous then pcall(function() previous:Disconnect() end) end
    end
    aceListenConnection = aceNotifyRemote.OnClientEvent:Connect(function(...)
        if not _enabled then return end
        pcall(onAceAnnouncement, ...)
    end)
    if getgenv then getgenv().ACECodeSniperNotifyConnection = aceListenConnection end
end

if getgenv then
    getgenv().StopAura = function()
        if aceListenConnection then
            pcall(function() aceListenConnection:Disconnect() end)
            aceListenConnection = nil
        end
        if getgenv().ACECodeSniperNotifyConnection then
            pcall(function() getgenv().ACECodeSniperNotifyConnection:Disconnect() end)
            getgenv().ACECodeSniperNotifyConnection = nil
        end
        if GUI then GUI:Destroy() end
    end
end
