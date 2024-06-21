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

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract Vanya is ERC20, ERC20Burnable, ERC20Pausable, Ownable, ERC20Permit {
    constructor(address initialOwner)
        ERC20("Vanya", "Vanya")
        Ownable(initialOwner)
        ERC20Permit("Vanya")
    {
        _mint(msg.sender, 125000000 * 10 ** decimals());
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Pausable)
    {
        super._update(from, to, value);
    }


}