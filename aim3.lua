-- Biến khởi tạo
local Skillaimbot = false -- Aimbot kỹ năng (Skill)
local Aimbot = false      -- Aimbot súng (Gun)
local SelectPlayer = nil  -- Người chơi mục tiêu
local SelectToolWeaponGun = nil -- Vũ khí hiện tại
local AimBotSkillPosition = nil -- Vị trí mục tiêu

-- Giữ nguyên metatable để bắt hành động FireServer
local gg = getrawmetatable(game)
local old = gg.__namecall
setreadonly(gg, false)
gg.__namecall = newcclosure(function(...)
    local method = getnamecallmethod()
    local args = { ... }
    if tostring(method) == "FireServer" then
        if tostring(args[1]) == "RemoteEvent" then
            if tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then
                if Skillaimbot then
                    args[2] = AimBotSkillPosition
                    return old(unpack(args))
                end
            end
        end
    end
    return old(...)
end)

-- Tìm vũ khí có thể sử dụng
task.spawn(function()
    while wait(0.5) do
        local lp = game.Players.LocalPlayer
        -- Kiểm tra trong balo
        for _, v in pairs(lp.Backpack:GetChildren()) do
            if v:IsA("Tool") and v:FindFirstChild("RemoteFunctionShoot") then
                SelectToolWeaponGun = v.Name
            end
        end
        -- Kiểm tra trong nhân vật
        for _, v in pairs(lp.Character:GetChildren()) do
            if v:IsA("Tool") and v:FindFirstChild("RemoteFunctionShoot") then
                SelectToolWeaponGun = v.Name
            end
        end
    end
end)

-- Cập nhật vị trí mục tiêu cho Skillaimbot
task.spawn(function()
    while wait(0.5) do
        if Skillaimbot and SelectPlayer then
            local target = game.Players:FindFirstChild(SelectPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                if target.Character:FindFirstChild("Humanoid").Health > 0 then
                    AimBotSkillPosition = target.Character.HumanoidRootPart.Position
                end
            end
        end
    end
end)

-- Xử lý khi bấm chuột (cho súng)
local lp = game.Players.LocalPlayer
local mouse = lp:GetMouse()
mouse.Button1Down:Connect(function()
    if Aimbot and SelectToolWeaponGun and SelectPlayer then
        local tool = lp.Character:FindFirstChild(SelectToolWeaponGun)
        local target = game.Players:FindFirstChild(SelectPlayer)
        if tool and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPosition = target.Character.HumanoidRootPart.Position
            local ray = Ray.new(tool.Handle.CFrame.p, (targetPosition - tool.Handle.CFrame.p).unit * 100)
            local hitPart = workspace:FindPartOnRayWithIgnoreList(ray, { lp.Character, workspace._WorldOrigin })

            -- Gửi thông tin đến RemoteFunction
            if tool:FindFirstChild("RemoteFunctionShoot") then
                tool.RemoteFunctionShoot:InvokeServer(targetPosition, (require(game.ReplicatedStorage.Util).Other.hrpFromPart(hitPart)))
            else
                warn("RemoteFunctionShoot không tồn tại trong Tool.")
            end
        end
    end
end)

-- Kích hoạt Aimbot khi script chạy
Aimbot = true
Skillaimbot = true
SelectPlayer = "TênNgườiChơiCầnTấnCông" -- Đặt tên người chơi mục tiêu tại đây (hoặc thay bằng UI)