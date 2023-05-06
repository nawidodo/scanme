//
//  UIViewController+Extensions.swift
//  Scan me! calculator
//
//  Created by Nugroho Arief Widodo on 03/05/23.
//

import UIKit

extension UIViewController {
    func showMessage(title: String? = nil, message: String, completion: (() -> Void)? = nil) {
        let alertController: UIAlertController = .init(title: title, message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = .init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: completion)
    }
}
