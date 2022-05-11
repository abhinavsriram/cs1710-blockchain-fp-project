#lang forge

open "common.frg"

// defines behavior of a GoodMiner
pred goodMinerBehavior[m: Miner] {
    some gn: GoodP2PNetwork | m.network = gn
}

// defines behavior of a BadMiner
pred badMinerBehavior[m: Miner] {
    some bn: BadP2PNetwork | m.network = bn
}

// every miner must be a good miner or a bad miner
pred allMinerGoodOrBad {
    all m: Miner {
        goodMinerBehavior[m] or badMinerBehavior[m]
    }
}

// all GoodMiners must exhibit behavior of a good miner
pred goodMinerGoodBehavior {
    all gm: GoodMiner {
        gm in Miners.allMiners
        goodMinerBehavior[gm]
    } 
}

// all BadMiners must exhibit behavior of a bad miner
pred badMinerBadBehavior {
    all bm: BadMiner {
        bm in Miners.allMiners
        badMinerBehavior[bm]
    }
}

// every miner must be present in Miners.allMiners
// potentially redundant
pred everyMinerInAllMiners {
    all m: Miner {
        m in Miners.allMiners
    }
}

pred wellformedMiners {
    allMinerGoodOrBad
    goodMinerGoodBehavior
    badMinerBadBehavior
    everyMinerInAllMiners
}