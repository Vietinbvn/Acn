local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- === Tạo ScreenGui ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportAndESP"
screenGui.Parent = playerGui

-- === Frame chính (menu đầy đủ) ===
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 400)
frame.Position = UDim2.new(0, 20, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true

local frameUICorner = Instance.new("UICorner")
frameUICorner.CornerRadius = UDim.new(0, 16)
frameUICorner.Parent = frame

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
title.BorderSizePixel = 0
title.Text = "🛸 Teleport & ESP Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 26
title.Parent = frame

local titleUICorner = Instance.new("UICorner")
titleUICorner.CornerRadius = UDim.new(0, 16)
titleUICorner.Parent = title

-- Nút thu nhỏ (X)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 45, 0, 45)
toggleBtn.Position = UDim2.new(1, -55, 0, 2)
toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 28
toggleBtn.Text = "❌"
toggleBtn.Parent = frame

local toggleUICorner = Instance.new("UICorner")
toggleUICorner.CornerRadius = UDim.new(0, 12)
toggleUICorner.Parent = toggleBtn

-- Thanh tìm kiếm
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -20, 0, 35)
searchBox.Position = UDim2.new(0, 10, 0, 60)
searchBox.PlaceholderText = "🔍 Tìm người chơi..."
searchBox.Text = ""
searchBox.ClearTextOnFocus = false
searchBox.TextColor3 = Color3.new(1,1,1)
searchBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 18
searchBox.Parent = frame

local searchUICorner = Instance.new("UICorner")
searchUICorner.CornerRadius = UDim.new(0, 10)
searchUICorner.Parent = searchBox

-- ScrollFrame chứa danh sách người chơi
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -130)
scrollFrame.Position = UDim2.new(0, 10, 0, 100)
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

-- Thông báo trạng thái nhỏ
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 1, -85)
statusLabel.BackgroundTransparency = 0.6
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextSize = 16
statusLabel.Text = ""
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Visible = false
statusLabel.Parent = frame

local statusUICorner = Instance.new("UICorner")
statusUICorner.CornerRadius = UDim.new(0, 8)
statusUICorner.Parent = statusLabel

-- === Nút thu nhỏ menu (hình tròn) ===
local miniButton = Instance.new("TextButton")
miniButton.Size = UDim2.new(0, 50, 0, 50)
miniButton.Position = UDim2.new(0, 20, 0, 50)
miniButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
miniButton.TextColor3 = Color3.new(1,1,1)
miniButton.Font = Enum.Font.GothamBold
miniButton.TextSize = 30
miniButton.Text = "🛸"
miniButton.Visible = false
miniButton.Parent = screenGui

local miniUICorner = Instance.new("UICorner")
miniUICorner.CornerRadius = UDim.new(1, 0)
miniUICorner.Parent = miniButton

-- === Hàm hiển thị thông báo trạng thái ===
local function showStatus(text, duration)
    statusLabel.Text = text
    statusLabel.Visible = true
    delay(duration or 3, function()
        statusLabel.Visible = false
    end)
end

-- === Logic teleport ===
local function teleportToPlayer(targetPlayer)
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        showStatus("Người chơi không có nhân vật hoặc HumanoidRootPart.")
        return
    end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        showStatus("Không tìm thấy HumanoidRootPart của bạn.")
        return
    end
    local targetHRP = targetPlayer.Character.HumanoidRootPart
    hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 3, 0)
    showStatus("Đã teleport đến " .. targetPlayer.Name)
end

-- === Tạo nút người chơi trong danh sách ===
local playerButtons = {}

local function createPlayerButton(targetPlayer)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 38)
    button.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 19
    button.Text = targetPlayer.Name
    button.Parent = scrollFrame

    local buttonUICorner = Instance.new("UICorner")
    buttonUICorner.CornerRadius = UDim.new(0, 12)
    buttonUICorner.Parent = button

    -- Hiệu ứng hover
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 95)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 65)}):Play()
    end)

    button.MouseButton1Click:Connect(function()
        teleportToPlayer(targetPlayer)
    end)
    return button
end

-- === Cập nhật danh sách người chơi theo filter ===
local function refreshPlayerList(filter)
    for _, btn in pairs(playerButtons) do
        if btn and btn.Parent then
            btn:Destroy()
        end
    end
    playerButtons = {}

    filter = filter and filter:lower() or ""
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Name:lower():find(filter) then
            local btn = createPlayerButton(p)
            table.insert(playerButtons, btn)
        end
    end

    local contentSize = listLayout.AbsoluteContentSize.Y
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentSize + 10)
end

Players.PlayerAdded:Connect(function()
    refreshPlayerList(searchBox.Text)
end)
Players.PlayerRemoving:Connect(function()
    refreshPlayerList(searchBox.Text)
end)

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    refreshPlayerList(searchBox.Text)
end)

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
        showStatus("ESP đã tắt")
    else
        enableESP()
        showStatus("ESP đã bật")
    end
end)

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

-- === Nút thu nhỏ menu ===
local menuVisible = true
toggleBtn.MouseButton1Click:Connect(function()
    menuVisible = false
    -- Ẩn frame với tween
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0, 20, 0, -frame.AbsoluteSize.Y - 20),
        Size = UDim2.new(0, 320, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    -- Hiện nút mini sau tween xong
    delay(0.3, function()
        frame.Visible = false
        frame.Size = UDim2.new(0, 320, 0, 400)
        frame.Position = UDim2.new(0, 20, 0, 50)
        frame.BackgroundTransparency = 0
        miniButton.Visible = true
    end)
    toggleBtn.Text = "☰"
end)

-- === Nút mở menu từ nút thu nhỏ ===
miniButton.MouseButton1Click:Connect(function()
    miniButton.Visible = false
    frame.Visible = true
    -- Hiện frame với tween
    frame.Position = UDim2.new(0, 20, 0, -frame.AbsoluteSize.Y - 20)
    frame.BackgroundTransparency = 1
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0, 20, 0, 50),
        BackgroundTransparency = 0
    }):Play()
    menuVisible = true
    toggleBtn.Text = "❌"
end)
