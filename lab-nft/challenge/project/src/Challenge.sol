// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {IERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import {IERC721Metadata} from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract Challenge {
    bool public solved;

    constructor() {}

    function solve(address nft) external {
        string memory name = "MY-NFT";
        string memory symbol = "MYNFT";
        require(Strings.equal(IERC721Metadata(nft).name(), name), "Challenge: name is not match");
        require(Strings.equal(IERC721Metadata(nft).symbol(), symbol), "Challenge: symbol is not match");
        // check the nft total supply is 5
        require(IERC721Enumerable(nft).totalSupply() == 5, "Challenge: total supply is not 5");
        // check the base URI
        string memory tokenURI = "ipfs://bafybeibc5sgo2plmjkq2tzmhrn54bk3crhnc23zd2msg4ea7a4pxrkgfna/1";
        require(Strings.equal(IERC721Metadata(nft).tokenURI(1), tokenURI), "Challenge: tokenURI is not match");
        solved = true;
    }

    function isSolved() external view returns (bool) {
        return solved;
    }
}
