//
//  Customer.swift
//  ClientApp
//
//  Created by Khoa Nguyen on 1/4/18.
//  Copyright © 2018 Khoa Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON
struct Customer {
    let id: Int
    let name: String
    let phone: String
    let birthday: String
    let familyRegister: String
    let deposite: Int
    let frontDriverImage: String
    let backDriverImage: String
    let userId: String
    init(data: JSON) {
        id = data["id"].intValue
        name = data["name"].stringValue
        phone = data["phone"].stringValue
        birthday = data["birthday"].stringValue
        familyRegister = data["familyRegister"].stringValue
        frontDriverImage = data["frontDriverImage"].stringValue
        backDriverImage = data["backDriverImage"].stringValue
        deposite = data["deposite"].intValue
        userId = data["userId"].stringValue
        
    }
}


//
//"id": 1,
//"name": "Nguyen Van C",
//"phone": "012831293",
//"birthday": "04/01/2012",
//"familyRegister": "Ho Chi Minh",
//"deposite": 13232,
//
//"frontDriverImage"
//"backDriverImage"
//"userId":

