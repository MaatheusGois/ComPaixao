//
//  ActDAO.swift
//  PropositoClient
//
//  Created by Matheus Gois on 08/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Foundation
import CoreData


class ActDAO: GenericDAO {
    typealias T = Act
    
    let managedContext = CoreDataManager.shared.persistentContainer.viewContext
    private let entityName = "PrayEntity"
    
    static let shared:ActDAO = ActDAO()
    private init(){}
    
    func create(newEntity: Act) throws {
        throw DAOError.internalError(description: "Not implement")
    }
    
    func read() throws -> [Act] {
        throw DAOError.internalError(description: "Not implement")
    }
    
    func update(entity: Act) throws {
        throw DAOError.internalError(description: "Not implement")
    }
    
    func delete(entity: Act) throws {
        throw DAOError.internalError(description: "Not implement")
    }
    private func idExist(id: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result.count > 0
        } catch {
            print("Problem during CoreData fetch")
            return false
        }
    }
}
