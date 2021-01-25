
require('__shared/MMUtils')

-- load resource list
mmResources = require('__shared/MMResources')

-- modules
mmPlayers = require('__shared/MMPlayers')
mmWeapons = require('__shared/MMWeapons')
mmGameMode = require('__shared/MMGameMode')

-- register console variables
mmConVars = require('__shared/MMConVars')
mmConVars:RegisterEvents('Server')


function onPlayerSpawned(player)

	local PlayersUS, PlayersRU, PlayersSpec = mmGameMode:GetPlayers()
	local startHealth = (#PlayersUS * 500)
	if (#PlayersUS > 4 and #PlayersRU > 1) then
		startHealth = math.round(startHealth / PlayersRU)
	end

	local customSoldier = ebxEditUtils:GetWritableContainer(mmResources:GetInstance('huntedsoldier'), 'object')
	customSoldier.maxHealth = math.max(math.min(startHealth, 2000), 250)
	setNightVisionState(player)
	setInvisibleState(player)
end

function onPlayerKilled(player)
	setNightVisionState(player, false)
	setInvisibleState(player, false)
	setSpectatorState(player, true)
end

function onPlayerAuthed(player)

	local PlayersUS, PlayersRU, PlayersSpec = mmGameMode:GetPlayers()
	
	if mmGameMode:GetRoundState() == mmGameMode.RoundState.Playing then
		mmGameMode:SetTeam(player, 'Spectator')
		mmGameMode:SetSquad(player, 'Spectator')
	elseif mmGameMode:GetRoundState() == mmGameMode.RoundState.PreRound then
		if (#PlayersRU == 0 or (#PlayersUS > 0 and PlayersUS % 5 == 0)) then
			mmGameMode:SetTeam(player, 'Hunted')
			mmGameMode:SetSquad(player, 'Hunted')
		else 
			mmGameMode:SetTeam(player, 'Soldier')
			mmGameMode:SetSquad(player, 'Soldier')
		end
	end
end

function setTeamHumans(player)
	print('setTeamHumans: '..player.name)
	player.teamId = mmGameMode.Teams.Soldier
	player.squadId = mmGameMode.Squads.Soldier
end

function setTeamHunted(player)
	print('setTeamHunted: '..player.name)
	player.teamId = mmGameMode.Teams.Hunted
	player.squadId = mmGameMode.Squads.Hunted
end

function onTeamChange(hook, player, team)
	local newTeamId = mmGameMode:ConvertTeamID(team)
	if (newTeamId == mmGameMode.Teams.Hunted) then
		setNightVisionState(player, false)
		setInvisibleState(player, false)
		setSpectatorState(player, false)
		mmGameMode:SetTeam(player, 'Soldier')
		mmGameMode:SetSquad(player, 'Soldier')
		team = mmGameMode.Teams.Soldier

	elseif (newTeamId == mmGameMode.Teams.Soldier) then
		setSpectatorState(player, false)
		mmGameMode:SetTeam(player, 'Hunted')
		mmGameMode:SetSquad(player, 'Hunted')
		team = mmGameMode.Teams.Hunted

	else
		setNightVisionState(player, false)
		setInvisibleState(player, false)
		setSpectatorState(player, true)
		mmGameMode:SetTeam(player, 'Spectator')
		mmGameMode:SetSquad(player, 'Spectator')
		team = mmGameMode.Teams.Spectator
	end
	hook:Pass(player, team)
end

function onFindSquad(hook, player)
	local gamemodeTeamId = mmGameMode:ConvertTeamID(player.teamId)
	if (gamemodeTeamId == mmGameMode.Teams.Hunted) then
		mmGameMode:SetSquad(player, 'Soldier')

	elseif (gamemodeTeamId == mmGameMode.Teams.Soldier) then
		mmGameMode:SetSquad(player, 'Hunted')

	else
		mmGameMode:SetSquad(player, 'Spectator')
	end
	hook:Return()
end

function setNightVisionState(player, enabled)
	if (enabled == nil) then
		enabled = (mmGameMode:ConvertTeamID(player.teamId) == mmGameMode.Teams.Hunted)
	end
	print('Hunted:SetNightVisionState: '..player.name..' | '..tostring(enabled))
	NetEvents:SendToLocal('Hunted:SetNightVisionState', player, enabled)
end

function setInvisibleState(player, enabled)
	if (player ~= nil and player.soldier ~= nil) then
		if (enabled == nil) then
			enabled = (player.soldier.pose == CharacterPoseType.CharacterPoseType_Crouch)
		end

		if (player.soldier.forceInvisible ~= enabled) then
			player.soldier.forceInvisible = enabled

			player:EnableInput(EntryInputActionEnum.EIAFire, (not enabled))
			player:EnableInput(EntryInputActionEnum.EIAMeleeAttack, (not enabled))
			player:EnableInput(EntryInputActionEnum.EIAThrowGrenade, (not enabled))


			player:EnableInput(EntryInputActionEnum.EIAThrottle, true)
			player:EnableInput(EntryInputActionEnum.EIAStrafe, true)
			player:EnableInput(EntryInputActionEnum.EIAJump, true)
			player:EnableInput(EntryInputActionEnum.EIAProne, true)

			print('Hunted:SetInvisibleState: '..player.name..' | '..tostring(enabled))
			NetEvents:SendToLocal('Hunted:SetInvisibleState', player, enabled)
		end
	end
end

function setSpectatorState(player, enabled)
	if (enabled == nil) then
		enabled = player.alive
	end
	--player.isAllowedToSpawn = (not enabled)
	--player.teamId = mmGameMode.Teams.Spectator
	--player.squadId = mmGameMode.Squads.Spectator
	--print('Hunted:SetSpectatorState: '..player.name..' | '..tostring(enabled))
	--NetEvents:SendToLocal('Hunted:SetSpectatorState', player, enabled)
end

Events:Subscribe('Player:Authenticated', function(player)
	print('Player:Authenticated: '..player.name)
	onPlayerAuthed(player)
end)

Events:Subscribe('Player:Killed', function(player)
	print('Player:Killed: '..player.name)
	onPlayerKilled(player)
end)

Events:Subscribe('Player:Respawn', function(player)
	print('Player:Respawn: '..player.name)
	onPlayerSpawned(player)
end)
Events:Subscribe('Player:Created', function(player)
	print('Player:Created: '..player.name)
	onPlayerSpawned(player)
end)
Events:Subscribe('Player:SpawnOnPlayer', function(playerA, playerB)
	print('Player:SpawnOnPlayer: '..playerA.name)
	onPlayerSpawned(playerA)
end)
Events:Subscribe('Player:SpawnAtVehicle', function(player, vehicle)
	print('Player:SpawnAtVehicle: '..player.name)
	onPlayerSpawned(player)
end)
Events:Subscribe('Player:SpawnOnSelectedSpawnPoint', function(player)
	print('Player:SpawnOnSelectedSpawnPoint: '..player.name)
	onPlayerSpawned(player)
end)

Hooks:Install('Player:SelectTeam', 1, onTeamChange)
--Hooks:Install('Player:FindBestSquad', 1, onFindSquad)

playerIsHiding = {}
playerTimers = {}

Events:Subscribe('Engine:Update', function(deltaTime, simulationDeltaTime)

	for playerGuid, timerData in  pairs(playerTimers) do
		if (timerData ~= nil) then
			timerData.wait = timerData.wait - deltaTime

			if (timerData.wait < 0) then
				print('Timer triggered: '..tostring(timerData))
				timerData.callback(table.unpack(timerData.args))
				playerTimers[playerGuid] = nil
			end
		end
	end

	local huntedPlayers = mmGameMode:GetPlayersByTeam(mmGameMode.Teams.Hunted)
	for i=1, #huntedPlayers do
		local player = huntedPlayers[i]
		if (player.soldier ~= nil) then

			local isCrouching = (player.soldier.pose == CharacterPoseType.CharacterPoseType_Crouch)

			-- crouched, then uncrouched
			if (playerIsHiding[tostring(player.guid)] and not isCrouching) then
				-- cancel any active timer
				if (playerTimers[tostring(player.guid)] ~= nil and playerTimers[tostring(player.guid)].wait > 0) then
					playerTimers[tostring(player.guid)] = nil
				end
			end

			-- crouching and holding
			if (playerIsHiding[tostring(player.guid)] and isCrouching) then
				-- no timer and player is visible
				if (playerTimers[tostring(player.guid)] == nil and not player.soldier.forceInvisible) then
					-- insert new timer
					playerTimers[tostring(player.guid)] = {
						['wait'] = 5.0, -- 5 second delay to hide
						['callback'] = setInvisibleState,
						['args'] = {player, isCrouching}
					}
				end
			end

			-- still hidden but stopped crouching
			if (player.soldier.forceInvisible and playerIsHiding[tostring(player.guid)] and not isCrouching) then
				-- no timer
				if (playerTimers[tostring(player.guid)] == nil) then
					-- insert new timer
					playerTimers[tostring(player.guid)] = {
						['wait'] = 2.0, --2 second delay after hiding
						['callback'] = setInvisibleState,
						['args'] = {player, isCrouching}
					}

					-- prevent movement/actions until timer completes
					player:EnableInput(EntryInputActionEnum.EIAThrottle, false)
					player:EnableInput(EntryInputActionEnum.EIAStrafe, false)
					player:EnableInput(EntryInputActionEnum.EIAJump, false)
					player:EnableInput(EntryInputActionEnum.EIAProne, false)
				end
			end

			-- update current state
			playerIsHiding[tostring(player.guid)] = isCrouching
		end
	end
end)