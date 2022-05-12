#lang forge

open "common.frg"

// helper pred that encodes all possible hash combinations between two blocks that need to be unique
// Each of the two blocks have 3 hashes, meaning we have 3^3 = 9 combinations between the two blocks 
// Not counting combinations within the same block
// 2 combinations are allowed
pred uniqueCombinations[b: BlockX, ob: BlockX] {
    // 1
    b.hash != ob.hash
    // 2
    b.hash != ob.header.merkleRootHash
    // 3 This is a possible combination, but it is allowed 
    // b.hash != ob.header.prevBlockHash
    // 4
    b.header.merkleRootHash != ob.hash
    // 5
    b.header.merkleRootHash != ob.header.prevBlockHash
    // 6
    b.header.merkleRootHash != ob.header.merkleRootHash
    // 7
    b.header.prevBlockHash != ob.header.prevBlockHash
    // 8
    b.header.prevBlockHash != ob.header.merkleRootHash
    // 9 This is a possible combination, but is is allowed
    // b.header.prevBlockHash != ob.hash
}

// Helper pred that states all hashes within the same block need to be unique
// There are 3 hashes, so there are 3 choose 2 = 3 combinations
pred uniqueInBlock[b: BlockX] {
    b.header.merkleRootHash != b.header.prevBlockHash
    b.header.prevBlockHash != b.hash
    b.header.merkleRootHash != b.hash
}

// ensure that every single hash being used in our blockchain is unique
// this predicate is certainly repeating constraints from block.frg and blockchain.frg
// but we preferred to be thorough and hence listed all possible combinations
pred allHashesUnique {
    all b: BlockX {
        // Block cannot share hashes with itself
        uniqueInBlock[b]

        all ob: BlockX {
            // Block cannot share hashes with other blocks
            b != ob => uniqueCombinations[b, ob]
        }
    }
}

// One block has all unique hashes
example uniqueOne is allHashesUnique for {
    BlockX = `BX0
    Header = `H0
    HASH = `HASH0 + `HASH1 + `HASH2

    header = `BX0 -> `H0
    prevBlockHash = `H0 -> `HASH0
    merkleRootHash = `H0 -> `HASH1
    hash = `BX0 -> `HASH2
}

// One block has repeated hashes with itself
example notUniqueOne is not allHashesUnique for {
    BlockX = `BX0
    Header = `H0
    HASH = `HASH0 + `HASH1 + `HASH2

    header = `BX0 -> `H0
    prevBlockHash = `H0 -> `HASH0
    merkleRootHash = `H0 -> `HASH1
    hash = `BX0 -> `HASH1
}

// Multiple blocks have one shared hash (block hash) that is not allowed
example notUniqueTwo is not allHashesUnique for {
    BlockX = `BX0 + `BX1
    Header = `H0 + `H1
    HASH = `HASH0 + `HASH1 + `HASH2 + `HASH3 + `HASH4

    header = `BX0 -> `H0 + `BX1 -> `H1
    prevBlockHash = `H0 -> `HASH0 + `H1 -> `HASH3
    merkleRootHash = `H0 -> `HASH1 + `H1 -> `HASH4
    hash = `BX0 -> `HASH2 + `BX1 -> `HASH2
}

// Multiple blocks with no shared hashes
example uniqueTwo is allHashesUnique for {
    BlockX = `BX0 + `BX1
    Header = `H0 + `H1
    HASH = `HASH0 + `HASH1 + `HASH2 + `HASH3 + `HASH4 + `HASH5

    header = `BX0 -> `H0 + `BX1 -> `H1
    prevBlockHash = `H0 -> `HASH0 + `H1 -> `HASH3
    merkleRootHash = `H0 -> `HASH1 + `H1 -> `HASH4
    hash = `BX0 -> `HASH2 + `BX1 -> `HASH5
}

// It is allowed that a block has another block's hash as its prevBlockHash
example hashPrevBlockHash is allHashesUnique for {
    BlockX = `BX0 + `BX1
    Header = `H0 + `H1
    HASH = `HASH0 + `HASH1 + `HASH2 + `HASH3 + `HASH4 + `HASH5

    header = `BX0 -> `H0 + `BX1 -> `H1
    prevBlockHash = `H0 -> `HASH0 + `H1 -> `HASH2
    merkleRootHash = `H0 -> `HASH1 + `H1 -> `HASH4
    hash = `BX0 -> `HASH2 + `BX1 -> `HASH5
}

pred wellformedHashes {
    allHashesUnique
}