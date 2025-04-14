// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract FlashLoanContract {
    address public owner;
    IERC20 public token;

    mapping(address => uint256) public deposits;

    constructor(address _tokenAddress) {
        owner = msg.sender;
        token = IERC20(_tokenAddress);
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Deposit amount must be greater than zero");
        require(token.transferFrom(msg.sender, address(this), amount), "Deposit failed");
        deposits[msg.sender] += amount;
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Withdraw amount must be greater than zero");
        require(deposits[msg.sender] >= amount, "Insufficient deposited balance");

        deposits[msg.sender] -= amount;
        require(token.transfer(msg.sender, amount), "Withdraw failed");
    }

    function flashLoan(uint256 amount, address borrower, bytes calldata data) external {
        require(amount > 0, "Loan amount must be greater than zero");
        require(token.balanceOf(address(this)) >= amount, "Insufficient liquidity for loan");

        uint256 initialBalance = token.balanceOf(address(this));

        require(token.transfer(borrower, amount), "Flash loan transfer failed");

        (bool success, ) = borrower.call(data);
        require(success, "Callback execution failed");

        uint256 currentBalance = token.balanceOf(address(this));
        require(currentBalance >= initialBalance, "Loan not repaid");
    }
}