//
//  EthereumHelper.swift
//  EtheriumDemoApp
//
//  Created by Rahul Dange on 11/02/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import Foundation
import web3swift
import BigInt

// -- shared instance
private let _sharedInstance = EthereumHelper.init()

class EthereumHelper {
	var web3RinkebyObj: web3?
	var keystore: EthereumKeystoreV3?
	let password: String = "EtheriumDemoApp"
	
	class var sharedInstance: EthereumHelper {
		return _sharedInstance
	}
	
	func initialize() {
		web3RinkebyObj = Web3.InfuraRinkebyWeb3()
	}
	
	func createKeyStore(fromPrivateKey privateKey: String) {
		let formattedKey = privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
		guard let dataKey = Data.fromHex(formattedKey) else {
			self.keystore = nil
			return
		}
		do {
			self.keystore = try EthereumKeystoreV3(privateKey: dataKey, password: password)
		} catch {
			print(error.localizedDescription)
		}
	}
	
	func getAccountAddress() -> EthereumAddress? {
		guard let ks = self.keystore else { return nil }
		return ks.addresses?.first
	}
	
	func getAccountBalance() -> String {
		guard let reqAddress = self.getAccountAddress() else { return "" }
		do {
			let rinkebyBalance = try self.web3RinkebyObj?.eth.getBalance(address: reqAddress)
			let divider: BigUInt = 1000000000000000000
			return "\((rinkebyBalance ?? 0) / divider) Ether"
		} catch {
			print(error.localizedDescription)
		}
		return ""
	}
	
	func getSignedMessage(from msg: String) -> String {
		do {
			guard let reqAddress = self.getAccountAddress() else { return "" }
			guard let reqKeystore = self.keystore else { return "" }
			
			let data = msg.data(using: .utf8)
			var signMsg = try Web3Signer.signPersonalMessage(data!, keystore: reqKeystore, account: reqAddress, password: password)?.toHexString()
			if !(signMsg?.hasPrefix("0x"))! {
				signMsg = "0x" + signMsg!
			}
			return signMsg ?? ""
		} catch {
			print(error.localizedDescription)
		}
		return ""
	}
	
	func verifySignedMsg(message msg: String, signdMessage signMsg: String) -> Bool {
		let stringReturn = self.web3RinkebyObj?.browserFunctions.personalECRecover(msg.toHexEncodedString(), signature: signMsg)
		guard let reqAddress = self.getAccountAddress() else { return false }
		return (stringReturn ?? "").uppercased() == reqAddress.address.uppercased()
	}
}
