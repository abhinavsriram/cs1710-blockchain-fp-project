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

pred wellformedBlocks {
    allBlocksInAChain
    allBlocksHaveTransaction
    allBlocksUnique
    allNoncesUnique
}