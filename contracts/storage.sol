//  /$$    /$$  /$$$$$$  /$$   /$$ /$$     /$$ /$$$$$$
// | $$   | $$ /$$__  $$| $$$ | $$|  $$   /$$//$$__  $$
// | $$   | $$| $$  \ $$| $$$$| $$ \  $$ /$$/| $$  \ $$
// |  $$ / $$/| $$$$$$$$| $$ $$ $$  \  $$$$/ | $$$$$$$$
//  \  $$ $$/ | $$__  $$| $$  $$$$   \  $$/  | $$__  $$
//   \  $$$/  | $$  | $$| $$\  $$$    | $$   | $$  | $$
//    \  $/   | $$  | $$| $$ \  $$    | $$   | $$  | $$
//     \_/    |__/  |__/|__/  \__/    |__/   |__/  |__/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";

import "./project.sol";

contract StorageContract is Initializable, OwnableUpgradeable {
    address private projectOwner;
    function initialize() public initializer {
        __Ownable_init(_msgSender());
     projectOwner = 0x4F02C3102A9D2e1cC0cC97c7fE2429B9B6F5965D;
    }

    // Mapping to store project contracts
    mapping(address => bool) public isProjectContract;

    // Event to log the creation of a new project
    event ProjectCreated(address indexed projectContract);

    // Function to create a new project
    function createProject() public {
        ProjectContract newProject = new ProjectContract();
        newProject.initialize(projectOwner);
        isProjectContract[address(newProject)] = true;
        emit ProjectCreated(address(newProject));
    }
}
