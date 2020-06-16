//
//  OnBordingViewController.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 16/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import Lottie

struct Slide{
    let title: String
    let animationName: String
    let buttonCollor: UIColor
    let buttonTitle: String
    
    static let collection: [Slide] = [
        .init(title: "Finde Qr code to scann", animationName: "", buttonCollor: .green, buttonTitle: "Next"),
        .init(title: "This is nice", animationName: "", buttonCollor: .systemGray, buttonTitle: "Next"),
        .init(title: "Finish", animationName: "", buttonCollor: .systemGray, buttonTitle: "Get started")
    ]
}

class OnBordingViewController: UIViewController {
    
    
    @IBOutlet weak var onbordCollection: UICollectionView!
    
    private let slides: [Slide] = Slide.collection
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        // Do any additional setup after loading the view.
    }
    
    private func setupCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        onbordCollection.collectionViewLayout = layout
        onbordCollection.contentInsetAdjustmentBehavior = .never
        onbordCollection.delegate = self
        onbordCollection.dataSource = self
        onbordCollection.isPagingEnabled = true
    }
   

}

extension OnBordingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = onbordCollection.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! OnBordingCell
        let slide = slides[indexPath.row]
        cell.configure(with: slide)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = onbordCollection.bounds.width
        let itemHeight = onbordCollection.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    
}

class OnBordingCell: UICollectionViewCell{
    
    @IBOutlet weak var animatinView: AnimationView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    func configure(with slide: Slide){
        infoLabel.text = slide.title
        startButton.backgroundColor = slide.buttonCollor
        startButton.setTitle(slide.buttonTitle, for: .normal)
        
        let animation = Animation.named("lottieQrAnim")
        animatinView.animation = animation
        animatinView.loopMode = .loop
        if !animatinView.isAnimationPlaying{
            animatinView.play()
        }
    }
    
    @IBAction func sratrButtonTapped(_ sender: Any?){
        
    }
    
    
}
