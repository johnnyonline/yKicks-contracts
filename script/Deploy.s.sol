// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {IOwnable2Step} from "../test/interfaces/IOwnable2Step.sol";
import {IyKicks} from "../test/interfaces/IyKicks.sol";

import "forge-std/Script.sol";

// ---- Usage ----

// deploy:
// forge script script/Deploy.s.sol:Deploy --verify --slow --legacy --etherscan-api-key $KEY --rpc-url $RPC_URL --broadcast
// @todo -- here -- deploy
contract Deploy is Script {
    bool public isTest;
    address public deployer;
    address public owner;

    IyKicks public ykicks;

    function run() public {
        uint256 _pk = isTest ? 42069 : vm.envUint("DEPLOYER_PRIVATE_KEY");
        VmSafe.Wallet memory _wallet = vm.createWallet(_pk);
        deployer = _wallet.addr;

        uint256 _ownerPk = isTest ? 69420 : vm.envUint("OWNER_PRIVATE_KEY");
        VmSafe.Wallet memory _ownerWallet = vm.createWallet(_ownerPk);
        owner = _ownerWallet.addr;

        vm.startBroadcast(_pk);

        // deploy yKicks
        ykicks = IyKicks(deployCode("ykicks", abi.encode(owner)));

        vm.stopBroadcast();

        if (isTest) {
            vm.label({account: address(ykicks), newLabel: "yKicks"});
        } else {
            console.log("Deployer address: %s", deployer);
            console.log("Owner address: %s", owner);
            console.log("yKicks address: %s", address(ykicks));
        }
    }
}
