# @version ^0.2.0

# Contract to create an ERC20 token



TOKEN_NAME: constant(String[10]) = "basedtoken"
TOKEN_SUPPLY: constant(uint256) = 10**9
_balances: HashMap[address, uint256]


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
def transfer(_to:address, _amount: uint256) -> bool:
    assert self._balances[msg.sender] >= _amount, 'Not enough balance'
    self._balances[msg.sender] -= _amount
    self._balances[_to] += _amount
    return True
 

@external
@view
def balanceOf(_address:address) -> uint256:
    return self._balances[_address]

