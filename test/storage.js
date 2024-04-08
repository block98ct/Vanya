const { expect } = require('chai');
const { ethers } = require('hardhat');
const { ABI } = require('../ABI/project.json')

// import expect from chai
//const ethers = require('eth')

const addr = '0x4F02C3102A9D2e1cC0cC97c7fE2429B9B6F5965D'

describe("Unit testing of storage contract", async function(){
    let owner, user, storage
    beforeEach(async()=>{
        
        const signers = await ethers.getSigners()
        owner = signers[0]
        user = signers[1]


        const Storage = await ethers.getContractFactory("StorageContract")   
        storage = await upgrades.deployProxy(Storage, [])              
        await storage.waitForDeployment();

    })
  

    it("it should check the owner of project contract instance ", async()=>{
        const tx = await storage.connect(user).createProject()
         const txn = await tx.wait()
        // console.log("txn ----->", txn.logs);
        const logs = txn.logs;

        const events = logs.map(log => {
            return storage.interface.parseLog(log);
        })

        const projectCreatedEvents = events.filter(event => {
            return event.name === "ProjectCreated";
        });
        const projectCreatedEvent = projectCreatedEvents[0];
        const projectAddress = projectCreatedEvent.args.projectContract;
        const projectOwner = projectCreatedEvent.args.owner
        // const projectInstance = new ethers.Contract(projectAddress, ABI)

        // console.table([projectAddress, projectOwner])

       // const contractInstance = new ethers.Contract(projectAddress, projectAddress.abi)
    

    })

    it("it should return the owner", async()=>{
        var contractAddr = await storage.owner()
        expect(contractAddr).to.equal(contractAddr)
    })
    
})