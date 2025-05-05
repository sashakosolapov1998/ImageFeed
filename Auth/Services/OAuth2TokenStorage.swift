import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let key = "OAuthToken"
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: key)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: key)
            } else {
                KeychainWrapper.standard.removeObject(forKey: key)
            }
        }
    }
}
