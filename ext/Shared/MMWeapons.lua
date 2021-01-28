class "MMWeapons"

function MMWeapons:__init()

	self.pistolDamageMultiplier = 3
	self.revolverDamageMultiplier = 4

end

function MMWeapons:Write(instance)

	if (mmResources:IsLoaded('m1911silencedbullet') and mmResources:IsLoaded('mavbullet')) then
		mmResources:SetLoaded('m1911silencedbullet', false)
		mmResources:SetLoaded('mavbullet', false)

		local projectileMod = ebxEditUtils:GetWritableInstance(mmResources:GetInstance('m1911silencedbullet'))
		projectileMod.projectileData:MakeWritable()
		projectileMod.projectileData = ebxEditUtils:GetWritableInstance(mmResources:GetInstance('mavbullet'))
		dprint('Changed M1911 Silenced Projectile...')
	end

	if (mmResources:IsLoaded('9x19mm_Pistol')) then
		mmResources:SetLoaded('9x19mm_Pistol', false)

		local bulletData = ebxEditUtils:GetWritableInstance(mmResources:GetInstance('9x19mm_Pistol'))
		bulletData.startDamage = bulletData.startDamage * self.pistolDamageMultiplier
		bulletData.endDamage = bulletData.endDamage * self.pistolDamageMultiplier

		dprint('Changed 9x19mm_Pistol Projectile...')
	end

	if (mmResources:IsLoaded('45cal_Pistol')) then
		mmResources:SetLoaded('45cal_Pistol', false)

		local bulletData = ebxEditUtils:GetWritableInstance(mmResources:GetInstance('45cal_Pistol'))
		bulletData.startDamage = bulletData.startDamage * self.pistolDamageMultiplier
		bulletData.endDamage = bulletData.endDamage * self.pistolDamageMultiplier

		dprint('Changed 45cal_Pistol Projectile...')
	end

	if (mmResources:IsLoaded('44Magnum')) then
		mmResources:SetLoaded('44Magnum', false)

		local bulletData = ebxEditUtils:GetWritableInstance(mmResources:GetInstance('44Magnum'))
		bulletData.startDamage = bulletData.startDamage * self.revolverDamageMultiplier
		bulletData.endDamage = bulletData.endDamage * self.revolverDamageMultiplier

		dprint('Changed 44Magnum Projectile...')
	end

	if (mmResources:IsLoaded('357Magnum')) then
		mmResources:SetLoaded('357Magnum', false)

		local bulletData = ebxEditUtils:GetWritableInstance(mmResources:GetInstance('357Magnum'))
		bulletData.startDamage = bulletData.startDamage * self.revolverDamageMultiplier
		bulletData.endDamage = bulletData.endDamage * self.revolverDamageMultiplier

		dprint('Changed 357Magnum Projectile...')
	end

	if (mmResources:IsLoaded('ammobag')) then
		mmResources:SetLoaded('ammobag', false)

		local fireFunc = ebxEditUtils:GetWritableInstance(mmResources:GetInstance('ammobag'))
		fireFunc.ammo.autoReplenishDelay = 10
		dprint('Changed Ammobag...')
	end

	if (mmResources:IsLoaded('ammobag_projectile')) then
		mmResources:SetLoaded('ammobag_projectile', false)

		local supplySphere = ebxEditUtils:GetWritableInstance(mmResources:GetInstance('ammobag_projectile'))
		supplySphere.supplyData.ammo.radius = 1
		supplySphere.supplyData.ammo.supplyIncSpeed = 0.75
		dprint('Changed Ammobag Projectile...')
	end

	if (mmResources:IsLoaded('medicbag')) then
		mmResources:SetLoaded('medicbag', false)

		local fireFunc = ebxEditUtils:GetWritableInstance(mmResources:GetInstance('medicbag'))
		fireFunc.ammo.autoReplenishDelay = 10
		dprint('Changed Medicbag...')
	end

	if (mmResources:IsLoaded('medicbag_projectile')) then
		mmResources:SetLoaded('medicbag_projectile', false)

		local supplySphere = ebxEditUtils:GetWritableInstance(mmResources:GetInstance('medicbag_projectile'))
		supplySphere.supplyData.healing.radius = 1
		dprint('Changed Medicbag...')
	end

	if (mmResources:IsLoaded('tugs')) then
		mmResources:SetLoaded('tugs', false)

		local deployData = ebxEditUtils:GetWritableContainer(mmResources:GetInstance('tugs'), 'object.customWeaponType')
		deployData.deployAreaRadius = 0.02
		deployData.deployAreaGroundRayLength = 5
		deployData.deployAreaGroundFlatness = 100

		local fireFunc = ebxEditUtils:GetWritableContainer(mmResources:GetInstance('tugs'), 'object.weaponFiring.primaryFire')
		fireFunc.ammo.autoReplenishDelay = 10
		fireFunc.ammo.ammoBagPickupDelayMultiplier = 10
		dprint('Changed Tugs...')
	end

	if (mmResources:IsLoaded('tugs_vehicle')) then
		mmResources:SetLoaded('tugs_vehicle', false)

		local radarSweep = ebxEditUtils:GetWritableInstance(mmResources:GetInstance('tugs_vehicle'))
		radarSweep.controllableSweepInterval = 0.8
		radarSweep.mineSweepInterval = 0.8
		dprint('Changed Tugs Vehicle...')
	end
end

-- specific to GunMaster only
--[[
Events:Subscribe('Level:Loaded', function()

end)
]]

return MMWeapons()