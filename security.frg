#lang forge

open "common.frg"

// simulating a 51% attack using majority bad miners that all use the same BadP2PNetwork
pred majorityAttack {
    // there are more bad miners than good miners
    #{BadMiner} > #{GoodMiner}
    // all the bad miners use the same bad network i.e., they all collude
    some attackNetwork: BadP2PNetwork | all otherNetwork: P2PNetwork {
        // bad miners part of attack network are greater than miners in every other network
        attackNetwork != otherNetwork => #{m: Miner | m.network = attackNetwork} > #{m: Miner | m.network = otherNetwork}
        // all the txs in any block are from the attack network
        all b: BlockX {
            all tx: b.blockTxs | tx in attackNetwork.networkTxs
        }
    }
}

// predicate that simply enforces that a majority attack is not taking place
// this is a stronger constraint than not having the constraint at all but
// this is a weaker constraint than enforcing that #{GoodMiner} > #{BadMiner}
// because we can still have #{BadMiner} > #{GoodMiner} but no attack
pred businessAsUsual {
    not majorityAttack
}