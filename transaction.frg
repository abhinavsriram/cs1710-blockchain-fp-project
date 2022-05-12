#lang forge

open "common.frg"

pred wellformedCoins {
    all c: Coin {
        // all coins must be present in Minted.coins
        c in Minted.coins
        // all coins must be spent or unspent
        c.spent = 1 or c.spent = 0
    }
    // all coins must be present in only one input or one output
    all c: Coin | all disj i1, i2: Input | c in i1.inputCoins => c not in i2.inputCoins
    all c: Coin | all disj o1, o2: Output | c in o1.outputCoins => c not in o2.outputCoins
    all c: Coin | all i: Input, o: Output | c in i.inputCoins => c not in o.outputCoins
}

// One spent coin
example oneCoin is wellformedCoins for {
    Coin = `C0
    spent = `C0 -> 1
    Input = `I0
    inputCoins = `I0 -> `C0
}

// One coin with an invalid spent value
example invalidSpent is not wellformedCoins for {
    Coin = `C0
    spent = `C0 -> 2
    Input = `I0
    inputCoins = `I0 -> `C0
}

// One coin in more than one input
example invalidTwoInput is not wellformedCoins for {
    Coin = `C0
    spent = `C0 -> 2
    Input = `I0 + `I1
    inputCoins = `I0 -> `C0 + `I1 -> `C0
}

// Input is valid if all coins in Input.inputCoins are present in Minted and spent
pred validInput[input: Input] {
    // there must be at least 1 coin present in an Input
    #{c: Coin | c in input.inputCoins} >= 1
    // all coins in Input.inputCoins are present in Minted
    input.inputCoins in Minted.coins
    // all coins in Input.inputCoins are spent
    all c: input.inputCoins {
        c.spent = 1
    }
}

// One valid input
example oneInput is {all i: Input | validInput[i]} for {
    Coin = `C0
    Minted = `M0
    Input = `I0

    spent = `C0 -> 1
    coins = `M0 -> `C0
    inputCoins = `I0 -> `C0
}

// One invalid input, because it has no coin
example oneInvalidInput is not {all i: Input | validInput[i]} for {
    Coin = `C0
    Minted = `M0
    Input = `I0

    spent = `C0 -> 1
    coins = `M0 -> `C0
    inputCoins = `I0 -> none
}

// Output is valid if all coins in Output.outputCoins are present in Minted and not spent
pred validOutput[output: Output] {
    // there must be at least 1 coin present in an Output
    #{c: Coin | c in output.outputCoins} >= 1
    // all coins in Output.outputCoins are present in Minted
    output.outputCoins in Minted.coins
    // all coins in Output.outputCoins are unspent
    all c: output.outputCoins {
        c.spent = 0
    }
}

// One valid output
example oneOutput is {all o: Output | validOutput[o]} for {
    Coin = `C0
    Minted = `M0
    Output = `O0

    spent = `C0 -> 0
    coins = `M0 -> `C0
    outputCoins = `O0 -> `C0
}

// One invalid input, because the coin is not minted
example oneInvalidOutput is not {all o: Output | validOutput[o]} for {
    Coin = `C0
    Minted = `M0
    Output = `O0

    spent = `C0 -> 0
    coins = `M0 -> none
    outputCoins = `O0 -> `C0
}

pred wellformedInputs {
    // wellformed inputs are those that are valid
    all i: Input {
        validInput[i]
    }
    // wellformed inputs are present in at most 1 transaction
    all i: Input | all disj tx1, tx2 : Transaction | i in tx1.inputs => i not in tx2.inputs
}

// Two inputs in separate transactions
example wellformedTwoInputs is wellformedInputs for {
    Coin = `C0 + `C1
    Minted = `M0
    Input = `I0 + `I1
    Transaction = `T0 + `T1

    spent = `C0 -> 1 + `C1 -> 1
    coins = `M0 -> `C0 + `M0 -> `C1
    inputCoins = `I0 -> `C0 + `I1 -> `C1
    inputs = `T0 -> `I0 + `T1 -> `I1
}

// One otherwise valid input is in two transactions
example malformedSharedInput is not wellformedInputs for {
    Coin = `C0
    Minted = `M0
    Input = `I0
    Transaction = `T0 + `T1

    spent = `C0 -> 1
    coins = `M0 -> `C0
    inputCoins = `I0 -> `C0
    inputs = `T0 -> `I0 + `T1 -> `I0
}

pred wellformedOutputs {
    // wellformed outputs are those that are valid
    all o: Output {
        validOutput[o]
    }
    // wellformed outputs are present in at most 1 transaction
    all o: Output | all disj tx1, tx2 : Transaction | o in tx1.outputs => o not in tx2.outputs
}

// Two outputs in separate transactions
example wellformedTwoOutputs is wellformedOutputs for {
    Coin = `C0 + `C1
    Minted = `M0
    Output = `O0 + `O1
    Transaction = `T0 + `T1

    spent = `C0 -> 0 + `C1 -> 0
    coins = `M0 -> `C0 + `M0 -> `C1
    outputCoins = `O0 -> `C0 + `O1 -> `C1
    outputs = `T0 -> `O0 + `T1 -> `O1
}

// One otherwise valid output is in two transactions
example malformedSharedOutput is not wellformedOutputs for {
    Coin = `C0
    Minted = `M0
    Output = `O0
    Transaction = `T0 + `T1

    spent = `C0 -> 0
    coins = `M0 -> `C0
    outputCoins = `O0 -> `C0
    outputs = `T0 -> `O0 + `T1 -> `O0
}

// good transactions are ones where 
pred goodTransaction[tx: Transaction, block: BlockX] {
    // no other transaction on that block has the same inputs and/or outputs
    all otherTx: block.blockTxs | otherTx != tx => (tx.inputs != otherTx.inputs and tx.outputs != otherTx.outputs)
    // there is at least one input and one output
    #{i: Input | i in tx.inputs} >= 1
    #{o: Output | o in tx.outputs} >= 1
    // these inputs and outputs are valid
    all i: tx.inputs | validInput[i]
    all o: tx.outputs | validOutput[o]
}

// Two good transactions
example twoGoodTransaction is {all tx: Transaction, block: BlockX | tx in block.blockTxs => goodTransaction[tx, block]} for {
    Coin = `C0 + `C1 + `C2 + `C3
    Minted = `M0
    Input = `I0 + `I1
    Output = `O0 + `O1
    Transaction = `T0 + `T1
    BlockX = `B0

    blockTxs = `B0 -> `T0 + `B0 -> `T1

    spent = `C0 -> 1 + `C1 -> 1 + `C2 -> 0 + `C3 -> 0
    coins = `M0 -> `C0 + `M0 -> `C1 + `M0 -> `C2 + `M0 -> `C3
    inputCoins = `I0 -> `C0 + `I1 -> `C1
    outputCoins = `O0 -> `C2 + `O1 -> `C3
    inputs = `T0 -> `I0 + `T1 -> `I1
    outputs = `T0 -> `O0 + `T1 -> `O1
}

// Two transactions on the same block share an input
example twoTransactionShareInput is not {all tx: Transaction, block: BlockX | tx in block.blockTxs => goodTransaction[tx, block]} for {
    Coin = `C0 + `C2 + `C3
    Minted = `M0
    Input = `I0
    Output = `O0 + `O1
    Transaction = `T0 + `T1
    BlockX = `B0

    blockTxs = `B0 -> `T0 + `B0 -> `T1

    spent = `C0 -> 1 + `C2 -> 0 + `C3 -> 0
    coins = `M0 -> `C0 + `M0 -> `C2 + `M0 -> `C3
    inputCoins = `I0 -> `C0
    outputCoins = `O0 -> `C2 + `O1 -> `C3
    inputs = `T0 -> `I0 + `T1 -> `I0
    outputs = `T0 -> `O0 + `T1 -> `O1
}

// Transaction doesn't have an output
example transactionMissingOutput is not {all tx: Transaction, block: BlockX | tx in block.blockTxs => goodTransaction[tx, block]} for {
    Coin = `C0
    Minted = `M0
    Input = `I0
    Transaction = `T0
    BlockX = `B0

    blockTxs = `B0 -> `T0

    spent = `C0 -> 1
    coins = `M0 -> `C0
    inputCoins = `I0 -> `C0
    outputCoins = `O0 -> none
    inputs = `T0 -> `I0
    outputs = `T0 -> none
}

// if any of the above condiitons are violated, then it is a bad transaction
pred badTransaction[tx: Transaction, block: BlockX] {
    not goodTransaction[tx, block]
}

// a transaction should only be contained in one block 
pred allTransactionsOnlyInOneBlock {
    all tx: Transaction | all disj b1, b2 : BlockX | tx in b1.blockTxs => tx not in b2.blockTxs
}

// every transaction must either be good or bad
pred allTransactionsGoodOrBad {
    all tx: Transaction, b: BlockX {
        goodTransaction[tx, b] or badTransaction[tx, b]
    }
}

// all transactions must be in some network
pred allTransactionsInSomeNetwork {
    all tx: Transaction | {
        some n: P2PNetwork {
            tx in n.networkTxs
        }
    }
}

pred wellformedTransactions {
    wellformedCoins
    wellformedInputs
    wellformedOutputs
    allTransactionsGoodOrBad
    allTransactionsOnlyInOneBlock
    allTransactionsInSomeNetwork
}