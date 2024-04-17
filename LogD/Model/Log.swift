//
//  Log.swift
//  LogD
//
//  Created by 정종인 on 4/12/24.
//

import Foundation
import SwiftData

@Model
class Log: Identifiable {
    var id: UUID
    var title: String
    var content: String
    var tags: Set<String>
    var createdDate: Date

    @Attribute(.ephemeral) var isLoadingTags: Bool = false

    init(title: String, content: String, tags: Set<String>) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.tags = tags
        self.createdDate = .now
    }
}

extension Log {
    @MainActor
    public func updateTags() {
        Task {
            self.tags = await generateTags(self.content)
            isLoadingTags = false
        }
    }
}

extension Log {
    private func generateTags(_ content: String?) async -> Set<String> {
//        try! await Task.sleep(nanoseconds: 1_000_000_000)
//        return ["tag\(Int.random(in: 0..<100))", "tag2"]
        guard let content else { return [] }
        return await DiaryClassifierUseCase.shared.predictTags(for: content)
    }
}

extension Log: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.title)
        hasher.combine(self.content)
        hasher.combine(self.tags)
        hasher.combine(self.id)
    }
}

extension Log {
    static var mockData: Log {
        Log(title: "12일 인데 제목이 깁니다 하나둘셋넷 하나둘셋 하나둘셋", content: "12일의 내용 하나둘셋넷다섯 하나둘셋넷 하나둘셋 하나둘 하나", tags: ["태그1", "태그2"])
    }

    static var emptyData: Log {
        Log(title: "", content: "", tags: [])
    }
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
