// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

import "./VeganRestaurant.sol";

contract VeganRestaurant_v2 is VeganRestaurant {
    function initialize(address initialOwner) public override initializer {
        __Ownable_init(initialOwner);
        version = 2;
    }

    function rateRestaurant(string memory plusCode, uint256 _rating) public {
        require(_rating >= 1 && _rating <= 5, "The rating must be between 1 and 5.");

        Restaurant storage restaurant = restaurants[plusCode];
        uint256 currentTotalScore = restaurant.avgRating * restaurant.totalRatings;
        uint256 newTotalRatings = restaurant.totalRatings + 1;

        restaurant.avgRating = (currentTotalScore + (_rating * 10)) / newTotalRatings;
        restaurant.totalRatings = newTotalRatings;
    }

    function getRestaurantRating(string memory plusCode) public view returns (uint256) {
        Restaurant storage restaurant = restaurants[plusCode];

        return restaurant.avgRating;
    }

    function tip(string memory plusCode) public payable {
        require(msg.value > 0, "Tip amount must be greater than zero.");

        address ownerAddr = restaurants[plusCode].owner;

        require(ownerAddr != address(0), "Restaurant does not exist.");

        (bool success,) = ownerAddr.call{value: msg.value}("");
        require(success, "Failed to send tip.");
    }
}
