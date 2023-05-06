//
//  UIView+Extensions.swift
//  Scan me! calculator
//
//  Created by Nugroho Arief Widodo on 01/05/23.
//

import UIKit

extension UIView {

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.gray.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.8
            layer.shadowRadius = newValue
        }
    }

    public static func getView(with identifier: String) -> UIView? {
        guard let _ = Bundle.main.path(forResource: identifier, ofType: "nib"),
              let customviewClass: AnyClass = self.getClass(from: identifier),
              let tempView: UIView = UINib(nibName: identifier, bundle: nil)
            .instantiate(withOwner: nil, options: nil)
            .first as? UIView,
            tempView.classForCoder == customviewClass else {
            return nil
        }
        return tempView
    }

    public static func getClass(from className: String) -> AnyClass? {
        guard let bundleName: String = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String,
              let cls: AnyClass = NSClassFromString("\(bundleName).\(className)") else { return nil }
        return cls
    }

    public func lock(alpha: CGFloat = 0.3) {
        DispatchQueue.main.async {
            if let _ = self.viewWithTag(2626) {
                //View is already locked
            } else {
                let lockView: UIView = .init(frame: CGRect(x: self.bounds.minX,
                                                    y: self.bounds.minY,
                                                    width: UIScreen.main.bounds.width,
                                                    height: UIScreen.main.bounds.height))
                lockView.backgroundColor = UIColor(white: 0.0, alpha: alpha)
                lockView.tag = 2626
                lockView.alpha = 0.0

                let activity: UIActivityIndicatorView = .init(style: .large)
                activity.hidesWhenStopped = true
                activity.center = lockView.center
                activity.translatesAutoresizingMaskIntoConstraints = false

                lockView.addSubview(activity)
                activity.startAnimating()

                var constraints: [NSLayoutConstraint] = []
                constraints.append(NSLayoutConstraint(item: activity, attribute: .centerX, relatedBy: .equal, toItem: lockView, attribute: .centerX, multiplier: 1, constant: 0))
                constraints.append(NSLayoutConstraint(item: activity, attribute: .centerY, relatedBy: .equal, toItem: lockView, attribute: .centerY, multiplier: 1, constant: 0))
                NSLayoutConstraint.activate(constraints)
                self.addSubview(lockView)

                UIView.animate(withDuration: 0.2, animations: {
                    lockView.alpha = 1.0
                })
            }
        }

    }

    public func unlock() {
        DispatchQueue.main.async {
            if let lockView = self.viewWithTag(2626) {
                self.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.2, animations: {
                    lockView.alpha = 0.0
                }, completion: { finished in
                    lockView.removeFromSuperview()
                })
            }
        }
    }
}
