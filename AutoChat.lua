-- Optimize Script by PPL (FIXED)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- [1] TẮT CÁC THỨ GÂY LAG (ĐÃ FIX)
local function optimizeEnvironment()
    -- Xóa hạt và hiệu ứng
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or 
           obj:IsA("Explosion") or 
           obj:IsA("Smoke") or 
           obj:IsA("Sparkles") then
            obj:Destroy()
        end
    end

    -- Tắt shadow không cần thiết
    settings().Rendering.QualityLevel = 1
    settings().Rendering.Shadows = false
    
    -- Giảm chất lượng terrain
    workspace.Terrain.WaterWaveSize = 0
    workspace.Terrain.WaterWaveSpeed = 0
    workspace.Terrain.Decoration = false
end

-- [2] FPS COUNTER (ĐÃ FIX DÒNG 21)
local function createFPSCounter()
    local fpsGui = Instance.new("ScreenGui")
    fpsGui.Name = "FPS_Monitor"
    fpsGui.ResetOnSpawn = false
    fpsGui.Parent = CoreGui

    local fpsText = Instance.new("TextLabel")
    fpsText.Size = UDim2.new(0, 100, 0, 30)
    fpsText.Position = UDim2.new(1, -110, 0, 10)
    fpsText.BackgroundTransparency = 0.7
    fpsText.BackgroundColor3 = Color3.new(0, 0, 0)
    fpsText.TextColor3 = Color3.new(1, 1, 1)
    fpsText.Font = Enum.Font.SourceSansBold
    fpsText.TextSize = 18
    fpsText.Text = "FPS: 0"
    fpsText.Parent = fpsGui

    local frameTimes = {}
    local function updateFPS()
        local now = tick()
        table.insert(frameTimes, now)
        
        -- Giữ 60 frame gần nhất
        while #frameTimes > 60 do
            table.remove(frameTimes, 1)
        end
        
        -- Tính FPS trung bình
        if #frameTimes > 1 then
            local fps = math.floor(#frameTimes / (now - frameTimes[1]))
            fpsText.Text = "FPS: " .. fps
        end
    end

    RunService.Heartbeat:Connect(updateFPS)
end

-- [3] CHỈNH FONT SANG SANS (ĐÃ FIX DÒNG 102)
local function applySansFont()
    -- Đợi PlayerGui tồn tại
    if not LocalPlayer:FindFirstChild("PlayerGui") then
        LocalPlayer:WaitForChild("PlayerGui")
    end
    
    local function updateFont(obj)
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            pcall(function()
                obj.Font = Enum.Font.SourceSans
                if obj:IsA("TextLabel") and string.find(obj.Name:lower(), "title") then
                    obj.Font = Enum.Font.SourceSansBold
                end
            end)
        end
    end

    -- Quét toàn bộ GUI
    for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        updateFont(gui)
    end
    
    LocalPlayer.PlayerGui.DescendantAdded:Connect(updateFont)
end

-- [4] TẮT RENDER KHU VỰC KHÔNG THẤY (ĐÃ FIX)
local function cullDistantObjects()
    local camera = workspace.CurrentCamera
    local originalFieldOfView = camera.FieldOfView
    
    -- Giữ nguyên camera type
    camera.CameraType = Enum.CameraType.Custom
    
    local function updateViewDistance()
        -- Chỉ render trong phạm vi 500 studs
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local distance = (obj.Position - camera.CFrame.Position).Magnitude
                obj.LocalTransparencyModifier = (distance > 500) and 1 or 0
            end
        end
    end
    
    RunService.RenderStepped:Connect(updateViewDistance)
end

-- [5] KÍCH HOẠT TẤT CẢ
optimizeEnvironment()
createFPSCounter()
applySansFont()
cullDistantObjects()

print("Tối ưu hóa hoàn tất! FPS counter đã hiển thị")
