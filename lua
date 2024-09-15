-- Create a ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false -- Ensures the GUI stays on the screen after respawn
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create a Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 250) -- Frame size (increased height to accommodate the new TextBox)
frame.Position = UDim2.new(0.5, -150, 0.5, -125) -- Center of the screen
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Frame color
frame.Active = true -- Allows the frame to detect input
frame.Transparency = 0.75
frame.Draggable = true -- Makes the frame draggable
frame.Parent = screenGui -- Set the Frame's parent to ScreenGui

-- Add a UICorner to the Frame
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 5) -- Adjust the radius as needed
uiCorner.Parent = frame

-- Create the first TextBox for Username input
local usernameTextBox = Instance.new("TextBox")
usernameTextBox.Size = UDim2.new(0, 200, 0, 40) -- TextBox size
usernameTextBox.Position = UDim2.new(0.5, -100, 0.1, -20) -- Positioned at the top center of the Frame
usernameTextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
usernameTextBox.Transparency = 0.75
usernameTextBox.PlaceholderText = "Input Target Player" -- Placeholder text
usernameTextBox.Text = "" -- Start with an empty text
usernameTextBox.Parent = frame -- Set the TextBox's parent to Frame

-- Create the second TextBox for Position input
local positionTextBox = Instance.new("TextBox")
positionTextBox.Size = UDim2.new(0, 200, 0, 40) -- TextBox size
positionTextBox.Position = UDim2.new(0.5, -100, 0.35, -20) -- Positioned at the middle center of the Frame
positionTextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
positionTextBox.Transparency = 0.75
positionTextBox.PlaceholderText = "Input Target Destination" -- Placeholder text
positionTextBox.Text = "" -- Start with an empty text
positionTextBox.Parent = frame -- Set the TextBox's parent to Frame

-- Create the TextButton for Teleport action
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 200, 0, 40) -- Button size
teleportButton.Position = UDim2.new(0.5, -100, 0.6, -20) -- Positioned at the bottom center of the Frame
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
teleportButton.Transparency = 0.75
teleportButton.Text = "Teleport" -- Button label
teleportButton.TextTransparency = 0
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Parent = frame -- Set the TextButton's parent to Frame

-- Create the third TextBox for Audio ID input
local audioTextBox = Instance.new("TextBox")
audioTextBox.Size = UDim2.new(0, 200, 0, 40) -- TextBox size
audioTextBox.Position = UDim2.new(0.5, -100, 0.85, -20) -- Positioned below the TextButton
audioTextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
audioTextBox.Transparency = 0.75
audioTextBox.PlaceholderText = "Input Teleport Audio (Optional)" -- Placeholder text
audioTextBox.Text = "" -- Start with an empty text
audioTextBox.Parent = frame -- Set the TextBox's parent to Frame

-- Function to handle teleportation and playing audio
local function teleportPlayer()
	local player = game.Players.LocalPlayer
	local character = player.Character

	if not character or not character:FindFirstChild("HumanoidRootPart") then return end

	-- Get the username input
	local inputUsername = usernameTextBox.Text:lower()

	-- Get the position input
	local inputPosition = positionTextBox.Text

	-- Get the audio ID input
	local inputAudio = audioTextBox.Text

	-- Determine the target player
	local targetPlayer = nil
	if inputUsername ~= "" then
		for _, p in pairs(game.Players:GetPlayers()) do
			if p.Name:lower():find(inputUsername) then
				targetPlayer = p
				break
			end
		end
	end

	if not targetPlayer then
		-- If no specific player is found, choose a random one
		local players = game.Players:GetPlayers()
		targetPlayer = players[math.random(1, #players)]
	end

	-- Ensure the target player has a character and HumanoidRootPart
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
		local directionToMove = -targetPlayer.Character.HumanoidRootPart.CFrame.LookVector
		local newPosition = targetPosition + (directionToMove * 3)

		-- Teleport the player 3 studs behind the target player
		character.HumanoidRootPart.CFrame = CFrame.new(newPosition, targetPosition)

		-- Play the audio if an audio ID is provided
		if inputAudio ~= "" then
			local sound = Instance.new("Sound")
			sound.SoundId = "rbxassetid://" .. inputAudio
			sound.Parent = game.Workspace -- Place the sound in the workspace
			sound:Play()
			sound.Ended:Connect(function()
				sound:Destroy() -- Destroy the sound object after it finishes playing
			end)
		end

		-- Wait for 1.5 seconds
		wait(1.5)

		-- Determine the final teleport position
		if inputPosition ~= "" then
			local positionValues = string.split(inputPosition, ",")
			if #positionValues == 3 then
				local x, y, z = tonumber(positionValues[1]), tonumber(positionValues[2]), tonumber(positionValues[3])
				if x and y and z then
					character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(x, y, z))
				end
			end
		else
			-- If no position is specified, teleport 150 studs below
			local finalPosition = character.HumanoidRootPart.Position - Vector3.new(0, 150, 0)
			character.HumanoidRootPart.CFrame = CFrame.new(finalPosition)
		end
	end
end

-- Connect the teleport function to the button click
teleportButton.MouseButton1Click:Connect(teleportPlayer)
