//
//  Protocolos.swift
//  ExamenPrueba
//
//  Created by victor_manzanero on 30/07/20.
//  Copyright © 2020 victor manzanero. All rights reserved.
//
import UIKit
protocol selecinado {
    
    func selecionar(id:Contacts)
    
}

extension ContactsViewController:selecinado {


func selecionar(id:Contacts) {
    
    let 🤟🏽 = UIStoryboard(name: "Main", bundle: nil)
    let 🎮 = 🤟🏽.instantiateViewController(withIdentifier: "show") as! ShowViewController
    🎮.contacto = id
    self.present(🎮, animated: true, completion: nil)
    // :P
    
    }
    
    
}


extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 ).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds))
    }
}
