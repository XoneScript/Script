local XKUI = {}
XKUI.__index = XKUI

local Colors = {
    Background = Color3.fromRGB(91, 59, 52),
    Foreground = Color3.fromRGB(70, 45, 40),
    Text = Color3.fromRGB(255, 223, 190),
    Accent = Color3.fromRGB(255, 223, 190),
    Button = Color3.fromRGB(120, 95, 85),
    Border = Color3.fromRGB(255, 223, 190)
}

local OSWALDFONT = Font.new(
    "rbxasset://fonts/families/Oswald.json",
    Enum.FontWeight.Bold,
    Enum.FontStyle.Normal
)

function XKUI:CreateWindow(config)
    local Window = setmetatable({}, self)
    
    Window.Title = config.Title or "XK UI"
    Window.Size = config.Size or UDim2.fromOffset(500, 400)
    Window.Folder = config.Folder or "XKHub"
    Window.Tabs = {}
    Window.CurrentTab = 1
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = Window.Folder
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = Window.Size
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BackgroundTransparency = 0.2
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Colors.Border
    UIStroke.Thickness = 3
    UIStroke.Parent = MainFrame
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundTransparency = 1
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Window.Title
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.FontFace = OSWALDFONT
    TitleLabel.TextSize = 28
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    TitleBar.Parent = MainFrame
    
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Position = UDim2.new(0, 10, 0, 60)
    TabContainer.Size = UDim2.new(0, 120, 0, 280)
    TabContainer.BackgroundColor3 = Colors.Foreground
    TabContainer.BackgroundTransparency = 0.3
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabContainer
    
    local TabStroke = Instance.new("UIStroke")
    TabStroke.Color = Colors.Border
    TabStroke.Thickness = 1
    TabStroke.Parent = TabContainer
    
    TabContainer.Parent = MainFrame
    
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Position = UDim2.new(0, 140, 0, 60)
    ContentContainer.Size = UDim2.new(1, -150, 1, -70)
    ContentContainer.BackgroundColor3 = Colors.Foreground
    ContentContainer.BackgroundTransparency = 0.3
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = ContentContainer
    
    local ContentStroke = Instance.new("UIStroke")
    ContentStroke.Color = Colors.Border
    ContentStroke.Thickness = 1
    ContentStroke.Parent = ContentContainer
    
    ContentContainer.Parent = MainFrame
    
    local ItemsContainer = Instance.new("Frame")
    ItemsContainer.Name = "ItemsContainer"
    ItemsContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    ItemsContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    ItemsContainer.Size = UDim2.new(0.9, 0, 0.9, 0)
    ItemsContainer.BackgroundTransparency = 1
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Parent = ItemsContainer
    
    ItemsContainer.Parent = ContentContainer
    
    MainFrame.Parent = ScreenGui
    ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    Window.GUI = ScreenGui
    Window.MainFrame = MainFrame
    Window.TabContainer = TabContainer
    Window.ItemsContainer = ItemsContainer
    Window.ContentContainer = ContentContainer
    
    function Window:Toggle()
        if Window.GUI then
            Window.GUI.Enabled = not Window.GUI.Enabled
        end
    end
    
    function Window:Destroy()
        if Window.GUI then
            Window.GUI:Destroy()
        end
    end
    
    function Window:Tab(config)
        local Tab = {}
        Tab.Title = config.Title or "Tab"
        Tab.TabFrame = nil
        Tab.ContentFrame = nil
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = Tab.Title .. "Tab"
        TabButton.Size = UDim2.new(0.9, 0, 0, 80)
        TabButton.BackgroundColor3 = Colors.Button
        TabButton.BackgroundTransparency = 0.4
        TabButton.Text = Tab.Title
        TabButton.TextColor3 = Colors.Text
        TabButton.FontFace = OSWALDFONT
        TabButton.TextSize = 18
        TabButton.AutoButtonColor = false
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = TabButton
        
        TabButton.MouseButton1Click:Connect(function()
            Window:SelectTab(Tab)
        end)
        
        TabButton.Parent = Window.TabContainer
        
        Tab.TabButton = TabButton
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            Window:SelectTab(Tab)
        end
        
        function Tab:CreateContent()
            Tab.ContentFrame = Instance.new("Frame")
            Tab.ContentFrame.Name = Tab.Title .. "Content"
            Tab.ContentFrame.Size = UDim2.new(1, 0, 1, 0)
            Tab.ContentFrame.BackgroundTransparency = 1
            Tab.ContentFrame.Visible = false
            
            local ContentScrolling = Instance.new("ScrollingFrame")
            ContentScrolling.Name = "ContentScrolling"
            ContentScrolling.Size = UDim2.new(1, 0, 1, 0)
            ContentScrolling.BackgroundTransparency = 1
            ContentScrolling.ScrollBarThickness = 6
            ContentScrolling.ScrollBarImageColor3 = Colors.Text
            
            local ContentLayout = Instance.new("UIListLayout")
            ContentLayout.Padding = UDim.new(0, 10)
            ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            ContentLayout.Parent = ContentScrolling
            
            ContentScrolling.Parent = Tab.ContentFrame
            Tab.ContentFrame.Parent = Window.ContentContainer
            
            ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                ContentScrolling.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            end)
            
            Tab.ScrollingFrame = ContentScrolling
        end
        
        function Tab:Button(config)
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = "ButtonFrame"
            ButtonFrame.Size = UDim2.new(0.9, 0, 0, 50)
            ButtonFrame.BackgroundColor3 = Colors.Button
            ButtonFrame.BackgroundTransparency = 0.2
            
            local FrameCorner = Instance.new("UICorner")
            FrameCorner.CornerRadius = UDim.new(0, 6)
            FrameCorner.Parent = ButtonFrame
            
            local FrameStroke = Instance.new("UIStroke")
            FrameStroke.Color = Colors.Border
            FrameStroke.Thickness = 1
            FrameStroke.Parent = ButtonFrame
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.BackgroundTransparency = 1
            Button.Text = config.Title or "Button"
            Button.TextColor3 = Colors.Text
            Button.FontFace = OSWALDFONT
            Button.TextSize = 16
            
            Button.MouseButton1Click:Connect(function()
                if config.Callback then
                    config.Callback()
                end
            end
            
            Button.MouseEnter:Connect(function()
                ButtonFrame.BackgroundTransparency = 0.1
            end)
            
            Button.MouseLeave:Connect(function()
                ButtonFrame.BackgroundTransparency = 0.2
            end)
            
            Button.Parent = ButtonFrame
            
            if Tab.ScrollingFrame then
                ButtonFrame.Parent = Tab.ScrollingFrame
            end
            
            return Button
        end
        
        function Tab:Toggle(config)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Size = UDim2.new(0.9, 0, 0, 50)
            ToggleFrame.BackgroundColor3 = Colors.Button
            ToggleFrame.BackgroundTransparency = 0.2
            
            local FrameCorner = Instance.new("UICorner")
            FrameCorner.CornerRadius = UDim.new(0, 6)
            FrameCorner.Parent = ToggleFrame
            
            local FrameStroke = Instance.new("UIStroke")
            FrameStroke.Color = Colors.Border
            FrameStroke.Thickness = 1
            FrameStroke.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "ToggleLabel"
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = config.Title or "Toggle"
            ToggleLabel.TextColor3 = Colors.Text
            ToggleLabel.FontFace = OSWALDFONT
            ToggleLabel.TextSize = 16
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.AnchorPoint = Vector2.new(1, 0.5)
            ToggleButton.Position = UDim2.new(1, -10, 0.5, 0)
            ToggleButton.Size = UDim2.new(0, 50, 0, 25)
            ToggleButton.BackgroundColor3 = Colors.Button
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(1, 0)
            ToggleCorner.Parent = ToggleButton
            
            local ToggleDot = Instance.new("Frame")
            ToggleDot.Name = "ToggleDot"
            ToggleDot.AnchorPoint = Vector2.new(0.5, 0.5)
            ToggleDot.Position = UDim2.new(0.25, 0, 0.5, 0)
            ToggleDot.Size = UDim2.new(0, 20, 0, 20)
            ToggleDot.BackgroundColor3 = Colors.Text
            ToggleDot.Parent = ToggleButton
            
            local DotCorner = Instance.new("UICorner")
            DotCorner.CornerRadius = UDim.new(1, 0)
            DotCorner.Parent = ToggleDot
            
            local isToggled = config.Value or false
            
            local function updateToggle()
                if isToggled then
                    game:GetService("TweenService"):Create(
                        ToggleDot,
                        TweenInfo.new(0.2),
                        {Position = UDim2.new(0.75, 0, 0.5, 0)}
                    ):Play()
                    ToggleButton.BackgroundColor3 = Color3.fromRGB(204, 147, 128)
                else
                    game:GetService("TweenService"):Create(
                        ToggleDot,
                        TweenInfo.new(0.2),
                        {Position = UDim2.new(0.25, 0, 0.5, 0)}
                    ):Play()
                    ToggleButton.BackgroundColor3 = Colors.Button
                end
            end
            
            updateToggle()
            
            ToggleButton.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                updateToggle()
                if config.Callback then
                    config.Callback(isToggled)
                end
            end)
            
            ToggleButton.Parent = ToggleFrame
            
            if Tab.ScrollingFrame then
                ToggleFrame.Parent = Tab.ScrollingFrame
            end
        end
        
        function Tab:Dropdown(config)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = "DropdownFrame"
            DropdownFrame.Size = UDim2.new(0.9, 0, 0, 45)
            DropdownFrame.BackgroundColor3 = Colors.Button
            DropdownFrame.BackgroundTransparency = 0.2
            
            local FrameCorner = Instance.new("UICorner")
            FrameCorner.CornerRadius = UDim.new(0, 6)
            FrameCorner.Parent = DropdownFrame
            
            local FrameStroke = Instance.new("UIStroke")
            FrameStroke.Color = Colors.Border
            FrameStroke.Thickness = 1
            FrameStroke.Parent = DropdownFrame
            
            local DropLabel = Instance.new("TextLabel")
            DropLabel.Name = "DropLabel"
            DropLabel.Position = UDim2.new(0, 10, 0, 0)
            DropLabel.Size = UDim2.new(0.7, 0, 1, 0)
            DropLabel.BackgroundTransparency = 1
            DropLabel.Text = config.Title or "Dropdown"
            DropLabel.TextColor3 = Colors.Text
            DropLabel.FontFace = OSWALDFONT
            DropLabel.TextSize = 14
            DropLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropLabel.Parent = DropdownFrame
            
            local DropButton = Instance.new("TextButton")
            DropButton.Name = "DropButton"
            DropButton.AnchorPoint = Vector2.new(1, 0.5)
            DropButton.Position = UDim2.new(1, -10, 0.5, 0)
            DropButton.Size = UDim2.new(0, 30, 0, 30)
            DropButton.BackgroundTransparency = 1
            DropButton.Text = "▼"
            DropButton.TextColor3 = Colors.Text
            DropButton.FontFace = OSWALDFONT
            DropButton.TextSize = 16
            DropButton.Parent = DropdownFrame
            
            local Values = config.Values or {}
            local Selected = config.Value or Values[1]
            
            local DropListFrame = Instance.new("Frame")
            DropListFrame.Name = "DropListFrame"
            DropListFrame.Size = UDim2.new(0.9, 0, 0, 0)
            DropListFrame.BackgroundColor3 = Colors.Foreground
            DropListFrame.BackgroundTransparency = 0.1
            DropListFrame.Visible = false
            DropListFrame.ClipsDescendants = true
            
            local ListCorner = Instance.new("UICorner")
            ListCorner.CornerRadius = UDim.new(0, 6)
            ListCorner.Parent = DropListFrame
            
            local ListStroke = Instance.new("UIStroke")
            ListStroke.Color = Colors.Border
            ListStroke.Thickness = 1
            ListStroke.Parent = DropListFrame
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 2)
            ListLayout.Parent = DropListFrame
            
            local isOpen = false
            
            local function updateOptions()
                for i, option in ipairs(Values) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = option .. "Option"
                    OptionButton.Size = UDim2.new(1, 0, 0, 36)
                    OptionButton.BackgroundColor3 = Colors.Button
                    OptionButton.BackgroundTransparency = 0.3
                    OptionButton.Text = option
                    OptionButton.TextColor3 = Colors.Text
                    OptionButton.FontFace = OSWALDFONT
                    OptionButton.TextSize = 14
                    OptionButton.AutoButtonColor = false
                    OptionButton.LayoutOrder = i
                    
                    local OptionCorner = Instance.new("UICorner")
                    OptionCorner.CornerRadius = UDim.new(0, 4)
                    OptionCorner.Parent = OptionButton
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        Selected = option
                        DropLabel.Text = config.Title .. ": " .. Selected
                        isOpen = false
                        DropListFrame.Visible = false
                        
                        game:GetService("TweenService"):Create(
                            DropListFrame,
                            TweenInfo.new(0.2),
                            {Size = UDim2.new(0.9, 0, 0, 0)}
                        ):Play()
                        
                        if config.Callback then
                            config.Callback(Selected)
                        end
                    end)
                    
                    OptionButton.MouseEnter:Connect(function()
                        OptionButton.BackgroundTransparency = 0.1
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        OptionButton.BackgroundTransparency = 0.3
                    end)
                    
                    OptionButton.Parent = DropListFrame
                end
            end
            
            updateOptions()
            DropLabel.Text = config.Title .. ": " .. Selected
            
            DropButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    DropListFrame.Visible = true
                    local listHeight = #Values * 38 + 4
                    
                    game:GetService("TweenService"):Create(
                        DropListFrame,
                        TweenInfo.new(0.2),
                        {Size = UDim2.new(0.9, 0, 0, listHeight)}
                    ):Play()
                else
                    game:GetService("TweenService"):Create(
                        DropListFrame,
                        TweenInfo.new(0.2),
                        {Size = UDim2.new(0.9, 0, 0, 0)}
                    ):Play()
                    
                    task.wait(0.2)
                    DropListFrame.Visible = false
                end
            end)
            
            DropdownFrame.Parent = Tab.ScrollingFrame
            DropListFrame.Parent = Tab.ScrollingFrame
        end
        
        Tab:CreateContent()
        
        return Tab
    end
    
    function Window:SelectTab(tab)
        for _, t in ipairs(Window.Tabs) do
            if t.TabButton then
                t.TabButton.BackgroundTransparency = 0.4
                t.TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            if t.ContentFrame then
                t.ContentFrame.Visible = false
            end
        end
        
        if tab.TabButton then
            tab.TabButton.BackgroundTransparency = 0.2
            tab.TabButton.TextColor3 = Colors.Text
        end
        if tab.ContentFrame then
            tab.ContentFrame.Visible = true
        end
        
        Window.CurrentTab = table.find(Window.Tabs, tab) or 1
    end
    
    return Window
end

return XKUI