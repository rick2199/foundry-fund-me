// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

/// @title FundMe Contract
/// @notice This contract allows users to fund a project and the owner to withdraw funds
/// @dev Uses Chainlink price feeds for ETH/USD conversion
contract FundMe {
    using PriceConverter for uint256;

    error FundMe__NotOwner();

    mapping(address => uint256) private s_addressToAmountFunded;
    address[] private s_funders;
    address private immutable i_owner;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;
    AggregatorV3Interface private s_priceFeed;

    /// @notice Sets the owner and initializes the price feed
    /// @param priceFeed The address of the Chainlink price feed contract
    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    /// @notice Allows users to fund the contract
    /// @dev The ETH amount must meet the minimum USD value
    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "You need to spend more ETH!");
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    /// @notice Returns the version of the price feed
    /// @return The version of the price feed
    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    /// @notice Modifier to restrict access to the contract owner
    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    /// @notice Allows the owner to withdraw all funds
    /// @dev Resets funders' balances and transfers contract balance to the owner
    function withdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length;
        for (uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    /// @notice Fallback function to handle ETH sent directly to the contract
    fallback() external payable {
        fund();
    }

    /// @notice Receive function to handle ETH sent directly to the contract
    receive() external payable {
        fund();
    }

    /// @notice Returns the amount funded by a specific address
    /// @param fundingAddress The address of the funder
    /// @return The amount funded by the address
    function getAddressToAmountFounded(address fundingAddress) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    /// @notice Returns the address of a funder by index
    /// @param index The index of the funder in the array
    /// @return The address of the funder
    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    /// @notice Returns the owner of the contract
    /// @return The address of the contract owner
    function getOwner() external view returns (address) {
        return i_owner;
    }
}
