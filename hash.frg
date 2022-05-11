#lang forge

open "common.frg"

// helper pred that encodes all pssible hash combinations that need to be unique
pred uniqueCombinations[b: BlockX, ob: BlockX] {
    b.hash != ob.hash
    b.hash != ob.header.merkleRootHash
    b.hash != b.header.merkleRootHash
    b.hash != b.header.prevBlockHash
    b.header.merkleRootHash != b.hash
    b.header.merkleRootHash != ob.hash
    b.header.merkleRootHash != b.header.prevBlockHash
    b.header.merkleRootHash != ob.header.prevBlockHash
    b.header.merkleRootHash != ob.header.merkleRootHash
    b.header.prevBlockHash != b.hash
    b.header.prevBlockHash != b.header.merkleRootHash
    b.header.prevBlockHash != ob.header.prevBlockHash
    b.header.prevBlockHash != ob.header.merkleRootHash
    ob.hash != b.hash
    ob.hash != b.header.merkleRootHash
    ob.hash != ob.header.merkleRootHash
    ob.hash != ob.header.prevBlockHash
    ob.header.merkleRootHash != ob.hash
    ob.header.merkleRootHash != b.hash
    ob.header.merkleRootHash != ob.header.prevBlockHash
    ob.header.merkleRootHash != b.header.prevBlockHash
    ob.header.merkleRootHash != b.header.merkleRootHash
    ob.header.prevBlockHash != ob.hash
    ob.header.prevBlockHash != ob.header.merkleRootHash
    ob.header.prevBlockHash != b.header.prevBlockHash
    ob.header.prevBlockHash != b.header.merkleRootHash
}

// ensure that every single hash being used in our blockchain is unique
pred allHashesUnique {
    all b: BlockX {
        all ob: BlockX {
            b != ob => uniqueCombinations[b, ob]
        }
    }
}