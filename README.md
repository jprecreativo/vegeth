## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

## Deployment & Upgrade Process (Sepolia Testnet)

To deploy the contracts to the Sepolia testnet and simulate a real-world upgrade scenario, we split the process into two steps: initial deployment (V1) and upgrading (V2).

### Prerequisites
Make sure your `.env` file is set up at the root of the project with the following variables:
```env
ETHERSCAN_API_KEY=your_ethscan_api_key
SEPOLIA_RPC_URL=your_sepolia_rpc_url
SEPOLIA_PRIVATE_KEY=your_private_key_without_0x
PROXY_ADDRESS=proxy_deployed_at_address
```

### Deploy version 1:
```shell
$ source .env
$ forge script script/DeployV1.s.sol:DeployV1 --rpc-url $SEPOLIA_RPC_URL --broadcast --verify -vvvv
```

Copy "Proxy deployed at" address and paste it in your PROXY_ADDRESS variable in the .env file.

### Upgrade to version 2:
```shell
$ source .env
$ forge script script/UpgradeV2.s.sol:UpgradeV2 --rpc-url $SEPOLIA_RPC_URL --broadcast --verify -vvvv
```