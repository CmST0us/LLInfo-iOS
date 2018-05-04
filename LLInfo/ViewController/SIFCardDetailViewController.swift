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
        static let cardInfoCell = "cardInfoCell"
        static let cardSkillCell = "cardSkillCell"
    }
    
    @objc var userCard: UserCardDataModel!

    // MARK: Private Member
    private lazy var cardDataModel: CardDataModel? = {
        guard userCard != nil else {
            return nil
        }
        
        var cardId = userCard!.cardId
        return SIFCacheHelper.shared.cards[cardId]
    }()
    
    var currentSelectCardImageType: SIFCardDetailCardImageCollectionReusableView.CardImageType = .normal
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
        self.collectionView.register(UINib.init(nibName: "SIFCardDetailCardInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Identifier.cardInfoCell)
        self.collectionView.register(UINib.init(nibName: "SIFCardDetailCardSkillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Identifier.cardSkillCell)
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
        return 4
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Identifier.cardImageCell, for: indexPath) as! SIFCardDetailCardImageCollectionReusableView
        
        cell.setupView(withUserCard: userCard, cardDataModel: cardDataModel!)
        cell.cardImageViewUrlBlock = { [weak self] (idolized, type) -> String? in
            self?.currentSelectCardImageType = type
            switch type {
            case .clear:
                return idolized ? self?.cardDataModel?.cleanUrIdolized : self?.cardDataModel?.cleanUr
            case .normal:
                return idolized ? self?.cardDataModel?.cardIdolizedImage : self?.cardDataModel?.cardImage
            case .transparent:
                return idolized ? self?.cardDataModel?.transparentIdolizedImage : self?.cardDataModel?.transparentImage
            }
        }
        
        let showActionSheetBlock: ((_ actionSheet: UIAlertController) -> Void) = { [weak self] actionSheet in
            let weakSelf = self!
            weakSelf.present(actionSheet, animated: true, completion: nil)
        }
        
        cell.nonIdolizedImageView.tapImageViewBlock = { (sender) in
            sender.zoomImageView.saveImageActionSheetShowBlock = showActionSheetBlock
        }
        
        cell.idolizedImageView.tapImageViewBlock = { (sender) in
            sender.zoomImageView.saveImageActionSheetShowBlock = showActionSheetBlock
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.tuple {
        case (0, 0):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.cardScoreCell, for: indexPath) as! SIFCardDetailCardScoreCollectionViewCell
            cell.setupView(withUserCard: userCard, cardDataModel: cardDataModel!)
            cell.idolizedStateChangeBlock = { [weak self] (levelState) in
                let weakSelf = self!
                let isKizunaMax = weakSelf.userCard.isKizunaMax
                var isIdolized = true
                var isLevelMax = true
                
                switch levelState {
                case .maxIdolizedLevel:
                    isLevelMax = true
                case .minLevel:
                    isLevelMax = false
                    isIdolized = false
                case .maxNonIdolizedLevel:
                    isIdolized = false
                    isLevelMax = true
                }
                
                cell.smileScoreIndicator.maxScore = CardDataModel.maxCardScore
                cell.smileScoreIndicator.score = weakSelf.cardDataModel!.statisticsSmile(idolized: isIdolized, isKizunaMax: isKizunaMax, currentIdolizedStateLevelMax: isLevelMax).doubleValue
        
                cell.coolScoreIndicator.maxScore = CardDataModel.maxCardScore
                cell.coolScoreIndicator.score = weakSelf.cardDataModel!.statisticsCool(idolized: isIdolized, isKizunaMax: isKizunaMax, currentIdolizedStateLevelMax: isLevelMax).doubleValue
        
                cell.pureScoreIndicator.maxScore = CardDataModel.maxCardScore
                cell.pureScoreIndicator.score = weakSelf.cardDataModel!.statisticsPure(idolized: isIdolized, isKizunaMax: isKizunaMax, currentIdolizedStateLevelMax: isLevelMax).doubleValue
                
                if isIdolized {
                    cell.hp = (weakSelf.cardDataModel?.hp?.intValue ?? 2) + 1
                } else {
                    cell.hp = (weakSelf.cardDataModel?.hp?.intValue ?? 2)
                }
                
            }
            return cell
        case (0, 1):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.cardIdolCell, for: indexPath) as! SIFCardDetailIdolCollectionViewCell
            cell.setupView(withUserCard: userCard, cardDataModel: cardDataModel!)
            return cell
        case (0, 2):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.cardInfoCell, for: indexPath) as! SIFCardDetailCardInfoCollectionViewCell
            cell.setupView(withUserCard: userCard, cardDataModel: cardDataModel!)
            cell.showPairCardButtonDownBlock = { [weak self] in
                let weakSelf = self!
                guard weakSelf.cardDataModel!.urPair?.card != nil else {
                    return
                }
                
                let pairCardVC = SIFCardDetailViewController.storyBoardInstance()
                let uc = UserCardDataModel.init()
                uc.cardId = weakSelf.cardDataModel!.urPair!.card!.id?.intValue ?? -1
                if uc.cardId == -1 {
                    return
                }
                uc.isImport = false
                uc.isIdolized = false
                uc.isKizunaMax = false
                pairCardVC.userCard = uc
                self?.navigationController?.pushViewController(pairCardVC, animated: true)
            }
            cell.showPairCardImageButtonDownBlock = { [weak self] in
                let weakSelf = self!
                let pariCardImage = OpenCVBridgeSwiftHelper.sharedInstance().emptyImage(with: CGSize.init(width: 1024, height: 720), channel: 3)
                
//                switch weakSelf.currentSelectCardImageType {
//                case .clear:
//                    
//                case .normal:
//                    
//                case .transparent:
//                    
//                }
            }
            return cell
        case (0, 3):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.cardSkillCell, for: indexPath) as!
                SIFCardDetailCardSkillCollectionViewCell
            cell.setupView(withUserCard: userCard, cardDataModel: cardDataModel!)
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
        let ratio = 1025.0 / 720.0
        var imageWidth = Double(self.collectionView.bounds.width)
        if imageWidth > 900 {
            imageWidth = 900
        }
        let imageHeight = imageWidth / ratio
        let height = imageHeight + 8.0 + 29.0 + 8.0
        return CGSize(width: imageWidth, height: height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

// MARK: - Story Board Method
extension SIFCardDetailViewController {
    
    static func storyBoardInstance() -> SIFCardDetailViewController {
        let storyBoard = UIStoryboard.init(name: "SIFCardDetail", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "SIFCardDetailViewController") as! SIFCardDetailViewController
    }
}

