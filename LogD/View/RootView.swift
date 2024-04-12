//
//  RootView.swift
//  LogD
//
//  Created by 정종인 on 4/12/24.
//

import SwiftUI
import SwiftData

struct RootView: View {
    var body: some View {
        NavigationStack {
            YearListView()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    RootView()
}
