//
//  UIViewExtensionTests.swift
//  ScanMeTests
//
//  Created by Nugroho Arief Widodo on 04/05/23.
//

import XCTest
@testable import ScanMe
class UIViewExtensionTests: XCTestCase {

    func testCornerRadius() {
        // Create a view with a corner radius of 10
        let view = UIView()
        view.cornerRadius = 10

        // Test that the view's layer has a corner radius of 10
        XCTAssertEqual(view.layer.cornerRadius, view.cornerRadius)
    }

    func testShadowRadius() {
        // Create a view with a shadow radius of 6
        let view = UIView()
        view.shadowRadius = 6

        // Test that the view's layer has a corner radius of 6
        XCTAssertEqual(view.layer.shadowRadius, view.shadowRadius)
    }

    func testBorderColor() {
        // Create a view with a border color of red
        let view = UIView()
        view.borderColor = UIColor.red

        // Test that the view's layer has a border color of red
        XCTAssertEqual(view.layer.borderColor, view.borderColor?.cgColor)
    }

    func testBorderWidth() {
        // Create a view with a border width of 2
        let view = UIView()
        view.borderWidth = 2

        // Test that the view's layer has a border width of 2
        XCTAssertEqual(view.layer.borderWidth, view.borderWidth)
    }

}
