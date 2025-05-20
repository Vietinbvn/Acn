-- Ducscript Không UI - Điều khiển bằng lệnh chat
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Trạng thái
local speedOn = false
local jumpOn = false
local espOn = false
local antiAFKOn = false
local speedConn
local afkConn
local espConnections = {}

-- SPEED
function enableSpeed()
    if speedConn then speedConn:Disconnect() end
    speedConn = RunService.Stepped:Connect(function()
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 100
            end
        end)
    end)
    speedOn = true
end

function disableSpeed()
    if speedConn then speedConn:Disconnect() end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
    speedOn = false
end

-- JUMP
function enableJump()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 120
    end
    jumpOn = true
end

function disableJump()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
    jumpOn = false
end

-- ANTI AFK
function enableAFK()
    if afkConn then afkConn:Disconnect() end
    local vu = game:GetService("VirtualUser")
    afkConn = LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
    antiAFKOn = true
end

function disableAFK()
    if afkConn then afkConn:Disconnect() end
    antiAFKOn = false
end

-- ESP
function createESP(player)
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

function removeESP(player)
    if player.Character and player.Character:FindFirstChild("Head") then
        local esp = player.Character.Head:FindFirstChild("ESP")
        if esp then esp:Destroy() end
    end
end

function enableESP()
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
    espOn = true
end

function disableESP()
    for _, player in ipairs(Players:GetPlayers()) do
        removeESP(player)
    end
    for _, conn in pairs(espConnections) do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        end
    end
    espConnections = {}
    espOn = false
end

-- TELEPORT
function teleportToPlayer(name)
    local target = Players:FindFirstChild(name)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end

-- LỆNH CHAT
LocalPlayer.Chatted:Connect(function(msg)
    msg = msg:lower()
    if msg == "/speed on" then
        enableSpeed()
        print("[Ducscript] Speed ON")
    elseif msg == "/speed off" then
        disableSpeed()
        print("[Ducscript] Speed OFF")
    elseif msg == "/jump on" then
        enableJump()
        print("[Ducscript] Jump ON")
    elseif msg == "/jump off" then
        disableJump()
        print("[Ducscript] Jump OFF")
    elseif msg == "/esp on" then
        enableESP()
        print("[Ducscript] ESP ON")
    elseif msg == "/esp off" then
        disableESP()
        print("[Ducscript] ESP OFF")
    elseif msg == "/afk on" then
        enableAFK()
        print("[Ducscript] Anti-AFK ON")
    elseif msg == "/afk off" then
        disableAFK()
        print("[Ducscript] Anti-AFK OFF")
    elseif msg:sub(1,4) == "/tp " then
        local name = msg:sub(5)
        teleportToPlayer(name)
        print("[Ducscript] Teleport to " .. name)
    end
end)

-- TỰ ĐỘNG RESET KHI NHÂN VẬT LOAD LẠI
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1)
    local humanoid = character:WaitForChild("Humanoid")
    if speedOn then
        humanoid.WalkSpeed = 100
    else
        humanoid.WalkSpeed = 16
    end
    if jumpOn then
        humanoid.JumpPower = 120
    else
        humanoid.JumpPower = 50
    end
end)

print("Ducscript không UI đã load! Gõ lệnh vào chat để dùng.")
