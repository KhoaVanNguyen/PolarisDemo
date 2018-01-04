//
//  RegisterVC.swift
//  ClientApp
//
//  Created by Khoa Nguyen on 1/3/18.
//  Copyright © 2018 Khoa Nguyen. All rights reserved.
//

import UIKit
import ProgressHUD

class RegisterVC: UIViewController {
    @IBOutlet weak var passwordTF: FancyTextField!
    @IBOutlet weak var showPasswordCheckBox: CheckBox!
    @IBOutlet weak var usernameTF: FancyTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
         showPasswordCheckBox.tintColor = #colorLiteral(red: 0.003921568627, green: 0.4470588235, blue: 0.5176470588, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegisterToUpdate" {
            if let updateVC = segue.destination as? UpdateProfileVC {
                updateVC.isRegistered = true
            }
        }
    }
    
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }

    

    @IBAction func registerBtn(_ sender: Any) {
        
        guard let username = usernameTF.text , username != "" else {
            ProgressHUD.dismiss()
            showAlert(title: "Error", message: "Username không được để trống")
            return
        }
        guard let password = passwordTF.text, password != "" else {
            showAlert(title: "Error", message: "Password không được để trống")
            return
        }

        guard password.characters.count >= 5 else {
            showAlert(title: "Error", message: "Password ít nhất 5 ký tự")
            return
        }
        ProgressHUD.show("Loading...")
        
        Api.shared.register(username: username, password: password) { (completion) in
            ProgressHUD.dismiss()
            switch completion {
            case .Success(_):
                self.performSegue(withIdentifier: "RegisterToUpdate", sender: true)
                break
            case .Failure(let value):
                self.showAlert(title: "Error", message: value as! String )
                break
            }
            
        }
        
    }
    
    
    @IBAction func showPassword_TouchUpInside(_ sender: Any) {
        if showPasswordCheckBox.isChecked {
            passwordTF.isSecureTextEntry = true
        }else {
            passwordTF.isSecureTextEntry = false
        }
    }

}
