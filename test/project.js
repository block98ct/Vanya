// const { expect } = require("chai");
// const { ethers } = require("hardhat");
// const { ABI } = require("../ABI/project.json");

// const addr = "0x4F02C3102A9D2e1cC0cC97c7fE2429B9B6F5965D";
// const addr1 = "0xb178512aA2C4D0c3C43a12c7b7C2d1465fe298A5";

// var latitude = "34.0522";
// var longitude = "-118.2437";
// var projectAddress = "789 Oak St, San Francisco, CA";
// var details = "test";
// var area = "50 acres";
// var ndvi = "0.85";
// var carbon = "750 tons";
// var npar = "400 units";
// var par = "200 units";
// var kmlLink = "https://example.com/warehouse-renovation.kml";
// var geoJsonLink = "https://example.com/historical-building-conversion.geojson";
// var projectDescription = "test";
// var firstImageLink =
//   "https://example.com/historical-building-conversion-image1.jpg";
// var landDeveloper = "Metro Properties LLC";
// var projectStoryImage =
//   "https://example.com/historical-building-conversion-story-image.jpg";
// var projectType = "Mixed-use development";
// var carbonCredits = "1500 credits";
// var amountWorth = "$3,500,000";
// var productName = "Warehouse Revival Project";

// var projectId = 1;
// var url = "https://ipfs.io/ipfs/QmdUYhyvAGqVuM1DwQxsAFH7b9hVe2qnUL4CnmgkjZ4PiS";

// describe("Unit testing of project contract", async function () {
//   let owner, user, project;
//   beforeEach(async () => {
//     const signers = await ethers.getSigners();
//     owner = signers[0];
//     user = signers[1];

//     const Project = await ethers.getContractFactory("ProjectContract");
//     project = await upgrades.deployProxy(Project, [owner.address]);
//     await project.waitForDeployment();
//   });

//   it("it should check the onwer", async () => {
//     let owner = await project.owner();
//     expect(owner).to.equal(addr);
//   });

//   it("it should transfer the ownership of smart contract", async () => {
//     var ownerBefore = await project.owner();
//     expect(ownerBefore).to.equal(addr);
//     // console.log("ownerBefore ------------->", ownerBefore)

//     var tx = await project.connect(owner).transferOwnership(addr1);
//     var txn = await tx.wait();

//     var ownerAfter = await project.owner();
//     //  console.log("owner after ------------>", ownerAfter)

//     expect(ownerAfter).to.equal(addr1);
//   });

//   it("it should add project data ", async () => {
//     var tx = await project
//       .connect(user)
//       .addProjectData(
//         latitude,
//         longitude,
//         projectAddress,
//         details,
//         area,
//         ndvi,
//         carbon,
//         npar,
//         par,
//         kmlLink,
//         geoJsonLink,
//         projectDescription,
//         firstImageLink,
//         landDeveloper,
//         projectStoryImage,
//         projectType,
//         carbonCredits,
//         amountWorth,
//         productName
//       );

//     var txn = await tx.wait();
//     var res = await project.projectData(1);

//     expect(
//       latitude,
//       longitude,
//       projectAddress,
//       details,
//       area,
//       ndvi,
//       carbon,
//       npar,
//       par,
//       kmlLink,
//       geoJsonLink,
//       projectDescription,
//       firstImageLink,
//       landDeveloper,
//       projectStoryImage,
//       projectType,
//       carbonCredits,
//       amountWorth,
//       productName
//     ).to.equal(
//       res.latitude,
//       res.longitude,
//       res.projectAddress,
//       res.details,
//       res.area,
//       res.ndvi,
//       res.carbon,
//       res.npar,
//       res.par,
//       res.kmlLink,
//       res.geoJsonLink,
//       res.projectDescription,
//       res.firstImageLink,
//       res.landDeveloper,
//       res.projectStoryImage,
//       res.projectType,
//       res.carbonCredits,
//       res.amountWorth,
//       res.productName
//     );
//     expect(res.createdAt).not.equal(0)
//     expect(res.updatedAt).to.equal(0)
//   });

//   it("it should give certificate as NFT", async () => {
//     var projectId = 1;
//     var url =
//       "https://ipfs.io/ipfs/QmdUYhyvAGqVuM1DwQxsAFH7b9hVe2qnUL4CnmgkjZ4PiS";

//     var tx = await project
//       .connect(owner)
//       .issueCertificate(addr1, projectId, url);

//     var txn = await tx.wait();
//     var nftOwner = await project.ownerOf(projectId);

//     expect(nftOwner).to.equal(addr1);
//   });

//   it("it should return the value of ndvi and carbon data", async () => {
//     var tx = await project
//       .connect(user)
//       .addProjectData(
//         latitude,
//         longitude,
//         projectAddress,
//         details,
//         area,
//         ndvi,
//         carbon,
//         npar,
//         par,
//         kmlLink,
//         geoJsonLink,
//         projectDescription,
//         firstImageLink,
//         landDeveloper,
//         projectStoryImage,
//         projectType,
//         carbonCredits,
//         amountWorth,
//         productName
//       );

//     var txn = await tx.wait();
//     var res = await project.projectData(1);

//     var carbonRes = await project.carbonData(res.createdAt);
//     var ndviRes = await project.ndviData(res.createdAt);

//     expect(ndviRes).to.equal(ndvi);
//     expect(carbonRes).to.equal(carbon);

//     // console.log("resTx -------->", resTx)
//   });

//   it("it should update the projectdata ", async () => {
//     var tx = await project
//       .connect(user)
//       .addProjectData(
//         latitude,
//         longitude,
//         projectAddress,
//         details,
//         area,
//         ndvi,
//         carbon,
//         npar,
//         par,
//         kmlLink,
//         geoJsonLink,
//         projectDescription,
//         firstImageLink,
//         landDeveloper,
//         projectStoryImage,
//         projectType,
//         carbonCredits,
//         amountWorth,
//         productName
//       );

//     var txn = await tx.wait();
//     var logs = txn.logs;

//     var events = logs.map((log) => {
//       return project.interface.parseLog(log);
//     });

//     var projectCreatedEvents = events.filter((event) => {
//       return event.name === "ProjectDataAdded";
//     });
//     var projectCreatedEvent = projectCreatedEvents[0];
//     var projectId = projectCreatedEvent.args.projectId;

//     var tx = await project
//       .connect(owner)
//       .updateProjectData(
//         projectId,
//         latitude,
//         longitude,
//         projectAddress,
//         details,
//         area,
//         ndvi,
//         carbon,
//         npar,
//         par,
//         kmlLink,
//         geoJsonLink,
//         projectDescription,
//         firstImageLink,
//         landDeveloper,
//         projectStoryImage,
//         projectType,
//         carbonCredits,
//         amountWorth,
//         productName
//       );


//       var txn = await tx.wait()

//   });
// });
