local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- === Tạo GUI chính ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportAndESP"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 350)
frame.Position = UDim2.new(0, 20, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "🛸 Teleport & ESP Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = frame

-- Nút tắt/mở menu
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(1, 5, 0, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 24
toggleBtn.Text = "❌"
toggleBtn.Parent = frame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -90)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = frame

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 6)

local espStatusLabel = Instance.new("TextLabel")
espStatusLabel.Size = UDim2.new(1, -20, 0, 30)
espStatusLabel.Position = UDim2.new(0, 10, 1, -35)
espStatusLabel.BackgroundTransparency = 1
espStatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
espStatusLabel.Font = Enum.Font.Gotham
espStatusLabel.TextSize = 16
espStatusLabel.Text = "ESP: Tắt"
espStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
espStatusLabel.Parent = frame

local espToggleBtn = Instance.new("TextButton")
espToggleBtn.Size = UDim2.new(0, 80, 0, 30)
espToggleBtn.Position = UDim2.new(1, -90, 1, -40)
espToggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
espToggleBtn.TextColor3 = Color3.new(1, 1, 1)
espToggleBtn.Font = Enum.Font.GothamBold
espToggleBtn.TextSize = 16
espToggleBtn.Text = "Bật ESP"
espToggleBtn.Parent = frame

-- === Logic teleport ===

local function teleportToPlayer(targetPlayer)
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        warn("Người chơi không có nhân vật hoặc HumanoidRootPart.")
        return
    end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        warn("Không tìm thấy HumanoidRootPart của bạn.")
        return
    end
    local targetHRP = targetPlayer.Character.HumanoidRootPart
    hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 3, 0)
    print("Đã teleport đến " .. targetPlayer.Name)
end

local function createPlayerButton(targetPlayer)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 18
    button.Text = targetPlayer.Name
    button.Parent = scrollFrame

    button.MouseButton1Click:Connect(function()
        teleportToPlayer(targetPlayer)
    end)
    return button
end

local playerButtons = {}

local function refreshPlayerList()
    -- Xóa nút cũ
    for _, btn in pairs(playerButtons) do
        if btn and btn.Parent then
            btn:Destroy()
        end
    end
    playerButtons = {}

    -- Tạo nút mới
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local btn = createPlayerButton(p)
            table.insert(playerButtons, btn)
        end
    end

    -- Cập nhật canvas size
    local contentSize = listLayout.AbsoluteContentSize.Y
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentSize + 10)
end

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
refreshPlayerList()

-- === Logic ESP ===

local espEnabled = false
local highlights = {}

local function createHighlight(p)
    if highlights[p] then return end
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = p.Character
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = Color3.fromRGB(0, 170, 255)
        highlight.OutlineColor = Color3.fromRGB(0, 120, 200)
        highlight.Parent = playerGui
        highlights[p] = highlight
    end
end

local function removeHighlight(p)
    if highlights[p] then
        highlights[p]:Destroy()
        highlights[p] = nil
    end
end

local function enableESP()
    espEnabled = true
    espStatusLabel.Text = "ESP: Bật"
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            createHighlight(p)
        end
    end
end

local function disableESP()
    espEnabled = false
    espStatusLabel.Text = "ESP: Tắt"
    for p, highlight in pairs(highlights) do
        highlight:Destroy()
    end
    highlights = {}
end

espToggleBtn.MouseButton1Click:Connect(function()
    if espEnabled then
        disableESP()
    else
        enableESP()
    end
end)

-- Tối ưu cập nhật ESP khi người chơi vào/ra hoặc respawn

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        wait(1)
        if espEnabled and p ~= player then
            createHighlight(p)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(p)
    removeHighlight(p)
end)

-- === Nút tắt/mở menu ===
local menuVisible = true
toggleBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    frame.Visible = menuVisible
    toggleBtn.Text = menuVisible and "❌" or "☰"
end)
