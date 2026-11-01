// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract ReentrancyGuard {
    bool private _nonReentrant;
    constructor() { _nonReentrant = false; }
    modifier nonReentrant() {
        require(!_nonReentrant, "ReentrancyGuard: reentrant call");
        _nonReentrant = true;
        _;
        _nonReentrant = false;
    }
}

contract FanTokens is ReentrancyGuard {
    struct FanToken {
        address creator;
        string name;
        string symbol;
        uint256 totalSupply;
        uint256 price;
        uint256 raised;
        bool active;
        mapping(address => uint256) balances;
        address[] holders;
    }

    FanToken[] public tokens;
    mapping(address => uint256[]) public creatorTokens;

    event TokenCreated(uint256 indexed tid, address indexed creator, string name, string symbol, uint256 price);
    event TokensBought(uint256 indexed tid, address indexed buyer, uint256 paid, uint256 minted);
    event TokensTransferred(uint256 indexed tid, address indexed from, address indexed to, uint256 amount);
    event TokenDeactivated(uint256 indexed tid);
    event TokenWithdrawn(uint256 indexed tid, address indexed creator, uint256 amount);

    function createToken(string calldata name, string calldata symbol, uint256 price) external returns (uint256) {
        require(price > 0, "Zero price");
        FanToken storage t = tokens.push();
        t.creator = msg.sender;
        t.name = name;
        t.symbol = symbol;
        t.price = price;
        t.active = true;
        uint256 tid = tokens.length - 1;
        creatorTokens[msg.sender].push(tid);
        emit TokenCreated(tid, msg.sender, name, symbol, price);
        return tid;
    }

    function buyTokens(uint256 tid) external payable nonReentrant {
        FanToken storage t = tokens[tid];
        require(t.active, "Token inactive");
        require(msg.value > 0, "Zero value");
        uint256 minted = msg.value * 1e18 / t.price;
        require(minted > 0, "Too little pay");
        if (t.balances[msg.sender] == 0) t.holders.push(msg.sender);
        t.balances[msg.sender] += minted;
        t.totalSupply += minted;
        t.raised += msg.value;
        emit TokensBought(tid, msg.sender, msg.value, minted);
    }

    function transferTokens(uint256 tid, address to, uint256 amount) external {
        FanToken storage t = tokens[tid];
        require(t.active, "Token inactive");
        require(to != address(0), "Zero address");
        require(t.balances[msg.sender] >= amount, "Insufficient balance");
        t.balances[msg.sender] -= amount;
        if (t.balances[to] == 0) t.holders.push(to);
        t.balances[to] += amount;
        emit TokensTransferred(tid, msg.sender, to, amount);
    }

    function deactivateToken(uint256 tid) external {
        FanToken storage t = tokens[tid];
        require(msg.sender == t.creator, "Creator only");
        require(t.active, "Already inactive");
        t.active = false;
        emit TokenDeactivated(tid);
    }

    // FIX: buyTokens collected raised ETH but nobody could ever withdraw it —
    // one-way lockbox. Creator can now pull the raised balance out once the
    // token is deactivated.
    function withdrawTokens(uint256 tid) external nonReentrant {
        FanToken storage t = tokens[tid];
        require(msg.sender == t.creator, "Creator only");
        require(!t.active, "Token active");
        uint256 raised = t.raised;
        require(raised > 0, "Nothing raised");
        t.raised = 0;
        (bool ok,) = payable(msg.sender).call{value: raised}("");
        require(ok, "ETH transfer failed");
        emit TokenWithdrawn(tid, msg.sender, raised);
    }

    function tokenInfo(uint256 tid) external view returns (address creator, string memory name, string memory symbol, uint256 supply, uint256 price, uint256 raised, bool active, uint256 holders) {
        FanToken storage t = tokens[tid];
        return (t.creator, t.name, t.symbol, t.totalSupply, t.price, t.raised, t.active, t.holders.length);
    }

    function balanceOf(uint256 tid, address holder) external view returns (uint256) {
        return tokens[tid].balances[holder];
    }

    function tokenCount() external view returns (uint256) {
        return tokens.length;
    }
}
