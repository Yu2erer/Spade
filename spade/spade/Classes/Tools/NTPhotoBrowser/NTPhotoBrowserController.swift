//
//  NTPhotoBrowserController.swift
//  NTPhotoBrowser
//
//  Created by ntian on 2017/6/13.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
@objc protocol NTPhotoBrowserDelegate: NSObjectProtocol {
    @objc optional func savePhotos(isSuccess: Bool)
}

class NTPhotoBrowserController: UIViewController {

    fileprivate lazy var photos = NTPhotoBrowserPhotos()
    fileprivate var currentViewer: NTPhotoViewerController?
    fileprivate var statusBarHidden = false
    fileprivate lazy var pageControl = UIPageControl()
    fileprivate var activityViewController: UIActivityViewController!
    fileprivate var animator: NTPhotoBrowserAnimator?
    public weak var delegate: NTPhotoBrowserDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    init(selectedIndex: Int, urls: [String], parentImageViews: [UIImageView]) {
        super.init(nibName: nil, bundle: nil)
        photos = NTPhotoBrowserPhotos()
        photos.selectedIndex = selectedIndex
        photos.urls = urls
        photos.parentImageViews = parentImageViews
        statusBarHidden = false
        animator = NTPhotoBrowserAnimator(photos: photos)
        self.modalPresentationStyle = .custom
        transitioningDelegate = animator
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        statusBarHidden = true
        self.setNeedsStatusBarAppearanceUpdate()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        statusBarHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
    }
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }

    fileprivate func viewerWithIndex(index: Int) -> NTPhotoViewerController {
        return NTPhotoViewerController(urlString: (photos.urls?[index])!, photoIndex: index, placeholder: (photos.parentImageViews?[index].image) ?? UIImage())
    }
    @objc fileprivate func singleTapGesture() {
        animator?.fromImageView = currentViewer?.imageView
        self.dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func doubleTapGesture(recognizer: UITapGestureRecognizer) {
        guard let scrollView = currentViewer?.scrollView else {
            return
        }
        if (scrollView.zoomScale <= scrollView.minimumZoomScale) {
            let location = recognizer.location(in: scrollView)
            let width = scrollView.bounds.width / scrollView.maximumZoomScale
            let height = scrollView.bounds.height / scrollView.maximumZoomScale
            let rect = CGRect(x: location.x * (1 - 1 / scrollView.maximumZoomScale), y: location.y * (1 - 1 / scrollView.maximumZoomScale), width: width, height: height)
            scrollView.zoom(to: rect, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
    @objc fileprivate func longPressGesture(recognizer: UILongPressGestureRecognizer) {
        // 不加会卡一下
        if (recognizer.state != .began || currentViewer?.imageView.image == nil) {
            return
        }
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let actionSava = UIAlertAction(title: "保存至相册", style: .destructive) { (action) in
            UIImageWriteToSavedPhotosAlbum((self.currentViewer?.imageView.image)!, self, #selector(self.savedPhotosAlbum), nil)
        }
        let actionAnother = UIAlertAction(title: "其他分享", style: .default) { (action) in
            guard let image = self.currentViewer?.imageView.image else {
                return
            }
            self.activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.activityViewController.completionWithItemsHandler = {
                (activity, success, items, error) in
                self.activityViewController = nil
            }
            if (UI_USER_INTERFACE_IDIOM() == .phone) {
                self.present(self.activityViewController, animated: true, completion: nil)
            } else {
                self.activityViewController.modalPresentationStyle = .popover
                self.present(self.activityViewController, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(actionCancel)
        actionSheet.addAction(actionSava)
        actionSheet.addAction(actionAnother)
        self.present(actionSheet, animated: true, completion: nil)
    }
    @objc fileprivate func savedPhotosAlbum(image: UIImage, didFinishSavingWithError error: Error?, contextInfo: AnyObject) {
        if (error != nil) {
            delegate?.savePhotos?(isSuccess: false)
        } else {
            delegate?.savePhotos?(isSuccess: true)
        }
    }
}
// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource
extension NTPhotoBrowserController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let viewer = pageViewController.viewControllers?[0] as! NTPhotoViewerController
        photos.selectedIndex = viewer.photoIndex
        currentViewer = viewer
        pageControl.currentPage = photos.selectedIndex
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! NTPhotoViewerController
        let index = vc.photoIndex
        if (index <= 0) {
            return nil
        }
        return self.viewerWithIndex(index: index - 1)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! NTPhotoViewerController
        let index = vc.photoIndex + 1
        if (index >= (photos.urls?.count)!) {
            return nil
        }
        return self.viewerWithIndex(index: index)
    }
}
extension NTPhotoBrowserController {
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.black
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey: 20])
        pageController.delegate = self
        pageController.dataSource = self
        let viewer = viewerWithIndex(index: photos.selectedIndex)
        pageController.setViewControllers([viewer], direction: .forward, animated: true, completion: nil)
        currentViewer = viewer
        view.addSubview(pageController.view)
        self.addChildViewController(pageController)
        pageController.didMove(toParentViewController: self)
        // 手势
        self.view.gestureRecognizers = pageController.gestureRecognizers
        addGesture()

        pageControl = UIPageControl(frame: CGRect(origin: .zero, size:         pageControl.size(forNumberOfPages: (photos.urls?.count)!)))
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.white
        var center = view.center
        center.y = view.bounds.height - 16
        pageControl.center = center
        pageControl.numberOfPages = (photos.urls?.count)!
        pageControl.currentPage = photos.selectedIndex
        view.addSubview(pageControl)
        if photos.urls?.count == 1 {
            pageControl.isHidden = true
        }
    }
    fileprivate func addGesture() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapGesture))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(singleTap)
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapGesture(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(doubleTap)
        singleTap.require(toFail: doubleTap)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(recognizer:)))
        self.view.addGestureRecognizer(longPress)
    }
}
