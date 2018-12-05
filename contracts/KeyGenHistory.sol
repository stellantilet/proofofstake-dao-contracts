pragma solidity 0.4.25;

import "./interfaces/IReportingValidatorSet.sol";
import "./eternal-storage/EternalStorage.sol";
import "./libs/SafeMath.sol";


contract KeyGenHistory is EternalStorage {
    using SafeMath for uint256;

    // ================================================ Events ========================================================

    event PartWritten(
        address indexed validator,
        bytes part,
        uint256 indexed stakingEpoch,
        uint256 indexed changeRequestCount
    );

    event AckWritten(
        address indexed validator,
        bytes ack,
        uint256 indexed stakingEpoch,
        uint256 indexed changeRequestCount
    );

    // ============================================== Modifiers =======================================================

    modifier onlyOwner() {
        require(msg.sender == addressStorage[OWNER]);
        _;
    }

    modifier onlyValidator() {
        require(validatorSet().isValidator(msg.sender));
        _;
    }

    // =============================================== Setters ========================================================

    function setValidatorSetContract(IReportingValidatorSet _validatorSet) public onlyOwner {
        require(validatorSet() == address(0));
        require(_validatorSet != address(0));
        addressStorage[VALIDATOR_SET] = _validatorSet;
    }

    // Note: since this is non-system transaction, the calling validator
    // should have enough balance to call this function.
    function writePart(bytes _part) public onlyValidator {
        require(!validatorWrotePart(changeRequestCount, msg.sender));

        _setValidatorWrotePart(changeRequestCount, msg.sender);

        IReportingValidatorSet validatorSetContract = validatorSet();

        uint256 stakingEpoch = validatorSetContract.stakingEpoch();
        uint256 changeRequestCount = validatorSetContract.changeRequestCount();

        emit PartWritten(msg.sender, _part, stakingEpoch, changeRequestCount);
    }

    // Note: since this is non-system transaction, the calling validator
    // should have enough balance to call this function.
    function writeAck(bytes _ack) public onlyValidator {
        IReportingValidatorSet validatorSetContract = validatorSet();

        uint256 stakingEpoch = validatorSetContract.stakingEpoch();
        uint256 changeRequestCount = validatorSetContract.changeRequestCount();

        emit AckWritten(msg.sender, _ack, stakingEpoch, changeRequestCount);
    }

    // =============================================== Getters ========================================================

    function validatorSet() public view returns(IReportingValidatorSet) {
        return IReportingValidatorSet(addressStorage[VALIDATOR_SET]);
    }

    function validatorWrotePart(uint256 _changeRequestCount, address _validator) public view returns(bool) {
        return boolStorage[
            keccak256(abi.encode(VALIDATOR_WROTE_PART, _changeRequestCount, _validator))
        ];
    }

    // =============================================== Private ========================================================

    bytes32 internal constant OWNER = keccak256("owner");
    bytes32 internal constant VALIDATOR_SET = keccak256("validatorSet");
    bytes32 internal constant VALIDATOR_WROTE_PART = "validatorWrotePart";

    function _setValidatorWrotePart(uint256 _changeRequestCount, address _validator) internal {
        boolStorage[
            keccak256(abi.encode(VALIDATOR_WROTE_PART, _changeRequestCount, _validator))
        ] = true;
    }
}
