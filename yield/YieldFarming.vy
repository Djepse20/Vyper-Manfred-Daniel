#pragma line
# @version ^0.2.0
#Contract Yield Farming

from vyper.interfaces import ERC20

implements: ERC20

TOTALSLUPPY: pbulic(uint256) = 10**27 #et tal
_balanceof: public(HashMap[address, uint256])
_allowance: public(HashMap[address, HashMap[address,uint256]])

event Transfer:
    _from: indexed(address)
    _to: indexed(address)
    _value: uint256

event Approval:
    _owner: indexed(address)
    _spender: indexed(address)
    _value: uint256

@external
def allowance(_owner: address, _spender: address) -> uint256:
    return self.allowance[_owner][_spender]
@external
def approve(_spender: address, _value: uint256) -> bool:
    self.allowance[msg.sender][_spender] = value
    log Approval(msg.sender, _spender, _value)
    return true

#Helper function containing the logic for transfering tokens.
@internal 
def transferCaller(_from: address,_to: address, _value: uint256) -> bool:
    assert self._balanceof[_from] >= _value, "not enough tokens in balance"
    self._balanceof[_from] -= _value
    self._balanceof[_to] += _value
    log Transfer(_from, _to, _value)
    return true
#transfer tokens form one adress to another
@external
def transferFrom(_from: address, _to: address, _value: uint256) -> bool:
    assert self.allowance[msg.sender][_from] >= _value, "not allowed to transfer that amount of tokens from given adress"
    return transferCaller(_from, _to: address, _value: uint256)

@external
def transfer(_to: address, _value: uint256) -> bool:
    return transferCaller(msg.sender, _to, _value)