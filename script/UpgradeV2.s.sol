// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

import {Script, console} from "forge-std/Script.sol";
import {VeganRestaurant} from "../src/VeganRestaurant.sol";
import {VeganRestaurant_v2} from "../src/VeganRestaurant_v2.sol";

contract UpgradeV2 is Script {
    function run() public {
        // 1. Load private key and proxy address from .env
        uint256 deployerPrivateKey = vm.envUint("SEPOLIA_PRIVATE_KEY");
        address proxyAddress = vm.envAddress("PROXY_ADDRESS");

        console.log("Upgrading Proxy at:", proxyAddress);

        vm.startBroadcast(deployerPrivateKey);

        // 2. Deploy the new V2 implementation
        VeganRestaurant_v2 implementation_v2 = new VeganRestaurant_v2();
        console.log("V2 Implementation deployed at:", address(implementation_v2));

        // 3. Upgrade the proxy
        // We cast the proxy address to the V1 interface to call upgradeToAndCall
        // (Assuming upgradeToAndCall is inherited from OpenZeppelin's UUPSUpgradeable)
        VeganRestaurant proxy = VeganRestaurant(payable(proxyAddress));
        proxy.upgradeToAndCall(address(implementation_v2), "");

        console.log("Proxy successfully upgraded to V2!");

        // Optional: Cast to V2 interface to test new functionality
        VeganRestaurant_v2 restaurantProxy_v2 = VeganRestaurant_v2(proxyAddress);
        restaurantProxy_v2.addRestaurant("8FVC9G8F+6X");

        (address owner_v2,,) = restaurantProxy_v2.restaurants("8FVC9G8F+6X");
        console.log("[v2] Owner:", owner_v2);

        vm.stopBroadcast();
    }
}
