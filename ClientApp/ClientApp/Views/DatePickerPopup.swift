//
//  DatePickerPopup.swift
//  SMAS
//
//  Created by Khoa Nguyen on 12/12/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

protocol DatePickerPopupDelegate {
    func didSelect(withDate date: Date)
}
class DatePickerPopup: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: DatePickerPopupDelegate?
    var dateString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
//        yyyy-MM-dd'T'HH:mm:ss.SSSZZ
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale(identifier: "vi_VN")
        let currentDate = dateFormatter.date(from: dateString)
        
        if let currentDate = currentDate {
            datePicker.date = currentDate
            let a = datePicker.locale!
            print(a)
        }else {
            datePicker.date = Date()
        }
        
        
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        // Do any additional setup after loading the view.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let firstTouch = touches.first {
            let hitView = containerView.hitTest(firstTouch.location(in: self.containerView), with: event)
            
            if hitView != containerView { // != headerView
//                isTouchOutSide = true
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func changeDate_TouchUpInside(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.didSelect(withDate: self.datePicker.date)
        }
//        dismiss(animated: true, completion: nil)
        
        
        
//        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: datePicker.date)
//        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
//            print("\(day) \(month) \(year)")
//        }
        
    }
}

