-- Serviços
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "Oren Client"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Painel principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,600,0,300)
mainFrame.Position = UDim2.new(0.5,-300,0.5,-150)
mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5,0.5)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,12)

-- Gradiente principal (vermelho -> preto)
local gradient = Instance.new("UIGradient", mainFrame)
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))
}
gradient.Rotation = 90

-- Animação do gradiente
task.spawn(function()
	while mainFrame.Parent do
		for i=0,1,0.01 do
			gradient.Offset = Vector2.new(0,i)
			task.wait(0.03)
		end
		for i=1,0,-0.01 do
			gradient.Offset = Vector2.new(0,i)
			task.wait(0.03)
		end
	end
end)

-- Partículas de brilho no fundo
local particles = Instance.new("ParticleEmitter", mainFrame)
particles.Rate = 5
particles.Lifetime = NumberRange.new(2,3)
particles.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(1,0.5)})
particles.Speed = NumberRange.new(5,10)
particles.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(1,0.8)})
particles.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
particles.Acceleration = Vector3.new(0,-10,0)
particles.Rotation = NumberRange.new(0,360)
particles.RotSpeed = NumberRange.new(-90,90)

-- Partículas seguindo o mouse
local mouse = player:GetMouse()
local mouseParticles = Instance.new("ParticleEmitter", mainFrame)
mouseParticles.Rate = 10
mouseParticles.Lifetime = NumberRange.new(0.2,0.5)
mouseParticles.Speed = NumberRange.new(0,0)
mouseParticles.Size = NumberSequence.new(0.15)
mouseParticles.Transparency = NumberSequence.new(0.5)
mouseParticles.Color = ColorSequence.new(Color3.fromRGB(255,50,50))
mouseParticles.EmissionDirection = Enum.NormalId.Top

task.spawn(function()
	while task.wait(0.03) do
		mouseParticles.Position = UDim2.new(0,mouse.X - mainFrame.AbsolutePosition.X,0,mouse.Y - mainFrame.AbsolutePosition.Y)
	end
end)

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

-- Botões fechar e minimizar
local function createButton(text, posX)
	local btn = Instance.new("TextButton", mainFrame)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 28
	btn.TextColor3 = Color3.fromRGB(255,100,100)
	btn.Size = UDim2.new(0,40,0,40)
	btn.Position = UDim2.new(1,-posX,0,5)
	btn.BackgroundTransparency = 1
	return btn
end

local closeBtn = createButton("×",50)
closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local minimizeBtn = createButton("-",100)
local logoBtn = Instance.new("ImageButton", gui)
logoBtn.Size = UDim2.new(0,60,0,60)
logoBtn.Position = UDim2.new(0,20,1,-80)
logoBtn.Image = "rbxassetid://133785217398803"
logoBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", logoBtn).CornerRadius = UDim.new(0,14)
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
end)

-- Barra lateral
local tabsHolder = Instance.new("Frame", mainFrame)
tabsHolder.Size = UDim2.new(0,120,1,-60)
tabsHolder.Position = UDim2.new(0,10,0,50)
tabsHolder.BackgroundTransparency = 1

-- Conteúdo
local contentHolder = Instance.new("Frame", mainFrame)
contentHolder.Size = UDim2.new(1,-150,1,-60)
contentHolder.Position = UDim2.new(0,140,0,50)
contentHolder.BackgroundColor3 = Color3.fromRGB(20,20,20)
contentHolder.BorderSizePixel = 0

-- Abas
local tabs = {
	{Name="Top Scripts", Order=1},
	{Name="Visual", Order=2},
	{Name="Utils", Order=3},
	{Name="Troll", Order=4},
}
local currentTab = nil
local indicator = Instance.new("Frame", tabsHolder)
indicator.Size = UDim2.new(1,0,0,35)
indicator.BackgroundColor3 = Color3.fromRGB(255,0,0)
indicator.ZIndex = 1
Instance.new("UICorner", indicator).CornerRadius = UDim.new(0,8)

-- Função criar conteúdo
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

	return frame
end

-- Função criar botão
local function createTabButton(name,order)
	local btn = Instance.new("TextButton")
	btn.Name = name.."Tab"
	btn.Text = name
	btn.Font = Enum.Font.Gotham
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.TextSize = 16
	btn.Size = UDim2.new(1,0,0,35)
	btn.Position = UDim2.new(0,0,0,(order-1)*40)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.BorderSizePixel = 0
	btn.Parent = tabsHolder
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

	-- Hover efeito
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(200,0,0)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		if currentTab ~= name then
			TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(50,50,50)}):Play()
		end
	end)

	btn.MouseButton1Click:Connect(function()
		switchTab(name)
	end)

	return btn
end

-- Alternar abas com fade e glow
local function switchTab(name)
	if currentTab then
		local old = contentHolder:FindFirstChild(currentTab.."Content")
		if old then
			TweenService:Create(old,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
			task.wait(0.3)
			old.Visible = false
		end
	end
	local newTab = contentHolder:FindFirstChild(name.."Content")
	if newTab then
		newTab.Visible = true
		newTab.BackgroundTransparency = 1
		TweenService:Create(newTab,TweenInfo.new(0.3),{BackgroundTransparency=0}):Play()
		currentTab = name
		for i,tab in pairs(tabs) do
			if tab.Name == name then
				TweenService:Create(indicator,TweenInfo.new(0.2),{Position=UDim2.new(0,0,0,(tab.Order-1)*40)}):Play()
			end
		end
	end
end

-- Criar abas e conteúdo
for _,tab in pairs(tabs) do
	createTabContent(tab.Name)
	createTabButton(tab.Name,tab.Order)
end

-- Ativar aba padrão
switchTab("Top Scripts")
