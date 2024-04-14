//
//  Month.swift
//  LogD
//
//  Created by 정종인 on 4/12/24.
//

import Foundation
import SwiftData

@Model
class Month: Identifiable {
    @Attribute(.unique) var id: UUID
    var value: Int
    @Relationship(deleteRule: .cascade) var logs: [Log]
    @Transient var sortedLogs: [Log] {
        self.logs.sorted { $0.createdDate > $1.createdDate }
    }

    init(value: Int, logs: [Log] = []) {
        self.id = UUID()
        self.value = value
        self.logs = logs
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
