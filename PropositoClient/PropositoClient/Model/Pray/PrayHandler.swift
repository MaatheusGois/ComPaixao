//
//  PrayHandler.swift
//  PropositoClient
//
//  Created by Matheus Gois on 05/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

enum PrayLoadResponse: Error {
    case success(prayers: [Pray])
    case error(description: String)
}

enum PrayUpdateResponse: Error {
    case success(pray: Pray)
    case error(description: String)
}

class PrayHandler {
    static func create(pray:Pray, withCompletion completion:(PrayUpdateResponse) -> Void) {
        do {
            try PrayDAO.shared.create(newEntity: pray)
            completion(PrayUpdateResponse.success(pray: pray))
        } catch {
            completion(PrayUpdateResponse.error(description: "OPS!! we have a problem to create your pray"))
        }
    }
    
    static func loadPrayWith(completion: @escaping (PrayLoadResponse) -> Void) {
        do {
            let prayers = try PrayDAO.shared.read()
            completion(PrayLoadResponse.success(prayers: prayers))
        } catch {
            completion(PrayLoadResponse.error(description: "OPS!! we have a problem to read your prayers"))
        }
    }
    static func findByID(id: Int, withCompletion completion:(PrayUpdateResponse) -> Void) {
        do {
            let pray = try PrayDAO.shared.findByID(id: id)
            completion(PrayUpdateResponse.success(pray: pray))
        }catch{
            completion(PrayUpdateResponse.error(description: "OPS!! We have a problem to update your Task"))
        }
    }
    static func update(pray: Pray, withCompletion completion:(PrayUpdateResponse) -> Void) {
        do {
            try PrayDAO.shared.update(entity: pray)
            completion(PrayUpdateResponse.success(pray: pray))
        }catch{
            completion(PrayUpdateResponse.error(description: "OPS!! We have a problem to update your Task"))
        }
    }
    
    static func delete(pray: Pray, withCompletion completion:(PrayUpdateResponse) -> Void) {
        do {
            try PrayDAO.shared.delete(entity: pray)
            completion(PrayUpdateResponse.success(pray: pray))
        }catch{
            completion(PrayUpdateResponse.error(description: "OPS!! We have a problem to delete your Task"))
        }
    }
    static private func saveLocally(_ prayers: [Pray]) {
        for pray in prayers {
            do {
                try PrayDAO.shared.create(newEntity: pray)
            }catch{
                print("Error to save task \"\(pray.title)\" locally");
            }
        }
    }
}
