class "MMWeapons"

function MMWeapons:Write(instance)

	if (mmResources:IsLoaded('m1911silencedbullet') and mmResources:IsLoaded('mavbullet')) then
		mmResources:SetLoaded('m1911silencedbullet', false)
		mmResources:SetLoaded('mavbullet', false)

		local projectileMod = ebxEditUtils:GetWritableInstance(mmResources:GetInstance('m1911silencedbullet'))
		projectileMod.projectileData:MakeWritable()
		projectileMod.projectileData = ebxEditUtils:GetWritableInstance(mmResources:GetInstance('mavbullet'))
		dprint('Changed M1911 Silenced Projectile...')
	end
end

-- specific to GunMaster only
--[[
Events:Subscribe('Level:Loaded', function()

end)
]]

return MMWeapons()