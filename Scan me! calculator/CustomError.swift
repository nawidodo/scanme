//
//  CustomError.swift
//  Scan me! calculator
//
//  Created by Nugroho Arief Widodo on 03/05/23.
//

import Foundation

enum CustomError: LocalizedError {
    case unknown
    case expressionNotFound

    var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("An unknown error occurred.", comment: "")
        case .expressionNotFound:
            return NSLocalizedString("A valid expression was not found.", comment: "")
        }
    }
}
