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
    @State private var addingLog: Log = .init(title: "", content: "", tags: [])

    @FocusState private var focusState: LogFocusType?
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach($month.logs) { log in
                    LogView(log: log, focusState: $focusState)
                        .contextMenu(ContextMenu(menuItems: {
                            Text("생성 : \(log.wrappedValue.createdDate.formatted())")
                            Button(role: .destructive, action: {
                                self.focusState = nil
                                month.logs.removeAll(where: { $0.id == log.id })
                            }, label: {
                                Label("삭제", systemImage: "trash.fill")
                            })
                        }))
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .searchable(text: $searchText, prompt: "일기를 검색하세요")
        .navigationTitle("\(month.value.description)월")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    let newLog: Log = .emptyData
                    month.logs.insert(newLog, at: 0)
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
}

enum LogFocusType: Hashable {
    case title(UUID)
    case content(UUID)
}

#Preview {
    LogListView(month: .mockData)
        .preferredColorScheme(.dark)
}
