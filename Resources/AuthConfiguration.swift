//
//  AuthConfiguration.swift
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

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.authURLString = authURLString
        self.defaultBaseURL = defaultBaseURL
    }

    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            authURLString: "https://unsplash.com/oauth/authorize",
            defaultBaseURL: Constants.defaultBaseURL
        )
    }
}
