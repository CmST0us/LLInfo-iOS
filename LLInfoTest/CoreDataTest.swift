//
//  CoreDataTest.swift
//  LLInfoTest
//
//  Created by CmST0us on 2018/1/7.
//  Copyright © 2018年 eki. All rights reserved.
//

import XCTest
import CoreData

class CoreDataTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        ApiHelper.shared.baseUrlPath = "http://127.0.0.1:3000/api/v1"
        print(Bundle.main.bundlePath)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testLazyInitPersistentContainer() {
        do {
            try CoreDataHelper.shared.saveContext()
        } catch {
            XCTFail()
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
