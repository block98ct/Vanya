//  /$$    /$$  /$$$$$$  /$$   /$$ /$$     /$$ /$$$$$$
// | $$   | $$ /$$__  $$| $$$ | $$|  $$   /$$//$$__  $$
// | $$   | $$| $$  \ $$| $$$$| $$ \  $$ /$$/| $$  \ $$
// |  $$ / $$/| $$$$$$$$| $$ $$ $$  \  $$$$/ | $$$$$$$$
//  \  $$ $$/ | $$__  $$| $$  $$$$   \  $$/  | $$__  $$
//   \  $$$/  | $$  | $$| $$\  $$$    | $$   | $$  | $$
//    \  $/   | $$  | $$| $$ \  $$    | $$   | $$  | $$
//     \_/    |__/  |__/|__/  \__/    |__/   |__/  |__/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

contract VanyaRewards is
    Initializable,
    OwnableUpgradeable,
    ReentrancyGuardUpgradeable
{
    IERC20 public stakingToken;
    uint256 public rewardRate; // Annual reward rate in percentage
    uint256 public vestingPeriod; // Vesting period in years

    struct Stake {
        uint256 amount;
        uint256 lastClaimTime;
        uint256 totalClaimed;
    }

    mapping(address => Stake) public stakes;

    event Staked(address indexed user, uint256 amount);
    event Claimed(address indexed user, uint256 reward);
    event Withdrawn(address indexed user, uint256 amount);

    function initialize(
        address _stakingToken,
        uint256 _rewardRate,
        uint256 _vestingPeriod,
        address _intialOwner
    ) public initializer {
        __Ownable_init(_intialOwner);
        __ReentrancyGuard_init();
        stakingToken = IERC20(_stakingToken);
        rewardRate = _rewardRate;
        vestingPeriod = _vestingPeriod;
    }

    function stake(uint256 _amount) external nonReentrant {
        require(_amount > 0, "Cannot stake 0 tokens");

        Stake storage userStake = stakes[msg.sender];

        stakingToken.transferFrom(msg.sender, address(this), _amount);

        if (userStake.amount > 0) {
            // Claim any pending rewards before updating the stake
            uint256 pendingRewards = calculateReward(msg.sender);
            userStake.totalClaimed += pendingRewards;
        }

        userStake.amount += _amount;
        // userStake.startTime = block.timestamp;
        userStake.lastClaimTime = block.timestamp;

        emit Staked(msg.sender, _amount);
    }

    function calculateReward(address _user) public view returns (uint256) {
        Stake memory userStake = stakes[_user];
        if (userStake.amount == 0) {
            return 0;
        }

        uint256 elapsedTime = block.timestamp - userStake.lastClaimTime;
        uint256 yearsElapsed = elapsedTime / 365 days;

        // Ensure rewards are only given after at least 1 year
        if (yearsElapsed == 0) {
            return 0;
        }

        uint256 annualReward = (userStake.amount * rewardRate) / 100;
        uint256 totalReward = yearsElapsed * annualReward;

        // Cap rewards to not exceed the reward rate over the vesting period
        uint256 maxReward = ((userStake.amount * rewardRate) / 100) *
            vestingPeriod;
        uint256 availableReward = totalReward > maxReward
            ? maxReward
            : totalReward;

        return availableReward - userStake.totalClaimed;
    }

    function claim() external nonReentrant {
        Stake storage userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No staked tokens");

        uint256 reward = calculateReward(msg.sender);
        require(reward > 0, "No rewards available");

        userStake.lastClaimTime = block.timestamp;
        userStake.totalClaimed += reward;

        stakingToken.transfer(msg.sender, reward);

        emit Claimed(msg.sender, reward);
    }

    function withdraw(uint256 _amount) external nonReentrant {
        Stake storage userStake = stakes[msg.sender];
        require(
            userStake.amount >= _amount,
            "Withdraw amount exceeds staked amount"
        );

        uint256 reward = calculateReward(msg.sender);

        if (reward > 0) {
            userStake.lastClaimTime = block.timestamp;
            userStake.totalClaimed += reward;
            stakingToken.transfer(msg.sender, reward);
            emit Claimed(msg.sender, reward);
        }

        userStake.amount -= _amount;
        stakingToken.transfer(msg.sender, _amount);

        emit Withdrawn(msg.sender, _amount);
    }

    // function emergencyWithdraw() external nonReentrant {
    //     Stake storage userStake = stakes[msg.sender];
    //     require(userStake.amount > 0, "No staked tokens");

    //     uint256 stakedAmount = userStake.amount;
    //     userStake.amount = 0;

    //     stakingToken.transfer(msg.sender, stakedAmount);

    //     emit Withdrawn(msg.sender, stakedAmount);
    // }
}
