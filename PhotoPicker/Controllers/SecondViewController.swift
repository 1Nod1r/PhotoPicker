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
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 21, weight: .bold)
        return label
    }()
    
    private let downloadsNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 21, weight: .bold)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 21, weight: .bold)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 21, weight: .bold)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        view.addSubview(nameLabel)
        view.addSubview(downloadsNumberLabel)
        view.addSubview(locationLabel)
        view.addSubview(dateLabel)

        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 125),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

}
