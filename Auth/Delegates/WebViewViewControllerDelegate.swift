//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 09.04.2025.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
