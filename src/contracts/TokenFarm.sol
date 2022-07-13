// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DaiToken.sol";
import "./GuruToken.sol";


contract TokenFarm{

    string public name = "Saksham Token Farm";
    string public sign = "DTF";

    DaiToken  daiToken ;
    GuruToken  guruToken;
    address owner;
    mapping(address => uint256) public stakedAmount;
    mapping(address => bool) public isStaked;
    mapping(address => bool) public isStaking;
    address[] public stakers;

    constructor(address _daiToken , address  _guruToken) public {
        daiToken = DaiToken(_daiToken);
        guruToken = GuruToken(_guruToken);
        owner = msg.sender;

    }

    function DaiAmount() public view returns(uint256){
        uint256 daiAmount = daiToken.balanceOf(address(this));
        return daiAmount;
    }

    function GuruAmount() public view returns(uint256){
        uint256 guruAmount = guruToken.balanceOf(address(this));
        return guruAmount;
    }

    function MyDaiAmount() public view returns(uint256){
        uint256 mydaiAmount = daiToken.balanceOf(msg.sender);
        return mydaiAmount;
    }

    function MyGuruAmount() public view returns(uint256){
        uint256 myguruAmount = guruToken.balanceOf(msg.sender);
        return myguruAmount;
    }
    
    function stakeTokens(uint256 _amount ) public payable{
        require(_amount > 0 , "Cannot Stake 0 tokens");
        daiToken.transferFrom(msg.sender , address(this), _amount);
        stakedAmount[msg.sender] = stakedAmount[msg.sender] + _amount;
        
        if(!isStaked[msg.sender]){
            stakers.push(msg.sender);
            
        }
        isStaked[msg.sender] = true;
        

    }

    function getRewards() public{
        require(msg.sender == owner);

        for (uint256 i=0 ; i < stakers.length ; i++){
            address receipent = stakers[i];
            if(stakedAmount[receipent] > 0 ){
            guruToken.transfer(receipent, _RewardRatio(receipent));
            }
        }
    }

    function getMyRewards() public{
        guruToken.transfer(msg.sender , _MyRewardRatio() );
        
    }

    function _MyRewardRatio() public view returns(uint256){
        uint256 myRewardRatio = stakedAmount[msg.sender]*3;
        return myRewardRatio;
    }

    function _RewardRatio(address _receipent) public view returns(uint256){
        uint256 rewardRatio = stakedAmount[_receipent]*3;
        return rewardRatio;
    }

    function unstakeDai() public{
        require(isStaked[msg.sender] , 'Not a staker yet');
        daiToken.transfer(msg.sender, stakedAmount[msg.sender]);
        stakedAmount[msg.sender] = 0;
        isStaked[msg.sender] = false;

    }



}



