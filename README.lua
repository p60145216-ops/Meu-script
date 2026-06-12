-- [[ BROOKHAVEN RP - MULTI-TOOL & TROLL HUB ]] --
-- Desenvolvido com Rayfield UI por PabloTheDev
-- Otimizado para Mobile e PC (Sem dependências locais)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "PABLO HUB SUPREME - Brookhaven RP",
   LoadingTitle = "Carregando Hub...",
   LoadingSubtitle = "by PabloTheDev",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = "PabloHub"
   },
   KeySystem = false -- Sistema de key desativado para execução direta
})

-- [[ VARIÁVEIS DE CONTROLE LOCAL ]] --
local LP = game:GetService("Players").LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local NoclipLoop
local FlingLoop

LP.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
end)

-- [[ ABAS DO PAINEL ]] --
local MainTab = Window:CreateTab("Movimentação", 4483362458) -- Ícone de engrenagem/movimento
local VisualTab = Window:CreateTab("Personagem", 4483362534) -- Ícone de usuário
local TrollTab = Window:CreateTab("Zoar / Troll", 4483362748) -- Ícone de diversão

-- [[ ABA 1: MOVIMENTAÇÃO (OFFLINE/CLIPE) ]] --

local NoclipToggle = MainTab:CreateToggle({
   Name = "NoClip (Atravessar Paredes)",
   CurrentValue = false,
   Flag = "NoclipFlag",
   Callback = function(Value)
      if Value then
          NoclipLoop = game:GetService("RunService").Stepped:Connect(function()
              if Character then
                  for _, part in pairs(Character:GetDescendants()) do
                      if part:IsA("BasePart") then
                          part.CanCollide = false
                      end
                  end
              end
          end)
      else
          if NoclipLoop then NoclipLoop:Disconnect() end
      end
   end,
})

local SpeedSlider = MainTab:CreateSlider({
   Name = "Velocidade (WalkSpeed)",
   Increment = 1,
   Max = 150,
   Min = 16,
   CurrentValue = 16,
   Flag = "SpeedFlag",
   Callback = function(Value)
      if Humanoid then Humanoid.WalkSpeed = Value end
   end,
})

local JumpSlider = MainTab:CreateSlider({
   Name = "Altura do Pulo (JumpPower)",
   Increment = 1,
   Max = 250,
   Min = 50,
   CurrentValue = 50,
   Flag = "JumpFlag",
   Callback = function(Value)
      if Humanoid then 
          Humanoid.UseJumpPower = true
          Humanoid.JumpPower = Value 
      end
   end,
})

-- Coordenadas principais do Brookhaven
local Teleports = {
    ["Banco"] = CFrame.new(-445, 23, -284),
    ["Hospital"] = CFrame.new(-342, 23, -295),
    ["Delegacia"] = CFrame.new(-367, 23, -177),
    ["Praça Central"] = CFrame.new(-333, 23, -200)
}

local TeleportDropdown = MainTab:CreateDropdown({
   Name = "Teletransportar para:",
   Options = {"Banco", "Hospital", "Delegacia", "Praça Central"},
   CurrentOption = {"Praça Central"},
   MultipleOptions = false,
   Flag = "TeleportFlag",
   Callback = function(Option)
      local target = Option[1]
      if Character and Character:FindFirstChild("HumanoidRootPart") and Teleports[target] then
          Character.HumanoidRootPart.CFrame = Teleports[target]
      end
   end,
})


-- [[ ABA 2: PERSONAGEM (SISTEMA PARA FICAR GRANDÃO) ]] --

VisualTab:CreateButton({
   Name = "Ficar Gigante (Grandão)",
   Callback = function()
      if Humanoid then
          local vars = {"BodyHeightScale", "BodyWidthScale", "BodyDepthScale", "HeadScale"}
          for _, var in pairs(vars) do
              local scale = Humanoid:FindFirstChild(var)
              if scale then scale.Value = 3.5 end -- Modifica o tamanho nativo do Roblox
          end
      end
   end,
})

VisualTab:CreateButton({
   Name = "Ficar Minúsculo",
   Callback = function()
      if Humanoid then
          local vars = {"BodyHeightScale", "BodyWidthScale", "BodyDepthScale", "HeadScale"}
          for _, var in pairs(vars) do
              local scale = Humanoid:FindFirstChild(var)
              if scale then scale.Value = 0.3 end
          end
      end
   end,
})

VisualTab:CreateButton({
   Name = "Tamanho Normal",
   Callback = function()
      if Humanoid then
          local vars = {"BodyHeightScale", "BodyWidthScale", "BodyDepthScale", "HeadScale"}
          for _, var in pairs(vars) do
              local scale = Humanoid:FindFirstChild(var)
              if scale then scale.Value = 1 end
          end
      end
   end,
})


-- [[ ABA 3: FUNÇÕES PARA ZOAR (TROLL) ]] --

local FlingToggle = TrollTab:CreateToggle({
   Name = "Super Fling (Arremessar Pessoas)",
   CurrentValue = false,
   Flag = "FlingFlag",
   Callback = function(Value)
      if Value then
          FlingLoop = game:GetService("RunService").Heartbeat:Connect(function()
              if Character and Character:FindFirstChild("HumanoidRootPart") then
                  local hrp = Character.HumanoidRootPart
                  local oldV = hrp.Velocity
                  -- Aplica velocidade angular massiva baseada na física do jogo
                  hrp.Velocity = Vector3.new(10000, 10000, 10000) 
                  game:GetService("RunService").RenderStepped:Wait()
                  hrp.Velocity = oldV
              end
          end)
      else
          if FlingLoop then FlingLoop:Disconnect() end
      end
   end,
})

TrollTab:CreateButton({
   Name = "Girar feito Maluco (Glitch)",
   Callback = function()
      if Character and Character:FindFirstChild("HumanoidRootPart") then
          -- Verifica se já existe um spin para não duplicar
          if Character.HumanoidRootPart:FindFirstChild("SpinBot") then
              Character.HumanoidRootPart.SpinBot:Destroy()
          end
          
          local spin = Instance.new("BodyAngularVelocity")
          spin.Name = "SpinBot"
          spin.MaxTorque = Vector3.new(0, math.huge, 0)
          spin.AngularVelocity = Vector3.new(0, 120, 0) -- Velocidade do giro
          spin.Parent = Character.HumanoidRootPart
          
          Rayfield:Notify({
             Name = "Glitch Ativado",
             Content = "Você começou a girar! Clique novamente ou espere resetar.",
             Duration = 3,
             Image = 4483362748,
          })
      end
   end,
})

TrollTab:CreateButton({
   Name = "Parar de Girar",
   Callback = function()
      if Character and Character:FindFirstChild("HumanoidRootPart") then
          local spin = Character.HumanoidRootPart:FindFirstChild("SpinBot")
          if spin then spin:Destroy() end
      end
   end,
})

-- Notificação de inicialização concluída
Rayfield:Notify({
   Name = "PABLO HUB SUPREME",
   Content = "Script carregado com sucesso no Rayfield!",
   Duration = 5,
   Image = 4483362458,
})

