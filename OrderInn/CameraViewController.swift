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
    @IBOutlet weak var QRView: UIView!
    @IBOutlet weak var QRlabel: UILabel!
    
    //MARK: Variables
    let session: AVCaptureSession = AVCaptureSession()
    let metadataOutput:AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    var succes: Bool = true
    var lable: UILabel!
    var image: UIImageView!

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
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        image.layer.removeAllAnimations()
    }
    
    fileprivate func initialSetup(){
        self.navigationController?.navigationBar.isHidden = true
        sessionSetup()
        addBlure()
        addCorners()
    }
    
    fileprivate func viewDidAppearSetup(){
        outputCheck()
        runSession()
        animateCorners()
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    //MARK: Camera setup session
    public func sessionSetup(){
        guard let device = AVCaptureDevice.default(for: .video) else {
            errorAlert("No Camera detected")
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
        view.layer.addSublayer(previewLayer)
        
        session.startRunning()
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
                // TODO: this is for testing please remove later
                let second = DispatchTime.now().advanced(by: .seconds(1))
                DispatchQueue.main.asyncAfter(deadline: second) {
                    self.handleQrRead(result: "orderinn://qr1/abcdef/ghi/1")
                }
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
    
    //MARK: UI setup
    func addBlure(){
        //BlureView
        let blur = UIBlurEffect(style: .regular)
        let blureView = UIVisualEffectView(effect: blur)
        blureView.frame = self.view.bounds
        blureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let scanerLayer = CAShapeLayer()
        let maskSize = getMaskSize()
        let outherPath = UIBezierPath(roundedRect: maskSize, cornerRadius: 30)
        
        //MARK: Add Mask
        let superLayerPath = UIBezierPath(rect: blureView.frame)
        outherPath.append(superLayerPath)
        scanerLayer.path = outherPath.cgPath
        scanerLayer.fillRule = .evenOdd
        
        //Final blure layer
        view.addSubview(blureView)
        blureView.layer.mask = scanerLayer
    }
    
    //Masc size to screen size
    private func getMaskSize() -> CGRect{
        let viewWidth = view.frame.width
        let rectWidth = viewWidth - 114
        let halfWidth = rectWidth/2
        let x = view.center.x - halfWidth
        let y = view.center.y - halfWidth
        return CGRect(x: x, y: y, width: rectWidth, height: rectWidth)
    }
    
    //MARK: Add white corners
    func addCorners(){
        let maskSize = getMaskSize().height
        let imageWidth = maskSize * 1.0866666667
        let halfWidth = (imageWidth) / 2
        let x = view.center.x - halfWidth
        let y = view.center.y - halfWidth
        let imageFrame = CGRect(x: x, y: y, width: imageWidth, height: imageWidth)
        
        image = UIImageView()
        image.frame = imageFrame
        image.image = UIImage(named: "Corners")
        print(imageFrame)
        view.addSubview(image)
    }
    
    //MARK: Add animation to Corners
    func animateCorners(){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.1
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        image.layer.add(animation, forKey: "animate")
    }
    //MARK: - End of UI setUp
    
    
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
            confirmationVC.restaurant = restaurant!
        } else if let navVC = segue.destination as? UINavigationController,
                let menuVC = navVC.topViewController as? MenuViewController {
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
    
    // MARK: Handle restaurant confirmation
    @IBAction func confirmationUnwind(unwindSegue: UIStoryboardSegue) {
        // TODO[pn] this is really crude and should be refactored but I don't currently see a cleaner way of replacing the navigation VC
        if let window = UIApplication.shared.keyWindow {
            NSLog("OrderInn: CameraVC: Unwind received and root window found")
            let storyboard = UIStoryboard(name: "OrderFlow", bundle: nil)
            guard let root = storyboard.instantiateInitialViewController() as? UINavigationController else { return }
            guard let menuVC = root.topViewController as? MenuViewController else { return }
            menuVC.restaurant = restaurant
            menuVC.tableId = readResult!.table
            menuVC.seatId = readResult!.seat
            window.rootViewController = root
        }
//        performSegue(withIdentifier: "switchToOrderFlow", sender: nil)
    }
}

class CameraConfirmationViewController: UIViewController {
    @IBOutlet var restaurantBannerImage: UIImageView!
    @IBOutlet var restaurantTitleLabel: UILabel!
    
    var restaurant: Restaurant?

    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantTitleLabel.text = restaurant!.name
        
        restaurantBannerImage.alpha = 0.0
        restaurantBannerImage.sd_setImage(with: restaurant!.bannerImageUrl!) { _, _, _, _ in
            AnimationUtils.fadeIn(self.restaurantBannerImage)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
}
