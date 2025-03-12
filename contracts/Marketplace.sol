// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Marketplace is Ownable {
    struct Listing {
        uint256 price;
        address seller;
    }

    // Reentrancy lock
    bool private _locked;
    
    modifier nonReentrant() {
        require(!_locked, "Reentrant call");
        _locked = true;
        _;
        _locked = false;
    }

    // NFT Contract address => Token ID => Listing
    mapping(address => mapping(uint256 => Listing)) public listings;
    
    // Events
    event ItemListed(address indexed nftContract, uint256 indexed tokenId, uint256 price, address seller);
    event ItemSold(address indexed nftContract, uint256 indexed tokenId, uint256 price, address seller, address buyer);
    event ItemCanceled(address indexed nftContract, uint256 indexed tokenId, address seller);

    constructor() Ownable(msg.sender) {}

    function listItem(address nftContract, uint256 tokenId, uint256 price) external {
        require(price > 0, "Price must be greater than 0");
        require(IERC721(nftContract).ownerOf(tokenId) == msg.sender, "Not the owner");
        require(IERC721(nftContract).getApproved(tokenId) == address(this), "NFT not approved");

        listings[nftContract][tokenId] = Listing(price, msg.sender);
        emit ItemListed(nftContract, tokenId, price, msg.sender);
    }

    function buyItem(address nftContract, uint256 tokenId) external payable nonReentrant {
        Listing memory listing = listings[nftContract][tokenId];
        require(listing.price > 0, "Item not listed");
        require(msg.value == listing.price, "Incorrect price");
        require(msg.sender != listing.seller, "Seller cannot be buyer");

        delete listings[nftContract][tokenId];
        
        // Transfer payment to seller
        (bool success, ) = payable(listing.seller).call{value: msg.value}("");
        require(success, "Transfer failed");

        // Transfer NFT to buyer
        IERC721(nftContract).safeTransferFrom(listing.seller, msg.sender, tokenId);

        emit ItemSold(nftContract, tokenId, listing.price, listing.seller, msg.sender);
    }

    function cancelListing(address nftContract, uint256 tokenId) external {
        Listing memory listing = listings[nftContract][tokenId];
        require(listing.seller == msg.sender, "Not the seller");

        delete listings[nftContract][tokenId];
        emit ItemCanceled(nftContract, tokenId, msg.sender);
    }

    function getListing(address nftContract, uint256 tokenId) external view returns (Listing memory) {
        return listings[nftContract][tokenId];
    }
} 