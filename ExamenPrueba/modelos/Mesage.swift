//
//  Mesage.swift
//  ExamenPrueba
//
//  Created by victor_manzanero on 30/07/20.
//  Copyright © 2020 victor manzanero. All rights reserved.
//

import Foundation

class Mesage {
    
    var hour:String
    var message:String
    var receiver:String
    var sender:String
    var issen:Bool
    
    
    init(hour:String,message:String,receiver:String,sender:String,issen:Bool) {
        
        self.hour = hour
        self.message = message
        self.receiver = receiver
        self.sender = sender
        self.issen = issen
        
    }
    
}
