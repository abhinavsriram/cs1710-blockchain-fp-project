#lang forge

open "common.frg"
open "blockchain.frg"
open "block.frg"

// a normal step appending to current chain (no fork)
pred step [b1, b2: BlockChain] {
    // the old lastBlock becomes the previous block of the new lastBlock
    some b1.lastBlock => {
        b2.lastBlock.header.prevBlockHash = b1.lastBlock.hash
    } else {
        no b2.lastBlock.header.prevBlockHash
    }
    some b2.lastBlock

    // only one block is added at a time, to the end of the chain, and no other block changes
    #{b: BlockX | b in b1.allBlocks and b in b2.allBlocks} = #{b: BlockX | b in b1.allBlocks}
    #{b: BlockX | b in b2.allBlocks and not b in b1.allBlocks} = 1

    // setting the blocksize in block header
    b2.lastBlock.header.blocksize = #{tx: Transaction | tx in b2.lastBlock.blockTxs}

    // the newly added block must have reached consensus
    consensus[b2.lastBlock]

    // coins used in transactions as inputs are now spent
    all tx: Transaction, i: Input, c: Coin {
        tx in b2.lastBlock.blockTxs => {i in tx.inputs => {c in i.inputCoins => c.spent = 1}}
    }
}

// generates traces
pred traces {
    all t1, t2: TIME {
        t1.next = t2 => {
            step[t1.blockchain, t2.blockchain]
            t2.blockchain.lastBlock.header.time = t2
        }
    }
}