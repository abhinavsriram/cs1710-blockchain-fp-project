#lang forge

open "common.frg"

// defines behavior of a GoodMiner
pred goodMiner[m: Miner] {
    some gn: GoodP2PNetwork | m.network = gn
}

// defines behavior of a BadMiner
pred badMiner[m: Miner] {
    some bn: BadP2PNetwork | m.network = bn
}

pred wellformedMiners {
    // every miner must be a good miner or a bad miner
    all m: Miner {
        goodMiner[m] or badMiner[m]
    }
    // all GoodMiner must exhibit behavior of a good miner
    all gm: GoodMiner {
        gm in Miners.allMiners
        goodMiner[gm]
    }
    // all BadMiner must exhibit behavior of a bad miner
    all bm: BadMiner {
        bm in Miners.allMiners
        badMiner[bm]
    }
    // every miner must be present in Miners.allMiners
    all m: Miner {
        m in Miners.allMiners
    }
}