function makeBlockDiv(fblock) {
    var block = document.createElement("div")
    block.style.width = "150px"
    block.style.height = "445px"
    block.style.border = "thin solid black"
    block.style.display = "flex"
    block.style.margin = "5px"
    block.style.padding = "3px"
    block.style['flex-direction'] = "column"
    block.style['font-size'] = "12px"
    block.style['align-items'] = "center"
    block.style['justify-content'] = "center"
    block.innerHTML = "Block " + fblock.toString()[fblock.toString().length - 1]
    return block
}

function makeHeaderDiv(blockHeader) {
    var header = document.createElement("div")
    header.style.width = "130px"
    header.style.height = "110px"
    header.style.border = "thin solid black"
    header.style.display = "flex"
    header.style.margin = "5px"
    header.style.padding = "3px"
    header.style['flex-direction'] = "column"
    header.style['font-size'] = "8px"

    var blockHeaderNameDiv = document.createElement("div")
    blockHeaderNameDiv.style.width = "auto"
    blockHeaderNameDiv.style.height = "auto"
    blockHeaderNameDiv.style.border = "thin solid black"
    blockHeaderNameDiv.style.display = "flex"
    blockHeaderNameDiv.style.margin = "5px"
    blockHeaderNameDiv.style.padding = "3px"
    blockHeaderNameDiv.style['align-items'] = "center"
    blockHeaderNameDiv.style['justify-content'] = "center"
    blockHeaderNameDiv.append("Block Header")
    header.append(blockHeaderNameDiv)

    var versionDiv = document.createElement("div")
    versionDiv.append("Version: " + blockHeader.join(version) + "\n")
    header.append(versionDiv)

    var timeDiv = document.createElement("div")
    timeDiv.append("Created at: " + blockHeader.join(time) + "\n")
    header.append(timeDiv)

    var nonceDiv = document.createElement("div")
    nonceDiv.append("Nonce: " + blockHeader.join(nonce) + "\n")
    header.append(nonceDiv)

    var blockSizeDiv = document.createElement("div")
    blockSizeDiv.append("Block Size: " + blockHeader.join(blocksize) + "\n")
    header.append(blockSizeDiv)

    var prevHashDiv = document.createElement("div")
    prevHashDiv.append("Prev Block Hash: " + blockHeader.join(prevBlockHash) + "\n")
    header.append(prevHashDiv)

    var merkleHashDiv = document.createElement("div")
    merkleHashDiv.append("Merkle Root Hash: " + blockHeader.join(merkleRootHash) + "\n")
    header.append(merkleHashDiv)

    return header
}

function makeApprovalDiv(blockApproved, blockVotes) {
    var approval = document.createElement("div")
    approval.style.width = "130px"
    approval.style.height = "20px"
    approval.style.border = "thin solid black"
    approval.style.display = "flex"
    approval.style.margin = "5px"
    approval.style.padding = "3px"
    approval.style['flex-direction'] = "column"
    approval.style['font-size'] = "8px"
    var blockApprovedFormatted = "Not"
    if (blockApproved == 1) {
        blockApprovedFormatted = ""
    }
    approval.append(blockApprovedFormatted + " Approved With " + blockVotes + " of " + Miners.join(allMiners).tuples().length + " Votes")
    return approval
}

function makeTransactionsDiv(blockTransactions) {
    var txs = document.createElement("div")
    txs.style.width = "130px"
    txs.style.height = "215px"
    txs.style.border = "thin solid black"
    txs.style.display = "flex"
    txs.style.margin = "5px"
    txs.style.padding = "3px"
    txs.style['flex-direction'] = "column"
    txs.style['font-size'] = "8px"

    var txNameDiv = document.createElement("div")
    txNameDiv.style.width = "auto"
    txNameDiv.style.height = "auto"
    txNameDiv.style.border = "thin solid black"
    txNameDiv.style.display = "flex"
    txNameDiv.style.margin = "5px"
    txNameDiv.style.padding = "3px"
    txNameDiv.style['align-items'] = "center"
    txNameDiv.style['justify-content'] = "center"
    txNameDiv.append("Transactions")
    txs.append(txNameDiv)

    for (const tx in blockTransactions.tuples()) {
        var txDiv = document.createElement("div")
        txDiv.append(blockTransactions.tuples()[tx] + '\n')
        txs.append(txDiv)
    }
    return txs
}

function makeBlockHashDiv(blockHash) {
    var hash = document.createElement("div")
    hash.style.width = "130px"
    hash.style.height = "20px"
    hash.style.border = "thin solid black"
    hash.style.display = "flex"
    hash.style.margin = "5px"
    hash.style.padding = "3px"
    hash.style['flex-direction'] = "column"
    hash.style['font-size'] = "8px"
    hash.append("Block Hash: " + blockHash + "\n")
    return hash
}

function makeBlock(block) {
    const blockHash = block.join(hash)
    const blockHeader = block.join(header)
    const blockTransactions = block.join(blockTxs)
    const blockVotes = block.join(votes)
    const blockApproved = block.join(approved)

    blockDiv = makeBlockDiv(block)

    headerDiv = makeHeaderDiv(blockHeader)
    blockDiv.append(headerDiv)
    
    approvalDiv = makeApprovalDiv(blockApproved, blockVotes)
    blockDiv.append(approvalDiv)

    txsDiv = makeTransactionsDiv(blockTransactions)
    blockDiv.append(txsDiv)

    blockHashDiv = makeBlockHashDiv(blockHash)
    blockDiv.append(blockHashDiv)

    return blockDiv
}

function createBlockChain(state) {
    blockChainContainer = document.createElement("div")
    blockChainContainer.innerHTML = "Blocks"
    blockChainContainer.style.width = "100%"
    blockChainContainer.style.height = "450px"
    blockChainContainer.style.margin = "5px"
    blockChainContainer.style.display = "flex"
    blockChainContainer.style['flex-direction'] = "column"
    blockChainContainer.style['margin-bottom'] = "30px"

    blockChainDiv = document.createElement("div")
    blockChainContainer.append(blockChainDiv)
    blockChainDiv.style.display = "flex"
    blockChainDiv.style['flex-direction'] = "row"
    blockChainDiv.style['flex-wrap'] = "wrap"

    for (const ind in state.join(blockchain).join(allBlocks).tuples()) {
        const block = state.join(blockchain).join(allBlocks).tuples()[ind]
        blockChainDiv.append(makeBlock(block))
    }
    
    return blockChainContainer
}

function makeMiner(miner) {
    newMiner = document.createElement("div")
    newMiner.style.width = "40px"
    newMiner.style.height = "58px"
    newMiner.style.display = "flex"
    newMiner.style.margin = "10px"
    newMiner.style['flex-direction'] = "column"
    newMiner.style['font-size'] = "8px"
    newMiner.style['align-items'] = "center"
    newMiner.style['justify-content'] = "center"

    const minerHatImageURL = "https://thumbs.dreamstime.com/b/mining-helmet-lamp-vector-illustration-6109854.jpg"
    const minerHatImage = document.createElement("img")
    minerHatImage.src = minerHatImageURL
    minerHatImage.style.width = '100%'
    minerHatImage.style.height = '80%'
    minerHatImage.style['margin-top'] = "2px"
    minerHatImage.style['margin-bottom'] = "2px"
    minerHatImage.style.padding = "2px"
    newMiner.append(minerHatImage)

    const minerNameDiv = document.createElement("div")
    minerNameDiv.style.margin = "5px"
    minerNameDiv.innerHTML = "Miner " + miner.toString()[miner.toString().length - 1]
    newMiner.append(minerNameDiv)
    
    return newMiner
}

function createMiners() {
    minerContainer = document.createElement("div")
    minerContainer.innerHTML = "Miners"
    minerContainer.style.height = "100px"
    minerContainer.style.margin = "5px"
    minerContainer.style.display = "flex"
    minerContainer.style['flex-direction'] = "column"

    minerDiv = document.createElement("div")
    minerContainer.append(minerDiv)
    minerDiv.style.display = "flex"
    minerDiv.style['flex-direction'] = "row"
    minerDiv.style['flex-wrap'] = "wrap"

    for (const ind in Miners.join(allMiners).tuples()) {
        const miner = Miners.join(allMiners).tuples()[ind]
        minerDiv.append(makeMiner(miner))
    }

    return minerContainer
}

function makeTxNameDiv(txName) {
    newTxNameDiv = document.createElement("div")
    newTxNameDiv.style['font-size'] = "8px"
    newTxNameDiv.innerHTML = "Transaction Name: " + txName
    return newTxNameDiv
}

function makeTxIDDiv(txID) {
    newTxIDDiv = document.createElement("div")
    newTxIDDiv.style['font-size'] = "8px"
    newTxIDDiv.innerHTML = "Transaction ID: " + txID
    return newTxIDDiv
}

function makeTxInputs(tx) {
    newTxInputDiv = document.createElement("div")
    newTxInputDiv.style['font-size'] = "8px"
    for (const ind in tx.join(inputs).tuples()) {
        const input = tx.join(inputs).tuples()[ind]
        var formattedInputString = input.toString()
        for (const ind2 in input.join(inputCoins).tuples()) {
            const coin = input.join(inputCoins).tuples()[ind2]
            if (formattedInputString == input.toString()) {
                formattedInputString += "(" + coin.toString()
            } else {
                formattedInputString += ", " + coin.toString()
            }
        }
        formattedInputString += ")"
        if (newTxInputDiv.innerHTML == "") {
            newTxInputDiv.innerHTML = "Inputs: " + formattedInputString
        } else {
            newTxInputDiv.innerHTML += formattedInputString
        }
    }
    return newTxInputDiv
}

function makeTxOutputs(tx) {
    newTxOutputDiv = document.createElement("div")
    newTxOutputDiv.style['font-size'] = "8px"
    for (const ind in tx.join(outputs).tuples()) {
        const input = tx.join(outputs).tuples()[ind]
        var formattedOutputString = input.toString()
        for (const ind2 in input.join(outputCoins).tuples()) {
            const coin = input.join(outputCoins).tuples()[ind2]
            if (formattedOutputString == input.toString()) {
                formattedOutputString += "(" + coin.toString()
            } else {
                formattedOutputString += ", " + coin.toString()
            }
        }
        formattedOutputString += ")"
        if (newTxOutputDiv.innerHTML == "") {
            newTxOutputDiv.innerHTML = "Outputs: " + formattedOutputString
        } else {
            newTxOutputDiv.innerHTML += formattedOutputString
        }
    }
    return newTxOutputDiv
}

function makeTransaction(tx) {
    newTxDiv = document.createElement("div")
    newTxDiv.style.width = "auto"
    newTxDiv.style.height = "auto"
    newTxDiv.style.border = "thin solid black"
    newTxDiv.style.display = "flex"
    newTxDiv.style.margin = "5px"
    newTxDiv.style.padding = "3px"
    newTxDiv.style['flex-direction'] = "column"
    newTxDiv.style['font-size'] = "8px"

    newTxDiv.append(makeTxNameDiv(tx.toString()))
    newTxDiv.append(makeTxIDDiv(tx.join(txID)))
    newTxDiv.append(makeTxInputs(tx))
    newTxDiv.append(makeTxOutputs(tx))

    return newTxDiv
}

function createTransactions() {
    transactionContainer = document.createElement("div")
    transactionContainer.innerHTML = "Transactions"
    transactionContainer.style.height = "100px"
    transactionContainer.style.margin = "5px"
    transactionContainer.style.display = "flex"
    transactionContainer.style['flex-direction'] = "column"

    for (const ind in GoodP2PNetwork.join(networkTxs).tuples()) {
        tx = GoodP2PNetwork.join(networkTxs).tuples()[ind]
        transactionContainer.append(makeTransaction(tx))
    }

    return transactionContainer
}

function createStateDiv(state) {
    outerDiv = document.createElement("div")
    outerDiv.innerHTML = "<h1> " + "Blockchain State at Timestep " + state.toString()[state.toString().length - 1] + "</h1>"
    outerDiv.style.display = "flex"
    outerDiv.style['flex-direction'] = "column"
    outerDiv.style.margin = "20px 5px"
    outerDiv.style.border = "medium solid black"
    outerDiv.style.padding = "5px"

    innerDiv = document.createElement("div")
    innerDiv.style.display = "flex"
    innerDiv.style['flex-direction'] = "row"
    innerDiv.style['flex-wrap'] = "wrap"
    innerDiv.append(createBlockChain(state))
    innerDiv.append(createMiners())
    innerDiv.append(createTransactions())
    outerDiv.append(innerDiv)
    return outerDiv
}

function createStates() {
    scrollableStates = document.createElement("div")
    scrollableStates.style.overflow = "scroll"
    scrollableStates.style.width = "100%"
    scrollableStates.style.height = "100%"
    scrollableStates.style.margin = "5px"
    for (const ind in TIME.tuples()) {
        const state = TIME.tuples()[ind]
        scrollableStates.append(createStateDiv(state))
    }
    div.append(scrollableStates)
}

div.replaceChildren()
createStates()