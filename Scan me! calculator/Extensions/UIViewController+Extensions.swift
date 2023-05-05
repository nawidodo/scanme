//
//  UIViewController+Extensions.swift
//  Scan me! calculator
//
//  Created by Nugroho Arief Widodo on 03/05/23.
//

import UIKit

typealias VoidCompletion = ()->Void

extension UIViewController {
    func showMessage(title: String? = nil, message: String, completion: VoidCompletion? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: completion)
    }
}
