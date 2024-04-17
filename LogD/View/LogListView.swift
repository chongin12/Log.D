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
    @State private var isFlimShowing: Bool = false

    @FocusState private var focusState: LogFocusType?
    var searchResultLogs: [Log] {
        self.month
            .logs
            .filter {
                $0.title.contains(searchText)
                || $0.content.contains(searchText)
                || $0.tags.contains(where: { tag in
                    tag.contains(searchText)
                })
            }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            if searchText.isEmpty {
                ListView()
            } else {
                SearchResultView()
            }
            if isFlimShowing {
                ImageListView()
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "일기를 검색하세요")
        .navigationTitle("\(month.value.description)월")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Toggle(isOn: self.$isFlimShowing) {
                    Image(systemName: "film.fill")
                }
                Button(action: {
                    let newLog: Log = .emptyData
                    month.logs.insert(contentsOf: [newLog], at: .zero)
                    focusState = .title(newLog.id)
                }, label: {
                    Image(systemName: "plus")
                })
            }
        }
        .toolbar {
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

    @ViewBuilder
    private func ListView() -> some View {
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
    }

    @ViewBuilder
    private func SearchResultView() -> some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(searchResultLogs) { log in
                    LogView(log: log, focusState: $focusState)
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
}

import SwiftData

#Preview {
    let fetchDescriptor = FetchDescriptor<Month>()

    let month = try! Year.preview.mainContext.fetch(fetchDescriptor)
    return NavigationStack {
        LogListView(month: month[0])
            .preferredColorScheme(.dark)
            .modelContainer(Year.preview)
    }
}
