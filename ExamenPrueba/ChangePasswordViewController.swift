//
//  ChangePasswordViewController.swift
//  ExamenPrueba
//
//  Created by victor_manzanero on 30/07/20.
//  Copyright © 2020 victor manzanero. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func recoberyPassword(_ sender: Any) {
        
        let signUpManager = FirebaseAuthManager()
        guard let email = userTextField.text else {
            return
        }
        
        signUpManager.recoberyPassword(emailAddress: email){ [weak self] (success) in
        var message: String = ""
        if (success){
            message = "Password change successfully."
        } else {
            message = "There was an error."
        }
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self!.display(alertController: alertController)
            
        
    }
        
    }
    
    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    
   

}
