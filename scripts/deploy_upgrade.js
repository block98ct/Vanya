const {ethers, upgrades} = require("hardhat");
async function main(){

    // CONTRACT DEPLOYER
    const [deployer] = await ethers.getSigners()
    const balance = await ethers.provider.getBalance(deployer.address);
    console.log(`Deploying contracts with the account: ${deployer.address}`);
    console.log(`The balance of account: ${balance}`);
    

    // TOKEN CONTRACT
    const Token = await ethers.getContractFactory("Vanya")   // 0x4b40736271f01a0a5707cbd9Bb0eb7c7cdF254d8
    const token = await Token.deploy(deployer.address)
    await token.waitForDeployment()
    console.log(`Token contract deployed to : ${await token.getAddress()}`);
    

    // STORAGE CONTRACT
    // const Storage = await ethers.getContractFactory("StorageContract")   // 0xcB15d729a91Df72b02D0E8F4EAA0C805dD7a0FeF 0xc48d7120623C66A36654c36F77B6796ea9A64540
    // const storage = await upgrades.deployProxy(Storage, [])              //  0xc76F5C194AB0B2C6CE3A1f8891AC9580B4356cfC
    // await storage.waitForDeployment();                                  // 0x5aBE4e5d7C234A0f28aEF73F574A05b70248d867  0xB2B1e1ac321fa893f51CC6E6a2599c6023AaED48
    // console.log(`Storage contract deployed to : ${await storage.getAddress()}`);
    

    // PROJECT CONTRACT
    // const Project = await ethers.getContractFactory("ProjectContract")  // 0x24c2c425b5f7ED630AF153E744186B022A16E72e  0xAe9f333693f8e35B80Aa26d5cad394a24D811586
    // const project = await upgrades.deployProxy(Project, [deployer.address]) // 0x8436d48D44efDa972375DF5E5b617Ab4C2017eBA  0xcfFb74476CfC850cc4AEDCA245cEdD87910863F4
    // await project.waitForDeployment(); 

    // console.log(`Project contract deployed to : ${await project.getAddress()}`);   //0xFFDCF291BdB570D92afd7e41eDC94E5838d7294e 0xe29F6eD5B743F6368c4Dea92Ad67d01eB2d91869

}
main()
     .then(()=> process.exit(0))
     .catch(error=>{
         console.info("check")
         console.log(error)
         process.exit(1)
     })


// KYOTO NETWORK
// Storage contract deployed to : 0xEA3b360bedf5cd9262bD73394C847D9599430843
// Project contract deployed to : 0x076Cf5648dF3B78Ff910e0CaD792EaCD3B5bf612


// storage contract deployed to : 0x6376d0850f978Cb232e5Ee6B30FeD549dBFEdD8d
// Project contract deployed to : 0x7734052eC951A3eb450295b41fC51759CF6a067C


// Storage contract deployed to : 0xe9446a1B26B6E597F54dB0314D9abc70A32a878e
// Project contract deployed to : 0xFA8C6391AD0B6461422474e2647254e79fF98b92

// Storage contract deployed to : 0xe91A6a2291b935dE523AB97d5C2914233D8AF696
// Project contract deployed to : 0xD1d0BD7607f0a9533AbB82e0Ef26188B1c7704Fa


// AURORA NETWORK
// Storage contract deployed to : 0xe91A6a2291b935dE523AB97d5C2914233D8AF696
// Project contract deployed to : 0xD1d0BD7607f0a9533AbB82e0Ef26188B1c7704Fa



// SEPOLIA NETWORK 

// Storage contract deployed to:  
//impl 0xa15f03A8b22E980B62f416aC39e639652a691520  proxy 0xD3CFB4e354912c7F18f7Ed82F9ee23Dca8b68108 
//impl 0x0Bf702aDD8dAD990aDc35D9724d66BC0ed4C3799 proxy 0x0D2A56c9C4CF20F62c18A88111CfE2434163bC55


// Project contract deployed to :  
//impl 0xe29F6eD5B743F6368c4Dea92Ad67d01eB2d91869  proxy 0xC4fa11FDDd34e8Ba71F01A1a654c0C13345B363A 
//impl 0xc728611b4459A49BCd55282C2938C4089cB2F422 proxy 0x674aE49f9499764E3e516d3A3a22Fa60388Cc30E


   
// npx hardhat run --network "network" scripts/deploy_upgrade.js
// npx hardhat verify --network "network" "address"


//npx hardhat verify --network polygon-amoy 0x6376d0850f978Cb232e5Ee6B30FeD549dBFEdD8d