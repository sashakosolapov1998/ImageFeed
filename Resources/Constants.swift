//
//  Constant.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 08.04.2025
import Foundation

enum Constants {
    static let accessKey = "YPi2RHVHvJZk9SQz9kiJEr7ZKkzq8rGHll9jYU4uoaw"
    static let secretKey = "_Unu58K-mOhrjJ2GPACiL5jZJvdknnoNRf8RpTntFOs"
    static let redirectURI = "https://example.com/callback"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL: URL = {
        guard let url = URL(string: "https://api.unsplash.com") else {
            preconditionFailure("Ошибка: неверный base URL")
        }
        return url
    }()
}
