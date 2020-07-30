//
//  ContactsViewController.swift
//  ExamenPrueba
//
//  Created by victor_manzanero on 29/07/20.
//  Copyright © 2020 victor manzanero. All rights reserved.
//

import UIKit
import Firebase

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate {
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var search: UISearchBar!
    var contactosNombre:Array<Contacts> = []
    var contactosNombreAux:Array<Contacts> = []
    
     var bar:Bool = true
    
    
    @IBOutlet weak var tabla: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.delegate = self
        search.endEditing(true)
        
        Constants.refs.db.whereField("id_user", isEqualTo: defaults.string(forKey: "uid")).getDocuments(){ (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                //print("\(document.documentID) => \(document.data())")
                //print(document.data()["nombre"])
                let contacto:Contacts = Contacts(nombre: document.data()["nombre"]! as! String , apellido: document.data()["apellido"] as! String, email: document.data()["email"] as! String, cell:document.data()["numero"] as! String, id_user:document.data()["id_user"] as! String, uid: document.documentID as! String)
                
                self.contactosNombre.append(contacto)
                
                
                
            }
             self.refrescar()
            }
        }
        
       
            
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if bar {
            
        return contactosNombre.count
            
        }else{
            
            return contactosNombreAux.count
        }


    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if bar{
        let aux = contactosNombre[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cel", for: indexPath) as! TableViewCell
            cell.txtName.text = "\(aux.nombre) \(aux.apellido)"
            cell.txtNumber.text = aux.cell
            cell.id = aux
            cell.delegate = self

        // Configure the cell...

        return cell
            
        }else{
            
            let aux = contactosNombreAux[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cel", for: indexPath) as! TableViewCell
            cell.txtName.text = "\(aux.nombre) \(aux.apellido)"
            cell.txtNumber.text = aux.cell
            cell.id = aux
            cell.delegate = self
            // Configure the cell...

            return cell
            
            
        }
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        
        
        self.contactosNombreAux = self.contactosNombre.filter { (exercise:Contacts ) -> Bool in
            if exercise.nombre.lowercased().contains(self.search.text!.lowercased()){
                
                return true
            } else{
                
                return false
            }
        }
        
        if (searchText != ""){
            
            self.bar = false
            self.refrescar()
            //print(lotes2.count)
            
        }else{
            self.bar = true
            self.refrescar()
            
        }
        
        
        
    }
    
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
           
       }
    
    @IBAction func addContact(_ sender: Any) {
        
        
        
        let alerta = UIAlertController(title: "Add Contacts", message: "Please fill all fields", preferredStyle: .alert)
               
               let cancelar = UIAlertAction(title: "Cancel", style: .cancel)
        alerta.addTextField()
        alerta.addTextField()
        alerta.addTextField()
        alerta.addTextField()
        alerta.textFields?[0].placeholder = "First Name"
        alerta.textFields?[1].placeholder = "Last Name"
        alerta.textFields?[2].placeholder = "Email"
        alerta.textFields?[3].placeholder = "Number"
        
               
               let guardar  = UIAlertAction(title: "Save", style: .default, handler: {(action: UIAlertAction) -> Void in
                   
                guard let campos:[UITextField] = alerta.textFields else {
                    
                    return
                    
                }
                   let ref = Constants.refs.db
                          var element:DocumentReference? = nil
                          element = ref.addDocument(data: [
                            "nombre":campos[0].text! ,
                            "apellido": campos[1].text! ,
                              "id_user": self.defaults.string(forKey: "uid")!,
                              "numero":campos[3].text!,
                              "email":campos[2].text!
                          ]) { err in
                              if let err = err {
                                  print("Error adding document: \(err)")
                              } else {
                                  print("Document added with ID: \(element!.documentID)")
                              }
                          }
                
                
               self.recargar()
                   
                   
                   
               })
               
               alerta.addAction(cancelar)
               alerta.addAction(guardar)
               
        self.display(alertController: alerta)
        
        
        
        
    }
    
    
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alerta = UIAlertController(title: "Delete Element", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
            let cancelar = UIAlertAction(title: "Cancel", style: .cancel)
            let guardar  = UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction) -> Void in
                       
                let contacto = self.contactosNombre[indexPath.row]
                                Constants.refs.db.document("\(contacto.uid)").delete(){ err in
                                if let err = err {
                                        print("Error removing document: \(err)")
                                    } else {
                                        print("Document successfully removed!")
                                    }
                                }
                                
                                self.recargar()
                       
                       
                       
                   })
                   
                   
            alerta.addAction(cancelar)
            alerta.addAction(guardar)
            
            self.display(alertController: alerta)
            
        } else if editingStyle == .insert {
           
        }
    }
    
    
    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func refrescar(){
        
        
        
        self.tabla.reloadData()
    }
    
    func recargar(){
        
        self.contactosNombre.removeAll()
        Constants.refs.db.whereField("id_user", isEqualTo: defaults.string(forKey: "uid")).getDocuments() { (querySnapshot, err) in
               if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                   for document in querySnapshot!.documents {
                       //print("\(document.documentID) => \(document.data())")
                       //print(document.data()["nombre"])
                   let contacto:Contacts = Contacts(nombre: document.data()["nombre"]! as! String , apellido: document.data()["apellido"] as! String, email: document.data()["email"] as! String, cell:document.data()["numero"] as! String, id_user:document.data()["id_user"] as! String, uid: document.documentID as! String)
                       
                       self.contactosNombre.append(contacto)
                       
                       
                       
                   }
                    self.refrescar()
                   }
               }
        
        
    }

}
