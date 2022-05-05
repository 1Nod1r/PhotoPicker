//
//  SecondViewController.swift
//  PhotoPicker
//
//  Created by Nodirbek on 02/05/22.
//

import UIKit

class SecondViewController: UIViewController {
    
    var photos: [Results] = [Results]()
    var image = ""
    var indexPath = 0
    var date = ""
    var name = ""
    var location = ""
    var like = ""
    
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
        let button = UIButton()
        button.setTitle("Like", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = .label
        button.setTitleColor(UIColor.systemBackground, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .label
        view.backgroundColor = .systemBackground
        getPhoto()
        configureUI()
        dateLabel.text = "Created at: \(date)"
        nameLabel.text = "Name: \(name)"
        locationLabel.text = "Location: \(location)"
        likeLabel.text = "Number of likes: \(like)"
    }
    
    private func getPhoto(){
        APICaller.shared.getImage(from: image) {image in
            DispatchQueue.main.async {[weak self] in
                guard let self = self else { return }
                self.imageView.image = image
            }
        }
    }
    
    private func configureUI(){
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
        let alertVC = UIAlertController(title: "Success", message: "You liked photo", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) {[weak self] action in
            guard let self = self else { return }
            DataPersistenceManager.shared.saveData(model: self.photos[self.indexPath]) {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    NotificationCenter.default.post(name: NSNotification.Name("liked"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error)
                }
            }
        }
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }

}
