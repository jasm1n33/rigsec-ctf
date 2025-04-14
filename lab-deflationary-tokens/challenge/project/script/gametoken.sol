pragma solidity ^0.8.12;

contract GameToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public _owner;

    mapping(address => uint256) public _balance;
    mapping(address => mapping(address => uint256)) public allowance;

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor() {
        name = "game";
        symbol = "gm";
        decimals = 18;
        _owner = msg.sender;
        totalSupply = 1_000_000 * 10 ** decimals;
        _mint(_owner, totalSupply);
    }

    function balanceOf(address owner) public view returns (uint256) {
        return _balance[owner];
    }

    function _mint(address to, uint256 value) private {
        _balance[to] = _balance[to] + value;
        emit Transfer(address(0), to, value);
    }

    function _approve(address owner, address spender, uint256 value) private {
        allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _transfer(address from, address to, uint256 value) private {
        require(from != to);
        require(_balance[from] >= value);
        _balance[from] = _balance[from] - value;
        _balance[to] = _balance[to] + value;
        if (from != address(_owner)) {
            takefee(from, value);
        }
        emit Transfer(from, to, value);
    }

    function approve(address spender, uint256 value) external returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transfer(address to, uint256 value) external returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        require(allowance[from][msg.sender] >= value);
        allowance[from][msg.sender] = allowance[from][msg.sender] - value;
        _transfer(from, to, value);
        return true;
    }

    function takefee(address spender, uint256 value) private {
        uint256 fee = value * 10 / 100;
        _balance[spender] = _balance[spender] - fee;
    }
}
