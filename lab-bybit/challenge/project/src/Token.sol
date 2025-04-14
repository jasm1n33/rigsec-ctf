// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@solady/src/tokens/ERC20.sol";

contract Token is ERC20 {
    constructor() payable {
        _mint(msg.sender, 10 ether);
    }

    function name() public view virtual override returns (string memory) {
        return "XYZ";
    }

    function symbol() public view virtual override returns (string memory) {
        return "XYZ";
    }
}
