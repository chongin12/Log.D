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
        VStack {
            ForEach($month.logs) { log in
                LogView(log: log, focusState: $focusState)
            }
            Button(action: {
                month.logs.append(Log(title: Date.now.description, content: "qwer", tags: []))
            }, label: {
                Text("Button")
            })
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
