// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

import {Script, console} from "forge-std/Script.sol";
import {VeganRestaurant} from "../src/VeganRestaurant.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract VeganRestaurantScript is Script {
    VeganRestaurant public restaurant;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // Deploy the v1 implementation.
        VeganRestaurant implementation = new VeganRestaurant();

        // Simulate an address for the deployer.
        address msgSender = msg.sender;

        console.log("Message sender address:", msgSender);

        // Encode the initialization data.
        bytes memory data = abi.encodeCall(VeganRestaurant.initialize, msgSender);

        // Deploy the proxy, pointing it to v1 and initializing it.
        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), data);

        // Cast the proxy address to the v1 interface so we can interact with it.
        VeganRestaurant restaurantProxy = VeganRestaurant(address(proxy));

        console.log("Proxy deployed at:", address(proxy));

        restaurantProxy.addRestaurant("344FWHMC+24F");

        (address owner, uint256 avgRating, uint256 totalRatings) = restaurantProxy.restaurants("344FWHMC+24F");

        console.log("Owner:", owner);
        console.log("Average Rating:", avgRating);
        console.log("Total Ratings:", totalRatings);

        vm.stopBroadcast();
    }
}
