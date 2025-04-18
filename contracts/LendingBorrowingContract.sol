// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Lending {
    IERC20 public token;
    address public owner;
    uint256 public interestRate = 5; // 5%

    struct Loan {
        uint256 amount;
        uint256 repayAmount;
        bool isActive;
    }

    mapping(address => Loan) public loans;

    constructor(IERC20 _token) {
        token = _token;
        owner = msg.sender;
    }

    function lend(uint256 amount) external {
        require(!loans[msg.sender].isActive, "Loan exists");
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        uint256 repay = amount + ((amount * interestRate) / 100);
        loans[msg.sender] = Loan(amount, repay, true);
    }

    function borrow() external {
        require(loans[msg.sender].isActive, "No loan");
        token.transfer(msg.sender, loans[msg.sender].amount);
    }

    function repayLoan() external {
        require(loans[msg.sender].isActive, "No active loan");
        require(token.transferFrom(msg.sender, address(this), loans[msg.sender].repayAmount), "Repayment failed");
        delete loans[msg.sender];
    }
}
