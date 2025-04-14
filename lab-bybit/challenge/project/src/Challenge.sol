// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "src/Token.sol";
import "src/MasterCopy.sol";
import "src/Wallet.sol";

contract Challenge {
    Token public token;
    Wallet public wallet;

    constructor() payable {
        token = new Token();
        wallet = new Wallet(address(new MasterCopy()));
        token.transfer(address(wallet), 10 ether);
    }

    function isSolved() external view returns (bool) {
        return (token.balanceOf(address(wallet)) == 0);
    }
}
