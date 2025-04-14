// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Box {
    address owner;
    mapping(address => bool) guardians;

    constructor() {
        owner = msg.sender;
    }

    function setGuardians(address addr) external {
        require(msg.sender == owner, "!owner");
        guardians[addr] = true;
    }

    function go(address target, bytes calldata data, bytes[] memory signaturesSortedBySigners) external payable {
        require(signaturesSortedBySigners.length >= 2, "need more signers");
        require(
            validateSignatures(keccak256(abi.encode(target, data)), signaturesSortedBySigners), "not valid signatures"
        );
        (bool ok,) = target.call{value: msg.value}(data);
        require(ok, "!ok");
    }

    function validateSignatures(bytes32 digest, bytes[] memory signaturesSortedBySigners) public view returns (bool) {
        bytes32 lastSignHash = bytes32(0); // ensure that the signers are not duplicated

        for (uint256 i = 0; i < signaturesSortedBySigners.length; i++) {
            address signer = recoverSigner(digest, signaturesSortedBySigners[i]);
            require(guardians[signer], "Not a guardian");

            bytes32 signHash = keccak256(signaturesSortedBySigners[i]);
            if (signHash <= lastSignHash) {
                return false;
            }

            lastSignHash = signHash;
        }

        return true;
    }

    function recoverSigner(bytes32 digest, bytes memory signature) public pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;
        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }
        return ecrecover(digest, v, r, s);
    }
}
