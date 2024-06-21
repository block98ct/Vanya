// const { expect } = require('chai');
// const { ethers } = require('hardhat');
// const { ABI } = require('../ABI/project.json')

// // import expect from chai
// //const ethers = require('eth')

// const addr = '0x4F02C3102A9D2e1cC0cC97c7fE2429B9B6F5965D'

// describe("Unit testing of storage contract", async function(){  
//     let bob, alice, storage
//     beforeEach(async()=>{
//         const signers = await ethers.getSigners()
//         bob = signers[0]
//         alice = signers[1]
//         const Storage = await ethers.getContractFactory("StorageContract")   
//         storage = await upgrades.deployProxy(Storage, [])              
//         await storage.waitForDeployment();

//     })
  

//     it("it should check the owner of storage contract instance ", async()=>{
//          var tx = await storage.connect(bob).createProject()
//          var txn = await tx.wait()
//          var logs = txn.logs;

//          var events = logs.map(log => {
//             return storage.interface.parseLog(log);
//          })

//          var projectCreatedEvents = events.filter(event => {
//             return event.name === "ProjectCreated";
//          });
//          var projectCreatedEvent = projectCreatedEvents[0];
//          var projectAddress = projectCreatedEvent.args.projectContract;
//          //console.log("projectAddress--------->", projectAddress)
//          var projectOwner = projectCreatedEvent.args.owner
//          expect(bob.address).to.equal(projectOwner)


//         //  console.log("projectAddress -------->", projectAddress);
//         //  console.log("projectOwner-------->", projectOwner);



//         // const projectInstance = new ethers.Contract(projectAddress, ABI)
//         // console.table([projectAddress, projectOwner])
//         // const contractInstance = new ethers.Contract(projectAddress, projectAddress.abi)
//     })

//     it("it should transfer the ownership of storage contract", async()=>{
//          var ownerBefore = await storage.owner()
//          expect(ownerBefore).to.equal(bob.address)
        
         
//          var tx = await storage.connect(bob).transferOwnership(alice.address)
//          var txn = await tx.wait();

//          var ownerAfter = await storage.owner()
//          expect(ownerAfter).to.equal(alice.address)
 

//     })


//     it("it should return the owner", async()=>{
//         var ownerRes = await storage.owner()
//         expect(ownerRes).to.equal(bob.address)
//     })



//     it("it should renounce the ownership of smart contract", async()=>{
//          var dummyAddr = "0x0000000000000000000000000000000000000000"
//          var ownerBefore = await storage.owner()
//          expect(ownerBefore).to.equal(bob.address)

//          var tx = await storage.connect(bob).renounceOwnership()
//          var txn = await tx.wait()

//          var ownerAfter = await storage.owner()
//          expect(ownerAfter).not.equal(ownerBefore)
//          expect(ownerAfter).to.equal(dummyAddr)
//         //  expect().to.equal()

//     })



//     it("it should return the contract is created or not", async()=>{
//         var tx = await storage.connect(bob).createProject()
//         var txn = await tx.wait()
//         var logs = txn.logs;

//         var events = logs.map(log => {
//            return storage.interface.parseLog(log);
//         })

//         var projectCreatedEvents = events.filter(event => {
//            return event.name === "ProjectCreated";
//         });
//         var projectCreatedEvent = projectCreatedEvents[0];
//         var projectAddress = projectCreatedEvent.args.projectContract;
//        // var projectOwner = projectCreatedEvent.args.owner

//         var res = await storage.isProjectContract(projectAddress)

//         expect(res).to.equal(true)
//         expect(res).not.equal(false)
         
//         var dummyAddr = "0xD958c160f4bA0583D80ffdF83C2e0FB0f74D8728"
//         var res = await storage.isProjectContract(dummyAddr)
//         expect(res).to.equal(false)

//    })



    




    
// })