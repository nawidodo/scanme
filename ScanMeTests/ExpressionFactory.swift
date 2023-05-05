//
//  ExpressionFactory.swift
//  ScanMeTests
//
//  Created by Nugroho Arief Widodo on 04/05/23.
//

@testable import ScanMe
import UIKit

class ExpressionFactory {
    static func single() -> Expression {
        return Expression(input: "2*6", result: 12, date: Date())
    }

    static func array() -> [Expression] {
        return [Expression(input: "2+6", result: 8, date: Date()), Expression(input: "6/2", result: 3, date: Date())]
    }
}
