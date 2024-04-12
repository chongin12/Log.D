//
//  MonthDetailView.swift
//  LogD
//
//  Created by 정종인 on 4/12/24.
//

import SwiftUI

struct LogListView: View {
    @Bindable var month: Month
    var logs: [Log] {
        self.month.logs
    }

    @State private var searchText: String = ""
    var body: some View {
        VStack {
            List(month.logs, id: \.self) { log in
                Text(log.content)
            }
            Button(action: {
                month.logs.append(Log(title: Date.now.description, content: "qwer", tags: []))
            }, label: {
                Text("Button")
            })
        }
        .onChange(of: month.logs) {
            dump("logs : \(month.logs)")
        }
    }
}

#Preview {
    LogListView(month: .mockData)
        .preferredColorScheme(.dark)
}
