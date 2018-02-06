//
//  InformationDataModel.swift
//  LLInfo
//
//  Created by CmST0us on 2018/1/7.
//  Copyright © 2018年 eki. All rights reserved.
//

import Foundation
import CoreData

class InformationDataModel: NSObject {
    //MARK: - Private Member
    
    //MARK: - Private Method
    
    //MARK: - Public Member
    
    //read only
    private(set) var dataDictionary: Dictionary<String, Any> = [:]
    
    lazy var timeZone: TimeZone = {
        return TimeZone.current
    }()
    
    override var hash: Int {
        if let u = self.urlPath {
            return u.hash
        }
        return 1
    }
    
    static func ==(lhs: InformationDataModel, rhs: InformationDataModel) -> Bool {
        if let s1 = lhs.urlPath {
            if let s2 = rhs.urlPath {
                return s1 == s2
            }
        }
        return false
    }
    
    static func !=(lhs: InformationDataModel, rhs: InformationDataModel) -> Bool {
        if let s1 = lhs.urlPath {
            if let s2 = rhs.urlPath {
                return s1 != s2
            }
        }
        return false
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let o = object as? InformationDataModel {
            return o == self
        }
        return false
    }
    
    //MARK: Decode Key
    struct CodingKey {
        static let id = "id"
        static let source = "source"
        static let sourceName = "sourceName"
        static let time = "time"
        static let url = "url"
        static let title = "title"
        static let brief = "brief"
        static let tags = "tags"
        static let briefImageUrl = "briefImageUrl"
        static let contentHtml = "contentHtml"
    }
    
    var id: String {
        return dataDictionary[CodingKey.id] as! String
    }
    
    var source: String? {
        return dataDictionary[CodingKey.source] as? String
    }
    
    var sourceName: String? {
        if let sn = dataDictionary[CodingKey.sourceName] as? String {
            return sn
        }
        return self.source
    }
    
    var time: TimeInterval? {
        if let n = dataDictionary[CodingKey.time] as? NSNumber {
            return n.doubleValue
        }
        return nil
    }
    
    var urlPath: String? {
        return dataDictionary[CodingKey.url] as? String
    }
    
    var title: String? {
        return dataDictionary[CodingKey.title] as? String
    }
    
    var brief: String? {
        return dataDictionary[CodingKey.brief] as? String
    }
    
    var tags: [String]? {
        return dataDictionary[CodingKey.tags] as? [String]
    }
    
    var briefImageUrlPath: String? {
        return dataDictionary[CodingKey.briefImageUrl] as? String
    }
    
    var contentHtml: String? {
        return dataDictionary[CodingKey.contentHtml] as? String
    }
    
    //MARK: - Public Method
    required init(dictionary: Dictionary<String, Any>) {
        dataDictionary = dictionary
        if let _ = dataDictionary["_id"] {
            dataDictionary[CodingKey.id] = dataDictionary["_id"]
            dataDictionary.removeValue(forKey: "_id")
        }
        if let tags = dataDictionary["tags"] as? String {
            dataDictionary["tags"] = tags.components(separatedBy: "||")
        }
    }
}
