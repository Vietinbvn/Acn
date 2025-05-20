local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local DataStoreService = game:GetService("DataStoreService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local placeId = game.PlaceId
local dataStore = DataStoreService:GetDataStore("PlayerServerData")

-- === Tạo ScreenGui chính ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ServerReconnectUI"
screenGui.Parent = playerGui

-- Khung chính chứa phiên bản và nút join lại server cũ
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 100)
frame.Position = UDim2.new(1, -270, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

-- Label hiển thị phiên bản game
local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(1, -20, 0, 40)
versionLabel.Position = UDim2.new(0, 10, 0, 10)
versionLabel.BackgroundTransparency = 1
versionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
versionLabel.Font = Enum.Font.GothamBold
versionLabel.TextSize = 24
versionLabel.Text = "Phiên bản: 1.0.0"
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.Parent = frame

-- Nút join lại server cũ
local reconnectBtn = Instance.new("TextButton")
reconnectBtn.Size = UDim2.new(1, -20, 0, 40)
reconnectBtn.Position = UDim2.new(0, 10, 0, 55)
reconnectBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
reconnectBtn.TextColor3 = Color3.new(1, 1, 1)
reconnectBtn.Font = Enum.Font.GothamBold
reconnectBtn.TextSize = 20
reconnectBtn.Text = "Join lại server cũ"
reconnectBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 12)
btnCorner.Parent = reconnectBtn

-- Label trạng thái thông báo
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 1, -30)
statusLabel.BackgroundTransparency = 0.6
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextSize = 16
statusLabel.Text = ""
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Visible = false
statusLabel.Parent = frame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusLabel

-- Hàm hiển thị trạng thái
local function showStatus(text, duration)
    statusLabel.Text = text
    statusLabel.Visible = true
    delay(duration or 3, function()
        statusLabel.Visible = false
    end)
end

-- Lưu JobId server hiện tại
local function saveCurrentServer()
    local success, err = pcall(function()
        dataStore:SetAsync(player.UserId, game.JobId)
    end)
    if not success then
        warn("Lưu JobId thất bại:", err)
        showStatus("Lưu server thất bại!")
    else
        print("Đã lưu JobId server hiện tại:", game.JobId)
    end
end

-- Lấy JobId server cũ
local function getOldServerJobId()
    local jobId
    local success, err = pcall(function()
        jobId = dataStore:GetAsync(player.UserId)
    end)
    if not success then
        warn("Lấy JobId server cũ thất bại:", err)
        showStatus("Không lấy được server cũ!")
        return nil
    end
    return jobId
end

-- Xử lý khi bấm nút join lại server cũ
reconnectBtn.MouseButton1Click:Connect(function()
    local oldJobId = getOldServerJobId()
    if oldJobId then
        showStatus("Đang chuyển đến server cũ...")
        TeleportService:TeleportToPlaceInstance(placeId, oldJobId, player)
    else
        showStatus("Không tìm thấy server cũ để join lại.")
    end
end)

-- Lưu JobId khi người chơi vào game
saveCurrentServer()
