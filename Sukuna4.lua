-- Thông Báo 
require(game.ReplicatedStorage:WaitForChild("Notification")).new(
            " <Color=Red>Turbo Lite — Teleport Sukuna<Color=/> "
        ):Display()
        
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local mouse = plr:GetMouse()

-- Biến điều khiển khả năng chạy siêu nhanh
local InfAbility = true

-- Phát nhạc khi mã chạy (ID nhạc khi chạy mã là 7817341182)
local joinSound = Instance.new("Sound")
joinSound.Name = "JoinSound"
joinSound.SoundId = "rbxassetid://7817341182" -- ID nhạc khi chạy mã
joinSound.Volume = 1
joinSound.Looped = false
joinSound.Parent = workspace
joinSound:Play()

-- Kiểm tra giao diện chọn đội và tự động chọn "Pirates"
if plr.PlayerGui.Main:FindFirstChild("ChooseTeam") then
    local chooseTeamGui = plr.PlayerGui.Main.ChooseTeam
    local piratesButton = chooseTeamGui.Container["Pirates"].Frame.TextButton

    -- Kích hoạt sự kiện khi chọn đội "Pirates"
    for _, connection in pairs(getconnections(piratesButton.Activated)) do
        connection.Function()
    end
end

-- Tạo công cụ teleport
local tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Teleport Tool"

-- Tạo âm thanh cho công cụ teleport (ID nhạc teleport là 6581614725)
local teleportSound = Instance.new("Sound")
teleportSound.Name = "TeleportSound"
teleportSound.SoundId = "rbxassetid://6581614725" -- ID nhạc teleport
teleportSound.Volume = 1
teleportSound.Looped = false
teleportSound.Parent = tool

-- Chức năng chạy siêu nhanh
local function InfAb()
    local character = plr.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if InfAbility then
            humanoid.WalkSpeed = 300 -- Tốc độ siêu nhanh (mặc định là 16)
        else
            humanoid.WalkSpeed = 16 -- Tốc độ chạy bình thường
        end
    end
end

-- Vòng lặp để duy trì khả năng chạy siêu nhanh
spawn(function()
    while wait() do
        if InfAbility then
            InfAb()
        end
    end
end)

-- Kết nối khi công cụ được kích hoạt
tool.Activated:Connect(function()
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end

    local root = plr.Character.HumanoidRootPart
    local pos = mouse.Hit.Position + Vector3.new(0, 2.5, 0)
    root.CFrame = CFrame.new(pos)
    
    -- Phát âm thanh teleport
    teleportSound:Play()
end)

tool.Parent = plr.Backpack