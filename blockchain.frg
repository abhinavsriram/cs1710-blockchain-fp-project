#lang forge

open "common.frg"
open "block.frg"

pred wellformedChain {
    // all blocks in the blockchain must have reached consensus
    all b: BlockX, bc: BlockChain {
        b in bc.allBlocks => consensus[b]
    }
    // all blocks in a blockchain must be legally part of that chain
    all b: BlockX, bc: BlockChain {
        b in bc.allBlocks iff blockInAChainLegally[b, bc]
    }
    // time is linear
    some last: TIME {
        no last.next
    }
    some first: TIME {
        // time is linear
        all other: TIME {
            reachable[other, first, next] or other = first
        }
        // blockchain starts with no block
        no b: BlockX {
            b in first.blockchain.allBlocks
        }
        // blockchain has no first/last block at the start
        no first.blockchain.lastBlock
    }
}

