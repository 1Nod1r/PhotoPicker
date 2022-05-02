//
//  APICaller.swift
//  PhotoPicker
//
//  Created by Nodirbek on 02/05/22.
//

import Foundation
import UIKit

struct Constants {
    static let APIKey = "N1wqDVIrlpV24mawPNS8QkA6Nb2KhFpkUZLrkJZ47eg"
    static let baseURL = "https://api.unsplash.com/"
    //search/photos?page=1&query=office&client_id=N1wqDVIrlpV24mawPNS8QkA6Nb2KhFpkUZLrkJZ47eg
}

enum APIErrors: Error {
    case failedToGetData
}

final class APICaller {
    
    static let shared = APICaller()
    
    public func getPhotos(page: Int,query: String, completion: @escaping (Result<[Results], Error>)->Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseURL)search/photos?page=\(page)&query=\(query)&client_id=\(Constants.APIKey)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIErrors.failedToGetData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let results = try decoder.decode(PhotoResults.self, from: data)
                completion(.success(results.results))
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    public func getImage(from url: String, completion: @escaping (UIImage?) -> Void){
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
        task.resume()
    }
    
    
}
