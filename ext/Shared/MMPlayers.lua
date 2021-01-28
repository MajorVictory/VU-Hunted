class "MMPlayers"

function MMPlayers:__init()
	Events:Subscribe('Level:Loaded', self, self.onLevelLoaded)
	Events:Subscribe('Level:Destroy', self, self.onLevelDestroy)
	
	-- negate damage from hitting stuff because 2FAST
	Hooks:Install('Soldier:Damage', 1, function(hook, soldier, info, giverInfo)

		-- no collision damage or 'Count' damage for 'RU' team
		if soldier ~= nil and soldier.player ~= nil and soldier.player.teamId == TeamId.Team2 then

			if giverInfo.damageType == 4 or giverInfo.damageType == 6 then
				info.damage = 0
				hook:Return()
			end
	  	end

	  	hook:Pass(soldier, info, giverInfo)
	end)
end

function MMPlayers:Write(instance)

	if (mmResources:IsLoaded('mpsoldier') and mmResources:IsLoaded('mpsoldierphysics')) then
		mmResources:SetLoaded('mpsoldier', false)
		mmResources:SetLoaded('mpsoldierphysics', false)

		local customPhys = createSoldierPhysics(mmResources:GetInstance('mpsoldierphysics'))
		local customPhysPartition = mmResources:GetPartition('mpsoldierphysics')
		customPhysPartition:AddInstance(customPhys)
		mmResources:SetLoaded('huntedsoldierphysics', true)

		local customSoldier = creatSoldierBP(mmResources:GetInstance('mpsoldier'), customPhys)
		local customSoldierPartition = mmResources:GetPartition('mpsoldier')
		customSoldierPartition:AddInstance(customSoldier)
		mmResources:SetLoaded('huntedsoldier', true)
		mmPlayers:Write(instance)

	end

	if (mmResources:IsLoaded('huntedsoldier')) then
		local teams = {'team_ru', 'team_ru_gm', 'team_ru_gm_xp4', 'team_ru_large', 'team_ru_xp4', 'team_ru_xp4_scv'}
		for team=1, #teams do
			if (mmResources:IsLoaded(teams[team])) then
				mmResources:SetLoaded(teams[team], false)

				local teamData = TeamData(mmResources:GetInstance(teams[team]))
				teamData:MakeWritable()
				teamData.soldier = SoldierBlueprint(mmResources:GetInstance('huntedsoldier'))
				print('Changed Team Soldier Blueprint: '..teamData.name)
			end
		end
	end

	-- chat lag spike fix
	if (mmResources:IsLoaded('chat')) then
		mmResources:SetLoaded('chat', false)
		local chat = UIMessageCompData(mmResources:GetInstance('chat'))
		chat:MakeWritable()
		MessageInfo(chat.chatMessageInfo).messageQueueSize = 20
	end

	if (mmResources:IsLoaded('yump')) then
		mmResources:SetLoaded('yump', false)

		local playerYump = JumpStateData(mmResources:GetInstance('yump'))
		playerYump:MakeWritable()
		playerYump.jumpHeight = 2
		playerYump.jumpEffectSize = 1
		print('Changed Player Jump...')
	end

	if (mmResources:IsLoaded('pose_stand') and
		mmResources:IsLoaded('pose_standair') and
		mmResources:IsLoaded('pose_swimming') and
		mmResources:IsLoaded('pose_climbing') and
		mmResources:IsLoaded('pose_chute')) then

		mmResources:SetLoaded('pose_stand', false)
		mmResources:SetLoaded('pose_standair', false)
		mmResources:SetLoaded('pose_swimming', false)
		mmResources:SetLoaded('pose_climbing', false)
		mmResources:SetLoaded('pose_chute', false)

		local poseStand = CharacterStatePoseInfo(mmResources:GetInstance('pose_stand'))
		poseStand:MakeWritable()
		poseStand.velocity = 3
		poseStand.sprintMultiplier = 2
		print('Changed Player Stand Pose...')

		local poseStandAir = CharacterStatePoseInfo(mmResources:GetInstance('pose_standair'))
		poseStandAir:MakeWritable()
		poseStandAir.velocity = 3
		poseStandAir.sprintMultiplier = 2
		print('Changed Player Stand Air Pose...')

		local poseSwim = CharacterStatePoseInfo(mmResources:GetInstance('pose_swimming'))
		poseSwim:MakeWritable()
		poseSwim.velocity = 3
		print('Changed Player Swim Pose...')

		local poseClimb = CharacterStatePoseInfo(mmResources:GetInstance('pose_climbing'))
		poseClimb:MakeWritable()
		poseClimb.velocity = 3
		poseClimb.sprintMultiplier = 2
		print('Changed Player Climb Pose...')

		local poseClimb = CharacterStatePoseInfo(mmResources:GetInstance('pose_chute'))
		poseClimb:MakeWritable()
		poseClimb.velocity = 3
		print('Changed Player Parachute Pose...')
	end
end

function MMPlayers:onLevelLoaded(levelName, gameMode)

	local kitSetups = {
		US = {
			Assault = {
				ID_M_SOLDIER_PRIMARY = {
					'Weapons/M416/U_M416',
					'Weapons/AEK971/U_AEK971',
					'Weapons/SKS/U_SKS',
					'Weapons/MK11/U_MK11',
					'Weapons/SG553LB/U_SG553LB',
					'Weapons/SCAR-H/U_SCAR-H',
					'Weapons/XP1_FAMAS/U_FAMAS'
				},
				ID_M_SOLDIER_SECONDARY = {
					'Weapons/MP443/U_MP443_TacticalLight',
					'Weapons/M9/U_M9_TacticalLight',
					'Weapons/M1911/U_M1911_Tactical',
					'Weapons/Taurus44/U_Taurus44',
					'Weapons/MP412Rex/U_MP412Rex'
				},
				ID_M_SOLDIER_GADGET1 = {},
				ID_WEAPON_CATEGORYGADGET1 = {
					'Weapons/Gadgets/Medicbag/U_Medkit',
					'Weapons/Gadgets/Ammobag/U_Ammobag'
				},
				ID_M_SOLDIER_GADGET2 = {
					'Weapons/Gadgets/M320/U_M320_SMK'
				},
				GRENADE = {
					'Weapons/M67/U_M67'
				},
				KNIFE = {},
			},
			Engineer = {
				ID_M_SOLDIER_PRIMARY = {
					'Weapons/M416/U_M416',
					'Weapons/AEK971/U_AEK971',
					'Weapons/SKS/U_SKS',
					'Weapons/Remington870/U_870',
					'Weapons/M1014/U_M1014',
					'Weapons/USAS-12/U_USAS-12',
					'Weapons/XP2_SPAS12/U_SPAS12'
				},
				ID_M_SOLDIER_SECONDARY = {
					'Weapons/MP443/U_MP443_TacticalLight',
					'Weapons/M9/U_M9_TacticalLight',
					'Weapons/M1911/U_M1911_Tactical',
					'Weapons/Taurus44/U_Taurus44',
					'Weapons/MP412Rex/U_MP412Rex'
				},
				ID_M_SOLDIER_GADGET1 = {},
				ID_WEAPON_CATEGORYGADGET1 = {
					'Weapons/Gadgets/Medicbag/U_Medkit',
					'Weapons/Gadgets/Ammobag/U_Ammobag'
				},
				ID_M_SOLDIER_GADGET2 = {
					'Weapons/Gadgets/C4/U_C4'
				},
				GRENADE = {
					'Weapons/M67/U_M67'
				},
				KNIFE = {},
			},
			Recon = {
				ID_M_SOLDIER_PRIMARY = {
					'Weapons/M416/U_M416',
					'Weapons/AEK971/U_AEK971',
					'Weapons/SKS/U_SKS',
					'Weapons/P90/U_P90',
					'Weapons/XP2_MP5K/U_MP5K',
					'Weapons/MK11/U_MK11',
					'Weapons/SVD/U_SVD_US'
				},
				ID_M_SOLDIER_SECONDARY = {
					'Weapons/MP443/U_MP443_TacticalLight',
					'Weapons/M9/U_M9_TacticalLight',
					'Weapons/M1911/U_M1911_Tactical',
					'Weapons/Taurus44/U_Taurus44',
					'Weapons/MP412Rex/U_MP412Rex'
				},
				ID_M_SOLDIER_GADGET1 = {},
				ID_WEAPON_CATEGORYGADGET1 = {
					'Weapons/Gadgets/Medicbag/U_Medkit',
					'Weapons/Gadgets/Ammobag/U_Ammobag'
				},
				ID_M_SOLDIER_GADGET2 = {
					'Weapons/Gadgets/T-UGS/U_UGS'
				},
				GRENADE = {
					'Weapons/M67/U_M67'
				},
				KNIFE = {},
			},
			Support = {
				ID_M_SOLDIER_PRIMARY = {
					'Weapons/M416/U_M416',
					'Weapons/AEK971/U_AEK971',
					'Weapons/SKS/U_SKS',
					'Weapons/M249/U_M249',
					'Weapons/M60/U_M60',
					'Weapons/Type88/U_Type88',
					'Weapons/Pecheneg/U_Pecheneg'
				},
				ID_M_SOLDIER_SECONDARY = {
					'Weapons/MP443/U_MP443_TacticalLight',
					'Weapons/M9/U_M9_TacticalLight',
					'Weapons/M1911/U_M1911_Tactical',
					'Weapons/Taurus44/U_Taurus44',
					'Weapons/MP412Rex/U_MP412Rex'
				},
				ID_M_SOLDIER_GADGET1 = {},
				ID_WEAPON_CATEGORYGADGET1 = {
					'Weapons/Gadgets/Medicbag/U_Medkit',
					'Weapons/Gadgets/Ammobag/U_Ammobag'
				},
				ID_M_SOLDIER_GADGET2 = {
					'Weapons/Gadgets/Claymore/U_Claymore'
				},
				GRENADE = {
					'Weapons/M67/U_M67'
				},
				KNIFE = {},
			}
		},
		RU = {
			Assault = {
				ID_M_SOLDIER_PRIMARY = { },
				ID_M_SOLDIER_SECONDARY = {
					'Weapons/M1911/U_M1911_Silenced'
				},
				ID_M_SOLDIER_GADGET1 = {},
				ID_WEAPON_CATEGORYGADGET1 = {},
				ID_M_SOLDIER_GADGET2 = {
					'Weapons/Gadgets/M320/U_M320_SMK'
				},
				GRENADE = {
					'Weapons/M67/U_M67'
				},
				KNIFE = {
					'Weapons/XP2_Knife_RazorBlade/U_Knife_Razor',
					'Weapons/Knife/U_Knife'
				}
			},
			Engineer = {
				ID_M_SOLDIER_PRIMARY = { },
				ID_M_SOLDIER_SECONDARY = {
					'Weapons/M1911/U_M1911_Silenced'
				},
				ID_M_SOLDIER_GADGET1 = {},
				ID_WEAPON_CATEGORYGADGET1 = {},
				ID_M_SOLDIER_GADGET2 = {
					'Weapons/Gadgets/M320/U_M320_SMK'
				},
				GRENADE = {
					'Weapons/M67/U_M67'
				},
				KNIFE = {
					'Weapons/XP2_Knife_RazorBlade/U_Knife_Razor',
					'Weapons/Knife/U_Knife'
				}
			},
			Recon = {
				ID_M_SOLDIER_PRIMARY = { },
				ID_M_SOLDIER_SECONDARY = {
					'Weapons/M1911/U_M1911_Silenced'
				},
				ID_M_SOLDIER_GADGET1 = {},
				ID_WEAPON_CATEGORYGADGET1 = {},
				ID_M_SOLDIER_GADGET2 = {
					'Weapons/Gadgets/M320/U_M320_SMK'
				},
				GRENADE = {
					'Weapons/M67/U_M67'
				},
				KNIFE = {
					'Weapons/XP2_Knife_RazorBlade/U_Knife_Razor',
					'Weapons/Knife/U_Knife'
				}
			},
			Support = {
				ID_M_SOLDIER_PRIMARY = { },
				ID_M_SOLDIER_SECONDARY = {
					'Weapons/M1911/U_M1911_Silenced'
				},
				ID_M_SOLDIER_GADGET1 = {},
				ID_WEAPON_CATEGORYGADGET1 = {},
				ID_M_SOLDIER_GADGET2 = {
					'Weapons/Gadgets/M320/U_M320_SMK'
				},
				GRENADE = {
					'Weapons/M67/U_M67'
				},
				KNIFE = {
					'Weapons/XP2_Knife_RazorBlade/U_Knife_Razor',
					'Weapons/Knife/U_Knife'
				}
			},
		}
	}

	for teamName, team in pairs(kitSetups) do
		for kitName, kit in pairs(team) do
			if (kitName ~= '*') then
				local kitData = self:findKit(teamName, kitName, true)
				for i=1, #kitData do

					local unlockCategories = ebxEditUtils:GetWritableContainer(kitData[i], 'WeaponTable')
					local specialsDone = false
					local newUnlockCategories = {}

					for categoryId, weapons in pairs(kit) do

						local unlockCategory = CustomizationUnlockParts()
						unlockCategory.uiCategorySid = categoryId

						for weapon=1, #weapons do
							unlockCategory.selectableUnlocks:add(ebxEditUtils:GetWritableInstance(weapons[weapon]))
							print('Adding ['..tostring(unlockCategory.uiCategorySid)..']: '..weapons[weapon])
						end

						if (categoryId == '') then
							specialsDone = true
						end
						newUnlockCategories[categoryId] = unlockCategory
					end

					unlockCategories.unlockParts:clear()
					unlockCategories.unlockParts:add(newUnlockCategories['ID_M_SOLDIER_PRIMARY'])
					unlockCategories.unlockParts:add(newUnlockCategories['ID_M_SOLDIER_SECONDARY'])
					unlockCategories.unlockParts:add(newUnlockCategories['ID_M_SOLDIER_GADGET1'])
					unlockCategories.unlockParts:add(CustomizationUnlockParts())
					unlockCategories.unlockParts:add(newUnlockCategories['ID_WEAPON_CATEGORYGADGET1'])
					unlockCategories.unlockParts:add(newUnlockCategories['ID_M_SOLDIER_GADGET2'])
					unlockCategories.unlockParts:add(newUnlockCategories['GRENADE'])
					unlockCategories.unlockParts:add(newUnlockCategories['KNIFE'])

					print('Changed Kit: '..teamName..' - '..kitName)
				end
			end
		end
	end
end

function MMPlayers:onLevelDestroy()
	mmResources:SetLoaded('huntedsoldier', false)
end

-- Tries to find first available kit
-- @param teamName string Values: 'US', 'RU'
-- @param kitName string Values: 'Assault', 'Engineer', 'Support', 'Recon'
-- @param returnAll boolean returns all matches
function MMPlayers:findKit(teamName, kitName, returnAll)

    local gameModeKits = {
        '', -- Standard
        '_GM', --Gun Master on XP2 Maps
        '_GM_XP4', -- Gun Master on XP4 Maps
        '_XP4', -- Copy of Standard for XP4 Maps
        '_XP4_SCV' -- Scavenger on XP4 Maps
    }

    local matches = {}

    for kitType=1, #gameModeKits do
        local properKitName = string.lower(kitName)
        properKitName = properKitName:gsub("%a", string.upper, 1)

        local fullKitName = string.upper(teamName)..properKitName..gameModeKits[kitType]
        local kit = ResourceManager:SearchForDataContainer('Gameplay/Kits/'..fullKitName)
        if kit ~= nil  then
        	print('Found Kit: '..fullKitName)
            table.insert(matches, kit)
            if (not returnAll) then
        		return kit
        	end
        end
    end

    return matches
end

return MMPlayers()