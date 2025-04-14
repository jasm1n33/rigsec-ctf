// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import {Test, console} from "forge-std/Test.sol";
// import {Challenge} from "../src/Challenge.sol";
// import {Solve} from "../src/Solve.sol";

// contract SolveTest is Test {
//     Challenge challenge;
//     Solve solve;

//     function setUp() public {
//         challenge = new Challenge();
//         solve = new Solve();
//     }

//     function test_solve() public {
//         vm.startPrank(0x2D1d32dB1444939E32b801f577446133B2863133);
//         deal(0x2D1d32dB1444939E32b801f577446133B2863133, 1000 ether);
//         solve.solve{value: 20e18}(challenge);
//         require(challenge.isSolved(), "!solved");
//         vm.stopPrank();
//     }
// }
