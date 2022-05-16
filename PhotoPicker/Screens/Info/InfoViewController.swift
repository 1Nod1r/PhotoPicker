//
//  InfoViewController.swift
//  PhotoPicker
//
//  Created by Nodirbek on 16/05/22.
//

import UIKit

class InfoViewController: UIViewController {
    
    
    let viewModel: InfoViewModel
    
    init(viewModel: InfoViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 19)
        label.numberOfLines = 0
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 19)
        label.numberOfLines = 0
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 19)
        label.numberOfLines = 0
        return label
    }()
    
    private let likeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 19)
        label.numberOfLines = 0
        return label
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    public let likeButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Like", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = .label
        button.setTitleColor(UIColor.systemBackground, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
        getPhoto()
    }
    
    private func configureUI(){
        navigationController?.navigationBar.tintColor = .label
        view.backgroundColor = .systemBackground
        let model = viewModel.model
        dateLabel.text = "Created at: \(model.createdAt ?? "")"
        nameLabel.text = "Name: \(model.name ?? "") "
        locationLabel.text = "Location: \(model.location ?? "")"
        likeLabel.text = "Number of likes: \(model.numberOfLikes ?? 0)"
    }
    
    private func getPhoto(){
        APICaller.shared.getImage(from: viewModel.model.photoURL ?? "") {image in
            DispatchQueue.main.async {[weak self] in
                guard let self = self else { return }
                self.imageView.image = image
            }
        }
    }
    
    private func setupUI(){
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(dateLabel)
        view.addSubview(locationLabel)
        view.addSubview(likeLabel)
        view.addSubview(likeButton)
        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)

        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 125),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 24),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 24),
            
            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: padding),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            locationLabel.heightAnchor.constraint(equalToConstant: 24),
            
            likeLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: padding),
            likeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            likeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            likeLabel.heightAnchor.constraint(equalToConstant: 24),
            
            likeButton.topAnchor.constraint(equalTo: likeLabel.bottomAnchor, constant: padding),
            likeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            likeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            likeButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    
    @objc private func didTapLike(){
        if DataPersistenceManager.shared.isEntityAttributeExist(id: self.viewModel.model.id ?? "", entityName: "PhotoAttributes") {
            print("already exist")
            let alertVC = UIAlertController(title: "Failed to like", message: "It seems this photo already in your liked list", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertVC.addAction(action)
            present(alertVC, animated: true)
            return
        }
        let alertVC = UIAlertController(title: "Success", message: "You liked photo", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) {[weak self] action in
            guard let self = self else { return }
           // self.viewModel.getPhotos()
        }
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
}
