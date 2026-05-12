// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {MarketplaceFactory} from "../src/MarketplaceFactory.sol";
import {RWATokenizer} from "../src/RWATokenizer.sol";
import {PaymentSplitter} from "../src/PaymentSplitter.sol";

contract DeployScript is Script {
    // Addresses for deployment
    address public deployer;
    address public marketplaceFactory;
    address public rwaTokenizer;
    address public paymentSplitter;

    function setUp() public {
        // Get deployer from private key
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        deployer = vm.addr(deployerPrivateKey);
        
        // Initialize contract addresses (will be set after deployment)
        marketplaceFactory = address(0);
        rwaTokenizer = address(0);
        paymentSplitter = address(0);
    }

    function run() public {
        vm.startBroadcast();

        // Deploy RWATokenizer
        rwaTokenizer = address(new RWATokenizer(
            "https://api.realflow.io/metadata/",
            deployer
        ));
        
        // Deploy PaymentSplitter
        paymentSplitter = address(new PaymentSplitter(deployer));

        // Deploy MarketplaceFactory
        // Deployment fee set to 0.01 MATIC (or equivalent on testnet)
        uint256 deploymentFee = 0.01 * 10 ** 18; // 0.01 token * 10^18
        marketplaceFactory = address(new MarketplaceFactory(
            rwaTokenizer,  // _implementation
            deploymentFee  // _deploymentFee
        ));

        vm.stopBroadcast();

        // Output deployed addresses
        console.log("Deployed contracts:");
        console.log("RWATokenizer: ", rwaTokenizer);
        console.log("PaymentSplitter: ", paymentSplitter);
        console.log("MarketplaceFactory: ", marketplaceFactory);
    }
}
