//
//  Contacts.swift
//  ExamenPrueba
//
//  Created by victor_manzanero on 30/07/20.
//  Copyright © 2020 victor manzanero. All rights reserved.
//

import Foundation

class Contacts {
    
    var nombre:String
    var apellido:String
    var email:String
    var cell:String
    var uid:String
    var id_user:String
    
    init(nombre:String, apellido:String, email:String, cell:String,id_user:String,uid:String) {
        
        
        self.nombre = nombre
        self.apellido =  apellido
        self.email = email
        self.cell = cell
        self.id_user = id_user
        self.uid = uid
        
        
    }
    
    
    
}
