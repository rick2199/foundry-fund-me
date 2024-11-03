# FundMe Project

**FundMe** is a decentralized application (dApp) designed to facilitate crowdfunding on the Ethereum blockchain. It allows users to contribute Ether to a project and enables the project owner to withdraw the funds once the funding goal is met.

## Project Overview

The FundMe project is built using Solidity and leverages Chainlink's price feeds to ensure accurate conversion rates between Ether and USD. The project includes several smart contracts and scripts to manage the deployment, funding, and withdrawal processes.

### Key Components

- **FundMe Contract**: The core contract that manages the funding process. It allows users to fund the project and the owner to withdraw the funds. The contract uses Chainlink's price feeds to ensure that contributions meet a minimum USD value.

- **HelperConfig Contract**: A configuration contract that provides network-specific settings, such as the address of the price feed contract. It supports multiple networks, including Sepolia and Mainnet.

- **MockV3Aggregator Contract**: A mock contract used for testing purposes. It simulates the behavior of a Chainlink price feed, allowing for reliable testing without relying on live data.

- **Deployment and Interaction Scripts**: Scripts to automate the deployment of the FundMe contract and to facilitate interactions such as funding and withdrawing.

## Usage

### Deployment

Deploy the FundMe contract using the provided script:

```shell
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url <your_rpc_url> --account <your_account> --sender <your_sender>
```


### Funding

Users can fund the project by sending Ether to the contract. The contract ensures that the contribution meets the minimum USD value using the current ETH/USD conversion rate.

### Withdrawal

The project owner can withdraw the funds once the funding goal is met. The withdrawal process is restricted to the contract owner to ensure security.

## Testing

The project includes a comprehensive suite of unit and integration tests to ensure the reliability and security of the smart contracts. Tests cover various scenarios, including funding, withdrawal, and edge cases.

### Running Tests

Execute the tests using Forge:

```shell
forge test
```


## Code Structure

- **Contracts**: Located in the `src` directory, including `FundMe.sol`, `HelperConfig.s.sol`, and `MockV3Aggregator.sol`.
- **Scripts**: Deployment and interaction scripts are located in the `script` directory.
- **Tests**: Unit and integration tests are located in the `test` directory.

