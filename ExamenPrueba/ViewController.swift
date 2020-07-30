//
//  ViewController.swift
//  ExamenPrueba
//
//  Created by victor_manzanero on 29/07/20.
//  Copyright © 2020 victor manzanero. All rights reserved.
//
import UIKit
import FirebaseAuth


class ViewController: UIViewController {
    
    
    fileprivate var currentNonce: String?
    @IBOutlet weak var contactPointTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var recuerdame: UISwitch!
    let defaults = UserDefaults.standard
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        if(defaults.bool(forKey: "ban")){
            
            recuerdame.setOn(true, animated: true)
            contactPointTextField.text = defaults.string(forKey: "username")
            passwordTextField.text = defaults.string(forKey: "pass")
            
        }else{
            
            contactPointTextField.text = ""
            passwordTextField.text = ""
        }
        // Do any additional setup after loading the view.
    }
    
    func hideKeyboard()
           {
               let tap: UITapGestureRecognizer = UITapGestureRecognizer(
                   target: self,
                   action: #selector(self.dismissKeyboard))
               
               tap.cancelsTouchesInView = false
               view.addGestureRecognizer(tap)
           }
           
           @objc func dismissKeyboard()
           {
               view.endEditing(true)
           }
    
    @IBAction func login(_ sender: Any) {
        
        let loginManager = FirebaseAuthManager()
        guard let email = contactPointTextField.text, let password = passwordTextField.text else { return }
        loginManager.signIn(email: email, pass: password) {[weak self] (success,result) in
            guard let `self` = self else { return }
            var message: String = ""
            if (success) {
                if(self.recuerdame.isOn){
                    
                    self.defaults.set(email, forKey: "username")
                    self.defaults.set(password, forKey: "pass")
                    self.defaults.set(true,forKey:"ban")
                    
                }else{
                    
                    self.defaults.set(email , forKey: "username")
                    self.defaults.set(password, forKey: "pass")
                    self.defaults.set(false,forKey:"ban")
                }
                self.goToNextVC()
            } else {
                message = "There was an error."
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.display(alertController: alertController)
            }
            
        }
        
    }
    
    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    func goToNextVC(){
        //creo registro para el chat y saber si esta online o no
        
        let ref = Constants.refs.ChatsActivos.childByAutoId()
        let message = ["me":defaults.string(forKey: "myemail"),"activo":false] as [String : Any]
        ref.setValue(message)
        defaults.set(ref.key!,forKey: "idaux")
        let dash = UIStoryboard(name: "Main", bundle: nil)
        let controller = dash.instantiateViewController(withIdentifier: "list")
        self.present(controller, animated: true, completion: nil)
        
        
    }
    

}


