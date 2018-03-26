//
//  Favorite+CoreDataProperties.swift
//  LLInfo
//
//  Created by CmST0us on 2018/2/6.
//  Copyright © 2018年 eki. All rights reserved.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: entiryName)
    }

    @NSManaged public var url: String?
    @NSManaged public var type: String?

}
