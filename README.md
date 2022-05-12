# README

## The Model

### What are we modeling?
We are modeling a blockchain. Blockchains are inherently very complex due to the complete transparency they offer while being completely decentralized and yet simultaneously having strong security and consensus guarantees that are yet to fail (for major blockchains). However, many of these protocols make tradeoffs in order to achieve this; these tradeoffs range from high transaction fees to massive energy usage due to PoW consensus approaches etc. As we try to combat these negative externalities of a system with otherwise great promise, there is innovation everywhere; and sometimes not nearly enough time to verify new approaches (especially for consensus) leading to implementation without confirmation and thus investment of real money prematurely which, in the worst case scenario, ultimately results in the common man losing their assets simply because they wanted to support something that could change the world. A perfect example of this is the "bank run" that just took place (May 12 2022) on UST that caused the inevtiable death spiral that was proven as a flaw of the LUNA/Terra ecosystem architecture months after the market cap of its stable coin token was in the billions. Now, hundreds of thousands of people have lost money, some of whom have lost everything, simply because their model was not formally verified prior to being built. This would be the best way to summarize our interest in this topic.

### What are our goals?
Modeling blockchains is an interesting topic for this specific class especially given the limitations of Forge because there will be significant abstraction. However, at the same time, because we had no way of estimating how much effort the entire modeling process would be, we wanted to create a model that was sufficiently detailed and extensible that it could be used to verify a wide range of properties if we had the time to do so. I think it will be clear that we struck this balance well, and potentially even erred a little too much on the side of the latter if you look at the number of sigs we have.

At a very minimum, what we were aiming for, was to generate traces of the chain building process, show coins not being double spent, miners receiving transactions, adding transactions to blocks, and verifying via distributed consensus. We also wanted to model a 51% attack on a blockchain and to specifically show that for such an attack to be successful, we did not just need a 51% majority of bad miners, but a 51% majority of coordinated bad miners. We were able to achieve these goals.

### How do you understand our Forge specification/code?
We have documented our modeling choices in detail using in-line comments in every single file. common.frg covers the various sigs we have defined for our model, and next to each sig we mention the frg file in which the sig is constrained. block.frg, blockchain.frg, hash.frg, miner.frg, network.frg, and transaction.frg constrain the various sigs we have defined and have a final wellformed predicate that encompasses every constraint on the respective sig. chainbuilder.frg describes traces of the chain building process, security.frg describes a 51% attack, and lastly, demonstration.frg has 2 run statements showing both the normal functioning of a blockchain as well as a 51% attack on a blockchain.

## Abstraction Choices, Understanding Instances and The Visualizer
The visualizer is a core part of our project (as you will see from it being close to 45% of our codebase). Without the visualizer, understanding instances is virtually impossible. The visualizer is also quite extensive and works for any trace generated using the predicates in chainbuilder.frg. However, one thing to note is that since our visualizer is so extensive and has so many elements, it will not look as intended and will be hard to understand unless you zoom out to 50% (or less) on most screens. After zooming out (using CTRL/CMD -) you can pinch to zoom on your trackpad to get a better look. Once each state in the trace should look like the example below, you have zoomed out sufficiently.

![alt text](https://raw.githubusercontent.com/abhinavsriram/cs1710-blockchain-fp-project/main/blockchain.png)

If you use the first run statement in demonstration.frg, it will produce 3 timesteps showing a blockchain being built, the above screenshot is an example from the last timestep of that run statement. 

#### The Blocks
You will see that the blockchain consists of blocks (BlockX), "chained" together. Each block has a block header (Header), set of transactions (Transaction) and a block hash (HASH). The block header contains a version (which serves no purpose in our models, but could be helpful when modeling blockchains with hard forks like Ethereum), the time at which it was created, its NONCE, the block size, the previous block hash (which will be blank for the first block) and a merkle root hash (which again, serves no purpose in our models but could be useful for more advanced verification). The set of transactions is exactly what you expect and the block hash is unique to each block. 

#### Consensus
Each block in the above picture also has a box that says "Approved With 4 of 7 Votes". This box must always say "Approved" for any block on the blockchain. When a block says "Approved" it means miners have reached consensus on that block and have agreed to add it to the chain. If a block ever says "Not Approved" and is part of the chain then our model is broken. This box also shows how many votes the block recieved. In this case, the block received 4 votes out of a possible 7, all 4 votes are from the good miners. A block is added to the chain IFF a majority of miners vote for the block and a miner votes for the block when all the transactions in the block are also in the miner's network.

#### The Peer to Peer (P2P) Networks and Miners
In the above screenshot, there is one Good P2P Network and one Bad P2P Network. P2P Networks are either Good P2P Networks or Bad P2P Networks and there is only ever one Good P2P Network but there can be an arbitrary number of Bad P2P Networks. A good miner is a miner who receives their transactions from the Good P2P Network and a bad miner is one who receives their transactions from a Bad P2P Network. This is one of our biggest abstraction choices. 

So why did we decide to have one Good P2P Network but an arbitrary number of Bad P2P Networks? and why did we decide to classify miners as good or bad based on their network? This was specifically to demonstrate that for a 51% attack to be successful, we did not just need a 51% majority of bad miners, but a 51% majority of coordinated bad miners. This is a very important distinction that we wanted to clearly highlight. The security of a blockchain is guaranteed only because, while one (a pessimist) could make the argument that there are always more bad actors than there are good in the world, it is very hard to rationally make the claim that all bad actors agree on what their evil goal is. On the other hand, honesty is very clearly defined, at least in the context of blockchains, so all good actors/miners have the same goal and perform the same actions so they all are part of the same P2P Network, and there is only one truth hence only one Good P2P Network. While, bad actors may have any number of evil goals and will likely organize themselves into groups based on their goals (I can only speculate here) and so it would make sense to have an arbitrary number of Bad P2P Networks.

What exactly qualifies a P2P Network as a Good P2P Network or a Bad P2P Network? This is not just a value judgement, though that is certainly sufficient to qualify a network, but Good P2P Networks are defined as those that consist exclusively of good transactions while Bad P2P Networks consist of good and/or bad transactions. What makes a transaction good or bad? More on that below.

We also felt like this was an abstraction but at the same time reflected what happens in the real world pretty accurately. Miners do in fact receive their transactions from a peer to peer network, but this peer to peer network is singular (broadly) and it is up to Miners to distinguish between good and bad transactions and they generally do this by organizing themselves into mining pools but we did not want to call our network abstraction a mining pool abstraction because if we did, there would be further implications, and thus complications we did not want to deal with.

#### Transactions and Coins



#### The Minted Coins

## Tests, Verification and Limitations

