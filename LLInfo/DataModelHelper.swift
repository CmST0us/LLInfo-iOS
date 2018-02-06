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
    private func trySyntaxJson(withJsonData data:Data, key: String) -> Any? {
        do {
            let jsonObj = try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers])
            if let value = jsonObj as? Dictionary<String, Any> {
                return value[key]
            }
        } catch {
            return nil
        }
        return nil
    }

    //MARK: - Private Method
    private init() {
        
    }
    
    //MARK: - Public Member
    //MARK: Single Instance
    static let shared = DataModelHelper()
    
    //MARK: - Public Method
    func payloadDictionaries(withJsonData data:Data) -> [Dictionary<String, Any>]? {
        return trySyntaxJson(withJsonData: data, key: "payload") as? [Dictionary<String, Any>]
    }
    func success(withJsonData data: Data) -> Bool? {
        return trySyntaxJson(withJsonData: data, key: "success") as? Bool
    }
    
    func message(withJsonData data: Data) -> String? {
        return trySyntaxJson(withJsonData: data, key: "message") as? String
    }
}
