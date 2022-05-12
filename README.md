# README

## The Model

### What are we modeling?
We are modeling a blockchain. Blockchains are inherently very complex due to the complete transparency they offer while being completely decentralized and yet simultaneously having strong security and consensus guarantees that are yet to fail (for major blockchains). However, many of these protocols make tradeoffs in order to achieve this; these tradeoffs range from high transaction fees to massive energy usage due to PoW consensus approaches etc. As we try to combat these negative externalities of a system with otherwise great promise, there is innovation everywhere; and sometimes not nearly enough time to verify new approaches (especially for consensus) leading to implementation without confirmation and thus investment of real money prematurely which, in the worst case scenario, ultimately results in the common man losing their assets simply because they wanted to support something that could change the world. A perfect example of this is the "bank run" that just took place (May 12 2022) on UST that caused the inevtiable death spiral that was proven as a flaw of the LUNA/Terra ecosystem architecture months after the market cap of its stable coin token was in the billions. Now, hundreds of thousands of people have lost money, some of whom have lost everything, simply because their model was not formally verified prior to being built. This would be the best way to summarize our interest in this topic.

### What is our objective with this model?
Modeling blockchains is an interesting topic for this specific class especially given the limitations of Forge because there will be significant abstraction. However, at the same time, because we had no way of estimating how much effort the entire modeling process would be, we wanted to create a model that was sufficiently detailed and extensible that it could be used to verify a wide range of properties if we had the time to do so. I think it will be clear that we struck this balance well, and potentially even erred a little too much on the side of the latter if you look at the number of sigs we have.

At a very minimum, what we were aiming for, was to generate traces of the chain building process, show coins not being double spent, miners receiving transactions, adding transactions to blocks, and verifying via distributed consensus. We also wanted to model a 51% attack on a blockchain and to specifically show that for such an attack to be successful, we did not just need a 51% majority of bad miners, but a 51% majority of coordinated bad miners. We were able to achieve these goals.

### How do you understand our Forge specification?
We have documented our modeling choices in detail using in-line comments in every single file. common.frg covers the various sigs we have defined for our model, and next to each sig we mention the frg file in which the sig is constrained. block.frg, blockchain.frg, hash.frg, miner.frg, network.frg, and transaction.frg constrain the various sigs we have defined and have a final wellformed predicate that encompasses every constraint on the respective sig. chainbuilder.frg describes traces of the chain building process, security.frg describes a 51% attack, and lastly, demonstration.frg has 2 run statements showing both the normal functioning of a blockchain as well as a 51% attack on a blockchain.

## Abstraction Choices

### What tradeoffs did you make in choosing your representation? What else did you try that didn’t work as well?

### What assumptions did you make about scope? What are the limits of your model?

### Did your goals change at all from your proposal? Did you realize anything you planned was unrealistic, or that anything you thought was unrealistic was doable?

## Understanding Instances and The Visualizer
The visualizer is a core part of our project. Without the visualizer, understanding instances is virtually impossible. The visualizer is also quite extensive and works for any trace generated using the predicates in chainbuilder.frg. However, one thing to note is that since our visualizer is so extensive and has so many elements, it will not look as intended and will be hard to understand unless you zoom out to 50% (or less) on most screens. After zooming out (using CTRL/CMD -) you can pinch to zoom on your trackpad to get a better look. Each state in the trace should look like this:

![alt text](https://raw.githubusercontent.com/abhinavsriram/cs1710-blockchain-fp-project/main/blockchain.png)

If you run the first run statement in demonstration.frg, it will produce 3 timesteps showing a blockchain being built, above is an example from the last timestep of that run statement. 

#### The Blocks
You will see that the blockchain consists of blocks (BlockX), "chained" together. Each block has a block header (Header), set of transactions (Transaction) and a block hash (HASH). The block header contains a version (which serves no purpose in our models, but could be helpful when modeling blockchains with hard forks like Ethereum), the time at which it was created, its NONCE, the block size, the previous block hash (which will be blank for the first block) and a merkle root hash (which again, serves no purpose in our models but could be useful for more advanced verification). The set of transactions is exactly what you expect and the block hash is unique to each block. 

#### Consensus
Each block in the above picture also has a box that says "Approved With 4 of 7 Votes". This box must always say "Approved" for any block on the blockchain. When a block says "Approved" it means miners have reached consensus on that block and have agreed to add it to the chain. If a block ever says "Not Approved" and is part of the chain then our model is broken. This box also shows how many votes the block recieved. In this case, the block received 4 votes out of a possible 7, all 4 votes are from good miners (desrcibed below). A block is added to the chain IFF a majority of miners vote for the block and a miner votes for the block when all the transactions in the block are also in the miner's network.

#### The Peer to Peer (P2P) Networks and Miners
In the above screenshot, there is one Good P2P Network and one Bad P2P Network. P2P Networks are either Good P2P Networks or Bad P2P Networks and there is only ever one Good P2P Network but there can be an arbitrary number of Bad P2P Networks.

#### Transactions and Coins

#### The Minted Coins

## Tests, Verification and Limitations

