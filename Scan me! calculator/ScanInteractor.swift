//
//  ScanInteractor.swift
//  Scan me! calculator
//
//  Created by Nugroho Arief Widodo on 02/05/23.
//

import UIKit

protocol ScanInteractorProtocol {
    func addImage()
    func changeStorage(_ storage: Storage?)
    func loadExpressions()
}

class ScanInteractor: NSObject, ScanInteractorProtocol {

    var presenter: ScanPresenterProtocol?
    var ocrService: OCRServiceProtocol?
    var fileService: FileServiceProtocol?
    var cloudService: CloudServiceProtocol?

    var storage: Storage = .localFile
    var expressions: [Expression] = []
    private let fileName = "exp.enc"
    private let privateKey = Bundle
        .main
        .object(forInfoDictionaryKey: "PrivateKey") as! String

    func addImage() {
        let picker = UIImagePickerController()
        picker.sourceType = App.input
        picker.delegate = self
        presenter?.show(picker: picker)
    }

    func changeStorage(_ storage: Storage?) {
        guard let storage = storage else { return }
        self.storage = storage
        loadExpressions()
    }

    func loadExpressions() {

        switch storage {
        case .localFile:
            guard let expressions = try? fileService?
                .decryptAndLoad(withPassword: privateKey,
                                fileName: fileName,
                                type: Expression.self) else {return}
            presenter?.display(expressions: expressions)
            self.expressions = expressions

        case .cloudDB:
            cloudService?.loadExpressions { [weak self] result in
                switch result {
                case .success(let expressions):
                    self?.presenter?.display(expressions: expressions)
                    self?.expressions = expressions
                case .failure(let error):
                    self?.presenter?.display(message: error.localizedDescription)
                }
            }
        }
    }

    func saveData() {

        switch storage {
        case .localFile:
            do {
                try fileService?.encryptAndSave(expressions,
                                                withPassword: privateKey,
                                                fileName: fileName)
            } catch (let error) {
                presenter?.display(message: error.localizedDescription)
            }

        case .cloudDB:
            guard let lastData = expressions.last else { return }
            cloudService?.saveExpression(lastData) { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.presenter?.display(message: error.localizedDescription)
                default:
                    break
                }
            }
        }
    }
}

extension ScanInteractor: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            ocrService?.recognizeText(image: image) { [weak self] result in
                switch result {
                case .success(let expression):
                    self?.presenter?.displayNew(expression: expression)
                    self?.expressions.append(expression)
                    self?.saveData()
                case .failure(let error):
                    self?.presenter?.display(message: error.localizedDescription)
                }
            }
        }
    }
}
