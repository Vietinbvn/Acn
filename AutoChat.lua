-- Optimize Script by PPL
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- [1] TẮT CÁC THỨ GÂY LAG
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

-- [2] FPS COUNTER
local function createFPSCounter()
    local fpsGui = Instance.new("ScreenGui", CoreGui)
    fpsGui.Name = "FPS_Monitor"
    fpsGui.ResetOnSpawn = false

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
        local fps = math.floor(#frameTimes / (now - frameTimes[1]))
        fpsText.Text = "FPS: " .. fps
    end

    RunService.Heartbeat:Connect(updateFPS)
end

-- [3] CHỈNH FONT SANG SANS
local function applySansFont()
    -- Chỉnh font cho CoreGui
    LocalPlayer:WaitForChild("PlayerGui"):GetPropertyChangedSignal("CurrentScreenOrientation"):Wait()
    
    local function updateFont(obj)
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            pcall(function()
                if obj.Font ~= Enum.Font.SourceSans then
                    obj.Font = Enum.Font.SourceSans
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

-- [4] TẮT RENDER KHU VỰC KHÔNG THẤY
local function cullDistantObjects()
    local camera = workspace.CurrentCamera
    
    local function updateViewDistance()
        -- Giới hạn view distance 500 studs
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = CFrame.new(camera.CFrame.Position, camera.Focus.Position)
        camera.DiagonalFieldOfView = 70
    end
    
    RunService.RenderStepped:Connect(updateViewDistance)
end

-- [5] KÍCH HOẠT TẤT CẢ
optimizeEnvironment()
createFPSCounter()
applySansFont()
cullDistantObjects()

-- [6] THÔNG BÁO HOÀN THÀNH
LocalPlayer.PlayerGui:WaitForChild("FPS_Monitor", 5)
print("Tối ưu hóa hoàn tất! FPS counter đã hiển thị")
