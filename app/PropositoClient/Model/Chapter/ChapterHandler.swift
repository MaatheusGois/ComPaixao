//
//  ChapterHandler.swift
//  PropositoClient
//
//  Created by Matheus Silva on 10/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import Foundation

enum ChaptersLoadResponse: Error {
    case success(chapters: Chapters)
    case error(description: String)
}
enum ChapterLoadResponse: Error {
    case success(chapter: Chapter)
    case error(description: String)
}

class ChapterHandler {
    static func getAll(completion: @escaping (ChaptersLoadResponse) -> Void) {
        do {
            let chapters = try ChapterDAO.shared.read()
            completion(ChaptersLoadResponse.success(chapters: chapters))
        } catch {
            completion(ChaptersLoadResponse.error(description: error.localizedDescription))
        }
    }
    static func getOne(withCompletion
        completion: (ChapterLoadResponse) -> Void) {
        do {
            let chapters = try ChapterDAO.shared.read()
            let index = Date().get(.day) + (Date().get(.month) * 30)
            let chapter = chapters[index]
            completion(ChapterLoadResponse.success(chapter: chapter))
        } catch {
            completion(ChapterLoadResponse.error(description: error.localizedDescription))
        }
    }
}
