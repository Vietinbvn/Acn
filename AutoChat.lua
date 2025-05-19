-- Tải thành công
print("Tải hoàn thành")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "ESP_GUI"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0, 20, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.AnchorPoint = Vector2.new(0, 0.5)
mainFrame.Name = "Menu"
mainFrame.Visible = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.UICorner = Instance.new("UICorner", mainFrame)
mainFrame.UICorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", mainFrame)
title.Text = "ESP Menu"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Danh sách người chơi
local playerList = Instance.new("ScrollingFrame", mainFrame)
playerList.Position = UDim2.new(0, 10, 0, 40)
playerList.Size = UDim2.new(1, -20, 1, -50)
playerList.BackgroundTransparency = 1
playerList.ScrollBarThickness = 4
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)

-- Hàm vẽ ESP
local function createESP(target)
    if target:FindFirstChild("ESP_Aura") then return end
    local char = target.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    -- Aura
    local aura = Instance.new("SelectionSphere", char.HumanoidRootPart)
    aura.Adornee = char.HumanoidRootPart
    aura.Name = "ESP_Aura"
    aura.Color3 = Color3.fromRGB(0, 255, 255)

    -- Billboard GUI
    local bb = Instance.new("BillboardGui", char)
    bb.Name = "ESP_Info"
    bb.Size = UDim2.new(0, 100, 0, 40)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.Adornee = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    bb.AlwaysOnTop = true

    -- Tên
    local name = Instance.new("TextLabel", bb)
    name.Size = UDim2.new(1, 0, 0.5, 0)
    name.BackgroundTransparency = 1
    name.TextColor3 = Color3.new(1, 1, 1)
    name.Text = target.Name
    name.Font = Enum.Font.GothamBold
    name.TextSize = 14

    -- Máu
    local health = Instance.new("TextLabel", bb)
    health.Size = UDim2.new(1, 0, 0.5, 0)
    health.Position = UDim2.new(0, 0, 0.5, 0)
    health.BackgroundTransparency = 1
    health.TextColor3 = Color3.new(1, 0, 0)
    health.Font = Enum.Font.Gotham
    health.TextSize = 14

    -- Cập nhật máu
    local function update()
        if char:FindFirstChild("Humanoid") then
            local hp = math.floor(char.Humanoid.Health)
            local max = math.floor(char.Humanoid.MaxHealth)
            health.Text = "HP: " .. hp .. "/" .. max
        end
    end

    RunService.RenderStepped:Connect(update)
end

-- Tạo nút + ESP cho mỗi player
local function addPlayer(p)
    if p == LocalPlayer then return end

    local btn = Instance.new("TextButton", playerList)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Text = p.Name
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.UICorner = Instance.new("UICorner", btn)
    btn.UICorner.CornerRadius = UDim.new(0, 8)

    playerList.CanvasSize = UDim2.new(0, 0, 0, #playerList:GetChildren() * 32)

    -- Click = teleport + ESP
    btn.MouseButton1Click:Connect(function()
        createESP(p)
        local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        if hrp and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
        end
    end)
end

-- Lặp qua các player hiện tại
for _, p in pairs(Players:GetPlayers()) do
    addPlayer(p)
end

-- Khi có người mới vào
Players.PlayerAdded:Connect(addPlayer)
