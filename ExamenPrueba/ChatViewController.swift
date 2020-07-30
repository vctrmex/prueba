//
//  ChatViewController.swift
//  ExamenPrueba
//
//  Created by victor_manzanero on 30/07/20.
//  Copyright © 2020 victor manzanero. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate  {
    
    
    var mjs:Array<Mesage> = []
    var objContact:Contacts!
    @IBOutlet weak var barraNavigate: UINavigationBar!
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var textoTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var titleItem: UINavigationItem!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        guard let contact:Contacts = objContact else {
                   
                   return
                   
               }
        titleItem.title = "\(contact.nombre) \(contact.apellido)"
         let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        tabla.dataSource = self
        tabla.delegate = self
        self.textoTextField.delegate = self
        detectActive()
        status()
        cargarchat()
        

   
    }
    
    /*Carga el chat anterior y actuliza al sentir el cambio*/
    func cargarchat(){
    
    let query = Constants.refs.databaseChats
           
           _ = query.observe(.childAdded, with: { [weak self] snapshot in
            let data        = snapshot.value as? [String : AnyObject] ?? [:]
            let mensa = Mesage(hour: data["hour"]! as! String, message: data["message"]! as! String, receiver: data["receiver"]! as! String, sender: data["sender"]! as! String, issen: data["isseen"]! as! Bool)
           
            if (mensa.receiver == self!.defaults.string(forKey: "myemail")! && mensa.sender == self!.objContact.email) || (mensa.receiver == self!.objContact.email && mensa.sender == self!.defaults.string(forKey: "myemail")!) {
                
                self!.mjs.append(mensa)
                
            }
           
            DispatchQueue.main.async {
                
                //self!.mjs = self!.bubbleSort(dd: self!.mjs)
                self!.tabla.reloadData()
                self!.scrollToBottom()
                
            }
            
            
            
            //print(id)
           })
        
    }
    
    //detecta por primera vez el status del usuario con el que chateara
    func status(){
        
        
              let query = Constants.refs.ChatsActivos
        _ = query.observe(.value) { snapshot in
         let data        = snapshot.value as? [String : AnyObject] ?? [:]
            for dato in data{
                guard let me = dato.value["me"] else {
                    return
                }
                
                if me as! String == self.objContact.email{
                
                    let bool = dato.value["activo"]! as! Bool
                if bool {
                    
                    self.statusLabel.text = "Online"
                    self.statusLabel.textColor = UIColor.green
                    
                }else{
                    
                    
                    self.statusLabel.text = "offline"
                    self.statusLabel.textColor = UIColor.black
                    
                }
                
            }
            
          
        }
        
    }
    }
    
        
        //actualiza el estatus del compañaero chateo
    func detectActive(){
        
        
        
        let query = Constants.refs.ChatsActivos
        _ = query.observe(.childChanged, with: { [weak self] snapshot in
                let data        = snapshot.value as? [String : AnyObject] ?? [:]
                let user = data["me"]! as! String
            if user == self!.objContact.email{
                
                let bool = data["activo"]! as! Bool
                if bool {
                    
                    self!.statusLabel.text = "Online"
                    self!.statusLabel.textColor = UIColor.green
                    
                }else{
                    
                    
                    self!.statusLabel.text = "offline"
                    self!.statusLabel.textColor = UIColor.black
                    
                }
                
            }
                
                

               })
        
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
          //En foco
        let key = Constants.refs.ChatsActivos.child(defaults.string(forKey: "idaux")!).updateChildValues(["activo":false])

        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Fuerda de foco
        let key = Constants.refs.ChatsActivos.child(defaults.string(forKey: "idaux")!).updateChildValues(["activo":true])
        
    }
    
    @objc func dismissKeyboard() {
        //Las vistas y toda la jerarquía renuncia a responder, para esconder el teclado
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= keyboardFrame.height
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
        
    }
    
    @IBAction func sendText(_ sender: Any) {
        
        guard let contact:Contacts = objContact else {
            
            return
            
        }
        let ref = Constants.refs.databaseChats.childByAutoId()
        let hora = Date().millisecondsSince1970
        
        let message = ["message":"\(self.textoTextField.text!)","sender":"\(defaults.string(forKey: "myemail")!)", "receiver":contact.email , "hour": "\(hora)","isseen":false ] as [String : Any]
        ref.setValue(message)
        self.scrollToBottom()
        self.textoTextField.text = ""
        self.updateTableContentInset()
        
        
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
    return mjs.count
    
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let m = mjs[indexPath.row]
       
        let strDate = self.createDateTime(timestamp: m.hour as! String)
    
        
        if(!m.sender.isEqual("\(defaults.string(forKey: "myemail")!)")){
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "uno", for: indexPath) as! ChatTableViewCell
            cell.textoTextField1.text = m.message
            cell.hotaTextField1.text = strDate
        print("\(defaults.string(forKey: "myemail"))")
        return cell
            
        }else{
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "dos", for: indexPath) as! ChatTableViewCell
            cell.textoTextField2.text = m.message
            cell.horaTextField2.text = strDate
            print("dos")
            return cell
            
        }
    
   }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        //textField code
        self.view.endEditing(true)
        
        if (textoTextField.returnKeyType==UIReturnKeyType.send){
                   
                         
                         
                          let ref = Constants.refs.databaseChats.childByAutoId()
                          let hora = Date().millisecondsSince1970
                          
                          let message = ["message":"\(self.textoTextField.text!)","sender":"\(defaults.string(forKey: "myemail")!)", "receiver":objContact!.email , "hour": "\(hora)","isseen":false ] as [String : Any]
                          ref.setValue(message)
                          self.scrollToBottom()
                          self.textoTextField.text = ""
                          self.updateTableContentInset()
                   
                   
               }
               
        return true
    }
    
    
    
    func createDateTime(timestamp: String) -> String {
        var strDate = "undefined"
            
        if let unixTime = Double(timestamp) {
            let date = Date(timeIntervalSince1970: unixTime)
            let dateFormatter = DateFormatter()
            let timezone = TimeZone.current.abbreviation() ?? "GTM-5"  // get current TimeZone abbreviation or set to CET
            dateFormatter.timeZone = TimeZone(abbreviation: timezone) //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "HH:mm" //Specify your format that you want
            strDate = dateFormatter.string(from: date)
        }
            
        return strDate
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.mjs.count > 0 {
            let indexPath = IndexPath(row: self.mjs.count-1, section: 0)
            self.tabla.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func updateTableContentInset() {
          let numRows = tableView(self.tabla, numberOfRowsInSection: 0)
          var contentInsetTop = self.tabla.bounds.size.height
          for i in 0..<numRows {
              let rowRect = self.tabla.rectForRow(at: IndexPath(item: i, section: 0))
              contentInsetTop -= rowRect.size.height
              if contentInsetTop <= 0 {
                  contentInsetTop = 0
              }
          }
          self.tabla.contentInset = UIEdgeInsets(top: contentInsetTop, left: 0, bottom: 0, right: 0)
          
      }
    
}
