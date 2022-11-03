// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 < 0.7.0;
pragma experimental ABIEncoderV2;
import "./SafeMath.sol";


//Interface de nuestro token ERC20
interface IERC20{
    //Devuelve la cantidad de tokens en existencia
    function totalSupply() external view returns (uint256);

    //Devuelve la cantidad de rokens para una dirección indicada por parámetro
    function balanceOf(address _account) external view returns (uint256);

    //Devuelve el número de token que el spender podrá gastar en nombre del propietario (owner)
    function allowance(address _owner, address _spender) external view returns (uint256);

    //Devuelve un valor booleano resultado de la operación indicada
    function transfer(address _recipient, uint256 _amount) external returns (bool);

    //Devuelve un valor booleano con el resultado de la operación de gasto
    function approve(address _spender, uint256 _amount) external returns (bool);

    //Devuelve un valor booleano con el resultado de la operación de paso de una cantidad de tokens usando el método allowance()
    function transferFrom(address _sender, address _recipient, uint256 _amount) external returns (bool);



    //Evento que se debe emitir cuando una cantidad de tokens pase de un origen a un destino
    event Transfer(address indexed from, address indexed to, uint256 value);

    //Evento que se debe emitir cuando se establece una asignación con el mmétodo allowance()
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

//Implementación de las funciones del token ERC20
contract ERC20Basic is IERC20{

    string public constant name = "ERC20PRIMERTOKEN";
    string public constant symbol = "LAAV";
    uint8 public constant decimals = 18;

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed owner, address indexed spender, uint256 tokens);


    using SafeMath for uint256;

    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;
    uint256 _totalSupply;

    constructor (uint256 _initialSupply) public{
        _totalSupply = _initialSupply;
        balances[msg.sender] = _totalSupply;
    }


    function totalSupply() public override view returns (uint256){
        return _totalSupply;
    }

    function increaseTotalSupply(uint _newTokensAmount) public {
        _totalSupply += _newTokensAmount;
        balances[msg.sender] += _newTokensAmount;
    }

    function balanceOf(address _tokenOwner) public override view returns (uint256){
        return balances[_tokenOwner];
    }

    function allowance(address _owner, address _delegate) public override view returns (uint256){
        return allowed[_owner][_delegate];
    }

    function transfer(address _recipient, uint256 _numTokens) public override returns (bool){
        require(_numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(_numTokens);
        balances[_recipient] = balances[_recipient].add(_numTokens);
        emit Transfer(msg.sender, _recipient, _numTokens);
        return true;
    }

    function approve(address _delegate, uint256 _numTokens) public override returns (bool){
        allowed[msg.sender][_delegate] = _numTokens;
        emit Approval(msg.sender, _delegate, _numTokens);
        return true;
    }

    function transferFrom(address _owner, address _buyer, uint256 _numTokens) public override returns (bool){
        require(_numTokens <= balances[_owner]);
        require(_numTokens <= allowed[_owner][msg.sender]);

        balances[_owner] = balances[_owner].sub(_umTokens);
        allowed[_owner][msg.sender] = allowed[_owner][msg.sender].sub(_numTokens);
        balances[_buyer] = balances[_buyer].add(_numTokens);
        emit Transfer(_owner, _buyer, _numTokens);
        return true;
    }
}