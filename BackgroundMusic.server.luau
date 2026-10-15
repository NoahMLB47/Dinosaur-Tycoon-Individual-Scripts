local soundService = game:GetService("SoundService")
local runService = game:GetService("RunService")
local playlist = soundService:WaitForChild("BackgroundPlaylist")
local songs = playlist:GetChildren()
local currentSong = 1
local songToPlay = songs[currentSong]
local player = game:GetService("Players").LocalPlayer
local volumeText = player.PlayerGui:WaitForChild("InGameGUI"):WaitForChild("Settings"):WaitForChild("Music"):WaitForChild("VolumeValueText")
local volumeValue
local fadeConnection
local endSong

local function startFade()
	-- gradually lower the volume
	fadeConnection = runService.Heartbeat:Connect(function(deltaTime: number) 
		songToPlay.Volume -= (0.3 / 5) * deltaTime
	end)
end


local function loopPlaylist()
	if endSong then
		endSong:Disconnect()
	end
	volumeValue = tonumber(volumeText.Text)
	songToPlay = songs[currentSong]
	songToPlay:Play() -- play the next song
	songToPlay.Volume = (volumeValue/10) * 0.3
	
	-- Wait for the sound asset to load before relying on TimeLength
	-- Without this, TimeLength is 0 for unloaded sounds, causing the fade to start instantly
	if not songToPlay.IsLoaded then
		songToPlay.Loaded:Wait()
	end
	
	task.wait(songToPlay.TimeLength - 5)
	startFade()
	
	endSong = songToPlay.Ended:Connect(function()
		-- disconnects the heartbeat
		if fadeConnection then
			fadeConnection:Disconnect()
		end
		songToPlay.Volume = 0.3
		currentSong += 1 -- go to next song
		-- if it is the last song in the playlist then go back to the start
		if currentSong > #songs then
			currentSong = 1
		end
		loopPlaylist()
	end)
end

loopPlaylist()

