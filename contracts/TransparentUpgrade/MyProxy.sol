// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {StorageSlot} from "@openzeppelin/contracts/utils/StorageSlot.sol";
// data : 0xfe4b84df000000000000000000000000000000000000000000000000000000000000038f
// IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
// ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
// 0x4154b243

contract MyProxy is TransparentUpgradeableProxy{
    constructor(address _logic, address initialOwner, bytes memory _data) 
        TransparentUpgradeableProxy(_logic,initialOwner, _data){

    }

    function getUint256Slot(uint256 solt) public view returns(uint256){
        return StorageSlot.getUint256Slot(bytes32(solt)).value;
    }

    function getAddressSlot(uint256 solt) public view returns(address){
        return StorageSlot.getAddressSlot(bytes32(solt)).value;
    }

}