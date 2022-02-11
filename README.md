# Sushi-Sway

An implementation of Sushiswap's Trident for the FuelVM V2 Written in Sway. The goal of Sushi Sway is to take advantage of the agglomeration affects gained by having the BentoBox on the network from Day 1, where liquidity can be also earning Yield, and enough so for flashswaps to also be mainly done through the BentoBox. Another advantage is the ability to implement isolated lending markets via Kashi, and Stablecoins via Abracadabra. By making all of these accessible early on for FuelV2 the hope is that they can work together and build a strong network affect.

Current Todo List of What Needs To Be Done


## BentoBox
- [x] - Fix Deposits, as balance is being incorrectly stored leading to a lack of persistence
- [x] - Implement Withdraw Function **STILL PENDING TOKEN TRANSFERS**
- [ ] - Allow for Flashloans Starting with a 0.05% fee that is then redistributed to everyone with tokens on BentoBox (including LP pools)

## Constant Product Pool

- [ ] - Using Nick's [Uniswap Example](https://github.com/FuelLabs/sway/issues/396#issuecomment-975465542) implement the basic UNI V2 interface
- [ ] - Proper management of LP tokens that comply to a Fuel token Standard
- [ ] - JIT liquidity by borrowing from the BentoBox, thus allowing normally idle Liquidity to be earning Yield when it's not providing liquidity

## Concentrated Liquidity Pool

- [ ] - The idea with Concentrated Liquidity is it can make up for the lack of a Curve Style LP until I am able to implement it, as well as compete with a Uniswap V3 deployment at the same time, also utilizing the BentoBox to maximize network affects
