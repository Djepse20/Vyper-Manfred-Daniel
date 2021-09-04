#pragma line
# @version ^0.2.0
#Contract Yield Farming

from vyper.interfaces import ERC20
#importing the contract to the contract
#makes it possible to call external functions from the contract 
#Use YieldFarm(self).external_function_name to call a given function

from . import YieldFarm 
implements: ERC20

#TODO:
#implement how the value paid per token is dertermined.
#variables
_totalsupply: public(uint256)
_farmToken: public(address)
_rewardToken: public(address)
_balanceof: public(HashMap[address, uint256])
_blockDepositedAt: public(HashMap[address, uint256])
_DepositedByUser: public(HashMap[address, uint256])
_allowance: public(HashMap[address, HashMap[address,uint256]])
_endBlock: public(uint256)
_owner: public(address)
_startBlock: public(uint256)
_lastBlock: public(address)
_userStartBlock: public(HashMap[address,uint256])
_paidPerToken: public(HashMap[address,uint256])
_RewardTokenPaid: public(HashMap[address,uint256])

@external
def __init__(_totalsupply: uint256, _farmToken: address, _rewardToken: address):
    self._totalsupply = 10**8
    self._balanceof[self] = _totalsupply
    self.__farmToken = _farmToken
    self._rewardToken = _rewardToken
    self._endBlock = 0
    self._startBlock = block.number
    self._owner = msg.sender

event Transfer:
    _from: indexed(address)
    _to: indexed(address)
    _value: uint256

event Approval:
    _owner: indexed(address)
    _spender: indexed(address)
    _value: uint256

event Deposit:
    _depositor: indexed(address)
    _value: uint256

event Withdraw:
    _withdrawer: indexed(address)
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
    assert self._allowance[_from][_to] >= _value, "not allowed to transfer that amount of tokens from given adress"
    self._allowance[_from][_to] -= _value
    return self.transferCaller(_from, _to, _value)

@external
def transfer(_to: address, _value: uint256) -> bool:
    return self.transferCaller(msg.sender, _to, _value)


@external
def withdraw( _value: uint256):
    _rewards: uint256 = self.GetRewards()
    _WithdrawValue = min(self._DepositedByUser[msg.sender],_value)
    self._DepositedByUser[msg.sender] -= _WithdrawValue
    ERC20(self._farmToken).transfer(msg.sender, _WithdrawValue)
    ERC20(self._rewardToken).transfer(msg.sender,rewards)
    Withdraw(msg.sender,_WithdrawValue)

@external
def deposit(_value: uint256) -> bool:
    self._DepositedByUser[msg.sender] += _value
    self._blockDepositedAt[msg.sender] = block.number
    ERC20(self.farmToken).transferFrom(msg.sender,self,_value)
    Deposit(msg.sender,_value)
    return True

#function to set the value paid for the farm token or the rewardtoken
@external
    def ValuePaid(_tokenaddress: address, _valuepertoken: uint256):
        assert msg.sender == self._owner "only owner can call"
        assert _tokenaddress == self._farmToken || _tokenaddress == self._rewardToken "Only give value of farm or reward token"
        self._paidPerToken[_tokenaddress] = _valuepertoken
#sets new start block, by transfering a value of the reward token.
@external
def NewStartBlock(_startBlock: uint256, _value: uint256):
    assert _startBlock >= block.number "new start block needs to be bigger"
    self._startBlock = _startBlock
    _RewardTokenPaid[msg.sender] += _value
    ERC20(self.rewardtoken).transferFrom(msg.sender,self,_value)


@internal
def UpdateBookKeeping(_blockDepoistedAt: uint256):
    self._startBlock = mi
#Get Reward For user based on time and percentage of the total amount
@internal
@view
def GetRewards(_AdressToReward: address) -> uint256:
    if self._userStartBlock[_AdressToReward] >= block.number:
        return 0
    UserBalance: uint256 = _DepositedByUser[_AdressToReward]
    TotalBalance: uint256 = ERC20(self.farmToken).balanceOf(self)
    PercentageOfTotal: decimal = convert(UserBalance, decimal)/convert(TotalBalance,decimal)
    PercentageOfTime: decimal = convert(block.number-self._blockDepositedAt[_AdressToReward],decimal)/
    convert(block.number-self._userStartBlock[__AdressToReward], decimal)

    return convert(
    convert(ERC20(self.rewardtoken).balanceOf(self)-self._RewardTokenPaid[_AdressToReward],decimal)*(PercentageOfTotal*PercentageOfTime)
    ,uint256)

