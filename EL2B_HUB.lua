-- Création de la GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "DiggingScannerGui"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

Frame.Name = "MainFrame"
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.Size = UDim2.new(0, 220, 0, 110)

UICorner.Parent = Frame

TextButton.Name = "ScanButton"
TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
TextButton.Position = UDim2.new(0.1, 0, 0.2, 0)
TextButton.Size = UDim2.new(0.8, 0, 0.6, 0)
TextButton.Font = Enum.Font.SourceSansBold
TextButton.Text = "Scanner & Envoyer"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 16

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.Parent = TextButton

-- Fonction du bouton
TextButton.MouseButton1Click:Connect(function()
    local webhookUrl = "https://discord.com/api/webhooks/1565350169048907869/nWiIdmCYiTDWHqwbGVozL_zdHwVI60ab-9VEwJKL2xP5GHgPfCMi4WyEzU7eFFBry3R_"
    local foundRemotes = ""
    
    -- Recherche du modèle "digging" dans Workspace ou ReplicatedStorage
    local targetModel = workspace:FindFirstChild("digging", true) or game:GetService("ReplicatedStorage"):FindFirstChild("digging", true)
    
    if targetModel then
        for _, descendant in ipairs(targetModel:GetDescendants()) do
            if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
                foundRemotes = foundRemotes .. "[" .. descendant.ClassName .. "] " .. descendant:GetFullName() .. "\n"
            end
        end
        if foundRemotes == "" then
            foundRemotes = "Aucun RemoteEvent ou RemoteFunction trouvé dans le modèle digging."
        end
    else
        foundRemotes = "Modèle 'digging' introuvable dans le jeu."
    end
    
    -- Préparation du message Discord
    local data = {
        ["content"] = "**Résultats du scan (digging) :**\n```text\n" .. foundRemotes .. "\n```"
    }
    
    -- Envoi de la requête HTTP via l'exploit
    local httpRequest = syn and syn.request or http and http.request or request or HttpPost
    if httpRequest then
        pcall(function()
            httpRequest({
                Url = webhookUrl,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = game:GetService("HttpService"):JSONEncode(data)
            })
        end)
        TextButton.Text = "Envoyé !"
        task.wait(2)
        TextButton.Text = "Scanner & Envoyer"
    else
        TextButton.Text = "Erreur HTTP"
    end
end)
