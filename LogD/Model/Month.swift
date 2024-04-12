//
//  Month.swift
//  LogD
//
//  Created by 정종인 on 4/12/24.
//

import Foundation

@Observable
class Month: Codable, Hashable {
    var value: Int
    var logs: [Log]

    init(value: Int, logs: [Log]) {
        self.value = value
        self.logs = logs
    }

    static func == (lhs: Month, rhs: Month) -> Bool {
        lhs.value == rhs.value
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.value)
        hasher.combine(self.logs)
    }
}

extension Month {
    static var mockData: Month {
        Month(value: 5, logs: .mockData)
    }
}

extension Array where Element == Month {
    static var mockData: Self {
        [
            .init(value: 1, logs: .mockData),
            .init(value: 2, logs: .mockData),
            .init(value: 3, logs: .mockData),
            .init(value: 4, logs: .mockData),
            .init(value: 5, logs: .mockData),
        ]
    }
}
