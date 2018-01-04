//
//  Api.swift
//  ClientApp
//
//  Created by Khoa Nguyen on 1/3/18.
//  Copyright © 2018 Khoa Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

typealias CompletionHandler =  (ActionResult<Any>) -> Void
class Api {
    
    static let shared = Api()
    var userId = ""
    let rootUrl = "http://localhost:5000"
    let defaultHeader = [
        "Content-Type": "application/json; charset=utf-8",
        
    ]
    
    func login(username: String, password: String, completion: @escaping CompletionHandler) {
        
        let loginUrl = "\(rootUrl)/account/login"
        let params = [
            "username": username,
            "password": password
        ] as [String:String]
        
        
        Alamofire.request(loginUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: defaultHeader).responseJSON { (response) in
            guard let data = response.data else {
                completion(ActionResult.Failure("Lỗi dữ liệu từ server"))
                return
            }
            let dict = JSON(data: data)
            
            switch response.result {
            case .success(_):
                
                if let response = response.response {
                    let statusCode = response.statusCode
                    if statusCode == 500 {
                        completion(ActionResult.Failure(dict["error"].stringValue))
                    }else if statusCode == 200 {
                        completion(ActionResult.Success(dict["token"].stringValue) )
                        self.userId = dict["userId"].stringValue
                    }
                }
                break
            case .failure(_):
                completion(ActionResult.Failure(dict["error"].stringValue))
                break
            }
        }
    }
    
    
    func updateCustomer(name: String, phone: String, birthday: String, familyRegister: String, deposite: Int, frontLicense: String, backLicense: String,completion: @escaping CompletionHandler  ) {
        
        let addUrl = "\(rootUrl)/customer/update"
        
        let params = [
        
            "name": name,
            "phone": phone,
            "birthday": birthday,
            "familyRegister": familyRegister,
            "deposite": deposite,
            "frontDriverImage": frontLicense,
            "backDriverImage": backLicense,
            "userId": userId
            ] as [String : Any]
        
        Alamofire.request(addUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: defaultHeader).responseJSON { (response) in
            guard let data = response.data else {
                completion(ActionResult.Failure("Lỗi dữ liệu từ server"))
                return
            }
            let dict = JSON(data: data)
            
            switch response.result {
            case .success(_):
                
                if let response = response.response {
                    let statusCode = response.statusCode
                    if statusCode == 500 {
                        completion(ActionResult.Failure(dict["error"].stringValue))
                    }else if statusCode == 201 {
                        completion(ActionResult.Success(dict["token"].stringValue) )
                        self.userId = dict["userId"].stringValue
                    }
                }
                break
            case .failure(_):
                completion(ActionResult.Failure(dict["error"].stringValue))
                break
            }
        }
    }

//
//    func updateCustomer(name: String, phone: String, birthday: String, familyRegister: String, deposite: Int, frontLicense: String, backLicense: String,completion: @escaping CompletionHandler  ) {
//
//    }
    
    
    
    
    
}
