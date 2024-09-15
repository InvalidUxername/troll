-- Create a ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ImageButtonGui"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create an ImageButton
local imageButton = Instance.new("ImageButton")
imageButton.Name = "MyImageButton"
imageButton.Size = UDim2.new(0, 75, 0, 100) -- Size of the button
imageButton.Position = UDim2.new(0.5, -50, 0.5, -50) -- Center of the screen
imageButton.Image = "rbxassetid://1234567890" -- Replace with your image asset ID
imageButton.Draggable = true
imageButton.Parent = screenGui
