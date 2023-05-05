//
//  ScanConfigurator.swift
//  Scan me! calculator
//
//  Created by Nugroho Arief Widodo on 03/05/23.
//

import UIKit

class ScanConfigurator {
    func configure() -> ScanViewController {
        let view = ScanViewController()
        let interactor = ScanInteractor()
        let presenter = ScanPresenter()
        let picker = UIImagePickerController()
        picker.sourceType = App.input
        interactor.presenter = presenter
        interactor.ocrService = OCRService()
        interactor.fileService = FileService()
        interactor.cloudService = FirebaseService()
        interactor.picker = picker
        picker.delegate = interactor
        presenter.view = view
        view.interactor = interactor

        return view
    }
}
