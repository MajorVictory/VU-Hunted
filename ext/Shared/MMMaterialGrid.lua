
-- adpated from: https://github.com/J4nssent/VU-Mods/blob/master/VehicleDamageTweak/ext/Shared/__init__.lua

-- member(107) MedicBag
-- member(108) Supply
-- member(109) ThrowingWeapon
-- member(151) EMP

local MaterialChangesList = {
	{
		materialA = 151, -- EMP
		materialB = 107, -- Medicbag
		collisionDamageMultiplier = 1.0,
		collisionDamageThreshold = 30.0,
		damageProtectionMultiplier = 1.0,
		damagePenetrationMultiplier = 1.0,
		damageProtectionThreshold = 2.0,
		explosionCoverDamageModifier = 1.0,
		inflictsDemolitionDamage = true,
	},
	{
		materialA = 151, -- EMP
		materialB = 108, -- Ammobag
		collisionDamageMultiplier = 1.0,
		collisionDamageThreshold = 30.0,
		damageProtectionMultiplier = 1.0,
		damagePenetrationMultiplier = 1.0,
		damageProtectionThreshold = 2.0,
		explosionCoverDamageModifier = 1.0,
		inflictsDemolitionDamage = true,
	},
	{
		materialA = 151, -- EMP
		materialB = 52, -- C4
		collisionDamageMultiplier = 1.0,
		collisionDamageThreshold = 30.0,
		damageProtectionMultiplier = 1.0,
		damagePenetrationMultiplier = 1.0,
		damageProtectionThreshold = 2.0,
		explosionCoverDamageModifier = 1.0,
		inflictsDemolitionDamage = true,
	},
	{
		materialA = 151, -- EMP
		materialB = 106, -- ExplosionPack
		collisionDamageMultiplier = 1.0,
		collisionDamageThreshold = 30.0,
		damageProtectionMultiplier = 1.0,
		damagePenetrationMultiplier = 1.0,
		damageProtectionThreshold = 2.0,
		explosionCoverDamageModifier = 1.0,
		inflictsDemolitionDamage = true,
	},
}


Events:Subscribe('Partition:Loaded', function(partition)

	if not partition.primaryInstance:Is('MaterialGridData') then
		return
	end

	local materialGrid = MaterialGridData(partition.primaryInstance)
	materialGrid:MakeWritable()

	for i=1, #MaterialChangesList do
		local materialSettings = MaterialChangesList[i]

		local matALevelPropertyIndex = materialGrid.materialIndexMap[materialSettings.materialA+1]
		local matBLevelPropertyIndex = materialGrid.materialIndexMap[materialSettings.materialB+1]

		if matALevelPropertyIndex ~= 0 and matBLevelPropertyIndex ~= 0 then
			
			local matAPropertyPair = materialGrid.interactionGrid[matALevelPropertyIndex+1].items[matBLevelPropertyIndex+1]
			local matBPropertyPair = materialGrid.interactionGrid[matBLevelPropertyIndex+1].items[matALevelPropertyIndex+1]

			local customDamageData = MaterialRelationDamageData()
			customDamageData.collisionDamageMultiplier = materialSettings.collisionDamageMultiplier
			customDamageData.collisionDamageThreshold = materialSettings.collisionDamageThreshold
			customDamageData.damageProtectionMultiplier = materialSettings.damageProtectionMultiplier
			customDamageData.damagePenetrationMultiplier = materialSettings.damagePenetrationMultiplier
			customDamageData.damageProtectionThreshold = materialSettings.damageProtectionThreshold
			customDamageData.explosionCoverDamageModifier = materialSettings.explosionCoverDamageModifier
			customDamageData.inflictsDemolitionDamage = materialSettings.inflictsDemolitionDamage

			for _,propertyPair in pairs({matAPropertyPair, matBPropertyPair}) do
				for i = 1, #propertyPair.physicsPropertyProperties do
					if propertyPair.physicsPropertyProperties[i]:Is('MaterialRelationDamageData') then
						propertyPair.physicsPropertyProperties[i] = customDamageData
					end
				end
			end
		end
	end
end)
