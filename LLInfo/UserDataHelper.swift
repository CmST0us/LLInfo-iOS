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
    
    struct EntityName {
        static let favorite = "Favorite"
    }
    
    
    private init() {
        
    }
    
    static var shared = UserDataHelper()
    
}

// MARK: - Favorite entity method
extension UserDataHelper {
    func fetchInformation(witId id: String, informationEntityName: String) -> InformationDataModel? {
        do {
            switch informationEntityName {
            case InfoDataModel.entityName:
                if let s: Set<InfoDataModel> = try InformationCacheHelper.shared.requestInfomation(withId: id) {
                    return s.first
                }
                break
            case OfficialNewsDataModel.entityName:
                if let s: Set<OfficialNewsDataModel> = try InformationCacheHelper.shared.requestInfomation(withId: id) {
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
        let e = NSEntityDescription.entity(forEntityName: EntityName.favorite, in: context)
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
