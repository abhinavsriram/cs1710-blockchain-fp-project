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

// Input is valid if all coins in Input.inputCoins are present in Minted and spent
pred validInput[input: Input] {
    // there must be at least 1 coin present in an Input
    #{c: Coin | c in input.inputCoins} > 1
    // all coins in Input.inputCoins are present in Minted
    input.inputCoins in Minted.coins
    // all coins in Input.inputCoins are spent
    all c: input.inputCoins {
        c.spent = 1
    }
}

// Output is valid if all coins in Output.outputCoins are present in Minted and not spent
pred validOutput[output: Output] {
    // there must be at least 1 coin present in an Output
    #{c: Coin | c in output.outputCoins} > 1
    // all coins in Output.outputCoins are present in Minted
    output.outputCoins in Minted.coins
    // all coins in Output.outputCoins are unspent
    all c: output.outputCoins {
        c.spent = 0
    }
}

pred wellformedInputs {
    // wellformed inputs are those that are valid
    all i: Input {
        validInput[i]
    }
    // wellformed inputs are present in at most 1 transaction
    all i: Input | all disj tx1, tx2 : Transaction | i in tx1.inputs => i not in tx2.inputs
}

pred wellformedOutputs {
    // wellformed outputs are those that are valid
    all o: Output {
        validOutput[o]
    }
    // wellformed outputs are present in at most 1 transaction
    all o: Output | all disj tx1, tx2 : Transaction | o in tx1.outputs => o not in tx2.outputs
}

// good transactions are ones where 
pred goodTransaction[tx: Transaction, block: BlockX] {
    // no other transaction on that block has the same inputs and/or outputs
    all otherTx: block.blockTxs | otherTx != tx => (tx.inputs != otherTx.inputs and tx.outputs != otherTx.outputs)
    // there is at least one input and one output
    #{i: Input | i in tx.inputs} > 1
    #{o: Output | o in tx.outputs} > 1
    // these inputs and outputs are valid
    all i: tx.inputs | validInput[i]
    all o: tx.outputs | validOutput[o]
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