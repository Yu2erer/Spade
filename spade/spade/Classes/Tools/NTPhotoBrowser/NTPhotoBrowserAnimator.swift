//
//  NTPhotoBrowserAnimator.swift
//  NTPhotoBrowser
//
//  Created by ntian on 2017/6/14.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import Kingfisher

class NTPhotoBrowserAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var fromImageView: UIImageView?
    fileprivate var isPresenting = false
    fileprivate var photos: NTPhotoBrowserPhotos!
    
    init(photos: NTPhotoBrowserPhotos) {
        super.init()
        self.photos = photos
    }
}
// MARK: - 转场动画
extension NTPhotoBrowserAnimator {
    // 进入转场
    func presentTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let dummyIv = self.dummyImageView()
        let parentIv = self.parentImageView()
        dummyIv.frame = containerView.convert(parentIv.frame, from: parentIv.superview)
        containerView.addSubview(dummyIv)
        let toView = transitionContext.view(forKey: .to)
        containerView.addSubview(toView!)
        containerView.backgroundColor = UIColor.black
        toView?.alpha = 0.0
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            dummyIv.frame = self.presentRectWithImageView(imageView: dummyIv)
        }) { (finished) in
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                toView?.alpha = 1.0
            }, completion: { (finished) in
                dummyIv.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
    }
    // 解除转场
    func dismissTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromImageView = fromImageView else {
            return
        }
        let containerView = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)
        let dummyIv = self.dummyImageView()
        let parentIv = self.parentImageView()
        dummyIv.frame = containerView.convert(fromImageView.frame,from: fromImageView.superview)
        dummyIv.alpha = (fromView?.alpha)!
        containerView.addSubview(dummyIv)
        containerView.backgroundColor = UIColor.clear
        fromView?.removeFromSuperview()
        let targetRect = containerView.convert(parentIv.frame, from: parentIv.superview)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            dummyIv.frame = targetRect
            dummyIv.alpha = 1.0
        }) { (finished) in
            dummyIv.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
// MARK: - UIViewControllerTransitioningDelegate
extension NTPhotoBrowserAnimator: UIViewControllerTransitioningDelegate {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresenting ? self.presentTransition(transitionContext: transitionContext) : self.dismissTransition(transitionContext: transitionContext)
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}
extension NTPhotoBrowserAnimator {
    fileprivate func presentRectWithImageView(imageView: UIImageView) -> CGRect {
        guard let image = imageView.image else {
            return imageView.frame
        }
        let screenSize = UIScreen.main.bounds.size
        var imageSize = screenSize
        imageSize.height = image.size.height * imageSize.width / image.size.width
        var rect = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        if (imageSize.height < screenSize.height) {
            rect.origin.y = (screenSize.height - imageSize.height) * 0.5
        }
        return rect
    }
    fileprivate func dummyImageView() -> UIImageView {
        let iv = UIImageView(image: self.dummyImage())
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }
    fileprivate func dummyImage() -> UIImage? {
        let key = photos?.urls?[(photos?.selectedIndex)!]
        var image = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: key!)
        if (image == nil) {
            image = photos?.parentImageViews?[(photos?.selectedIndex)!].image
        }
        return image
    }
    fileprivate func parentImageView() -> UIImageView {
        return photos.parentImageViews![photos.selectedIndex]
    }
}
