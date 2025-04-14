// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Chal} from "../src/Chal.sol";
import {Solve} from "../src/Solve.sol";

contract SolveTest is Test {
    Chal chal;
    Solve solve;

    function setUp() public {
        chal = new Chal();
        //chal = Chal(address(0x31986B0f4aD8710c90aDb22716DB44FDC2dc3aE6));
        solve = new Solve();
    }

    function test_solve() public {
        vm.prank(address(0x71556C38F44e17EC21F355Bd18416155000BF5a6));
        solve.solve(chal);
        require(chal.isSolved(), "!solved");
    }
}
