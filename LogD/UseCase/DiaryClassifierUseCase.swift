//
//  DiaryClassifierUseCase.swift
//  LogD
//
//  Created by 정종인 on 4/17/24.
//

import Foundation
import CoreML
import NaturalLanguage

class DiaryClassifierUseCase {
    public static let shared = DiaryClassifierUseCase()
    private let THRESHOLD = 0.08 // 확률이 8% 이상이면 태그로 선정.
    private init() {
    }

    public func predictHypotheses(for content: String) async -> [String : Double] {
        do {
            let diaryClassifierModel = try NLModel(mlModel: DiaryClassifier(configuration: MLModelConfiguration()).model)
            let prediction = diaryClassifierModel.predictedLabelHypotheses(for: content, maximumCount: 21)

            return prediction
        } catch {
            dump(error.localizedDescription)
            return [:]
        }
    }
    
    /// 태그를
    /// - Parameter content: 예측을 원하는 내용이 들어갑니다.
    /// - Returns: 예측 결과 중 ``THRESHOLD``값보다 큰 친구들이 뽑힙니다..
    public func predictTags(for content: String) async -> Set<String> {
        let results = await predictHypotheses(for: content)
        return Set<String>(
            results
                .map { ($0, $1) }
                .filter { $1 >= THRESHOLD }
                .map { label, hypotheses -> String in
                    refinedLabel(label)
                }
        )
    }

    private func refinedLabel(_ label: String) -> String {
        return switch label {
        case "건강":
            "#건강"
        case "가족":
            "#가족"
        case "여행":
            "#여행"
        case "타국가이슈":
            "#외국"
        case "계절,날씨":
            "#환경"
        case "교육":
            "#교육"
        case "회사,아르바이트":
            "#일"
        case "미용":
            "#스타일"
        case "스포츠,레저":
            "#액티비티"
        case "상거래전반":
            "#쇼핑"
        case "연애,결혼":
            "#사랑"
        case "식음료":
            "#음식"
        case "영화,만화":
            "#콘텐츠"
        case "방송,연예":
            "#셀럽"
        case "게임":
            "#게임"
        case "반려동물":
            "#반려동물"
        case "교통":
            "#교통"
        case "사회이슈":
            "#이슈"
        case "주거와생활":
            "#생활"
        case "군대":
            "#군대"
        default:
            ""
        }
    }
}

