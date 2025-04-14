// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {GameToken} from "../script/gametoken.sol";
import {UniswapV2Pair} from "../script/uniswapv2pair.sol";
import {USDT} from "../script/USDT.sol";

contract Chal {
    GameToken public gametoken;
    USDT public usdt;
    UniswapV2Pair public lp;
    bool public get;

    constructor() {
        gametoken = new GameToken();
        usdt = new USDT("USDT", address(this));
        usdt._mint();
        lp = new UniswapV2Pair(address(this));
        lp.initialize(address(usdt), address(gametoken));
        gametoken.transfer(address(lp), 1_000_000 * 10 ** 18);
        usdt.transfer(address(lp), 1000 * 10 ** 18);
        lp.sync();
    }

    function getusdt() external returns (uint256) {
        require(get != true);
        get = true;
        usdt.transfer(address(msg.sender), 9000 * 10 ** 18);
    }

    function swap_pair(bool token0, uint256 amount) external {
        if (token0) {
            usdt.transferFrom(address(msg.sender), address(lp), amount);
            (uint256 reserve0, uint256 reserve1, uint32 blockTimestampLast) = lp.getReserves();
            uint256 outamount = reserve1 - (reserve0 * reserve1 / (reserve0 + amount)) - 1;
            outamount = outamount * 100 / 110;
            lp.swap(0, outamount, address(msg.sender), "");
        } else {
            gametoken.transferFrom(address(msg.sender), address(lp), amount);
            (uint256 reserve0, uint256 reserve1, uint32 blockTimestampLast) = lp.getReserves();
            uint256 outamount = reserve0 - (reserve0 * reserve1 / (reserve1 + amount)) - 1;
            lp.swap(outamount, 0, address(msg.sender), "");
        }
    }

    function isSolved() external view returns (bool) {
        return (usdt.balanceOf(address(lp)) <= 100 * 10 ** 18);
    }
}
