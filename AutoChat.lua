-- LocalScript, ví dụ đặt trong StarterPlayerScripts

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

-- === 1. Thiết lập hiệu ứng shader đẹp ===

-- Xoá các hiệu ứng post-processing cũ để tránh trùng lặp
for _, effect in pairs(Lighting:GetChildren()) do
    if effect:IsA("PostEffect") then
        effect:Destroy()
    end
end

-- BloomEffect - tạo hiệu ứng phát sáng mềm mại
local bloom = Instance.new("BloomEffect")
bloom.Name = "CustomBloomEffect"
bloom.Intensity = 1.8
bloom.Threshold = 0.5
bloom.Size = 24
bloom.Parent = Lighting

-- ColorCorrectionEffect - chỉnh màu sắc tươi sáng, ấm áp
local colorCorrection = Instance.new("ColorCorrectionEffect")
colorCorrection.Name = "CustomColorCorrection"
colorCorrection.TintColor = Color3.fromRGB(255, 240, 220)
colorCorrection.Contrast = 0.1
colorCorrection.Brightness = 0.05
colorCorrection.Saturation = 0.2
colorCorrection.Parent = Lighting

-- === 2. Tạo GUI hiển thị FPS ===

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FPSDisplayGui"
screenGui.Parent = playerGui

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0, 100, 0, 30)
fpsLabel.Position = UDim2.new(1, -110, 0, 10) -- góc trên bên phải màn hình
fpsLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
fpsLabel.BackgroundTransparency = 0.5
fpsLabel.TextColor3 = Color3.new(1, 1, 1)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 18
fpsLabel.Text = "FPS: ..."
fpsLabel.Parent = screenGui

-- === 3. Cập nhật FPS realtime ===

local lastTime = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local currentTime = tick()
    if currentTime - lastTime >= 1 then
        fpsLabel.Text = "FPS: " .. frameCount
        frameCount = 0
        lastTime = currentTime
    end
end)
