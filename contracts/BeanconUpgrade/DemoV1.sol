// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import {Initializable } from  "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract Demo is Initializable{
    uint256 public number;

    function initialize(uint256 _number) public initializer {
        number = _number;
    }

    function getNumber() public view returns(uint256){
        return number;
    }

    function setNumber() public{
        number = number * 3;
    }

    function getSign(string memory str,uint256 value) public pure returns(bytes memory){
        return value == 0 ?abi.encodeWithSignature(str):abi.encodeWithSignature(str,value);
    }
}