# Laurel — Fan Tokens

> Laurel gives creators and clubs a capped fungible token for their communities. Fans mint in, hold loyalty, and redeem-perks logic lives in the token itself rather than a middleman dashboard.

## What it does

Laurel gives creators and clubs a capped fungible token for their communities. Fans mint in, hold loyalty, and redeem-perks logic lives in the token itself rather than a middleman dashboard. The entire lifecycle lives in one contract, every button in the UI calls a real function on it — there is no mock backend.

## Contract

| | |
|---|---|
| File | `contracts/FanTokens.sol` |
| Contract name | `FanTokens` (inherits `ReentrancyGuard`) |
| Solidity | `^0.8.20` |
| State functions | 8 (of which 1 payable) |
| Deployed (mainnet 677) | not yet deployed — placeholder `0x000…000` |

### Function surface

| Function | Type | Returns |
|---|---|---|
| `createToken` | write | uint256 |
| `buyTokens` | payable | tx receipt |
| `transferTokens` | write | result / revert |
| `deactivateToken` | write | result / revert |
| `withdrawTokens` | write | result / revert |
| `tokenInfo` | view | address creator, string memory name, string memory symbol, uint256 supply, uint256 price, uint256 raised, bool active, uint256 holders |
| `balanceOf` | view | uint256 |
| `tokenCount` | view | uint256 |

### Events

| Event | Signature |
|---|---|
| `TokenCreated` | (uint256 indexed tid, address indexed creator, string name, string symbol, uint256 price) |
| `TokensBought` | (uint256 indexed tid, address indexed buyer, uint256 paid, uint256 minted) |
| `TokensTransferred` | (uint256 indexed tid, address indexed from, address indexed to, uint256 amount) |
| `TokenDeactivated` | (uint256 indexed tid) |
| `TokenWithdrawn` | (uint256 indexed tid, address indexed creator, uint256 amount) |

## Network

| | |
|---|---|
| Chain | BOT Chain Mainnet (chainId `677`) |
| RPC | `https://rpc.botchain.ai` |
| Explorer | `https://scan.botchain.ai` |
| Native currency | BOT (18 decimals) |
| Testnet | BOT Chain Testnet (chainId `968`) - `https://rpc.bohr.life` |

## Frontend

- **Wallet connection** - [Reown/AppKit](https://reown.com) (Web3Modal v2, inline modal, `subscribeAccount` / `subscribeNetwork`)
- **Web3 library** - ethers.js v6 (`BrowserProvider`, `Contract`, `parseEther`)
- **Animation** - GSAP 3 + ScrollTrigger (`expo.out` entrances, `prefers-reduced-motion` fallback renders content instantly)
- **Zero build step** - single `index.html`, CDN imports via ESM import map; no bundler, no framework runtime
- **Accessibility** - auto-generated `aria-label`s on all binary and form controls, focus-visible styles, button busy states

## Run it locally

```bash
git clone https://github.com/Henoch4/FanTokens.git
cd FanTokens
# open the frontend directly (no build step)
start frontend/index.html   # Windows
# or serve it if your browser blocks file:// modules:
npx serve frontend
```

> **Note** — contract addresses: the UI reads its deploy target from the `CA` constant at the top of the inline script. Until the contract is deployed to mainnet 677, the demo runs against the deterministic sample data built into the page; after deployment, set `CA['677']` to the real address and every button goes live.