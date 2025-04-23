import Foundation

final class OAuth2TokenStorage {
    private let defaults = UserDefaults.standard
    private let key = "OAuthToken"
    
    var token: String? {
        get {
            defaults.string(forKey: key)
        }
        set {
            defaults.set(newValue, forKey: key)
        }
    }
}
