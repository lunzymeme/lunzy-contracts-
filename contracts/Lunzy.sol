// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

 
contract Lunzy is ERC20 {
    
    address public constant MARKETING_WALLET = 0x5d44Fe2020256200957f5119673F45F7A2e1B208; 
    address public constant LUNC_BURN_WALLET = 0xd00E9D19B54D485356B1B48843cfe3407fe4ad8E; 
    address public constant LIQUIDITY_WALLET = 0x9f332c4cD30f8693E3DDCa41b98bB3d3DeCaBE52; 

    
    address public constant PINKLOCK_ADDRESS = 0x9479C6484a392113bB829A15E7c9E033C9e70D30;

    constructor() ERC20("Lunzy", "LNZ") {
       
        _mint(msg.sender, 5000000000000 * 10 ** decimals());
    }

    function _update(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        
        if (from == address(0) || to == address(0)) {
            super._update(from, to, amount);
            return;
        }

       
        if (from == PINKLOCK_ADDRESS || to == PINKLOCK_ADDRESS) {
            super._update(from, to, amount);
            return;
        }

      
        uint256 marketingTax = (amount * 2) / 100; // %2
        uint256 luncTax      = (amount * 1) / 100; // %1
        uint256 liquidityTax = (amount * 1) / 100; // %1
        uint256 autoBurn     = (amount * 1) / 100; // %1
        
        uint256 totalTax = marketingTax + luncTax + liquidityTax + autoBurn;
        uint256 netAmount = amount - totalTax;

       
        super._update(from, MARKETING_WALLET, marketingTax);
        super._update(from, LUNC_BURN_WALLET, luncTax);
        super._update(from, LIQUIDITY_WALLET, liquidityTax);
        super._update(from, address(0), autoBurn);
        
        
        super._update(from, to, netAmount);
    }
}