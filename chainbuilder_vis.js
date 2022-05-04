function makeBlockDiv() {
    var block = document.createElement("div")
    block.style.width = "150px"
    block.style.height = "385px"
    block.style.border = "thin solid black"
    block.style.display = "flex"
    block.style.margin = "5px"
    block.style.padding = "3px"
    block.style['flex-direction'] = "column"
    block.style['font-size'] = "12px"
    return block
}

function makeHeaderDiv(blockHeader) {
    var header = document.createElement("div")
    header.style.width = "130px"
    header.style.height = "85px"
    header.style.border = "thin solid black"
    header.style.display = "flex"
    header.style.margin = "5px"
    header.style.padding = "3px"
    header.style['flex-direction'] = "row"
    header.style['font-size'] = "8px"
    headerDiv.append("block created at: " + blockHeader.join(time) + "\n")
    headerDiv.append("block nonce: " + blockHeader.join(nonce) + "\n")
    headerDiv.append("prev block hash: " + blockHeader.join(prevBlockHash) + "\n")
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
    txs.style['flex-direction'] = "row"
    txs.style['font-size'] = "8px"
    for (const tx in blockTransactions.tuples()) {
        txsDiv.append(blockTransactions.tuples()[tx] + '\n')
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
    hash.style['flex-direction'] = "row"
    hash.style['font-size'] = "8px"
    hash.append("block hash: " + blockHash + "\n")
    return hash
}

function makeBlock(block) {
    const blockHash = block.join(hash)
    const blockHeader = block.join(header)
    const blockTransactions = block.join(blockTxs)
    const blockVotes = block.join(votes)
    const blockApproved = block.join(approved)

    blockDiv = makeBlockDiv()
    blockDiv.innerHTML = "<h1> " + "Block " + block.toString()[block.toString().length - 1] + "</h1>"

    headerDiv = makeHeaderDiv(blockHeader)
    blockDiv.append(headerDiv)

    txsDiv = makeTransactionsDiv(blockTransactions)
    blockDiv.append(txsDiv)

    blockHashDiv = makeBlockHashDiv(blockHash)
    blockDiv.append(blockHashDiv)

    return blockDiv
}

function createBlockChain(state) {
    container = document.createElement("div")
    container.style.width = "100%"
    container.style.height = "400px"
    container.style.margin = "5px"
    container.style.padding = "5px"
    container.style.display = "flex"
    container.style['flex-direction'] = "column"

    blockChainDiv = document.createElement("div")
    container.append(blockChainDiv)
    blockChainDiv.style.display = "flex"
    blockChainDiv.style['flex-direction'] = "row"
    blockChainDiv.style['flex-wrap'] = "wrap"

    for (const ind in state.join(blockchain).join(allBlocks).tuples()) {
        const block = state.join(blockchain).join(allBlocks).tuples()[ind]
        blockChainDiv.append(makeBlock(block))
    }
    return container
}

function createStateDiv(state) {
    outCont = document.createElement("div")
    outCont.innerHTML = "<h1> " + "Blockchain State at Timestep " + state.toString()[state.toString().length - 1] + "</h1>"
    outCont.style.display = "flex"
    outCont.style.display = "flex"
    outCont.style['flex-direction'] = "column"
    outCont.style.margin = "20px 5px"
    outCont.style.border = "medium solid black"
    outCont.style.padding = "5px"

    divCont = document.createElement("div")
    divCont.style.display = "flex"
    divCont.style['flex-direction'] = "row"
    divCont.style['flex-wrap'] = "wrap"
    divCont.append(createBlockChain(state))
    outCont.append(divCont)
    return outCont
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