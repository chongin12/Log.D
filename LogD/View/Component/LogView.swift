//
//  LogView.swift
//  LogD
//
//  Created by 정종인 on 4/13/24.
//

import SwiftUI

struct LogView: View {
    @Bindable var log: Log

    @FocusState.Binding var focusState: LogFocusType?

    init(log: Log, focusState: FocusState<LogFocusType?>.Binding) {
        self.log = log
        self._focusState = focusState
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleTextField()
            ContentTextEditor()
            FooterView()
                .padding(.horizontal, 4)
                .transition(.identity)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.background.secondary)
        )
        .onChange(of: self.focusState) { oldValue, newValue in
            if case let .content(id) = oldValue, id == self.log.id {
                self.updateTags()
            }
        }
    }

    @ViewBuilder
    private func TitleTextField() -> some View {
        TextField("타이틀", text: $log.title, axis: .vertical)
            .lineLimit(1...)
            .onChange(of: log.title, { oldValue, newValue in
                guard let lastCharacter = newValue.last else { return }
                if lastCharacter == "\n" {
                    log.title.removeLast()
                    self.focusState = .content(self.log.id)
                }
            })
            .submitLabel(.next)
            .focused($focusState, equals: .title(log.id))
            .font(.title.bold())
            .padding(.horizontal, 4)
    }

    @ViewBuilder
    private func ContentTextEditor() -> some View {
        TextEditor(text: $log.content)
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
        if log.isLoadingTags {
            ProgressView()
        } else if [.content(self.log.id), .title(self.log.id)].contains(focusState) {
            EmptyView()
        } else {
            TagsView()
        }
    }

    @ViewBuilder
    private func TagsView() -> some View {
        HStack(spacing: 8) {
            ForEach(self.log.tags.sorted(), id: \.self) { tag in
                Text(tag)
                    .padding(8)
                    .background(
                        Capsule()
                            .fill(.background.tertiary)
                    )
            }
        }
    }

    @MainActor 
    private func updateTags() {
        withAnimation(.bouncy) {
            self.log.isLoadingTags = true
            self.log.updateTags()
        }
    }
}

#Preview {
    @FocusState var focusState: LogFocusType?
    return LogView(log: .mockData, focusState: $focusState)
        .preferredColorScheme(.dark)
}
