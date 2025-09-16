-- Serviços
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "Oren Client"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Título
local title = Instance.new("TextLabel", mainFrame)
title.Text = "Oren Client | Portugues | Brookhave"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

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

-- Criar botões verticais
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

-- Área de conteúdo
local contentHolder = Instance.new("Frame", mainFrame)
contentHolder.Size = UDim2.new(1, -150, 1, -60)
contentHolder.Position = UDim2.new(0, 140, 0, 30)
contentHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
contentHolder.BorderSizePixel = 0
contentHolder.Name = "ContentHolder"

-- Função para criar botões de aba
local function createTabButton(name, order)
	local btn = Instance.new("TextButton")
	btn.Name = name.."Tab"
	btn.Text = name
	btn.Font = Enum.Font.Gotham
	btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	btn.TextSize = 16
	btn.Size = UDim2.new(0, 100, 1, 0)
	btn.Position = UDim2.new(0, (order-1)*110, 0, 0)
	btn.BackgroundTransparency = 1
	btn.Parent = tabsHolder
	return btn
end
