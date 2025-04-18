// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Escrow {
    address public buyer;
    address public seller;
    address public arbiter;

    uint256 public amount;
    bool public isFunded;

    constructor(address _buyer, address _seller, address _arbiter) {
        buyer = _buyer;
        seller = _seller;
        arbiter = _arbiter;
    }

    function fund() external payable {
        require(msg.sender == buyer, "Only buyer can fund");
        require(!isFunded, "Already funded");
        require(msg.value > 0, "No value sent");

        amount = msg.value;
        isFunded = true;
    }

    function releaseFunds() external {
        require(msg.sender == buyer || msg.sender == arbiter, "Unauthorized");
        require(isFunded, "No funds");

        isFunded = false;
        payable(seller).transfer(amount);
    }

    function refundBuyer() external {
        require(msg.sender == seller || msg.sender == arbiter, "Unauthorized");
        require(isFunded, "No funds");

        isFunded = false;
        payable(buyer).transfer(amount);
    }
}
