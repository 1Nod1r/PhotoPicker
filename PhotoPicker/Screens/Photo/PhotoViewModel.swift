//
//  PhotoViewModel.swift
//  PhotoPicker
//
//  Created by Nodirbek on 16/05/22.
//

import Foundation
import UIKit

final class PhotoViewModel {
    let model: Results
    init(model: Results){
        self.model = model
    }
    
    func getImage(completion: @escaping (UIImage?) ->Void ) {
        APICaller.shared.getImage(from: model.urls.regular) {[weak self] image in
            guard let self = self else { return }
            guard let url = URL(string: self.model.urls.regular) else { return }
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
}
