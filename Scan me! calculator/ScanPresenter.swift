//
//  ScanPresenter.swift
//  Scan me! calculator
//
//  Created by Nugroho Arief Widodo on 02/05/23.
//

import UIKit

protocol ScanPresenterProtocol {
    func show(picker: UIViewController)
    func display(expressions: [Expression])
    func displayNew(expression: Expression)
    func display(message: String)
}

protocol ScanViewProtocol {
    func getNewResult(expression: Expression)
    func reload(expressions: [Expression])
    func present(_ viewControllerToPresent: UIViewController,
                 animated flag: Bool,
                 completion: (() -> Void)?)
    func showMessage(title: String?, message: String)
}

class ScanPresenter: ScanPresenterProtocol {

    var view: ScanViewProtocol?

    func show(picker: UIViewController) {
        picker.modalPresentationStyle = .overFullScreen
        view?.present(picker, animated: true, completion: nil)
    }

    func display(expressions: [Expression]) {
        view?.reload(expressions: expressions.sorted { $0.date < $1.date } )
    }

    func display(message: String) {
        view?.showMessage(title: nil, message: message)
    }

    func displayNew(expression: Expression) {
        view?.getNewResult(expression: expression)
    }
}
