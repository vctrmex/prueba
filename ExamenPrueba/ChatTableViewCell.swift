//
//  ChatTableViewCell.swift
//  ExamenPrueba
//
//  Created by victor_manzanero on 30/07/20.
//  Copyright © 2020 victor manzanero. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var textoTextField1: UILabel!
    @IBOutlet weak var hotaTextField1: UILabel!
    
    @IBOutlet weak var textoTextField2: UILabel!
    @IBOutlet weak var horaTextField2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
