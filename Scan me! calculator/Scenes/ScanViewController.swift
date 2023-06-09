//
//  MainViewController.swift
//  Scan me! calculator
//
//  Created by Nugroho Arief Widodo on 01/05/23.
//

import UIKit

protocol ScanViewProtocol {
    func didGetNew(expression: Expression)
    func didGet(expressions: [Expression])
    func present(_ viewControllerToPresent: UIViewController,
                 animated flag: Bool,
                 completion: (() -> Void)?)
    func showMessage(title: String?, message: String, completion: (() -> Void)?)
}

class ScanViewController: UIViewController {

    var interactor: ScanInteractorProtocol?

    @IBOutlet var tableView: UITableView!
    @IBOutlet var buttonAdd: UIButton!

    let segmentedControl: UISegmentedControl = .build(titles: ["Local File", "Cloud DB"])
    
    private var expressions: [Expression] = []
    private let cellID: String = "ContentView"

    @IBAction func didTabButton(_ sender: UIButton) {
        interactor?.addImage()
    }

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        view.lock()
        let storage = Storage(rawValue: sender.selectedSegmentIndex)
        interactor?.changeStorage(storage)
    }

    private func setupUI(){
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: cellID)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)

        buttonAdd.backgroundColor = App.color
        navigationItem.titleView = segmentedControl
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = App.color
        navigationController?.navigationBar.backgroundColor = App.color
    }

    private func reload() {
        tableView.reloadData()
        view.unlock()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor?.loadExpressions()
    }
}

// MARK: UITableViewDataSource
extension ScanViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expressions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: PaddingTableViewCell =
                tableView.dequeueReusableCell(withIdentifier: cellID,
                                              for: indexPath) as? PaddingTableViewCell,
            let customView: ContentView = cell.customView as? ContentView else { return UITableViewCell() }

            let index = expressions.count - indexPath.row - 1
            let data = expressions[index]

            customView.backgroundColor = .white
            customView.inputLabel.text = data.input
            customView.inputLabel.textColor = App.color
            customView.resultLabel.text = "\(data.result)"
            customView.resultLabel.textColor = App.color
            customView.borderColor = App.color

            cell.setCard(leading: 16, trailing: 16, bottom: 0, top: 16)
            cell.selectionStyle = .none

            return cell
    }
}

// MARK: ScanViewProtocol
extension ScanViewController: ScanViewProtocol {
    func didGetNew(expression: Expression) {
        expressions.append(expression)
        reload()
    }

    func didGet(expressions: [Expression]) {
        self.expressions = expressions
        reload()
    }
}
