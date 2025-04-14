// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Challenge} from "../src/Challenge.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract MyToken is ERC721, ERC721Enumerable, Ownable, ReentrancyGuard {
    using Strings for uint256;

    string public baseURI;
    mapping(address => bool) minted;

    constructor(string memory baseURI_) ERC721("MY-NFT", "MYNFT") Ownable(msg.sender) {
        baseURI = baseURI_;
    }

    // --- public functions ---

    function ownerMint(address to) public onlyOwner {
        uint256 tokenId = totalSupply() + 1;
        _safeMint(to, tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // --- internal functions ---

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }
}

contract Solve {
    function solve(address _chal) public {
        Challenge chal = Challenge(_chal);

        MyToken myToken = new MyToken("ipfs://bafybeibc5sgo2plmjkq2tzmhrn54bk3crhnc23zd2msg4ea7a4pxrkgfna/");
        for (uint256 i; i < 5; i++) {
            myToken.ownerMint(address(this));
        }
        chal.solve(address(myToken));
        require(chal.isSolved(), "!solve");
    }

    function onERC721Received(address, address, uint256, bytes calldata) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}
