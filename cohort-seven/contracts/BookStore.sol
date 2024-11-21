// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BookStore is Ownable {
    struct Book {
        string title;
        string author;
        uint256 price;
        uint256 stock;
        bool isAvailable;
    }

    mapping(uint256 => Book) public books;
    uint256[] public bookIds;

    event BookAdded(uint256 bookId, string title, string author, uint256 price, uint256 stock);
    event BookPurchased(uint256 bookId, address buyer, uint256 quantity);

    // Pass the owner address to the Ownable constructor
    constructor(address initialOwner) Ownable(initialOwner) {}

    function addBook(
        uint256 _bookId,
        string calldata _title,
        string calldata _author,
        uint256 _price,
        uint256 _stock
    ) public onlyOwner {
        require(books[_bookId].price == 0, "Book already exists with this ID.");
        books[_bookId] = Book({
            title: _title,
            author: _author,
            price: _price,
            stock: _stock,
            isAvailable: _stock > 0
        });
        bookIds.push(_bookId);
        emit BookAdded(_bookId, _title, _author, _price, _stock);
    }

    // Gets a book based on book id
    function getBook(uint256 _bookId)
        public
        view
        returns (string memory, string memory, uint256, uint256, bool)
    {
        Book memory book = books[_bookId];
        return (book.title, book.author, book.price, book.stock, book.isAvailable);
    }

    // Function to get all books available
    function getAllBooks() public view returns (Book[] memory) {
        Book[] memory allBooks = new Book[](bookIds.length);
        for (uint256 i = 0; i < bookIds.length; i++) {
            allBooks[i] = books[bookIds[i]];
        }
        return allBooks;
    }

    // Function to buy a book
    function buyBook(uint256 _bookId, uint256 _quantity) public payable {
        Book storage book = books[_bookId];
        require(book.isAvailable, "This book is not available.");
        require(book.stock >= _quantity, "Not enough stock available.");
        require(msg.value == book.price * _quantity, "Incorrect payment amount.");

        book.stock -= _quantity;
        if (book.stock == 0) {
            book.isAvailable = false;
        }

        // Use the inherited `owner()` function to get the owner's address
        payable(owner()).transfer(msg.value);
        emit BookPurchased(_bookId, msg.sender, _quantity);
    }
}
