//
//  LikeViewModel.swift
//  PhotoPicker
//
//  Created by Nodirbek on 16/05/22.
//

import Foundation

final class LikeViewModel {
    var didChange: (() -> Void)?
    
    private var photos: [PhotoAttributes] = [] {
        didSet {
            didChange?()
        }
    }
    
    func getPhotos(){
        DataPersistenceManager.shared.fetchData {[weak self] result in
            switch result {
            case .success(let photos):
                self?.photos.append(contentsOf: photos)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deletePhoto(at indexPath: Int) {
        DataPersistenceManager.shared.deleteFromData(model: photos[indexPath]) {[weak self] result in
            switch result {
            case .success():
                self?.photos.remove(at: indexPath)
                print("deleted")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func numberOfPhotos() -> Int {
        return photos.count
    }
    
    func item(for index: Int) -> PhotoAttributes {
        return photos[index]
    }
    
}
