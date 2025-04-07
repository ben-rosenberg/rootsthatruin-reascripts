local timeToBeats = reaper.TimeMap2_timeToBeats
local beatsToTime = reaper.TimeMap2_beatsToTime

local abs = math.abs

local retval, grid_division = reaper.GetSetProjectGrid(0, false)
grid_division = grid_division * 4

local TTT_ID = 40375
local SPLIT_ID = reaper.NamedCommandLookup("_SWS_AWSPLITXFADELEFT")
SPLIT_ID = SPLIT_ID == 0 and 40759 or SPLIT_ID
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

local function isCloseEnoughTime(tpos)
    return abs(tpos - getNearestGridPositionTime(tpos)) <= precision
end

local cursor_pos = reaper.GetCursorPosition()
local transient_pos = cursor_pos
local last_transient_pos = cursor_pos
local last_pos = transient_pos
local last_loop = transient_pos
local loop_counter = 0
local MAX_LOOPS_BEFORE_BREAK = 50

-- TODO refactor into do... while loop
--[[ repeat
    
until (transient_pos - last_pos > retrigger_time and not isCloseEnoughTime(transient_pos)) ]]

while transient_pos - last_pos < retrigger_time
or transient_pos - last_transient_pos < retrigger_time
or isCloseEnoughTime(transient_pos) do
    last_transient_pos = transient_pos
    reaper.Main_OnCommand(TTT_ID, 0)
    transient_pos = reaper.GetCursorPosition()

    if last_loop == transient_pos then break end
    last_loop = transient_pos


    loop_counter = loop_counter + 1
    if loop_counter > MAX_LOOPS_BEFORE_BREAK then
        break
    end
end

local nearest_grid_tpos = getNearestGridPositionTime(transient_pos)

if transient_pos - nearest_grid_tpos > 0 then -- late hit
    reaper.SetEditCurPos(nearest_grid_tpos - late_hit_leading_pad, true, false)
else -- early hit
    reaper.ApplyNudge(0, 0, 6, 1, leading_pad, true, 0)
end

reaper.Main_OnCommand(SPLIT_ID, 0)
reaper.ApplyNudge(0, 0, 4, 1, nearest_grid_tpos - transient_pos, false, 0) -- quantize
