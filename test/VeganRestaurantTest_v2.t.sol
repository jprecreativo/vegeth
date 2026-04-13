// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {VeganRestaurant_v2} from "../src/VeganRestaurant_v2.sol";

contract VeganRestaurantTest_v2 is Test {
    VeganRestaurant_v2 public restaurant;

    function setUp() public {
        restaurant = new VeganRestaurant_v2();
        restaurant.initialize(address(this));
    }

    function testRateRestaurant() public {
        string memory plusCode = "8FVC9G8F+6X";

        restaurant.addRestaurant(plusCode);
        restaurant.rateRestaurant(plusCode, 5);

        // We expect 5.0, but since we are storing ratings multiplied by 10, we check for 50.
        assertEq(restaurant.getRestaurantRating(plusCode), 50);

        restaurant.rateRestaurant(plusCode, 4);

        // We expect 4.5, but since we are storing ratings multiplied by 10, we check for 45.
        assertEq(restaurant.getRestaurantRating(plusCode), 45);
    }

    function testTip() public {
        string memory plusCode = "8FVC9G8F+6X";
        uint256 tipAmount = 1 ether;

        restaurant.addRestaurant(plusCode);
        vm.deal(address(this), tipAmount);
        restaurant.tip{value: tipAmount}(plusCode);

        (address ownerAddr,,) = restaurant.restaurants(plusCode);

        assertEq(ownerAddr.balance, tipAmount);
    }

    receive() external payable {}
}
