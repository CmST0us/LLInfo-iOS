//
//  ApiRequestParam.swift
//  LLInfo
//
//  Created by CmST0us on 2018/1/31.
//  Copyright © 2018年 eki. All rights reserved.
//

import Foundation
class ApiRequestParam {
    
    struct Method {
        static let GET = "GET"
        static let POST = "POST"
        static let PUT = "PUT"
        static let DELETE = "DELETE"
        static let UPDATE = "UPDATE"
    }
    
    var method: String = ""
    var params: [String: String] = [:]
    var query: [String: String] = [:]
    var path: String = ""
    var headerField: [String: String] = [:]
}
