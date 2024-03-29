//
//  ViewController.swift
//  SIFTool
//
//  Created by CmST0us on 2018/2/14.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit
import MobileCoreServices
import TZImagePickerController
import MBProgressHUD
import SnapKit

class SIFCardToolListViewController: UIViewController {
    
    struct Segue {
        static let cardFilterSegue = "cardFilterSegue"
        static let screenshotImportSegue = "screenshotImportSegue"
        static let allCardImportSegue = "allCardImportSegue"
        static let cardDetailSegue = "cardDetailSegue"
    }
    
    struct Identificer {
        static let userCardCell = "userCardCell"
        static let sortCell = "sortCell"
        
    }
    
    struct NotificationName {
        static let importFinish = "SIFCardScreenshotImportCollectionViewController.importFinish"
        static let switchCardSet = "SIFCardScreenshotImportCollectionViewController.switchCardSet"
    }
    
    //MARK: Private Member
    private weak var nextViewController: UIViewController? = nil
    
    private lazy var cardUpdater: SIFCardUpdater = {
        var updater = SIFCardUpdater(withWorkQueue: DispatchQueue.init(label: "SIFCardToolListViewController.cardUpdater"))
        updater.delegate = self
        return updater
    }()
    
    private lazy var processHUD: MBProgressHUD = {
        var hud = MBProgressHUD(view: self.view)
        return hud
    }()
    
    private var sortToolView: SIFCardSortToolView!
    
    private var selectScreenshots: [UIImage]!
    
    private var sortConfigSelectIndexTuple = (attribute: 0, rank: 0, method: 0) {
        didSet {
            userCardDataSource.sort { (a, b) -> Bool in
                let aCard = SIFCacheHelper.shared.cards[a.cardId]!
                let bCard = SIFCacheHelper.shared.cards[b.cardId]!
                
                /*
                 <rank attr=min>
                 <attribute attr=Cool> </attribute>
                 <attribute attr=Pure> </attribute>
                 <attribute attr=Smile> </attribute>
                 </rank>
                 <rank attr=nonidolized>
                 <attribute attr=Cool> </attribute>
                 <attribute attr=Pure> </attribute>
                 <attribute attr=Smile> </attribute>
                 </rank>
                 <rank attr=idolized>
                 <attribute attr=Cool> </attribute>
                 <attribute attr=Pure> </attribute>
                 <attribute attr=Smile> </attribute>
                 </rank>
                 <rank attr=user>
                 <attribute attr=Cool> </attribute>
                 <attribute attr=Pure> </attribute>
                 <attribute attr=Smile> </attribute>
                 </rank>
                 */
                
                let aSortArray = [
                    [aCard.minimumStatisticsCool, aCard.minimumStatisticsPure, aCard.minimumStatisticsSmile],
                    [aCard.nonIdolizedMaximumStatisticsCool, aCard.nonIdolizedMaximumStatisticsPure, aCard.nonIdolizedMaximumStatisticsSmile],
                    [aCard.idolizedMaximumStatisticsCool, aCard.idolizedMaximumStatisticsPure, aCard.idolizedMaximumStatisticsSmile],
                    [aCard.statisticsCool(idolized: a.isIdolized, isKizunaMax: a.isKizunaMax), aCard.statisticsPure(idolized: a.isIdolized, isKizunaMax: a.isKizunaMax), aCard.statisticsSmile(idolized: a.isIdolized, isKizunaMax: a.isKizunaMax)]
                    
                ]
                
                let bSortArray = [
                    [bCard.minimumStatisticsCool, bCard.minimumStatisticsPure, bCard.minimumStatisticsSmile],
                    [bCard.nonIdolizedMaximumStatisticsCool, bCard.nonIdolizedMaximumStatisticsPure, bCard.nonIdolizedMaximumStatisticsSmile],
                    [bCard.idolizedMaximumStatisticsCool, bCard.idolizedMaximumStatisticsPure, bCard.idolizedMaximumStatisticsSmile],
                    [bCard.statisticsCool(idolized: b.isIdolized, isKizunaMax: b.isKizunaMax), bCard.statisticsPure(idolized: b.isIdolized, isKizunaMax: b.isKizunaMax), bCard.statisticsSmile(idolized: b.isIdolized, isKizunaMax: b.isKizunaMax)]
                ]
                
                let attributeIndex = sortConfigSelectIndexTuple.attribute
                let rankIndex = sortConfigSelectIndexTuple.rank
                
                
                let sortScoreA = aSortArray[rankIndex][attributeIndex].intValue
                let sortScoreB = bSortArray[rankIndex][attributeIndex].intValue
                
                if sortConfigSelectIndexTuple.method == 0 {
                    return sortScoreA > sortScoreB
                }
                return sortScoreA < sortScoreB
            }
            self.reloadData()
        }
    }
    
    private var cardFilterPredicates: [SIFCardFilterPredicate] = []

    private var filteCardDataSource: [UserCardDataModel] {
        
        let p = cardFilterPredicates.map { (item) -> NSPredicate in
            item.predicate
        }
        
        return userCardDataSource.filter { (item) -> Bool in
            let cardInfoModel = SIFCacheHelper.shared.cards[item.cardId]!
            for i in p {
                if i.evaluate(with: cardInfoModel) == false {
                    return false
                }
            }
            return true
        }
        
    }
    
    lazy private var userCardDataSource: [UserCardDataModel] = {
        
       return UserDataHelper.shared.fetchAllCard(cardSetName: SIFCacheHelper.shared.currentCardSetName) ?? []
        
    }()
    
    private var collectionViewDataSource: [UserCardDataModel] {
        
        if cardFilterPredicates.count > 0 {
            return filteCardDataSource
        }
        
        return userCardDataSource
        
    }
    
    private func isPhotoLibraryAvailable() -> Bool {
        
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
        
    }
    
    // MARK: Private Method
    private func reloadData() {
        
        self.userCardCollectionView.reloadData()
        
    }
    
    private func setupSortToolView() {
        
        self.sortToolView = Bundle.main.loadNibNamed("SortToolView", owner: SIFCardSortToolView.self, options: nil)?.last! as! SIFCardSortToolView
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        
        sortToolView.attributeSortBlock = { [weak self] sender in
            
            let sheet = UIAlertController(title: "排序属性", message: nil, preferredStyle: .actionSheet)
            
            let pureSortAction = UIAlertAction(title: "洒脱", style: .default, handler: { (action) in
                self?.sortConfigSelectIndexTuple.attribute = 0
            })
            let coolSortAction = UIAlertAction(title: "清纯", style: .default, handler: { (action) in
                self?.sortConfigSelectIndexTuple.attribute = 1
            })
            let smileSortActin = UIAlertAction(title: "甜美", style: .default, handler: { (action) in
                self?.sortConfigSelectIndexTuple.attribute = 2
            })
            
            sheet.addAction(pureSortAction)
            sheet.addAction(coolSortAction)
            sheet.addAction(smileSortActin)
            sheet.addAction(cancelAction)
            
            if let sheetPopverController = sheet.popoverPresentationController {
                sheetPopverController.sourceView = sender
                sheetPopverController.sourceRect = sender.frame
                sheetPopverController.permittedArrowDirections = .any
                self?.present(sheet, animated: true, completion: nil)
            } else {
                self?.present(sheet, animated: true, completion: nil)
            }
            
        }
        
        sortToolView.rankSortBlock = { [weak self] sender in
            let sheet = UIAlertController(title: "排序等级", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let minRankSortAction = UIAlertAction(title: "1级", style: UIAlertActionStyle.default, handler: { (action) in
                self?.sortConfigSelectIndexTuple.rank = 0
            })
            let maxRankNonIdolizedAction = UIAlertAction(title: "未觉醒最高", style: UIAlertActionStyle.default, handler: { (action) in
                self?.sortConfigSelectIndexTuple.rank = 1
            })
            let maxRankIdolizedAction = UIAlertAction(title: "觉醒最高", style: UIAlertActionStyle.default, handler: { (action) in
                self?.sortConfigSelectIndexTuple.rank = 2
            })
            let userIdolizedStateAction = UIAlertAction(title: "用户持有觉醒状态", style: UIAlertActionStyle.default, handler: { (action) in
                self?.sortConfigSelectIndexTuple.rank = 3
            })
            
            sheet.addAction(minRankSortAction)
            sheet.addAction(maxRankNonIdolizedAction)
            sheet.addAction(maxRankIdolizedAction)
            sheet.addAction(userIdolizedStateAction)
            sheet.addAction(cancelAction)
            
            if let sheetPopverController = sheet.popoverPresentationController {
                sheetPopverController.sourceView = sender
                sheetPopverController.sourceRect = sender.frame
                sheetPopverController.permittedArrowDirections = .any
                self?.present(sheet, animated: true, completion: nil)
            } else {
                self?.present(sheet, animated: true, completion: nil)
            }
            
        }
        
        sortToolView.sortMethodBlcok = { [weak self] sender in
            let sheet = UIAlertController(title: "排序方式", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let ascendingMethodAction = UIAlertAction(title: "升序", style: UIAlertActionStyle.default, handler: { (action) in
                self?.sortConfigSelectIndexTuple.method = 0
            })
            let deascendingMethodAction = UIAlertAction(title: "降序", style: UIAlertActionStyle.default, handler: { (action) in
                self?.sortConfigSelectIndexTuple.method = 1
            })
            
            sheet.addAction(ascendingMethodAction)
            sheet.addAction(deascendingMethodAction)
            sheet.addAction(cancelAction)
            
            if let sheetPopverController = sheet.popoverPresentationController {
                sheetPopverController.sourceView = sender
                sheetPopverController.sourceRect = sender.frame
                sheetPopverController.permittedArrowDirections = .any
                self?.present(sheet, animated: true, completion: nil)
            } else {
                self?.present(sheet, animated: true, completion: nil)
            }
            
        }
        
    }
    
    private func setupSelectCardSetButtonTitle() {
        
        self.selectCardSetButton.setTitle("\(SIFCacheHelper.shared.currentCardSetName)的卡组▼", for: UIControlState.normal)
        
    }
    
    // MARK: IBOutlet
    @IBOutlet private weak var userCardCollectionView: UICollectionView!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var selectCardSetButton: UIButton!
    
    @IBAction func onSelectCardSetButtonDown(_ sender: UIButton) {
        
        let cardSetSelectVC = SIFCardSetNameSelectTableViewController.storyBoardInstance()
        
        cardSetSelectVC.modalPresentationStyle = .popover
        if let popover = cardSetSelectVC.popoverPresentationController {
            popover.delegate = cardSetSelectVC
            popover.permittedArrowDirections = .up
            popover.sourceView = sender
            popover.sourceRect = sender.frame
        }
        
        self.present(cardSetSelectVC, animated: true, completion: nil)
    }
    
    @IBAction func onEditButtonDown(_ sender: Any) {
        
        self.isEditing = !self.isEditing
        
        if self.isEditing {
            editButton.title = "完成"
        } else {
            editButton.title = "编辑"
        }
        
        self.userCardCollectionView.reloadData()
        
    }
    
    @IBAction func addCard(_ sender: Any) {
        
        let addMethodSheet = UIAlertController(title: "添加卡片", message: nil, preferredStyle: .actionSheet)
        let addMethodAllCard = UIAlertAction(title: "从所有卡片中添加", style: .default) { [weak self] (action) in
            self?.performSegue(withIdentifier: Segue.allCardImportSegue, sender: nil)
        }
        let addMethodScreenshot = UIAlertAction(title: "从游戏截图添加", style: .default) { [weak self] (action) in
            guard self?.isPhotoLibraryAvailable() ?? false else {
                return
            }
            
            let photoPicker = TZImagePickerController()
            photoPicker.allowCrop = false
            photoPicker.allowTakePicture = true
            photoPicker.allowPickingVideo = false
            photoPicker.pickerDelegate = self
            photoPicker.naviBgColor = UIColor.navigationBar
            photoPicker.naviTitleColor = UIColor.white
            photoPicker.allowPickingOriginalPhoto = false
            
            self?.present(photoPicker, animated: true, completion: nil)
        }
        let addMethodCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        addMethodSheet.addAction(addMethodScreenshot)
        addMethodSheet.addAction(addMethodAllCard)
        addMethodSheet.addAction(addMethodCancel)
        
        let popoverController = addMethodSheet.popoverPresentationController
        
        if popoverController != nil {
            if sender is UIBarButtonItem {
                popoverController!.barButtonItem = (sender as! UIBarButtonItem)
            }
            popoverController!.permittedArrowDirections = .any
        }
        
        self.present(addMethodSheet, animated: true, completion: nil)
        
    }
    
}


// MARK: - Notification Method
extension SIFCardToolListViewController {
    
    @objc func importFinish() {
        self.userCardDataSource = UserDataHelper.shared.fetchAllCard(cardSetName: SIFCacheHelper.shared.currentCardSetName) ?? []
        self.userCardCollectionView.reloadData()
    }
    
    @objc func didSwitchCardSet() {
        self.userCardDataSource = UserDataHelper.shared.fetchAllCard(cardSetName: SIFCacheHelper.shared.currentCardSetName) ?? []
        self.userCardCollectionView.reloadData()
        self.isEditing = false
        setupSelectCardSetButtonTitle()
    }
}

// MARK: - View Life Cycle
extension SIFCardToolListViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        userCardCollectionView.delegate = self
        userCardCollectionView.dataSource = self

        setupSortToolView()
        
        self.sortToolView.translatesAutoresizingMaskIntoConstraints = false
        
        self.userCardCollectionView.addSubview(self.sortToolView)
        self.userCardCollectionView.alwaysBounceVertical = true
        
        self.sortToolView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self.userCardCollectionView.snp.top)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.centerX.equalToSuperview()
            maker.height.equalTo(34)
        }
        
        self.userCardCollectionView.contentInset = UIEdgeInsets(top: 34, left: 0, bottom: 0, right: 0)

        NotificationCenter.default.addObserver(self, selector: #selector(importFinish), name: NSNotification.Name(rawValue: NotificationName.importFinish), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSwitchCardSet), name: NSNotification.Name(rawValue: NotificationName.switchCardSet), object: nil)
        
        self.cardUpdater.startCheckCardUpdate()
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        setupSelectCardSetButtonTitle()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
    }

}

// MARK: - Collection View Delegate And DataSouce
extension SIFCardToolListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionViewDataSource.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identificer.userCardCell, for: indexPath) as! SIFUserCardCollectionViewCell
        let userCardModel = collectionViewDataSource[indexPath.row]
        cell.setupView(withCard: SIFCacheHelper.shared.cards[userCardModel.cardId]!, userCard: userCardModel)
        cell.deleteHandle = { [weak self] sender in
            if let deletedCell = sender.superview?.superview as? UICollectionViewCell {
                let deletedIndex = collectionView.indexPath(for: deletedCell)!
                let deletedUserCardModel = self?.collectionViewDataSource[deletedIndex.row]
                self?.userCardDataSource = (self?.userCardDataSource.filter({ (item) -> Bool in
                    !(item.cardId == deletedUserCardModel!.cardId)
                }))!
                collectionView.deleteItems(at: [deletedIndex])
                UserDataHelper.shared.removeUserCard(withCardId: deletedUserCardModel!.cardId, cardSetName: SIFCacheHelper.shared.currentCardSetName)
            }
        }
        if self.isEditing {
            cell.deleteButton.isHidden = false
        } else {
            cell.deleteButton.isHidden = true
        }
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! SIFUserCardCollectionViewCell
        if !self.isEditing {
            let userCardModel = collectionViewDataSource[indexPath.row]
            nextViewController?.setValue(userCardModel, forKey: "userCard")
        }
        
    }
    
}


// MARK: - StoryBoard Method
extension SIFCardToolListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            if identifier == Segue.cardFilterSegue {
                let dest = (segue.destination as! UINavigationController).topViewController! as! SIFCardFilterViewController
                dest.predicates = self.cardFilterPredicates
                dest.delegate = self
                dest.templateRow = [
                    SIFCardFilterPredicateEditorRowTemplate.init(
                        withLeftExpression: (expression: NSExpression.init(forKeyPath: "id.stringValue"), displayName: "卡片ID"),
                        rightExpression: [(expression: NSExpression.init(expressionType: NSExpression.ExpressionType.variable), displayName: "")],
                        condition: SIFCardFilterPredicateCondition.init(withConditions: [SIFCardFilterPredicateCondition.Condition.equal]),
                        rightExpressionType: .variable),
                    
                    SIFCardFilterPredicateEditorRowTemplate.init(
                        withLeftExpression: (expression: NSExpression.init(forKeyPath: "idol.name"), displayName: "名字"),
                        rightExpression: [(expression: NSExpression.init(expressionType: NSExpression.ExpressionType.variable), displayName: "")],
                        condition: SIFCardFilterPredicateCondition.init(withConditions: [SIFCardFilterPredicateCondition.Condition.equal, .contains]),
                        rightExpressionType: .variable),
                    
                    SIFCardFilterPredicateEditorRowTemplate.init(
                        withLeftExpression: (expression: NSExpression.init(forKeyPath: "rarity"), displayName: "稀有度"),
                        rightExpression: [(expression: NSExpression.init(forConstantValue: "N"), displayName: "N"),
                                          (expression: NSExpression.init(forConstantValue: "R"), displayName: "R"),
                                          (expression: NSExpression.init(forConstantValue: "SR"), displayName: "SR"),
                                          (expression: NSExpression.init(forConstantValue: "SSR"), displayName: "SSR"),
                                          (expression: NSExpression.init(forConstantValue: "UR"), displayName: "UR"),
                                          ],
                        condition: SIFCardFilterPredicateCondition.init(withConditions: [SIFCardFilterPredicateCondition.Condition.equal]),
                        rightExpressionType: .constantValue),
                    
                    SIFCardFilterPredicateEditorRowTemplate.init(
                        withLeftExpression: (expression: NSExpression.init(forKeyPath: "attribute"), displayName: "属性"),
                        rightExpression: [(expression: NSExpression.init(forConstantValue: "Pure"), displayName: "清纯"),
                                          (expression: NSExpression.init(forConstantValue: "Cool"), displayName: "洒脱"),
                                          (expression: NSExpression.init(forConstantValue: "Smile"), displayName: "甜美")
                        ],
                        condition: SIFCardFilterPredicateCondition.init(withConditions: [SIFCardFilterPredicateCondition.Condition.equal]),
                        rightExpressionType: NSExpression.ExpressionType.constantValue)
                ]
            } else if identifier == Segue.screenshotImportSegue {
                let importViewController = segue.destination as! SIFCardScreenshotImportCollectionViewController
                importViewController.screenshots = self.selectScreenshots
            } else if identifier == Segue.cardDetailSegue {
                nextViewController = segue.destination
                
            }
        }
        
    }
    
}
// MARK: - SIFCardFilterDelegate
extension SIFCardToolListViewController: SIFCardFilterDelegate {
    
    func cardFilter(_ cardFilter: SIFCardFilterViewController, didFinishPredicateEdit predicates: [SIFCardFilterPredicate]) {
        
        self.cardFilterPredicates = predicates
        self.userCardCollectionView.reloadData()
        
    }
    
}

// MARK: - TZImagePickerControllerDelegate Delegate
extension SIFCardToolListViewController: TZImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        
        self.selectScreenshots = []
        var originCallCount: Int = 0 {
            didSet {
                if originCallCount == assets.count {
                    self.performSegue(withIdentifier: Segue.screenshotImportSegue, sender: nil)
                }
            }
            
        }
        
        for item in assets {
            TZImageManager.default().getOriginalPhoto(withAsset: item, completion: { (image, info) in
                guard image != nil else {
                    originCallCount += 1
                    return
                }
                self.selectScreenshots.append(image!)
                originCallCount += 1
            })
        }
        
    }

    
}

// MARK: - UINavigationController Delegate
extension SIFCardToolListViewController: UINavigationControllerDelegate {
    
}

// MARK: - SFICardUpdaterDelegate
extension SIFCardToolListViewController: SIFCardUpdaterDelegate {
    
    func updaterWillStartCheckCardUpdate(_ updater: SIFCardUpdater) {
        Logger.shared.console("")
    }
    
    func updaterDidFindNewCard(_ updater: SIFCardUpdater) {
        let alert = UIAlertController(title: "卡片", message: "有新的卡片数据，是否更新", preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "更新", style: .default) { (alertAction) in
            self.cardUpdater.startUpdateCard()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (cancelAction) in
            self.cardUpdater.stopUpdateCard()
        }
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updaterWillUpdateCard(_ updater: SIFCardUpdater) {
        DispatchQueue.main.async {
            self.view.addSubview(self.processHUD)
            self.processHUD.show(animated: true)
            self.processHUD.label.text = "正在更新卡片数据"
        }
    }
    
    func updaterDidUpdateCard(_ updater: SIFCardUpdater, currentCardCount: Int, totalCardCount: Int) {
        self.processHUD.setLabelTextAsync(text: "正在更新卡片数据 \(String(currentCardCount)) / \(String(totalCardCount))")
    }
    
    func updaterWillCancelByUser(_ updater: SIFCardUpdater) {
        self.processHUD.hideAsync(animated: true)
    }
    
    func updaterWillStartUpdateCardRoundImage(_ updater: SIFCardUpdater) {
        self.processHUD.setLabelTextAsync(text: "正在缓存图片数据")
    }
    
    func updaterDidFinishUpdateCard(_ updater: SIFCardUpdater, success: Bool) {
        if success {
            self.processHUD.setLabelTextAsync(text: "更新成功")
        } else {
            self.processHUD.setLabelTextAsync(text: "更新失败")
        }
        
        self.processHUD.hideAsync(animated: true, afterDelay: 1.0)
        
    }
    
    
}
