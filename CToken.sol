pragma solidity ^0.4.14;

import './IERC20.sol';
import './SafeMath.sol';

contract CToken is IERC20 {
    
    using SafeMath for uint256;
    
    uint256 public constant _totalSupply = 1000000000000000000000000000; 
    string public constant symbol = "CTK";
    string public constant name = "C Token";
    uint8 public constant decimals = 18;
    
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    
    function CToken() {
        balances[msg.sender] = _totalSupply; 
    }
    
    function totalSupply() constant returns (uint256 totalSupply){
        return _totalSupply;
    }
    
    function balanceOf(address _owner) constant returns (uint256 balance){
        return balances[_owner];
    }
    //Send _value amount of tokens to address _to
    function transfer(address _to, uint256 _value) returns (bool success){
        require(balances[msg.sender] > _value && _value > 0);
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }
    //Send _value amount of tokens from address _from to address _to
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
        require(
            allowed[_from][msg.sender] >= _value
            && balances[_from] >= _value
            && _value >= 0
        );
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }
    //Allow _spender to withdraw from your account, multiple times, up to the _value amount. 
    //If this function is called again it overwrites the current allowance with _value.
    function approve(address _spender, uint256 _value) returns (bool success){
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    //function allowance(address _owner, address _spender) constant returns (uint256 remaining)
    function allowance(address _owner, address _spender) constant returns (uint256 remaining){
        return allowed[_owner][_spender];
    }
    //Triggered when tokens are transferred.
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    
    //Triggered whenever approve(address _spender, uint256 _value) is called.
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

        
}
