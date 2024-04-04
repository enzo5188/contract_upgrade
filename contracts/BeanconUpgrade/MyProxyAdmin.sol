// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
contract ProxyAdmin is Ownable {
    constructor(address initialOwner) Ownable(initialOwner) {

    }

    function upgradeBeaconToAndCall(
        IBeaconProxy proxy, 
        address beaconAddress, 
        bytes memory data) 
        public  
        onlyOwner {
        proxy.upgradeBeaconToAndCall(beaconAddress, data);
    }
}

interface IBeaconProxy {

    function upgradeBeaconToAndCall(address newBeacon, bytes memory data) external;
    
}
