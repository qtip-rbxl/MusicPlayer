--[[
getgenv().songs = {
	{id = "rbxassetid://SONG_ID", title = "Artist\nSong", icon = "rbxassetid://SONG_COVER-ART"},
	{id = "rbxassetid://SONG_ID", title = "Artist\nSong", icon = "rbxassetid://SONG_COVER-ART"}
}
--]]

local gui = game:GetObjects("rbxassetid://18647165019")[1]
local songs = getgenv().songs

local mainFrame = gui.Main
local guiIcon = gui.button
local musicListFrame = mainFrame.list
local songButtonTemplate = musicListFrame.template
local musicPlayerFrame = mainFrame.player

local playPauseButton = musicPlayerFrame.play
local muteButton = musicPlayerFrame.mute
local durationBar = musicPlayerFrame.bar
local durationFill = durationBar:FindFirstChild("Fill")
local durationLabel = musicPlayerFrame.duration
local closeButton = mainFrame.topbar.close

local sound = Instance.new("Sound")
sound.Volume = 2
sound.Parent = game:GetService("SoundService")

local currentSong = nil

local function updateDuration()
	while sound.Playing do
		durationFill.Visible = true
		durationFill.Size = UDim2.new(sound.TimePosition / sound.TimeLength, 0, 1, 0)
		durationLabel.Text = string.format("%i:%02i - %i:%02i",
			math.floor(sound.TimePosition / 60), sound.TimePosition % 60,
			math.floor(sound.TimeLength / 60), sound.TimeLength % 60)
		wait(0.1)
	end
end

local function playSong(song)
	currentSong = song
	sound.SoundId = song.id
	sound:Play()
	musicPlayerFrame.Visible = true
	playPauseButton.Image = "rbxassetid://18633490352"

	spawn(updateDuration)

	while sound.Playing do
		durationLabel.Text = string.format("%i:%02i - %i:%02i",
			math.floor(sound.TimePosition / 60), sound.TimePosition % 60,
			math.floor(sound.TimeLength / 60), sound.TimeLength % 60)
		wait(1)
	end
end

local function stopSong()
	sound:Stop()
	musicPlayerFrame.Visible = false
	currentSong = nil
end

for i, song in ipairs(songs) do
	local songButton = songButtonTemplate:Clone()
	songButton.Image = song.icon
	songButton.Name = "SongButton" .. i
	songButton.Parent = musicListFrame
	songButton.label.Text = song.title
	songButton.MouseEnter:Connect(function()
		songButton.play_Icon.Visible = true
	end)
	songButton.MouseLeave:Connect(function()
		songButton.play_Icon.Visible = false
	end)
	songButton.MouseButton1Click:Connect(function()
		playSong(song)
	end)
end
songButtonTemplate:Destroy()

playPauseButton.MouseButton1Click:Connect(function()
	if sound.IsPlaying then
		sound:Pause()
		playPauseButton.Image = "rbxassetid://18633371542"
	else
		sound:Resume()
		playPauseButton.Image = "rbxassetid://18633490352"
		updateDuration()
	end
end)

muteButton.MouseButton1Click:Connect(function()
	sound.Volume = sound.Volume == 0 and 2 or 0
	muteButton.Text = sound.Volume == 0 and "UNMUTE" or "MUTE"
end)

sound.Ended:Connect(stopSong)

closeButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

guiIcon.MouseButton1Click:Connect(function()
	if mainFrame.Visible then
		mainFrame.Visible = false
	else
		mainFrame.Visible = true
	end
end)

gui.Parent = game.Players.LocalPlayer.PlayerGui
