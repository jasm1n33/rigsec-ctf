// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {WETH9} from "./WETH9.sol";
import {Oracle, RoundData} from "./Oracle.sol";

/// @title RUSD Stablecoin Contract
/// @notice A managed stablecoin that can be minted and burned by a designated manager
/// @dev Inherits from OpenZeppelin's ERC20 implementation
contract RUSD is ERC20("Rigsec USD", "rUSD") {
    /// @notice Address of the contract manager
    address public manager;

    /// @notice Sets the contract manager during deployment
    /// @param _manager Address of the manager who can mint/burn tokens
    constructor(address _manager) {
        manager = _manager;
    }

    /// @notice Ensures only the manager can call the function
    modifier onlyManager() {
        require(manager == msg.sender);
        _;
    }

    /// @notice Creates new tokens and assigns them to the specified address
    /// @param to Address to receive the minted tokens
    /// @param amount Amount of tokens to mint
    function mint(address to, uint256 amount) public onlyManager {
        _mint(to, amount);
    }

    /// @notice Destroys tokens from a specified address
    /// @param from Address from which to burn tokens
    /// @param amount Amount of tokens to burn
    function burn(address from, uint256 amount) public onlyManager {
        _burn(from, amount);
    }
}

/// @title MicroStable Protocol
/// @notice A decentralized stablecoin system using WETH as collateral
/// @dev Implements a Collateralized Debt Position (CDP) system
contract MicroStable {
    /// @notice Minimum collateral ratio (150%)
    uint256 public constant MIN_COLLAT_RATIO = 1.5e18;

    /// @notice WETH contract instance
    WETH9 public weth;
    /// @notice RUSD stablecoin contract instance
    RUSD public rUSD;
    /// @notice Price oracle contract instance
    Oracle public oracle;

    /// @notice Maps user addresses to their collateral amounts
    mapping(address => uint256) public collateral;
    /// @notice Maps user addresses to their debt amounts
    mapping(address => uint256) public debt;

    /// @notice Initializes the protocol by deploying required contracts
    /// @dev Sets up WETH, RUSD, and Oracle contracts with initial price data
    constructor() {
        weth = new WETH9();
        rUSD = new RUSD(address(this));
        oracle = new Oracle();

        oracle.updateRoundData(
            RoundData({answer: 4000e18, startedAt: block.timestamp, updatedAt: block.timestamp, answeredInRound: 1})
        );
    }

    /// @notice Allows users to deposit WETH as collateral
    /// @param amount Amount of WETH to deposit
    function deposit(uint256 amount) public {
        weth.transferFrom(msg.sender, address(this), amount);
        collateral[msg.sender] += amount;
    }

    /// @notice Allows users to burn RUSD to reduce their debt
    /// @param amount Amount of RUSD to burn
    function burn(uint256 amount) public {
        debt[msg.sender] -= amount;
        rUSD.burn(msg.sender, amount);
    }

    /// @notice Allows users to mint new RUSD against their collateral
    /// @param amount Amount of RUSD to mint
    /// @dev Requires sufficient collateralization ratio
    function mint(uint256 amount) public {
        debt[msg.sender] += amount;
        require(collateralRatio(msg.sender) >= MIN_COLLAT_RATIO, "MicroStable: CR is below MCR");
        rUSD.mint(msg.sender, amount);
    }

    /// @notice Allows users to withdraw their WETH collateral
    /// @param amount Amount of WETH to withdraw
    /// @dev Requires maintaining minimum collateralization ratio after withdrawal
    function withdraw(uint256 amount) public {
        collateral[msg.sender] -= amount;
        require(collateralRatio(msg.sender) >= MIN_COLLAT_RATIO, "MicroStable: CR is below MCR");
        weth.transfer(msg.sender, amount);
    }

    /// @notice Allows anyone to liquidate undercollateralized positions
    /// @param user Address of the position to liquidate
    /// @dev Liquidator must have enough RUSD to repay the user's debt
    function liquidate(address user) public {
        require(collateralRatio(user) < MIN_COLLAT_RATIO, "MicroStable: CR is not below MCR");
        rUSD.burn(msg.sender, debt[user]);
        weth.transfer(msg.sender, collateral[user]);
        collateral[user] = 0;
        debt[user] = 0;
    }

    /// @notice Calculates the collateral ratio for a user
    /// @param user Address of the user to check
    /// @return The collateral ratio in 18 decimal precision
    /// @dev Returns max uint256 if user has no debt
    function collateralRatio(address user) public view returns (uint256) {
        uint256 minted = debt[user];
        if (minted == 0) return type(uint256).max;
        (, int256 price,,,) = oracle.latestRoundData();
        uint256 totalValue = collateral[user] * uint256(price) * 1e18 / 1e18;
        return totalValue / minted;
    }
}
