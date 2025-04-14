// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IWETH9 {
    function deposit() external payable;
}

interface IPair {
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
}

interface IERC20 {
    function transfer(address, uint) external;
    function balanceOf(address) external view returns (uint256);
}

contract Challenge {
    address constant WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    address constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    address constant DAI = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);

    constructor() payable {
        IWETH9(WETH).deposit{value: msg.value}();
    }

    function swap(address pair, uint256 tokenYouWant, uint256 amount) external {
        if (tokenYouWant == 0) {
            IPair(pair).swap(amount, 0, address(this), "");
        } else {
            IPair(pair).swap(0, amount, address(this), "");
        }
    }

    function transfer(address token, address to, uint amount) external {
        IERC20(token).transfer(to, amount);
    }

    function isSolved() external view returns (bool) {
        return (IERC20(USDC).balanceOf(address(this)) > 3000e6 && IERC20(DAI).balanceOf(address(this)) > 3000e18);
    }
}
