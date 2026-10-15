local CollectionService = game:GetService("CollectionService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local soundEvent = replicatedStorage:WaitForChild("PlaySoundEvent")
local MarketplaceService = game:GetService("MarketplaceService")
local template = game.Workspace.TemplatePlot
local TemplateItems = template.Items
local TemplateButtons = template.Buttons
local isTouched = false
local soundPlaying = false

local function onTouched(hit, button)
	local isTouched = button:GetAttribute("IsTouched")
	
	if not isTouched then
		-- start cooldown
		button:SetAttribute("IsTouched", true)
		local Fullbutton = button.Parent
		local plot = button.Parent.Parent.Parent
		local price = button:GetAttribute('Price')

		local character = game.Players:GetPlayerFromCharacter(hit.Parent)
		if not character then return end
		-- if the person who pressed the button isn't the owner then it doesn't do anything
		if plot:GetAttribute('Owner') ~= character.UserId then 
			task.wait(1)
			button:SetAttribute("IsTouched", false)
			return
		end
		-- if it is a robux button then prompt purchase
		if string.find(Fullbutton:GetAttribute('ID'), "R$", 1, true) then
			local productId = button:GetAttribute('ProductID')
			MarketplaceService:PromptGamePassPurchase(character, productId)

		elseif character.leaderstats.Cash.Value >= price then
			character.leaderstats.Cash.Value -= price

			Fullbutton:Destroy()
			local itemToUnlock = button:GetAttribute('IDOfMultiplierToUnlock')
			if not itemToUnlock then warn("no item to unlock") return end

			-- search all the items
			for _, item in TemplateItems:FindFirstChild("Multipliers"):GetChildren() do
				if item:GetAttribute('ID') ~= itemToUnlock then continue end

				-- copy and move the item when the item to unlock is found
				local itemClone = item:Clone()
				local multipliersFolder = plot.Items.Multipliers
				itemClone.Parent = multipliersFolder

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
				itemClone.Parent = multipliersFolder
			end
			local PressSound = game:GetService("ServerStorage"):FindFirstChild("SoundEffects"):FindFirstChild("ButtonPress")

			-- play sound
			if soundPlaying == false then
				print(PressSound.SoundId)
				soundPlaying = true
			end
			soundEvent:FireClient(character, PressSound.SoundId)

			local buttonToUnlock = button:GetAttribute('IDOfButtonToUnlock')
			if not buttonToUnlock then warn("no button to unlock") return end

			local ButtonsFolder = plot.Buttons
			-- search all the buttons
			for _, buttonFolder in TemplateButtons:GetChildren() do

				for _, buttonTemplate in buttonFolder:GetChildren() do
					if string.find(buttonToUnlock, buttonTemplate:GetAttribute('ID')) then 

						-- copy and spawn the button
						local buttonClone = buttonTemplate:Clone()
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
						buttonClone.Parent = ButtonsFolder
					end
				end
			end
			
		end
		task.wait(1)
		-- end cooldown
		button:SetAttribute("IsTouched", false)
	end
end

local function setupButton(button)
	button.Touched:Connect(function(hit)
		onTouched(hit, button)
	end)
end

-- hook up any buttons that already exist

-- hook up any future buttons (e.g. clones created above)
CollectionService:GetInstanceAddedSignal("MultiplierButton"):Connect(setupButton)
CollectionService:GetInstanceAddedSignal("R$MultiplierButton"):Connect(setupButton)