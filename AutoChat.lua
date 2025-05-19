local Lighting = game:GetService("Lighting")

-- Xóa hết các hiệu ứng post-processing cũ để tránh trùng lặp
for _, effect in pairs(Lighting:GetChildren()) do
    if effect:IsA("PostEffect") then
        effect:Destroy()
    end
end

-- BloomEffect: Hiệu ứng phát sáng mềm mại, lung linh
local bloom = Instance.new("BloomEffect")
bloom.Intensity = 3
bloom.Threshold = 0.4
bloom.Size = 30
bloom.Parent = Lighting

-- ColorCorrectionEffect: Chỉnh màu ấm áp, rực rỡ
local colorCorrection = Instance.new("ColorCorrectionEffect")
colorCorrection.TintColor = Color3.fromRGB(255, 230, 200)
colorCorrection.Contrast = 0.25
colorCorrection.Brightness = 0.1
colorCorrection.Saturation = 0.45
colorCorrection.Parent = Lighting

-- DepthOfFieldEffect: Làm mờ hậu cảnh, tạo chiều sâu
local depthOfField = Instance.new("DepthOfFieldEffect")
depthOfField.FocusDistance = 60
depthOfField.InFocusRadius = 30
depthOfField.NearIntensity = 0.8
depthOfField.FarIntensity = 0.8
depthOfField.Parent = Lighting

-- SunRaysEffect: Tạo tia sáng mặt trời lung linh
local sunRays = Instance.new("SunRaysEffect")
sunRays.Intensity = 0.15
sunRays.Spread = 0.2
sunRays.Parent = Lighting

-- BlurEffect: Xóa mờ toàn màn hình, tạo hiệu ứng mờ đẹp mắt
local blur = Instance.new("BlurEffect")
blur.Size = 6 -- Bạn có thể tăng giảm để điều chỉnh mức độ mờ
blur.Parent = Lighting

-- Atmosphere: Tạo không gian khí quyển, sương mù nhẹ nhàng
local atmosphere = Instance.new("Atmosphere")
atmosphere.Density = 0.05
atmosphere.Offset = 0.1
atmosphere.Color = Color3.fromRGB(255, 240, 220)
atmosphere.Decay = 0.2
atmosphere.Glare = 0.1
atmosphere.Haze = 0.3
atmosphere.Parent = Lighting
