-- Tạo GUI
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoChatGUI"

local toggleMenuBtn = Instance.new("TextButton")
toggleMenuBtn.Size = UDim2.new(0, 100, 0, 30)
toggleMenuBtn.Position = UDim2.new(0, 10, 0, 10)
toggleMenuBtn.Text = "Hiện Menu"
toggleMenuBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
toggleMenuBtn.Parent = gui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0, 10, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false
frame.Parent = gui

local messageBox = Instance.new("TextBox")
messageBox.Size = UDim2.new(1, -20, 0, 30)
messageBox.Position = UDim2.new(0, 10, 0, 10)
messageBox.PlaceholderText = "Nhập tin nhắn..."
messageBox.Text = ""
messageBox.Parent = frame

local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(1, -20, 0, 30)
delayBox.Position = UDim2.new(0, 10, 0, 50)
delayBox.PlaceholderText = "Thời gian (giây)"
delayBox.Text = "5"
delayBox.Parent = frame

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(1, -20, 0, 30)
startBtn.Position = UDim2.new(0, 10, 0, 90)
startBtn.Text = "Bắt đầu"
startBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.Parent = frame

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(1, -20, 0, 30)
stopBtn.Position = UDim2.new(0, 10, 0, 130)
stopBtn.Text = "Dừng"
stopBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Parent = frame

local autoChatRunning = false

-- Hiện / ẩn menu
toggleMenuBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    toggleMenuBtn.Text = frame.Visible and "Ẩn Menu" or "Hiện Menu"
end)

-- Hàm gửi chat
local function startAutoChat()
    autoChatRunning = true
    coroutine.wrap(function()
        while autoChatRunning do
            local msg = messageBox.Text
            local delayTime = tonumber(delayBox.Text) or 5

            if msg ~= "" and ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") then
                ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
            end
            wait(delayTime)
        end
    end)()
end

-- Nút bắt đầu
startBtn.MouseButton1Click:Connect(function()
    if not autoChatRunning then
        startAutoChat()
    end
end)

-- Nút dừng
stopBtn.MouseButton1Click:Connect(function()
    autoChatRunning = false
end)
