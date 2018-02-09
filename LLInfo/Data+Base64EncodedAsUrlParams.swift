//
//  Data+Base64EncodeAsUrlParams.swift
//  LLInfo
//
//  Created by CmST0us on 2018/2/9.
//  Copyright © 2018年 eki. All rights reserved.
//

import Foundation
extension Data {
    func base64EncodedAsUrlParams() -> String {
        var c = CharacterSet.urlQueryAllowed
        c.remove(charactersIn: "+=")
        let s = self.base64EncodedString()
         return s.addingPercentEncoding(withAllowedCharacters: c) ?? ""
    }
}
