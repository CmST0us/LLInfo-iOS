//
//  ApiHelper.swift
//  LLInfo
//
//  Created by CmST0us on 2018/1/2.
//  Copyright © 2018年 eki. All rights reserved.
//

import Foundation

struct ApiRequestError: Error {
    enum ErrorCode {
        case badUrl
        case requestTimeout
        case notInitial
        
    }
    
    var code: ErrorCode = .notInitial
    var message = ""
}

final class ApiHelper {
    //MARK: - Private Member
    private lazy var _baseUrlPath: String = {
        return baseUrlPath
    }()
    
    //MARK: - Private Method
    private init() {
        
    }
    
    //MARK: - Public Member
    //MARK: Single Instance
    static let shared = ApiHelper()
    //api base url
    var baseUrlPath: String = ""
    
    //last invoke error
    var lastInvokeError: Error? = nil
    
    //request task wait time
    var taskWaitTime: Int = 4
    
    //MARK: - Public Method
    
    //app newest ver
    func getAppNewestVersion() -> Data? {
        let requestPath = _baseUrlPath + "/app/ios/version"
        let url = URL(string: requestPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let connectionSession = URLSession(configuration: .default)
        let sem = DispatchSemaphore(value: 0)
        var retData: Data? = nil
        let task = connectionSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                self.lastInvokeError = error
                return
            } else {
                self.lastInvokeError = nil
            }
            retData = data
            sem.signal()
        })
        task.resume()
        let waitTime = DispatchTime.now() + DispatchTimeInterval.seconds(taskWaitTime)
        let _ = sem.wait(timeout: waitTime)
        task.suspend()
        return retData
    }
    
    //
    func getInfoPage(_ pageNum:Int, _ simpleMode: Bool) -> Data? {
        var requestPath = _baseUrlPath + "/info/page/\(pageNum)" 
        if simpleMode {
            requestPath += "?simple=1"
        }
        let url = URL(string: requestPath)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let connectionSession = URLSession(configuration: .default)
        let sem = DispatchSemaphore(value: 0)
        var retData: Data? = nil
        
        let task = connectionSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                self.lastInvokeError = error
                return
            } else {
                self.lastInvokeError = nil
            }
            retData = data
            sem.signal()
        })
        task.resume()
        let waitTime = DispatchTime.now() + DispatchTimeInterval.seconds(taskWaitTime)
        let _ = sem.wait(timeout: waitTime)
        task.suspend()
        return retData
    }
    
    //Get newest info
    func getNewestInfo(_ simpleMode: Bool) -> Data? {
        var requestPath = _baseUrlPath + "/info/item"
        if simpleMode {
            requestPath += "?simple=1"
        }
        
        let url = URL(string: requestPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let connectionSession = URLSession(configuration: .default)
        let sem = DispatchSemaphore(value: 0)
        var retData: Data? = nil
        
        let task = connectionSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                self.lastInvokeError = error
                return
            } else {
                self.lastInvokeError = nil
            }
            retData = data
            sem.signal()
        })
        task.resume()
        let waitTime = DispatchTime.now() + DispatchTimeInterval.seconds(taskWaitTime)
        let _ = sem.wait(timeout: waitTime)
        task.suspend()
        return retData
    }
    
    //Get infos between time range
    func getInfo(atTimeIntervalRange range: NSRange, _ simpleMode: Bool) -> Data? {
        var requestPath = _baseUrlPath + "/info/item"

        let afterTime = range.location
        let beforeTime = range.location + range.length
        
        requestPath += "?after=\(afterTime)&before=\(beforeTime)"
        
        if simpleMode {
            requestPath += "&simple=1"
        }
        let url = URL(string: requestPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let connectionSession = URLSession(configuration: .default)
        let sem = DispatchSemaphore(value: 0)
        var retData: Data? = nil
        
        let task = connectionSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                self.lastInvokeError = error
                return
            } else {
                self.lastInvokeError = nil
            }
            retData = data
            sem.signal()
        })
        task.resume()
        let waitTime = DispatchTime.now() + DispatchTimeInterval.seconds(taskWaitTime)
        let _ = sem.wait(timeout: waitTime)
        task.suspend()
        return retData
    }
    
    func getInfo(beforeTimeInterval: TimeInterval, _ simpleMode: Bool) -> Data? {
        var requestPath = _baseUrlPath + "/info/item"
        
        let beforeTime = Int(beforeTimeInterval)
        
        requestPath += "?before=\(beforeTime)"
        if simpleMode {
            requestPath += "&simple=1"
        }
        
        let url = URL(string: requestPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let connectionSession = URLSession(configuration: .default)
        let sem = DispatchSemaphore(value: 0)
        var retData: Data? = nil
        
        let task = connectionSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                self.lastInvokeError = error
                return
            } else {
                self.lastInvokeError = nil
            }
            retData = data
            sem.signal()
        })
        task.resume()
        let waitTime = DispatchTime.now() + DispatchTimeInterval.seconds(taskWaitTime)
        let _ = sem.wait(timeout: waitTime)
        task.suspend()
        return retData
    }
    
    func getInfo(afterTimeInterval: TimeInterval, _ simpleMode: Bool) -> Data? {
        var requestPath = _baseUrlPath + "/info/item"
        
        let afterTime = Int(afterTimeInterval)
        
        requestPath += "?after=\(afterTime)"
        if simpleMode {
            requestPath += "&simple=1"
        }
        let url = URL(string: requestPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let connectionSession = URLSession(configuration: .default)
        let sem = DispatchSemaphore(value: 0)
        var retData: Data? = nil
        
        let task = connectionSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                self.lastInvokeError = error
                return
            } else {
                self.lastInvokeError = nil
            }
            retData = data
            sem.signal()
        })
        task.resume()
        let waitTime = DispatchTime.now() + DispatchTimeInterval.seconds(taskWaitTime)
        let _ = sem.wait(timeout: waitTime)
        task.suspend()
        return retData
    }
    
    func getInfo(withId id: String) -> Data? {
        let requestPath = _baseUrlPath + "/info/item/\(id)"

        let url = URL(string: requestPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let connectionSession = URLSession(configuration: .default)
        let sem = DispatchSemaphore(value: 0)
        var retData: Data? = nil
        
        let task = connectionSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                self.lastInvokeError = error
                return
            } else {
                self.lastInvokeError = nil
            }
            retData = data
            sem.signal()
        })
        task.resume()
        let waitTime = DispatchTime.now() + DispatchTimeInterval.seconds(taskWaitTime)
        let _ = sem.wait(timeout: waitTime)
        task.suspend()
        return retData
    }
    
    func getOfficialNews(withId id:String) -> Data? {
        let requestPath = _baseUrlPath + "/official/news/item/\(id)"
        
        let url = URL(string: requestPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let connectionSession = URLSession(configuration: .default)
        let sem = DispatchSemaphore(value: 0)
        var retData: Data? = nil
        
        let task = connectionSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                self.lastInvokeError = error
                return
            } else {
                self.lastInvokeError = nil
            }
            retData = data
            sem.signal()
        })
        task.resume()
        let waitTime = DispatchTime.now() + DispatchTimeInterval.seconds(taskWaitTime)
        let _ = sem.wait(timeout: waitTime)
        task.suspend()
        return retData
    }
    
    func getOfficialNewsPage(_ pageNum:Int, _ simpleMode: Bool) -> Data? {
        var requestPath = _baseUrlPath + "/official/news/page/\(pageNum)"
        if simpleMode {
            requestPath += "?simple=1"
        }
        let url = URL(string: requestPath)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let connectionSession = URLSession(configuration: .default)
        let sem = DispatchSemaphore(value: 0)
        var retData: Data? = nil
        
        let task = connectionSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                self.lastInvokeError = error
                return
            } else {
                self.lastInvokeError = nil
            }
            retData = data
            sem.signal()
        })
        task.resume()
        let waitTime = DispatchTime.now() + DispatchTimeInterval.seconds(taskWaitTime)
        let _ = sem.wait(timeout: waitTime)
        task.suspend()
        return retData
    }
    
    func getNewestOfficialNews(_ simpleMode: Bool) -> Data? {
        var requestPath = _baseUrlPath + "/official/news/item"
        if simpleMode {
            requestPath += "?simple=1"
        }
        
        let url = URL(string: requestPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let connectionSession = URLSession(configuration: .default)
        let sem = DispatchSemaphore(value: 0)
        var retData: Data? = nil
        
        let task = connectionSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                self.lastInvokeError = error
                return
            } else {
                self.lastInvokeError = nil
            }
            retData = data
            sem.signal()
        })
        task.resume()
        let waitTime = DispatchTime.now() + DispatchTimeInterval.seconds(taskWaitTime)
        let _ = sem.wait(timeout: waitTime)
        task.suspend()
        return retData
    }
    
    func getOfficialNews(atTimeIntervalRange range: NSRange, _ simpleMode: Bool) -> Data? {
        var requestPath = _baseUrlPath + "/official/news/item"
        
        let afterTime = range.location
        let beforeTime = range.location + range.length
        
        requestPath += "?after=\(afterTime)&before=\(beforeTime)"
        
        if simpleMode {
            requestPath += "&simple=1"
        }
        let url = URL(string: requestPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let connectionSession = URLSession(configuration: .default)
        let sem = DispatchSemaphore(value: 0)
        var retData: Data? = nil
        
        let task = connectionSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                self.lastInvokeError = error
                return
            } else {
                self.lastInvokeError = nil
            }
            retData = data
            sem.signal()
        })
        task.resume()
        let waitTime = DispatchTime.now() + DispatchTimeInterval.seconds(taskWaitTime)
        let _ = sem.wait(timeout: waitTime)
        task.suspend()
        return retData
    }
    
    func getOfficialNews(beforeTimeInterval: TimeInterval, _ simpleMode: Bool) -> Data? {
        var requestPath = _baseUrlPath + "/official/news/item"
        
        let beforeTime = Int(beforeTimeInterval)
        
        requestPath += "?before=\(beforeTime)"
        if simpleMode {
            requestPath += "&simple=1"
        }
        
        let url = URL(string: requestPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let connectionSession = URLSession(configuration: .default)
        let sem = DispatchSemaphore(value: 0)
        var retData: Data? = nil
        
        let task = connectionSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                self.lastInvokeError = error
                return
            } else {
                self.lastInvokeError = nil
            }
            retData = data
            sem.signal()
        })
        task.resume()
        let waitTime = DispatchTime.now() + DispatchTimeInterval.seconds(taskWaitTime)
        let _ = sem.wait(timeout: waitTime)
        task.suspend()
        return retData
    }
    
    func getOfficialNews(afterTimeInterval: TimeInterval, _ simpleMode: Bool) -> Data? {
        var requestPath = _baseUrlPath + "/official/news/item"
        
        let afterTime = Int(afterTimeInterval)
        
        requestPath += "?after=\(afterTime)"
        if simpleMode {
            requestPath += "&simple=1"
        }
        let url = URL(string: requestPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let connectionSession = URLSession(configuration: .default)
        let sem = DispatchSemaphore(value: 0)
        var retData: Data? = nil
        
        let task = connectionSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                self.lastInvokeError = error
                return
            } else {
                self.lastInvokeError = nil
            }
            retData = data
            sem.signal()
        })
        task.resume()
        let waitTime = DispatchTime.now() + DispatchTimeInterval.seconds(taskWaitTime)
        let _ = sem.wait(timeout: waitTime)
        task.suspend()
        return retData
    }
}


//MARK: - NEW DESIGN
extension ApiHelper {
    func request(withParam param: ApiParam) throws -> Data {
        var requestPath = _baseUrlPath + param.path
        
        if param.query.count > 0 {
            requestPath += ("?" + param.query.urlQueryString())
        }
        
        if let url = URL(string: requestPath) {
            var request = URLRequest(url: url)
            request.httpMethod = param.method
            let connectionSession = URLSession(configuration: .default)
            let sem = DispatchSemaphore(value: 0)
            var retData: Data? = nil
            
            let task = connectionSession.dataTask(with: request, completionHandler: { (data, response, error) in
                retData = data
                sem.signal()
            })
            task.resume()
            let waitTime = DispatchTime.now() + DispatchTimeInterval.seconds(taskWaitTime)
            let _ = sem.wait(timeout: waitTime)
            task.suspend()
            
            if retData == nil {
                throw ApiRequestError(code: .requestTimeout, message: "请求超时")
            } else {
                return retData!
            }
            
        } else {
            throw ApiRequestError(code: .badUrl, message: "URL 格式错误")
        }
    }
}
