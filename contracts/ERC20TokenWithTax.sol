// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TaxedERC20 is ERC20, Ownable {
    uint256 public taxRate; // Tax rate in basis points (100 = 1%)
    address public taxWallet;
    uint256 constant MAX_TAX_RATE = 1000; // Max 10% tax
    
    // Mapping to store addresses exempt from tax
    mapping(address => bool) public isExempt;

    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        uint256 _taxRate,
        address _taxWallet
    ) ERC20(name, symbol) Ownable(msg.sender) {
        require(_taxRate <= MAX_TAX_RATE, "Tax rate too high");
        require(_taxWallet != address(0), "Invalid tax wallet");
        
        taxRate = _taxRate;
        taxWallet = _taxWallet;
        isExempt[msg.sender] = true; // Contract deployer is exempt
        _mint(msg.sender, initialSupply);
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        return _transferWithTax(_msgSender(), recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        uint256 currentAllowance = allowance(sender, _msgSender());
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        
        _transferWithTax(sender, recipient, amount);
        _approve(sender, _msgSender(), currentAllowance - amount);
        
        return true;
    }

    function _transferWithTax(address sender, address recipient, uint256 amount) internal returns (bool) {
        require(sender != address(0), "ERC20: transfer from zero address");
        require(recipient != address(0), "ERC20: transfer to zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        uint256 taxAmount = 0;
        uint256 amountAfterTax = amount;

        // Apply tax if neither sender nor recipient is exempt
        if (!isExempt[sender] && !isExempt[recipient]) {
            taxAmount = (amount * taxRate) / 10000; // Calculate tax (taxRate is in basis points)
            amountAfterTax = amount - taxAmount;
            
            if (taxAmount > 0) {
                super._transfer(sender, taxWallet, taxAmount);
            }
        }

        super._transfer(sender, recipient, amountAfterTax);
        return true;
    }

    // Owner functions to manage tax parameters
    function setTaxRate(uint256 newTaxRate) external onlyOwner {
        require(newTaxRate <= MAX_TAX_RATE, "Tax rate too high");
        taxRate = newTaxRate;
    }

    function setTaxWallet(address newTaxWallet) external onlyOwner {
        require(newTaxWallet != address(0), "Invalid tax wallet");
        taxWallet = newTaxWallet;
    }

    function setExemptStatus(address account, bool exempt) external onlyOwner {
        require(account != address(0), "Invalid address");
        isExempt[account] = exempt;
    }
}