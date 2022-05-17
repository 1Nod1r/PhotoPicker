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
    let id: String
    let created_at: String
    let urls: Url
    let likes: Int
    let user: User
    
    var url: String {
        return urls.regular
    }
    
    var location: String {
        return user.location ?? "No location available :("
    }
    
    var name: String {
        return user.name
    }
}

struct User: Codable {
    let name: String
    let location: String?
}

struct Url: Codable {
    let regular: String
}


