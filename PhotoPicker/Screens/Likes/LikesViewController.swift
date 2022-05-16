//
//  LikesViewController.swift
//  PhotoPicker
//
//  Created by Nodirbek on 04/05/22.
//

import UIKit

class LikesViewController: UIViewController {
    
    var photos: [PhotoAttributes] = [PhotoAttributes]()
    
    var viewModel: LikeViewModel
    
    init(viewModel: LikeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let noLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 19, weight: .semibold)
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
        title = "Liked"
        tableView.dataSource = self
        tableView.delegate = self
        setupBinding()
    }
    
    func setupBinding(){
        viewModel.didChange = {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(forName: NSNotification.Name("liked"), object: nil, queue: nil) {[weak self] _ in
            self?.viewModel.getPhotos()
            self?.setupBinding()
        }
        viewModel.getPhotos()
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

}

extension LikesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPhotos()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LikesTableViewCell.identifier, for: indexPath) as? LikesTableViewCell else { return UITableViewCell() }
        
        let model = viewModel.item(for: indexPath.row)
        cell.set(with: LikesViewModel(name: model.name ?? "", imageUrl: model.photoURL ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = viewModel.item(for: indexPath.row)
        let likeViewModel = InfoViewModel(model: model)
        let vc = InfoViewController(viewModel: likeViewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DispatchQueue.main.async {[weak self] in
                self?.viewModel.deletePhoto(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
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
