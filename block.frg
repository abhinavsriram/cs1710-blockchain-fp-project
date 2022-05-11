#lang forge

open "common.frg"

// checks if a block is in a blockchain 
pred blockInChain[b: BlockX, bc: BlockChain] {
    // check that it points to another block and another block points to it
    bc.lastBlock != b => {
        some next: BlockX {
            next.header.prevBlockHash = b.hash
            next in bc.allBlocks
        } 
    }
    // also checks that the block is in BlockChain.allBlocks
    b in bc.allBlocks
}

// forces all blocks to be in a chain
pred allBlocksInAChain {
    all b: BlockX {
        some bc: BlockChain {
            blockInChain[b, bc]
        }
    }
    // all blocks in a chain must have the same version
    // right now we only have one chain so we set all block versions to be 1
    all b: BlockX {
        b.header.version = 1
    }
}

// forces all blocks to contain a transaction
pred allBlocksHaveTransaction {
    all b: BlockX {
        // block must have at least 1 transaction from some P2PNetwork
        some tx: Transaction {
            tx in b.blockTxs
        }
        // all transactions in a block must be from some P2PNetwork
        all tx: Transaction {
            some n: P2PNetwork {
                tx in b.blockTxs => tx in n.networkTxs
            }
        }
    }
}

// forces all blocks to not share a hash, header or block transactions
pred allBlocksUnique {
    all b: BlockX {
        all ob: BlockX {
            b != ob => b.hash != ob.hash and b.header != ob.header and b.blockTxs != ob.blockTxs
            b != ob => b.blockTxs not in ob.blockTxs and ob.blockTxs not in b.blockTxs
        }
    }
}

// forces all blocks to have a unique nonce
pred allNoncesUnique {
    all b: BlockX {
        all ob: BlockX {
            b != ob => b.header.nonce != ob.header.nonce
        }
    }
}

// a block is added to the chain IFF a majority of miners approve the block
// a miner approves the block when Block.transactions in Miner.network.transactions
// increment Block.votes if a miner approves the block
// block is approved when Block.votes > Miners.allMiners.len/2 + 1
pred consensus[block: BlockX] {
    #{m: Miner | m in Miners.allMiners and (block.blockTxs in m.network.networkTxs)} >= add[divide[#{m: Miner | m in Miners.allMiners}, 2], 1]
}

// labels if block is approved or not and enumerates votes
pred blockConsensus {
    all b: BlockX {
        // if a block reaches consensus, it is marked as approved, else not approved
        consensus[b] => b.approved = 1
        not consensus[b] => b.approved = 0

        // set number of votes
        b.votes = #{m: Miner | m in Miners.allMiners and (b.blockTxs in m.network.networkTxs)}
    }
}

pred wellformedBlocks {
    allBlocksInAChain
    allBlocksHaveTransaction
    allBlocksUnique
    allNoncesUnique
    blockConsensus
}