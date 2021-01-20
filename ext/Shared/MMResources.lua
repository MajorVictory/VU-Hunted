class "MMResources"

function MMResources:__init()
	self.MMResources = {}

	self.MMResources["chat"] = {}
	self.MMResources["chat"]["Partition"] = '3E6AF1E2-B10E-11DF-9395-96FA88A245BF'
	self.MMResources["chat"]["Instance"] = '78B3E33E-098B-3320-ED15-89A36F04007B'

	self.MMResources["knoife"] = {}
	self.MMResources["knoife"]["Partition"] = 'B6CDC48A-3A8C-11E0-843A-AC0656909BCB'
	self.MMResources["knoife"]["Instance"] = 'F21FB5EA-D7A6-EE7E-DDA2-C776D604CD2E'

	self.MMResources["yump"] = {}
	self.MMResources["yump"]["Partition"] = '235CD1DA-8B06-4A7F-94BE-D50DA2D077CE'
	self.MMResources["yump"]["Instance"] = '3129BCFE-000E-4001-9F8F-316E5835C9FC'

	self.MMResources["pose_stand"] = {}
	self.MMResources["pose_stand"]["Partition"] = '235CD1DA-8B06-4A7F-94BE-D50DA2D077CE'
	self.MMResources["pose_stand"]["Instance"] = '69A866A2-DF7C-4BAD-B55F-99536F2551F6'

	self.MMResources["pose_standair"] = {}
	self.MMResources["pose_standair"]["Partition"] = '235CD1DA-8B06-4A7F-94BE-D50DA2D077CE'
	self.MMResources["pose_standair"]["Instance"] = 'DF7475F9-216E-48C3-AED1-5483EFA3BB15'

	self.MMResources["pose_swimming"] = {}
	self.MMResources["pose_swimming"]["Partition"] = '235CD1DA-8B06-4A7F-94BE-D50DA2D077CE'
	self.MMResources["pose_swimming"]["Instance"] = 'C3755191-6B9F-4B88-8677-59488AFC7530'

	self.MMResources["pose_climbing"] = {}
	self.MMResources["pose_climbing"]["Partition"] = '235CD1DA-8B06-4A7F-94BE-D50DA2D077CE'
	self.MMResources["pose_climbing"]["Instance"] = 'AF7A12E9-D79A-4856-8C03-3C88DF1ED8A6'

	self.MMResources["pose_chute"] = {}
	self.MMResources["pose_chute"]["Partition"] = '235CD1DA-8B06-4A7F-94BE-D50DA2D077CE'
	self.MMResources["pose_chute"]["Instance"] = 'F39A8591-BA69-4BE9-B289-B2A0B336A7EE'

	self.MMResources["mpsoldier"] = {}
	self.MMResources["mpsoldier"]["Partition"] = 'F256E142-C9D8-4BFE-985B-3960B9E9D189'
	self.MMResources["mpsoldier"]["Instance"] = '261E43BF-259B-41D2-BF3B-9AE4DDA96AD2'

	self.MMResources["huntedsoldier"] = {}
	self.MMResources["huntedsoldier"]["Partition"] = 'F256E142-C9D8-4BFE-985B-3960B9E9D189'
	self.MMResources["huntedsoldier"]["Instance"] = '261E43BF-1118-1987-BF34-000000000001' -- custom guid

	self.MMResources["mpsoldierphysics"] = {}
	self.MMResources["mpsoldierphysics"]["Partition"] = '235CD1DA-8B06-4A7F-94BE-D50DA2D077CE'
	self.MMResources["mpsoldierphysics"]["Instance"] = 'A10FF2AA-F3CF-416B-A79B-E8C5416A9EBC'

	self.MMResources["huntedsoldierphysics"] = {}
	self.MMResources["huntedsoldierphysics"]["Partition"] = '235CD1DA-8B06-4A7F-94BE-D50DA2D077CE'
	self.MMResources["huntedsoldierphysics"]["Instance"] = '261E43BF-1118-1987-BF34-000000000002' -- custom guid

	self.MMResources["nightvision"] = {}
	self.MMResources["nightvision"]["Partition"] = 'C7E88CE9-CD43-4490-8E44-D6A813A07145'
	self.MMResources["nightvision"]["Instance"] = 'F4F6815E-43E1-4FA4-A1DF-617308ED63F4' -- custom guid


	self.MMResources["team_ru"] = {}
	self.MMResources["team_ru"]["Partition"] = 'AE32D36B-372B-4D7E-9D4A-2938355F4A82'
	self.MMResources["team_ru"]["Instance"] = 'DA5D89A8-5157-4B5A-813C-128903870851'

	self.MMResources["team_ru_gm"] = {}
	self.MMResources["team_ru_gm"]["Partition"] = '48C2B2E7-55F4-4758-8EFE-84F9AB081AAB'
	self.MMResources["team_ru_gm"]["Instance"] = '6E461057-B354-4C5F-9B0C-5A99D06401F0'

	self.MMResources["team_ru_gm_xp4"] = {}
	self.MMResources["team_ru_gm_xp4"]["Partition"] = '82F864C4-F3B6-4D2F-8235-F184F17B4EB0'
	self.MMResources["team_ru_gm_xp4"]["Instance"] = '762E3274-CEBF-4DB6-AE25-AAEF382FBDAB'

	self.MMResources["team_ru_large"] = {}
	self.MMResources["team_ru_large"]["Partition"] = '19631E31-2E3A-432B-8929-FB57BAA7D28E'
	self.MMResources["team_ru_large"]["Instance"] = 'B4BB6CFA-0E53-45F9-B190-1287DCC093A9'

	self.MMResources["team_ru_xp4"] = {}
	self.MMResources["team_ru_xp4"]["Partition"] = '3B5C4E3D-6614-4C5D-8712-1661C0B08FE1'
	self.MMResources["team_ru_xp4"]["Instance"] = '1FF2397E-9455-418B-833E-511786CBD148'

	self.MMResources["team_ru_xp4_scv"] = {}
	self.MMResources["team_ru_xp4_scv"]["Partition"] = 'EFCF6ECE-2B43-4358-A694-0E2D5F81E3B0'
	self.MMResources["team_ru_xp4_scv"]["Instance"] = '092BAEF2-78B5-4D29-8E85-661FCD934491'


	for resourceName, resourceData in pairs(self.MMResources) do
		self.MMResources[resourceName].Loaded = false
	end
end


function MMResources:IsLoaded(resourceName)
	if not self.MMResources[resourceName] then
		print("Tried to check unregistered resource: "..tostring(resourceName))
		return false
	else
		return self.MMResources[resourceName].Loaded
	end
end

function MMResources:SetLoaded(resourceName, value)
	if not self.MMResources[resourceName] then
		print("Tried to set unregistered resource: "..tostring(resourceName))
	else
		self.MMResources[resourceName].Loaded = value
		if (value) then
			dprint("Resource Loaded: "..tostring(resourceName))
		end
	end
end

function MMResources:Get(resourceName)
	if (resourceName ~= nil) then
		return self.MMResources[resourceName]
	else
		return self.MMResources
	end
end

function MMResources:GetPartition(resourceName)
	return ResourceManager:FindDatabasePartition(Guid(self.MMResources[resourceName].Partition))
end

function MMResources:GetInstance(resourceName, secondaryResource)
	if (secondaryResource ~= nil) then
		return ResourceManager:FindInstanceByGuid(Guid(self.MMResources[resourceName].Partition), Guid(self.MMResources[resourceName][secondaryResource]))
	else
		return ResourceManager:FindInstanceByGuid(Guid(self.MMResources[resourceName].Partition), Guid(self.MMResources[resourceName].Instance))
	end
end

function MMResources:AddToPartition(resourceName, partition)
	if not self.MMResources[resourceName] then
		print("Tried to add unregistered resource to partition: "..tostring(resourceName))
		return
	end

    print('Adding '..resourceName..' instances to partition...')
    self.MMResources[resourceName].Register = true
	local resourceData = self.MMResources[resourceName]

	if (resourceData.Entities) then
        print("Adding Entities ["..resourceName.."]...")
        for i = 1, #resourceData.Entities do
            local res = ResourceManager:SearchForInstanceByGuid(Guid(resourceData.Entities[i]))
            if (res) then
                print("["..i.."] Added: "..res.typeInfo.name)
                partition:AddInstance(res)
            else
                print("["..i.."] Failed: "..resourceData.Entities[i])
            end
        end
    end
    if (resourceData.Blueprints) then
        print("Adding Blueprints ["..resourceName.."]...")
        for i = 1, #resourceData.Blueprints do
            local res = ResourceManager:SearchForInstanceByGuid(Guid(resourceData.Blueprints[i]))
            if (res) then
                print("["..i.."] Added: "..res.typeInfo.name)
                partition:AddInstance(res)
            else
                print("["..i.."] Failed: "..resourceData.Blueprints[i])
            end
        end
    end
    if (resourceData.LogicReferrence) then
        print("Adding Logic Referrences ["..resourceName.."]...")
        for i = 1, #resourceData.LogicReferrence do
            local res = ResourceManager:SearchForInstanceByGuid(Guid(resourceData.LogicReferrence[i]))
            if (res) then
                print("["..i.."] Added: "..res.typeInfo.name)
                partition:AddInstance(res)
            else
                print("["..i.."] Failed: "..resourceData.LogicReferrence[i])
            end
        end
    end
end

function MMResources:CreateRegistryContainer()
	local resourceContainer = RegistryContainer()
    
    print('Creating instance registry...')
    local registrySize = 0

    for resourceName, resourceData in pairs(self.MMResources) do
    	if (resourceData.Register) then 
	        if (resourceData.Entities) then
	            print("Adding Entities ["..resourceName.."]...")
	            for i = 1, #resourceData.Entities do
	                local res = ResourceManager:SearchForInstanceByGuid(Guid(resourceData.Entities[i]))
	                if (res) then
	                    print("["..i.."] Added: "..res.typeInfo.name)
	                    resourceContainer.entityRegistry:add(res)
	                    registrySize = registrySize+1
	                else
	                    print("["..i.."] Failed: "..resourceData.Entities[i])
	                end
	            end
	        end
	        if (resourceData.Blueprints) then
	            print("Adding Blueprints ["..resourceName.."]...")
	            for i = 1, #resourceData.Blueprints do
	                local res = ResourceManager:SearchForInstanceByGuid(Guid(resourceData.Blueprints[i]))
	                if (res) then
	                    print("["..i.."] Added: "..res.typeInfo.name)
	                    resourceContainer.blueprintRegistry:add(res)
	                    registrySize = registrySize+1
	                else
	                    print("["..i.."] Failed: "..resourceData.Blueprints[i])
	                end
	            end
	        end
	        if (resourceData.LogicReferrence) then
	            print("Adding Logic Referrences ["..resourceName.."]...")
	            for i = 1, #resourceData.LogicReferrence do
	                local res = ResourceManager:SearchForInstanceByGuid(Guid(resourceData.LogicReferrence[i]))
	                if (res) then
	                    print("["..i.."] Added: "..res.typeInfo.name)
	                    resourceContainer.referenceObjectRegistry:add(res)
	                    registrySize = registrySize+1
	                else
	                    print("["..i.."] Failed: "..resourceData.LogicReferrence[i])
	                end
	            end
	        end
	    end
    end
    if (registrySize > 0) then
    	return resourceContainer
    else
    	return
    end
end

function MMResources:ScaleTransforms(transformList, scale)

	if (transformList == nil or #transformList < 1) then 
		return
	end
	if (scale == nil) then 
		scale = 1
	end

	for i=1, #transformList do

		local transform = nil

		if (transformList[i].typeInfo.name ~= 'LinearTransform' and transformList[i].transform) then 
			transform = transformList[i].transform
		else 
			transform = transformList[i]
		end

		if (transform.left == nil) then
			transform.right = transform.right * scale
		else
			transform.left.x = scale
		end

		transform.up.y = scale
		transform.forward.z = scale

		transform.trans.x = transform.trans.x * scale
		transform.trans.y = transform.trans.y * scale
		transform.trans.z = transform.trans.z * scale
	end

end

return MMResources()