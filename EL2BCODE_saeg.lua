-- إنشاء واجهة تحتوي على زر إعادة التشغيل والتنظيف الآمن
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- إزالة أي زر قديم تم إنشاؤه مسبقاً لمنع التكرار
if playerGui:FindFirstChild("ZlhubReloadUI") then
    playerGui.ZlhubReloadUI:Destroy()
end

-- بناء الواجهة والزر
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZlhubReloadUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local button = Instance.new("TextButton")
button.Name = "ReloadButton"
button.Size = UDim2.new(0, 160, 0, 45)
button.Position = UDim2.new(0, 20, 0, 100) -- مكان الزر على الشاشة (يمكنك تحريكه أو تعديل مكانه)
button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
button.BorderColor3 = Color3.fromRGB(0, 170, 255)
button.BorderSizePixel = 2
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 14
button.Font = Enum.Font.SourceSansBold
button.Text = "🔄 إعادة تشغيل السكريبت"
button.Parent = screenGui

-- جعل الزر قابلاً للسحب والإفلات (Dragable) لكي تضعه في أي مكان يناسبك
local dragging, dragInput, dragStart, startPos

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = button.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- وظيفة الزر عند النقر عليه
button.MouseButton1Click:Connect(function()
    button.Text = "جاري التطهير والتشغيل..."
    button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    
    task.spawn(function()
        -- 1. حذف واجهات Zlhub القديمة بدقة
        local guiContainers = { game.CoreGui, playerGui }
        for _, container in pairs(guiContainers) do
            for _, gui in pairs(container:GetChildren()) do
                if gui ~= screenGui then -- لا تحذف الزر الخاص بنا
                    local name = gui.Name:lower()
                    if name:find("zl") or name:find("zlpv") or name:find("xspeed") then
                        pcall(function() gui:Destroy() end)
                    end
                end
            end
        end

        -- 2. تفريغ متغيرات البيئة العامة
        pcall(function()
            if getgenv then
                for i, v in pairs(getgenv()) do
                    if type(i) == "string" then
                        local lowerKey = i:lower()
                        if lowerKey:find("zl") or lowerKey:find("zlpv") or lowerKey:find("xspeed") then
                            getgenv()[i] = nil
                        end
                    end
                end
            end
        end)

        task.wait(0.5)

        -- 3. تشغيل السكريبت من جديد
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xspeedHub0/Zlhub/main/ZLPVPreview.lua"))()
        end)

        if success then
            button.Text = "✅ تم التشغيل بنجاح!"
            button.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        else
            button.Text = "❌ فشل التشغيل"
            button.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
            warn("خطأ: " .. tostring(err))
        end

        task.wait(2)
        button.Text = "🔄 إعادة تشغيل السكريبت"
        button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)
end)

print("--- تم إظهار زر إعادة التشغيل على الشاشة بنجاح ---")
