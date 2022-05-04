//
//  LikesTableViewCell.swift
//  PhotoPicker
//
//  Created by Nodirbek on 04/05/22.
//

import UIKit
import SDWebImage

class LikesTableViewCell: UITableViewCell {
    
    static let identifier = "LikesTableViewCell"
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        contentView.addSubview(image)
        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            image.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func set(with model: String){
        guard let url = URL(string: model) else { return }
        image.sd_setImage(with: url)
    }

}
