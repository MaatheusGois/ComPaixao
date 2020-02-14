//
//  PrayHandler.swift
//  PropositoClient
//
//  Created by Matheus Gois on 05/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit

enum PrayerLoadResponse: Error {
    case success(prayers: Prayers)
    case error(description: String)
}

enum PrayerActionsResponse: Error {
    case success(actions: Actions)
    case error(description: String)
}

enum PrayerUpdateResponse: Error {
    case success(prayer: Prayer)
    case error(description: String)
}

class PrayerHandler {
    static func create(pray: Prayer, withCompletion
                                     completion: (PrayerUpdateResponse) -> Void) {
        do {
            try PrayerDAO.shared.create(newEntity: pray)
            completion(PrayerUpdateResponse.success(prayer: pray))
        } catch {
            completion(PrayerUpdateResponse.error(description: error.localizedDescription))
        }
    }
    static func addAction(prayerID: String, actionID: String, withCompletion
                                     completion: (PrayerUpdateResponse) -> Void) {
        do {
            var prayer = try PrayerDAO.shared.readOne(uuid: prayerID)
            prayer.actions.append(actionID)
            try PrayerDAO.shared.update(entity: prayer)
            completion(PrayerUpdateResponse.success(prayer: prayer))
        } catch {
            completion(PrayerUpdateResponse.error(description: error.localizedDescription))
        }
    }
    static func updateAction(prayerID: String,
                             prayerOldID: String,
                             actionID: String,
                             withCompletion completion: (PrayerUpdateResponse) -> Void) {
        do {
            if prayerOldID != "" {
                var oldPrayer = try PrayerDAO.shared.readOne(uuid: prayerOldID)
                guard let index: Int = oldPrayer.actions.firstIndex(of: actionID) else {
                    completion(PrayerUpdateResponse.error(description: "oldPrayer without action"))
                    return
                }
                oldPrayer.actions.remove(at: index)
                try PrayerDAO.shared.update(entity: oldPrayer)
            }
            var prayer = try PrayerDAO.shared.readOne(uuid: prayerID)
            prayer.actions.append(actionID)
            try PrayerDAO.shared.update(entity: prayer)
            completion(PrayerUpdateResponse.success(prayer: prayer))
        } catch {
            completion(PrayerUpdateResponse.error(description: error.localizedDescription))
        }
    }
    static func getAll(completion: @escaping (PrayerLoadResponse) -> Void) {
        do {
            let prayers = try PrayerDAO.shared.read()
            completion(PrayerLoadResponse.success(prayers: prayers))
        } catch {
            completion(PrayerLoadResponse.error(description: error.localizedDescription))
        }
    }
    static func getOne(uuid: String, withCompletion
                                   completion: (PrayerUpdateResponse) -> Void) {
        do {
            let pray = try PrayerDAO.shared.readOne(uuid: uuid)
            completion(PrayerUpdateResponse.success(prayer: pray))
        } catch {
            completion(PrayerUpdateResponse.error(description: error.localizedDescription))
        }
    }
    static func getActions(uuid: String, withCompletion
                                   completion: (PrayerActionsResponse) -> Void) {
        do {
            let prayer = try PrayerDAO.shared.readOne(uuid: uuid)
            var actions = Actions()
            for actionUUID in prayer.actions {
                let action = try ActionDAO.shared.readOne(uuid: actionUUID)
                actions.append(action)
            }
            completion(PrayerActionsResponse.success(actions: actions))
        } catch {
            completion(PrayerActionsResponse.error(description: error.localizedDescription))
        }
    }
    static func update(pray: Prayer, withCompletion
                                     completion: (PrayerUpdateResponse) -> Void) {
        do {
            try PrayerDAO.shared.update(entity: pray)
            completion(PrayerUpdateResponse.success(prayer: pray))
        } catch {
            completion(PrayerUpdateResponse.error(description: error.localizedDescription))
        }
    }
    static func done(uuid: String, withCompletion
                                     completion: (PrayerUpdateResponse) -> Void) {
        do {
            var prayer = try PrayerDAO.shared.readOne(uuid: uuid)
            prayer.answered = true
            try PrayerDAO.shared.update(entity: prayer)
            for actionUUID in prayer.actions {
                var action = try ActionDAO.shared.readOne(uuid: actionUUID)
                action.completed = true
                try ActionDAO.shared.update(entity: action)
            }
            completion(PrayerUpdateResponse.success(prayer: prayer))
        } catch {
            completion(PrayerUpdateResponse.error(description: error.localizedDescription))
        }
    }
    static func answered(pray: Prayer, withCompletion
                                     completion: (PrayerUpdateResponse) -> Void) {
        do {
            var prayer = pray
            prayer.answered = true
            Notification.disable(with: prayer.uuid)
            try PrayerDAO.shared.update(entity: prayer)
            for actionUUID in prayer.actions {
                Notification.disable(with: actionUUID)
                var action = try ActionDAO.shared.readOne(uuid: actionUUID)
                action.completed = true
                try ActionDAO.shared.update(entity: action)
            }
            completion(PrayerUpdateResponse.success(prayer: pray))
        } catch {
            completion(PrayerUpdateResponse.error(description: error.localizedDescription))
        }
    }
    static func delete(pray: Prayer, withCompletion
                                     completion: (PrayerUpdateResponse) -> Void) {
        do {
            Notification.disable(with: pray.uuid)
            try PrayerDAO.shared.delete(uuid: pray.uuid)
            for actionUUID in pray.actions {
                Notification.disable(with: actionUUID)
                try ActionDAO.shared.delete(uuid: actionUUID)
            }
            completion(PrayerUpdateResponse.success(prayer: pray))
        } catch {
            completion(PrayerUpdateResponse.error(description: error.localizedDescription))
        }
    }
    static private func saveLocally(_ prayers: Prayers) {
        for pray in prayers {
            do {
                try PrayerDAO.shared.create(newEntity: pray)
            } catch {
                NSLog("Error to save task \"\(pray.name)\" locally")
            }
        }
    }
}
