//
//  StockTableViewCell.swift
//  Voorraadbeheer
//
//  Created by Wytze Dijkstra on 16/01/2019.
//  Copyright © 2019 Wytze Dijkstra. All rights reserved.
//

import UIKit

class StockTableViewCell: UITableViewCell {

    @IBOutlet weak var stepperOutlet: UIStepper!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBAction func stepper(_ sender: UIStepper) {
        //when stepper is pressed label changes as well
        quantityLabel.text = String(Double(sender.value))
    }
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //current value of the label is also current value of the stepper
        stepperOutlet.value = Double(quantityLabel.text!)!
    }

}
