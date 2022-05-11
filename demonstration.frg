#lang forge

// opening all files
// opening all sigs
open "common.frg"
// basic building blocks of a blockchain
open "hash.frg"
open "block.frg"
open "miner.frg"
open "network.frg"
open "transaction.frg"
open "blockchain.frg"
// producing traces of blockchains being built
open "chainbuilder.frg"
// exposing security vulnerabilities of a blockchain
open "security.frg"

run {
    wellformedHashes
    wellformedBlocks
    wellformedMiners
    wellformedNetworks
    wellformedTransactions
    wellformedChain
    traces
    // we use a majority of GoodMiners to show business-as-usual operations
    businessAsUsual
} for exactly 3 TIME for { next is linear }

// run {
//     allHashesUnique
//     wellformedBlocks
//     wellformedMiners
//     wellformedNetworks
//     wellformedTransactions
//     wellformedChain
//     traces
//     // we use a majority of bad miners from the same network to show a 51% attack on the blockchain
//     majorityAttack
// } for exactly 3 TIME for { next is linear }