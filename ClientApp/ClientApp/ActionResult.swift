//
//  ActionResult.swift
//  ClientApp
//
//  Created by Khoa Nguyen on 1/3/18.
//  Copyright © 2018 Khoa Nguyen. All rights reserved.
//

import Foundation


public enum ActionResult<T> {
    
    /**
     Call API successfully
     - Author: Khoa Nguyen
     
     */
    case Success(T)
    
    /**
     Call API fail because of users's input
     - Author: Khoa Nguyen
     
     */
    case Failure(T)
}
