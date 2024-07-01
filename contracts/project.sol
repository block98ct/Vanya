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

contract ProjectContract is Initializable, OwnableUpgradeable {
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
        uint256 createdAt;
        uint256 updatedAt;
    }

    // Mapping to store project data for each project ID
    mapping(uint256 => mapping(uint256 => ProjectData)) public projectData;

    // Mapping to store the creation timestamps for each project ID
    mapping(uint256 => uint256) public projectCreatedAt;

    // Mapping to store array of timestamps for each project ID
    mapping(uint256 => uint256[]) public projectTimestamps;

    // Mapping to store carbon estimation with each timestamp
    mapping(uint256 => string) public carbonData;

    // Mapping to store NDVI estimation with each timestamp
    mapping(uint256 => string) public ndviData;

    // Event to log the addition of project data
    event ProjectDataAdded(uint256 indexed projectId);

    // Event to log the modification of project data
    event ProjectDataModified(uint256 indexed projectId);

    // Upgradeability: Initialize function with an argument for the initial owner address
    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner);
    }

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

        uint256 timestamp = block.timestamp;
        projectData[projectId][timestamp] = ProjectData(
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
            timestamp,
            0
        );

        carbonData[timestamp] = _carbon;
        ndviData[timestamp] = _ndvi;

        projectCreatedAt[projectId] = block.timestamp;

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
        require(projectCreatedAt[_projectId] > 0, "Project does not exists");

        uint256 createdAt = projectCreatedAt[_projectId];
        uint256 timestamp = block.timestamp;

        projectData[_projectId][timestamp] = ProjectData(
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
            projectData[_projectId][createdAt].createdAt,
            timestamp
        );

        carbonData[timestamp] = _carbon;
        ndviData[timestamp] = _ndvi;

        projectTimestamps[_projectId].push(timestamp);
        emit ProjectDataModified(_projectId);
    }

    function getProjectTimestamps(
        uint256 _projectId
    ) external view returns (uint256[] memory) {
        return projectTimestamps[_projectId];
    }

    // Function to get project data by project ID and timestamp
    function getProjectData(
        uint256 _projectId,
        uint256 _timestamp
    ) external view returns (ProjectData memory) {
        return projectData[_projectId][_timestamp];
    }
}
