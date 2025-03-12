const hre = require("hardhat");

async function main() {
  try {
    console.log("Starting deployment...");

    // Deploy NFT contract
    console.log("Deploying NFT contract...");
    const NFT = await hre.ethers.getContractFactory("NFT");
    const nft = await NFT.deploy();
    await nft.waitForDeployment();
    const nftAddress = await nft.getAddress();
    console.log("NFT contract deployed to:", nftAddress);

    // Deploy Marketplace contract
    console.log("\nDeploying Marketplace contract...");
    const Marketplace = await hre.ethers.getContractFactory("Marketplace");
    const marketplace = await Marketplace.deploy();
    await marketplace.waitForDeployment();
    const marketplaceAddress = await marketplace.getAddress();
    console.log("Marketplace contract deployed to:", marketplaceAddress);

    console.log("\nDeployment completed successfully!");
    console.log("-----------------------------------");
    console.log("NFT:", nftAddress);
    console.log("Marketplace:", marketplaceAddress);
    
  } catch (error) {
    console.error("\nDeployment failed!");
    console.error(error);
    process.exit(1);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  }); 