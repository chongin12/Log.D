//
//  MonthDetailView.swift
//  LogD
//
//  Created by 정종인 on 4/12/24.
//

import SwiftUI

struct LogListView: View {
    @Binding var month: Month

    @State private var searchText: String = ""
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    LogListView(month: .constant(.mockData))
}
