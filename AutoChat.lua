--// ESP Player Script
print("Tải hoàn thành")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Giao diện chính
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "ESP_GUI"

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0, 20, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Parent = ScreenGui

-- Bo góc
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "ESP Player"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = mainFrame

-- Nút teleport
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(1, -20, 0, 30)
teleportButton.Position = UDim2.new(0, 10, 0, 50)
teleportButton.Text = "Teleport đến người chơi đầu tiên"
teleportButton.TextColor3 = Color3.new(1, 1, 1)
teleportButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
teleportButton.Font = Enum.Font.Gotham
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

-- ESP Aura + Tên + Máu
function createESP(target)
    if target == LocalPlayer then return end
    local character = target.Character
    if not character then return end

    local root = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if root and head and humanoid then
        -- Vòng aura
        local aura = Instance.new("SelectionSphere")
        aura.Adornee = root
        aura.Color3 = Color3.new(0, 1, 0)
        aura.SurfaceTransparency = 0.5
        aura.Parent = root

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
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextScaled = true
        nameLabel.Parent = espGui

        local healthLabel = Instance.new("TextLabel")
        healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
        healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
        healthLabel.BackgroundTransparency = 1
        healthLabel.TextColor3 = Color3.new(1, 0, 0)
        healthLabel.Text = "Máu: " .. humanoid.Health
        healthLabel.Font = Enum.Font.Gotham
        healthLabel.TextScaled = true
        healthLabel.Parent = espGui

        -- Cập nhật máu liên tục
        RunService.RenderStepped:Connect(function()
            if humanoid and humanoid.Parent then
                healthLabel.Text = "Máu: " .. math.floor(humanoid.Health)
            end
        end)
    end
end

-- Gọi ESP cho người chơi đang có
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        createESP(plr)
    end
end

-- Tự thêm khi có người chơi mới
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        wait(1)
        createESP(plr)
    end)
end)
