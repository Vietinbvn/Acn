local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Tạo GUI (giống script trước)
-- ...

-- Hàm gửi tin nhắn với random delay và thay đổi nhẹ nội dung
local function sendSafeMessage(baseMsg)
    -- Thêm ký tự ngẫu nhiên nhỏ để tránh spam giống hệt
    local suffix = tostring(math.random(100,999))
    local msg = baseMsg .. " " .. suffix

    local ChatEvent = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
    ChatEvent:FireServer(msg, "All")
end

-- Hàm random thời gian delay giữa các tin nhắn (10-20 giây)
local function getRandomInterval()
    return math.random(10,20)
end

-- Coroutine gửi tin nhắn an toàn
local messageCoroutine

toggleBtn.MouseButton1Click:Connect(function()
    if not isRunning then
        message = msgBox.Text
        if message == nil or message == "" then
            warn("Vui lòng nhập nội dung tin nhắn!")
            return
        end

        isRunning = true
        toggleBtn.Text = "Dừng"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)

        messageCoroutine = coroutine.create(function()
            while isRunning do
                sendSafeMessage(message)
                wait(getRandomInterval())
            end
        end)
        coroutine.resume(messageCoroutine)
    else
        isRunning = false
        toggleBtn.Text = "Bắt đầu"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    end
end)

-- Bạn có thể thêm logic theo dõi cảnh báo hoặc giới hạn chat nếu Roblox cung cấp API (hiện Roblox không công khai)
