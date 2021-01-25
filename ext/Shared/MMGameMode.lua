class "MMGameMode"

function MMGameMode:__init()
	self.RoundState = {
	    PreRound = 0,
	    Playing = 1,
	    PostRound = 2
	}
	self.Teams = {
	    Soldier = TeamId.Team1,
	    Hunted = TeamId.Team2,
	    Spectator = TeamId.TeamNeutral
	}
	self.Squads = {
	    Soldier = SquadId.Squad1,
	    Hunted = SquadId.Squad2,
	    Spectator = SquadId.SquadNone
	}
	self.KillsNeeded = {
	    Soldier = {maxKillCount = 100, enemyWeight = 25},
	    Hunted = {maxKillCount = 100, enemyWeight = 10},
	    Spectator = {maxKillCount = 100, enemyWeight = 1}
	}
	self.currentRoundState = 0
	self.preRoundTimer = 2
end


function MMGameMode:Write(instance)
end

function MMGameMode:HandleInstance(partition, instance)

	if (instance:Is('PreRoundEntityData')) then
		print('Found PreRoundEntityData: '..tostring(instance.instanceGuid))
		local castIntance = ebxEditUtils:GetWritableInstance(instance)
		castIntance.roundRestartCountdown = self.preRoundTimer
	end

	if (instance:Is('AutoTeamEntityData')) then
		print('Found AutoTeamEntityData: '..tostring(instance.instanceGuid))
		local castIntance = ebxEditUtils:GetWritableInstance(instance)
		castIntance.autoBalance = false
	end

	if (instance:Is('KillCounterEntityData')) then
		print('Found KillCounterEntityData: '..tostring(instance.instanceGuid))
		local castIntance = ebxEditUtils:GetWritableInstance(instance)
		local teamName = self:TeamIDToName(castIntance.teamId)
		castIntance.maxKillCount = self.KillsNeeded[teamName].maxKillCount
		castIntance.enemyWeight = self.KillsNeeded[teamName].enemyWeight
	end

end


function MMGameMode:SetRoundState(state)
	self.currentRoundState = state
end


function MMGameMode:SetRoundState(state)
	self.currentRoundState = state
end

function MMGameMode:GetRoundState()
	return self.currentRoundState
end

function MMGameMode:ConvertTeamID(teamId)
	if (teamId == 0) then
		return self.Teams.Spectator
	elseif (teamId % 2 == 0) then
		return self.Teams.Hunted
	else
		return self.Teams.Soldier
	end
end

function MMGameMode:TeamIDToName(teamId)
	if (teamId == 0) then
		return 'Spectator'
	elseif (teamId % 2 == 0) then
		return 'Hunted'
	else
		return 'Soldier'
	end
end

function MMGameMode:GetPlayers()
	local players = PlayerManager:GetPlayers()
	local team_us = {}
	local team_ru = {}
	local team_spec = {}

	for i=1, #players do
		if (players[i].teamId == 0) then
			table.insert(team_spec, players[i])
		elseif (players[i].teamId % 2 == 0) then
			table.insert(team_ru, players[i])
		else
			table.insert(team_us, players[i])
		end
	end

	return team_us, team_ru, team_spec
end

function MMGameMode:GetPlayersByTeam(teamId)
	local PlayersUS, PlayersRU, PlayersSpec = self:GetPlayers()
	if (teamId == self.Teams.Soldier) then
		return PlayersUS
	elseif (teamId == self.Teams.Hunted) then
		return PlayersRU
	else
		return PlayersSpec
	end
end

function MMGameMode:SetTeam(player, teamName)
	print('MMGameMode:SetTeam: '..player.name.. ' | '..teamName)
	player.teamId = mmGameMode.Teams[teamName]
end

function MMGameMode:SetSquad(player, teamName)
	print('MMGameMode:SetSquad: '..player.name.. ' | '..teamName)
	player.squadId = mmGameMode.Squads[teamName]
end

return MMGameMode()