//
//  ScanViewControllerTests.swift
//  ScanMeTests
//
//  Created by Nugroho Arief Widodo on 03/05/23.
//

import XCTest
@testable import ScanMe

final class ScanViewControllerTests: XCTestCase {
    var sut: ScanViewController!
    var interactor: ScanInteractorSpy!
    var window: UIWindow!

    override func setUp() {
        super.setUp()
        window = .init()
        sut = .init()
        interactor = .init()
        sut.interactor = interactor
    }

    override func tearDown() {
        sut = nil
        interactor = nil
        window = nil
        super.tearDown()
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 2))
    }

    func testAddImage() {
        loadView()
        sut.buttonAdd.sendActions(for: .touchUpInside)

        XCTAssertTrue(interactor.isAddImageCalled)
    }

    func testChangeStorage() {
        loadView()
        sut.segmentedControl.selectedSegmentIndex = 1
        sut.segmentedControl.sendActions(for: .valueChanged)

        XCTAssertTrue(interactor.isChangeStorageCalled)
        XCTAssertEqual(interactor.storage, .cloudDB)

        sut.segmentedControl.selectedSegmentIndex = 0
        sut.segmentedControl.sendActions(for: .valueChanged)

        XCTAssertEqual(interactor.storage, .localFile)
    }

    func testLoadExpressions() {
        loadView()
        XCTAssertTrue(interactor.isLoadExpressionsCalled)
    }

    func testLoadExpressionFromStorage() {
        loadView()

        let expressions: [Expression] = ExpressionFactory.array()

        XCTAssertEqual(sut.tableView.visibleCells.count, 0)

        sut.didGet(expressions: expressions)

        XCTAssertEqual(sut.tableView.visibleCells.count, 2)
    }

    func testGetNewExpression() {
        loadView()
        let expression: Expression = ExpressionFactory.single()

        XCTAssertEqual(sut.tableView.visibleCells.count, 0)

        sut.didGetNew(expression: expression)
        
        XCTAssertEqual(sut.tableView.visibleCells.count, 1)
    }

}

class ScanInteractorSpy: ScanInteractorProtocol {

    var isAddImageCalled: Bool = false
    var isChangeStorageCalled: Bool = false
    var isLoadExpressionsCalled: Bool = false
    var storage: ScanMe.Storage?

    func addImage() {
        isAddImageCalled = true
    }

    func changeStorage(_ storage: ScanMe.Storage?) {
        isChangeStorageCalled = true
        self.storage = storage
    }

    func loadExpressions() {
        isLoadExpressionsCalled = true
    }
}


