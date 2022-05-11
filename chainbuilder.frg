#lang forge

open "common.frg"
open "blockchain.frg"
open "block.frg"

// predicate that describes transition from one timestep to the next
// this predicate describes the chainbuilding process under normal circumstances (no forks)
pred step [b1, b2: BlockChain] {
    // the old lastBlock becomes the previous block of the new lastBlock
    some b1.lastBlock => {
        b2.lastBlock.header.prevBlockHash = b1.lastBlock.hash
    } else {
        no b2.lastBlock.header.prevBlockHash
    }
    // there is a new block added to the chain
    some b2.lastBlock
    // and the newly added block must have reached consensus
    consensus[b2.lastBlock]
    // only one block is added at a time, to the end of the chain, and no other block changes
    #{b: BlockX | b in b1.allBlocks and b in b2.allBlocks} = #{b: BlockX | b in b1.allBlocks}
    #{b: BlockX | b in b2.allBlocks and not b in b1.allBlocks} = 1
    // setting the blocksize in block header
    b2.lastBlock.header.blocksize = #{tx: Transaction | tx in b2.lastBlock.blockTxs}
}

// Step from empty blockchain with no blocks to blockchain with one block
// Should be step[`BC0, `BC1] and no other ordered combination, hence ONE b1, b2
example canStepNoneToOne is {one b1, b2: BlockChain | step[b1, b2]} for {
    BlockChain = `BC0 + `BC1
    BlockX = `BX0
    
    lastBlock = `BC1 -> `BX0
    allBlocks = `BC1 -> `BX0
}

// Not a valid step to go from a blockchain to itself
example noStepSameBlockchain is not {some b1: BlockChain | step[b1, b1]} for {
    BlockChain = `BC0
    BlockX = `BX0

    lastBlock = `BC0 -> `BX0
    allBlocks = `BC0 -> `BX0
}

// Step from blockchain with blocks to blockchain with one more block
// Should be step[`BC0, `BC1] and no other ordered combination, hence one b1, b2
example canStepSome is {one b1, b2: BlockChain | step[b1, b2]} for {
    BlockChain = `BC0 + `BC1
    BlockX = `BX0 + `BX1 + `BX2 + `BX3
    
    lastBlock = `BC0 -> `BX2 + `BC1 -> `BX3 
    allBlocks = `BC0 -> `BX0 + `BC0 -> `BX1 + `BC0 -> `BX2 + 
                `BC1 -> `BX0 + `BC1 -> `BX1 + `BC1 -> `BX2 + `BC1 -> `BX3
}

// Cannot step without changing lastBlock to brand new block not previously in chain
example noStepWrongLast is not {some b1, b2: BlockChain | step[b1, b2]} for {
    BlockChain = `BC0 + `BC1
    BlockX = `BX0 + `BX1 + `BX2 + `BX3
    
    lastBlock = `BC0 -> `BX2 + `BC1 -> `BX0 
    allBlocks = `BC0 -> `BX0 + `BC0 -> `BX1 + `BC0 -> `BX2 + 
                `BC1 -> `BX0 + `BC1 -> `BX1 + `BC1 -> `BX2 + `BC1 -> `BX3
}

// Can step[`BC0, `BC1] when prevBlockHash of `BC1's header is hash of `BC0's lastBlock
// Cannot step any other ordered combination
example canStepWithHash is {one b1, b2: BlockChain | step[b1, b2]} for {
    BlockChain = `BC0 + `BC1
    BlockX = `BX2 + `BX3
    Header = `HEADER3 + `HEADER2
    HASH = `HASH2 + `HASH3
    
    lastBlock = `BC0 -> `BX2 + `BC1 -> `BX3 
    allBlocks = `BC0 -> `BX2 + `BC1 -> `BX2 + `BC1 -> `BX3

    header = `BX3 -> `HEADER3 + `BX2 -> `HEADER2
    hash = `BX2 -> `HASH2 + `BX3 -> `HASH3
    prevBlockHash = `HEADER3 -> `HASH2
}

// Cannot step when new block's header's prevBlockHash is not the old lastBlock's hash
example noStepWrongPrevHash is not {some b1, b2: BlockChain | step[b1, b2]} for {
    BlockChain = `BC0 + `BC1
    BlockX = `BX2 + `BX3
    Header = `HEADER3 + `HEADER2
    HASH = `HASH2 + `HASH3
    
    lastBlock = `BC0 -> `BX2 + `BC1 -> `BX3 
    allBlocks = `BC0 -> `BX2 + `BC1 -> `BX2 + `BC1 -> `BX3

    header = `BX3 -> `HEADER3 + `BX2 -> `HEADER2
    hash = `BX2 -> `HASH2 + `BX3 -> `HASH3
    prevBlockHash = `HEADER3 -> `HASH3
}

// Cannot step when previous blocks in chain have changed
example noStepHistoryChanged is not {some b1, b2: BlockChain | step[b1, b2]} for {
    BlockChain = `BC0 + `BC1
    BlockX = `BX0 + `BX1 + `BX2 + `BX3 + 
            `BX4 + `BX5 + `BX6
    
    lastBlock = `BC0 -> `BX2 + `BC1 -> `BX3 
    allBlocks = `BC0 -> `BX0 + `BC0 -> `BX1 + `BC0 -> `BX2 + 
                `BC1 -> `BX4 + `BC1 -> `BX5 + `BC1 -> `BX6 + `BC1 -> `BX3
}

// generates traces of a blockchain being built
pred traces {
    all t1, t2: TIME {
        t1.next = t2 => {
            step[t1.blockchain, t2.blockchain]
            t2.blockchain.lastBlock.header.time = t2
        }
    }
}

test expect {
    // This should be sat but is not. Change value to test different amounts of TIME
    tracesSat5 : {
        traces
    } for exactly 5 TIME for {next is linear} is sat
}