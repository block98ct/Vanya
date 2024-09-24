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

contract StorageContract is
    Initializable,
    OwnableUpgradeable,
    ERC721Upgradeable,
    ERC721URIStorageUpgradeable
{

    address private preojectOwner;
    function initialize(address intialOwner) public initializer {
          preojectOwner = intialOwner;
        __Ownable_init(intialOwner);
        __ERC721_init("ProjectCertificate", "PC");
        __ERC721URIStorage_init();
    }

    uint256 private tokenId;

    // Mapping to store project contracts
    mapping(address => bool) public isProjectContract;

    // Event to log the creation of a new project
    event ProjectCreated(
        address indexed projectContract,
        address indexed owner
    );

    event CertificateIssued(address indexed owner, uint256 indexed tokenId);

    // Function to create a new project
    function createProject() public {
        ProjectContract newProject = new ProjectContract();
        newProject.initialize(preojectOwner);
        isProjectContract[address(newProject)] = true;
        emit ProjectCreated(address(newProject), msg.sender);
    }

    function issueCertificate(
        address to,
        string memory uri
    ) public onlyOwner {
        tokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        emit CertificateIssued(to, tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(
        uint256 _tokenId
    )
        public
        view
        virtual
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return ERC721URIStorageUpgradeable.tokenURI(_tokenId);
    }
}