//
//  ScanPresenterTests.swift
//  ScanMeTests
//
//  Created by Nugroho Arief Widodo on 03/05/23.
//

import XCTest
@testable import ScanMe

final class ScanPresenterTests: XCTestCase {
    var sut: ScanPresenter!
    var view: ScanViewControllerSpy!

    override func setUp() {
        super.setUp()
        sut = .init()
        view = .init()
        sut.view = view
    }

    override func tearDown() {
        sut = nil
        view = nil
        super.tearDown()
    }

    func testGetNewResult(){

        let expression: Expression = ExpressionFactory.single()
        let counter: Int = view.expressions.count
        sut.displayNew(expression: expression)

        XCTAssertTrue(view.isDidGetNewResultCalled)
        XCTAssertEqual(view.expressions.count, counter+1)
        XCTAssertEqual(view.expressions.last?.input, expression.input)
        XCTAssertEqual(view.expressions.last?.result, expression.result)
    }

    func testReload(){
        let expressions: [Expression] = ExpressionFactory.array()
        sut.display(expressions: expressions)

        XCTAssertTrue(view.isDidGetExpressionsCalled)
        XCTAssertEqual(view.expressions.count, expressions.count)
    }

    func testPresent() {
        let vc: UIViewController = .init()
        sut.show(picker: vc)

        XCTAssertTrue(view.isPresentCalled)
        XCTAssertEqual(view.viewControllerToPresent, vc)
    }

    func testShowMessage() {
        let message:String = UUID().uuidString
        sut.display(message: message)

        XCTAssertTrue(view.isShowMessageCalled)
        XCTAssertEqual(message, view.message)
    }
}

class ScanViewControllerSpy: ScanViewProtocol {

    var isDidGetNewResultCalled: Bool = false
    var isDidGetExpressionsCalled: Bool = false
    var isPresentCalled: Bool = false
    var isShowMessageCalled: Bool = false
    var expressions: [ScanMe.Expression] = []
    var viewControllerToPresent: UIViewController!
    var message: String = ""

    func didGetNew(expression: ScanMe.Expression) {
        isDidGetNewResultCalled = true
        expressions.append(expression)
    }

    func didGet(expressions: [ScanMe.Expression]) {
        isDidGetExpressionsCalled = true
        self.expressions = expressions
    }

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        isPresentCalled = true
        self.viewControllerToPresent = viewControllerToPresent
    }

    func showMessage(title: String?, message: String, completion: (() -> Void)?) {
        isShowMessageCalled = true
        self.message = message
    }
}
