local CollectionService = game:GetService("CollectionService")

function onTouch(hit, laser, plot) 
	local humanoid = hit.Parent:FindFirstChild("Humanoid") 
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	local ownerId = plot:GetAttribute('Owner')
	-- kills player if they aren't the owner of the plot
	if (humanoid ~= nil) and player.UserId ~= ownerId then	-- if a humanoid exists, then
		humanoid.Health = 0	-- damage the humanoid
	end 
end

function setupLaser(laser)
	local plot = laser.Parent.Parent.Parent.Parent
	laser.Touched:Connect(function(hit)
		onTouch(hit, laser, plot)
	end)
end


for _, laser in CollectionService:GetTagged("Laser") do
	setupLaser(laser)
end

-- hook up any future lasers (e.g. clones created above)
CollectionService:GetInstanceAddedSignal("Laser"):Connect(setupLaser)