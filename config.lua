local config = {
    -- NOTE: EACH CONFIG SHOULD END WITH A COMMA

    -- Side Length of Storage Farm
    storageFarmSize = 9,
    -- Side Length of Working Farm
    workingFarmSize = 6,
    -- Side Length of Glacier Farm
    glacierFarmSize = 15,

    -- Once complete, remove all extra crop sticks to prevent the working farm from weeding
    cleanUp = true,
    -- Pickup any and all drops (don't change)
    keepDrops = true,
    -- Keep crops that are not the target crop during autoSpread and autoStat
    keepMutations = false,
    -- Stat-up crops during autoTier (Very Slow)
    statWhileTiering = false,

    -- Minimum tier for the working farm during autoTier
    autoTierThreshold = 13,
    -- Minimum Gr + Ga - Re for the working farm during autoStat (21 + 31 - 0 = 52)
    autoStatThreshold = 52,
    -- Minimum Gr + Ga - Re for the storage farm during autoSpread (23 + 31 - 0 = 54)
    autoSpreadThreshold = 50,

    -- Maximum Growth for crops on the working farm
    workingMaxGrowth = 21,
    -- Maximum Resistance for crops on the working farm
    workingMaxResistance = 2,
    -- Maximum Growth for crops on the storage farm
    storageMaxGrowth = 23,
    -- Maximum Resistance for crops on the storage farm
    storageMaxResistance = 2,

    -- Minimum Charge Level
    needChargeLevel = 0.2,
    -- Max breed round before termination of autoTier.
    maxBreedRound = 1000,

    -- Wether ntfy.sh notifications should be enabled
    ntfyEnabled = false,

    -- The ntfy.sh channel to send notifications to
    ntfyChannel = "invalid",

    -- =========== DO NOT CHANGE ===========

    -- The coordinate for charger
    chargerPos = {0, 0},
    -- The coordinate for the container contains crop sticks
    stickContainerPos = {-1, 0},
    -- The coordinate for the container to store seeds, products, etc
    storagePos = {-2, 0},
    -- The coordinate for the farmland that the dislocator is facing
    relayFarmlandPos = {1, 1},
    -- The coordinate for the transvector dislocator
    dislocatorPos = {1, 2},

    -- The slot for spade
    spadeSlot = 0,
    -- The slot for the transvector binder
    binderSlot = -1,
    -- The slot for crop sticks
    stickSlot = -2,
    -- The slot which the robot will stop storing items
    storageStopSlot = -3
}

-- =========== GLACIER ===========

config.glacierDislocatorPos = {3, config.workingFarmSize+1}

config.workingFarmArea = config.workingFarmSize^2
config.storageFarmArea = config.storageFarmSize^2
config.glacierFarmArea = config.glacierFarmSize^2

return config
