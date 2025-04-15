# @version 0.4.1

"""
@title yKicks Executor
@license MIT
@author yearn.finance (johnnyonline)
@notice ykicks.vy is used by the yKicks bot to kick auctions
"""

import ownable_2step as ownable


# ============================================================================================
# Modules
# ============================================================================================


initializes: ownable
exports: (
    ownable.owner,
    ownable.pending_owner,
    ownable.transfer_ownership,
    ownable.accept_ownership,
)


# ============================================================================================
# Events
# ============================================================================================


event ApprovedCallerSet:
    caller: indexed(address)
    approved: bool


# ============================================================================================
# Storage
# ============================================================================================


approved_callers: public(HashMap[address, bool])


# ============================================================================================
# Constructor
# ============================================================================================


@deploy
def __init__(owner: address):
    """
    @notice Initialize the contract
    @param owner Address of the owner
    """
    ownable.__init__(owner)


# ============================================================================================
# Owner functions
# ============================================================================================


@external
def set_approved_caller(caller: address, approved: bool):
    """
    @notice Set the approved caller
    @param caller Address of the caller
    @param approved Boolean indicating if the caller is approved
    """
    ownable._check_owner()
    assert caller != empty(address), "!caller"
    self.approved_callers[caller] = approved
    log ApprovedCallerSet(caller=caller, approved=approved)


# ============================================================================================
# Mutative functions
# ============================================================================================


@external
def execute(
    to: address,
    data: Bytes[4096],
) -> Bytes[4096]:
    """
    @notice Execute a call to a contract
    @dev Reverts on failure
    @param to Address of the contract to call
    @param data Data to send with the call
    @return response Data returned from the call
    """
    assert self.approved_callers[msg.sender], "!caller"
    return raw_call(to, data, max_outsize=4096)
