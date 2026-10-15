local CollectionService = game:GetService("CollectionService")
local isTouched = false
local teams = game:GetService("Teams")
local template = game.Workspace.TemplatePlot
local gamepassModule = require(game.ServerScriptService.GamepassRewards)
local marketplaceService = game:GetService("MarketplaceService")
local gamepassTable = require(game.ServerScriptService.GamepassOwnershipTable)
local saveDataModule = require(game.ServerScriptService.StoreAndRetrieveSaveData)


local function onTouched(hit, sign)
	local plot = sign.Parent.Parent
	local character = hit.Parent
	local humanoid = character:FindFirstChild("Humanoid")

	if humanoid and not isTouched then
		isTouched = true -- activate cooldown

		-- try to get player object
		local player = game.Players:GetPlayerFromCharacter(character)
		if player then
			print(player.Name .. "touched the object")
			
			-- only activates if the plot is not taken and the player doesn't have a plot
			if plot:GetAttribute('Taken') == false and player.Team == teams:WaitForChild("No Dinosaur") then
				print("attempt to change text")
				-- gives the plot to the player
				plot:SetAttribute('Taken', true)
				plot:SetAttribute('Owner', player.UserId)
				sign.SurfaceGui.TextLabel.Text = player.Name
				sign.Transparency = 0.7
				sign.CanCollide = false
				sign.CanTouch = false
				
				-- puts player on right team
				if sign:GetAttribute('PlotID') == 1 then
					player.Team = teams:WaitForChild("Tyrannosaurus")
				
				elseif sign:GetAttribute('PlotID') == 2 then
					player.Team = teams:WaitForChild("Pterodactyl")
					
				elseif sign:GetAttribute('PlotID') == 3 then
					player.Team = teams:WaitForChild("Spinosaurus")
					
				elseif sign:GetAttribute('PlotID') == 4 then
					player.Team = teams:WaitForChild("Stegosaurus")
					
				elseif sign:GetAttribute('PlotID') == 5 then
					player.Team = teams:WaitForChild("Triceratops")
					
				elseif sign:GetAttribute('PlotID') == 6 then
					player.Team = teams:WaitForChild("Velociraptor")
					
				elseif sign:GetAttribute('PlotID') == 7 then
					player.Team = teams:WaitForChild("Brachiosaurus")
					
				elseif sign:GetAttribute('PlotID') == 8 then
					player.Team = teams:WaitForChild("Parasaurolophus")
				end

				local respawnPoint = template:WaitForChild("RespawnPoint"):Clone()
				
				-- make buttons folder structure
				local buttonsFolder = Instance.new('Folder')
				buttonsFolder.Name = "Buttons"
				buttonsFolder.Parent = plot
				
				-- make items folder structure
				local itemsFolder = Instance.new('Folder')
				itemsFolder.Name = "Items"
				itemsFolder.Parent = plot
				
				local conveyorsFolder = Instance.new('Folder')
				conveyorsFolder.Name = "Conveyors"
				conveyorsFolder.Parent = itemsFolder
				
				local droppersFolder = Instance.new('Folder')
				droppersFolder.Name = "Droppers"
				droppersFolder.Parent = itemsFolder
				
				local wallsFolder = Instance.new('Folder')
				wallsFolder.Name = "Walls"
				wallsFolder.Parent = itemsFolder
				
				local multiplierFolder = Instance.new('Folder')
				multiplierFolder.Name = "Multipliers"
				multiplierFolder.Parent = itemsFolder
				
				local miscItemsFolder = Instance.new('Folder')
				miscItemsFolder.Name = "Misc"
				miscItemsFolder.Parent = itemsFolder

				respawnPoint.Parent = plot

				local saveData = saveDataModule.currentSaveData[player.UserId]
				print(saveData)
				-- if the player does have save data then copy all the right items and buttons
				if saveData ~= nil then
					for i = 1, #saveData.buttons do
						for _, button in template.Buttons:GetDescendants() do
							if not button:IsA("Model") then
								continue
							end
							
							if button:GetAttribute("ID") == saveData.buttons[i] then
								local buttonClone = button:Clone()
								local buttonCFrame
								if buttonClone:IsA('Model') then
									buttonCFrame = buttonClone:GetPivot()
								elseif buttonClone:IsA('BasePart') then
									buttonCFrame = buttonClone.CFrame
								end

								local relativeButtonCFrame = template.CFrame:ToObjectSpace(buttonCFrame)
								if buttonClone:IsA('Model') then
									buttonClone:PivotTo(plot.CFrame:ToWorldSpace(relativeButtonCFrame))
								elseif buttonClone:IsA('BasePart') then
									buttonClone.CFrame = plot.CFrame:ToWorldSpace(relativeButtonCFrame)
								end
								buttonClone.Parent = buttonsFolder
							end
						end
					end
					
					for i = 1, #saveData.items do
						for _, folder in template.Items:GetChildren() do
							for _, item in folder:GetChildren() do
							
								if item:GetAttribute("ID") == saveData.items[i] then
									local itemClone = item:Clone()
									
									if string.find(itemClone.Name, "Dropper") then
										local spawnEggScript = itemClone:WaitForChild("dropperPart"):WaitForChild("SpawnEgg")
										spawnEggScript.Enabled = true
										itemClone.Parent = droppersFolder
									elseif string.find(itemClone.Name, "Multiplier") then
										itemClone.Parent = multiplierFolder
									elseif string.find(itemClone.Name, "Conveyor") then
										itemClone.Parent = conveyorsFolder
									elseif string.find(itemClone.Name, "Wall") then
										itemClone.Parent = wallsFolder
									else
										itemClone.Parent = miscItemsFolder
									end
									
									local itemCFrame
									if itemClone:IsA('Model') then
										itemCFrame = itemClone:GetPivot()
									elseif itemClone:IsA('BasePart') then
										itemCFrame = itemClone.CFrame
									end
									
									local relativeItemCFrame = template.CFrame:ToObjectSpace(itemCFrame)
									if itemClone:IsA('Model') then
										itemClone:PivotTo(plot.CFrame:ToWorldSpace(relativeItemCFrame))
									elseif itemClone:IsA('BasePart') then
										itemClone.CFrame = plot.CFrame:ToWorldSpace(relativeItemCFrame)
									end
								end
							end
						end
					end
				end
				-- if the player doesnt have save data then copy the starting items and buttons
				if saveData == nil then
					-- load starting objects
					local starterButton = template.Buttons.ConveyorButtons:WaitForChild("Conveyor1Button"):Clone()
					-- Put the cloned DropperButtons folder inside the player's plot
					starterButton.Parent = buttonsFolder
					local templateItems = template.Items.Conveyors

					print("attempt to clone button")

					-- Get the button's position relative to the template plot
					local starterButtonRelativeCFrame = template.CFrame:ToObjectSpace(starterButton:GetPivot())
					local respawnPointRelativeCFrame = template.CFrame:ToObjectSpace(respawnPoint.CFrame)

					-- Move it to the same relative position in the player's plot
					starterButton:PivotTo(plot.CFrame:ToWorldSpace(starterButtonRelativeCFrame))
					respawnPoint.CFrame = plot.CFrame:ToWorldSpace(respawnPointRelativeCFrame)

					print("moved starting button")
				end
				
				-- gives rewards for any gamepasses the player has
				for i = 1, #gamepassModule.itemRewards do
					local gamepassId = gamepassModule.itemRewards[i]
					local hasGamepass = gamepassTable.playerGamepasses[player][gamepassId]

					if hasGamepass == true then
						gamepassModule.giveRewards(gamepassId, plot)
					end
					
				end
				
				-- check if they have auto collect
				if gamepassTable.playerGamepasses[player][1983188253] == false then
					local autoCollectButton = template.Buttons.MiscButtons:FindFirstChild("R$AutoCollectButton"):Clone()
					autoCollectButton.Parent = buttonsFolder
					local autoCollectButtonRelativeCFrame = template.CFrame:ToObjectSpace(autoCollectButton:GetPivot())
					autoCollectButton:PivotTo(plot.CFrame:ToWorldSpace(autoCollectButtonRelativeCFrame))
				end


			task.wait(1)
			-- players can touch object again
			isTouched = false
			
		end
	end
	end
end

local function setupSign(sign)
	sign.Touched:Connect(function(hit)
		onTouched(hit, sign)
	end)
end



for _, sign in CollectionService:GetTagged("TycoonSign") do
	setupSign(sign)
end
