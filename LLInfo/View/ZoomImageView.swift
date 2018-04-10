//
//  ZoomImageView.swift
//  LLInfo
//
//  Created by CmST0us on 2018/4/10.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit
import SnapKit

class ZoomImageView: UIScrollView {

    var imageView: UIImageView = UIImageView()
    var saveImageActionSheetShowBlock: ((_ actionSheet: UIAlertController) -> Void)? = nil
    
    @objc
    func onTap() {
        self.removeFromSuperview()
    }
    
    @objc
    func onLongPress() {
        
        let actionSheet = UIAlertController(title: "保存图片", message: nil, preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: "保存", style: .default) { (action) in
            guard self.imageView.image != nil else {
                return
            }
            UIImageWriteToSavedPhotosAlbum(self.imageView.image!, nil, nil, nil)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        actionSheet.addAction(saveAction)
        actionSheet.addAction(cancelAction)
        if let pc = actionSheet.popoverPresentationController {
            pc.permittedArrowDirections = .any
            pc.sourceView = self
        }
        
        if let block = saveImageActionSheetShowBlock {
            block(actionSheet)
        }
        
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        
        self.addGestureRecognizer(tap)
        self.addGestureRecognizer(longPress)
    }
    
    private func setupImageView() {
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            let screenRadio = self.bounds.size.width / self.bounds.size.height
            let imageRadio = imageView.image!.size.width / imageView.image!.size.height
            if  imageRadio > screenRadio {
                make.width.equalToSuperview()
                make.height.equalTo(imageView.snp.width).multipliedBy(imageView.image!.size.height / imageView.image!.size.width)
            } else {
                make.height.equalToSuperview()
                make.width.equalTo(imageView.snp.height).multipliedBy(imageView.image!.size.width / imageView.image!.size.height)
            }
        }
        
    }
    
    override func layoutSubviews() {
        self.backgroundColor = UIColor.black
        
        guard self.imageView.image != nil else {
            return
        }
        
//        self.contentSize = self.imageView.image!.size
        self.maximumZoomScale = 2
        self.minimumZoomScale = 0.8
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.delegate = self
        setupGesture()
        setupImageView()
    }

}

extension ZoomImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
