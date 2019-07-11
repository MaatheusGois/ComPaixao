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
    private let entityName = "ActEntity"
    
    static let shared:ActDAO = ActDAO()
    private init(){}
    
    func create(newEntity: Act) throws {
        if idExists(id: newEntity.id) {
            throw DAOError.invalidData(description: "ID already exists")
        }
        
        guard let actEntity = NSEntityDescription.entity(forEntityName: self.entityName, in: managedContext) else {
            throw DAOError.internalError(description: "Failed to create NSEntityDescription Entity")
        }
        
        guard let act = NSManagedObject(entity: actEntity, insertInto: managedContext) as? ActEntity else {
            throw DAOError.internalError(description: "Failed to create NSManagedObject")
        }
        
        act.id        = Int64(newEntity.id)
        act.title     = newEntity.title
        act.date      = newEntity.date
        act.pray      = newEntity.pray
        act.completed = newEntity.completed
        
        
        do {
            try managedContext.save()
        } catch {
            throw DAOError.internalError(description: "Problem to save Task using CoreData")
        }
    }
    
    func read() throws -> [Act] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            
            guard let actData = result as? [ActEntity] else {
                throw DAOError.internalError(description: "Error to cast fetch result to [PrayEntity]")
            }
            
            var acts:[Act] = []
            
            for act in actData {
                acts.append(Act(id: Int(act.id),
                                    title: act.title ?? "",
                                    pray: act.pray ?? "",
                                    completed: act.completed,
                                    date: act.date ?? Date()))
            }
            
            return acts
        } catch {
            throw DAOError.internalError(description: "Problema during CoreData fetch")
        }
    }
    
    func update(entity: Act) throws {
        throw DAOError.internalError(description: "Not implement")
    }
    
    func delete(entity: Act) throws {
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
