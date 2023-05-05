//
//  FileServiceTests.swift
//  ScanMeTests
//
//  Created by Nugroho Arief Widodo on 04/05/23.
//

import XCTest
@testable import ScanMe

final class FileServiceTests: XCTestCase {
    let privateKey = UUID().uuidString
    let fileName = "test.enc"
    var sut: FileService!

    override func setUp() {
        super.setUp()
        sut = FileService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testSaveToLocalFileReturnSuccess() {
        let expressions = ExpressionFactory.array()
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(fileName)

        do {
            if fileManager.fileExists(atPath: fileURL.path()) {
                try fileManager.removeItem(at: fileURL)
            }
            try sut.encryptAndSave(expressions, withPassword: privateKey, fileName: fileName)
            XCTAssertTrue(fileManager.fileExists(atPath: fileURL.path()))
        } catch (_) {
            XCTFail()
        }
    }

    func testSaveToLocalFileReturnError() {
        let fileName = #":/exp.enc"#
        let expressions = ExpressionFactory.array()
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(fileName)

        do {
            if fileManager.fileExists(atPath: fileURL.path()) {
                try fileManager.removeItem(at: fileURL)
            }
            try sut.encryptAndSave(expressions, withPassword: privateKey, fileName: fileName)
            XCTFail()
        } catch (_) {
            XCTAssertFalse(fileManager.fileExists(atPath: fileURL.path()))
        }
    }

    func testLoadToLocalFileReturnSuccess() {
        let expressions = ExpressionFactory.array()
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(fileName)

        do {
            if fileManager.fileExists(atPath: fileURL.path()) {
                try fileManager.removeItem(at: fileURL)
            }
            try sut.encryptAndSave(expressions, withPassword: privateKey, fileName: fileName)
            XCTAssertTrue(fileManager.fileExists(atPath: fileURL.path()))
            let expressions = try sut.decryptAndLoad(withPassword: privateKey, fileName: fileName, type: Expression.self)
            XCTAssertFalse(expressions.isEmpty)
        } catch (_) {
            XCTFail()
        }
    }

    func testLoadToLocalFileReturnError() {
        let expressions = ExpressionFactory.array()
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(fileName)

        do {
            if fileManager.fileExists(atPath: fileURL.path()) {
                try fileManager.removeItem(at: fileURL)
            }
            try sut.encryptAndSave(expressions, withPassword: privateKey, fileName: fileName)
            XCTAssertTrue(fileManager.fileExists(atPath: fileURL.path()))
            let expressions = try sut.decryptAndLoad(withPassword: UUID().uuidString, fileName: fileName, type: Expression.self)
            XCTFail()
        } catch (let err) {
            XCTAssertNotNil(err)
        }
    }
}
