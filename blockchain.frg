#lang forge

open "common.frg"
open "block.frg"

pred wellformedChain {
    // all blocks in the blockchain must have reached consensus
    all b: BlockX, bc: BlockChain {
        b in bc.allBlocks => consensus[b]
        b.votes >= add[divide[#{m: Miner | m in Miners.allMiners}, 2], 1]
    }
    // block is in allBlocks iff it is part of the chain
    all b: BlockX, bc: BlockChain {
        b in bc.allBlocks iff blockPartOfChain[b, bc]
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

