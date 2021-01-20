
function createSoldierPhysics(originalInstance)
	local customSoldierPhysics = CharacterPhysicsData(originalInstance:Clone(Guid(mmResources:Get('huntedsoldierphysics').Instance)))
	customSoldierPhysics.name = 'Characters/Soldiers/HuntedSoldierPhysics'

	for state=1, #customSoldierPhysics.states do

		local stateType = customSoldierPhysics.states[state].typeInfo.name
		local customState = _G[stateType](customSoldierPhysics.states[state]:Clone())

		if (customState:Is('JumpStateData')) then
			customState:MakeWritable()
			customState.jumpHeight = 6
			customState.jumpEffectSize = 2
		end

		if (customState:Is('InAirStateData')) then
			customState:MakeWritable()
			customState.freeFallVelocity = 100
		end

		customSoldierPhysics.states[state] = customState

		for pose=1, #customSoldierPhysics.states[state].poseInfo do

			local customPose = CharacterStatePoseInfo(customSoldierPhysics.states[state].poseInfo[pose]:Clone())
			customPose:MakeWritable()

			-- extra creepy crawling
			if (customPose.poseType == CharacterPoseType.CharacterPoseType_Prone) then
				customPose.velocity = 8
			else
				customPose.velocity = 4
			end

			customPose.sprintMultiplier = 2
			customSoldierPhysics.states[state].poseInfo[pose] = customPose
		end
	end

	return customSoldierPhysics
end

function creatSoldierBP(originalBP)
	-- Clone the original soldier blueprint and assign it our custom GUID and name.
	local customSoldierBp = SoldierBlueprint(originalBP:Clone(Guid(mmResources:Get('huntedsoldier').Instance)))
	customSoldierBp.name = 'Characters/Soldiers/HuntedSoldier'

	-- We also need to clone the original SoldierEntityData and replace all references to it.
	local originalSoldierData = customSoldierBp.object
	local customSoldierData = SoldierEntityData(originalSoldierData:Clone())

	customSoldierBp.object = customSoldierData

	for _, connection in pairs(customSoldierBp.propertyConnections) do
		if connection.source == originalSoldierData then
			connection.source = customSoldierData
		end

		if connection.target == originalSoldierData then
			connection.target = customSoldierData
		end
	end

	for _, connection in pairs(customSoldierBp.linkConnections) do
		if connection.source == originalSoldierData then
			connection.source = customSoldierData
		end

		if connection.target == originalSoldierData then
			connection.target = customSoldierData
		end
	end

	for _, connection in pairs(customSoldierBp.eventConnections) do
		if connection.source == originalSoldierData then
			connection.source = customSoldierData
		end

		if connection.target == originalSoldierData then
			connection.target = customSoldierData
		end
	end

	-- Change the soldier's max health.
	customSoldierData.maxHealth = 1000
	customSoldierData.characterPhysics = CharacterPhysicsData(mmResources:GetInstance('huntedsoldierphysics'))

	return customSoldierBp
end

Events:Subscribe('Level:RegisterEntityResources', function()
	local registry = RegistryContainer()
	local customSoldierBp = SoldierBlueprint(mmResources:GetInstance('huntedsoldier'))
	local soldierData = customSoldierBp.object

	registry.blueprintRegistry:add(customSoldierBp)
	registry.entityRegistry:add(soldierData)

	ResourceManager:AddRegistry(registry, ResourceCompartment.ResourceCompartment_Game)
end)