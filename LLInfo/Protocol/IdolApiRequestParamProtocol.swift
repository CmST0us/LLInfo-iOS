//
//  IdolApiRequestParamProtocol.swift
//  LLInfo
//
//  Created by CmST0us on 2018/3/26.
//  Copyright © 2018年 eki. All rights reserved.
//

import Foundation

protocol IdolApiRequestParamProtocol {
    static func requestPage(_ page: Int, pageSize: Int) -> ApiRequestParam
    static func requestIdol(withEnglishName englishName: String) -> ApiRequestParam
}

