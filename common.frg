#lang forge

// each block contains the following fields
// hash: HASH sig;
//       - unique hash representing the block
// header: Header sig;
//         - described further below
// transactions: Transaction set;
//               - set of all Transaction(s) in the Block
// votes: Int;
//        - counter for the number of votes the block gets for consensus
// approved: Int;
//           - 0 if not approved by consensus, 1 if approved by consensus
sig BlockX {
    hash: one HASH,
    header: one Header,
    blockTxs: set Transaction,
    votes: one Int,
    approved: one Int
}

// each header contains the following fields
// version: Int; 
//          - represents the version of the blockchain we are using
//          - useful for representing hard forks
// time: TIME sig; 
//       - represents the time step at which this block was mined
//       - useful for ordering blocks
// nonce: NONCE sig;
//        - represents whether or not a block has the nonce
//        - block can be added to chain IFF it has the nonce
// blocksize: Int;
//            - represents number of transactions in a block
//            - useful for changing block sizes during hard forks
//            - also useful for spotting bad blocks from bad miners
// prevBlockHash: HASH sig;
//                - this is a reference to the unique hash of the previous block
// merkleRootHash: HASH sig;
//                 - may not be needed
sig Header {
    version: one Int,
    time: one TIME,
    nonce: one NONCE,
    blocksize: one Int,
    prevBlockHash: lone HASH,
    merkleRootHash: one HASH
}

// represents time (state)
sig TIME {
    next: lone TIME,
    blockchain: one BlockChain
}

// represents a nonce for a block
sig NONCE {}

// represents 256-bit hashes
sig HASH {}

// abstract sig representing a miner
abstract sig Miner {
    network: one P2PNetwork
}

// a good miner's network is a GoodP2PNetwork
sig GoodMiner extends Miner {}

// a bad miner's network is a BadP2PNetwork
sig BadMiner extends Miner {}

// set of all miners
one sig Miners {
    allMiners: set Miner
}

// abstract sig representing a peer to peer network
// the peer to peer network simply consists of a set of transactions
abstract sig P2PNetwork {
    networkTxs: set Transaction
}

// there is only one legitimate network
// GoodP2PNetwork.transactions consists of only good transactions 
// good transactions are defined by goodTransaction[tx, block]
one sig GoodP2PNetwork extends P2PNetwork {}

// there can be multiple bad networks
// BadP2PNetwork.transactions consists of good transactions and/or bad transactions
// bad transactions are defined by badTransaction[tx, block]
sig BadP2PNetwork extends P2PNetwork {}

// set of all minted/mined coins i.e., set of all coins in our universe
one sig Minted {
    coins: set Coin
}

// each coin is either spent or unspent
// spent is set to 1 if spent, 0 if unspent
sig Coin {
    spent: one Int 
}

// each transaction has a set of inputs and outputs
sig Transaction {
    inputs: set Input,
    outputs: set Output
}

// sig to represent inputs to a transaction
sig Input {
    inputCoins: set Coin
}

// sig to represent outputs from a transaction
sig Output {
    outputCoins: set Coin
}

// a blockchain can be represented by the last block in the chain and 
// a set of all blocks in the chain; we can access the entire chain by 
// using BlockChain.lastBlock.header.prevBlockHash which gives us the 
// hash of the previous block, and we can continue to iterate backward 
// as needed
sig BlockChain {
    lastBlock: lone BlockX,
    allBlocks: set BlockX
}