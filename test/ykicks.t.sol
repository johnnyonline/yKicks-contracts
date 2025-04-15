// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "./Base.sol";

interface IStrategy {
    function kickAuction(address _from) external;
    function setKeeper(address _keeper) external;
    function management() external view returns (address);
}

contract yKicksTests is Base {
    function setUp() public override {
        Base.setUp();
    }

    function test_setupOK(address _notApprovedCaller) public view {
        assertEq(ykicks.owner(), owner, "test_setupOK: E0");
        assertEq(ykicks.pending_owner(), address(0), "test_setupOK: E1");
        assertFalse(ykicks.approved_callers(_notApprovedCaller), "test_setupOK: E2");
    }

    function test_setApprovedCaller(address _approvedCaller) public {
        vm.assume(_approvedCaller != address(0));

        vm.expectRevert("!owner");
        ykicks.set_approved_caller(_approvedCaller, true);

        vm.expectRevert("!caller");
        vm.prank(owner);
        ykicks.set_approved_caller(address(0), true);

        vm.prank(owner);
        ykicks.set_approved_caller(_approvedCaller, true);
        assertTrue(ykicks.approved_callers(_approvedCaller), "test_setApprovedCaller: E0");
    }

    function test_removeApprovedCaller(address _approvedCaller) public {
        test_setApprovedCaller(_approvedCaller);

        vm.prank(owner);
        ykicks.set_approved_caller(_approvedCaller, false);
        assertFalse(ykicks.approved_callers(_approvedCaller), "test_removeApprovedCaller: E1");
    }

    function test_executeKickAuction(uint256 _amount, address _approvedCaller) public {
        vm.assume(_approvedCaller != address(this));
        vm.assume(_amount > 0);

        // set approved caller
        test_setApprovedCaller(_approvedCaller);

        // whitelist yKicks as a keeper for the strategy
        vm.prank(IStrategy(STRATEGY).management());
        IStrategy(STRATEGY).setKeeper(address(ykicks));

        // airdrop reward token to strategy
        airdrop(REWARD_TOKEN, STRATEGY, _amount);

        // kick auction
        bytes memory _data = abi.encodeWithSignature("kickAuction(address)", REWARD_TOKEN);
        vm.expectRevert("!caller");
        ykicks.execute(STRATEGY, _data);
        vm.prank(_approvedCaller);
        ykicks.execute(STRATEGY, _data);

        // make sure auction was kicked
        assertEq(IERC20(REWARD_TOKEN).balanceOf(STRATEGY), 0, "test_executeKickAuction: E0");
    }
}
