
    合约升级的底层原理参考https://aandds.com/blog/eth-delegatecall.html
    具体示例(基于openzeppelin实现)如下：
    1.透明代理(Transparent Proxy Pattern)
      - 合约结构参照https://github.com/enzo5188/solidity_messy.github
      - 操作测试流程如下：
        1. 部署demoV1, 得到logic contract address
        2. 调用demoV1 的辅助方法getSign获取到initialize(uint256)的signdata
        3. 部署myProxy合约得到代理合约地址，参数_logic为logic contract address，
           参数initialOwner为proxyAdmin的owner地址（外部地址),参数_data为signdata.
        4. 调用myProxy的getUint256Slot（输入0）可以得到demoV1中number的值，
           调用myProxy的getAddressSlot，分别传入如下参数可获得对应的值：
            0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;//获取到的是当前逻辑合约的地址
            0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;//获取到的是proxyAdmin合约的地址
        5. 调用demoV1 的辅助方法getSign获取到setNumber()的signdata
        6. 在代理合约中通过低级交互calldata方式传入上一步获取的signdata并调用，
           之后再调用myProxy的getUint256Slot,发现number的值已经发生改变（按照demov1中setNumber的逻辑）
        7. 调用myProxy的getAddressSlot,并传入0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103，
           获取到proxyAdmin合约的地址,并通过remix的at address功能将proxy合约加载出来。
        8. 将demov2部署得到demoV2合约地址，并得到demov2中initialize(uint256)的signdata.
        9. 调用proxyAdmin中的upgradeAndCall函数，参数proxy出入代理合约地址，implementation传入demov2的地址，
           data传入上一步得到的signdata，之后执行。
        10.调用myProxy的getAddressSlot,并传入0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc,
           获取到值已经是demov2的地址。
        11.在代理合约中再次通过低级交互calldata方式传入setNumber()的signdata并调用，
           之后再调用myProxy的getUint256Slot,发现number的值已经发生改变（按照demov2中setNumber的逻辑）
        12.升级成功。
                
    2.UUPS代理(Universal Upgradeable Proxy Standard)
        - 合约结构参照https://github.com/enzo5188/solidity_messy.github
        - 操作测试流程如下：
        1. 部署demoV1, 得到logic contract address,
           并通过demoV1中的getSign函数获取initialize(address,uint256)的signdata,
           函数initialize(address initialOwner,uint256 _number)中initialOwner为即将部署的代理合约的owner地址。
        2. 部署代理合约myProxy，参数implementation 为逻辑合约地址，_data为上一步得到的signdata。
        3. 调用myProxy的getUint256Slot（输入0）可以得到demoV1中number的值，
           调用myProxy的getAddressSlot，分别传入如下参数可获得对应的值：
           0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;//获取到的是当前逻辑合约的地址
        4. 调用demoV1 的辅助方法getSign获取到setNumber()的signdata
        5. 在代理合约中通过低级交互calldata方式传入上一步获取的signdata并调用，
           之后再调用myProxy的getUint256Slot,发现number的值已经发生改变（按照demov1中setNumber的逻辑）
        6. 部署demoV2, 得到demov2的地址,并通过demoV2中的getSign函数获取initialize(uint256)的signdata，备用。
        7. 通过demoV2中的helper函数获取升级函数upgradeToAndCall(address,bytes)的signdata,
           注意 upgradeToAndCall(address,bytes) 中address为上一步得到的demoV2的地址，bytes为上一步得到的signdata.
        8. 代理合约中通过低级交互calldata方式传入上一步得到的升级函数upgradeToAndCall(address,bytes)的signdata并调用，
        9.调用myProxy的getAddressSlot,并传入0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc,
           获取到值已经是demov2的地址。
        10.在代理合约中再次通过低级交互calldata方式传入setNumber()的signdata并调用，
           之后再调用myProxy的getUint256Slot,发现number的值已经发生改变（按照demov2中setNumber的逻辑）
        11.升级成功。


    3.Beacon代理（openzeppelin的beacon代理不支持使用proxyAdmin修改bencon的功能，以下代码参照透明代理的实现，加入了使用proxyAdmin修改bencon的功能） 
        - 合约结构参照https://github.com/enzo5188/solidity_messy.github
        - 操作测试流程如下：
        1. 部署demoV1, 得到logic contract address,
        2. 部署myBeaconV1，得到myBeaconV1的地址，其中参数implementation为demoV1的地址，initialOwner为myBeaconV1的owner地址。
        3. 并通过demoV1中的getSign函数获取initialize(uint256)的signdata
        4. 部署代理合约myProxy，参数beacon 为myBeaconV1的地址，data为上一步得到的signdata,initialOwner为proxyAdmin合约的owner地址(外部地址)
        5. 调用myProxy的getUint256Slot（输入0）可以得到demoV1中number的值，
           调用myProxy的getAddressSlot，分别传入如下参数可获得对应的值：
            0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;//获取到的是当前beacon的地址
            0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;//获取到的是proxyAdmin合约的地址
        4. 调用demoV1 的辅助方法getSign获取到setNumber()的signdata
        5. 在代理合约中通过低级交互calldata方式传入上一步获取的signdata并调用，
           之后再调用myProxy的getUint256Slot,发现number的值已经发生改变（按照demov1中setNumber的逻辑）
        6. 部署demoV2, 得到demov2的地址.
        7. 在myBeaconV1中调用upgradeTo函数，其中newimplementation传入demoV2的地址，执行。
        9.调用myProxy的getAddressSlot,并传入0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc,
           获取到值已经是demov2的地址。
        10.在代理合约中再次通过低级交互calldata方式传入setNumber()的signdata并调用，
           之后再调用myProxy的getUint256Slot,发现number的值已经发生改变（按照demov2中setNumber的逻辑）
        11. 升级成功。

        12. 接下来是测试proxyAdmin的功能，
            调用myProxy的getAddressSlot,并传入0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103，
            获取到proxyAdmin合约的地址,并通过remix的at address功能将proxy合约加载出来。
        13 .部署MybeaconV2 , 得到myBeaconV2的地址，其中参数implementation为demoV1的地址，initialOwner为myBeaconV2的owner地址。
        14 .调用proxyAdmin中的upgradeBeaconToAndCall函数，参数proxy出入代理合约地址，参数beaconAddress传入MybeaconV2的地址，
            参数data传入0x即可。之后执行。
        15.调用myProxy的getAddressSlot,并传入0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50,
           获取到值已经是beaconv2的地址。
        16.在代理合约中再次通过低级交互calldata方式传入setNumber()的signdata并调用，
           之后再调用myProxy的getUint256Slot,发现number的值已经发生改变（按照beaconv2中demoV1的逻辑）




   


