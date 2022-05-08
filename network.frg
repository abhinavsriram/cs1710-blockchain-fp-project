#lang forge

open "common.frg"
open "transaction.frg"

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

// good networks must only have good transactions
pred goodNetworkGoodTransaction {
    all tx: Transaction, b: BlockX {
        tx in GoodP2PNetwork iff goodTransaction[tx, b]
    }
}

// bad networks can have good and bad transactions
pred badNetworkBadTransaction {
    all tx: Transaction, b: BlockX {
        tx in BadP2PNetwork iff goodTransaction[tx, b] or badTransaction[tx, b]
    }
}

pred wellformedNetworks {
    allNetworksHaveTransactions
    allNetworksDoNotShareTransactions
    goodNetworkGoodTransaction
    badNetworkBadTransaction
}