#lang forge

open "common.frg"
open "block.frg"

// a block is added to the chain IFF a majority of miners approve the block
// a miner approves the block when Block.transactions in Miner.network.transactions
// increment Block.votes if a miner approves the block
// block is approved when Block.votes > Miners.allMiners.len/2 + 1
pred consensus[block: BlockX] {
    #{m: Miner | m in Miners.allMiners and (block.blockTxs in m.network.networkTxs)} >= add[divide[#{m: Miner | m in Miners.allMiners}, 2], 1] implies block.approved = 1   
}

pred wellformedChain {
    // blocks can only have the same hash if they are the same block
    all b1, b2: BlockX {
        b1.hash = b2.hash => b1 = b2
    }
    // block is in allBlocks iff it is in the chain
    all b: BlockX, bc: BlockChain {
        b in bc.allBlocks iff blockInChain[b, bc]
    }
    // time is linear
    some last: TIME {
        no last.next
    }
    some first: TIME {
        all other: TIME {
            reachable[other, first, next] or other = first
        }
        // blockchain starts with no block
        no b: BlockX {
            b in first.blockchain.allBlocks
        }
        no first.blockchain.lastBlock
    }
}

