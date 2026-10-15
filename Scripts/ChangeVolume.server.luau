local volumeDownButton = script.Parent:WaitForChild("MusicDownArrow")
local volumeUpButton = script.Parent:WaitForChild("MusicUpArrow")
local backgroundPlaylist = game:GetService("SoundService"):FindFirstChild("BackgroundPlaylist")

volumeDownButton.MouseButton1Click:Connect(function() 
	local volumeText = script.Parent:WaitForChild("VolumeValueText").Text
	local volumeValue = tonumber(volumeText)
	if volumeValue ~= 0 then
		volumeValue -= 1
	end
	local newVolumeText = tostring(volumeValue)
	local songToChangeVolume
	
	for _, song in backgroundPlaylist:GetChildren() do
		if song.Playing == true then
			songToChangeVolume = song
		end
	end
	
	songToChangeVolume.Volume = (volumeValue/10) * 0.3
	
	script.Parent:WaitForChild("VolumeValueText").Text = newVolumeText
end)

volumeUpButton.MouseButton1Click:Connect(function() 
	local volumeText = script.Parent:WaitForChild("VolumeValueText").Text
	local volumeValue = tonumber(volumeText)
	if volumeValue ~= 10 then
		volumeValue += 1
	end
	local newVolumeText = tostring(volumeValue)
	local songToChangeVolume

	for _, song in backgroundPlaylist:GetChildren() do
		if song.Playing == true then
			songToChangeVolume = song
		end
	end

	songToChangeVolume.Volume = (volumeValue/10) * 0.3

	script.Parent:WaitForChild("VolumeValueText").Text = newVolumeText
end)
