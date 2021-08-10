#pragma line
# @version ^0.2.0
#Contract Yield Farming

from vyper.interfaces import ERC20
#importing the contract to the contract
#makes it possible to call external functions from the contract 
#Use YieldFarm(self).external_function_name to call a given function
from . import YieldFarm 
implements: ERC20


#variables
_totalsupply: public(uint256)
_farmToken: public(address)
_rewardToken: public(address)
_balanceof: public(HashMap[address, uint256])
_blockTradedAt: public(HashMap[address, uint256])
_DepositedByUser: public(HashMap[address, uint256])
_allowance: public(HashMap[address, HashMap[address,uint256]])

@external
def __init__(_totalsupply: uint256, _farmToken: address, _rewardToken: address):
    self._totalsupply = 10**8
    self._balanceof[self] = _totalsupply
    self.__farmToken = _farmToken
    self._rewardToken = _rewardToken

event Transfer:
    _from: indexed(address)
    _to: indexed(address)
    _value: uint256

event Approval:
    _owner: indexed(address)
    _spender: indexed(address)
    _value: uint256


@external
def balanceOf(_owner: address) -> uint256:
    return self._balanceof[_owner]
@external
def allowance(_owner: address, _spender: address) -> uint256:
    return self._allowance[_owner][_spender]
@external
def totalSupply() -> uint256:
    return self._totalsupply
@external
def approve(_spender: address, _value: uint256) -> bool:
    assert self._balanceof[msg.sender] >= _value, "not enough tokens in balance"
    self._allowance[msg.sender][_spender] = _value
    log Approval(msg.sender, _spender, _value)
    return True

#Helper function containing the logic for transfering tokens.
@internal 
def transferCaller(_from: address,_to: address, _value: uint256) -> bool:
    assert self._balanceof[_from] >= _value, "not enough tokens in balance"
    self._balanceof[_from] -= _value
    self._balanceof[_to] += _value
    log Transfer(_from, _to, _value)
    return True
#transfer tokens form one adress to another
@external
def transferFrom(_from: address, _to: address, _value: uint256) -> bool:
    assert self._allowance[_from][msg.sender] >= _value, "not allowed to transfer that amount of tokens from given adress"
    self._allowance[_from][msg.sender] -= _value
    return self.transferCaller(_from, _to, _value)

@external
def transfer(_to: address, _value: uint256) -> bool:
    return self.transferCaller(msg.sender, _to, _value)


@external
def withdraw( _to: address, _value: uint256):
    YieldFarm(self).transfer(_to, _value)

@external
def deposit() -> bool:
        ERC20(self.farmToken).transfer(self,_value)
    return True

@external
def withdraw() -> bool:
    
    return True

#Get Reward For Specific user
@internal
@view
def GetRewards(_AdressToReward: address) -> uint256:
    UserBalance: uint256 = _DepositedByUser[_AdressToReward]
    TotalBalance: uint256 = ERC20(self.farmToken).balanceOf(self)
    PercentageOfTotal: decimal = convert(TotalBalance)/convert(UserBalance, decimal)
    Reward: uint256 = convert(
        convert(ERC20(self.rewardtoken).balanceOf(self))
    ,uint256)