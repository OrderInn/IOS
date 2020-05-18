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


public class CameraViewController: UIViewController {
    
    @IBOutlet weak var resturountText: UILabel!
    @IBOutlet weak var QRView: UIView!
    @IBOutlet var popUpView: UIView!
    @IBOutlet var blureView: UIVisualEffectView!
    
    //MARK: Variables
    
    let session: AVCaptureSession = AVCaptureSession()
    let metadataOutput:AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    var succes: Bool = true
    var lable: UILabel!
    var image: UIImageView!
    
    //MARK: VC lifecycle methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        popUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.6)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        image.layer.removeAllAnimations()
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
        runSession()
        animateCorners()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: Camera setup session
    func sessionSetup(){
        guard let device = AVCaptureDevice.default(for: .video) else { errorAlert("No Camera detected"); return }
        
        session.sessionPreset = AVCaptureSession.Preset.high
        
        do { try session.addInput(AVCaptureDeviceInput(device: device))}
        catch { errorAlert(error.localizedDescription)}
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = self.view.layer.bounds
        view.layer.addSublayer(previewLayer)
        
        session.startRunning()
        
        //MARK: Check if camera video can be displayd
        if session.canAddOutput(metadataOutput){
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            errorAlert("Cannot display Camera")
        }
    }
    
    private func runSession(){
        if !session.isRunning{
            session.startRunning()
        }
    }
    
    //MARK: - POP window start
    @IBAction func Continue(_ sender: Any) {
    
        animateOut(desiredView: blureView)
        animateOut(desiredView: popUpView)
        
        
    }
    //MARK: - POP UP window end
    
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
}

//MARK: DelegateMetods
extension CameraViewController: AVCaptureMetadataOutputObjectsDelegate{
    
    //returns Metadata as String
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.first != nil{
            
            guard let readableObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {return}
            guard let outputString = readableObject.stringValue else{return}
            DispatchQueue.main.async {
                print(outputString)
                self.animatedIn(desiredView: self.popUpView)
            }
        }
        session.stopRunning()
        
    }
}


//Alert shown when qr scan fails
extension CameraViewController{
    
    public func errorAlert(_ message: String){
        
        let aLert = UIAlertController(title: "Try Again", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        aLert.addAction(action)
        self.present(aLert,animated: true)
        
    }
    
    //MARK: - Pop UP window config
    func animatedIn(desiredView: UIView){
        
        let background = self.view!
        
        //Pievienot view pie ekrāna
        
        background.addSubview(desiredView)
        
        //Uzliek view scaling uz 120%
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        desiredView.alpha = 0
        
        desiredView.center = background.center
        
        //Anemate effekta funkcija
        UIView.animate(withDuration: 0.3) {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            desiredView.alpha = 1
            
        }
    }
    func animateOut(desiredView: UIView){
        
        UIView.animate(withDuration: 0.3, animations: {
            
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
            desiredView.alpha = 0
            
        }, completion: { _ in
            
            desiredView.removeFromSuperview()
           
        })
        
        let newVC = storyboard?.instantiateViewController(withIdentifier: "MenuStoryboard")
        view.window?.rootViewController = newVC
        view.window?.makeKeyAndVisible()
        
    }
    
    
    
}
