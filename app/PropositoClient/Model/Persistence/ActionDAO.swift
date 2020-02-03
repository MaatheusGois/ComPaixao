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
    static let shared: ActionDAO = ActionDAO()
    private init() { }
    func create(newEntity: Action) throws {
        guard let actEntity = NSEntityDescription.entity(forEntityName: self.entityName, in: managedContext) else {
            throw DAOError.internalError(description: "Failed to create NSEntityDescription Entity")
        }
        guard let act = NSManagedObject(entity: actEntity, insertInto: managedContext) as? ActEntity else {
            throw DAOError.internalError(description: "Failed to create NSManagedObject")
        }
        act.uuid        = UUID()
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
        do {
            let result = try managedContext.fetch(fetchRequest)
            guard let actData = result as? [ActEntity] else {
                throw DAOError.internalError(description: "Error to cast fetch result to [ActEntity]")
            }
            var acts: [Action] = []
            for data in actData {
                acts.append(Action(uuid: data.uuid  ?? UUID(),
                                   prayID: data.prayID,
                                   name: data.name  ?? "",
                                   date: data.date  ?? Date(),
                                   time: data.time  ?? "",
                                   remember: data.remember,
                                   repetition: data.repetition,
                                   whenRepeat: data.whenRepeat,
                                   completed: data.completed))
            }
            return acts
        } catch {
            throw DAOError.internalError(description: "Problem during CoreData fetch")
        }
    }
    func readOne(uuid: UUID) throws -> Action {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid.uuidString)
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count != 0 {
                guard let data = result[0] as? NSManagedObject else {
                    throw DAOError.internalError(description: "Error to take prayer:NSManagedObject")
                }
                guard let uuid: UUID = data.value(forKey: "uuid") as? UUID else {
                    throw DAOError.internalError(description: "Error to take id")
                }
                guard let name: String = data.value(forKey: "name") as? String else {
                    throw DAOError.internalError(description: "Error to take name")
                }
                guard let prayID: UUID = data.value(forKey: "prayID") as? UUID else {
                    throw DAOError.internalError(description: "Error to take prayID")
                }
                guard let date: Date = data.value(forKey: "date") as? Date else {
                    throw DAOError.internalError(description: "Error to take date")
                }
                guard let time: String = data.value(forKey: "date") as? String else {
                    throw DAOError.internalError(description: "Error to take date")
                }
                guard let remember: Bool = data.value(forKey: "remember") as? Bool else {
                    throw DAOError.internalError(description: "Error to take remember")
                }
                guard let repetition: Bool = data.value(forKey: "repetition") as? Bool else {
                    throw DAOError.internalError(description: "Error to take repetition")
                }
                guard let completed: Bool = data.value(forKey: "completed") as? Bool else {
                    throw DAOError.internalError(description: "Error to take completed")
                }
                guard let whenRepeat: String = data.value(forKey: "whenRepeat") as? String else {
                    throw DAOError.internalError(description: "Error to take whenRepeat")
                }
                return Action(uuid: uuid,
                              prayID: prayID,
                              name: name,
                              date: date,
                              time: time,
                              remember: remember,
                              repetition: repetition,
                              whenRepeat: whenRepeat,
                              completed: completed)
            } else {
                throw DAOError.internalError(description: "Action not found")
            }
        } catch {
            throw DAOError.internalError(description: "Problem during CoreData fetch")
        }
    }
    func update(entity: Action) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", entity.uuid.uuidString)
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count != 0 {
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
                do {
                    try managedContext.save()
                } catch {
                    throw DAOError.internalError(description: "Problem to save Act using CoreData")
                }
            } else {
                throw DAOError.internalError(description: "Action not found")
            }
        } catch {
            throw DAOError.internalError(description: "Problem during CoreData fetch")
        }
    }
    func delete(entity: Action) throws {
        throw DAOError.internalError(description: "Not implement")
    }
    private func idExists(uuid: UUID) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid.uuidString)
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result.count > 0
        } catch {
            print("Problem during CoreData fetch")
            return false
        }
    }
}
