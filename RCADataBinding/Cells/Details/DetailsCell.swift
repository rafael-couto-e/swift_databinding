//
//  DetailsCell.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 08/03/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import UIKit

class DetailsCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var carnetLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    // MARK: properties
    
    lazy var viewModel = {
        return DetailsCellViewModel()
    }()
    
    // MARK: parent functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    // MARK: functions
    
    func initCell(vc: UIViewController) {
        self.viewModel.installment.observe(vc) { [weak self] installment in
            self?.dateLabel.text = installment?.pastDue
            self?.codeLabel.text = installment?.carnet
            self?.carnetLabel.text = installment?.installment
            self?.valueLabel.text = installment?.value
        }
    }
}
