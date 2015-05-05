ACH_TOTAL_DISTANCE_MOVED			= 1
ACH_TOTAL_KILLED_UNITS				= 2
ACH_TOTAL_DAMAGE_DEALT_BY_ATTACK	= 3
ACH_TOTAL_DAMAGE_TAKEN				= 4
ACH_TOTAL_GOLD_GAINED				= 5
ACH_TOTAL_MANA_SPENT				= 6

--------------------------------------------------------------------------------
function OnDealDamage( event )
--	AchievementManager:AddValue( event.caster,  )
end

--------------------------------------------------------------------------------
function OnTakeDamage( event )
	AchievementManager:AddValue( event.caster, ACH_TOTAL_DAMAGE_TAKEN, event.attack_damage )
end

--------------------------------------------------------------------------------
function OnAttackLanded( event )
	AchievementManager:AddValue( event.caster, ACH_TOTAL_DAMAGE_DEALT_BY_ATTACK, event.attack_damage )
end

--------------------------------------------------------------------------------
function OnKill( event )
	-- Increment the value
	AchievementManager:AddValue( event.caster, ACH_TOTAL_KILLED_UNITS, 1 )
end

--------------------------------------------------------------------------------
function OnManaGained( event )
	local unit = event.caster
	unit.ach_lastMana = unit:GetMana()
end

--------------------------------------------------------------------------------
function OnSpentMana( event )
	local unit = event.caster

	-- Calculate spent mana
	if unit.ach_lastMana then
		local manaSpent = unit.ach_lastMana - unit:GetMana()
		if manaSpent > 0 then
			AchievementManager:AddValue( unit, ACH_TOTAL_MANA_SPENT, manaSpent )
		end
	end

	unit.ach_lastMana = unit:GetMana()
end

--------------------------------------------------------------------------------
-- Calculate distance unit moved.
--------------------------------------------------------------------------------
function OnUnitMoved( event )
	local unit = event.caster
	local unitOrigin = unit:GetAbsOrigin()

	local baseMoveSpeed	= unit:GetBaseMoveSpeed()
	local moveSpeed		= unit:GetMoveSpeedModifier( baseMoveSpeed )
	--print( "BASE = " .. moveSpeed .. ", MOD = " .. moveSpeedMod )

	local tickInterval = 1.0 / 30.0
	local maxDistancePerTick = ( moveSpeed + 1 ) * tickInterval
	--print( "Max distance to accum = " .. maxDistancePerTick )

	if unit.ach_lastPos then
		-- Calculate distance moved
		local distance = ( unitOrigin - unit.ach_lastPos ):Length2D()
		--print( "[ACH/OnUnitMoved] distance = " .. distance .. ", max = " .. maxDistancePerTick )

		distance = math.min( distance, maxDistancePerTick )

		-- Accumulate distance
		AchievementManager:AddValue( unit, ACH_TOTAL_DISTANCE_MOVED, distance )
	end

	unit.ach_lastPos = unitOrigin
end

--------------------------------------------------------------------------------
-- Calculate gold gained.
--------------------------------------------------------------------------------
function OnIntervalThink( event )
	local unit = event.caster

	-- Store some states
	unit.ach_lastMana = unit:GetMana()

	-- Gold gained
	if unit.ach_lastGold then
		local goldGained = unit:GetGold() - unit.ach_lastGold
		if goldGained > 0 then
			AchievementManager:AddValue( unit, ACH_TOTAL_GOLD_GAINED, goldGained )
		end
	end
	unit.ach_lastGold = unit:GetGold()
end