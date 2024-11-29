-- Biến khởi tạo
local Aimbot = true -- Bật/tắt Aimbot
local SelectedPlayer = nil -- Người chơi mục tiêu
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

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

-- Hàm kiểm tra công cụ hợp lệ
local function isValidWeapon(tool)
    if tool and tool:FindFirstChild("RemoteFunctionShoot") then
        return true
    end
    return false
end

-- Bắt sự kiện bấm chuột trái
LocalPlayer:GetMouse().Button1Down:Connect(function()
    if Aimbot and SelectedPlayer then
        local tool = getEquippedWeapon()
        local targetPlayer = Players:FindFirstChild(SelectedPlayer)

        if not tool then
            warn("Không tìm thấy vũ khí nào được trang bị.")
            return
        end

        if not isValidWeapon(tool) then
            warn("Công cụ hiện tại không hỗ trợ RemoteFunctionShoot.")
            return
        end

        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
            local ignoreList = { LocalPlayer.Character, workspace._WorldOrigin }
            local startPosition = tool:FindFirstChild("Handle") and tool.Handle.CFrame.p or LocalPlayer.Character.HumanoidRootPart.Position

            -- Tính toán đường ray và bắn
            local ray = Ray.new(startPosition, (targetPosition - startPosition).unit * 100)
            local hitPart = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)

            -- Sử dụng RemoteFunctionShoot
            tool.RemoteFunctionShoot:InvokeServer(targetPosition, (require(game.ReplicatedStorage.Util).Other.hrpFromPart(hitPart)))
        else
            warn("Không tìm thấy mục tiêu hợp lệ.")
        end
    elseif not SelectedPlayer then
        warn("Chưa chọn người chơi mục tiêu!")
    end
end)

-- Tạo GUI để hiển thị danh sách người chơi
local function createPlayerSelectionGUI()
    -- Tạo ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PlayerSelectionGUI"
    screenGui.Parent = game.CoreGui

    -- Tạo Frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0.5, -150, 0.5, -200)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    -- Tạo tiêu đề
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    title.Text = "Chọn người chơi"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSans
    title.TextSize = 20
    title.Parent = frame

    -- Tạo danh sách nút
    local layout = Instance.new("UIListLayout")
    layout.Parent = frame
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Thêm nút cho từng người chơi
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0.9, 0, 0, 40)
            button.Text = player.Name
            button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
            button.TextColor3 = Color3.new(1, 1, 1)
            button.Font = Enum.Font.SourceSans
            button.TextSize = 18
            button.Parent = frame

            -- Khi bấm nút, chọn người chơi
            button.MouseButton1Click:Connect(function()
                SelectedPlayer = player.Name
                print("Bạn đã chọn: " .. SelectedPlayer)
                screenGui:Destroy() -- Xóa GUI sau khi chọn
            end)
        end
    end
end

-- Gọi hàm tạo GUI để chọn người chơi
createPlayerSelectionGUI()