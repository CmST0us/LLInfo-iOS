//
//  InfoDataModelTest.swift
//  ApiHelperTest
//
//  Created by CmST0us on 2018/1/3.
//  Copyright © 2018年 eki. All rights reserved.
//

import XCTest

class InfoDataModelTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ApiHelper.shared.baseUrlPath = "http://127.0.0.1:3000/api/v1"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInfoDataModelInit() {
        if let d = ApiHelper.shared.getNewestInfo(false) {
            if let j = DataModelHelper.shared.createDictionaries(withJsonData: d) {
                XCTAssert(j.count > 0)
                
                for o in j {
                    let m = InfoDataModel(dictionary: o)
                    print(m)
                }
                return
            } else {
                XCTFail()
            }
        }
    }
    func testOrderSet() {
        let dict = [
            "url": "http://www.baidu.com",
            "title": "foo"
        ]
        
        let dict2 = [
            "url": "http://www.baidu.com",
            "title": "bar"
        ]
        
        let m1 = InfoDataModel(dictionary: dict)
        let m2 = InfoDataModel(dictionary: dict2)
        
        let os = NSMutableOrderedSet()
        os.insert(m1, at: 0)
        os.insert(m2, at: 0)
        if os.count == 1 {
            return
        }
        XCTFail()
    }
    
    func testIsInfoEqual() {
        let dict = [
            "url": "http://www.baidu.com",
            "title": "foo"
        ]
        
        let dict2 = [
            "url": "http://www.baidu.com",
        ]
        
        let m1 = InfoDataModel(dictionary: dict)
        let m2 = InfoDataModel(dictionary: dict2)
        
        if m1 == m2 {
            return
        }
        XCTFail()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
