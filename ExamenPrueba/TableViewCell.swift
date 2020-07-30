//
//  TableViewCell.swift
//  ExamenPrueba
//
//  Created by victor_manzanero on 29/07/20.
//  Copyright © 2020 victor manzanero. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtNumber: UILabel!
    @IBOutlet weak var btnChat: UIButton!
    var delegate:selecinado?
    var id:Contacts?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func showContact(_ sender: Any) {
        
         self.delegate?.selecionar(id: self.id!)
        
    }
    
}
