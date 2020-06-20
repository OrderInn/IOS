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
        .init(title: "Find our Partner Restaurant", animationName: "findPartner", buttonCollor: .systemTeal, buttonTitle: "How we work"),
        .init(title: "Scan our Qr code witch is located on table", animationName: "lottieQrAnim", buttonCollor: .systemGray, buttonTitle: "Next"),
        .init(title: "Select any food or drinks you like", animationName: "menuList", buttonCollor: .systemTeal, buttonTitle: "Next"),
        .init(title: "Send your order", animationName: "orderSent", buttonCollor: .systemTeal, buttonTitle: "Next"),
        .init(title: "Relax and wait your order, because it is on its way!", animationName: "relaxAnim", buttonCollor: .systemTeal, buttonTitle: "Next"),
        .init(title: "And there you go, enjoy your order!", animationName: "foodServed", buttonCollor: .systemTeal, buttonTitle: "Start Ordering")
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
   
    private func handleActionButton(at indexPath: IndexPath){
        if indexPath.item == slides.count - 1{
            goToMainApp()
        }else{
            let nextItem = indexPath.item + 1
            let nextIndexPath = IndexPath(item: nextItem, section: 0)
            onbordCollection.scrollToItem(at: nextIndexPath, at: .top, animated: true)
        }
    }
    
    private func goToMainApp(){
        let mainAppVC = UIStoryboard(name: "AuthFlow", bundle: nil).instantiateViewController(identifier: "AuthOptions")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
        let sceneDelegate = windowScene.delegate as? SceneDelegate,
            let window = sceneDelegate.window{
            window.rootViewController = mainAppVC
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
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
        cell.actionButtonDidTap = { [weak self] in
            self?.handleActionButton(at: indexPath)
        }
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
    
    var actionButtonDidTap: (() -> Void)?
    
    func configure(with slide: Slide){
        infoLabel.text = slide.title
        startButton.backgroundColor = slide.buttonCollor
        startButton.setTitle(slide.buttonTitle, for: .normal)
        
        let animation = Animation.named(slide.animationName)
        animatinView.animation = animation
        animatinView.loopMode = .loop
        if !animatinView.isAnimationPlaying{
            animatinView.play()
        }
        startButton.layer.cornerRadius = 7
    }
    
    @IBAction func sratrButtonTapped(_ sender: Any?){
        actionButtonDidTap?()
    }
    
    
}
