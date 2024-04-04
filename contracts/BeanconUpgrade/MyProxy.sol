// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import {BeaconProxy} from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import {StorageSlot} from "@openzeppelin/contracts/utils/StorageSlot.sol";
import {ERC1967Utils} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {ProxyAdmin,IBeaconProxy} from "./MyProxyAdmin.sol";
import {IBeacon} from "@openzeppelin/contracts/proxy/beacon/IBeacon.sol";

// BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
// ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
// 0x4154b243
// 0xfe4b84df000000000000000000000000000000000000000000000000000000000000006f
contract MyProxy is BeaconProxy{
    address private immutable _admin;

    error ProxyDeniedAdminAccess();

    constructor(address beacon, bytes memory data,address initialOwner) 
        BeaconProxy(beacon, data){ 
        _admin = address(new ProxyAdmin(initialOwner));
        ERC1967Utils.changeAdmin(_admin);
    }

    event log1(address adr1,address adr2);

    event log2(address adr1,bytes  adr2);

    event log3(bytes4 sign1,bytes4  sign2);

    function _implementation() internal view virtual override returns (address) {
        return IBeacon(ERC1967Utils.getBeacon()).implementation();
    }
    
    function _fallback() internal virtual override {
        emit log1(msg.sender,_admin);
        if (msg.sender == _admin) {
            emit log3(msg.sig,IBeaconProxy.upgradeBeaconToAndCall.selector);
            if (msg.sig != IBeaconProxy.upgradeBeaconToAndCall.selector) {
                revert ProxyDeniedAdminAccess();
            } else {
                _dispatchUpgradeBeaconToAndCall();
            }
        } else {
            super._fallback();
        }
    }

    function _dispatchUpgradeBeaconToAndCall() private {
        (address beaconAddress, bytes memory data) = abi.decode(msg.data[4:], (address, bytes));
        emit log2(beaconAddress,data);
        ERC1967Utils.upgradeBeaconToAndCall(beaconAddress, data);
    }
   
    
    function getUint256Slot(uint256 solt) public view returns(uint256){
        return StorageSlot.getUint256Slot(bytes32(solt)).value;
    }

    function getAddressSlot(uint256 solt) public view returns(address){
        return StorageSlot.getAddressSlot(bytes32(solt)).value;
    }

}