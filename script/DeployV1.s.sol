// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

import {Script, console} from "forge-std/Script.sol";
import {VeganRestaurant} from "../src/VeganRestaurant.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployV1 is Script {
    function run() public {
        // 1. Load the private key from the .env file
        uint256 deployerPrivateKey = vm.envUint("SEPOLIA_PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);

        console.log("Deployer address:", deployerAddress);

        // 2. Start broadcasting transactions to the network
        vm.startBroadcast(deployerPrivateKey);

        // 3. Deploy the V1 implementation
        VeganRestaurant implementation = new VeganRestaurant();
        console.log("V1 Implementation deployed at:", address(implementation));

        // 4. Encode the initialization data
        bytes memory data = abi.encodeCall(VeganRestaurant.initialize, deployerAddress);

        // 5. Deploy the proxy and point it to V1
        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), data);
        console.log("Proxy deployed at:", address(proxy));

        // Optional: Cast to interact and test
        VeganRestaurant restaurantProxy = VeganRestaurant(address(proxy));
        restaurantProxy.addRestaurant("344FWHMC+24F");

        (address owner,,) = restaurantProxy.restaurants("344FWHMC+24F");
        console.log("[v1] Owner:", owner);

        vm.stopBroadcast();
    }
}
