//
//  FileService.swift
//  Scan me! calculator
//
//  Created by Nugroho Arief Widodo on 03/05/23.
//

import Foundation
import CryptoKit

protocol FileServiceProtocol {
    func encryptAndSave<T: Codable>(_ array: [T], withPassword password: String, fileName: String) throws
    func decryptAndLoad<T: Codable>(withPassword password: String, fileName: String, type: T.Type) throws -> [T]
}

class FileService: FileServiceProtocol {

    func encryptAndSave<T: Codable>(_ array: [T], withPassword password: String, fileName: String) throws {
        // Convert the array to data
        let jsonData = try JSONEncoder().encode(array)

        // Derive a key from the password
        let key = getKeyFromPassword(password: password)

        // Encrypt the data
        let sealedBox = try AES.GCM.seal(jsonData, using: key)
        let encryptedData = sealedBox.combined

        // Save the encrypted data to the document directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let encryptedDataFileURL = documentsDirectory.appendingPathComponent(fileName)
        try encryptedData?.write(to: encryptedDataFileURL)
    }

    func decryptAndLoad<T: Codable>(withPassword password: String, fileName: String, type: T.Type) throws -> [T] {
        // Load the encrypted data from the document directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let encryptedDataFileURL = documentsDirectory.appendingPathComponent(fileName)

        guard FileManager.default.fileExists(atPath: encryptedDataFileURL.path) else { return [] }

        let encryptedData = try Data(contentsOf: encryptedDataFileURL)

        // Derive a key from the password
        let key = getKeyFromPassword(password: password)

        // Decrypt the data
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)

        // Convert the decrypted data to an array of structs
        let array = try JSONDecoder().decode([T].self, from: decryptedData)
        return array
    }


    // Function to derive a key from a string password
    private func getKeyFromPassword(password: String) -> SymmetricKey {
        // Use SHA-256 to derive a key from the password
        let keyData = SHA256.hash(data: password.data(using: .utf8)!)
        return SymmetricKey(data: keyData)
    }

}
