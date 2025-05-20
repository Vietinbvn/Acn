local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- === Tạo GUI chính ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportAndESP"
screenGui.Parent = playerGui

-- Khung chính
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 380)
frame.Position = UDim2.new(0, 20, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true

-- Bo tròn cho frame
local frameUICorner = Instance.new("UICorner")
frameUICorner.CornerRadius = UDim.new(0, 12)
frameUICorner.Parent = frame

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
title.BorderSizePixel = 0
title.Text = "🛸 Teleport & ESP Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = frame

local titleUICorner = Instance.new("UICorner")
titleUICorner.CornerRadius = UDim.new(0, 12)
titleUICorner.Parent = title

-- Nút tắt/mở menu
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 45, 0, 45)
toggleBtn.Position = UDim2.new(1, -50, 0, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 28
toggleBtn.Text = "❌"
toggleBtn.Parent = frame

local toggleUICorner = Instance.new("UICorner")
toggleUICorner.CornerRadius = UDim.new(0, 12)
toggleUICorner.Parent = toggleBtn

-- ScrollFrame chứa danh sách người chơi
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -120)
scrollFrame.Position = UDim2.new(0, 10, 0, 60)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 8
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = frame

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8)

-- Label trạng thái ESP
local espStatusLabel = Instance.new("TextLabel")
espStatusLabel.Size = UDim2.new(1, -20, 0, 30)
espStatusLabel.Position = UDim2.new(0, 10, 1, -50)
espStatusLabel.BackgroundTransparency = 1
espStatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
espStatusLabel.Font = Enum.Font.Gotham
espStatusLabel.TextSize = 16
espStatusLabel.Text = "ESP: Tắt"
espStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
espStatusLabel.Parent = frame

-- Nút bật/tắt ESP
local espToggleBtn = Instance.new("TextButton")
espToggleBtn.Size = UDim2.new(0, 90, 0, 35)
espToggleBtn.Position = UDim2.new(1, -110, 1, -55)
espToggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
espToggleBtn.TextColor3 = Color3.new(1, 1, 1)
espToggleBtn.Font = Enum.Font.GothamBold
espToggleBtn.TextSize = 18
espToggleBtn.Text = "Bật ESP"
espToggleBtn.Parent = frame

local espToggleUICorner = Instance.new("UICorner")
espToggleUICorner.CornerRadius = UDim.new(0, 12)
espToggleUICorner.Parent = espToggleBtn

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
    button.Size = UDim2.new(1, -20, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 18
    button.Text = targetPlayer.Name
    button.Parent = scrollFrame

    local buttonUICorner = Instance.new("UICorner")
    buttonUICorner.CornerRadius = UDim.new(0, 10)
    buttonUICorner.Parent = button

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
