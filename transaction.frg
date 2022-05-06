#lang forge

// basic building blocks of a blockchain
open "common.frg"

// Input is valid if all coins in Input.inputCoins are present in Minted and not spent
pred validInput[input: Input] {
    #{c: Coin | c in input.inputCoins} >= 1
    input.inputCoins in Minted.coins
    all c: input.inputCoins {
        c.spent = 0 
    }
}

// Output is valid if all coins in Output.outputCoins are present in Minted and not spent
pred validOutput[output: Output] {
    #{c: Coin | c in output.outputCoins} >= 1
    output.outputCoins in Minted.coins
    all c: output.outputCoins {
        c.spent = 1
    }
}

// good transactions are ones where 
// no other transaction on that block has the same inputs and/or outputs
// there is at least one input and one output
// these inputs and outputs are valid
pred goodTransaction[tx: Transaction, block: BlockX] {
    all otherTx: block.blockTxs | otherTx != tx => (tx.inputs != otherTx.inputs and tx.outputs != otherTx.outputs)
    #{i: Input | i in tx.inputs} >= 1
    #{o: Output | o in tx.outputs} >= 1
    all i: tx.inputs | validInput[i]
    all o: tx.outputs | validOutput[o]
}

// if any of the above condiitons are violated, then it is a bad transaction
pred badTransaction[tx: Transaction, block: BlockX] {
    not goodTransaction[tx, block]
}

pred wellformedInputs {
    all i: Input {
        validInput[i]
    }
}

pred wellformedOutputs {
    all o: Output {
        validOutput[o]
    }
}

pred wellformedCoins {
    all c: Coin {
        c in Minted.coins
        c.spent = 1 or c.spent = 0
    }
}

pred wellformedTransactions {
    wellformedInputs
    wellformedOutputs
    wellformedCoins
    all tx: Transaction, b: BlockX {
        goodTransaction[tx, b]
        // goodTransaction[tx, b] or badTransaction[tx, b]
    }
}