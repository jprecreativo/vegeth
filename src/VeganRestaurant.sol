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

    function addRestaurant(string memory plusCode) external {
        require(bytes(plusCode).length > 0, "Plus code cannot be empty.");
        require(restaurants[plusCode].owner == address(0), "Restaurant already exists.");

        restaurants[plusCode] = Restaurant({owner: msg.sender, avgRating: 0, totalRatings: 0});
    }
}
