// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {VeganRestaurant} from "../src/VeganRestaurant.sol";

contract VeganRestaurantTest is Test {
    VeganRestaurant public restaurant;

    function setUp() public {
        restaurant = new VeganRestaurant();
    }

    // 1. Check require: Plus code cannot be empty.
    function test_RevertIf_PlusCodeEmpty() public {
        vm.expectRevert("Plus code cannot be empty.");
        restaurant.addRestaurant("");
    }

    // 2. Check require: Restaurant already exists.
    function test_RevertIf_RestaurantExists() public {
        string memory code = "8FVC9G8F+6X";

        // First addition.
        restaurant.addRestaurant(code);

        // Expect failure on second addition of the same code.
        vm.expectRevert("Restaurant already exists.");
        restaurant.addRestaurant(code);
    }

    // 3. Check successful addition.
    function test_AddRestaurant() public {
        string memory code = "8FVC9G8F+6X";
        address user = address(0x123);

        // Tell Foundry that the next call should come from 'user'
        vm.prank(user);
        restaurant.addRestaurant(code);

        // Retrieve the data to verify.
        (address owner, uint256 avgRating, uint256 totalRatings) = restaurant.restaurants(code);

        assertEq(owner, user);
        assertEq(avgRating, 0);
        assertEq(totalRatings, 0);
    }

    // 4. Check require: Only the owner can delete.
    function test_RevertIf_NotOwnerDeletes() public {
        string memory code = "8FVC9G8F+6X";
        address owner = address(0x123);
        address attacker = address(0x456);

        // Owner adds the restaurant.
        vm.prank(owner);
        restaurant.addRestaurant(code);

        // Attacker tries to delete it.
        vm.prank(attacker);
        vm.expectRevert("Only the owner can perform this action.");
        restaurant.deleteRestaurant(code);
    }

    // 5. Check successful deletion.
    function test_DeleteRestaurant() public {
        string memory code = "8FVC9G8F+6X";
        address user = address(0x123);

        // Add a restaurant first.
        vm.prank(user);
        restaurant.addRestaurant(code);

        // Now delete it.
        vm.prank(user);
        restaurant.deleteRestaurant(code);

        // Verify deletion.
        (address owner, uint256 avgRating, uint256 totalRatings) = restaurant.restaurants(code);
        assertEq(owner, address(0));
        assertEq(avgRating, 0);
        assertEq(totalRatings, 0);
    }

    // 6. Check require: Only the owner can modify.
    function test_RevertIf_NotOwnerModifies() public {
        string memory code = "8FVC9G8F+6X";
        address owner = address(0x123);
        address attacker = address(0x456);

        // Owner adds the restaurant.
        vm.prank(owner);
        restaurant.addRestaurant(code);

        // Attacker tries to modify it.
        vm.prank(attacker);
        vm.expectRevert("Only the owner can perform this action.");
        restaurant.modifyRestaurant(code, "8FVC9G8F+6Y");
    }

    // 7. Check successful modification.
    function test_ModifyRestaurant() public {
        string memory code = "8FVC9G8F+6X";
        string memory newCode = "8FVC9G8F+6Y";
        address user = address(0x123);

        // Add a restaurant first.
        vm.prank(user);
        restaurant.addRestaurant(code);

        // Modify the restaurant.
        vm.prank(user);
        restaurant.modifyRestaurant(code, newCode);

        // Verify modification.
        (address owner, uint256 avgRating, uint256 totalRatings) = restaurant.restaurants(newCode);
        assertEq(owner, user);
        assertEq(avgRating, 0);
        assertEq(totalRatings, 0);

        // Old code should be deleted.
        (address oldOwner, uint256 oldAvgRating, uint256 oldTotalRatings) = restaurant.restaurants(code);
        assertEq(oldOwner, address(0));
        assertEq(oldAvgRating, 0);
        assertEq(oldTotalRatings, 0);
    }
}
