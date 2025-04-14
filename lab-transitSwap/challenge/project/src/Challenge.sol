// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Token} from "../src/Token.sol";

contract Challenge {
    Token public token;
    address constant TRANSIT_SWAP = 0x8785bb8deAE13783b24D7aFE250d42eA7D7e9d72;
    address constant APPROVE_GOV = 0xeD1afC8C4604958C2F38a3408FA63B32E737c428;

    constructor() {
        token = new Token();
        token.approve(APPROVE_GOV, 1 ether);
    }

    function isSolved() external view returns (bool) {
        return (token.balanceOf(address(this)) == 0);
    }
}