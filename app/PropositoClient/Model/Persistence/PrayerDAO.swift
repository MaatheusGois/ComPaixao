//
//  PrayDAO.swift
//  PropositoClient
//
//  Created by Matheus Gois on 05/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Foundation
import CoreData

class PrayerDAO: GenericDAO {
    typealias T = Prayer
    
    let managedContext = CoreDataManager.shared.persistentContainer.viewContext
    private let entityName = "PrayEntity"
    
    static let shared:PrayerDAO = PrayerDAO()
    private init(){}
    
    func create(newEntity: Prayer) throws {
        
        guard let prayEntity = NSEntityDescription.entity(forEntityName: self.entityName, in: managedContext) else {
            throw DAOError.internalError(description: "Failed to create NSEntityDescription Entity")
        }
        
        guard let pray = NSManagedObject(entity: prayEntity, insertInto: managedContext) as? PrayEntity else {
            throw DAOError.internalError(description: "Failed to create NSManagedObject")
        }
        
        
        pray.id = UUID()
        
        pray.name     = newEntity.name
        pray.image   = newEntity.image
        pray.date = newEntity.date
        pray.time = newEntity.time
        pray.remember = newEntity.remember
        pray.repetition = newEntity.repetition
        pray.whenRepeat = newEntity.whenRepeat
        pray.answered  = newEntity.answered
        pray.actions      = newEntity.actions as NSObject
        
        
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
            
            var prayers:[Prayer] = []
            
            for data in prayData {
                
                prayers.append(
                    Prayer(
                        id: data.id ?? UUID(),
                        name: data.name ?? "",
                        image: data.image ?? "",
                        date: data.date ?? Date(),
                        time: data.time ?? "",
                        remember: data.remember ,
                        repetition: data.repetition ,
                        whenRepeat: data.whenRepeat,
                        answered: data.answered ,
                        actions: data.actions as? [UUID] ?? []
                    )
                )
            }
            
            return prayers
        } catch {
            throw DAOError.internalError(description: "Problema during CoreData fetch")
        }
    }
    func findByID(id: UUID) throws -> Prayer {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id = \(id)")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            if(result.count != 0){
                guard let pray = result[0] as? NSManagedObject else {
                    throw DAOError.internalError(description: "Error to take prayer:NSManagedObject")
                }
                guard let id:UUID = pray.value(forKey: "id") as? UUID else {
                    throw DAOError.internalError(description: "Error to take id")
                }
                guard let name:String = pray.value(forKey: "name") as? String else {
                    throw DAOError.internalError(description: "Error to take name")
                }
                guard let image:String = pray.value(forKey: "image") as? String else {
                    throw DAOError.internalError(description: "Error to take image")
                }
                guard let date:Date = pray.value(forKey: "date") as? Date else {
                    throw DAOError.internalError(description: "Error to take date")
                }
                guard let time:String = pray.value(forKey: "date") as? String else {
                   throw DAOError.internalError(description: "Error to take date")
                }
                guard let remember:Bool = pray.value(forKey: "remember") as? Bool else {
                    throw DAOError.internalError(description: "Error to take remember")
                }
                guard let repetition:Bool = pray.value(forKey: "repetition") as? Bool else {
                    throw DAOError.internalError(description: "Error to take repetition")
                }
                guard let answered:Bool = pray.value(forKey: "answered") as? Bool else {
                    throw DAOError.internalError(description: "Error to take answered")
                }
                guard let whenRepeat:String = pray.value(forKey: "whenRepeat") as? String else {
                    throw DAOError.internalError(description: "Error to take whenRepeat")
                }
                guard let actions:[UUID] = pray.value(forKey: "actions") as? [UUID] else {
                    throw DAOError.internalError(description: "Error to take actions")
                }
                return Prayer(id: id, name: name, image: image, date: date, time: time, remember: remember, repetition: repetition, whenRepeat: whenRepeat, answered: answered, actions: actions)
                
            } else {
                throw DAOError.internalError(description: "Pray not found")
            }
            
        } catch {
            throw DAOError.internalError(description: "Problema during CoreData fetch")
        }
    }
    
    func update(entity: Prayer) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id = \(entity.id)")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            if(result.count != 0){
                guard let pray = result[0] as? NSManagedObject else {
                    throw DAOError.internalError(description: "Error to take prayer:NSManagedObject")
                }
                
                pray.setValue(entity.name, forKeyPath: "name")
                pray.setValue(entity.image, forKeyPath: "image")
                pray.setValue(entity.date, forKeyPath: "date")
                pray.setValue(entity.time, forKeyPath: "time")
                pray.setValue(entity.remember, forKeyPath: "remember")
                pray.setValue(entity.repetition, forKeyPath: "repetition")
                pray.setValue(entity.whenRepeat, forKeyPath: "whenRepeat")
                pray.setValue(entity.answered, forKeyPath: "answered")
                pray.setValue(entity.actions, forKeyPath: "actions")
                
                do{
                    try managedContext.save()
                } catch {
                    throw DAOError.internalError(description: "Problem to save Pray using CoreData")
                }
                
            } else {
                throw DAOError.internalError(description: "Act not found")
            }
            
        } catch {
            throw DAOError.internalError(description: "Problema during CoreData fetch")
        }
    }
    
    func delete(entity: Prayer) throws {
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
