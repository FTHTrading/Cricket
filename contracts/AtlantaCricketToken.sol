// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AtlantaCricketToken
 * @notice Reference implementation for Atlanta Cricket Holdings tokenized preferred units.
 *         This is a simplified ERC-3643-style security token with issuer controls.
 *         Production deployment MUST use the full ERC-3643 (T-REX) framework with
 *         ONCHAINID identity verification and audited compliance modules.
 *
 * @dev NOT FOR PRODUCTION USE — reference architecture only.
 *      Must be professionally audited before any mainnet deployment.
 */

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

contract AtlantaCricketToken is ERC20, AccessControl, Pausable {

    // =========================================================================
    //                              ROLES
    // =========================================================================

    bytes32 public constant TRANSFER_AGENT_ROLE = keccak256("TRANSFER_AGENT_ROLE");
    bytes32 public constant COMPLIANCE_OFFICER_ROLE = keccak256("COMPLIANCE_OFFICER_ROLE");
    bytes32 public constant IDENTITY_REGISTRAR_ROLE = keccak256("IDENTITY_REGISTRAR_ROLE");

    // =========================================================================
    //                              STATE
    // =========================================================================

    /// @notice Treasury address for issuer operations
    address public issuerTreasury;

    /// @notice Transfer agent address
    address public transferAgent;

    /// @notice Frozen wallets cannot send or receive
    mapping(address => bool) private _frozen;

    /// @notice Verified investor wallets (KYC approved)
    mapping(address => bool) private _verified;

    /// @notice Mint date per wallet for lockup calculation
    mapping(address => uint256) private _mintDate;

    /// @notice Lockup duration in seconds (default 365 days)
    uint256 public lockupDuration = 365 days;

    // =========================================================================
    //                           CAP TABLE RECORDS
    // =========================================================================

    struct CapTableRecord {
        bytes32 hash;
        uint256 timestamp;
        uint256 blockNumber;
        address recorder;
    }

    CapTableRecord[] public capTableHashes;

    // =========================================================================
    //                        DISTRIBUTION RECORDS
    // =========================================================================

    struct DistributionRecord {
        uint256 distributionId;
        uint256 periodEnd;
        uint256 totalAmount;
        uint256 perUnitAmount;
        uint256 recordDate;
        uint256 paymentDate;
        bytes32 ipfsHash;
        uint256 navPerUnit;
    }

    mapping(uint256 => DistributionRecord) public distributions;

    // =========================================================================
    //                              EVENTS
    // =========================================================================

    event InvestorMinted(address indexed investor, uint256 amount, uint256 timestamp);
    event InvestorRedeemed(address indexed investor, uint256 amount, uint256 timestamp);
    event WalletFrozen(address indexed wallet, string reason, uint256 timestamp);
    event WalletUnfrozen(address indexed wallet, uint256 timestamp);
    event ForcedTransfer(
        address indexed from,
        address indexed to,
        uint256 amount,
        string reason,
        uint256 timestamp
    );
    event TransferAgentUpdated(address indexed agent, uint256 timestamp);
    event CapTableSynced(bytes32 indexed hash, uint256 timestamp, uint256 blockNumber);
    event DistributionRecorded(
        uint256 indexed distributionId,
        uint256 totalAmount,
        uint256 perUnitAmount,
        uint256 navPerUnit
    );
    event DistributionPaymentConfirmed(uint256 indexed distributionId, uint256 paymentDate);
    event InvestorVerified(address indexed investor, uint256 timestamp);
    event InvestorUnverified(address indexed investor, uint256 timestamp);
    event LockupDurationUpdated(uint256 oldDuration, uint256 newDuration);

    // =========================================================================
    //                            CONSTRUCTOR
    // =========================================================================

    constructor(
        string memory name_,
        string memory symbol_,
        address _treasury,
        address _transferAgent
    ) ERC20(name_, symbol_) {
        require(_treasury != address(0), "Invalid treasury");
        require(_transferAgent != address(0), "Invalid transfer agent");

        issuerTreasury = _treasury;
        transferAgent = _transferAgent;

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(TRANSFER_AGENT_ROLE, _transferAgent);
        _grantRole(COMPLIANCE_OFFICER_ROLE, msg.sender);
        _grantRole(IDENTITY_REGISTRAR_ROLE, msg.sender);
    }

    // =========================================================================
    //                         DECIMALS OVERRIDE
    // =========================================================================

    /// @notice Preferred units are whole units, no fractional
    function decimals() public pure override returns (uint8) {
        return 0;
    }

    // =========================================================================
    //                         IDENTITY MANAGEMENT
    // =========================================================================

    /// @notice Add a verified investor wallet (after KYC/AML/accreditation)
    function verifyInvestor(address _investor) external onlyRole(IDENTITY_REGISTRAR_ROLE) {
        require(_investor != address(0), "Invalid address");
        _verified[_investor] = true;
        emit InvestorVerified(_investor, block.timestamp);
    }

    /// @notice Remove verification from a wallet
    function unverifyInvestor(address _investor) external onlyRole(IDENTITY_REGISTRAR_ROLE) {
        _verified[_investor] = false;
        emit InvestorUnverified(_investor, block.timestamp);
    }

    /// @notice Check if a wallet is verified
    function isVerified(address _wallet) external view returns (bool) {
        return _verified[_wallet];
    }

    /// @notice Check if a wallet is frozen
    function isFrozen(address _wallet) external view returns (bool) {
        return _frozen[_wallet];
    }

    // =========================================================================
    //                             MINTING
    // =========================================================================

    /// @notice Mint tokens to a verified investor after subscription clears
    function mintToApprovedInvestor(
        address _investor,
        uint256 _amount
    ) external onlyRole(TRANSFER_AGENT_ROLE) whenNotPaused {
        require(_verified[_investor], "Investor not verified");
        require(_amount > 0, "Amount must be positive");

        if (_mintDate[_investor] == 0) {
            _mintDate[_investor] = block.timestamp;
        }

        _mint(_investor, _amount);
        emit InvestorMinted(_investor, _amount, block.timestamp);
    }

    // =========================================================================
    //                            REDEMPTION
    // =========================================================================

    /// @notice Burn tokens on issuer redemption or investor exit
    function burnOnRedemption(
        address _investor,
        uint256 _amount
    ) external onlyRole(TRANSFER_AGENT_ROLE) {
        require(balanceOf(_investor) >= _amount, "Insufficient balance");
        _burn(_investor, _amount);
        emit InvestorRedeemed(_investor, _amount, block.timestamp);
    }

    // =========================================================================
    //                         COMPLIANCE CONTROLS
    // =========================================================================

    /// @notice Freeze a wallet for compliance reasons
    function freezeWallet(
        address _wallet,
        string calldata _reason
    ) external onlyRole(COMPLIANCE_OFFICER_ROLE) {
        _frozen[_wallet] = true;
        emit WalletFrozen(_wallet, _reason, block.timestamp);
    }

    /// @notice Unfreeze a previously frozen wallet
    function unfreezeWallet(
        address _wallet
    ) external onlyRole(COMPLIANCE_OFFICER_ROLE) {
        _frozen[_wallet] = false;
        emit WalletUnfrozen(_wallet, block.timestamp);
    }

    /// @notice Force transfer tokens for compliance, legal, or regulatory reasons
    function forceTransfer(
        address _from,
        address _to,
        uint256 _amount,
        string calldata _reason
    ) external onlyRole(COMPLIANCE_OFFICER_ROLE) {
        require(balanceOf(_from) >= _amount, "Insufficient balance");
        require(
            _verified[_to] || _to == issuerTreasury,
            "Destination not verified"
        );
        _transfer(_from, _to, _amount);
        emit ForcedTransfer(_from, _to, _amount, _reason, block.timestamp);
    }

    /// @notice Pause all transfers (emergency)
    function pause() external onlyRole(COMPLIANCE_OFFICER_ROLE) {
        _pause();
    }

    /// @notice Unpause transfers
    function unpause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    // =========================================================================
    //                        TRANSFER RESTRICTIONS
    // =========================================================================

    /// @notice Override transfer to enforce compliance rules
    function _update(
        address from,
        address to,
        uint256 value
    ) internal override whenNotPaused {
        // Allow minting (from == address(0)) and burning (to == address(0))
        if (from != address(0) && to != address(0)) {
            // Not a mint or burn — enforce restrictions
            require(!_frozen[from], "Sender wallet is frozen");
            require(!_frozen[to], "Receiver wallet is frozen");
            require(_verified[to], "Receiver not verified");
            require(
                block.timestamp >= _mintDate[from] + lockupDuration,
                "Lockup period has not expired"
            );
        }

        super._update(from, to, value);
    }

    // =========================================================================
    //                       TRANSFER AGENT MANAGEMENT
    // =========================================================================

    /// @notice Update the transfer agent
    function setTransferAgent(
        address _agent
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(_agent != address(0), "Invalid address");

        // Revoke old role
        if (transferAgent != address(0)) {
            _revokeRole(TRANSFER_AGENT_ROLE, transferAgent);
        }

        transferAgent = _agent;
        _grantRole(TRANSFER_AGENT_ROLE, _agent);
        emit TransferAgentUpdated(_agent, block.timestamp);
    }

    /// @notice Update the lockup duration
    function setLockupDuration(
        uint256 _duration
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        uint256 oldDuration = lockupDuration;
        lockupDuration = _duration;
        emit LockupDurationUpdated(oldDuration, _duration);
    }

    // =========================================================================
    //                        CAP TABLE SYNC
    // =========================================================================

    /// @notice Record a hash of the offchain cap table for auditability
    function syncCapTableHash(
        bytes32 _hash,
        uint256 _timestamp
    ) external onlyRole(TRANSFER_AGENT_ROLE) {
        capTableHashes.push(CapTableRecord({
            hash: _hash,
            timestamp: _timestamp,
            blockNumber: block.number,
            recorder: msg.sender
        }));
        emit CapTableSynced(_hash, _timestamp, block.number);
    }

    /// @notice Get the number of cap table records
    function getCapTableRecordCount() external view returns (uint256) {
        return capTableHashes.length;
    }

    // =========================================================================
    //                       DISTRIBUTION RECORDS
    // =========================================================================

    /// @notice Record a distribution event hash onchain
    function recordDistributionHash(
        uint256 _distributionId,
        uint256 _periodEnd,
        uint256 _totalAmount,
        uint256 _perUnitAmount,
        bytes32 _ipfsHash,
        uint256 _navPerUnit
    ) external onlyRole(TRANSFER_AGENT_ROLE) {
        require(distributions[_distributionId].recordDate == 0, "Distribution already recorded");

        distributions[_distributionId] = DistributionRecord({
            distributionId: _distributionId,
            periodEnd: _periodEnd,
            totalAmount: _totalAmount,
            perUnitAmount: _perUnitAmount,
            recordDate: block.timestamp,
            paymentDate: 0,
            ipfsHash: _ipfsHash,
            navPerUnit: _navPerUnit
        });

        emit DistributionRecorded(
            _distributionId,
            _totalAmount,
            _perUnitAmount,
            _navPerUnit
        );
    }

    /// @notice Confirm that a distribution payment was executed
    function confirmDistributionPayment(
        uint256 _distributionId
    ) external onlyRole(TRANSFER_AGENT_ROLE) {
        require(distributions[_distributionId].recordDate != 0, "Distribution not found");
        require(distributions[_distributionId].paymentDate == 0, "Already confirmed");

        distributions[_distributionId].paymentDate = block.timestamp;
        emit DistributionPaymentConfirmed(_distributionId, block.timestamp);
    }

    // =========================================================================
    //                           VIEW HELPERS
    // =========================================================================

    /// @notice Get the mint date for a wallet (for lockup calculation)
    function getMintDate(address _wallet) external view returns (uint256) {
        return _mintDate[_wallet];
    }

    /// @notice Check if a wallet's lockup has expired
    function isLockupExpired(address _wallet) external view returns (bool) {
        if (_mintDate[_wallet] == 0) return false;
        return block.timestamp >= _mintDate[_wallet] + lockupDuration;
    }

    /// @notice Get investor status summary
    function getInvestorStatus(address _wallet) external view returns (
        bool verified,
        bool frozen,
        uint256 balance,
        uint256 mintDate,
        bool lockupExpired
    ) {
        verified = _verified[_wallet];
        frozen = _frozen[_wallet];
        balance = balanceOf(_wallet);
        mintDate = _mintDate[_wallet];
        lockupExpired = mintDate > 0 && block.timestamp >= mintDate + lockupDuration;
    }
}
