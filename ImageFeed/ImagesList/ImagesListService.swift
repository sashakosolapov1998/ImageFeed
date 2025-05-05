//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 5/5/25.
//

import Foundation

final class ImagesListService {
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    private var task: URLSessionTask?
    private(set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    struct Photo {
        let id: String
        let size: CGSize
        let createdAt: Date?
        let welcomeDescription: String?
        let thumbImageURL: String
        let largeImageURL: String
        let isLiked: Bool
    }
    
    struct UrlsResult: Decodable {
        let thumb: String
        let full: String
    }
    
    struct PhotoResult: Decodable {
        let id: String
        let createdAt: String
        let description: String?
        let likedByUser: Bool
        let urls: UrlsResult
        let width: Int
        let height: Int
        
        enum CodingKeys: String, CodingKey {
            case id
            case createdAt = "created_at"
            case description
            case likedByUser = "liked_by_user"
            case urls
            case width
            case height
        }
    }
    
    func fetchPhotosNextPage() {
        if task != nil { return }
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(nextPage)&per_page=10") else { return }
        
        guard let token = OAuth2TokenStorage().token else {
            print("⚠️ Нет токена")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        self.task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer { self.task = nil }
            if let data = data {
                do {
                    let photoResults = try JSONDecoder().decode([PhotoResult].self, from: data)
                    
                    let newPhotos = photoResults.map { result in
                        Photo(
                            id: result.id,
                            size: CGSize(width: CGFloat(result.width), height: CGFloat(result.height)),
                            createdAt: ISO8601DateFormatter().date(from: result.createdAt),
                            welcomeDescription: result.description,
                            thumbImageURL: result.urls.thumb,
                            largeImageURL: result.urls.full,
                            isLiked: result.likedByUser
                        )
                    }
                    
                    DispatchQueue.main.async {
                        self.photos.append(contentsOf: newPhotos)
                        self.lastLoadedPage = nextPage
                        NotificationCenter.default.post(
                            name: ImagesListService.didChangeNotification,
                            object: self
                        )
                    }
                    
                } catch {
                    print("Ошибка при декодировании:", error)
                }
            }
        }
        
        task?.resume()
    }
}
