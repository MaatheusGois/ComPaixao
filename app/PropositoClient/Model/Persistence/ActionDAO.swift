//
//  ActDAO.swift
//  PropositoClient
//
//  Created by Matheus Gois on 08/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Foundation
import CoreData


class ActionDAO: GenericDAO {
    typealias T = Action
    
    let managedContext = CoreDataManager.shared.persistentContainer.viewContext
    private let entityName = "ActEntity"
    
    static let shared:ActionDAO = ActionDAO()
    private init(){}
    
    func create(newEntity: Action) throws {
        
        guard let actEntity = NSEntityDescription.entity(forEntityName: self.entityName, in: managedContext) else {
            throw DAOError.internalError(description: "Failed to create NSEntityDescription Entity")
        }
        
        guard let act = NSManagedObject(entity: actEntity, insertInto: managedContext) as? ActEntity else {
            throw DAOError.internalError(description: "Failed to create NSManagedObject")
        }
        
        act.id        = UUID()
        act.name = newEntity.name
        act.prayID    = newEntity.prayID
        act.date      = newEntity.date
        act.completed = newEntity.completed
        act.time = newEntity.time
        act.remember = newEntity.remember
        act.repetition = newEntity.repetition
        act.whenRepeat = newEntity.whenRepeat
        
        do {
            try managedContext.save()
        } catch {
            throw DAOError.internalError(description: "Problem to save Act using CoreData")
        }
    }
    
    func read() throws -> [Action] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            
            guard let actData = result as? [ActEntity] else {
                throw DAOError.internalError(description: "Error to cast fetch result to [ActEntity]")
            }
            
            var acts:[Action] = []
            
            for data in actData {
                acts.append(Action(id: data.id  ?? UUID(), prayID: data.prayID, name: data.name  ?? "", date: data.date  ?? Date(), time: data.time  ?? "", remember: data.remember, repetition: data.repetition, whenRepeat: data.whenRepeat, completed: data.completed))
            }
            
            return acts
        } catch {
            throw DAOError.internalError(description: "Problema during CoreData fetch")
        }
    }
    
    func findByID(id: UUID) throws -> Action{
        throw DAOError.internalError(description: "Not implement")
    }
    
    func update(entity: Action) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id = \(entity.id)")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            if(result.count != 0){
                guard let act = result[0] as? NSManagedObject else {
                    throw DAOError.internalError(description: "Error Action NSManagedObject")
                }
                
                
                act.setValue(entity.name, forKeyPath: "name")
                act.setValue(entity.prayID, forKeyPath: "prayID")
                act.setValue(entity.date, forKeyPath: "date")
                act.setValue(entity.completed, forKeyPath: "completed")
                act.setValue(entity.time, forKeyPath: "time")
                act.setValue(entity.remember, forKeyPath: "remember")
                act.setValue(entity.repetition, forKeyPath: "repetition")
                act.setValue(entity.whenRepeat, forKeyPath: "whenRepeat")
                
                do{
                    try managedContext.save()
                } catch {
                    throw DAOError.internalError(description: "Problem to save Act using CoreData")
                }
                
            } else {
                throw DAOError.internalError(description: "Act not found")
            }
            
        } catch {
            throw DAOError.internalError(description: "Problema during CoreData fetch")
        }
    }
    
    func delete(entity: Action) throws {
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
