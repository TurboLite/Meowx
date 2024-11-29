-- Thông Báo 
require(game.ReplicatedStorage:WaitForChild("Notification")).new(
            " <Color=Red>Turbo Lite — Teleport Sukuna<Color=/> "
        ):Display()
        
-- Join 
-- Kiểm tra xem giao diện chọn đội có tồn tại không
if game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("ChooseTeam") then
    -- Chọn đội "Pirates" ngay lập tức
    local chooseTeamGui = game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam
    local piratesButton = chooseTeamGui.Container["Pirates"].Frame.TextButton

    -- Kích hoạt sự kiện khi người chơi chọn đội "Pirates"
    for _, connection in pairs(getconnections(piratesButton.Activated)) do
        -- Giả lập việc nhấn nút
        for _, inputConnection in pairs(getconnections(game:GetService("UserInputService").TouchTapInWorld)) do
            inputConnection:Fire() 
        end
        -- Thực thi hành động liên kết với nút
        connection.Function()
    end
end

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local mouse = plr:GetMouse()

-- Biến điều khiển khả năng chạy siêu nhanh
local InfAbility = true

-- Tạo công cụ teleport
local tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Teleport Tool"

-- Tạo âm thanh cho công cụ teleport
local sound = Instance.new("Sound")
sound.Name = "TeleportSound"
sound.SoundId = "rbxassetid://7817341182" -- ID nhạc teleport
sound.Volume = 1
sound.Looped = false
sound.Parent = tool

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
    
    -- Phát âm thanh
    sound:Play()
end)

tool.Parent = plr.Backpack