//
//  SIFRoundIconDetectorConfiguration.swift
//  SIFTool
//
//  Created by CmST0us on 2018/2/21.
//  Copyright © 2018年 eki. All rights reserved.
//

import Foundation
struct SIFRoundIconDetectorConfiguration {
    var patternWidth = 1
    var patternHeight = 1
    
    var patternLeft = 1
    var patternRight = 1
    var patternTop = 1
    var patternBottom = 1
    
    static var defaultRoundIconConfiguration: SIFRoundIconDetectorConfiguration {
        return defaultRoundIconConfiguration(ratio: 1)
    }
    
    static func defaultRoundIconConfiguration(ratio: Double) -> SIFRoundIconDetectorConfiguration {
        return SIFRoundIconDetectorConfiguration.init(patternWidth: Int(80.0 * ratio), patternHeight: Int(80.0 * ratio), patternLeft: Int(15.0 * ratio), patternRight: Int(17.0 * ratio), patternTop: Int(16.0 * ratio), patternBottom: Int(15.0 * ratio))
    }
    
    static func advanceRoundIconConfiguration(ratio: Double) -> SIFRoundIconDetectorConfiguration {
        return SIFRoundIconDetectorConfiguration.init(patternWidth: Int(120.0 * ratio), patternHeight: Int(120.0 * ratio), patternLeft: Int(20.0 * ratio), patternRight: Int(20.0 * ratio), patternTop: Int(20.0 * ratio), patternBottom: Int(20.0 * ratio))
    }
    
    var patternSize: CGSize {
        return CGSize.init(width: patternWidth, height: patternHeight)
    }
    var patternRealSize: CGSize {
        return CGSize.init(width: patternRealWidth, height: patternRealHeight)
    }
    
    var patternRealWidth: Int {
        return patternWidth - patternLeft - patternRight
    }
    
    var patternRealHeight: Int {
        return patternHeight - patternTop - patternBottom
    }
    
    var patternRealRect: CGRect {
        return CGRect.init(x: CGFloat(patternLeft), y: CGFloat(patternTop), width: CGFloat(patternRealWidth), height: CGFloat(patternRealHeight))
    }
    
    var templateRealRect: CGRect {
        var templateRoiRect = self.patternRealRect
        templateRoiRect.origin.x += 3
        templateRoiRect.origin.y += 3
        templateRoiRect.size.width -= 3
        templateRoiRect.size.height -= 3
        return templateRoiRect
    }
}
