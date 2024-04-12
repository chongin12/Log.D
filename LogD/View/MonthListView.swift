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
                List($year.months, id: \.self) { month in
                    var monthValue: Month {
                        month.wrappedValue
                    }
                    NavigationLink(monthValue.value.description + "월") {
                        LogListView(month: month)
                    }
                }
            } else {
                List {
                    Text("검색~ : \(searchText)")
                }
            }
        }
        .searchable(text: $searchText, prompt: "일기를 검색하세요")
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
            AddYearView()
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
