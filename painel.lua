-- Serviços
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "Oren Client"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Painel principal com gradiente
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 620, 0, 320)
mainFrame.Position = UDim2.new(0.5, -310, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Título
local title = Instance.new("TextLabel", mainFrame)
title.Text = "Oren Client | Portugues | Brookhaven"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

-- Gradiente vermelho/preto
local gradient = Instance.new("UIGradient", mainFrame)
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
}
gradient.Rotation = 90

-- Animação do gradiente
task.spawn(function()
	while mainFrame.Parent do
		for i = 0, 1, 0.02 do
			gradient.Offset = Vector2.new(0, i)
			task.wait(0.05)
		end
	end
end)

-- Partículas caindo
local particles = Instance.new("ParticleEmitter", mainFrame)
particles.Rate = 6
particles.Lifetime = NumberRange.new(2, 3)
particles.Size = NumberSequence.new(0.2)
particles.Speed = NumberRange.new(10, 15)
particles.Transparency = NumberSequence.new(0.5)
particles.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
particles.Acceleration = Vector3.new(0, -15, 0)

-- Barra lateral (esquerda)
local tabsHolder = Instance.new("Frame", mainFrame)
tabsHolder.Size = UDim2.new(0, 120, 1, -40)
tabsHolder.Position = UDim2.new(0, 10, 0, 30)
tabsHolder.BackgroundTransparency = 1
tabsHolder.Name = "TabsHolder"

-- Área de conteúdo
local contentHolder = Instance.new("Frame", mainFrame)
contentHolder.Size = UDim2.new(1, -150, 1, -60)
contentHolder.Position = UDim2.new(0, 140, 0, 30)
contentHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
contentHolder.BorderSizePixel = 0
contentHolder.Name = "ContentHolder"

-- Lista de abas
local tabs = {
	{ Name = "Top Scripts", Order = 1 },
	{ Name = "Visual", Order = 2 },
	{ Name = "Utils", Order = 3 },
	{ Name = "Troll", Order = 4 },
}

-- Função para criar conteúdo de cada aba
local function createTabContent(name)
	local frame = Instance.new("Frame")
	frame.Name = name.."Content"
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 0
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.Visible = false
	frame.Parent = contentHolder

	local label = Instance.new("TextLabel", frame)
	label.Text = "Conteúdo da aba " .. name
	label.Size = UDim2.new(1, 0, 0, 30)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 20
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Left

	return frame
end

-- Função para criar botões da barra lateral
local function createTabButton(name, order)
	local btn = Instance.new("TextButton")
	btn.Name = name.."Tab"
	btn.Text = name
	btn.Font = Enum.Font.Gotham
	btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	btn.TextSize = 16
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.Position = UDim2.new(0, 0, 0, (order-1)*50)
	btn.BackgroundTransparency = 1
	btn.Parent = tabsHolder
	return btn
end

-- Alternar abas
local currentTab = nil
local function switchTab(name)
	if currentTab then
		local old = contentHolder:FindFirstChild(currentTab.."Content")
		if old then old.Visible = false end
	end
	local newTab = contentHolder:FindFirstChild(name.."Content")
	if newTab then
		newTab.Visible = true
		currentTab = name
	end
end

-- Criar abas e conteúdo
for _, tab in pairs(tabs) do
	createTabContent(tab.Name)
	local btn = createTabButton(tab.Name, tab.Order)
	btn.MouseButton1Click:Connect(function()
		switchTab(tab.Name)
	end)
end

-- Ativar aba padrão
switchTab("Top Scripts")
