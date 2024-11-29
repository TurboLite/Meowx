local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local mouse = plr:GetMouse()

-- Tạo công cụ teleport
local tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Teleport Tool"

tool.Activated:Connect(function()
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end

    local root = plr.Character.HumanoidRootPart
    local pos = mouse.Hit.Position + Vector3.new(0, 2.5, 0)
    root.CFrame = CFrame.new(pos)
end)

tool.Parent = plr.Backpack