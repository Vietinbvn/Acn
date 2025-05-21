-- Tạo GUI đơn giản
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "AutoChatGUI"

Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Parent = ScreenGui

ToggleButton.Size = UDim2.new(1, 0, 1, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
ToggleButton.Text = "Auto Chat: OFF"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Parent = Frame

-- Auto chat logic
local autoChatEnabled = false
local chatMessages = {
    "Chào mọi người!",
    "Tôi đang dùng script riêng của mình!",
    "Bạn có khỏe không?",
    "Script này tự động chat!"
}

local function autoChat()
    while autoChatEnabled do
        local message = chatMessages[math.random(1, #chatMessages)]
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
        wait(5) -- Chat mỗi 5 giây
    end
end

-- Bắt sự kiện khi bấm nút
ToggleButton.MouseButton1Click:Connect(function()
    autoChatEnabled = not autoChatEnabled
    ToggleButton.Text = autoChatEnabled and "Auto Chat: ON" or "Auto Chat: OFF"

    if autoChatEnabled then
        coroutine.wrap(autoChat)()
    end
end)

