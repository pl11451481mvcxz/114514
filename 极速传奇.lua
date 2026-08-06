-- 光球收集器 (Fluent UI版)
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/Beta.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "光球收集器",
    SubTitle = "By User",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl,
})

-- 服务初始化
local replicatedStorage = game:GetService("ReplicatedStorage")
local orbEvent = replicatedStorage:WaitForChild("rEvents"):WaitForChild("orbEvent")

-- 变量
local isAutoCollecting = false
local collectInterval = 1

-- 收集函数
local function collectOrb(orbType, location)
    local args = {"collectOrb", orbType, location}
    orbEvent:FireServer(unpack(args))
end

local function collectAll(location)
    local items = {"Red Orb", "Yellow Orb", "Orange Orb", "Gem"}
    for _, item in ipairs(items) do
        collectOrb(item, location)
        task.wait(0.05)
    end
end

-- ============== 标签页 ==============
local Tabs = {
    Main = Window:AddTab({ Title = "主页", Icon = "home" }),
    Auto = Window:AddTab({ Title = "自动", Icon = "refresh-cw" }),
    Settings = Window:AddTab({ Title = "设置", Icon = "settings" })
}

-- ============== 主页 ==============
Tabs.Main:AddButton({
    Title = "收集全部",
    Description = "红光 + 黄光 + 橙光 + 钻石",
    Callback = function()
        collectAll("City")
        Fluent:Notify({
            Title = "光球收集器",
            Content = "已收集全部物品！",
            Duration = 3
        })
    end
})

Tabs.Main:AddButton({
    Title = "收集红光",
    Description = "Red Orb",
    Callback = function()
        collectOrb("Red Orb", "City")
        Fluent:Notify({
            Title = "光球收集器",
            Content = "已收集红光",
            Duration = 2
        })
    end
})

Tabs.Main:AddButton({
    Title = "收集黄光",
    Description = "Yellow Orb",
    Callback = function()
        collectOrb("Yellow Orb", "City")
        Fluent:Notify({
            Title = "光球收集器",
            Content = "已收集黄光",
            Duration = 2
        })
    end
})

Tabs.Main:AddButton({
    Title = "收集橙光",
    Description = "Orange Orb",
    Callback = function()
        collectOrb("Orange Orb", "City")
        Fluent:Notify({
            Title = "光球收集器",
            Content = "已收集橙光",
            Duration = 2
        })
    end
})

Tabs.Main:AddButton({
    Title = "收集钻石",
    Description = "Gem",
    Callback = function()
        collectOrb("Gem", "City")
        Fluent:Notify({
            Title = "光球收集器",
            Content = "已收集钻石",
            Duration = 2
        })
    end
})

-- ============== 自动 ==============
local AutoToggle = Tabs.Auto:AddToggle("AutoToggle", {
    Title = "自动收集",
    Description = "开启后自动循环收集",
    Default = false,
    Callback = function(value)
        isAutoCollecting = value
    end
})

Tabs.Auto:AddSlider("IntervalSlider", {
    Title = "收集间隔(秒)",
    Description = "自动收集的间隔时间",
    Default = 1,
    Min = 0.1,
    Max = 5,
    Rounding = 1,
    Callback = function(value)
        collectInterval = value
    end
})

-- 自动收集循环
task.spawn(function()
    while task.wait(collectInterval) do
        if isAutoCollecting then
            collectAll("City")
        end
    end
end)

-- ============== 设置 ==============
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/OrbCollector")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "光球收集器",
    Content = "脚本已加载！",
    Duration = 5
})

SaveManager:LoadAutoloadConfig()
