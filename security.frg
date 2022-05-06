#lang forge

open "common.frg"

// simulating a 51% attack using majority bad miners that all use the same BadP2PNetwork
pred majorityAttack[block: BlockX] {
    // there are more bad miners than good miners
    #{BadMiner} > #{GoodMiner}

    some n1: BadP2PNetwork | all n2: P2PNetwork {
        #{bm: BadMiner | bm.network = n1} > #{gm: GoodMiner | gm.network = n1}
        n1 != n2 => #{m: Miner | m.network = n1} > #{m: Miner | m.network = n2}
        all tx: block.blockTxs | tx in n1.networkTxs
    }
}