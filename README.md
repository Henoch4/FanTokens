# Laurel

Create a fan token, buy units, and transfer holdings on-chain.

## Mainnet status

Contract on BOT Chain mainnet (677): [0x9635d8ffda3704DA5AeD7A2afC9b2d4374342644](https://scan.botchain.ai/address/0x9635d8ffda3704DA5AeD7A2afC9b2d4374342644).

Wallet actions require BOT Chain mainnet, deployed bytecode, and a connected compatible wallet. Every action is simulated before a transaction review; only a subsequent wallet confirmation can send it.

## Interface

- Live reads use the configured mainnet address; an unavailable RPC produces an explicit error.
- No seeded financial metrics, synthetic receipts, or assessment traces appear in the product.
- Management actions require proof of the connected account’s owner, creator, oracle, merchant, guardian, or record role. The contract remains the authority.
- Account/network changes invalidate an open transaction review.
- The footer provides BOT Chain and BOTScan homepage links; deployed products also link to their contract.
- Ethers is vendored locally with its license. No CDN script is required for wallet or contract operations.

## Contract interface

`frontend/product.json` uses the current-source ABI, matched against the deployed mainnet runtime bytecode. Explorer source publication is tracked separately.

| Action | Contract signature |
|---|---|
| Buy fan tokens | `buyTokens(uint256)` |
| Create a fan token | `createToken(string,string,uint256)` |
| Retire a token | `deactivateToken(uint256)` |
| Transfer fan tokens | `transferTokens(uint256,address,uint256)` |
| Withdraw token proceeds | `withdrawTokens(uint256)` |

## Run locally

Serve the frontend over HTTP so the browser can load its configuration:

```sh
python -m http.server 8080 --directory frontend
```

Open http://localhost:8080. Only connect a wallet when you intend to use the configured mainnet contract.

## Regression test

```sh
npm install
npm test
```

The test requires Chromium or Edge. Windows defaults to the standard Edge installation; set `BROWSER_PATH` to another Chromium executable when needed. It mocks all chain requests and broadcasts no transactions. Tests cover pending deployment, RPC failure, read-only initialization and missing-wallet handling.

## Deployment and assessment

Update `frontend/product.json` only after confirming the new contract's network, bytecode and ABI. Do not substitute placeholder addresses or remove truthful limitations. Operator-wallet testing proves technical activity, not independent users. Official social accounts, launch posts, independent users and continuous operation require separate evidence.

## Legacy version

[0xfDE43fd63CE37Bdfa2986a0a257bD2e754ABBD85](https://scan.botchain.ai/address/0xfDE43fd63CE37Bdfa2986a0a257bD2e754ABBD85) remains accessible through the local frontend's `?legacy=1` read-only view. Deployment of this version did not migrate legacy balances or records.
