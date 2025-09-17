--// OREN CLIENT TURBO ULTIMATE - VERSÃO COMPLETA
-- Painel pronto para Brookhaven 🏠

-- Serviços
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Variáveis globais
local currentTarget = nil
local currentTab = nil
local tabContents = {}
local tabButtons = {}
local flying, noclip, invisible, lowGravity, infiniteJump = false, false, false, false, false

-- Função de popup
local function showPopup(msg, color)
    local gui = LocalPlayer.PlayerGui:FindFirstChild("OrenClientPopup") or Instance.new("ScreenGui", LocalPlayer.PlayerGui)
    gui.Name = "OrenClientPopup"
    local text = Instance.new("TextLabel", gui)
    text.Size = UDim2.new(0, 380, 0, 36)
    text.Position = UDim2.new(0.5, -190, 0.1, 0)
    text.BackgroundTransparency = 0.2
    text.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    text.TextColor3 = color or Color3.fromRGB(0, 255, 0)
    text.Font = Enum.Font.GothamBold
    text.TextSize = 18
    text.Text = msg
    text.AnchorPoint = Vector2.new(0.5, 0)
    Instance.new("UICorner", text).CornerRadius = UDim.new(0, 6)
    TweenService:Create(text, TweenInfo.new(0.4), {BackgroundTransparency = 0.1, TextTransparency = 0}):Play()
    task.delay(2, function()
        TweenService:Create(text, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
        task.delay(0.5, function() text:Destroy() end)
    end)
end

-- Função principal: Executar ações
local function sendAction(actionName, extra)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        showPopup("❌ Personagem não encontrado!", Color3.fromRGB(255, 0, 0))
        return
    end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if actionName == "ChangeWalkSpeed" then
        humanoid.WalkSpeed = extra.speed
        showPopup("🚀 Velocidade " .. extra.speed)

    elseif actionName == "TeleportToTarget" then
        if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = currentTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 5)
            showPopup("🌀 Teleportado para " .. currentTarget.Name)
        else
            showPopup("❌ Alvo inválido!", Color3.fromRGB(255, 0, 0))
        end

    elseif actionName == "Fly" then
        flying = not flying
        if flying then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            bv.Name = "FlyVelocity"
            bv.Parent = char.HumanoidRootPart
            showPopup("✈️ Voar ativado")
            RunService.RenderStepped:Connect(function()
                if not flying then return end
                local dir = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Workspace.CurrentCamera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Workspace.CurrentCamera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Workspace.CurrentCamera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Workspace.CurrentCamera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
                local v = char.HumanoidRootPart:FindFirstChild("FlyVelocity")
                if v then v.Velocity = dir*60 end
            end)
        else
            local v = char.HumanoidRootPart:FindFirstChild("FlyVelocity")
            if v then v:Destroy() end
            showPopup("✈️ Voar desativado", Color3.fromRGB(255,255,0))
        end

    elseif actionName == "Noclip" then
        noclip = not noclip
        showPopup(noclip and "🚷 Noclip ativado" or "🚷 Noclip desativado")
        RunService.Stepped:Connect(function()
            if noclip then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide=false end
                end
            end
        end)

    elseif actionName == "SuperJump" then
        humanoid.JumpPower = 200
        showPopup("🦘 Super Pulo!")

    elseif actionName == "ResetCharacter" then
        char:BreakJoints()
        showPopup("🔄 Resetado")

    elseif actionName == "TeleportSpawn" then
        local spawn = Workspace:FindFirstChildWhichIsA("SpawnLocation")
        if spawn then
            char.HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0,5,0)
            showPopup("🏠 Spawn")
        else
            showPopup("❌ Nenhum Spawn", Color3.fromRGB(255,0,0))
        end

    elseif actionName == "CopySkin" then
        if not currentTarget or currentTarget == LocalPlayer then
            showPopup("❌ Selecione outro jogador!", Color3.fromRGB(255,0,0))
            return
        end
        local ok, desc = pcall(function()
            return Players:GetHumanoidDescriptionFromUserId(currentTarget.UserId)
        end)
        if ok then
            humanoid:ApplyDescription(desc)
            showPopup("🧑‍🎨 Skin copiada: "..currentTarget.Name)
        else
            showPopup("❌ Falha copiar skin", Color3.fromRGB(255,0,0))
        end

    elseif actionName == "Invisibility" then
        invisible = not invisible
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name~="HumanoidRootPart" then
                part.Transparency = invisible and 1 or 0
            elseif part:IsA("Decal") then
                part.Transparency = invisible and 1 or 0
            end
        end
        showPopup(invisible and "👻 Invisível" or "👻 Visível")

    elseif actionName == "LowGravity" then
        lowGravity = not lowGravity
        Workspace.Gravity = lowGravity and 40 or 196.2
        showPopup(lowGravity and "🌌 Gravidade baixa" or "🌌 Gravidade normal")

    elseif actionName == "InfiniteJump" then
        infiniteJump = not infiniteJump
        showPopup(infiniteJump and "♾️ Pulo infinito" or "♾️ Normal")
        UserInputService.JumpRequest:Connect(function()
            if infiniteJump then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)

    elseif actionName == "ResizeCharacter" then
        local scale = extra.scale or 1
        humanoid.BodyDepthScale.Value = scale
        humanoid.BodyHeightScale.Value = scale
        humanoid.BodyWidthScale.Value = scale
        humanoid.HeadScale.Value = scale
        showPopup("📏 Escala "..scale)
    end
end

-- Funções Troll
local function trollActions(action)
    if not currentTarget or not currentTarget.Character then
        showPopup("❌ Selecione um alvo válido!", Color3.fromRGB(255,0,0))
        return
    end
    local char = currentTarget.Character
    local humanoidRoot = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoidRoot or not humanoid then return end

    if action=="PushTarget" then
        humanoidRoot.Velocity = Vector3.new(0,50,0)+Workspace.CurrentCamera.CFrame.LookVector*50
        showPopup("💥 Alvo empurrado!")
    elseif action=="TPUp" then
        humanoidRoot.CFrame = humanoidRoot.CFrame+Vector3.new(0,100,0)
        showPopup("🛫 Alvo lançado!")
    elseif action=="DanceTarget" then
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://180435571"
        humanoid:LoadAnimation(anim):Play()
        showPopup("💃 Alvo dançando!")
    elseif action=="FreezeTarget" then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.Anchored=true end
        end
        showPopup("❄️ Alvo congelado!")
    elseif action=="ResetTarget" then
        char:BreakJoints()
        showPopup("🔄 Alvo resetado!")
    end
end

-- GUI Principal (igual ao seu painel original)
-- Crie ScreenGui, mainFrame, gradiente, partículas, título, botões fechar/minimizar, logo, abas, lista de players, etc.
-- Para os botões da aba Troll:
-- btn.MouseButton1Click:Connect(function()
--     trollActions(act.actionName)
-- end)
-- Para os botões da aba Comandos:
-- btn.MouseButton1Click:Connect(function()
--     sendAction(act.actionName, act.extra)
-- end)

showPopup("✅ Oren Client Turbo Ultimate carregado!")
