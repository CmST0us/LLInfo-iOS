//
//  SIFCardDetailViewController.swift
//  LLInfo
//
//  Created by CmST0us on 2018/4/2.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit

class SIFCardDetailViewController: UIViewController {
    
    struct Identifier {
        static let cardImageCell = "cardImageCell"
        static let cardScoreCell = "cardScoreCell"
        static let cardIdolCell = "cardIdolCell"
    }
    
    @objc var userCard: UserCardDataModel!
    
    lazy var cardDataModel: CardDataModel? = { [weak self] in
        guard userCard != nil else {
            return nil
        }
        
        var cardId = userCard!.cardId
        return SIFCacheHelper.shared.cards[cardId]
    }()

    // MARK: Private Member
    
    // MARK: IBOutlet And IBAction
    @IBOutlet weak var collectionView: UICollectionView!
}

// MARK: - Private Method
extension SIFCardDetailViewController {
    private func setTitleString(_ title: String) {
        self.navigationItem.title = title
    }
    
    private func registerCell() {
        self.collectionView.register(UINib.init(nibName: "SIFCardDetailCardImageCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Identifier.cardImageCell)
        self.collectionView.register(UINib.init(nibName: "SIFCardDetailCardScoreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Identifier.cardScoreCell)
        self.collectionView.register(UINib.init(nibName: "SIFCardDetailIdolCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Identifier.cardIdolCell)
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
}


// MARK: - View Life Cycle Method
extension SIFCardDetailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard cardDataModel != nil else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        self.setTitleString(cardDataModel?.idol.name ?? "")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.registerCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

// MARK: UICollectionView Delegate DataSource FlowLayoutDelegate
extension SIFCardDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Identifier.cardImageCell, for: indexPath) as! SIFCardDetailCardImageCollectionReusableView
        cell.cardImageViewUrlBlock = { [weak self] (idolized, type) -> String? in
            switch type {
            case .clear:
                return idolized ? self?.cardDataModel?.cleanUrIdolized : self?.cardDataModel?.cleanUr
            case .normal:
                return idolized ? self?.cardDataModel?.cardIdolizedImage : self?.cardDataModel?.cardImage
            case .transparent:
                return idolized ? self?.cardDataModel?.transparentIdolizedImage : self?.cardDataModel?.transparentImage
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.tuple {
        case (0, 0):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.cardScoreCell, for: indexPath)
            return cell
        case (0, 1):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.cardIdolCell, for: indexPath)
            return cell
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numberOfCellInRow = 2
        if self.traitCollection.horizontalSizeClass == .compact {
            numberOfCellInRow = 1
        }
        let cellWidth = collectionView.bounds.size.width / CGFloat(numberOfCellInRow)
        let height = CGFloat(235)
        return CGSize(width: cellWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let radio = 1026.0 / 720.0
        var imageWidth = Double(self.collectionView.bounds.width)
        if imageWidth > 900 {
            imageWidth = 900
        }
        let imageHeight = imageWidth / radio
        let height = imageHeight + 8.0 + 29.0 + 8.0
        return CGSize(width: imageWidth, height: height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

