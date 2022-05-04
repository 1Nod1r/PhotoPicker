//
//  LikesViewController.swift
//  PhotoPicker
//
//  Created by Nodirbek on 04/05/22.
//

import UIKit

class LikesViewController: UIViewController {
    
    var photos: [PhotoAttributes] = [PhotoAttributes]()
    
    private let noLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 2
        label.text = "No Favorites? \nAdd one on the Home Screen!"
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(LikesTableViewCell.self, forCellReuseIdentifier: LikesTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(forName: NSNotification.Name("liked"), object: nil, queue: nil) {[weak self] _ in
            self?.fetchLocalStorageForDownload()
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        fetchLocalStorageForDownload()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureLabel(){
        view.addSubview(noLabel)
        NSLayoutConstraint.activate([
            noLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -100)
        ])

    }
    
    private func fetchLocalStorageForDownload(){
        DataPersistenceManager.shared.fetchData {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photos):
                if photos.isEmpty {
                    self.configureLabel()
                }
                else {
                    self.photos = photos
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }


}

extension LikesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LikesTableViewCell.identifier, for: indexPath) as? LikesTableViewCell else { return UITableViewCell() }
        cell.set(with: photos[indexPath.row].photoURL!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DispatchQueue.main.async {
                DataPersistenceManager.shared.deleteFromData(model: self.photos[indexPath.row]) {[weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(()):
                        print("deleted")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    self.photos.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            
        case .none:
            break
        case .insert:
            break
        @unknown default:
            break
        }
    }
    
    
}
