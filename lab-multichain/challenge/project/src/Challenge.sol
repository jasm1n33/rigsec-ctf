// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Token} from "../src/Token.sol";

contract Challenge {
    Token public token;
    address constant ANYSWAP_V4_ROUTER = 0x6b7a87899490EcE95443e979cA9485CBE7E71522;

    constructor() {
        token = new Token();
        token.approve(ANYSWAP_V4_ROUTER, 1 ether);
    }

    function isSolved() external view returns (bool) {
        return (token.balanceOf(address(this)) == 0);
    }
}