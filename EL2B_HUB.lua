-- AspectUnifiedMenu (ScreenGui)
G.AspectUnifiedMenu = Instance.new("ScreenGui")
G.AspectUnifiedMenu.Name = "AspectUnifiedMenu"
G.AspectUnifiedMenu.ResetOnSpawn = false
G.AspectUnifiedMenu.DisplayOrder = 100
G.AspectUnifiedMenu.IgnoreGuiInset = true
G.AspectUnifiedMenu.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
G.AspectUnifiedMenu.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets

-- Sound (Sound)
G.Sound = Instance.new("Sound")
G.Sound.Parent = G.AspectUnifiedMenu

-- UIScale (UIScale)
G.UIScale = Instance.new("UIScale")
G.UIScale.Scale = 0.64999997615814209
G.UIScale.Parent = G.AspectUnifiedMenu

-- AspectTP (Frame)
G.AspectTP = Instance.new("Frame")
G.AspectTP.Name = "AspectTP"
G.AspectTP.AutomaticSize = Enum.AutomaticSize.Y
G.AspectTP.BackgroundColor3 = Color3.fromRGB(42, 17, 69)
G.AspectTP.BackgroundTransparency = 0.2800000011920929
G.AspectTP.BorderSizePixel = 0
G.AspectTP.Position = UDim2.new(0, 16, 0, 119)
G.AspectTP.Size = UDim2.new(0, 300, 0, 0)
G.AspectTP.ZIndex = 2
G.AspectTP.Parent = G.AspectUnifiedMenu

-- UICorner (UICorner)
G.UICorner = Instance.new("UICorner")
G.UICorner.CornerRadius = UDim.new(0, 14)
G.UICorner.Parent = G.AspectTP

-- UIGradient (UIGradient)
G.UIGradient = Instance.new("UIGradient")
G.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(23, 9, 39)), ColorSequenceKeypoint.new(0.25, Color3.fromRGB(41, 16, 67)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(61, 24, 95)), ColorSequenceKeypoint.new(0.75, Color3.fromRGB(80, 34, 122)), ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 7, 30))})
G.UIGradient.Rotation = 135
G.UIGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.059999998658895493, 0), NumberSequenceKeypoint.new(0.5, 0.10000000149011612, 0), NumberSequenceKeypoint.new(1, 0.059999998658895493, 0)})
G.UIGradient.Parent = G.AspectTP

-- UIStroke (UIStroke)
G.UIStroke = Instance.new("UIStroke")
G.UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke.Thickness = 1.3999999761581421
G.UIStroke.Transparency = 0.18000000715255737
G.UIStroke.Parent = G.AspectTP

-- UIGradient_2 (UIGradient)
G.UIGradient_2 = Instance.new("UIGradient")
G.UIGradient_2.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(129, 65, 181)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(186, 117, 245)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 47, 149))})
G.UIGradient_2.Rotation = 90
G.UIGradient_2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.44999998807907104, 0), NumberSequenceKeypoint.new(0.5, 0.2199999988079071, 0), NumberSequenceKeypoint.new(1, 0.41999998688697815, 0)})
G.UIGradient_2.Parent = G.UIStroke

-- Shadow (ImageLabel)
G.Shadow = Instance.new("ImageLabel")
G.Shadow.Name = "Shadow"
G.Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
G.Shadow.BackgroundTransparency = 1
G.Shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
G.Shadow.Size = UDim2.new(1, 40, 1, 40)
G.Shadow.ZIndex = 0
G.Shadow.Image = "rbxassetid://6014261993"
G.Shadow.ImageColor3 = Color3.fromRGB(11, 4, 19)
G.Shadow.ImageTransparency = 0.25
G.Shadow.ScaleType = Enum.ScaleType.Slice
G.Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
G.Shadow.Parent = G.AspectTP

-- Header (Frame)
G.Header = Instance.new("Frame")
G.Header.Name = "Header"
G.Header.Active = true
G.Header.BackgroundTransparency = 1
G.Header.BorderSizePixel = 0
G.Header.Size = UDim2.new(1, 0, 0, 40)
G.Header.ZIndex = 10
G.Header.Parent = G.AspectTP

-- TitleText (TextLabel)
G.TitleText = Instance.new("TextLabel")
G.TitleText.Name = "TitleText"
G.TitleText.BackgroundTransparency = 1
G.TitleText.Position = UDim2.new(0, 14, 0, 0)
G.TitleText.Size = UDim2.new(1, -28, 1, 0)
G.TitleText.ZIndex = 11
G.TitleText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TitleText.Text = "Aspect TP"
G.TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TitleText.TextSize = 14
G.TitleText.TextXAlignment = Enum.TextXAlignment.Left
G.TitleText.Parent = G.Header

-- Frame (Frame)
G.Frame = Instance.new("Frame")
G.Frame.BackgroundColor3 = Color3.fromRGB(188, 120, 255)
G.Frame.BackgroundTransparency = 0.55000001192092896
G.Frame.BorderSizePixel = 0
G.Frame.Position = UDim2.new(0, 14, 1, -1)
G.Frame.Size = UDim2.new(1, -28, 0, 1)
G.Frame.ZIndex = 11
G.Frame.Parent = G.Header

-- Holder (Frame)
G.Holder = Instance.new("Frame")
G.Holder.Name = "Holder"
G.Holder.AutomaticSize = Enum.AutomaticSize.Y
G.Holder.BackgroundTransparency = 1
G.Holder.Position = UDim2.new(0, 10, 0, 44)
G.Holder.Size = UDim2.new(1, -20, 0, 0)
G.Holder.ZIndex = 2
G.Holder.Parent = G.AspectTP

-- UIListLayout (UIListLayout)
G.UIListLayout = Instance.new("UIListLayout")
G.UIListLayout.Padding = UDim.new(0, 6)
G.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout.Parent = G.Holder

-- UIPadding (UIPadding)
G.UIPadding = Instance.new("UIPadding")
G.UIPadding.PaddingBottom = UDim.new(0, 12)
G.UIPadding.Parent = G.Holder

-- Frame_2 (Frame)
G.Frame_2 = Instance.new("Frame")
G.Frame_2.AutomaticSize = Enum.AutomaticSize.Y
G.Frame_2.BackgroundTransparency = 1
G.Frame_2.Size = UDim2.new(1, 0, 0, 0)
G.Frame_2.Parent = G.Holder

-- UIGridLayout (UIGridLayout)
G.UIGridLayout = Instance.new("UIGridLayout")
G.UIGridLayout.CellPadding = UDim2.new(0, 8, 0, 6)
G.UIGridLayout.CellSize = UDim2.new(0.5, -4, 0, 36)
G.UIGridLayout.FillDirectionMaxCells = 2
G.UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
G.UIGridLayout.Parent = G.Frame_2

-- Frame_3 (Frame)
G.Frame_3 = Instance.new("Frame")
G.Frame_3.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.Frame_3.BackgroundTransparency = 0.15000000596046448
G.Frame_3.BorderSizePixel = 0
G.Frame_3.Parent = G.Frame_2

-- UICorner_2 (UICorner)
G.UICorner_2 = Instance.new("UICorner")
G.UICorner_2.CornerRadius = UDim.new(0, 10)
G.UICorner_2.Parent = G.Frame_3

-- UIStroke_2 (UIStroke)
G.UIStroke_2 = Instance.new("UIStroke")
G.UIStroke_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_2.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_2.Transparency = 0.55000001192092896
G.UIStroke_2.Parent = G.Frame_3

-- TextLabel (TextLabel)
G.TextLabel = Instance.new("TextLabel")
G.TextLabel.BackgroundTransparency = 1
G.TextLabel.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel.Size = UDim2.new(1, -40, 1, 0)
G.TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel.Text = "Inf Jump"
G.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel.TextSize = 11
G.TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel.Parent = G.Frame_3

-- Frame_4 (Frame)
G.Frame_4 = Instance.new("Frame")
G.Frame_4.AnchorPoint = Vector2.new(1, 0.5)
G.Frame_4.BackgroundColor3 = Color3.fromRGB(188, 120, 255)
G.Frame_4.BackgroundTransparency = 0.15000000596046448
G.Frame_4.BorderSizePixel = 0
G.Frame_4.Position = UDim2.new(1, -6, 0.5, 0)
G.Frame_4.Size = UDim2.new(0, 32, 0, 18)
G.Frame_4.Parent = G.Frame_3

-- UICorner_3 (UICorner)
G.UICorner_3 = Instance.new("UICorner")
G.UICorner_3.CornerRadius = UDim.new(0, 9)
G.UICorner_3.Parent = G.Frame_4

-- UIStroke_3 (UIStroke)
G.UIStroke_3 = Instance.new("UIStroke")
G.UIStroke_3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_3.Color = Color3.fromRGB(188, 120, 255)
G.UIStroke_3.Transparency = 0.34999999403953552
G.UIStroke_3.Parent = G.Frame_4

-- Frame_5 (Frame)
G.Frame_5 = Instance.new("Frame")
G.Frame_5.AnchorPoint = Vector2.new(0, 0.5)
G.Frame_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Frame_5.BorderSizePixel = 0
G.Frame_5.Position = UDim2.new(0, 15, 0.5, 0)
G.Frame_5.Size = UDim2.new(0, 14, 0, 14)
G.Frame_5.Parent = G.Frame_4

-- UICorner_4 (UICorner)
G.UICorner_4 = Instance.new("UICorner")
G.UICorner_4.CornerRadius = UDim.new(0, 7)
G.UICorner_4.Parent = G.Frame_5

-- TextButton (TextButton)
G.TextButton = Instance.new("TextButton")
G.TextButton.BackgroundTransparency = 1
G.TextButton.Size = UDim2.new(1, 0, 1, 0)
G.TextButton.ZIndex = 5
G.TextButton.Text = ""
G.TextButton.Parent = G.Frame_3

-- Frame_6 (Frame)
G.Frame_6 = Instance.new("Frame")
G.Frame_6.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.Frame_6.BackgroundTransparency = 0.15000000596046448
G.Frame_6.BorderSizePixel = 0
G.Frame_6.Parent = G.Frame_2

-- UICorner_5 (UICorner)
G.UICorner_5 = Instance.new("UICorner")
G.UICorner_5.CornerRadius = UDim.new(0, 10)
G.UICorner_5.Parent = G.Frame_6

-- UIStroke_4 (UIStroke)
G.UIStroke_4 = Instance.new("UIStroke")
G.UIStroke_4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_4.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_4.Transparency = 0.55000001192092896
G.UIStroke_4.Parent = G.Frame_6

-- TextLabel_2 (TextLabel)
G.TextLabel_2 = Instance.new("TextLabel")
G.TextLabel_2.BackgroundTransparency = 1
G.TextLabel_2.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_2.Size = UDim2.new(1, -40, 1, 0)
G.TextLabel_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_2.Text = "Anti Ragdoll"
G.TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_2.TextSize = 11
G.TextLabel_2.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_2.Parent = G.Frame_6

-- Frame_7 (Frame)
G.Frame_7 = Instance.new("Frame")
G.Frame_7.AnchorPoint = Vector2.new(1, 0.5)
G.Frame_7.BackgroundColor3 = Color3.fromRGB(36, 16, 50)
G.Frame_7.BackgroundTransparency = 0.15000000596046448
G.Frame_7.BorderSizePixel = 0
G.Frame_7.Position = UDim2.new(1, -6, 0.5, 0)
G.Frame_7.Size = UDim2.new(0, 32, 0, 18)
G.Frame_7.Parent = G.Frame_6

-- UICorner_6 (UICorner)
G.UICorner_6 = Instance.new("UICorner")
G.UICorner_6.CornerRadius = UDim.new(0, 9)
G.UICorner_6.Parent = G.Frame_7

-- UIStroke_5 (UIStroke)
G.UIStroke_5 = Instance.new("UIStroke")
G.UIStroke_5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_5.Color = Color3.fromRGB(188, 120, 255)
G.UIStroke_5.Transparency = 0.69999998807907104
G.UIStroke_5.Parent = G.Frame_7

-- Frame_8 (Frame)
G.Frame_8 = Instance.new("Frame")
G.Frame_8.AnchorPoint = Vector2.new(0, 0.5)
G.Frame_8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Frame_8.BorderSizePixel = 0
G.Frame_8.Position = UDim2.new(0, 2, 0.5, 0)
G.Frame_8.Size = UDim2.new(0, 14, 0, 14)
G.Frame_8.Parent = G.Frame_7

-- UICorner_7 (UICorner)
G.UICorner_7 = Instance.new("UICorner")
G.UICorner_7.CornerRadius = UDim.new(0, 7)
G.UICorner_7.Parent = G.Frame_8

-- TextButton_2 (TextButton)
G.TextButton_2 = Instance.new("TextButton")
G.TextButton_2.BackgroundTransparency = 1
G.TextButton_2.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_2.ZIndex = 5
G.TextButton_2.Text = ""
G.TextButton_2.Parent = G.Frame_6

-- Frame_9 (Frame)
G.Frame_9 = Instance.new("Frame")
G.Frame_9.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.Frame_9.BackgroundTransparency = 0.15000000596046448
G.Frame_9.BorderSizePixel = 0
G.Frame_9.Parent = G.Frame_2

-- UICorner_8 (UICorner)
G.UICorner_8 = Instance.new("UICorner")
G.UICorner_8.CornerRadius = UDim.new(0, 10)
G.UICorner_8.Parent = G.Frame_9

-- UIStroke_6 (UIStroke)
G.UIStroke_6 = Instance.new("UIStroke")
G.UIStroke_6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_6.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_6.Transparency = 0.55000001192092896
G.UIStroke_6.Parent = G.Frame_9

-- TextLabel_3 (TextLabel)
G.TextLabel_3 = Instance.new("TextLabel")
G.TextLabel_3.BackgroundTransparency = 1
G.TextLabel_3.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_3.Size = UDim2.new(1, -40, 1, 0)
G.TextLabel_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_3.Text = "X-Ray"
G.TextLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_3.TextSize = 11
G.TextLabel_3.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_3.Parent = G.Frame_9

-- Frame_10 (Frame)
G.Frame_10 = Instance.new("Frame")
G.Frame_10.AnchorPoint = Vector2.new(1, 0.5)
G.Frame_10.BackgroundColor3 = Color3.fromRGB(188, 120, 255)
G.Frame_10.BackgroundTransparency = 0.15000000596046448
G.Frame_10.BorderSizePixel = 0
G.Frame_10.Position = UDim2.new(1, -6, 0.5, 0)
G.Frame_10.Size = UDim2.new(0, 32, 0, 18)
G.Frame_10.Parent = G.Frame_9

-- UICorner_9 (UICorner)
G.UICorner_9 = Instance.new("UICorner")
G.UICorner_9.CornerRadius = UDim.new(0, 9)
G.UICorner_9.Parent = G.Frame_10

-- UIStroke_7 (UIStroke)
G.UIStroke_7 = Instance.new("UIStroke")
G.UIStroke_7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_7.Color = Color3.fromRGB(188, 120, 255)
G.UIStroke_7.Transparency = 0.34999999403953552
G.UIStroke_7.Parent = G.Frame_10

-- Frame_11 (Frame)
G.Frame_11 = Instance.new("Frame")
G.Frame_11.AnchorPoint = Vector2.new(0, 0.5)
G.Frame_11.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Frame_11.BorderSizePixel = 0
G.Frame_11.Position = UDim2.new(0, 15, 0.5, 0)
G.Frame_11.Size = UDim2.new(0, 14, 0, 14)
G.Frame_11.Parent = G.Frame_10

-- UICorner_10 (UICorner)
G.UICorner_10 = Instance.new("UICorner")
G.UICorner_10.CornerRadius = UDim.new(0, 7)
G.UICorner_10.Parent = G.Frame_11

-- TextButton_3 (TextButton)
G.TextButton_3 = Instance.new("TextButton")
G.TextButton_3.BackgroundTransparency = 1
G.TextButton_3.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_3.ZIndex = 5
G.TextButton_3.Text = ""
G.TextButton_3.Parent = G.Frame_9

-- Frame_12 (Frame)
G.Frame_12 = Instance.new("Frame")
G.Frame_12.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.Frame_12.BackgroundTransparency = 0.15000000596046448
G.Frame_12.BorderSizePixel = 0
G.Frame_12.Parent = G.Frame_2

-- UICorner_11 (UICorner)
G.UICorner_11 = Instance.new("UICorner")
G.UICorner_11.CornerRadius = UDim.new(0, 10)
G.UICorner_11.Parent = G.Frame_12

-- UIStroke_8 (UIStroke)
G.UIStroke_8 = Instance.new("UIStroke")
G.UIStroke_8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_8.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_8.Transparency = 0.55000001192092896
G.UIStroke_8.Parent = G.Frame_12

-- TextLabel_4 (TextLabel)
G.TextLabel_4 = Instance.new("TextLabel")
G.TextLabel_4.BackgroundTransparency = 1
G.TextLabel_4.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_4.Size = UDim2.new(1, -40, 1, 0)
G.TextLabel_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_4.Text = "Slots ESP"
G.TextLabel_4.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_4.TextSize = 11
G.TextLabel_4.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_4.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_4.Parent = G.Frame_12

-- Frame_13 (Frame)
G.Frame_13 = Instance.new("Frame")
G.Frame_13.AnchorPoint = Vector2.new(1, 0.5)
G.Frame_13.BackgroundColor3 = Color3.fromRGB(188, 120, 255)
G.Frame_13.BackgroundTransparency = 0.15000000596046448
G.Frame_13.BorderSizePixel = 0
G.Frame_13.Position = UDim2.new(1, -6, 0.5, 0)
G.Frame_13.Size = UDim2.new(0, 32, 0, 18)
G.Frame_13.Parent = G.Frame_12

-- UICorner_12 (UICorner)
G.UICorner_12 = Instance.new("UICorner")
G.UICorner_12.CornerRadius = UDim.new(0, 9)
G.UICorner_12.Parent = G.Frame_13

-- UIStroke_9 (UIStroke)
G.UIStroke_9 = Instance.new("UIStroke")
G.UIStroke_9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_9.Color = Color3.fromRGB(188, 120, 255)
G.UIStroke_9.Transparency = 0.34999999403953552
G.UIStroke_9.Parent = G.Frame_13

-- Frame_14 (Frame)
G.Frame_14 = Instance.new("Frame")
G.Frame_14.AnchorPoint = Vector2.new(0, 0.5)
G.Frame_14.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Frame_14.BorderSizePixel = 0
G.Frame_14.Position = UDim2.new(0, 15, 0.5, 0)
G.Frame_14.Size = UDim2.new(0, 14, 0, 14)
G.Frame_14.Parent = G.Frame_13

-- UICorner_13 (UICorner)
G.UICorner_13 = Instance.new("UICorner")
G.UICorner_13.CornerRadius = UDim.new(0, 7)
G.UICorner_13.Parent = G.Frame_14

-- TextButton_4 (TextButton)
G.TextButton_4 = Instance.new("TextButton")
G.TextButton_4.BackgroundTransparency = 1
G.TextButton_4.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_4.ZIndex = 5
G.TextButton_4.Text = ""
G.TextButton_4.Parent = G.Frame_12

-- Frame_15 (Frame)
G.Frame_15 = Instance.new("Frame")
G.Frame_15.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.Frame_15.BackgroundTransparency = 0.15000000596046448
G.Frame_15.BorderSizePixel = 0
G.Frame_15.Parent = G.Frame_2

-- UICorner_14 (UICorner)
G.UICorner_14 = Instance.new("UICorner")
G.UICorner_14.CornerRadius = UDim.new(0, 10)
G.UICorner_14.Parent = G.Frame_15

-- UIStroke_10 (UIStroke)
G.UIStroke_10 = Instance.new("UIStroke")
G.UIStroke_10.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_10.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_10.Transparency = 0.55000001192092896
G.UIStroke_10.Parent = G.Frame_15

-- TextLabel_5 (TextLabel)
G.TextLabel_5 = Instance.new("TextLabel")
G.TextLabel_5.BackgroundTransparency = 1
G.TextLabel_5.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_5.Size = UDim2.new(1, -40, 1, 0)
G.TextLabel_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_5.Text = "Brainrot ESP"
G.TextLabel_5.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_5.TextSize = 11
G.TextLabel_5.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_5.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_5.Parent = G.Frame_15

-- Frame_16 (Frame)
G.Frame_16 = Instance.new("Frame")
G.Frame_16.AnchorPoint = Vector2.new(1, 0.5)
G.Frame_16.BackgroundColor3 = Color3.fromRGB(36, 16, 50)
G.Frame_16.BackgroundTransparency = 0.15000000596046448
G.Frame_16.BorderSizePixel = 0
G.Frame_16.Position = UDim2.new(1, -6, 0.5, 0)
G.Frame_16.Size = UDim2.new(0, 32, 0, 18)
G.Frame_16.Parent = G.Frame_15

-- UICorner_15 (UICorner)
G.UICorner_15 = Instance.new("UICorner")
G.UICorner_15.CornerRadius = UDim.new(0, 9)
G.UICorner_15.Parent = G.Frame_16

-- UIStroke_11 (UIStroke)
G.UIStroke_11 = Instance.new("UIStroke")
G.UIStroke_11.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_11.Color = Color3.fromRGB(188, 120, 255)
G.UIStroke_11.Transparency = 0.69999998807907104
G.UIStroke_11.Parent = G.Frame_16

-- Frame_17 (Frame)
G.Frame_17 = Instance.new("Frame")
G.Frame_17.AnchorPoint = Vector2.new(0, 0.5)
G.Frame_17.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Frame_17.BorderSizePixel = 0
G.Frame_17.Position = UDim2.new(0, 2, 0.5, 0)
G.Frame_17.Size = UDim2.new(0, 14, 0, 14)
G.Frame_17.Parent = G.Frame_16

-- UICorner_16 (UICorner)
G.UICorner_16 = Instance.new("UICorner")
G.UICorner_16.CornerRadius = UDim.new(0, 7)
G.UICorner_16.Parent = G.Frame_17

-- TextButton_5 (TextButton)
G.TextButton_5 = Instance.new("TextButton")
G.TextButton_5.BackgroundTransparency = 1
G.TextButton_5.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_5.ZIndex = 5
G.TextButton_5.Text = ""
G.TextButton_5.Parent = G.Frame_15

-- Frame_18 (Frame)
G.Frame_18 = Instance.new("Frame")
G.Frame_18.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.Frame_18.BackgroundTransparency = 0.15000000596046448
G.Frame_18.BorderSizePixel = 0
G.Frame_18.Parent = G.Frame_2

-- UICorner_17 (UICorner)
G.UICorner_17 = Instance.new("UICorner")
G.UICorner_17.CornerRadius = UDim.new(0, 10)
G.UICorner_17.Parent = G.Frame_18

-- UIStroke_12 (UIStroke)
G.UIStroke_12 = Instance.new("UIStroke")
G.UIStroke_12.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_12.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_12.Transparency = 0.55000001192092896
G.UIStroke_12.Parent = G.Frame_18

-- TextLabel_6 (TextLabel)
G.TextLabel_6 = Instance.new("TextLabel")
G.TextLabel_6.BackgroundTransparency = 1
G.TextLabel_6.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_6.Size = UDim2.new(1, -40, 1, 0)
G.TextLabel_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_6.Text = "Next Base"
G.TextLabel_6.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_6.TextSize = 11
G.TextLabel_6.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_6.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_6.Parent = G.Frame_18

-- Frame_19 (Frame)
G.Frame_19 = Instance.new("Frame")
G.Frame_19.AnchorPoint = Vector2.new(1, 0.5)
G.Frame_19.BackgroundColor3 = Color3.fromRGB(36, 16, 50)
G.Frame_19.BackgroundTransparency = 0.15000000596046448
G.Frame_19.BorderSizePixel = 0
G.Frame_19.Position = UDim2.new(1, -6, 0.5, 0)
G.Frame_19.Size = UDim2.new(0, 32, 0, 18)
G.Frame_19.Parent = G.Frame_18

-- UICorner_18 (UICorner)
G.UICorner_18 = Instance.new("UICorner")
G.UICorner_18.CornerRadius = UDim.new(0, 9)
G.UICorner_18.Parent = G.Frame_19

-- UIStroke_13 (UIStroke)
G.UIStroke_13 = Instance.new("UIStroke")
G.UIStroke_13.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_13.Color = Color3.fromRGB(188, 120, 255)
G.UIStroke_13.Transparency = 0.69999998807907104
G.UIStroke_13.Parent = G.Frame_19

-- Frame_20 (Frame)
G.Frame_20 = Instance.new("Frame")
G.Frame_20.AnchorPoint = Vector2.new(0, 0.5)
G.Frame_20.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Frame_20.BorderSizePixel = 0
G.Frame_20.Position = UDim2.new(0, 2, 0.5, 0)
G.Frame_20.Size = UDim2.new(0, 14, 0, 14)
G.Frame_20.Parent = G.Frame_19

-- UICorner_19 (UICorner)
G.UICorner_19 = Instance.new("UICorner")
G.UICorner_19.CornerRadius = UDim.new(0, 7)
G.UICorner_19.Parent = G.Frame_20

-- TextButton_6 (TextButton)
G.TextButton_6 = Instance.new("TextButton")
G.TextButton_6.BackgroundTransparency = 1
G.TextButton_6.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_6.ZIndex = 5
G.TextButton_6.Text = ""
G.TextButton_6.Parent = G.Frame_18

-- Frame_21 (Frame)
G.Frame_21 = Instance.new("Frame")
G.Frame_21.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.Frame_21.BackgroundTransparency = 0.15000000596046448
G.Frame_21.BorderSizePixel = 0
G.Frame_21.Parent = G.Frame_2

-- UICorner_20 (UICorner)
G.UICorner_20 = Instance.new("UICorner")
G.UICorner_20.CornerRadius = UDim.new(0, 10)
G.UICorner_20.Parent = G.Frame_21

-- UIStroke_14 (UIStroke)
G.UIStroke_14 = Instance.new("UIStroke")
G.UIStroke_14.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_14.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_14.Transparency = 0.55000001192092896
G.UIStroke_14.Parent = G.Frame_21

-- TextLabel_7 (TextLabel)
G.TextLabel_7 = Instance.new("TextLabel")
G.TextLabel_7.BackgroundTransparency = 1
G.TextLabel_7.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_7.Size = UDim2.new(1, -40, 1, 0)
G.TextLabel_7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_7.Text = "Auto Equip"
G.TextLabel_7.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_7.TextSize = 11
G.TextLabel_7.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_7.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_7.Parent = G.Frame_21

-- Frame_22 (Frame)
G.Frame_22 = Instance.new("Frame")
G.Frame_22.AnchorPoint = Vector2.new(1, 0.5)
G.Frame_22.BackgroundColor3 = Color3.fromRGB(36, 16, 50)
G.Frame_22.BackgroundTransparency = 0.15000000596046448
G.Frame_22.BorderSizePixel = 0
G.Frame_22.Position = UDim2.new(1, -6, 0.5, 0)
G.Frame_22.Size = UDim2.new(0, 32, 0, 18)
G.Frame_22.Parent = G.Frame_21

-- UICorner_21 (UICorner)
G.UICorner_21 = Instance.new("UICorner")
G.UICorner_21.CornerRadius = UDim.new(0, 9)
G.UICorner_21.Parent = G.Frame_22

-- UIStroke_15 (UIStroke)
G.UIStroke_15 = Instance.new("UIStroke")
G.UIStroke_15.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_15.Color = Color3.fromRGB(188, 120, 255)
G.UIStroke_15.Transparency = 0.69999998807907104
G.UIStroke_15.Parent = G.Frame_22

-- Frame_23 (Frame)
G.Frame_23 = Instance.new("Frame")
G.Frame_23.AnchorPoint = Vector2.new(0, 0.5)
G.Frame_23.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Frame_23.BorderSizePixel = 0
G.Frame_23.Position = UDim2.new(0, 2, 0.5, 0)
G.Frame_23.Size = UDim2.new(0, 14, 0, 14)
G.Frame_23.Parent = G.Frame_22

-- UICorner_22 (UICorner)
G.UICorner_22 = Instance.new("UICorner")
G.UICorner_22.CornerRadius = UDim.new(0, 7)
G.UICorner_22.Parent = G.Frame_23

-- TextButton_7 (TextButton)
G.TextButton_7 = Instance.new("TextButton")
G.TextButton_7.BackgroundTransparency = 1
G.TextButton_7.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_7.ZIndex = 5
G.TextButton_7.Text = ""
G.TextButton_7.Parent = G.Frame_21

-- Frame_24 (Frame)
G.Frame_24 = Instance.new("Frame")
G.Frame_24.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.Frame_24.BackgroundTransparency = 0.15000000596046448
G.Frame_24.BorderSizePixel = 0
G.Frame_24.Parent = G.Frame_2

-- UICorner_23 (UICorner)
G.UICorner_23 = Instance.new("UICorner")
G.UICorner_23.CornerRadius = UDim.new(0, 10)
G.UICorner_23.Parent = G.Frame_24

-- UIStroke_16 (UIStroke)
G.UIStroke_16 = Instance.new("UIStroke")
G.UIStroke_16.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_16.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_16.Transparency = 0.55000001192092896
G.UIStroke_16.Parent = G.Frame_24

-- TextLabel_8 (TextLabel)
G.TextLabel_8 = Instance.new("TextLabel")
G.TextLabel_8.BackgroundTransparency = 1
G.TextLabel_8.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_8.Size = UDim2.new(1, -40, 1, 0)
G.TextLabel_8.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_8.Text = "Carpet Speed"
G.TextLabel_8.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_8.TextSize = 11
G.TextLabel_8.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_8.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_8.Parent = G.Frame_24

-- Frame_25 (Frame)
G.Frame_25 = Instance.new("Frame")
G.Frame_25.AnchorPoint = Vector2.new(1, 0.5)
G.Frame_25.BackgroundColor3 = Color3.fromRGB(36, 16, 50)
G.Frame_25.BackgroundTransparency = 0.15000000596046448
G.Frame_25.BorderSizePixel = 0
G.Frame_25.Position = UDim2.new(1, -6, 0.5, 0)
G.Frame_25.Size = UDim2.new(0, 32, 0, 18)
G.Frame_25.Parent = G.Frame_24

-- UICorner_24 (UICorner)
G.UICorner_24 = Instance.new("UICorner")
G.UICorner_24.CornerRadius = UDim.new(0, 9)
G.UICorner_24.Parent = G.Frame_25

-- UIStroke_17 (UIStroke)
G.UIStroke_17 = Instance.new("UIStroke")
G.UIStroke_17.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_17.Color = Color3.fromRGB(188, 120, 255)
G.UIStroke_17.Transparency = 0.69999998807907104
G.UIStroke_17.Parent = G.Frame_25

-- Frame_26 (Frame)
G.Frame_26 = Instance.new("Frame")
G.Frame_26.AnchorPoint = Vector2.new(0, 0.5)
G.Frame_26.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Frame_26.BorderSizePixel = 0
G.Frame_26.Position = UDim2.new(0, 2, 0.5, 0)
G.Frame_26.Size = UDim2.new(0, 14, 0, 14)
G.Frame_26.Parent = G.Frame_25

-- UICorner_25 (UICorner)
G.UICorner_25 = Instance.new("UICorner")
G.UICorner_25.CornerRadius = UDim.new(0, 7)
G.UICorner_25.Parent = G.Frame_26

-- TextButton_8 (TextButton)
G.TextButton_8 = Instance.new("TextButton")
G.TextButton_8.BackgroundTransparency = 1
G.TextButton_8.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_8.ZIndex = 5
G.TextButton_8.Text = ""
G.TextButton_8.Parent = G.Frame_24

-- Frame_27 (Frame)
G.Frame_27 = Instance.new("Frame")
G.Frame_27.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.Frame_27.BackgroundTransparency = 0.15000000596046448
G.Frame_27.BorderSizePixel = 0
G.Frame_27.Parent = G.Frame_2

-- UICorner_26 (UICorner)
G.UICorner_26 = Instance.new("UICorner")
G.UICorner_26.CornerRadius = UDim.new(0, 10)
G.UICorner_26.Parent = G.Frame_27

-- UIStroke_18 (UIStroke)
G.UIStroke_18 = Instance.new("UIStroke")
G.UIStroke_18.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_18.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_18.Transparency = 0.55000001192092896
G.UIStroke_18.Parent = G.Frame_27

-- TextLabel_9 (TextLabel)
G.TextLabel_9 = Instance.new("TextLabel")
G.TextLabel_9.BackgroundTransparency = 1
G.TextLabel_9.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_9.Size = UDim2.new(1, -40, 1, 0)
G.TextLabel_9.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_9.Text = "Aimbot"
G.TextLabel_9.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_9.TextSize = 11
G.TextLabel_9.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_9.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_9.Parent = G.Frame_27

-- Frame_28 (Frame)
G.Frame_28 = Instance.new("Frame")
G.Frame_28.AnchorPoint = Vector2.new(1, 0.5)
G.Frame_28.BackgroundColor3 = Color3.fromRGB(36, 16, 50)
G.Frame_28.BackgroundTransparency = 0.15000000596046448
G.Frame_28.BorderSizePixel = 0
G.Frame_28.Position = UDim2.new(1, -6, 0.5, 0)
G.Frame_28.Size = UDim2.new(0, 32, 0, 18)
G.Frame_28.Parent = G.Frame_27

-- UICorner_27 (UICorner)
G.UICorner_27 = Instance.new("UICorner")
G.UICorner_27.CornerRadius = UDim.new(0, 9)
G.UICorner_27.Parent = G.Frame_28

-- UIStroke_19 (UIStroke)
G.UIStroke_19 = Instance.new("UIStroke")
G.UIStroke_19.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_19.Color = Color3.fromRGB(188, 120, 255)
G.UIStroke_19.Transparency = 0.69999998807907104
G.UIStroke_19.Parent = G.Frame_28

-- Frame_29 (Frame)
G.Frame_29 = Instance.new("Frame")
G.Frame_29.AnchorPoint = Vector2.new(0, 0.5)
G.Frame_29.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Frame_29.BorderSizePixel = 0
G.Frame_29.Position = UDim2.new(0, 2, 0.5, 0)
G.Frame_29.Size = UDim2.new(0, 14, 0, 14)
G.Frame_29.Parent = G.Frame_28

-- UICorner_28 (UICorner)
G.UICorner_28 = Instance.new("UICorner")
G.UICorner_28.CornerRadius = UDim.new(0, 7)
G.UICorner_28.Parent = G.Frame_29

-- TextButton_9 (TextButton)
G.TextButton_9 = Instance.new("TextButton")
G.TextButton_9.BackgroundTransparency = 1
G.TextButton_9.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_9.ZIndex = 5
G.TextButton_9.Text = ""
G.TextButton_9.Parent = G.Frame_27

-- Frame_30 (Frame)
G.Frame_30 = Instance.new("Frame")
G.Frame_30.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.Frame_30.BackgroundTransparency = 0.15000000596046448
G.Frame_30.BorderSizePixel = 0
G.Frame_30.Parent = G.Frame_2

-- UICorner_29 (UICorner)
G.UICorner_29 = Instance.new("UICorner")
G.UICorner_29.CornerRadius = UDim.new(0, 10)
G.UICorner_29.Parent = G.Frame_30

-- UIStroke_20 (UIStroke)
G.UIStroke_20 = Instance.new("UIStroke")
G.UIStroke_20.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_20.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_20.Transparency = 0.55000001192092896
G.UIStroke_20.Parent = G.Frame_30

-- TextLabel_10 (TextLabel)
G.TextLabel_10 = Instance.new("TextLabel")
G.TextLabel_10.BackgroundTransparency = 1
G.TextLabel_10.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_10.Size = UDim2.new(1, -40, 1, 0)
G.TextLabel_10.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_10.Text = "Auto Kick"
G.TextLabel_10.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_10.TextSize = 11
G.TextLabel_10.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_10.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_10.Parent = G.Frame_30

-- Frame_31 (Frame)
G.Frame_31 = Instance.new("Frame")
G.Frame_31.AnchorPoint = Vector2.new(1, 0.5)
G.Frame_31.BackgroundColor3 = Color3.fromRGB(36, 16, 50)
G.Frame_31.BackgroundTransparency = 0.15000000596046448
G.Frame_31.BorderSizePixel = 0
G.Frame_31.Position = UDim2.new(1, -6, 0.5, 0)
G.Frame_31.Size = UDim2.new(0, 32, 0, 18)
G.Frame_31.Parent = G.Frame_30

-- UICorner_30 (UICorner)
G.UICorner_30 = Instance.new("UICorner")
G.UICorner_30.CornerRadius = UDim.new(0, 9)
G.UICorner_30.Parent = G.Frame_31

-- UIStroke_21 (UIStroke)
G.UIStroke_21 = Instance.new("UIStroke")
G.UIStroke_21.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_21.Color = Color3.fromRGB(188, 120, 255)
G.UIStroke_21.Transparency = 0.69999998807907104
G.UIStroke_21.Parent = G.Frame_31

-- Frame_32 (Frame)
G.Frame_32 = Instance.new("Frame")
G.Frame_32.AnchorPoint = Vector2.new(0, 0.5)
G.Frame_32.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Frame_32.BorderSizePixel = 0
G.Frame_32.Position = UDim2.new(0, 2, 0.5, 0)
G.Frame_32.Size = UDim2.new(0, 14, 0, 14)
G.Frame_32.Parent = G.Frame_31

-- UICorner_31 (UICorner)
G.UICorner_31 = Instance.new("UICorner")
G.UICorner_31.CornerRadius = UDim.new(0, 7)
G.UICorner_31.Parent = G.Frame_32

-- TextButton_10 (TextButton)
G.TextButton_10 = Instance.new("TextButton")
G.TextButton_10.BackgroundTransparency = 1
G.TextButton_10.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_10.ZIndex = 5
G.TextButton_10.Text = ""
G.TextButton_10.Parent = G.Frame_30

-- Frame_33 (Frame)
G.Frame_33 = Instance.new("Frame")
G.Frame_33.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.Frame_33.BackgroundTransparency = 0.15000000596046448
G.Frame_33.BorderSizePixel = 0
G.Frame_33.Parent = G.Frame_2

-- UICorner_32 (UICorner)
G.UICorner_32 = Instance.new("UICorner")
G.UICorner_32.CornerRadius = UDim.new(0, 10)
G.UICorner_32.Parent = G.Frame_33

-- UIStroke_22 (UIStroke)
G.UIStroke_22 = Instance.new("UIStroke")
G.UIStroke_22.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_22.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_22.Transparency = 0.55000001192092896
G.UIStroke_22.Parent = G.Frame_33

-- TextLabel_11 (TextLabel)
G.TextLabel_11 = Instance.new("TextLabel")
G.TextLabel_11.BackgroundTransparency = 1
G.TextLabel_11.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_11.Size = UDim2.new(1, -40, 1, 0)
G.TextLabel_11.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_11.Text = "Steal Boost"
G.TextLabel_11.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_11.TextSize = 11
G.TextLabel_11.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_11.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_11.Parent = G.Frame_33

-- Frame_34 (Frame)
G.Frame_34 = Instance.new("Frame")
G.Frame_34.AnchorPoint = Vector2.new(1, 0.5)
G.Frame_34.BackgroundColor3 = Color3.fromRGB(188, 120, 255)
G.Frame_34.BackgroundTransparency = 0.15000000596046448
G.Frame_34.BorderSizePixel = 0
G.Frame_34.Position = UDim2.new(1, -6, 0.5, 0)
G.Frame_34.Size = UDim2.new(0, 32, 0, 18)
G.Frame_34.Parent = G.Frame_33

-- UICorner_33 (UICorner)
G.UICorner_33 = Instance.new("UICorner")
G.UICorner_33.CornerRadius = UDim.new(0, 9)
G.UICorner_33.Parent = G.Frame_34

-- UIStroke_23 (UIStroke)
G.UIStroke_23 = Instance.new("UIStroke")
G.UIStroke_23.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_23.Color = Color3.fromRGB(188, 120, 255)
G.UIStroke_23.Transparency = 0.34999999403953552
G.UIStroke_23.Parent = G.Frame_34

-- Frame_35 (Frame)
G.Frame_35 = Instance.new("Frame")
G.Frame_35.AnchorPoint = Vector2.new(0, 0.5)
G.Frame_35.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Frame_35.BorderSizePixel = 0
G.Frame_35.Position = UDim2.new(0, 15, 0.5, 0)
G.Frame_35.Size = UDim2.new(0, 14, 0, 14)
G.Frame_35.Parent = G.Frame_34

-- UICorner_34 (UICorner)
G.UICorner_34 = Instance.new("UICorner")
G.UICorner_34.CornerRadius = UDim.new(0, 7)
G.UICorner_34.Parent = G.Frame_35

-- TextButton_11 (TextButton)
G.TextButton_11 = Instance.new("TextButton")
G.TextButton_11.BackgroundTransparency = 1
G.TextButton_11.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_11.ZIndex = 5
G.TextButton_11.Text = ""
G.TextButton_11.Parent = G.Frame_33

-- TextButton_12 (TextButton)
G.TextButton_12 = Instance.new("TextButton")
G.TextButton_12.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.TextButton_12.BackgroundTransparency = 0.2800000011920929
G.TextButton_12.Size = UDim2.new(1, 0, 0, 32)
G.TextButton_12.AutoButtonColor = false
G.TextButton_12.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_12.Text = "Binds"
G.TextButton_12.TextColor3 = Color3.fromRGB(224, 193, 255)
G.TextButton_12.TextSize = 12
G.TextButton_12.Parent = G.Holder

-- UICorner_35 (UICorner)
G.UICorner_35 = Instance.new("UICorner")
G.UICorner_35.CornerRadius = UDim.new(0, 10)
G.UICorner_35.Parent = G.TextButton_12

-- UIStroke_24 (UIStroke)
G.UIStroke_24 = Instance.new("UIStroke")
G.UIStroke_24.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_24.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_24.Transparency = 0.44999998807907104
G.UIStroke_24.Parent = G.TextButton_12

-- UIScale_2 (UIScale)
G.UIScale_2 = Instance.new("UIScale")
G.UIScale_2.Parent = G.TextButton_12

-- ServerJobID (Frame)
G.ServerJobID = Instance.new("Frame")
G.ServerJobID.Name = "ServerJobID"
G.ServerJobID.AutomaticSize = Enum.AutomaticSize.Y
G.ServerJobID.BackgroundColor3 = Color3.fromRGB(42, 17, 69)
G.ServerJobID.BackgroundTransparency = 0.2800000011920929
G.ServerJobID.BorderSizePixel = 0
G.ServerJobID.Position = UDim2.new(0, 334, 0, 185)
G.ServerJobID.Size = UDim2.new(0, 300, 0, 0)
G.ServerJobID.ZIndex = 2
G.ServerJobID.Parent = G.AspectUnifiedMenu

-- UICorner_36 (UICorner)
G.UICorner_36 = Instance.new("UICorner")
G.UICorner_36.CornerRadius = UDim.new(0, 14)
G.UICorner_36.Parent = G.ServerJobID

-- UIGradient_3 (UIGradient)
G.UIGradient_3 = Instance.new("UIGradient")
G.UIGradient_3.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(23, 9, 39)), ColorSequenceKeypoint.new(0.25, Color3.fromRGB(41, 16, 67)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(61, 24, 95)), ColorSequenceKeypoint.new(0.75, Color3.fromRGB(80, 34, 122)), ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 7, 30))})
G.UIGradient_3.Rotation = 135
G.UIGradient_3.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.059999998658895493, 0), NumberSequenceKeypoint.new(0.5, 0.10000000149011612, 0), NumberSequenceKeypoint.new(1, 0.059999998658895493, 0)})
G.UIGradient_3.Parent = G.ServerJobID

-- UIStroke_25 (UIStroke)
G.UIStroke_25 = Instance.new("UIStroke")
G.UIStroke_25.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_25.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_25.Thickness = 1.3999999761581421
G.UIStroke_25.Transparency = 0.18000000715255737
G.UIStroke_25.Parent = G.ServerJobID

-- UIGradient_4 (UIGradient)
G.UIGradient_4 = Instance.new("UIGradient")
G.UIGradient_4.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(129, 65, 181)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(186, 117, 245)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 47, 149))})
G.UIGradient_4.Rotation = 90
G.UIGradient_4.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.44999998807907104, 0), NumberSequenceKeypoint.new(0.5, 0.2199999988079071, 0), NumberSequenceKeypoint.new(1, 0.41999998688697815, 0)})
G.UIGradient_4.Parent = G.UIStroke_25

-- Shadow_2 (ImageLabel)
G.Shadow_2 = Instance.new("ImageLabel")
G.Shadow_2.Name = "Shadow"
G.Shadow_2.AnchorPoint = Vector2.new(0.5, 0.5)
G.Shadow_2.BackgroundTransparency = 1
G.Shadow_2.Position = UDim2.new(0.5, 0, 0.5, 4)
G.Shadow_2.Size = UDim2.new(1, 40, 1, 40)
G.Shadow_2.ZIndex = 0
G.Shadow_2.Image = "rbxassetid://6014261993"
G.Shadow_2.ImageColor3 = Color3.fromRGB(11, 4, 19)
G.Shadow_2.ImageTransparency = 0.25
G.Shadow_2.ScaleType = Enum.ScaleType.Slice
G.Shadow_2.SliceCenter = Rect.new(49, 49, 450, 450)
G.Shadow_2.Parent = G.ServerJobID

-- Header_2 (Frame)
G.Header_2 = Instance.new("Frame")
G.Header_2.Name = "Header"
G.Header_2.Active = true
G.Header_2.BackgroundTransparency = 1
G.Header_2.BorderSizePixel = 0
G.Header_2.Size = UDim2.new(1, 0, 0, 40)
G.Header_2.ZIndex = 10
G.Header_2.Parent = G.ServerJobID

-- TitleText_2 (TextLabel)
G.TitleText_2 = Instance.new("TextLabel")
G.TitleText_2.Name = "TitleText"
G.TitleText_2.BackgroundTransparency = 1
G.TitleText_2.Position = UDim2.new(0, 14, 0, 0)
G.TitleText_2.Size = UDim2.new(1, -28, 1, 0)
G.TitleText_2.ZIndex = 11
G.TitleText_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TitleText_2.Text = "Server Job ID"
G.TitleText_2.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TitleText_2.TextSize = 14
G.TitleText_2.TextXAlignment = Enum.TextXAlignment.Left
G.TitleText_2.Parent = G.Header_2

-- Frame_36 (Frame)
G.Frame_36 = Instance.new("Frame")
G.Frame_36.BackgroundColor3 = Color3.fromRGB(188, 120, 255)
G.Frame_36.BackgroundTransparency = 0.55000001192092896
G.Frame_36.BorderSizePixel = 0
G.Frame_36.Position = UDim2.new(0, 14, 1, -1)
G.Frame_36.Size = UDim2.new(1, -28, 0, 1)
G.Frame_36.ZIndex = 11
G.Frame_36.Parent = G.Header_2

-- Holder_2 (Frame)
G.Holder_2 = Instance.new("Frame")
G.Holder_2.Name = "Holder"
G.Holder_2.AutomaticSize = Enum.AutomaticSize.Y
G.Holder_2.BackgroundTransparency = 1
G.Holder_2.Position = UDim2.new(0, 10, 0, 44)
G.Holder_2.Size = UDim2.new(1, -20, 0, 0)
G.Holder_2.ZIndex = 2
G.Holder_2.Parent = G.ServerJobID

-- UIListLayout_2 (UIListLayout)
G.UIListLayout_2 = Instance.new("UIListLayout")
G.UIListLayout_2.Padding = UDim.new(0, 6)
G.UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_2.Parent = G.Holder_2

-- UIPadding_2 (UIPadding)
G.UIPadding_2 = Instance.new("UIPadding")
G.UIPadding_2.PaddingBottom = UDim.new(0, 12)
G.UIPadding_2.Parent = G.Holder_2

-- Frame_37 (Frame)
G.Frame_37 = Instance.new("Frame")
G.Frame_37.BackgroundColor3 = Color3.fromRGB(55, 20, 73)
G.Frame_37.BorderSizePixel = 0
G.Frame_37.Size = UDim2.new(1, 0, 0, 36)
G.Frame_37.Parent = G.Holder_2

-- UICorner_37 (UICorner)
G.UICorner_37 = Instance.new("UICorner")
G.UICorner_37.CornerRadius = UDim.new(0, 9)
G.UICorner_37.Parent = G.Frame_37

-- UIStroke_26 (UIStroke)
G.UIStroke_26 = Instance.new("UIStroke")
G.UIStroke_26.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_26.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_26.Transparency = 0.55000001192092896
G.UIStroke_26.Parent = G.Frame_37

-- TextLabel_12 (TextLabel)
G.TextLabel_12 = Instance.new("TextLabel")
G.TextLabel_12.BackgroundTransparency = 1
G.TextLabel_12.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_12.Size = UDim2.new(1, -16, 1, 0)
G.TextLabel_12.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_12.Text = "••••••••••••••••••••••••••••••••••••"
G.TextLabel_12.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_12.TextSize = 11
G.TextLabel_12.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_12.Parent = G.Frame_37

-- Frame_38 (Frame)
G.Frame_38 = Instance.new("Frame")
G.Frame_38.BackgroundTransparency = 1
G.Frame_38.Size = UDim2.new(1, 0, 0, 32)
G.Frame_38.Parent = G.Holder_2

-- TextButton_13 (TextButton)
G.TextButton_13 = Instance.new("TextButton")
G.TextButton_13.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.TextButton_13.BackgroundTransparency = 0.2800000011920929
G.TextButton_13.Size = UDim2.new(0.5, -3, 1, 0)
G.TextButton_13.AutoButtonColor = false
G.TextButton_13.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_13.Text = "Copy"
G.TextButton_13.TextColor3 = Color3.fromRGB(224, 193, 255)
G.TextButton_13.TextSize = 12
G.TextButton_13.Parent = G.Frame_38

-- UICorner_38 (UICorner)
G.UICorner_38 = Instance.new("UICorner")
G.UICorner_38.CornerRadius = UDim.new(0, 10)
G.UICorner_38.Parent = G.TextButton_13

-- UIStroke_27 (UIStroke)
G.UIStroke_27 = Instance.new("UIStroke")
G.UIStroke_27.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_27.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_27.Transparency = 0.44999998807907104
G.UIStroke_27.Parent = G.TextButton_13

-- UIScale_3 (UIScale)
G.UIScale_3 = Instance.new("UIScale")
G.UIScale_3.Parent = G.TextButton_13

-- TextButton_14 (TextButton)
G.TextButton_14 = Instance.new("TextButton")
G.TextButton_14.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.TextButton_14.BackgroundTransparency = 0.2800000011920929
G.TextButton_14.Position = UDim2.new(0.5, 3, 0, 0)
G.TextButton_14.Size = UDim2.new(0.5, -3, 1, 0)
G.TextButton_14.AutoButtonColor = false
G.TextButton_14.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_14.Text = "Show"
G.TextButton_14.TextColor3 = Color3.fromRGB(224, 193, 255)
G.TextButton_14.TextSize = 12
G.TextButton_14.Parent = G.Frame_38

-- UICorner_39 (UICorner)
G.UICorner_39 = Instance.new("UICorner")
G.UICorner_39.CornerRadius = UDim.new(0, 10)
G.UICorner_39.Parent = G.TextButton_14

-- UIStroke_28 (UIStroke)
G.UIStroke_28 = Instance.new("UIStroke")
G.UIStroke_28.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_28.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_28.Transparency = 0.44999998807907104
G.UIStroke_28.Parent = G.TextButton_14

-- UIScale_4 (UIScale)
G.UIScale_4 = Instance.new("UIScale")
G.UIScale_4.Parent = G.TextButton_14

-- TextButton_15 (TextButton)
G.TextButton_15 = Instance.new("TextButton")
G.TextButton_15.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.TextButton_15.BackgroundTransparency = 0.2800000011920929
G.TextButton_15.Size = UDim2.new(1, 0, 0, 32)
G.TextButton_15.AutoButtonColor = false
G.TextButton_15.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_15.Text = "Empty Server Finder"
G.TextButton_15.TextColor3 = Color3.fromRGB(224, 193, 255)
G.TextButton_15.TextSize = 12
G.TextButton_15.Parent = G.Holder_2

-- UICorner_40 (UICorner)
G.UICorner_40 = Instance.new("UICorner")
G.UICorner_40.CornerRadius = UDim.new(0, 10)
G.UICorner_40.Parent = G.TextButton_15

-- UIStroke_29 (UIStroke)
G.UIStroke_29 = Instance.new("UIStroke")
G.UIStroke_29.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_29.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_29.Transparency = 0.44999998807907104
G.UIStroke_29.Parent = G.TextButton_15

-- UIScale_5 (UIScale)
G.UIScale_5 = Instance.new("UIScale")
G.UIScale_5.Parent = G.TextButton_15

-- EmptyServerFinderInline (Frame)
G.EmptyServerFinderInline = Instance.new("Frame")
G.EmptyServerFinderInline.Name = "EmptyServerFinderInline"
G.EmptyServerFinderInline.BackgroundColor3 = Color3.fromRGB(55, 20, 73)
G.EmptyServerFinderInline.BorderSizePixel = 0
G.EmptyServerFinderInline.ClipsDescendants = true
G.EmptyServerFinderInline.Size = UDim2.new(1, 0, 0, 1)
G.EmptyServerFinderInline.ZIndex = 10
G.EmptyServerFinderInline.Parent = G.Holder_2

-- UICorner_41 (UICorner)
G.UICorner_41 = Instance.new("UICorner")
G.UICorner_41.Parent = G.EmptyServerFinderInline

-- UIStroke_30 (UIStroke)
G.UIStroke_30 = Instance.new("UIStroke")
G.UIStroke_30.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_30.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_30.Transparency = 0.5
G.UIStroke_30.Parent = G.EmptyServerFinderInline

-- TextLabel_13 (TextLabel)
G.TextLabel_13 = Instance.new("TextLabel")
G.TextLabel_13.BackgroundTransparency = 1
G.TextLabel_13.Position = UDim2.new(0, 8, 0, 9)
G.TextLabel_13.Size = UDim2.new(1, -16, 0, 20)
G.TextLabel_13.ZIndex = 11
G.TextLabel_13.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_13.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_13.TextSize = 12
G.TextLabel_13.Parent = G.EmptyServerFinderInline

-- TextLabel_14 (TextLabel)
G.TextLabel_14 = Instance.new("TextLabel")
G.TextLabel_14.BackgroundTransparency = 1
G.TextLabel_14.Position = UDim2.new(0, 10, 0, 30)
G.TextLabel_14.Size = UDim2.new(1, -20, 0, 24)
G.TextLabel_14.ZIndex = 11
G.TextLabel_14.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_14.TextColor3 = Color3.fromRGB(224, 193, 255)
G.TextLabel_14.TextSize = 10
G.TextLabel_14.TextWrapped = true
G.TextLabel_14.Parent = G.EmptyServerFinderInline

-- TextButton_16 (TextButton)
G.TextButton_16 = Instance.new("TextButton")
G.TextButton_16.BackgroundColor3 = Color3.fromRGB(188, 120, 255)
G.TextButton_16.Position = UDim2.new(0, 10, 0, 58)
G.TextButton_16.Size = UDim2.new(0.5, -15, 0, 32)
G.TextButton_16.ZIndex = 11
G.TextButton_16.AutoButtonColor = false
G.TextButton_16.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_16.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextButton_16.TextSize = 11
G.TextButton_16.Parent = G.EmptyServerFinderInline

-- UICorner_42 (UICorner)
G.UICorner_42 = Instance.new("UICorner")
G.UICorner_42.CornerRadius = UDim.new(0, 9)
G.UICorner_42.Parent = G.TextButton_16

-- TextButton_17 (TextButton)
G.TextButton_17 = Instance.new("TextButton")
G.TextButton_17.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.TextButton_17.Position = UDim2.new(0.5, 5, 0, 58)
G.TextButton_17.Size = UDim2.new(0.5, -15, 0, 32)
G.TextButton_17.ZIndex = 11
G.TextButton_17.AutoButtonColor = false
G.TextButton_17.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_17.TextColor3 = Color3.fromRGB(224, 193, 255)
G.TextButton_17.TextSize = 11
G.TextButton_17.Parent = G.EmptyServerFinderInline

-- UICorner_43 (UICorner)
G.UICorner_43 = Instance.new("UICorner")
G.UICorner_43.CornerRadius = UDim.new(0, 9)
G.UICorner_43.Parent = G.TextButton_17

-- Helper (Frame)
G.Helper = Instance.new("Frame")
G.Helper.Name = "Helper"
G.Helper.AutomaticSize = Enum.AutomaticSize.Y
G.Helper.BackgroundColor3 = Color3.fromRGB(42, 17, 69)
G.Helper.BackgroundTransparency = 0.2800000011920929
G.Helper.BorderSizePixel = 0
G.Helper.Position = UDim2.new(0, 10, 0, 560)
G.Helper.Size = UDim2.new(0, 240, 0, 0)
G.Helper.ZIndex = 2
G.Helper.Parent = G.AspectUnifiedMenu

-- UICorner_44 (UICorner)
G.UICorner_44 = Instance.new("UICorner")
G.UICorner_44.CornerRadius = UDim.new(0, 14)
G.UICorner_44.Parent = G.Helper

-- UIGradient_5 (UIGradient)
G.UIGradient_5 = Instance.new("UIGradient")
G.UIGradient_5.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(23, 9, 39)), ColorSequenceKeypoint.new(0.25, Color3.fromRGB(41, 16, 67)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(61, 24, 95)), ColorSequenceKeypoint.new(0.75, Color3.fromRGB(80, 34, 122)), ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 7, 30))})
G.UIGradient_5.Rotation = 135
G.UIGradient_5.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.059999998658895493, 0), NumberSequenceKeypoint.new(0.5, 0.10000000149011612, 0), NumberSequenceKeypoint.new(1, 0.059999998658895493, 0)})
G.UIGradient_5.Parent = G.Helper

-- UIStroke_31 (UIStroke)
G.UIStroke_31 = Instance.new("UIStroke")
G.UIStroke_31.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_31.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_31.Thickness = 1.3999999761581421
G.UIStroke_31.Transparency = 0.18000000715255737
G.UIStroke_31.Parent = G.Helper

-- UIGradient_6 (UIGradient)
G.UIGradient_6 = Instance.new("UIGradient")
G.UIGradient_6.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(129, 65, 181)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(186, 117, 245)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 47, 149))})
G.UIGradient_6.Rotation = 90
G.UIGradient_6.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.44999998807907104, 0), NumberSequenceKeypoint.new(0.5, 0.2199999988079071, 0), NumberSequenceKeypoint.new(1, 0.41999998688697815, 0)})
G.UIGradient_6.Parent = G.UIStroke_31

-- Shadow_3 (ImageLabel)
G.Shadow_3 = Instance.new("ImageLabel")
G.Shadow_3.Name = "Shadow"
G.Shadow_3.AnchorPoint = Vector2.new(0.5, 0.5)
G.Shadow_3.BackgroundTransparency = 1
G.Shadow_3.Position = UDim2.new(0.5, 0, 0.5, 4)
G.Shadow_3.Size = UDim2.new(1, 40, 1, 40)
G.Shadow_3.ZIndex = 0
G.Shadow_3.Image = "rbxassetid://6014261993"
G.Shadow_3.ImageColor3 = Color3.fromRGB(11, 4, 19)
G.Shadow_3.ImageTransparency = 0.25
G.Shadow_3.ScaleType = Enum.ScaleType.Slice
G.Shadow_3.SliceCenter = Rect.new(49, 49, 450, 450)
G.Shadow_3.Parent = G.Helper

-- Header_3 (Frame)
G.Header_3 = Instance.new("Frame")
G.Header_3.Name = "Header"
G.Header_3.Active = true
G.Header_3.BackgroundTransparency = 1
G.Header_3.BorderSizePixel = 0
G.Header_3.Size = UDim2.new(1, 0, 0, 40)
G.Header_3.ZIndex = 10
G.Header_3.Parent = G.Helper

-- TitleText_3 (TextLabel)
G.TitleText_3 = Instance.new("TextLabel")
G.TitleText_3.Name = "TitleText"
G.TitleText_3.BackgroundTransparency = 1
G.TitleText_3.Position = UDim2.new(0, 14, 0, 0)
G.TitleText_3.Size = UDim2.new(1, -28, 1, 0)
G.TitleText_3.ZIndex = 11
G.TitleText_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TitleText_3.Text = "Helper"
G.TitleText_3.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TitleText_3.TextSize = 14
G.TitleText_3.TextXAlignment = Enum.TextXAlignment.Left
G.TitleText_3.Parent = G.Header_3

-- Frame_39 (Frame)
G.Frame_39 = Instance.new("Frame")
G.Frame_39.BackgroundColor3 = Color3.fromRGB(188, 120, 255)
G.Frame_39.BackgroundTransparency = 0.55000001192092896
G.Frame_39.BorderSizePixel = 0
G.Frame_39.Position = UDim2.new(0, 14, 1, -1)
G.Frame_39.Size = UDim2.new(1, -28, 0, 1)
G.Frame_39.ZIndex = 11
G.Frame_39.Parent = G.Header_3

-- Holder_3 (Frame)
G.Holder_3 = Instance.new("Frame")
G.Holder_3.Name = "Holder"
G.Holder_3.AutomaticSize = Enum.AutomaticSize.Y
G.Holder_3.BackgroundTransparency = 1
G.Holder_3.Position = UDim2.new(0, 10, 0, 44)
G.Holder_3.Size = UDim2.new(1, -20, 0, 0)
G.Holder_3.ZIndex = 2
G.Holder_3.Parent = G.Helper

-- UIListLayout_3 (UIListLayout)
G.UIListLayout_3 = Instance.new("UIListLayout")
G.UIListLayout_3.Padding = UDim.new(0, 6)
G.UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_3.Parent = G.Holder_3

-- UIPadding_3 (UIPadding)
G.UIPadding_3 = Instance.new("UIPadding")
G.UIPadding_3.PaddingBottom = UDim.new(0, 12)
G.UIPadding_3.Parent = G.Holder_3

-- Frame_40 (Frame)
G.Frame_40 = Instance.new("Frame")
G.Frame_40.BackgroundTransparency = 1
G.Frame_40.Size = UDim2.new(1, 0, 0, 34)
G.Frame_40.Parent = G.Holder_3

-- TextButton_18 (TextButton)
G.TextButton_18 = Instance.new("TextButton")
G.TextButton_18.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.TextButton_18.BackgroundTransparency = 0.2800000011920929
G.TextButton_18.Size = UDim2.new(0.5, -3, 1, 0)
G.TextButton_18.AutoButtonColor = false
G.TextButton_18.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_18.Text = "Instant Reset"
G.TextButton_18.TextColor3 = Color3.fromRGB(224, 193, 255)
G.TextButton_18.TextSize = 12
G.TextButton_18.Parent = G.Frame_40

-- UICorner_45 (UICorner)
G.UICorner_45 = Instance.new("UICorner")
G.UICorner_45.CornerRadius = UDim.new(0, 10)
G.UICorner_45.Parent = G.TextButton_18

-- UIStroke_32 (UIStroke)
G.UIStroke_32 = Instance.new("UIStroke")
G.UIStroke_32.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_32.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_32.Transparency = 0.44999998807907104
G.UIStroke_32.Parent = G.TextButton_18

-- UIScale_6 (UIScale)
G.UIScale_6 = Instance.new("UIScale")
G.UIScale_6.Parent = G.TextButton_18

-- TextButton_19 (TextButton)
G.TextButton_19 = Instance.new("TextButton")
G.TextButton_19.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.TextButton_19.BackgroundTransparency = 0.2800000011920929
G.TextButton_19.Position = UDim2.new(0.5, 3, 0, 0)
G.TextButton_19.Size = UDim2.new(0.5, -3, 1, 0)
G.TextButton_19.AutoButtonColor = false
G.TextButton_19.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_19.Text = "Drop"
G.TextButton_19.TextColor3 = Color3.fromRGB(224, 193, 255)
G.TextButton_19.TextSize = 12
G.TextButton_19.Parent = G.Frame_40

-- UICorner_46 (UICorner)
G.UICorner_46 = Instance.new("UICorner")
G.UICorner_46.CornerRadius = UDim.new(0, 10)
G.UICorner_46.Parent = G.TextButton_19

-- UIStroke_33 (UIStroke)
G.UIStroke_33 = Instance.new("UIStroke")
G.UIStroke_33.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_33.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_33.Transparency = 0.44999998807907104
G.UIStroke_33.Parent = G.TextButton_19

-- UIScale_7 (UIScale)
G.UIScale_7 = Instance.new("UIScale")
G.UIScale_7.Parent = G.TextButton_19

-- TextButton_20 (TextButton)
G.TextButton_20 = Instance.new("TextButton")
G.TextButton_20.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.TextButton_20.BackgroundTransparency = 0.2800000011920929
G.TextButton_20.Size = UDim2.new(1, 0, 0, 32)
G.TextButton_20.AutoButtonColor = false
G.TextButton_20.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_20.Text = "Rejoin"
G.TextButton_20.TextColor3 = Color3.fromRGB(224, 193, 255)
G.TextButton_20.TextSize = 12
G.TextButton_20.Parent = G.Holder_3

-- UICorner_47 (UICorner)
G.UICorner_47 = Instance.new("UICorner")
G.UICorner_47.CornerRadius = UDim.new(0, 10)
G.UICorner_47.Parent = G.TextButton_20

-- UIStroke_34 (UIStroke)
G.UIStroke_34 = Instance.new("UIStroke")
G.UIStroke_34.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_34.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_34.Transparency = 0.44999998807907104
G.UIStroke_34.Parent = G.TextButton_20

-- UIScale_8 (UIScale)
G.UIScale_8 = Instance.new("UIScale")
G.UIScale_8.Parent = G.TextButton_20

-- BindsWindow (Frame)
G.BindsWindow = Instance.new("Frame")
G.BindsWindow.Name = "BindsWindow"
G.BindsWindow.BackgroundColor3 = Color3.fromRGB(42, 17, 69)
G.BindsWindow.BackgroundTransparency = 0.2800000011920929
G.BindsWindow.BorderSizePixel = 0
G.BindsWindow.Position = UDim2.new(0, 20, 0, 200)
G.BindsWindow.Size = UDim2.new(0, 300, 0, 340)
G.BindsWindow.Visible = false
G.BindsWindow.ZIndex = 200
G.BindsWindow.Parent = G.AspectUnifiedMenu

-- UICorner_48 (UICorner)
G.UICorner_48 = Instance.new("UICorner")
G.UICorner_48.CornerRadius = UDim.new(0, 14)
G.UICorner_48.Parent = G.BindsWindow

-- UIGradient_7 (UIGradient)
G.UIGradient_7 = Instance.new("UIGradient")
G.UIGradient_7.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(23, 9, 39)), ColorSequenceKeypoint.new(0.25, Color3.fromRGB(41, 16, 67)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(61, 24, 95)), ColorSequenceKeypoint.new(0.75, Color3.fromRGB(80, 34, 122)), ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 7, 30))})
G.UIGradient_7.Rotation = 135
G.UIGradient_7.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.059999998658895493, 0), NumberSequenceKeypoint.new(0.5, 0.10000000149011612, 0), NumberSequenceKeypoint.new(1, 0.059999998658895493, 0)})
G.UIGradient_7.Parent = G.BindsWindow

-- UIStroke_35 (UIStroke)
G.UIStroke_35 = Instance.new("UIStroke")
G.UIStroke_35.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_35.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_35.Thickness = 1.3999999761581421
G.UIStroke_35.Transparency = 0.18000000715255737
G.UIStroke_35.Parent = G.BindsWindow

-- UIGradient_8 (UIGradient)
G.UIGradient_8 = Instance.new("UIGradient")
G.UIGradient_8.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(129, 65, 181)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(186, 117, 245)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 47, 149))})
G.UIGradient_8.Rotation = 90
G.UIGradient_8.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.44999998807907104, 0), NumberSequenceKeypoint.new(0.5, 0.2199999988079071, 0), NumberSequenceKeypoint.new(1, 0.41999998688697815, 0)})
G.UIGradient_8.Parent = G.UIStroke_35

-- Header_4 (Frame)
G.Header_4 = Instance.new("Frame")
G.Header_4.Name = "Header"
G.Header_4.Active = true
G.Header_4.BackgroundTransparency = 1
G.Header_4.BorderSizePixel = 0
G.Header_4.Size = UDim2.new(1, 0, 0, 46)
G.Header_4.ZIndex = 10
G.Header_4.Parent = G.BindsWindow

-- TitleText_4 (TextLabel)
G.TitleText_4 = Instance.new("TextLabel")
G.TitleText_4.Name = "TitleText"
G.TitleText_4.BackgroundTransparency = 1
G.TitleText_4.Position = UDim2.new(0, 14, 0, 0)
G.TitleText_4.Size = UDim2.new(1, -28, 1, 0)
G.TitleText_4.ZIndex = 11
G.TitleText_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TitleText_4.Text = "Binds"
G.TitleText_4.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TitleText_4.TextSize = 14
G.TitleText_4.TextXAlignment = Enum.TextXAlignment.Left
G.TitleText_4.Parent = G.Header_4

-- Frame_41 (Frame)
G.Frame_41 = Instance.new("Frame")
G.Frame_41.BackgroundColor3 = Color3.fromRGB(188, 120, 255)
G.Frame_41.BackgroundTransparency = 0.55000001192092896
G.Frame_41.BorderSizePixel = 0
G.Frame_41.Position = UDim2.new(0, 14, 1, -1)
G.Frame_41.Size = UDim2.new(1, -28, 0, 1)
G.Frame_41.ZIndex = 11
G.Frame_41.Parent = G.Header_4

-- TextButton_21 (TextButton)
G.TextButton_21 = Instance.new("TextButton")
G.TextButton_21.AnchorPoint = Vector2.new(1, 0.5)
G.TextButton_21.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.TextButton_21.Position = UDim2.new(1, -12, 0, 23)
G.TextButton_21.Size = UDim2.new(0, 24, 0, 24)
G.TextButton_21.ZIndex = 5
G.TextButton_21.AutoButtonColor = false
G.TextButton_21.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_21.Text = "×"
G.TextButton_21.TextColor3 = Color3.fromRGB(224, 193, 255)
G.TextButton_21.TextSize = 18
G.TextButton_21.Parent = G.BindsWindow

-- UICorner_49 (UICorner)
G.UICorner_49 = Instance.new("UICorner")
G.UICorner_49.CornerRadius = UDim.new(0, 7)
G.UICorner_49.Parent = G.TextButton_21

-- UIStroke_36 (UIStroke)
G.UIStroke_36 = Instance.new("UIStroke")
G.UIStroke_36.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_36.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_36.Transparency = 0.64999997615814209
G.UIStroke_36.Parent = G.TextButton_21

-- ScrollingFrame (ScrollingFrame)
G.ScrollingFrame = Instance.new("ScrollingFrame")
G.ScrollingFrame.Active = true
G.ScrollingFrame.BackgroundTransparency = 1
G.ScrollingFrame.BorderSizePixel = 0
G.ScrollingFrame.Position = UDim2.new(0, 10, 0, 54)
G.ScrollingFrame.Size = UDim2.new(1, -20, 1, -66)
G.ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
G.ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(188, 120, 255)
G.ScrollingFrame.ScrollBarThickness = 3
G.ScrollingFrame.Parent = G.BindsWindow

-- UIListLayout_4 (UIListLayout)
G.UIListLayout_4 = Instance.new("UIListLayout")
G.UIListLayout_4.Padding = UDim.new(0, 7)
G.UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_4.Parent = G.ScrollingFrame

-- Frame_42 (Frame)
G.Frame_42 = Instance.new("Frame")
G.Frame_42.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.Frame_42.BorderSizePixel = 0
G.Frame_42.Size = UDim2.new(1, -4, 0, 42)
G.Frame_42.Parent = G.ScrollingFrame

-- UICorner_50 (UICorner)
G.UICorner_50 = Instance.new("UICorner")
G.UICorner_50.CornerRadius = UDim.new(0, 9)
G.UICorner_50.Parent = G.Frame_42

-- UIStroke_37 (UIStroke)
G.UIStroke_37 = Instance.new("UIStroke")
G.UIStroke_37.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_37.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_37.Transparency = 0.72000002861022949
G.UIStroke_37.Parent = G.Frame_42

-- TextLabel_15 (TextLabel)
G.TextLabel_15 = Instance.new("TextLabel")
G.TextLabel_15.BackgroundTransparency = 1
G.TextLabel_15.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_15.Size = UDim2.new(1, -100, 1, 0)
G.TextLabel_15.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_15.Text = "Carpet Speed"
G.TextLabel_15.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_15.TextSize = 14
G.TextLabel_15.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_15.Parent = G.Frame_42

-- TextButton_22 (TextButton)
G.TextButton_22 = Instance.new("TextButton")
G.TextButton_22.AnchorPoint = Vector2.new(1, 0.5)
G.TextButton_22.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.TextButton_22.Position = UDim2.new(1, -8, 0.5, 0)
G.TextButton_22.Size = UDim2.new(0, 66, 0, 26)
G.TextButton_22.AutoButtonColor = false
G.TextButton_22.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_22.Text = "Q"
G.TextButton_22.TextColor3 = Color3.fromRGB(224, 193, 255)
G.TextButton_22.TextSize = 13
G.TextButton_22.Parent = G.Frame_42

-- UICorner_51 (UICorner)
G.UICorner_51 = Instance.new("UICorner")
G.UICorner_51.Parent = G.TextButton_22

-- UIStroke_38 (UIStroke)
G.UIStroke_38 = Instance.new("UIStroke")
G.UIStroke_38.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_38.Color = Color3.fromRGB(224, 193, 255)
G.UIStroke_38.Transparency = 0.55000001192092896
G.UIStroke_38.Parent = G.TextButton_22

-- Frame_43 (Frame)
G.Frame_43 = Instance.new("Frame")
G.Frame_43.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.Frame_43.BorderSizePixel = 0
G.Frame_43.Size = UDim2.new(1, -4, 0, 42)
G.Frame_43.Parent = G.ScrollingFrame

-- UICorner_52 (UICorner)
G.UICorner_52 = Instance.new("UICorner")
G.UICorner_52.CornerRadius = UDim.new(0, 9)
G.UICorner_52.Parent = G.Frame_43

-- UIStroke_39 (UIStroke)
G.UIStroke_39 = Instance.new("UIStroke")
G.UIStroke_39.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_39.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_39.Transparency = 0.72000002861022949
G.UIStroke_39.Parent = G.Frame_43

-- TextLabel_16 (TextLabel)
G.TextLabel_16 = Instance.new("TextLabel")
G.TextLabel_16.BackgroundTransparency = 1
G.TextLabel_16.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_16.Size = UDim2.new(1, -100, 1, 0)
G.TextLabel_16.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_16.Text = "Instant Reset"
G.TextLabel_16.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_16.TextSize = 14
G.TextLabel_16.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_16.Parent = G.Frame_43

-- TextButton_23 (TextButton)
G.TextButton_23 = Instance.new("TextButton")
G.TextButton_23.AnchorPoint = Vector2.new(1, 0.5)
G.TextButton_23.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.TextButton_23.Position = UDim2.new(1, -8, 0.5, 0)
G.TextButton_23.Size = UDim2.new(0, 66, 0, 26)
G.TextButton_23.AutoButtonColor = false
G.TextButton_23.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_23.Text = "R"
G.TextButton_23.TextColor3 = Color3.fromRGB(224, 193, 255)
G.TextButton_23.TextSize = 13
G.TextButton_23.Parent = G.Frame_43

-- UICorner_53 (UICorner)
G.UICorner_53 = Instance.new("UICorner")
G.UICorner_53.Parent = G.TextButton_23

-- UIStroke_40 (UIStroke)
G.UIStroke_40 = Instance.new("UIStroke")
G.UIStroke_40.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_40.Color = Color3.fromRGB(224, 193, 255)
G.UIStroke_40.Transparency = 0.55000001192092896
G.UIStroke_40.Parent = G.TextButton_23

-- Frame_44 (Frame)
G.Frame_44 = Instance.new("Frame")
G.Frame_44.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.Frame_44.BorderSizePixel = 0
G.Frame_44.Size = UDim2.new(1, -4, 0, 42)
G.Frame_44.Parent = G.ScrollingFrame

-- UICorner_54 (UICorner)
G.UICorner_54 = Instance.new("UICorner")
G.UICorner_54.CornerRadius = UDim.new(0, 9)
G.UICorner_54.Parent = G.Frame_44

-- UIStroke_41 (UIStroke)
G.UIStroke_41 = Instance.new("UIStroke")
G.UIStroke_41.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_41.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_41.Transparency = 0.72000002861022949
G.UIStroke_41.Parent = G.Frame_44

-- TextLabel_17 (TextLabel)
G.TextLabel_17 = Instance.new("TextLabel")
G.TextLabel_17.BackgroundTransparency = 1
G.TextLabel_17.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_17.Size = UDim2.new(1, -100, 1, 0)
G.TextLabel_17.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_17.Text = "Drop"
G.TextLabel_17.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_17.TextSize = 14
G.TextLabel_17.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_17.Parent = G.Frame_44

-- TextButton_24 (TextButton)
G.TextButton_24 = Instance.new("TextButton")
G.TextButton_24.AnchorPoint = Vector2.new(1, 0.5)
G.TextButton_24.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.TextButton_24.Position = UDim2.new(1, -8, 0.5, 0)
G.TextButton_24.Size = UDim2.new(0, 66, 0, 26)
G.TextButton_24.AutoButtonColor = false
G.TextButton_24.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_24.Text = "G"
G.TextButton_24.TextColor3 = Color3.fromRGB(224, 193, 255)
G.TextButton_24.TextSize = 13
G.TextButton_24.Parent = G.Frame_44

-- UICorner_55 (UICorner)
G.UICorner_55 = Instance.new("UICorner")
G.UICorner_55.Parent = G.TextButton_24

-- UIStroke_42 (UIStroke)
G.UIStroke_42 = Instance.new("UIStroke")
G.UIStroke_42.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_42.Color = Color3.fromRGB(224, 193, 255)
G.UIStroke_42.Transparency = 0.55000001192092896
G.UIStroke_42.Parent = G.TextButton_24

-- Frame_45 (Frame)
G.Frame_45 = Instance.new("Frame")
G.Frame_45.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.Frame_45.BorderSizePixel = 0
G.Frame_45.Size = UDim2.new(1, -4, 0, 42)
G.Frame_45.Parent = G.ScrollingFrame

-- UICorner_56 (UICorner)
G.UICorner_56 = Instance.new("UICorner")
G.UICorner_56.CornerRadius = UDim.new(0, 9)
G.UICorner_56.Parent = G.Frame_45

-- UIStroke_43 (UIStroke)
G.UIStroke_43 = Instance.new("UIStroke")
G.UIStroke_43.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_43.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_43.Transparency = 0.72000002861022949
G.UIStroke_43.Parent = G.Frame_45

-- TextLabel_18 (TextLabel)
G.TextLabel_18 = Instance.new("TextLabel")
G.TextLabel_18.BackgroundTransparency = 1
G.TextLabel_18.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_18.Size = UDim2.new(1, -100, 1, 0)
G.TextLabel_18.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_18.Text = "Aimbot"
G.TextLabel_18.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_18.TextSize = 14
G.TextLabel_18.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_18.Parent = G.Frame_45

-- TextButton_25 (TextButton)
G.TextButton_25 = Instance.new("TextButton")
G.TextButton_25.AnchorPoint = Vector2.new(1, 0.5)
G.TextButton_25.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.TextButton_25.Position = UDim2.new(1, -8, 0.5, 0)
G.TextButton_25.Size = UDim2.new(0, 66, 0, 26)
G.TextButton_25.AutoButtonColor = false
G.TextButton_25.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_25.Text = "C"
G.TextButton_25.TextColor3 = Color3.fromRGB(224, 193, 255)
G.TextButton_25.TextSize = 13
G.TextButton_25.Parent = G.Frame_45

-- UICorner_57 (UICorner)
G.UICorner_57 = Instance.new("UICorner")
G.UICorner_57.Parent = G.TextButton_25

-- UIStroke_44 (UIStroke)
G.UIStroke_44 = Instance.new("UIStroke")
G.UIStroke_44.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_44.Color = Color3.fromRGB(224, 193, 255)
G.UIStroke_44.Transparency = 0.55000001192092896
G.UIStroke_44.Parent = G.TextButton_25

-- Frame_46 (Frame)
G.Frame_46 = Instance.new("Frame")
G.Frame_46.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.Frame_46.BorderSizePixel = 0
G.Frame_46.Size = UDim2.new(1, -4, 0, 42)
G.Frame_46.Parent = G.ScrollingFrame

-- UICorner_58 (UICorner)
G.UICorner_58 = Instance.new("UICorner")
G.UICorner_58.CornerRadius = UDim.new(0, 9)
G.UICorner_58.Parent = G.Frame_46

-- UIStroke_45 (UIStroke)
G.UIStroke_45 = Instance.new("UIStroke")
G.UIStroke_45.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_45.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_45.Transparency = 0.72000002861022949
G.UIStroke_45.Parent = G.Frame_46

-- TextLabel_19 (TextLabel)
G.TextLabel_19 = Instance.new("TextLabel")
G.TextLabel_19.BackgroundTransparency = 1
G.TextLabel_19.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_19.Size = UDim2.new(1, -100, 1, 0)
G.TextLabel_19.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_19.Text = "Auto Kick"
G.TextLabel_19.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_19.TextSize = 14
G.TextLabel_19.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_19.Parent = G.Frame_46

-- TextButton_26 (TextButton)
G.TextButton_26 = Instance.new("TextButton")
G.TextButton_26.AnchorPoint = Vector2.new(1, 0.5)
G.TextButton_26.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.TextButton_26.Position = UDim2.new(1, -8, 0.5, 0)
G.TextButton_26.Size = UDim2.new(0, 66, 0, 26)
G.TextButton_26.AutoButtonColor = false
G.TextButton_26.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_26.Text = "K"
G.TextButton_26.TextColor3 = Color3.fromRGB(224, 193, 255)
G.TextButton_26.TextSize = 13
G.TextButton_26.Parent = G.Frame_46

-- UICorner_59 (UICorner)
G.UICorner_59 = Instance.new("UICorner")
G.UICorner_59.Parent = G.TextButton_26

-- UIStroke_46 (UIStroke)
G.UIStroke_46 = Instance.new("UIStroke")
G.UIStroke_46.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_46.Color = Color3.fromRGB(224, 193, 255)
G.UIStroke_46.Transparency = 0.55000001192092896
G.UIStroke_46.Parent = G.TextButton_26

-- Frame_47 (Frame)
G.Frame_47 = Instance.new("Frame")
G.Frame_47.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.Frame_47.BorderSizePixel = 0
G.Frame_47.Size = UDim2.new(1, -4, 0, 42)
G.Frame_47.Parent = G.ScrollingFrame

-- UICorner_60 (UICorner)
G.UICorner_60 = Instance.new("UICorner")
G.UICorner_60.CornerRadius = UDim.new(0, 9)
G.UICorner_60.Parent = G.Frame_47

-- UIStroke_47 (UIStroke)
G.UIStroke_47 = Instance.new("UIStroke")
G.UIStroke_47.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_47.Color = Color3.fromRGB(186, 117, 245)
G.UIStroke_47.Transparency = 0.72000002861022949
G.UIStroke_47.Parent = G.Frame_47

-- TextLabel_20 (TextLabel)
G.TextLabel_20 = Instance.new("TextLabel")
G.TextLabel_20.BackgroundTransparency = 1
G.TextLabel_20.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_20.Size = UDim2.new(1, -100, 1, 0)
G.TextLabel_20.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_20.Text = "Steal Boost"
G.TextLabel_20.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_20.TextSize = 14
G.TextLabel_20.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_20.Parent = G.Frame_47

-- TextButton_27 (TextButton)
G.TextButton_27 = Instance.new("TextButton")
G.TextButton_27.AnchorPoint = Vector2.new(1, 0.5)
G.TextButton_27.BackgroundColor3 = Color3.fromRGB(61, 24, 95)
G.TextButton_27.Position = UDim2.new(1, -8, 0.5, 0)
G.TextButton_27.Size = UDim2.new(0, 66, 0, 26)
G.TextButton_27.AutoButtonColor = false
G.TextButton_27.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_27.Text = "V"
G.TextButton_27.TextColor3 = Color3.fromRGB(224, 193, 255)
G.TextButton_27.TextSize = 13
G.TextButton_27.Parent = G.Frame_47

-- UICorner_61 (UICorner)
G.UICorner_61 = Instance.new("UICorner")
G.UICorner_61.Parent = G.TextButton_27

-- UIStroke_48 (UIStroke)
G.UIStroke_48 = Instance.new("UIStroke")
G.UIStroke_48.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_48.Color = Color3.fromRGB(224, 193, 255)
G.UIStroke_48.Transparency = 0.55000001192092896
G.UIStroke_48.Parent = G.TextButton_27

-- mount
G.AspectUnifiedMenu.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

return G.AspectUnifiedMenu
