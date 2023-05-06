//
//  PaddingTableViewCell.swift
//  Scan me! calculator
//
//  Created by Nugroho Arief Widodo on 02/05/23.
//

import UIKit

class PaddingTableViewCell: UITableViewCell {
    public var customView: UIView?
    public var leadingTrailingConstraint : [NSLayoutConstraint]?
    public var topBottomConstraint : [NSLayoutConstraint]?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Add content container view
        self.backgroundColor = .clear

        if let reuseIdentifier: String = reuseIdentifier,
            let customView: UIView = .getView(with: reuseIdentifier) {
            self.customView = customView
            contentView.addSubview(customView)
            customView.translatesAutoresizingMaskIntoConstraints = false
            addCustomViewConstraintWith(leading: 0, trailing: 0, bottom: 0, top: 0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setCard(leading: CGFloat, trailing: CGFloat,bottom: CGFloat,top: CGFloat) {

        if let leadingTrailing: [NSLayoutConstraint] = leadingTrailingConstraint {
            contentView.removeConstraints(leadingTrailing)
        }
        if let topBottom: [NSLayoutConstraint] = topBottomConstraint {
            contentView.removeConstraints(topBottom)
        }
        addCustomViewConstraintWith(leading: leading, trailing: trailing,bottom: bottom,top: top)
    }

    private func addCustomViewConstraintWith(leading: CGFloat, trailing: CGFloat,bottom: CGFloat,top: CGFloat) {

        if let tempView: UIView = customView {
            let leadingTrailing: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(leading)-[view]-\(trailing)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":tempView])
            contentView.addConstraints(leadingTrailing)
            leadingTrailingConstraint = leadingTrailing

            let topBottom: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(top)-[view]-\(bottom)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":tempView])
            contentView.addConstraints(topBottom)
            topBottomConstraint = topBottom
        }
    }
}
