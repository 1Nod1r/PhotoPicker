//
//  PhotoCell.swift
//  PhotoPicker
//
//  Created by Nodirbek on 02/05/22.
//

import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
    static let identifier = "PhotoCell"
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        image.frame = contentView.bounds
    }
    
    public func set(with model: String){
        guard let url = URL(string: "\(model)") else { return }
        image.sd_setImage(with: url)
    }
    
}
