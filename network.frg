#lang forge

open "common.frg"
open "transaction.frg"

// good networks must only have good transactions
pred goodNetworkGoodTransaction {
    all tx: Transaction, b: BlockX, gn: GoodP2PNetwork {
        tx in gn.networkTxs => goodTransaction[tx, b]
    }
}

// bad networks can have good and/or bad transactions
pred badNetworkBadTransaction {
    all tx: Transaction, b: BlockX, bn: BadP2PNetwork {
        tx in bn.networkTxs => goodTransaction[tx, b] or badTransaction[tx, b]
    }
}

// all networks are either good or bad
pred allNetworkGoodOrBad {
    all n: P2PNetwork {
        n = GoodP2PNetwork or n = BadP2PNetwork
    }
}

// all networks must have at least 1 miner
pred allNetworksHaveMiners {
    all n: P2PNetwork | {
        some m: Miner {
            m.network = n
        }
    }
}

// all networks must have at least 1 transaction
pred allNetworksHaveTransactions {
    all n: P2PNetwork | {
        some tx: Transaction {
            tx in n.networkTxs
        }
    }
}

// all networks must have unique transactions
pred allNetworksDoNotShareTransactions {
    all tx: Transaction {
        all disj n1, n2: P2PNetwork {
            tx in n1.networkTxs => tx not in n2.networkTxs
        }
    }
}

pred wellformedNetworks {
    goodNetworkGoodTransaction
    badNetworkBadTransaction
    allNetworkGoodOrBad
    allNetworksHaveMiners
    allNetworksHaveTransactions
    allNetworksDoNotShareTransactions
}