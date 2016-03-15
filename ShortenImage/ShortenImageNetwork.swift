//
//  ShortenImageNetwork.swift
//  ShortenImage
//
//  Created by Phat Le on 3/15/16.
//  Copyright © 2016 FourFi. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ShortenImageNetwork {
    func createGroup(images: [String], completion: ((String) -> Void)) {
        let parameters = ["images" : images]
        Alamofire.request(.POST, "http://localhost:4000/api/create-group", parameters: parameters)
            .responseJSON { response in
                if let JSON = response.result.value {
                    let result = JSON as! NSDictionary
                    completion("http://localhost:4000/api/group/\(result["id"] as! NSNumber)")
                }
        }
    }
}