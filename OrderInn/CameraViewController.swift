//
//  CameraViewController.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 29/03/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase
import Firebase
import SDWebImage

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    let session = AVCaptureSession()
    let metadataOutput = AVCaptureMetadataOutput()
    @IBOutlet var vfxView: UIVisualEffectView!
    @IBOutlet var cutoutView: UIView!
    
    var readResult: QRURI?
    var restaurant: Restaurant?
    
    //MARK: VC lifecycle methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppearSetup()
        
        // Oddly enough, we need to do the graphics (blur mask) setup exactly here,
        // because apparently AutoLayout just runs at some weird time, and viewDidLayoutSubviews
        // gets called _before the whole tree_ has been laid out which just makes the frames all
        // weird like.
        //
        // But whatever.
        setupGraphics()
    }
    
    fileprivate func initialSetup(){
        self.navigationController?.navigationBar.isHidden = true
        sessionSetup()
    }
    
    fileprivate func viewDidAppearSetup(){
        outputCheck()
        runSession()
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    //MARK: Camera setup session
    public func sessionSetup(){
        guard let device = AVCaptureDevice.default(for: .video) else {
            errorAlert("No Camera detected") {
                self.handleQrRead(result: "orderinn://qr1/abcdef/ghi/1")
            }
            return
        }
        
        session.sessionPreset = AVCaptureSession.Preset.high
        
        do {
            try session.addInput(AVCaptureDeviceInput(device: device))
        } catch {
            errorAlert(error.localizedDescription)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = self.view.layer.bounds
        view.layer.insertSublayer(previewLayer, at: 0)

        session.startRunning()
    }
    
    func setupGraphics() {
        // https://stackoverflow.com/a/46253916
        let outerPath = UIBezierPath(rect: vfxView.bounds)
        let cutout = UIBezierPath(roundedRect: cutoutView.frame, cornerRadius: 25)
        outerPath.append(cutout)
        outerPath.usesEvenOddFillRule = true
        let mask = CAShapeLayer()
        mask.path = outerPath.cgPath
        mask.fillRule = .evenOdd
        vfxView.layer.mask = mask
    }

    //MARK: Check if camera video can be displayd
    func outputCheck(){
        if session.canAddOutput(metadataOutput){
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            if metadataOutput.availableMetadataObjectTypes.contains(.qr) {
                metadataOutput.metadataObjectTypes = [.qr]
            } else {
                // cannot scan QR codes even though camera is present?
                errorAlert("Sorry, something went wrong.")
            }
        } else {
            errorAlert("Cannot display Camera")
        }
    }
    
    private func runSession(){
        if !session.isRunning{
            session.startRunning()
        }
    }
    
    
    //MARK: - QR Scanner
//returns Metadata as String
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else { return }
        guard let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else { return }
        guard let result = object.stringValue else { return }
        session.stopRunning()
        handleQrRead(result: result)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let confirmationVC = segue.destination as? CameraConfirmationViewController {
            confirmationVC.cameraVC = self
            confirmationVC.restaurant = restaurant!
        } else if let menuVC = segue.destination as? CategoryViewController {
            menuVC.restaurant = restaurant!
            menuVC.tableId = readResult!.table
            menuVC.seatId = readResult!.seat
        }
        super.prepare(for: segue, sender: sender)
    }
    
    func errorAlert(_ message: String) {
        errorAlert(message, completion: noop)
    }
    func errorAlert(_ message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
        
    }
    
    // MARK: Handling of QR result
    func handleQrRead(result: String) {
        guard let uri = QRURI.parse(from: result) else {
            errorAlert("Sorry, that does not seem to be a valid OrderInn QR code.") {
                self.session.startRunning()
            }
            return
        }
        
        // TODO: show loading spinner
        self.readResult = uri
        Restaurant.tryLoad(withId: uri.restaurant, from: Firestore.firestore()) { maybeRestaurant in
            if let restaurant = maybeRestaurant {
                self.restaurant = restaurant
                self.performSegue(withIdentifier: "presentConfirmationView", sender: nil)
            } else {
                self.errorAlert("Sorry, that code doesn't seem to be valid.") {
                    self.session.startRunning()
                }
            }
        }
    }
    
    func resumeMediaSession() {
        session.startRunning()
    }
    
    func handleOrderRequested() {
        if session.isRunning {
            session.stopRunning()
        }
        performSegue(withIdentifier: "showOrderMenu", sender: nil)
    }
}

class CameraConfirmationViewController: UIViewController {
    @IBOutlet var restaurantBannerImage: UIImageView!
    @IBOutlet var restaurantTitleLabel: UILabel!
    
    var cameraVC: CameraViewController?
    var restaurant: Restaurant?

    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantTitleLabel.text = restaurant!.name
        
        restaurantBannerImage.alpha = 0.0
        restaurantBannerImage.sd_setImage(with: restaurant!.bannerImageUrl!) { _, _, _, _ in
            AnimationUtils.fadeIn(self.restaurantBannerImage)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraVC!.resumeMediaSession()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }

    @IBAction func handleOrderTapped(_ sender: Any) {
        navigationController?.popToViewController(cameraVC!, animated: true)
        cameraVC?.handleOrderRequested()
    }
}
