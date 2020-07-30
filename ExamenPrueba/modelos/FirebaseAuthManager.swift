//
//  FirebaseAuthManager.swift
//  ExamenPrueba
//
//  Created by victor_manzanero on 30/07/20.
//  Copyright © 2020 victor manzanero. All rights reserved.
//

import FirebaseAuth
import UIKit
class FirebaseAuthManager {
    let defaults = UserDefaults.standard
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
    
    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool,_ result:Any) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false,result)
            } else {
                let userInfo = Auth.auth().currentUser
                self.defaults.set(userInfo!.uid, forKey: "uid")
                self.defaults.set(userInfo!.email, forKey: "myemail")
                completionBlock(true,result)
            }
    
            
        }
    }
    
    func recoberyPassword(emailAddress:String,completionBlock: @escaping (_ success: Bool) -> Void){

        Auth.auth().sendPasswordReset(withEmail: emailAddress){ (error) in
            
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                completionBlock(true)
            }
            
        }
        
    }
}
