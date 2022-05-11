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

// generates a blockchain with 2 blocks being added over 3 timesteps
// we use a majority of GoodMiners to show business-as-usual operations
run {
    allHashesUnique
    wellformedBlocks
    wellformedMiners
    wellformedNetworks
    wellformedTransactions
    wellformedChain
    traces
} for exactly 3 TIME, exactly 1 GoodP2PNetwork, exactly 2 BadP2PNetwork, exactly 3 BadMiner, exactly 5 GoodMiner for { next is linear }

// shows a 51% attack on the blockchain
// run {
//     wellformedChain
//     allBlocksInAChain
//     traces
//     all b: BlockX | majorityAttack[b]
// } for exactly 3 TIME, 1 GoodMiner for { next is linear }