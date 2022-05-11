#lang forge

// each block contains the following fields:
// hash: HASH sig; 
// unique hash representing the block
// header: Header sig; 
// described further below
// blockTxs: Transaction set; 
// set of all Transaction(s) in the Block
// votes: Int; 
// number of votes the block gets for consensus
// approved: Int; 
// 0 if not approved by consensus, 1 if approved by consensus
// *constrained in block.frg*
sig BlockX {
    hash: one HASH,
    header: one Header,
    blockTxs: set Transaction,
    votes: one Int,
    approved: one Int
}

// each header contains the following fields:
// version: Int; 
// represents the version of the blockchain we are using; useful for representing hard forks
// time: TIME sig; 
// represents the time step at which this block was mined; useful for ordering blocks
// nonce: NONCE sig;
// represents whether or not a block has the nonce; block can be added to chain IFF it has the nonce
// blocksize: Int;
// represents number of transactions in a block; useful for changing block sizes during hard forks
// prevBlockHash: HASH sig;
// this is a reference to the unique hash of the previous block
// merkleRootHash: HASH sig;
// this is a reference to the merkle root hash of txs in a block;
// *constrained in block.frg*
sig Header {
    version: one Int,
    time: one TIME,
    nonce: one NONCE,
    blocksize: one Int,
    prevBlockHash: lone HASH,
    merkleRootHash: one HASH
}

// represents time (state)
// *constrained in blockchain.frg*
sig TIME {
    next: lone TIME,
    blockchain: one BlockChain
}

// represents a nonce for a block
// *constrained in block.frg*
sig NONCE {}

// represents 256-bit hashes
// *constrained in hash.frg*
sig HASH {}

// abstract sig representing a miner
// every miner receives its transactions from a peer to peer network
// *constrained in miner.frg*
abstract sig Miner {
    network: one P2PNetwork
}

// a good miner's network is a GoodP2PNetwork
// *constrained in miner.frg*
sig GoodMiner extends Miner {}

// a bad miner's network is a BadP2PNetwork
// *constrained in miner.frg*
sig BadMiner extends Miner {}

// set of all miners
// *constrained in miner.frg*
one sig Miners {
    allMiners: set Miner
}

// abstract sig representing a peer to peer network
// the peer to peer network simply consists of a set of transactions
// *constrained in network.frg*
abstract sig P2PNetwork {
    networkTxs: set Transaction
}

// there is only one legitimate network
// GoodP2PNetwork.networkTxs consists of only good transactions 
// *constrained in network.frg*
one sig GoodP2PNetwork extends P2PNetwork {}

// there can be multiple bad networks
// BadP2PNetwork.networkTxs consists of good transactions and/or bad transactions
// *constrained in network.frg*
sig BadP2PNetwork extends P2PNetwork {}

// set of all minted/mined coins i.e., set of all coins in our universe
// *constrained in transaction.frg*
one sig Minted {
    coins: set Coin
}

// each coin is either spent or unspent
// spent is set to 1 if spent, 0 if unspent
// *constrained in transaction.frg*
sig Coin {
    spent: one Int 
}

// each transaction has a set of inputs and outputs
// *constrained in transaction.frg*
sig Transaction {
    inputs: set Input,
    outputs: set Output
}

// sig to represent inputs to a transaction
// each input consists of a set of (spent) coins
// *constrained in transaction.frg*
sig Input {
    inputCoins: set Coin
}

// sig to represent outputs from a transaction
// each output consists of a set of (unspent) coins
// *constrained in transaction.frg*
sig Output {
    outputCoins: set Coin
}

// a blockchain can be represented by the last block in the chain and 
// a set of all blocks in the chain; we can access the entire chain by 
// using BlockChain.lastBlock.header.prevBlockHash which gives us the 
// hash of the previous block, and we can continue to iterate backward 
// as needed
// *constrained in blockchain.frg*
sig BlockChain {
    lastBlock: lone BlockX,
    allBlocks: set BlockX
}