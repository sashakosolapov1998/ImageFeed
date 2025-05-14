//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 5/5/25.
//

import Foundation

// MARK: - ImageListService
final class ImagesListService {
    static let shared = ImagesListService()
    private init() {}
    
    // MARK: - Properties
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    private var task: URLSessionTask?
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    let token = OAuth2TokenStorage().token
    
    struct Photo {
        fileprivate static let dateFormatter: ISO8601DateFormatter = {
            ISO8601DateFormatter()
        }()
        
        let id: String
        let size: CGSize
        let createdAt: Date?
        let welcomeDescription: String?
        let thumbImageURL: String
        let smallImageURL: String
        let regularImageURL: String
        let fullImageURL: String
        let isLiked: Bool
    }
    
    struct UrlsResult: Decodable {
        let thumb: String
        let full: String
        let small: String
        let regular: String
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
    
    // MARK: - Methods
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
                            createdAt: Photo.dateFormatter.date(from: result.createdAt),
                            welcomeDescription: result.description,
                            thumbImageURL: result.urls.thumb,
                            smallImageURL: result.urls.small,
                            regularImageURL: result.urls.regular,
                            fullImageURL: result.urls.full,
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
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = OAuth2TokenStorage().token else {
            completion(.failure(NSError(domain: "NoToken", code: 401, userInfo: nil)))
            return
        }
        
        let urlString = "https://api.unsplash.com/photos/\(photoId)/like"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 400, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            DispatchQueue.main.async {
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        smallImageURL: photo.smallImageURL,
                        regularImageURL: photo.regularImageURL,
                        fullImageURL: photo.fullImageURL,
                        
                        isLiked: !photo.isLiked
                    )
                    self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                }
                
                completion(.success(()))
            }
        }
        task.resume()
    }
    
    func clean(){
        photos = []
        lastLoadedPage = 0
    }
}
