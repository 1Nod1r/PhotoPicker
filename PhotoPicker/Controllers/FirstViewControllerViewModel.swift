//
//  FirstViewControllerViewModel.swift
//  PhotoPicker
//
//  Created by Nodirbek on 15/05/22.
//

import Foundation

class FirstViewControllerViewModel {
    private var photos: [Results] = [Results]()
    var page = 0
    var query: String?
    func numberOfPhotos()->Int{
        return photos.count
    }
    
    func getPhotos(completion: @escaping () -> Void) {
        APICaller.shared.getPhotos(page: page, query: query ?? "Sun") {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photos):
                self.photos = photos
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func photoForCell(at indexPath: IndexPath) {
        
    }
    
}
