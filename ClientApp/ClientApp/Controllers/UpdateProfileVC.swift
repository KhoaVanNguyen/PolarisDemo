//
//  UpdateProfileVC.swift
//  ClientApp
//
//  Created by Khoa Nguyen on 1/3/18.
//  Copyright © 2018 Khoa Nguyen. All rights reserved.
//

import UIKit

class UpdateProfileVC: UIViewController {

    @IBOutlet weak var nameTF: FancyTextField!
    @IBOutlet weak var birthdayBtn: UIButton!
    @IBOutlet weak var phoneTF: FancyTextField!
    @IBOutlet weak var familyRegisterTF: FancyTextField!
    
    @IBOutlet weak var depositeTF: FancyTextField!
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var updateBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func update_TouchUpInside(_ sender: Any) {
    }
    
    @IBOutlet weak var birthday_TouchUpInside: UIButton!
    
}
