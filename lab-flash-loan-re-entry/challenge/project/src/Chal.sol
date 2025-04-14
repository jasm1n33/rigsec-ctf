// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {FlashLoanContract} from "../script/FlashLoanContract.sol";
import {USDT} from "../script/USDT.sol";

contract Chal {
    FlashLoanContract public flashloancontract;
    USDT public usdt;
    constructor() {
        usdt = new USDT( "USDT" ,address(this));
        usdt._mint();
        flashloancontract = new FlashLoanContract(address(usdt));
        usdt.approve(address(flashloancontract), usdt.balanceOf(address(this)));
        flashloancontract.deposit(usdt.balanceOf(address(this)));
    }

    function isSolved() external view returns (bool) {
        return (usdt.balanceOf(address(flashloancontract)) == 0);
    }
}
