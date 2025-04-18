// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract RoyaltyNFT is ERC721, ERC2981 {
    constructor() ERC721("RoyaltyNFT", "RNFT") {
        _setDefaultRoyalty(msg.sender, 500); // 5% (500 basis points)
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }
}
