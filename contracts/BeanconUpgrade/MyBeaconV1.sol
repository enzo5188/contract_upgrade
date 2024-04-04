// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

contract MyBeacon is UpgradeableBeacon{
    constructor(address implementation, address initialOwner) 
        UpgradeableBeacon(implementation, initialOwner){ 
    }

}