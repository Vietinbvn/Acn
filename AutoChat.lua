-- Ducscript v1.3 - Không dùng Rayfield UI, thêm nút bật/tắt menu, hiển thị FPS và chat teleport
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Trạng thái
local speedBoost = false
local jumpBoost = false
local antiAFK = false
local espEnabled = false
local speedBoostConnection
local antiAFKConnection
local espConnections = {}

-- UI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DucscriptUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 520)
frame.Position = UDim2.new(0, 50, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local function createButton(text, posY, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = text
    btn.AutoButtonColor = true
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createLabel(text, posY)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -20, 0, 30)
    lbl.Position = UDim2.new(0, 10, 0, posY)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 16
    lbl.Text = text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

-- Nút bật/tắt menu (góc trên trái)
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 80, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18
toggleBtn.Text = "Menu"

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    toggleBtn.Text = frame.Visible and "Menu" or "Hiện"
end)

-- FPS Label (góc trên phải)
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

-- Speed Boost
createLabel("Speed Boost:", 10)
local speedBtn = createButton("Bật", 40, function()
    speedBoost = not speedBoost
    speedBtn.Text = speedBoost and "Tắt" or "Bật"
    if speedBoost then
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
end)

-- Jump Boost
createLabel("Jump Boost:", 90)
local jumpBtn = createButton("Bật", 120, function()
    jumpBoost = not jumpBoost
    jumpBtn.Text = jumpBoost and "Tắt" or "Bật"
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = jumpBoost and 120 or 50
    end
end)

-- Anti-AFK
createLabel("Anti-AFK:", 170)
local afkBtn = createButton("Bật", 200, function()
    antiAFK = not antiAFK
    afkBtn.Text = antiAFK and "Tắt" or "Bật"
    if antiAFKConnection then antiAFKConnection:Disconnect() end
    if antiAFK then
        local vu = game:GetService("VirtualUser")
        antiAFKConnection = Players.LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

-- ESP
createLabel("Player ESP:", 250)
local espBtn = createButton("Bật", 280, function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "Tắt" or "Bật"
    if espEnabled then
        -- Setup ESP
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
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
                espConnections[player] = player.CharacterAdded:Connect(function()
                    wait(0.2)
                    if player.Character and player.Character:FindFirstChild("Head") then
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
                end)
            end
        end
        espConnections["PlayerAdded"] = Players.PlayerAdded:Connect(function(player)
            if player ~= LocalPlayer then
                player.CharacterAdded:Connect(function()
                    wait(0.2)
                    if player.Character and player.Character:FindFirstChild("Head") then
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
                end)
            end
        end)
    else
        -- Cleanup ESP
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Head") then
                local esp = player.Character.Head:FindFirstChild("ESP")
                if esp then esp:Destroy() end
            end
        end
        for _, conn in pairs(espConnections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        espConnections = {}
    end
end)

-- Teleport bằng UI
createLabel("Teleport đến người chơi:", 330)
local teleportInput = Instance.new("TextBox", frame)
teleportInput.Size = UDim2.new(1, -20, 0, 30)
teleportInput.Position = UDim2.new(0, 10, 0, 360)
teleportInput.PlaceholderText = "Nhập tên người chơi..."
teleportInput.BackgroundColor3 = Color3.fromRGB(50,50,50)
teleportInput.TextColor3 = Color3.new(1,1,1)
teleportInput.Font = Enum.Font.Gotham
teleportInput.TextSize = 16

local teleportBtn = createButton("Teleport", 400, function()
    local targetName = teleportInput.Text
    if targetName ~= "" then
        local target = Players:FindFirstChild(targetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)

-- Thông tin
local infoLabel = Instance.new("TextLabel", frame)
infoLabel.Size = UDim2.new(1, -20, 0, 60)
infoLabel.Position = UDim2.new(0, 10, 0, 450)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.new(1,1,1)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 14
infoLabel.Text = "Script By Duc_Nhat\nChức năng: ESP, Speed, Jump, Anti-AFK, Teleport\nKhông dùng Rayfield UI"

-- Khi nhân vật load lại
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = speedBoost and 100 or 16
    humanoid.JumpPower = jumpBoost and 120 or 50
end)

-- Teleport bằng lệnh chat: "tp tên_người_chơi"
LocalPlayer.Chatted:Connect(function(msg)
    local prefix = "tp "
    if msg:sub(1, #prefix):lower() == prefix then
        local targetName = msg:sub(#prefix + 1)
        if targetName ~= "" then
            local target = Players:FindFirstChild(targetName)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                print("Đã teleport đến "..targetName)
            else
                print("Không tìm thấy người chơi hoặc họ chưa có nhân vật.")
            end
        end
    end
end)
