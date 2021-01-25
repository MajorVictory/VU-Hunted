

local visualEnvironmentEntity = nil

-- send config to compass mod
Events:Dispatch('Compass:Config', {
	['position'] = 'bottom'
})

function onSetNightvisionState(enabled)
	if (enabled) then
		if visualEnvironmentEntity ~= nil then
			return
		end

		local visionBP = ebxEditUtils:GetWritableInstance(mmResources:GetInstance('nightvision')):Clone()
		local nightVisionEntityData = VisualEnvironmentEntityData(visionBP.object:Clone())
		nightVisionEntityData:MakeWritable()
		nightVisionEntityData.enabled = true
		nightVisionEntityData.visibility = 1.0
		nightVisionEntityData.priority = 9001

		visualEnvironmentEntity = EntityManager:CreateEntity(nightVisionEntityData, LinearTransform())

		if visualEnvironmentEntity ~= nil then
			visualEnvironmentEntity:Init(Realm.Realm_Client, true)
		end
	else
		if visualEnvironmentEntity ~= nil then
			visualEnvironmentEntity:Destroy()
			visualEnvironmentEntity = nil
		end
	end
end

function onSetInvisibleState(enabled)
	local myself = PlayerManager:GetLocalPlayer()
	if (myself ~= nil and myself.soldier ~= nil and myself.soldier.alive) then
		--myself.soldier.forceInvisible = enabled
		myself:EnableInput(EntryInputActionEnum.EIAFire, (not enabled))
		myself:EnableInput(EntryInputActionEnum.EIAMeleeAttack, (not enabled))
		myself:EnableInput(EntryInputActionEnum.EIAThrowGrenade, (not enabled))
	end
end

function onSetSpectatorState(enabled)
	SpectatorManager:SetSpectating(enabled)
end

function onUnload()
	onSetNightvisionState(false)
	onSetInvisibleState(false)
	onSetSpectatorState(false)
end

NetEvents:Subscribe("Hunted:SetSpectatorState", onSetSpectatorState)
NetEvents:Subscribe("Hunted:SetNightVisionState", onSetNightvisionState)
NetEvents:Subscribe("Hunted:SetInvisibleState", onSetInvisibleState)
Events:Subscribe('Extension:Unloading', onUnload)

-- for testing
Console:Register('SetNightVisionState', '<boolean>', function(args)
    onSetNightvisionState((args and (args[1] == "true" or args[1] =='1')))
end)

Console:Register('SetSpectatorState', '<boolean>', function(args)
    onSetSpectatorState((args and (args[1] == "true" or args[1] =='1')))
end)

Console:Register('SetInvisibleState', '<boolean>', function(args)
    onSetInvisibleState((args and (args[1] == "true" or args[1] =='1')))
end)