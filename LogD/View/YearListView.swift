//
//  YearListView.swift
//  LogD
//
//  Created by 정종인 on 4/12/24.
//

import SwiftUI
import SwiftData

struct YearListView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Year.value, order: .reverse) private var years: [Year]

    @State private var isPresentingModal: Bool = false
    @State private var searchText: String = ""
    @FocusState private var focusState: LogFocusType?
    var searchResultLogs: [Log] {
        self.years
            .flatMap { year in
                year.months
            }
            .flatMap { month in
                month.logs
            }
            .filter {
                $0.title.contains(searchText)
                || $0.content.contains(searchText)
                || $0.tags.contains(where: { tag in
                    tag.contains(searchText)
                })
            }
    }
    var body: some View {
        Group {
            if searchText.isEmpty {
                ListView()
            } else {
                SearchResultView()
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "일기를 검색하세요")
        .navigationTitle("Log.Yearly")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    isPresentingModal.toggle()
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
        .fullScreenCover(isPresented: $isPresentingModal, onDismiss: {

        }, content: {
            AddYearView(
                insertYear: { year in
                    modelContext.insert(year)
                },
                fetchYearsWithValue: { yearValue in
                    let fetchDescriptor = FetchDescriptor<Year>(predicate: #Predicate { $0.value == yearValue })
                    return try modelContext.fetch(fetchDescriptor)
                }
            )
            .presentationBackground(.thinMaterial)
        })
    }

    @ViewBuilder
    private func ListView() -> some View {
        List(years) { year in
            NavigationLink(year.value.description + "년") {
                MonthListView(year: year) {
                    try? self.modelContext.save()
                }
            }
            .contextMenu {
                Button(role: .destructive, action: {
                    modelContext.delete(year)
                    try? self.modelContext.save()
                }, label: {
                    Label("삭제", systemImage: "trash.fill")
                })
            }
        }
    }

    @ViewBuilder
    private func SearchResultView() -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(searchResultLogs) { log in
                    LogView(log: log, focusState: $focusState)
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    return NavigationStack {
        YearListView()
            .preferredColorScheme(.dark)
            .modelContainer(Year.preview)
    }
}
