// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Token} from "../src/Token.sol";

contract Challenge {

    Token public token;

    mapping(address => uint256) public balances;

    constructor() {
        token = new Token();
    }

    function deposit(uint256 amount) external {
        token.transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
    }

    function withdraw(uint256 amount) external {
        balances[msg.sender] -= amount;
        token.transfer(msg.sender, amount);
    }

    function flashLoan(uint256 amount) external {
        uint256 before_balance = token.balanceOf(address(this));

        token.transfer(msg.sender, amount);

        uint256 after_balance = token.balanceOf(address(this));
        require(after_balance >= before_balance, "Failed to execute flash loan");
    }

    function isSolved() public view returns (bool) {
        return token.balanceOf(address(this)) == 0;
    }
}