//
//  UIViewControllerExtensionsTests.swift
//  ScanMeTests
//
//  Created by Nugroho Arief Widodo on 04/05/23.
//

import XCTest
@testable import ScanMe

class UIViewControllerExtensionTests: XCTestCase {
    var sut: UIViewController!
    var window: UIWindow!

    override func setUp() {
        super.setUp()
        sut = UIViewController()
        window = UIWindow()
    }

    override func tearDown() {
        sut = nil
        window = nil
        super.tearDown()
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    func testShowAlert() {
        // Create an expectation for the alert
        loadView()
        let alertExpectation = expectation(description: "Alert was shown")

        // Set up the alert completion handler
        sut.showMessage(message: "This is a test alert") {
            alertExpectation.fulfill()
        }

        // Test that the alert is presented
        waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }

}
