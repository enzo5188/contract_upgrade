// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract Demo is Initializable,UUPSUpgradeable,OwnableUpgradeable{
    uint256 public number;
    uint256 public number1;
    // 0xfe4b84df0000000000000000000000000000000000000000000000000000000000000378
    function initialize(uint256 _number) public reinitializer(2) {
        number1 = _number;
    }

    function getNumber() public view onlyProxy returns(uint256) {
        return number;
    }

    function setNumber() public onlyProxy{
        number = number + 1;
    }

    function getNumber1() public view onlyProxy returns(uint256) {
        return number;
    }

    function setNumber1() public onlyProxy{
        number = number + 2;
    }

    function getSign(string memory str,uint256 _number) public pure returns(bytes memory){
        return _number == 0 ?abi.encodeWithSignature(str):abi.encodeWithSignature(str,_number);
    }

    function helper(address addr_,bytes memory data) public  pure returns(bytes memory){
        // bytes memory bts = hex"fe4b84df000000000000000000000000000000000000000000000000000000000000006f";
        return abi.encodeWithSignature("upgradeToAndCall(address,bytes)",addr_,data);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}
}