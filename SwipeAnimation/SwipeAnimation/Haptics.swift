//
//  Haptics.swift
//  PRTracker
//
//  Created by robevans on 1/3/22.
//

import Foundation
import SwiftUI

func playHaptic(style: String) {
    switch style {
    case "error":
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    case "heavy":
        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
        impactMed.impactOccurred()
    case "medium":
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
        impactMed.impactOccurred()
    default:
        let impactMed = UIImpactFeedbackGenerator(style: .light)
        impactMed.impactOccurred()
    }
}
