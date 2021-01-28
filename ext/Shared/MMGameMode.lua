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
	    Hunted = SquadId.Squad1,
	    Spectator = SquadId.SquadNone
	}
	self.KillsNeeded = {
	    Soldier = {maxKillCount = 100, enemyWeight = 20},
	    Hunted = {maxKillCount = 100, enemyWeight = 10},
	    Spectator = {maxKillCount = 100, enemyWeight = 10}
	}
	self.currentRoundState = 0
	self.preRoundTimer = 2
	self.lastHuntedPlayers = {}
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
		castIntance.forceIntoSquad = true
		castIntance.rotateTeamOnNewRound = false
		castIntance.playerCountNeededToAutoBalance = 100
		castIntance.teamDifferenceToAutoBalance = 100
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

function MMGameMode:RandomizeTeams()
	local players = PlayerManager:GetPlayers()
	local team_select = {} -- list of valid players to pick next hunted
	local team_us = {}
	local team_ru = {}

	for i=1, #players do
		if (#players > 1 and #self.lastHuntedPlayers > 0 and self.lastHuntedPlayers:has(tostring(players[i].guid))) then
			-- don't repick the last players who were the hunted
			table.insert(team_us, players[i])
		else
			table.insert(team_select, players[i])
		end
	end

	self.lastHuntedPlayers = {}
	local numHiddenNeeded = math.floor(#team_select / 5)

	for i=1, numHiddenNeeded do
		local randIndex = MathUtils:GetRandomInt(1, #team_select)
		local huntedPlayer = team_select[randIndex]
		table.insert(self.lastHuntedPlayers, tostring(huntedPlayer.guid))
		table.insert(team_ru, huntedPlayer)
		table.remove(team_select, randIndex)
	end

	for i=1, #team_select do
		table.insert(team_us, team_select[i])
	end

	return team_us, team_ru, {}
end

function getWeightedRandomIndex( tab )
    local sum = 0

    for _, chance in pairs( tab ) do
        sum = sum + chance
    end

    local select = MathUtils:GetRandom(0,1) * sum

    for key, chance in pairs( tab ) do
        select = select - chance
        if select < 0 then return key end
    end
end

return MMGameMode()