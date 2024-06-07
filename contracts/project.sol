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
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/common/ERC2981Upgradeable.sol";

contract ProjectContract is Initializable, OwnableUpgradeable, ERC721Upgradeable, ERC721URIStorageUpgradeable {

    // Upgradeability: Initialize function with an argument for the initial owner address
    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner);
        __ERC721_init("ProjectCertificate", "PC");
        __ERC721URIStorage_init();
    }

    uint256 private projectId;

    // Struct to represent project data
    struct ProjectData {
        string latitude;
        string longitude;
        string projectAddress;
        string area;
        string ndvi;
        string carbon;
        string npar;
        string par;
        string kmlLink;
        string geoJsonLink;
        string projectType;
        string carbonCredits;
        string amountWorth;
        uint256 updatedAt;
        uint256 createdAt;
    }

    /************** MAPPINGS  ***********/

    // Mapping to store project data for each project ID
    mapping(uint256 => ProjectData) public projectData;

    // Mapping to store carbon estimation with each timestamp
    mapping(uint256 => string) public carbonData;

    // Mapping to store carbon estimation with each timestamp
    mapping(uint256 => string) public ndviData;

    /************ EVENTS  ***********/

    // Event to log the issuance of a certificate
    event CertificateIssued(address indexed owner, uint256 indexed tokenId);

    // Event to log the addition of project data
    event ProjectDataAdded(uint256 indexed projectId);

    // Event to log the modification of project data
    event ProjectDataModified(uint256 indexed projectId);

    // Function to add project data
    function addProjectData(
        string memory _latitude,
        string memory _longitude,
        string memory _projectAddress,
        string memory _area,
        string memory _ndvi,
        string memory _carbon,
        string memory _npar,
        string memory _par,
        string memory _kmlLink,
        string memory _geoJsonLink,
        string memory _projectType,
        string memory _carbonCredits,
        string memory _amountWorth
              
    ) external {
        projectId++;
        require(projectId > 0, "Project ID must be greater than zero");
        require(projectData[projectId].createdAt == 0, "Project data already exists for this project ID");

        projectData[projectId] = ProjectData(
            _latitude,
            _longitude,
            _projectAddress,
            _area,
            _ndvi,
            _carbon,
            _npar,
            _par,
            _kmlLink,
            _geoJsonLink,
            _projectType,
            _carbonCredits,
            _amountWorth,
            0,
            block.timestamp
        );

        carbonData[block.timestamp] = _carbon;
        ndviData[block.timestamp] = _ndvi;
        emit ProjectDataAdded(projectId);
    }

    // Function to edit project data (only owner)
    function updateProjectData(
        uint256 _projectId,
        string memory _latitude,
        string memory _longitude,
        string memory _projectAddress,
        string memory _area,
        string memory _ndvi,
        string memory _carbon,
        string memory _npar,
        string memory _par,
        string memory _kmlLink,
        string memory _geoJsonLink,
        string memory _projectType,
        string memory _carbonCredits,
        string memory _amountWorth
    ) external onlyOwner {
        require(_projectId > 0, "Project ID must be greater than zero");
        require(projectData[_projectId].createdAt > 0, "Project data does not exist for this project ID");
        uint256 createdAtTime = projectData[_projectId].createdAt;

        projectData[_projectId] = ProjectData(
            _latitude,
            _longitude,
            _projectAddress,
            _area,
            _ndvi,
            _carbon,
            _npar,
            _par,
            _kmlLink,
            _geoJsonLink,
            _projectType,
            _carbonCredits,
            _amountWorth,
            block.timestamp,
            createdAtTime
        );

        carbonData[block.timestamp] = _carbon;
        ndviData[block.timestamp] = _ndvi;
        emit ProjectDataModified(_projectId);
    }

    function issueCertificate(address to, uint256 _projectId, string memory uri) public onlyOwner {
        uint256 tokenId = _projectId; // You can customize the tokenId based on your requirements
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        emit CertificateIssued(to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return ERC721URIStorageUpgradeable.tokenURI(tokenId);
    }
}
