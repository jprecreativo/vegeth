// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract VeganRestaurant {
    struct Restaurant {
        address owner;
        uint256 avgRating;
        uint256 totalRatings;
    }
    // Version number for the contract.
    uint256 public version = 1;
    // Mapping from the Open Location Code (Plus Code) to its details.
    mapping(string => Restaurant) public restaurants;

    modifier onlyOwner(string memory plusCode) {
        require(restaurants[plusCode].owner == msg.sender, "Only the owner can perform this action.");

        _;
    }

    function addRestaurant(string memory plusCode) public {
        require(bytes(plusCode).length > 0, "Plus code cannot be empty.");
        require(restaurants[plusCode].owner == address(0), "Restaurant already exists.");

        restaurants[plusCode] = Restaurant({owner: msg.sender, avgRating: 0, totalRatings: 0});
    }

    function deleteRestaurant(string memory plusCode) public onlyOwner(plusCode) {
        delete restaurants[plusCode];
    }

    function modifyRestaurant(string memory plusCode, string memory newPlusCode) external onlyOwner(plusCode) {
        require(bytes(plusCode).length > 0, "Plus code cannot be empty.");
        require(restaurants[plusCode].owner != address(0), "Restaurant does not exist.");

        uint256 currentAvgRating = restaurants[plusCode].avgRating;
        uint256 currentTotalRatings = restaurants[plusCode].totalRatings;

        deleteRestaurant(plusCode);
        addRestaurant(newPlusCode);

        restaurants[newPlusCode].avgRating = currentAvgRating;
        restaurants[newPlusCode].totalRatings = currentTotalRatings;
    }
}
