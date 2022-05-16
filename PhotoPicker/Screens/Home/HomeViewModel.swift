//
//  FirstViewControllerViewModel.swift
//  PhotoPicker
//
//  Created by Nodirbek on 15/05/22.
//

import Foundation

class HomeViewModel {
    
    var didChange: (() -> Void)?
    var page = 0
    var query: String?
    
    private var photos: [Results] = [] {
        didSet {
            didChange?()
        }
    }
    
    func loadPhotos(){
        getPhotos()
    }
    
    func numberOfPhotos() -> Int{
        return photos.count
    }

    
    private func getPhotos() {
        APICaller.shared.getPhotos(page: page, query: query ?? "random") {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photos):
                self.photos.append(contentsOf: photos)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func item(for index: Int) -> Results {
        return photos[index]
    }
    
    func clearPhotos(){
        photos = []
    }
    
    
}
