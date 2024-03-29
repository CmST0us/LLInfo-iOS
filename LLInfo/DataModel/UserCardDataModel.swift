//
//  UserCardDataModel.swift
//  SIFTool
//
//  Created by CmST0us on 2018/2/25.
//  Copyright © 2018年 eki. All rights reserved.
//
import CoreData

@objcMembers
class UserCardDataModel: NSObject {
    var cardId: Int = 0
    var isIdolized: Bool = false
    var cardSetName: String = ""
    
    var isImport: Bool = true
    var isKizunaMax: Bool = false

    init(withDictionary dictionary:[String: Any]) {
        cardId = dictionary["cardId"] as! Int
        isIdolized = dictionary["isIdolized"] as! Bool
        cardSetName = dictionary["cardSetName"] as! String
        isKizunaMax = dictionary["isKizunaMax"] as! Bool
    }
    
    override init() {
        super.init()
    }
    
}

extension UserCardDataModel: CoreDataModelBridgeProtocol {
    static var entityName: String = "UserCard"
    
    func copy(to managedObject: NSManagedObject) {
        managedObject.setValue(cardId, forKey: "cardId")
        managedObject.setValue(isIdolized, forKey: "isIdolized")
        managedObject.setValue(cardSetName, forKey: "cardSetName")
        managedObject.setValue(isKizunaMax, forKey: "isKizunaMax")
    }
}

