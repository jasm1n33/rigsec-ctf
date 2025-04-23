// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {CommonBase} from "forge-std/Base.sol";
import {Challenge} from "src/Challenge.sol";
import {Solve} from "./Solve.sol";

contract Exp is CommonBase {
    Challenge challenge;
    uint256 privKey;

    constructor() {
        challenge = Challenge(payable(vm.envAddress("CHAL_ADDR")));
        privKey = uint256(vm.envBytes32("PRIV_KEY"));
    }

    function run() public {
        vm.startBroadcast(privKey);
        Solve solve = new Solve();
        solve.solve{value: 1 ether}(address(challenge));
        require(challenge.isSolved(), "!solved");
        vm.stopBroadcast();
    }
}
