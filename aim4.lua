-- Biến khởi tạo
local Aimbot = true -- Bật/tắt Aimbot
local SelectedPlayer = nil -- Người chơi mục tiêu
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Hàm tạo danh sách người chơi
local function createPlayerList()
    local playerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    return playerList
end

-- Hiển thị danh sách người chơi và cho phép chọn mục tiêu
local function displayPlayerList()
    print("Danh sách người chơi trong server:")
    local playerList = createPlayerList()
    for i, playerName in ipairs(playerList) do
        print(i .. ". " .. playerName)
    end

    print("\nHãy nhập số tương ứng với người chơi bạn muốn chọn:")
    local choice = tonumber(io.read()) -- Lấy lựa chọn từ người dùng
    if choice and playerList[choice] then
        SelectedPlayer = playerList[choice]
        print("Bạn đã chọn: " .. SelectedPlayer)
    else
        print("Lựa chọn không hợp lệ!")
    end
end

-- Hàm lấy vũ khí hiện tại của người chơi
local function getEquippedWeapon()
    local lpChar = LocalPlayer.Character
    if not lpChar then return nil end

    for _, item in pairs(lpChar:GetChildren()) do
        if item:IsA("Tool") then
            return item -- Trả về vũ khí đầu tiên tìm thấy
        end
    end

    return nil -- Không tìm thấy vũ khí
end

-- Bắt sự kiện bấm chuột trái
LocalPlayer:GetMouse().Button1Down:Connect(function()
    if Aimbot and SelectedPlayer then
        local tool = getEquippedWeapon()
        local targetPlayer = Players:FindFirstChild(SelectedPlayer)

        if tool and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
            local ignoreList = { LocalPlayer.Character, workspace._WorldOrigin }
            local startPosition = tool:FindFirstChild("Handle") and tool.Handle.CFrame.p or LocalPlayer.Character.HumanoidRootPart.Position

            -- Tính toán đường ray và bắn
            local ray = Ray.new(startPosition, (targetPosition - startPosition).unit * 100)
            local hitPart = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)

            -- Kiểm tra RemoteFunction tồn tại
            if tool:FindFirstChild("RemoteFunctionShoot") then
                tool.RemoteFunctionShoot:InvokeServer(targetPosition, (require(game.ReplicatedStorage.Util).Other.hrpFromPart(hitPart)))
            else
                warn("RemoteFunctionShoot không tồn tại trong công cụ.")
            end
        else
            warn("Không tìm thấy mục tiêu hợp lệ hoặc vũ khí.")
        end
    elseif not SelectedPlayer then
        warn("Chưa chọn người chơi mục tiêu!")
    end
end)

-- Gọi hàm hiển thị danh sách người chơi để chọn mục tiêu
displayPlayerList()