// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import { CommonBase } from "forge-std/Base.sol";
import { Chal } from "src/Chal.sol";
import { Solve } from "src/Solve.sol";

contract Exp is CommonBase {
    Chal chal;
    uint256 privKey;

    constructor() {
        chal = Chal(vm.envAddress("CHAL_ADDR"));
        privKey = uint256(vm.envBytes32("PRIV_KEY"));
    }

    function run() public {
        vm.startBroadcast(privKey);
        Solve solve = new Solve();
        solve.solve(chal);
        require(chal.isSolved(), "!solved");
        vm.stopBroadcast();
    }
}
