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

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VanyaILO is
    OwnableUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable
{
    IERC20 token;
    uint256 public saleId;
    uint256 public initialTokens; // Initial number of tokens available
    bool public presaleActive;

    uint256 private constant VESTING_PERIOD = 2 * 365 days; // 3 years

    struct SaleDetail {
        uint256 rate; // Number of tokens per Ether
        uint256 start; // Sale start time
        uint256 duration; // Duration of the sale in days
        uint256 raisedIn; // Amount of Ether raised in the sale
        uint256 tokenSold; // Tokens sold in the sale
        uint256 minBound; // Minimum tokens to buy
    }

    struct UserToken {
        uint256 saleRound; // Sale round ID
        uint256 tokensPurchased; // Tokens purchased by the user
        uint256 claimed; // Tokens claimed by the user
        uint256 lastClaimedTime; // Last time the user claimed tokens
        uint256 createdOn; // When the user participated in the sale
        uint256 remainingTokens; // Tokens remaining to be claimed
    }

    mapping(uint256 => SaleDetail) public salesDetailMap;
    mapping(uint256 => mapping(address => UserToken)) public userTokenMap;
    mapping(uint256 => bool) public saleIdMap;

    event BoughtTokens(address indexed to, uint256 value, uint256 saleId);
    event SaleCreated(uint256 saleId);
    event Claimed(address indexed receiver, uint256 amount, uint256 saleId);

    uint256 private seedSaleId;
    uint256 private privateSaleId;

    /**
     * Initialize the contract
     **/
    function initialize(
        address _tokenAddr,
        uint256 _initialTokens,
        address initialOwner
    ) external initializer {
        require(_tokenAddr != address(0), "Invalid token address");
        require(_initialTokens > 0, "Initial tokens must be greater than zero");
        initialTokens = _initialTokens * 10 ** 18;

        __Ownable_init(initialOwner);
        __Pausable_init();
        __ReentrancyGuard_init();
        token = IERC20(_tokenAddr);
    }

    function setInitialTokens(uint256 _newValue) public onlyOwner {
        initialTokens = _newValue * 10 ** 18;
    }

    function updateSaleIdByType(uint256 _saleType, uint256 _saleId) internal {
        if (_saleType == 0) {
            seedSaleId = _saleId;
        } else if (_saleType == 1) {
            privateSaleId = _saleId;
        }
    }

    function getSaleIdByType(
        uint256 _saleType
    ) public view returns (uint256) {
        return
            _saleType == 0 ? seedSaleId : (_saleType == 1 ? privateSaleId : 0);
    }

    /**
     * Start a token sale
     */
    function startTokenSale(
        uint256 _saleType,
        uint256 _rate,
        uint256 _start,
        uint256 _duration,
        uint256 _minBound
    ) external whenNotPaused onlyOwner returns (uint256) {
        require(_saleType == 0 || _saleType == 1, "Invalid sale type");
        saleId++;
        updateSaleIdByType(_saleType, saleId);

        SaleDetail memory detail;
        detail.rate = _rate;
        detail.start = _start;
        detail.duration = _duration;
        detail.minBound = _minBound;
        salesDetailMap[saleId] = detail;
        emit SaleCreated(saleId);
        return saleId;
    }

    /**
     * Toggle presale status
     */
    function togglePresale() public onlyOwner {
        presaleActive = !presaleActive;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function updateSaleIdStatus(uint256 _saleId) external onlyOwner {
        saleIdMap[_saleId] = !saleIdMap[_saleId];
    }

    /**
     * Check if a sale is active
     */
    function isActive(uint256 _saleId) public view returns (bool) {
        SaleDetail memory detail = salesDetailMap[_saleId];
        return (block.timestamp >= detail.start &&
            block.timestamp <= detail.start + (detail.duration * 1 days) &&
            !saleIdMap[_saleId]);
    }

    /**
     * Fallback function if ether is sent to address instead of buyTokens function
    //  */
    // fallback() external payable {
    //     buyTokens();
    // }

    // receive() external payable {
    //     buyTokens();
    // }
    /**
     * Buy tokens during the presale
     */
    // function preSaleBuy(
    //     uint256 _saleType
    // ) public payable whenNotPaused nonReentrant {
    //     require(_saleType == 0 || _saleType == 1, "Invalid sale type");
    //     uint256 _saleId = getSaleIdByType(_saleType);
    //     require(isActive(_saleId), "Sale is not active");
    //     require(presaleActive, "Presale is OFF");
    //     require(msg.value > 0, "Invalid amount");

    //     SaleDetail memory detail = salesDetailMap[_saleId];
    //     UserToken memory userToken = userTokenMap[_saleId][_msgSender()];

    //     uint256 _tokens = calculateToken(msg.value, detail.rate);
    //     require(
    //         _tokens >= detail.minBound && _tokens <= initialTokens,
    //         "Invalid token amount"
    //     );

    //     userToken.saleRound = _saleId;
    //     userToken.createdOn = block.timestamp;
    //     userToken.lastClaimedTime = block.timestamp;
    //     userToken.tokensPurchased += _tokens;
    //     userToken.remainingTokens += _tokens;

    //     emit BoughtTokens(msg.sender, _tokens, _saleId);
    //     detail.tokenSold += _tokens;
    //     detail.raisedIn += msg.value;
    //     initialTokens -= _tokens;
    //     salesDetailMap[_saleId] = detail;
    //     userTokenMap[_saleId][_msgSender()] = userToken;
    //     payable(owner()).transfer(msg.value);
    // }

    event Debug(string message, uint256 value);

    function preSaleBuy(
        uint256 _saleType
    ) public payable whenNotPaused nonReentrant { 
        require(_saleType == 0 || _saleType == 1, "Invalid sale type");
        uint256 _saleId = getSaleIdByType(_saleType);
        require(isActive(_saleId), "Sale is not active");
        require(presaleActive, "Presale is OFF");
        require(msg.value > 0, "Invalid amount");

        SaleDetail memory detail = salesDetailMap[_saleId];
        UserToken memory userToken = userTokenMap[_saleId][_msgSender()];

        uint256 _tokens = calculateToken(msg.value, detail.rate);
        emit Debug("Tokens calculated", _tokens);
        emit Debug("Minimum bound", detail.minBound);
        emit Debug("Initial tokens", initialTokens);

        require(
            _tokens >= detail.minBound && _tokens <= initialTokens,
            "Invalid token amount"
        );

        userToken.saleRound = _saleId;
        userToken.createdOn = block.timestamp;
        userToken.lastClaimedTime = block.timestamp;
        userToken.tokensPurchased += _tokens;
        userToken.remainingTokens += _tokens;

        emit BoughtTokens(msg.sender, _tokens, _saleId);
        detail.tokenSold += _tokens;
        detail.raisedIn += msg.value;
        initialTokens -= _tokens;
        salesDetailMap[_saleId] = detail;
        userTokenMap[_saleId][_msgSender()] = userToken;
        payable(owner()).transfer(msg.value);
    }

    /**
     * Calculate the number of tokens to be released_
     */
    function calculateReleaseToken(
        uint256 _tokensPurchased,
        uint256 lastClaimedTime,
        uint256 currentTime,
        uint256 _saleId
    ) public view returns (uint256) {
            require(currentTime >= lastClaimedTime, "Current time must be greater than or equal to last claimed time");

        uint256 vestingDuration = currentTime - lastClaimedTime;
        uint256 totalVestingDuration = VESTING_PERIOD;

        // Calculate the total number of tokens that should have vested by now
        uint256 vestedTokens = (_tokensPurchased * vestingDuration) /
            totalVestingDuration;

        // Calculate the number of tokens that can be claimed now
        uint256 claimableTokens = vestedTokens -
            (userTokenMap[_saleId][_msgSender()].claimed);

        return claimableTokens;
    }

    function calculateToken(
        uint256 _amount,
        uint256 _rate
    ) public pure returns (uint256) {
        return (_amount * _rate) / 10 ** 18;
    }

    function claim(uint256 _saleId) external whenNotPaused nonReentrant {
        UserToken memory utoken = userTokenMap[_saleId][_msgSender()];
        require(utoken.saleRound == _saleId, "Not purchase data");
        require(utoken.remainingTokens != 0, "No tokens left");


        uint256 claimedOn = utoken.lastClaimedTime == utoken.createdOn
            ? utoken.createdOn
            : utoken.lastClaimedTime;
        uint256 amount = calculateReleaseToken(
            utoken.tokensPurchased,
            claimedOn,
            block.timestamp,
            _saleId
        );
        require(amount > 0, "No rewards");
        require(amount <= tokensAvailable(), "Insufficient token balance");

        utoken.claimed += amount;
        utoken.remainingTokens -= amount;
        utoken.lastClaimedTime = block.timestamp;
        userTokenMap[_saleId][_msgSender()] = utoken;
        token.transfer(_msgSender(), amount);
        emit Claimed(_msgSender(), amount, _saleId);
    }

    /**
     * Get the number of tokens available in the contract
     */
    function tokensAvailable() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    /**
     * Withdraw ETH from the contract
     */
    function withdrawETH(address admin) external onlyOwner {
        payable(admin).transfer(address(this).balance);
    }

    /**
     * Withdraw tokens from the contract
     */
    function withdrawToken(
        address admin,
        address _paymentToken
    ) external onlyOwner {
        IERC20 _token = IERC20(_paymentToken);
        uint256 amount = _token.balanceOf(address(this));
        token.transfer(admin, amount);
    }
}
