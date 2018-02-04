//
//  InfoDetailViewController.swift
//  LLInfo
//
//  Created by CmST0us on 2017/12/29.
//  Copyright © 2017年 eki. All rights reserved.
//

import UIKit
import WebKit

class InformationDetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate{
    //MARK: - Data Model
    var informationDataModel: InformationDataModel? = nil
    //MARK: - Outlet
    var wkView: WKWebView!
    
    //MARK: - Private Method
    private func setupWebView() {
        wkView = WKWebView()
        wkView.contentMode = .scaleAspectFit
        wkView.translatesAutoresizingMaskIntoConstraints = false
    
        self.view.addSubview(wkView)
        
        NSLayoutConstraint(item: wkView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: wkView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: wkView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: wkView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0).isActive = true

        self.wkView.uiDelegate = self
        self.wkView.navigationDelegate = self
        
    }
    
    func loadHtml() {
        if let model = self.informationDataModel {
            self.title = model.title
            if let html = model.contentHtml {
                self.wkView.loadHTMLString(html, baseURL: nil)
            }
        }
    }
    
    
    /// setup InformationDetailViewController with model
    /// this method will request server if network is reachable. Or it will fetch database. When it download data from server it will update data in database
    /// - Parameter model: model is subclass of InformationDataModel, InformationApiParamProtocol, CoreDataModelBridgeProtocol
    func setup<T>(withInformationDataModel model: T) where T: InformationDataModel, T: InformationApiParamProtocol, T: CoreDataModelBridgeProtocol {
    
        do {
            let param = T.requestInfomationApiParam(withId: model.id)
            let data = try ApiHelper.shared.request(withParam: param)
            if let dicts = DataModelHelper.shared.createDictionaries(withJsonData: data) {
                let m = T(dictionary: dicts[0])
                self.informationDataModel = m
                print(m.id)
                if let contentHtml = m.contentHtml {
                    let _ = InformationCacheHelper.shared.updata(information: m, usingId: m.id, updateValuesAndKeys: [T.CodingKey.contentHtml: contentHtml])
                    try CoreDataHelper.shared.saveContext()
                    return
                }
            }
        } catch {
            
        }
        // fetch from database
        do {
            if let set: Set<T> = try InformationCacheHelper.shared.requestInfomation(withId: model.id) {
                let m = set.first!
                self.informationDataModel = m
            }
        } catch {
            
        }
    }
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView()
        self.loadHtml()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - WebView Nav Delegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if navigationResponse.isForMainFrame == true {
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

