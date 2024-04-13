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
            ForEach($month.logs) { log in
                LogView(log: log, focusState: $focusState)
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

                }, label: {
                    Image(systemName: "plus")
                })
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
