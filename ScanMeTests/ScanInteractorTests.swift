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
        sut = .init()
        presenter = .init()
        fileService = .init()
        cloudService = .init()
        ocrService = .init()
        sut.presenter = presenter
        sut.fileService = fileService
        sut.cloudService = cloudService
        sut.ocrService = ocrService
        sut.picker = .init()
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
        let storage: Storage = ScanMe.Storage.cloudDB
        sut.changeStorage(storage)

        XCTAssertEqual(sut.storage, storage)
    }

    func testLoadExpressionsFromLocalFileReturnSuccess() {
        sut.storage = ScanMe.Storage.localFile
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
        sut.storage = ScanMe.Storage.localFile
        fileService.isError = true

        XCTAssertEqual(sut.expressions.count, 0)
        XCTAssertEqual(presenter.expressions.count, 0)

        sut.loadExpressions()
        
        XCTAssertTrue(fileService.isDecryptAndLoadCalled)
        XCTAssertEqual(sut.expressions.count, 0)
        XCTAssertEqual(presenter.expressions.count, 0)
    }


    func testLoadExpressionsFromCloudDBReturnSuccess() {
        sut.storage = ScanMe.Storage.cloudDB
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
        sut.storage = ScanMe.Storage.cloudDB
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
        sut.storage = ScanMe.Storage.localFile
        fileService.isError = false
        sut.saveExpressions()

        XCTAssertTrue(fileService.isEncryptAndSaveCalled)
    }

    func testSaveExpressionsToLocalFileReturnError() {
        sut.storage = ScanMe.Storage.localFile
        fileService.isError = true
        sut.saveExpressions()

        XCTAssertTrue(fileService.isEncryptAndSaveCalled)
        XCTAssertTrue(presenter.isDisplayMessageCalled)
        XCTAssertEqual(presenter.message, CustomError.unknown.localizedDescription)
    }

    func testSaveExpressionsToCloudDBReturnSuccess() {
        sut.storage = ScanMe.Storage.cloudDB
        cloudService.isError = false
        sut.expressions = ExpressionFactory.array()
        sut.saveExpressions()

        XCTAssertTrue(cloudService.isSaveExpressionCalled)
    }

    func testSaveExpressionsToCloudDBReturnError() {
        sut.storage = ScanMe.Storage.cloudDB
        cloudService.isError = true
        sut.expressions = ExpressionFactory.array()
        sut.saveExpressions()

        XCTAssertTrue(cloudService.isSaveExpressionCalled)
        XCTAssertTrue(presenter.isDisplayMessageCalled)
        XCTAssertEqual(presenter.message, CustomError.unknown.localizedDescription)
    }

    func testOCRReturnSuccess() {
        guard let picker: UIImagePickerController = sut.picker else {return}

        ocrService.isError = false
        var info: [UIImagePickerController.InfoKey : Any] = [:]
        info[UIImagePickerController.InfoKey.originalImage] = UIImage()
        sut.imagePickerController(picker, didFinishPickingMediaWithInfo: info)

        XCTAssertTrue(presenter.isDisplayNewCalled)
    }

    func testOCRReturnError() {
        guard let picker: UIImagePickerController = sut.picker else {return}

        ocrService.isError = true
        var info: [UIImagePickerController.InfoKey : Any] = [:]
        info[UIImagePickerController.InfoKey.originalImage] = UIImage()
        sut.imagePickerController(picker, didFinishPickingMediaWithInfo: info)

        XCTAssertTrue(presenter.isDisplayMessageCalled)
        XCTAssertEqual(presenter.message, CustomError.expressionNotFound.localizedDescription)
    }
}

class ScanPresenterProtocolSpy: ScanPresenterProtocol {

    var isShowCalled: Bool = false
    var isDisplayNewCalled: Bool = false
    var isDisplayCalled: Bool = false
    var isDisplayMessageCalled: Bool = false
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

    var isError: Bool = false
    var isEncryptAndSaveCalled: Bool = false
    var isDecryptAndLoadCalled: Bool = false

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

        let expressions: [Expression] = ExpressionFactory.array()
        let jsonData: Data = try JSONEncoder().encode(expressions)
        let array: [T] = try JSONDecoder().decode([T].self, from: jsonData)
        return array
    }
}


class MockCloudService: CloudServiceProtocol {

    var isError: Bool = false
    var isLoadExpressionsCalled: Bool = false
    var isSaveExpressionCalled: Bool = false

    func saveExpression(_ expression: ScanMe.Expression, completion: @escaping ScanMe.ExpressionCompletion) {
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

    var isError: Bool = false

    func recognizeText(image: UIImage, completion: @escaping ScanMe.ExpressionCompletion) {

        if isError {
            completion(.failure(CustomError.expressionNotFound))
        } else {
            let expression = ExpressionFactory.single()
            completion(.success(expression))
        }
    }
}
