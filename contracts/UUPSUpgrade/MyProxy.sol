// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {StorageSlot} from "@openzeppelin/contracts/utils/StorageSlot.sol";

// OwnableStorageLocation = 0x9016d09d72d40fdae2fd8ceac6b6234c7706214fd39c1cd1e609a0528c199300;
// IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
// data:0x4f1ef28600000000000000000000000020d7f8779f9f151e0dda34c497782af44de2fd2b00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000024fe4b84df000000000000000000000000000000000000000000000000000000000000006f00000000000000000000000000000000000000000000000000000000
// 0x4154b243
// 初始化= 0xf0c57e16840df040f15088dc2f81fe391c3923bec73e23a9662efc9c229c6a00
contract MyProxy is ERC1967Proxy{
    constructor(address implementation, bytes memory _data) 
        ERC1967Proxy(implementation, _data){

    }

    function getUint256Slot(uint256 solt) public view  returns(uint256){
        return StorageSlot.getUint256Slot(bytes32(solt)).value;
    }

    function getAddressSlot(uint256 solt) public view returns(address){
        return StorageSlot.getAddressSlot(bytes32(solt)).value;
    }

}