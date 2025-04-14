// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Enum {
    enum Operation {
        Call,
        DelegateCall
    }
}

contract MasterCopy {
    function execute(
        address to,
        uint256 value,
        bytes memory data,
        Enum.Operation operation
    ) external returns (bool success) {
		uint txGas = gasleft() - 2500;
        if (operation == Enum.Operation.DelegateCall) {
            /* solhint-disable no-inline-assembly */
            /// @solidity memory-safe-assembly
            assembly {
                success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
            }
            /* solhint-enable no-inline-assembly */
        } else {
			if ( bytes4(data) == 0xa9059cbb ) revert("transfer() not allowed");
			if ( bytes4(data) == 0x095ea7b3 ) revert("approve() not allowed");

            /* solhint-disable no-inline-assembly */
            /// @solidity memory-safe-assembly
            assembly {
                success := call(txGas, to, value, add(data, 0x20), mload(data), 0, 0)
            }
            /* solhint-enable no-inline-assembly */
        }       
    }
}
