print("Tải hoàn thành")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Giao diện chính
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESP_GUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0, 20, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Parent = ScreenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "ESP Player"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = mainFrame

-- Nút teleport
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(1, -20, 0, 30)
teleportButton.Position = UDim2.new(0, 10, 0, 50)
teleportButton.Text = "Teleport đến người chơi đầu tiên"
teleportButton.TextColor3 = Color3.new(1, 1, 1)
teleportButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
teleportButton.Font = Enum.Font.SourceSans
teleportButton.TextSize = 14
teleportButton.Parent = mainFrame

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 8)
tpCorner.Parent = teleportButton

-- Hàm Teleport
teleportButton.MouseButton1Click:Connect(function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
            break
        end
    end
end)

-- Bảng lưu ESP để dễ quản lý
local ESPs = {}

-- Hàm tạo ESP cho 1 người chơi
local function createESP(target)
    if target == LocalPlayer then return end
    local character = target.Character
    if not character then return end

    local root = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if root and head and humanoid then
        -- Tạo aura (dùng Part Neon)
        local aura = Instance.new("Part")
        aura.Shape = Enum.PartType.Ball
        aura.Material = Enum.Material.Neon
        aura.Color = Color3.new(0, 1, 0)
        aura.Transparency = 0.5
        aura.Size = Vector3.new(4, 4, 4)
        aura.CanCollide = false
        aura.Anchored = true
        aura.Parent = workspace

        -- Billboard GUI
        local espGui = Instance.new("BillboardGui")
        espGui.Adornee = head
        espGui.Size = UDim2.new(0, 200, 0, 50)
        espGui.StudsOffset = Vector3.new(0, 2, 0)
        espGui.AlwaysOnTop = true
        espGui.Parent = head

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.Text = target.Name
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextScaled = true
        nameLabel.Parent = espGui

        local healthLabel = Instance.new("TextLabel")
        healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
        healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
        healthLabel.BackgroundTransparency = 1
        healthLabel.TextColor3 = Color3.new(1, 0, 0)
        healthLabel.Text = "Máu: " .. math.floor(humanoid.Health)
        healthLabel.Font = Enum.Font.SourceSans
        healthLabel.TextScaled = true
        healthLabel.Parent = espGui

        -- Cập nhật aura vị trí theo root
        local auraUpdate
        auraUpdate = RunService.Heartbeat:Connect(function()
            if root and root.Parent then
                aura.CFrame = root.CFrame
            else
                auraUpdate:Disconnect()
                aura:Destroy()
            end
        end)

        -- Cập nhật máu liên tục
        local healthUpdate
        healthUpdate = RunService.Heartbeat:Connect(function()
            if humanoid and humanoid.Parent then
                healthLabel.Text = "Máu: " .. math.floor(humanoid.Health)
            else
                healthUpdate:Disconnect()
                espGui:Destroy()
            end
        end)

        -- Lưu ESP để quản lý
        ESPs[target] = {
            aura = aura,
            auraUpdate = auraUpdate,
            healthUpdate = healthUpdate,
            espGui = espGui
        }
    end
end

-- Xóa ESP khi người chơi rời hoặc nhân vật biến mất
local function removeESP(target)
    local esp = ESPs[target]
    if esp then
        if esp.auraUpdate then esp.auraUpdate:Disconnect() end
        if esp.healthUpdate then esp.healthUpdate:Disconnect() end
        if esp.aura then esp.aura:Destroy() end
        if esp.espGui then esp.espGui:Destroy() end
        ESPs[target] = nil
    end
end

-- Tạo ESP cho người chơi hiện có
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        if plr.Character then
            createESP(plr)
        end
        -- Tạo ESP khi nhân vật xuất hiện
        plr.CharacterAdded:Connect(function()
            wait(1)
            createESP(plr)
        end)
    end
end

-- Xử lý khi có người chơi mới
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        wait(1)
        createESP(plr)
    end)
end)

-- Xử lý khi người chơi rời game
Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
end)
