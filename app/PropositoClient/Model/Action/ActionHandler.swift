//
//  ActHandler.swift
//  PropositoClient
//
//  Created by Matheus Gois on 08/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Foundation

enum ActionLoadResponse: Error {
    case success(acts: [Action])
    case error(description: String)
}

enum ActionUpdateResponse: Error {
    case success(act: Action)
    case error(description: String)
}

class ActionHandler {
    static func create(act: Action, withCompletion completion: (ActionUpdateResponse) -> Void) {
        do {
            try ActionDAO.shared.create(newEntity: act)
            completion(ActionUpdateResponse.success(act: act))
        } catch {
            completion(ActionUpdateResponse.error(description: error.localizedDescription))
        }
    }
    static func getAll(completion: @escaping (ActionLoadResponse) -> Void) {
        do {
            let acts = try ActionDAO.shared.read()
            completion(ActionLoadResponse.success(acts: acts))
        } catch {
            completion(ActionLoadResponse.error(description: error.localizedDescription))
        }
    }
    static func getOne(uuid: String, withCompletion
        completion: (ActionUpdateResponse) -> Void) {
        do {
            let act = try ActionDAO.shared.readOne(uuid: uuid)
            completion(ActionUpdateResponse.success(act: act))
        } catch {
            completion(ActionUpdateResponse.error(description: error.localizedDescription))
        }
    }
    static func update(act: Action, withCompletion completion: (ActionUpdateResponse) -> Void) {
        do {
            try ActionDAO.shared.update(entity: act)
            completion(ActionUpdateResponse.success(act: act))
        } catch {
            completion(ActionUpdateResponse.error(description: error.localizedDescription))
        }
    }
    static func delete(act: Action, withCompletion
        completion: (ActionUpdateResponse) -> Void) {
        do {
            try ActionDAO.shared.delete(entity: act)
            completion(ActionUpdateResponse.success(act: act))
        } catch {
            completion(ActionUpdateResponse.error(description: error.localizedDescription))
        }
    }
    static private func saveLocally(_ acts: [Action]) {
        for act in acts {
            do {
                try ActionDAO.shared.create(newEntity: act)
            } catch {
                NSLog("Error to save task \"\(act.name)\" locally")
            }
        }
    }
}
