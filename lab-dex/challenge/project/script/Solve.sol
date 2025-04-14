// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Challenge} from "../src/Challenge.sol";

contract Solve {

    function solve(Challenge chal) public payable {
        address WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        address usdcWethPair = address(0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc);
        address daiWethPair = address(0xA478c2975Ab1Ea89e8196811F51A7B7Ade33eB11);
        chal.transfer(WETH, usdcWethPair, 2e18);
        chal.swap(usdcWethPair, 0, 3001e6);
        chal.transfer(WETH, daiWethPair, 2e18);
        chal.swap(daiWethPair, 0, 3001e18);
        require(chal.isSolved(), "not solved");
    }
}

