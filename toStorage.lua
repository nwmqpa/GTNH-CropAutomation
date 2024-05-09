local database = require("database")
local action = require("action")
local posUtil = require("posUtil")

local function init()
    database.resetFarm()
    database.resetStorage()

    database.scanAllFarm()
    action.charge()
    database.scanStorage()
    action.charge()
end

local function main()
    init()

    local workingSlot = database.findNextFilledFarmSlot()
    while workingSlot ~= -1 do
        local storageSlot = database.findNextEmptyStorageSlot()
        
        if storageSlot == -1 then
            print('toStorage: No empty storage slot')
            return
        end

        -- Move plants to storage
        action.movePlant(
            posUtil.workingSlotToPos(workingSlot),
            posUtil.storageSlotToPos(storageSlot)
        )

        -- Return to charger
        action.charge()

        -- Update database
        database.updateStorage(storageSlot, database.getFarm()[workingSlot])
        database.updateFarm(workingSlot, { isCrop = true, name = "air" })

        -- Find next plant to transplant
        workingSlot = database.findNextFilledFarmSlot()
    end

    print('toStorage: Complete!')
end

main()