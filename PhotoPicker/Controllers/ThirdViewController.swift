//
//  ThirdViewController.swift
//  PhotoPicker
//
//  Created by Nodirbek on 05/05/22.
//

import UIKit

class ThirdViewController: UIViewController {
    
    var photos: [PhotoAttributes] = [PhotoAttributes]()
    var image = ""
    var indexPath = 0
    
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

        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 125),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
    
}

