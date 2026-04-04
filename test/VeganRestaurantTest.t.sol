// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {VeganRestaurant} from "../src/VeganRestaurant.sol";

contract VeganRestaurantTest is Test {
    VeganRestaurant public restaurant;

    function setUp() public {
        restaurant = new VeganRestaurant();
    }
}
