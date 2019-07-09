//
//  PrayDAO.swift
//  PropositoClient
//
//  Created by Matheus Gois on 05/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Foundation
import CoreData

class PrayDAO: GenericDAO {
    typealias T = Pray
    
    let managedContext = CoreDataManager.shared.persistentContainer.viewContext
    private let entityName = "PrayEntity"
    
    static let shared:PrayDAO = PrayDAO()
    private init(){}
    
    func create(newEntity: Pray) throws {
        throw DAOError.internalError(description: "Not implement")
    }
    
    func read() throws -> [Pray] {
        throw DAOError.internalError(description: "Not implement")
    }
    
    func update(entity: Pray) throws {
        throw DAOError.internalError(description: "Not implement")
    }
    
    func delete(entity: Pray) throws {
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
