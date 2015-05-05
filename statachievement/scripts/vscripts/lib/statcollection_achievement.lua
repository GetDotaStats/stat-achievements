--[[
Usage:

You firstly need to include the module like so:

require('lib.statcollection_achievement')

You can then begin to collect stats like this:

statcollection.addStats({
	modID = 'YourUniqueModID',
	someStat = 'someOtherValue'
})
]]

-- Begin statcollection module
module('statcollection_achievement', package.seeall)

-- Require libs
require( "lib.AchievementManager" )

-- modID
local modID = nil

-- Set mod ID
function setModID( _modID )
	modID = _modID
end


-- Function to grab achievement data
function loadAchievements()
	-- Check if the modID has been set
	if not modID then
		print('ERROR: Please call statcollection_achievement.setModID()!')
		return
	end

	-- This is for Flash to know its steamID
	j = {}
	for i=0,9 do
		j[tostring(i)] = tostring(PlayerResource:GetSteamAccountID(i))
	end
	FireGameEvent("stat_collection_steamID", j)

	-- Tell the user the achievements are being loaded
	print('Loading achievements...')

	-- Load the achievements
	FireGameEvent("stat_ach_load", {
		modID = modID
	})
end


-- Function to send stats
function sendAchievements()
	-- Check if the modID has been set
	if not modID then
		print('ERROR: Please call statcollection_achievement.setModID()!')
		return
	end

	-- Tell the user the achievements are being sent
	print('Sending achievements...')

	-- Send the achievements
	FireGameEvent("stat_ach_send", {
		modID = modID
	} )
end


-- Earn an achievement and update the UI immediately
function earnAchievement( unit, achievementID )
	AchievementManager:EarnAchievement( unit, achievementID )
end

-- Add achievement value
function addAchievementValue( unit, achievementID, valueToAdd )
	AchievementManager:AddValue( unit, achievementID, valueToAdd )
end

-- Set achievement value
function setAchievementValue( unit, achievementID, value )
	AchievementManager:SetValue( unit, achievementID, value )
end
