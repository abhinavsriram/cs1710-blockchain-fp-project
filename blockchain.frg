#lang forge

open "common.frg"
open "block.frg"

pred wellformedChain {
    // there should not be any hanging blockchains
    all bc: BlockChain {
        some t: TIME | t.blockchain = bc
    }
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

// A single starting time, where the chain starts with no blocks
example wellformedOneTime is wellformedChain for {
    BlockChain = `BC0
    TIME = `T0
    allBlocks = `BC0 -> none
    lastBlock = `BC0 -> none
}

// A single starting time, where the chain has blocks somehow
example malformedOneTime is not wellformedChain for {
    BlockChain = `BC0
    TIME = `T0
    BlockX = `BX0

    allBlocks = `BC0 -> `BX0
    lastBlock = `BC0 -> `BX0
}

// Two times
example wellformedTwoTime is wellformedChain for {
    BlockChain = `BC0 + `BC1
    TIME = `T0 + `T1
    BlockX = `BX0

    allBlocks = `BC0 -> none + `BC1 -> `BX0
    lastBlock = `BC0 -> none + `BC1 -> `BX0
    blockchain = `T0 -> `BC0 + `T1 -> `BC1
}

// Two times but allBlocks does not contain all blocks
example malformedAllBlocks is not wellformedChain for {
    BlockChain = `BC0 + `BC1
    TIME = `T0 + `T1
    BlockX = `BX0

    allBlocks = `BC0 -> none + `BC1 -> none
    lastBlock = `BC0 -> none + `BC1 -> `BX0
    blockchain = `T0 -> `BC0 + `T1 -> `BC1
}