//
//  ScanInteractorTests.swift
//  ScanMeTests
//
//  Created by Nugroho Arief Widodo on 03/05/23.
//

import XCTest
@testable import ScanMe

final class ScanInteractorTests: XCTestCase {
    var sut: ScanInteractor!
    var presenter: ScanPresenterProtocolSpy!
    var fileService: MockLocalFileService!
    var cloudService: MockCloudService!
    var ocrService: MockOCRService!

    override func setUp() {
        super.setUp()
        sut = ScanInteractor()
        presenter = ScanPresenterProtocolSpy()
        fileService = MockLocalFileService()
        cloudService = MockCloudService()
        ocrService = MockOCRService()
        sut.presenter = presenter
        sut.fileService = fileService
        sut.cloudService = cloudService
        sut.ocrService = ocrService
        sut.picker = UIImagePickerController()
        sut.picker?.sourceType = App.input
        sut.picker?.delegate = sut
    }

    override func tearDown() {
        sut = nil
        presenter = nil
        fileService = nil
        cloudService = nil
        ocrService = nil
        super.tearDown()
    }

    func testAddImage() {
        sut.addImage()
        XCTAssertTrue(presenter.isShowCalled)
        XCTAssertEqual(sut.picker, presenter.picker)
    }

    func testChangeStorage() {
        let storage = ScanMe.Storage.cloudDB
        sut.changeStorage(storage)
        XCTAssertEqual(sut.storage, storage)
    }

    func testLoadExpressionsFromLocalFileReturnSuccess() {
        let storage = ScanMe.Storage.localFile
        sut.storage = storage
        fileService.isError = false
        XCTAssertEqual(sut.expressions.count, 0)
        XCTAssertEqual(presenter.expressions.count, 0)
        sut.loadExpressions()
        XCTAssertTrue(fileService.isDecryptAndLoadCalled)
        XCTAssertTrue(presenter.isDisplayCalled)
        XCTAssertEqual(sut.expressions.count, 2)
        XCTAssertEqual(presenter.expressions.count, 2)
    }

    func testLoadExpressionsFromLocalFileReturnError() {
        let storage = ScanMe.Storage.localFile
        sut.storage = storage
        fileService.isError = true
        XCTAssertEqual(sut.expressions.count, 0)
        XCTAssertEqual(presenter.expressions.count, 0)
        sut.loadExpressions()
        XCTAssertTrue(fileService.isDecryptAndLoadCalled)
        XCTAssertEqual(sut.expressions.count, 0)
        XCTAssertEqual(presenter.expressions.count, 0)
    }


    func testLoadExpressionsFromCloudDBReturnSuccess() {
        let storage = ScanMe.Storage.cloudDB
        sut.storage = storage
        cloudService.isError = false
        XCTAssertEqual(sut.expressions.count, 0)
        XCTAssertEqual(presenter.expressions.count, 0)
        sut.loadExpressions()
        XCTAssertTrue(cloudService.isLoadExpressionsCalled)
        XCTAssertTrue(presenter.isDisplayCalled)
        XCTAssertEqual(sut.expressions.count, 2)
        XCTAssertEqual(presenter.expressions.count, 2)
    }

    func testLoadExpressionsFromCloudDBReturnError() {
        let storage = ScanMe.Storage.cloudDB
        sut.storage = storage
        cloudService.isError = true
        XCTAssertEqual(sut.expressions.count, 0)
        XCTAssertEqual(presenter.expressions.count, 0)
        sut.loadExpressions()
        XCTAssertTrue(cloudService.isLoadExpressionsCalled)
        XCTAssertTrue(presenter.isDisplayMessageCalled)
        XCTAssertEqual(presenter.message, CustomError.unknown.localizedDescription)
        XCTAssertEqual(sut.expressions.count, 0)
        XCTAssertEqual(presenter.expressions.count, 0)
    }

    func testSaveExpressionsToLocalFileReturnSuccess() {
        let storage = ScanMe.Storage.localFile
        sut.storage = storage
        fileService.isError = false
        sut.saveData()
        XCTAssertTrue(fileService.isEncryptAndSaveCalled)
    }

    func testSaveExpressionsToLocalFileReturnError() {
        let storage = ScanMe.Storage.localFile
        sut.storage = storage
        fileService.isError = true
        sut.saveData()
        XCTAssertTrue(fileService.isEncryptAndSaveCalled)
        XCTAssertTrue(presenter.isDisplayMessageCalled)
        XCTAssertEqual(presenter.message, CustomError.unknown.localizedDescription)
    }

    func testSaveExpressionsToCloudDBReturnSuccess() {
        let storage = ScanMe.Storage.cloudDB
        sut.storage = storage
        cloudService.isError = false
        sut.expressions = ExpressionFactory.array()
        sut.saveData()
        XCTAssertTrue(cloudService.isSaveExpressionCalled)
    }

    func testSaveExpressionsToCloudDBReturnError() {
        let storage = ScanMe.Storage.cloudDB
        sut.storage = storage
        cloudService.isError = true
        sut.expressions = ExpressionFactory.array()
        sut.saveData()
        XCTAssertTrue(cloudService.isSaveExpressionCalled)
        XCTAssertTrue(presenter.isDisplayMessageCalled)
        XCTAssertEqual(presenter.message, CustomError.unknown.localizedDescription)
    }

    func testOCRReturnSuccess() {
        guard let picker = sut.picker else {return}
        ocrService.isError = false
        var info: [UIImagePickerController.InfoKey : Any] = [:]
        info[UIImagePickerController.InfoKey.originalImage] = UIImage()
        sut.imagePickerController(picker, didFinishPickingMediaWithInfo: info)
        XCTAssertTrue(presenter.isDisplayNewCalled)
    }

    func testOCRReturnError() {
        guard let picker = sut.picker else {return}
        ocrService.isError = true
        var info: [UIImagePickerController.InfoKey : Any] = [:]
        info[UIImagePickerController.InfoKey.originalImage] = UIImage()
        sut.imagePickerController(picker, didFinishPickingMediaWithInfo: info)
        XCTAssertTrue(presenter.isDisplayMessageCalled)
        XCTAssertEqual(presenter.message, CustomError.expressionNotFound.localizedDescription)
    }
}

class ScanPresenterProtocolSpy: ScanPresenterProtocol {

    var isShowCalled = false
    var isDisplayNewCalled = false
    var isDisplayCalled = false
    var isDisplayMessageCalled = false
    var picker: UIViewController!
    var expressions: [Expression] = []
    var message: String = ""

    func show(picker: UIViewController) {
        isShowCalled = true
        self.picker = picker
    }

    func display(expressions: [ScanMe.Expression]) {
        isDisplayCalled = true
        self.expressions = expressions
    }

    func displayNew(expression: ScanMe.Expression) {
        isDisplayNewCalled = true
    }

    func display(message: String) {
        isDisplayMessageCalled = true
        self.message = message
    }

}

class MockLocalFileService: FileServiceProtocol {

    var isError = false
    var isEncryptAndSaveCalled = false
    var isDecryptAndLoadCalled = false

    func encryptAndSave<T: Codable>(_ array: [T], withPassword password: String, fileName: String) throws {
        isEncryptAndSaveCalled = true
        if isError {
            throw CustomError.unknown
        }
    }

    func decryptAndLoad<T: Codable>(withPassword password: String, fileName: String, type: T.Type) throws -> [T] {
        isDecryptAndLoadCalled = true

        if isError {
            throw CustomError.unknown
        }

        let expressions = ExpressionFactory.array()
        let jsonData = try JSONEncoder().encode(expressions)
        let array = try JSONDecoder().decode([T].self, from: jsonData)
        return array
    }
}


class MockCloudService: CloudServiceProtocol {

    var isError = false
    var isLoadExpressionsCalled = false
    var isSaveExpressionCalled = false

    func saveExpression(_ expression: ScanMe.Expression, completion: @escaping ScanMe.OCRCompletion) {
        isSaveExpressionCalled = true
        if isError {
            completion(.failure(CustomError.unknown))
        } else {
            completion(.success(expression))
        }
    }

    func loadExpressions(completion: @escaping (Result<[ScanMe.Expression], Error>) -> Void) {
        isLoadExpressionsCalled = true

        if isError {
            completion(.failure(CustomError.unknown))
        } else {
            let expressions = ExpressionFactory.array()
            completion(.success(expressions))
        }
    }
}


class MockOCRService: OCRServiceProtocol {

    var isError = false

    func recognizeText(image: UIImage, completion: @escaping ScanMe.OCRCompletion) {

        if isError {
            completion(.failure(CustomError.expressionNotFound))
        } else {
            let expression = ExpressionFactory.single()
            completion(.success(expression))
        }
    }
}
