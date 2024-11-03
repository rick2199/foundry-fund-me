// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

/// @title PriceConverter Library
/// @notice Provides functions to convert ETH to USD using Chainlink price feeds
library PriceConverter {
    /// @notice Retrieves the latest ETH/USD price from the Chainlink price feed
    /// @param priceFeed The address of the Chainlink AggregatorV3Interface
    /// @return The latest ETH/USD price with 18 decimals
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        (, int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000);
    }

    /// @notice Converts a given amount of ETH to USD
    /// @param ethAmount The amount of ETH to convert
    /// @param priceFeed The address of the Chainlink AggregatorV3Interface
    /// @return The equivalent amount in USD
    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }
}
