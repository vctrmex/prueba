//
//  ShowViewController.swift
//  ExamenPrueba
//
//  Created by victor_manzanero on 30/07/20.
//  Copyright © 2020 victor manzanero. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController {
    
    var contacto:Contacts!
    @IBOutlet weak var uidLabel: UILabel!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var apellidoTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var numeroTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    var ban = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let contact:Contacts = contacto else {
            
            return
            
        }
        
        
        uidLabel.text = contact.uid
        nombreTextField.text = contact.nombre
        apellidoTextField.text = contact.apellido
        emailTextField.text = contact.email
        numeroTextField.text = contact.cell

        // Do any additional setup after loading the view.
    }
    
    @IBAction func editEnable(_ sender: Any) {
        
        if ban {
            
            nombreTextField.isEnabled = true
            apellidoTextField.isEnabled = true
            emailTextField.isEnabled = true
            numeroTextField.isEnabled = true
            editButton.setTitle("Cancelar", for: .normal)
            chatButton.isHidden = true
            saveButton.isHidden = false
            ban = false
            
        }else {
            
            nombreTextField.isEnabled = false
            apellidoTextField.isEnabled = false
            emailTextField.isEnabled = false
            numeroTextField.isEnabled = false
            editButton.setTitle("Editar", for: .normal)
            chatButton.isHidden = false
            saveButton.isHidden = true
            ban = true
            
        }
        
    }
    
    @IBAction func saveEdit(_ sender: Any) {
        
        guard let objAux:Contacts = contacto else {
            
            return
            
        }
        Constants.refs.db.document("\(objAux.uid)").updateData(["nombre":nombreTextField.text!,"apellido":apellidoTextField.text!,"email":emailTextField.text!,"numero":numeroTextField.text!])
        
        
        nombreTextField.isEnabled = false
        apellidoTextField.isEnabled = false
        emailTextField.isEnabled = false
        numeroTextField.isEnabled = false
        editButton.setTitle("Editar", for: .normal)
        chatButton.isHidden = false
        saveButton.isHidden = true
        ban = true
        
    }
    
    
    @IBAction func chatStar(_ sender: Any) {
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "chat"{
            
            let controlador = segue.destination as! ChatViewController
            controlador.objContact = self.contacto
            
        }
        
    }
    

}
