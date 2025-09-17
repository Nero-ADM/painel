-- Serviços
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Variáveis globais
local currentTarget = nil
local currentTab = nil
local tabContents = {}
local tabButtons = {}

-- Função de envio (para comandos locais)
local function sendAction(actionName, extra)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        warn("Personagem não encontrado ou HumanoidRootPart ausente!")
        return
    end

    if actionName == "ChangeWalkSpeed" then
        char.Humanoid.WalkSpeed = extra.speed
        print("Velocidade de caminhada alterada para: " .. extra.speed)
    elseif actionName == "TeleportToTarget" then
        if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = currentTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 5)
            print("Teleportado para o alvo: " .. currentTarget.Name)
        else
            warn("Alvo inválido para teletransporte!")
        end
    end
end

-- GUI Principal
local gui = Instance.new("ScreenGui")
gui.Name = "Oren Client"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Painel principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 350)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Gradiente principal
local gradient = Instance.new("UIGradient", mainFrame)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
gradient.Rotation = 90

-- Partículas
local particles = Instance.new("ParticleEmitter", mainFrame)
particles.Rate = 5
particles.Lifetime = NumberRange.new(2, 3)
particles.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 0.5) })
particles.Speed = NumberRange.new(5, 10)
particles.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 0.8) })
particles.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
particles.Acceleration = Vector3.new(0, -10, 0)

-- Título
local title = Instance.new("TextLabel", mainFrame)
title.Text = "Oren Client | Brookhaven 🏠"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

-- Botões fechar e minimizar
local function createTitleButton(text, posX)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 28
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.Size = UDim2.new(0, 40, 0, 40)
    btn.Position = UDim2.new(1, -posX, 0, 5)
    btn.BackgroundTransparency = 1
    return btn
end

local closeBtn = createTitleButton("×", 50)
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local minimizeBtn = createTitleButton("-", 100)
local logoBtn = Instance.new("ImageButton", gui)
logoBtn.Size = UDim2.new(0, 60, 0, 60)
logoBtn.Position = UDim2.new(0, 20, 1, -80)
logoBtn.Image = "rbxassetid://133785217398803"
logoBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
logoBtn.BackgroundTransparency = 0.2
Instance.new("UICorner", logoBtn).CornerRadius = UDim.new(0, 14)
logoBtn.Visible = false
local isMinimized = false

minimizeBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        mainFrame.Visible = true
        logoBtn.Visible = false
        isMinimized = false
    else
        mainFrame.Visible = false
        logoBtn.Visible = true
        isMinimized = true
    end
end)

logoBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    logoBtn.Visible = false
    isMinimized = false
end)

-- Barra lateral de abas
local tabsHolder = Instance.new("Frame", mainFrame)
tabsHolder.Size = UDim2.new(0, 120, 1, -60)
tabsHolder.Position = UDim2.new(0, 10, 0, 50)
tabsHolder.BackgroundTransparency = 1
local tabsLayout = Instance.new("UIListLayout", tabsHolder)
tabsLayout.Padding = UDim.new(0, 5)
tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Conteúdo das abas
local contentHolder = Instance.new("Frame", mainFrame)
contentHolder.Size = UDim2.new(1, -150, 1, -60)
contentHolder.Position = UDim2.new(0, 140, 0, 50)
contentHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
contentHolder.BackgroundTransparency = 0.2
contentHolder.BorderSizePixel = 0
Instance.new("UICorner", contentHolder).CornerRadius = UDim.new(0, 10)

-- Definição das abas
local tabs = {
    { Name="Comandos", Order=1, Emoji="⚙️", Actions={
        {label="Velocidade 30", actionName="ChangeWalkSpeed", extra={speed=30}},
        {label="Velocidade 50", actionName="ChangeWalkSpeed", extra={speed=50}},
        {label="Teleportar para Alvo", actionName="TeleportToTarget", emoji="🚀"}
    }},
    { Name="Carro", Order=2, Emoji="🚗", Actions={
        {label="Ações de Carro", actionName="None", emoji="💥"},
        {label="Esses comandos precisam", actionName="None", emoji="📥"},
        {label="de um script no servidor!", actionName="None", emoji="⚠️"}
    }},
    { Name="Sofá", Order=3, Emoji="🛋️", Actions={
        {label="Ações de Sofá", actionName="None", emoji="⚡"},
        {label="Esses comandos precisam", actionName="None", emoji="📥"},
        {label="de um script no servidor!", actionName="None", emoji="⚠️"}
    }},
}

-- Funções para criar e gerenciar a UI
local function createTabContent(name, actions)
    local frame = Instance.new("Frame")
    frame.Name = name .. "Content"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.2
    frame.Visible = false
    frame.Parent = contentHolder
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    -- Player selecionado
    local selectedLabel = Instance.new("TextLabel", frame)
    selectedLabel.Size = UDim2.new(1, 0, 0, 30)
    selectedLabel.Position = UDim2.new(0, 0, 0, 0)
    selectedLabel.Font = Enum.Font.GothamBold
    selectedLabel.TextSize = 18
    selectedLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Text = "Alvo: Nenhum"

    -- Lista de players
    local playersFrame = Instance.new("ScrollingFrame", frame)
    playersFrame.Size = UDim2.new(0.4, -10, 1, -40)
    playersFrame.Position = UDim2.new(0, 5, 0, 40)
    playersFrame.ScrollBarThickness = 6
    playersFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    playersFrame.BackgroundTransparency = 0.2
    Instance.new("UICorner", playersFrame).CornerRadius = UDim.new(0, 8)

    local listLayout = Instance.new("UIListLayout", playersFrame)
    listLayout.Padding = UDim.new(0, 4)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function refreshPlayers()
        for _, child in ipairs(playersFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        for i, plr in ipairs(Players:GetPlayers()) do
            local btn = Instance.new("TextButton", playersFrame)
            btn.Size = UDim2.new(1, -6, 0, 28)
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.BackgroundTransparency = 0.2
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            btn.LayoutOrder = i

            btn.MouseButton1Click:Connect(function()
                currentTarget = plr
                selectedLabel.Text = "Alvo: " .. plr.Name
            end)
        end
        playersFrame.CanvasSize = UDim2.new(0, 0, 0, (#Players:GetPlayers() * 32) + 4)
    end

    refreshPlayers()
    Players.PlayerAdded:Connect(refreshPlayers)
    Players.PlayerRemoving:Connect(refreshPlayers)

    -- Botões de ações
    local actionsFrame = Instance.new("ScrollingFrame", frame)
    actionsFrame.Size = UDim2.new(0.6, -10, 1, -40)
    actionsFrame.Position = UDim2.new(0.4, 10, 0, 40)
    actionsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    actionsFrame.BackgroundTransparency = 0.2
    actionsFrame.ScrollBarThickness = 6
    Instance.new("UICorner", actionsFrame).CornerRadius = UDim.new(0, 8)

    local actionsList = Instance.new("UIListLayout", actionsFrame)
    actionsList.Padding = UDim.new(0, 6)

    for i, act in ipairs(actions) do
        local btn = Instance.new("TextButton", actionsFrame)
        btn.Size = UDim2.new(1, -10, 0, 32)
        btn.Text = act.emoji .. " " .. act.label
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 16
        btn.TextColor3 = Color3.fromRGB(240, 240, 240)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        btn.BackgroundTransparency = 0.2
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.LayoutOrder = i

        btn.MouseButton1Click:Connect(function()
            sendAction(act.actionName, act.extra)
        end)
    end
    actionsFrame.CanvasSize = UDim2.new(0, 0, 0, (#actions * 38) + 6)

    return frame
end

local function createTabButton(name, order, emoji)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Tab"
    btn.Text = emoji .. " " .. name
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.Parent = tabsHolder
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    -- Efeitos de hover
    btn.MouseEnter:Connect(function()
        if currentTab ~= name then
            TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(200, 0, 0) }):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if currentTab ~= name then
            TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(50, 50, 50) }):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)

    tabButtons[name] = btn
end

-- Função para alternar entre as abas
local function switchTab(name)
    if currentTab and tabContents[currentTab] and tabButtons[currentTab] then
        tabContents[currentTab].Visible = false
        TweenService:Create(tabButtons[currentTab], TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(50, 50, 50) }):Play()
    end

    if tabContents[name] then
        tabContents[name].Visible = true
        TweenService:Create(tabButtons[name], TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(200, 0, 0) }):Play()
        currentTab = name
    end
end

-- Criação das abas
for _, tab in ipairs(tabs) do
    tabContents[tab.Name] = createTabContent(tab.Name, tab.Actions)
    createTabButton(tab.Name, tab.Order, tab.Emoji)
end

-- Ativa a aba padrão
switchTab("Comandos")

print("Oren Client GUI carregado com lista de players e alvo selecionado")
