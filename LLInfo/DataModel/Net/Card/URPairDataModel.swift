//
//  URPairDataModel.swift
//  SIFTool
//
//  Created by CmST0us on 2018/2/14.
//  Copyright © 2018年 eki. All rights reserved.
//

import Foundation

struct URPairCard {
    struct CodingKey{
        static let attribute = "attribute"
        static let roundCardImage = "round_card_image"
        static let id = "id"
        static let name = "name"
    }
    
    var attribute: String? = nil
    var roundCardImage: String? = nil
    var id: NSNumber? = nil
    var name: String? = nil
    
    init(withDictionar dictionary: Dictionary<String, Any>) {
        attribute = dictionary[CodingKey.attribute] as? String
        roundCardImage = dictionary[CodingKey.roundCardImage] as? String
        if let idRaw = dictionary[CodingKey.id] as? Int {
            id = NSNumber.init(value: idRaw)
        }
        name = dictionary[CodingKey.name] as? String
    }
}
class URPairDataModel: NSObject {
    struct CodingKey {
        static let card = "card"
        static let reverseDisplayIdolized = "reverse_display_idolized"
        static let reverseDisplay = "reverse_display"
    }
    
    var card: URPairCard? = nil
    var reverseDisplayIdolized: Bool? = nil
    var reverseDisplay: Bool? = nil
    
    required init(withDictionary dictionary: Dictionary<String, Any>) {
        if let c = dictionary[CodingKey.card] as? Dictionary<String, Any> {
            card = URPairCard(withDictionar: c)
        }
        reverseDisplay = dictionary[CodingKey.reverseDisplay] as? Bool
        reverseDisplayIdolized = dictionary[CodingKey.reverseDisplayIdolized] as? Bool
    }
 }
