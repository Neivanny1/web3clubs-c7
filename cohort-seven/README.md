# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js --network sepolia 
## or ##
npx hardhat run ignition/deploy.js --network sepolia // ethereum

npx hardhat verify --network sepolia 0x19c2A74b83750218efD1445e56C711c01155E273
```
