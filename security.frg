#lang forge

open "common.frg"

// simulating a 51% attack using majority bad miners that all use the same BadP2PNetwork
pred majorityAttack[block: BlockX] {
    // there are more bad miners than good miners
    #{BadMiner} > #{GoodMiner}

    some attackNetwork: BadP2PNetwork | all otherNetwork: P2PNetwork {
        // bad miners part of attack network are greater than miners in every other network
        attackNetwork != otherNetwork => #{m: Miner | m.network = attackNetwork} > #{m: Miner | m.network = otherNetwork}
        // all the txs in any block are from the attack network
        all tx: block.blockTxs | tx in attackNetwork.networkTxs
    }
}