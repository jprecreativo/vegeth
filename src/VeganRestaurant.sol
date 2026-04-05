// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract VeganRestaurant is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    struct Restaurant {
        address owner;
        uint256 avgRating;
        uint256 totalRatings;
    }

    // Version number for the contract.
    uint256 public version;

    // Mapping from the Open Location Code (Plus Code) to its details.
    mapping(string => Restaurant) public restaurants;

    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner);
        version = 1;
    }

    modifier onlyRestaurantOwner(string memory plusCode) {
        require(restaurants[plusCode].owner == msg.sender, "Only the owner can perform this action.");
        _;
    }

    function addRestaurant(string memory plusCode) public {
        require(bytes(plusCode).length > 0, "Plus code cannot be empty.");
        require(restaurants[plusCode].owner == address(0), "Restaurant already exists.");

        restaurants[plusCode] = Restaurant({owner: msg.sender, avgRating: 0, totalRatings: 0});
    }

    function deleteRestaurant(string memory plusCode) public onlyRestaurantOwner(plusCode) {
        delete restaurants[plusCode];
    }

    function modifyRestaurant(string memory plusCode, string memory newPlusCode)
        external
        onlyRestaurantOwner(plusCode)
    {
        require(bytes(plusCode).length > 0, "Plus code cannot be empty.");
        require(restaurants[plusCode].owner != address(0), "Restaurant does not exist.");

        uint256 currentAvgRating = restaurants[plusCode].avgRating;
        uint256 currentTotalRatings = restaurants[plusCode].totalRatings;

        deleteRestaurant(plusCode);
        addRestaurant(newPlusCode);

        restaurants[newPlusCode].avgRating = currentAvgRating;
        restaurants[newPlusCode].totalRatings = currentTotalRatings;
    }

    // This restricts contract upgrades to the global owner of the contract.
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
