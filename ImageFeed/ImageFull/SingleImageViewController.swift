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
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    
    
    
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
