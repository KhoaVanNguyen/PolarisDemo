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
    
    let disconnectErrMessage = "Không thể kết nối đến server"
    
    static let shared = Api()
    var userId = ""
    var token = ""
    let rootUrl = "http://localhost:5000"
    var defaultHeader = [
        "Content-Type": "application/json; charset=utf-8",
        
    ]
    
    func register(username: String, password: String, completion: @escaping CompletionHandler) {
        
        let registerUrl = "\(rootUrl)/account/register"
        let params = [
            "username": username,
            "password": password
            ] as [String:String]
        
        
        Alamofire.request(registerUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: defaultHeader).responseJSON { (response) in
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
                        self.token = dict["token"].stringValue
                    }
                }
                break
            case .failure(_):
                completion(ActionResult.Failure(self.disconnectErrMessage))
                break
            }
        }
    }
    
    func logout() {
        
        let url = "\(rootUrl)/account/logout"
       
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: defaultHeader).response { (response) in
            self.token = ""
            self.userId = ""
        }
    }
    
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
                        self.token = dict["token"].stringValue
                    }
                }
                break
            case .failure(_):
                completion(ActionResult.Failure(self.disconnectErrMessage))
                break
            }
        }
    }
    
    
    func getCustomerById(completion: @escaping CompletionHandler) {
        
        let url = "\(rootUrl)/api/customers/ById/\(userId)"
        
        defaultHeader["Authorization"] = "Bearer \(token)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: defaultHeader).responseJSON { (response) in
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
                        let customer = Customer(data: dict["customer"])
                        completion(ActionResult.Success(customer))
                    }
                }
                break
            case .failure(_):
                completion(ActionResult.Failure(self.disconnectErrMessage))
                break
            }
        }
    }
    
    func updateCustomer(name: String, phone: String, birthday: String, familyRegister: String, deposite: String, frontLicense: String, backLicense: String,completion: @escaping CompletionHandler  ) {
        
        defaultHeader["Authorization"] = "Bearer \(token)"
        let addUrl = "\(rootUrl)/api/customers/update"
        
        let params = [
        
            "name": name,
            "phone": phone,
            "birthday": birthday,
            "familyRegister": familyRegister,
            "deposite": deposite,
            "frontDriverImage": frontLicense,
            "backDriverImage": backLicense,
            "userId": userId,
            ] as [String : Any]
        print(params)
        Alamofire.request(addUrl, method: .put, parameters: params, encoding: JSONEncoding.default, headers: defaultHeader).responseJSON { (response) in
            print(response)
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
                    }else if statusCode == 201 || statusCode == 200 {
                        completion(ActionResult.Success(dict["success"].stringValue) )
                    }
                }
                break
            case .failure(_):
                completion(ActionResult.Failure(self.disconnectErrMessage))
                break
            }
        }
    }
    
}
