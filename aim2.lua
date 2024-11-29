-- Biến khởi tạo
local Aimbot = true
local AimPreference = "near" -- "near" (gần nhất) hoặc "far" (xa nhất)

-- Hàm tính khoảng cách giữa hai vị trí
local function getDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

-- Hàm tìm người chơi mục tiêu
local function findTarget(preference)
    local lp = game.Players.LocalPlayer
    local lpChar = lp.Character
    if not lpChar or not lpChar:FindFirstChild("HumanoidRootPart") then
        return nil
    end

    local lpPosition = lpChar.HumanoidRootPart.Position
    local targetPlayer = nil
    local bestDistance = (preference == "near") and math.huge or 0

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= lp and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character.Humanoid
            if humanoid.Health > 0 then
                local distance = getDistance(lpPosition, player.Character.HumanoidRootPart.Position)
                if preference == "near" and distance < bestDistance then
                    bestDistance = distance
                    targetPlayer = player
                elseif preference == "far" and distance > bestDistance then
                    bestDistance = distance
                    targetPlayer = player
                end
            end
        end
    end

    return targetPlayer
end

-- Hàm lấy vũ khí hiện tại của người chơi
local function getEquippedWeapon()
    local lp = game.Players.LocalPlayer
    local lpChar = lp.Character
    if not lpChar then return nil end

    -- Kiểm tra tất cả các công cụ (Tool) trong nhân vật
    for _, item in pairs(lpChar:GetChildren()) do
        if item:IsA("Tool") then
            return item -- Trả về vũ khí đầu tiên tìm thấy
        end
    end

    return nil -- Không tìm thấy vũ khí
end

-- Lấy thông tin người chơi hiện tại và chuột
local lp = game.Players.LocalPlayer
local mouse = lp:GetMouse()

-- Bắt sự kiện bấm chuột trái
mouse.Button1Down:Connect(function()
    if Aimbot then
        local tool = getEquippedWeapon()
        if tool then
            local targetPlayer = findTarget(AimPreference)

            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
                local ignoreList = { lp.Character, workspace._WorldOrigin }

                -- Tính toán đường ray và bắn
                local ray = Ray.new(tool.Handle.CFrame.p, (targetPosition - tool.Handle.CFrame.p).unit * 100)
                local hitPart = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)

                -- Kiểm tra RemoteFunction tồn tại
                if tool:FindFirstChild("RemoteFunctionShoot") then
                    tool.RemoteFunctionShoot:InvokeServer(targetPosition, (require(game.ReplicatedStorage.Util).Other.hrpFromPart(hitPart)))
                else
                    warn("RemoteFunctionShoot không tồn tại trong công cụ.")
                end
            end
        else
            warn("Không tìm thấy vũ khí nào được trang bị.")
        end
    end
end)