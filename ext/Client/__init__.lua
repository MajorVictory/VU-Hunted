

local visualEnvironments = {}
local nightVisionEntity = nil

Events:Subscribe('Partition:Loaded', function(partition)
	for _, instance in pairs(partition.instances) do

		-- global vehicle "Sturdification"
		if (instance:Is('VisualEnvironmentBlueprint')) then
			local visualEnvironment = VisualEnvironmentBlueprint(instance)
			print('VisualEnvironmentBlueprint: '..visualEnvironment.name.. '['..tostring(visualEnvironment.instanceGuid)..']')
			visualEnvironments[visualEnvironment.name] = tostring(visualEnvironment.instanceGuid)
		end
	end
end)


Console:Register('nightvision', 'Set Nightvision Environment', function(args)

	if #args < 1 then
		for i=1, #visualEnvironments do
			print('['..i..']: '..visualEnvironments[i])
		end
	elseif (args[1] == '0' or args[1] == 'false') then
		disableNightVision()
	else
		disableNightVision()
		enableNightVision(args[1])
	end
end)


function enableNightVision(environment)
	if nightVisionEntity ~= nil then
		return
	end

	if (environment == nil) then
		environment = mmResources:GetInstance('nightvision')
	end

	local visionBP = ebxEditUtils:GetWritableInstance(environment):Clone()
	local nightVisionEntityData = VisualEnvironmentEntityData(visionBP.object:Clone())
	nightVisionEntityData:MakeWritable()
	nightVisionEntityData.enabled = true
	nightVisionEntityData.visibility = 1.0
	nightVisionEntityData.priority = 9001

	nightVisionEntity = EntityManager:CreateEntity(nightVisionEntityData, LinearTransform())

	if nightVisionEntity ~= nil then
		nightVisionEntity:Init(Realm.Realm_Client, true)
	end
end

function disableNightVision()
	if nightVisionEntity ~= nil then
		nightVisionEntity:Destroy()
		nightVisionEntity = nil
	end
end

NetEvents:Subscribe("Hunted:EnableNightVision", enableNightVision)
NetEvents:Subscribe("Hunted:DisableNightVision", disableNightVision)
Events:Subscribe('Extension:Unloading', disableNightVision)