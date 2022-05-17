//
//  InfoViewModel.swift
//  PhotoPicker
//
//  Created by Nodirbek on 16/05/22.
//

import Foundation
import UIKit

class InfoViewModel {
    var model: PhotoAttributes
    
    init(model: PhotoAttributes) {
        self.model = model
    }
    
    func getImage(completin: @escaping (UIImage?) -> Void) {
        guard let modelURL = model.photoURL else { return }
        APICaller.shared.getImage(from: modelURL) { image in
            guard let url = URL(string: modelURL) else { return }
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else {
                    completin(nil)
                    return
                }
                completin(image)
            }
            task.resume()
        }
    }
    
}
