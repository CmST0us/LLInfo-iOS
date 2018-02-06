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
import CoreMotion

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {
    
    lazy var motionManager: CMMotionManager? = {
        let m = CMMotionManager()
        if m.isAccelerometerAvailable == false {
            return nil
        }
        m.accelerometerUpdateInterval = 0.3
        return m
    }()
    
    var extensionContext: NSExtensionContext?
    var speaker: TextSpeaker? = nil
    
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
                                    self.speaker = TextSpeaker(delegate: self)
                                    self.speaker!.speak(text: text, language: "ja")
                                    self.startUpdateMotion(completionHandler: { (data, error) in
                                        if let _ = error {
                                            return
                                        }
                                        if let d = data {
                                            //综合3个方向的加速度
                                            let accelerameter = sqrt( pow( d.acceleration.x , 2 ) + pow( d.acceleration.y , 2 )
                                                + pow( d.acceleration.z , 2) );
                                            //当综合加速度大于2.3时，就激活效果（此数值根据需求可以调整，数据越小，用户摇动的动作就越小，越容易激活，反之加大难度，但不容易误触发）
                                            if (accelerameter > 2.0) {
                                                //立即停止更新加速仪（很重要！）
                                                OperationQueue.main.addOperation {
                                                    self.motionManager?.stopAccelerometerUpdates()
                                                    self.doneWithResults()
                                                }
                                            }
                                        }
                                    })
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
        self.speaker?.stop()
        self.motionManager = nil
        self.extensionContext = nil
    }

}
extension ActionRequestHandler: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.doneWithResults()
    }
}

extension ActionRequestHandler {
    func startUpdateMotion(completionHandler: @escaping((CMAccelerometerData?, Error?) -> Void)) {
        self.motionManager?.startAccelerometerUpdates(to: OperationQueue.init(), withHandler: { (data, error) in
            completionHandler(data, error)
        })
    }
}
