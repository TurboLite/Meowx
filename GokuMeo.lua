-- Tạo công cụ "Biến Hình"
local tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Biến Hình"
tool.Parent = game.Players.LocalPlayer.Backpack

-- Hàm chạy animation
local function playTransformationAnimation()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    -- Kiểm tra Humanoid và Animator
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

        -- Tạo animation
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://658832070" -- ID của animation Goku biến hình
        local track = animator:LoadAnimation(animation)

        -- Phát animation
        track:Play()
        print("Animation Goku biến hình đã được kích hoạt!")
    else
        warn("Không tìm thấy Humanoid trong nhân vật!")
    end
end

-- Tạo và phát nhạc khi biến hình
local function playTransformationMusic(character)
    -- Kiểm tra xem đã có nhạc phát trong nhân vật chưa
    if character:FindFirstChild("TransformationMusic") then
        character.TransformationMusic:Stop()
    end
    
    -- Tạo nhạc
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://6427919074" -- ID nhạc
    sound.Name = "TransformationMusic"
    sound.Parent = character:FindFirstChild("HumanoidRootPart") -- Gắn nhạc vào HumanoidRootPart
    sound:Play() -- Phát nhạc
end

-- Tạo hiệu ứng ánh sáng khi biến hình (tuỳ chọn)
local function createGlowEffect(character)
    -- Xóa hiệu ứng cũ nếu có
    if character:FindFirstChild("FakeGlow") then
        character.FakeGlow:Destroy()
    end

    -- Tạo ánh sáng tập trung
    local light = Instance.new("SurfaceLight")
    light.Name = "FakeGlow"
    light.Color = Color3.new(1, 0.5, 0) -- Màu cam vàng (Super Saiyan)
    light.Brightness = 10 -- Độ sáng mạnh
    light.Angle = 90 -- Giới hạn góc sáng để không lan ra ngoài
    light.Range = 15 -- Phạm vi ánh sáng
    light.Face = Enum.NormalId.Top -- Chỉ chiếu sáng lên trên
    light.Parent = character:FindFirstChild("HumanoidRootPart")
end

-- Kết nối sự kiện khi công cụ được sử dụng
tool.Activated:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    if character and character:FindFirstChild("HumanoidRootPart") then
        createGlowEffect(character) -- Kích hoạt ánh sáng
        playTransformationMusic(character) -- Phát nhạc khi biến hình
    end

    playTransformationAnimation() -- Chạy animation
end)