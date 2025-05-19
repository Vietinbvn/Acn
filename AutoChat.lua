local Lighting = game:GetService("Lighting")

-- Xóa hết hiệu ứng post-processing cũ
for _, effect in pairs(Lighting:GetChildren()) do
    if effect:IsA("PostEffect") then
        effect:Destroy()
    end
end

-- BloomEffect: ánh sáng phát sáng nhẹ, không quá chói
local bloom = Instance.new("BloomEffect")
bloom.Intensity = 1.2      -- Giảm cường độ
bloom.Threshold = 0.6      -- Tăng ngưỡng để giảm vùng sáng
bloom.Size = 20            -- Kích thước vừa phải
bloom.Parent = Lighting

-- ColorCorrectionEffect: chỉnh màu ấm áp, nhẹ nhàng
local colorCorrection = Instance.new("ColorCorrectionEffect")
colorCorrection.TintColor = Color3.fromRGB(255, 245, 230) -- tông sáng nhẹ, ấm
colorCorrection.Contrast = 0.1
colorCorrection.Brightness = 0.03
colorCorrection.Saturation = 0.15
colorCorrection.Parent = Lighting

-- DepthOfFieldEffect: làm mờ hậu cảnh tạo chiều sâu vừa phải
local depthOfField = Instance.new("DepthOfFieldEffect")
depthOfField.FocusDistance = 50
depthOfField.InFocusRadius = 25
depthOfField.NearIntensity = 0.5
depthOfField.FarIntensity = 0.5
depthOfField.Parent = Lighting

-- SunRaysEffect: tia sáng mặt trời nhẹ nhàng
local sunRays = Instance.new("SunRaysEffect")
sunRays.Intensity = 0.08
sunRays.Spread = 0.15
sunRays.Parent = Lighting

-- BlurEffect: mờ nhẹ, không làm mất nét quá nhiều
local blur = Instance.new("BlurEffect")
blur.Size = 3     -- Độ mờ vừa phải, tránh mờ quá
blur.Parent = Lighting

-- Atmosphere: khí quyển nhẹ, tạo cảm giác không gian thoáng đãng
local atmosphere = Instance.new("Atmosphere")
atmosphere.Density = 0.03
atmosphere.Offset = 0.05
atmosphere.Color = Color3.fromRGB(255, 245, 230)
atmosphere.Decay = 0.15
atmosphere.Glare = 0.05
atmosphere.Haze = 0.2
atmosphere.Parent = Lighting
