//
//  AddYearView.swift
//  LogD
//
//  Created by 정종인 on 4/12/24.
//

import SwiftUI

struct AddYearView: View {
    @Environment(\.dismiss) private var dismiss

    let insertYear: (Year) -> Void
    let fetchYearsWithValue: (Int) throws -> [Year]

    @State private var inputText: String = ""
    @State private var validateStatus: ValidateType = .none
    @FocusState private var focusField: Bool

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                YearInputView()
                ValidatingText()
                Spacer()
                DoneButton()
            }
            .navigationTitle("연도 추가")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                    .symbolRenderingMode(.hierarchical)
                }
            }
        }
        .onAppear {
            focusField = true
        }
        .onTapGesture {
            focusField = false
        }
    }
}

// MARK: - Private Views
extension AddYearView {
    @ViewBuilder
    private func YearInputView() -> some View {
        HStack {
            Spacer()
            TextField("연도 입력", text: $inputText, prompt: Text("____"))
                .font(.system(size: 64, weight: .bold))
                .keyboardType(.numberPad)
                .fixedSize()
                .focused($focusField)
                .onChange(of: inputText) { oldValue, newValue in
                    Task {
                        self.validateStatus = await self.validate()
                    }
                }
            Text("년")
                .font(.title)
                .fontWeight(.regular)
            Spacer()
        }
    }

    @ViewBuilder
    private func ValidatingText() -> some View {
        switch validateStatus {
        case .none:
            EmptyView()
        case .success:
            Text("✅ 해당 연도를 추가할 수 있습니다.")
                .font(.footnote)
                .foregroundStyle(.green)
        case .alreadyExist:
            Text("해당 내용은 이미 있어요 👀")
                .font(.footnote)
                .foregroundStyle(.orange)
        case .notANumber:
            Text("숫자가 아닌 것 같아요 👀")
                .font(.footnote)
                .foregroundStyle(.orange)
        case .outOfRange:
            Text("입력 가능한 범위를 벗어났어요 👀")
                .font(.footnote)
                .foregroundStyle(.orange)
        case .pending:
            ProgressView("값을 판별하고 있습니다")
        case .unknownError:
            Text("에러 발생! 잠시 후 다시 시도해주세요 👀")
                .font(.footnote)
                .foregroundStyle(.orange)
        }
    }

    @ViewBuilder
    private func DoneButton() -> some View {
        Button(action: {
            if let yearValue = Int(inputText) {
                self.insertYear(Year(value: yearValue))
            }
            dismiss()
        }, label: {
            HStack {
                Spacer()
                Text("완료")
                    .font(.title3.bold())
                    .padding()
                Spacer()
            }
            .background(Color.green)
            .frame(minHeight: 20)
        })
        .buttonStyle(.plain)
        .disabled(self.validateStatus != .success)
    }
}

import SwiftData

// MARK: - Private Logics
extension AddYearView {
    @MainActor
    private func validate() -> ValidateType {
        if inputText.isEmpty {
            return .none
        }
        if let yearValue = Int(inputText) {
            if 1000..<10000 ~= yearValue {
                if let sameModels = try? self.fetchYearsWithValue(yearValue) {
                    return sameModels.isEmpty ? .success : .alreadyExist
                } else {
                    return .unknownError
                }
            } else {
                return .outOfRange
            }
        } else {
            return .notANumber
        }
    }
}

#Preview {
    AddYearView(insertYear: { _ in }, fetchYearsWithValue: { _ in [] })
        .preferredColorScheme(.dark)
}
