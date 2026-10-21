-- Leaked by @mwp0622 https://discord.gg/VMevrRXMwc https://mwpscripts.shop
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local AdminCommand = game:GetService("ReplicatedStorage"):WaitForChild("AdminCommand", 15)
if AdminCommand then
    local v_u_6 = Enum.KeyCode.K
    local v_u_7 = LocalPlayer.UserId == 11033186906
    local v_u_8 = {
        ["Background"] = Color3.fromRGB(10, 10, 12),
        ["Panel"] = Color3.fromRGB(17, 17, 20),
        ["Sidebar"] = Color3.fromRGB(13, 13, 16),
        ["Card"] = Color3.fromRGB(23, 23, 27),
        ["CardHover"] = Color3.fromRGB(30, 30, 35),
        ["PillBg"] = Color3.fromRGB(23, 23, 27),
        ["Accent"] = Color3.fromRGB(59, 130, 246),
        ["AccentHover"] = Color3.fromRGB(96, 165, 250),
        ["AccentDim"] = Color3.fromRGB(30, 64, 120),
        ["AccentText"] = Color3.fromRGB(255, 255, 255),
        ["Success"] = Color3.fromRGB(58, 209, 120),
        ["SuccessHover"] = Color3.fromRGB(80, 224, 138),
        ["Danger"] = Color3.fromRGB(235, 80, 80),
        ["DangerHover"] = Color3.fromRGB(250, 104, 104),
        ["Warning"] = Color3.fromRGB(255, 170, 40),
        ["WarningHover"] = Color3.fromRGB(255, 190, 70),
        ["TextPrimary"] = Color3.fromRGB(244, 244, 248),
        ["TextSecondary"] = Color3.fromRGB(160, 160, 172),
        ["TextMuted"] = Color3.fromRGB(100, 100, 112),
        ["Border"] = Color3.fromRGB(38, 38, 44),
        ["BorderBright"] = Color3.fromRGB(60, 55, 20),
        ["InputBg"] = Color3.fromRGB(15, 15, 18)
    }
    local GothamBlack = Enum.Font.GothamBlack
    local GothamBold = Enum.Font.GothamBold
    local Gotham = Enum.Font.Gotham
    local GothamMedium = Enum.Font.GothamMedium
    local function v_u_23(p13) -- name: FormatDuration
        local v14 = math.floor(p13)
        local v15 = math.max(0, v14)
        local v16 = v15 / 60
        local v17 = math.floor(v16)
        local v18 = v17 / 60
        local v19 = math.floor(v18)
        local v20 = v19 / 24
        local v21 = math.floor(v20)
        local v22 = v15 % 60
        if v21 > 0 then
            return v21 .. "d " .. v19 % 24 .. "h"
        elseif v19 > 0 then
            return v19 .. "h " .. v17 % 60 .. "m"
        else
            return v17 % 60 .. "m " .. v22 .. "s"
        end
    end
    local function v_u_30(p24, p25, p26, p27, p28) -- name: Pad
        local v29 = Instance.new("UIPadding")
        v29.PaddingLeft = UDim.new(0, p25 or 0)
        v29.PaddingRight = UDim.new(0, p26 or 0)
        v29.PaddingTop = UDim.new(0, p27 or 0)
        v29.PaddingBottom = UDim.new(0, p28 or 0)
        v29.Parent = p24
        return v29
    end
    local function v_u_39(p31) -- name: MakeButton
        -- upvalues: (copy) v_u_8, (copy) GothamBold, (copy) TweenService
        local v_u_32 = Instance.new("TextButton")
        v_u_32.Size = p31.Size or UDim2.new(1, 0, 0, 32)
        v_u_32.Position = p31.Position or UDim2.new(0, 0, 0, 0)
        v_u_32.BackgroundColor3 = p31.Color or v_u_8.Accent
        v_u_32.Text = p31.Text or ""
        v_u_32.TextColor3 = p31.TextColor or (p31.Color and Color3.fromRGB(255, 255, 255) or v_u_8.AccentText)
        v_u_32.Font = p31.Font or GothamBold
        v_u_32.TextSize = p31.TextSize or 12
        v_u_32.BorderSizePixel = 0
        v_u_32.AutoButtonColor = false
        v_u_32.Parent = p31.Parent
        local v33 = p31.Radius or 10
        local v34 = Instance.new("UICorner")
        v34.CornerRadius = UDim.new(0, v33 or 10)
        v34.Parent = v_u_32
        local AccentHover = p31.HoverColor or v_u_8.AccentHover
        local Accent = p31.Color or v_u_8.Accent
        v_u_32.MouseEnter:Connect(function()
            -- upvalues: (copy) v_u_32, (copy) AccentHover, (ref) TweenService
            local v37 = {
                ["BackgroundColor3"] = AccentHover
            }
            TweenService:Create(v_u_32, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), v37):Play()
        end)
        v_u_32.MouseLeave:Connect(function()
            -- upvalues: (copy) v_u_32, (copy) Accent, (ref) TweenService
            local v38 = {
                ["BackgroundColor3"] = Accent
            }
            TweenService:Create(v_u_32, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), v38):Play()
        end)
        return v_u_32
    end
    local function v_u_49(p40) -- name: MakeTextbox
        -- upvalues: (copy) v_u_8, (copy) Gotham, (copy) v_u_30, (copy) TweenService
        local v41 = Instance.new("TextBox")
        v41.Size = p40.Size or UDim2.new(1, 0, 0, 32)
        v41.Position = p40.Position or UDim2.new(0, 0, 0, 0)
        v41.PlaceholderText = p40.Placeholder or ""
        v41.Text = p40.Text or ""
        v41.BackgroundColor3 = v_u_8.InputBg
        v41.TextColor3 = v_u_8.TextPrimary
        v41.PlaceholderColor3 = v_u_8.TextMuted
        v41.Font = Gotham
        v41.TextSize = 12
        v41.ClearTextOnFocus = false
        v41.TextTruncate = Enum.TextTruncate.AtEnd
        v41.Parent = p40.Parent
        local v42 = Instance.new("UICorner")
        v42.CornerRadius = UDim.new(0, 10)
        v42.Parent = v41
        local Border = v_u_8.Border
        local v_u_44 = Instance.new("UIStroke")
        v_u_44.Color = Border or v_u_8.Border
        v_u_44.Thickness = 1
        v_u_44.Transparency = 0
        v_u_44.Parent = v41
        v_u_30(v41, 10, 10, 0, 0)
        v41.Focused:Connect(function()
            -- upvalues: (copy) v_u_44, (ref) v_u_8, (ref) TweenService
            local v45 = v_u_44
            local v46 = {
                ["Color"] = v_u_8.Accent
            }
            TweenService:Create(v45, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), v46):Play()
        end)
        v41.FocusLost:Connect(function()
            -- upvalues: (copy) v_u_44, (ref) v_u_8, (ref) TweenService
            local v47 = v_u_44
            local v48 = {
                ["Color"] = v_u_8.Border
            }
            TweenService:Create(v47, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), v48):Play()
        end)
        return v41
    end
    local function v_u_56(p50, p51) -- name: SectionLabel
        -- upvalues: (copy) v_u_8, (copy) GothamBold
        local v52 = Instance.new("Frame")
        v52.Size = UDim2.new(1, 0, 0, 16)
        v52.BackgroundTransparency = 1
        v52.Parent = p50
        local v53 = Instance.new("Frame")
        v53.Size = UDim2.new(0, 3, 0, 10)
        v53.Position = UDim2.new(0, 0, 0.5, -5)
        v53.BackgroundColor3 = v_u_8.Accent
        v53.BorderSizePixel = 0
        v53.Parent = v52
        local v54 = Instance.new("UICorner")
        v54.CornerRadius = UDim.new(0, 2)
        v54.Parent = v53
        local v55 = Instance.new("TextLabel")
        v55.Size = UDim2.new(1, -10, 1, 0)
        v55.Position = UDim2.new(0, 10, 0, 0)
        v55.BackgroundTransparency = 1
        v55.Text = p51
        v55.TextColor3 = v_u_8.TextSecondary
        v55.Font = GothamBold
        v55.TextSize = 10
        v55.TextXAlignment = Enum.TextXAlignment.Left
        v55.Parent = v52
        return v52
    end
    local function v64(p57, p58, p59, p60, p61) -- name: LabeledInput
        -- upvalues: (copy) v_u_56, (copy) v_u_49
        local v62 = Instance.new("Frame")
        v62.Size = p61 or UDim2.new(1, 0, 0, 50)
        v62.BackgroundTransparency = 1
        v62.Parent = p57
        v_u_56(v62, p58).Position = UDim2.new(0, 0, 0, 0)
        local v63 = v_u_49({
            ["Parent"] = v62,
            ["Placeholder"] = p59,
            ["Text"] = p60 or "",
            ["Size"] = UDim2.new(1, 0, 0, 32)
        })
        v63.Position = UDim2.new(0, 0, 0, 20)
        return v62, v63
    end
    local function v68(p65, p66) -- name: MakeScrollFrame
        -- upvalues: (copy) v_u_8
        local v67 = Instance.new("ScrollingFrame")
        v67.Size = UDim2.new(1, 0, 0, p66)
        v67.BackgroundTransparency = 1
        v67.ScrollBarThickness = 3
        v67.ScrollBarImageColor3 = v_u_8.Accent
        v67.CanvasSize = UDim2.new(0, 0, 0, 0)
        v67.AutomaticCanvasSize = Enum.AutomaticSize.Y
        v67.BorderSizePixel = 0
        v67.Parent = p65
        return v67
    end
    local function v72(p69, p70) -- name: MakeListLayout
        local v71 = Instance.new("UIListLayout", p69)
        v71.SortOrder = Enum.SortOrder.LayoutOrder
        v71.Padding = UDim.new(0, p70 or 4)
        return v71
    end
    local function v91(p73, p74, p_u_75) -- name: MakePillSwitcher
        -- upvalues: (copy) v_u_8, (copy) v_u_30, (copy) GothamBold, (copy) TweenService
        local v76 = Instance.new("Frame")
        v76.Size = UDim2.new(1, 0, 0, 30)
        v76.BackgroundColor3 = v_u_8.PillBg
        v76.BorderSizePixel = 0
        v76.Parent = p73
        local v77 = Instance.new("UICorner")
        v77.CornerRadius = UDim.new(0, 9)
        v77.Parent = v76
        local Border_0 = v_u_8.Border
        local v79 = Instance.new("UIStroke")
        v79.Color = Border_0 or v_u_8.Border
        v79.Thickness = 1
        v79.Transparency = 0
        v79.Parent = v76
        v_u_30(v76, 3, 3, 3, 3)
        local v80 = Instance.new("UIListLayout", v76)
        v80.FillDirection = Enum.FillDirection.Horizontal
        v80.SortOrder = Enum.SortOrder.LayoutOrder
        v80.Padding = UDim.new(0, 3)
        local v_u_81 = {}
        for v82, v83 in ipairs(p74) do
            local v84 = Instance.new("TextButton")
            v84.Size = UDim2.new(1 / #p74, -2, 1, 0)
            v84.BackgroundColor3 = v82 == 1 and v_u_8.Accent or v_u_8.PillBg
            v84.Text = v83
            v84.TextColor3 = v82 == 1 and v_u_8.AccentText or v_u_8.TextSecondary
            v84.Font = GothamBold
            v84.TextSize = 11
            v84.AutoButtonColor = false
            v84.BorderSizePixel = 0
            v84.Parent = v76
            local v85 = Instance.new("UICorner")
            v85.CornerRadius = UDim.new(0, 7)
            v85.Parent = v84
            v_u_81[v83] = v84
        end
        for v_u_86, v87 in pairs(v_u_81) do
            v87.MouseButton1Click:Connect(function()
                -- upvalues: (copy) v_u_81, (copy) v_u_86, (ref) v_u_8, (ref) TweenService, (copy) p_u_75
                for v88, v89 in pairs(v_u_81) do
                    local v90 = {
                        ["BackgroundColor3"] = v88 == v_u_86 and v_u_8.Accent or v_u_8.PillBg
                    }
                    TweenService:Create(v89, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), v90):Play()
                    v89.TextColor3 = v88 == v_u_86 and v_u_8.AccentText or v_u_8.TextSecondary
                end
                p_u_75(v_u_86)
            end)
        end
        return v76, v_u_81
    end
    local v_u_92 = Instance.new("Sound")
    v_u_92.SoundId = "rbxassetid://3398620867"
    v_u_92.Volume = 0.4
    v_u_92.Parent = LocalPlayer
    local v_u_93 = Instance.new("Sound")
    v_u_93.SoundId = "rbxassetid://9120386545"
    v_u_93.Volume = 0.4
    v_u_93.Parent = LocalPlayer
    local v_u_94 = Instance.new("ScreenGui")
    v_u_94.Name = "AdminPanel"
    v_u_94.ResetOnSpawn = false
    v_u_94.ZIndexBehavior = Enum.ZIndexBehavior.Global
    v_u_94.Parent = LocalPlayer.PlayerGui
    v_u_94.Enabled = false
    local v_u_95 = Instance.new("Frame")
    v_u_95.Size = UDim2.new(0, 540, 0, 500)
    v_u_95.Position = UDim2.new(0.5, -270, 0.5, -250)
    v_u_95.BackgroundTransparency = 1
    v_u_95.Visible = false
    v_u_95.Parent = v_u_94
    local v_u_96 = Instance.new("Frame")
    v_u_96.Size = UDim2.new(0, 540, 0, 500)
    v_u_96.Position = UDim2.new(0, 0, 0, 0)
    v_u_96.BackgroundColor3 = v_u_8.Background
    v_u_96.BorderSizePixel = 0
    v_u_96.ClipsDescendants = true
    v_u_96.Visible = false
    v_u_96.Parent = v_u_95
    local v97 = Instance.new("UICorner")
    v97.CornerRadius = UDim.new(0, 16)
    v97.Parent = v_u_96
    local BorderBright = v_u_8.BorderBright
    local v99 = Instance.new("UIStroke")
    v99.Color = BorderBright or v_u_8.Border
    v99.Thickness = 1.5
    v99.Transparency = 0
    v99.Parent = v_u_96
    local v100 = Instance.new("Frame")
    v100.Size = UDim2.new(1, 0, 0, 46)
    v100.Position = UDim2.new(0, 0, 0, 0)
    v100.BackgroundColor3 = v_u_8.Sidebar
    v100.BorderSizePixel = 0
    v100.Parent = v_u_96
    local Sidebar = v_u_8.Sidebar
    local Panel = v_u_8.Panel
    local v103 = Instance.new("UIGradient")
    v103.Color = ColorSequence.new(Sidebar, Panel)
    v103.Rotation = 90
    v103.Parent = v100
    local v104 = Instance.new("Frame")
    v104.Size = UDim2.new(1, 0, 0, 2)
    v104.Position = UDim2.new(0, 0, 1, -2)
    v104.BackgroundColor3 = v_u_8.Accent
    v104.BorderSizePixel = 0
    v104.ZIndex = 5
    v104.Parent = v100
    local Accent_0 = v_u_8.Accent
    local AccentDim = v_u_8.AccentDim
    local v107 = Instance.new("UIGradient")
    v107.Color = ColorSequence.new(Accent_0, AccentDim)
    v107.Rotation = 0
    v107.Parent = v104
    local v108 = Instance.new("Frame")
    v108.Size = UDim2.new(0, 3, 0, 20)
    v108.Position = UDim2.new(0, 18, 0.5, -10)
    v108.BackgroundColor3 = v_u_8.Accent
    v108.BorderSizePixel = 0
    v108.Parent = v100
    local v109 = Instance.new("UICorner")
    v109.CornerRadius = UDim.new(0, 2)
    v109.Parent = v108
    local v110 = Instance.new("TextLabel")
    v110.Size = UDim2.new(0, 180, 1, 0)
    v110.Position = UDim2.new(0, 32, 0, 0)
    v110.BackgroundTransparency = 1
    v110.Text = v_u_7 and "X ADMIN \194\183 OWNER" or "X ADMIN"
    v110.TextColor3 = v_u_8.TextPrimary
    v110.Font = GothamBlack
    v110.TextSize = 14
    v110.TextXAlignment = Enum.TextXAlignment.Left
    v110.Parent = v100
    local v_u_111 = Instance.new("TextLabel")
    v_u_111.Size = UDim2.new(0, 110, 1, 0)
    v_u_111.Position = UDim2.new(1, -260, 0, 0)
    v_u_111.BackgroundTransparency = 1
    v_u_111.Text = #Players:GetPlayers() .. " online"
    v_u_111.TextColor3 = v_u_8.TextSecondary
    v_u_111.Font = GothamMedium
    v_u_111.TextSize = 11
    v_u_111.TextXAlignment = Enum.TextXAlignment.Right
    v_u_111.Parent = v100
    local v_u_112 = Instance.new("Frame")
    v_u_112.Size = UDim2.new(0, 106, 0, 24)
    v_u_112.Position = UDim2.new(1, -146, 0.5, -12)
    v_u_112.BackgroundColor3 = v_u_8.Card
    v_u_112.BorderSizePixel = 0
    v_u_112.Visible = false
    v_u_112.Parent = v100
    local v113 = Instance.new("UICorner")
    v113.CornerRadius = UDim.new(0, 12)
    v113.Parent = v_u_112
    local Warning = v_u_8.Warning
    local v115 = Instance.new("UIStroke")
    v115.Color = Warning or v_u_8.Border
    v115.Thickness = 1
    v115.Transparency = 0.5
    v115.Parent = v_u_112
    local v_u_116 = Instance.new("Frame")
    v_u_116.Size = UDim2.new(0, 6, 0, 6)
    v_u_116.Position = UDim2.new(0, 8, 0.5, -3)
    v_u_116.BackgroundColor3 = v_u_8.Warning
    v_u_116.BorderSizePixel = 0
    v_u_116.Parent = v_u_112
    local v117 = Instance.new("UICorner")
    v117.CornerRadius = UDim.new(0, 3)
    v117.Parent = v_u_116
    local v_u_118 = Instance.new("TextLabel")
    v_u_118.Size = UDim2.new(1, -22, 1, 0)
    v_u_118.Position = UDim2.new(0, 18, 0, 0)
    v_u_118.BackgroundTransparency = 1
    v_u_118.Text = "--"
    v_u_118.TextColor3 = v_u_8.Warning
    v_u_118.Font = GothamBold
    v_u_118.TextSize = 10
    v_u_118.TextXAlignment = Enum.TextXAlignment.Left
    v_u_118.Parent = v_u_112
    local v_u_119 = Instance.new("TextButton")
    v_u_119.Size = UDim2.new(0, 28, 0, 28)
    v_u_119.Position = UDim2.new(1, -38, 0.5, -14)
    v_u_119.BackgroundColor3 = v_u_8.Danger
    v_u_119.Text = "X"
    v_u_119.TextColor3 = Color3.fromRGB(255, 255, 255)
    v_u_119.Font = GothamBold
    v_u_119.TextSize = 13
    v_u_119.AutoButtonColor = false
    v_u_119.Parent = v100
    local v120 = Instance.new("UICorner")
    v120.CornerRadius = UDim.new(0, 8)
    v120.Parent = v_u_119
    v_u_119.MouseEnter:Connect(function()
        -- upvalues: (copy) v_u_119, (copy) v_u_8, (copy) TweenService
        local v121 = v_u_119
        local v122 = {
            ["BackgroundColor3"] = v_u_8.DangerHover
        }
        TweenService:Create(v121, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), v122):Play()
    end)
    v_u_119.MouseLeave:Connect(function()
        -- upvalues: (copy) v_u_119, (copy) v_u_8, (copy) TweenService
        local v123 = v_u_119
        local v124 = {
            ["BackgroundColor3"] = v_u_8.Danger
        }
        TweenService:Create(v123, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), v124):Play()
    end)
    v_u_119.MouseButton1Click:Connect(function()
        -- upvalues: (copy) v_u_96, (copy) v_u_95
        v_u_96.Visible = false
        v_u_95.Visible = false
    end)
    local v125 = Instance.new("Frame")
    v125.Size = UDim2.new(0, 84, 1, -46)
    v125.Position = UDim2.new(0, 0, 0, 46)
    v125.BackgroundColor3 = v_u_8.Sidebar
    v125.BorderSizePixel = 0
    v125.Parent = v_u_96
    local v126 = Instance.new("Frame")
    v126.Size = UDim2.new(0, 1, 1, 0)
    v126.Position = UDim2.new(0, 84, 0, 0)
    v126.BackgroundColor3 = v_u_8.Border
    v126.BorderSizePixel = 0
    v126.Parent = v_u_96
    local v127 = Instance.new("UIListLayout", v125)
    v127.SortOrder = Enum.SortOrder.LayoutOrder
    v127.Padding = UDim.new(0, 4)
    v_u_30(v125, 6, 6, 10, 10)
    local v128 = {
        "Teleport",
        "Find",
        "Friends",
        "Dice",
        "Settings"
    }
    if v_u_7 then
        table.insert(v128, 4, "Anchor")
        table.insert(v128, 5, "Bans")
        table.insert(v128, 6, "Whitelist")
        local v129 = #v128
        table.insert(v128, v129, "Logs")
    end
    local v_u_130 = {}
    for v131, v132 in ipairs(v128) do
        local v133 = Instance.new("TextButton")
        v133.Size = UDim2.new(1, 0, 0, 32)
        v133.BackgroundColor3 = v131 == 1 and v_u_8.Accent or v_u_8.Sidebar
        v133.Text = ""
        v133.AutoButtonColor = false
        v133.BorderSizePixel = 0
        v133.Parent = v125
        local v134 = Instance.new("UICorner")
        v134.CornerRadius = UDim.new(0, 8)
        v134.Parent = v133
        local v135 = Instance.new("TextLabel")
        v135.Size = UDim2.new(1, -20, 1, 0)
        v135.Position = UDim2.new(0, 12, 0, 0)
        v135.BackgroundTransparency = 1
        v135.Text = v132
        v135.TextColor3 = v131 == 1 and v_u_8.AccentText or v_u_8.TextSecondary
        v135.Font = GothamBold
        v135.TextSize = 11
        v135.TextXAlignment = Enum.TextXAlignment.Left
        v135.Parent = v133
        v_u_130[v132] = {
            ["Button"] = v133,
            ["Label"] = v135
        }
    end
    local v136 = Instance.new("Frame")
    v136.Size = UDim2.new(1, -84, 1, -46)
    v136.Position = UDim2.new(0, 84, 0, 46)
    v136.BackgroundTransparency = 1
    v136.Parent = v_u_96
    v_u_30(v136, 18, 18, 14, 14)
    local v_u_137 = Instance.new("Frame")
    v_u_137.Size = UDim2.new(1, 0, 1, 0)
    v_u_137.BackgroundTransparency = 1
    v_u_137.Visible = true
    v_u_137.Parent = v136
    local v138 = Instance.new("UIListLayout", v_u_137)
    v138.SortOrder = Enum.SortOrder.LayoutOrder
    v138.Padding = UDim.new(0, 10)
    local v139, v140 = v91(v_u_137, { "Players", "Places" }, function(_) end)
    v139.LayoutOrder = 0
    local v_u_141 = Instance.new("Frame")
    v_u_141.Size = UDim2.new(1, 0, 1, -40)
    v_u_141.BackgroundTransparency = 1
    v_u_141.Visible = true
    v_u_141.LayoutOrder = 1
    v_u_141.Parent = v_u_137
    local v_u_142 = Instance.new("Frame")
    v_u_142.Size = UDim2.new(1, 0, 1, -40)
    v_u_142.BackgroundTransparency = 1
    v_u_142.Visible = false
    v_u_142.LayoutOrder = 1
    v_u_142.Parent = v_u_137
    for v_u_143, v144 in pairs(v140) do
        v144.MouseButton1Click:Connect(function()
            -- upvalues: (copy) v_u_143, (copy) v_u_141, (copy) v_u_142
            local v145 = v_u_143
            v_u_141.Visible = v145 == "Players"
            v_u_142.Visible = v145 == "Places"
        end)
    end
    local v146 = Instance.new("UIListLayout", v_u_141)
    v146.SortOrder = Enum.SortOrder.LayoutOrder
    v146.Padding = UDim.new(0, 8)
    local v147 = Instance.new("Frame")
    v147.Size = UDim2.new(1, 0, 0, 50)
    v147.BackgroundTransparency = 1
    v147.LayoutOrder = 0
    v147.Parent = v_u_141
    local PlaceId = game.PlaceId
    local v149, v150 = v64(v147, "PLACE ID", "e.g. 1818", tostring(PlaceId), UDim2.new(0.485, 0, 1, 0))
    local v_u_151 = v150
    v149.Position = UDim2.new(0, 0, 0, 0)
    local v152, v153 = v64(v147, "JOB ID", "Blank = new server", "", UDim2.new(0.485, 0, 1, 0))
    local v_u_154 = v153
    v152.Position = UDim2.new(0.515, 0, 0, 0)
    v_u_154.FocusLost:Connect(function()
        -- upvalues: (copy) AdminCommand, (ref) v_u_154, (ref) v_u_151
        AdminCommand:FireServer("updatesettings", v_u_154.Text, v_u_151.Text)
    end)
    v_u_151.FocusLost:Connect(function()
        -- upvalues: (copy) AdminCommand, (ref) v_u_154, (ref) v_u_151
        AdminCommand:FireServer("updatesettings", v_u_154.Text, v_u_151.Text)
    end)
    local v155 = Instance.new("Frame")
    v155.Size = UDim2.new(1, 0, 0, 32)
    v155.BackgroundTransparency = 1
    v155.LayoutOrder = 1
    v155.Parent = v_u_141
    local v_u_156 = v_u_39({
        ["Parent"] = nil,
        ["Text"] = "Mutuals only: On",
        ["Size"] = nil,
        ["Position"] = nil,
        ["Color"] = nil,
        ["HoverColor"] = nil,
        ["TextSize"] = 11,
        ["TextColor"] = nil,
        ["Parent"] = v155,
        ["Size"] = UDim2.new(0.36, 0, 1, 0),
        ["Position"] = UDim2.new(0, 0, 0, 0),
        ["Color"] = v_u_8.Card,
        ["HoverColor"] = v_u_8.CardHover,
        ["TextColor"] = v_u_8.TextPrimary
    })
    local Border_1 = v_u_8.Border
    local v158 = Instance.new("UIStroke")
    v158.Color = Border_1 or v_u_8.Border
    v158.Thickness = 1
    v158.Transparency = 0
    v158.Parent = v_u_156
    local v_u_159 = v_u_49({
        ["Parent"] = nil,
        ["Placeholder"] = "Search players...",
        ["Size"] = nil,
        ["Position"] = nil,
        ["Parent"] = v155,
        ["Size"] = UDim2.new(0.62, 0, 1, 0),
        ["Position"] = UDim2.new(0.38, 0, 0, 0)
    })
    local v_u_160 = v68(v_u_141, 164)
    v_u_160.LayoutOrder = 3
    local v161 = Instance.new("UIListLayout", v_u_160)
    v161.SortOrder = Enum.SortOrder.LayoutOrder
    v161.Padding = UDim.new(0, 4)
    local v162 = Instance.new("UIListLayout", v_u_142)
    v162.SortOrder = Enum.SortOrder.LayoutOrder
    v162.Padding = UDim.new(0, 8)
    v_u_56(v_u_142, "SAB PRESETS").LayoutOrder = 0
    local v163 = v_u_39({
        ["Parent"] = nil,
        ["Text"] = "SAB Normal",
        ["Size"] = nil,
        ["Color"] = nil,
        ["HoverColor"] = nil,
        ["TextSize"] = 13,
        ["Parent"] = v_u_142,
        ["Size"] = UDim2.new(1, 0, 0, 38),
        ["Color"] = v_u_8.Accent,
        ["HoverColor"] = v_u_8.AccentHover
    })
    v163.LayoutOrder = 1
    local v164 = v_u_39({
        ["Parent"] = nil,
        ["Text"] = "SAB New Player",
        ["Size"] = nil,
        ["Color"] = nil,
        ["HoverColor"] = nil,
        ["TextSize"] = 13,
        ["TextColor"] = nil,
        ["Parent"] = v_u_142,
        ["Size"] = UDim2.new(1, 0, 0, 38),
        ["Color"] = v_u_8.Card,
        ["HoverColor"] = v_u_8.CardHover,
        ["TextColor"] = v_u_8.TextPrimary
    })
    v164.LayoutOrder = 2
    local Border_2 = v_u_8.Border
    local v166 = Instance.new("UIStroke")
    v166.Color = Border_2 or v_u_8.Border
    v166.Thickness = 1
    v166.Transparency = 0
    v166.Parent = v164
    v163.MouseButton1Click:Connect(function()
        -- upvalues: (ref) v_u_151, (copy) AdminCommand, (ref) v_u_154
        v_u_151.Text = "109983668079237"
        AdminCommand:FireServer("updatesettings", v_u_154.Text, v_u_151.Text)
        AdminCommand:FireServer("sabnormal")
    end)
    v164.MouseButton1Click:Connect(function()
        -- upvalues: (ref) v_u_151, (copy) AdminCommand, (ref) v_u_154
        v_u_151.Text = "96342491571673"
        AdminCommand:FireServer("updatesettings", v_u_154.Text, v_u_151.Text)
        AdminCommand:FireServer("sabnewplayer")
    end)
    local v_u_167 = {}
    local v_u_168 = {}
    local v_u_169 = true
    local v_u_170 = {}
    local v_u_171 = false
    local function v_u_188(p172, p173, p174) -- name: MakePlayerCard
        -- upvalues: (copy) v_u_8, (copy) GothamMedium, (copy) Gotham
        local v175 = p174 or {}
        local v176 = Instance.new("Frame")
        v176.Size = UDim2.new(1, 0, 0, 48)
        v176.BackgroundColor3 = v_u_8.Card
        v176.BorderSizePixel = 0
        v176.Parent = p172
        local v177 = Instance.new("UICorner")
        v177.CornerRadius = UDim.new(0, 11)
        v177.Parent = v176
        local Border_3 = v_u_8.Border
        local v179 = Instance.new("UIStroke")
        v179.Color = Border_3 or v_u_8.Border
        v179.Thickness = 1
        v179.Transparency = 0
        v179.Parent = v176
        local v180 = Instance.new("Frame")
        v180.Size = UDim2.new(0, 34, 0, 34)
        v180.Position = UDim2.new(0, 9, 0.5, -17)
        v180.BackgroundColor3 = v_u_8.Panel
        v180.BorderSizePixel = 0
        v180.Parent = v176
        local v181 = Instance.new("UICorner")
        v181.CornerRadius = UDim.new(0, 9)
        v181.Parent = v180
        local Accent_1 = v_u_8.Accent
        local v183 = Instance.new("UIStroke")
        v183.Color = Accent_1 or v_u_8.Border
        v183.Thickness = 1
        v183.Transparency = 0.6
        v183.Parent = v180
        local v184 = Instance.new("ImageLabel")
        v184.Size = UDim2.new(1, -2, 1, -2)
        v184.Position = UDim2.new(0, 1, 0, 1)
        v184.BackgroundTransparency = 1
        v184.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. (p173.userId or (p173.UserId or 0)) .. "&width=60&height=60&format=png"
        v184.Parent = v180
        local v185 = Instance.new("UICorner")
        v185.CornerRadius = UDim.new(0, 8)
        v185.Parent = v184
        local v186 = Instance.new("TextLabel")
        v186.Text = p173.name or (p173.Name or "?")
        v186.Size = UDim2.new(0, 130, 0, 18)
        v186.Position = UDim2.new(0, 58, 0, 8)
        v186.BackgroundTransparency = 1
        v186.TextColor3 = v_u_8.TextPrimary
        v186.Font = GothamMedium
        v186.TextSize = 13
        v186.TextXAlignment = Enum.TextXAlignment.Left
        v186.TextTruncate = Enum.TextTruncate.AtEnd
        v186.Parent = v176
        if v175.subtitle then
            local v187 = Instance.new("TextLabel")
            v187.Text = v175.subtitle
            v187.Size = UDim2.new(0, 130, 0, 14)
            v187.Position = UDim2.new(0, 58, 0, 28)
            v187.BackgroundTransparency = 1
            v187.TextColor3 = v_u_8.TextMuted
            v187.Font = Gotham
            v187.TextSize = 10
            v187.TextXAlignment = Enum.TextXAlignment.Left
            v187.Parent = v176
        end
        return v176
    end
    local function v_u_197(p189, p190, p191, p192, p193, p194, p_u_195) -- name: AddActionButton
        -- upvalues: (copy) v_u_39
        local v_u_196 = v_u_39({
            ["Parent"] = nil,
            ["Text"] = nil,
            ["Size"] = nil,
            ["Position"] = nil,
            ["Color"] = nil,
            ["HoverColor"] = nil,
            ["TextSize"] = 10,
            ["Radius"] = 7,
            ["TextColor"] = nil,
            ["Parent"] = p189,
            ["Text"] = p190,
            ["Size"] = UDim2.new(0, p194 or 58, 0, 28),
            ["Position"] = UDim2.new(1, p193, 0.5, -14),
            ["Color"] = p191,
            ["HoverColor"] = p192,
            ["TextColor"] = Color3.fromRGB(255, 255, 255)
        })
        v_u_196.MouseButton1Click:Connect(function()
            -- upvalues: (copy) p_u_195, (copy) v_u_196
            p_u_195(v_u_196)
        end)
        return v_u_196
    end
    local function v_u_209(p_u_198) -- name: MakeTeleportPlayerRow
        -- upvalues: (copy) LocalPlayer, (copy) v_u_7, (ref) v_u_168, (ref) v_u_169, (ref) v_u_170, (ref) v_u_188, (copy) v_u_160, (ref) v_u_197, (copy) v_u_8, (ref) v_u_154, (ref) v_u_151, (copy) AdminCommand
        if p_u_198 == LocalPlayer then
            return nil
        end
        if not v_u_7 and v_u_168[p_u_198.UserId] then
            return nil
        end
        if v_u_169 then
            local v199 = v_u_170
            local UserId = p_u_198.UserId
            if not v199[tostring(UserId)] then
                return nil
            end
        end
        local v201 = v_u_170
        local UserId_0 = p_u_198.UserId
        local v203 = v201[tostring(UserId_0)]
        local v204
        if v203 and (v203.names and #v203.names > 0) then
            if v203.isDirect then
                v204 = "Friend: " .. table.concat(v203.names, ", ")
            else
                v204 = "Mutual: " .. table.concat(v203.names, ", ")
            end
        else
            v204 = "In this server"
        end
        local v205 = v_u_188(v_u_160, p_u_198, {
            ["subtitle"] = v204
        })
        v_u_197(v205, "Teleport", v_u_8.Accent, v_u_8.AccentHover, -140, 66, function()
            -- upvalues: (ref) v_u_154, (ref) v_u_151, (ref) AdminCommand, (copy) p_u_198
            local v206 = v_u_154.Text ~= "" and v_u_154.Text or nil
            local Text = v_u_151.Text ~= "" and v_u_151.Text
            if not Text then
                local PlaceId_0 = game.PlaceId
                Text = tostring(PlaceId_0)
            end
            AdminCommand:FireServer("teleportplayertoserver", p_u_198, v206, Text)
        end)
        v_u_197(v205, "Timeout", v_u_8.Warning, v_u_8.WarningHover, -70, 62, function(_)
            -- upvalues: (ref) AdminCommand, (copy) p_u_198
            AdminCommand:FireServer("timeout", p_u_198)
        end)
        return v205
    end
    local function v_u_216() -- name: UpdateTeleportPlayerList
        -- upvalues: (ref) v_u_167, (copy) v_u_159, (copy) Players, (copy) LocalPlayer, (copy) v_u_209, (ref) v_u_169, (ref) v_u_171, (copy) v_u_8, (copy) Gotham, (copy) v_u_160
        for _, v210 in pairs(v_u_167) do
            v210:Destroy()
        end
        v_u_167 = {}
        local v211 = string.lower(v_u_159.Text or "")
        local v212 = 0
        for _, v213 in pairs(Players:GetPlayers()) do
            if v213 ~= LocalPlayer and (v211 == "" or string.lower(v213.Name):find(v211, 1, true)) then
                local v214 = v_u_209(v213)
                if v214 then
                    v_u_167[v213.Name] = v214
                    v212 = v212 + 1
                end
            end
        end
        if v_u_169 and v212 == 0 then
            local v215 = Instance.new("TextLabel")
            v215.Size = UDim2.new(1, 0, 0, 30)
            v215.BackgroundTransparency = 1
            v215.Text = v_u_171 and "Loading friends..." or "No friends or mutuals found in this server."
            v215.TextColor3 = v_u_8.TextMuted
            v215.Font = Gotham
            v215.TextSize = 11
            v215.TextWrapped = true
            v215.Parent = v_u_160
            v_u_167.__mutuals_msg__ = v215
        end
    end
    v_u_159:GetPropertyChangedSignal("Text"):Connect(v_u_216)
    v_u_156.MouseButton1Click:Connect(function()
        -- upvalues: (ref) v_u_169, (copy) v_u_156, (ref) v_u_216
        v_u_169 = not v_u_169
        v_u_156.Text = "Mutuals only: " .. (v_u_169 and "On" or "Off")
        v_u_216()
    end)
    local v_u_217 = Instance.new("Frame")
    v_u_217.Size = UDim2.new(1, 0, 1, 0)
    v_u_217.BackgroundTransparency = 1
    v_u_217.Visible = false
    v_u_217.Parent = v136
    local v218 = Instance.new("UIListLayout", v_u_217)
    v218.SortOrder = Enum.SortOrder.LayoutOrder
    v218.Padding = UDim.new(0, 10)
    local v219, v_u_220 = v91(v_u_217, { "Search", "Staff", "Tracking" }, function(_) end)
    v219.LayoutOrder = 0
    v_u_220.Tracking.Text = "Tracking (0)"
    local v_u_221 = Instance.new("Frame")
    v_u_221.Size = UDim2.new(1, 0, 1, -42)
    v_u_221.BackgroundTransparency = 1
    v_u_221.Visible = true
    v_u_221.LayoutOrder = 1
    v_u_221.Parent = v_u_217
    local v_u_222 = Instance.new("Frame")
    v_u_222.Size = UDim2.new(1, 0, 1, -42)
    v_u_222.BackgroundTransparency = 1
    v_u_222.Visible = false
    v_u_222.LayoutOrder = 1
    v_u_222.Parent = v_u_217
    local v_u_223 = Instance.new("Frame")
    v_u_223.Size = UDim2.new(1, 0, 1, -42)
    v_u_223.BackgroundTransparency = 1
    v_u_223.Visible = false
    v_u_223.LayoutOrder = 1
    v_u_223.Parent = v_u_217
    local v224 = Instance.new("UIListLayout", v_u_221)
    v224.SortOrder = Enum.SortOrder.LayoutOrder
    v224.Padding = UDim.new(0, 8)
    local v225 = Instance.new("Frame")
    v225.Size = UDim2.new(1, 0, 0, 34)
    v225.BackgroundTransparency = 1
    v225.LayoutOrder = 0
    v225.Parent = v_u_221
    local v_u_226 = v_u_49({
        ["Parent"] = nil,
        ["Placeholder"] = "Username or user id...",
        ["Size"] = nil,
        ["Parent"] = v225,
        ["Size"] = UDim2.new(1, -74, 1, 0)
    })
    local v227 = v_u_39({
        ["Parent"] = nil,
        ["Text"] = "Search",
        ["Size"] = nil,
        ["Position"] = nil,
        ["Color"] = nil,
        ["HoverColor"] = nil,
        ["TextSize"] = 11,
        ["Parent"] = v225,
        ["Size"] = UDim2.new(0, 68, 1, 0),
        ["Position"] = UDim2.new(1, -68, 0, 0),
        ["Color"] = v_u_8.Accent,
        ["HoverColor"] = v_u_8.AccentHover
    })
    local v_u_228 = v68(v_u_221, 190)
    v_u_228.LayoutOrder = 1
    local v229 = v_u_228
    local v230 = Instance.new("UIListLayout", v229)
    v230.SortOrder = Enum.SortOrder.LayoutOrder
    v230.Padding = UDim.new(0, 4)
    local v_u_231 = {}
    local v_u_232 = "global"
    local function v_u_236(p233) -- name: ShowSearchPlaceholder
        -- upvalues: (ref) v_u_231, (copy) v_u_8, (copy) Gotham, (ref) v_u_228
        for _, v234 in pairs(v_u_231) do
            v234:Destroy()
        end
        v_u_231 = {}
        local v235 = Instance.new("TextLabel")
        v235.Size = UDim2.new(1, 0, 0, 30)
        v235.BackgroundTransparency = 1
        v235.Text = p233
        v235.TextColor3 = v_u_8.TextMuted
        v235.Font = Gotham
        v235.TextSize = 11
        v235.TextWrapped = true
        v235.Parent = v_u_228
        v_u_231.__msg__ = v235
    end
    local function v_u_248(p237) -- name: UpdateSearchResults
        -- upvalues: (ref) v_u_231, (copy) v_u_236, (ref) v_u_188, (ref) v_u_228, (copy) v_u_7, (ref) v_u_197, (copy) v_u_8, (copy) AdminCommand, (copy) Players
        for _, v238 in pairs(v_u_231) do
            v238:Destroy()
        end
        v_u_231 = {}
        if p237 and #p237 ~= 0 then
            for _, v_u_239 in pairs(p237) do
                local v_u_240 = v_u_239.inServer ~= false
                local v241 = v_u_188(v_u_228, v_u_239, {
                    ["subtitle"] = v_u_240 and "In this server" or "Other server"
                })
                if v_u_7 then
                    v_u_197(v241, "Ban", v_u_8.Danger, v_u_8.DangerHover, -196, 46, function(p_u_242)
                        -- upvalues: (ref) AdminCommand, (copy) v_u_239
                        AdminCommand:FireServer("ban", v_u_239.name)
                        p_u_242.Text = "Done"
                        task.delay(1.5, function()
                            -- upvalues: (copy) p_u_242
                            p_u_242.Text = "Ban"
                        end)
                    end)
                end
                v_u_197(v241, "Track", v_u_8.Success, v_u_8.SuccessHover, -142, 52, function(p_u_243)
                    -- upvalues: (ref) AdminCommand, (copy) v_u_239
                    AdminCommand:FireServer("track", {
                        ["userId"] = v_u_239.userId,
                        ["name"] = v_u_239.name
                    })
                    p_u_243.Text = "Done"
                    task.delay(1.5, function()
                        -- upvalues: (copy) p_u_243
                        p_u_243.Text = "Track"
                    end)
                end)
                v_u_197(v241, v_u_240 and "Go To" or "Join", v_u_240 and v_u_8.Accent or v_u_8.Warning, v_u_240 and v_u_8.AccentHover or v_u_8.WarningHover, -80, 68, function()
                    -- upvalues: (copy) v_u_240, (ref) Players, (copy) v_u_239, (ref) AdminCommand
                    if v_u_240 then
                        for _, v244 in pairs(Players:GetPlayers()) do
                            if v244.UserId == v_u_239.userId then
                                AdminCommand:FireServer("teleportmetoplayer", v244)
                                return
                            end
                        end
                    else
                        local v245 = AdminCommand
                        local jobId = v_u_239.jobId
                        local placeId = v_u_239.placeId
                        v245:FireServer("teleportmetoserver", jobId, (tostring(placeId)))
                    end
                end)
                v_u_231[v_u_239.userId] = v241
            end
        else
            v_u_236("No results. Check spelling (exact username required).")
        end
    end
    v_u_236("Type a name or user id, then press Search.")
    v_u_226:GetPropertyChangedSignal("Text"):Connect(function()
        -- upvalues: (copy) v_u_226, (ref) v_u_232, (copy) AdminCommand, (copy) v_u_236
        local Text_0 = v_u_226.Text
        if Text_0 == "" then
            v_u_236("Type a name or user id, then press Search.")
        else
            v_u_232 = "global"
            AdminCommand:FireServer("searchglobal", Text_0)
        end
    end)
    local function v250() -- name: RunOfflineSearch
        -- upvalues: (copy) v_u_226, (ref) v_u_232, (copy) AdminCommand
        if v_u_226.Text ~= "" then
            v_u_232 = "offline"
            AdminCommand:FireServer("searchoffline", v_u_226.Text)
        end
    end
    v_u_226.FocusLost:Connect(function(p251)
        -- upvalues: (copy) v_u_226, (ref) v_u_232, (copy) AdminCommand
        if p251 then
            if v_u_226.Text == "" then
                return
            end
            v_u_232 = "offline"
            AdminCommand:FireServer("searchoffline", v_u_226.Text)
        end
    end)
    v227.MouseButton1Click:Connect(v250)
    if v_u_7 then
        v_u_56(v_u_221, "UNTIMEOUT PLAYER").LayoutOrder = 2
        local v_u_252 = v_u_49({
            ["Parent"] = nil,
            ["Placeholder"] = "Username",
            ["Size"] = nil,
            ["Parent"] = v_u_221,
            ["Size"] = UDim2.new(1, 0, 0, 32)
        })
        v_u_252.LayoutOrder = 3
        local v253 = v_u_39({
            ["Parent"] = nil,
            ["Text"] = "UnTimeout Player (restores sign)",
            ["Size"] = nil,
            ["Color"] = nil,
            ["HoverColor"] = nil,
            ["TextSize"] = 11,
            ["Parent"] = v_u_221,
            ["Size"] = UDim2.new(1, 0, 0, 32),
            ["Color"] = v_u_8.Success,
            ["HoverColor"] = v_u_8.SuccessHover
        })
        v253.LayoutOrder = 4
        v253.MouseButton1Click:Connect(function()
            -- upvalues: (copy) v_u_252, (copy) AdminCommand
            local Text_1 = v_u_252.Text
            if Text_1 == "" then
                CreateAlert("Error", "Enter a username to un-timeout", nil, nil)
            else
                AdminCommand:FireServer("untimeout", Text_1)
            end
        end)
    end
    local v255 = Instance.new("UIListLayout", v_u_222)
    v255.SortOrder = Enum.SortOrder.LayoutOrder
    v255.Padding = UDim.new(0, 8)
    v_u_56(v_u_222, "ONLINE STAFF").LayoutOrder = 0
    local v_u_256 = v68(v_u_222, 300)
    v_u_256.LayoutOrder = 1
    local v257 = Instance.new("UIListLayout", v_u_256)
    v257.SortOrder = Enum.SortOrder.LayoutOrder
    v257.Padding = UDim.new(0, 4)
    local v_u_258 = {}
    local function v_u_265(p259) -- name: UpdateStaffList
        -- upvalues: (ref) v_u_258, (copy) v_u_8, (copy) Gotham, (copy) v_u_256, (copy) v_u_23, (ref) v_u_188
        for _, v260 in pairs(v_u_258) do
            v260:Destroy()
        end
        v_u_258 = {}
        if p259 and #p259 ~= 0 then
            for _, v261 in pairs(p259) do
                local v262
                if v261.isOwner then
                    v262 = "Owner - unlimited"
                elseif v261.paused then
                    v262 = v_u_23(v261.timeLeft) .. " left (paused)"
                else
                    v262 = v_u_23(v261.timeLeft) .. " left"
                end
                local v263 = v_u_188(v_u_256, v261, {
                    ["subtitle"] = v262
                })
                v_u_258[v261.userId] = v263
            end
        else
            local v264 = Instance.new("TextLabel")
            v264.Size = UDim2.new(1, 0, 0, 30)
            v264.BackgroundTransparency = 1
            v264.Text = "No staff online."
            v264.TextColor3 = v_u_8.TextMuted
            v264.Font = Gotham
            v264.TextSize = 11
            v264.Parent = v_u_256
            v_u_258.__none__ = v264
        end
    end
    local v266 = Instance.new("UIListLayout", v_u_223)
    v266.SortOrder = Enum.SortOrder.LayoutOrder
    v266.Padding = UDim.new(0, 8)
    v_u_56(v_u_223, "TRACKED PLAYERS").LayoutOrder = 0
    local v_u_267 = v68(v_u_223, 300)
    v_u_267.LayoutOrder = 1
    local v268 = Instance.new("UIListLayout", v_u_267)
    v268.SortOrder = Enum.SortOrder.LayoutOrder
    v268.Padding = UDim.new(0, 4)
    local v_u_269 = {}
    local function v_u_280(p270) -- name: UpdateTrackedList
        -- upvalues: (ref) v_u_269, (copy) AdminCommand, (copy) v_u_220, (copy) v_u_8, (copy) Gotham, (copy) v_u_267, (ref) v_u_188, (ref) v_u_197, (copy) Players
        for _, v271 in pairs(v_u_269) do
            v271:Destroy()
        end
        v_u_269 = {}
        if p270 then
            v_u_220.Tracking.Text = "Tracking (" .. #p270 .. ")"
            if #p270 == 0 then
                local v272 = Instance.new("TextLabel")
                v272.Size = UDim2.new(1, 0, 0, 30)
                v272.BackgroundTransparency = 1
                v272.Text = "Not tracking anyone yet. Use Search or Teleport to track a player."
                v272.TextColor3 = v_u_8.TextMuted
                v272.Font = Gotham
                v272.TextSize = 11
                v272.TextWrapped = true
                v272.Parent = v_u_267
                v_u_269.__none__ = v272
            else
                for _, v_u_273 in pairs(p270) do
                    local v274 = v_u_188(v_u_267, v_u_273, {
                        ["subtitle"] = v_u_273.online and "Online" or "Offline"
                    })
                    v_u_197(v274, "Untrack", v_u_8.Danger, v_u_8.DangerHover, -140, 62, function()
                        -- upvalues: (ref) AdminCommand, (copy) v_u_273
                        AdminCommand:FireServer("untrack", v_u_273.userId)
                        task.wait(0.4)
                        AdminCommand:FireServer("gettracked")
                    end)
                    if v_u_273.online and v_u_273.jobId then
                        local JobId = v_u_273.jobId == game.JobId
                        v_u_197(v274, JobId and "Go To" or "Join", v_u_8.Accent, v_u_8.AccentHover, -74, 64, function()
                            -- upvalues: (copy) JobId, (ref) Players, (copy) v_u_273, (ref) AdminCommand
                            if JobId then
                                for _, v276 in pairs(Players:GetPlayers()) do
                                    if v276.UserId == v_u_273.userId then
                                        AdminCommand:FireServer("teleportmetoplayer", v276)
                                        return
                                    end
                                end
                            else
                                local v277 = AdminCommand
                                local jobId_0 = v_u_273.jobId
                                local PlaceId_1 = v_u_273.placeId or game.PlaceId
                                v277:FireServer("teleportmetoserver", jobId_0, (tostring(PlaceId_1)))
                            end
                        end)
                    else
                        v_u_197(v274, "Go To", v_u_8.Card, v_u_8.CardHover, -74, 64, function() end)
                    end
                    v_u_269[v_u_273.userId] = v274
                end
            end
        else
            AdminCommand:FireServer("gettracked")
            return
        end
    end
    local v_u_281 = v_u_231
    local v_u_282 = v_u_216
    local v_u_283 = v_u_154
    local v_u_284 = v_u_151
    local v_u_285 = v_u_171
    local v_u_286 = v_u_232
    local v_u_287 = v_u_228
    local v_u_288 = v_u_170
    local v_u_289 = v_u_168
    local v_u_290 = v_u_197
    local v_u_291 = v_u_188
    for v_u_292, v293 in pairs(v_u_220) do
        v293.MouseButton1Click:Connect(function()
            -- upvalues: (copy) v_u_292, (copy) v_u_221, (copy) v_u_222, (ref) v_u_223, (copy) AdminCommand
            local v294 = v_u_292
            v_u_221.Visible = v294 == "Search"
            v_u_222.Visible = v294 == "Staff"
            v_u_223.Visible = v294 == "Tracking"
            if v294 == "Staff" then
                AdminCommand:FireServer("getstafflist")
            elseif v294 == "Tracking" then
                AdminCommand:FireServer("gettracked")
            end
        end)
    end
    local v_u_295 = {}
    local v_u_296 = Instance.new("Frame")
    v_u_296.Size = UDim2.new(1, 0, 1, 0)
    v_u_296.BackgroundTransparency = 1
    v_u_296.Visible = false
    v_u_296.Parent = v136
    local v297 = Instance.new("UIListLayout", v_u_296)
    v297.SortOrder = Enum.SortOrder.LayoutOrder
    v297.Padding = UDim.new(0, 10)
    local v298, v299 = v91(v_u_296, { "Add Friend", "My Whitelisted" }, function(_) end)
    v298.LayoutOrder = 0
    local v_u_300 = Instance.new("Frame")
    v_u_300.Size = UDim2.new(1, 0, 1, -40)
    v_u_300.BackgroundTransparency = 1
    v_u_300.Visible = true
    v_u_300.LayoutOrder = 1
    v_u_300.Parent = v_u_296
    local v_u_301 = Instance.new("Frame")
    v_u_301.Size = UDim2.new(1, 0, 1, -40)
    v_u_301.BackgroundTransparency = 1
    v_u_301.Visible = false
    v_u_301.LayoutOrder = 1
    v_u_301.Parent = v_u_296
    local v302 = Instance.new("UIListLayout", v_u_300)
    v302.SortOrder = Enum.SortOrder.LayoutOrder
    v302.Padding = UDim.new(0, 8)
    v_u_56(v_u_300, "YOUR FRIENDS IN THIS SERVER").LayoutOrder = 0
    local v_u_303 = v68(v_u_300, 360)
    v_u_303.LayoutOrder = 1
    local v304 = Instance.new("UIListLayout", v_u_303)
    v304.SortOrder = Enum.SortOrder.LayoutOrder
    v304.Padding = UDim.new(0, 4)
    local v_u_305 = {}
    local function v316() -- name: UpdateFriendsAddList
        -- upvalues: (ref) v_u_305, (copy) Players, (copy) LocalPlayer, (ref) v_u_289, (ref) v_u_288, (ref) v_u_291, (copy) v_u_303, (ref) v_u_290, (copy) v_u_8, (copy) v_u_295, (copy) AdminCommand, (copy) Gotham
        for _, v306 in pairs(v_u_305) do
            v306:Destroy()
        end
        v_u_305 = {}
        local v307 = 0
        for _, v_u_308 in pairs(Players:GetPlayers()) do
            if v_u_308 ~= LocalPlayer and not v_u_289[v_u_308.UserId] then
                local v309 = v_u_288
                local UserId_1 = v_u_308.UserId
                local v311 = v309[tostring(UserId_1)]
                if v311 and (v311.names and #v311.names > 0) then
                    local v312
                    if v311.isDirect then
                        v312 = "Friend: " .. table.concat(v311.names, ", ")
                    else
                        v312 = "Mutual: " .. table.concat(v311.names, ", ")
                    end
                    local v313 = v_u_291(v_u_303, v_u_308, {
                        ["subtitle"] = v312
                    })
                    v_u_290(v313, "Whitelist Friend", v_u_8.Success, v_u_8.SuccessHover, -118, 108, function(p314)
                        -- upvalues: (ref) v_u_295, (copy) v_u_308, (ref) AdminCommand
                        p314.Text = "..."
                        v_u_295[v_u_308.UserId] = p314
                        AdminCommand:FireServer("whitelistmyfriend", v_u_308.UserId)
                    end)
                    v_u_305[v_u_308.Name] = v313
                    v307 = v307 + 1
                end
            end
        end
        if v307 == 0 then
            local v315 = Instance.new("TextLabel")
            v315.Size = UDim2.new(1, 0, 0, 30)
            v315.BackgroundTransparency = 1
            v315.Text = "No friends or mutuals in this server to whitelist right now."
            v315.TextColor3 = v_u_8.TextMuted
            v315.Font = Gotham
            v315.TextSize = 11
            v315.TextWrapped = true
            v315.Parent = v_u_303
            v_u_305.__none__ = v315
        end
    end
    local v317 = Instance.new("UIListLayout", v_u_301)
    v317.SortOrder = Enum.SortOrder.LayoutOrder
    v317.Padding = UDim.new(0, 8)
    v_u_56(v_u_301, "FRIENDS YOU\'VE WHITELISTED").LayoutOrder = 0
    local v_u_318 = v68(v_u_301, 360)
    v_u_318.LayoutOrder = 1
    local v319 = Instance.new("UIListLayout", v_u_318)
    v319.SortOrder = Enum.SortOrder.LayoutOrder
    v319.Padding = UDim.new(0, 4)
    local v_u_320 = {}
    local function v_u_326(p321) -- name: UpdateMyWhitelistedFriends
        -- upvalues: (ref) v_u_320, (copy) v_u_8, (copy) Gotham, (copy) v_u_318, (ref) v_u_291
        for _, v322 in pairs(v_u_320) do
            v322:Destroy()
        end
        v_u_320 = {}
        if p321 and #p321 ~= 0 then
            for _, v323 in pairs(p321) do
                local v324 = v_u_291(v_u_318, v323, {
                    ["subtitle"] = "Whitelisted by you"
                })
                v_u_320[v323.userId] = v324
            end
        else
            local v325 = Instance.new("TextLabel")
            v325.Size = UDim2.new(1, 0, 0, 30)
            v325.BackgroundTransparency = 1
            v325.Text = "You haven\'t whitelisted any friends yet."
            v325.TextColor3 = v_u_8.TextMuted
            v325.Font = Gotham
            v325.TextSize = 11
            v325.TextWrapped = true
            v325.Parent = v_u_318
            v_u_320.__none__ = v325
        end
    end
    local v_u_327 = v316
    for v_u_328, v329 in pairs(v299) do
        v329.MouseButton1Click:Connect(function()
            -- upvalues: (copy) v_u_328, (copy) v_u_300, (copy) v_u_301, (ref) v_u_327, (copy) AdminCommand
            local v330 = v_u_328
            v_u_300.Visible = v330 == "Add Friend"
            v_u_301.Visible = v330 == "My Whitelisted"
            if v330 == "Add Friend" then
                v_u_327()
            elseif v330 == "My Whitelisted" then
                AdminCommand:FireServer("getmywhitelistedfriends")
            end
        end)
    end
    local v_u_331 = {
        ["Red"] = Color3.fromRGB(235, 80, 80),
        ["Orange"] = Color3.fromRGB(255, 150, 60),
        ["Yellow"] = Color3.fromRGB(255, 210, 60),
        ["Green"] = Color3.fromRGB(70, 200, 120),
        ["Blue"] = Color3.fromRGB(70, 140, 235),
        ["Purple"] = Color3.fromRGB(170, 100, 235)
    }
    local v_u_332 = Instance.new("Frame")
    v_u_332.Size = UDim2.new(1, 0, 1, 0)
    v_u_332.BackgroundTransparency = 1
    v_u_332.Visible = false
    v_u_332.Parent = v136
    local v333 = Instance.new("UIListLayout", v_u_332)
    v333.SortOrder = Enum.SortOrder.LayoutOrder
    v333.Padding = UDim.new(0, 10)
    local v334, v335 = v91(v_u_332, {
        "Balance",
        "Play",
        "Last 20 Rolls",
        "My Keys"
    }, function(_) end)
    v334.LayoutOrder = 0
    local v_u_336 = Instance.new("Frame")
    v_u_336.Size = UDim2.new(1, 0, 1, -42)
    v_u_336.BackgroundTransparency = 1
    v_u_336.Visible = true
    v_u_336.LayoutOrder = 1
    v_u_336.Parent = v_u_332
    local v_u_337 = Instance.new("Frame")
    v_u_337.Size = UDim2.new(1, 0, 1, -42)
    v_u_337.BackgroundTransparency = 1
    v_u_337.Visible = false
    v_u_337.LayoutOrder = 1
    v_u_337.Parent = v_u_332
    local v_u_338 = Instance.new("Frame")
    v_u_338.Size = UDim2.new(1, 0, 1, -42)
    v_u_338.BackgroundTransparency = 1
    v_u_338.Visible = false
    v_u_338.LayoutOrder = 1
    v_u_338.Parent = v_u_332
    local v_u_339 = Instance.new("Frame")
    v_u_339.Size = UDim2.new(1, 0, 1, -42)
    v_u_339.BackgroundTransparency = 1
    v_u_339.Visible = false
    v_u_339.LayoutOrder = 1
    v_u_339.Parent = v_u_332
    local function v352(p340, p341, p342, p343, p344) -- name: MakeActionCard
        -- upvalues: (copy) v_u_8, (copy) v_u_30, (copy) GothamBold, (copy) Gotham
        local v345 = Instance.new("Frame")
        v345.Size = UDim2.new(1, 0, 0, 92)
        v345.BackgroundColor3 = v_u_8.Card
        v345.BorderSizePixel = 0
        v345.LayoutOrder = p341
        v345.Parent = p340
        local v346 = Instance.new("UICorner")
        v346.CornerRadius = UDim.new(0, 11)
        v346.Parent = v345
        local Border_4 = v_u_8.Border
        local v348 = Instance.new("UIStroke")
        v348.Color = Border_4 or v_u_8.Border
        v348.Thickness = 1
        v348.Transparency = 0
        v348.Parent = v345
        v_u_30(v345, 14, 14, 10, 10)
        local v349 = Instance.new("TextLabel")
        v349.Size = UDim2.new(1, 0, 0, 16)
        v349.BackgroundTransparency = 1
        v349.Text = p342
        v349.TextColor3 = p344 or v_u_8.TextPrimary
        v349.Font = GothamBold
        v349.TextSize = 12
        v349.TextXAlignment = Enum.TextXAlignment.Left
        v349.Parent = v345
        local v350 = Instance.new("TextLabel")
        v350.Size = UDim2.new(1, 0, 0, 14)
        v350.Position = UDim2.new(0, 0, 0, 18)
        v350.BackgroundTransparency = 1
        v350.Text = p343
        v350.TextColor3 = v_u_8.TextMuted
        v350.Font = Gotham
        v350.TextSize = 10
        v350.TextXAlignment = Enum.TextXAlignment.Left
        v350.TextWrapped = true
        v350.Parent = v345
        local v351 = Instance.new("Frame")
        v351.Size = UDim2.new(1, 0, 0, 32)
        v351.Position = UDim2.new(0, 0, 0, 42)
        v351.BackgroundTransparency = 1
        v351.Parent = v345
        return v345, v351
    end
    local v353 = Instance.new("UIListLayout", v_u_336)
    v353.SortOrder = Enum.SortOrder.LayoutOrder
    v353.Padding = UDim.new(0, 8)
    local v354 = Instance.new("Frame")
    v354.Size = UDim2.new(1, 0, 0, 64)
    v354.BackgroundColor3 = v_u_8.Card
    v354.BorderSizePixel = 0
    v354.LayoutOrder = 0
    v354.Parent = v_u_336
    local v355 = Instance.new("UICorner")
    v355.CornerRadius = UDim.new(0, 11)
    v355.Parent = v354
    local Border_5 = v_u_8.Border
    local v357 = Instance.new("UIStroke")
    v357.Color = Border_5 or v_u_8.Border
    v357.Thickness = 1
    v357.Transparency = 0
    v357.Parent = v354
    v_u_30(v354, 14, 14, 10, 10)
    local v358 = Instance.new("Frame")
    v358.Size = UDim2.new(0, 40, 0, 40)
    v358.Position = UDim2.new(0, 0, 0.5, -20)
    v358.BackgroundColor3 = v_u_8.Warning
    v358.BorderSizePixel = 0
    v358.Parent = v354
    local v359 = Instance.new("UICorner")
    v359.CornerRadius = UDim.new(0, 20)
    v359.Parent = v358
    local v360 = Instance.new("TextLabel")
    v360.Size = UDim2.new(1, 0, 1, 0)
    v360.BackgroundTransparency = 1
    v360.Text = "B"
    v360.TextColor3 = Color3.fromRGB(40, 30, 5)
    v360.Font = GothamBlack
    v360.TextSize = 16
    v360.Parent = v358
    local v361 = Instance.new("TextLabel")
    v361.Size = UDim2.new(0, 200, 0, 14)
    v361.Position = UDim2.new(0, 52, 0, 0)
    v361.BackgroundTransparency = 1
    v361.Text = "YOUR BALANCE"
    v361.TextColor3 = v_u_8.TextSecondary
    v361.Font = GothamBold
    v361.TextSize = 10
    v361.TextXAlignment = Enum.TextXAlignment.Left
    v361.Parent = v354
    local v_u_362 = Instance.new("TextLabel")
    v_u_362.Size = UDim2.new(0, 200, 0, 26)
    v_u_362.Position = UDim2.new(0, 52, 0, 14)
    v_u_362.BackgroundTransparency = 1
    v_u_362.Text = "0 min"
    v_u_362.TextColor3 = v_u_8.Warning
    v_u_362.Font = GothamBlack
    v_u_362.TextSize = 20
    v_u_362.TextXAlignment = Enum.TextXAlignment.Left
    v_u_362.Parent = v354
    local v363 = Instance.new("TextLabel")
    v363.Size = UDim2.new(0, 120, 0, 14)
    v363.Position = UDim2.new(1, -120, 0, 0)
    v363.BackgroundTransparency = 1
    v363.Text = 60 .. " to a 1h key"
    v363.TextColor3 = v_u_8.TextMuted
    v363.Font = Gotham
    v363.TextSize = 10
    v363.TextXAlignment = Enum.TextXAlignment.Right
    v363.Parent = v354
    local _, v364 = v352(v_u_336, 1, "Deposit time -> balance", "Move admin minutes into your dice balance to bet")
    local v_u_365 = v_u_49({
        ["Parent"] = nil,
        ["Placeholder"] = "minutes",
        ["Size"] = nil,
        ["Parent"] = v364,
        ["Size"] = UDim2.new(0.5, -4, 1, 0)
    })
    local v366 = v_u_39({
        ["Parent"] = nil,
        ["Text"] = "All",
        ["Size"] = nil,
        ["Position"] = nil,
        ["Color"] = nil,
        ["HoverColor"] = nil,
        ["TextSize"] = 11,
        ["TextColor"] = nil,
        ["Parent"] = v364,
        ["Size"] = UDim2.new(0.2, -4, 1, 0),
        ["Position"] = UDim2.new(0.5, 4, 0, 0),
        ["Color"] = v_u_8.Card,
        ["HoverColor"] = v_u_8.CardHover,
        ["TextColor"] = v_u_8.TextPrimary
    })
    local Border_6 = v_u_8.Border
    local v368 = Instance.new("UIStroke")
    v368.Color = Border_6 or v_u_8.Border
    v368.Thickness = 1
    v368.Transparency = 0
    v368.Parent = v366
    local v369 = v_u_39({
        ["Parent"] = nil,
        ["Text"] = "Deposit",
        ["Size"] = nil,
        ["Position"] = nil,
        ["Color"] = nil,
        ["HoverColor"] = nil,
        ["TextSize"] = 11,
        ["Parent"] = v364,
        ["Size"] = UDim2.new(0.3, -4, 1, 0),
        ["Position"] = UDim2.new(0.7, 4, 0, 0),
        ["Color"] = v_u_8.Accent,
        ["HoverColor"] = v_u_8.AccentHover
    })
    v366.MouseButton1Click:Connect(function()
        -- upvalues: (copy) AdminCommand
        AdminCommand:FireServer("dicedeposit", 0)
    end)
    v369.MouseButton1Click:Connect(function()
        -- upvalues: (copy) v_u_365, (copy) AdminCommand
        local Text_2 = v_u_365.Text
        local v371 = tonumber(Text_2) or 0
        if v371 <= 0 then
            CreateAlert("Error", "Enter a number of minutes to deposit", nil, nil)
        else
            AdminCommand:FireServer("dicedeposit", v371)
            v_u_365.Text = ""
        end
    end)
    local _, v372 = v352(v_u_336, 2, "Withdraw balance -> time", "Turn balance back into admin time on your timer")
    local v_u_373 = v_u_49({
        ["Parent"] = nil,
        ["Placeholder"] = "minutes",
        ["Size"] = nil,
        ["Parent"] = v372,
        ["Size"] = UDim2.new(0.5, -4, 1, 0)
    })
    local v374 = v_u_39({
        ["Parent"] = nil,
        ["Text"] = "All",
        ["Size"] = nil,
        ["Position"] = nil,
        ["Color"] = nil,
        ["HoverColor"] = nil,
        ["TextSize"] = 11,
        ["TextColor"] = nil,
        ["Parent"] = v372,
        ["Size"] = UDim2.new(0.2, -4, 1, 0),
        ["Position"] = UDim2.new(0.5, 4, 0, 0),
        ["Color"] = v_u_8.Card,
        ["HoverColor"] = v_u_8.CardHover,
        ["TextColor"] = v_u_8.TextPrimary
    })
    local Border_7 = v_u_8.Border
    local v376 = Instance.new("UIStroke")
    v376.Color = Border_7 or v_u_8.Border
    v376.Thickness = 1
    v376.Transparency = 0
    v376.Parent = v374
    local v377 = v_u_39({
        ["Parent"] = nil,
        ["Text"] = "Withdraw",
        ["Size"] = nil,
        ["Position"] = nil,
        ["Color"] = nil,
        ["HoverColor"] = nil,
        ["TextSize"] = 11,
        ["Parent"] = v372,
        ["Size"] = UDim2.new(0.3, -4, 1, 0),
        ["Position"] = UDim2.new(0.7, 4, 0, 0),
        ["Color"] = v_u_8.Success,
        ["HoverColor"] = v_u_8.SuccessHover
    })
    v374.MouseButton1Click:Connect(function()
        -- upvalues: (copy) AdminCommand
        AdminCommand:FireServer("dicewithdraw", 0)
    end)
    v377.MouseButton1Click:Connect(function()
        -- upvalues: (copy) v_u_373, (copy) AdminCommand
        local Text_3 = v_u_373.Text
        local v379 = tonumber(Text_3) or 0
        if v379 <= 0 then
            CreateAlert("Error", "Enter a number of minutes to withdraw", nil, nil)
        else
            AdminCommand:FireServer("dicewithdraw", v379)
            v_u_373.Text = ""
        end
    end)
    local v380 = Instance.new("Frame")
    v380.Size = UDim2.new(1, 0, 0, 112)
    v380.BackgroundColor3 = v_u_8.Card
    v380.BorderSizePixel = 0
    v380.LayoutOrder = 3
    v380.Parent = v_u_336
    local v381 = Instance.new("UICorner")
    v381.CornerRadius = UDim.new(0, 11)
    v381.Parent = v380
    local Warning_0 = v_u_8.Warning
    local v383 = Instance.new("UIStroke")
    v383.Color = Warning_0 or v_u_8.Border
    v383.Thickness = 1
    v383.Transparency = 0.5
    v383.Parent = v380
    v_u_30(v380, 14, 14, 10, 10)
    local v384 = Instance.new("TextLabel")
    v384.Size = UDim2.new(1, 0, 0, 16)
    v384.BackgroundTransparency = 1
    v384.Text = "Cash out a 1-hour admin key"
    v384.TextColor3 = v_u_8.Warning
    v384.Font = GothamBold
    v384.TextSize = 12
    v384.TextXAlignment = Enum.TextXAlignment.Left
    v384.Parent = v380
    local v385 = Instance.new("TextLabel")
    v385.Size = UDim2.new(1, 0, 0, 14)
    v385.Position = UDim2.new(0, 0, 0, 18)
    v385.BackgroundTransparency = 1
    v385.Text = "Spend " .. 60 .. " balance for a redeemable 1-hour key"
    v385.TextColor3 = v_u_8.TextMuted
    v385.Font = Gotham
    v385.TextSize = 10
    v385.TextXAlignment = Enum.TextXAlignment.Left
    v385.Parent = v380
    local v386 = v_u_39({
        ["Parent"] = nil,
        ["Text"] = "Cash out 1h key",
        ["Size"] = nil,
        ["Position"] = nil,
        ["Color"] = nil,
        ["HoverColor"] = nil,
        ["TextSize"] = 12,
        ["Parent"] = v380,
        ["Size"] = UDim2.new(1, 0, 0, 32),
        ["Position"] = UDim2.new(0, 0, 0, 40),
        ["Color"] = v_u_8.Warning,
        ["HoverColor"] = v_u_8.WarningHover
    })
    local v_u_387 = v_u_49({
        ["Parent"] = nil,
        ["Text"] = "",
        ["Placeholder"] = "Your key will appear here after cashing out",
        ["Size"] = nil,
        ["Position"] = nil,
        ["Parent"] = v380,
        ["Size"] = UDim2.new(1, 0, 0, 30),
        ["Position"] = UDim2.new(0, 0, 0, 78)
    })
    v_u_387.TextEditable = false
    v386.MouseButton1Click:Connect(function()
        -- upvalues: (copy) AdminCommand
        AdminCommand:FireServer("dicecashoutkey")
    end)
    local v388 = Instance.new("UIListLayout", v_u_337)
    v388.SortOrder = Enum.SortOrder.LayoutOrder
    v388.Padding = UDim.new(0, 8)
    local v389 = Instance.new("Frame")
    v389.Size = UDim2.new(1, 0, 0, 40)
    v389.BackgroundColor3 = v_u_8.Card
    v389.BorderSizePixel = 0
    v389.LayoutOrder = 0
    v389.Parent = v_u_337
    local v390 = Instance.new("UICorner")
    v390.CornerRadius = UDim.new(0, 10)
    v390.Parent = v389
    v_u_30(v389, 12, 12, 0, 0)
    local v391 = Instance.new("Frame")
    v391.Size = UDim2.new(0, 24, 0, 24)
    v391.Position = UDim2.new(0, 0, 0.5, -12)
    v391.BackgroundColor3 = v_u_8.Warning
    v391.BorderSizePixel = 0
    v391.Parent = v389
    local v392 = Instance.new("UICorner")
    v392.CornerRadius = UDim.new(0, 12)
    v392.Parent = v391
    local v393 = Instance.new("TextLabel")
    v393.Size = UDim2.new(1, 0, 1, 0)
    v393.BackgroundTransparency = 1
    v393.Text = "B"
    v393.TextColor3 = Color3.fromRGB(40, 30, 5)
    v393.Font = GothamBlack
    v393.TextSize = 11
    v393.Parent = v391
    local v_u_394 = Instance.new("TextLabel")
    v_u_394.Size = UDim2.new(1, -36, 1, 0)
    v_u_394.Position = UDim2.new(0, 34, 0, 0)
    v_u_394.BackgroundTransparency = 1
    v_u_394.Text = "BALANCE: 0 min"
    v_u_394.TextColor3 = v_u_8.TextPrimary
    v_u_394.Font = GothamMedium
    v_u_394.TextSize = 12
    v_u_394.TextXAlignment = Enum.TextXAlignment.Left
    v_u_394.Parent = v389
    local v395 = Instance.new("Frame")
    v395.Size = UDim2.new(1, 0, 0, 90)
    v395.BackgroundColor3 = v_u_8.Card
    v395.BorderSizePixel = 0
    v395.LayoutOrder = 1
    v395.Parent = v_u_337
    local v396 = Instance.new("UICorner")
    v396.CornerRadius = UDim.new(0, 12)
    v396.Parent = v395
    local Border_8 = v_u_8.Border
    local v398 = Instance.new("UIStroke")
    v398.Color = Border_8 or v_u_8.Border
    v398.Thickness = 1
    v398.Transparency = 0
    v398.Parent = v395
    local v399 = Instance.new("UIListLayout", v395)
    v399.FillDirection = Enum.FillDirection.Horizontal
    v399.SortOrder = Enum.SortOrder.LayoutOrder
    v399.Padding = UDim.new(0, 10)
    v399.HorizontalAlignment = Enum.HorizontalAlignment.Center
    v399.VerticalAlignment = Enum.VerticalAlignment.Center
    local v_u_400 = {}
    local v401 = {
        "Red",
        "Orange",
        "Yellow",
        "Green",
        "Blue",
        "Purple"
    }
    local v_u_402 = 0
    for v403 = 1, 4 do
        local v404 = Instance.new("Frame")
        v404.Size = UDim2.new(0, 56, 0, 56)
        v404.BackgroundColor3 = v_u_8.PillBg
        v404.BorderSizePixel = 0
        v404.LayoutOrder = v403
        v404.Parent = v395
        local v405 = Instance.new("UICorner")
        v405.CornerRadius = UDim.new(0, 12)
        v405.Parent = v404
        local Border_9 = v_u_8.Border
        local v407 = Instance.new("UIStroke")
        v407.Color = Border_9 or v_u_8.Border
        v407.Thickness = 1
        v407.Transparency = 0
        v407.Parent = v404
        local v408 = Instance.new("Frame")
        v408.Size = UDim2.new(0, 12, 0, 12)
        v408.Position = UDim2.new(0.5, -6, 0.5, -6)
        v408.BackgroundColor3 = v_u_8.TextMuted
        v408.BorderSizePixel = 0
        v408.Parent = v404
        local v409 = Instance.new("UICorner")
        v409.CornerRadius = UDim.new(0, 6)
        v409.Parent = v408
        v_u_400[v403] = {
            ["Face"] = v404,
            ["Dot"] = v408
        }
    end
    v_u_56(v_u_337, "PICK YOUR COLOR").LayoutOrder = 2
    local v410 = Instance.new("Frame")
    v410.Size = UDim2.new(1, 0, 0, 44)
    v410.BackgroundTransparency = 1
    v410.LayoutOrder = 3
    v410.Parent = v_u_337
    local v411 = Instance.new("UIListLayout", v410)
    v411.FillDirection = Enum.FillDirection.Horizontal
    v411.SortOrder = Enum.SortOrder.LayoutOrder
    v411.Padding = UDim.new(0, 8)
    local v_u_412 = "Red"
    local v_u_413 = {}
    local function v_u_418(p414) -- name: ShowDiceResult
        -- upvalues: (copy) v_u_331, (copy) v_u_8, (copy) v_u_400
        for v415 = 1, 4 do
            local v416
            if p414 then
                v416 = p414[v415]
            else
                v416 = p414
            end
            local PillBg = v416 and v_u_331[v416] or v_u_8.PillBg
            v_u_400[v415].Face.BackgroundColor3 = PillBg
            v_u_400[v415].Dot.BackgroundColor3 = v416 and Color3.new(1, 1, 1) or v_u_8.TextMuted
        end
    end
    for v419, v420 in ipairs(v401) do
        local v421 = Instance.new("TextButton")
        v421.Size = UDim2.new(0, 44, 0, 44)
        v421.BackgroundColor3 = v_u_331[v420]
        v421.Text = ""
        v421.AutoButtonColor = false
        v421.BorderSizePixel = 0
        v421.LayoutOrder = v419
        v421.Parent = v410
        local v422 = Instance.new("UICorner")
        v422.CornerRadius = UDim.new(0, 10)
        v422.Parent = v421
        local v423 = Color3.new(1, 1, 1)
        local v424 = v420 == v_u_412 and 0 or 1
        local v425 = Instance.new("UIStroke")
        v425.Color = v423 or v_u_8.Border
        v425.Thickness = 2
        v425.Transparency = v424 or 0
        v425.Parent = v421
        v_u_413[v420] = {
            ["Button"] = v421,
            ["Stroke"] = v425
        }
    end
    local v_u_426 = Instance.new("TextLabel")
    v_u_426.Size = UDim2.new(1, 0, 0, 16)
    v_u_426.BackgroundTransparency = 1
    v_u_426.Text = "Selected: " .. v_u_412
    v_u_426.TextColor3 = v_u_331[v_u_412]
    v_u_426.Font = GothamBold
    v_u_426.TextSize = 11
    v_u_426.TextXAlignment = Enum.TextXAlignment.Center
    v_u_426.LayoutOrder = 4
    v_u_426.Parent = v_u_337
    local function v_u_432(p427) -- name: SelectDiceColor
        -- upvalues: (ref) v_u_412, (copy) v_u_413, (copy) TweenService, (copy) v_u_426, (copy) v_u_331
        v_u_412 = p427
        for v428, v429 in pairs(v_u_413) do
            local Stroke = v429.Stroke
            local v431 = {
                ["Transparency"] = v428 == p427 and 0 or 1
            }
            TweenService:Create(Stroke, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), v431):Play()
        end
        v_u_426.Text = "Selected: " .. p427
        v_u_426.TextColor3 = v_u_331[p427]
    end
    for v_u_433, v434 in pairs(v_u_413) do
        v434.Button.MouseButton1Click:Connect(function()
            -- upvalues: (copy) v_u_432, (copy) v_u_433
            v_u_432(v_u_433)
        end)
    end
    v_u_56(v_u_337, "YOUR BET").LayoutOrder = 5
    local v435 = Instance.new("Frame")
    v435.Size = UDim2.new(1, 0, 0, 34)
    v435.BackgroundTransparency = 1
    v435.LayoutOrder = 6
    v435.Parent = v_u_337
    local v_u_436 = v_u_49({
        ["Parent"] = nil,
        ["Placeholder"] = "amount",
        ["Size"] = nil,
        ["Parent"] = v435,
        ["Size"] = UDim2.new(0.4, -4, 1, 0)
    })
    local v437 = v_u_39({
        ["Parent"] = nil,
        ["Text"] = "+5",
        ["Size"] = nil,
        ["Position"] = nil,
        ["Color"] = nil,
        ["HoverColor"] = nil,
        ["TextSize"] = 10,
        ["TextColor"] = nil,
        ["Parent"] = v435,
        ["Size"] = UDim2.new(0.14, -4, 1, 0),
        ["Position"] = UDim2.new(0.4, 4, 0, 0),
        ["Color"] = v_u_8.Card,
        ["HoverColor"] = v_u_8.CardHover,
        ["TextColor"] = v_u_8.TextPrimary
    })
    local Border_10 = v_u_8.Border
    local v439 = Instance.new("UIStroke")
    v439.Color = Border_10 or v_u_8.Border
    v439.Thickness = 1
    v439.Transparency = 0
    v439.Parent = v437
    local v440 = v_u_39({
        ["Parent"] = nil,
        ["Text"] = "+25",
        ["Size"] = nil,
        ["Position"] = nil,
        ["Color"] = nil,
        ["HoverColor"] = nil,
        ["TextSize"] = 10,
        ["TextColor"] = nil,
        ["Parent"] = v435,
        ["Size"] = UDim2.new(0.15, -4, 1, 0),
        ["Position"] = UDim2.new(0.54, 4, 0, 0),
        ["Color"] = v_u_8.Card,
        ["HoverColor"] = v_u_8.CardHover,
        ["TextColor"] = v_u_8.TextPrimary
    })
    local Border_11 = v_u_8.Border
    local v442 = Instance.new("UIStroke")
    v442.Color = Border_11 or v_u_8.Border
    v442.Thickness = 1
    v442.Transparency = 0
    v442.Parent = v440
    local v443 = v_u_39({
        ["Parent"] = nil,
        ["Text"] = "1/2",
        ["Size"] = nil,
        ["Position"] = nil,
        ["Color"] = nil,
        ["HoverColor"] = nil,
        ["TextSize"] = 10,
        ["TextColor"] = nil,
        ["Parent"] = v435,
        ["Size"] = UDim2.new(0.15, -4, 1, 0),
        ["Position"] = UDim2.new(0.69, 4, 0, 0),
        ["Color"] = v_u_8.Card,
        ["HoverColor"] = v_u_8.CardHover,
        ["TextColor"] = v_u_8.TextPrimary
    })
    local Border_12 = v_u_8.Border
    local v445 = Instance.new("UIStroke")
    v445.Color = Border_12 or v_u_8.Border
    v445.Thickness = 1
    v445.Transparency = 0
    v445.Parent = v443
    local v446 = v_u_39({
        ["Parent"] = nil,
        ["Text"] = "Max",
        ["Size"] = nil,
        ["Position"] = nil,
        ["Color"] = nil,
        ["HoverColor"] = nil,
        ["TextSize"] = 10,
        ["TextColor"] = nil,
        ["Parent"] = v435,
        ["Size"] = UDim2.new(0.16, -4, 1, 0),
        ["Position"] = UDim2.new(0.84, 4, 0, 0),
        ["Color"] = v_u_8.Card,
        ["HoverColor"] = v_u_8.CardHover,
        ["TextColor"] = v_u_8.TextPrimary
    })
    local Border_13 = v_u_8.Border
    local v448 = Instance.new("UIStroke")
    v448.Color = Border_13 or v_u_8.Border
    v448.Thickness = 1
    v448.Transparency = 0
    v448.Parent = v446
    v437.MouseButton1Click:Connect(function()
        -- upvalues: (copy) v_u_436, (ref) v_u_402
        local Text_4 = v_u_436.Text
        local v450 = v_u_436
        local v451 = v_u_402
        local v452 = (tonumber(Text_4) or 0) + 5
        local v453 = math.min(v451, v452)
        v450.Text = tostring(v453)
    end)
    v440.MouseButton1Click:Connect(function()
        -- upvalues: (copy) v_u_436, (ref) v_u_402
        local Text_5 = v_u_436.Text
        local v455 = v_u_436
        local v456 = v_u_402
        local v457 = (tonumber(Text_5) or 0) + 25
        local v458 = math.min(v456, v457)
        v455.Text = tostring(v458)
    end)
    v443.MouseButton1Click:Connect(function()
        -- upvalues: (copy) v_u_436, (ref) v_u_402
        local v459 = v_u_436
        local v460 = v_u_402 / 2
        local v461 = math.floor(v460)
        v459.Text = tostring(v461)
    end)
    v446.MouseButton1Click:Connect(function()
        -- upvalues: (copy) v_u_436, (ref) v_u_402
        local v462 = v_u_402
        v_u_436.Text = tostring(v462)
    end)
    local v_u_463 = Instance.new("TextLabel")
    v_u_463.Size = UDim2.new(1, 0, 0, 16)
    v_u_463.BackgroundTransparency = 1
    v_u_463.Text = "2+ Match! Pick a color above, then press Re-Roll (free)"
    v_u_463.TextColor3 = v_u_8.Warning
    v_u_463.Font = GothamBold
    v_u_463.TextSize = 10
    v_u_463.TextXAlignment = Enum.TextXAlignment.Center
    v_u_463.TextWrapped = true
    v_u_463.Visible = false
    v_u_463.LayoutOrder = 7
    v_u_463.Parent = v_u_337
    local v_u_464 = v_u_39({
        ["Parent"] = nil,
        ["Text"] = "ROLL",
        ["Size"] = nil,
        ["Color"] = nil,
        ["HoverColor"] = nil,
        ["TextSize"] = 15,
        ["Parent"] = v_u_337,
        ["Size"] = UDim2.new(1, 0, 0, 44),
        ["Color"] = v_u_8.Success,
        ["HoverColor"] = v_u_8.SuccessHover
    })
    v_u_464.LayoutOrder = 8
    local v_u_465 = false
    local function v_u_467(p466) -- name: BeginDiceRedice
        -- upvalues: (ref) v_u_465, (copy) v_u_464, (copy) v_u_463
        v_u_465 = p466
        v_u_464.Text = p466 and "RE-ROLL (FREE)" or "ROLL"
        v_u_463.Visible = p466
    end
    v_u_464.MouseButton1Click:Connect(function()
        -- upvalues: (ref) v_u_465, (copy) AdminCommand, (ref) v_u_412, (copy) v_u_436
        if v_u_465 then
            AdminCommand:FireServer("diceredice", v_u_412)
            return
        else
            local Text_6 = v_u_436.Text
            local v469 = tonumber(Text_6) or 0
            if v469 <= 0 then
                CreateAlert("Error", "Enter a bet amount", nil, nil)
            else
                AdminCommand:FireServer("diceroll", v_u_412, v469)
            end
        end
    end)
    local v470 = Instance.new("UIListLayout", v_u_338)
    v470.SortOrder = Enum.SortOrder.LayoutOrder
    v470.Padding = UDim.new(0, 8)
    local v471 = Instance.new("TextLabel")
    v471.Size = UDim2.new(1, 0, 0, 18)
    v471.BackgroundTransparency = 1
    v471.Text = "Your last 20 rolls"
    v471.TextColor3 = v_u_8.TextPrimary
    v471.Font = GothamBold
    v471.TextSize = 13
    v471.TextXAlignment = Enum.TextXAlignment.Left
    v471.LayoutOrder = 0
    v471.Parent = v_u_338
    local v_u_472 = v68(v_u_338, 300)
    v_u_472.LayoutOrder = 1
    v72(v_u_472, 4)
    local v_u_473 = {}
    local function v_u_497(p474) -- name: UpdateDiceHistory
        -- upvalues: (ref) v_u_473, (copy) v_u_8, (copy) Gotham, (copy) v_u_472, (copy) v_u_331, (copy) GothamBold
        for _, v475 in pairs(v_u_473) do
            v475:Destroy()
        end
        v_u_473 = {}
        if p474 and #p474 ~= 0 then
            for v476, v477 in ipairs(p474) do
                local v478 = Instance.new("Frame")
                v478.Size = UDim2.new(1, 0, 0, 34)
                v478.BackgroundColor3 = v_u_8.Card
                v478.BorderSizePixel = 0
                v478.LayoutOrder = v476
                v478.Parent = v_u_472
                local v479 = Instance.new("UICorner")
                v479.CornerRadius = UDim.new(0, 8)
                v479.Parent = v478
                local Border_14 = v_u_8.Border
                local v481 = Instance.new("UIStroke")
                v481.Color = Border_14 or v_u_8.Border
                v481.Thickness = 1
                v481.Transparency = 0
                v481.Parent = v478
                local v482 = Instance.new("Frame")
                v482.Size = UDim2.new(0, 10, 0, 10)
                v482.Position = UDim2.new(0, 10, 0.5, -5)
                v482.BackgroundColor3 = v_u_331[v477.color] or v_u_8.TextMuted
                v482.BorderSizePixel = 0
                v482.Parent = v478
                local v483 = Instance.new("UICorner")
                v483.CornerRadius = UDim.new(0, 5)
                v483.Parent = v482
                local v484 = Instance.new("TextLabel")
                v484.Size = UDim2.new(0, 260, 1, 0)
                v484.Position = UDim2.new(0, 28, 0, 0)
                v484.BackgroundTransparency = 1
                local color = v477.color
                local v486 = tostring(color)
                local bet = v477.bet
                local v488 = tostring(bet)
                local matches = v477.matches
                local v490 = v486 .. " - bet " .. v488 .. " - " .. tostring(matches) .. "/4 matches"
                if v477.redice then
                    local bonusMatches = v477.bonusMatches
                    if bonusMatches then
                        bonusMatches = v477.bonusMatches > 0
                    end
                    local bonusColor = v477.bonusColor
                    v490 = v490 .. " - re-rolled " .. tostring(bonusColor) .. ", " .. (bonusMatches and "won" or "lost")
                end
                v484.Text = v490
                v484.TextColor3 = v_u_8.TextSecondary
                v484.Font = Gotham
                v484.TextSize = 10
                v484.TextXAlignment = Enum.TextXAlignment.Left
                v484.Parent = v478
                local v493 = Instance.new("TextLabel")
                v493.Size = UDim2.new(0, 80, 1, 0)
                v493.Position = UDim2.new(1, -90, 0, 0)
                v493.BackgroundTransparency = 1
                local v494 = v477.net >= 0 and "+" or ""
                local net = v477.net
                v493.Text = v494 .. tostring(net)
                v493.TextColor3 = v477.net >= 0 and v_u_8.Success or v_u_8.Danger
                v493.Font = GothamBold
                v493.TextSize = 11
                v493.TextXAlignment = Enum.TextXAlignment.Right
                v493.Parent = v478
                v_u_473[v476] = v478
            end
        else
            local v496 = Instance.new("TextLabel")
            v496.Size = UDim2.new(1, 0, 0, 30)
            v496.BackgroundTransparency = 1
            v496.Text = "No rolls yet - place your first bet!"
            v496.TextColor3 = v_u_8.TextMuted
            v496.Font = Gotham
            v496.TextSize = 11
            v496.Parent = v_u_472
            v_u_473.__none__ = v496
        end
    end
    local function v_u_499(p498) -- name: UpdateDiceBalanceDisplay
        -- upvalues: (ref) v_u_402, (copy) v_u_362, (copy) v_u_394
        v_u_402 = p498
        v_u_362.Text = p498 .. " min"
        v_u_394.Text = "BALANCE: " .. p498 .. " min"
    end
    local v500 = Instance.new("UIListLayout", v_u_339)
    v500.SortOrder = Enum.SortOrder.LayoutOrder
    v500.Padding = UDim.new(0, 8)
    local v501 = Instance.new("TextLabel")
    v501.Size = UDim2.new(1, 0, 0, 18)
    v501.BackgroundTransparency = 1
    v501.Text = "Unused keys from cashing out"
    v501.TextColor3 = v_u_8.TextPrimary
    v501.Font = GothamBold
    v501.TextSize = 13
    v501.TextXAlignment = Enum.TextXAlignment.Left
    v501.LayoutOrder = 0
    v501.Parent = v_u_339
    local v_u_502 = v68(v_u_339, 300)
    v_u_502.LayoutOrder = 1
    v72(v_u_502, 4)
    local v_u_503 = {}
    local function v_u_518(p504) -- name: UpdateMyKeysList
        -- upvalues: (ref) v_u_503, (copy) v_u_8, (copy) Gotham, (copy) v_u_502, (copy) v_u_49
        for _, v505 in pairs(v_u_503) do
            v505:Destroy()
        end
        v_u_503 = {}
        if p504 and #p504 ~= 0 then
            for v506, v507 in ipairs(p504) do
                local v508 = Instance.new("Frame")
                v508.Size = UDim2.new(1, 0, 0, 38)
                v508.BackgroundColor3 = v_u_8.Card
                v508.BorderSizePixel = 0
                v508.LayoutOrder = v506
                v508.Parent = v_u_502
                local v509 = Instance.new("UICorner")
                v509.CornerRadius = UDim.new(0, 8)
                v509.Parent = v508
                local Border_15 = v_u_8.Border
                local v511 = Instance.new("UIStroke")
                v511.Color = Border_15 or v_u_8.Border
                v511.Thickness = 1
                v511.Transparency = 0
                v511.Parent = v508
                local v512 = v_u_49
                local v513 = {
                    ["Parent"] = v508
                }
                local code = v507.code
                v513.Text = tostring(code)
                v513.Size = UDim2.new(0, 130, 0, 26)
                v513.Position = UDim2.new(0, 8, 0.5, -13)
                v512(v513).TextEditable = false
                local v515 = Instance.new("TextLabel")
                v515.Size = UDim2.new(0, 90, 1, 0)
                v515.Position = UDim2.new(0, 148, 0, 0)
                v515.BackgroundTransparency = 1
                local hours = v507.hours
                v515.Text = tostring(hours) .. "h key"
                v515.TextColor3 = v_u_8.TextMuted
                v515.Font = Gotham
                v515.TextSize = 10
                v515.TextXAlignment = Enum.TextXAlignment.Left
                v515.Parent = v508
                v_u_503[v507.code] = v508
            end
        else
            local v517 = Instance.new("TextLabel")
            v517.Size = UDim2.new(1, 0, 0, 30)
            v517.BackgroundTransparency = 1
            v517.Text = "No unused keys. Cash one out from the Balance tab."
            v517.TextColor3 = v_u_8.TextMuted
            v517.Font = Gotham
            v517.TextSize = 11
            v517.TextWrapped = true
            v517.Parent = v_u_502
            v_u_503.__none__ = v517
        end
    end
    for v_u_519, v520 in pairs(v335) do
        v520.MouseButton1Click:Connect(function()
            -- upvalues: (copy) v_u_519, (copy) v_u_336, (copy) v_u_337, (copy) v_u_338, (ref) v_u_339, (copy) AdminCommand
            local v521 = v_u_519
            v_u_336.Visible = v521 == "Balance"
            v_u_337.Visible = v521 == "Play"
            v_u_338.Visible = v521 == "Last 20 Rolls"
            v_u_339.Visible = v521 == "My Keys"
            if v521 == "My Keys" then
                AdminCommand:FireServer("getmykeys")
            end
        end)
    end
    local v_u_522 = {}
    local v_u_523, v_u_524, v_u_525, v_u_526, v_u_527, v_u_528, v_u_529
    if v_u_7 then
        v_u_523 = Instance.new("Frame")
        v_u_523.Size = UDim2.new(1, 0, 1, 0)
        v_u_523.BackgroundTransparency = 1
        v_u_523.Visible = false
        v_u_523.Parent = v136
        local v530 = Instance.new("UIListLayout", v_u_523)
        v530.SortOrder = Enum.SortOrder.LayoutOrder
        v530.Padding = UDim.new(0, 8)
        v_u_56(v_u_523, "ACTIVE ADMINS").LayoutOrder = 0
        local v_u_531 = v68(v_u_523, 155)
        v_u_531.LayoutOrder = 1
        local v532 = Instance.new("UIListLayout", v_u_531)
        v532.SortOrder = Enum.SortOrder.LayoutOrder
        v532.Padding = UDim.new(0, 4)
        local v_u_533 = {}
        v_u_56(v_u_523, "GIVE / REVOKE / PAUSE / COMPENSATE").LayoutOrder = 2
        local v_u_534 = v_u_49({
            ["Parent"] = nil,
            ["Placeholder"] = "Enter username...",
            ["Size"] = nil,
            ["Parent"] = v_u_523,
            ["Size"] = UDim2.new(1, 0, 0, 32)
        })
        v_u_534.LayoutOrder = 3
        local v_u_535 = v_u_49({
            ["Parent"] = nil,
            ["Placeholder"] = "Minutes",
            ["Text"] = "60",
            ["Size"] = nil,
            ["Parent"] = v_u_523,
            ["Size"] = UDim2.new(1, 0, 0, 32)
        })
        v_u_535.LayoutOrder = 4
        local v536 = Instance.new("Frame")
        v536.Size = UDim2.new(1, 0, 0, 34)
        v536.BackgroundTransparency = 1
        v536.LayoutOrder = 5
        v536.Parent = v_u_523
        local v537 = v_u_39({
            ["Parent"] = nil,
            ["Text"] = "Give",
            ["Size"] = nil,
            ["Position"] = nil,
            ["Color"] = nil,
            ["HoverColor"] = nil,
            ["TextSize"] = 12,
            ["Parent"] = v536,
            ["Size"] = UDim2.new(0.48, 0, 1, 0),
            ["Position"] = UDim2.new(0, 0, 0, 0),
            ["Color"] = v_u_8.Accent,
            ["HoverColor"] = v_u_8.AccentHover
        })
        local v538 = v_u_39({
            ["Parent"] = nil,
            ["Text"] = "Revoke",
            ["Size"] = nil,
            ["Position"] = nil,
            ["Color"] = nil,
            ["HoverColor"] = nil,
            ["TextSize"] = 12,
            ["Parent"] = v536,
            ["Size"] = UDim2.new(0.48, 0, 1, 0),
            ["Position"] = UDim2.new(0.52, 0, 0, 0),
            ["Color"] = v_u_8.Danger,
            ["HoverColor"] = v_u_8.DangerHover
        })
        local v539 = v_u_39({
            ["Parent"] = nil,
            ["Text"] = "Refresh List",
            ["Size"] = nil,
            ["Color"] = nil,
            ["HoverColor"] = nil,
            ["TextSize"] = 10,
            ["TextColor"] = nil,
            ["Parent"] = v_u_523,
            ["Size"] = UDim2.new(1, 0, 0, 30),
            ["Color"] = v_u_8.Card,
            ["HoverColor"] = v_u_8.CardHover,
            ["TextColor"] = v_u_8.TextPrimary
        })
        v539.LayoutOrder = 6
        local Border_16 = v_u_8.Border
        local v541 = Instance.new("UIStroke")
        v541.Color = Border_16 or v_u_8.Border
        v541.Thickness = 1
        v541.Transparency = 0
        v541.Parent = v539
        v_u_56(v_u_523, "TRANSFER TIME (moves time between admins)").LayoutOrder = 7
        local v_u_542 = v_u_49({
            ["Parent"] = nil,
            ["Placeholder"] = "From username (loses time)",
            ["Size"] = nil,
            ["Parent"] = v_u_523,
            ["Size"] = UDim2.new(1, 0, 0, 32)
        })
        v_u_542.LayoutOrder = 8
        local v_u_543 = v_u_49({
            ["Parent"] = nil,
            ["Placeholder"] = "To username (gains time)",
            ["Size"] = nil,
            ["Parent"] = v_u_523,
            ["Size"] = UDim2.new(1, 0, 0, 32)
        })
        v_u_543.LayoutOrder = 9
        local v544 = Instance.new("Frame")
        v544.Size = UDim2.new(1, 0, 0, 34)
        v544.BackgroundTransparency = 1
        v544.LayoutOrder = 10
        v544.Parent = v_u_523
        local v_u_545 = v_u_49({
            ["Parent"] = nil,
            ["Placeholder"] = "Minutes",
            ["Text"] = "60",
            ["Size"] = nil,
            ["Position"] = nil,
            ["Parent"] = v544,
            ["Size"] = UDim2.new(0.48, 0, 1, 0),
            ["Position"] = UDim2.new(0, 0, 0, 0)
        })
        v_u_39({
            ["Parent"] = nil,
            ["Text"] = "Transfer",
            ["Size"] = nil,
            ["Position"] = nil,
            ["Color"] = nil,
            ["HoverColor"] = nil,
            ["TextSize"] = 12,
            ["Parent"] = v544,
            ["Size"] = UDim2.new(0.48, 0, 1, 0),
            ["Position"] = UDim2.new(0.52, 0, 0, 0),
            ["Color"] = v_u_8.Accent,
            ["HoverColor"] = v_u_8.AccentHover
        }).MouseButton1Click:Connect(function()
            -- upvalues: (copy) v_u_542, (copy) v_u_543, (copy) v_u_545, (copy) AdminCommand
            local Text_7 = v_u_542.Text
            local Text_8 = v_u_543.Text
            local Text_9 = v_u_545.Text
            local v549 = tonumber(Text_9) or 0
            if Text_7 == "" or Text_8 == "" then
                CreateAlert("Error", "Enter both a from and to username", nil, nil)
                return
            elseif v549 <= 0 then
                CreateAlert("Error", "Enter a valid number of minutes", nil, nil)
            else
                AdminCommand:FireServer("transferadmintime", Text_7, Text_8, v549)
                task.wait(0.4)
                AdminCommand:FireServer("getadminlist")
            end
        end)
        v_u_524 = function(p550)
            -- upvalues: (ref) v_u_533, (copy) v_u_8, (copy) v_u_531, (copy) v_u_23, (copy) GothamMedium, (copy) v_u_39, (copy) v_u_535, (copy) AdminCommand
            for _, v551 in pairs(v_u_533) do
                v551:Destroy()
            end
            v_u_533 = {}
            for _, v_u_552 in pairs(p550) do
                local v553 = Instance.new("Frame")
                v553.Size = UDim2.new(1, 0, 0, 38)
                v553.BackgroundColor3 = v_u_8.Card
                v553.BorderSizePixel = 0
                v553.Parent = v_u_531
                local v554 = Instance.new("UICorner")
                v554.CornerRadius = UDim.new(0, 8)
                v554.Parent = v553
                local Border_17 = v_u_8.Border
                local v556 = Instance.new("UIStroke")
                v556.Color = Border_17 or v_u_8.Border
                v556.Thickness = 1
                v556.Transparency = 0
                v556.Parent = v553
                local v557 = v_u_552.paused and "  (PAUSED)" or ""
                local v558 = Instance.new("TextLabel")
                v558.Text = v_u_552.name .. "  \194\183  " .. v_u_23(v_u_552.timeLeft) .. v557
                v558.Size = UDim2.new(1, -130, 1, 0)
                v558.Position = UDim2.new(0, 10, 0, 0)
                v558.BackgroundTransparency = 1
                v558.TextColor3 = v_u_552.paused and v_u_8.Accent or v_u_8.TextPrimary
                v558.Font = GothamMedium
                v558.TextSize = 11
                v558.TextXAlignment = Enum.TextXAlignment.Left
                v558.Parent = v553
                v_u_39({
                    ["Parent"] = nil,
                    ["Text"] = "+Comp",
                    ["Size"] = nil,
                    ["Position"] = nil,
                    ["Color"] = nil,
                    ["HoverColor"] = nil,
                    ["TextSize"] = 9,
                    ["Radius"] = 6,
                    ["Parent"] = v553,
                    ["Size"] = UDim2.new(0, 58, 0, 26),
                    ["Position"] = UDim2.new(1, -68, 0.5, -13),
                    ["Color"] = v_u_8.Accent,
                    ["HoverColor"] = v_u_8.AccentHover
                }).MouseButton1Click:Connect(function()
                    -- upvalues: (ref) v_u_535, (ref) AdminCommand, (copy) v_u_552
                    local Text_10 = v_u_535.Text
                    local v560 = tonumber(Text_10) or 60
                    AdminCommand:FireServer("compensateadmin", v_u_552.name, v560)
                    task.wait(0.3)
                    AdminCommand:FireServer("getadminlist")
                end)
                v_u_533[v_u_552.userId] = v553
            end
        end
        v537.MouseButton1Click:Connect(function()
            -- upvalues: (copy) v_u_534, (copy) v_u_535, (copy) AdminCommand
            local Text_11 = v_u_534.Text
            local Text_12 = v_u_535.Text
            local v563 = tonumber(Text_12) or 60
            if Text_11 ~= "" then
                AdminCommand:FireServer("giveadmin", Text_11, v563)
                v_u_534.Text = ""
            end
        end)
        v538.MouseButton1Click:Connect(function()
            -- upvalues: (copy) v_u_534, (copy) AdminCommand
            local Text_13 = v_u_534.Text
            if Text_13 ~= "" then
                AdminCommand:FireServer("revokeadmin", Text_13)
                v_u_534.Text = ""
            end
        end)
        v539.MouseButton1Click:Connect(function()
            -- upvalues: (copy) AdminCommand
            AdminCommand:FireServer("getadminlist")
        end)
        v_u_525 = Instance.new("Frame")
        v_u_525.Size = UDim2.new(1, 0, 1, 0)
        v_u_525.BackgroundTransparency = 1
        v_u_525.Visible = false
        v_u_525.Parent = v136
        local v565 = Instance.new("UIListLayout", v_u_525)
        v565.SortOrder = Enum.SortOrder.LayoutOrder
        v565.Padding = UDim.new(0, 8)
        local v_u_566 = v68(v_u_525, 276)
        v_u_566.LayoutOrder = 0
        local v567 = Instance.new("UIListLayout", v_u_566)
        v567.SortOrder = Enum.SortOrder.LayoutOrder
        v567.Padding = UDim.new(0, 4)
        v_u_56(v_u_525, "BANNED PLAYERS").LayoutOrder = 1
        local v568 = v_u_39({
            ["Parent"] = nil,
            ["Text"] = "Refresh",
            ["Size"] = nil,
            ["Color"] = nil,
            ["HoverColor"] = nil,
            ["TextSize"] = 10,
            ["TextColor"] = nil,
            ["Parent"] = v_u_525,
            ["Size"] = UDim2.new(1, 0, 0, 30),
            ["Color"] = v_u_8.Card,
            ["HoverColor"] = v_u_8.CardHover,
            ["TextColor"] = v_u_8.TextPrimary
        })
        v568.LayoutOrder = 2
        local Border_18 = v_u_8.Border
        local v570 = Instance.new("UIStroke")
        v570.Color = Border_18 or v_u_8.Border
        v570.Thickness = 1
        v570.Transparency = 0
        v570.Parent = v568
        v568.MouseButton1Click:Connect(function()
            -- upvalues: (copy) AdminCommand
            AdminCommand:FireServer("getbanlist")
        end)
        v_u_526 = function(p571)
            -- upvalues: (ref) v_u_522, (copy) v_u_8, (copy) v_u_566, (copy) GothamMedium, (copy) Gotham, (copy) v_u_39, (copy) AdminCommand
            for _, v572 in pairs(v_u_522) do
                v572:Destroy()
            end
            v_u_522 = {}
            if p571 and #p571 ~= 0 then
                for _, v_u_573 in pairs(p571) do
                    local v574 = Instance.new("Frame")
                    v574.Size = UDim2.new(1, 0, 0, 38)
                    v574.BackgroundColor3 = v_u_8.Card
                    v574.BorderSizePixel = 0
                    v574.Parent = v_u_566
                    local v575 = Instance.new("UICorner")
                    v575.CornerRadius = UDim.new(0, 8)
                    v575.Parent = v574
                    local Border_19 = v_u_8.Border
                    local v577 = Instance.new("UIStroke")
                    v577.Color = Border_19 or v_u_8.Border
                    v577.Thickness = 1
                    v577.Transparency = 0
                    v577.Parent = v574
                    local v578 = Instance.new("TextLabel")
                    v578.Text = v_u_573.name
                    v578.Size = UDim2.new(0.5, 0, 0, 16)
                    v578.Position = UDim2.new(0, 10, 0, 4)
                    v578.BackgroundTransparency = 1
                    v578.TextColor3 = v_u_8.TextPrimary
                    v578.Font = GothamMedium
                    v578.TextSize = 11
                    v578.TextXAlignment = Enum.TextXAlignment.Left
                    v578.Parent = v574
                    local v579 = Instance.new("TextLabel")
                    local bannedBy = v_u_573.bannedBy
                    v579.Text = "by " .. tostring(bannedBy)
                    v579.Size = UDim2.new(0.5, 0, 0, 12)
                    v579.Position = UDim2.new(0, 10, 0, 20)
                    v579.BackgroundTransparency = 1
                    v579.TextColor3 = v_u_8.TextMuted
                    v579.Font = Gotham
                    v579.TextSize = 9
                    v579.TextXAlignment = Enum.TextXAlignment.Left
                    v579.Parent = v574
                    local v_u_581 = v_u_39({
                        ["Parent"] = nil,
                        ["Text"] = "Unban",
                        ["Size"] = nil,
                        ["Position"] = nil,
                        ["Color"] = nil,
                        ["HoverColor"] = nil,
                        ["TextSize"] = 9,
                        ["Radius"] = 6,
                        ["Parent"] = v574,
                        ["Size"] = UDim2.new(0, 56, 0, 26),
                        ["Position"] = UDim2.new(1, -62, 0.5, -13),
                        ["Color"] = v_u_8.Danger,
                        ["HoverColor"] = v_u_8.DangerHover
                    })
                    v_u_581.MouseButton1Click:Connect(function()
                        -- upvalues: (ref) AdminCommand, (copy) v_u_573, (copy) v_u_581
                        AdminCommand:FireServer("unban", v_u_573.name)
                        v_u_581.Text = "Done"
                        task.delay(1.5, function()
                            -- upvalues: (ref) AdminCommand
                            AdminCommand:FireServer("getbanlist")
                        end)
                    end)
                    v_u_522[v_u_573.userId] = v574
                end
            end
        end
        v_u_527 = Instance.new("Frame")
        v_u_527.Size = UDim2.new(1, 0, 1, 0)
        v_u_527.BackgroundTransparency = 1
        v_u_527.Visible = false
        v_u_527.Parent = v136
        local v582 = Instance.new("UIListLayout", v_u_527)
        v582.SortOrder = Enum.SortOrder.LayoutOrder
        v582.Padding = UDim.new(0, 8)
        v_u_56(v_u_527, "WHITELISTED PLAYERS").LayoutOrder = 0
        local v_u_583 = v68(v_u_527, 190)
        v_u_583.LayoutOrder = 1
        local v584 = Instance.new("UIListLayout", v_u_583)
        v584.SortOrder = Enum.SortOrder.LayoutOrder
        v584.Padding = UDim.new(0, 4)
        local v_u_585 = {}
        v_u_56(v_u_527, "ADD (works if offline)").LayoutOrder = 2
        local v_u_586 = v_u_49({
            ["Parent"] = nil,
            ["Placeholder"] = "Enter username...",
            ["Size"] = nil,
            ["Parent"] = v_u_527,
            ["Size"] = UDim2.new(1, 0, 0, 32)
        })
        v_u_586.LayoutOrder = 3
        local v587 = v_u_39({
            ["Parent"] = nil,
            ["Text"] = "Add To Whitelist",
            ["Size"] = nil,
            ["Color"] = nil,
            ["HoverColor"] = nil,
            ["TextSize"] = 10,
            ["Parent"] = v_u_527,
            ["Size"] = UDim2.new(1, 0, 0, 32),
            ["Color"] = v_u_8.Accent,
            ["HoverColor"] = v_u_8.AccentHover
        })
        v587.LayoutOrder = 4
        v_u_528 = function(p588)
            -- upvalues: (ref) v_u_585, (copy) v_u_8, (copy) v_u_583, (copy) GothamMedium, (copy) v_u_39, (copy) AdminCommand
            for _, v589 in pairs(v_u_585) do
                v589:Destroy()
            end
            v_u_585 = {}
            for _, v_u_590 in pairs(p588 or {}) do
                local v591 = Instance.new("Frame")
                v591.Size = UDim2.new(1, 0, 0, 38)
                v591.BackgroundColor3 = v_u_8.Card
                v591.BorderSizePixel = 0
                v591.Parent = v_u_583
                local v592 = Instance.new("UICorner")
                v592.CornerRadius = UDim.new(0, 8)
                v592.Parent = v591
                local Border_20 = v_u_8.Border
                local v594 = Instance.new("UIStroke")
                v594.Color = Border_20 or v_u_8.Border
                v594.Thickness = 1
                v594.Transparency = 0
                v594.Parent = v591
                local v595 = Instance.new("TextLabel")
                v595.Text = v_u_590.name
                v595.Size = UDim2.new(1, -78, 1, 0)
                v595.Position = UDim2.new(0, 10, 0, 0)
                v595.BackgroundTransparency = 1
                v595.TextColor3 = v_u_8.TextPrimary
                v595.Font = GothamMedium
                v595.TextSize = 11
                v595.TextXAlignment = Enum.TextXAlignment.Left
                v595.Parent = v591
                v_u_39({
                    ["Parent"] = nil,
                    ["Text"] = "Remove",
                    ["Size"] = nil,
                    ["Position"] = nil,
                    ["Color"] = nil,
                    ["HoverColor"] = nil,
                    ["TextSize"] = 9,
                    ["Radius"] = 6,
                    ["Parent"] = v591,
                    ["Size"] = UDim2.new(0, 62, 0, 26),
                    ["Position"] = UDim2.new(1, -68, 0.5, -13),
                    ["Color"] = v_u_8.Danger,
                    ["HoverColor"] = v_u_8.DangerHover
                }).MouseButton1Click:Connect(function()
                    -- upvalues: (ref) AdminCommand, (copy) v_u_590
                    AdminCommand:FireServer("removewhitelist", v_u_590.name)
                end)
                v_u_585[v_u_590.userId] = v591
            end
        end
        v587.MouseButton1Click:Connect(function()
            -- upvalues: (copy) v_u_586, (copy) AdminCommand
            local Text_14 = v_u_586.Text
            if Text_14 ~= "" then
                AdminCommand:FireServer("addwhitelist", Text_14)
                v_u_586.Text = ""
            end
        end)
        v_u_529 = Instance.new("Frame")
        v_u_529.Size = UDim2.new(1, 0, 1, 0)
        v_u_529.BackgroundTransparency = 1
        v_u_529.Visible = false
        v_u_529.Parent = v136
        local v597 = Instance.new("UIListLayout", v_u_529)
        v597.SortOrder = Enum.SortOrder.LayoutOrder
        v597.Padding = UDim.new(0, 8)
        local v598 = Instance.new("Frame")
        v598.Size = UDim2.new(1, 0, 0, 28)
        v598.BackgroundTransparency = 1
        v598.LayoutOrder = 0
        v598.Parent = v_u_529
        v_u_56(v598, "ACTION LOGS").Size = UDim2.new(0.6, 0, 1, 0)
        v_u_39({
            ["Parent"] = nil,
            ["Text"] = "Clear",
            ["Size"] = nil,
            ["Position"] = nil,
            ["Color"] = nil,
            ["HoverColor"] = nil,
            ["TextSize"] = 9,
            ["Radius"] = 6,
            ["Parent"] = v598,
            ["Size"] = UDim2.new(0, 50, 0, 22),
            ["Position"] = UDim2.new(1, -54, 0.5, -11),
            ["Color"] = v_u_8.Danger,
            ["HoverColor"] = v_u_8.DangerHover
        }).MouseButton1Click:Connect(function()
            -- upvalues: (copy) AdminCommand
            AdminCommand:FireServer("clearlogs")
        end)
        local v599 = v_u_39({
            ["Parent"] = nil,
            ["Text"] = "Refresh",
            ["Size"] = nil,
            ["Position"] = nil,
            ["Color"] = nil,
            ["HoverColor"] = nil,
            ["TextSize"] = 9,
            ["Radius"] = 6,
            ["TextColor"] = nil,
            ["Parent"] = v598,
            ["Size"] = UDim2.new(0, 54, 0, 22),
            ["Position"] = UDim2.new(1, -112, 0.5, -11),
            ["Color"] = v_u_8.Card,
            ["HoverColor"] = v_u_8.CardHover,
            ["TextColor"] = v_u_8.TextPrimary
        })
        local Border_21 = v_u_8.Border
        local v601 = Instance.new("UIStroke")
        v601.Color = Border_21 or v_u_8.Border
        v601.Thickness = 1
        v601.Transparency = 0
        v601.Parent = v599
        v599.MouseButton1Click:Connect(function()
            -- upvalues: (copy) AdminCommand
            AdminCommand:FireServer("getlogs")
        end)
        local v_u_602 = v68(v_u_529, 328)
        v_u_602.LayoutOrder = 1
        local v603 = Instance.new("UIListLayout", v_u_602)
        v603.SortOrder = Enum.SortOrder.LayoutOrder
        v603.Padding = UDim.new(0, 3)
        local v_u_604 = {}
        local function v_u_620(p605, p606) -- name: AddLogRow
            -- upvalues: (copy) v_u_8, (copy) v_u_30, (copy) Gotham, (copy) GothamBold, (copy) GothamMedium, (copy) v_u_602, (ref) v_u_604
            local v607 = Instance.new("Frame")
            v607.Size = UDim2.new(1, 0, 0, 28)
            v607.BackgroundColor3 = v_u_8.Card
            v607.BorderSizePixel = 0
            local v608 = Instance.new("UICorner")
            v608.CornerRadius = UDim.new(0, 6)
            v608.Parent = v607
            local Border_22 = v_u_8.Border
            local v610 = Instance.new("UIStroke")
            v610.Color = Border_22 or v_u_8.Border
            v610.Thickness = 1
            v610.Transparency = 0
            v610.Parent = v607
            v_u_30(v607, 6, 6, 0, 0)
            local v611 = Instance.new("TextLabel")
            v611.Size = UDim2.new(0, 50, 1, 0)
            v611.BackgroundTransparency = 1
            v611.Text = os.date("%H:%M:%S", p605.t or 0)
            v611.TextColor3 = v_u_8.TextMuted
            v611.Font = Gotham
            v611.TextSize = 9
            v611.TextXAlignment = Enum.TextXAlignment.Left
            v611.Parent = v607
            local v612 = Instance.new("TextLabel")
            v612.Size = UDim2.new(0, 70, 1, 0)
            v612.Position = UDim2.new(0, 50, 0, 0)
            v612.BackgroundTransparency = 1
            local v613 = p605.admin or "?"
            v612.Text = tostring(v613)
            v612.TextColor3 = v_u_8.Accent
            v612.Font = GothamBold
            v612.TextSize = 10
            v612.TextXAlignment = Enum.TextXAlignment.Left
            v612.TextTruncate = Enum.TextTruncate.AtEnd
            v612.Parent = v607
            local v614 = Instance.new("TextLabel")
            v614.Size = UDim2.new(0, 80, 1, 0)
            v614.Position = UDim2.new(0, 120, 0, 0)
            v614.BackgroundTransparency = 1
            local v615 = p605.action or "?"
            v614.Text = tostring(v615)
            v614.TextColor3 = v_u_8.TextSecondary
            v614.Font = GothamMedium
            v614.TextSize = 9
            v614.TextXAlignment = Enum.TextXAlignment.Left
            v614.TextTruncate = Enum.TextTruncate.AtEnd
            v614.Parent = v607
            local v616 = Instance.new("TextLabel")
            v616.Size = UDim2.new(0, 80, 1, 0)
            v616.Position = UDim2.new(0, 200, 0, 0)
            v616.BackgroundTransparency = 1
            local v617 = p605.target or ""
            v616.Text = tostring(v617)
            v616.TextColor3 = v_u_8.TextMuted
            v616.Font = Gotham
            v616.TextSize = 9
            v616.TextXAlignment = Enum.TextXAlignment.Left
            v616.TextTruncate = Enum.TextTruncate.AtEnd
            v616.Parent = v607
            if not p606 then
                v607.Parent = v_u_602
                local v618 = v_u_604
                table.insert(v618, v607)
                return v607
            end
            v607.Parent = v_u_602
            v607.LayoutOrder = -#v_u_604
            local v619 = v_u_604
            table.insert(v619, 1, v607)
            return v607
        end
        local function v625(p621) -- name: RefreshLogs
            -- upvalues: (ref) v_u_604, (copy) v_u_620
            for _, v622 in pairs(v_u_604) do
                v622:Destroy()
            end
            v_u_604 = {}
            if p621 and #p621 ~= 0 then
                for v623, v624 in ipairs(p621) do
                    v_u_620(v624, false).LayoutOrder = v623
                end
            end
        end
        _G._AdminPanel_RefreshLogs = v625
        _G._AdminPanel_AddLogRow = v_u_620
    else
        v_u_526 = nil
        v_u_525 = nil
        v_u_524 = nil
        v_u_527 = nil
        v_u_523 = nil
        v_u_529 = nil
        v_u_528 = nil
    end
    local v_u_626 = Instance.new("Frame")
    v_u_626.Size = UDim2.new(1, 0, 1, 0)
    v_u_626.BackgroundTransparency = 1
    v_u_626.Visible = false
    v_u_626.Parent = v136
    local v627 = Instance.new("UIListLayout", v_u_626)
    v627.SortOrder = Enum.SortOrder.LayoutOrder
    v627.Padding = UDim.new(0, 8)
    v_u_56(v_u_626, "SETTINGS").LayoutOrder = 0
    local v628 = Instance.new("Frame")
    v628.Size = UDim2.new(1, 0, 0, 52)
    v628.BackgroundColor3 = v_u_8.Card
    v628.BorderSizePixel = 0
    v628.LayoutOrder = 1
    v628.Parent = v_u_626
    local v629 = Instance.new("UICorner")
    v629.CornerRadius = UDim.new(0, 8)
    v629.Parent = v628
    local Accent_2 = v_u_8.Accent
    local v631 = Instance.new("UIStroke")
    v631.Color = Accent_2 or v_u_8.Border
    v631.Thickness = 1
    v631.Transparency = 0.7
    v631.Parent = v628
    v_u_30(v628, 12, 12, 8, 8)
    local v632 = Instance.new("TextLabel")
    v632.Size = UDim2.new(1, 0, 1, 0)
    v632.BackgroundTransparency = 1
    v632.Text = "Press " .. v_u_6.Name .. " to toggle.\nDrag title bar to move."
    v632.TextColor3 = v_u_8.TextSecondary
    v632.Font = Gotham
    v632.TextSize = 11
    v632.TextXAlignment = Enum.TextXAlignment.Left
    v632.TextWrapped = true
    v632.Parent = v628
    v_u_56(v_u_626, "MY TRACKING SOUND ID (only affects you)").LayoutOrder = 2
    local v633 = Instance.new("Frame")
    v633.Size = UDim2.new(1, 0, 0, 32)
    v633.BackgroundTransparency = 1
    v633.LayoutOrder = 3
    v633.Parent = v_u_626
    local v_u_634 = v_u_49({
        ["Parent"] = nil,
        ["Placeholder"] = "e.g. 3398620867",
        ["Text"] = "3398620867",
        ["Size"] = nil,
        ["Parent"] = v633,
        ["Size"] = UDim2.new(1, -74, 1, 0)
    })
    v_u_39({
        ["Parent"] = nil,
        ["Text"] = "Save",
        ["Size"] = nil,
        ["Position"] = nil,
        ["Color"] = nil,
        ["HoverColor"] = nil,
        ["TextSize"] = 11,
        ["Parent"] = v633,
        ["Size"] = UDim2.new(0, 68, 1, 0),
        ["Position"] = UDim2.new(1, -68, 0, 0),
        ["Color"] = v_u_8.Accent,
        ["HoverColor"] = v_u_8.AccentHover
    }).MouseButton1Click:Connect(function()
        -- upvalues: (copy) v_u_634, (copy) AdminCommand
        if v_u_634.Text ~= "" then
            AdminCommand:FireServer("updatetrackingsound", v_u_634.Text)
        end
    end)
    local v635 = v_u_39({
        ["Parent"] = nil,
        ["Text"] = "Preview Sound",
        ["Size"] = nil,
        ["Color"] = nil,
        ["HoverColor"] = nil,
        ["TextSize"] = 11,
        ["TextColor"] = nil,
        ["Parent"] = v_u_626,
        ["Size"] = UDim2.new(1, 0, 0, 32),
        ["Color"] = v_u_8.Card,
        ["HoverColor"] = v_u_8.CardHover,
        ["TextColor"] = v_u_8.TextPrimary
    })
    v635.LayoutOrder = 4
    local Border_23 = v_u_8.Border
    local v637 = Instance.new("UIStroke")
    v637.Color = Border_23 or v_u_8.Border
    v637.Thickness = 1
    v637.Transparency = 0
    v637.Parent = v635
    v635.MouseButton1Click:Connect(function()
        -- upvalues: (copy) v_u_92
        pcall(function()
            -- upvalues: (ref) v_u_92
            v_u_92:Play()
        end)
    end)
    local v_u_638 = v_u_39({
        ["Parent"] = nil,
        ["Text"] = "Mute Game Audio",
        ["Size"] = nil,
        ["Color"] = nil,
        ["HoverColor"] = nil,
        ["TextSize"] = 12,
        ["TextColor"] = nil,
        ["Parent"] = v_u_626,
        ["Size"] = UDim2.new(1, 0, 0, 34),
        ["Color"] = v_u_8.Card,
        ["HoverColor"] = v_u_8.CardHover,
        ["TextColor"] = v_u_8.TextPrimary
    })
    v_u_638.LayoutOrder = 5
    local Border_24 = v_u_8.Border
    local v640 = Instance.new("UIStroke")
    v640.Color = Border_24 or v_u_8.Border
    v640.Thickness = 1
    v640.Transparency = 0
    v640.Parent = v_u_638
    local v_u_641 = false
    local v_u_642
    if v_u_7 then
        v_u_642 = nil
    else
        v_u_642 = v_u_39({
            ["Parent"] = nil,
            ["Text"] = "Pause Time (-8 min)",
            ["Size"] = nil,
            ["Color"] = nil,
            ["HoverColor"] = nil,
            ["TextSize"] = 12,
            ["Parent"] = v_u_626,
            ["Size"] = UDim2.new(1, 0, 0, 34),
            ["Color"] = v_u_8.Warning,
            ["HoverColor"] = v_u_8.WarningHover
        })
        v_u_642.LayoutOrder = 6
        v_u_642.MouseButton1Click:Connect(function()
            -- upvalues: (ref) v_u_641, (copy) AdminCommand
            if v_u_641 then
                AdminCommand:FireServer("unpauseadmintime")
            else
                AdminCommand:FireServer("pauseadmintime")
            end
        end)
    end
    if v_u_7 then
        v_u_56(v_u_626, "COMPENSATE ALL ADMINS").LayoutOrder = 6
        local v643 = Instance.new("Frame")
        v643.Size = UDim2.new(1, 0, 0, 34)
        v643.BackgroundTransparency = 1
        v643.LayoutOrder = 7
        v643.Parent = v_u_626
        local v_u_644 = v_u_49({
            ["Parent"] = nil,
            ["Placeholder"] = "Minutes",
            ["Text"] = "60",
            ["Size"] = nil,
            ["Parent"] = v643,
            ["Size"] = UDim2.new(1, -100, 1, 0)
        })
        local v_u_645 = v_u_39({
            ["Parent"] = nil,
            ["Text"] = "Comp All",
            ["Size"] = nil,
            ["Position"] = nil,
            ["Color"] = nil,
            ["HoverColor"] = nil,
            ["TextSize"] = 11,
            ["Parent"] = v643,
            ["Size"] = UDim2.new(0, 94, 1, 0),
            ["Position"] = UDim2.new(1, -94, 0, 0),
            ["Color"] = v_u_8.Success,
            ["HoverColor"] = v_u_8.SuccessHover
        })
        v_u_645.MouseButton1Click:Connect(function()
            -- upvalues: (copy) v_u_644, (copy) v_u_645, (copy) v_u_8, (copy) AdminCommand
            local Text_15 = v_u_644.Text
            local v647 = tonumber(Text_15) or 60
            v_u_645.Text = "..."
            v_u_645.BackgroundColor3 = v_u_8.TextMuted
            AdminCommand:FireServer("compall", v647)
            task.wait(0.5)
            v_u_645.Text = "Comp All"
            v_u_645.BackgroundColor3 = v_u_8.Success
        end)
        v_u_56(v_u_626, "DELETE ALL CODES").LayoutOrder = 8
        local v_u_648 = v_u_39({
            ["Parent"] = nil,
            ["Text"] = "Delete All Codes",
            ["Size"] = nil,
            ["Color"] = nil,
            ["HoverColor"] = nil,
            ["TextSize"] = 12,
            ["Parent"] = v_u_626,
            ["Size"] = UDim2.new(1, 0, 0, 34),
            ["Color"] = v_u_8.Danger,
            ["HoverColor"] = v_u_8.DangerHover
        })
        v_u_648.LayoutOrder = 9
        local v_u_649 = false
        v_u_648.MouseButton1Click:Connect(function()
            -- upvalues: (ref) v_u_649, (copy) v_u_648, (copy) AdminCommand
            if v_u_649 then
                v_u_649 = false
                v_u_648.Text = "Delete All Codes"
                AdminCommand:FireServer("deleteallcodes")
            else
                v_u_649 = true
                v_u_648.Text = "Click again to confirm"
                task.delay(3, function()
                    -- upvalues: (ref) v_u_649, (ref) v_u_648
                    if v_u_649 then
                        v_u_649 = false
                        v_u_648.Text = "Delete All Codes"
                    end
                end)
            end
        end)
    end
    if not v_u_7 then
        v_u_56(v_u_626, "TRANSFER MY TIME").LayoutOrder = 7
        local v_u_650 = v_u_49({
            ["Parent"] = nil,
            ["Placeholder"] = "Username to send time to",
            ["Size"] = nil,
            ["Parent"] = v_u_626,
            ["Size"] = UDim2.new(1, 0, 0, 32)
        })
        v_u_650.LayoutOrder = 8
        local v651 = Instance.new("Frame")
        v651.Size = UDim2.new(1, 0, 0, 32)
        v651.BackgroundTransparency = 1
        v651.LayoutOrder = 9
        v651.Parent = v_u_626
        local v_u_652 = v_u_49({
            ["Parent"] = nil,
            ["Placeholder"] = "Minutes",
            ["Size"] = nil,
            ["Parent"] = v651,
            ["Size"] = UDim2.new(1, -74, 1, 0)
        })
        v_u_39({
            ["Parent"] = nil,
            ["Text"] = "Send",
            ["Size"] = nil,
            ["Position"] = nil,
            ["Color"] = nil,
            ["HoverColor"] = nil,
            ["TextSize"] = 11,
            ["Parent"] = v651,
            ["Size"] = UDim2.new(0, 68, 1, 0),
            ["Position"] = UDim2.new(1, -68, 0, 0),
            ["Color"] = v_u_8.Accent,
            ["HoverColor"] = v_u_8.AccentHover
        }).MouseButton1Click:Connect(function()
            -- upvalues: (copy) v_u_650, (copy) v_u_652, (copy) AdminCommand
            local Text_16 = v_u_650.Text
            local Text_17 = v_u_652.Text
            local v655 = tonumber(Text_17) or 0
            if Text_16 == "" then
                CreateAlert("Error", "Enter a username to send time to", nil, nil)
                return
            elseif v655 <= 0 then
                CreateAlert("Error", "Enter a valid number of minutes", nil, nil)
            else
                AdminCommand:FireServer("playertransfertime", Text_16, v655)
                v_u_650.Text = ""
                v_u_652.Text = ""
            end
        end)
    end
    if not v_u_7 then
        v_u_56(v_u_626, "REDEEM CODE").LayoutOrder = 10
        local v656 = Instance.new("Frame")
        v656.Size = UDim2.new(1, 0, 0, 32)
        v656.BackgroundTransparency = 1
        v656.LayoutOrder = 11
        v656.Parent = v_u_626
        local v_u_657 = v_u_49({
            ["Parent"] = nil,
            ["Placeholder"] = "e.g. ABCDEF",
            ["Size"] = nil,
            ["Parent"] = v656,
            ["Size"] = UDim2.new(1, -74, 1, 0)
        })
        v_u_39({
            ["Parent"] = nil,
            ["Text"] = "Redeem",
            ["Size"] = nil,
            ["Position"] = nil,
            ["Color"] = nil,
            ["HoverColor"] = nil,
            ["TextSize"] = 11,
            ["Parent"] = v656,
            ["Size"] = UDim2.new(0, 68, 1, 0),
            ["Position"] = UDim2.new(1, -68, 0, 0),
            ["Color"] = v_u_8.Accent,
            ["HoverColor"] = v_u_8.AccentHover
        }).MouseButton1Click:Connect(function()
            -- upvalues: (copy) v_u_657, (copy) AdminCommand
            if v_u_657.Text == "" then
                CreateAlert("Error", "Enter a code to redeem", nil, nil)
            else
                AdminCommand:FireServer("redeemcode", v_u_657.Text)
                v_u_657.Text = ""
            end
        end)
    end
    local v658 = v_u_39({
        ["Parent"] = nil,
        ["Text"] = "Close Panel",
        ["Size"] = nil,
        ["Color"] = nil,
        ["HoverColor"] = nil,
        ["TextSize"] = 12,
        ["Parent"] = v_u_626,
        ["Size"] = UDim2.new(1, 0, 0, 34),
        ["Color"] = v_u_8.Danger,
        ["HoverColor"] = v_u_8.DangerHover
    })
    v658.LayoutOrder = 12
    local v_u_659 = false
    local v_u_660 = {}
    local function v_u_666(p661) -- name: applyMuteState
        -- upvalues: (ref) v_u_659, (copy) v_u_92, (copy) v_u_93, (ref) v_u_660, (copy) v_u_638, (copy) v_u_8
        v_u_659 = p661
        if v_u_659 then
            for _, v662 in ipairs(game:GetDescendants()) do
                if v662:IsA("Sound") and (v662 ~= v_u_92 and v662 ~= v_u_93) then
                    if v_u_660[v662] == nil then
                        v_u_660[v662] = v662.Volume
                    end
                    v662.Volume = 0
                end
            end
            v_u_638.Text = "Unmute Game Audio"
            v_u_638.BackgroundColor3 = v_u_8.Danger
            v_u_638.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            local v663 = v_u_660
            v_u_660 = {}
            for v664, v665 in pairs(v663) do
                if v664 and v664:IsDescendantOf(game) then
                    v664.Volume = v665
                end
            end
            v_u_638.Text = "Mute Game Audio"
            v_u_638.BackgroundColor3 = v_u_8.Card
            v_u_638.TextColor3 = v_u_8.TextPrimary
        end
    end
    v_u_638.MouseButton1Click:Connect(function()
        -- upvalues: (copy) AdminCommand
        AdminCommand:FireServer("togglegamemute")
    end)
    game.DescendantAdded:Connect(function(p667)
        -- upvalues: (ref) v_u_659, (copy) v_u_92, (copy) v_u_93, (ref) v_u_660
        if v_u_659 and p667:IsA("Sound") and (p667 ~= v_u_92 and p667 ~= v_u_93) then
            if v_u_660[p667] == nil then
                v_u_660[p667] = p667.Volume
            end
            p667.Volume = 0
        end
    end)
    v658.MouseButton1Click:Connect(function()
        -- upvalues: (copy) v_u_96, (copy) v_u_95
        v_u_96.Visible = false
        v_u_95.Visible = false
    end)
    local function v_u_675(p668) -- name: SwitchTab
        -- upvalues: (ref) v_u_137, (ref) v_u_217, (ref) v_u_296, (ref) v_u_332, (copy) v_u_626, (copy) v_u_7, (ref) v_u_523, (ref) v_u_525, (ref) v_u_527, (ref) v_u_529, (copy) v_u_130, (copy) v_u_8, (copy) TweenService, (ref) v_u_282, (copy) AdminCommand, (ref) v_u_327
        v_u_137.Visible = p668 == "Teleport"
        v_u_217.Visible = p668 == "Find"
        v_u_296.Visible = p668 == "Friends"
        v_u_332.Visible = p668 == "Dice"
        v_u_626.Visible = p668 == "Settings"
        if v_u_7 and v_u_523 then
            v_u_523.Visible = p668 == "Anchor"
        end
        if v_u_7 and v_u_525 then
            v_u_525.Visible = p668 == "Bans"
        end
        if v_u_7 and v_u_527 then
            v_u_527.Visible = p668 == "Whitelist"
        end
        if v_u_7 and v_u_529 then
            v_u_529.Visible = p668 == "Logs"
        end
        for v669, v670 in pairs(v_u_130) do
            if v669 == p668 then
                local Button = v670.Button
                local v672 = {
                    ["BackgroundColor3"] = v_u_8.Accent
                }
                TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), v672):Play()
                v670.Label.TextColor3 = v_u_8.AccentText
            else
                local Button_0 = v670.Button
                local v674 = {
                    ["BackgroundColor3"] = v_u_8.Sidebar
                }
                TweenService:Create(Button_0, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), v674):Play()
                v670.Label.TextColor3 = v_u_8.TextSecondary
            end
        end
        if p668 == "Teleport" then
            v_u_282()
            AdminCommand:FireServer("getwhitelistids")
            return
        elseif p668 == "Friends" then
            v_u_327()
            AdminCommand:FireServer("getwhitelistids")
            AdminCommand:FireServer("getmywhitelistedfriends")
            return
        elseif p668 == "Dice" then
            AdminCommand:FireServer("getdicebalance")
            AdminCommand:FireServer("getdicehistory")
            return
        elseif p668 == "Anchor" and v_u_7 then
            AdminCommand:FireServer("getadminlist")
            return
        elseif p668 == "Bans" and v_u_7 then
            AdminCommand:FireServer("getbanlist")
            return
        elseif p668 == "Whitelist" and v_u_7 then
            AdminCommand:FireServer("getwhitelist")
        elseif p668 == "Logs" and v_u_7 then
            AdminCommand:FireServer("getlogs")
        end
    end
    for v_u_676, v677 in pairs(v_u_130) do
        v677.Button.MouseButton1Click:Connect(function()
            -- upvalues: (copy) v_u_675, (copy) v_u_676
            v_u_675(v_u_676)
        end)
    end
    local v_u_678 = false
    local Position = nil
    local Position_0 = nil
    v100.InputBegan:Connect(function(p681)
        -- upvalues: (ref) v_u_678, (ref) Position, (ref) Position_0, (copy) v_u_95
        if p681.UserInputType == Enum.UserInputType.MouseButton1 or p681.UserInputType == Enum.UserInputType.Touch then
            v_u_678 = true
            Position = p681.Position
            Position_0 = v_u_95.Position
        end
    end)
    v100.InputEnded:Connect(function()
        -- upvalues: (ref) v_u_678
        v_u_678 = false
    end)
    UserInputService.InputChanged:Connect(function(p682)
        -- upvalues: (ref) v_u_678, (ref) Position, (copy) v_u_95, (ref) Position_0
        if v_u_678 and (p682.UserInputType == Enum.UserInputType.MouseMovement or p682.UserInputType == Enum.UserInputType.Touch) then
            local v683 = p682.Position - Position
            v_u_95.Position = UDim2.new(Position_0.X.Scale, Position_0.X.Offset + v683.X, Position_0.Y.Scale, Position_0.Y.Offset + v683.Y)
        end
    end)
    local function v_u_685() -- name: TogglePanel
        -- upvalues: (copy) v_u_94, (copy) v_u_96, (copy) v_u_95, (ref) v_u_282, (copy) AdminCommand, (copy) v_u_7
        if v_u_94.Enabled then
            local Visible = not v_u_96.Visible
            v_u_96.Visible = Visible
            v_u_95.Visible = Visible
            if Visible then
                v_u_282()
                AdminCommand:FireServer("gettracked")
                AdminCommand:FireServer("getsavedsettings")
                AdminCommand:FireServer("getmutualfriends")
                AdminCommand:FireServer("getwhitelistids")
                if v_u_7 then
                    AdminCommand:FireServer("getadminlist")
                    AdminCommand:FireServer("getbanlist")
                end
            end
        end
    end
    UserInputService.InputBegan:Connect(function(p686, p687)
        -- upvalues: (copy) v_u_6, (copy) v_u_685
        if not p687 then
            if p686.KeyCode == v_u_6 then
                v_u_685()
            end
        end
    end)
    local v_u_688 = Instance.new("TextButton")
    v_u_688.Name = "MobileAdminToggle"
    v_u_688.Size = UDim2.new(0, 118, 0, 36)
    v_u_688.Position = UDim2.new(1, -130, 0, 16)
    v_u_688.BackgroundColor3 = v_u_8.Accent
    v_u_688.Text = "Admin Panel"
    v_u_688.TextColor3 = v_u_8.AccentText
    v_u_688.TextSize = 13
    v_u_688.Font = GothamBold
    v_u_688.AutoButtonColor = false
    v_u_688.BorderSizePixel = 0
    v_u_688.ZIndex = 40
    v_u_688.Visible = true
    v_u_688.Parent = v_u_94
    local v689 = Instance.new("UICorner")
    v689.CornerRadius = UDim.new(0, 18)
    v689.Parent = v_u_688
    local v690 = Color3.fromRGB(0, 0, 0)
    local v691 = Instance.new("UIStroke")
    v691.Color = v690 or v_u_8.Border
    v691.Thickness = 1
    v691.Transparency = 0.6
    v691.Parent = v_u_688
    v_u_688.MouseEnter:Connect(function()
        -- upvalues: (copy) v_u_688, (copy) v_u_8, (copy) TweenService
        local v692 = v_u_688
        local v693 = {
            ["BackgroundColor3"] = v_u_8.AccentHover
        }
        TweenService:Create(v692, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), v693):Play()
    end)
    v_u_688.MouseLeave:Connect(function()
        -- upvalues: (copy) v_u_688, (copy) v_u_8, (copy) TweenService
        local v694 = v_u_688
        local v695 = {
            ["BackgroundColor3"] = v_u_8.Accent
        }
        TweenService:Create(v694, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), v695):Play()
    end)
    v_u_688.MouseButton1Click:Connect(v_u_685)
    local v_u_696 = nil
    local Position_1 = nil
    local Position_2 = nil
    v_u_688.InputBegan:Connect(function(p699)
        -- upvalues: (ref) v_u_696, (ref) Position_1, (ref) Position_2, (copy) v_u_688
        if p699.UserInputType == Enum.UserInputType.Touch or p699.UserInputType == Enum.UserInputType.MouseButton1 then
            v_u_696 = true
            Position_1 = p699.Position
            Position_2 = v_u_688.Position
        end
    end)
    v_u_688.InputEnded:Connect(function()
        -- upvalues: (ref) v_u_696
        v_u_696 = false
    end)
    UserInputService.InputChanged:Connect(function(p700)
        -- upvalues: (ref) v_u_696, (ref) Position_1, (copy) v_u_688, (ref) Position_2
        if v_u_696 and (p700.UserInputType == Enum.UserInputType.Touch or p700.UserInputType == Enum.UserInputType.MouseMovement) then
            local v701 = p700.Position - Position_1
            v_u_688.Position = UDim2.new(Position_2.X.Scale, Position_2.X.Offset + v701.X, Position_2.Y.Scale, Position_2.Y.Offset + v701.Y)
        end
    end)
    local v_u_702 = Instance.new("ScreenGui")
    v_u_702.Name = "RejoinGui"
    v_u_702.ResetOnSpawn = false
    v_u_702.ZIndexBehavior = Enum.ZIndexBehavior.Global
    v_u_702.Parent = LocalPlayer.PlayerGui
    v_u_702.Enabled = false
    local v_u_703 = Instance.new("TextButton")
    v_u_703.Name = "RejoinButton"
    v_u_703.Size = UDim2.new(0, 94, 0, 34)
    v_u_703.Position = UDim2.new(1, -106, 1, -46)
    v_u_703.BackgroundColor3 = v_u_8.Accent
    v_u_703.Text = "Rejoin"
    v_u_703.TextColor3 = v_u_8.AccentText
    v_u_703.TextSize = 12
    v_u_703.Font = GothamBold
    v_u_703.AutoButtonColor = false
    v_u_703.BorderSizePixel = 0
    v_u_703.ZIndex = 40
    v_u_703.Parent = v_u_702
    local v704 = Instance.new("UICorner")
    v704.CornerRadius = UDim.new(0, 8)
    v704.Parent = v_u_703
    local v705 = Color3.fromRGB(0, 0, 0)
    local v706 = Instance.new("UIStroke")
    v706.Color = v705 or v_u_8.Border
    v706.Thickness = 1
    v706.Transparency = 0.6
    v706.Parent = v_u_703
    v_u_703.MouseEnter:Connect(function()
        -- upvalues: (copy) v_u_703, (copy) v_u_8, (copy) TweenService
        local v707 = v_u_703
        local v708 = {
            ["BackgroundColor3"] = v_u_8.AccentHover
        }
        TweenService:Create(v707, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), v708):Play()
    end)
    v_u_703.MouseLeave:Connect(function()
        -- upvalues: (copy) v_u_703, (copy) v_u_8, (copy) TweenService
        local v709 = v_u_703
        local v710 = {
            ["BackgroundColor3"] = v_u_8.Accent
        }
        TweenService:Create(v709, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), v710):Play()
    end)
    v_u_703.MouseButton1Click:Connect(function()
        -- upvalues: (copy) AdminCommand
        print("[AdminPanel-Client] Rejoin button clicked, sending to server...")
        AdminCommand:FireServer("rejoin")
    end)
    local v_u_711 = {}
    local function v_u_715() -- name: RepositionAlerts
        -- upvalues: (copy) v_u_711, (copy) TweenService
        local v712 = 14
        for _, v713 in ipairs(v_u_711) do
            if v713 and v713.Parent then
                local v714 = {
                    ["Position"] = UDim2.new(0.5, -170, 0, v712)
                }
                TweenService:Create(v713, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), v714):Play()
                v712 = v712 + v713.AbsoluteSize.Y + 8
            end
        end
    end
    function CreateAlert(p716, p717, p_u_718, p_u_719, p720) -- name: CreateAlert
        -- upvalues: (copy) v_u_92, (copy) v_u_93, (copy) v_u_8, (copy) v_u_94, (copy) v_u_30, (copy) GothamBold, (copy) Gotham, (copy) v_u_39, (copy) AdminCommand, (copy) v_u_711, (copy) v_u_715, (copy) TweenService
        if p720 then
            pcall(function()
                -- upvalues: (ref) v_u_92
                v_u_92:Play()
            end)
        else
            pcall(function()
                -- upvalues: (ref) v_u_93
                v_u_93:Play()
            end)
        end
        local v_u_721 = Instance.new("Frame")
        v_u_721.Size = UDim2.new(0, 340, 0, 0)
        v_u_721.AutomaticSize = Enum.AutomaticSize.Y
        v_u_721.Position = UDim2.new(0.5, -170, 0, -100)
        v_u_721.BackgroundColor3 = v_u_8.Panel
        v_u_721.BorderSizePixel = 0
        v_u_721.Parent = v_u_94
        v_u_721.ZIndex = 50
        local v722 = Instance.new("UICorner")
        v722.CornerRadius = UDim.new(0, 10)
        v722.Parent = v_u_721
        local BorderBright_0 = v_u_8.BorderBright
        local v724 = Instance.new("UIStroke")
        v724.Color = BorderBright_0 or v_u_8.Border
        v724.Thickness = 1
        v724.Transparency = 0
        v724.Parent = v_u_721
        v_u_30(v_u_721, 12, 12, 10, 10)
        local v725 = Instance.new("Frame")
        v725.Size = UDim2.new(0, 3, 1, -20)
        v725.Position = UDim2.new(0, 0, 0, 10)
        v725.BackgroundColor3 = v_u_8.Accent
        v725.BorderSizePixel = 0
        v725.ZIndex = 51
        v725.Parent = v_u_721
        local v726 = Instance.new("UICorner")
        v726.CornerRadius = UDim.new(0, 2)
        v726.Parent = v725
        local v727 = p_u_718 ~= nil and true or p_u_719 ~= nil
        local v728 = Instance.new("Frame")
        v728.Size = UDim2.new(1, 0, 0, 0)
        v728.AutomaticSize = Enum.AutomaticSize.Y
        v728.BackgroundTransparency = 1
        v728.ZIndex = 51
        v728.Parent = v_u_721
        v_u_30(v728, 8, v727 and 84 or 0, 0, 0)
        local v729 = Instance.new("TextLabel")
        v729.Size = UDim2.new(1, 0, 0, 18)
        v729.BackgroundTransparency = 1
        v729.Text = tostring(p716 or "ALERT")
        v729.TextColor3 = v_u_8.Accent
        v729.Font = GothamBold
        v729.TextSize = 12
        v729.TextXAlignment = Enum.TextXAlignment.Left
        v729.ZIndex = 51
        v729.Parent = v728
        local v730 = Instance.new("TextLabel")
        v730.Size = UDim2.new(1, 0, 0, 0)
        v730.AutomaticSize = Enum.AutomaticSize.Y
        v730.Position = UDim2.new(0, 0, 0, 20)
        v730.BackgroundTransparency = 1
        v730.Text = tostring(p717 or "")
        v730.TextColor3 = v_u_8.TextSecondary
        v730.Font = Gotham
        v730.TextSize = 11
        v730.TextXAlignment = Enum.TextXAlignment.Left
        v730.TextWrapped = true
        v730.ZIndex = 51
        v730.Parent = v728
        if v727 then
            local v731 = v_u_39({
                ["Parent"] = nil,
                ["Text"] = "Join",
                ["Size"] = nil,
                ["Position"] = nil,
                ["Color"] = nil,
                ["HoverColor"] = nil,
                ["TextSize"] = 10,
                ["Radius"] = 7,
                ["Parent"] = v_u_721,
                ["Size"] = UDim2.new(0, 66, 0, 28),
                ["Position"] = UDim2.new(1, -78, 0.5, -14),
                ["Color"] = v_u_8.Accent,
                ["HoverColor"] = v_u_8.AccentHover
            })
            v731.ZIndex = 51
            v731.MouseButton1Click:Connect(function()
                -- upvalues: (ref) AdminCommand, (copy) p_u_719, (copy) p_u_718, (ref) v_u_711, (copy) v_u_721, (ref) v_u_715
                local v732 = AdminCommand
                local v733 = p_u_719
                local PlaceId_2 = p_u_718 or game.PlaceId
                v732:FireServer("teleportmetoserver", v733, (tostring(PlaceId_2)))
                for v735, v736 in ipairs(v_u_711) do
                    if v736 == v_u_721 then
                        table.remove(v_u_711, v735)
                        break
                    end
                end
                v_u_721:Destroy()
                v_u_715()
            end)
        end
        local v737 = v_u_711
        table.insert(v737, v_u_721)
        task.defer(function()
            -- upvalues: (ref) v_u_715
            task.wait()
            v_u_715()
        end)
        task.delay(10, function()
            -- upvalues: (copy) v_u_721, (ref) v_u_711, (ref) TweenService, (ref) v_u_715
            if v_u_721 and v_u_721.Parent then
                for v738, v739 in ipairs(v_u_711) do
                    if v739 == v_u_721 then
                        table.remove(v_u_711, v738)
                        break
                    end
                end
                local v740 = v_u_721
                local v741 = {
                    ["Position"] = UDim2.new(0.5, -170, 0, -100)
                }
                TweenService:Create(v740, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), v741):Play()
                v_u_715()
                task.delay(0.22, function()
                    -- upvalues: (ref) v_u_721
                    if v_u_721 and v_u_721.Parent then
                        v_u_721:Destroy()
                    end
                end)
            end
        end)
    end
    local v_u_742 = nil
    local function v_u_754() -- name: buildLoadingGui
        -- upvalues: (copy) v_u_8, (copy) GothamBlack, (copy) TweenService
        local v743 = Instance.new("ScreenGui")
        v743.Name = "TeleportLoadingGui"
        v743.ResetOnSpawn = false
        v743.IgnoreGuiInset = true
        v743.DisplayOrder = 9999
        local v744 = Instance.new("Frame")
        v744.Size = UDim2.fromScale(1, 1)
        v744.BackgroundColor3 = v_u_8.Background
        v744.BackgroundTransparency = 0
        v744.BorderSizePixel = 0
        v744.ZIndex = 9999
        v744.Parent = v743
        local v745 = Instance.new("TextLabel")
        v745.AnchorPoint = Vector2.new(0.5, 0.5)
        v745.Size = UDim2.new(0.8, 0, 0, 40)
        v745.Position = UDim2.new(0.5, 0, 0.45, 0)
        v745.BackgroundTransparency = 1
        v745.Text = "RESTARTING SERVERS..."
        v745.Font = GothamBlack
        v745.TextSize = 26
        v745.TextColor3 = v_u_8.Accent
        v745.ZIndex = 9999
        v745.Parent = v744
        local v746 = Instance.new("Frame")
        v746.AnchorPoint = Vector2.new(0.5, 0.5)
        v746.Size = UDim2.new(0.5, 0, 0, 6)
        v746.Position = UDim2.new(0.5, 0, 0.52, 0)
        v746.BackgroundColor3 = v_u_8.Panel
        v746.BorderSizePixel = 0
        v746.ZIndex = 9999
        v746.Parent = v744
        local v747 = Instance.new("UICorner")
        v747.CornerRadius = UDim.new(0, 3)
        v747.Parent = v746
        local v_u_748 = Instance.new("Frame")
        v_u_748.Size = UDim2.new(0, 0, 1, 0)
        v_u_748.BackgroundColor3 = v_u_8.Accent
        v_u_748.BorderSizePixel = 0
        v_u_748.ZIndex = 9999
        v_u_748.Parent = v746
        local v749 = Instance.new("UICorner")
        v749.CornerRadius = UDim.new(0, 3)
        v749.Parent = v_u_748
        task.spawn(function()
            -- upvalues: (copy) v_u_748, (ref) TweenService
            while v_u_748 and v_u_748.Parent do
                local v750 = v_u_748
                local v751 = {
                    ["Size"] = UDim2.new(0.75, 0, 1, 0)
                }
                TweenService:Create(v750, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), v751):Play()
                task.wait(0.9)
                if not (v_u_748 and v_u_748.Parent) then
                    break
                end
                local v752 = v_u_748
                local v753 = {
                    ["Size"] = UDim2.new(0.08, 0, 1, 0)
                }
                TweenService:Create(v752, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), v753):Play()
                task.wait(0.5)
            end
        end)
        return v743
    end
    game:GetService("TeleportService").TeleportInitFailed:Connect(function(p755, _, p756)
        -- upvalues: (copy) LocalPlayer, (ref) v_u_742
        if p755 == LocalPlayer then
            if v_u_742 then
                v_u_742:Destroy()
                v_u_742 = nil
            end
            local TpOverlay = LocalPlayer.PlayerGui:FindFirstChild("TpOverlay")
            if TpOverlay then
                TpOverlay:Destroy()
            end
            local v758 = tostring(p756 or "")
            if v758:lower():find("full") then
                CreateAlert("Error", "Server is full!", nil, nil)
            else
                CreateAlert("Error", "Teleport failed" .. (v758 == "" and "" or (": " .. v758 or "")), nil, nil)
            end
        else
            return
        end
    end)
    AdminCommand.OnClientEvent:Connect(function(p759, p760, p761, p762, p763)
        -- upvalues: (ref) v_u_742, (copy) v_u_754, (copy) LocalPlayer, (copy) v_u_94, (copy) v_u_96, (copy) v_u_95, (copy) v_u_7, (ref) v_u_641, (ref) v_u_642, (copy) v_u_112, (copy) v_u_118, (copy) v_u_23, (copy) v_u_8, (copy) v_u_116, (ref) v_u_286, (ref) v_u_248, (ref) v_u_281, (ref) v_u_287, (ref) v_u_291, (ref) v_u_290, (copy) AdminCommand, (copy) Gotham, (ref) v_u_223, (ref) v_u_280, (ref) v_u_265, (ref) v_u_523, (ref) v_u_524, (ref) v_u_526, (ref) v_u_289, (copy) v_u_702, (ref) v_u_137, (ref) v_u_282, (ref) v_u_296, (ref) v_u_327, (ref) v_u_528, (ref) v_u_326, (copy) v_u_295, (ref) v_u_283, (ref) v_u_284, (copy) v_u_92, (copy) v_u_634, (copy) v_u_666, (ref) v_u_529, (ref) v_u_499, (ref) v_u_497, (ref) v_u_418, (ref) v_u_467, (ref) v_u_518, (ref) v_u_387, (ref) v_u_285, (ref) v_u_288
        if p759 == "ShowTPLoading" then
            if v_u_742 then
                v_u_742:Destroy()
            end
            v_u_742 = v_u_754()
            game:GetService("TeleportService"):SetTeleportGui(v_u_742)
        elseif p759 == "HideTPLoading" then
            if v_u_742 then
                v_u_742:Destroy()
                v_u_742 = nil
            end
            local TpOverlay_0 = LocalPlayer.PlayerGui:FindFirstChild("TpOverlay")
            if TpOverlay_0 then
                TpOverlay_0:Destroy()
                return
            end
        else
            if p759 == "EnablePanel" then
                print("[AdminPanel-Client] Received EnablePanel")
                v_u_94.Enabled = true
                return
            end
            if p759 == "AdminGranted" then
                v_u_94.Enabled = true
                CreateAlert("Admin Granted", tostring(p761) .. " gave you admin for " .. tostring(p760) .. " minutes", nil, nil)
                return
            end
            if p759 == "AdminRevoked" then
                print("[AdminPanel-Client] Received AdminRevoked - closing panel")
                v_u_94.Enabled = false
                v_u_96.Visible = false
                v_u_95.Visible = false
                CreateAlert("Admin Revoked", "Your admin access has been removed", nil, nil)
                return
            end
            if p759 == "AdminTimeLeft" then
                if not v_u_7 then
                    local v765 = p761 or false
                    v_u_641 = v765
                    if v_u_642 then
                        v_u_642.Text = v765 and "Resume Time" or "Pause Time (-8 min)"
                    end
                    if p760 and p760 > 0 then
                        v_u_112.Visible = true
                        if v765 then
                            v_u_118.Text = v_u_23(p760) .. " (paused)"
                            v_u_118.TextColor3 = v_u_8.Success
                            v_u_116.BackgroundColor3 = v_u_8.Success
                        else
                            v_u_118.Text = v_u_23(p760) .. " left"
                            v_u_118.TextColor3 = v_u_8.Warning
                            v_u_116.BackgroundColor3 = v_u_8.Warning
                        end
                    else
                        v_u_112.Visible = false
                        return
                    end
                end
            elseif p759 == "AdminTimePaused" then
                v_u_641 = true
                if v_u_642 then
                    v_u_642.Text = "Resume Time"
                end
                if not v_u_7 and (p760 and p760 > 0) then
                    v_u_112.Visible = true
                    v_u_118.Text = v_u_23(p760) .. " (paused)"
                    v_u_118.TextColor3 = v_u_8.Success
                    v_u_116.BackgroundColor3 = v_u_8.Success
                    return
                end
            elseif p759 == "AdminTimeUnpaused" then
                v_u_641 = false
                if v_u_642 then
                    v_u_642.Text = "Pause Time (-8 min)"
                end
                if not v_u_7 and (p760 and p760 > 0) then
                    v_u_112.Visible = true
                    v_u_118.Text = v_u_23(p760) .. " left"
                    v_u_118.TextColor3 = v_u_8.Warning
                    v_u_116.BackgroundColor3 = v_u_8.Warning
                    return
                end
            elseif p759 == "DicingStatus" then
                if not v_u_7 then
                    v_u_112.Visible = true
                    v_u_118.Text = "DICING"
                    v_u_118.TextColor3 = v_u_8.Accent
                    v_u_116.BackgroundColor3 = v_u_8.Accent
                    return
                end
            elseif p759 == "KeysPendingStatus" then
                if not v_u_7 then
                    v_u_112.Visible = true
                    v_u_118.Text = "KEY PENDING"
                    v_u_118.TextColor3 = v_u_8.Success
                    v_u_116.BackgroundColor3 = v_u_8.Success
                    return
                end
            elseif p759 == "SearchResults" then
                if v_u_286 == "global" then
                    v_u_248(p760)
                    return
                end
            elseif p759 == "GlobalSearchResults" then
                if v_u_286 == "global" then
                    v_u_248(p760)
                    return
                end
            elseif p759 == "OfflineSearchResult" then
                if v_u_286 == "offline" then
                    for _, v766 in pairs(v_u_281) do
                        v766:Destroy()
                    end
                    v_u_281 = {}
                    if p760 and #p760 > 0 then
                        v_u_287.Visible = true
                        for _, v_u_767 in pairs(p760) do
                            local v768 = v_u_291(v_u_287, v_u_767, {
                                ["subtitle"] = v_u_767.online and "Online (other server)" or "Offline"
                            })
                            v_u_290(v768, "Track", v_u_8.Success, v_u_8.SuccessHover, -62, 48, function(p_u_769)
                                -- upvalues: (ref) AdminCommand, (copy) v_u_767
                                AdminCommand:FireServer("track", {
                                    ["userId"] = v_u_767.userId,
                                    ["name"] = v_u_767.name
                                })
                                p_u_769.Text = "Done"
                                task.delay(1.5, function()
                                    -- upvalues: (copy) p_u_769
                                    p_u_769.Text = "Track"
                                end)
                            end)
                            if v_u_7 then
                                v_u_290(v768, "Ban", v_u_8.Danger, v_u_8.DangerHover, -118, 42, function(p_u_770)
                                    -- upvalues: (ref) AdminCommand, (copy) v_u_767
                                    AdminCommand:FireServer("ban", v_u_767.name)
                                    p_u_770.Text = "Done"
                                    task.delay(1.5, function()
                                        -- upvalues: (copy) p_u_770
                                        p_u_770.Text = "Ban"
                                    end)
                                end)
                            end
                            if v_u_767.online and v_u_767.jobId then
                                v_u_290(v768, "Join", v_u_8.Warning, v_u_8.WarningHover, -172, 48, function()
                                    -- upvalues: (ref) AdminCommand, (copy) v_u_767
                                    local v771 = AdminCommand
                                    local jobId_1 = v_u_767.jobId
                                    local PlaceId_3 = v_u_767.placeId or game.PlaceId
                                    v771:FireServer("teleportmetoserver", jobId_1, (tostring(PlaceId_3)))
                                end)
                            end
                            v_u_281[v_u_767.userId] = v768
                        end
                    else
                        v_u_287.Visible = true
                        local v774 = Instance.new("TextLabel")
                        v774.Size = UDim2.new(1, 0, 0, 30)
                        v774.BackgroundTransparency = 1
                        v774.Text = "No results. Check spelling (exact username required)."
                        v774.TextColor3 = v_u_8.TextMuted
                        v774.Font = Gotham
                        v774.TextSize = 10
                        v774.TextWrapped = true
                        v774.Parent = v_u_287
                        v_u_281.__none__ = v774
                    end
                end
            elseif p759 == "PlayerOnline" then
                CreateAlert("Player Online", tostring(p760) .. " is now online \226\128\148 click Join to go there", p762, p763, true)
                if v_u_223.Visible then
                    AdminCommand:FireServer("gettracked")
                    return
                end
            elseif p759 == "PlayerOffline" then
                CreateAlert("Player Offline", tostring(p760) .. " has gone offline", nil, nil)
                if v_u_223.Visible then
                    AdminCommand:FireServer("gettracked")
                    return
                end
            else
                if p759 == "TrackedList" then
                    v_u_280(p760)
                    return
                end
                if p759 == "StaffList" then
                    v_u_265(p760)
                    return
                end
                if p759 == "AdminList" then
                    if v_u_7 and (v_u_523 and v_u_524) then
                        v_u_524(p760 or {})
                        return
                    end
                elseif p759 == "BanList" then
                    if v_u_7 and v_u_526 then
                        v_u_526(p760 or {})
                        return
                    end
                elseif p759 == "WhitelistIds" then
                    v_u_289 = {}
                    for _, v775 in ipairs(p760 or {}) do
                        v_u_289[v775] = true
                    end
                    local v776 = print
                    local format = string.format
                    local v778 = #(p760 or {})
                    local v779 = v_u_289[LocalPlayer.UserId] == true
                    v776(format("[AdminPanel-Client] Received WhitelistIds, count=%d, amIWhitelisted=%s", v778, (tostring(v779))))
                    if v_u_289[LocalPlayer.UserId] then
                        v_u_702.Enabled = true
                    end
                    if v_u_137.Visible then
                        v_u_282()
                    end
                    if v_u_296.Visible then
                        v_u_327()
                        return
                    end
                elseif p759 == "WhitelistList" then
                    if v_u_7 and v_u_528 then
                        v_u_528(p760 or {})
                        return
                    end
                else
                    if p759 == "MyWhitelistedFriends" then
                        v_u_326(p760)
                        return
                    end
                    if p759 == "WhitelistFriendResult" then
                        local v780 = p760 or {}
                        local userId = v780.userId
                        if userId then
                            userId = v_u_295[v780.userId]
                        end
                        if v780.userId then
                            v_u_295[v780.userId] = nil
                        end
                        if not v780.success then
                            if userId then
                                userId.Text = "Whitelist Friend"
                            end
                            local v782 = CreateAlert
                            local v783 = v780.message or "Failed to whitelist"
                            v782("Error", tostring(v783), nil, nil)
                            return
                        end
                        if userId then
                            userId.Text = "Done"
                            userId.AutoButtonColor = false
                            return
                        end
                    elseif p759 == "SettingsUpdated" then
                        if p760.jobId ~= nil then
                            v_u_283.Text = p760.jobId
                        end
                        if p760.placeId and p760.placeId ~= "" then
                            v_u_284.Text = p760.placeId
                        else
                            local v784 = v_u_284
                            local PlaceId_4 = game.PlaceId
                            v784.Text = tostring(PlaceId_4)
                        end
                        if p760.trackingSoundId and p760.trackingSoundId ~= "" then
                            v_u_92.SoundId = "rbxassetid://" .. p760.trackingSoundId
                            local v786 = v_u_634
                            local trackingSoundId = p760.trackingSoundId
                            v786.Text = tostring(trackingSoundId)
                        end
                        if p760.gameAudioMuted ~= nil then
                            v_u_666(p760.gameAudioMuted)
                            return
                        end
                    elseif p759 == "LogsList" then
                        if v_u_7 and _G._AdminPanel_RefreshLogs then
                            _G._AdminPanel_RefreshLogs(p760 or {})
                            return
                        end
                    elseif p759 == "LogEntry" then
                        if v_u_7 and (_G._AdminPanel_AddLogRow and (v_u_529 and v_u_529.Visible)) then
                            _G._AdminPanel_AddLogRow(p760, true)
                            return
                        end
                    else
                        if p759 == "WhitelistRejoin" then
                            v_u_702.Enabled = true
                            return
                        end
                        if p759 == "DiceBalanceUpdated" then
                            v_u_499(p760 or 0)
                            return
                        end
                        if p759 == "DiceHistory" then
                            v_u_497(p760)
                            return
                        end
                        if p759 == "DiceRerollPending" then
                            if p760 then
                                v_u_418(p760.dice)
                                v_u_467(true)
                                local v788 = CreateAlert
                                local matches_0 = p760.matches
                                local color_0 = p760.color
                                v788("2+ Match!", matches_0 .. "/4 " .. tostring(color_0) .. " - pick a color and press Re-Roll (free)", nil, nil)
                                return
                            end
                        elseif p759 == "DiceRollResult" then
                            v_u_467(false)
                            AdminCommand:FireServer("getdicehistory")
                            if p760 then
                                local v791 = p760.net >= 0 and "+" or ""
                                local net_0 = p760.net
                                local v793 = v791 .. tostring(net_0) .. " min"
                                if p760.redice then
                                    v_u_418(p760.bonusDice)
                                    local v794 = p760.bonusMatches and p760.bonusMatches > 0 and "Re-roll won" or "Re-roll lost"
                                    local v795 = CreateAlert
                                    local bonusColor_0 = p760.bonusColor
                                    v795("Roll Result", v794 .. " (" .. tostring(bonusColor_0) .. ") - " .. v793, nil, nil)
                                else
                                    v_u_418(p760.dice)
                                    local v797 = CreateAlert
                                    local matches_1 = p760.matches
                                    local color_1 = p760.color
                                    v797("Roll Result", matches_1 .. "/4 " .. tostring(color_1) .. " - " .. v793, nil, nil)
                                end
                            end
                        else
                            if p759 == "MyKeysList" then
                                v_u_518(p760)
                                return
                            end
                            if p759 == "DiceKeyGenerated" then
                                v_u_387.Text = tostring(p760)
                                CreateAlert("Key Generated", "Your 1-hour key is ready - copy it from the box under Cash Out", nil, nil)
                                AdminCommand:FireServer("getmykeys")
                                return
                            end
                            if p759 == "DiceError" then
                                CreateAlert("Error", tostring(p760), nil, nil)
                                return
                            end
                            if p759 == "CodeSuccess" then
                                CreateAlert("Success", tostring(p760), nil, nil)
                                return
                            end
                            if p759 == "CodeError" then
                                CreateAlert("Error", tostring(p760), nil, nil)
                                return
                            end
                            if p759 == "Error" then
                                CreateAlert("Error", tostring(p760), nil, nil)
                                return
                            end
                            if p759 == "Success" then
                                CreateAlert("Success", tostring(p760), nil, nil)
                                return
                            end
                            if p759 == "MutualFriends" then
                                v_u_285 = false
                                v_u_288 = p760 or {}
                                v_u_282()
                                if v_u_296.Visible then
                                    v_u_327()
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    if v_u_7 then
        v_u_94.Enabled = true
        v_u_702.Enabled = true
        AdminCommand:FireServer("getsavedsettings")
        AdminCommand:FireServer("getadminlist")
        AdminCommand:FireServer("getbanlist")
    end
    AdminCommand:FireServer("getmutualfriends")
    Players.PlayerAdded:Connect(function()
        -- upvalues: (copy) v_u_111, (copy) Players, (ref) v_u_282
        v_u_111.Text = #Players:GetPlayers() .. " online"
        task.delay(0.3, v_u_282)
    end)
    Players.PlayerRemoving:Connect(function()
        -- upvalues: (copy) v_u_111, (copy) Players, (ref) v_u_282
        task.defer(function()
            -- upvalues: (ref) v_u_111, (ref) Players
            v_u_111.Text = #Players:GetPlayers() .. " online"
        end)
        v_u_282()
    end)
else
    warn("AdminCommand remote not found! (waited 15s - check that the server script is running and placed correctly)")
end
