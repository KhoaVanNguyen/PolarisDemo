//
//  LoginVC.swift
//  ClientApp
//
//  Created by Khoa Nguyen on 1/3/18.
//  Copyright © 2018 Khoa Nguyen. All rights reserved.
//

import UIKit
import ProgressHUD


class LoginVC: UIViewController {
    
    /**
     Activity Indicator
     - Author: Khoa Nguyen
     
     */
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /**
     Show Password Checkbox
     - Author: Khoa Nguyen
     
     */
    @IBOutlet weak var showPasswordCheckBox: CheckBox!
    
    
    
    /**
     Password TextField
     - Author: Khoa Nguyen
     
     */
    @IBOutlet weak var passwordTF: FancyTextField!
    /**
     Username Text Field
     - Author: Khoa Nguyen
     
     */
    @IBOutlet weak var usernameTF: FancyTextField!
    
    
    /**
     Instantiate instance variables and build views
     
     - Author: Khoa Nguyen
     
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTF.delegate = self
        passwordTF.delegate = self
        
        usernameTF.returnKeyType = .next
        passwordTF.returnKeyType = .done
        
        showPasswordCheckBox.tintColor = #colorLiteral(red: 0.003921568627, green: 0.4470588235, blue: 0.5176470588, alpha: 1)
    }
    
    /**
     If user doesn't logout before, login automatically.
     
     - Author: Khoa Nguyen
     
     */
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        usernameTF.text = ""
        passwordTF.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    /**
     Move to Register Screen
     
     - Author: Khoa Nguyen
     
     */
    
    @IBAction func register_TouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "LoginVCToRegisterVC", sender: nil)
    }
    
    /**
     Call Login API
     
     - Author: Khoa Nguyen
     
     */
    
    
    @IBAction func login_TouchUpInside(_ sender: Any) {
        login()
    }

    func login() {
        
        guard let username = usernameTF.text , username != "" else {
            ProgressHUD.dismiss()
            showAlert(title: "Error", message: "Username không được để trống")
            return
        }
        guard let password = passwordTF.text, password != "" else {
            showAlert(title: "Error", message: "Password không được để trống")
            return
        }
        ProgressHUD.show("Loading...")
        
        Api.shared.login(username: username, password: password) { (completion) in
            ProgressHUD.dismiss()
            switch completion {
            case .Success(_):
                self.performSegue(withIdentifier: "LoginToUpdate", sender: true)
                break
            case .Failure(let value):
                self.showAlert(title: "Error", message: value as! String )
                break
            }
            
        }
        
        
    }
    
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }

    /**
     Show password when click on checkbox
     
     - Author: Khoa Nguyen
     
     */
    
    @IBAction func showPassword_TouchUpInside(_ sender: Any) {
        if showPasswordCheckBox.isChecked {
            passwordTF.isSecureTextEntry = true
        }else {
            passwordTF.isSecureTextEntry = false
        }
    }
    
    /**
     Turn off keyboard
     
     - Author: Khoa Nguyen
     
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
extension LoginVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTF {
            usernameTF.resignFirstResponder()
            passwordTF.becomeFirstResponder()
        }else if textField == passwordTF{
            passwordTF.resignFirstResponder()
            login()
        }
        
        return true
        
    }
}


