const { expect } = require("chai");
const { ethers } = require("hardhat");

// describe("Unit testing of ILO ", async function () {
//   let owner, alice, bob, vanyaIlo, token;
//   let initialTokens = "1000000000000000000000000"; // 1,000,000 tokens
//   let tokenRate = 1000;
//   beforeEach(async () => {
//     [owner, alice, bob] = await ethers.getSigners();
//     const Token = await ethers.getContractFactory("Vanya");
//     token = await Token.deploy(owner.address);
//     token.waitForDeployment();

//     const VanyaILO = await ethers.getContractFactory("VanyaILO");
//     vanyaIlo = await upgrades.deployProxy(VanyaILO, [
//       token.target,
//       initialTokens,
//       owner.address,
//     ]);
//     await vanyaIlo.waitForDeployment();
//     token.transfer(vanyaIlo.target, initialTokens);
//   });

//   it("should start a token sale", async () => {
//     const saleType = 0; // Seed sale
//     const rate = 1000;
//     const start = Math.floor(Date.now() / 1000);
//     const duration = 30; // 30 days
//     const minBound = ethers.parseEther("0.1"); // Minimum purchase is 0.1 Ether

//     await expect(
//       vanyaIlo.startTokenSale(saleType, rate, start, duration, minBound)
//     )
//       .to.emit(vanyaIlo, "SaleCreated")
//       .withArgs(1);

//     const saleDetail = await vanyaIlo.salesDetailMap(1);

//     expect(saleDetail.rate).to.equal(rate);

//     expect(saleDetail.start).to.equal(start);

//     expect(saleDetail.duration).to.equal(duration);

//     expect(saleDetail.minBound).to.equal(minBound);
//   });
//   it("should allow presale token purchase", async () => {
//     const saleType = 0; // Seed sale
//     const rate = 1000;
//     const start = Math.floor(Date.now() / 1000);
//     const duration = 30; // 30 days
//     const minBound = 5; // Minimum purchase is 0.1 Ether

//     await vanyaIlo.startTokenSale(saleType, rate, start, duration, minBound);
//     await vanyaIlo.togglePresale();

//     const purchaseAmount = ethers.parseEther("0.1"); // 0.1 Ether
//     // const expectedTokens = purchaseAmount * BigInt(rate);
//     // console.log("expectedTokens  -------->", expectedTokens, typeof(expectedTokens))

//     // Debugging token calculation
//     const expectedTokens = await vanyaIlo.calculateToken(purchaseAmount, rate);

//     // Ensure the calculated token amount meets the minimum bound
//     // console.log("Min bound:", minBound);
//     // console.log("Purchase amount:", purchaseAmount.toString());
//     // Perform the presale purchase
//     await expect(
//       vanyaIlo.connect(alice).preSaleBuy(saleType, { value: purchaseAmount })
//     )
//       .to.emit(vanyaIlo, "BoughtTokens")
//       .withArgs(alice.address, BigInt(expectedTokens), 1);

//     // Verify the user's token purchase
//     const userToken = await vanyaIlo.userTokenMap(1, alice.address);
//     expect(userToken.tokensPurchased).to.equal(expectedTokens);
//   });

//   it("should calculate release tokens correctly", async () => {
//     const saleType = 0; // Seed sale
//     const rate = 1000;
//     const start = Math.floor(Date.now() / 1000);
//     const duration = 30; // 30 days
//     const minBound = 2; // Minimum purchase

//     await vanyaIlo.startTokenSale(saleType, rate, start, duration, minBound);
//     await vanyaIlo.togglePresale();

//     const purchaseAmount = ethers.parseEther("0.1"); // 0.1 Ether
//     await vanyaIlo
//       .connect(alice)
//       .preSaleBuy(saleType, { value: purchaseAmount });

//     // Fast forward time by 1 year
//     await ethers.provider.send("evm_increaseTime", [365 * 24 * 60 * 60]);
//     await ethers.provider.send("evm_mine", []);

//     const latestBlock = await ethers.provider.getBlock("latest");
//     const currentTime = BigInt(latestBlock.timestamp);

//     const userToken = await vanyaIlo.userTokenMap(1, alice.address);
//     const tokensPurchased = BigInt(userToken.tokensPurchased);
//     const lastClaimedTime = BigInt(userToken.lastClaimedTime);

//     const oneYearInSeconds = BigInt(365 * 24 * 60 * 60);
//     const vestingPeriodInSeconds = BigInt(2) * oneYearInSeconds;

//     const expectedClaimableTokens =
//       (tokensPurchased * (currentTime - lastClaimedTime)) /
//       vestingPeriodInSeconds; // 2 years vesting

//     const claimableTokens = await vanyaIlo.calculateReleaseToken(
//       tokensPurchased,
//       lastClaimedTime,
//       currentTime,
//       1
//     );

//     expect(claimableTokens).to.equal(expectedClaimableTokens);
//   });

//   it("should allow token claim", async () => {
//     const saleType = 0; // Seed sale
//     const rate = 1000;
//     const currentBlockTimestamp = (await ethers.provider.getBlock("latest")).timestamp;
//     const start = currentBlockTimestamp; // Start now    
//     const duration = 30; // 30 days
//     const minBound = 2; // Minimum purchase

//     await vanyaIlo.startTokenSale(saleType, rate, start, duration, minBound);
//     await vanyaIlo.togglePresale();
    

//     // const saleId = await vanyaIlo.getSaleIdByType(saleType);
//     // console.log("saleType--------->", Number(saleId));

//     // const saleDetail = await vanyaIlo.salesDetailMap(saleId);
//     // console.log("saleDetail--------->", saleDetail);


//     // console.log("Current Block Timestamp --------->", currentBlockTimestamp);

//     // console.log("Sale Start Time--------->", Number(saleDetail.start));
//     // const saleEndTime =
//     //   Number(saleDetail.start) + Number(saleDetail.duration) * 86400;
//     // console.log("Sale End Time--------->", saleEndTime);

//     //const saleIdMapStatus = await vanyaIlo.saleIdMap(saleId);
//     // console.log("Sale ID Map Status--------->", saleIdMapStatus);

//    // const isActiveStatus = await vanyaIlo.isActive(saleId);
//     // console.log("isActiveStatus --------->", isActiveStatus);

//     const purchaseAmount = ethers.parseEther("0.1"); // 0.1 Ether
//     await vanyaIlo
//       .connect(alice)
//       .preSaleBuy(saleType, { value: purchaseAmount });

//     await ethers.provider.send("evm_increaseTime", [365 * 24 * 60 * 60]);
//     await ethers.provider.send("evm_mine", []);

//     const userToken = await vanyaIlo.userTokenMap(1, alice.address);
//     const tokensPurchased = BigInt(userToken.tokensPurchased);
//     const lastClaimedTime = BigInt(userToken.lastClaimedTime);

//     const oneYearInSeconds = BigInt(365 * 24 * 60 * 60);
//     const vestingPeriodInSeconds = BigInt(2) * oneYearInSeconds;
    
//     const latestBlock = await ethers.provider.getBlock("latest")

//     const currentTime = BigInt(latestBlock.timestamp);
//     const expectedClaimableTokens =
//       (tokensPurchased * (currentTime - lastClaimedTime)) /
//       vestingPeriodInSeconds; // 2 years vesting


//     await expect(vanyaIlo.connect(alice).claim(1))
//       .to.emit(vanyaIlo, "Claimed")
//       .withArgs(alice.address, expectedClaimableTokens, 1);

//     const updatedUserToken = await vanyaIlo.userTokenMap(1, alice.address);
//     expect(updatedUserToken.claimed).to.equal(expectedClaimableTokens);
//     expect(updatedUserToken.remainingTokens).to.equal(
//       tokensPurchased - expectedClaimableTokens
//     );
//   });
// });
