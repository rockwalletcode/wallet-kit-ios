//
//  WKAddress.swift
//  WalletKit
//
//  Created by Ed Gamble on 6/7/19.
//  Copyright © 2019 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//  See the CONTRIBUTORS file at the project root for a list of contributors.
//
import WalletKitCore

///
/// An Address for transferring an amount.  Addresses are network specific.
///
public final class Address: Equatable, CustomStringConvertible {
    let core: WKAddress

    internal init (core: WKAddress, take: Bool) {
        self.core = take ? wkAddressTake(core) : core
    }

    internal convenience init (core: WKAddress) {
        self.init (core: core, take: true)
    }

    public private(set) lazy var description: String = {
        return asUTF8String (wkAddressAsString (core), true)
    }()

    ///
    /// Create an Addres from `string` and `network`.  The provided `string` must be valid for
    /// the provided `network` - that is, an ETH address (as a string) differs from a BTC address
    /// and a BTC mainnet address differs from a BTC testnet address.  If `string` is not
    /// appropriate for `network`, then `nil` is returned.
    ///
    /// This function is typically used to convert User input - of a 'target address' as a string -
    /// into an Address.
    ///
    /// - Parameters:
    ///   - string: A string representing a crypto address
    ///   - network: The network for which the string is value
    ///
    /// - Returns: An address or nil if `string` is invalide for `network`
    ///
    public static func create (string: String, network: Network) -> Address? {
        return wkNetworkCreateAddress (network.core, string)
            .map { Address (core: $0, take: false) }
    }
    
    public static func createLegacy (string: String, network: Network) -> Address? {
        var address : Address? = nil
        if network.name == "Bitcoin Cash" && (string.first == "1" || string.first == "3") {
            address = wkNetworkCreateAddressLegacy (network.core, string)
                .map { Address (core: $0, take: false) }
        }
        return address
    }

    deinit {
        wkAddressGive (core)
    }

    public static func == (lhs: Address, rhs: Address) -> Bool {
        return WK_TRUE == wkAddressIsIdentical (lhs.core, rhs.core)
    }
}

///
/// An AddressScheme determines the from of wallet-generated address.  For example, a Bitcoin wallet
/// can have a 'Segwit/BECH32' address scheme or a 'Legacy' address scheme.  The address, which is
/// ultimately a sequence of bytes, gets formatted as a string based on the scheme.
///
/// The WalletManager holds an array of AddressSchemes as well as the preferred AddressScheme.
///
public enum AddressScheme: Equatable, CustomStringConvertible {
    case btcLegacy
    case btcSegwit
    case native


    internal init (core: WKAddressScheme) {
        switch core {
        case WK_ADDRESS_SCHEME_BTC_LEGACY:  self = .btcLegacy
        case WK_ADDRESS_SCHEME_BTC_SEGWIT:  self = .btcSegwit
        case WK_ADDRESS_SCHEME_NATIVE:      self = .native
        default: self = .native;  preconditionFailure()
        }
    }

    internal var core: WKAddressScheme {
        switch self {
        case .btcLegacy:  return WK_ADDRESS_SCHEME_BTC_LEGACY
        case .btcSegwit:  return WK_ADDRESS_SCHEME_BTC_SEGWIT
        case .native:     return WK_ADDRESS_SCHEME_NATIVE
        }
    }

    public var description: String {
        switch self {
        case .btcLegacy: return "BTC Legacy"
        case .btcSegwit: return "BTC Segwit"
        case .native:   return "Native"
        }
    }

    public static let all = [AddressScheme.btcLegacy,
                             AddressScheme.btcSegwit,
                             AddressScheme.native]
}
