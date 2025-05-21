-- Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Phiên bản game
local gameVersion = "1.0.0"

-- Key bảo mật
local correctKey = "DucDepTrai"
local keyValidated = false

-- ================= AntiBan đơn giản =================
local AntiBan = {}

function AntiBan.ProtectErrors()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "Destroy" then
            warn("[AntiBan] Ngăn chặn gọi phương thức: " .. method)
            return nil
        end
        return oldNamecall(self, ...)
    end)

    setreadonly(mt, true)
end

function AntiBan.AutoReconnect()
    player.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Failed then
            TeleportService:Teleport(game.PlaceId, player)
        end
    end)
end

function AntiBan.LimitClicks()
    local lastClickTime = 0
    local minInterval = 0.2

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local now = tick()
            if now - lastClickTime < minInterval then
                warn("[AntiBan] Click quá nhanh, bỏ qua")
            else
                lastClickTime = now
            end
        end
    end)
end

function AntiBan.HideLogs()
    local oldPrint = print
    print = function(...)
        local args = {...}
        for _, v in ipairs(args) do
            local s = tostring(v):lower()
            if s:find("cheat") or s:find("hack") then
                return
            end
        end
        oldPrint(...)
    end
end

function AntiBan.Start()
    pcall(AntiBan.ProtectErrors)
    pcall(AntiBan.AutoReconnect)
    pcall(AntiBan.LimitClicks)
    pcall(AntiBan.HideLogs)
    print("[AntiBan] Hệ thống chống ban đã kích hoạt.")
end

-- ================= Tạo UI =================

local function createBlackScreen()
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

    wait(5)
    blackScreen:Destroy()
end

local function createMenu()
    local menuGui = Instance.new("ScreenGui")
    menuGui.Name = "MenuGui"
    menuGui.ResetOnSpawn = false
    menuGui.Parent = playerGui

    -- Nút mở menu nhỏ góc trên trái
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
    openButton.BorderSizePixel = 0

    -- Menu chính (ẩn ban đầu)
    local menuFrame = Instance.new("Frame")
    menuFrame.Size = UDim2.new(0, 250, 0, 160)
    menuFrame.Position = UDim2.new(0, 10, 0, 70)
    menuFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    menuFrame.BackgroundTransparency = 0.5
    menuFrame.Parent = menuGui
    menuFrame.Visible = false
    menuFrame.ClipsDescendants = true
    menuFrame.BorderSizePixel = 0
    menuFrame.ZIndex = 4

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 15)
    uicorner.Parent = menuFrame

    -- Hàm tạo label dòng
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

    -- Phiên bản game
    local versionLabel = createMenuLine("Phiên bản game: " .. gameVersion, 10)

    -- Nút Rejoin
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

    -- Nút Hop Server
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

    -- Nút Old Server >=1 ngày
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

    -- Hàm lấy danh sách server public
    local function getServers()
        local servers = {}
        local success, err = pcall(function()
            local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", game.PlaceId)
            local response = HttpService:GetAsync(url)
            servers = HttpService:JSONDecode(response).data
        end)
        if success then
            return servers
        else
            warn("Lỗi lấy server list:", err)
            return nil
        end
    end

    -- Xử lý nút Rejoin
    rejoinButton.MouseButton1Click:Connect(function()
        TeleportService:Teleport(game.PlaceId, player)
    end)

    -- Xử lý nút Hop Server
    hopButton.MouseButton1Click:Connect(function()
        local servers = getServers()
        if not servers then return end

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
    end)

    -- Xử lý nút Old Server >=1 ngày
    oldServerButton.MouseButton1Click:Connect(function()
        local servers = getServers()
        if not servers then return end

        local now = os.time()
        local oneDaySeconds = 24 * 60 * 60
        local oldServers = {}

        for _, server in pairs(servers) do
            if server.playing > 0 and server.id ~= game.JobId then
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
    end)

    -- Yêu cầu nhập key khi mở menu lần đầu
    openButton.MouseButton1Click:Connect(function()
        if not keyValidated then
            -- Tạo popup nhập key
            local keyGui = Instance.new("ScreenGui")
            keyGui.Name = "KeyGui"
            keyGui.Parent = playerGui

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 300, 0, 150)
            frame.Position = UDim2.new(0.5, -150, 0.5, -75)
            frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            frame.BackgroundTransparency = 0.3
            frame.ClipsDescendants = true
            frame.BorderSizePixel = 0
            frame.Parent = keyGui

            local uicorner = Instance.new("UICorner")
            uicorner.CornerRadius = UDim.new(0, 15)
            uicorner.Parent = frame

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, 0, 0, 30)
            title.Position = UDim2.new(0, 0, 0, 10)
            title.BackgroundTransparency = 1
            title.Text = "Nhập Key để mở Menu"
            title.TextColor3 = Color3.new(1, 1, 1)
            title.Font = Enum.Font.SourceSansBold
            title.TextScaled = true
            title.Parent = frame

            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(1, -40, 0, 40)
            textBox.Position = UDim2.new(0, 20, 0, 60)
            textBox.ClearTextOnFocus = false
            textBox.PlaceholderText = "Nhập key ở đây..."
            textBox.Text = ""
            textBox.TextColor3 = Color3.new(1,1,1)
            textBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            textBox.Parent = frame
            textBox.Font = Enum.Font.SourceSans
            textBox.TextScaled = true
            textBox.ClipsDescendants = true
            local uicornerText = Instance.new("UICorner")
            uicornerText.CornerRadius = UDim.new(0, 10)
            uicornerText.Parent = textBox

            local submitBtn = Instance.new("TextButton")
            submitBtn.Size = UDim2.new(0, 100, 0, 30)
            submitBtn.Position = UDim2.new(0.5, -50, 1, -40)
            submitBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
            submitBtn.TextColor3 = Color3.new(1,1,1)
            submitBtn.Font = Enum.Font.SourceSansBold
            submitBtn.TextScaled = true
            submitBtn.Text = "Xác nhận"
            submitBtn.Parent = frame
            local uicornerBtn = Instance.new("UICorner")
            uicornerBtn.CornerRadius = UDim.new(0, 10)
            uicornerBtn.Parent = submitBtn

            submitBtn.MouseButton1Click:Connect(function()
                local inputKey = textBox.Text
                if inputKey == correctKey then
                    keyValidated = true
                    menuFrame.Visible = true
                    keyGui:Destroy()
                else
                    textBox.Text = ""
                    textBox.PlaceholderText = "Sai key, thử lại!"
                end
            end)
        else
            menuFrame.Visible = not menuFrame.Visible
        end
    end)
end

-- ================= Chạy chính =================

createBlackScreen()
AntiBan.Start()
createMenu()
