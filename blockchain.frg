#lang forge "final"

sig BlockChain {
    lastBlock: one Block,
    allBlocks: set Block
}

sig Block {
    header: one Header,
    transactions: set Transaction,
    transactionCounter: one Int
}

sig Header {
    version: one Version,
    time: one TIME,
    nonce: one NONCE,
    blocksize: one Int
    prevBlockHash: one HASH,
    merkleRootHash: one HASH
}

sig TIME {}
sig NONCE {}
sig HASH {}
sig Version {}

// master set of all minted coins
sig Minted {
    coins: set Coin
}

sig Coin {
    id: one HASH,
    // 1 if spent, 0 if not
    spent: one Int 
}

sig Transaction {
    id: one HASH,
    inputs: set Input,
    outputs: set Output
}
// bad transactions are ones where 
//      inputs or outputs have spent coins or coins not in Minted
//      multiple transactions have same input and/or output

// inputs and outputs are valid if all coins are present in Minted and not spent
sig Input {
    coins: set Coin
}
sig Output {
    coins: set Coin
}

abstract sig P2PNetwork {
    transactions: set Transaction
}
// there is only one legitimate network
one sig GoodP2PNetwork extends P2PNetwork {}
// there can be multiple bad networks
sig BadP2PNetwork extends P2PNetwork {}

sig Miners {
    allMiners: set Miner
}

abstract sig Miner {}
sig GoodMiner {
    network: one GoodP2PNetwork
}
sig BadMiner {
    network: one BadP2PNetwork
}


