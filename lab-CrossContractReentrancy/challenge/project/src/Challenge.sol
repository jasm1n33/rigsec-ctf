// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Token} from "../src/Token.sol";
import {MarketETH} from "../src/EthMarket.sol";
import {MarketToken} from "../src/TokenMarket.sol";

contract Challenge {
    Token public token;
    MarketETH public marketETH;
    MarketToken public marketToken;

    constructor() {
        token = new Token();
        marketETH = new MarketETH();
        marketToken = new MarketToken(address(marketETH), address(token));
        marketETH.set(address(marketToken));
        token.transfer(address(marketToken), 1 ether);
    }

    function isSolved() external view returns (bool) {
        return (token.balanceOf(address(marketToken)) + address(marketETH).balance == 0);
    }
}