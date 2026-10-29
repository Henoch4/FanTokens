# Fan Tokens

**Creator coins at a fixed price, settled natively.**

Live on **BOT Chain mainnet (chain ID 677)**.

| | |
|---|---|
| Contract | `0xfDE43fd63CE37Bdfa2986a0a257bD2e754ABBD85` |
| Network | BOT Chain Mainnet |
| Chain ID | 677 |
| RPC | https://rpc.botchain.ai |
| Explorer | https://scan.botchain.ai/ |
| Website | https://botchain.ai |

## What it does

Any creator mints a token at a fixed price per whole token. Buyers pay in BOT and minted supply is tracked per address. Transfers are peer to peer. The creator can deactivate the token permanently, closing further buys.

## Functions

- `createToken(name, symbol, price) — price is BOT per whole token`
- `buyTokens(tokenId) — payable, mints value × 1e18 / price`
- `transferTokens(tokenId, to, amount) — peer to peer`
- `deactivateToken(tokenId) — creator only, permanent`

## Frontend

A single self-contained `index.html` — no build step, no bundler. Open it directly or serve the folder statically.

- Wallet connect through any injected EIP-1193 wallet (MetaMask, OKX Wallet).
- If chain 677 is not configured, the page offers to add it (`wallet_addEthereumChain`).
- Every number on the page is read live from the contract over JSON-RPC; nothing is mocked.
- All writes are sent from the connected account and confirmed before the UI refreshes.

```bash
# any static server works
npx serve .
```

## Contract

`contracts/FanTokens.sol` — self-contained Solidity 0.8.20, no external imports. Reentrancy guard and ownership are declared inline so the file compiles standalone with `solc`.

## License

MIT
