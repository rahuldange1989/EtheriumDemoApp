//
//  SetupViewController.swift
//  EtheriumDemoApp
//
//  Created by Rahul Dange on 09/02/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import UIKit
import RxCocoa

class SetupViewController: UIViewController {

	@IBOutlet weak var privateKeyTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		self.doEventBinding()
	}
	
	// MARK: - Internal methods -
	func doEventBinding() {
		_ = self.privateKeyTextField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [unowned self] () in
			self.privateKeyTextField.resignFirstResponder()
			let privateKey = self.privateKeyTextField.text ?? ""
			if privateKey.count > 0 {
				self.moveToAccountVC(privateKey: privateKey)
			} else {
				Utility.showAlert(self, title: "Required", message: "Empty private key. Please enter valid private key.")
			}
		})
	}
	
	func moveToAccountVC(privateKey key: String) {
		guard let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as? AccountViewController else { return }
		accountVC.setPrivateKey(key: key)
		self.navigationController?.pushViewController(accountVC, animated: false)
	}
	
	// MARK: - Event Handler methods -
	
}
