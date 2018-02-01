//
//  AppVersionUpdateDataModel.swift
//  LLInfo
//
//  Created by CmST0us on 2018/1/6.
//  Copyright © 2018年 eki. All rights reserved.
//

import Foundation
class AppVersionUpdateDataModel {
    private var _dataDictionary: Dictionary<String, Any>
    
    struct CodingKey{
        static let versionKey = "version"
        static let messageKey = "message"
    }
    
    var version: Float? {
        return _dataDictionary[CodingKey.versionKey] as? Float
    }
    
    var message: String? {
        return _dataDictionary[CodingKey.messageKey] as? String
    }
    
    init(dictionary: Dictionary<String, Any>) {
        _dataDictionary = dictionary
    }
}

extension AppVersionUpdateDataModel: CommonApiParamProtocol {
    static func requestApiParam() -> ApiParam {
        let p = ApiParam()
        p.method = ApiParam.Method.GET
        p.path = "/app/ios/version"
        return p
    }
}
