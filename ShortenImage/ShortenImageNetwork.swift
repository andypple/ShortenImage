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

struct NetworkConst {
    static let host = "https://shortenimage.herokuapp.com/api"
    static let createGroupAction = "/create-group"
    static let getGroupAction = "/group"
}

class ShortenImageNetwork {
    func createGroup(images: [String], completion: ((Bool, String) -> Void)) {
        let parameters = ["images" : images]
        Alamofire.request(.POST, NetworkConst.host + NetworkConst.createGroupAction, parameters: parameters)
            .responseJSON { response in
                if let JSON = response.result.value {
                    let result = JSON as! NSDictionary
                    completion(true, NetworkConst.host + NetworkConst.getGroupAction + "/\(result["id"] as! NSNumber)")
                } else {
                    completion(false, "Something went wrong")
                }
        }
    }

    func fetchGroup(url: String, completion: ((Bool, [String]) -> Void)) {
        Alamofire.request(.GET, url, parameters: ["type" : ""])
            .responseJSON { response in
                if let JSON = response.result.value as? NSDictionary {
                    completion(true, JSON["images"] as! [String])
                } else {
                    completion(false, ["Something went wrong"])
                }
        }

    }
}