// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";


contract LoyaltyProgram is Ownable {

    /* MAPPINGS ARE DECLARED HERE */
    // Mapping to store user points
    mapping(address => uint256) private userPoints;

    /* EVENTS ARE DECLARED HERE */
    event PointsAdded(address indexed user, uint256 points);
    event PointsRedeemed(address indexed user, uint256 points);

    /* CONSTRUCTORS ARE DECLARED HERE */
    // Pass the owner address to the Ownable constructor
    constructor(address initialOwner) Ownable(initialOwner) {}

    /* FUNCTIONS */
    // Adds points to a user's account
    function addPoints(address _user, uint256 _points) public onlyOwner {
        require(_points > 0, "Points must be greater than zero.");
        userPoints[_user] += _points;
        emit PointsAdded(_user, _points);
    }

    // Gets the points of a user
    function getUserPoints(address _user) public view returns (uint256) {
        return userPoints[_user];
    }
}
