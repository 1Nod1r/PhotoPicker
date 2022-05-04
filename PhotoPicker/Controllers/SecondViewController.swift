//
//  SecondViewController.swift
//  PhotoPicker
//
//  Created by Nodirbek on 02/05/22.
//

import UIKit

class SecondViewController: UIViewController {
    
    public var completion: ((String)->Void)?
    var photos: [Results] = [Results]()
    var image = ""
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let likeButton: UIButton = {
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
        view.addSubview(likeButton)
        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)

        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 125),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            likeButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50),
            likeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            likeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            likeButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    
    @objc private func didTapLike(){
        let alertVC = UIAlertController(title: "Success", message: "You liked photo", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) {[weak self] action in
            guard let self = self else { return }
            self.completion?(self.image)
        }
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }

}
