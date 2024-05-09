local config = require('config')

-- ======================== WORKING FARM ========================
--  _________________
-- |31 30 19 18 07 06|  6x6 Slot Map
-- |32 29 20 17 08 05|
-- |33 28 21 16 09 04|  One down from 01 is (0,0)
-- |34 27 22 15 10 03|
-- |35 26 23 14 11 02|
-- |36 25 24 13 12 01|
--  ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

local function workingSlotToPos(slot)
    local x = (slot - 1) // config.workingFarmSize
    local row = (slot - 1) % config.workingFarmSize
    local y

    if x % 2 == 0 then
        y = row + 1
    else
        y = -row + config.workingFarmSize
    end

    return {-x, y}
end

-- ======================== STORAGE FARM ========================
--  __________________________
-- |09 10 27 28 45 46 63 64 81|  9x9 Slot Map
-- |08 11 26 29 44 47 62 65 80|
-- |07 12 25 30 43 48 61 66 79|  Two left from 03 is (0,0)
-- |06 13 24 31 42 49 60 67 78|
-- |05 14 23 32 41 50 59 68 77|
-- |04 15 22 33 40 51 58 69 76|
-- |03 16 21 34 39 52 57 70 75|
-- |02 17 20 35 38 53 56 71 74|
-- |01 18 19 36 37 54 55 72 73|
--  ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

local function storageSlotToPos(slot)
    local x = (slot - 1) // config.storageFarmSize + 2
    local row = (slot - 1) % config.storageFarmSize
    local y

    if x % 2 == 0 then
        y = row - config.storageFarmSize + config.workingFarmSize + 1
    else
        y = -row + config.workingFarmSize
    end

    return {x, y}
end

-- Return coordinates in the system
--  _________
-- |02 12 22|  3x3 slot map
-- |01 11 21|  for maxSide = 3
-- |00 10 20|  (with slot = 0 returning {0, 0})
-- ‾‾‾‾‾‾‾‾‾

local function slotToIJ(slot, maxSide)
    local i = slot % maxSide
    local j = slot // maxSide

    return {i, j}
end


-- Return coordinates in the system (with zigzaging)
--  _________
-- |02 10 22|  3x3 slot map
-- |01 11 21|  for maxSide = 3
-- |00 12 20|  (with slot = 0 returning {0, 0})
-- ‾‾‾‾‾‾‾‾‾

local function slotToIJMorton(slot, maxSide)
    local ij = slotToIJ(slot, maxSide)

    if ij[2] % 2 == 0 then
        return ij
    else
        return {-ij[1] + maxSide - 1, ij[2]}
    end
end

-- ======================== Glacier FARM ========================
--  __________________________
-- |09 10 27 28 45 46 63 64 81|  9x9 Slot Map
-- |08 11 26 29 44 47 62 65 80|
-- |07 12 25 30 43 48 61 66 79|  One down from 18 is config.glacierDislocatorPos
-- |06 13 24 31 42 49 60 67 78|
-- |05 14 23 32 41 50 59 68 77|
-- |04 15 22 33 40 51 58 69 76|
-- |03 16 21 34 39 52 57 70 75|
-- |02 17 20 35 38 53 56 71 74|
-- |01 18 19 36 37 54 55 72 73|
--  ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
local function glacierSlotToPos(slot)
    local ij = slotToIJMorton(slot - 1, config.glacierFarmSize)

    local x = ij[1] + config.glacierDislocatorPos - 1
    local y = ij[2] + config.glacierDislocatorPos + 1

    return {x, y}
end


return {
    workingSlotToPos = workingSlotToPos,
    storageSlotToPos = storageSlotToPos,
    glacierSlotToPos = glacierSlotToPos
}
