//
//  Year.swift
//  LogD
//
//  Created by 정종인 on 4/12/24.
//

import Foundation
import SwiftData

@Model
class Year {
    @Attribute(.unique) var value: Int
    @Relationship(deleteRule: .cascade) var months: [Month]
    @Transient var sortedMonths: [Month] {
        self.months.sorted { $0.value > $1.value }
    }

    init(value: Int, months: [Month] = []) {
        self.value = value
        self.months = months
    }
}

extension Year {
    static var mockData: Year {
        Year(value: 2024, months: .mockData)
    }
}

extension Array where Element == Year {
    static var mockData: Self {
        [
            .init(value: 2024, months: .mockData),
            .init(value: 2023, months: .mockData),
            .init(value: 2022, months: .mockData),
            .init(value: 2021, months: .mockData),
        ]
    }
}
