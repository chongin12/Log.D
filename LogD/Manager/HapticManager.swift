//
//  HapticManager.swift
//  LogD
//
//  Created by 정종인 on 4/18/24.
//

import Foundation
import SwiftUI

final class HapticManager {
    static let instance = HapticManager()
    private init() {

    }

    public func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    public func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    public func successNotification() {
        self.notification(type: .success)
    }

    public func softImpact() {
        self.impact(style: .soft)
    }
}
