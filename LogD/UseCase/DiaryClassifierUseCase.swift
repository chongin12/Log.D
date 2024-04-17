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
    private var mlModel: MLModel? = nil
    private init() {
        self.mlModel = try? DiaryClassifier(configuration: MLModelConfiguration()).model

        dump(self.mlModel)
    }

    public func predict(for content: String) async -> String? {
        guard let featureProvider = try? MLDictionaryFeatureProvider(dictionary: ["text": content]) else { return nil }
//        let modelInput = DiaryClassifierInput(text: content)
        let prediction = try? await self.mlModel?.prediction(from: featureProvider)

        dump(prediction)
        return prediction.debugDescription
    }
}
