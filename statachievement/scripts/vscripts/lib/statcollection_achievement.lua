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
34
-- Begin statcollection module
module('statcollection_achievement', package.seeall)


-- This is for Flash to know its steamID
j = {}
for i=0,9 do
	j[tostring(i)] = PlayerResource:GetSteamAccountID(i)
end
FireGameEvent("stat_collection_steamID", j)

