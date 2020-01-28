//
//  GenericDAO.swift
//  PropositoClient
//
//  Created by Matheus Gois on 05/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Foundation

enum DAOError: Error {
    case invalidData(description: String)
    case internalError(description: String)
}

protocol GenericDAO {
    associatedtype T
    
    func create(newEntity: T) throws
    func read() throws -> [T]
    func findByID(id: UUID) throws -> T
    func update(entity: T) throws
    func delete(entity: T) throws
}
