#lang forge

open "common.frg"

// forces all blocks to not share a hash, header or block transactions
// blocks can obviously have the same votes or approval status
pred allBlocksUnique {
    all b: BlockX {
        all ob: BlockX {
            b != ob => b.hash != ob.hash and b.header != ob.header and b.blockTxs != ob.blockTxs
            b != ob => b.blockTxs not in ob.blockTxs and ob.blockTxs not in b.blockTxs
        }
    }
}

example blocksSharedHash is not allBlocksUnique for {
    BlockChain = `BC0
    BlockX = `BX0 + `BX1
    HASH = `H1 + `H2
    hash = `BX0 -> `H1 + `BX1 -> `H1

}
example blockSharedHeader is not allBlocksUnique for {
    BlockChain = `BC0
    BlockX = `BX0 + `BX1
    Header = `H1 + `H2
    header = `BX0 -> `H1 + `BX1 -> `H1
}
example blocksSharedTx is not allBlocksUnique for {
    BlockChain = `BC0
    BlockX = `BX0 + `BX1
    Transaction = `Tx1 + `Tx2
    blockTxs =  `BX1 -> `Tx1
}
// forces all headers to not share a timestamp, nonce, prevBlockHash or merkleRootHash
// headers can obviously have the same version or block size
pred allHeadersUnique {
    all h: Header {
        all oh: Header {
            h != oh => h.time != oh.time and h.nonce != oh.nonce and h.prevBlockHash != oh.prevBlockHash and h.merkleRootHash != oh.merkleRootHash
        }
    }
}
example headerSharedTimestamp is not allHeadersUnique for {
    Header = `H1 + `H2 
    TIME = `T1 + `T2 
    time = `H1 -> `T1 + `H2  -> `T1 
}

example headerSharedNonce is not allHeadersUnique for {
    Header = `H1 + `H2 
    NONCE = `N1 + `N2
    nonce = `H1 -> `N1 + `H2 -> `N1
}

example headerShareprevBlockHash is not allHeadersUnique for {
    Header = `H1 + `H2 
    HASH = `HS1 + `HS2
    prevBlockHash = `H1 -> `HS1 + `H2 -> `HS1
}

example headerShareMerkleRootHash is not allHeadersUnique for {
    Header = `H1 + `H2 
    HASH = `HS1 + `HS2
    merkleRootHash = `H1 -> `HS1 + `H2 -> `HS1
}

// check that the block is legally part of a blockchain
pred blockInAChainLegally[currBlock: BlockX, chain: BlockChain] {
    // check that it points to another block and another block points to it
    currBlock != chain.lastBlock => {
        some nextBlock: BlockX {
            nextBlock.header.prevBlockHash = currBlock.hash
            nextBlock in chain.allBlocks
        } 
    }
    // also checks that the block is in BlockChain.allBlocks
    currBlock in chain.allBlocks
}
// forces all blocks to be in a chain
pred allBlocksInAChain {
    // checks that every block is part of some blockchain
    // currently only have one blockchain so all blocks must be in that chain
    all b: BlockX {
        some bc: BlockChain {
            blockInAChainLegally[b, bc]
        }
    }
    // all blocks in a chain must have the same version
    // currently only have one blockchain so we set all block versions to be 1
    all bc: BlockChain {
        all b: BlockX {
            b in bc.allBlocks => b.header.version = 1
        }
    }
}

example notAllBlocksInChain is not allBlocksInAChain for {
    BlockX = `BX1 + `BX2 
    BlockChain = `BC1 + `BC2 + `BC3
    allBlocks = `BC1 -> `BX1 + `BC2 -> `BX2
}
// a block is added to the chain IFF a majority of miners vote for the block
// a miner votes for the block when all txs in block are also in miner's network
pred consensus[block: BlockX] {
    #{m: Miner | m in Miners.allMiners and (block.blockTxs in m.network.networkTxs)} >= add[divide[#{m: Miner | m in Miners.allMiners}, 2], 1]
}

// labels if block is approved or not and enumerates votes
pred allBlocksObeyConsensus {
    all b: BlockX {
        // if a block reaches consensus, it is marked as approved, else not approved
        consensus[b] iff b.approved = 1
        not consensus[b] iff b.approved = 0
        // set number of votes
        b.votes = #{m: Miner | m in Miners.allMiners and (b.blockTxs in m.network.networkTxs)}
    }
}

// forces all blocks to contain a transaction
pred allBlocksHaveTransactions {
    all b: BlockX {
        // block must have at least 1 transaction from some P2PNetwork
        some tx: Transaction {
            tx in b.blockTxs
        }
        // all transactions in a block must be from the same P2PNetwork
        some n: P2PNetwork | {
            all tx: Transaction {
                tx in b.blockTxs => tx in n.networkTxs
            }
        }
    }
}

example notAllBlocksHaveTx is not allBlocksHaveTransactions for {
    BlockX = `BX1 + `BX2
    Transaction = `Tx1 + `Tx2 
    blockTxs = `BX1 -> `Tx1
}
pred wellformedBlocks {
    allBlocksUnique
    allHeadersUnique
    allBlocksInAChain
    allBlocksObeyConsensus
    allBlocksHaveTransactions
}