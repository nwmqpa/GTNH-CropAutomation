local gps = require('gps')
local posUtil = require('posUtil')
local scanner = require('scanner')
local config = require('config')
local notifications = require('notifications')
local storage = {}
local reverseStorage = {}
local farm = {}

-- ======================== WORKING FARM ========================

local function getFarm()
    return farm
end

local function resetFarm()
    farm = {}
end

local function updateFarm(slot, crop)
    farm[slot] = crop
end


local function scanFarm()
    for slot=1, config.workingFarmArea, 2 do
        gps.go(posUtil.workingSlotToPos(slot))
        local crop = scanner.scan()
            farm[slot] = crop
    end
end

local function scanAllFarm()
    for slot=1, config.workingFarmArea do
        gps.go(posUtil.workingSlotToPos(slot))
        local crop = scanner.scan()
        farm[slot] = crop
    end
end

local function findNextFilledFarmSlot()
    for slot=1, config.workingFarmArea, 1 do
        crop = farm[slot]
        if crop.name ~= "air" then
            return slot
        end
    end
    return -1
end

-- ======================== STORAGE FARM ========================

local function getStorage()
    return storage
end


local function resetStorage()
    storage = {}
end

local function updateStorage(slot, crop)
    storage[slot] = crop
end

local function addToStorage(crop)
    storage[#storage+1] = crop
    reverseStorage[crop.name] = #storage

    notifications.sendNotification("New crop discovered", "Discovered crop: " .. crop.name)
end


local function existInStorage(crop)
    if reverseStorage[crop.name] then
        return true
    else
        return false
    end
end


local function nextStorageSlot()
    return #storage + 1
end

local function scanStorage()
    for slot=1, config.storageFarmArea, 1 do
        gps.go(posUtil.storageSlotToPos(slot))
        local crop = scanner.scan()
        storage[slot] = crop
    end
end

local function findNextEmptyStorageSlot()
    for slot=1, config.storageFarmArea, 1 do
        crop = storage[slot]
        if crop.name == "air" then
            return slot
        end
    end
    return -1
end

return {
    getFarm = getFarm,
    updateFarm = updateFarm,
    scanFarm = scanFarm,
    getStorage = getStorage,
    resetStorage = resetStorage,
    addToStorage = addToStorage,
    existInStorage = existInStorage,
    nextStorageSlot = nextStorageSlot,
    scanAllFarm = scanAllFarm,
    scanStorage = scanStorage,
    findNextFilledFarmSlot = findNextFilledFarmSlot,
    findNextEmptyStorageSlot = findNextEmptyStorageSlot,
    resetFarm = resetFarm,
    updateStorage = updateStorage
}
