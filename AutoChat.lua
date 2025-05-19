local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Tạo ScreenGui và Frame
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoMessageGui"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "Auto Message Bot"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = frame

-- Nút ẩn/hiện menu
local toggleMenuBtn = Instance.new("TextButton")
toggleMenuBtn.Size = UDim2.new(0, 60, 0, 25)
toggleMenuBtn.Position = UDim2.new(1, -65, 0, 2)
toggleMenuBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleMenuBtn.Text = "Ẩn"
toggleMenuBtn.TextColor3 = Color3.new(1, 1, 1)
toggleMenuBtn.Font = Enum.Font.SourceSansBold
toggleMenuBtn.TextSize = 14
toggleMenuBtn.Parent = frame

-- Các thành phần trong menu (để dễ ẩn hiện)
local menuElements = {}

-- Nội dung nhắn
local msgLabel = Instance.new("TextLabel")
msgLabel.Size = UDim2.new(1, -20, 0, 25)
msgLabel.Position = UDim2.new(0, 10, 0, 40)
msgLabel.BackgroundTransparency = 1
msgLabel.Text = "Nội dung nhắn:"
msgLabel.TextColor3 = Color3.new(1, 1, 1)
msgLabel.Font = Enum.Font.SourceSans
msgLabel.TextSize = 18
msgLabel.TextXAlignment = Enum.TextXAlignment.Left
msgLabel.Parent = frame
table.insert(menuElements, msgLabel)

local msgBox = Instance.new("TextBox")
msgBox.Size = UDim2.new(1, -20, 0, 30)
msgBox.Position = UDim2.new(0, 10, 0, 65)
msgBox.PlaceholderText = "Nhập nội dung tin nhắn..."
msgBox.Text = ""
msgBox.ClearTextOnFocus = false
msgBox.TextColor3 = Color3.new(0, 0, 0)
msgBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
msgBox.Font = Enum.Font.SourceSans
msgBox.TextSize = 18
msgBox.Parent = frame
table.insert(menuElements, msgBox)

-- Thời gian lặp lại
local timeLabel = Instance.new("TextLabel")
timeLabel.Size = UDim2.new(1, -20, 0, 25)
timeLabel.Position = UDim2.new(0, 10, 0, 100)
timeLabel.BackgroundTransparency = 1
timeLabel.Text = "Thời gian lặp lại (giây):"
timeLabel.TextColor3 = Color3.new(1, 1, 1)
timeLabel.Font = Enum.Font.SourceSans
timeLabel.TextSize = 18
timeLabel.TextXAlignment = Enum.TextXAlignment.Left
timeLabel.Parent = frame
table.insert(menuElements, timeLabel)

local timeBox = Instance.new("TextBox")
timeBox.Size = UDim2.new(1, -20, 0, 30)
timeBox.Position = UDim2.new(0, 10, 0, 125)
timeBox.PlaceholderText = "Nhập số giây..."
timeBox.Text = ""
timeBox.ClearTextOnFocus = false
timeBox.TextColor3 = Color3.new(0, 0, 0)
timeBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
timeBox.Font = Enum.Font.SourceSans
timeBox.TextSize = 18
timeBox.Parent = frame
table.insert(menuElements, timeBox)

-- Nút Bật/Tắt
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 100, 0, 35)
toggleBtn.Position = UDim2.new(0.5, -50, 1, -45)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
toggleBtn.Text = "Bắt đầu"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20
toggleBtn.Parent = frame
table.insert(menuElements, toggleBtn)

-- Biến trạng thái
local isRunning = false
local message = ""
local interval = 5

-- Hàm gửi tin nhắn chat
local function sendMessage(msg)
    if msg ~= "" then
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
    end
end

-- Coroutine gửi tin nhắn lặp lại
local messageCoroutine

toggleBtn.MouseButton1Click:Connect(function()
    if not isRunning then
        message = msgBox.Text
        interval = tonumber(timeBox.Text)

        if message == "" then
            warn("Vui lòng nhập nội dung tin nhắn!")
            return
        end
        if not interval or interval < 1 then
            warn("Thời gian lặp lại phải là số nguyên lớn hơn hoặc bằng 1 giây!")
            return
        end

        isRunning = true
        toggleBtn.Text = "Dừng"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)

        -- Tạo coroutine gửi tin nhắn
        messageCoroutine = coroutine.create(function()
            while isRunning do
                sendMessage(message)
                wait(interval)
            end
        end)
        coroutine.resume(messageCoroutine)
    else
        isRunning = false
        toggleBtn.Text = "Bắt đầu"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    end
end)

-- Xử lý nút ẩn/hiện menu
toggleMenuBtn.MouseButton1Click:Connect(function()
    if menuElements[1].Visible then
        -- Ẩn tất cả thành phần
        for _, element in pairs(menuElements) do
            element.Visible = false
        end
        toggleMenuBtn.Text = "Hiện"
        -- Thu nhỏ frame để chỉ còn tiêu đề + nút
        frame.Size = UDim2.new(0, 300, 0, 35)
    else
        -- Hiện lại tất cả thành phần
        for _, element in pairs(menuElements) do
            element.Visible = true
        end
        toggleMenuBtn.Text = "Ẩn"
        frame.Size = UDim2.new(0, 300, 0, 180)
    end
end)
