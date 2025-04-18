// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenVesting {
    IERC20 public token;
    address public beneficiary;
    uint256 public start;
    uint256 public duration;
    uint256 public totalAmount;
    uint256 public claimed;

    constructor(
        address _beneficiary,
        uint256 _start,
        uint256 _duration,
        uint256 _amount,
        IERC20 _token
    ) {
        beneficiary = _beneficiary;
        start = _start;
        duration = _duration;
        totalAmount = _amount;
        token = _token;
    }

    function claim() external {
        require(msg.sender == beneficiary, "Not beneficiary");
        uint256 vested = _vestedAmount();
        uint256 claimable = vested - claimed;
        require(claimable > 0, "Nothing to claim");
        claimed += claimable;
        token.transfer(beneficiary, claimable);
    }

    function _vestedAmount() internal view returns (uint256) {
        if (block.timestamp < start) return 0;
        if (block.timestamp >= start + duration) return totalAmount;
        return (totalAmount * (block.timestamp - start)) / duration;
    }
}
