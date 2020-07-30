//
//  Constants.swift
//  ExamenPrueba
//
//  Created by victor_manzanero on 30/07/20.
//  Copyright © 2020 victor manzanero. All rights reserved.
//

import Firebase

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chat")
        static let ChatsActivos = databaseRoot.child("activos")
        static let db = Firestore.firestore().collection("contacts")
    }
    
    
}
