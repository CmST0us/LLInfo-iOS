//
//  DataModelHelper.swift
//  LLInfo
//
//  Created by CmST0us on 2018/1/3.
//  Copyright © 2018年 eki. All rights reserved.
//

import Foundation
class DataModelHelper {
    //MARK: - Private Member
    private func tryCreateDictionaries(withJsonData data:Data) -> [Dictionary<String, Any>]? {
        do {
            let jsonObj = try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers])
            let dictionaryObj = jsonObj as? [Dictionary<String, Any>]
            return dictionaryObj
        } catch {
            return nil
        }
    }
    
    private func tryCreateDictionary(withJsonData data:Data) -> Dictionary<String, Any>? {
        do {
            let jsonObj = try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers])
            let dictionaryObj = jsonObj as? Dictionary<String, Any>
            return dictionaryObj
        } catch {
            return nil
        }
    }
    //MARK: - Private Method
    private init() {
        
    }
    
    //MARK: - Public Member
    //MARK: Single Instance
    static let shared = DataModelHelper()
    
    //MARK: - Public Method
    func createDictionaries(withJsonData data:Data) -> [Dictionary<String, Any>]? {
        if let d1 = self.tryCreateDictionaries(withJsonData: data) {
            if d1.count == 0 {
                return nil
            }
            return d1
        }
        if let d2 = self.tryCreateDictionary(withJsonData: data) {
            if d2.count == 0 {
                return nil
            }
            return [d2]
        }
        return nil
    }
    
}
