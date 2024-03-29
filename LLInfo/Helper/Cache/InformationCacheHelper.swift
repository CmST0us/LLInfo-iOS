//
//  InformationCacheHelper.swift
//  LLInfo
//
//  Created by CmST0us on 2018/1/7.
//  Copyright © 2018年 eki. All rights reserved.
//

import Foundation
import CoreData

final class InformationCacheHelper {
    
    static let shared = InformationCacheHelper()
    private init() {
        
    }
    
    //MARK: Fetch
    private func fetchInformationManagedObject(withUrlPath urlPath: String, entityName: String) -> [NSManagedObject]? {
        let context = InformationCoreDataHelper.shared.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sort = NSSortDescriptor(key: "time", ascending: false)
        fetch.predicate = NSPredicate(format: "url == %@", urlPath)
        fetch.resultType = .managedObjectResultType
        fetch.fetchLimit = 1
        fetch.sortDescriptors = [sort]
        
        do {
            let o = try context.fetch(fetch) as? [NSManagedObject]
            return o
        } catch {
            return nil
        }
    }
    
    private func fetchInformationManagedObject(withId id: String, entityName: String) -> [NSManagedObject]? {
        let context = InformationCoreDataHelper.shared.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sort = NSSortDescriptor(key: "time", ascending: false)
        fetch.predicate = NSPredicate(format: "id == %@", id)
        fetch.resultType = .managedObjectResultType
        fetch.fetchLimit = 1
        fetch.sortDescriptors = [sort]
        
        do {
            let o = try context.fetch(fetch) as? [NSManagedObject]
            return o
        } catch {
            return nil
        }
    }
    
    private func fetchInformation<T>(withId id: String) -> Set<T>? where T: InformationDataModel, T: CoreDataModelBridgeProtocol {
        let context = InformationCoreDataHelper.shared.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        let sort = NSSortDescriptor(key: "time", ascending: false)
        fetch.predicate = NSPredicate(format: "id == %@", id)
        fetch.resultType = .dictionaryResultType
        fetch.fetchLimit = 1
        fetch.sortDescriptors = [sort]
        do {
            if let dicts = try context.fetch(fetch) as? [Dictionary<String, Any>] {
                if dicts.count == 0 {
                    return nil
                }
                let m = T(dictionary: dicts[0])
                return Set<T>([m])
            }
        } catch {
            return nil
        }
        return nil
    }
    
    private func fetchInformation<T>(withUrlPath urlPath: String) -> Set<T>? where T: InformationDataModel, T: CoreDataModelBridgeProtocol {
        let context = InformationCoreDataHelper.shared.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        let sort = NSSortDescriptor(key: "time", ascending: false)
        fetch.predicate = NSPredicate(format: "url == %@", urlPath)
        fetch.resultType = .dictionaryResultType
        fetch.fetchLimit = 1
        fetch.sortDescriptors = [sort]
        do {
            if let dicts = try context.fetch(fetch) as? [Dictionary<String, Any>] {
                if dicts.count == 0 {
                    return nil
                }
                let m = T(dictionary: dicts[0])
                return Set<T>([m])
            }
        } catch {
            return nil
        }
        return nil
    }
    
    //[TODO] set to private when not debug
    func fetchInformation<T>(limit: Int = 20, offset: Int = 0) -> Set<T>? where T: InformationDataModel, T: CoreDataModelBridgeProtocol {
        let context = InformationCoreDataHelper.shared.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        let sort = NSSortDescriptor(key: "time", ascending: false)
        fetch.resultType = .dictionaryResultType
        fetch.fetchLimit = limit
        fetch.fetchOffset = offset
        fetch.sortDescriptors = [sort]
        
        do {
            if let dicts = try context.fetch(fetch) as? [Dictionary<String, Any>] {
                if dicts.count == 0 {
                    return nil
                }
                var a = Set<T>()
                for dict in dicts {
                    let m = T(dictionary: dict)
                    a.insert(m)
                }
                return a
            }
        } catch {
            return nil
        }
        return nil
    }
    
    private func fetchInformation<T>(beforeTimeInterval: TimeInterval, limit: Int = 20, offset: Int = 0, batchSize: Int = 0) -> Set<T>? where T: InformationDataModel, T: CoreDataModelBridgeProtocol {
        let context = InformationCoreDataHelper.shared.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        let sort = NSSortDescriptor(key: "time", ascending: false)
        fetch.resultType = .dictionaryResultType
        fetch.fetchLimit = limit
        fetch.fetchOffset = offset
        fetch.fetchBatchSize = batchSize
        fetch.sortDescriptors = [sort]
        fetch.predicate = NSPredicate(format: "time <= %f", beforeTimeInterval)
        do {
            if let dicts = try context.fetch(fetch) as? [Dictionary<String, Any>] {
                if dicts.count == 0 {
                    return nil
                }
                var a = Set<T>()
                for dict in dicts {
                    let m = T(dictionary: dict)
                    a.insert(m)
                }
                return a
            }
        } catch {
            return nil
        }
        return nil
    }
    
    private func fetchInformation<T>(afterTimeInterval: TimeInterval, limit: Int = 20, offset: Int = 0, batchSize: Int = 0) -> Set<T>? where T: InformationDataModel, T: CoreDataModelBridgeProtocol {
        let context = InformationCoreDataHelper.shared.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        let sort = NSSortDescriptor(key: "time", ascending: true)
        fetch.resultType = .dictionaryResultType
        fetch.fetchLimit = limit
        fetch.fetchOffset = offset
        fetch.fetchBatchSize = batchSize
        fetch.sortDescriptors = [sort]
        fetch.predicate = NSPredicate(format: "time >= %f", afterTimeInterval)
        do {
            if let dicts = try context.fetch(fetch) as? [Dictionary<String, Any>] {
                if dicts.count == 0 {
                    return nil
                }
                var a = Set<T>()
                for dict in dicts {
                    let m = T(dictionary: dict)
                    a.insert(m)
                }
                return a
            }
        } catch {
            return nil
        }
        return nil
    }
    
    
}

//MARK: - InformationCacheHelper+TestUtil
extension InformationCacheHelper {
    func removeAll(inEntity entity:String) {
        let context = InformationCoreDataHelper.shared.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let res = try! context.fetch(fetch) as! [NSManagedObject]
        for r in res {
            context.delete(r)
        }
    }
}

//MARK: - InformationCacheApi
extension InformationCacheHelper {
    // MARK: Request
    func requestPage<T>(pageNum: Int, simpleMode: Bool) throws -> Set<T>? where T:InformationDataModel, T: CoreDataModelBridgeProtocol, T:InformationApiRequestParamProtocol{
        if let a: Set<T> = fetchInformation(limit: 20, offset: (pageNum - 1) * 20) {
            return a
        }
        let param = T.requestPageApiRequestParam(pageNum: pageNum, simpleMode: simpleMode)
        do {
            let data = try ApiHelper.shared.request(withParam: param)
            if let dicts = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                var s: Set<T> = Set<T>()
                for dict in dicts {
                    let m = T(dictionary: dict)
                    insertInformationIfNotExist(m)
                    s.insert(m)
                }
                try! InformationCoreDataHelper.shared.saveContext()
                return s
            } else {
                return nil
            }
        } catch {
            throw error
        }
        
    }
    
    func requestNewestInformation<T>(simpleMode: Bool) throws -> Set<T>? where T:InformationDataModel, T: CoreDataModelBridgeProtocol, T:InformationApiRequestParamProtocol{
        if let a: Set<T> = fetchInformation(limit: 1, offset: 0) {
            return a
        }
        let param = T.requestNewestInformationApiRequestParam(simpleMode: simpleMode)
        do {
            let data = try ApiHelper.shared.request(withParam: param)
            if let dicts = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                var s: Set<T> = Set<T>()
                for dict in dicts {
                    let m = T(dictionary: dict)
                    insertInformationIfNotExist(m)
                    s.insert(m)
                }
                try! InformationCoreDataHelper.shared.saveContext()
                return s
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    func requestInfomation<T>(beforeTimeInterval: TimeInterval, simpleMode: Bool) throws -> Set<T>? where T:InformationDataModel, T: CoreDataModelBridgeProtocol, T:InformationApiRequestParamProtocol{
        if let a: Set<T> = fetchInformation(beforeTimeInterval: beforeTimeInterval), a.count > 1 {
            return a
        }
        let param = T.requestInfomationApiRequestParam(beforeTimeInterval: beforeTimeInterval, simpleMode: simpleMode)
        do {
            let data = try ApiHelper.shared.request(withParam: param)
            if let dicts = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                var s: Set<T> = Set<T>()
                for dict in dicts {
                    let m = T(dictionary: dict)
                    insertInformationIfNotExist(m)
                    s.insert(m)
                }
                try! InformationCoreDataHelper.shared.saveContext()
                return s
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    func requestInfomation<T>(afterTimeInterval: TimeInterval, simpleMode: Bool) throws -> Set<T>? where T:InformationDataModel, T: CoreDataModelBridgeProtocol, T:InformationApiRequestParamProtocol{
        if let a: Set<T> = fetchInformation(afterTimeInterval: afterTimeInterval), a.count > 1 {
            return a
        }
        let param = T.requestInfomationApiRequestParam(afterTimeInterval: afterTimeInterval, simpleMode: simpleMode)
        do {
            let data = try ApiHelper.shared.request(withParam: param)
            if let dicts = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                var s: Set<T> = Set<T>()
                for dict in dicts {
                    let m = T(dictionary: dict)
                    insertInformationIfNotExist(m)
                    s.insert(m)
                }
                try! InformationCoreDataHelper.shared.saveContext()
                return s
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    func requestInfomation<T>(withUrl url: String) throws -> Set<T>? where T:InformationDataModel, T: CoreDataModelBridgeProtocol, T:InformationApiRequestParamProtocol{
        if let a: Set<T> = fetchInformation(withUrlPath: url) {
            return a
        }
        let param = T.requestInformationApiRequestParam(withUrl: url)
        do {
            let data = try ApiHelper.shared.request(withParam: param)
            if let dicts = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                var s: Set<T> = Set<T>()
                for dict in dicts {
                    let m = T(dictionary: dict)
                    insertInformationIfNotExist(m)
                    s.insert(m)
                }
                try! InformationCoreDataHelper.shared.saveContext()
                return s
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    
    //MARK: Insert
    func insertInformation<T>(_ information: T) where T: InformationDataModel, T: CoreDataModelBridgeProtocol {
        let context = InformationCoreDataHelper.shared.persistentContainer.viewContext
        let e = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: context)
        information.copy(to: e)
    }
    
    func insertInformationIfNotExist<T>(_ information: T) where T: InformationDataModel, T: CoreDataModelBridgeProtocol {
        
        if let urlPath = information.urlPath {
            let s: Set<T>? = fetchInformation(withUrlPath: urlPath)
            if s == nil {
                insertInformation(information)
            }
        }
    }
    //MARK: Remove
    func removeInformation<T>(byUrlPath urlPath: String, information: T) -> Bool where T:InformationDataModel, T: CoreDataModelBridgeProtocol{
        let context = InformationCoreDataHelper.shared.persistentContainer.viewContext
        if let o = self.fetchInformationManagedObject(withUrlPath: urlPath, entityName: T.entityName) {
            guard o.count > 0 else {
                return false
            }
            context.delete(o.first!)
            return true
        }
        return false
    }
    
    //MARK: Update
    func update<T>(information: T, usingUrlPath urlPath: String, updateValuesAndKeys: [String: Any]) -> Bool where T: InformationDataModel, T: CoreDataModelBridgeProtocol{
        if let o = fetchInformationManagedObject(withUrlPath: urlPath, entityName: T.entityName) {
            guard o.count > 0 else {
                return false
            }
            o.first!.setValuesForKeys(updateValuesAndKeys)
            return true
        }
        return false
    }
    func updata<T>(information: T, usingId id: String, updateValuesAndKeys: [String: Any]) -> Bool where T: InformationDataModel, T: CoreDataModelBridgeProtocol {
        if let o = fetchInformationManagedObject(withId: id, entityName: T.entityName){
            guard o.count > 0 else {
                return false
            }
            o.first!.setValuesForKeys(updateValuesAndKeys)
            return true
        }
        return false
    }
}
