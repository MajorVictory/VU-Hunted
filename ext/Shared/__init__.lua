
-- global funcs and utils
require('__shared/MMUtils')

-- load resource list
mmResources = require('__shared/MMResources')

-- modules
mmPlayers = require('__shared/MMPlayers')
mmWeapons = require('__shared/MMWeapons')
mmGameMode = require('__shared/MMGameMode')

require('__shared/MMCustomSoldier')
require('__shared/MMMaterialGrid')

-- loop registered resources to listen for
for resourceName, resourceData in pairs(mmResources:Get()) do
	if (resourceData.Partition and resourceData.Instance) then
		ResourceManager:RegisterInstanceLoadHandler(Guid(resourceData.Partition), Guid(resourceData.Instance), function(instance)
			mmResources:SetLoaded(resourceName, true)
			mmPlayers:Write(instance)
			mmWeapons:Write(instance)
			mmGameMode:Write(instance)
		end)
	end
end

Events:Subscribe('Partition:Loaded', function(partition)
	for _, instance in pairs(partition.instances) do
		mmGameMode:HandleInstance(partition, instance)
	end
end)

-- all these bundles to get the superior nightvision for the hunted
Events:Subscribe('Level:LoadResources', function()
	ResourceManager:MountSuperBundle('spchunks')
	ResourceManager:MountSuperBundle('levels/sp_sniper/sp_sniper')
end)

Hooks:Install('ResourceManager:LoadBundles', 100, function(hook, bundles, compartment)
	if #bundles == 1 and bundles[1] == SharedUtils:GetLevelName() then
		print('Injecting bundles.')

		bundles = {
			'levels/sp_sniper/sp_sniper',
			'levels/sp_sniper/albashirstrike',
			bundles[1],
		}

		hook:Pass(bundles, compartment)
	end
end)

Events:Subscribe('Level:RegisterEntityResources', function(levelData)
	local registry = RegistryContainer(ResourceManager:SearchForInstanceByGuid(Guid('2E3BEE0C-AC8F-A2C1-5E78-833BA278093C')))
	ResourceManager:AddRegistry(registry, ResourceCompartment.ResourceCompartment_Game)
end)