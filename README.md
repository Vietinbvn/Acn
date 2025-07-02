local selectedFont = Enum.Font.Arcade

local function changeFontInGui(gui)
    for _, obj in pairs(gui:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            obj.Font = selectedFont
        end
    end
end

local player = game.Players.LocalPlayer
local guiList = player:WaitForChild("PlayerGui"):GetChildren()

for _, gui in pairs(guiList) do
    if gui:IsA("ScreenGui") then
        changeFontInGui(gui)
    end
end

print("✅ Font đã được đổi sang Arcade (kiểu Minecraft) nha Puzi!")
