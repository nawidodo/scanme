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
        let jsonData: Data = try JSONEncoder().encode(array)

        // Derive a key from the password
        let key: SymmetricKey = getKeyFromPassword(password: password)

        // Encrypt the data
        let sealedBox: AES.GCM.SealedBox = try AES.GCM.seal(jsonData, using: key)
        let encryptedData: Data? = sealedBox.combined

        // Save the encrypted data to the document directory
        let documentsDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let encryptedDataFileURL: URL = documentsDirectory.appendingPathComponent(fileName)
        try encryptedData?.write(to: encryptedDataFileURL)
    }

    func decryptAndLoad<T: Codable>(withPassword password: String, fileName: String, type: T.Type) throws -> [T] {
        // Load the encrypted data from the document directory
        let documentsDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let encryptedDataFileURL:URL = documentsDirectory.appendingPathComponent(fileName)

        guard FileManager.default.fileExists(atPath: encryptedDataFileURL.path) else { return [] }

        let encryptedData: Data = try Data(contentsOf: encryptedDataFileURL)

        // Derive a key from the password
        let key: SymmetricKey = getKeyFromPassword(password: password)

        // Decrypt the data
        let sealedBox: AES.GCM.SealedBox = try .init(combined: encryptedData)
        let decryptedData: Data = try AES.GCM.open(sealedBox, using: key)

        // Convert the decrypted data to an array of structs
        let array: [T] = try JSONDecoder().decode([T].self, from: decryptedData)
        return array
    }


    // Function to derive a key from a string password
    private func getKeyFromPassword(password: String) -> SymmetricKey {
        // Use SHA-256 to derive a key from the password
        let keyData: any Digest = SHA256.hash(data: password.data(using: .utf8)!)
        return SymmetricKey(data: keyData)
    }

}
