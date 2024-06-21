const { expect } = require("chai");
const { ethers } = require("hardhat");

// describe("Unit testing of staking and rewards", async function () {
//   let owner, alice, bob, stakingAndReward, token;
//   let rewardRate = 10; // 10%
//   let vestingPeriod = 2 * 365 * 24 * 60 * 60; // 2 years in seconds
//   beforeEach(async () => {
//     try {
//       [owner, alice, bob] = await ethers.getSigners();

//       const Token = await ethers.getContractFactory("Vanya");
//       token = await Token.deploy(owner.address);
//       token.waitForDeployment();
//       const StakingAndReward = await ethers.getContractFactory("VanyaRewards");
//       stakingAndReward = await upgrades.deployProxy(StakingAndReward, [
//         token.target,
//         rewardRate,
//         vestingPeriod,
//         owner.address,
//       ]);
//       await stakingAndReward.waitForDeployment();
//       await token.transfer(alice.address, "1000000000000000000000");
//       await token.transfer(bob.address, "1000000000000000000000");
//     } catch (error) {
//       console.log(error);
//     }
//   });

//   it("should stake tokens and emit Staked event", async () => {
//     const stakeAmount = "500000000000000000000";

//     await token.connect(alice).approve(stakingAndReward.target, stakeAmount);
//     await expect(stakingAndReward.connect(alice).stake(stakeAmount))
//       .to.emit(stakingAndReward, "Staked")
//       .withArgs(alice.address, stakeAmount);

//     const stake = await stakingAndReward.stakes(alice.address);
//     expect(stake.amount).to.equal(stakeAmount);
//   });

//   it("should calculate rewards correctly", async () => {
//     const stakeAmount = "500000000000000000000";
//     await token.connect(alice).approve(stakingAndReward.target, stakeAmount);
//     await stakingAndReward.connect(alice).stake(stakeAmount);
//     await ethers.provider.send("evm_increaseTime", [365 * 24 * 60 * 60]);
//     await ethers.provider.send("evm_mine", []);
//     const reward = await stakingAndReward.calculateReward(alice.address);

//     // const expectedReward = (stakeAmount * rewardRate) / 100;
//     const expectedReward = (BigInt(stakeAmount) * BigInt(rewardRate)) / 100n;
//     expect(reward).to.equal(expectedReward);
//   });

//   it("should claim rewards correctly", async () => {
//     const stakeAmount = BigInt("500000000000000000000"); // Convert to BigInt
//     await token.connect(alice).approve(stakingAndReward.target, stakeAmount);

//     await stakingAndReward.connect(alice).stake(stakeAmount);

//     // Fast forward time by 1 year
//     await ethers.provider.send("evm_increaseTime", [365 * 24 * 60 * 60]);
//     await ethers.provider.send("evm_mine", []);

//     const expectedReward = (stakeAmount * BigInt(rewardRate)) / BigInt(100); // Use BigInt for reward calculation

//     await expect(stakingAndReward.connect(alice).claim())
//       .to.emit(stakingAndReward, "Claimed")
//       .withArgs(alice.address, expectedReward); // Use expectedReward here

//     const stake = await stakingAndReward.stakes(alice.address);

//     expect(stake.totalClaimed).to.equal(expectedReward); // Use expectedReward here
//   });

//   it("should transfer ownership", async () => {
//     const ownerBefore = await stakingAndReward.owner();
//     expect(ownerBefore).to.equal(owner.address);

//     await stakingAndReward.transferOwnership(alice.address);

//     const ownerAfter = await stakingAndReward.owner();
//     expect(ownerAfter).to.equal(alice.address);
//   });

//   it("should renounce ownership", async () => {
//     const dummyAddr = "0x0000000000000000000000000000000000000000";

//     const ownerBefore = await stakingAndReward.owner();
//     expect(ownerBefore).to.equal(owner.address);
//     await stakingAndReward.renounceOwnership();

//     const ownerAfter = await stakingAndReward.owner();
//     expect(ownerAfter).to.equal(dummyAddr);
//   });

//   it("claim rewards ", async()=>{

//   })
// });
