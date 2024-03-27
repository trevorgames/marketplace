// SPDX-License-Identifier: MIT
pragma solidity >=0.8.23 <0.9.0;

import { TransparentUpgradeableProxy } from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import { TrevorMarketplace } from "src/TrevorMarketPlace.sol";
import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
    function run()
        public
        broadcast
        returns (TransparentUpgradeableProxy marketplaceProxy, TrevorMarketplace marketplace)
    {
        marketplace = new TrevorMarketplace();

        uint256 fee = vm.envOr({ name: "FEE", defaultValue: uint256(500) });
        address feeRecipient = vm.envOr({ name: "FEE_RECIPIENT", defaultValue: address(0) });
        address paymentToken = vm.envOr({ name: "PAYMENT_TOKEN", defaultValue: address(0) });

        if (feeRecipient == address(0)) {
            // TODO
            (feeRecipient,) = deriveRememberKey({ mnemonic: mnemonic, index: 1 });
        }

        bytes4 selector = TrevorMarketplace.initialize.selector;

        bytes memory data = abi.encodeWithSelector(selector, fee, feeRecipient, paymentToken);

        marketplaceProxy = new TransparentUpgradeableProxy(address(marketplace), broadcaster, data);
    }
}
