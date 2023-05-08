local database = require("database")
local gps = require("gps")
local posUtil = require("posUtil")
local scanner = require("scanner")
local action = require("action")
local config = require("config")
local args = {...}
local targetCrop;

-- ====================== SCANNING ======================

local function isWeed(crop)
    return crop.name == "weed" or 
        crop.name == "Grass" or
        crop.gr > 21 or 
        (crop.name == "venomilia" and crop.gr > 7);
end


local function checkChildren(slot, crop)
    if crop.name == "air" then
        action.placeCropStick(2)

    elseif (not config.assumeNoBareStick) and crop.name == "crop" then
        action.placeCropStick()

    elseif crop.isCrop then
        if isWeed(crop) then
            action.deweed()
            action.placeCropStick()

        elseif crop.name == targetCrop then
            local stat = crop.gr + crop.ga - crop.re
            if stat >= config.autoSpreadThreshold then
                action.transplant(posUtil.farmToGlobal(slot), posUtil.storageToGlobal(database.nextStorageSlot()));
                database.addToStorage(crop)
                action.placeCropStick(2)
            end

        elseif config.keepMutations and (not database.existInStorage(crop)) then
            action.transplant(posUtil.farmToGlobal(slot), posUtil.storageToGlobal(database.nextStorageSlot()))
            action.placeCropStick(2)
            database.addToStorage(crop)
            
        else
            action.deweed()
            action.placeCropStick()
    
        end
    end
end


local function checkParent(slot, crop)
    if crop.isCrop and isWeed(crop) then
        action.deweed();
        database.updateFarm(slot, nil);
    end
end

-- ====================== SPREADING ======================

local function spreadOnce()

    for slot=1, config.farmArea, 1 do

        -- Terminal Condition
        if #database.getStorage() >= 81 then
            return true
        end

        -- Scan
        gps.go(posUtil.farmToGlobal(slot))
        local crop = scanner.scan()

        if (slot % 2 == 0) then
            checkChildren(slot, crop)
        else
            checkParent(slot, crop)
        end

        if action.needCharge() then
            action.charge()
        end
    end
    return false
end

-- ======================== MAIN ========================

local function init()
    database.resetStorage()

    database.scanFarm()
    if config.keepMutations then
        database.scanStorage()
    end

    targetCrop = database.getFarm()[1].name;
    print(string.format('Target crop recognized: %s.', targetCrop))

    action.restockAll();
end


local function main()
    init()

    -- Loop
    while not spreadOnce() do
        gps.go({0, 0})
        action.restockAll();
    end

    -- Finish
    gps.go({0,0})
    if #args == 0 then
        action.cleanup()
        gps.go({0,0})
    end

    gps.turnTo(1)
    print("autoSpread Complete!")
end

main()