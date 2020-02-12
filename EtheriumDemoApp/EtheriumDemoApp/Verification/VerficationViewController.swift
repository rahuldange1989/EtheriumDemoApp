//
//  VerficationViewController.swift
//  EtheriumDemoApp
//
//  Created by Rahul Dange on 11/02/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import UIKit

class VerficationViewController: UIViewController {

	@IBOutlet weak var messageTextField: UITextField!
	@IBOutlet weak var verifyMsgBtn: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		self.doEventBinding()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.messageTextField.resignFirstResponder()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showVerifyScanQR" {
			guard let destinationVC = segue.destination as? QRScanViewController else { return }
			destinationVC.setMessage(msg: self.messageTextField.text ?? "")
		}
	}
	
	// MARK: - Internal methods -
	func doEventBinding() {
		_ = self.messageTextField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [unowned self] () in
			self.messageTextField.resignFirstResponder()
		})
		_ = self.messageTextField.rx.controlEvent(.editingChanged).subscribe(onNext: { [unowned self] () in
			let shouldEnable = self.messageTextField.text!.count > 0
			self.verifyMsgBtn.isEnabled = shouldEnable
			self.verifyMsgBtn.backgroundColor = shouldEnable ? UIColor.darkGray : UIColor.lightGray
		})
	}
}
