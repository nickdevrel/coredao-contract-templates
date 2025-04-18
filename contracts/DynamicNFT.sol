// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract DynamicNFT is ERC721URIStorage {
    uint256 public tokenIdCounter;

    mapping(uint256 => uint256) public scores;

    constructor() ERC721("DynamicNFT", "DNFT") {}

    function mint(address to, string memory uri) external {
        uint256 newId = tokenIdCounter++;
        _mint(to, newId);
        _setTokenURI(newId, uri);
    }

    function updateScore(uint256 tokenId, uint256 newScore) external {
        scores[tokenId] = newScore;

        if (newScore > 100) {
            _setTokenURI(tokenId, "ipfs://high-score-metadata.json");
        } else {
            _setTokenURI(tokenId, "ipfs://low-score-metadata.json");
        }
    }
}
