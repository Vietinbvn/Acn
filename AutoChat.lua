-- Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Version game (bạn thay đổi theo game của bạn)
local gameVersion = "1.0.0"

-- Hàm tạo UI
local function createUI()
    -- 1. Màn hình đen + chữ
    local blackScreen = Instance.new("ScreenGui")
    blackScreen.Name = "BlackScreenGui"
    blackScreen.ResetOnSpawn = false
    blackScreen.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.Parent = blackScreen

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 50)
    label.Position = UDim2.new(0, 0, 0.5, -25)
    label.BackgroundTransparency = 1
    label.Text = "DucScript-By Duc_Nhat"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.Parent = frame

    -- Hiện 5 giây rồi ẩn
    wait(5)
    blackScreen:Destroy()

    -- 2. Anti-ban (giả lập)
    -- Ví dụ: disable một số event hoặc cảnh báo (tùy game)
    -- Ở đây đơn giản chỉ in ra console
    print("Anti-ban system activated!")

    -- 3. Tạo nút nhỏ góc để mở menu
    local menuGui = Instance.new("ScreenGui")
    menuGui.Name = "MenuGui"
    menuGui.ResetOnSpawn = false
    menuGui.Parent = playerGui

    local openButton = Instance.new("TextButton")
    openButton.Size = UDim2.new(0, 50, 0, 50)
    openButton.Position = UDim2.new(0, 10, 0, 10)
    openButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    openButton.BackgroundTransparency = 0.3
    openButton.Text = "Menu"
    openButton.TextColor3 = Color3.new(1, 1, 1)
    openButton.Font = Enum.Font.SourceSansBold
    openButton.TextScaled = true
    openButton.AutoButtonColor = true
    openButton.Parent = menuGui
    openButton.ZIndex = 5
    openButton.ClipsDescendants = true
    openButton.BorderSizePixel = 0
    openButton.AnchorPoint = Vector2.new(0, 0)

    -- 4. Tạo menu chính (ẩn ban đầu)
    local menuFrame = Instance.new("Frame")
    menuFrame.Size = UDim2.new(0, 250, 0, 150)
    menuFrame.Position = UDim2.new(0, 10, 0, 70)
    menuFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    menuFrame.BackgroundTransparency = 0.5
    menuFrame.Parent = menuGui
    menuFrame.Visible = false
    menuFrame.ClipsDescendants = true
    menuFrame.AnchorPoint = Vector2.new(0, 0)
    menuFrame.BorderSizePixel = 0
    menuFrame.ZIndex = 4
    menuFrame.Name = "MainMenu"

    -- Bo tròn góc
    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 15)
    uicorner.Parent = menuFrame

    -- Tạo 4 dòng chức năng
    local function createMenuLine(text, posY)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 30)
        label.Position = UDim2.new(0, 10, 0, posY)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.SourceSans
        label.TextScaled = true
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = menuFrame
        label.Text = text
        return label
    end

    -- Dòng 1: Phiên bản game
    local versionLabel = createMenuLine("Phiên bản game: " .. gameVersion, 10)

    -- Dòng 2: Rejoin server (nút)
    local rejoinButton = Instance.new("TextButton")
    rejoinButton.Size = UDim2.new(1, -20, 0, 30)
    rejoinButton.Position = UDim2.new(0, 10, 0, 50)
    rejoinButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    rejoinButton.BackgroundTransparency = 0.3
    rejoinButton.TextColor3 = Color3.new(1, 1, 1)
    rejoinButton.Font = Enum.Font.SourceSansBold
    rejoinButton.TextScaled = true
    rejoinButton.Text = "Rejoin Server"
    rejoinButton.Parent = menuFrame
    rejoinButton.AutoButtonColor = true
    local uicornerBtn1 = Instance.new("UICorner")
    uicornerBtn1.CornerRadius = UDim.new(0, 10)
    uicornerBtn1.Parent = rejoinButton

    -- Dòng 3: Hop server (chuyển server khác)
    local hopButton = Instance.new("TextButton")
    hopButton.Size = UDim2.new(1, -20, 0, 30)
    hopButton.Position = UDim2.new(0, 10, 0, 90)
    hopButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    hopButton.BackgroundTransparency = 0.3
    hopButton.TextColor3 = Color3.new(1, 1, 1)
    hopButton.Font = Enum.Font.SourceSansBold
    hopButton.TextScaled = true
    hopButton.Text = "Hop Server"
    hopButton.Parent = menuFrame
    hopButton.AutoButtonColor = true
    local uicornerBtn2 = Instance.new("UICorner")
    uicornerBtn2.CornerRadius = UDim.new(0, 10)
    uicornerBtn2.Parent = hopButton

    -- Dòng 4: Old server (ít nhất 1 ngày)
    local oldServerButton = Instance.new("TextButton")
    oldServerButton.Size = UDim2.new(1, -20, 0, 30)
    oldServerButton.Position = UDim2.new(0, 10, 0, 130)
    oldServerButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    oldServerButton.BackgroundTransparency = 0.3
    oldServerButton.TextColor3 = Color3.new(1, 1, 1)
    oldServerButton.Font = Enum.Font.SourceSansBold
    oldServerButton.TextScaled = true
    oldServerButton.Text = "Old Server (>=1 day)"
    oldServerButton.Parent = menuFrame
    oldServerButton.AutoButtonColor = true
    local uicornerBtn3 = Instance.new("UICorner")
    uicornerBtn3.CornerRadius = UDim.new(0, 10)
    uicornerBtn3.Parent = oldServerButton

    -- Hiệu ứng mở menu
    openButton.MouseButton1Click:Connect(function()
        menuFrame.Visible = not menuFrame.Visible
    end)

    -- Xử lý Rejoin Server
    rejoinButton.MouseButton1Click:Connect(function()
        -- Teleport lại chính mình vào server hiện tại
        TeleportService:Teleport(game.PlaceId, player)
    end)

    -- Xử lý Hop Server (chọn server khác ngẫu nhiên)
    hopButton.MouseButton1Click:Connect(function()
        -- Lấy list server public (giới hạn 100)
        local servers
        local success, err = pcall(function()
            local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", game.PlaceId)
            local response = game:GetService("HttpService"):GetAsync(url)
            servers = HttpService:JSONDecode(response).data
        end)
        if success and servers then
            -- Lọc server khác với server hiện tại
            local currentJobId = game.JobId
            local availableServers = {}
            for _, server in pairs(servers) do
                if server.id ~= currentJobId and server.playing > 0 then
                    table.insert(availableServers, server)
                end
            end
            if #availableServers > 0 then
                local chosenServer = availableServers[math.random(1, #availableServers)]
                TeleportService:TeleportToPlaceInstance(game.PlaceId, chosenServer.id, player)
            else
                warn("Không tìm thấy server khác để hop!")
            end
        else
            warn("Lỗi lấy server list: ", err)
        end
    end)

    -- Xử lý Old Server (ít nhất 1 ngày)
    oldServerButton.MouseButton1Click:Connect(function()
        -- Lấy list server public
        local servers
        local success, err = pcall(function()
            local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", game.PlaceId)
            local response = HttpService:GetAsync(url)
            servers = HttpService:JSONDecode(response).data
        end)
        if success and servers then
            -- Lọc server có createdAt cách đây >= 1 ngày
            local now = os.time()
            local oneDaySeconds = 24 * 60 * 60
            local oldServers = {}
            for _, server in pairs(servers) do
                if server.playing > 0 and server.id ~= game.JobId then
                    -- createdAt là ISO8601 string, chuyển sang timestamp
                    local pattern = "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)%.%d+Z"
                    local year, month, day, hour, min, sec = server.createdAt:match(pattern)
                    if year then
                        local timestamp = os.time({year = tonumber(year), month = tonumber(month), day = tonumber(day), hour = tonumber(hour), min = tonumber(min), sec = tonumber(sec)})
                        if now - timestamp >= oneDaySeconds then
                            table.insert(oldServers, server)
                        end
                    end
                end
            end
            if #oldServers > 0 then
                local chosenServer = oldServers[math.random(1, #oldServers)]
                TeleportService:TeleportToPlaceInstance(game.PlaceId, chosenServer.id, player)
            else
                warn("Không tìm thấy server cũ >= 1 ngày!")
            end
        else
            warn("Lỗi lấy server list: ", err)
        end
    end)
end

-- Chạy UI
createUI()
