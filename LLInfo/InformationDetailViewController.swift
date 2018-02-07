//
//  InfoDetailViewController.swift
//  LLInfo
//
//  Created by CmST0us on 2017/12/29.
//  Copyright © 2017年 eki. All rights reserved.
//

import UIKit
import WebKit
import SafariServices
import SnapKit
import MobileCoreServices

class InformationDetailViewController: UIViewController{
    
    var informationDataModel: InformationDataModel? = nil
    var wkView: WKWebView!
    var sharedUrl: String = ""
    
    @IBAction func showMore(_ sender: Any) {
        let moreSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let openInformationSourceUrlAction = UIAlertAction(title: "打开来源", style: .default) { (alertAction) in
            if let urlPath = self.informationDataModel?.urlPath {
               self.showUrlInSafariViewController(url: URL(string: urlPath))
            }
        }
        
        let systemShare = UIAlertAction(title: "分享...", style: .default) { (alertAction) in
            
            if let url = URL(string: self.sharedUrl) {
                let ac = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                ac.excludedActivityTypes = [.openInIBooks, .print, .copyToPasteboard]
                if let popover = ac.popoverPresentationController {
                    popover.barButtonItem = sender as? UIBarButtonItem
                    popover.permittedArrowDirections = UIPopoverArrowDirection.up
                }
                self.present(ac, animated: true, completion: nil)
            }
            
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        moreSheet.addAction(openInformationSourceUrlAction)
        moreSheet.addAction(systemShare)
        moreSheet.addAction(cancel)
        if let popover = moreSheet.popoverPresentationController {
            popover.barButtonItem = sender as? UIBarButtonItem
            popover.permittedArrowDirections = UIPopoverArrowDirection.up
        }
        self.present(moreSheet, animated: true, completion: nil)
    }
    //MARK: - Private Method
    private func setupWebView() {
        let configure = WKWebViewConfiguration()
        configure.allowsInlineMediaPlayback = true
        wkView = WKWebView(frame: .zero, configuration: configure)
        wkView.contentMode = .scaleAspectFit
        wkView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(wkView)
        
        self.wkView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }

        self.wkView.uiDelegate = self
        self.wkView.navigationDelegate = self
    }
    
    private func loadHtml() {
        if let model = self.informationDataModel {
            self.title = model.title
            if let html = model.contentHtml {
                self.wkView.loadHTMLString(html, baseURL: nil)
            }
        }
    }
    
    // MARK: - Public method
    
    /// setup InformationDetailViewController with model
    /// this method will request server if network is reachable. Or it will fetch database. When it download data from server it will update data in database
    /// - Parameter model: model is subclass of InformationDataModel, InformationApiParamProtocol, CoreDataModelBridgeProtocol
    func setup<T>(withInformationDataModel model: T) where T: InformationDataModel, T: InformationApiParamProtocol, T: CoreDataModelBridgeProtocol, T:InformationShareableProtocol {
    
        do {
            let param = T.requestInfomationApiParam(withId: model.id)
            let data = try ApiHelper.shared.request(withParam: param)
            if let dicts = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                let m = T(dictionary: dicts[0])
                self.informationDataModel = m
                self.sharedUrl = ApiHelper.shared.baseUrlPath + m.sharedUrl
                print(m.id)
                if let contentHtml = m.contentHtml {
                    let _ = InformationCacheHelper.shared.updata(information: m, usingId: m.id, updateValuesAndKeys: [T.CodingKey.contentHtml: contentHtml])
                    try InformationCoreDataHelper.shared.saveContext()
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
    
    func showUrlInSafariViewController(url: URL?) {
        if let u = url {
            let s = SFSafariViewController(url: u)
            if #available(iOS 11.0, *) {
                s.dismissButtonStyle = .close
            } else {
                // Fallback on earlier versions
            }
            self.present(s, animated: true, completion: nil)
        }
    }
}


// MARK: - View life cycle method
extension InformationDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView()
        self.loadHtml()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - WebKit delegate method
extension InformationDetailViewController: WKUIDelegate, WKNavigationDelegate  {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if navigationResponse.isForMainFrame {
            decisionHandler(.cancel)
            self.showUrlInSafariViewController(url: navigationResponse.response.url)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

        if navigationAction.navigationType != .linkActivated {
            return nil
        }
        self.showUrlInSafariViewController(url: navigationAction.request.url)
        return nil

    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .other {
            decisionHandler(.allow)
            return
        }
        
        if navigationAction.navigationType == .linkActivated {
            decisionHandler(.cancel)
            self.showUrlInSafariViewController(url: navigationAction.request.url)
            return
        }
        decisionHandler(.cancel)
        
    }
    
}
