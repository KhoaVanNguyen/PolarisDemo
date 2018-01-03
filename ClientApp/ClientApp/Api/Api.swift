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
class Api {
    
    static let shared = Api()
    
    let rootUrl = "http://localhost:5000"
    let defaultHeader = [
        "Content-Type": "application/json; charset=utf-8",
        
    ]
    
    func login(username: String, password: String, completion: @escaping (ActionResult<Any>) -> Void ) {
        
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
                        }
                    }
                    
                    
                    
                    break
                case .failure(_):
                    completion(ActionResult.Failure(dict["error"].stringValue))
                    break
            }
        }
    }
}
