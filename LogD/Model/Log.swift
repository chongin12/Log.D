//
//  Log.swift
//  LogD
//
//  Created by 정종인 on 4/12/24.
//

import Foundation

struct Log: Codable, Hashable {
    var title: String
    var content: String
    var tags: Set<String>
}

extension Array where Element == Log {
    static var mockData: Self {
        [
            Log(title: "12일", content: "12일의 내용", tags: ["태그1", "태그2"]),
            Log(title: "11일", content: "11일의 내용\n이번엔 두줄짜리", tags: ["태그1", "태그2"]),
            Log(title: "10일", content: "10일의 내용 이번엔 쫌 길게 텍스트를 써보려고 합니다. 몇 줄이 될진 모르겠지만 충분했으면 좋겠네요. 으하하ㅓ허하헣허허ㅓ.......", tags: ["태그1", "태그2"])
        ]
    }
}