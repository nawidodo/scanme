//
//  OCRServiceTests.swift
//  ScanMeTests
//
//  Created by Nugroho Arief Widodo on 04/05/23.
//

import XCTest
@testable import ScanMe
final class OCRServiceTests: XCTestCase {
    let bundle: Bundle = .init(for: OCRServiceTests.self)
    let expectation: XCTestExpectation = .init()

    var sut: OCRService!

    override func setUp() {
        super.setUp()
        sut = OCRService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testParseExpressionWithPlusOperator() {
        let image: UIImage = .init(named: "1+2", in: bundle, compatibleWith: nil)!
        sut.recognizeText(image: image) { result in
            switch result {
            case .success(let expression):
                XCTAssertEqual(expression.input, "1+2")
                XCTAssertEqual(expression.result, 3)

                self.expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }

        wait(for: [expectation], timeout: 2)
    }

    func testParseExpressionWithMinusOperator() {
        let image: UIImage = .init(named: "7-2", in: bundle, compatibleWith: nil)!
        sut.recognizeText(image: image) { result in
            switch result {
            case .success(let expression):
                XCTAssertEqual(expression.input, "7-2")
                XCTAssertEqual(expression.result, 5)

                self.expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }

        wait(for: [expectation], timeout: 2)
    }

    func testParseExpressionWithAsteriskOperator() {
        let image: UIImage = .init(named: "2*6", in: bundle, compatibleWith: nil)!
        sut.recognizeText(image: image) { result in
            switch result {
            case .success(let expression):
                XCTAssertEqual(expression.input, "2*6")
                XCTAssertEqual(expression.result, 12)

                self.expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }

        wait(for: [expectation], timeout: 2)
    }

    func testParseExpressionWithSlashOperator() {
        let image: UIImage = .init(named: "27.3", in: bundle, compatibleWith: nil)!
        sut.recognizeText(image: image) { result in
            switch result {
            case .success(let expression):
                XCTAssertEqual(expression.input, "27/3")
                XCTAssertEqual(expression.result, 9)

                self.expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }

        wait(for: [expectation], timeout: 2)
    }

    func testParseInvalidImage() {
        let image: UIImage = .init(named: "dummy", in: bundle, compatibleWith: nil)!
        sut.recognizeText(image: image) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(_):
                self.expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2)
    }
}
