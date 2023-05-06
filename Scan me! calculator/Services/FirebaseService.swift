//
//  FirebaseService.swift
//  Scan me! calculator
//
//  Created by Nugroho Arief Widodo on 03/05/23.
//

import FirebaseFirestore

protocol CloudServiceProtocol {
    func saveExpression(_ expression: Expression, completion: @escaping ExpressionCompletion)
    func loadExpressions(completion: @escaping (Result<[Expression], Error>) -> Void)
}

class FirebaseService: CloudServiceProtocol {

    private let expressionsKey: String = "expressions"
    private let inputKey: String = "input"
    private let resultKey: String = "result"
    private let dateKey: String = "date"

    func saveExpression(_ expression: Expression, completion: @escaping ExpressionCompletion) {
        let db: Firestore = .firestore()
        let ref: CollectionReference = db.collection(expressionsKey)

        // Convert each Expression object to a dictionary
        let expressionsDict: [String : Any] =
            [
                inputKey: expression.input,
                resultKey: expression.result,
                dateKey: Timestamp(date: expression.date)
            ]

        // Add the array of dictionaries to Firestore
        ref.addDocument(data: expressionsDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(expression))
            }
        }
    }

    func loadExpressions(completion: @escaping (Result<[Expression], Error>) -> Void) {
        let db: Firestore = .firestore()
        let ref: CollectionReference = db.collection(expressionsKey)

         // Get all documents from the "expressions" collection
         ref.getDocuments { snapshot, error in
             if let error = error {
                 completion(.failure(error))
                 return
             }

             guard let snapshot = snapshot else {
                 completion(.failure(CustomError.unknown))
                 return
             }

             // Convert each document to an Expression object
             let expressions: [Expression] = snapshot.documents.compactMap { document -> Expression? in
                 let data = document.data()
                 guard let input = data[self.inputKey] as? String,
                       let result = data[self.resultKey] as? Int,
                       let dateTimestamp = data[self.dateKey] as? Timestamp
                 else { return nil }

                 let date: Date = dateTimestamp.dateValue()
                 return Expression(input: input, result: result, date: date)
             }

             completion(.success(expressions))
         }
    }

}
