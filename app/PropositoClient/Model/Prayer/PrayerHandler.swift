//
//  PrayHandler.swift
//  PropositoClient
//
//  Created by Matheus Gois on 05/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit

enum PrayerLoadResponse: Error {
    case success(prayers: [Prayer])
    case error(description: String)
}

enum PrayerUpdateResponse: Error {
    case success(pray: Prayer)
    case error(description: String)
}

class PrayerHandler {
    static func create(pray: Prayer, withCompletion
                                     completion: (PrayerUpdateResponse) -> Void) {
        do {
            try PrayerDAO.shared.create(newEntity: pray)
            completion(PrayerUpdateResponse.success(pray: pray))
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
            completion(PrayerUpdateResponse.success(pray: pray))
        } catch {
            completion(PrayerUpdateResponse.error(description: error.localizedDescription))
        }
    }
    static func update(pray: Prayer, withCompletion
                                     completion: (PrayerUpdateResponse) -> Void) {
        do {
            try PrayerDAO.shared.update(entity: pray)
            completion(PrayerUpdateResponse.success(pray: pray))
        } catch {
            completion(PrayerUpdateResponse.error(description: error.localizedDescription))
        }
    }
    static func delete(pray: Prayer, withCompletion
                                     completion: (PrayerUpdateResponse) -> Void) {
        do {
            try PrayerDAO.shared.delete(entity: pray)
            completion(PrayerUpdateResponse.success(pray: pray))
        } catch {
            completion(PrayerUpdateResponse.error(description: error.localizedDescription))
        }
    }
    static private func saveLocally(_ prayers: [Prayer]) {
        for pray in prayers {
            do {
                try PrayerDAO.shared.create(newEntity: pray)
            } catch {
                NSLog("Error to save task \"\(pray.name)\" locally")
            }
        }
    }
}
