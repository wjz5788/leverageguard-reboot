# LeverageGuard Contracts

This directory contains the Solidity sources for the LeverageGuard protocol.
The layout remains Foundry-compatible; run all commands from this folder unless
explicitly stated otherwise.

## Tooling

- Install Foundry via `curl -L https://foundry.paradigm.xyz | bash` and run
  `foundryup`.
- Copy `env/templates/contracts.env.example` to `.env` (at the repo root or in
  this directory) and populate the RPC URL, deployer key, and Etherscan key if
  you plan to broadcast transactions.

## Manual Tasks

- **Format & lint:** `forge fmt`.
- **Tests:** `forge test`.
- **Gas snapshots:** `forge snapshot` (commit results when contracts change).
- **Deploy dry-run:** `forge script script/DeployLeverSafe.s.sol --fork-url $RPC_URL`.
- **Production deploy:** `forge script ... --broadcast --verify`.

Record transaction metadata (hash, block number, address) in release notes and
update any dependent microservice configuration before shipping to production.
