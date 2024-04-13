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
    var body: some View {
        Group {
            if searchText.isEmpty {
                List(year.months) { month in
                    NavigationLink(month.value.description + "월") {
                        LogListView(month: month)
                    }
                    Text("개수 : \(month.logs.count)")
                }
            } else {
                List {
                    Text("검색~ : \(searchText)")
                }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "일기를 검색하세요")
        .navigationTitle("Log.\(year.value.description)")
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
            AddMonthView(year: year) { month in
                self.year.months.append(month)
            }
            .presentationBackground(.thinMaterial)
        })
    }
}

#Preview {
    NavigationStack {
        MonthListView(year: .mockData)
            .preferredColorScheme(.dark)
    }
}
