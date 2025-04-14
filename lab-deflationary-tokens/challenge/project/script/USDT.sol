pragma solidity ^0.8.12;

contract USDT {
    string public name;
    string public symbol;
    uint256 public decimals = 18;
    uint256 public totalSupply;
    address public owner;
    mapping(address => uint256) public _balance;
    mapping(address => mapping(address => uint256)) public allowance;

    event Approval(address indexed user, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(string memory _name, address _owner) {
        name = _name;
        owner = _owner;
    }

    function balanceOf(address user) public view returns (uint256) {
        return _balance[user];
    }

    function _mint() public {
        require(msg.sender == owner);
        _balance[msg.sender] += 10000 * 10 ** decimals;
    }

    function _approve(address user, address spender, uint256 value) private {
        allowance[user][spender] = value;
        emit Approval(user, spender, value);
    }

    function _transfer(address from, address to, uint256 value) private {
        require(_balance[from] >= value);
        _balance[from] = _balance[from] - value;
        _balance[to] = _balance[to] + value;
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
}
