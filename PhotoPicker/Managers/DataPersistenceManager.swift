//
//  DataPersistenceManager.swift
//  PhotoPicker
//
//  Created by Nodirbek on 04/05/22.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
    
    public func saveData(model: Results, completion: @escaping (Result<Void, Error>)->Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let photo = PhotoAttributes(context: context)
        
        photo.photoURL = model.urls.regular
        photo.name = model.user.username
        photo.location = model.user.location
        photo.createdAt = model.created_at.convertToDisplayFormat()
        photo.numberOfLikes = Int64(model.likes)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    public func fetchData(completion: @escaping (Result<[PhotoAttributes], Error>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        var request: NSFetchRequest<PhotoAttributes>
        request = PhotoAttributes.fetchRequest()
        do {
            let photos = try context.fetch(request)
            completion(.success(photos))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    public func deleteFromData(model: PhotoAttributes, completion: @escaping (Result<Void,Error>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
}
