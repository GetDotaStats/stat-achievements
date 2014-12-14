GetDotaStats Stat-Achievements
=====

###About###
 - This repo allows mods to have achievement data. It would be most useful for RPGs.

# GetDotaStats - StatCollectionAchievements specs 1.0 #

## Client --> Server ##

#### SAVE ####
|Field Name|Field DataType|Field Description
|----------|--------------|-----------------
|type      |String        |Always "SAVE", as that's this packet
|modID     |String        |The modID allocated by GetDotaStats
|steamID   |Long          |The SteamID of the owner of this save.
|achievementID |Integer       |The unique ID for this achievement, as was set via the site.
|achievedValue  |Integer          |The data for this achievement. Can be in the form of a tinyint(for bools) or an integer.

#### LIST ####
|Field Name|Field DataType|Field Description
|----------|--------------|-----------------
|type      |String        |Always "LIST", as that's this packet
|modID     |String        |The modID allocated by GetDotaStats
|steamID   |Long          |The SteamID of the owner of this save.

## Server --> Client ##

#### success ####
|Field Name|Field DataType|Field Description
|----------|--------------|-----------------
|type      |String        |Always "success", as that's this packet

#### failure ####
|Field Name|Field DataType|Field Description
|----------|--------------|-----------------
|type      |String        |Always "failure", as that's this packet
|error     |String        |A string describing the error. Only useful for debugging purposes

#### list (10 most recent for now) ####
|Field Name|Field DataType|Field Description
|----------|--------------|-----------------
|type      |String        |Always "list", as that's this packet
|jsonData  |Array of JSON |Contains an array of all the achievement metadata.
