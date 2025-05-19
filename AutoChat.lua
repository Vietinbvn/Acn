local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local teleportEvent = ReplicatedStorage:WaitForChild("RequestTeleportToPlayer")

-- Tạo GUI đơn giản
local playerGui = player:WaitForChild("PlayerGui")
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

-- Hàm tạo nút cho từng người chơi
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
        teleportEvent:FireServer(targetPlayer.Name)
    end)
end

-- Tạo danh sách người chơi ban đầu
for _, p in pairs(Players:GetPlayers()) do
    if p ~= player then -- không hiện tên chính mình
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
    -- Xoá nút tương ứng khi người chơi thoát
    for _, button in pairs(frame:GetChildren()) do
        if button:IsA("TextButton") and button.Text == p.Name then
            button:Destroy()
        end
    end
end)
