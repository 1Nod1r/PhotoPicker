//
//  Model.swift
//  PhotoPicker
//
//  Created by Nodirbek on 02/05/22.
//

import Foundation

struct PhotoResults: Codable {
    let results: [Results]
}

struct Results: Codable {
    let created_at: String
    let urls: Urls
}

struct Urls: Codable {
    let regular: String
}
