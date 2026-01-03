local EntityNotification = {}
EntityNotification.__index = EntityNotification

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui
local screenGui
local activeNotifications = {}
local notificationSpacing = 100
local borderColor = Color3.fromRGB(255, 223, 190)
local textColor = Color3.fromRGB(255, 223, 190)
local innerColor = Color3.fromRGB(84, 68, 61)

local function isMobile()
    return game:GetService("UserInputService").TouchEnabled
end

local function getNotificationSize()
    local viewport = workspace.CurrentCamera.ViewportSize
    
    if isMobile() then
        local width = math.min(viewport.X * 0.85, 380)
        return {width = width, height = 110}
    else
        return {width = 380, height = 110}
    end
end

local function calculateNotificationPositions()
    local positions = {}
    local baseY = 25
    
    for i, notif in ipairs(activeNotifications) do
        if notif and notif.Parent then
            positions[notif] = baseY + ((i - 1) * notificationSpacing)
        end
    end
    
    return positions
end

local function updateAllNotificationPositions()
    for i = #activeNotifications, 1, -1 do
        local notif = activeNotifications[i]
        if not notif or not notif.Parent then
            table.remove(activeNotifications, i)
        end
    end
    
    local positions = calculateNotificationPositions()
    
    for i, notif in ipairs(activeNotifications) do
        if notif and notif.Parent then
            local targetY = positions[notif]
            
            local entityNoticeLabel = notif:FindFirstChild("EntityNotice")
            if entityNoticeLabel then
                entityNoticeLabel.Position = UDim2.new(0, 10, 0, 5)
            end
            
            local tween = TweenService:Create(
                notif,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = UDim2.new(0.5, 0, 0, targetY)}
            )
            tween:Play()
        end
    end
end

local function showNotification(content, iconId, duration)
    duration = duration or 3
    iconId = iconId or "97837015726495"
    
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
    
    local sizeInfo = getNotificationSize()
    local notificationWidth = sizeInfo.width
    local notificationHeight = sizeInfo.height
    
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "NotificationContainer"
    mainContainer.Size = UDim2.new(0, notificationWidth, 0, notificationHeight)
    mainContainer.AnchorPoint = Vector2.new(0.5, 0)
    mainContainer.BackgroundTransparency = 1
    mainContainer.ZIndex = 999
    mainContainer.Parent = screenGui
    
    table.insert(activeNotifications, 1, mainContainer)
    local positions = calculateNotificationPositions()
    local targetY = positions[mainContainer] or 25
    mainContainer.Position = UDim2.new(0.5, 0, 0, targetY)
    
    mainContainer.Size = UDim2.new(0, 0, 0, 0)
    mainContainer.BackgroundTransparency = 1
    
    local titleHeight = 30
    local entityNoticeLabel = Instance.new("TextLabel")
    entityNoticeLabel.Name = "EntityNotice"
    entityNoticeLabel.Size = UDim2.new(1, -20, 0, titleHeight)
    entityNoticeLabel.Position = UDim2.new(0, 10, 0, 5)
    entityNoticeLabel.BackgroundTransparency = 1
    entityNoticeLabel.Text = "ENTITY NOTICE"
    entityNoticeLabel.TextColor3 = borderColor
    entityNoticeLabel.TextSize = 20
    entityNoticeLabel.Font = Enum.Font.Oswald
    entityNoticeLabel.FontFace = Font.new(
        "rbxasset://fonts/families/Oswald.json",
        Enum.FontWeight.Bold,
        Enum.FontStyle.Normal
    )
    entityNoticeLabel.TextXAlignment = Enum.TextXAlignment.Left
    entityNoticeLabel.TextYAlignment = Enum.TextYAlignment.Center
    entityNoticeLabel.ZIndex = 1000
    entityNoticeLabel.TextTransparency = 1
    entityNoticeLabel.ClipsDescendants = true
    entityNoticeLabel.Parent = mainContainer
    
    local mainFrameHeight = notificationHeight - titleHeight - 10
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Name = "Notification"
    notificationFrame.Size = UDim2.new(1, 0, 0, mainFrameHeight)
    notificationFrame.Position = UDim2.new(0, 0, 0, titleHeight + 8)
    notificationFrame.BackgroundColor3 = innerColor
    notificationFrame.BackgroundTransparency = 0.2
    notificationFrame.BorderSizePixel = 0
    notificationFrame.ZIndex = 999
    notificationFrame.Parent = mainContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notificationFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = borderColor
    stroke.Thickness = 2.5
    stroke.Transparency = 0.1
    stroke.ZIndex = 1000
    stroke.Parent = notificationFrame
    
    local iconSize = math.min(mainFrameHeight - 20, 45)
    local iconContainer = Instance.new("Frame")
    iconContainer.Name = "IconContainer"
    iconContainer.Size = UDim2.new(0, iconSize, 0, iconSize)
    iconContainer.Position = UDim2.new(0, 10, 0.5, 0)
    iconContainer.AnchorPoint = Vector2.new(0, 0.5)
    iconContainer.BackgroundColor3 = innerColor
    iconContainer.BackgroundTransparency = 0.3
    iconContainer.ZIndex = 1000
    iconContainer.Parent = notificationFrame
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0.5, 0)
    iconCorner.Parent = iconContainer
    
    local iconStroke = Instance.new("UIStroke")
    iconStroke.Color = borderColor
    iconStroke.Thickness = 2
    iconStroke.Transparency = 0.2
    iconStroke.ZIndex = 1001
    iconStroke.Parent = iconContainer
    
    local iconImage = Instance.new("ImageLabel")
    iconImage.Name = "Icon"
    iconImage.Size = UDim2.new(0.85, 0, 0.85, 0)
    iconImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    iconImage.AnchorPoint = Vector2.new(0.5, 0.5)
    iconImage.BackgroundTransparency = 1
    iconImage.Image = "rbxassetid://" .. iconId
    iconImage.ScaleType = Enum.ScaleType.Fit
    iconImage.ZIndex = 1002
    iconImage.ImageTransparency = 1
    iconImage.Parent = iconContainer
    
    local iconImageCorner = Instance.new("UICorner")
    iconImageCorner.CornerRadius = UDim.new(0.5, 0)
    iconImageCorner.Parent = iconImage
    
    local messageLeftMargin = iconSize + 15
    local messageFrame = Instance.new("Frame")
    messageFrame.Name = "MessageFrame"
    messageFrame.Size = UDim2.new(1, -(messageLeftMargin + 10), 1, -10)
    messageFrame.Position = UDim2.new(0, messageLeftMargin, 0.5, 0)
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
    messageLabel.TextSize = isMobile() and 14 or 16
    messageLabel.TextWrapped = true
    messageLabel.Font = Enum.Font.RobotoCondensed
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Center
    messageLabel.ZIndex = 1001
    messageLabel.TextTransparency = 1
    messageLabel.ClipsDescendants = true
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
        sound.Volume = 5
        sound.Parent = workspace
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
        sound:Play()
    end)
    
    local function playEntranceAnimation()
        local scaleTween = TweenService:Create(
            mainContainer,
            TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, notificationWidth, 0, notificationHeight)}
        )
        
        local textTween = TweenService:Create(
            entityNoticeLabel,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.2),
            {TextTransparency = 0}
        )
        
        local iconTween = TweenService:Create(
            iconImage,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.3),
            {ImageTransparency = 0}
        )
        
        local messageTween = TweenService:Create(
            messageLabel,
            TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.4),
            {TextTransparency = 0}
        )
        
        scaleTween:Play()
        
        scaleTween.Completed:Connect(function()
            textTween:Play()
            iconTween:Play()
            messageTween:Play()
            
            task.wait(0.5)
            updateAllNotificationPositions()
        end)
    end
    
    playEntranceAnimation()
    
    task.spawn(function()
        task.wait(0.1)
        updateAllNotificationPositions()
    end)
    
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
                    
                    updateAllNotificationPositions()
                end)
            end)
        end
        
        playExitAnimation()
    end)
end

local function initialize()
    playerGui = player:WaitForChild("PlayerGui")
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