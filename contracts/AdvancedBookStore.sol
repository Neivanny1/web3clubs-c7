// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "contracts/BookStore.sol";

contract AdvancedBookStore is BookStore {
    event BookRemoved(uint256 bookId);
    event AllBooksRemoved();
    // Constructor for AdvancedBookStore
    constructor(address initialOwner) BookStore(initialOwner) {}
    // Remove a specific book by its ID
    function removeBook(uint256 _bookId) public onlyOwner virtual {
        require(books[_bookId].price != 0, "Book does not exist.");
        // Remove the book from the mapping
        delete books[_bookId];
        // Update the `bookIds` array
        for (uint256 i = 0; i < bookIds.length; i++) {
            if (bookIds[i] == _bookId) {
                bookIds[i] = bookIds[bookIds.length - 1];
                bookIds.pop();
                break;
            }
        }
        emit BookRemoved(_bookId);
    }
    // Remove all books from the store
    function removeAllBooks() public onlyOwner {
        require(bookIds.length > 0, "No books to remove.");
        // Delete all books from the mapping
        for (uint256 i = 0; i < bookIds.length; i++) {
            delete books[bookIds[i]];
        }
        delete bookIds;
        emit AllBooksRemoved();
    }
}
