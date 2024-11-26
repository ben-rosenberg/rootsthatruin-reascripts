local TESTING = false
local QUANTIZE = true

local rPrint = reaper.ShowConsoleMsg
local timeToBeats = reaper.TimeMap2_timeToBeats
local beatsToTime = reaper.TimeMap2_beatsToTime

local function printMult(separator_string, ...)
    local args = {...}
    for i, v in ipairs(args) do
        rPrint(tostring(v) .. separator_string)
    end
end


local abs = math.abs
local floor = math.floor
local ceil = math.ceil

local retval, grid_division = reaper.GetSetProjectGrid(0, false)
grid_division = grid_division * 4

local TTT_ID = 40375
local SPLIT_ID = reaper.NamedCommandLookup("_SWS_AWSPLITXFADELEFT")
local leading_pad = 0.005
local late_hit_leading_pad = 0.005
local retrigger_time = 0.05
local precision = 0.005

local function floorToInc(x, inc)
    return x - x % inc
end

local function roundToInc(x, inc)
    return x % inc < inc / 2
        and x - x % inc
        or x + inc - x % inc
end

local function getNearestGridPosition(tpos_beats)
    return tpos_beats % grid_division < grid_division / 2
        and tpos_beats - tpos_beats % grid_division
        or tpos_beats + grid_division - tpos_beats % grid_division
end

local function getNearestGridPositionTime(tpos)
    local beats, measure = timeToBeats(0, tpos)
    return beatsToTime(0, getNearestGridPosition(beats), measure)
end

local function isCloseEnough(tpos_beats)
    return abs(tpos_beats - getNearestGridPosition(tpos_beats)) <= precision
end

local function isCloseEnoughTime(tpos)
    return abs(tpos - getNearestGridPositionTime(tpos)) <= precision
end

if not TESTING then

local transient_pos = reaper.GetCursorPosition()
local last_pos = transient_pos
local last_loop = transient_pos
local counter = 0

while transient_pos - last_pos < retrigger_time
or isCloseEnoughTime(transient_pos) do
    reaper.Main_OnCommand(TTT_ID, 0)
    transient_pos = reaper.GetCursorPosition()
    if last_loop == transient_pos then break end
    last_loop = transient_pos
    counter = counter + 1
    if counter > 10 then
        rPrint("ERROR: This shit broken.\nBen is bad at programming and you should tell him that\n")
        printMult(" ", "breaking point:", transient_pos, last_pos)
        break
    end
end

local nearest_grid_tpos = getNearestGridPositionTime(transient_pos)
if transient_pos - nearest_grid_tpos > 0 then -- late hit
    reaper.SetEditCurPos(nearest_grid_tpos - late_hit_leading_pad, true, false)
else
    reaper.ApplyNudge(0, 0, 6, 1, leading_pad, true, 0)
end

if QUANTIZE then

reaper.Main_OnCommand(SPLIT_ID, 0)
reaper.ApplyNudge(0, 0, 4, 1, nearest_grid_tpos - transient_pos, false, 0)

end

else -- TESTING


-- local media_item_take = reaper.GetMediaItemTake(reaper.GetSelectedMediaItem(0, 0), 0)
-- reaper.SetMediaItemTakeInfo_Value(media_item_take, "D_STARTOFFS", 1)

reaper.ApplyNudge(0, 0, 4, 1, 1, false, 0)

end