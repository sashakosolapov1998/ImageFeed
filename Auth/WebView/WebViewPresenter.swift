//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 11/5/25.
//
import Foundation
import WebKit

// MARK: - WebViewPresenter
final class WebViewPresenter: WebViewPresenterProtocol {
    private let configuration = AuthConfiguration.standard
    var authHelper: AuthHelperProtocol
    weak var view: WebViewViewControllerProtocol?
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    // MARK: - Lifecycle
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else {
            print("Ошибка: не удалось создать authRequest")
            return
        }
        didUpdateProgressValue(0)
        view?.load(request: request)
    }
    
    // MARK: - Methods
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
