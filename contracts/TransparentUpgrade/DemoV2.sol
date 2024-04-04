// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import {Initializable } from  "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract Demo is Initializable{
    uint256 public number;
    uint256 public number1;

    function initialize(uint256 _number) public reinitializer(2) {
        number1 = _number;
    }

    function getNumber() public view returns(uint256){
        return number;
    }

    function setNumber() public{
        number = number + 1;
    }

    function getNumber1() public view returns(uint256){
        return number;
    }

    function setNumber1() public{
        number = number + 1;
    }

    function getSign(string memory str,uint256 value) public pure returns(bytes memory){
        return value == 0 ?abi.encodeWithSignature(str):abi.encodeWithSignature(str,value);
    }
}