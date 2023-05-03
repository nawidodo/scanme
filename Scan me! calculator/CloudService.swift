//
//  CloudService.swift
//  Scan me! calculator
//
//  Created by Nugroho Arief Widodo on 03/05/23.
//

import FirebaseFirestore

protocol CloudServiceProtocol {
    func saveExpression(_ expression: Expression, completion: @escaping OCRCompletion)
    func loadExpressions(completion: @escaping (Result<[Expression], Error>) -> Void)
}

class FirebaseService: CloudServiceProtocol {

    func saveExpression(_ expression: Expression, completion: @escaping OCRCompletion) {
        let db = Firestore.firestore()
        let ref = db.collection("expressions")

        // Convert each Expression object to a dictionary
        let expressionsDict: [String : Any] =
            [
                "input": expression.input,
                "result": expression.result,
                "date": Timestamp(date: expression.date)
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
        let db = Firestore.firestore()
         let ref = db.collection("expressions")

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
             let expressions = snapshot.documents.compactMap { document -> Expression? in
                 let data = document.data()
                 guard let input = data["input"] as? String,
                       let result = data["result"] as? Int,
                       let dateTimestamp = data["date"] as? Timestamp
                 else { return nil }

                 let date = dateTimestamp.dateValue()
                 return Expression(input: input, result: result, date: date)
             }

             completion(.success(expressions))
         }
    }

}
