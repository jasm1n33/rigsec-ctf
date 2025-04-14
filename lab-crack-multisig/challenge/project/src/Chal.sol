// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Token} from "../src/Token.sol";
import {Box} from "../src/Box.sol";

contract Chal {
    Token public token;
    Box public box;

    constructor() {
        token = new Token();
        box = new Box();
        token.transfer(address(box), 1337);
        box.setGuardians(address(0x71556C38F44e17EC21F355Bd18416155000BF5a6));
        box.setGuardians(address(0xdeadbeef));
    }

    function isSolved() external view returns (bool) {
        return (token.balanceOf(address(box)) == 0);
    }
}
