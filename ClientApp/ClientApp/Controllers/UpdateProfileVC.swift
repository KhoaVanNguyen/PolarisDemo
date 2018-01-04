//
//  UpdateProfileVC.swift
//  ClientApp
//
//  Created by Khoa Nguyen on 1/3/18.
//  Copyright © 2018 Khoa Nguyen. All rights reserved.
//

import UIKit
import Foundation
import ProgressHUD
class UpdateProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var nameTF: FancyTextField!
    @IBOutlet weak var birthdayBtn: UIButton!
    @IBOutlet weak var phoneTF: FancyTextField!
    @IBOutlet weak var familyRegisterTF: FancyTextField!
    
    @IBOutlet weak var depositeTF: FancyTextField!
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var updateBtn: UIButton!
    var isFront = true
    var picker: UIImagePickerController!
    let defaultBirthdayTitle = "Ngày sinh"
    
    var isRegistered = false
    
    
 
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCustomerData()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back))
        self.navigationItem.leftBarButtonItem = newBackButton
        
    }
    func back(sender: UIBarButtonItem) {
      
        Api.shared.logout()
        if isRegistered {
            _ = navigationController?.popToRootViewController(animated: true)
            
        }else {
            _ = navigationController?.popViewController(animated: true)
        }
        
    }
    
    func loadCustomerData(){
        if isRegistered {
            return
        }
        ProgressHUD.show("Loading...")
        Api.shared.getCustomerById { (completion) in
            ProgressHUD.dismiss()
            switch completion {
            case .Success(let value):
                if let customer = value as? Customer {
                    self.nameTF.text = customer.name
                    self.phoneTF.text = customer.phone
                    self.birthdayBtn.setTitle(customer.birthday, for: .normal)
                    self.familyRegisterTF.text = customer.familyRegister
                    self.depositeTF.text = String(customer.deposite)
                    if let img = getImageFrom(base64Encode: customer.frontDriverImage) {
                        self.frontImage.image = img
                    }
                    if let img = getImageFrom(base64Encode: customer.backDriverImage) {
                        self.backImage.image = img
                    }
                    
                }
                
                break
            case .Failure(let value):
                self.showAlert(title: "Error", message: value as! String )
                break
            }
        }
    }
    
    func setupUI(){
        picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        
        let frontTap = UITapGestureRecognizer(target: self, action: #selector(self.frontImageTapped))
        frontImage.isUserInteractionEnabled = true
        frontImage.addGestureRecognizer(frontTap)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.backImageTapped))
        backImage.isUserInteractionEnabled = true
        backImage.addGestureRecognizer(backTap)
        
        birthdayBtn.setTitle(defaultBirthdayTitle, for: .normal)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func frontImageTapped() {
        isFront = true
        present(picker, animated: true, completion: nil)
    }
    func backImageTapped() {
        isFront = false
        present(picker, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if isFront {
                frontImage.image = img
            }else {
                backImage.image = img
            }
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func update_TouchUpInside(_ sender: Any) {
        
//        nameTF.text = "Nguyen Van C"
//        phoneTF.text = "012831293"
//        depositeTF.text = "13232"
//        familyRegisterTF.text = "Ho Chi Minh"
        guard let name = nameTF.text, name != "" else {
            showAlert(title: "Lỗi", message: "Tên không được để trống")
            return
        }
        guard let phone = phoneTF.text, phone != "" else {
            showAlert(title: "Lỗi", message: "Số điện thoại không được để trống")
            return
        }
        guard birthdayBtn.currentTitle! != defaultBirthdayTitle  else {
            showAlert(title: "Lỗi", message: "Bạn chưa chọn ngày sinh")
            return
        }
        guard let familyRegister = familyRegisterTF.text, familyRegister != "" else {
            showAlert(title: "Lỗi", message: "Hộ khẩu không được để trống")
            return
        }
        guard let deposite = depositeTF.text else {
            showAlert(title: "Lỗi", message: "Tiền đặt cọc không được để trống")
            return
        }
        
        guard frontImage.image != nil else {
            showAlert(title: "Lỗi", message: "Bạn chưa chọn hình mặt trước bằng lái")
            return
        }
        guard backImage.image != nil else {
            showAlert(title: "Lỗi", message: "Bạn chưa chọn hình mặt sau bằng lái")
            return
        }
        
        ProgressHUD.show("Đang nén hình ảnh")
        let birthday = birthdayBtn.currentTitle!
        compressImage { (frontImg, backImg) in
            Api.shared.updateCustomer(name: name, phone: phone, birthday: birthday, familyRegister: familyRegister, deposite: deposite, frontLicense: frontImg, backLicense: backImg) { (completion) in
                ProgressHUD.dismiss()
                switch completion {
                case .Success(let value):
                    self.showAlert(title: "App", message: value as! String)
                    break
                case .Failure(let value):
                    self.showAlert(title: "Error", message: value as! String )
                    break
                }
            }
        }
        
        
        
    }
    
    
    func compressImage( completion: @escaping (String,String) -> Void  ) {
        
        let jpegCompressionQuality: CGFloat = 0.5
        
        let frontImage = self.frontImage.image!
        let backImage = self.backImage.image!
        DispatchQueue.global().async {
            guard let base64StringFront = UIImageJPEGRepresentation(frontImage, jpegCompressionQuality)?.base64EncodedString() else {
//                showAlert(title: "Lỗi", message: "Có lỗi trong quá trình xử lý ảnh")
                return
            }
            guard let base64StringBack = UIImageJPEGRepresentation(backImage, jpegCompressionQuality)?.base64EncodedString() else {
//                showAlert(title: "Lỗi", message: "Có lỗi trong quá trình xử lý ảnh")
                return
            }
            ProgressHUD.show("Nén hình ảnh xong")
            ProgressHUD.show("Cập nhật dữ liệu")
            completion(base64StringFront, base64StringBack)
            
        }
        
       
        
    }
    
    
    @IBAction func birthday_TouchUpInside(_ sender: Any) {
        
        let datePickerPopup = DatePickerPopup()
        datePickerPopup.dateString = birthdayBtn.currentTitle!
        datePickerPopup.delegate = self
        datePickerPopup.modalPresentationStyle = .custom
        present(datePickerPopup, animated: true, completion: nil)
        
    }
   
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }

}

extension UpdateProfileVC: DatePickerPopupDelegate {
    func didSelect(withDate date: Date) {
        
            let dateString = formatDayAndMonth(date: date)
            let today = Date().addingTimeInterval(1)
            if date > today {
                
                showAlert(title: "Lỗi", message: "Ngày được chọn phải nhỏ hơn ngày hiện tại")
                
            }else {
                birthdayBtn.setTitle(dateString, for: .normal)
            }
        
        
    }
}

