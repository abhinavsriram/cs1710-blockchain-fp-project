#lang forge

open "common.frg"

// defines behavior of a GoodMiner
pred goodMiner[m: Miner] {
    m.network = GoodP2PNetwork
}

// defines behavior of a BadMiner
pred badMiner[m: Miner] {
    m.network = BadP2PNetwork
}

pred wellformedMiners {
    // every miner must be a good miner or a bad miner
    all m: Miner {
        goodMiner[m] or badMiner[m]
    }
    all gm: GoodMiner {
        goodMiner[gm]
    }
    // all bm: BadMiner {
    //     badMiner[bm]
    // }
    // every miner must be present in Miners.allMiners
    all m: Miner {
        m in Miners.allMiners
    }
}