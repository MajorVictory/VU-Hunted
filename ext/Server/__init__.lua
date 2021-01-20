
require('__shared/MMUtils')

-- load resource list
mmResources = require('__shared/MMResources')

-- modules
mmPlayers = require('__shared/MMPlayers')
mmWeapons = require('__shared/MMWeapons')

-- register console variables
mmConVars = require('__shared/MMConVars')
mmConVars:RegisterEvents('Server')


function enableNightVision(player)
	if player and player.teamId == TeamId.Team2 then
		print('Hunted:EnableNightVision: '..player.name)
		NetEvents:SendToLocal('Hunted:EnableNightVision', player)
	end
end
function disableNightVision(player)
	if player and player.teamId == TeamId.Team2 then
		print('Hunted:DisableNightVision: '..player.name)
		NetEvents:SendToLocal('Hunted:DisableNightVision', player)
	end
end

Events:Subscribe('Player:Killed', disableNightVision)

Events:Subscribe('Player:Respawn', enableNightVision)
Events:Subscribe('Player:Created', enableNightVision)
Events:Subscribe('Player:SpawnOnPlayer', enableNightVision)
Events:Subscribe('Player:SpawnAtVehicle', enableNightVision)
Events:Subscribe('Player:SpawnOnSelectedSpawnPoint', enableNightVision)