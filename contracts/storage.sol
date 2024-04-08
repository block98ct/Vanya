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
    function initialize() public initializer {
        __Ownable_init(_msgSender());
    }

    // Mapping to store project contracts
    mapping(address => bool) public isProjectContract;

    // Event to log the creation of a new project
    event ProjectCreated(address indexed projectContract, address indexed owner);

    // Function to create a new project
    function createProject() public {
        ProjectContract newProject = new ProjectContract();
        newProject.initialize(msg.sender);
        isProjectContract[address(newProject)] = true;
        emit ProjectCreated(address(newProject), msg.sender);
    }
}
