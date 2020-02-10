//
//  ChapterDAO.swift
//  PropositoClient
//
//  Created by Matheus Silva on 09/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import Foundation

class ChapterDAO: GenericDAO {
    typealias T = Chapter
    static let shared: ChapterDAO = ChapterDAO()
    private init() {}
    
    func create(newEntity: Chapter) throws {
        throw DAOError.internalError(description: "Not implemented")
    }
    func read() throws -> [Chapter] {
        let location = "Chapter"
        let fileType = "json"
        guard let path = Bundle.main.path(forResource: location, ofType: fileType) else {
            throw DAOError.internalError(description: "JSON not found")
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let chapters = try JSONDecoder().decode(Chapters.self, from: data)
            return chapters
        } catch {
            throw DAOError.internalError(description: error.localizedDescription)
        }
    }
    func readOne(uuid: String) throws -> Chapter {
        throw DAOError.internalError(description: "Not implemented")
    }
    func update(entity: Chapter) throws {
        throw DAOError.internalError(description: "Not implemented")
    }
    func delete(uuid: String) throws {
        throw DAOError.internalError(description: "Not implemented")
    }
}
