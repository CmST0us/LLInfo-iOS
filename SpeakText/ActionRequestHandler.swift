//
//  ActionRequestHandler.swift
//  SpeakText
//
//  Created by CmST0us on 2018/2/5.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
class ActionRequestHandler: NSObject, NSExtensionRequestHandling {

    var extensionContext: NSExtensionContext?
    
    func beginRequest(with context: NSExtensionContext) {
        // Do not call super in an Action extension with no user interface
        self.extensionContext = context
        
        var found = false
        
        // Find the item containing the results from the JavaScript preprocessing.
        outer:
            for item in context.inputItems as! [NSExtensionItem] {
                if let attachments = item.attachments {
                    for itemProvider in attachments as! [NSItemProvider] {
                        if itemProvider.hasItemConformingToTypeIdentifier(String(kUTTypeText)) {
                            itemProvider.loadItem(forTypeIdentifier: String(kUTTypeText), options: nil, completionHandler: { (item, error) in
                                let text = item as! String
                                OperationQueue.main.addOperation {
                                    TextSpeaker(delegate: self).speak(text: text, language: "ja")
                                }
                            })
                            found = true
                            break outer
                        }
                    }
                }
        }
        
        if !found {
            self.doneWithResults()
        }
    }
    
    func doneWithResults() {
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        self.extensionContext = nil
    }

}
extension ActionRequestHandler: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.doneWithResults()
    }
}
