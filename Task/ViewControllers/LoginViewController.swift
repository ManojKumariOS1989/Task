//
//  LoginViewController.swift
//  Collection_View
//
//  Created by Practice on 05/10/19.
//  Copyright © 2019 Practice. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    let service = "LoginCredentials"
    let userNameKey = "USERNAME"
    let passwordKey = "PASSWORD"
    let isFirstTimeLoginKey = "FirstTimeLogin"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func logInBtn_Action(_ sender: Any) {
        let userNameSTR:String = KeychainService.loadData(service: service, account: userNameKey) ?? ""
        let passwordSTR:String = KeychainService.loadData(service: service, account: passwordKey) ?? ""
        
        if self.userName.text?.isEmpty == true {
            self.showAlertToUser(message: "Please enter Usename")
        }
        if self.password.text?.isEmpty == true {
            self.showAlertToUser(message: "Please enter Password")
        }
        
        if userNameSTR.isEmpty == false && userNameSTR != "" && passwordSTR.isEmpty == false && passwordSTR != ""  {
                if self.userName.text == userNameSTR {
                    if self.password.text == passwordSTR {
                        self.callForMoveHomeVC()
                    }else{
                        self.showAlertToUser(message: "InvalidUserName or Password")
                    }
                    
                }else{
                    self.showAlertToUser(message: "InvalidUserName or Password")
                }
         
        }else {
            if self.userName.text?.isEmpty == false && self.userName.text != "" {
                if self.password.text?.isEmpty == false && self.password.text != "" {
                    KeychainService.saveData(service: service, account: userNameKey, data: self.userName.text ?? "")
                    KeychainService.saveData(service: service, account: passwordKey, data: self.password.text ?? "")
                    self.callForMoveHomeVC()
                    
                }else{
                    self.showAlertToUser(message: "All Fields are mandatory")
                }
            }else{
                self.showAlertToUser(message: "All Fields are mandatory")
            }
        }
    }
    
    
    @IBAction func removeCredentialsButtonTapped(_ sender: UIButton) {
        
        KeychainService.removeData(service: service, account: userNameKey)
        KeychainService.removeData(service: service, account: passwordKey)
        KeychainService.removeData(service: service, account: isFirstTimeLoginKey)
        self.showAlertToUser(message: "Successfully removed Credentials")
    }
    
    
    func callForMoveHomeVC(){
        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let nav = UINavigationController(rootViewController: homeVC)
        self.present(nav, animated: true, completion: nil)
    }
    

}
extension UIViewController{
    func showAlertToUser(message:String){
        let alertVC = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
}
