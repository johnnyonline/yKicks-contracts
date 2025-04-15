// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "../script/Deploy.s.sol";

import "forge-std/Test.sol";

abstract contract Base is Deploy, Test {
    address public constant STRATEGY = 0x84E750c4B79482050Ab25C7B3D77fFF334663A53; // Morpho LlamaRisk crvUSD Vault Compounder
    address public constant REWARD_TOKEN = 0x58D97B57BB95320F9a05dC918Aef65434969c2B2; // MORPHO

    function setUp() public virtual {
        // notify deplyment script that this is a test
        {
            isTest = true;
        }

        // create fork
        {
            uint256 _blockNumber = 22_275_356; // cache state for faster tests
            vm.selectFork(vm.createFork(vm.envString("MAINNET_RPC_URL"), _blockNumber));
        }

        // deploy and initialize contracts
        {
            run();
        }
    }

    function airdrop(address _token, address _to, uint256 _amount) public {
        deal({token: _token, to: _to, give: _amount});
    }
}
