-- REQUISIÇÃO DA BIBLIOTECA RAYFIELD UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- CONFIGURAÇÕES DO HUB
local CHAVE_CORRETA = "PABLOHUB1"
local LINK_DA_KEY = "https://link-hub.net"

-- VARIÁVEIS DE CONTROLE
local lp = game:GetService("Players").LocalPlayer
local noclipActive = false
local flyActive = false

-- CRIAÇÃO DA JANELA PRINCIPAL (COM SISTEMA DE KEY INTEGRADO)
local Window = Rayfield:CreateWindow({
   Name = "PABLO HUB",
   LoadingTitle = "Carregando Configurações...",
   LoadingSubtitle = "by Pablo",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = true, -- Ativa o sistema de verificação integrado
   KeySettings = {
      Title = "Sistema de Key | PABLO HUB",
      Subtitle = "Insira a chave correta para acessar",
      Note = "Clique em 'Copiar Link' para obter a chave pelo encurtador",
      FileName = "PabloHubKey",
      SaveKey = false,
      GrabKeyFromUrl = false,
      Key = {CHAVE_CORRETA}
   }
})

-- NOTIFICAÇÃO DE INICIALIZAÇÃO SUCEDIDA
Rayfield:Notify({
   Title = "Autenticado!",
   Content = "Seja bem-vindo ao PABLO HUB.",
   Duration = 5,
   Image = 4483362458,
})

-- CRIANDO AS ABAS NO MENU
local PrincipalTab = Window:CreateTab("Principal", 4483362458) -- Aba de utilitários
local InfoTab = Window:CreateTab("Informações", 4483362458) -- Aba do link

-- ----------------------------------------------------
-- CONTEÚDO DA ABA PRINCIPAL
-- ----------------------------------------------------

-- Alternador de Fly (Voo)
local FlyToggle = PrincipalTab:CreateToggle({
   Name = "Ativar Fly (Voar)",
   CurrentValue = false,
   Flag = "FlyFlag",
   Callback = function(Value)
      flyActive = Value
      local char = lp.Character
      if not char or not char:FindFirstChild("HumanoidRootPart") then return end
      local hrp = char.HumanoidRootPart
      
      if flyActive then
         local bv = Instance.new("BodyVelocity", hrp)
         bv.Name = "FlyVelocity"
         bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
         local bg = Instance.new("BodyGyro", hrp)
         bg.Name = "FlyGyro"
         bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
         
         task.spawn(function()
            while flyActive and char:FindFirstChild("HumanoidRootPart") do
               local cam = workspace.CurrentCamera
               bg.cframe = cam.CFrame
               bv.velocity = cam.CFrame.LookVector * (char.Humanoid.MoveDirection.Magnitude > 0 and 60 or 0)
               task.wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
         end)
      end
   end,
})

-- Alternador de Noclip (Atravessar Paredes)
local NoclipToggle = PrincipalTab:CreateToggle({
   Name = "Ativar Noclip (Paredes)",
   CurrentValue = false,
   Flag = "NoclipFlag",
   Callback = function(Value)
      noclipActive = Value
      if noclipActive then
         game:GetService("RunService").Stepped:Connect(function()
            if noclipActive and lp.Character then
               for _, part in pairs(lp.Character:GetDescendants()) do
                  if part:IsA("BasePart") then part.CanCollide = false end
               end
            end
         end)
      end
   end,
})

-- CORREÇÃO DA FUNÇÃO GIGANTE (Método Universal via HumanoidDescription)
local GiantButton = PrincipalTab:CreateButton({
   Name = "Ficar Gigante (Método Seguro)",
   Callback = function()
      local char = lp.Character
      if char and char:FindFirstChild("Humanoid") then
         local hum = char.Humanoid
         -- Altera as propriedades físicas do tamanho do boneco
         local bodyWidth = char:FindFirstChild("BodyWidthScale")
         local bodyHeight = char:FindFirstChild("BodyHeightScale")
         local bodyDepth = char:FindFirstChild("BodyDepthScale")
         local headScale = char:FindFirstChild("HeadScale")

         if bodyWidth and bodyHeight and bodyDepth and headScale then
            bodyWidth.Value = 4.0
            bodyHeight.Value = 4.0
            bodyDepth.Value = 4.0
            headScale.Value = 4.0
            Rayfield:Notify({Title = "Sucesso", Content = "Você ficou gigante!", Duration = 3})
         else
            -- Segunda tentativa caso o jogo use o padrão alternativo R15
            pcall(function()
               local desc = hum:GetAppliedDescription()
               desc.HeightScale = 4.0
               desc.WidthScale = 4.0
               desc.DepthScale = 4.0
               desc.HeadScale = 4.0
               hum:ApplyDescription(desc)
               Rayfield:Notify({Title = "Sucesso", Content = "Escala modificada via descrição!", Duration = 3})
            end)
         end
      end
   end,
})

-- ----------------------------------------------------
-- CONTEÚDO DA ABA DE INFORMAÇÕES
-- ----------------------------------------------------
InfoTab:CreateLabel("Caso precise pegar a chave novamente:")

InfoTab:CreateButton({
   Name = "Copiar Link da Key (Linkvertise)",
   Callback = function()
      setclipboard(LINK_DA_KEY)
      Rayfield:Notify({
         Title = "Copiado!",
         Content = "O link do encurtador foi copiado para sua área de transferência.",
         Duration = 3
      })
   end,
})
