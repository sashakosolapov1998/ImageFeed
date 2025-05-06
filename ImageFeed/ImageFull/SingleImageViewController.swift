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
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.delegate = self

        if let imageURL = imageURL {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: imageURL) { [weak self] result in
                if case let .success(value) = result {
                    self?.rescaleAndCenterImageInScrollView(image: value.image)
                }
            }
            return
        }
        
        if let image = image {
            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        centerImageInScrollView()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    // MARK: - Метод для центрирования изображения через contentInset (добавлено по дополнительному заданию)
    private func centerImageInScrollView() {
        let scrollViewSize = scrollView.bounds.size
        let imageViewSize = imageView.frame.size
        
        let horizontalInset = max(0, (scrollViewSize.width - imageViewSize.width) / 2)
        let verticalInset = max(0, (scrollViewSize.height - imageViewSize.height) / 2)
        
        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // MARK: - Центрирование изображения после зума (добавлено по дополнительному заданию)
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        centerImageInScrollView()
    }
}
