local saveDataModule = {}

local dataStore = game:GetService("DataStoreService")
local playerData = dataStore:GetDataStore("PlayerData")
saveDataModule.currentSaveData = {}

function saveDataModule.savePlayerData(player, saveData)
	-- save the players data to the data store
	local success, errorMessage = pcall(function()
		playerData:SetAsync(tostring(player.UserId), saveData)
	end)
	
	if success then
		print (player.Name.. " saved")
	end
	
	if not success then
		warn("failed for", player.Name,": ", errorMessage)
	end
end


function saveDataModule.loadPlayerData(player)
	playerData:RemoveAsync(tostring(player.UserId))
	local success, saveData = pcall(function()
		return playerData:GetAsync(tostring(player.UserId))
	end)
		
	-- return the players save data
	if success then
		return saveData
	end
		
	if not success then
		warn("failed to load ", player.Name, "'s data")
	end
end

return saveDataModule
