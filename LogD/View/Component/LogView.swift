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

    @State private var title: String = ""
    @State private var content: String = ""

    init(log: Binding<Log>, focusState: FocusState<LogFocusType?>.Binding) {
        self._log = log
        self._focusState = focusState
        self._title = State<String>(initialValue: self.log.title)
        self._content = State<String>(initialValue: self.log.content)
    }
    var body: some View {
        VStack(alignment: .leading) {
            TitleTextField()
            ContentTextEditor()
            FooterView()
                .padding(.horizontal, 6)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.background.secondary)
        )
    }

    @ViewBuilder
    private func TitleTextField() -> some View {
        TextField("타이틀", text: $title, axis: .vertical)
            .lineLimit(1...)
            .focused($focusState, equals: .title(log.id))
            .font(.title.bold())
            .padding(.horizontal, 4)
    }

    @ViewBuilder
    private func ContentTextEditor() -> some View {
        TextEditor(text: $content)
            .focused($focusState, equals: .content(log.id))
            .scrollIndicators(.hidden)
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            .background(.clear)
            .frame(minHeight: 32, maxHeight: .infinity)
            .fixedSize(horizontal: false, vertical: true)
    }

    @ViewBuilder
    private func FooterView() -> some View {
        if [.content(self.log.id), .title(self.log.id)].contains(focusState) {
            ConfirmView()
        } else {
            TagsView()
        }
    }

    @ViewBuilder
    private func TagsView() -> some View {
        Text("태그가 여기에 표시됩니당")
    }

    @ViewBuilder
    private func ConfirmView() -> some View {
        HStack(spacing: 8) {
            Button(action: {
                self.focusState = nil
            }, label: {
                HStack {
                    Spacer()
                    Text("취소")
                    Spacer()
                }
            })
            .tint(Color.gray)

            Button(action: {
                self.log.title = self.title
                self.log.content = self.content
                self.focusState = nil
            }, label: {
                HStack {
                    Spacer()
                    Text("완료")
                    Spacer()
                }
            })
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .controlSize(.large)
    }
}

#Preview {
    @FocusState var focusState: LogFocusType?
    return LogView(log: .constant(.mockData), focusState: $focusState)
        .preferredColorScheme(.dark)
}
