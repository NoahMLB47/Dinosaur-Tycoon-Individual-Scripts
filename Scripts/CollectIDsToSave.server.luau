local players = game:GetService("Players")
local plots = game.Workspace.Map.TycoonLayers.Plots
local saveDataModule = require(script.Parent.StoreAndRetrieveSaveData)
	
local function collectData()
	print("Start save")
	for _, player in players:GetChildren() do
		local playersPlot = nil
		
		-- gets the player's plot
		for _, plot in plots:GetChildren() do
			if plot:GetAttribute("Owner") == player.UserId then
				playersPlot = plot
			end
		end
		
		-- data only saves if player has a plot
		if playersPlot ~= nil then
			-- creates a table and stores the cash
			local saveData = {
				cash = player.leaderstats.Cash.Value,
				items = {},
				buttons = {}
			}
			
			local buttonsFolder = playersPlot.Buttons
			local itemsFolder = playersPlot.Items
			
			-- goes through every button and if the player has it in their plot and it is not already in the table it adds it
			for _, button in buttonsFolder:GetChildren() do
				local index = table.find(saveData.buttons, button:GetAttribute("ID"))
				if not index then
					table.insert(saveData.buttons, button:GetAttribute("ID"))
				end
			end
			
			-- same as before but for items
			for _, folder in itemsFolder:GetChildren() do
				for _, item in folder:GetChildren() do
				
					if string.find(item:GetAttribute("ID"), "R$", 1, true) then
						continue
					end
					
					local index = table.find(saveData.items, item:GetAttribute("ID"))
					if not index then					
						table.insert(saveData.items, item:GetAttribute("ID"))
					end
				end
			end
			
			print(saveData)
			
			-- save data is pushed to the data store
			--saveDataModule.savePlayerData(player, saveData)
		end
	end
	task.wait(300)
	collectData()
end

collectData()