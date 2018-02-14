//
//  ApiHelperTest.swift
//  ApiHelperTest
//
//  Created by CmST0us on 2018/1/2.
//  Copyright © 2018年 eki. All rights reserved.
//

import XCTest

class ApiHelperTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        ApiHelper.shared.baseUrlPath = "http://127.0.0.1:3000/api/v1"
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetPageWithSimple() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    
        do {
            let param = InfoDataModel.requestPageApiRequestParam(pageNum: 1, simpleMode: true)
            let data = try ApiHelper.shared.request(withParam: param)
            if let dict = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                for o in dict {
                    let i = InfoDataModel(dictionary: o)
                    print(i)
                }
                return
            }
        } catch let error as ApiRequestError {
            print(error.message)
        } catch {
            print(error.localizedDescription)
        }
        XCTFail()
    }
    
    func testGetPageWithoutSimple() {
        
        do {
            let param = InfoDataModel.requestPageApiRequestParam(pageNum: 1, simpleMode: false)
            let data = try ApiHelper.shared.request(withParam: param)
            if let dict = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                for o in dict {
                    let i = InfoDataModel(dictionary: o)
                    print(i)
                }
                return
            }
        } catch let error as ApiRequestError {
            print(error.message)
        } catch {
            print(error.localizedDescription)
        }
        XCTFail()

    }
    
    func testGetPageOverRange() {
        do {
            let param = InfoDataModel.requestPageApiRequestParam(pageNum: 999, simpleMode: false)
            let data = try ApiHelper.shared.request(withParam: param)
            if let dict = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                for o in dict {
                    let i = InfoDataModel(dictionary: o)
                    print(i)
                    XCTFail()
                }
                return
            }
        } catch let error as ApiRequestError {
            print(error.message)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func testGetInfoNewest() {
        
        do {
            let param = InfoDataModel.requestNewestInfoApiRequestParam(simpleMode: false)
            let data = try ApiHelper.shared.request(withParam: param)
            if let dict = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                for o in dict {
                    let m = InfoDataModel(dictionary: o)
                    if m.contentHtml == nil {
                        XCTFail()
                    }
                    return
                }
            }
        } catch let error as ApiRequestError {
            print(error.message)
        } catch {
            print(error.localizedDescription)
        }
        do {
            let param = InfoDataModel.requestNewestInfoApiRequestParam(simpleMode: true)
            let data = try ApiHelper.shared.request(withParam: param)
            if let dict = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                for o in dict {
                    let m = InfoDataModel(dictionary: o)
                    if m.contentHtml != nil {
                        XCTFail()
                    }
                    return
                }
            }
        } catch let error as ApiRequestError {
            print(error.message)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func testGetInfoBeforeTime() {
        do {
            let param = InfoDataModel.requestInfomationApiRequestParam(beforeTimeInterval: Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970, simpleMode: false)
            let data = try ApiHelper.shared.request(withParam: param)
            if let dict = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                for o in dict {
                    let _ = InfoDataModel(dictionary: o)
                    return
                }
                XCTFail()
            }
        } catch let error as ApiRequestError {
            print(error.message)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func testGetInfoWithId() {
        do {
            let param = InfoDataModel.requestInfomationApiRequestParam(withId: "")
            let data = try ApiHelper.shared.request(withParam: param)
            if let dict = DataModelHelper.shared.payloadDictionaries(withJsonData: data), dict.count == 1 {
                for o in dict {
                    let _ = InfoDataModel(dictionary: o)
                    return
                }
            }
        } catch let error as ApiRequestError {
            print(error.message)
        } catch {
            print(error.localizedDescription)
        }
        XCTFail()
    }
    
    func testGetOfficialNewsWithPage() {
        do {
            let param = OfficialNewsDataModel.requestPageApiRequestParam(pageNum: 1, simpleMode: true)
            let data = try ApiHelper.shared.request(withParam: param)
            if let dict = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                for o in dict {
                    let i = InfoDataModel(dictionary: o)
                    print(i)
                }
            }
        } catch let error as ApiRequestError {
            print(error.message)
        } catch {
            print(error.localizedDescription)
        }
        
        do {
            let param = OfficialNewsDataModel.requestPageApiRequestParam(pageNum: 1, simpleMode: false)
            let data = try ApiHelper.shared.request(withParam: param)
            if let dict = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                for o in dict {
                    let i = InfoDataModel(dictionary: o)
                    print(i)
                }
                return
            }
        } catch let error as ApiRequestError {
            print(error.message)
        } catch {
            print(error.localizedDescription)
        }
        XCTFail()
    }
    
    func testGetOfficialNewsWithId() {
        do {
            let param = OfficialNewsDataModel.requestInfomationApiRequestParam(withId: "")
            let data = try ApiHelper.shared.request(withParam: param)
            if let dict = DataModelHelper.shared.payloadDictionaries(withJsonData: data), dict.count == 1 {
                for o in dict {
                    let _ = InfoDataModel(dictionary: o)
                    return
                }
            }
        } catch let error as ApiRequestError {
            print(error.message)
        } catch {
            print(error.localizedDescription)
        }
        XCTFail()
    }
    
    func testGetOfficialNewsNewest() {
        do {
            let param = OfficialNewsDataModel.requestNewestInfoApiRequestParam(simpleMode: false)
            let data = try ApiHelper.shared.request(withParam: param)
            if let dict = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                for o in dict {
                    let m = InfoDataModel(dictionary: o)
                    if m.contentHtml == nil {
                        XCTFail()
                    }
                    return
                }
            }
        } catch let error as ApiRequestError {
            print(error.message)
        } catch {
            print(error.localizedDescription)
        }
        do {
            let param = OfficialNewsDataModel.requestNewestInfoApiRequestParam(simpleMode: true)
            let data = try ApiHelper.shared.request(withParam: param)
            if let dict = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                for o in dict {
                    let m = InfoDataModel(dictionary: o)
                    if m.contentHtml != nil {
                        XCTFail()
                    }
                    return
                }
            }
        } catch let error as ApiRequestError {
            print(error.message)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func testGetOfficialNewsBeforTime() {
        do {
            let param = OfficialNewsDataModel.requestInfomationApiRequestParam(beforeTimeInterval: Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970, simpleMode: false)
            let data = try ApiHelper.shared.request(withParam: param)
            if let dict = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                for o in dict {
                    let _ = InfoDataModel(dictionary: o)
                    return
                }
                XCTFail()
            }
        } catch let error as ApiRequestError {
            print(error.message)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func testAppNewestVersion() {
        if let data = ApiHelper.shared.getAppNewestVersion() {
            if let dict = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                let m = AppVersionUpdateDataModel(dictionary: dict[0])
                print(m.version!)
                print(m.message!)
                return
            }
        }
        XCTFail()
    }
    
    //[TODO]
    func testSearchInfoOrOfficial() {
        
    }
    
    //[TODO]
    func testPostDevicePushToken() {
        
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
