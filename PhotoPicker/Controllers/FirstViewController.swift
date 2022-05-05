//
//  ViewController.swift
//  PhotoPicker
//
//  Created by Nodirbek on 02/05/22.
//

import UIKit

class FirstViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var photos: [Results] = [Results]()
    var page = 0
    var query: String?
    
    func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a username..."
        navigationItem.searchController = searchController
    }
    
    func configureCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width - 50, height: view.frame.size.width)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureCollectionView()
        
        getPhotos(query: query ?? "nature", page: page)
    }
    
    private func getPhotos(query: String,page: Int){
        APICaller.shared.getPhotos(page: page, query: query) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let results):
                self.photos.append(contentsOf: results)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
}

extension FirstViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        let model = photos[indexPath.row]
        cell.set(with: model.urls.regular)
        return cell
    }
}

extension FirstViewController: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offSetY > contentHeight - height {
            page += 1
            DispatchQueue.main.async {[weak self] in
                guard let self = self else { return }
                self.getPhotos(query: self.query ?? "movie", page: self.page)
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SecondViewController()
        let model = photos[indexPath.row]
        vc.image = model.urls.regular
        vc.photos = photos
        vc.indexPath = indexPath.row
        vc.name = model.user.username
        vc.location = model.user.location ?? "No location :("
        vc.like = "\(model.likes)"
        vc.date = model.created_at
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FirstViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            query = text
            photos = []
            getPhotos(query: query ?? "office", page: page)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
    

