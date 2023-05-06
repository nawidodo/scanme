//
//  OCRService.swift
//  Scan me! calculator
//
//  Created by Nugroho Arief Widodo on 03/05/23.
//

import Vision
import UIKit


protocol OCRServiceProtocol {
    func recognizeText(image: UIImage, completion: @escaping ExpressionCompletion)
}

typealias ExpressionCompletion = (Result<Expression, Error>) -> Void

class OCRService: OCRServiceProtocol {

    func recognizeText(image: UIImage, completion: @escaping ExpressionCompletion) {
        // Create a VNImageRequestHandler to process the image
        let requestHandler: VNImageRequestHandler = .init(cgImage: image.cgImage!, options: [:])

        // Create a VNRecognizeTextRequest to recognize text in the image
        let request: VNRecognizeTextRequest = .init { [weak self] (request, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            // Handle the recognition results
            guard let observations: [VNRecognizedTextObservation] = request.results as? [VNRecognizedTextObservation] else {
                completion(.failure(CustomError.unknown))
                return
            }

            // Process the recognized text
            let recognizedStrings: [String] = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }

            print("Recognize: \(recognizedStrings)")
            if let expression: Expression = self?.parseValidText(recognizedStrings) {
                completion(.success(expression))
            } else {
                completion(.failure(CustomError.expressionNotFound))
            }
        }

        // Set the recognition level to accurate for higher accuracy
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        // Perform the text recognition request
        do {
            try requestHandler.perform([request])
        } catch (let error){
            completion(.failure(error))
        }
    }

    private func parseValidText(_ strings: [String]) -> Expression? {

        for text in strings {
            let input: String = text.replacingOccurrences(of: " ", with: "")
            let pattern: String = #"^\s*(\d+)\s*([-+*/])\s*(\d+)"#
            let regex: NSRegularExpression = try! .init(pattern: pattern)
            let range: NSRange = .init(input.startIndex..<input.endIndex, in: input)
            let operatorCharacterSet: CharacterSet = .init(charactersIn: "+-*/")
            let components: [String] = input.components(separatedBy: operatorCharacterSet)

            if let _ = regex.firstMatch(in: input,
                                        options: [],
                                        range: range),
               components.count >= 2,
               let left: Int = .init(components[0]),
               let right: Int = .init(components[1]) {

                let operatorIndex: String.Index = input.rangeOfCharacter(from: operatorCharacterSet)!.lowerBound
                let operatorString: String = .init(input[operatorIndex])
                    var result = 0

                    switch operatorString {
                    case "+":
                        result = left + right
                    case "-":
                        result = left - right
                    case "*":
                        result = left * right
                    case "/":
                        result = left / right
                    default:
                        break
                    }

                return Expression(input: "\(left)\(operatorString)\(right)", result: result, date: Date())
            }
        }

        return nil
    }
}
