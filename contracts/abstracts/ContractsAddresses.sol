pragma solidity 0.5.2;


/// @dev This contract is just for having all the contracts addresses in one place.
/// The contracts which need the addresses are inherited from this one.
contract ContractsAddresses {
    address internal constant VALIDATOR_SET_CONTRACT = address(0x1000000000000000000000000000000000000001);
    address internal constant STAKING_CONTRACT = address(0x1100000000000000000000000000000000000001);
    address internal constant BLOCK_REWARD_CONTRACT = address(0x2000000000000000000000000000000000000001);
    address internal constant RANDOM_CONTRACT = address(0x3000000000000000000000000000000000000001);
    address internal constant PERMISSION_CONTRACT = address(0x4000000000000000000000000000000000000001);
    address internal constant CERTIFIER_CONTRACT = address(0x5000000000000000000000000000000000000001);
}
