local playerNameText = script.Parent.PlayerName
local index = 2
local playerNameToShow
local players = game:GetService("Players")
local leftArrow = script.Parent.LeftArrow
local rightArrow = script.Parent.RightArrow
local steal1000 = script.Parent.Steal1000CashButton
local steal10000 = script.Parent.Steal10000CashButton
local steal50000 = script.Parent.Steal50000CashButton
local steal100000 = script.Parent.Steal100000CashButton
local playerOrderModule = require(game:GetService("ReplicatedStorage"):WaitForChild("PlayersInGame"))
local marketplaceService = game:GetService("MarketplaceService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local stealCashPurchaseEvent = replicatedStorage.StealCashPurchase

leftArrow.Activated:Connect(function()
	local playerTable = playerOrderModule.playersTable
	print(playerTable)
	if index > 2 then
		index -= 1
		while index >= 1 and playerTable[index] == nil do
			index -= 1
		end
		playerNameText.Text = playerTable[index].DisplayName
	end
end)

rightArrow.Activated:Connect(function()
	local playerTable = playerOrderModule.playersTable
	if index < #playerTable then
		index += 1
		while index <= #playerTable and playerTable[index] == nil do
			index += 1
		end
		playerNameText.Text = playerTable[index].DisplayName
	end
end)

steal1000.Activated:Connect(function()
	local playerToStealFrom
	
	for i = 1, #playerOrderModule.playersTable, 1 do
		local player = playerOrderModule.playersTable[i]
		if player.DisplayName == playerNameText.Text then
			playerToStealFrom = player
			break
		end
	end
	
	if playerToStealFrom ~= nil then
		local player = players.LocalPlayer
		local playerToStealFromId = playerToStealFrom.UserId
		print("player to steal from " .. playerToStealFromId)
		stealCashPurchaseEvent:FireServer(playerToStealFromId)
		
		local productId = steal1000:GetAttribute("ProductID")
		marketplaceService:PromptProductPurchase(player, productId)
		
		print("Would buy")
	else
		print("Player is no longer in the server")
	end
end)

steal10000.Activated:Connect(function()
	local playerToStealFrom

	for i = 1, #playerOrderModule.playersTable, 1 do
		local player = playerOrderModule.playersTable[i]
		if player.DisplayName == playerNameText.Text then
			playerToStealFrom = player
			break
		end
	end

	if playerToStealFrom ~= nil then
		local player = players.LocalPlayer
		local playerToStealFromId = playerToStealFrom.UserId
		print("player to steal from " .. playerToStealFromId)
		stealCashPurchaseEvent:FireServer(playerToStealFromId)

		local productId = steal1000:GetAttribute("ProductID")
		marketplaceService:PromptProductPurchase(player, productId)

		print("Would buy")
	else
		print("Player is no longer in the server")
	end
end)