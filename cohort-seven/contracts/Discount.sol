// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BookStore.sol";
import "./LoyaltyProgram.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Discount is Ownable {
    BookStore public bookStore;
    LoyaltyProgram public loyaltyProgram;

    /**
     * @notice Initializes the contract with the owner, BookStore, and LoyaltyProgram addresses.
     * @param initialOwner The address of the contract owner
     * @param _bookStore The address of the BookStore contract
     * @param _loyaltyProgram The address of the LoyaltyProgram contract
     */
    constructor(
        address initialOwner,
        address _bookStore,
        address _loyaltyProgram
    ) Ownable(initialOwner) {
        bookStore = BookStore(_bookStore);
        loyaltyProgram = LoyaltyProgram(_loyaltyProgram);
    }

    /**
     * @notice Sets the BookStore contract
     * @param _bookStore Address of the BookStore contract
     */
    function setBookStore(address _bookStore) public onlyOwner {
        bookStore = BookStore(_bookStore);
    }

    /**
     * @notice Sets the LoyaltyProgram contract
     * @param _loyaltyProgram Address of the LoyaltyProgram contract
     */
    function setLoyaltyProgram(address _loyaltyProgram) public onlyOwner {
        loyaltyProgram = LoyaltyProgram(_loyaltyProgram);
    }

    /**
     * @notice Gets the discounted price for a book based on user points
     * @param _bookId The ID of the book
     * @param _user The address of the user
     * @return The discounted price of the book
     */
    function getDiscountedPrice(uint256 _bookId, address _user)
        public
        view
        returns (uint256)
    {
        // Fetch the original price from the BookStore
        (, , uint256 originalPrice, , ) = bookStore.getBook(_bookId);

        // Fetch the user's points from the LoyaltyProgram
        uint256 userPoints = loyaltyProgram.getUserPoints(_user);

        // Calculate percentage discount (points capped at 100%)
        uint256 percentageDiscount = userPoints > 100 ? 100 : userPoints;
        uint256 discountAmount = (originalPrice * percentageDiscount) / 100;

        // Calculate and return the discounted price
        return originalPrice - discountAmount;
    }
}
