// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interface.sol";

contract MarketETH {
    IMarketToken public marketToken;
    
    address internal owner;
    uint256 public totalBalance;
    mapping(address => uint256) public collateral;
    mapping(address => uint256) public debt;
    
    constructor() {
        owner = msg.sender;
    }

    function set(address _marketToken) external {
        require(msg.sender == owner, "only owner can set marketToken");
        marketToken = IMarketToken(_marketToken);
    }

    function deposit() external payable {
        collateral[msg.sender] += msg.value;
        totalBalance += msg.value;
    }

    function borrow(uint256 amount) external {
        uint256 user_collateral = collateral[msg.sender] + marketToken.collateral(msg.sender);
        uint256 user_debt = debt[msg.sender] + marketToken.debt(msg.sender);

        require(user_collateral >= user_debt + amount, "insufficient balance");
        (bool success,) = payable(msg.sender).call{value: amount}(new bytes(0));
        require(success, "Failed to transfer Ether");

        debt[msg.sender] += amount;
    }

    receive() external payable {}
}