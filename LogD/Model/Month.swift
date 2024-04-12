//
//  Month.swift
//  LogD
//
//  Created by 정종인 on 4/12/24.
//

import Foundation

struct Month: Codable, Hashable {
    var value: Int
    var logs: [Log]
}

extension Month {
    static var mockData: Self {
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
