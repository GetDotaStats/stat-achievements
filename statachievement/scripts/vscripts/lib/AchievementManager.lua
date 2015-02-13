
local UPDATE_INTERVAL = 1.0

--------------------------------------------------------------------------------
if AchievementManager == nil then
	AchievementManager = class({})
end

--------------------------------------------------------------------------------
function AchievementManager:start()
	-- Pending changes
	self.vPlayerIDToValueMap			= {}
	self.vPlayerIDToPendingChangeList	= {}

	-- Create think
	self.thinkEnt = Entities:CreateByClassname( "info_target" )

	self.thinkEnt:SetContextThink( "SendPendingChanges", function ()
		self:SendPendingChanges()
		return UPDATE_INTERVAL
	end, UPDATE_INTERVAL )
end

--------------------------------------------------------------------------------
function AchievementManager:EarnAchievement( unit, achievementID )
	local valueMap = self:GetValueMapFor( unit )
	valueMap[achievementID] = 1

	-- Send the update to AS3 immediately
	FireGameEvent( "stat_ach_update_value", {
		playerID = unit:GetPlayerID(),
		achievementID = achievementID,
		value = valueMap[achievementID],
	} )
end

--------------------------------------------------------------------------------
function AchievementManager:GetValue( unit, achievementID )
	local valueMap = self:GetValueMapFor( unit )
	return valueMap[achievementID] or 0
end

--------------------------------------------------------------------------------
function AchievementManager:AddValue( unit, achievementID, value )
	local valueMap = self:GetValueMapFor( unit )
	local changeList = self:GetPendingChangeListFor( unit )
	valueMap[achievementID] = ( valueMap[achievementID] or 0 ) + value
	changeList[achievementID] = valueMap[achievementID]
end

--------------------------------------------------------------------------------
function AchievementManager:SetValue( unit, achievementID, value )
	local valueMap = self:GetValueMapFor( unit )
	local changeList = self:GetPendingChangeListFor( unit )
	valueMap[achievementID] = value
	changeList[achievementID] = valueMap[achievementID]
end

--------------------------------------------------------------------------------
function AchievementManager:GetValueMapFor( unit )
	local playerID = unit:GetPlayerID()
	local valueMap = self.vPlayerIDToValueMap[playerID]
	if not valueMap then
		valueMap = {}
		self.vPlayerIDToValueMap[playerID] = valueMap
	end
	return valueMap
end

--------------------------------------------------------------------------------
function AchievementManager:GetPendingChangeListFor( unit )
	local playerID = unit:GetPlayerID()
	local changeList = self.vPlayerIDToPendingChangeList[playerID]
	if not changeList then
		changeList = {}
		self.vPlayerIDToPendingChangeList[playerID] = changeList
	end
	return changeList
end

--------------------------------------------------------------------------------
function AchievementManager:SendPendingChanges()
	local debug_numChangesSent = 0

	for playerID, changeList in pairs( self.vPlayerIDToPendingChangeList ) do
		for achievementID, value in pairs( changeList ) do
			FireGameEvent( "stat_ach_update_value", {
				playerID = playerID,
				achievementID = achievementID,
				value = value,
			} )

			debug_numChangesSent = debug_numChangesSent + 1
		end
	end

	--print( "[ACH-Manager/Update] " .. debug_numChangesSent .. " changes sent." )

	-- Clear the pending changes
	self.vPlayerIDToPendingChangeList = {}

	return UPDATE_INTERVAL
end

--------------------------------------------------------------------------------
AchievementManager:start()
