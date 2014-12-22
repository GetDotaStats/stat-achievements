GetDotaStats Stat-Achievements
=====

###About###
 - This repo allows mods to have achievement data. It would be most useful for RPGs.

# GetDotaStats - StatCollectionAchievements specs 1.0 #

## Client --> Server ##

#### LIST ####
|Field Name|Field DataType|Field Description
|----------|--------------|-----------------
|type      |String        |Always "LIST", as that's this packet
|modID     |String        |The modID allocated by GetDotaStats
|steamID   |Long          |The SteamID of the owner of this save.

#### SAVE ####
|Field Name     |Field DataType  |Field Description
|---------------|----------------|-----------------
|type           |String          |Always "SAVE", as that's this packet
|modID          |String          |The modID allocated by GetDotaStats
|steamID        |Long            |The SteamID of the owner of this save.
|achievementID  |Integer         |The achievement that got progress
|achievmentValue|Integer |This will be the value of the achievement. (0,1) for booleans and the rest as integers.

## Server --> Client ##

#### success ####
  - This is used for SAVE only

|Field Name|Field DataType|Field Description
|----------|--------------|-----------------
|type      |String        |Always "success", as that's this packet

#### failure ####
- This is used for SAVE only

|Field Name|Field DataType|Field Description
|----------|--------------|-----------------
|type      |String        |Always "failure", as that's this packet
|error     |String        |A string describing the error. Only useful for debugging purposes

#### list ####
|Field Name|Field DataType |Field Description
|----------|---------------|-----------------
|type      |String         |Always "list", as that's this packet
|jsonData  |AchievementInfo|Contains an array of all the achievement metadata.

## AchievementInfo
This will be a JSON array of the following  

|FieldName     |Field Datatype|Field Description
|--------------|--------------|-----------------
|achievementID  |Integer         |The achievement that got progress
|hidden        |TinyInt (0,1)       |This will tell flash if this achievement should be shown in menus when locked
|type          |String        |This defines what kind of achievement it is. As of 1.0, this will be "Count" or "Event"
|acquired |TinyInt (0,1)       |Does the user have this achievement? (only appears for Event as of 1.0)
|count_current |Integer       |How much progress does the user have (if complete, it will just be same as max)
|count_max     |Integer       |What is the max progress of this achievement (used for rendering progress bars)

As an example,  
``` json
[
    {
        "achievementID" : 0,
        "hidden" : 0,
        "type" : "Event",
        "count_current" : 1,
        "count_max" : 1,
        "acquired" : 1
    },
    {
        "achievementID" : 1,
        "hidden" : 1,
        "type" : "Count",
        "count_current" : 57,
        "count_max" : 378,
        "acquired" : 0
    }
]
```
In this example, it will have the following localization
```
"ACHIEVEMENT_0_NAME"        "F in Chemistry"
"ACHIEVEMENT_0_DESCRIPTION" "On day 1 of the Rat job, blow up the lab."

"ACHIEVEMENT_1_NAME"        "License to Kill"
"ACHIEVEMENT_1_DESCRIPTION" "Kill 378 enemies using the Gruber Kurz handgun."
```
And for each achievement it'll have two images:  
* `resource/flash3/images/achievements/0_on.png`
* `resource/flash3/images/achievements/0_off.png`  
where 0 is the achievement ID

## Ports ##

* Test: 4448
* Live: 4449
