-- Ducscript - By Duc_Nhat (Fix & Optimize Rayfield)

-- Khởi tạo thư viện UI Rayfield (đảm bảo load 1 lần duy nhất)
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local TeleportPlayer

-- Biến lưu trạng thái và kết nối Speed Boost
local speedBoostConnection = nil
local espEnabled = false

-- UI
local Window = Rayfield:CreateWindow({
    Name = "Ducscript - By Duc_Nhat",
    LoadingTitle = "Ducscript v1.0",
    LoadingSubtitle = "Tạo bởi Duc_Nhat",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- Tab 1: Gameplay
local Tab1 = Window:CreateTab("Gameplay", "🏃‍♂️")

-- Speed Boost Toggle
Tab1:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Callback = function(state)
        if state then
            -- Ngắt kết nối cũ nếu có để tránh trùng lặp
            if speedBoostConnection then
                speedBoostConnection:Disconnect()
            end
            speedBoostConnection = RunService.Stepped:Connect(function()
                pcall(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid.WalkSpeed = 100
                    end
                end)
            end)
        else
            if speedBoostConnection then
                speedBoostConnection:Disconnect()
                speedBoostConnection = nil
            end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    end,
})

-- Jump Boost Toggle
Tab1:CreateToggle({
    Name = "Jump Boost",
    CurrentValue = false,
    Callback = function(state)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if state then
                LocalPlayer.Character.Humanoid.JumpPower = 120
            else
                LocalPlayer.Character.Humanoid.JumpPower = 50
            end
        end
    end,
})

-- Anti-AFK Toggle
Tab1:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Callback = function(state)
        if state then
            local vu = game:GetService("VirtualUser")
            Players.LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end,
})

-- Tab 2: ESP
local Tab2 = Window:CreateTab("ESP", "👁️")

local function createESP(player)
    if player.Character and player.Character:FindFirstChild("Head") and not player.Character.Head:FindFirstChild("ESP") then
        local esp = Instance.new("BillboardGui")
        esp.Name = "ESP"
        esp.Size = UDim2.new(0, 100, 0, 40)
        esp.Adornee = player.Character.Head
        esp.AlwaysOnTop = true
        esp.Parent = player.Character.Head

        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1,0,1,0)
        text.BackgroundTransparency = 1
        text.TextColor3 = Color3.new(1,0,0)
        text.Text = player.Name
        text.TextScaled = true
        text.Parent = esp
    end
end

local function removeESP(player)
    if player.Character and player.Character:FindFirstChild("Head") then
        local esp = player.Character.Head:FindFirstChild("ESP")
        if esp then esp:Destroy() end
    end
end

Tab2:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(state)
        espEnabled = state
        if state then
            -- Tạo ESP cho tất cả người chơi hiện tại
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createESP(player)
                end
            end
            -- Tự động thêm ESP khi có người chơi mới vào
            Players.PlayerAdded:Connect(function(player)
                if espEnabled and player ~= LocalPlayer then
                    player.CharacterAdded:Connect(function()
                        wait(0.1) -- Đợi nhân vật load
                        createESP(player)
                    end)
                end
            end)
            -- Xóa ESP khi người chơi rời
            Players.PlayerRemoving:Connect(function(player)
                removeESP(player)
            end)
        else
            -- Xóa tất cả ESP khi tắt
            for _, player in pairs(Players:GetPlayers()) do
                removeESP(player)
            end
        end
    end
})

-- Tab 3: Teleport
local Tab3 = Window:CreateTab("Teleport", "⚡")

local playerList = {}

local function updatePlayerList()
    playerList = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            table.insert(playerList, v.Name)
        end
    end
    -- Cập nhật dropdown options
    TeleportDropdown:SetOptions(playerList)
end

local TeleportDropdown = Tab3:CreateDropdown({
    Name = "Chọn người để Teleport tới",
    Options = playerList,
    CurrentOption = "",
    Callback = function(value)
        TeleportPlayer = value
    end
})

Tab3:CreateButton({
    Name = "Teleport đến người chơi đã chọn",
    Callback = function()
        if TeleportPlayer then
            local target = Players:FindFirstChild(TeleportPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
})

-- Cập nhật danh sách người chơi khi có người vào hoặc rời
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Khởi tạo danh sách người chơi ban đầu
updatePlayerList()

-- Tab 4: Thông tin
local Tab4 = Window:CreateTab("Thông tin", "ℹ️")
Tab4:CreateParagraph({
    Title = "Script By Duc_Nhat",
    Content = "Phiên bản: 1.0\nUI: Rayfield\nChức năng: ESP, Speed, Jump, Anti-AFK, Teleport"
})

-- Xử lý khi nhân vật load lại (để reset WalkSpeed và JumpPower nếu toggle đang bật)
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1) -- Đợi nhân vật load xong
    local humanoid = character:WaitForChild("Humanoid")
    if speedBoostConnection then
        humanoid.WalkSpeed = 100
    else
        humanoid.WalkSpeed = 16
    end
    -- Jump Boost
    if Tab1:GetToggle("Jump Boost").CurrentValue then
        humanoid.JumpPower = 120
    else
        humanoid.JumpPower = 50
    end
end)
