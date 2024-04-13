//
//  LogView.swift
//  LogD
//
//  Created by 정종인 on 4/13/24.
//

import SwiftUI

struct LogView: View {
    @Binding var log: Log
    @FocusState.Binding var focusState: LogFocusType?
    var body: some View {
        VStack {
            TitleTextFieldView()
            TextEditor(text: $log.content)
                .focused($focusState, equals: .content(log.id))
                .scrollIndicators(.hidden)
                .scrollContentBackground(.hidden)
                .background(.clear)
                .frame(minHeight: 32, maxHeight: .infinity)
                .fixedSize(horizontal: false, vertical: true)
            if [.content(self.log.id), .title(self.log.id)].contains(focusState) {
                Text("까꿍")
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.background.secondary)
        )
    }

    @ViewBuilder
    private func TitleTextFieldView() -> some View {
        TextField("타이틀", text: $log.title)
            .focused($focusState, equals: .title(log.id))
            .font(.title.bold())
            .padding(.horizontal, 4)
    }
}

#Preview {
    @FocusState var focusState: LogFocusType?
    return LogView(log: .constant(.mockData), focusState: $focusState)
        .preferredColorScheme(.dark)
}
