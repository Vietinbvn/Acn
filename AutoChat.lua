local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- FPS Label (góc trên phải)
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SimpleFPSandTP"

local fpsLabel = Instance.new("TextLabel", gui)
fpsLabel.Size = UDim2.new(0, 100, 0, 30)
fpsLabel.Position = UDim2.new(1, -110, 0, 10)
fpsLabel.BackgroundColor3 = Color3.fromRGB(30,30,30)
fpsLabel.BorderSizePixel = 0
fpsLabel.TextColor3 = Color3.new(1,1,1)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 18
fpsLabel.Text = "FPS: 0"
fpsLabel.TextStrokeTransparency = 0.7

local lastTime = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastTime >= 1 then
        fpsLabel.Text = "FPS: "..frameCount
        frameCount = 0
        lastTime = now
    end
end)

-- Hàm tìm người chơi theo tên gần đúng (partial match, không phân biệt hoa thường)
local function findPlayerByPartialName(partialName)
    local lowerPartial = partialName:lower()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(lowerPartial, 1, true) then
            return player
        end
    end
    return nil
end

-- Lắng nghe chat lệnh t [tên gần đúng]
LocalPlayer.Chatted:Connect(function(msg)
    local prefix = "t "
    if msg:sub(1, #prefix):lower() == prefix then
        local partialName = msg:sub(#prefix + 1)
        if partialName ~= "" then
            local target = findPlayerByPartialName(partialName)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                print("Đã teleport đến "..target.Name)
            else
                print("Không tìm thấy người chơi phù hợp hoặc họ chưa có nhân vật.")
            end
        end
    end
end)
