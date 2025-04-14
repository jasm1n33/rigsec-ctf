// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interface.sol";

contract MarketToken {
    IMarketETH public marketETH;
    IERC20 public token;

    uint256 public totalBalance;
    mapping(address => uint256) public collateral;
    mapping(address => uint256) public debt;

    constructor(address _marketETH, address _token) {
        marketETH = IMarketETH(_marketETH);
        token = IERC20(_token);
    }

    function deposit(uint256 amount) external {
        token.transferFrom(msg.sender, address(this), amount);
        collateral[msg.sender] += amount;
        totalBalance += amount;
    }

    function borrow(uint256 amount) external {
        uint256 user_collateral = collateral[msg.sender] + marketETH.collateral(msg.sender);
        uint256 user_debt = debt[msg.sender] + marketETH.debt(msg.sender);

        require(user_collateral >= user_debt + amount, "insufficient balance");
        token.transfer(msg.sender, amount);
        debt[msg.sender] += amount;
    }
}