// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface ITokenReceiver {
    function onTokenReceived(address from, uint256 amount) external returns (bytes4);
}

contract Token is ERC20("XYZ", "XYZ") {
    constructor() {
        _mint(msg.sender, 1 ether);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        super.transfer(recipient, amount);
        if (recipient.code.length > 0) {
            try ITokenReceiver(recipient).onTokenReceived(msg.sender, amount) returns (bytes4 result) {
                require(result == ITokenReceiver.onTokenReceived.selector, "Invalid onTokenReceived response");
            } catch {
                revert("Failed to call onTokenReceived");
            }
        }
        return true;
    }
}
