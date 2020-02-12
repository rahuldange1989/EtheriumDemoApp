//
//  SignatureViewController.swift
//  EtheriumDemoApp
//
//  Created by Rahul Dange on 12/02/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import UIKit

class SignatureViewController: UIViewController {

	@IBOutlet weak var messageLabel: UILabel!
	@IBOutlet weak var qrImageView: UIImageView!
	
	fileprivate var message: String = ""
	
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		self.messageLabel.text = "Message: \"\( self.message)\""
		self.generateQRCode()
    }
	
	// MARK: - Internal methods -
	func setMessage(msg: String) {
		self.message = msg
	}
	
	func generateQRCode() {
		// -- generate signed message from message
		let signedMessage = EthereumHelper.sharedInstance.getSignedMessage(from: self.message)
		
		// -- generate QR code from signedMessage
		let signedData = signedMessage.data(using: String.Encoding.ascii)
		if let filter = CIFilter(name: "CIQRCodeGenerator") {
			filter.setValue(signedData, forKey: "inputMessage")
			let transform = CGAffineTransform(scaleX: 3, y: 3)

			if let output = filter.outputImage?.transformed(by: transform) {
				let image = UIImage(ciImage: output)
				self.qrImageView.image = image
			}
		}
	}
}
