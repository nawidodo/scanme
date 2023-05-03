//
//  MainViewController.swift
//  Scan me! calculator
//
//  Created by Nugroho Arief Widodo on 01/05/23.
//

import UIKit

class ScanViewController: UIViewController {

    var interactor: ScanInteractorProtocol?

    @IBOutlet var tableView: UITableView!
    @IBOutlet var buttonAdd: UIButton!

    private let segmentedControl = SegmentedControlFactory().build(titles: ["Local File", "Cloud DB"])
    
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
        navigationItem.titleView = segmentedControl

        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        buttonAdd.backgroundColor = App.color
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = App.color
    }

    private func reload() {
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor?.loadExpressions()
    }
}

extension ScanViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expressions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? PaddingTableViewCell, let customView = cell.customView as? ContentView {

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
        } else {
            return UITableViewCell()
        }
    }
}

extension ScanViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ScanViewController: ScanViewProtocol {
    func getNewResult(expression: Expression) {
        expressions.append(expression)
        reload()
    }

    func reload(expressions: [Expression]) {
        view.unlock()
        self.expressions = expressions
        reload()
    }
}
