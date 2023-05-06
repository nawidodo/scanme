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

class ScanPresenter: ScanPresenterProtocol {

    var view: ScanViewProtocol?

    func show(picker: UIViewController) {
        picker.modalPresentationStyle = .overFullScreen
        view?.present(picker, animated: true, completion: nil)
    }

    func display(expressions: [Expression]) {
        view?.didGet(expressions: expressions.sorted { $0.date < $1.date } )
    }

    func display(message: String) {
        view?.showMessage(title: nil, message: message, completion: nil)
    }

    func displayNew(expression: Expression) {
        view?.didGetNew(expression: expression)
    }
}
