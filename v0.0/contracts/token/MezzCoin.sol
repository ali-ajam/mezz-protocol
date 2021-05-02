// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "../math/SafeMath.sol";
import "./IERC20.sol";

contract MezzCoin is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) public balances;
	mapping (address => mapping (address => uint256)) public allowed;

    string public name;             // Mezz        
    uint8 public decimals;          // 2
    string public symbol;           // Mezz
    uint256 private supply; 

	constructor(uint256 _initialAmount, string memory _tokenName,
        uint8 _decimalUnits, uint256 _totalSupply,
        string memory _tokenSymbol) {
		balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
        name = _tokenName;                                   // Set the name for display purposes
        decimals = _decimalUnits;                            // Amount of decimals for display purposes
		supply = _totalSupply;
        symbol = _tokenSymbol;   
	}

	/**
    * @dev Total number of tokens in existence
    */
    function totalSupply() public override view returns (uint256) {
    return supply;
    }

	/**
	* @dev Transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value) public override returns (bool success) {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

	/**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {
        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
		require(_to != address(0));
        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param _owner The address to query the balance of.
    * @return balance An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address _owner) public override view returns (uint256 balance) {
        return balances[_owner];
    }

	/**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
    function approve(address _spender, uint256 _value) public override returns (bool success) {
        require(_spender != address(0));

        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }
	/**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return  remaining A uint256 specifying the amount of tokens still available for the spender.
   */
    function allowance(address _owner, address _spender) public override view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
}
