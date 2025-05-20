-- Ducscript-By Duc_Nhat
-- Version: 1.0

-- Khởi tạo thư viện UI (sử dụng Rayfield UI cho đẹp và có animation)
loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TeleportPlayer

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

Tab1:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Callback = function(state)
        if state then
            game:GetService("RunService").Stepped:Connect(function()
                pcall(function()
                    LocalPlayer.Character.Humanoid.WalkSpeed = 100
                end)
            end)
        else
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end,
})

Tab1:CreateToggle({
    Name = "Jump Boost",
    CurrentValue = false,
    Callback = function(state)
        if state then
            LocalPlayer.Character.Humanoid.JumpPower = 120
        else
            LocalPlayer.Character.Humanoid.JumpPower = 50
        end
    end,
})

Tab1:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Callback = function(state)
        if state then
            local vu = game:GetService("VirtualUser")
            game:GetService("Players").LocalPlayer.Idled:connect(function()
                vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                wait(1)
                vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            end)
        end
    end,
})

-- Tab 2: ESP
local Tab2 = Window:CreateTab("ESP", "👁️")

Tab2:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(state)
        if state then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local esp = Instance.new("BillboardGui", player.Character:WaitForChild("Head"))
                    esp.Name = "ESP"
                    esp.Size = UDim2.new(0, 100, 0, 40)
                    esp.AlwaysOnTop = true

                    local text = Instance.new("TextLabel", esp)
                    text.Size = UDim2.new(1,0,1,0)
                    text.BackgroundTransparency = 1
                    text.TextColor3 = Color3.new(1,0,0)
                    text.Text = player.Name
                    text.TextScaled = true
                end
            end
        else
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("Head") then
                    local esp = player.Character.Head:FindFirstChild("ESP")
                    if esp then esp:Destroy() end
                end
            end
        end
    end
})

-- Tab 3: Teleport
local Tab3 = Window:CreateTab("Teleport", "⚡")

local playerList = {}
for _, v in pairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then
        table.insert(playerList, v.Name)
    end
end

Tab3:CreateDropdown({
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
            if target and target.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
})

-- Tab 4: Thông tin
local Tab4 = Window:CreateTab("Thông tin", "ℹ️")
Tab4:CreateParagraph({Title="Script By Duc_Nhat", Content="Phiên bản: 1.0\nUI: Rayfield\nChức năng: ESP, Speed, Jump, Anti-AFK, Teleport"})
