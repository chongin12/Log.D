//
//  YearListView.swift
//  LogD
//
//  Created by 정종인 on 4/12/24.
//

import SwiftUI

struct YearListView: View {
    @Query private var years: [Year]

    @State private var isPresentingModal: Bool = false
    @State private var searchText: String = ""
    var body: some View {
        Group {
            if searchText.isEmpty {
                YearListView()
            } else {
                SearchResultView()
            }
        }
        .searchable(text: $searchText, prompt: "일기를 검색하세요")
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
        .fullScreenCover(isPresented: $isPresentingModal, onDismiss: {

        }, content: {
            AddYearView()
                .presentationBackground(.thinMaterial)
        })
    }

    @ViewBuilder
    private func YearListView() -> some View {
        List(years) { year in
//            @Bindable var year = year
            NavigationLink(year.value.description + "년") {
                MonthListView(year: year)
            }
        }
    }

    @ViewBuilder
    private func SearchResultView() -> some View {
        List {
            Text("검색~ : \(searchText)")
        }
    }
}

import SwiftData

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Year.self, configurations: config)

    container.mainContext.insert(Year.mockData)

    return NavigationStack {
        YearListView()
            .preferredColorScheme(.dark)
            .modelContainer(container)
    }
}
