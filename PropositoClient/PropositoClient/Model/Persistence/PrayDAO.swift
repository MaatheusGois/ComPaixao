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
        if idExists(id: newEntity.id) {
            throw DAOError.invalidData(description: "ID already exists")
        }
        
        guard let prayEntity = NSEntityDescription.entity(forEntityName: self.entityName, in: managedContext) else {
            throw DAOError.internalError(description: "Failed to create NSEntityDescription Entity")
        }
        
        guard let pray = NSManagedObject(entity: prayEntity, insertInto: managedContext) as? PrayEntity else {
            throw DAOError.internalError(description: "Failed to create NSManagedObject")
        }
        
        pray.id        = Int64(newEntity.id)
        pray.title     = newEntity.title
        pray.purpose   = newEntity.purpose
        pray.answered  = newEntity.answered
        pray.acts      = newEntity.acts as NSObject
        
        
        do {
            try managedContext.save()
        } catch {
            throw DAOError.internalError(description: "Problem to save Task using CoreData")
        }
    }
    
    func read() throws -> Prayers {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            
            guard let prayData = result as? [PrayEntity] else {
                throw DAOError.internalError(description: "Error to cast fetch result to [PrayEntity]")
            }
            
            var prayers:[Pray] = []
            
            for data in prayData {
                prayers.append(Pray(id: Int(data.id),
                                  title: data.title ?? "",
                                  purpose: data.purpose ?? "",
                                  answered: data.answered,
                                  acts: data.acts as! [String]))
            }
            
            return prayers
        } catch {
            throw DAOError.internalError(description: "Problema during CoreData fetch")
        }
    }
    
    func update(entity: Pray) throws {
        throw DAOError.internalError(description: "Not implement")
    }
    
    func delete(entity: Pray) throws {
        throw DAOError.internalError(description: "Not implement")
    }
    private func idExists(id: Int) -> Bool {
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
