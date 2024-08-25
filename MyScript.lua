-- LocalScript en StarterGui

-- Crear GUI
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Parent = screenGui

-- Configurar el Frame (Menú)
frame.Size = UDim2.new(0, 200, 0, 400)  -- Tamaño del menú
frame.Position = UDim2.new(1, -210, 0.5, -200)  -- Posición inicial
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(1, 0.5)
frame.Draggable = true  -- Permitir que el menú se pueda mover
frame.Active = true
frame.ClipsDescendants = true

-- Bordes redondeados
local uICorner = Instance.new("UICorner")
uICorner.CornerRadius = UDim.new(0, 15)  -- Bordes redondeados
uICorner.Parent = frame

-- Oscurecer parte superior
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topBar.BorderSizePixel = 0
topBar.Parent = frame

-- Texto de la tecla
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, -40, 0, 50)
textLabel.Position = UDim2.new(0, 20, 0, 50)
textLabel.Text = "Press 'V' to activate the script"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.BackgroundTransparency = 1
textLabel.TextScaled = true
textLabel.Font = Enum.Font.SourceSans
textLabel.Parent = frame

-- Indicador de activación (foco)
local indicator = Instance.new("Frame")
indicator.Size = UDim2.new(0, 20, 0, 20)
indicator.Position = UDim2.new(0, 170, 0, 65)
indicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
indicator.BorderSizePixel = 0
indicator.Parent = frame

local uICornerIndicator = Instance.new("UICorner")
uICornerIndicator.CornerRadius = UDim.new(1, 0)  -- Bordes redondeados
uICornerIndicator.Parent = indicator

-- Variables del script
local isActive = false
local character = player.Character or player.CharacterAdded:Wait()

local function onTouched(hit)
    if isActive and hit:IsA("Part") and hit.Name == "Bullet" then
        -- Evita que la bala dañe al jugador
        character.HumanoidRootPart.Anchored = true

        -- Teletransporta al jugador
        character:SetPrimaryPartCFrame(CFrame.new(Vector3.new(math.random(-50, 50), 10, math.random(-50, 50))))

        -- Vuelve a activar la colisión
        wait(0.1)
        character.HumanoidRootPart.Anchored = false
    end
end

-- Activar/Desactivar el script con la tecla 'V'
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.V then
        isActive = not isActive
        indicator.BackgroundColor3 = isActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end
end)

-- Conectar el evento Touched al personaje
character.HumanoidRootPart.Touched:Connect(onTouched)

-- Asegurar que el menú no se quede atorado al moverlo rápidamente
local function preventStuck()
    if frame.Position.X.Offset < 0 then
        frame.Position = UDim2.new(1, -frame.Size.X.Offset - 10, frame.Position.Y.Scale, frame.Position.Y.Offset)
    end
end

frame:GetPropertyChangedSignal("Position"):Connect(preventStuck)
