#lang forge

open "common.frg"
open "block.frg"

pred wellformedChain {
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

