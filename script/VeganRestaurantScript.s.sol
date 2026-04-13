// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

import {Script, console} from "forge-std/Script.sol";
import {VeganRestaurant} from "../src/VeganRestaurant.sol";
import {VeganRestaurant_v2} from "../src/VeganRestaurant_v2.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract VeganRestaurantScript is Script {
    VeganRestaurant public restaurant;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // ---------------------------------------------
        // 1. DEPLOY V1
        // ---------------------------------------------

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

        (address owner,,) = restaurantProxy.restaurants("344FWHMC+24F");

        console.log("[v1] Owner:", owner);

        // ---------------------------------------------
        // 2. UPGRADE TO V2
        // ---------------------------------------------

        // Deploy the new V2 implementation.
        VeganRestaurant_v2 implementation_v2 = new VeganRestaurant_v2();

        // Call the upgrade function via the proxy.
        // Since restaurantProxy is an Ownable UUPS contract, only the owner can do this.
        restaurantProxy.upgradeToAndCall(address(implementation_v2), "");

        // Cast the proxy to the new V2 interface.
        VeganRestaurant_v2 restaurantProxy_v2 = VeganRestaurant_v2(address(proxy));

        restaurantProxy_v2.addRestaurant("8FVC9G8F+6X");

        (address owner_v2,,) = restaurantProxy_v2.restaurants("8FVC9G8F+6X");

        console.log("[v2] Owner:", owner_v2);

        vm.stopBroadcast();
    }
}
