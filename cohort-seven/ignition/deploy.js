const hre = require("hardhat");

async function main() {

    await hre.run('compile');

    const Lock = await hre.ethers.getContractFactory("Lock");

    const lock = await Lock.deploy();

    await lock.waitForDeployment();

    console.log("Lock Contract Address", await lock.getAddress())

}

main().then(() => process.exit(0))

.catch((error) => { 

    console.error(error);

    process.exit(1);

    });