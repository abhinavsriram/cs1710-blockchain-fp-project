function makeBlockDiv(fblock) {
    var block = document.createElement("div")
    block.style.width = "150px"
    block.style.height = "380px"
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

function makeTransactionsDiv(blockTransactions) {
    var txs = document.createElement("div")
    txs.style.width = "130px"
    txs.style.height = "185px"
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

    txsDiv = makeTransactionsDiv(blockTransactions)
    blockDiv.append(txsDiv)

    blockHashDiv = makeBlockHashDiv(blockHash)
    blockDiv.append(blockHashDiv)

    return blockDiv
}

function createBlockChain(state) {
    blockChainContainer = document.createElement("div")
    blockChainContainer.style.width = "100%"
    blockChainContainer.style.height = "400px"
    blockChainContainer.style.margin = "5px"
    blockChainContainer.style.display = "flex"
    blockChainContainer.style['flex-direction'] = "column"

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

function createStateDiv(state) {
    outerDiv = document.createElement("div")
    outerDiv.innerHTML = "<h1> " + "Blockchain State at Timestep " + state.toString()[state.toString().length - 1] + "</h1>"
    outerDiv.style.display = "flex"
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
    outerDiv.append(innerDiv)
    return outerDiv
}

function createStates() {
    scrollableStates = document.createElement("div")
    scrollableStates.style.overflow = "scroll"
    scrollableStates.style.width = "100%"
    scrollableStates.style.height = "1500px"
    scrollableStates.style.margin = "5px"
    for (const ind in TIME.tuples()) {
        const state = TIME.tuples()[ind]
        scrollableStates.append(createStateDiv(state))
    }
    div.append(scrollableStates)
}

div.replaceChildren()
createStates()