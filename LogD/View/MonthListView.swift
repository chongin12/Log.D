//
//  MonthListView.swift
//  LogD
//
//  Created by 정종인 on 4/12/24.
//

import SwiftUI

struct MonthListView: View {
    @Bindable var year: Year

    @State private var isPresentingModal: Bool = false
    @State private var searchText: String = ""
    @FocusState private var focusState: LogFocusType?

    let modelContextSave: () -> Void

    var searchResultLogs: [Log] {
        self.year
            .months
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
                List(year.sortedMonths) { month in
                    NavigationLink(month.value.description + "월") {
                        LogListView(month: month) {
                            self.modelContextSave()
                        }
                    }
                    .contextMenu {
                        Button(role: .destructive, action: {
                            year.months.removeAll(where: { $0.id == month.id })
                            modelContextSave()
                        }, label: {
                            Label("삭제", systemImage: "trash.fill")
                        })
                    }
                }
            } else {
                SearchResultView()
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "일기를 검색하세요")
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Log.\(year.value.description)년")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    isPresentingModal.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
            }
        }
        .fullScreenCover(isPresented: $isPresentingModal, onDismiss: {

        }, content: {
            AddMonthView(year: year) { month in
                self.year.months.append(month)
            }
            .presentationBackground(.thinMaterial)
        })
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

import SwiftData

#Preview {
    let fetchDescriptor = FetchDescriptor<Year>()

    let years = try! Year.preview.mainContext.fetch(fetchDescriptor)
    return NavigationStack {
        MonthListView(year: years[0], modelContextSave: {})
            .preferredColorScheme(.dark)
    }
}
