// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// A simple ERC-20 token staking contract with flat reward
contract Staking {
    IERC20 public token;

    mapping(address => uint256) public balances;
    mapping(address => uint256) public stakingTime;

    uint256 public rewardRate = 10; // 10 tokens as reward

    constructor(IERC20 _token) {
        token = _token;
    }

    // Stake tokens to earn rewards
    function stake(uint256 amount) public {
        require(amount > 0, "Stake > 0");
        token.transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
        stakingTime[msg.sender] = block.timestamp;
    }

    // Withdraw tokens and earn a flat reward
    function withdraw() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Nothing to withdraw");

        uint256 reward = rewardRate;
        balances[msg.sender] = 0;
        token.transfer(msg.sender, amount + reward);
    }
}
