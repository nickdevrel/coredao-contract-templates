// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTRental {
    struct Rental {
        address lender;
        address renter;
        uint256 tokenId;
        uint256 rentDuration;
        uint256 rentEnd;
        uint256 rentFee;
        bool isActive;
    }

    IERC721 public nft;
    mapping(uint256 => Rental) public rentals;

    constructor(IERC721 _nft) {
        nft = _nft;
    }

    function listForRent(uint256 tokenId, uint256 duration, uint256 fee) external {
        require(nft.ownerOf(tokenId) == msg.sender, "Not owner");
        rentals[tokenId] = Rental(msg.sender, address(0), tokenId, duration, 0, fee, false);
        nft.transferFrom(msg.sender, address(this), tokenId);
    }

    function rentNFT(uint256 tokenId) external payable {
        Rental storage rental = rentals[tokenId];
        require(!rental.isActive, "Already rented");
        require(msg.value == rental.rentFee, "Incorrect fee");

        rental.renter = msg.sender;
        rental.rentEnd = block.timestamp + rental.rentDuration;
        rental.isActive = true;

        nft.transferFrom(address(this), msg.sender, tokenId);
    }

    function returnNFT(uint256 tokenId) external {
        Rental storage rental = rentals[tokenId];
        require(rental.isActive && msg.sender == rental.renter, "Not rented by you");
        require(block.timestamp >= rental.rentEnd, "Rental not over");

        nft.transferFrom(msg.sender, rental.lender, tokenId);
        rental.isActive = false;
        payable(rental.lender).transfer(rental.rentFee);
    }
}
