// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Insurance {
    address public insurer;
    uint256 public premium;
    uint256 public payout;

    mapping(address => bool) public hasPaid;
    mapping(address => bool) public eligible;

    constructor(uint256 _premium, uint256 _payout) {
        insurer = msg.sender;
        premium = _premium;
        payout = _payout;
    }

    function payPremium() external payable {
        require(msg.value == premium, "Incorrect premium");
        hasPaid[msg.sender] = true;
    }

    function setEligible(address user, bool status) external {
        require(msg.sender == insurer, "Not insurer");
        eligible[user] = status;
    }

    function claim() external {
        require(hasPaid[msg.sender], "No premium paid");
        require(eligible[msg.sender], "Not eligible");

        eligible[msg.sender] = false;
        payable(msg.sender).transfer(payout);
    }

    receive() external payable {} // To receive insurer funding
}
