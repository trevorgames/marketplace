// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC7572 {
    event ContractURIUpdated();

    /**
     * @dev Returns the contract-level metadata.
     */
    function contractURI() external view returns (string memory);
}
