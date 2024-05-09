local database = require("database")
local action = require("action")
local posUtil = require("posUtil")

local args = {...}

local function init()
    database.resetFarm()
    database.resetStorage()
    database.resetGlacier()

    database.scanAllFarm()
    action.charge()
    database.scanStorage()
    action.charge()
    database.scanGlacier()
    action.charge()
end

local function main()
    if #args >= 1 then
        crop = args[1]
    else
        print("No crop specified. Aborting")
        return
    end

    init()

    allCrops = database.findAllCrop(crop)

    if #allCrops == 0 then
        print("No crops found. Aborting")
        return
    end

    startingCrop = database.getFarm()[1].name

    if startingCrop ~= crop and startingCrop ~= "air" then
        print("Starting crop is not the same as the target crop. Aborting")
        return
    end

    for _, crop in pairs(allCrops) do
        local farmSlot = database.findNextEmptyFarmSlot()
        
        if farmSlot == -1 then
            print('prepareWorking: No empty farm slot')
            return
        end

        if crop.inStorage then
            action.movePlant(
                posUtil.storageSlotToPos(crop.slot),
                posUtil.farmSlotToPos(farmSlot)
            )
            database.updateFarm(farmSlot, database.getStorage()[crop.slot])
            database.updateStorage(crop.slot, { isCrop = true, name = "air" })
        else
            action.movePlantFarmGlacier(
                posUtil.glacierSlotToPos(crop.slot),
                posUtil.farmSlotToPos(farmSlot)
            )
            database.updateFarm(farmSlot, database.getGlacier()[crop.slot])
            database.updateGlacier(crop.slot, { isCrop = true, name = "air" })
        end

        -- Return to charger
        action.charge()
    end

    print('prepareWorking: Complete!')
end

main()