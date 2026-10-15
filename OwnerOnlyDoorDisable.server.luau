local CollectionService = game:GetService("CollectionService")
local MarketplaceService = game:GetService("MarketplaceService")

local function onPressed(player, button)
	local productId = button:GetAttribute("ProductId")
	local laserDoor = button.Parent.Parent
	local otherPlayersPlot = laserDoor.Parent.Parent.Parent
	local ownerName = game.Players:GetPlayerByUserId(otherPlayersPlot:GetAttribute("Owner"))
	if player.UserId ~= otherPlayersPlot:GetAttribute("Owner") and laserDoor:GetAttribute("DoorDisableProductActive") == false then
		MarketplaceService:PromptProductPurchase(player, productId)
		player:SetAttribute("PlotThatPurchaseIsFor", otherPlayersPlot:GetAttribute("Owner")) -- sets the plot to disable the doors on
	end
end

local function setupButton(button)
	button:WaitForChild("ClickDetector").MouseClick:Connect(function(player)
		onPressed(player, button)
	end)
end


CollectionService:GetInstanceAddedSignal("OwnerOnlyDoorDisable"):Connect(setupButton)