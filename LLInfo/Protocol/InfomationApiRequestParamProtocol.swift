//
//  ApiRequestParamProtocol.swift
//  LLInfo
//
//  Created by CmST0us on 2018/1/31.
//  Copyright © 2018年 eki. All rights reserved.
//

import Foundation
protocol InformationApiRequestParamProtocol {
    static func requestPageApiRequestParam(pageNum: Int, simpleMode: Bool) -> ApiRequestParam
    
    static func requestNewestInformationApiRequestParam(simpleMode: Bool) -> ApiRequestParam
    
    static func requestInfomationApiRequestParam(atTimeIntervalRange range: NSRange, simpleMode: Bool) -> ApiRequestParam
    
    static func requestInfomationApiRequestParam(beforeTimeInterval: TimeInterval, simpleMode: Bool) -> ApiRequestParam
    
    static func requestInfomationApiRequestParam(afterTimeInterval: TimeInterval, simpleMode: Bool) -> ApiRequestParam
    
    static func requestInformationApiRequestParam(withUrl url: String) -> ApiRequestParam
    
}
