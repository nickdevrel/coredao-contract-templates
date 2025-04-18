// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// A basic mintable NFT contract with IPFS metadata support
contract MintableNFT is ERC721URIStorage {
    uint256 public tokenId;

    constructor() ERC721("MintableNFT", "MNFT") {}

    // Mint an NFT with a given IPFS metadata URI
    function mint(string memory _uri) public {
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, _uri);
        tokenId++;
    }
}
