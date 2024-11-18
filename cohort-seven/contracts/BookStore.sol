// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.2;

// Book Store - we have an owner
// Books - cat_name, price, author, title, isbn, available
// - string, uint, int, bool
// uint8 (137) - unit256 (878687678678687876) 2*8 2*256
// int8 - int255

// struct - grouping items
// mapping - used to store items with thier unique id
// array - two type - dynamic, fixed size unit256[] and unit256[4]
// event - notify about new addition or act as audit trail
// variables - global, state, local

// functions - setters and getters
// addBooks() - event BookAdded setter - setting data
// getBook() - getter - getting data
// buyBook() - event
// getTotalBooks() -

// inheritance - 

contract BookStore {

    address public owner;

    struct Book {
        string title;
        string author;
        uint price;
        uint256 stock;
        bool isAvailable;
    }

    
     function addBook(uint256 _bookId, string memory _title, string memory _author, uint256 _price, uint256 _stock) public  {
        require(books[_bookId].price == 0, "Book already exists with this ID.");
        books[_bookId] = Book({
            title: _title,
            author: _author,
            price: _price,
            stock: _stock,
            isAvailable: _stock > 0
        });
        bookIds.push(_bookId); // push() , remove()
        emit BookAdded(_bookId, _title, _author, _price, _stock);
    }

        function getBooks(uint256 _bookId) public view returns (string memory, string memory, uint256, uint256, bool) {
        Book memory book = books[_bookId];
        return (book.title, book.author, book.price, book.stock, book.isAvailable);
    }

    function buyBook(uint256 _bookId, uint256 _quantity, uint256 _amount) public payable {
        Book storage book = books[_bookId];
        require(book.isAvailable, "This book is not available.");
        require(book.stock >= _quantity, "Not enough stock available.");
        require(_amount == book.price * _quantity, "Incorrect payment amount.");

        // Decrease stock and update availability
        book.stock -= _quantity;
        if (book.stock == 0) {
            book.isAvailable = false;
        }

              // Transfer payment to the owner - paybale == transfer(from, to, amount)
        payable(owner).transfer(msg.value);
        emit BookPurchased(_bookId, msg.sender, _quantity);
    }

}


