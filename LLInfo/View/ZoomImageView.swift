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
        Logger.shared.console("Tap")
        self.removeFromSuperview()
    }
    
    @objc
    func onLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else {
            return
        }
        Logger.shared.console("LongPress")
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
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.delegate = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        longPress.delegate = self
        
        self.addGestureRecognizer(tap)
        self.addGestureRecognizer(longPress)
    }
    
    @objc
    private func setupImageViewFrame() {
        let screenRatio = self.bounds.size.width / self.bounds.size.height
        let imageRatio = imageView.image!.size.width / imageView.image!.size.height
        imageView.center = self.center
        if  imageRatio > screenRatio {
            imageView.frame.size.width = self.bounds.size.width
            imageView.frame.size.height = imageView.frame.width * (imageView.image!.size.height / imageView.image!.size.width)
        } else {
            imageView.frame.size.height = self.bounds.size.height
            imageView.frame.size.width = imageView.frame.height * (imageView.image!.size.width / imageView.image!.size.height)
        }
    }
    

    override func layoutSubviews() {
        if self.zoomScale == 1 {
            setupImageViewFrame()
        }
    }
    
    private func setupImageView() {
        self.addSubview(imageView)
    }
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            self.backgroundColor = UIColor.black
            
            guard self.imageView.image != nil else {
                return
            }
            
            self.maximumZoomScale = 2.0
            self.minimumZoomScale = 1.0
            self.bounds.origin = CGPoint.zero
            self.showsVerticalScrollIndicator = false
            self.showsHorizontalScrollIndicator = false
            self.delegate = self
            
            setupGesture()
            setupImageView()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if let previous = previousTraitCollection, previous.horizontalSizeClass != .unspecified || previous.verticalSizeClass != .unspecified {
            self.setupImageViewFrame()
        }
    }
    
}

extension ZoomImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let xcenter = scrollView.contentSize.width > scrollView.bounds.size.width ? scrollView.contentSize.width / 2 : scrollView.center.x
        let ycenter = scrollView.contentSize.height > scrollView.bounds.size.height ? scrollView.contentSize.height / 2 : scrollView.center.y
        
        imageView.center = CGPoint.init(x: xcenter, y: ycenter)
    }
}

extension ZoomImageView: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer && !isDecelerating{
            return true
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}
