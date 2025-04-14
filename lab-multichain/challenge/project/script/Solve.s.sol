// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Solve} from "./Solve.sol";

contract SolveScript is Script {
    address constant CHAL = address(/*CHAL_ADDRESS*/);

    function run() public {
        vm.startBroadcast();

        Solve solve = new Solve();
        solve.solve(CHAL);

        vm.stopBroadcast();
    }
}
