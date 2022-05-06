#lang forge

open "common.frg"

pred uniqueCombinations[b: BlockX, ob: BlockX] {
    b.header.prevBlockHash != ob.header.prevBlockHash 
    b.header.prevBlockHash != ob.header.merkleRootHash  
    b.header.prevBlockHash != b.hash
    b.header.prevBlockHash != b.header.merkleRootHash
    ob.header.prevBlockHash != b.header.prevBlockHash 
    ob.header.prevBlockHash != b.header.merkleRootHash  
    ob.header.prevBlockHash != ob.hash
    ob.header.prevBlockHash != ob.header.merkleRootHash
}

// ensure that every single hash being used is unique
pred allHashesUnique {
    all b: BlockX {
        all ob: BlockX {
            b != ob => uniqueCombinations[b, ob]
        }
    }
}