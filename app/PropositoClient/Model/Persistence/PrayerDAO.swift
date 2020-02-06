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
    static let shared: PrayerDAO = PrayerDAO()
    private init() {}
    func create(newEntity: Prayer) throws {
        guard let prayEntity = NSEntityDescription.entity(forEntityName: self.entityName, in: managedContext) else {
            throw DAOError.internalError(description: "Failed to create NSEntityDescription Entity")
        }
        guard let pray = NSManagedObject(entity: prayEntity, insertInto: managedContext) as? PrayEntity else {
            throw DAOError.internalError(description: "Failed to create NSManagedObject")
        }
        pray.uuid       = newEntity.uuid
        pray.name       = newEntity.name
        pray.subject    = newEntity.subject
        pray.image      = newEntity.image
        pray.date       = newEntity.date
        pray.time       = newEntity.time
        pray.remember   = newEntity.remember
        pray.repetition = newEntity.repetition
        pray.whenRepeat = newEntity.whenRepeat
        pray.answered   = newEntity.answered
        pray.actions    = newEntity.actions as NSObject
        do {
            try managedContext.save()
        } catch {
            throw DAOError.internalError(description: "Problem to save Task using CoreData")
        }
    }
    func read() throws -> Prayers {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        do {
            let result = try managedContext.fetch(fetchRequest)
            guard let prayData = result as? [PrayEntity] else {
                throw DAOError.internalError(description: "Error to cast fetch result to [PrayEntity]")
            }
            var prayers: [Prayer] = []
            for data in prayData {
                prayers.append(
                    Prayer(
                        uuid: data.uuid ?? UUID().uuidString,
                        name: data.name ?? "",
                        subject: data.subject ?? "",
                        image: data.image ?? "",
                        date: data.date ?? Date(),
                        time: data.time ?? "",
                        remember: data.remember ,
                        repetition: data.repetition ,
                        whenRepeat: data.whenRepeat,
                        answered: data.answered ,
                        actions: data.actions as? [String] ?? []
                    )
                )
            }
            return prayers
        } catch {
            throw DAOError.internalError(description: error.localizedDescription)
        }
    }
    func readOne(uuid: String) throws -> Prayer {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count != 0 {
                guard let pray = result[0] as? NSManagedObject else {
                    throw DAOError.internalError(description: "Error to take prayer:NSManagedObject")
                }
                guard let uuid: String = pray.value(forKey: "uuid") as? String else {
                    throw DAOError.internalError(description: "Error to take id")
                }
                guard let name: String = pray.value(forKey: "name") as? String else {
                    throw DAOError.internalError(description: "Error to take name")
                }
                guard let subject: String = pray.value(forKey: "subject") as? String else {
                    throw DAOError.internalError(description: "Error to take subject")
                }
                guard let image: String = pray.value(forKey: "image") as? String else {
                    throw DAOError.internalError(description: "Error to take image")
                }
                guard let date: Date = pray.value(forKey: "date") as? Date else {
                    throw DAOError.internalError(description: "Error to take date")
                }
                guard let time: String = pray.value(forKey: "time") as? String else {
                    throw DAOError.internalError(description: "Error to take time")
                }
                guard let remember: Bool = pray.value(forKey: "remember") as? Bool else {
                    throw DAOError.internalError(description: "Error to take remember")
                }
                guard let repetition: Bool = pray.value(forKey: "repetition") as? Bool else {
                    throw DAOError.internalError(description: "Error to take repetition")
                }
                guard let answered: Bool = pray.value(forKey: "answered") as? Bool else {
                    throw DAOError.internalError(description: "Error to take answered")
                }
                guard let whenRepeat: String = pray.value(forKey: "whenRepeat") as? String else {
                    throw DAOError.internalError(description: "Error to take whenRepeat")
                }
                guard let actions: [String] = pray.value(forKey: "actions") as? [String] else {
                    throw DAOError.internalError(description: "Error to take actions")
                }
                return Prayer(uuid: uuid,
                              name: name,
                              subject: subject,
                              image: image,
                              date: date,
                              time: time,
                              remember: remember,
                              repetition: repetition,
                              whenRepeat: whenRepeat,
                              answered: answered,
                              actions: actions)
            } else {
                throw DAOError.internalError(description: "Pray not found")
            }
        } catch {
            throw DAOError.internalError(description: error.localizedDescription)
        }
    }
    func update(entity: Prayer) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", entity.uuid)
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count != 0 {
                guard let pray = result[0] as? NSManagedObject else {
                    throw DAOError.internalError(description: "Error to take prayer:NSManagedObject")
                }
                pray.setValue(entity.name, forKeyPath: "name")
                pray.setValue(entity.subject, forKeyPath: "subject")
                pray.setValue(entity.image, forKeyPath: "image")
                pray.setValue(entity.date, forKeyPath: "date")
                pray.setValue(entity.time, forKeyPath: "time")
                pray.setValue(entity.remember, forKeyPath: "remember")
                pray.setValue(entity.repetition, forKeyPath: "repetition")
                pray.setValue(entity.whenRepeat, forKeyPath: "whenRepeat")
                pray.setValue(entity.answered, forKeyPath: "answered")
                pray.setValue(entity.actions, forKeyPath: "actions")
                do {
                    try managedContext.save()
                } catch {
                    throw DAOError.internalError(description: error.localizedDescription)
                }
            } else {
                throw DAOError.internalError(description: "Act not found")
            }
        } catch {
            throw DAOError.internalError(description: error.localizedDescription)
        }
    }
    func delete(uuid: String) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count != 0 {
                let objectToDelete = result[0] as? NSManagedObject
                if objectToDelete != nil {
                    managedContext.delete(objectToDelete!)
                    do {
                        try managedContext.save()
                    } catch {
                        throw DAOError.internalError(description: "Pray not posible deleted")
                    }
                }
            } else {
                throw DAOError.internalError(description: "Pray not found")
            }
        } catch {
            throw DAOError.internalError(description: error.localizedDescription)
        }
    }
    private func idExists(uuid: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result.count > 0
        } catch {
            print("Problem during CoreData fetch")
            return false
        }
    }
}
