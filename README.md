# NFT Marketplace

This project implements a decentralized NFT marketplace where users can mint, list, and trade NFTs.

## Features

- Mint new NFTs with custom metadata
- List NFTs for sale
- Purchase NFTs
- Cancel listings
- View NFT listings

## Setup

1. Clone the repository
2. Install dependencies:
```bash
npm install
```

## Local Development

1. Start the local Hardhat node:
```bash
npx hardhat node
```

2. In a new terminal, deploy the contracts to the local network:
```bash
npx hardhat run scripts/deploy.js --network localhost
```

3. Save the deployed contract addresses displayed in the console:
- NFT Contract: [Contract Address]
- Marketplace Contract: [Contract Address]

## Interacting with the Contracts

### Using Hardhat Console

1. Open Hardhat console connected to local network:
```bash
npx hardhat console --network localhost
```

2. Get the contract instances:
```javascript
const NFT = await ethers.getContractFactory("NFT")
const Marketplace = await ethers.getContractFactory("Marketplace")
const nft = await NFT.attach("YOUR_NFT_CONTRACT_ADDRESS")
const marketplace = await Marketplace.attach("YOUR_MARKETPLACE_CONTRACT_ADDRESS")
```

3. Example commands:
```javascript
// Mint a new NFT
await nft.createToken("YOUR_TOKEN_URI")

// List an NFT
// First approve marketplace to handle your NFT
await nft.approve(marketplace.address, tokenId)
// Then list the NFT
await marketplace.listItem(nft.address, tokenId, ethers.parseEther("1.0"))

// Buy an NFT
await marketplace.buyItem(nft.address, tokenId, { value: ethers.parseEther("1.0") })

// Cancel a listing
await marketplace.cancelListing(nft.address, tokenId)
```

### Using MetaMask

1. Add Hardhat's local network to MetaMask:
- Network Name: Hardhat Local
- RPC URL: http://127.0.0.1:8545/
- Chain ID: 31337
- Currency Symbol: ETH

2. Import one of the test accounts provided by Hardhat node using its private key

## Contract Details

### NFT Contract
- ERC721 implementation with custom minting functionality
- Token URI storage for metadata
- Owner-controlled minting

### Marketplace Contract
- Secure listing and trading of NFTs
- Built-in reentrancy protection
- Event emission for all major actions
- Price validation and ownership checks

## Security Features

- Reentrancy protection using boolean locks
- Proper access controls
- Price validation
- Safe transfer checks for ETH and NFTs
