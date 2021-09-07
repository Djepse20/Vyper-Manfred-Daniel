# @version ^0.2.0

# Contract to create an ERC20 token



TOKEN_NAME: constant(String[10]) = "basedtoken"
TOKEN_SUPPLY: constant(uint256) = 10**(5+DECCONSTANT)
_balances: HashMap[address, uint256]
_allowances: HashMap[address, HashMap[address, uint256]]

DECCONSTANT: constant(uint256) = 18


event Transfer:
    _from: indexed(address)
    _to: indexed(address)
    _value: uint256

event Apporve:
    _owner: indexed(address)
    _spender: indexed(address)
    _value: uint256

@external
def __init__():
    self._balances[msg.sender] = TOKEN_SUPPLY

@external
@view
def name() -> String[10]:
    return TOKEN_NAME


@external
@view
def totalsupply() -> uint256:
    return TOKEN_SUPPLY

@external
@view
def balanceOf(_address:address) -> uint256:
    return self._balances[_address]

@external
@view
def allowance(_owner: address, _spender: address) -> uint256:
    return self._allowances[_owner][_spender]

@external
@view
def decimals() -> uint256:
    return DECCONSTANT

@internal
def _transfer(_from: address, _to:address, _amount: uint256):
    assert self._balances[_from] >= _amount, 'Not enough balance'
    self._balances[_from] -= _amount
    self._balances[_to] += _amount
    log Transfer(_from, _to, _amount)

@internal
def _apporve(_owner: address, _spender: address, _amount: uint256):
    self._allowances[_owner][_spender] = _amount
    log Apporve(_owner, _spender, _amount)

@external
def transfer(_to:address, _amount: uint256) -> bool:
    self._transfer(msg.sender, _to, _amount)
    return True

@external
def apporve(_spender: address, _amount: uint256) -> bool:
    self._apporve(msg.sender, _spender, _amount)
    return True

@external 
def transferFrom(_owner: address, _to: address, _amount: uint256) -> bool:
    assert self._allowances[_owner][msg.sender] >= _amount, "The allowance is too low"
    assert self._balances[_owner]>= _amount, "The balance is not enough for this operation"
    self._balances[_owner] -= _amount
    self._balances[_to] += _amount
    self._allowances[_owner][msg.sender] -= _amount
    return True