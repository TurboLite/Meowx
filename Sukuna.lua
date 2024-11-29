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

-- Biến để kiểm soát khả năng "Infinite Ability" và hào quang
local InfAbility = true
local AuraEnabled = true

-- Tạo công cụ teleport
local tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Teleport Tool"

-- Tạo âm thanh cho công cụ teleport
local sound = Instance.new("Sound")
sound.Name = "TeleportSound"
sound.SoundId = "rbxassetid://7817341182" -- ID nhạc mới
sound.Volume = 1
sound.Looped = false
sound.Parent = tool

-- Hàm tạo hiệu ứng hào quang
local function CreateAuraEffect(part)
    local aura = Instance.new("ParticleEmitter")
    aura.Name = "AuraEffect"
    aura.Texture = "rbxassetid://2596153391" -- Texture ánh sáng (có thể thay đổi)
    aura.Color = ColorSequence.new(
        Color3.fromRGB(255, 255, 0), -- Màu vàng (Super Saiyan)
        Color3.fromRGB(255, 140, 0) -- Màu cam sáng
    )
    aura.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0), 
        NumberSequenceKeypoint.new(1, 1) 
    })
    aura.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 3),
        NumberSequenceKeypoint.new(1, 6)
    })
    aura.Speed = NumberRange.new(10, 15)
    aura.Lifetime = NumberRange.new(1, 2)
    aura.Rate = 50
    aura.RotSpeed = NumberRange.new(100, 200)
    aura.LockedToPart = true
    aura.SpreadAngle = Vector2.new(360, 360)
    aura.LightInfluence = 1
    aura.Parent = part
end

-- Hàm để thêm hào quang toàn thân
local function ApplyAuraEffect()
    local character = plr.Character
    if not character then return end

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and not part:FindFirstChild("AuraEffect") then
            CreateAuraEffect(part)
        end
    end
end

-- Hàm để xóa hào quang toàn thân
local function RemoveAuraEffect()
    local character = plr.Character
    if not character then return end

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part:FindFirstChild("AuraEffect") then
            part:FindFirstChild("AuraEffect"):Destroy()
        end
    end
end

-- Kết hợp hào quang toàn thân và hiệu ứng Infinite Ability
local function InfAb()
    if InfAbility then
        ApplyAuraEffect()
    else
        RemoveAuraEffect()
    end
end

-- Tùy chọn bật/tắt hào quang và Infinite Ability
local function ToggleAura(Value)
    AuraEnabled = Value
    if not Value then
        RemoveAuraEffect()
    else
        ApplyAuraEffect()
    end
end

local function ToggleInfAbility(Value)
    InfAbility = Value
    if not Value then
        RemoveAuraEffect()
    end
end

-- Đặt giá trị mặc định
ToggleInfAbility(true)
ToggleAura(true)

-- Kết nối khi công cụ được kích hoạt
tool.Activated:Connect(function()
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end

    local root = plr.Character.HumanoidRootPart
    local pos = mouse.Hit.Position + Vector3.new(0, 2.5, 0)
    root.CFrame = CFrame.new(pos)
    
    -- Phát âm thanh
    sound:Play()

    -- Làm mới hiệu ứng khi teleport
    InfAb()
end)

tool.Parent = plr.Backpack

-- Vòng lặp kiểm tra trạng thái Infinite Ability và hào quang
spawn(function()
    while wait() do
        if AuraEnabled then
            ApplyAuraEffect()
        end
        if InfAbility then
            InfAb()
        end
    end
end)