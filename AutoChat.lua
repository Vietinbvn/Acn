local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

-- Hiển thị chữ khi bắt đầu
local splashText = Instance.new("TextLabel")
splashText.Size = UDim2.new(1, 0, 1, 0)
splashText.BackgroundColor3 = Color3.new(0, 0, 0)
splashText.TextColor3 = Color3.new(1, 1, 1)
splashText.Text = "DucScript-By Duc_Nhat"
splashText.TextScaled = true
splashText.TextTransparency = 1
splashText.Parent = screenGui

local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenIn = TweenService:Create(splashText, tweenInfo, { TextTransparency = 0 })
local tweenOut = TweenService:Create(splashText, tweenInfo, { TextTransparency = 1 })

tweenIn:Play()
tweenIn.Completed:Wait()
wait(5)
tweenOut:Play()
tweenOut.Completed:Wait()
splashText:Destroy()

-- Tạo Frame UI chính
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 150)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Tạo TextLabel hiển thị thông tin
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -10, 1, -10)
infoLabel.Position = UDim2.new(0, 5, 0, 5)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.new(1, 1, 1)
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.TextWrapped = true
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextSize = 14
infoLabel.Parent = mainFrame

-- Cập nhật thông tin mỗi giây
RunService.RenderStepped:Connect(function()
    local ping = Stats.Network.ServerStatsItem and Stats.Network.ServerStatsItem["Data Ping"] and Stats.Network.ServerStatsItem["Data Ping"].Value or 0
    local serverTime = os.date("%X", os.time())
    local version = game.PlaceVersion or "Unknown"
    local fps = math.floor(1 / RunService.RenderStepped:Wait())

    infoLabel.Text = string.format(
        "Ping: %d ms\nFPS: %d\nThời gian Server: %s\nPhiên bản máy chủ: %s",
        ping, fps, serverTime, version
    )
end)
