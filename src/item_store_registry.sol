pragma solidity ^0.4.18;

import "./item_store_interface.sol";


/**
 * @title ItemStoreRegistry
 * @author Jonathan Brown <jbrown@mix-blockchain.org>
 * @dev Contract that every ItemStore implementation must register with.
 */
contract ItemStoreRegistry {

    /**
     * @dev Mapping of contract id to contract addresses.
     */
    mapping (bytes32 => ItemStoreInterface) contracts;

    /**
     * @dev A ItemStore contract has been registered.
     * @param contractId Id of the contract.
     * @param contractAddress Address of the contract.
     */
    event Register(bytes32 indexed contractId, ItemStoreInterface indexed contractAddress);

    /**
     * @dev Throw if contract is registered.
     * @param contractId Id of the contract.
     */
    modifier isNotRegistered(bytes32 contractId) {
        require (address(contracts[contractId]) == 0);
        _;
    }

    /**
     * @dev Throw if contract is not registered.
     * @param contractId Id of the contract.
     */
    modifier isRegistered(bytes32 contractId) {
        require (address(contracts[contractId]) != 0);
        _;
    }

    /**
     * @dev Register the calling ItemStore contract.
     * @param contractId Id of the ItemStore contract.
     */
    function register(bytes32 contractId) external isNotRegistered(contractId) {
        // Record the calling contract address.
        contracts[contractId] = ItemStoreInterface(msg.sender);
        // Log the registration.
        Register(contractId, ItemStoreInterface(msg.sender));
    }

    /**
     * @dev Get a ItemStore contract.
     * @param contractId Id of the contract.
     * @return The ItemStore contract.
     */
    function getItemStore(bytes32 contractId) external view isRegistered(contractId) returns (ItemStoreInterface) {
        return contracts[contractId];
    }

}
