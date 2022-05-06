#lang forge

open "blockchain.frg"
open "security.frg"
// a block is added to the chain IFF a majority of miners approve the block
// a miner approves the block when Block.transactions in Miner.network.transactions
// increment Block.votes if a miner approves the block
// block is approved when Block.votes > Miners.allMiners.len/2 + 1
pred consensus[block: FBlock] {
    #{m: Miner | m in Miners.allMiners and (block.blockTxs in m.network.networkTxs)} >= add[divide[#{m: Miner | m in Miners.allMiners}, 2], 1] iff block.approved = 1   
}

pred reachConsensus {
    all b: FBlock {
        consensus[b]
    }
}

// checks if a block is in a blockchain 
// i.e., it points to another block and another block points to it
// also checks that the block is in BlockChain.allBlocks
pred blockInChain[b: FBlock, bc: BlockChain] {
    bc.lastBlock != b => {
        some next: FBlock {
            next.header.prevBlockHash = b.hash
            next in bc.allBlocks
        } 
    }
    b in bc.allBlocks
}

// forces all blocks to be in a chain
pred allBlocksInAChain {
    all b: FBlock {
        some bc: BlockChain {
            blockInChain[b, bc]
        }
    }
}

pred wellformedChain {
    // blocks can only have the same hash if they are the same block
    all b1, b2: FBlock {
        b1.hash = b2.hash => b1 = b2
    }

    // the blockChain is linear
    all bc: BlockChain {
        // no cycles
        some root: FBlock {
            no root.header.prevBlockHash
            blockInChain[root, bc]
        }
    }

    all b: FBlock, bc:BlockChain {
        // block is in allBlocks iff it is in the chain
        b in bc.allBlocks iff blockInChain[b, bc]
    }

    // block is in chain iff it reached consensus
    reachConsensus

    // time is linear
    some last: TIME {
        no last.next
    }
    some first: TIME {
        all other: TIME {
            reachable[other, first, next] or other = first
        }
    }
}

// a normal step appending to current chain (no fork)
pred step [b1, b2: BlockChain] {
    // the old lastBlock becomes the previous block of the new lastBlock
    b2.lastBlock.header.prevBlockHash = b1.lastBlock.hash
}

// generates traces
pred traces {
    all t1, t2: TIME {
        t1.next = t2 => step[t1.blockchain, t2.blockchain]
    }
}

// generates a blockchain with 3 blocks being added
run {
    wellformedChain
    allBlocksInAChain
    traces
    // majorityAttack
} for exactly 3 TIME, 5 GoodMiner
