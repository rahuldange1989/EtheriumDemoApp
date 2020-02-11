//
//  AccountViewController.swift
//  EtheriumDemoApp
//
//  Created by Rahul Dange on 11/02/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import UIKit
import web3swift

class AccountViewController: UIViewController {

	@IBOutlet weak var accountAddressLabel: UILabel!
	@IBOutlet weak var balanceAddressLabel: UILabel!
	
	fileprivate var privateKey: String?
	
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		self.getAccountAddressAndBalance()
    }
	
	// MARK: - Internal Methods -
	func setPrivateKey(key: String) {
		self.privateKey = key
	}
	
	func getAccountAddressAndBalance() {
		Utility.showActivityIndicatory((self.navigationController?.view)!)
		EthereumHelper.sharedInstance.createKeyStore(fromPrivateKey: self.privateKey!)
		let accountAddress = EthereumHelper.sharedInstance.getAccountAddress()
		if accountAddress == nil {
			self.view.isUserInteractionEnabled = false
			Utility.hideActivityIndicatory((self.navigationController?.view)!)
			Utility.showAlert(self.navigationController, title: "Invalid", message: "Invalid private key.")
		} else {
			self.accountAddressLabel.text = accountAddress?.address
			// -- Doing below code on bakcground queue, because 'try self.web3RinkebyObj?.eth.getBalance(address: reqAddress)' this is interanlly calling wait() method
			DispatchQueue.global().async {
				let balance = EthereumHelper.sharedInstance.getAccountBalance()
				DispatchQueue.main.async {
					self.balanceAddressLabel.text = balance
					Utility.hideActivityIndicatory((self.navigationController?.view)!)
				}
			}
		}
	}
}
