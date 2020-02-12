//
//  ImpactFeedback.swift
//  PropositoClient
//
//  Created by Matheus Silva on 02/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit

class ImpactFeedback {
    private init () { }
    static let shared = ImpactFeedback()
    func generateHeavy() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    func generateMedium() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    func generateLight() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    func generateError() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    func generateSuccess() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    func generateWarning() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
    func generateSelectionChanged() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
