-- Ducscript - By Duc_Nhat (Fix + Improve)
-- Rayfield UI chuẩn: https://github.com/shlexware/Rayfield

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Biến lưu trạng thái
local speedBoostConnection
local antiAFKConnection
local espEnabled = false
local espConnections = {}

-- UI
local Window = Rayfield:CreateWindow({
    Name = "Ducscript - By Duc_Nhat",
    LoadingTitle = "Ducscript v1.0",
    LoadingSubtitle = "Tạo bởi Duc_Nhat",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

-- Tab 1: Gameplay
local Tab1 = Window:CreateTab("Gameplay", "🏃‍♂️")

Tab1:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Callback = function(state)
        if state then
            if speedBoostConnection then speedBoostConnection:Disconnect() end
            speedBoostConnection = RunService.Stepped:Connect(function()
                pcall(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid.WalkSpeed = 100
                    end
                end)
            end)
        else
            if speedBoostConnection then speedBoostConnection:Disconnect() end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    end,
})

Tab1:CreateToggle({
    Name = "Jump Boost",
    CurrentValue = false,
    Callback = function(state)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = state and 120 or 50
        end
    end,
})

Tab1:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Callback = function(state)
        if antiAFKConnection then antiAFKConnection:Disconnect() end
        if state then
            local vu = game:GetService("VirtualUser")
            antiAFKConnection = Players.LocalPlayer.Idled:Connect(function()
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

local function setupESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESP(player)
            espConnections[player] = player.CharacterAdded:Connect(function()
                wait(0.2)
                createESP(player)
            end)
        end
    end
    espConnections["PlayerAdded"] = Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            player.CharacterAdded:Connect(function()
                wait(0.2)
                createESP(player)
            end)
        end
    end)
end

local function cleanupESP()
    for _, player in ipairs(Players:GetPlayers()) do
        removeESP(player)
    end
    for _, conn in pairs(espConnections) do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        end
    end
    espConnections = {}
end

Tab2:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(state)
        espEnabled = state
        if state then
            setupESP()
        else
            cleanupESP()
        end
    end
})

-- Tab 3: Teleport
local Tab3 = Window:CreateTab("Teleport", "⚡")

local playerList = {}
local function updatePlayerList()
    playerList = {}
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            table.insert(playerList, v.Name)
        end
    end
    if Tab3TeleportDropdown then
        Tab3TeleportDropdown:SetOptions(playerList)
    end
end

local TeleportPlayer
local Tab3TeleportDropdown = Tab3:CreateDropdown({
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
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
})

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

-- Tab 4: Thông tin
local Tab4 = Window:CreateTab("Thông tin", "ℹ️")
Tab4:CreateParagraph({
    Title = "Script By Duc_Nhat",
    Content = "Phiên bản: 1.0\nUI: Rayfield\nChức năng: ESP, Speed, Jump, Anti-AFK, Teleport"
})

-- Đảm bảo khi nhân vật load lại sẽ cập nhật đúng trạng thái
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1)
    local humanoid = character:WaitForChild("Humanoid")
    -- Speed
    if speedBoostConnection then
        humanoid.WalkSpeed = 100
    else
        humanoid.WalkSpeed = 16
    end
    -- Jump
    if Tab1:GetToggle("Jump Boost") and Tab1:GetToggle("Jump Boost").CurrentValue then
        humanoid.JumpPower = 120
    else
        humanoid.JumpPower = 50
    end
end)
