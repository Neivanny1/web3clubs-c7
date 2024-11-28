// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BookStore is Ownable {
    /* VARIABLES ARE DECLARED HERE */
    struct Book {
        string title;
        string author;
        uint256 price;
        uint256 stock;
        bool isAvailable;
    }
    uint256[] public bookIds;

    /* MAPPINGS ARE DECLARED HERE */
    mapping(uint256 => Book) public books;

    /* EVENTS ARE DECLARED HERE */
    event BookAdded(uint256 indexed bookId, string title, string author, uint256 price, uint256 stock);

    /* CONSTRUCTORS ARE DECLARED HERE */
    // Pass the owner address to the Ownable constructor
    constructor(address initialOwner) Ownable(initialOwner) {}

    /* FUNCTIONS */
    // adding books to stock
    function addBook(uint256 _bookId,string memory _title,string memory _author,uint256 _price,uint256 _stock) public onlyOwner {
        require(books[_bookId].price == 0, "Book already exists with this ID.");
        books[_bookId] = Book({
            title: _title,
            author: _author,
            price: _price * 1 ether, // Proper conversion to make sure price is in wei
            stock: _stock,
            isAvailable: _stock > 0
        });
        bookIds.push(_bookId);
        emit BookAdded(_bookId, _title, _author, _price, _stock);
    }
}

