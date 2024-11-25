
import { ethers, Wallet } from "ethers";
import * as dotenv from 'dotenv';
dotenv.config();
import bookStore from "./ABI/BookStore.json" assert { type: 'json' };


const createContractInstanceOnEthereum = (contractAddress, contractAbi) => {
    const alchemyApiKey = process.env.ALCHEMY_API_KEY_SEPOLIA;
    const provider = new ethers.AlchemyProvider('sepolia', alchemyApiKey);
    console.log("provider", provider)

    const privateKey = process.env.WALLET_PRIVATE_KEY;
    const wallet = new Wallet(privateKey, provider);

    const contract = new ethers.Contract(contractAddress, contractAbi, wallet);

    return contract
}

const contractAddress = '0x0F9696E62ce7BF9fDCBa39FD3ad1cAE821E2458a'
const contractOnETH =  createContractInstanceOnEthereum(contractAddress, bookStore.abi)


const addBookToContract = async(bookId, title, author, price, stock) => {
    try {
        const txResponse = await contractOnETH.addBook(bookId, title, author, price, stock)
        console.log(txResponse.hash)
        console.log(`https://sepolia.etherscan.io/tx/${txResponse.hash}`)
        
    } catch (error) {
        console.error(error) 
    }
}


const bookDetails = {
    bookId: 1,
    title: "Harry Potter",
    author: "J.K. Rowling",
    price: 10,
    stock: 100
}


const _bookId = 1
const getBook = async () => {
    try{
        const books = await contractOnETH.getBooks(_bookId)
        console.log(books)
    } catch (error) {
        console.error(error)
    }
}

// create public and private key
const createEthereumAccount = () => {
    try {
        // Create a random wallet
        const wallet = ethers.Wallet.createRandom();
        console.log("Wallet Address:", wallet.address);
        console.log("Private Key:", wallet.privateKey);
    } catch (error) {
        console.log(error);
        throw error;
    }
};



// 0x7590AC5189C76ab75c88AE95843aF4D5398854ec




(async () => {
    await createEthereumAccount()
    await addBookToContract(3, "Harry Potter", "J.K. Rowling", 10, 100)
    await getBook()
})()