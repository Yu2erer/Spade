//
//  NTPhotoViewerController.swift
//  NTPhotoBrowser
//
//  Created by ntian on 2017/6/13.
//  Copyright © 2017年 ntian. All rights reserved.
//

import UIKit
import Kingfisher

class NTPhotoViewerController: UIViewController {

    lazy var scrollView = UIScrollView()
    lazy var imageView = UIImageView()
    fileprivate lazy var progressView: NTPhotoProgressView = NTPhotoProgressView()
    var photoIndex: Int = 0
    fileprivate var url: URL?
    fileprivate var placeholder: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadImage()
    }
    init(urlString: String, photoIndex: Int, placeholder: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.url = URL(string: urlString)
        self.photoIndex = photoIndex
        let zeroSize = CGSize(width: 0, height: 0)
        if placeholder.size == zeroSize {
            self.placeholder = UIImage().nt_image(size: zeroSize, backColor: UIColor.black)
        } else {
            self.placeholder = UIImage(cgImage: placeholder.cgImage!, scale: 1.0, orientation: placeholder.imageOrientation)
        }

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension NTPhotoViewerController {
    fileprivate func setupUI() {
        scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView)
        imageView = UIImageView(image: placeholder)
//        imageView = UIImageView(frame: CGRect(origin: .zero, size:    imageSizeWithScreen(placeholder!)))
        imageView.center = view.center
        scrollView.addSubview(imageView)
        progressView = NTPhotoProgressView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        progressView.center = self.view.center
        progressView.progress = 1.0
        view.addSubview(progressView)
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
    }
    fileprivate func resetUI() {
        imageView.center = scrollView.center
    }
    fileprivate func loadImage() {
        imageView.kf.setImage(with: url, placeholder: placeholder, progressBlock: { (receivedSize, expectedSize) in
            DispatchQueue.main.async {
                self.progressView.progress = CGFloat(receivedSize / expectedSize)
            }
        }) { (image, error, cacheType, imageURL) in
            guard let image = image else {
                return
            }
            self.setImagePosition(image)
        }
    }
    fileprivate func setImagePosition(_ image: UIImage) {
        let size = imageSizeWithScreen(image)
        imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        scrollView.contentSize = size
        if (size.height < scrollView.bounds.size.height) {
            let offsetY: CGFloat = (scrollView.bounds.size.height - size.height) * 0.5
            scrollView.contentInset = UIEdgeInsets(top: offsetY, left: 0, bottom: offsetY, right: 0)
        }
    }
    fileprivate func imageSizeWithScreen(_ image: UIImage) -> CGSize {
        var size = UIScreen.main.bounds.size
        size.height = image.size.height * size.width / image.size.width
        return size
    }
    fileprivate func setImageViewToTheCenter() {
        let offsetX = scrollView.frame.width > scrollView.contentSize.width ? (scrollView.frame.width - scrollView.contentSize.width) * 0.5 : 0.0
        let offsetY = (scrollView.frame.height > scrollView.contentSize.height) ? (scrollView.frame.height - scrollView.contentSize.height) * 0.5 : 0.0
        imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5)
    }

}
// MARK: - UIScrollViewDelegate
extension NTPhotoViewerController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        setImageViewToTheCenter()
    }
}
