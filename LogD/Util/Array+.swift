//
//  String+.swift
//  LogD
//
//  Created by 정종인 on 4/12/24.
//

import Foundation

extension Array where Element: Hashable {
    func unique() -> [Element] {
        Array(Set(self))
    }
}
