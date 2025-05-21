-- Các phần đã có từ trước
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gameVersion = "1.0.0"
local currentServerId = game.JobId  -- Lấy ID của server hiện tại

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

    -- Tạo các dòng chức năng
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

    -- Dòng 4: Nút copy Server ID
    local copyIdButton = Instance.new("TextButton")
    copyIdButton.Size = UDim2.new(1, -20, 0, 30)
    copyIdButton.Position = UDim2.new(0, 10, 0, 130)
    copyIdButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    copyIdButton.BackgroundTransparency = 0.3
    copyIdButton.TextColor3 = Color3.new(1, 1, 1)
    copyIdButton.Font = Enum.Font.SourceSansBold
    copyIdButton.TextScaled = true
    copyIdButton.Text = "Copy Server ID"
    copyIdButton.Parent = menuFrame
    copyIdButton.AutoButtonColor = true
    local uicornerBtn3 = Instance.new("UICorner")
    uicornerBtn3.CornerRadius = UDim.new(0, 10)
    uicornerBtn3.Parent = copyIdButton

    -- Dòng 5: Dán Server ID để join
    local joinIdInput = Instance.new("TextBox")
    joinIdInput.Size = UDim2.new(1, -20, 0, 30)
    joinIdInput.Position = UDim2.new(0, 10, 0, 170)
    joinIdInput.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    joinIdInput.BackgroundTransparency = 0.3
    joinIdInput.TextColor3 = Color3.new(1, 1, 1)
    joinIdInput.Font = Enum.Font.SourceSans
    joinIdInput.TextScaled = true
    joinIdInput.PlaceholderText = "Dán Server ID để Join"
    joinIdInput.Parent = menuFrame
    joinIdInput.ClearTextOnFocus = true
    local uicornerBtn4 = Instance.new("UICorner")
    uicornerBtn4.CornerRadius = UDim.new(0, 10)
    uicornerBtn4.Parent = joinIdInput

    -- Nút Join Server bằng ID
    local joinByIdButton = Instance.new("TextButton")
    joinByIdButton.Size = UDim2.new(1, -20, 0, 30)
    joinByIdButton.Position = UDim2.new(0, 10, 0, 210)
    joinByIdButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    joinByIdButton.BackgroundTransparency = 0.3
    joinByIdButton.TextColor3 = Color3.new(1, 1, 1)
    joinByIdButton.Font = Enum.Font.SourceSansBold
    joinByIdButton.TextScaled = true
    joinByIdButton.Text = "Join by ID"
    joinByIdButton.Parent = menuFrame
    joinByIdButton.AutoButtonColor = true
    local uicornerBtn5 = Instance.new("UICorner")
    uicornerBtn5.CornerRadius = UDim.new(0, 10)
    uicornerBtn5.Parent = joinByIdButton

    -- Hiệu ứng mở menu
    openButton.MouseButton1Click:Connect(function()
        menuFrame.Visible = not menuFrame.Visible
    end)

    -- Xử lý Rejoin Server
    rejoinButton.MouseButton1Click:Connect(function()
        TeleportService:Teleport(game.PlaceId, player)
    end)

    -- Xử lý Hop Server
    hopButton.MouseButton1Click:Connect(function()
        local servers
        local success, err = pcall(function()
            local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", game.PlaceId)
            local response = HttpService:GetAsync(url)
            servers = HttpService:JSONDecode(response).data
        end)
        if success and servers then
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

    -- Xử lý Copy Server ID
    copyIdButton.MouseButton1Click:Connect(function()
        setclipboard(currentServerId)
        print("Server ID copied: " .. currentServerId)
    end)

    -- Xử lý Join Server bằng ID
    joinByIdButton.MouseButton1Click:Connect(function()
        local serverId = joinIdInput.Text
        if serverId and serverId ~= "" then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, player)
        else
            warn("Please enter a valid server ID.")
        end
    end)
end

-- Chạy UI
createUI()
