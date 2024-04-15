//
//  MonthDetailView.swift
//  LogD
//
//  Created by 정종인 on 4/12/24.
//

import SwiftUI

struct LogListView: View {
    @Bindable var month: Month

    @State private var searchText: String = ""

    @FocusState private var focusState: LogFocusType?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(month.sortedLogs) { log in
                    LogView(log: log, focusState: $focusState)
                        .contextMenu {
                            Text("생성 : \(log.createdDate.formatted())")
                            Button(role: .destructive, action: {
                                self.focusState = nil
                                month.logs.removeAll(where: { $0.id == log.id })
                            }, label: {
                                Label("삭제", systemImage: "trash.fill")
                            })
                        }
                }
                .listStyle(.plain)
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "일기를 검색하세요")
        .navigationTitle("\(month.value.description)월")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    let newLog: Log = .emptyData
                    month.logs.insert(contentsOf: [newLog], at: .zero)
                    focusState = .title(newLog.id)
                }, label: {
                    Image(systemName: "plus")
                })
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                if case let .title(id) = self.focusState {
                    Button("다음") {
                        self.focusState = .content(id)
                    }
                } else {
                    Button("완료") {
                        self.focusState = nil
                    }
                }
            }
        }
    }

    private func generateTags(_ content: String?) async -> Set<String> {
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        return ["tag1", "tag2"]
    }
}

import SwiftData

#Preview {
    let fetchDescriptor = FetchDescriptor<Month>()

    let month = try! Year.preview.mainContext.fetch(fetchDescriptor)
    return LogListView(month: month[0])
        .preferredColorScheme(.dark)
        .modelContainer(Year.preview)
}
