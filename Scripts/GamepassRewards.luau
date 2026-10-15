local gamepassModule = {}
local template = game.Workspace.TemplatePlot
gamepassModule.itemRewards = {
	1963278518, -- +100 dropper
	1966032258,  -- 1st floor multi
	1965762845,	-- +150 dropper
	1962817063,	-- 2nd floor multi
	1964029145, -- +200 dropper
	1962349092, -- 3rd floor multi
	1963495123 -- +1000 dropper
}

local scriptService = game:GetService("ServerScriptService")
local playersGamepasses = require(scriptService.GamepassOwnershipTable)

function gamepassModule.giveRewards(gamepassId, plot, player)
	-- spawns the items in the same way as the non-robux items
	if gamepassId == 1963278518 then
		local button = plot.Buttons:FindFirstChild("BottomR$Dropper5Button")
		if button ~= nil then
			button:Destroy()
		end
		
		local item = template.Items.Droppers:WaitForChild("BottomR$Dropper5")
		local itemClone = item:Clone()
		
		local droppersFolder = plot.Items.Droppers
		itemClone.Parent = droppersFolder
		
		local itemCFrame = itemClone:GetPivot()
		local relativeItemCFrame = template.CFrame:ToObjectSpace(itemCFrame)
		
		itemClone:PivotTo(plot.CFrame:ToWorldSpace(relativeItemCFrame))
		
		local spawnEggScript = itemClone:WaitForChild("dropperPart"):WaitForChild("SpawnEgg")
		spawnEggScript.Enabled = true
		
		
	elseif gamepassId == 1966032258 then
		local button = plot.Buttons:FindFirstChild("BottomR$Multi3Button")
		if button ~= nil then
			button:Destroy()
		end

		local item = template.Items.Multipliers:WaitForChild("BottomR$Multiplier3")
		local itemClone = item:Clone()

		local multiFolder = plot.Items.Multipliers
		itemClone.Parent = multiFolder

		local itemCFrame = itemClone:GetPivot()
		local relativeItemCFrame = template.CFrame:ToObjectSpace(itemCFrame)

		itemClone:PivotTo(plot.CFrame:ToWorldSpace(relativeItemCFrame))
	
	elseif gamepassId == 1965762845 then
		local button = plot.Buttons:FindFirstChild("MiddleR$Dropper6Button")
		if button ~= nil then
			button:Destroy()
		end

		local item = template.Items.Droppers:WaitForChild("MiddleR$Dropper6")
		local itemClone = item:Clone()

		local droppersFolder = plot.Items.Droppers
		itemClone.Parent = droppersFolder

		local itemCFrame = itemClone:GetPivot()
		local relativeItemCFrame = template.CFrame:ToObjectSpace(itemCFrame)

		itemClone:PivotTo(plot.CFrame:ToWorldSpace(relativeItemCFrame))

		local spawnEggScript = itemClone:WaitForChild("dropperPart"):WaitForChild("SpawnEgg")
		spawnEggScript.Enabled = true
	
	
	elseif gamepassId == 1962817063 then
		local button = plot.Buttons:FindFirstChild("MiddleR$Multi3Button")
		if button ~= nil then
			button:Destroy()
		end

		local item = template.Items.Multipliers:WaitForChild("MiddleR$Multiplier3")
		local itemClone = item:Clone()

		local multiFolder = plot.Items.Multipliers
		itemClone.Parent = multiFolder

		local itemCFrame = itemClone:GetPivot()
		local relativeItemCFrame = template.CFrame:ToObjectSpace(itemCFrame)

		itemClone:PivotTo(plot.CFrame:ToWorldSpace(relativeItemCFrame))
	
	elseif gamepassId == 1964029145 then
		local button = plot.Buttons:FindFirstChild("TopR$Dropper6Button")
		if button ~= nil then
			button:Destroy()
		end

		local item = template.Items.Droppers:WaitForChild("TopR$Dropper6")
		local itemClone = item:Clone()

		local droppersFolder = plot.Items.Droppers
		itemClone.Parent = droppersFolder

		local itemCFrame = itemClone:GetPivot()
		local relativeItemCFrame = template.CFrame:ToObjectSpace(itemCFrame)

		itemClone:PivotTo(plot.CFrame:ToWorldSpace(relativeItemCFrame))

		local spawnEggScript = itemClone:WaitForChild("dropperPart"):WaitForChild("SpawnEgg")
		spawnEggScript.Enabled = true
	
	elseif gamepassId == 1962349092 then
		local button = plot.Buttons:FindFirstChild("TopR$Multiplier3Button")
		if button ~= nil then
			button:Destroy()
		end

		local item = template.Items.Multipliers:WaitForChild("TopR$Multiplier3")
		local itemClone = item:Clone()

		local multiFolder = plot.Items.Multipliers
		itemClone.Parent = multiFolder

		local itemCFrame = itemClone:GetPivot()
		local relativeItemCFrame = template.CFrame:ToObjectSpace(itemCFrame)

		itemClone:PivotTo(plot.CFrame:ToWorldSpace(relativeItemCFrame))
		
	elseif gamepassId == 1963495123 then
		local button = plot.Buttons:FindFirstChild("TopR$Dropper7Button")
		if button ~= nil then
			button:Destroy()
		end

		local item = template.Items.Droppers:WaitForChild("TopR$Dropper7")
		local itemClone = item:Clone()

		local droppersFolder = plot.Items.Droppers
		itemClone.Parent = droppersFolder

		local itemCFrame = itemClone:GetPivot()
		local relativeItemCFrame = template.CFrame:ToObjectSpace(itemCFrame)

		itemClone:PivotTo(plot.CFrame:ToWorldSpace(relativeItemCFrame))

		local spawnEggScript = itemClone:WaitForChild("dropperPart"):WaitForChild("SpawnEgg")
		spawnEggScript.Enabled = true
	
	elseif gamepassId == 1983188253 then
		playersGamepasses.playerGamepasses[player][gamepassId] = true
		
		local button = plot.Buttons:FindFirstChild("R$AutoCollectButton")
		if button ~= nil then
			button:Destroy()
		end
	end
end

return gamepassModule
