local EntityNotification = {}
EntityNotification.__index = EntityNotification

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui
local screenGui
local activeNotifications = {}
local notificationSpacing = 0.15
local basePosition = 0.08
local borderColor = Color3.fromRGB(255, 223, 190)
local textColor = Color3.fromRGB(255, 223, 190)
local innerColor = Color3.fromRGB(84, 68, 61)

local function updateNotificationPositions()
    for i, notif in ipairs(activeNotifications) do
        if notif and notif.Parent then
            local targetPosition = basePosition + ((i - 1) * notificationSpacing)
            local tween = TweenService:Create(
                notif,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = UDim2.new(0.5, 0, targetPosition, 0)}
            )
            tween:Play()
        end
    end
end

local function getAdaptiveSize()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local aspectRatio = viewportSize.X / viewportSize.Y
    
    local baseWidth = 0.4
    local baseHeight = 0.15
    local iconSize = 50
    local fontSize = 18
    local titleFontSize = 20
    
    if viewportSize.Y < 700 then
        baseWidth = 0.85
        baseHeight = 0.22
        iconSize = 40
        fontSize = 16
        titleFontSize = 18
    elseif viewportSize.Y < 900 then
        baseWidth = 0.7
        baseHeight = 0.18
        iconSize = 45
        fontSize = 17
        titleFontSize = 19
    end
    
    return baseWidth, baseHeight, iconSize, fontSize, titleFontSize
end

local function showNotification(content, iconId, duration)
    duration = duration or 3
    iconId = iconId or "97837015726495"
    
    local baseWidth, baseHeight, iconSize, fontSize, titleFontSize = getAdaptiveSize()
    
    if not playerGui then
        playerGui = player:WaitForChild("PlayerGui")
    end
    
    if not screenGui or not screenGui.Parent then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "EntityNoticeNotificationGui"
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.Parent = playerGui
    end
    
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "NotificationContainer"
    mainContainer.Size = UDim2.new(baseWidth, 0, baseHeight, 0)
    mainContainer.Position = UDim2.new(0.5, 0, basePosition, 0)
    mainContainer.AnchorPoint = Vector2.new(0.5, 0)
    mainContainer.BackgroundTransparency = 1
    mainContainer.ZIndex = 999
    mainContainer.Parent = screenGui
    
    mainContainer.Size = UDim2.new(0, 0, 0, 0)
    mainContainer.BackgroundTransparency = 1
    
    local entityNoticeLabel = Instance.new("TextLabel")
    entityNoticeLabel.Name = "EntityNotice"
    entityNoticeLabel.Size = UDim2.new(0.9, 0, 0.25, 0)
    entityNoticeLabel.Position = UDim2.new(0.05, 0, 0, 0)
    entityNoticeLabel.BackgroundTransparency = 1
    entityNoticeLabel.Text = "ENTITY NOTICE"
    entityNoticeLabel.TextColor3 = borderColor
    entityNoticeLabel.TextSize = titleFontSize
    entityNoticeLabel.Font = Enum.Font.Oswald
    entityNoticeLabel.FontFace = Font.new(
        "rbxasset://fonts/families/Oswald.json",
        Enum.FontWeight.Bold,
        Enum.FontStyle.Normal
    )
    entityNoticeLabel.TextXAlignment = Enum.TextXAlignment.Left
    entityNoticeLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    entityNoticeLabel.ZIndex = 1000
    entityNoticeLabel.TextTransparency = 1
    entityNoticeLabel.Parent = mainContainer
    
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Name = "Notification"
    notificationFrame.Size = UDim2.new(0.95, 0, 0.7, 0)
    notificationFrame.Position = UDim2.new(0.025, 0, 0.3, 0)
    notificationFrame.AnchorPoint = Vector2.new(0, 0)
    notificationFrame.BackgroundColor3 = innerColor
    notificationFrame.BackgroundTransparency = 0.2
    notificationFrame.BorderSizePixel = 0
    notificationFrame.ZIndex = 999
    notificationFrame.Parent = mainContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notificationFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = borderColor
    stroke.Thickness = 3
    stroke.Transparency = 0.1
    stroke.ZIndex = 1000
    stroke.Parent = notificationFrame
    
    local iconContainer = Instance.new("Frame")
    iconContainer.Name = "IconContainer"
    iconContainer.Size = UDim2.new(0, iconSize, 0, iconSize)
    iconContainer.Position = UDim2.new(0.05, 0, 0.5, 0)
    iconContainer.AnchorPoint = Vector2.new(0, 0.5)
    iconContainer.BackgroundColor3 = innerColor
    iconContainer.BackgroundTransparency = 0.3
    iconContainer.ZIndex = 1000
    iconContainer.Parent = notificationFrame
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = iconContainer
    
    local iconStroke = Instance.new("UIStroke")
    iconStroke.Color = borderColor
    iconStroke.Thickness = 2
    iconStroke.Transparency = 0.2
    iconStroke.ZIndex = 1001
    iconStroke.Parent = iconContainer
    
    local iconImage = Instance.new("ImageLabel")
    iconImage.Name = "Icon"
    iconImage.Size = UDim2.new(1, 0, 1, 0)
    iconImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    iconImage.AnchorPoint = Vector2.new(0.5, 0.5)
    iconImage.BackgroundTransparency = 1
    iconImage.Image = "rbxassetid://" .. iconId
    iconImage.ScaleType = Enum.ScaleType.Fit
    iconImage.ZIndex = 1002
    iconImage.ImageTransparency = 1
    iconImage.Parent = iconContainer
    
    local iconImageCorner = Instance.new("UICorner")
    iconImageCorner.CornerRadius = UDim.new(1, 0)
    iconImageCorner.Parent = iconImage
    
    local messageFrame = Instance.new("Frame")
    messageFrame.Name = "MessageFrame"
    messageFrame.Size = UDim2.new(0.75, 0, 0.8, 0)
    messageFrame.Position = UDim2.new(0.2 + (iconSize/300), 0, 0.5, 0)
    messageFrame.AnchorPoint = Vector2.new(0, 0.5)
    messageFrame.BackgroundTransparency = 1
    messageFrame.ZIndex = 1000
    messageFrame.Parent = notificationFrame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.Size = UDim2.new(1, 0, 1, 0)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = content
    messageLabel.TextColor3 = textColor
    messageLabel.TextSize = fontSize
    messageLabel.TextWrapped = true
    messageLabel.Font = Enum.Font.RobotoCondensed
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Center
    messageLabel.ZIndex = 1001
    messageLabel.TextTransparency = 1
    messageLabel.Parent = messageFrame
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(94, 78, 71)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(84, 68, 61)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(94, 78, 71))
    })
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(0.5, 0.25),
        NumberSequenceKeypoint.new(1, 0.2)
    })
    gradient.Rotation = 90
    gradient.Parent = notificationFrame
    
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://99469140131424"
        sound.Volume = 10
        sound.Parent = workspace
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
        sound:Play()
    end)
    
    table.insert(activeNotifications, 1, mainContainer)
    
    local function playEntranceAnimation()
        local scaleTween = TweenService:Create(
            mainContainer,
            TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Size = UDim2.new(baseWidth, 0, baseHeight, 0)}
        )
        
        local textTween = TweenService:Create(
            entityNoticeLabel,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.3),
            {TextTransparency = 0}
        )
        
        local iconTween = TweenService:Create(
            iconImage,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.4),
            {ImageTransparency = 0}
        )
        
        local messageTween = TweenService:Create(
            messageLabel,
            TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.5),
            {TextTransparency = 0}
        )
        
        scaleTween:Play()
        
        scaleTween.Completed:Connect(function()
            textTween:Play()
            iconTween:Play()
            messageTween:Play()
            
            messageTween.Completed:Connect(function()
                updateNotificationPositions()
            end)
        end)
    end
    
    playEntranceAnimation()
    
    task.delay(duration, function()
        if not mainContainer or not mainContainer.Parent then
            return
        end
        
        local function playExitAnimation()
            local textTween = TweenService:Create(
                entityNoticeLabel,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {TextTransparency = 1}
            )
            
            local iconTween = TweenService:Create(
                iconImage,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {ImageTransparency = 1}
            )
            
            local messageTween = TweenService:Create(
                messageLabel,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {TextTransparency = 1}
            )
            
            local scaleTween = TweenService:Create(
                mainContainer,
                TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In, 0, false, 0.3),
                {Size = UDim2.new(0, 0, 0, 0)}
            )
            
            textTween:Play()
            iconTween:Play()
            messageTween:Play()
            
            messageTween.Completed:Connect(function()
                scaleTween:Play()
                
                scaleTween.Completed:Connect(function()
                    for i, notif in ipairs(activeNotifications) do
                        if notif == mainContainer then
                            table.remove(activeNotifications, i)
                            break
                        end
                    end
                    
                    if mainContainer and mainContainer.Parent then
                        mainContainer:Destroy()
                    end
                    
                    updateNotificationPositions()
                end)
            end)
        end
        
        playExitAnimation()
    end)
end

local function initialize()
    playerGui = player:WaitForChild("PlayerGui")
    
    local function onCharacterAdded(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            for _, notif in ipairs(activeNotifications) do
                if notif and notif.Parent then
                    notif:Destroy()
                end
            end
            activeNotifications = {}
        end)
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end

function EntityNotification.Show(content, iconId, duration)
    if not content then
        return
    end
    
    if not playerGui then
        initialize()
    end
    
    showNotification(content, iconId, duration)
end

return EntityNotification