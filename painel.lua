-- Serviços
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "Oren Client"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Painel principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,600,0,300) -- painel um pouco menor
mainFrame.Position = UDim2.new(0.5,-300,0.5,-150)
mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5,0.5)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,12)

-- Gradiente animado
local gradient = Instance.new("UIGradient", mainFrame)
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))
}
gradient.Rotation = 90

task.spawn(function()
	while mainFrame.Parent do
		for i=0,1,0.02 do
			gradient.Offset = Vector2.new(0,i)
			task.wait(0.03)
		end
	end
end)

-- Partículas melhoradas
local particles = Instance.new("ParticleEmitter", mainFrame)
particles.Rate = 6
particles.Lifetime = NumberRange.new(2,3)
particles.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(1,0.5)})
particles.Speed = NumberRange.new(5,12)
particles.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(1,1)})
particles.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
particles.Acceleration = Vector3.new(0,-15,0)
particles.Rotation = NumberRange.new(0,360)
particles.RotSpeed = NumberRange.new(-90,90)

-- Título
local title = Instance.new("TextLabel", mainFrame)
title.Text = "Oren Client | Português | Brookhaven"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 20
title.Size = UDim2.new(1,-20,0,30)
title.Position = UDim2.new(0,10,0,10)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

-- Barra lateral (esquerda)
local tabsHolder = Instance.new("Frame", mainFrame)
tabsHolder.Size = UDim2.new(0,120,1,-60) -- menor altura para não sobrepor título
tabsHolder.Position = UDim2.new(0,10,0,50) -- abaixo do título
tabsHolder.BackgroundTransparency = 1

-- Área de conteúdo
local contentHolder = Instance.new("Frame", mainFrame)
contentHolder.Size = UDim2.new(1,-150,1,-60)
contentHolder.Position = UDim2.new(0,140,0,50)
contentHolder.BackgroundColor3 = Color3.fromRGB(20,20,20)
contentHolder.BorderSizePixel = 0

-- Lista de abas
local tabs = {
	{Name="Top Scripts", Order=1},
	{Name="Visual", Order=2},
	{Name="Utils", Order=3},
	{Name="Troll", Order=4},
}

-- Função para criar conteúdo de cada aba com fade
local function createTabContent(name)
	local frame = Instance.new("Frame")
	frame.Name = name.."Content"
	frame.Size = UDim2.new(1,0,1,0)
	frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
	frame.BackgroundTransparency = 1
	frame.Visible = false
	frame.Parent = contentHolder

	local label = Instance.new("TextLabel", frame)
	label.Text = "Conteúdo da aba "..name
	label.Size = UDim2.new(1,0,0,30)
	label.Position = UDim2.new(0,0,0,0)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 18
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Left

	-- Exemplo de botão Utils
	if name=="Utils" then
		local btn = Instance.new("TextButton", frame)
		btn.Size = UDim2.new(0,140,0,35)
		btn.Position = UDim2.new(0,10,0,50)
		btn.Text = "Ativar Script"
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 16
		btn.TextColor3 = Color3.fromRGB(255,255,255)
		btn.BackgroundColor3 = Color3.fromRGB(255,70,70)
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
		btn.MouseButton1Click:Connect(function()
			loadstring(game:HttpGet("https://pastebin.com/raw/PZt4tguj"))()
		end)
	end

	return frame
end

-- Função para criar botão lateral
local function createTabButton(name, order)
	local btn = Instance.new("TextButton")
	btn.Name = name.."Tab"
	btn.Text = name
	btn.Font = Enum.Font.Gotham
	btn.TextColor3 = Color3.fromRGB(200,200,200)
	btn.TextSize = 16
	btn.Size = UDim2.new(1,0,0,35) -- aba menor
	btn.Position = UDim2.new(0,0,0,(order-1)*40) -- espaçamento reduzido
	btn.BackgroundTransparency = 1
	btn.Parent = tabsHolder

	-- Hover animado
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3=Color3.fromRGB(255,0,0)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3=Color3.fromRGB(200,200,200)}):Play()
	end)

	return btn
end

-- Alternar abas com fade
local currentTab = nil
local function switchTab(name)
	if currentTab then
		local old = contentHolder:FindFirstChild(currentTab.."Content")
		if old then
			TweenService:Create(old, TweenInfo.new(0.3), {BackgroundTransparency=1}):Play()
			task.wait(0.3)
			old.Visible=false
		end
	end
	local newTab = contentHolder:FindFirstChild(name.."Content")
	if newTab then
		newTab.Visible = true
		newTab.BackgroundTransparency = 1
		TweenService:Create(newTab, TweenInfo.new(0.3), {BackgroundTransparency=0}):Play()
		currentTab = name
	end
end

-- Criar abas e conteúdo
for _,tab in pairs(tabs) do
	createTabContent(tab.Name)
	local btn = createTabButton(tab.Name,tab.Order)
	btn.MouseButton1Click:Connect(function()
		switchTab(tab.Name)
	end)
end

-- Ativar aba padrão
switchTab("Top Scripts")
