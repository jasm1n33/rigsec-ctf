// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20("XYZ", "XYZ") {
    constructor() {
        _mint(msg.sender, 1 ether);
    }

    fallback() external {}
}
