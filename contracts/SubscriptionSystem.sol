// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Subscription {
    IERC20 public token;
    address public owner;
    uint256 public monthlyFee;

    mapping(address => uint256) public nextPaymentDue;

    constructor(IERC20 _token, uint256 _monthlyFee) {
        token = _token;
        monthlyFee = _monthlyFee;
        owner = msg.sender;
    }

    function subscribe() external {
        require(token.transferFrom(msg.sender, owner, monthlyFee), "Payment failed");
        nextPaymentDue[msg.sender] = block.timestamp + 30 days;
    }

    function isSubscribed(address user) external view returns (bool) {
        return block.timestamp < nextPaymentDue[user];
    }
}
