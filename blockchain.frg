#lang forge

// a blockchain can be represented by the last block in the chain and 
// a set of all blocks in the chain; we can access the entire chain by 
// using BlockChain.lastBlock.header.prevBlockHash which gives us the 
// hash of the previous block, and we can continue to iterate backward 
// as needed
one sig BlockChain {
    lastBlock: one FBlock,
    allBlocks: set FBlock
}

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
sig FBlock {
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
    prevBlockHash: one HASH,
    merkleRootHash: one HASH
}

// represents time
sig TIME {}
// represents a nonce for a block
sig NONCE {}
// represents 256-bit hashes
sig HASH {}

// set of all minted/mined coins i.e., set of all coins in our universe
one sig Minted {
    coins: set Coin
}

// each coin has a unique ID given by a unique HASH
// each coin is either spent or unspent
// spent is set to 1 if spent, 0 if unspent
sig Coin {
    coinID: one HASH,
    spent: one Int 
}

// each transaction has a unique ID given by a unique HASH
// it also has a set of inputs and outputs
sig Transaction {
    txID: one HASH,
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

// set of all miners
one sig Miners {
    allMiners: set Miner
}

// active field? in order to change number of miners dynamically
abstract sig Miner {
    network: one P2PNetwork
}
// a good miner's network is a GoodP2PNetwork
sig GoodMiner {
    // goodNetwork: one GoodP2PNetwork
}
// a bad miner's network is a BadP2PNetwork
sig BadMiner {
    // badNetwork: one BadP2PNetwork
}

// Input is valid if all coins in Input.coins are present in Minted and not spent
pred validInput[input: Input] {
    // TODO
    input.inputCoins in Minted.coins
    all coin: input.inputCoins | coin.spent = 0 
}

// Output is valid if all coins in Output.coins are present in Minted and not spent
pred validOutput[output: Output] {
    // TODO
    output.outputCoins in Minted.coins
    all coin: output.outputCoins | coin.spent = 0
}

// good transactions are ones where 
// - Transaction.id is unique
// - Transaction.inputs is valid
// - Transaction.outputs is valid
// - no other transaction on that block has the same inputs and/or outputs
pred goodTransaction[tx: Transaction, block: FBlock] {
    // TODO
    all otherTx: Transaction | tx.txID = otherTx <=> tx = otherTx
    all input: tx.inputs | validInput[input]
    all output: tx.outputs | validOutput[output]
    all otherTx: block.blockTxs | otherTx != tx => (tx.inputs != otherTx.inputs and tx.outputs != otherTx.outputs)
}

// if any of the above condiitons are violated, then it is a bad transaction
pred badTransaction[tx: Transaction, block: FBlock] {
    not goodTransaction[tx, block]
}

// a block is added to the chain IFF a majority of miners approve the block
// a miner approves the block when Block.transactions in Miner.network.transactions
// increment Block.votes if a miner approves the block
// block is approved when Block.votes > Miners.allMiners.len/2 + 1
pred consensus[block: FBlock] {
    // #{m: Miner | m in Miners.allMiners and block.blockTxs in m.network.networkTxs} >= add[divide[#{m: Miner | m in Miners.allMiners}, 2], 1] implies block.approved = 1   
}

// simulating a 51% attack using majority bad miners that all use the same BadP2PNetwork
pred majorityAttack {
    // TODO
}

run {
    consensus
}


