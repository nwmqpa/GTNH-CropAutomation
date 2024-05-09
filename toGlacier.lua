local database = require("database")
local action = require("action")
local posUtil = require("posUtil")

local function init()
    database.resetStorage()
    database.resetGlacier()

    database.scanStorage()
    action.charge()
    database.scanGlacier()
    action.charge()
end

local function main()
    init()

    local storageSlot = database.findNextFilledStorageSlot()
    while storageSlot ~= -1 do
        local glacierSlot = database.findNextEmptyGlacierSlot()
        
        if glacierSlot == -1 then
            print('toGlacier: No empty storage slot')
            return
        end

        -- Move plants to glacier
        action.movePlantToGlacier(
            posUtil.storageSlotToPos(storageSlot),
            posUtil.glacierSlotToPos(glacierSlot)
        )

        -- Return to charger
        action.charge()

        -- Update database
        database.updateGlacier(glacierSlot, database.getStorage()[storageSlot])
        database.updateStorage(storageSlot, { isCrop = true, name = "air" })

        -- Find next plant to transplant
        workingSlot = database.findNextFilledStorageSlot()
    end

    print('toGlacier: Complete!')
end

main()