//
//  UserDataHelper.swift
//  LLInfo
//
//  Created by CmST0us on 2018/2/6.
//  Copyright © 2018年 eki. All rights reserved.
//

import Foundation
import CoreData
class UserDataHelper {
    
    private init() {
        
    }
    
    static var shared = UserDataHelper()
    
    private func doSave() {
        do {
            try UserDataCoreDataHelper.shared.saveContext()
        } catch {
            Logger.shared.output("can not save core data")
        }
    }
}

// MARK: - Favorite entity method
extension UserDataHelper {
    func fetchInformation(withUrl url: String, informationEntityName: String) -> InformationDataModel? {
        do {
            switch informationEntityName {
            case InfoDataModel.entityName:
                if let s: Set<InfoDataModel> = try InformationCacheHelper.shared.requestInfomation(withUrl: url) {
                    return s.first
                }
                break
            case OfficialNewsDataModel.entityName:
                if let s: Set<OfficialNewsDataModel> = try InformationCacheHelper.shared.requestInfomation(withUrl: url) {
                    return s.first
                }
                break
            default: break
            }
        }catch {
            return nil
        }
        return nil
    }
    
    func fetchFavorite(limit: Int = 0, batch: Int = 0, offset: Int = 0) -> Set<Favorite>? {
        let req: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        req.fetchLimit = limit
        req.fetchBatchSize = batch
        req.fetchOffset = offset
        req.resultType = .managedObjectResultType
        let context = UserDataCoreDataHelper.shared.persistentContainer.viewContext
        do {
            let res = try context.fetch(req)
            return Set<Favorite>(res)
        } catch {
            return nil
        }
    }
    
    func fetchFavorite(url: String) -> Set<Favorite>? {
        let req: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        req.resultType = .managedObjectResultType
        req.predicate = NSPredicate(format: "url == %@", url)
        let context = UserDataCoreDataHelper.shared.persistentContainer.viewContext
        do {
            let res = try context.fetch(req)
            return Set<Favorite>(res)
        } catch {
            return nil
        }
    }
    
    func addFavorite(url: String, informationEntityName: String) {
        let context = UserDataCoreDataHelper.shared.persistentContainer.viewContext
        let e = NSEntityDescription.entity(forEntityName: Favorite.entiryName, in: context)
        if let ee = e {
            let f = Favorite(entity: ee, insertInto: context)
            f.url = url
            f.type = informationEntityName
            do {
                try UserDataCoreDataHelper.shared.saveContext()
            } catch {
                //[TODO] error log
                //do somethine
            }
        }
        
    }
}


// MARK: User Card Method
extension UserDataHelper {
    //Fetch Method
    func fetchUserCardManagedObject(withCardId cardId: Int, cardSetName: String) -> NSManagedObject? {
        let viewContext = UserDataCoreDataHelper.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>.init(entityName: UserCardDataModel.entityName)
        fetchRequest.predicate = NSPredicate(format: "cardId == %d AND cardSetName == %@", cardId, cardSetName)
        do {
            if let result = try viewContext.fetch(fetchRequest).first {
                return result
            }
        } catch {
            return nil
        }
        return nil
    }
    
    
    
    func fetchAllCard(cardSetName: String) -> [UserCardDataModel]? {
        let viewContext = UserDataCoreDataHelper.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: UserCardDataModel.entityName)
        fetchRequest.predicate = NSPredicate(format: "cardSetName == %@", cardSetName)
        fetchRequest.resultType = .dictionaryResultType
        do {
            if let result = try viewContext.fetch(fetchRequest) as? [[String: Any]] {
                return result.map({ (obj) -> UserCardDataModel in
                    return UserCardDataModel(withDictionary: obj)
                })
            }
        } catch {
            return nil
        }
        return nil
    }
    
    func fetchAllCardSetName() -> NSOrderedSet {
        let viewContext = UserDataCoreDataHelper.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>.init(entityName: UserCardDataModel.entityName)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            var userSet = Set<String>.init()
            for result in results {
                let user = result.value(forKey: "cardSetName") as! String
                userSet.insert(user)
            }
            return NSOrderedSet.init(set: userSet)
        } catch {
            return []
        }
    }
    
    //MARK: Add Method
    func addCard(card: UserCardDataModel, checkExist: Bool = true) {
        
        func add(card: UserCardDataModel) {
            let viewContext = UserDataCoreDataHelper.shared.persistentContainer.viewContext
            let description = NSEntityDescription.insertNewObject(forEntityName: UserCardDataModel.entityName, into: viewContext)
            card.copy(to: description)
            doSave()
            do {
                try UserDataCoreDataHelper.shared.saveContext()
            } catch {
                Logger.shared.output("can not save core data")
            }
        }
        
        if checkExist == false {
            add(card: card)
        } else {
            if let _ = fetchUserCardManagedObject(withCardId: card.cardId, cardSetName: card.cardSetName) {
                return
            } else {
                add(card: card)
            }
        }
    }
    
    // MARK: Remove Method
    func removeUserCard(withCardId cardId: Int, cardSetName: String) {
        let viewContext = UserDataCoreDataHelper.shared.persistentContainer.viewContext
        if let managedObject = fetchUserCardManagedObject(withCardId: cardId, cardSetName: cardSetName) {
            viewContext.delete(managedObject)
            doSave()
        }
    }
    func removeAllCards(cardSetName: String) {
        let viewContext = UserDataCoreDataHelper.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>.init(entityName: UserCardDataModel.entityName)
        fetchRequest.predicate = NSPredicate(format: "cardSetName == %@", cardSetName)
        do {
            let results = try viewContext.fetch(fetchRequest)
            for result in results {
                viewContext.delete(result)
            }
            doSave()
        } catch {
            return
        }
    }
}
