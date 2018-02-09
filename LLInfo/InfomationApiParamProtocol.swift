//
//  ApiParamProtocol.swift
//  LLInfo
//
//  Created by CmST0us on 2018/1/31.
//  Copyright © 2018年 eki. All rights reserved.
//

import Foundation
protocol InformationApiParamProtocol {
    static func requestPageApiParam(pageNum: Int, simpleMode: Bool) -> ApiParam
    
    static func requestNewestInformationApiParam(simpleMode: Bool) -> ApiParam
    
    static func requestInfomationApiParam(atTimeIntervalRange range: NSRange, simpleMode: Bool) -> ApiParam
    
    static func requestInfomationApiParam(beforeTimeInterval: TimeInterval, simpleMode: Bool) -> ApiParam
    
    static func requestInfomationApiParam(afterTimeInterval: TimeInterval, simpleMode: Bool) -> ApiParam
    
//    static func requestInfomationApiParam(withId id: String) -> ApiParam
    
    static func requestInformationApiParam(withUrl url: String) -> ApiParam
    
}
