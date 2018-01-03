//
//  CheckBox.swift
//  ClientApp
//
//  Created by Khoa Nguyen on 1/3/18.
//  Copyright © 2018 Khoa Nguyen. All rights reserved.
//


import UIKit

@IBDesignable
class CheckBox: UIButton {
    
    // Images
    @IBInspectable
    var checkedImage: UIImage? {
        didSet{
            self.layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var uncheckedImage: UIImage? {
        didSet{
            self.layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var imageColor: UIColor? {
        didSet{
            updateButton()
        }
    }
    
    
    //    var uncheckedImage = UIImage(named: "password")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControlState.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControlState.normal)
            }
        }
    }
    
    func updateButton(){
    }
    
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
    
}

