// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {VeganRestaurant} from "../src/VeganRestaurant.sol";

contract VeganRestaurantScript is Script {
    VeganRestaurant public restaurant;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        restaurant = new VeganRestaurant();

        vm.stopBroadcast();
    }
}
