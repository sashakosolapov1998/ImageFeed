//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 12/5/25.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
