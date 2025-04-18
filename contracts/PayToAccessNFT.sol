// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.24;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Users must pay in tokens to mint an NFT
contract PayToAccessNFT is ERC721URIStorage {
    IERC20 public paymentToken;
    uint256 public mintFee;
    uint256 public tokenId;

    constructor(address _token, uint256 _fee) ERC721("AccessNFT", "ANFT") {
        paymentToken = IERC20(_token);
        mintFee = _fee;
    }

    function mint(string memory _uri) external {
        require(
            paymentToken.transferFrom(msg.sender, address(this), mintFee),
            "Payment failed"
        );

        tokenId++;
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, _uri);
    }
}
