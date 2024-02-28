const {ethers, upgrades} = require("hardhat");
async function main(){
    const [deployer] = await ethers.getSigners()
    console.log(`Deploying contracts with the account: ${deployer.address}`);

    const Storage = await ethers.getContractFactory("StorageContract")   // 0xcB15d729a91Df72b02D0E8F4EAA0C805dD7a0FeF 0xc48d7120623C66A36654c36F77B6796ea9A64540
    const storage = await upgrades.deployProxy(Storage, [])              //  0xc76F5C194AB0B2C6CE3A1f8891AC9580B4356cfC
    await storage.waitForDeployment();                                  

    console.log(`Storage contract deployed to : ${await storage.getAddress()}`);


    const Project = await ethers.getContractFactory("ProjectContract")  // 0x24c2c425b5f7ED630AF153E744186B022A16E72e  0xAe9f333693f8e35B80Aa26d5cad394a24D811586
    const project = await upgrades.deployProxy(Project, [deployer.address]) // 0x8436d48D44efDa972375DF5E5b617Ab4C2017eBA  0xcfFb74476CfC850cc4AEDCA245cEdD87910863F4
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
