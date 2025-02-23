local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local targetPlaceId = 16670640252 -- Buraya hedef oyun ID'nizi yazın

local function deleteBots()
    local bots = workspace:FindFirstChild("Botlar")
    if bots then
        bots:Destroy()
        print("Botlar başarıyla silindi.")
    else
        print("Botlar bulunamadı.")
    end
end

local function getNil(name, class)
    for _, v in next, game:GetDescendants() do
        if v.ClassName == class and v.Name == name then
            return v
        end
    end
end

local function showNotification(message, duration)
    if game:GetService("UserInputService").TouchEnabled then
        return
    end

    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.3, 0, 0.1, 0)
    frame.Position = UDim2.new(0.7, -10, 0.9, -10)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    frame.Parent = notificationGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = message
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 24
    label.Parent = frame

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://2865226178"
    sound.Parent = notificationGui
    sound:Play()

    wait(duration)
    notificationGui:Destroy()
end

local function jumpAndStartFarm()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid", 10)

    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    else
        warn("Humanoid bulunamadı!")
        return
    end

    wait(1)

    -- Farm işlemlerini başlat
    local regions = {
         40},
        {name = "E", waitTime = 40},
        {name = "F", waitTime = 40},
        {name = "G", waitTime = 40},
        {name = "H", waitTime = 40},
        {name = "C", waitTime = 40},
        {name = "A", waitTime = 40},
        {name = "D", waitTime = 40}
    }

    for _, region in ipairs(regions) do
        local point = getNil(region.name, "Part")
        if point and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = point.CFrame * CFrame.new(0, 3, 0)
            wait(region.waitTime)
        else
            print(region.name .. " bölgesi bulunamadı veya HumanoidRootPart yok.")
        end
    end
end

local function onTeleportCompleted()
    showNotification("Hedef oyuna teleport edildiniz. Botlar siliniyor ve farma başlıyor.", 3)
    deleteBots()
    wait(1) -- Botların silinmesi için kısa bir süre bekleyin
    jumpAndStartFarm()
end

local function checkAndTeleport()
    local currentPlaceId = game.PlaceId
    if currentPlaceId ~= targetPlaceId then
        showNotification("Hedef oyun ID'sine ışınlanıyorsunuz.", 3)
        TeleportService:Teleport(targetPlaceId, player)
    else
        onTeleportCompleted()
    end
end

-- Kontrolü başlat
checkAndTeleport()
