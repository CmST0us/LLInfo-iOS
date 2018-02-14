//
//  OfficialNewsDataModel.swift
//  LLInfo
//
//  Created by CmST0us on 2018/1/6.
//  Copyright © 2018年 eki. All rights reserved.
//

import Foundation
import CoreData

class OfficialNewsDataModel: InformationDataModel {
    //MARK: - Private Member
    
    //MARK: - Private Method
    
    //MARK: - Public Member
    override lazy var timeZone: TimeZone = {
        return TimeZone(identifier: "Japan")!
    }()
    
    var formatTime: String {
        var tt: TimeInterval = 0
        if let t = self.time {
            tt = t
        } else {
            tt = 0
        }
        let time = Date(timeIntervalSince1970: tt)
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY年MM月dd日"
        formatter.timeZone = self.timeZone
        let timeString = formatter.string(from: time)
        return timeString
    }
    //MARK: - Public Method

}

extension OfficialNewsDataModel: CoreDataModelBridgeProtocol {
    static var entityName: String = "OfficialNews"
    
    func copy(to managerObject: NSManagedObject) {
        managerObject.setValue(self.id, forKey: CodingKey.id)
        managerObject.setValue(self.brief, forKey: CodingKey.brief)
        managerObject.setValue(self.briefImageUrlPath, forKey: CodingKey.briefImageUrl)
        managerObject.setValue(self.contentHtml, forKey: CodingKey.contentHtml)
        managerObject.setValue(self.source, forKey: CodingKey.source)
        managerObject.setValue(self.sourceName, forKey: CodingKey.sourceName)
        managerObject.setValue(self.tags?.joined(separator: "||"), forKey: CodingKey.tags)
        managerObject.setValue(self.title, forKey: CodingKey.title)
        managerObject.setValue(self.time, forKey: CodingKey.time)
        managerObject.setValue(self.urlPath, forKey: CodingKey.url)
    }
}

extension OfficialNewsDataModel: InformationApiRequestParamProtocol {
    
    static func requestPageApiRequestParam(pageNum: Int, simpleMode: Bool) -> ApiRequestParam {
        let p = ApiRequestParam()
        p.method = ApiRequestParam.Method.GET
        
        if simpleMode == true {
            p.query["simple"] = "1"
        }
        
        p.path = "/official/news/page/\(pageNum)"
        return p
    }
    
    static func requestNewestInformationApiRequestParam(simpleMode: Bool) -> ApiRequestParam {
        let p = ApiRequestParam()
        p.method = ApiRequestParam.Method.GET
        p.path = "/official/news/item"
        if simpleMode == true {
            p.query["simple"] = "1"
        }
        return p
    }
    
    static func requestInfomationApiRequestParam(atTimeIntervalRange range: NSRange, simpleMode: Bool) -> ApiRequestParam {
        let p = ApiRequestParam()
        p.method = ApiRequestParam.Method.GET
        p.path = "/official/news/item"
        if simpleMode == true {
            p.query["simple"] = "1"
        }
        let afterTime = range.location
        let beforeTime = range.location + range.length
        
        p.query["after"] = String(afterTime)
        p.query["before"] = String(beforeTime)
        
        return p
    }
    
    static func requestInfomationApiRequestParam(beforeTimeInterval: TimeInterval, simpleMode: Bool) -> ApiRequestParam {
        let p = ApiRequestParam()
        p.method = ApiRequestParam.Method.GET
        p.path = "/official/news/item"
        
        if simpleMode == true {
            p.query["simple"] = "1"
        }
        let beforeTime = Int(beforeTimeInterval)
        p.query["before"] = String(beforeTime)
        
        return p
    }
    static func requestInfomationApiRequestParam(afterTimeInterval: TimeInterval, simpleMode: Bool) -> ApiRequestParam {
        let p = ApiRequestParam()
        p.method = ApiRequestParam.Method.GET
        p.path = "/official/news/item"
        
        if simpleMode == true {
            p.query["simple"] = "1"
        }
        
        let afterTime = Int(afterTimeInterval)
        p.query["after"] = String(afterTime)
        
        return p
    }
        
    static func requestInformationApiRequestParam(withUrl url: String) -> ApiRequestParam {
        let p = ApiRequestParam()
        p.method = ApiRequestParam.Method.GET
        if let data = url.data(using: .utf8) {
            let base64String = data.base64EncodedAsUrlParams()
            p.path = "/official/news/item/\(base64String)"
        } else {
            p.path = "/official/news/item/notfound"
        }
        return p
    }
}

extension OfficialNewsDataModel: InformationShareableProtocol {
    var sharedUrl: String {
        if let data = self.urlPath?.data(using: .utf8) {
            let base64EncodeString = data.base64EncodedAsUrlParams()
            return "/official/news/item/\(base64EncodeString)"
        }
        return "/official/news/item/notfound"
    }
}
