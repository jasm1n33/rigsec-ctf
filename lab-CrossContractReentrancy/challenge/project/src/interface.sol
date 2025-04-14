// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IMarketETH {
    function deposit() external payable;
    function borrow(uint256 amount) external;
    function totalBalance() external;
    function collateral(address user) external returns (uint256);
    function debt(address user) external returns (uint256);
}

interface IMarketToken {
    function deposit(uint256 amount) external;
    function borrow(uint256 amount) external;
    function totalBalance() external;
    function collateral(address user) external returns (uint256);
    function debt(address user) external returns (uint256);
}

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function mint(address recipient, uint256 amount, bytes calldata userData, bytes calldata operatorData) external;
}