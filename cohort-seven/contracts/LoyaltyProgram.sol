// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract LoyaltyProgram is Ownable {
    // Mapping to store user points
    mapping(address => uint256) private userPoints;

    event PointsAdded(address indexed user, uint256 points);
    event PointsRedeemed(address indexed user, uint256 points);
    // Pass the owner address to the Ownable constructor
    constructor(address initialOwner) Ownable(initialOwner) {}
    /**
     * @notice Adds points to a user's account
     * @param _user Address of the user
     * @param _points Number of points to add
     */
    function addPoints(address _user, uint256 _points) public onlyOwner {
        require(_points > 0, "Points must be greater than zero.");
        userPoints[_user] += _points;
        emit PointsAdded(_user, _points);
    }

    /**
     * @notice Gets the points of a user
     * @param _user Address of the user
     * @return The total points of the user
     */
    function getUserPoints(address _user) public view returns (uint256) {
        return userPoints[_user];
    }
}
