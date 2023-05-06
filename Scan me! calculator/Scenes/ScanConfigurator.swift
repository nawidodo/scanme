//
//  ScanConfigurator.swift
//  Scan me! calculator
//
//  Created by Nugroho Arief Widodo on 03/05/23.
//

import UIKit

class ScanConfigurator {
    func configure() -> ScanViewController {
        let view: ScanViewController = .init()
        let interactor: ScanInteractor = .init()
        let presenter: ScanPresenter = .init()
        let picker: UIImagePickerController = .init()
        
        interactor.presenter = presenter
        interactor.ocrService = OCRService()
        interactor.fileService = FileService()
        interactor.cloudService = FirebaseService()
        interactor.picker = picker

        picker.sourceType = App.input
        picker.delegate = interactor
        
        presenter.view = view
        view.interactor = interactor

        return view
    }
}
