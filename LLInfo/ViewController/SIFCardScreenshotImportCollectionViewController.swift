 //
//  SIFCardScreenshotImportCollectionViewController.swift
//  SIFTool
//
//  Created by CmST0us on 2018/3/11.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit
import MBProgressHUD

class SIFCardScreenshotImportCollectionViewController: UICollectionViewController {
    deinit {
        Logger.shared.console("deinit")
    }
    struct Identifier {
        static let cardCell = "cardCell"
    }
    
    
    enum ImportType {
        case cardSet
        case screenshot
    }
    
    // MARK: Private Member
    var screenshots: [UIImage]!
    var progressHud: MBProgressHUD!
    
    var detector: SIFRoundIconDetector!
    var detectorConfiguration: SIFRoundIconDetectorConfiguration!
    var scanWorkItem: DispatchWorkItem!
    
    
    var cards: [UserCardDataModel] = []
    
    // MARK: Private Method
    @objc func exitCurrentVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: IBAction IBOutlet
    @IBOutlet weak var importButton: UIBarButtonItem!
    
    @IBAction func onDoImportButtonDown(_ sender: Any) {

        for card in self.cards {
            if card.isImport {
                UserDataHelper.shared.addCard(card: card, checkExist: true)
            }
        }
        progressHud.label.text = "导入成功"
        progressHud.hide(animated: true, afterDelay: 0.5)
        self.perform(#selector(exitCurrentVC), with: nil, afterDelay: 0.5)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SIFCardToolListViewController.NotificationName.importFinish), object: nil)
        
    }
    
    
    private func setupDetector(usePatternCache: Bool = true) {
        
        let cardCache = SIFCacheHelper.shared.cards
        self.detectorConfiguration = SIFRoundIconDetectorConfiguration.defaultRoundIconConfiguration(ratio: 0.5)
        let patternImage = UIImage.init(contentsOfFile: SIFCacheHelper.shared.cacheDirectory.appendingPathComponent("pattern.png"))
        if patternImage != nil && usePatternCache {
            self.detector = SIFRoundIconDetector(withCards: cardCache, configuration: self.detectorConfiguration, roundCardImagePattern: patternImage!.mat)
            Logger.shared.console("use pattern image cache")
        } else {
            self.detector = SIFRoundIconDetector(withCards: cardCache, configuration: self.detectorConfiguration)
            
            for roundCardIconUrl in self.detector.roundCardUrls {
                var roundCardIconPair: (CVMat?, CVMat?) = (nil, nil)
                
                if let nonIdolizedRoundCardIconImage = roundCardIconUrl.1 {
                    roundCardIconPair.0 = SIFCacheHelper.shared.image(withUrl: nonIdolizedRoundCardIconImage)?.mat
                }
                
                if let idolizedRoundCardIconImage = roundCardIconUrl.2 {
                    roundCardIconPair.1 = SIFCacheHelper.shared.image(withUrl: idolizedRoundCardIconImage)?.mat
                }
                
                self.detector.makeRoundCardImagePattern(cardId: roundCardIconUrl.0, images: roundCardIconPair)
            }
            
            self.detector.saveRoundCardImagePattern(toPath: SIFCacheHelper.shared.cacheDirectory.appendingPathComponent("pattern.png"))
        }
        
    }
    
    private func checkCardUpdate() -> Bool {
        let param = CardDataModel.requestIds()
        if let resData = try? SchoolIdolTomotachiApiHelper.shared.request(withParam: param) {
            if let array = DataModelHelper.shared.array(withJsonData: resData) as? [Int] {
                return !(array.count == SIFCacheHelper.shared.cards.count)
            }
        }
        return false
    }
    
    private func scanScreenshot() {
        
        self.progressHud = MBProgressHUD(view: UIApplication.shared.keyWindow!)
        self.view.addSubview(self.progressHud)
        self.progressHud.show(animated: true)
        self.progressHud.label.text = "正在扫描图片"
        self.cards = []
        
        scanWorkItem = DispatchWorkItem(block: { [weak self] in
            self?.progressHud.setLabelTextAsync(text: "扫描中")
            
            if let weakSelf = self {
                for screenshot in weakSelf.screenshots {
                    let originMat = weakSelf.detector.cutEdgeArea(screenshot.mat)
                    
                    let results = weakSelf.detector.search(screenshot: originMat)
                    
                    for result in results.1 {
                        let roi = originMat.roi(at: results.0)?.roi(at: result)
                        guard roi != nil else {
                            continue
                        }
                        
                        let template = weakSelf.detector.makeTemplateImagePattern(image: roi!)
                        
                        if let point = weakSelf.detector.match(image: template) {
                            let card = weakSelf.detector.card(atPatternPoint: point)
                            
                            if card == nil {
                                continue
                            }
                            
                            let userCard = UserCardDataModel()
                            userCard.cardId = card!.0.id.intValue
                            userCard.isIdolized = card!.1
                            userCard.isImport = true
                            userCard.isKizunaMax = true
                            userCard.cardSetName = SIFCacheHelper.shared.currentCardSetName
                            weakSelf.cards.append(userCard)
                            
                            weakSelf.progressHud.setLabelTextAsync(text: "找到卡片(ID: \(String(userCard.cardId)))")
                        }
                        
                    }
                    
                }
            }
            
            
            self?.progressHud.hideAsync(animated: true)

            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
                self?.importButton.isEnabled = true
            }
            
        })
        
        DispatchQueue.global().async(execute: self.scanWorkItem)
        
    }

}


// MARK: - View Life Cycle Method
extension SIFCardScreenshotImportCollectionViewController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        scanScreenshot()
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        scanWorkItem.cancel()
        
    }
    
}


// MARK: - Collection View DataSource And Delegate Method
extension SIFCardScreenshotImportCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.cards.count
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.cardCell, for: indexPath) as! SIFCardImportCollectionViewCell
    
        let userCard = cards[indexPath.row]
        let cardDataModel = SIFCacheHelper.shared.cards[userCard.cardId]
        cell.setupView(withCard: cardDataModel!, userCard: userCard)
        cell.valueChangeHandle = { [weak self] v in
            if let index = collectionView.indexPath(for: v.cell) {
                let uc = self?.cards[index.row]
                let c = SIFCacheHelper.shared.cards[uc!.cardId]
                
                uc?.isIdolized = v.isIdolized
                uc?.isImport = v.isImport
                uc?.isKizunaMax = v.isKizunaMax
                
                v.cell.setupView(withCard: c!, userCard: uc!)
            }
        }
        return cell
        
    }
    
}

// MARK: - Story Board Instance
extension SIFCardScreenshotImportCollectionViewController {
    
    static func storyBoardInstance() -> SIFCardScreenshotImportCollectionViewController {
        
        let storyBoard = UIStoryboard.init(name: "SIFCardTool", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "SIFCardScreenshotImportCollectionViewController") as! SIFCardScreenshotImportCollectionViewController
        
    }
    
}

