//
//  TapToZoomImageView.swift
//  LLInfo
//
//  Created by CmST0us on 2018/4/10.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit
import SnapKit

class TapToZoomImageView: UIImageView {
    
    var zoomImageView: ZoomImageView!
    var tapImageViewBlock: ((_ sender: TapToZoomImageView) -> Void)? = nil
    
    @objc
    func onTapImageView() {
        showZoomImageView()
        if let block = tapImageViewBlock {
            block(self)
        }
    }
    
    override func layoutSubviews() {
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(onTapImageView))
        self.addGestureRecognizer(tapGesture)
    }
    
    private func showZoomImageView() {
        zoomImageView = ZoomImageView()
        zoomImageView.imageView.image = self.image
        if let window = UIApplication.shared.keyWindow?.subviews.last {
            window.addSubview(zoomImageView)
            zoomImageView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
}
