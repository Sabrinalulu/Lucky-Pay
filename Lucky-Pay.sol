pragma solidity ^0.4.8;
// ----------------------------------------------------------------------------------------------
// Sample fixed supply token contract
// Enjoy. (c) BokkyPooBah 2017. The MIT Licence.
// ----------------------------------------------------------------------------------------------
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol ";
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/issues/20
contract ERC20Interface {
    // Get the total token supply
    function totalSupply() constant returns (uint256);
    // Get the account balance of another account with address _owner function balanceOf(address _owner) constant returns (uint256 balance);
    // Send _value amount of tokens to address _to
    function transfer(address _to, uint256 _value) returns (bool success);
    // Send _value amount of tokens from address _from to address _to
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    // Allow _spender to withdraw from your account, multiple times, up to the _value amount. // If this function is called again it overwrites the current allowance with _value.
    // this function is required for some DEX functionality
    function approve(address _spender, uint256 _value) returns (bool success);
    // Returns the amount which _spender is still allowed to withdraw from _owner
    function allowance(address _owner, address _spender) constant returns (uint256 remaining);
    // Triggered when tokens are transferred.
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    // Triggered whenever approve(address _spender, uint256 _value) is called.
    event Approval(address indexed _owner, address indexed _spender, uint256 _value); }

contract FixedSupplyToken is ERC20Interface { string public constant symbol = "fuban";
    string public constant name = "fuban";
    uint8 public constant decimals = 18;
    using SafeMath for uint;
    uint256 _totalSupply =10000 ether;
    address public owner;
    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed; uint luckyCoin;
    uint TotalLCoin;
    modifier onlyOwner() {
        if (msg.sender != owner) {
            require(msg.sender == owner);
        }_;
    }
    
    function FixedSupplyToken() { //定義初始帳戶裡有多少錢
        owner = msg.sender;
        balances[owner] = 50000;
    }
    
    function totalSupply() constant returns (uint256) {//fuban 幣的總額 return _totalSupply;
    }
    function balanceOf(address _owner) constant returns (uint256 balance) {//查目前帳戶的餘額 return balances[_owner];
    }
    function transfer(address _to, uint256 _amount) returns (bool success) {//轉錢
        if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) { 
            balances[msg.sender] -= _amount;
            balances[_to] += _amount;
            Transfer(msg.sender, _to, _amount);
            luckyCoin = (now % (_amount - 1)) + 1; //每次交易最多能得到_amount 個 LuckyCoin,最少 1 個 TotalLCoin += luckyCoin;
            return true;
        } else {
            return false;
        }
    }
    
    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) returns (bool success) {
        if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0
        && balances[_to] + _amount > balances[_to]) {
            balances[_from] -= _amount;
            allowed[_from][msg.sender] -= _amount;
            balances[_to] += _amount;
            Transfer(_from, _to, _amount);
            luckyCoin = (now % (_amount - 1)) + 1;//取得 LuckCoin 的數量限制為 1~當前交易金額
            return true;
        } else {
        return false;
        }
    }
    
    function approve(address _spender, uint256 _amount) returns (bool success) { allowed[msg.sender][_spender] = _amount;
        Approval(msg.sender, _spender, _amount);
        return true;
    }
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) { return allowed[_owner][_spender];
    }
// ===================================================================


    function getLuckyCoin() public constant returns (uint256) { //取得當前交易能得到的 LuckyCoin return luckyCoin;
    }
    function getTotalLuckyCoin() public constant returns (uint256) { //取得目前累積的 Luckycoin return TotalLCoin;
    }
}