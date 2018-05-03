//
//  SIFCardAllCardImportCollectionViewController.swift
//  LLInfo
//
//  Created by CmST0us on 2018/3/27.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit
import MBProgressHUD

class SIFCardAllCardImportCollectionViewController: UICollectionViewController {
    
    struct Identifier {
        static let cardCell = "cardCell"
    }
    
    struct Segue {
        static let cardFilterSegue = "cardFilterSegue"
    }
    
    private var filteCardDataSource: [UserCardDataModel] {
        
        let p = cardFilterPredicates.map { (item) -> NSPredicate in
            item.predicate
        }
        
        return allCardDataSource.filter { (item) -> Bool in
            let cardInfoModel = SIFCacheHelper.shared.cards[item.cardId]!
            for i in p {
                if i.evaluate(with: cardInfoModel) == false {
                    return false
                }
            }
            return true
        }
        
    }
    
    private var allCardDataSource: [UserCardDataModel] = []
    
    private var collectionViewDataSource: [UserCardDataModel] {
        
        if cardFilterPredicates.count > 0 {
            return filteCardDataSource
        }
        
        return allCardDataSource
        
    }
    
    private var cardFilterPredicates: [SIFCardFilterPredicate] = []
    
    private lazy var progressHud: MBProgressHUD = {
        var hud = MBProgressHUD(view: self.view)
        return hud
    }()
    
    // MARK: Private Method
    private func initAllCardDataSource() {
        allCardDataSource = SIFCacheHelper.shared.cards.map({ (kv) -> UserCardDataModel in
            let userCard = UserCardDataModel()
            userCard.cardId = kv.key
            userCard.cardSetName = SIFCacheHelper.shared.currentCardSetName
            userCard.isIdolized = false
            userCard.isKizunaMax = false
            userCard.isImport = false
            if let promo = kv.value.isPromo?.boolValue {
                if promo {
                    userCard.isIdolized = true
                }
            }
            return userCard
        }).sorted(by: { (a, b) -> Bool in
            let aCard: CardDataModel = SIFCacheHelper.shared.cards[a.cardId]!
            let bCard: CardDataModel = SIFCacheHelper.shared.cards[b.cardId]!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let aDate = dateFormatter.date(from: aCard.releaseDate ?? "") {
                if let bDate = dateFormatter.date(from: bCard.releaseDate ?? "") {
                    return aDate > bDate
                }
            }
            return a.cardId > b.cardId
        })
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
    
    // MARK: IBAction IBOutlet
    @IBAction func onImportButtonDown(_ sender: Any) {
        progressHud.mode = .indeterminate
        progressHud.label.text = "正在导入"
        progressHud.show(animated: true)
        
        DispatchQueue.global().async {
            for card in self.allCardDataSource {
                if card.isImport {
                    UserDataHelper.shared.addCard(card: card, checkExist: true)
                }
            }
            
            DispatchQueue.main.async {
                self.progressHud.mode = .text
                self.progressHud.label.text = "导入成功"
                self.progressHud.hide(animated: true, afterDelay: 0.5)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: SIFCardToolListViewController.NotificationName.importFinish), object: nil)
            }
        }

    }
    
    deinit {
        Logger.shared.console("deinit")
    }
}

// MARK: Stroy Board Method
extension SIFCardAllCardImportCollectionViewController {
    
    static func storyBoardInstance() -> SIFCardAllCardImportCollectionViewController {
        
        let storyBoard = UIStoryboard.init(name: "SIFCardTool", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "SIFCardAllCardImportCollectionViewController") as! SIFCardAllCardImportCollectionViewController
        
    }
        
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
            }
        }
    }
}


// MARK: Collection View Data Source And Delegate
extension SIFCardAllCardImportCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return collectionViewDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.cardCell, for: indexPath) as! SIFCardImportCollectionViewCell
        let userCard = collectionViewDataSource[indexPath.row]
        let card = SIFCacheHelper.shared.cards[userCard.cardId]!
        cell.setupView(withCard: card, userCard: userCard)
        cell.isImport = false
        cell.valueChangeHandle = { [weak self] v in
            if let index = collectionView.indexPath(for: v.cell) {
                let uc = self?.collectionViewDataSource[index.row]
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

// MARK: - SIFCardFilterDelegate
extension SIFCardAllCardImportCollectionViewController: SIFCardFilterDelegate {
    
    func cardFilter(_ cardFilter: SIFCardFilterViewController, didFinishPredicateEdit predicates: [SIFCardFilterPredicate]) {
        
        self.cardFilterPredicates = predicates
        self.collectionView?.reloadData()
        
    }
    
}

// MARK: View Lift Cycle
extension SIFCardAllCardImportCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAllCardDataSource()
        self.view.addSubview(progressHud)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        SIFCacheHelper.shared.removeAllImageCache()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.progressHud.removeFromSuperview()
    }
}
