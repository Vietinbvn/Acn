local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Tạo GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportMenu"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0, 20, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.Text = "Chọn người để Teleport"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = frame

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = frame
listLayout.Padding = UDim.new(0, 5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function teleportToPlayer(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local targetHRP = targetPlayer.Character.HumanoidRootPart
        if hrp then
            hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 3, 0)
            print("Đã teleport đến " .. targetPlayer.Name)
        else
            warn("Không tìm thấy HumanoidRootPart của bạn.")
        end
    else
        warn("Người chơi không có nhân vật hoặc HumanoidRootPart.")
    end
end

local function createPlayerButton(targetPlayer)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.TextColor3 = Color3.new(1,1,1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 18
    button.Text = targetPlayer.Name
    button.Parent = frame

    button.MouseButton1Click:Connect(function()
        teleportToPlayer(targetPlayer)
    end)
end

-- Tạo danh sách người chơi ban đầu
for _, p in pairs(Players:GetPlayers()) do
    if p ~= player then
        createPlayerButton(p)
    end
end

-- Cập nhật danh sách khi có người vào hoặc ra
Players.PlayerAdded:Connect(function(p)
    if p ~= player then
        createPlayerButton(p)
    end
end)

Players.PlayerRemoving:Connect(function(p)
    for _, button in pairs(frame:GetChildren()) do
        if button:IsA("TextButton") and button.Text == p.Name then
            button:Destroy()
        end
    end
end)
