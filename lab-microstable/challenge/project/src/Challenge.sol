// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {MicroStable} from "./MicroStable.sol";

contract Challenge {
    MicroStable public microStable;
    bool public solved;

    constructor() {
        microStable = new MicroStable();
    }

    function solve() external {
        require(
            microStable.collateralRatio(msg.sender) > 2e18 && microStable.debt(msg.sender) > 0, "Challenge: Not Solved!"
        );
        solved = true;
    }

    function isSolved() external view returns (bool) {
        return solved;
    }
}
