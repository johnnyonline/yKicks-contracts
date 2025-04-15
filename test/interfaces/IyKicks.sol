// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {IOwnable2Step} from "./IOwnable2Step.sol";

interface IyKicks is IOwnable2Step {
    function approved_callers(address caller) external view returns (bool);
    function set_approved_caller(address caller, bool approved) external;
    function execute(address to, bytes calldata data) external returns (bytes memory);
}
