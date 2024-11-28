// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "contracts/AdvancedBookStore.sol";
import "contracts/LoyaltyProgram.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Discount is Ownable {

    /* VARIABLES ARE DECLARED HERE */
    AdvancedBookStore public bookStore;
    LoyaltyProgram public loyaltyProgram;

    /* CONSTRUCTORS ARE DECLARED HERE */
    // Initializes the contract with the owner, BookStore, and LoyaltyProgram addresses.
    constructor(address initialOwner,address _bookStore,address _loyaltyProgram) Ownable(initialOwner) {
        bookStore = AdvancedBookStore(_bookStore);
        loyaltyProgram = LoyaltyProgram(_loyaltyProgram);
    }

    /* FUNCTIONS */
    // Sets the BookStore contract
    function setBookStore(address _bookStore) public onlyOwner {
        bookStore = AdvancedBookStore(_bookStore);
    }

    // Sets the LoyaltyProgram contract
    function setLoyaltyProgram(address _loyaltyProgram) public onlyOwner {
        loyaltyProgram = LoyaltyProgram(_loyaltyProgram);
    }

    // Gets the discounted price for a book based on user points
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
