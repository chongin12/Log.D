//
//  Film.swift
//  LogD
//
//  Created by 정종인 on 4/16/24.
//

import Foundation
import SwiftUI

struct Film: Identifiable {
    let date: Date?
    let image: Image
    let id: UUID

    init(date: Date?, image: Image) {
        self.date = date
        self.image = image
        self.id = UUID()
    }
}
