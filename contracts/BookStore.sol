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
    address[] public subscriberList;

    event BookAdded(uint256 indexed bookId, string title, string author, uint256 price, uint256 stock);
    event PurchaseIntiated(uint256 indexed bookId, address indexed buyer, address indexed seller,  uint256 quantity);  // add a seller address for the event
    event PurchaseConfirmed(uint256 indexed bookId, address indexed buyer, address indexed seller, uint256 quantity); // add a seller address
    event SubscriptionAdded(address indexed subscriber);          // complete on this two 
    event SubscriptionRemoved(address indexed subscriber);

    // Pass the owner address to the Ownable constructor
    constructor(address initialOwner) Ownable(initialOwner) {}

    function addBook(
        uint256 _bookId,
        string memory _title,
        string memory _author,
        uint256 _price,
        uint256 _stock
    ) public onlyOwner {
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

        uint256 totalPrice = book.price * _quantity;
        require(msg.value == totalPrice, "Incorrect payment amount.");
        require(msg.value <= totalPrice, "Overpaid for book purchase.");

        emit PurchaseIntiated(_bookId, msg.sender, owner(), _quantity);

        // Transfer payment to the owner
        payable(owner()).transfer(msg.value);
    }
    // Confirm purchase
    function confirmPurchase(uint256 _bookId, uint256 _quantity) public onlyOwner {
        Book storage book = books[_bookId];
        require(book.stock >= _quantity, "Not enough stock to confirm purchase.");
        
        book.stock -= _quantity;
        if (book.stock == 0) {
            book.isAvailable = false;
        }

        emit PurchaseConfirmed(_bookId, msg.sender, owner(), _quantity);
    }
}
