const {ethers} = require("hardhat");
async function main(){
    const [deployer] = await ethers.getSigners()
    console.log(`Deploying contracts with the account: ${deployer.address}`);

    const Storage = await ethers.getContractFactory("StorageContract")   // 0xBd7D38071Ec906Eb448C4c7D5eAF90a045cf2858
    const storage = await Storage.deploy()
    await storage.waitForDeployment();

    console.log(`Storage contract deployed to : ${await storage.getAddress()}`);


    const Project = await ethers.getContractFactory("ProjectContract")  // 0x67Fab672DF722E2197b424F9a64B800E2A054026
    const project = await Project.deploy()
    await project.waitForDeployment();

    console.log(`Project contract deployed to : ${await project.getAddress()}`);
}

main()
     .then(()=> process.exit(0))
     .catch(error=>{
         console.info("check")
         console.log(error)
         process.exit(1)
     })


// npx hardhat run --network sepolia scripts/deploy_storage.ts
// npx hardhat verify --network sepolia "address"
//npx hardhat verify --network kyoto 0xEA3b360bedf5cd9262bD73394C847D9599430843