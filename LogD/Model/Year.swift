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
    var value: Int
    var months: [Month]

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
