//
//  UISegmentedControl+Extensions.swift
//  Scan me! calculator
//
//  Created by Nugroho Arief Widodo on 06/05/23.
//

import UIKit

extension UISegmentedControl {
    static func build(titles: [String]) -> UISegmentedControl {
        let segmentedControl: UISegmentedControl = .init(items: titles)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .clear
        segmentedControl.selectedSegmentTintColor = .white
        segmentedControl.tintColor = .white

        // Define the text attributes for the selected state
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 14)
        ]

        // Define the text attributes for the normal state
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14)
        ]

        // Set the text attributes for the selected and normal states
        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)

        return segmentedControl
    }
}
