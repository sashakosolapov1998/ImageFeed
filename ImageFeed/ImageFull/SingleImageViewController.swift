//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 14.03.2025.
//
import UIKit

// MARK: - SingleImageViewController
final class SingleImageViewController: UIViewController {
    
    // MARK: - Properties
    var image: UIImage? {
        didSet {
            if isViewLoaded, let image = image {
                imageView.image = image
                imageView.frame.size = image.size
                rescaleAndCenterImageInScrollView(image: image)
            }
        }
    }
    var imageURL: URL?
    
    // MARK: - Outlets and Action
    @IBAction func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard let image = image else { return }
        
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityController, animated: true)
    }
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 3.0
        scrollView.delegate = self
        imageView.contentMode = .scaleAspectFill
        
        if let _ = imageURL {
            loadImage()
        }
    }
    
    // MARK: - Public Methods
    func loadImage() {
        guard let imageURL = imageURL else { return }
        
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case.success(let value):
                self.image = value.image
                self.imageView.image = value.image
                self.imageView.frame.size = value.image.size
                self.rescaleAndCenterImageInScrollView(image: value.image)
            case.failure:
                self.showError()
            }
        }
    }
    
    // MARK: - Private Methods
    private func showError() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Что-то пошло не так. Попробовать еще раз?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Не надо", style: .cancel))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.loadImage()
        })
        
        present(alert, animated: true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        view.layoutIfNeeded()
        
        let scrollViewSize = scrollView.frame.size
        let imageSize = image.size
        
        let widthRatio = scrollViewSize.width / imageSize.width
        let heightRatio = scrollViewSize.height / imageSize.height
        let scale = max(widthRatio, heightRatio)
        
        let scaledSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
        imageView.frame = CGRect(origin: .zero, size: scaledSize)
        
        scrollView.contentSize = scaledSize
        scrollView.zoomScale = 1.0
        
        centerImageInScrollView()
    }
    
    private func centerImageInScrollView() {
        let scrollViewSize = scrollView.frame.size
        let imageViewSize = imageView.frame.size
        
        let horizontalInset = max(0, (scrollViewSize.width - imageViewSize.width) / 2)
        let verticalInset = max(0, (scrollViewSize.height - imageViewSize.height) / 2)
        
        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        
        let offsetX = max((scrollView.contentSize.width - scrollView.bounds.width) / 2, 0)
        let offsetY = max((scrollView.contentSize.height - scrollView.bounds.height) / 2, 0)
        scrollView.contentOffset = CGPoint(x: offsetX, y: offsetY)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        centerImageInScrollView()
    }
}


// MARK: - Extension
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImageInScrollView()
    }
    
}
