// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract CrowdFund {
    struct Campaign {
        address creator;
        uint256 goal;
        uint256 pledged;
        uint256 deadline;
        bool claimed;
    }

    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => mapping(address => uint256)) public pledgedAmounts;
    uint256 public campaignCount;

    function launch(uint256 _goal, uint256 _duration) external {
        campaignCount++;
        campaigns[campaignCount] = Campaign(msg.sender, _goal, 0, block.timestamp + _duration, false);
    }

    function pledge(uint256 _id) external payable {
        Campaign storage c = campaigns[_id];
        require(block.timestamp < c.deadline, "Ended");
        c.pledged += msg.value;
        pledgedAmounts[_id][msg.sender] += msg.value;
    }

    function claim(uint256 _id) external {
        Campaign storage c = campaigns[_id];
        require(msg.sender == c.creator, "Not creator");
        require(block.timestamp >= c.deadline, "Too soon");
        require(c.pledged >= c.goal, "Goal not met");
        require(!c.claimed, "Already claimed");

        c.claimed = true;
        payable(c.creator).transfer(c.pledged);
    }

    function refund(uint256 _id) external {
        Campaign storage c = campaigns[_id];
        require(block.timestamp >= c.deadline, "Too soon");
        require(c.pledged < c.goal, "Goal met");

        uint256 amount = pledgedAmounts[_id][msg.sender];
        pledgedAmounts[_id][msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
