//
//  QRScanViewController.swift
//  EtheriumDemoApp
//
//  Created by Rahul Dange on 12/02/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import UIKit
import AVFoundation

class QRScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

	fileprivate var captureSession: AVCaptureSession!
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
	fileprivate var message: String = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		view.backgroundColor = UIColor.lightGray
		self.setupForQRScanning()
	}
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
	
	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
	
	// MARK: - Internal methods -
	func setupForQRScanning() {
		captureSession = AVCaptureSession()
		
		guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
			failed()
			return
		}
		
        let videoInput: AVCaptureDeviceInput
		do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
		
		if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
		
		let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
		
		previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
	}
	
	func setMessage(msg: String) {
		self.message = msg
	}
	
	func failed() {
		captureSession = nil
		Utility.showAlert(self.navigationController, title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.")
    }
	
	func found(code: String) {
		let status = EthereumHelper.sharedInstance.verifySignedMsg(message: self.message, signdMessage: code)
		DispatchQueue.main.asyncAfter(deadline:.now() + .milliseconds(500) , execute: {
			Utility.showAlert(self, title: "Status", message: "Signature is \(status ? "Valid" : "not Valid").")
		})
	}
	
	// MARK: - AVCaptureMetadataOutputObjectsDelegate methods -
	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }
}
