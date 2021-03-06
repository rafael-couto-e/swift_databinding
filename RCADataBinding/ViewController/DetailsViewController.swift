//
//  DetailsViewController.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 07/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import UIKit

// MARK: class

class DetailsViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: properties
    
    lazy var viewModel = {
        return DetailsViewModel(self)
    }()

    // MARK: parent functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind(nameLabel, to: viewModel.username)
        self.bind(availableLabel, to: viewModel.available)
        
        self.limitLabel.bind(self, to: viewModel.total)
        self.usedLabel.bind(self, to: viewModel.expent)
        self.tableView.bind(self, to: viewModel.items, dataSource: self)
        
        self.setupTableView()
    }
    
    // MARK: functions
    
    func setupTableView() {
        self.tableView.register(
            UINib(
                nibName: "DetailsCell",
                bundle: nil
            ), forCellReuseIdentifier: "detailsCell"
        )
    }
}

// MARK: extensions

extension DetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row at index \(indexPath.row)")
    }
}

extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell") as? DetailsCell
        else {
            return UITableViewCell()
        }
        
        cell.initCell(vc: self)
        
        cell.viewModel.installment.value = self.viewModel.installment(for: indexPath.row)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
